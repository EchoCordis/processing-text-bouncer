//Class used to store an enum as standard .pde classes don't allow for enums
public class Screen {
  //Three types of screen in the program:
  //START - The initial screen the user sees
  //TYPE - The screen allowing for users to enter a word
  //VISUAL - The screen displaying the visual and audio depiction of the user's word
  enum CurrentScreen {
    START,
    TYPE,
    VISUAL,
    SETTINGS
  }
}
