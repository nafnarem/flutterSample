const GOOGLE_API_KEY = 'AIzaSyAzib8TYN4VuqCw49jnq6Uvwi9P8oxTwco';

class LocationHelper {
  static String generateLocationPreviewImage(
      {double? latitude, double? longitude}) {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$latitude, $longitude&zoom=13&size=600x300&maptype=roadmap&markers=color:blue%7Clabel:S%7C$latitude, $longitude&key=$GOOGLE_API_KEY';
  }
}
