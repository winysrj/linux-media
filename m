Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f54.google.com ([74.125.83.54]:65223 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201Ab3LVJnb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 22 Dec 2013 04:43:31 -0500
Received: by mail-ee0-f54.google.com with SMTP id e51so1563228eek.27
        for <linux-media@vger.kernel.org>; Sun, 22 Dec 2013 01:43:29 -0800 (PST)
Received: from [192.168.1.202] (ip-37-201-160-51.unitymediagroup.de. [37.201.160.51])
        by mx.google.com with ESMTPSA id j46sm34841438eew.18.2013.12.22.01.43.28
        for <linux-media@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Sun, 22 Dec 2013 01:43:29 -0800 (PST)
Message-ID: <52B6B4A4.7090501@googlemail.com>
Date: Sun, 22 Dec 2013 10:45:08 +0100
From: =?ISO-8859-15?Q?Christian_L=F6pke?=
	<christian.loepke@googlemail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: omap4 pandaboard - Technisat USB HD problem
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

subscribe linux-media

Hello there,

theres some trouble with technisat DVBS/S2 USB HD on pandaboard.
My system: ubuntu 3.2.0-1441-omap4
media_build is installed and firmware 
dvb-usb-SkyStar_USB_HD_FW_v17_63.HEX.fw
is at /lib/firmware.

With all debugging options enabled dmesg sais the following if I remove 
the stick and
reconnect it:

[ 7934.843811] dvb_usb_technisat_usb2 1-1.2.5:1.0: usb_probe_interface
[ 7934.843841] dvb_usb_technisat_usb2 1-1.2.5:1.0: usb_probe_interface - 
got id
[ 7934.843872] check for cold 14f7 500
[ 7934.844696] technisat-usb2: set alternate setting
[ 7934.844970] technisat-usb2: firmware version: 17.63
[ 7934.844970] dvb-usb: found a 'Technisat SkyStar USB HD (DVB-S/S2)' in 
warm state.
[ 7934.845001] power control: 1
[ 7934.852355] dvb-usb: will pass the complete MPEG2 transport stream to 
the software demuxer.
[ 7934.861267] state before exiting everything: 1
[ 1592.359924] all in all I will use 524288 bytes for streaming
[ 1592.359954] allocating buffer 0
[ 1592.360321] buffer 0: ffc30000 (dma: 2813526016)
[ 1592.360382] allocating buffer 1
[ 1592.360717] buffer 1: ffc20000 (dma: 2806579200)
[ 1592.360778] allocating buffer 2
[ 1592.361206] buffer 2: ffc10000 (dma: 2813394944)
[ 1592.361267] allocating buffer 3
[ 1592.361755] buffer 3: ffc00000 (dma: 2815033344)
[ 1592.361846] allocating buffer 4
[ 1592.362792] not enough memory for urb-buffer allocation.
[ 1592.362792] freeing buffer 3
[ 1592.362823] freeing buffer 2
[ 1592.362854] freeing buffer 1
[ 1592.362884] freeing buffer 0
[ 1592.362915] state before exiting everything: 1
[ 1592.363128] state should be zero now: 0
[ 1592.363128] dvb-usb: Technisat SkyStar USB HD (DVB-S/S2) error while 
loading driver (-12)
[ 7934.861846] usbcore: registered new interface driver 
dvb_usb_technisat_usb2
[ 7947.469573] hub 1-1.2:1.0: state 7 ports 5 chg 0000 evt 0020
[ 7947.470428] hub 1-1.2:1.0: port 5, status 0100, change 0001, 12 Mb/s
[ 7947.470916] usb 1-1.2.5: USB disconnect, device number 10
[ 7947.470947] usb 1-1.2.5: unregistering device
[ 7947.470947] usb 1-1.2.5: unregistering interface 1-1.2.5:1.0
[ 7947.471405] usb 1-1.2.5: usb_disable_device nuking all URBs
[ 7947.631744] hub 1-1.2:1.0: debounce: port 5: total 100ms stable 100ms 
status 0x100
[ 7949.005615] hub 1-1.2:1.0: state 7 ports 5 chg 0000 evt 0020
[ 7949.006683] hub 1-1.2:1.0: port 5, status 0101, change 0001, 12 Mb/s
[ 7949.162841] hub 1-1.2:1.0: debounce: port 5: total 100ms stable 100ms 
status 0x101
[ 7949.248687] usb 1-1.2.5: new high-speed USB device number 11 using 
ehci-omap
[ 7949.366424] usb 1-1.2.5: default language 0x0409
[ 7949.367156] usb 1-1.2.5: udev 11, busnum 1, minor = 10
[ 7949.367187] usb 1-1.2.5: New USB device found, idVendor=14f7, 
idProduct=0500
[ 7949.367187] usb 1-1.2.5: New USB device strings: Mfr=1, Product=2, 
SerialNumber=3
[...] same as above

The device has to be handled as USB 2.0 to work correctly..
=>[ 7949.248687] usb 1-1.2.5: new high-speed USB device number 11 using 
ehci-omap
looks good, but
=> [ 7947.470428] hub 1-1.2:1.0: port 5, status 0100, change 0001, 12 Mb/s
is too slow or ?

But /usr/bin/usb-devices tells me that the device is on 480Mb/s speed..

The hub:
T:  Bus=01 Lev=02 Prnt=02 Port=01 Cnt=02 Dev#=  4 Spd=480 MxCh= 5
D:  Ver= 2.00 Cls=09(hub  ) Sub=00 Prot=02 MxPS=64 #Cfgs=  1
P:  Vendor=2101 ProdID=8500 Rev=01.06
S:  Manufacturer=Action Star
S:  Product=USB2.0 Hub
C:  #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=100mA
I:  If#= 0 Alt= 1 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=02 Driver=hub

The stick:
T:  Bus=01 Lev=03 Prnt=04 Port=04 Cnt=05 Dev#= 11 Spd=480 MxCh= 0
D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=14f7 ProdID=0500 Rev=00.01
S:  Manufacturer=TechniSat Digital
S:  Product=TechniSat USB device
S:  SerialNumber=0008C9F0B853
C:  #Ifs= 1 Cfg#= 1 Atr=c0 MxPwr=300mA
I:  If#= 0 Alt= 1 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=(none)

What I could do to get this working ?
I dont know where to search anymore..

Regards
- Christian Löpke -

