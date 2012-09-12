Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:39121 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755056Ab2ILHIN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 12 Sep 2012 03:08:13 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1TBh3X-0004V3-O5
	for linux-media@vger.kernel.org; Wed, 12 Sep 2012 09:08:15 +0200
Received: from acjd188.neoplus.adsl.tpnet.pl ([83.10.53.188])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Wed, 12 Sep 2012 09:08:15 +0200
Received: from acc.for.news by acjd188.neoplus.adsl.tpnet.pl with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Wed, 12 Sep 2012 09:08:15 +0200
To: linux-media@vger.kernel.org
From: Marx <acc.for.news@gmail.com>
Subject: ITE9135 on AMD SB700 - ehci_hcd bug
Date: Wed, 12 Sep 2012 08:32:20 +0200
Message-ID: <ksm5i9-2t1.ln1@wuwek.kopernik.gliwice.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello
I'm trying to use dual DVB-T tuner based on ITE9135 tuner. I use Debian 
kernel 3.5-trunk-686-pae. My motherboard is AsRock E350M1 (no USB3 ports).
Tuner is detected ok, see log at the end of post.

When I try to scan channels, bug happens:
Sep 11 17:16:31 wuwek kernel: [  209.291329] ehci_hcd 0000:00:13.2: 
force halt; handshake f821a024 00004000 00000000 -> -110
Sep 11 17:16:31 wuwek kernel: [  209.291401] ehci_hcd 0000:00:13.2: HC 
died; cleaning up
Sep 11 17:16:31 wuwek kernel: [  209.291606] usb 2-3: USB disconnect, 
device number 2
Sep 11 17:16:41 wuwek kernel: [  219.312848] dvb-usb: error while 
stopping stream.
Sep 11 17:16:41 wuwek kernel: [  219.320585] dvb-usb: ITE 9135(9006) 
Generic successfully deinitialized and disconnected.

After trying many ways I've read about problems with ehci on SB700 based 
boards and switched off ehci via command
sh -c 'echo -n "0000:00:13.2" > unbind'
and now ehci bug doesn't happen. Of course I can see only one tuner and 
in slower USB mode (see log at the end). But now I can scan succesfully 
without any errors.

Of course it isn't acceptable fix for my problem. Drivers for ITE9135 
seems ok, but there is a problem with ehci_hcd on my motherboard.
I would like to know what can I do to fix my problem.


KERN.LOG from startup:
Sep 11 17:13:44 wuwek kernel: [    6.278832] input: ITE Technologies, 
Inc. USB Deivce as 
/devices/pci0000:00/0000:00:13.2/usb2/2-3/2-3:1.1/input/input3
Sep 11 17:13:44 wuwek kernel: [    6.279051] hid-generic 
0003:048D:9006.0001: input,hidraw0: USB HID v1.01 Keyboard [ITE 
Technologies, Inc. USB Deivce] on usb-0000:00:13.2-3/input1
Sep 11 17:13:44 wuwek kernel: [    6.637391] it913x: Chip Version=01 
Chip Type=9135
Sep 11 17:13:44 wuwek kernel: [    6.638007] it913x: Firmware Version 
204869120
Sep 11 17:13:44 wuwek kernel: [    6.639737] it913x: Remote HID mode NOT 
SUPPORTED
Sep 11 17:13:44 wuwek kernel: [    6.640176] it913x: Dual mode=3 Tuner 
Type=0
Sep 11 17:13:44 wuwek kernel: [    6.640189] dvb-usb: found a 'ITE 
9135(9006) Generic' in warm state.
Sep 11 17:13:44 wuwek kernel: [    6.640335] dvb-usb: will use the 
device's hardware PID filter (table count: 31).
Sep 11 17:13:44 wuwek kernel: [    6.640725] DVB: registering new 
adapter (ITE 9135(9006) Generic)
Sep 11 17:13:44 wuwek kernel: [    6.799021] it913x-fe: ADF table value :00
Sep 11 17:13:44 wuwek kernel: [    6.803268] it913x-fe: Crystal 
Frequency :12000000 Adc Frequency :20250000 ADC X2: 01
Sep 11 17:13:44 wuwek kernel: [    6.821662] snd_hda_intel 0000:00:01.1: 
irq 41 for MSI/MSI-X
Sep 11 17:13:44 wuwek kernel: [    6.848189] it913x-fe: Tuner LNA type :38
Sep 11 17:13:44 wuwek kernel: [    6.907792] DVB: registering adapter 0 
frontend 0 (ITE 9135(9006) Generic_1)...
Sep 11 17:13:44 wuwek kernel: [    6.908455] dvb-usb: will use the 
device's hardware PID filter (table count: 31).
Sep 11 17:13:44 wuwek kernel: [    6.909192] DVB: registering new 
adapter (ITE 9135(9006) Generic)
Sep 11 17:13:44 wuwek kernel: [    6.920916] input: HD-Audio Generic 
HDMI/DP,pcm=3 as /devices/pci0000:00/0000:00:01.1/sound/card0/input4
Sep 11 17:13:44 wuwek kernel: [    6.928156] it913x-fe: ADF table value :00
Sep 11 17:13:44 wuwek kernel: [    6.954368] it913x-fe: Crystal 
Frequency :12000000 Adc Frequency :20250000 ADC X2: 01
Sep 11 17:13:44 wuwek kernel: [    7.039275] input: HDA ATI SB Line as 
/devices/pci0000:00/0000:00:14.2/sound/card1/input5
Sep 11 17:13:44 wuwek kernel: [    7.039580] input: HDA ATI SB Rear Mic 
as /devices/pci0000:00/0000:00:14.2/sound/card1/input6
Sep 11 17:13:44 wuwek kernel: [    7.039841] input: HDA ATI SB Line Out 
CLFE as /devices/pci0000:00/0000:00:14.2/sound/card1/input7
Sep 11 17:13:44 wuwek kernel: [    7.042805] input: HDA ATI SB Line Out 
Surround as /devices/pci0000:00/0000:00:14.2/sound/card1/input8
Sep 11 17:13:44 wuwek kernel: [    7.043328] input: HDA ATI SB Line Out 
Front as /devices/pci0000:00/0000:00:14.2/sound/card1/input9
Sep 11 17:13:44 wuwek kernel: [    7.228898] it913x-fe: Tuner LNA type :38
Sep 11 17:13:44 wuwek kernel: [    7.560210] DVB: registering adapter 1 
frontend 0 (ITE 9135(9006) Generic_2)...
Sep 11 17:13:44 wuwek kernel: [    7.560650] dvb-usb: ITE 9135(9006) 
Generic successfully initialized and connected.
Sep 11 17:13:44 wuwek kernel: [    7.560661] it913x: DEV registering 
device driver
Sep 11 17:13:44 wuwek kernel: [    7.560743] usbcore: registered new 
interface driver it913x

