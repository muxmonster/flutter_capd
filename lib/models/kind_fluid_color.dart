import 'dart:convert';

class KindFluidColorModel {
  final String kind_fluid_color_id;
  final String kind_fluid_color_detail;
  KindFluidColorModel({
    required this.kind_fluid_color_id,
    required this.kind_fluid_color_detail,
  });

  KindFluidColorModel copyWith({
    String? kind_fluid_color_id,
    String? kind_fluid_color_detail,
  }) {
    return KindFluidColorModel(
      kind_fluid_color_id: kind_fluid_color_id ?? this.kind_fluid_color_id,
      kind_fluid_color_detail:
          kind_fluid_color_detail ?? this.kind_fluid_color_detail,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'kind_fluid_color_id': kind_fluid_color_id,
      'kind_fluid_color_detail': kind_fluid_color_detail,
    };
  }

  factory KindFluidColorModel.fromMap(Map<String, dynamic> map) {
    return KindFluidColorModel(
      kind_fluid_color_id: map['kind_fluid_color_id'],
      kind_fluid_color_detail: map['kind_fluid_color_detail'],
    );
  }

  String toJson() => json.encode(toMap());

  factory KindFluidColorModel.fromJson(String source) =>
      KindFluidColorModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'KindFluidColorModel(kind_fluid_color_id: $kind_fluid_color_id, kind_fluid_color_detail: $kind_fluid_color_detail)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is KindFluidColorModel &&
        other.kind_fluid_color_id == kind_fluid_color_id &&
        other.kind_fluid_color_detail == kind_fluid_color_detail;
  }

  @override
  int get hashCode =>
      kind_fluid_color_id.hashCode ^ kind_fluid_color_detail.hashCode;
}
