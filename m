Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from ik-out-1112.google.com ([66.249.90.177])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <devin.heitmueller@gmail.com>) id 1LA4gn-0002BH-JA
	for linux-dvb@linuxtv.org; Tue, 09 Dec 2008 16:39:59 +0100
Received: by ik-out-1112.google.com with SMTP id c28so15188ika.1
	for <linux-dvb@linuxtv.org>; Tue, 09 Dec 2008 07:39:54 -0800 (PST)
Message-ID: <412bdbff0812090739n831d446tf19faab40c85763@mail.gmail.com>
Date: Tue, 9 Dec 2008 10:39:54 -0500
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: "Oliver Maurhart" <oliver.maurhart@gmx.net>
In-Reply-To: <200812091251.57007.oliver.maurhart@gmx.net>
MIME-Version: 1.0
Content-Disposition: inline
References: <200812091251.57007.oliver.maurhart@gmx.net>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Help: /dev/dvb missing with Terratec Cinergy XS
	Hybrid
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

On Tue, Dec 9, 2008 at 6:51 AM, Oliver Maurhart <oliver.maurhart@gmx.net> wrote:
> Hi *,
>
> After months of googling I'm out of  knowledge. I'm the (lucky?) owner of a
> Terratec Hybrid XS USB Card:
>
> # lsusb | grep TerraTec
> Bus 001 Device 007: ID 0ccd:005e TerraTec Electronic GmbH
>
> I think, I followed each and every hint and tip, but I failed to get a
> /dev/dvb device created. :(
>
> I'm really lost! Please help!
>
>
> dmesg after pluging in the device:
>
> usb 1-4: new high speed USB device using ehci_hcd and address 7
> usb 1-4: configuration #1 chosen from 1 choice
> em28xx v4l2 driver version 0.1.0 loaded
> em28xx new video device (0ccd:005e): interface 0, class 255
> em28xx Doesn't have usb audio class
> em28xx #0: Alternate settings: 8
> em28xx #0: Alternate setting 0, max size= 0
> em28xx #0: Alternate setting 1, max size= 0
> em28xx #0: Alternate setting 2, max size= 1448
> em28xx #0: Alternate setting 3, max size= 2048
> em28xx #0: Alternate setting 4, max size= 2304
> em28xx #0: Alternate setting 5, max size= 2580
> em28xx #0: Alternate setting 6, max size= 2892
> em28xx #0: Alternate setting 7, max size= 3072
> em28xx #0: chip ID is em2882/em2883
> em28xx #0: i2c eeprom 00: 1a eb 67 95 cd 0c 5e 00 d0 12 5c 03 9e 40 de 1c
> em28xx #0: i2c eeprom 10: 6a 34 27 57 46 07 01 00 00 00 00 00 00 00 00 00
> em28xx #0: i2c eeprom 20: 46 00 01 00 f0 10 31 00 b8 00 14 00 5b 1e 00 00
> em28xx #0: i2c eeprom 30: 00 00 20 40 20 6e 02 20 10 01 00 00 00 00 00 00
> em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 34 03 54 00 65 00
> em28xx #0: i2c eeprom 70: 72 00 72 00 61 00 54 00 65 00 63 00 20 00 45 00
> em28xx #0: i2c eeprom 80: 6c 00 65 00 63 00 74 00 72 00 6f 00 6e 00 69 00
> em28xx #0: i2c eeprom 90: 63 00 20 00 47 00 6d 00 62 00 48 00 00 00 40 03
> em28xx #0: i2c eeprom a0: 43 00 69 00 6e 00 65 00 72 00 67 00 79 00 20 00
> em28xx #0: i2c eeprom b0: 48 00 79 00 62 00 72 00 69 00 64 00 20 00 54 00
> em28xx #0: i2c eeprom c0: 20 00 55 00 53 00 42 00 20 00 58 00 53 00 20 00
> em28xx #0: i2c eeprom d0: 28 00 32 00 38 00 38 00 32 00 29 00 00 00 1c 03
> em28xx #0: i2c eeprom e0: 30 00 37 00 31 00 30 00 30 00 32 00 30 00 30 00
> em28xx #0: i2c eeprom f0: 36 00 34 00 32 00 38 00 00 00 00 00 00 00 00 00
> EEPROM ID= 0x9567eb1a, hash = 0x6013b1be
> Vendor/Product ID= 0ccd:005e
> AC97 audio (5 sample rates)
> 500mA max power
> Table at 0x27, strings=0x409e, 0x1cde, 0x346a
> em28xx #0:
>
> em28xx #0: The support for this board weren't valid yet.
> em28xx #0: Please send a report of having this working
> em28xx #0: not to V4L mailing list (and/or to other addresses)
>
> tuner' 4-0061: chip found @ 0xc2 (em28xx #0)
> xc2028 4-0061: creating new instance
> xc2028 4-0061: type set to XCeive xc2028/xc3028 tuner
> firmware: requesting xc3028-v27.fw
> xc2028 4-0061: Loading 80 firmware images from xc3028-v27.fw, type: xc2028
> firmware, ver 2.7
> xc2028 4-0061: Loading firmware for type=BASE (1), id 0000000000000000.
> xc2028 4-0061: Loading firmware for type=(0), id 000000000000b700.
> SCODE (20000000), id 000000000000b700:
> xc2028 4-0061: Loading SCODE for type=MONO SCODE HAS_IF_4320 (60008000), id
> 0000000000008000.
> xc2028 4-0061: i2c input error: rc = -19 (should be 2)
> xc2028 4-0061: Unable to read tuner registers.
> xc2028 4-0061: Loading firmware for type=BASE (1), id 0000000000000000.
> xc2028 4-0061: Loading firmware for type=(0), id 000000000000b700.
> SCODE (20000000), id 000000000000b700:
> xc2028 4-0061: Loading SCODE for type=MONO SCODE HAS_IF_4320 (60008000), id
> 0000000000008000.
> xc2028 4-0061: i2c input error: rc = -19 (should be 2)
> xc2028 4-0061: Unable to read tuner registers.
> tvp5150 debug 4-005c: i2c i/o error: rc == -19 (should be 1)
> tvp5150 debug 4-005c: i2c i/o error: rc == -19 (should be 1)
> tvp5150 debug 4-005c: i2c i/o error: rc == -19 (should be 1)
> tvp5150 debug 4-005c: i2c i/o error: rc == -19 (should be 1)
> tvp5150 4-005c: *** unknown tvp8081 chip detected.
> tvp5150 4-005c: *** Rom ver is 130.131
> tvp5150 debug 4-005c: i2c i/o error: rc == -19 (should be 1)
> tvp5150 debug 4-005c: i2c i/o error: rc == -19 (should be 1)
> tvp5150 debug 4-005c: i2c i/o error: rc == -19 (should be 1)
> em28xx #0: V4L2 device registered as /dev/video1 and /dev/vbi0
> em28xx #0: Found Terratec Hybrid XS (em2882)
> usbcore: registered new interface driver em28xx
> tvp5150 4-005c: tvp5150am1 detected.
>
>
> Kernel-System:
>
> # uname -a
> Linux semirhage 2.6.27-gentoo-r4 #3 SMP PREEMPT Sun Nov 30 15:16:17 CET 2008
> i686 Intel(R) Pentium(R) 4 CPU 3.00GHz GenuineIntel GNU/Linux
>
>
> Loaded Modules:
>
> # lsmod | grep dvb
> dvb_usb                23180  0
> dvb_core               76392  1 dvb_usb
> i2c_core               28948  18
> tuner,tea5767,tda8290,tda18271,tda827x,tuner_xc2028,xc5000,tda9887,tuner_simple,mt20xx,tea5761,v4l2_common,tvp5150,em28xx,tveeprom,dvb_usb,nvidia,i2c_i801
> usbcore               124120  14
> em28xx,dvb_usb,uvcvideo,snd_usb_audio,snd_usb_lib,usblp,ati_remote,sl811_hcd,usbhid,ohci_hcd,uhci_hcd,usb_storage,ehci_hcd
>
> # lsmod | grep em28
> em28xx                 61608  0
> videobuf_vmalloc       14212  1 em28xx
> ir_common              47748  1 em28xx
> tveeprom               19076  1 em28xx
> compat_ioctl32          9472  2 em28xx,uvcvideo
> videodev               38912  3 tuner,em28xx,uvcvideo
> i2c_core               28948  18
> tuner,tea5767,tda8290,tda18271,tda827x,tuner_xc2028,xc5000,tda9887,tuner_simple,mt20xx,tea5761,v4l2_common,tvp5150,em28xx,tveeprom,dvb_usb,nvidia,i2c_i801
> usbcore               124120  14
> em28xx,dvb_usb,uvcvideo,snd_usb_audio,snd_usb_lib,usblp,ati_remote,sl811_hcd,usbhid,ohci_hcd,uhci_hcd,usb_storage,ehci_hcd
> videobuf_core          24708  2 em28xx,videobuf_vmalloc
>
>
> What is wrong here?
>
> Oliver

I figured ones of these days a user of this device would come along.  :-)

This is an em28xx based device we don't have a profile for yet -
although all the core components are supported -
em28xx/zarlink/xc3028.

If you want to get this device supported under Linux, I'll put in in
my queue of em28xx devices to look at.  I think we are just missing
the GPIOs and the dvb profile.

Devin

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