KERN.LOG after switching off ehci_hd
Sep 11 22:58:30 wuwek kernel: [20696.545018] usb 5-3: new full-speed USB 
device number 2 using ohci_hcd
Sep 11 22:58:31 wuwek kernel: [20696.704020] usb 5-3: not running at top 
speed; connect to a high speed hub
Sep 11 22:58:31 wuwek kernel: [20696.716016] usb 5-3: New USB device 
found, idVendor=048d, idProduct=9006
Sep 11 22:58:31 wuwek kernel: [20696.716031] usb 5-3: New USB device 
strings: Mfr=1, Product=2, SerialNumber=0
Sep 11 22:58:31 wuwek kernel: [20696.716039] usb 5-3: Product: USB Deivce
Sep 11 22:58:31 wuwek kernel: [20696.716047] usb 5-3: Manufacturer: ITE 
Technologies, Inc.
Sep 11 22:58:31 wuwek kernel: [20696.723971] it913x: Chip Version=01 
Chip Type=9135
Sep 11 22:58:31 wuwek kernel: [20696.727964] it913x: Firmware Version 
204869120
Sep 11 22:58:31 wuwek kernel: [20696.739946] it913x: Remote HID mode NOT 
SUPPORTED
Sep 11 22:58:31 wuwek kernel: [20696.743945] it913x: USB 1 low speed 
mode - connect to USB 2 port
Sep 11 22:58:31 wuwek kernel: [20696.743958] it913x: Dual mode not 
supported in USB 1
Sep 11 22:58:31 wuwek kernel: [20696.743964] it913x: Dual mode=0 Tuner 
Type=0
Sep 11 22:58:31 wuwek kernel: [20696.743972] dvb-usb: found a 'ITE 
9135(9006) Generic' in warm state.
Sep 11 22:58:31 wuwek kernel: [20696.744129] dvb-usb: will use the 
device's hardware PID filter (table count: 5).
Sep 11 22:58:31 wuwek kernel: [20696.745985] DVB: registering new 
adapter (ITE 9135(9006) Generic)
Sep 11 22:58:31 wuwek kernel: [20696.769729] it913x-fe: ADF table value :00
Sep 11 22:58:31 wuwek kernel: [20696.809852] it913x-fe: Crystal 
Frequency :12000000 Adc Frequency :20250000 ADC X2: 01
Sep 11 22:58:31 wuwek kernel: [20697.243177] it913x-fe: Tuner LNA type :38
Sep 11 22:58:32 wuwek kernel: [20697.738388] DVB: registering adapter 0 
frontend 0 (ITE 9135(9006) Generic_1)...
Sep 11 22:58:32 wuwek kernel: [20697.739188] dvb-usb: ITE 9135(9006) 
Generic successfully initialized and connected.
Sep 11 22:58:32 wuwek kernel: [20697.739199] it913x: DEV registering 
device driver
Sep 11 22:58:32 wuwek kernel: [20697.745730] input: ITE Technologies, 
Inc. USB Deivce as 
/devices/pci0000:00/0000:00:13.0/usb5/5-3/5-3:1.1/input/input15
Sep 11 22:58:32 wuwek kernel: [20697.746082] hid-generic 
0003:048D:9006.0007: input,hidraw0: USB HID v1.01 Keyboard [ITE 
Technologies, Inc. USB Deivce] on usb-0000:00:13.0-3/input1

