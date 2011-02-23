Return-path: <mchehab@pedra>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54203 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755262Ab1BWTwq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Feb 2011 14:52:46 -0500
Received: by fxm17 with SMTP id 17so4402070fxm.19
        for <linux-media@vger.kernel.org>; Wed, 23 Feb 2011 11:52:45 -0800 (PST)
From: Vivek Periaraj <vivek.periaraj@gmail.com>
To: linux-media@vger.kernel.org
Subject: Hauppauge WinTV USB 2
Date: Thu, 24 Feb 2011 01:16:18 +0530
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201102240116.18770.Vivek.Periaraj@gmail.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Folks,

I bought a new Hauppauge WinTV USB 2 tuner card and was hoping to use it in 
linux. I specifically looked up to find whether this card is supported or not, 
and I found that it's indeed supported by em28xx drivers.

So i was hoping that this card would be autodetected and register all the dev 
nodes. But it wasn't. Am using Kernel 2.6.32-5 on debian lenny.

Following are the dmesg output when I insert the card:

[  550.320563] usb 5-7: new high speed USB device using ehci_hcd and address 8
[  550.661901] usb 4-1: new full speed USB device using uhci_hcd and address 2
[  550.810999] usb 4-1: not running at top speed; connect to a high speed hub
[  550.845015] usb 4-1: New USB device found, idVendor=2040, idProduct=6610
[  550.845023] usb 4-1: New USB device strings: Mfr=16, Product=32, 
SerialNumber=64
[  550.845046] usb 4-1: Product: WTV910 
[  550.845050] usb 4-1: SerialNumber: 12502365
[  550.845471] usb 4-1: configuration #1 chosen from 1 choice

Following is from lsusb output:

Bus 001 Device 005: ID 045e:0734 Microsoft Corp. Wireless Optical Desktop 700
Bus 001 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 005 Device 007: ID 413c:8126 Dell Computer Corp. Wireless 355 Bluetooth
Bus 005 Device 004: ID 0bc2:2120 Seagate RSS LLC 
Bus 005 Device 002: ID 413c:a005 Dell Computer Corp. Internal 2.0 Hub
Bus 005 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 002 Device 002: ID 046d:c05a Logitech, Inc. 
Bus 002 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 004 Device 002: ID 2040:6610 Hauppauge 
Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 003 Device 002: ID 041e:3040 Creative Technology, Ltd SoundBlaster Live! 
24-bit External SB0490
Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub

Following is from cat /proc/bus/usb/devices:

T:  Bus=04 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#=  2 Spd=12  MxCh= 0
D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=2040 ProdID=6610 Rev= 0.6f
S:  Product=WTV910 
S:  SerialNumber=12502365
C:* #Ifs= 1 Cfg#= 1 Atr=a0 MxPwr=500mA
I:* If#= 0 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=ff Driver=(none)
E:  Ad=81(I) Atr=01(Isoc) MxPS=   0 Ivl=1ms
E:  Ad=82(I) Atr=02(Bulk) MxPS=  64 Ivl=0ms
I:  If#= 0 Alt= 1 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=ff Driver=(none)
E:  Ad=81(I) Atr=01(Isoc) MxPS= 512 Ivl=1ms
E:  Ad=82(I) Atr=02(Bulk) MxPS=  64 Ivl=0ms
I:  If#= 0 Alt= 2 #EPs= 2 Cls=ff(vend.) Sub=00 Prot=ff Driver=(none)
E:  Ad=81(I) Atr=01(Isoc) MxPS= 512 Ivl=1ms
E:  Ad=82(I) Atr=02(Bulk) MxPS=  64 Ivl=0ms

Following is the output when I manually modprobe the driver:

[  844.336942] Linux video capture interface: v2.00
[  844.386271] usbcore: registered new interface driver em28xx
[  844.387234] em28xx driver loaded

Could you pls tell me if this card is supported? If so, what should I do?

One thing I noticed is the card is identified with the product as "WTV 910" 
instead of the expected "WinTV USB2"

Pls let me know if you need any other info and I can get it for you.

Thanks,
Vivek.
