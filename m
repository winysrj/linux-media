Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ppp196-18.static.internode.on.net ([59.167.196.18]
	helo=jumpgate.rods.id.au) by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <Rod@Rods.id.au>) id 1JSRQl-0002VU-8s
	for linux-dvb@linuxtv.org; Fri, 22 Feb 2008 07:30:48 +0100
Received: from jumpgate.rods.id.au (localhost [127.0.0.1])
	by jumpgate.rods.id.au (Postfix) with ESMTP id CDDFB5B77FC
	for <linux-dvb@linuxtv.org>; Fri, 22 Feb 2008 17:29:51 +1100 (EST)
Received: from [192.168.3.44] (unknown [192.168.3.44])
	by jumpgate.rods.id.au (Postfix) with ESMTP id B7E525B776E
	for <linux-dvb@linuxtv.org>; Fri, 22 Feb 2008 17:29:51 +1100 (EST)
Message-ID: <47BE6BDE.1090403@Rods.id.au>
Date: Fri, 22 Feb 2008 17:29:50 +1100
From: Rod <Rod@Rods.id.au>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
References: <47BD55BA.1040305@Rods.id.au>
In-Reply-To: <47BD55BA.1040305@Rods.id.au>
Subject: Re: [linux-dvb] Compro VideoMate T-750 DVB tuner card, any updates?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

    Update info on the card connections at the end..

