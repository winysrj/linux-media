Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from m0-if0.velocitynet.com.au ([203.17.154.50]
	helo=m0.velocity.net.au) by mail.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <mylists@wilsononline.id.au>) id 1NFe3v-0008El-Rp
	for linux-dvb@linuxtv.org; Wed, 02 Dec 2009 02:31:25 +0100
Received: from [192.168.0.10] (110.143.46.202-static.velocitynet.com.au
	[202.46.143.110])
	by m0.velocity.net.au (Postfix) with ESMTP id 7905A603F0
	for <linux-dvb@linuxtv.org>; Wed,  2 Dec 2009 12:31:07 +1100 (EST)
Message-ID: <4B15C35A.9010902@wilsononline.id.au>
Date: Wed, 02 Dec 2009 12:31:06 +1100
From: Paul <mylists@wilsononline.id.au>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] dvb_usb_dib0700  ( T14BR) not initializing on reboot
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

I have a DVB-T USB device ( T14BR),
which seems to work fine when I plug in my Fedora 10 box but I if I 
reboot with device connected it regularity fails to initialise correctly
and to correct I have to remove unplug-device remove the module and 
reload module to fix up and only after system has been fully booted

eg
modprobe -r dvb-usb-dib0700
then
modprobe dvb-usb-dib0700  adapter_nr=2
and then plug device in.
I get the following msgs when it seems to fail and the second set when 
it works

kernel log (failed)

Nov 22 13:51:50 mythbox kernel: usb 2-7: new full speed USB device using 
ohci_hcd and address 2
Nov 22 13:51:50 mythbox kernel: usb 2-7: new full speed USB device using 
ohci_hcd and address 3
Nov 22 13:51:50 mythbox kernel: usb 2-7: new full speed USB device using 
ohci_hcd and address 4
Nov 22 13:51:50 mythbox kernel: usb 2-7: new full speed USB device using 
ohci_hcd and address 5
Nov 22 13:51:50 mythbox kernel: usb 2-8: new low speed USB device using 
ohci_hcd and address 6
Nov 22 13:51:50 mythbox kernel: usb 2-8: configuration #1 chosen from 1 
choice
Nov 22 13:51:50 mythbox kernel: usb 2-8: New USB device found, 
idVendor=413c, idProduct=3010
Nov 22 13:51:50 mythbox kernel: usb 2-8: New USB device strings: Mfr=0, 
Product=0, SerialNumber=0
Nov 22 13:51:50 mythbox kernel: usbcore: registered new interface driver 
hiddev
Nov 22 13:51:50 mythbox kernel: input: HID 413c:3010 as 
/devices/pci0000:00/0000:00:02.0/usb2/2-8/2-8:1.0/input/input4
Nov 22 13:51:50 mythbox kernel: input,hidraw0: USB HID v1.00 Mouse [HID 
413c:3010] on usb-0000:00:02.0-8
Nov 22 13:51:50 mythbox kernel: usbcore: registered new interface driver 
usbhid
Nov 22 13:51:50 mythbox kernel: usbhid: v2.6:USB HID core driver


http://www.artectv.com/ehtm/products/t14.htm

kernel log (working)

Nov 29 09:58:20 mythbox kernel: usb 1-8: new high speed USB device using 
ehci_hcd and address 3
Nov 29 09:58:20 mythbox kernel: usb 1-8: configuration #1 chosen from 1 
choice
Nov 29 09:58:20 mythbox kernel: usb 1-8: New USB device found, 
idVendor=05d8, idProduct=810f
Nov 29 09:58:20 mythbox kernel: usb 1-8: New USB device strings: Mfr=1, 
Product=2, SerialNumber=3
Nov 29 09:58:20 mythbox kernel: usb 1-8: Product: ART7070
Nov 29 09:58:20 mythbox kernel: usb 1-8: Manufacturer: Ultima
Nov 29 09:58:20 mythbox kernel: usb 1-8: SerialNumber: 001
Nov 29 09:58:20 mythbox kernel: dib0700: loaded with support for 7 
different device-types
Nov 29 09:58:20 mythbox kernel: dvb-usb: found a 'Artec T14BR DVB-T' in 
cold state, will try to load a firmware
Nov 29 09:58:20 mythbox kernel: firmware: requesting dvb-usb-dib0700-1.10.fw
Nov 29 09:58:20 mythbox kernel: dvb-usb: downloading firmware from file 
'dvb-usb-dib0700-1.10.fw'
Nov 29 09:58:22 mythbox kernel: dib0700: firmware started successfully.
Nov 29 09:58:23 mythbox kernel: dvb-usb: found a 'Artec T14BR DVB-T' in 
warm state.
Nov 29 09:58:23 mythbox kernel: dvb-usb: will pass the complete MPEG2 
transport stream to the software demuxer.
Nov 29 09:58:23 mythbox kernel: DVB: registering new adapter (Artec 
T14BR DVB-T)
Nov 29 09:58:23 mythbox kernel: DiB0070: successfully identified
Nov 29 09:58:23 mythbox kernel: input: IR-receiver inside an USB DVB 
receiver as /devices/pci0000:00/0000:00:02.1/usb1/1
-8/input/input7
Nov 29 09:58:23 mythbox kernel: dvb-usb: schedule remote query interval 
to 150 msecs.
Nov 29 09:58:23 mythbox kernel: dvb-usb: Artec T14BR DVB-T successfully 
initialized and connected.

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
