import React, { Component } from 'react';
//import logo from './8ball.png';
import './App.css';
import {venuContract} from './EthereumSetup.js';

class App extends Component {

    constructor(props) {
        super(props)
        this.state = {
            currentPrice: 5
        }
        //this.execute = this.execute.bind(this);
    }

    componentWillMount() {
        var data = venuContract.calcTokenPrice.call()
        console.log(data.toString())
        this.setState({
          currentPrice: data.toString()
        })
        document.write(this.state.currentPrice)
    }

    render() {
        return (
            <center>
                <p><strong>Your Potential Events:</strong></p>
                <table>
                    <tr>
                        <th>Location</th>
                        <th>Date</th>
                        <th>Time</th>
                        <th>Minimum Revenue</th>
                        <th>Minimum Attendance</th>
                        <th>Accept/Deny</th>
                    </tr>
                    <tr>
                        <td>Oracle Arena</td>
                        <td>11/28/17</td>
                        <td>8:00 pm</td>
                        <td><input type="number" /> ether</td>
                        <td><input type="number" /> people</td>
                        <td><button>Accept</button>  <button>Deny</button></td>
                    </tr>
                </table>

                <br />
                <br />
                <br />

                <p><strong>Upcoming Events</strong></p>
                <table>
                    <tr>
                        <th>Artist</th>
                        <th>Location</th>
                        <th>Date</th>
                        <th>Time</th>
                        <th>Current Price</th>
                        <th>Buy Tickets!</th>
                    </tr>
                    <tr>
                        <td>Panic! at the Crypto</td>
                        <td>Berkeley Greek Theater</td>
                        <td>10/31/17</td>
                        <td>7:00 pm</td>
                        <td>1 eth ($300)</td>
                        <td><input type = "number" /> Tickets <button>Place Bid</button></td>
                    </tr>
                    <tr>
                        <td>Vitallica</td>
                        <td>Bill Graham Civic Auditorium</td>
                        <td>11/10/17</td>
                        <td>8:00 pm</td>
                        <td>0.5 eth ($150)</td>
                        <td><input type = "number" /> Tickets <button>Place Bid</button></td>
                    </tr>
                    <tr>
                        <td>Tupac SHA-kur</td>
                        <td>The Warfield</td>
                        <td>11/25/17</td>
                        <td>9:00 pm</td>
                        <td>0.25 eth ($75)</td>
                        <td><input type = "number" /> Tickets <button>Place Bid</button></td>
                    </tr>
                </table>
            </center>
        );
    }
  }

export default App;
