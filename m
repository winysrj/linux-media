Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f210.google.com ([209.85.218.210]:59893 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758369AbZJLV2q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Oct 2009 17:28:46 -0400
MIME-Version: 1.0
In-Reply-To: <f326ee1a0910121420j59d4f63dy1ffcb1636a9a63d1@mail.gmail.com>
References: <f326ee1a0910121420j59d4f63dy1ffcb1636a9a63d1@mail.gmail.com>
Date: Mon, 12 Oct 2009 17:28:34 -0400
Message-ID: <829197380910121428v2255df2av3bff2f21ad6a5707@mail.gmail.com>
Subject: Re: Kworld Analog TV 305U without audio - updated
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: =?ISO-8859-1?Q?D=EAnis_Goes?= <denishark@gmail.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	lauri.laanmets@proekspert.ee, grythumn@gmail.com,
	jarod@wilsonet.com, ridzevicius@gmail.com, xwang1976@email.it,
	mchehab@infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Oct 12, 2009 at 5:20 PM, Dênis Goes <denishark@gmail.com> wrote:
> Hi...
>
> I updated the driver to latest in repository, but I having audio problems
> yet:
>
> I'm testing a USB TV "Kworld PlusTV Analog TV stick VS-PVR-TV 305U" the TV
> video works fine, but without audio...
> ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
> I tried to pipe the audio via sox:
> tvtime -d /dev/video1 & sox -v 1 -V4 -S -t ossdsp /dev/dsp1 -t ossdsp
> /dev/dsp
>
> -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
> But without sucess, sox report follow error:
>
> sox: SoX v14.2.0
> time:  Dec  1 2008 10:12:25
> issue: Ubuntu jaunty (development branch)
> uname: Linux denis-laptop 2.6.28-11-generic #42-Ubuntu SMP Fri Apr 17
> 01:57:59 UTC 2009 i686
> gcc:   4.3.3 20081130 (prerelease)
> arch:  1248 48 44 L
> sox oss: OSS driver only supports bytes and words
> sox oss: Forcing to signed linear word
>
> Input File     : '/dev/dsp1' (ossdsp)
> Channels       : 2
> Sample Rate    : 48000
> Precision      : 16-bit
> Sample Encoding: 16-bit Signed Integer PCM
> Endian Type    : little
> Reverse Nibbles: no
> Reverse Bits   : no
> Level adjust   : 1 (linear gain)
>
>
> Output File    : '/dev/dsp' (ossdsp)
> Channels       : 2
> Sample Rate    : 48000
> Precision      : 16-bit
> Sample Encoding: 16-bit Signed Integer PCM
> Endian Type    : little
> Reverse Nibbles: no
> Reverse Bits   : no
>
> sox sox: effects chain: input      48000Hz 2 channels 16 bits (multi)
> sox sox: effects chain: output     48000Hz 2 channels 16 bits (multi)
> In:0.00% 00:00:00.00 [00:00:00.00] Out:0     [      |      ]
> Clip:0    sox sox: /dev/dsp1: lsx_readbuf: Input/output error
> In:0.00% 00:00:00.00 [00:00:00.00] Out:0     [      |      ]
> Clip:0
> Done.
>
> -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
> Follow my dmesg:
>
> [   59.904056] usb 1-1: new high speed USB device using ehci_hcd and address
> 5
> [   60.058312] usb 1-1: configuration #1 chosen from 1 choice
> [   60.180943] em28xx: New device USB 2861 Device @ 480 Mbps (eb1a:e305,
> interface 0, class 0)
> [   60.181035] em28xx #0: chip ID is em2860
> [   60.450213] em28xx #0: i2c eeprom 00: 1a eb 67 95 1a eb 05 e3 d0 00 5c 00
> 6a 22 00 00
> [   60.450223] em28xx #0: i2c eeprom 10: 00 00 04 57 4e 03 00 00 00 00 00 00
> 00 00 00 00
> [   60.450231] em28xx #0: i2c eeprom 20: 06 00 01 00 f0 10 01 00 00 00 00 00
> 5b 00 00 00
> [   60.450239] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 01 01 00 00
> 00 00 00 00
> [   60.450246] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00
> [   60.450253] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00
> [   60.450260] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 22 03
> 55 00 53 00
> [   60.450268] em28xx #0: i2c eeprom 70: 42 00 20 00 32 00 38 00 36 00 31 00
> 20 00 44 00
> [   60.450275] em28xx #0: i2c eeprom 80: 65 00 76 00 69 00 63 00 65 00 00 00
> 00 00 00 00
> [   60.450282] em28xx #0: i2c eeprom 90: 00 00 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00
> [   60.450289] em28xx #0: i2c eeprom a0: 00 00 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00
> [   60.450297] em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00
> [   60.450304] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00
> [   60.450311] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00
> [   60.450318] em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00
> [   60.450325] em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00
> [   60.450334] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0x28a51142
> [   60.450336] em28xx #0: EEPROM info:
> [   60.450338] em28xx #0:    AC97 audio (5 sample rates)
> [   60.450340] em28xx #0:    500mA max power
> [   60.450342] em28xx #0:    Table at 0x04, strings=0x226a, 0x0000, 0x0000
> [   60.450345] em28xx #0: Identified as KWorld DVB-T 305U (card=47)
> [   60.450347] em28xx #0:
> [   60.450348]
> [   60.450351] em28xx #0: The support for this board weren't valid yet.
> [   60.450353] em28xx #0: Please send a report of having this working
> [   60.450355] em28xx #0: not to V4L mailing list (and/or to other
> addresses)
> [   60.450356]
> [   60.458495] tvp5150 1-005c: chip found @ 0xb8 (em28xx #0)
> [   60.468901] tuner 1-0061: chip found @ 0xc2 (em28xx #0)
> [   60.516398] xc2028 1-0061: creating new instance
> [   60.516403] xc2028 1-0061: type set to XCeive xc2028/xc3028 tuner
> [   60.516413] usb 1-1: firmware: requesting xc3028-v27.fw
> [   60.562982] xc2028 1-0061: Loading 80 firmware images from xc3028-v27.fw,
> type: xc2028 firmware, ver 2.7
> [   60.644046] xc2028 1-0061: Loading firmware for type=BASE (1), id
> 0000000000000000.
> [   77.096041] xc2028 1-0061: Loading firmware for type=(0), id
> 000000000000b700.
> [   77.432037] SCODE (20000000), id 000000000000b700:
> [   77.432043] xc2028 1-0061: Loading SCODE for type=MONO SCODE HAS_IF_4320
> (60008000), id 0000000000008000.
> [   77.684132] em28xx #0: Config register raw data: 0xd0
> [   77.708262] em28xx #0: AC97 vendor ID = 0xffffffff
> [   77.720275] em28xx #0: AC97 features = 0x6a90
> [   77.720278] em28xx #0: Empia 202 AC97 audio processor detected
> [   78.244483] tvp5150 1-005c: tvp5150am1 detected.
> [   80.464057] em28xx #0: v4l2 driver version 0.1.2
> [   81.212052] Clocksource tsc unstable (delta = -259806109 ns)
> [   81.456278] em28xx #0: V4L2 video device registered as /dev/video1
> [   81.456284] em28xx #0: V4L2 VBI device registered as /dev/vbi0
> [   81.473378] em28xx video device (eb1a:e305): interface 1, class 255
> found.
> [   81.473388] em28xx This is an anciliary interface not used by the driver
> [   81.473455] usbcore: registered new interface driver em28xx
> [   81.473464] em28xx driver loaded
> [   81.561813] em28xx-audio.c: probing for em28x1 non standard usbaudio
> [   81.561821] em28xx-audio.c: Copyright (C) 2006 Markus Rechberger
> [   81.562433] Em28xx: Initialized (Em28xx Audio Extension) extension
> [   81.884540] tvp5150 1-005c: tvp5150am1 detected.
> [  116.460577] tvp5150 1-005c: tvp5150am1 detected.
> [  119.536060] xc2028 1-0061: Loading firmware for type=BASE (1), id
> 0000000000000000.
> [  135.964059] xc2028 1-0061: Loading firmware for type=(0), id
> 000000000000b700.
> [  136.300049] SCODE (20000000), id 000000000000b700:
> [  136.300065] xc2028 1-0061: Loading SCODE for type=MONO SCODE HAS_IF_4320
> (60008000), id 0000000000008000.
> [  146.808549] tvp5150 1-005c: tvp5150am1 detected.
> [  149.872067] xc2028 1-0061: Loading firmware for type=BASE (1), id
> 0000000000000000.
> [  166.300060] xc2028 1-0061: Loading firmware for type=(0), id
> 000000000000b700.
> [  166.636040] SCODE (20000000), id 000000000000b700:
> [  166.636056] xc2028 1-0061: Loading SCODE for type=MONO SCODE HAS_IF_4320
> (60008000), id 0000000000008000.
> [  197.324544] tvp5150 1-005c: tvp5150am1 detected.
> [  200.388079] xc2028 1-0061: Loading firmware for type=BASE (1), id
> 0000000000000000.
> [  216.816069] xc2028 1-0061: Loading firmware for type=(0), id
> 000000000000b700.
> [  217.152046] SCODE (20000000), id 000000000000b700:
> [  217.152059] xc2028 1-0061: Loading SCODE for type=MONO SCODE HAS_IF_4320
> (60008000), id 0000000000008000.
> [  269.632469] tvp5150 1-005c: tvp5150am1 detected.
> [  272.696064] xc2028 1-0061: Loading firmware for type=BASE (1), id
> 0000000000000000.
> [  289.128062] xc2028 1-0061: Loading firmware for type=(0), id
> 000000000000b700.
> [  289.468044] SCODE (20000000), id 000000000000b700:
> [  289.468060] xc2028 1-0061: Loading SCODE for type=MONO SCODE HAS_IF_4320
> (60008000), id 0000000000008000.
> [  539.336535] tvp5150 1-005c: tvp5150am1 detected.
> [  542.400100] xc2028 1-0061: Loading firmware for type=BASE (1), id
> 0000000000000000.
> [  558.828072] xc2028 1-0061: Loading firmware for type=(0), id
> 000000000000b700.
> [  559.164052] SCODE (20000000), id 000000000000b700:
> [  559.164068] xc2028 1-0061: Loading SCODE for type=MONO SCODE HAS_IF_4320
> (60008000), id 0000000000008000.
>
> -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
>
> Anyone have any idea what might be happening?
>
> Thanks.
>
> Denis Goes

Can you please provide the output of "lsusb -v"?

Thanks,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
