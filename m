Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailgate.leissner.se ([212.3.1.210]:21048 "EHLO
	mailgate.leissner.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752916AbbGGPij (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 7 Jul 2015 11:38:39 -0400
Date: Tue, 7 Jul 2015 17:38:25 +0200 (SST)
From: Peter Fassberg <pf@leissner.se>
To: Patrick Boettcher <patrick.boettcher@posteo.de>
cc: linux-media@vger.kernel.org
Subject: Re: PCTV Triplestick and Raspberry Pi B+
In-Reply-To: <20150707173500.21041ab3@dibcom294.coe.adi.dibcom.com>
Message-ID: <alpine.BSF.2.20.1507071736350.72900@nic-i.leissner.se>
References: <alpine.BSF.2.20.1507041303560.12057@nic-i.leissner.se> <20150705184449.0017f114@lappi3.parrot.biz> <alpine.BSF.2.20.1507071722280.72900@nic-i.leissner.se> <20150707173500.21041ab3@dibcom294.coe.adi.dibcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 7 Jul 2015, Patrick Boettcher wrote:

>> I installed the 32-bit version of the same OS (Debian 8, kernel 3.16.0, i386) and the result was a bit suprising.
>>
>> In 32-bit I couldn't even scan a DVT-T transponder!  dvbv5-scan did Lock, but it didn't find any PSI PIDs.  So there is for sure a problem with 32-bit platforms.  And the DVT-T2 transponders didn't work either.
>>
>> Maybe the Raspberry problem can be a Endianess problem?
>
> No, rpi (arm) is little-endian as Intel.
>
> Which drivers is your device using again?

[    7.245815] em28xx: New device PCTV PCTV 292e @ 480 Mbps (2013:025f, interface 0, class 0)
[    7.256731] em28xx: DVB interface 0 found: isoc
[    7.262712] em28xx: chip ID is em28178
[    9.258341] em28178 #0: EEPROM ID = 26 00 01 00, EEPROM hash = 0x5110ff04
[    9.267163] em28178 #0: EEPROM info:
[    9.272644] em28178 #0:      microcode start address = 0x0004, boot configuration = 0x01
[    9.291418] em28178 #0:      AC97 audio (5 sample rates)
[    9.298231] em28178 #0:      500mA max power
[    9.303993] em28178 #0:      Table at offset 0x27, strings=0x146a, 0x1888, 0x0a7e
[    9.313288] em28178 #0: Identified as PCTV tripleStick (292e) (card=94)
[    9.321852] em28178 #0: dvb set to isoc mode.
[    9.328536] usbcore: registered new interface driver em28xx
[    9.357476] em28178 #0: Binding DVB extension
[    9.380909] i2c i2c-1: Added multiplexed i2c bus 2
[    9.389469] si2168 1-0064: Silicon Labs Si2168 successfully attached
[    9.410263] si2157 2-0060: Silicon Labs Si2147/2148/2157/2158 successfully attached
[    9.422419] DVB: registering new adapter (em28178 #0)
[    9.428929] usb 1-1.4: DVB: registering adapter 0 frontend 0 (Silicon Labs Si2168)...
[    9.442954] em28178 #0: DVB extension successfully initialized
[    9.450692] em28xx: Registered (Em28xx dvb Extension) extension
[    9.482115] em28178 #0: Registering input extension
[    9.563907] em28178 #0: Input extension successfully initalized
[    9.571364] em28xx: Registered (Em28xx Input Extension) extension
[  297.703612] si2168 1-0064: found a 'Silicon Labs Si2168-B40'
[  300.998391] si2168 1-0064: downloading firmware from file 'dvb-demod-si2168-b40-01.fw'
[  301.275434] si2168 1-0064: firmware version: 4.0.4 [  301.284625] si2157 2-0060: found a 'Silicon Labs Si2157-A30'
[  301.340643] si2157 2-0060: firmware version: 3.0.5



// Peter

