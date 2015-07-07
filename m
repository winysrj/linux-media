Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx02.posteo.de ([89.146.194.165]:37452 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757449AbbGGQZv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 7 Jul 2015 12:25:51 -0400
Date: Tue, 7 Jul 2015 18:25:41 +0200
From: Patrick Boettcher <patrick.boettcher@posteo.de>
To: Peter Fassberg <pf@leissner.se>
Cc: linux-media@vger.kernel.org
Subject: Re: PCTV Triplestick and Raspberry Pi B+
Message-ID: <20150707182541.0960177f@lappi3.parrot.biz>
In-Reply-To: <alpine.BSF.2.20.1507071736350.72900@nic-i.leissner.se>
References: <alpine.BSF.2.20.1507041303560.12057@nic-i.leissner.se>
	<20150705184449.0017f114@lappi3.parrot.biz>
	<alpine.BSF.2.20.1507071722280.72900@nic-i.leissner.se>
	<20150707173500.21041ab3@dibcom294.coe.adi.dibcom.com>
	<alpine.BSF.2.20.1507071736350.72900@nic-i.leissner.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 7 Jul 2015 17:38:25 +0200 (SST)
Peter Fassberg <pf@leissner.se> wrote:

> On Tue, 7 Jul 2015, Patrick Boettcher wrote:
> 
> >> I installed the 32-bit version of the same OS (Debian 8, kernel 3.16.0, i386) and the result was a bit suprising.
> >>
> >> In 32-bit I couldn't even scan a DVT-T transponder!  dvbv5-scan did Lock, but it didn't find any PSI PIDs.  So there is for sure a problem with 32-bit platforms.  And the DVT-T2 transponders didn't work either.
> >>
> >> Maybe the Raspberry problem can be a Endianess problem?
> >
> > No, rpi (arm) is little-endian as Intel.
> >
> > Which drivers is your device using again?
> 
> [    7.245815] em28xx: New device PCTV PCTV 292e @ 480 Mbps (2013:025f, interface 0, class 0)
> [    7.256731] em28xx: DVB interface 0 found: isoc
> [    7.262712] em28xx: chip ID is em28178
> [    9.258341] em28178 #0: EEPROM ID = 26 00 01 00, EEPROM hash = 0x5110ff04
> [    9.267163] em28178 #0: EEPROM info:
> [    9.272644] em28178 #0:      microcode start address = 0x0004, boot configuration = 0x01
> [    9.291418] em28178 #0:      AC97 audio (5 sample rates)
> [    9.298231] em28178 #0:      500mA max power
> [    9.303993] em28178 #0:      Table at offset 0x27, strings=0x146a, 0x1888, 0x0a7e
> [    9.313288] em28178 #0: Identified as PCTV tripleStick (292e) (card=94)
> [    9.321852] em28178 #0: dvb set to isoc mode.
> [    9.328536] usbcore: registered new interface driver em28xx
> [    9.357476] em28178 #0: Binding DVB extension
> [    9.380909] i2c i2c-1: Added multiplexed i2c bus 2
> [    9.389469] si2168 1-0064: Silicon Labs Si2168 successfully attached
> [    9.410263] si2157 2-0060: Silicon Labs Si2147/2148/2157/2158 successfully attached
> [    9.422419] DVB: registering new adapter (em28178 #0)
> [    9.428929] usb 1-1.4: DVB: registering adapter 0 frontend 0 (Silicon Labs Si2168)...
> [    9.442954] em28178 #0: DVB extension successfully initialized
> [    9.450692] em28xx: Registered (Em28xx dvb Extension) extension
> [    9.482115] em28178 #0: Registering input extension
> [    9.563907] em28178 #0: Input extension successfully initalized
> [    9.571364] em28xx: Registered (Em28xx Input Extension) extension
> [  297.703612] si2168 1-0064: found a 'Silicon Labs Si2168-B40'
> [  300.998391] si2168 1-0064: downloading firmware from file 'dvb-demod-si2168-b40-01.fw'
> [  301.275434] si2168 1-0064: firmware version: 4.0.4 [  301.284625] si2157 2-0060: found a 'Silicon Labs Si2157-A30'
> [  301.340643] si2157 2-0060: firmware version: 3.0.5

Just reading quickly the changes made to the si2157 and si2168 driver
since 3.16 up to 4.1 makes me think that it is worth a try. 

Plenty of things have changed regarding buffers and memcpy. Though I
haven't found (yet) a 64bit and 32bit mix up yet in the 3.16 version.

Might be the RF frequency that is truncated on 32bit platforms
somewhere. That could explain that there is no crash but simply not
tuning.

Can you easily try more recent kernels or media_trees?
--
Patrick.



