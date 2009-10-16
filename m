Return-path: <linux-media-owner@vger.kernel.org>
Received: from jack.mail.tiscali.it ([213.205.33.53]:54271 "EHLO
	jack.mail.tiscali.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbZJPVvB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 16 Oct 2009 17:51:01 -0400
Message-ID: <4AD8EA6E.1050004@email.it>
Date: Fri, 16 Oct 2009 23:49:34 +0200
From: xwang1976@email.it
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: em28xx DVB modeswitching change: call for testers
References: <829197380910132052w155116ecrcea808abe87a57a6@mail.gmail.com>
In-Reply-To: <829197380910132052w155116ecrcea808abe87a57a6@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------060509060703070300010403"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060509060703070300010403
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Devin,
I've tested my Empire Dual TV.
These are the results:
1) it is recognized as a different card (as you can see from the dmesg
2) it works perfectly in digital mode (even if itdetects less channel 
than the Dikom DK-300 (aka Kworld 323U?). It scans and tune channels and 
they can be seen and listened.
3) it can tune analog tv channels
4) it shows analog programs
5) it does not play any sound when showing analog tv programs (I sent 
the script I use to play sox and the output I obtain execunting it)

Xwang

Ps I've tried also the Dikom DK-300 but it is recognized as a kworld 
323u and digital tv does not work at all (kaffeine does not display the 
bottom to select it) while the anlog tv can tune channel but has the 
same audio issue (is the script I use correct?)

Devin Heitmueller ha scritto:
> Hello all,
> 
> I have setup a tree that removes the mode switching code when
> starting/stopping streaming.  If you have one of the em28xx dvb
> devices mentioned in the previous thread and volunteered to test,
> please try out the following tree:
> 
> http://kernellabs.com/hg/~dheitmueller/em28xx-modeswitch
> 
> In particular, this should work for those of you who reported problems
> with zl10353 based devices like the Pinnacle 320e (or Dazzle) and were
> using that one line change I sent this week.  It should also work with
> Antti's Reddo board without needing his patch to move the demod reset
> into the tuner_gpio.
> 
> This also brings us one more step forward to setting up the locking
> properly so that applications cannot simultaneously open the analog
> and dvb side of the device.
> 
> Thanks for your help,
> 
> Devin
> 

--------------060509060703070300010403
Content-Type: text/plain;
 name="Output_sox.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="Output_sox.txt"

$ ./start_tvtime.sh
Running tvtime 1.0.2.
Reading configuration from /etc/tvtime/tvtime.xml
Reading configuration from /home/andreak/.tvtime/tvtime.xml

Input File     : 'hw:1,0' (alsa)
Channels       : 2
Sample Rate    : 48000
Precision      : 16-bit
Sample Encoding: 16-bit Signed Integer PCM

In:0.00% 00:00:00.00 [00:00:00.00] Out:0     [      |      ]        Clip:0    sox sox: hw:1,0: ALSA read error: Operation not permitted
In:0.00% 00:00:00.00 [00:00:00.00] Out:0     [      |      ]        Clip:0
Done.

Thank you for using tvtime.
kill: 6: No such process


--------------060509060703070300010403
Content-Type: text/plain;
 name="dmesg_empire.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmesg_empire.txt"

[175538.084082] usb 1-2: new high speed USB device using ehci_hcd and address 4                                                            
[175538.221574] usb 1-2: configuration #1 chosen from 1 choice                                                                             
[175538.221793] em28xx: New device USB 2881 Device @ 480 Mbps (eb1a:e310, interface 0, class 0)
[175538.221940] em28xx #0: chip ID is em2882/em2883
[175538.382058] em28xx #0: i2c eeprom 00: 1a eb 67 95 1a eb 10 e3 d0 12 5c 03 6a 22 00 00
[175538.382089] em28xx #0: i2c eeprom 10: 00 00 04 57 4e 07 00 00 00 00 00 00 00 00 00 00
[175538.382116] em28xx #0: i2c eeprom 20: 46 00 01 00 f0 10 01 00 00 00 00 00 5b 1e 00 00
[175538.382143] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 01 01 00 00 00 00 00 00
[175538.382170] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[175538.382197] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[175538.382223] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 22 03 55 00 53 00
[175538.382250] em28xx #0: i2c eeprom 70: 42 00 20 00 32 00 38 00 38 00 31 00 20 00 44 00
[175538.382276] em28xx #0: i2c eeprom 80: 65 00 76 00 69 00 63 00 65 00 00 00 00 00 00 00
[175538.382303] em28xx #0: i2c eeprom 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[175538.382330] em28xx #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[175538.382356] em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[175538.382382] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[175538.382409] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[175538.382435] em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[175538.382461] em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[175538.382492] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0x166a0441
[175538.382498] em28xx #0: EEPROM info:
[175538.382503] em28xx #0:      AC97 audio (5 sample rates)
[175538.382509] em28xx #0:      500mA max power
[175538.382515] em28xx #0:      Table at 0x04, strings=0x226a, 0x0000, 0x0000
[175538.382525] em28xx #0: Identified as MSI DigiVox A/D (card=49)
[175538.382532] em28xx #0: Your board has no unique USB ID.
[175538.382541] em28xx #0: A hint were successfully done, based on eeprom hash.
[175538.382548] em28xx #0: This method is not 100% failproof.
[175538.382555] em28xx #0: If the board were missdetected, please email this log to:
[175538.382562] em28xx #0:      V4L Mailing List  <linux-media@vger.kernel.org>
[175538.382569] em28xx #0: Board detected as Empire dual TV
[175538.715497] tvp5150 3-005c: chip found @ 0xb8 (em28xx #0)
[175538.831302] tuner 3-0061: chip found @ 0xc2 (em28xx #0)
[175538.831772] xc2028 3-0061: creating new instance
[175538.831780] xc2028 3-0061: type set to XCeive xc2028/xc3028 tuner
[175538.831795] usb 1-2: firmware: requesting xc3028-v27.fw
[175539.134790] xc2028 3-0061: Loading 80 firmware images from xc3028-v27.fw, type: xc2028 firmware, ver 2.7
[175539.204055] xc2028 3-0061: Loading firmware for type=BASE MTS (5), id 0000000000000000.
 

--------------060509060703070300010403
Content-Type: application/x-sh;
 name="start_tvtime.sh"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="start_tvtime.sh"

#!/bin/sh
#xterm -hold -e sox -r 48000 -t alsa hw:1,0 -t alsa default &
sox -r 48000 -t alsa hw:1,0 -t alsa default &
mpid=$!
tvtime -d /dev/video0
kill $mpid 

--------------060509060703070300010403--
