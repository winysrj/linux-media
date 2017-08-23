Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:42128 "EHLO smtp.gentoo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753318AbdHWHVi (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Aug 2017 03:21:38 -0400
Subject: Re: analog support for WinTV-HVR-900H/930C-HD
To: Sven Verdoolaege <sven.verdoolaege@gmail.com>,
        linux-media@vger.kernel.org, Antti Palosaari <crope@iki.fi>,
        "olli.salonen" <olli.salonen@iki.fi>
References: <20170819194636.GM6785MdfPADPa@purples.kotnet.org>
From: Matthias Schwarzott <zzam@gentoo.org>
Message-ID: <bcc367e0-00f0-d178-274f-a93d6cba800b@gentoo.org>
Date: Wed, 23 Aug 2017 09:21:37 +0200
MIME-Version: 1.0
In-Reply-To: <20170819194636.GM6785MdfPADPa@purples.kotnet.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 19.08.2017 um 21:46 schrieb Sven Verdoolaege:
> Hi,
> 

Hi!

> I hope this is the right place for asking about support
> for analog TV on Hauppauge cards.
> 
> I recently bought what I thought is a Hauppauge WinTV-HVR-900H
> (that's what it says on the stick itself) because according
> to https://www.linuxtv.org/wiki/index.php/Hauppauge_WinTV-HVR-900H
> analog TV should work on those sticks.
> However, the stick is identified as a
> "Hauppauge WinTV 930C-HD (1114xx) / HVR-901H (1114xx) / PCTV QuatroStick 522e"
> instead and it seems that there is no support for analog TV
> for this device (yet?).
> 
> In particular, when I try to run tvtime, I get
> videoinput: Can't get tuner info: Inappropriate ioctl for device
> videoinput: Can't set tuner audio mode: Inappropriate ioctl for device
> videoinput: Can't get tuner info: Inappropriate ioctl for device
> videoinput: Can't set tuner audio mode: Inappropriate ioctl for device
> videoinput: Tuner present, but our request to change to
> videoinput: frequency 62250 failed with this error: Inappropriate ioctl for device.
> videoinput: Please file a bug report at http://tvtime.net/
> videoinput: Tuner refuses to tell us the current frequency: Inappropriate ioctl for device
> videoinput: Please file a bug report at http://tvtime.net/
> 
> Is anyone working on support for such devices?
> Or does it already work and am I doing something wrong?
> 
> I'm pasting the relevant dmesg output below.
> Kernel version is 4.4.0-83-generic #106-Ubuntu.
> 
> Thanks,
> 
> skimo
> 
> [   44.522766] usb 3-4: new high-speed USB device number 2 using xhci_hcd
> [   44.653945] usb 3-4: New USB device found, idVendor=2013, idProduct=025e
> [   44.653947] usb 3-4: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> [   44.653949] usb 3-4: Product: Hauppauge Device
> [   44.653950] usb 3-4: Manufacturer: Hauppauge
> [   44.653951] usb 3-4: SerialNumber: 4035578631
> [   44.698824] Registered IR keymap rc-pinnacle-pctv-hd
> [   44.698928] input: Conexant Hybrid TV (cx231xx) MCE IR no TX (2013:025e) as /devices/pci0000:00/0000:00:14.0/usb3/3-4/3-4:1.0/rc/rc0/input23
> [   44.698985] rc0: Conexant Hybrid TV (cx231xx) MCE IR no TX (2013:025e) as /devices/pci0000:00/0000:00:14.0/usb3/3-4/3-4:1.0/rc/rc0
> [   44.703474] IR NEC protocol handler initialized
> [   44.703661] IR Sony protocol handler initialized
> [   44.703955] IR JVC protocol handler initialized
> [   44.703958] IR RC6 protocol handler initialized
> [   44.704086] IR SANYO protocol handler initialized
> [   44.704636] IR RC5(x/sz) protocol handler initialized
> [   44.704930] IR Sharp protocol handler initialized
> [   44.705056] input: MCE IR Keyboard/Mouse (mceusb) as /devices/virtual/input/input24
> [   44.705140] IR MCE Keyboard/mouse protocol handler initialized
> [   44.705330] IR XMP protocol handler initialized
> [   44.705705] lirc_dev: IR Remote Control driver registered, major 240 
> [   44.707056] rc rc0: lirc_dev: driver ir-lirc-codec (mceusb) registered at minor = 0
> [   44.707058] IR LIRC bridge handler initialized
> [   44.907035] mceusb 3-4:1.0: Registered Hauppauge Hauppauge Device with mce emulator interface version 1
> [   44.907038] mceusb 3-4:1.0: 2 tx ports (0x3 cabled) and 2 rx sensors (0x1 active)
> [   44.907130] usbcore: registered new interface driver mceusb
> [   44.918365] cx231xx 3-4:1.1: New device Hauppauge Hauppauge Device @ 480 Mbps (2013:025e) with 7 interfaces
> [   44.918441] cx231xx 3-4:1.1: Identified as Hauppauge WinTV 930C-HD (1114xx) / HVR-901H (1114xx) / PCTV QuatroStick 522e (card=20)
> [   44.918733] i2c i2c-12: Added multiplexed i2c bus 14
> [   44.918775] i2c i2c-12: Added multiplexed i2c bus 15
> [   45.062403] cx25840 11-0044: cx23102 A/V decoder found @ 0x88 (cx231xx #0-0)
> [   47.044238] cx25840 11-0044: loaded v4l-cx231xx-avcore-01.fw firmware (16382 bytes)
> [   47.101579] tveeprom 14-0050: Hauppauge model 111429, rev E2I6, serial# 4035578631
> [   47.101582] tveeprom 14-0050: MAC address is 00:0d:fe:8a:0b:07
> [   47.101583] tveeprom 14-0050: tuner model is SiLabs Si2157 (idx 186, type 4)
> [   47.101584] tveeprom 14-0050: TV standards PAL(B/G) PAL(I) SECAM(L/L') PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xf4)
> [   47.101585] tveeprom 14-0050: audio processor is CX23102 (idx 47)
> [   47.101586] tveeprom 14-0050: decoder processor is CX23102 (idx 46)
> [   47.101587] tveeprom 14-0050: has radio, has IR receiver, has no IR transmitter
> [   47.102572] cx231xx 3-4:1.1: v4l2 driver version 0.0.3
> [   47.157788] cx231xx 3-4:1.1: Unknown tuner type configuring SIF
> [   47.182657] cx231xx 3-4:1.1: Registered video device video1 [v4l2]
> [   47.182721] cx231xx 3-4:1.1: Registered VBI device vbi0
> [   47.182725] cx231xx 3-4:1.1: video EndPoint Addr 0x84, Alternate settings: 5
> [   47.182728] cx231xx 3-4:1.1: VBI EndPoint Addr 0x85, Alternate settings: 2
> [   47.182730] cx231xx 3-4:1.1: sliced CC EndPoint Addr 0x86, Alternate settings: 2
> [   47.182732] cx231xx 3-4:1.1: TS EndPoint Addr 0x81, Alternate settings: 6
> [   47.182784] usbcore: registered new interface driver cx231xx
> [   47.188184] cx231xx 3-4:1.1: audio EndPoint Addr 0x83, Alternate settings: 3
> [   47.188187] cx231xx 3-4:1.1: Cx231xx Audio Extension initialized
> [   47.251193] i2c i2c-15: si2165: Detected Silicon Labs Si2165-D (type 7, rev 3)
> [   47.251197] i2c i2c-15: si2165: DVB-C is not yet supported.
> [   47.254581] si2157 15-0060: Silicon Labs Si2147/2148/2157/2158 successfully attached
> [   47.254588] DVB: registering new adapter (cx231xx #0)
> [   47.254591] cx231xx 3-4:1.1: DVB: registering adapter 0 frontend 0 (Silicon Labs Si2165 DVB-T)...
> [   47.254850] cx231xx 3-4:1.1: Successfully loaded cx231xx-dvb
> [   47.254855] cx231xx 3-4:1.1: Cx231xx dvb Extension initialized
> [  100.672828] cx231xx 3-4:1.1: Unknown tuner type configuring SIF
> [  100.748631] cx231xx 3-4:1.1: Unknown tuner type configuring SIF
> 

Your stick is labeled as WinTV-HVR-900H but you got a different hardware
than described by the wiki page mentioned above.

According to your dmesg output your card has USB IDs: 2013:025e and that
is the same ID as used for PCTV 522e DVB-T/C (Si2158+Si2165)

The output shows that the chips si2158 and si2165 are successfully
identified.

The driver for the tuner (si2157) does currently not support analog
reception. I do not know what is necessary to add this support.

Maybe Antti or Olli can answer that question.

Regards
Matthias
