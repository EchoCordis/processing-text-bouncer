//Import ControlP5 library for user input UI elements
import controlP5.*;
//Import Minim library for audio elements
import ddf.minim.*;

//UI elements
ControlP5 cp5;  //ControlP5 controller
Button startButton;  //Start button
Button submitButton;  //Submit button - submits text
Button eraseButton;  //Button to erase text in textfield
Button backButton;  //Button to go back to previous screen
Button settingButton;  //Button to go to the settings screen
Textfield txtField;  //Textfield for user to enter text
Slider speedSlider;  //Slider to control the speed at which the text moves
Slider redSlider;  //Slider to control the speed at which the text moves
Slider blueSlider;  //Slider to control the speed at which the text moves
Slider greenSlider;  //Slider to control the speed at which the text moves
ScrollableList fontSelect;  //Dropdown list to select which font the text is using
Knob volumeKnob;  //Knob to control the music's volume(gain)

//Background images - used for the backgrounds for each screen
PImage startBG;  //Background for start screen
PImage typeBG;  //Background for typing screen
PImage visualBG;  //Background for visualiser screen
PImage settingBG;  //Background for settings screen

//Text control elements
String userText;  //The text the user has entered
float textSpeed = 1;  //The speed at which the text moves - changeable
float textXPos;  //The text's X position on screen
float textYPos;  //The text's Y position on screen
float textXDir = random(-1, 1);  //The direction the text moves towards on the X axis
float textYDir = random(-1, 1);  //The direction the text moves towards on the Y axis
int redColour = 0;  //The red colour value of the text's current colour
int blueColour = 0;  //The blue colour value of the text's current colour
int greenColour = 0;  //The green colour value of the text's current colour
PFont textFont;  //The text's current font
//The list of fonts available to the user to change the text's font
//Listed fonts should be available on all PCs by default
String[] fonts = {"arial", "bookman old style", "calibri", "comic sans ms", "courier new", "lucida console", "tahoma", "times new roman", "trebuchet MS", "verdana"};

//Audio elements
Minim minim;  //Minim controller
int volume = -5;  //Current volume of the audio
AudioOutput out;  //Plays the current note

//Enum for storing the current screen being displayed - possible screens:
//START - The initial screen the user sees
//TYPE - The screen allowing for users to enter a word
//VISUAL - The screen displaying the visual and audio depiction of the user's word
Screen.CurrentScreen currentScreen;

void setup() {
  size(1600,900);
  frameRate(240);
  //Initialises controllers for ControlP5 and Sound libraries
  cp5 = new ControlP5(this);
  minim = new Minim(this);

  //Initialise the AudioOutput object
  out = minim.getLineOut();
  //Sets default volume
  out.setGain(volume);  
  
  //Sets the current screen as the starting screen
  currentScreen = Screen.CurrentScreen.START;
  //Loads in all background images
  startBG = loadImage("data/StartBG.png");
  typeBG = loadImage("data/TypeBG.png");
  visualBG = loadImage("data/VisualBG.png");
  settingBG = loadImage("data/SettingsBG.png");
  
  //Initialises the UI elements
  initialiseUI();
  
  //Sets the text's X and Y positions to the middle of the screen at the start
  textXPos = width / 2;
  textYPos = height / 2;
  
  //Creates the starting font for the user's text - different from UI font
  textFont = createFont("arial", 50);
}

