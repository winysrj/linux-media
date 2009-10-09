Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f210.google.com ([209.85.218.210]:45504 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933523AbZJIPcO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Oct 2009 11:32:14 -0400
Received: by bwz6 with SMTP id 6so1667213bwz.37
        for <linux-media@vger.kernel.org>; Fri, 09 Oct 2009 08:31:37 -0700 (PDT)
Message-ID: <4ACF7374.8090908@xfce.org>
Date: Fri, 09 Oct 2009 17:31:32 +0000
From: Ali Abdallah <aliov@xfce.org>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: Michael Krufky <mkrufky@kernellabs.com>,
	linux-media@vger.kernel.org
Subject: Re: Hauppage WinTV-HVR-900H
References: <4ACDF829.3010500@xfce.org>	 <37219a840910080545v72165540v622efd43574cf085@mail.gmail.com>	 <4ACDFED9.30606@xfce.org>	 <829197380910080745j3015af10pbced2a7e04c7595b@mail.gmail.com>	 <4ACE2D5B.4080603@xfce.org>	 <829197380910080928t30fc0ecas7f9ab2a7d8437567@mail.gmail.com>	 <4ACF03BA.4070505@xfce.org>	 <829197380910090629h64ce22e5y64ce5ff5b5991802@mail.gmail.com>	 <4ACF714A.2090209@xfce.org> <829197380910090826r5358a8a2p7a13f2915b5adcd8@mail.gmail.com>
In-Reply-To: <829197380910090826r5358a8a2p7a13f2915b5adcd8@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Devin Heitmueller wrote:
> On Fri, Oct 9, 2009 at 1:22 PM, Ali Abdallah <aliov@xfce.org> wrote:
>   
>> Screenshots here for TV and S-Video input configuration with TV time.
>>
>> http://ali.blogsite.org/files/tvtime/
>>     
>>> Could you try the S-Video or composite input and see if the picture
>>> quality is still bad (as this well help isolate whether it's a problem
>>> with the tuner chip or the decoder.
>>>
>>>       
>> Same picture quality with S-Video, but with composite there is no picture.
>>     
>
> Ok, this helps alot.  This rules out the tuner and suggests that
> perhaps the video decoder is not being programmed properly.
>
> Could you please send me the output of "dmesg"?  
usb 1-1: new high speed USB device using ehci_hcd and address 15
usb 1-1: configuration #1 chosen from 1 choice
em28xx: New device USB 2881 Video @ 480 Mbps (eb1a:2881, interface 0, 
class 0)
em28xx #0: chip ID is em2882/em2883
em28xx #0: i2c eeprom 00: 1a eb 67 95 1a eb 81 28 58 12 5c 00 6a 20 6a 00
em28xx #0: i2c eeprom 10: 00 00 04 57 64 57 00 00 60 f4 00 00 02 02 00 00
em28xx #0: i2c eeprom 20: 56 00 01 00 00 00 02 00 b8 00 00 00 5b 1e 00 00
em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 10 02 00 00 00 00 00 00
em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 20 03 55 00 53 00
em28xx #0: i2c eeprom 70: 42 00 20 00 32 00 38 00 38 00 31 00 20 00 56 00
em28xx #0: i2c eeprom 80: 69 00 64 00 65 00 6f 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom 90: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: i2c eeprom e0: 5a 00 55 aa 79 55 54 03 00 17 98 01 00 00 00 00
em28xx #0: i2c eeprom f0: 0c 00 00 01 00 00 00 00 00 00 00 00 00 00 00 00
em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0xb8846b20
em28xx #0: EEPROM info:
em28xx #0:    AC97 audio (5 sample rates)
em28xx #0:    USB Remote wakeup capable
em28xx #0:    500mA max power
em28xx #0:    Table at 0x04, strings=0x206a, 0x006a, 0x0000
em28xx #0: Identified as Unknown EM2750/28xx video grabber (card=1)
em28xx #0: Your board has no unique USB ID.
em28xx #0: A hint were successfully done, based on eeprom hash.
em28xx #0: This method is not 100% failproof.
em28xx #0: If the board were missdetected, please email this log to:
em28xx #0:     V4L Mailing List  <linux-media@vger.kernel.org>
em28xx #0: Board detected as Pinnacle Hybrid Pro
tvp5150 1-005c: chip found @ 0xb8 (em28xx #0)
tuner 1-0061: chip found @ 0xc2 (em28xx #0)
xc2028 1-0061: creating new instance
xc2028 1-0061: type set to XCeive xc2028/xc3028 tuner
usb 1-1: firmware: requesting xc3028-v27.fw
xc2028 1-0061: Loading 80 firmware images from xc3028-v27.fw, type: 
xc2028 firmware, ver 2.7
xc2028 1-0061: Loading firmware for type=BASE (1), id 0000000000000000.
xc2028 1-0061: Loading firmware for type=(0), id 000000000000b700.
SCODE (20000000), id 000000000000b700:
xc2028 1-0061: Loading SCODE for type=MONO SCODE HAS_IF_4320 (60008000), 
id 0000000000008000.
em28xx #0: Config register raw data: 0x58
em28xx #0: AC97 vendor ID = 0xffffffff
em28xx #0: AC97 features = 0x6a90
em28xx #0: Empia 202 AC97 audio processor detected
tvp5150 1-005c: tvp5150am1 detected.
em28xx #0: v4l2 driver version 0.1.2
em28xx #0: V4L2 video device registered as /dev/video0
em28xx #0: V4L2 VBI device registered as /dev/vbi0
xc2028 1-0061: attaching existing instance
xc2028 1-0061: type set to XCeive xc2028/xc3028 tuner
em28xx #0/2: xc3028 attached
DVB: registering new adapter (em28xx #0)
DVB: registering adapter 0 frontend 0 (Zarlink ZL10353 DVB-T)...
Successfully loaded em28xx-dvb
tvp5150 1-005c: tvp5150am1 detected.
tvp5150 1-005c: tvp5150am1 detected.
tvp5150 1-005c: tvp5150am1 detected.
xc2028 1-0061: Loading firmware for type=BASE F8MHZ (3), id 
0000000000000000.
(0), id 0000000000ff0000:
xc2028 1-0061: Loading firmware for type=(0), id 0000000000200000.
xc2028 1-0061: Loading SCODE for type=MONO SCODE HAS_IF_6320 (60008000), 
id 0000000000200000.
tvp5150 1-005c: tvp5150am1 detected.
xc2028 1-0061: Loading firmware for type=BASE F8MHZ (3), id 
0000000000000000.
(0), id 0000000000ff0000:
xc2028 1-0061: Loading firmware for type=(0), id 0000000000200000.
xc2028 1-0061: Loading SCODE for type=MONO SCODE HAS_IF_6320 (60008000), 
id 0000000000200000.


> I'll see about
> setting up a tree with some additional debugging for you to try out.
>   

Okay i'm ready to try it out.

> Thanks,
>
> Devin
>
>   

Cheers,

Ali.

