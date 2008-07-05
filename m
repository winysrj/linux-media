Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n60.bullet.mail.sp1.yahoo.com ([98.136.44.40])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <free_beer_for_all@yahoo.com>) id 1KF8dI-0007fx-4M
	for linux-dvb@linuxtv.org; Sat, 05 Jul 2008 16:21:03 +0200
Date: Sat, 5 Jul 2008 07:20:22 -0700 (PDT)
From: barry bouwsma <free_beer_for_all@yahoo.com>
To: linux-dvb@linuxtv.org
In-Reply-To: <153722.52467.qm@web46116.mail.sp1.yahoo.com>
MIME-Version: 1.0
Message-ID: <577691.27608.qm@web46112.mail.sp1.yahoo.com>
Subject: Re: [linux-dvb] UMT-010-like USB DVB-T receivers, that aren't
Reply-To: free_beer_for_all@yahoo.com
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

Yo!  What I said!

> I've seen messages from the past years in the archive referring
> to the UMT-010 code that seems to not work with different
> devices.  I've got one of them, that's partly supported but

> The MT352 demodulator is successfully identified.
> I tried, disconnecting the device results in a panic, which

Fixed by the recent patch.


> The actual tuner in the stick is the MT2060F.  I'm guessing I
> The tuner in my stick is definitively not on the expected 0x61,
> but at 0x60

Successfully probed and identified:

[11881.612826] DVB: registering new adapter (Hanftek UMT-010 DVB-T USB2.0)
[11881.621216] DVB: registering frontend 2 (Zarlink MT352 DVB-T)...
[11881.625922] MT2060: successfully identified (IF1 = 1220)
[11882.201936] dibusb: Found MT2060 at 0x60

However with the warning after loading firmware, Linux/Hanftek:
[11881.580848] usb 4-2.2: config 1 interface 0 altsetting 0 bulk endpoint 0x1 has invalid maxpacket 64
[11881.581169] usb 4-2.2: config 1 interface 0 altsetting 0 bulk endpoint 0x81 has invalid maxpacket 64
[11881.584942] usb 4-2.2: configuration #1 chosen from 1 choice

Similar warning when loaded vendor firmware from cdrom (prod ID 0x25) :
[11138.581373] usb 4-2.2: config 1 interface 0 altsetting 0 bulk endpoint 0x1 has invalid maxpacket 64
[11138.581712] usb 4-2.2: config 1 interface 0 altsetting 0 bulk endpoint 0x81 has invalid maxpacket 64
[11138.581987] usb 4-2.2: config 1 interface 0 altsetting 0 bulk endpoint 0x82 has invalid maxpacket 376
[11138.584747] usb 4-2.2: configuration #1 chosen from 1 choice


In neither case have I yet to receive any signal whatsoever when
scanning verbosely.  Code is based on 2.6.26-rc8 aged a week for
smoothness, manually patched and hacked for the MT2060 at 0x60.



> If there might be an additional PLL chip, that might be what
> I see mounted on the bottom of the board, next to the MT2060,

Lies, untruths, falsehoods, slander.  Here's a complete inventory
of significant components on this Clone'o'Hanftek:

working from antenna towards USB connector, upperside of board

label VT6330C1 VER:1.0
Tuner  MT2060F
smd bandpass filter (if filter)  EPCOS X7350P on side
    prob IR RX, no label
Demod  MT352CG
serial eeprom  ATMEL630 + 24C02BN
24MHz xtal
empty space for one LED next to USB connector

bottom of board
not a PLL, but 18MHz xtal
20,48MHz xtal
EZ-USB uC  CY7C68013A-56LFXC + cyp 606155



I've just grepped the list archives and reread the messages about
Hanftek/UMT-010.  None of them (esp.2006-ish) seemed to come to
a satisfactory conclusion within the list archive.

As this board has the MT2060 tuner, is it appropriate that I try
to keep it within the umt-010.c framework?  I bet I need to add
more config info to the tuner attach, which so far has been without
success.

Or should I be trying to get dibusb to talk to this device, as the
umt source seems to partly depend on that?  Or something else??

And should I concern myself with the maxpacket messages???


You've heard it before, I don't know what I'm doing
thanks
barry bouwsma


      


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
