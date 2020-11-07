import ddf.minim.ugens.*;

//Class used to create an instrument that plays on a sine wave
class SineInstrument implements Instrument
{
  //Audio elements
  Oscil wave;  //An oscillator to produce the sound
  Line  ampEnv;  //A line that linearily changes from one value to another over time
  
  //Constructor class
  SineInstrument(float frequency)
  {
    //Initialises  a sine wave oscillator
    wave   = new Oscil( frequency, 0, Waves.SINE );
    ampEnv = new Line();  //Initialises the audio line
    ampEnv.patch(wave.amplitude);  //Patches a line to the oscillator
  }
  
  //Used to begin making sound using the instrument for the duration
  void noteOn(float duration)
  {
    //Starts the amplitude envelope
    ampEnv.activate(duration, 0.5f, 0);
    //Attaches the oscillator to the output so it makes sound
    wave.patch(out);
  }
  //Stops the instrument from outputting sound
  void noteOff()
  {
    wave.unpatch(out);
  }
}