//Initialises all of the UI on screen
void initialiseUI(){
  //Custom font for the UI's text
  ControlFont font = new ControlFont(createFont("arial", 20));
  
  //Adds a start button to the start screen
  startButton = cp5.addButton("begin").setBroadcast(false)
                .setPosition(700, 650)
                .setColorForeground(#AFAFAF)
                .setColorBackground(0)
                .setColorActive(0xffFFFFFF)
                .setSize(200,50)
                .activateBy(ControlP5.PRESS)
                .setValue(0)
                .setBroadcast(true);
  startButton.getCaptionLabel().setFont(font);
  
  //Adds a submit button to the typing screen
  submitButton = cp5.addButton("submit").setBroadcast(false)
                .setPosition(700, 650)
                .setColorForeground(#AFAFAF)
                .setColorBackground(0)
                .setColorActive(0xffFFFFFF)
                .setSize(200,50)
                .activateBy(ControlP5.PRESS)
                .setValue(0)
                .setBroadcast(true);
  submitButton.getCaptionLabel().setFont(font);
  
  //Adds a back button that will appear on the visualiser and setting screens
  backButton = cp5.addButton("back").setBroadcast(false)
                .setPosition(100, 800)
                .setColorForeground(#AFAFAF)
                .setColorBackground(0)
                .setColorActive(0xffFFFFFF)
                .setSize(150,50)
                .activateBy(ControlP5.PRESS)
                .setValue(0)
                .setBroadcast(true);
  backButton.getCaptionLabel().setFont(font);
  
  //Adds a textfield for data entry on the typing screen
  txtField = cp5.addTextfield("input")
             .setPosition(590,500)
             .setSize(400,40)
             .setColorBackground(0)
             .setFont(font)
             .setFocus(true)
             .setAutoClear(false)
             .setCaptionLabel("");
             
  //Adds an erase button on the typing screen
  eraseButton = cp5.addButton("erase").setBroadcast(false)
                .setPosition(1100, 500)
                .setColorForeground(#AFAFAF)
                .setColorBackground(0)
                .setColorActive(0xffFFFFFF)
                .setSize(110,40)
                .activateBy(ControlP5.PRESS)
                .setValue(0)
                .setBroadcast(true);
  eraseButton.getCaptionLabel().setFont(font);
  
  //Adds a button to the visualiser screen
  settingButton = cp5.addButton("settings").setBroadcast(false)
                .setPosition(1350, 800)
                .setColorForeground(#AFAFAF)
                .setColorBackground(0)
                .setColorActive(0xffFFFFFF)
                .setSize(150,50)
                .activateBy(ControlP5.PRESS)
                .setValue(0)
                .setBroadcast(true);
  settingButton.getCaptionLabel().setFont(font);
  
  //Adds a speed slider into the visualiser screen
  speedSlider = cp5.addSlider("speed").setBroadcast(false)
              .setRange(1, 20)
              .setColorForeground(#AFAFAF)
              .setCaptionLabel("")
              .setColorBackground(0)
              .setColorActive(#C4C4C4)
              .setPosition(350, 810)
              .setSize(900, 50)
              .setSliderMode(Slider.FLEXIBLE)
              .setBroadcast(true);
  speedSlider.getValueLabel().setFont(font);
  
  //Adds a red slider into the settings screen to change the text colour's green value
  redSlider = cp5.addSlider("red").setBroadcast(false)
              .setRange(0, 255)
              .setColorForeground(#AFAFAF)
              .setCaptionLabel("")
              .setColorBackground(0)
              .setColorActive(#C4C4C4)
              .setPosition(300, 300)
              .setSize(400, 50)
              .setSliderMode(Slider.FLEXIBLE)
              .setBroadcast(true);
  redSlider.getValueLabel().setFont(font);
  
  //Adds a blue slider into the settings screen to change the text colour's green value
  blueSlider = cp5.addSlider("blue").setBroadcast(false)
              .setRange(0, 255)
              .setColorForeground(#AFAFAF)
              .setCaptionLabel("")
              .setColorBackground(0)
              .setColorActive(#C4C4C4)
              .setPosition(300, 400)
              .setSize(400, 50)
              .setSliderMode(Slider.FLEXIBLE)
              .setBroadcast(true);
  blueSlider.getValueLabel().setFont(font);
  
  //Adds a green slider into the settings screen to change the text colour's green value
  greenSlider = cp5.addSlider("green").setBroadcast(false)
              .setRange(0, 255)
              .setColorForeground(#AFAFAF)
              .setCaptionLabel("")
              .setColorBackground(0)
              .setColorActive(#C4C4C4)
              .setPosition(300, 500)
              .setSize(400, 50)
              .setSliderMode(Slider.FLEXIBLE)
              .setBroadcast(true);
  greenSlider.getValueLabel().setFont(font);
  
  //Adds a dropdown box for user selection of font
  fontSelect = cp5.addScrollableList("fontSelect").setBroadcast(false)
               .setPosition(900, 300)
               .setSize(300, 250)
               .setColorBackground(0)
               .setColorActive(#C4C4C4)
               .setColorForeground(#AFAFAF)
               .setBarHeight(50)
               .setItemHeight(50)
               .addItems(fonts)
               .setType(ScrollableList.DROPDOWN)
               .setFont(font)
               .setCaptionLabel("arial")
               .setOpen(false)
               .setBroadcast(true);
               
  //Adds a volume slider into the settings screen
  volumeKnob = cp5.addKnob("volume")
              .setColorForeground(#AFAFAF)
              .setCaptionLabel("")
              .setColorBackground(0)
              .setColorActive(#C4C4C4)
              .setPosition(1000,450)
              .setRange(-30,10)
              .setRadius(60)
              .setFont(font)
              .setValue(-5);
             
  //Hides all UI elements that don't appear on the starting screen
  submitButton.hide();
  txtField.hide();
  backButton.hide();
  eraseButton.hide();
  settingButton.hide();
  speedSlider.hide();
  redSlider.hide();
  blueSlider.hide();
  greenSlider.hide();
  fontSelect.hide();
  volumeKnob.hide();
}

//Changes the UI based on the current screen that is active
void toggleUI() {
  startButton.hide();
  if (currentScreen == Screen.CurrentScreen.TYPE) {
    submitButton.show();
    txtField.show();
    backButton.hide();
    eraseButton.show();
    settingButton.hide();
    speedSlider.hide();
  }
  else if (currentScreen == Screen.CurrentScreen.VISUAL) {
    submitButton.hide();
    txtField.hide();
    backButton.show();
    eraseButton.hide();
    settingButton.show();
    speedSlider.show();
    redSlider.hide();
    blueSlider.hide();
    greenSlider.hide();
    fontSelect.hide();
    volumeKnob.hide();
  }
  else if (currentScreen == Screen.CurrentScreen.SETTINGS) {
    txtField.hide();
    backButton.show();
    eraseButton.hide();
    settingButton.hide();
    redSlider.show();
    blueSlider.show();
    greenSlider.show();
    fontSelect.show();
    volumeKnob.show();
  }
}

//Starting screen for the program
void startScreen() {
  //Display introductory image
  image(startBG, 0, 0);
}

//Screen for users to enter their text into the program
void typeScreen() {
  image(typeBG, 0, 0);  //Background for typing screen
  txtField.setFocus(true);

  //Prevents users from entering more than 20 characters into the textfield
  if (userText.length() > 20) {
    cp5.get(Textfield.class,"input").setText(userText.substring(0, 20));
  }
  //Prevents users from submitting no characters
  if (userText.length() == 0) {
    submitButton.hide();
  }
  else {
    submitButton.show(); 
  }
}

void visualScreen() {
  image(visualBG, 0, 0);  //Background for visualiser screen
  fill(redColour, blueColour, greenColour);
  textSize(50);  //Sets text size

  //Sets up their current position on the screen
  //By adding their current position with the speed of the text and its direction
  textXPos = textXPos + textSpeed * textXDir;
  textYPos = textYPos + textSpeed * textYDir;
  
  //Reverse the direction of the text when it touches the boundaries of the screen
  //Also plays a note when the text hits the boundaries
  if (textXPos > width - 50 || textXPos < 0) {
      textXDir *= -1;
      out.playNote( 0.0, 0.9, new SineInstrument(random(50, 500)));
  }
  if (textYPos > height - 150 || textYPos < 40) {
      textYDir *= -1;
      out.playNote( 0.0, 0.9, new SineInstrument(random(50, 500)));
  }
  
  //Draws the text on screen
  text(userText, textXPos, textYPos);
}

//Displays the settings screen
void settingsScreen() {
  image(settingBG, 0, 0);  //Background for settings screen
  fill(redColour, blueColour, greenColour);
  textSize(25);  //Sets the text size for the sample text
  //Sample text to let the user know what has changed without going back
  text("Sample Text", 720, 210);
}

//Switches between drawing the different screen in the program
void toggleScreen() {
  if (currentScreen == Screen.CurrentScreen.START) {
    startScreen();  //Starting screen
  }
  else if (currentScreen == Screen.CurrentScreen.TYPE) {
    typeScreen();  //Typing screen
  }
  else if (currentScreen == Screen.CurrentScreen.VISUAL) {
    visualScreen();  //Visualiser screen
  }
  else if (currentScreen == Screen.CurrentScreen.SETTINGS) {
    settingsScreen();  //Settings screen
  }
}

void draw() {
  toggleScreen();
  userText = cp5.get(Textfield.class,"input").getText();
  out.setGain(volume);
}

//Erases text in the textfield
void erase() {
  cp5.get(Textfield.class,"input").clear();
}

//Changes the font of the text to the font selected by the user
void fontSelect(int n) {
  //Retrieves the font selected by the user
  textFont = createFont(cp5.get(ScrollableList.class, "fontSelect").getItem(n).get("name").toString(), 50);
}


//Event controller for the UI
void controlEvent(ControlEvent event) {
  //Changes the screen from the start screen to the type screen
  if (event.getController().getName() == "begin"){
   currentScreen = Screen.CurrentScreen.TYPE;
   toggleUI();
  }
  //Changes the screen from the type screen to the visualiser screen
  if (event.getController().getName() == "submit"){
   currentScreen = Screen.CurrentScreen.VISUAL;
   toggleUI();
  } 
  //Goes back to the previous screen when pressed
  //Visualiser screen --> Typing screen
  //Settings screen --> Visualiser screen
  if (event.getController().getName() == "back"){
   if (currentScreen == Screen.CurrentScreen.VISUAL) {
     currentScreen = Screen.CurrentScreen.TYPE;
     //Resets the text position and trajectory after returning to the typing screen
     textXPos = width/2;
     textYPos = height/2;
     textXDir = random(-1, 1);
     textYDir = random(-1, 1);
   }
   else {
     currentScreen = Screen.CurrentScreen.VISUAL;
   }
   toggleUI();
  }
  //Changes the screen to the settings screen
  if (event.getController().getName() == "settings"){
   currentScreen = Screen.CurrentScreen.SETTINGS;
   toggleUI();
  }
  //Changes the speed of the text when the slider is moved
  if (event.getController().getName() == "speed"){
      textSpeed = cp5.getController("speed").getValue();
  }
  //Changes the speed of the text when the slider is moved
  if (event.getController().getName() == "red"){
      redColour = round(cp5.getController("red").getValue());
      cp5.getController("red").setValueLabel(str(redColour));
  }
  //Changes the speed of the text when the slider is moved
  if (event.getController().getName() == "blue"){
      blueColour = round(cp5.getController("blue").getValue());
      cp5.getController("blue").setValueLabel(str(blueColour));
  }
  //Changes the speed of the text when the slider is moved
  if (event.getController().getName() == "green"){
      greenColour = round(cp5.getController("green").getValue());
      cp5.getController("green").setValueLabel(str(greenColour));
  }
  //Changes the font of the text when a font has been selected in the dropdown list
  if (event.getController().getName() == "fontSelect"){
      textFont(textFont);
  }
}
