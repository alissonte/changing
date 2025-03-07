import 'package:flutter/material.dart';

class CurrencyPair {
  final String code;
  final String name;
  final String from;
  final String to;
  final IconData fromIcon;
  final IconData toIcon;
  final Color color;
  final bool isHidden; // New property to track hidden state

  const CurrencyPair({
    required this.code,
    required this.name,
    required this.from,
    required this.to,
    required this.fromIcon,
    required this.toIcon,
    required this.color,
    this.isHidden = false,
  });

  // Create a copy of this pair with modified properties
  CurrencyPair copyWith({
    String? code,
    String? name,
    String? from,
    String? to,
    IconData? fromIcon,
    IconData? toIcon,
    Color? color,
    bool? isHidden,
  }) {
    return CurrencyPair(
      code: code ?? this.code,
      name: name ?? this.name,
      from: from ?? this.from,
      to: to ?? this.to,
      fromIcon: fromIcon ?? this.fromIcon,
      toIcon: toIcon ?? this.toIcon,
      color: color ?? this.color,
      isHidden: isHidden ?? this.isHidden,
    );
  }
}

class Currencies {
  // Store the original default pairs
  static final List<CurrencyPair> _defaultPairs = [
    const CurrencyPair(
      code: 'EUR-BRL',
      name: 'Euro to Brazilian Real',
      from: 'EUR',
      to: 'BRL',
      fromIcon: Icons.euro,
      toIcon: Icons.attach_money,
      color: Color(0xFF2ECC71),
    ),
    const CurrencyPair(
      code: 'EUR-USD',
      name: 'Euro to US Dollar',
      from: 'EUR',
      to: 'USD',
      fromIcon: Icons.euro,
      toIcon: Icons.attach_money,
      color: Color(0xFF3498DB),
    ),
    const CurrencyPair(
      code: 'USD-EUR',
      name: 'US Dollar to Euro',
      from: 'USD',
      to: 'EUR',
      fromIcon: Icons.attach_money,
      toIcon: Icons.euro,
      color: Color(0xFFF1C40F),
    ),
    const CurrencyPair(
      code: 'BRL-USD',
      name: 'Brazilian Real to US Dollar',
      from: 'BRL',
      to: 'USD',
      fromIcon: Icons.attach_money,
      toIcon: Icons.attach_money,
      color: Color(0xFFE74C3C),
    ),
    const CurrencyPair(
      code: 'USD-BRL',
      name: 'US Dollar to Brazilian Real',
      from: 'USD',
      to: 'BRL',
      fromIcon: Icons.attach_money,
      toIcon: Icons.attach_money,
      color: Color(0xFF9B59B6),
    ),
  ];

  // Using a list that can be modified at runtime
  static final List<CurrencyPair> pairs = List.from(_defaultPairs);

  static CurrencyPair getByCode(String code) {
    return pairs.firstWhere(
      (pair) => pair.code == code,
      orElse: () => pairs.first,
    );
  }

  static void addCustomPair(CurrencyPair pair) {
    // Check if the pair already exists
    final existingIndex = pairs.indexWhere((p) => p.code == pair.code);

    if (existingIndex >= 0) {
      // Replace existing pair
      pairs[existingIndex] = pair;
    } else {
      // Add new pair
      pairs.add(pair);
    }
  }

  static void removePair(String code) {
    // Remove any pair (default or custom)
    final index = pairs.indexWhere((p) => p.code == code);
    if (index >= 0) {
      pairs.removeAt(index);
    }
  }

  static void hidePair(String code) {
    // For default pairs, we just hide them instead of removing
    final index = pairs.indexWhere((p) => p.code == code);
    if (index >= 0) {
      final pair = pairs[index];
      pairs[index] = pair.copyWith(isHidden: true);
      // Move to the end of the list
      pairs.add(pairs.removeAt(index));
    }
  }

  static void restoreDefaults() {
    // Clear all pairs and add back the defaults
    pairs.clear();
    pairs.addAll(_defaultPairs);
  }

  static void removeAllCustomPairs() {
    // Keep only the default pairs
    pairs.removeWhere(
        (pair) => !_defaultPairs.any((def) => def.code == pair.code));
  }

  static void sortByName() {
    // Sort pairs alphabetically by name
    pairs.sort((a, b) => a.name.compareTo(b.name));
  }

  static void sortDefaultFirst() {
    // Sort with default pairs first, then custom pairs
    pairs.sort((a, b) {
      final aIsDefault = _defaultPairs.any((def) => def.code == a.code);
      final bIsDefault = _defaultPairs.any((def) => def.code == b.code);

      if (aIsDefault && !bIsDefault) return -1;
      if (!aIsDefault && bIsDefault) return 1;
      return a.name.compareTo(b.name);
    });
  }
}
