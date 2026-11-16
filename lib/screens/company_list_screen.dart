import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

import '../models/company.dart';
import '../models/service.dart';
import '../providers/company_provider.dart';
import '../widgets/content_width.dart';
import 'create_company_screen.dart';
import 'create_service_screen.dart';

class CompanyListScreen extends StatelessWidget {
  const CompanyListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CompanyProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Companies'),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            icon: const Icon(Icons.refresh),
            onPressed: provider.isLoading ? null : provider.loadCompanies,
          ),
        ],
      ),
      body: ContentWidth(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      icon: const Icon(Icons.add_business),
                      label: const Text('Add company'),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CreateCompanyScreen(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text('Add service'),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CreateServiceScreen(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // error from a refresh while we still have old data on screen
            if (provider.error != null && provider.companies.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Text(
                  provider.error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            Expanded(child: _buildList(provider)),
          ],
        ),
      ),
    );
  }

  Widget _buildList(CompanyProvider provider) {
    if (provider.isLoading && provider.companies.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.error != null && provider.companies.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(provider.error!, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: provider.loadCompanies,
                child: const Text('Try again'),
              ),
            ],
          ),
        ),
      );
    }

    if (provider.companies.isEmpty) {
      return const Center(child: Text('No companies yet. Add one to get started.'));
    }

    return RefreshIndicator(
      onRefresh: provider.loadCompanies,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        itemCount: provider.companies.length,
        itemBuilder: (context, index) =>
            _CompanyCard(company: provider.companies[index]),
      ),
    );
  }
}

class _CompanyCard extends StatelessWidget {
  final Company company;

  const _CompanyCard({required this.company});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(company.name, style: textTheme.titleMedium),
            const SizedBox(height: 2),
            Text(
              'Reg. no: ${company.registrationNumber}',
              style: textTheme.bodySmall,
            ),
            const Divider(height: 24),
            if (company.services.isEmpty)
              Text('No services yet', style: textTheme.bodySmall)
            else
              for (final service in company.services)
                _ServiceRow(service: service),
          ],
        ),
      ),
    );
  }
}

class _ServiceRow extends StatelessWidget {
  final Service service;

  const _ServiceRow({required this.service});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(service.name, style: textTheme.bodyMedium),
                Text(service.description, style: textTheme.bodySmall),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text('RM ${service.price.toStringAsFixed(2)}'),
        ],
      ),
    );
  }
}