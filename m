Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:64699 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084Ab0ARPB4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jan 2010 10:01:56 -0500
Received: by fxm25 with SMTP id 25so535403fxm.21
        for <linux-media@vger.kernel.org>; Mon, 18 Jan 2010 07:01:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <ad6681df0912220841n2f77f2c3v7aad0604575b5564@mail.gmail.com>
References: <ad6681df0912220711p2666f0f5m84317a7bf0ffc137@mail.gmail.com>
	<829197380912220750j116894baw8343010b123f929@mail.gmail.com>
	<ad6681df0912220841n2f77f2c3v7aad0604575b5564@mail.gmail.com>
From: Valerio Bontempi <valerio.bontempi@gmail.com>
Date: Mon, 18 Jan 2010 16:01:34 +0100
Message-ID: <ad6681df1001180701s26584cdfua9e413d9bb843a35@mail.gmail.com>
Subject: Re: em28xx driver - xc3028 tuner - readreg error
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2009/12/22 Valerio Bontempi <valerio.bontempi@gmail.com>:
> 2009/12/22 Devin Heitmueller <dheitmueller@kernellabs.com>:
>> On Tue, Dec 22, 2009 at 10:11 AM, Valerio Bontempi
>> <valerio.bontempi@gmail.com> wrote:
>>> Before the update, v4l-dvb driver worked fine, and now it doesn't work
>>> even if I remove the updated packages.
>>> Checking for kernel modules conflict, I found only the modules
>>> installed by v4l-dvb sources.
>>> #find /lib/modules/`uname -r` -name 'em28xx*' | xargs -i ls -l {}
>>> totale 236
>>> -rw-r--r-- 1 root root 21464 22 dic 16:03
>>> /lib/modules/2.6.31.5-0.1-desktop/kernel/drivers/media/video/em28xx/em28xx-alsa.ko
>>> -rw-r--r-- 1 root root 26176 22 dic 16:03
>>> /lib/modules/2.6.31.5-0.1-desktop/kernel/drivers/media/video/em28xx/em28xx-dvb.ko
>>> -rw-r--r-- 1 root root 184936 22 dic 16:03
>>> /lib/modules/2.6.31.5-0.1-desktop/kernel/drivers/media/video/em28xx/em28xx.ko
>>
>> My guess is that these files were provided by your distro through a
>> kernel update (and in 2.6.31 this board is known to have problems
>> which have been fixed in the latest v4l-dvb tree).
>>
>> I would suggest the following going into your v4l-dvb tree and doing
>> the following:
>>
>> make distclean && make && make install && reboot
>>
>> And see if the problem clears up.
>>
>> Devin
>>
>> --
>> Devin J. Heitmueller - Kernel Labs
>> http://www.kernellabs.com
>>
>
> This is just I have done after removing the update packages (all
> related to v4l libs and tools, none related to opensuse kernel), but
> with no luck
>
> However I have just tried what you suggested, but the problem hasn't
> been cleared up
>
> [    7.276755] em28xx: New device TerraTec Electronic GmbH Cinergy T
> USB XS @ 480 Mbps (0ccd:0043, interface 0, class 0)
> [    7.276993] em28xx #0: chip ID is em2870
> [    7.310070] vc032x: Sensor ID 7673 (16)
> [    7.310075] vc032x: Find Sensor OV7670
> [    7.310187] gspca: /dev/video0 created
> [    7.310224] usbcore: registered new interface driver vc032x
> [    7.310228] vc032x: registered
> [    7.394941] em28xx #0: i2c eeprom 00: 1a eb 67 95 cd 0c 43 00 c0 12
> 5c 00 9e 24 6a 34
> [    7.394956] em28xx #0: i2c eeprom 10: 00 00 06 57 02 0c 00 00 00 00
> 00 00 00 00 00 00
> [    7.394967] em28xx #0: i2c eeprom 20: 44 00 00 00 f0 10 01 00 00 00
> 00 00 5b 00 00 00
> [    7.394977] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 01 01
> 00 00 00 00 00 00
> [    7.394988] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00 00 00
> [    7.394998] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00 00 00
> [    7.395008] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00
> 34 03 54 00 65 00
> [    7.395021] em28xx #0: i2c eeprom 70: 72 00 72 00 61 00 54 00 65 00
> 63 00 20 00 45 00
> [    7.395032] em28xx #0: i2c eeprom 80: 6c 00 65 00 63 00 74 00 72 00
> 6f 00 6e 00 69 00
> [    7.395042] em28xx #0: i2c eeprom 90: 63 00 20 00 47 00 6d 00 62 00
> 48 00 00 00 24 03
> [    7.395052] em28xx #0: i2c eeprom a0: 43 00 69 00 6e 00 65 00 72 00
> 67 00 79 00 20 00
> [    7.395063] em28xx #0: i2c eeprom b0: 54 00 20 00 55 00 53 00 42 00
> 20 00 58 00 53 00
> [    7.395074] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00 00 00
> [    7.395084] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00 00 00
> [    7.395094] em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00 00 00
> [    7.395104] em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00 00 00
> [    7.395116] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0xbfdf1b96
> [    7.395119] em28xx #0: EEPROM info:
> [    7.395120] em28xx #0:       No audio on board.
> [    7.395122] em28xx #0:       500mA max power
> [    7.395125] em28xx #0:       Table at 0x06, strings=0x249e, 0x346a, 0x0000
> [    7.395813] em28xx #0: Identified as Terratec Cinergy T XS (card=43)
> [    7.395816] em28xx #0:
> [    7.395816]
> [    7.395830] em28xx #0: The support for this board weren't valid yet.
> [    7.395838] em28xx #0: Please send a report of having this working
> [    7.395845] em28xx #0: not to V4L mailing list (and/or to other addresses)
> [    7.395846]
> [    7.412090] forcedeth 0000:00:0a.0: ifname eth0, PHY OUI 0x1374 @
> 0, addr 00:1a:92:34:d4:d7
> [    7.412096] forcedeth 0000:00:0a.0: highdma csum gbit lnktim desc-v3
> [    7.412275] k8temp 0000:00:18.3: Temperature readouts might be
> wrong - check erratum #141
> [    7.414043] EDAC amd64: This node reports that Memory ECC is
> currently disabled.
> [    7.414048] EDAC amd64: bit 0x400000 in register F3x44 of the
> MISC_CONTROL device (0000:00:18.3) should be enabled
> [    7.414051] EDAC amd64: WARNING: ECC is NOT currently enabled by
> the BIOS. Module will NOT be loaded.
> [    7.414053]     Either Enable ECC in the BIOS, or use the
> 'ecc_enable_override' parameter.
> [    7.414055]     Might be a BIOS bug, if BIOS says ECC is enabled
> [    7.414056]     Use of the override can cause unknown side effects.
> [    7.414073] amd64_edac: probe of 0000:00:18.2 failed with error -22
> [    7.501404] usbcore: registered new interface driver snd-usb-audio
> [    7.843367] tuner 2-0061: chip found @ 0xc2 (em28xx #0)
> [    8.123514] xc2028 2-0061: creating new instance
> [    8.123519] xc2028 2-0061: type set to XCeive xc2028/xc3028 tuner
> [    8.123530] usb 1-4: firmware: requesting xc3028-v27.fw
> [    8.134197] xc2028 2-0061: Loading 80 firmware images from
> xc3028-v27.fw, type: xc2028 firmware, ver 2.7
> [    8.167270] xc2028 2-0061: Loading firmware for type=BASE (1), id
> 0000000000000000.
> [    8.310475] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[0011d80000f828c2]
> [    8.440483] ieee1394: Host added: ID:BUS[1-00:1023]  GUID[00023c01510ec213]
> [    9.574269] xc2028 2-0061: Loading firmware for type=(0), id
> 000000000000b700.
> [    9.600262] SCODE (20000000), id 000000000000b700:
> [    9.600267] xc2028 2-0061: Loading SCODE for type=MONO SCODE
> HAS_IF_4320 (60008000), id 0000000000008000.
> [    9.723270] em28xx #0: v4l2 driver version 0.1.2
> [    9.728271] em28xx #0: V4L2 video device registered as /dev/video1
> [    9.729313] usbcore: registered new interface driver em28xx
> [    9.729317] em28xx driver loaded
> [    9.811316] zl10353_read_register: readreg error (reg=127, ret==-19)
> [    9.837317] mt352_read_register: readreg error (reg=127, ret==-19)
> [    9.837412] em28xx #0: /2: dvb frontend not attached. Can't attach xc3028
> [    9.837494] Em28xx: Initialized (Em28xx dvb Extension) extension
>
> and
>
> #find /lib/modules/`uname -r` -name 'em28xx*' | xargs -i ls -l {}
> -rw-r--r-- 1 root root 21464 22 dic 17:07
> /lib/modules/2.6.31.5-0.1-desktop/kernel/drivers/media/video/em28xx/em28xx-alsa.ko
> -rw-r--r-- 1 root root 26176 22 dic 17:07
> /lib/modules/2.6.31.5-0.1-desktop/kernel/drivers/media/video/em28xx/em28xx-dvb.ko
> -rw-r--r-- 1 root root 184936 22 dic 17:07
> /lib/modules/2.6.31.5-0.1-desktop/kernel/drivers/media/video/em28xx/em28xx.ko
>
> shows that I have install only the just compiled modules
>
> I also tried to update my downloaded v4l-dvb tree to its last version,
> but I am not able to install it, I receive a lot of undefined symbol
> error after modprobe em28xx.
>
> Valerio
>

Hi all,

I am still having problem using v4l-dvb drivers with Terratec Cinergy T USB XS.
As reported in first mail, I am using the last version of v4l-dvb
drivers with few lines adjustment in order to make this driver to
enable dvb for my dvb only device (this because official v4l-dvb
driver actually doesn't support my device at all)
I have cleaned my distro (openSuse 11.2 x86-64) about all the v4l
modules provided by distro's repositories, and I compiled modified
v4l-dvb source.
So acutally I am using a cleaned version of v4l-dvb.

But the
[ 1483.314420] zl10353_read_register: readreg error (reg=127, ret==-19)
[ 1483.315166] mt352_read_register: readreg error (reg=127, ret==-19)
error isn't solved yet.
Could it be related to the firmware I am using?


Regars,

Valerio Bontempi
