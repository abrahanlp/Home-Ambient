# Home Ambient
 2-wire smart home thermostat with temperature, humidity, pressure and air quality measurements.

The main target is replace traditional tow wires bimetal thermostats with an intelligent one, cable to integrate with [HomeAssistance](https://www.home-assistant.io/) or works _standalone_ with custom firmware.

### 2-wire classical thermostat replacement
![Classic two wire thermostat](/Docu/HA_SimpleThermo.png)

## Product Requirements

| Requirement   | Description  | Definition |
|:-------------:|:-------------|:----------:|
| Temperature	|  Temperature measurement, with minimal interference from the device.	| ±2°C 	|
| Humidity	| Humidity measurement from ambient 	| ±5% 	|
| Air quality	| Air quality estimation by particle detection| Not defined, optional |
| Switch	| 2 pole switch	| >=10A	|
| Switch feedback	| Switch feedback to check operation 	| Digital or analog	|
| HA | Home Assistance integration	| Mandatory	|
| Display | Optional e-Ink display	| Could be removed	|
| Autonomy | Capable to operate without power	| As long as possible	|

## Blocks diagram

![Home Ambient connection](/Docu/HA_Diagram-Home-Ambient.png)

## CPU
The easiest way to integrate custom electronics on _HomeAssistant_ are the [ESPHome](https://esphome.io/) devices. This smart thermostat will be designed around classical ESP32-C3.

![ESP32 Home Ambient Core](https://docs.espressif.com/projects/esp-dev-kits/en/latest/esp32c3/_images/esp32-c3-devkitm-1-v1-isometric.png)

## More info on FaultyProject.es
