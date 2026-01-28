#include <Wire.h>
#include <Adafruit_Sensor.h>
#include "Adafruit_BME680.h"
#include <Adafruit_NeoPixel.h>

const int rgb_pin = 8;
const int relay_pin = 4;
const int temp_adc_pin = 0;
const int sys_adc_pin = 1;
const int bme_sda = 6;
const int bme_scl = 7;

Adafruit_NeoPixel rgb_led(1, rgb_pin, NEO_GRB + NEO_KHZ800);
bool rgb_on = false;
byte rgb_r = 0;
byte rgb_g = 0;
byte rgb_b = 0;

TwoWire i2c = TwoWire(0);

Adafruit_BME680 bme(&i2c);

void setup() {
  //Set RGB on ESP32-C3 module
  rgb_led.begin();
  rgb_led.setPixelColor(0, rgb_led.Color(0, 0, 0));
  rgb_led.setBrightness(63);

  //Set power monitor
  pinMode(temp_adc_pin, INPUT);
  pinMode(sys_adc_pin, INPUT);

  //Set relay
  pinMode(relay_pin, OUTPUT);
  digitalWrite(relay_pin, LOW);

  //Set serial port
  Serial.begin(115200);
  while(!Serial);
  Serial.println("Home Ambient ESP32 Arduino Test");

  //Set BME680
  i2c.begin(bme_sda, bme_scl, 400000);
  if (!bme.begin()) {
      Serial.println("BME680 sensor not found");
  }else{
    bme.setTemperatureOversampling(BME680_OS_8X);
    bme.setHumidityOversampling(BME680_OS_2X);
    bme.setPressureOversampling(BME680_OS_4X);
    bme.setIIRFilterSize(BME680_FILTER_SIZE_3);
    bme.setGasHeater(320, 150);
  }
}

void loop() {
  bme.beginReading();
  int temp_mV = analogReadMilliVolts(temp_adc_pin);
  int sys_mV = analogReadMilliVolts(sys_adc_pin);

  if(rgb_on){
    rgb_led.setPixelColor(0, rgb_led.Color(rgb_r, rgb_g, rgb_b));
    rgb_led.show();

    if(rgb_b){
      rgb_b += 85;
      if(rgb_b == 255){
        rgb_b = 0;
      }
    }else{
      if(rgb_g){
        rgb_g += 85;
        if(rgb_g == 255){
          rgb_g = 0;
          rgb_b = 85;
        }
      }else{
        rgb_r += 85;
        if(rgb_r == 255){
          rgb_r = 0;
          rgb_g = 85;
        }
      }
    }
  }
  
  if(Serial.available()) {
    byte rx_char = Serial.read();
    switch(rx_char) {
      case 'R':
      case 'r':
        digitalWrite(relay_pin, HIGH);
        Serial.println("Relay ON");
        break;
      case 'L':
      case 'l':
        rgb_led.setPixelColor(0, rgb_led.Color(0, 0, 0));
        rgb_led.show();
        if(rgb_on == false){
          rgb_on = true;
        }else{
          rgb_on = false;
        }
        break;
      default:
        Serial.print(rx_char);
        digitalWrite(relay_pin, LOW);
        break;
    }
  }

  delay(50);

  Serial.print("Temp(mV):");   Serial.print(temp_mV);    Serial.print(",");
  Serial.print("Sys(mV):");     Serial.print(sys_mV);     Serial.print(",");

  if (bme.endReading()) {
    Serial.print("T2(C):");     Serial.print(bme.temperature);             Serial.print(",");
    Serial.print("P(hPa):");    Serial.print(bme.pressure / 100.0);        Serial.print(",");
    Serial.print("H(%):");      Serial.print(bme.humidity);                Serial.print(",");
    Serial.print("Gas(kOhm):"); Serial.print(bme.gas_resistance / 1000.0); //Serial.print(",");
  }

  //Serial.print("R:"); Serial.print(rgb_r); Serial.print(",");
  //Serial.print("G:"); Serial.print(rgb_g); Serial.print(",");
  //Serial.print("B:"); Serial.print(rgb_b);
  
  Serial.println("");

  delay(450);
}
