Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from outgoing.selfhost.de ([82.98.87.70] helo=mordac.selfhost.de)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <bumkunjo@gmx.de>) id 1JyPuk-0000yg-Db
	for linux-dvb@linuxtv.org; Tue, 20 May 2008 13:21:57 +0200
From: jochen s <bumkunjo@gmx.de>
To: linux-dvb@linuxtv.org
Date: Tue, 20 May 2008 13:21:49 +0200
References: <20080513085753.5AD4411581F@ws1-7.us4.outblaze.com>
	<1210721429.14631.5.camel@media1>
In-Reply-To: <1210721429.14631.5.camel@media1>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200805201321.49598.bumkunjo@gmx.de>
Subject: Re: [linux-dvb]
	=?iso-8859-1?q?DViCO_Fusion_HDTV_DVB-T_Dual_Express_-?=
	=?iso-8859-1?q?_When_will=09it_be?=
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


I tried to use the xc-test branch with this card and loading the driver with 
option card=5 looks good:

 468.353850] cx23885 driver version 0.0.1 loaded
[  468.354084] ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 16 (level, low) -> 
IRQ 16
[  468.354213] CORE cx23885[0]: subsystem: 18ac:db78, board: DViCO FusionHDTV 
DVB-T Dual Express [card=5,insmod option]
[  468.402021] input: i2c IR (FusionHDTV) as /class/input/input6
[  468.402153] ir-kbd-i2c: i2c IR (FusionHDTV) detected at i2c-2/2-006b/ir0 
[cx23885[0]]
[  468.402157] cx23885[0]: i2c bus 0 registered
[  468.402814] cx23885[0]: i2c bus 1 registered
[  468.402950] cx23885[0]: i2c bus 2 registered
[  468.424684] cx23885[0]: cx23885 based dvb card
[  468.427525] xc2028 2-0061: type set to XCeive xc2028/xc3028 tuner
[  468.427625] DVB: registering new adapter (cx23885[0])
[  468.427723] DVB: registering frontend 1 (Zarlink ZL10353 DVB-T)...
[  468.428072] cx23885[0]: cx23885 based dvb card
[  468.430856] xc2028 3-0061: type set to XCeive xc2028/xc3028 tuner
[  468.430954] DVB: registering new adapter (cx23885[0])
[  468.431051] DVB: registering frontend 2 (Zarlink ZL10353 DVB-T)...
[  468.431383] cx23885[0]/0: found at 0000:02:00.0, rev: 2, irq: 16, latency: 
0, mmio: 0xfd600000
[  468.431392] PCI: Setting latency timer of device 0000:02:00.0 to 64

but  when tuning to a channel via VDR  it does not work - i got STR 0% SNR 0% 
and immediately after changing to the card my system load goes up and I got 
the following messages (continuing): 

[  590.342432] xc2028 2-0061: Loading 3 firmware images from 
xc3028-dvico-au-01.fw, type: DViCO DualDig4/Nano2 (Australia), ver 2.7
[  590.344845] xc2028 2-0061: Loading firmware for type=BASE F8MHZ (3), id 
0000000000000000.
[  590.838414] xc2028 2-0061: Loading firmware for type=BASE F8MHZ (3), id 
0000000000000000.
[  592.654769] xc2028 2-0061: Loading firmware for type=BASE F8MHZ (3), id 
0000000000000000.
[  593.522195] xc2028 2-0061: Loading firmware for type=BASE F8MHZ (3), id 
0000000000000000.
[  595.363939] xc2028 2-0061: Loading firmware for type=BASE F8MHZ (3), id 
0000000000000000.
[  595.927471] xc2028 2-0061: Loading firmware for type=BASE F8MHZ (3), id 
0000000000000000.

then syslog is full of these messages - so I assume something went wrong - 
seems like the firmware doesn't match or loading the firmware fails in a way?

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
