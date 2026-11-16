String? requiredField(String? value, String label) {
  if (value == null || value.trim().isEmpty) {
    return '$label is required';
  }
  return null;
}

String? priceField(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Price is required';
  }
  final price = double.tryParse(value.trim());
  if (price == null) {
    return 'Price must be a number';
  }
  if (price < 0) {
    return 'Price cannot be negative';
  }
  return null;
}