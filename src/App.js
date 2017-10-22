import React, { Component } from 'react';
//import logo from './8ball.png';
import './App.css';
import {venuContract} from './EthereumSetup.js';

class App extends Component {

    constructor(props) {
        super(props)
        this.state = {
            currentPrice: 0
        }
        //this.execute = this.execute.bind(this);
    }

    componentWillMount() {
        var data = venuContract.calcTokenPrice.call()
        console.log(data)
        this.setState({
          currentPrice: data
        })
        document.write(this.state.currentPrice)
    }

    execute() {
        window.print("Current Price: " + this.state.currentPrice)
    }

    render() {
        return (
                <center>
                    <button onclick = "execute">Panic! at the Crypto @ Berkeley Greek Theater on 10/31</button>
                    <br />
                    <button>Vitalica @ Bill Graham Civic Auditorium on 11/10</button>
                    <br />
                    <button>Tupac SHA-kur @ The Warfield on 11/25</button>
                </center>
        );
    }
  }

export default App;
