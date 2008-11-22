Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from qmta03.westchester.pa.mail.comcast.net ([76.96.62.32])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <jeffd@i2k.com>) id 1L3yXu-00007s-KG
	for linux-dvb@linuxtv.org; Sat, 22 Nov 2008 20:53:36 +0100
Received: from localhost (localhost [127.0.0.1])
	by blorp.plorb.com (Postfix) with ESMTP id 6E45F16E06D
	for <linux-dvb@linuxtv.org>; Sat, 22 Nov 2008 14:52:53 -0500 (EST)
Received: from blorp.plorb.com ([127.0.0.1])
	by localhost (blorp.plorb.com [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id Bbio6e-z39mO for <linux-dvb@linuxtv.org>;
	Sat, 22 Nov 2008 14:52:53 -0500 (EST)
Date: Sat, 22 Nov 2008 14:52:52 -0500
From: Jeff DeFouw <jeffd@i2k.com>
To: linux-dvb@linuxtv.org
Message-ID: <20081122195252.GA26727@blorp.plorb.com>
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] notes and code for HVR-1800 S-Video
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

I compared the registers in different modes with the Windows driver for 
my WinTV-HVR-1800 (CX23887 based, PCI-E).  Setting the AFE control 
registers fixes bad and flickering colors in S-Video mode.  The same 
register values are used for Composite.

/* Set AFE control for Composite/S-Video input */
cx25840_write4(client, 0x104, 0x071cdc00);

In analog tuner mode, the values are the chip defaults (0x0704dd80), but 
I've left the regs set for S-Video and didn't notice anything.

To get the external audio input working (for Composite and S-Video 
modes), the input needs to be set to AC97, unmuted, and the 
microcontroller must be disabled (so it doesn't mute it).  The 
microcontroller was always being enabled for some reason no matter the 
audio source.

/* Set Path1 to AC97 and unmute */
cx25840_write4(client, 0x8d0, 0x00063073);

With those two changes I am able to record S-Video and external audio 
through the MPEG encoder.  I managed to hack the code up enough to get 
all modes working based on the input setting.  It's not clear in the 
existing cx23885-cx25840 framework how the audio input is supposed to be 
configured.

Other issues:

The MPEG encoder video device randomly fails to start streaming, times 
out, and returns an I/O error.  It's like something isn't being reset or 
waited on properly during the setup.  The next attempt usually works, 
but I can try 5 times and not succeed.

The MPEG encoder video device rejects attempts to set the input and 
other settings as the raw video device does.  The raw video device must 
be used for configuration, so any application would have to do something 
special with both devices to be fully functional.  Is there a reason for 
that?

Viewing the analog tuner over the raw video device and then using the 
MPEG video device often causes the tuner video on both devices to be 
scrambled.  Reloading the modules fixes it.  This only happens the first 
time after boot.

The cx23885-audio branch screws up the operation of my card.  
Specifically the patch to cx23885_initialize that disables the write to 
register 0x2 affects my board and scrambles the video and audio rate.  
It even screws up the MCU firmware download.

-- 
Jeff DeFouw <jeffd@i2k.com>

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