Rod wrote:
> Hi... new here..
>
>     Just wondering if there were any updates with the Compro T-750 dual 
> tuner card?
>
>     Possibly the interesting bit is at the end...
>
>     I had a look at "previous posts" but found only that the card was 
> scanned with some Windoze software???  I don't have that software, but 
> here is what I know
>
>     1/. there is nothing written anywhere that the card uses QT1010 or a 
> XC2028, seems no one has tried pulling the "Cans" from the PCB, easy 
> job, when you have the tools ;o)
>
>     The QT1010 is the front-end for the DVB stream (top can)
>
>      The XC2028 is the front-end for the Analog stream (lower can)...
>
>     Most of this, I have E-mailed on the MythTV E-mail list, but 
> re-verifying it here if anyone missed it..
>  
>     Here is what I have found on this little card....
>
>      The RTC on the card, being a known chip, also linked into the 
> "Power-SW" wiring from the front panel simplifies the "power saving 
> feature, also the complexity across differing mobo's and their BIOS 
> timing circuits
>
>      Onboard, it has the following devices.
>
>     DVB-in -> QT1010 -> CE6353 -> SAA7135
>     Analog-in -> XC2028 -> SAA7135
>     Radio-in   -> XC2028  -> SAA7135 (I think it goes thru the XC chip)
>     Composite-in -> SAA7135
>     RTC (DS1337)-> SAA7135 (I2C)
>     EEPROM (HT24LC02)-> SAA7135 (I2C)
>     CE6353 -> SAA7135 (I2C)
>     QT1010 -> CE6353 (I2C)  I'm sure it does this connection, see below..
>
> I have QT1010, SAA7133/5, XC2028, DS1337 loaded as a modules
>
> The RTC is connected to the I2C buss from the SAA7135, the INT
> output is connected thru a custom driver chip (seems like just a custom
> driver similar to a ULN2004 driver chip, I doubt its I2C, it wouldn't
> buzz out to that chip
>
> I2C addresses
> QT1010 = 0xA0 DVB Front End (#)
> DS1337 = 0xD0 RTC, the Alarm out restarts the computer
> HT24LC02 = 0xA0 CMOS 2K 2-wire serial EEPROM (#)
> XC2028 = 0x Analog/Radio front End (Difficult to get
> address info, as its a BGA)
> CE6353 = 0x1E Nordig Unified DVB-T CDFDM Terrestrial
> Demodulator
>
> (#) Now, as you notice, the I2C address for the QT1010 and the EEPROM 
> have the same address (0xA0) I feel (assume, could be wrong) that the 
> I2C for the QT device is wired to the 2nd port of the CE6353 device
>
> QT1010 (module)
> DS1337 (module)
> XC2028 (CX8800 = module) or CX88... series modules
> CE6353 not sure of the module for this yet... not sure how
> programmable it is
>
>
> Have a PDF of the QT1010, cannot find the linky again
> DS1337 http://datasheets.maxim-ic.com/en/ds/DS1337-DS1337C.pdf
> CE6353 http://download.intel.com/design/celect/datashts/D55752.pdf
>
>
>
> CE6353 looks pin-for-pin compatable for the following (Zarlink Devices)
> http://www.pctuner.ru/files/pdf/zarlink_mt352.pdf
> http://www.pctuner.ru/files/pdf/zarlink_zl10353.pdf
>     There is a linky on the Intel web site for cross referencing the CE 
> with Zarlink
>
> Also the I2C address on the chip Doc refers to SADD0:4, in the doc,
> it said that "In the current TNIM evaluation application, the 2-wire bus
> address is 0001 111 R/ W with the pins connected as
> follows:"
>
>     I actually found this rather difficult to understand, but I guess I 
> sussed it...  SADD0:4 is 5 pins that are tied to Vdd or Vss, but the pin 
> outs state they are N.C. (Non Connected) strange..
>
> For the T-750 the configuration is 0001 111r/w Strange how they
> didn't change it, but thats what happens when you follow App notes,...
>
> So, I hope this helps someone getting these little beasties going, I
> would love to utilise them ;o)
>
>
>     Ok, that little bit above was posted on the MythTV-users listserv, 
> no one replied to it  ;o(
>
>      Ok, now for more information, I havn't found this posted on the 
> Internet anywhere, so I did some probing myself, if I had the computer I 
> used to have at work, I could post almost the complete circuit diagram 
> gained from the PCB, and possibly got myself into some real trouble :P
>
>     I don't know what the PRO1A does, but I feel its a port driver, or a 
> masked ROM, or a Fuse link device...
>
>     Someone did mention that the tops of the IC's were damaged, and 
> difficult to read, if you live in Australia, go out and buy yourself a 
> bottle of "Eucalyptus Oil" it'll clean those chips up really well for 
> you, the device is something like a 74ALC74 (or is it ALC174, no matter, 
> its just a simple chip, driving the switch gear to control the outputs, 
> nothing really special, I think its driven a bit by the PRO1A device, if 
> I had that computer (mentioned above) I'd have that figgured out
>
>     I2C comms are as above, no more clarity needed I think..
>
>     I think the bit that people are having a problem with is the GPIO 
> connections... I'm not sure how accurate the Windoze scanner is, but 
> here is what I probed...
>
>     Format, is SAA7134 (SAA) -> CE6353 (CE)
> SAA Pin:Desig -> CE Pin:Desig
> 86:GPIO0 -> 49:MDO0
> 85:GPIO1 -> 50:MDO1
> 84:GPIO2 -> 51:MDO2
> 83:GPIO3 -> 52:MDO3
> 82:GPIO4 -> 53:MDO4
> 81:GPIO5 -> 56:MDO5
> 80:GPIO6 -> 57:MDO6
> 79:GPIO7 -> 58:MDO7
>
> 68:GPIO16 -> 48:MOVAL
>
> 60:GPIO19 -> 47:MOSTRT
> 59:GPIO20 -> 61:MOCLK
>
>     Next is the GPIO to the PRO1A Device from the SAA
>
> SAA 78:GPIO8 -> PRO1A U5:6  (U5 is the PRO1A Desig)
>
> 77:GPIO9 -> U5:7
> 76:GPIO10 -> U5:8
> 77:GPIO11 -> U5:9
>
> 61:GPIO18 -> U5:12
>
> 56:GPIO23 -> U5:13 (or 14) strange, same resistance to either pin from 
> GPIO23 200-500R (Ohms)
>
>     Next, not 100% sure of these being No-Connect... further 
> investigation (another lunch break)
>
> 72:GPIO12
> 71:GPIO13
> 70:GPIO14
> 69:GPIO15
> 58:GPIO21
> 57:GPIO22
> 89:GPIO25
> 88:GPIO26
> 87:GPIO27
>
>     Ok, I hope this helps get this little cart moving...
>   
    Well, had lunch today, and probed deeper into the card, probing with 
some nice sharp test probes (POGO series from ECT)

SAA:70:GPIO14 -> RT104 -> CE:9:RESET

    RT104 is missing, Reset connected to a RC circuit.

SAA:71:GPIO13 -> U5:11
SAA:72:GPIO12 -> U5:10

    There are a number of Test Points (TPx) on the back, near the Analog 
can,

TP9 -> Vdd
TP8 -> SAA:69:GPIO15 (with pull-up resistor)
TP6 -> SDA (I2C on SAA)
TP5 -> SCL (I2D on SAA)
TP3 -> C93 -> SAA:106:SIF

    Guessing,

TP8 = Active Low signal to the XC device
TP5/6 = I2C comms (Given)
TP3 = IF signal Capactively coupled to the IF input of the SAA device

    I think thats about all..

    What else would be needed to get this beasty going?

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
