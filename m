Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-in-02.arcor-online.net ([151.189.21.42])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <gumhead@arcor.de>) id 1K0Em4-00035P-GI
	for linux-dvb@linuxtv.org; Sun, 25 May 2008 13:52:29 +0200
Received: from mail-in-20-z2.arcor-online.net (mail-in-20-z2.arcor-online.net
	[151.189.8.85])
	by mail-in-02.arcor-online.net (Postfix) with ESMTP id 2352232E93B
	for <linux-dvb@linuxtv.org>; Sun, 25 May 2008 13:52:25 +0200 (CEST)
Received: from mail-in-16.arcor-online.net (mail-in-16.arcor-online.net
	[151.189.21.56])
	by mail-in-20-z2.arcor-online.net (Postfix) with ESMTP id 0BC88107D1D
	for <linux-dvb@linuxtv.org>; Sun, 25 May 2008 13:52:25 +0200 (CEST)
Received: from [10.132.205.78] (dslb-084-056-153-084.pools.arcor-ip.net
	[84.56.153.84]) (Authenticated sender: gumhead@arcor.de)
	by mail-in-16.arcor-online.net (Postfix) with ESMTP id DEBE2236E49
	for <linux-dvb@linuxtv.org>; Sun, 25 May 2008 13:52:24 +0200 (CEST)
From: Bernie <gumhead@arcor.de>
To: linux-dvb@linuxtv.org
Date: Sun, 25 May 2008 13:53:01 +0200
Message-Id: <1211716381.4613.1.camel@linux-tg2z.site>
Mime-Version: 1.0
Subject: [linux-dvb] ADS Tech Dual TV USB Analog + DVB-T PTV-332
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

Hi,

I'm having problems running the ADS Tech Dual TV USB Analog + DVB-T
PTV-332 box under openSuse 10.3 linux, kernel 2.6.22.17-0.1-default.
Details of the box can be found here: http://www.bttv-gallery.de/. When
I plug the box via USB, I still do not get any device
subfolder /dev/dvb/ (udev package is installed).

I have compiled and installed the 4vl-dvb drivers and followed all the
other steps described in
http://www.linuxtv.org/wiki/index.php/How_to_install_DVB_device_drivers

Also I have tried to install the TM6000 experimental driver following
the instructions on
http://www.linuxtv.org/v4lwiki/index.php/Trident_TM6000 as the ADS box
contains the TM6000, but failed when I tried to "make" the driver at the
following spot in the make process:

/tmp/xxx/v4l-dvb/v4l/tm6000.c:2005: error: too few arguments to function
'dvb_register_adapter'
/tmp/xxx/v4l-dvb/v4l/tm6000.c:2059: warning: label 'err' defined but not
used
make[5]: *** [/tmp/xxx/v4l-dvb/v4l/tm6000.o] Error 1
make[4]: *** [_module_/tmp/xxx/v4l-dvb/v4l] Error 2
make[3]: *** [modules] Error 2
make[2]: *** [modules] Error 2
make[2]: Leaving directory
`/usr/src/linux-2.6.22.17-0.1-obj/i386/default'
make[1]: *** [default] Fehler 2
make[1]: Leaving directory `/tmp/xxx/v4l-dvb/v4l'
make: *** [all] Fehler 2
>

Here is the output of "lsmod" regarding all the dvb related modules (I
think it contains the necessary modules described in the HOWTOs...):

linux-tg2z:/tmp/xxx/v4l-dvb # lsmod |grep dvb
dvb_usb                24716  0 
dvb_pll                12424  0 
dvb_ttpci              97992  0 
saa7146_vv             49280  1 dvb_ttpci
saa7146                22280  2 dvb_ttpci,saa7146_vv
ttpci_eeprom            6528  1 dvb_ttpci
dvb_core               76804  6
dvb_usb,stv0299,or51211,or51132,lgdt330x,dvb_ttpci
firmware_class         13568  12
dvb_usb,tda1004x,tda10048,sp887x,sp8870,or51211,or51132,nxt200x,drx397xD,bcm3510,dvb_ttpci,microcode
i2c_core               27520  49
dvb_usb,zl10353,ves1x93,ves1820,tua6100,tda826x,tda8083,tda10086,tda1004x,tda10048,tda10023,tda10021,stv0299,stv0297,sp887x,sp8870,s5h1420,s5h1411,s5h1409,or51211,or51132,nxt6000,nxt200x,mt352,mt312,lnbp21,lgdt330x,l64781,itd1000,isl6421,isl6405,dvb_pll,drx397xD,dib7000p,dib7000m,dib3000mc,dibx000_common,dib3000mb,dib0070,cx24123,cx24110,cx22702,cx22700,bcm3510,au8522,dvb_ttpci,ttpci_eeprom,nvidia,i2c_i801
usbcore               124268  6
dvb_usb,usb_storage,usbhid,ehci_hcd,uhci_hcd


When I plug in the DVB box, the system seems to not recognize the box as
a DVB device properly. Here is the tail of "dmesg":

usb 7-6: new high speed USB device using ehci_hcd and address 5
usb 7-6: new device found, idVendor=06e1, idProduct=f332
usb 7-6: new device strings: Mfr=16, Product=32, SerialNumber=64
usb 7-6: Product: DualTV USB
usb 7-6: Manufacturer: ADS
usb 7-6: SerialNumber: 2.0
usb 7-6: configuration #1 chosen from 1 choice
usb 7-6: USB disconnect, address 5
usb 7-6: new high speed USB device using ehci_hcd and address 6
usb 7-6: new device found, idVendor=06e1, idProduct=f332
usb 7-6: new device strings: Mfr=16, Product=32, SerialNumber=64
usb 7-6: Product: DualTV USB
usb 7-6: Manufacturer: ADS
usb 7-6: SerialNumber: 2.0
usb 7-6: configuration #1 chosen from 1 choice

It does not even seem to try to download the firmware even though I have
put tm6000-firmware1 and tm6000-firmware2 in the /lib/firmware/
subfolder.

I don't know what else I can do to get this DVB box running... Is there
any way to force the USB device to be handled by usb-dvb or some other
module when it is plugged?

Is there any chance to get this ADS box running at all? Or is it maybe
totally impossible to run it under Linux (I have used it many times
under WinXP using ProgDVB without any problems...)?

Please help me!
Thank you & regards,
Bernie



_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
