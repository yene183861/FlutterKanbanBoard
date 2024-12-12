enum ReservationStatus {
  pending,
  accept,
  process,
  complete,
  cancel,
  reject,
}

extension ReservationStatusEx on ReservationStatus {
  int get type {
    switch (this) {
      case ReservationStatus.pending:
        return 1;
      case ReservationStatus.accept:
        return 2;
      case ReservationStatus.cancel:
        return 3;
      case ReservationStatus.reject:
        return 4;
      case ReservationStatus.complete:
        return 20;
      case ReservationStatus.process:
        return 15;
      default:
        return 0;
    }
  }

  String get title {
    switch (this) {
      case ReservationStatus.pending:
        return 'Chờ phê duyệt';
      case ReservationStatus.accept:
        return 'Tiếp nhận';
      case ReservationStatus.cancel:
        return 'Huỷ lịch';
      case ReservationStatus.reject:
        return 'Từ chối';
      case ReservationStatus.complete:
        return 'Hoàn thành';
      case ReservationStatus.process:
        return 'Đang xử lý';

      default:
        return '';
    }
  }
}

ReservationStatus convertReservationStatus(int type) {
  switch (type) {
    case 1:
      return ReservationStatus.pending;
    case 2:
      return ReservationStatus.accept;
    case 3:
      return ReservationStatus.cancel;
    case 4:
      return ReservationStatus.reject;
    case 20:
      return ReservationStatus.complete;
    case 15:
    case 16:
      return ReservationStatus.process;
    default:
      return ReservationStatus.pending;
  }
}
