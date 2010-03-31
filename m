Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail.tu-berlin.de ([130.149.7.33])
	by www.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <ohase@synergyom.com.au>) id 1Nwshv-0006th-Qx
	for linux-dvb@linuxtv.org; Wed, 31 Mar 2010 09:51:25 +0200
Received: from magellan.websiteactive.com ([202.191.61.201])
	by mail.tu-berlin.de (exim-4.69/mailfrontend-b) with esmtps
	[TLSv1:AES256-SHA:256] for <linux-dvb@linuxtv.org>
	id 1Nwshu-0006cW-8Z; Wed, 31 Mar 2010 09:51:23 +0200
Received: from 60-241-40-165.static.tpgi.com.au ([60.241.40.165]
	helo=linux-xf9w.localnet)
	by magellan.websiteactive.com with esmtp (Exim 4.69)
	(envelope-from <ohase@synergyom.com.au>) id 1Nwshm-0001Wd-V6
	for linux-dvb@linuxtv.org; Wed, 31 Mar 2010 18:51:15 +1100
From: Otto Hase <ohase@synergyom.com.au>
To: linux-dvb@linuxtv.org
Date: Wed, 31 Mar 2010 17:52:22 +1000
MIME-Version: 1.0
Message-Id: <201003311752.22801.>
Subject: [linux-dvb] missing /dev/dvb/ for DVB-t usb Mobidtv Trio (v-gear)
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
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

Hi

I got stuck.  Anyway DVB-t usb Mobidtv Trio (v-gear) is (appears to be) same 
as MSI Digivox mini II V3.0

I am running Suse 11.2 on Asus Laptop Intel(R) Core(TM)2 Duo CPU T7300 @ 
2.00GHz

I installed what was recommended. 

What is missing is

/dev/dvb

It is my understanding that means that the tuner has not been installed ?!

Please view dmesg

   112.242186] usb 2-3: new high speed USB device using ehci_hcd and address 3
[  112.362196] usb 2-3: New USB device found, idVendor=eb1a, idProduct=2883
[  112.362222] usb 2-3: New USB device strings: Mfr=0, Product=1, 
SerialNumber=2
[  112.362238] usb 2-3: Product: V-Gear MobiDTV Trio
[  112.362250] usb 2-3: SerialNumber: 200708
[  112.362518] usb 2-3: configuration #1 chosen from 1 choice
[  112.556151] em28xx: New device V-Gear MobiDTV Trio @ 480 Mbps (eb1a:2883, 
interface 0, class 0)
[  112.556271] em28xx #0: chip ID is em2882/em2883
[  112.635771] em28xx #0: i2c eeprom 00: 1a eb 67 95 1a eb 83 28 d0 12 65 03 
6a 2a 94 10
[  112.635824] em28xx #0: i2c eeprom 10: 00 00 24 57 4e 37 41 00 60 00 00 00 
02 00 00 00
[  112.635866] em28xx #0: i2c eeprom 20: 5e 00 01 00 f0 10 01 00 b8 00 00 00 
5b 1e 00 00
[  112.635909] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 10 01 00 00 
00 00 00 00
[  112.635951] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00 00 00 
d3 c4 00 00
[  112.635993] em28xx #0: i2c eeprom 50: 00 a2 b2 87 81 80 00 00 00 00 00 00 
00 00 00 00
[  112.636036] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00 2a 03 
56 00 2d 00
[  112.636077] em28xx #0: i2c eeprom 70: 47 00 65 00 61 00 72 00 20 00 4d 00 
6f 00 62 00
[  112.636119] em28xx #0: i2c eeprom 80: 69 00 44 00 54 00 56 00 20 00 54 00 
72 00 69 00
[  112.636160] em28xx #0: i2c eeprom 90: 6f 00 00 00 10 03 32 00 30 00 30 00 
37 00 30 00
[  112.636203] em28xx #0: i2c eeprom a0: 38 00 00 00 00 00 00 00 00 00 00 00 
00 00 00 00
[  112.636244] em28xx #0: i2c eeprom b0: 00 00 00 00 00 00 00 00 00 00 00 00 
00 00 00 00
[  112.637094] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00 00 00 
00 00 00 00
[  112.637139] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00 00 00 
00 00 00 00
[  112.637181] em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00 00 00 
00 00 00 00
[  112.637228] em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 00 00 00 00 
00 00 00 00
[  112.637285] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0x6d1ec21d
[  112.637301] em28xx #0: EEPROM info:
[  112.637312] em28xx #0:       AC97 audio (5 sample rates)
[  112.637325] em28xx #0:       500mA max power
[  112.637339] em28xx #0:       Table at 0x24, strings=0x2a6a, 0x1094, 0x0000
[  112.638516] em28xx #0: Identified as MSI VOX USB 2.0 (card=5)
[  112.685010] tuner 3-0061: chip found @ 0xc2 (em28xx #0)
[  112.725795] tuner-simple 3-0061: creating new instance
[  112.725817] tuner-simple 3-0061: type set to 37 (LG PAL (newer TAPC 
series))
[  112.727157] em28xx #0: Config register raw data: 0xd0
[  112.727907] em28xx #0: AC97 vendor ID = 0xffffffff
[  112.728754] em28xx #0: AC97 features = 0x6a90
[  112.728768] em28xx #0: Empia 202 AC97 audio processor detected
[  112.751382] em28xx #0: v4l2 driver version 0.1.2
[  112.780496] em28xx #0: V4L2 video device registered as video1
[  112.780516] em28xx #0: V4L2 VBI device registered as vbi0
[  112.780578] usbcore: registered new interface driver em28xx
[  112.780595] em28xx driver loaded
[  112.796832] em28xx-audio.c: probing for em28x1 non standard usbaudio
[  112.796843] em28xx-audio.c: Copyright (C) 2006 Markus Rechberger
[  112.797500] Em28xx: Initialized (Em28xx Audio Extension) extension


I wonder what I missed.  Can anyone help !

thanks Otto

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
