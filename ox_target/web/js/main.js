import { createOptions } from "./createOptions.js";

const optionsWrapper = document.getElementById("options-wrapper");
const body = document.body;
const eye = document.getElementById("eyeSvg");

window.addEventListener("message", (event) => {
  const data = event.data;

  if (data.action === 'updateColor') {
    if (eye) {
      const polygon = eye.querySelector('polygon:first-child');
      if (polygon) {
        polygon.setAttribute('fill', data.color);
      }
    }
    
    const colorWithOpacity = data.color + '9d'; // 60% opacity
    const colorWithLowOpacity = data.color + '52'; // 32% opacity
    
    document.documentElement.style.setProperty('--color-default', data.color);
    document.documentElement.style.setProperty('--color-hover', data.color);
    document.documentElement.style.setProperty('--color-fill', data.color);
    document.documentElement.style.setProperty('--color-border', colorWithOpacity);
    document.documentElement.style.setProperty('--color-shadow', colorWithLowOpacity);
    document.documentElement.style.setProperty('--color-glow-start', data.color);
    document.documentElement.style.setProperty('--color-glow-end', data.color);
    
    if (eye) {
      eye.style.animation = 'none';
      void eye.offsetWidth;
      eye.style.animation = 'glow 1.5s infinite';
    }
    
    return; 
  }

  switch (data.event) {
    case "visible": {
      optionsWrapper.innerHTML = "";
      body.style.visibility = data.state ? "visible" : "hidden";
      return eye.classList.remove("eye-hover");
    }

    case "leftTarget": {
      optionsWrapper.innerHTML = "";
      return eye.classList.remove("eye-hover");
    }

    case "setTarget": {
      eye.classList.add("eye-hover");
      optionsWrapper.innerHTML = "";

      if (data.options) {
        for (const type in data.options) {
          data.options[type].forEach((optionData, id) => {
            createOptions(type, optionData, id + 1);
          });
        }
      }

      if (data.zones) {
        for (let i = 0; i < data.zones.length; i++) {
          data.zones[i].forEach((optionData, id) => {
            createOptions("zones", optionData, id + 1, i + 1);
          });
        }
      }
    }
  }
});