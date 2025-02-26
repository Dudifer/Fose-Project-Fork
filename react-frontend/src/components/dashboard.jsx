import React from "react";

function dashboard() {
  return (
    <div className="container">
      <h1>Welcome to the Dashboard</h1>
      <div className="options-box">
        <h2>What would you like to do?</h2>
        <ul>
          <li>
            <button onClick={() => alert("Request Help Selected")}>
              Request Help
            </button>
          </li>
          <li>
            <button onClick={() => alert("Respond to Help Selected")}>
              Respond to Help
            </button>
          </li>
        </ul>
      </div>
    </div>
  );
}

export default dashboard;