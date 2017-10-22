import React, { Component } from 'react';
//import logo from './8ball.png';
import './App.css';
import {venuContract} from './EthereumSetup.js';
import web3 from './EthereumSetup.js';

class App extends Component {

    constructor(props) {
        super(props)
        this.state = {
            currentPrice: "",
            answer: ""
        }
        this.execute = this.execute.bind(this);
    }

    execute(e) {
        window.print("Current Price: " + )
    }

    render() {
        return (
                <center><table>
                    <tr onmouseover = "execute()">
                        Panic! at the Crypto @ Berkeley Greek Theater on 10/31
                    </tr>
                    <tr>
                        Vitalica @ Bill Graham Civic Auditorium on 11/10
                    </tr>
                    <tr>
                        Tupac SHA-kur @ The Warfield on 11/25
                    </tr>
                </table></center>
        );
    }
  }

export default App;
