Return-path: <linux-media-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:38675 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945932Ab2EKTpG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 11 May 2012 15:45:06 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1SSvlw-0001ly-5J
	for linux-media@vger.kernel.org; Fri, 11 May 2012 21:45:04 +0200
Received: from 89-69-21-174.dynamic.chello.pl ([89.69.21.174])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Fri, 11 May 2012 21:45:04 +0200
Received: from arekm by 89-69-21-174.dynamic.chello.pl with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Fri, 11 May 2012 21:45:04 +0200
To: linux-media@vger.kernel.org
From: Arkadiusz =?ISO-8859-2?Q?Mi=B6kiewicz?= <arekm@maven.pl>
Subject: IT9135 on kernel 3.3.4 and frequent firmware loading problems
Date: Fri, 11 May 2012 21:38:40 +0200
Message-ID: <jojps1$mei$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-2"
Content-Transfer-Encoding: 8Bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Hello.

I'm trying to use it9135 v1 device on 3.3.4 kernel.

Unfortunately most of the time there are problems with loading firmware 
(udev 182).

Firmware file is there:
-rw-r--r-- 1 root root 8128 05-03 21:31 /lib/firmware/dvb-usb-it9135-01.fw

In most cases dmesg log below shows what happens. Sometimes udev also logs:

May 11 21:33:23 serarm udevd[13078]: error: can not open 
'/sys/devices/pci0000:00/0000:00:13.2/usb2/2-1/firmware/2-1/loading'

Rarely it succeeds. Both logs below. Any ideas/patches to test?

dmesg:

[690924.825272] usb 2-1: USB disconnect, device number 5
[690928.177811] usb 2-1: new high-speed USB device number 6 using ehci_hcd
[690928.306673] usb 2-1: New USB device found, idVendor=048d, idProduct=9005
[690928.306682] usb 2-1: New USB device strings: Mfr=1, Product=0, 
SerialNumber=3
[690928.306688] usb 2-1: Manufacturer: ITE Technologies, Inc.
[690928.306691] usb 2-1: SerialNumber: AF0102020700001
[690928.308060] it913x: Chip Version=01 Chip Type=9135
[690928.309768] it913x: Dual mode=0 Remote=5 Tuner Type=0
[690928.310893] dvb-usb: found a 'ITE 9135(9005) Generic' in cold state, 
will try to load a firmware
[690989.424555] dvb-usb: did not find the firmware file. (dvb-usb-
it9135-01.fw) Please see linux/Documentation/dvb/ for more details on 
firmware-problems. (-2)
[690989.424569] it913x: DEV it913x Error
[691095.461641] usb 2-1: USB disconnect, device number 6
[691135.164358] usb 2-1: new high-speed USB device number 7 using ehci_hcd
[691135.293947] usb 2-1: New USB device found, idVendor=048d, idProduct=9005
[691135.293961] usb 2-1: New USB device strings: Mfr=1, Product=0, 
SerialNumber=3
[691135.293970] usb 2-1: Manufacturer: ITE Technologies, Inc.
[691135.293977] usb 2-1: SerialNumber: AF0102020700001
[691135.298425] it913x: Chip Version=01 Chip Type=9135
[691135.300412] it913x: Dual mode=0 Remote=5 Tuner Type=0
[691135.302788] dvb-usb: found a 'ITE 9135(9005) Generic' in cold state, 
will try to load a firmware
[691196.357877] dvb-usb: did not find the firmware file. (dvb-usb-
it9135-01.fw) Please see linux/Documentation/dvb/ for more details on 
firmware-problems. (-2)
[691196.357890] it913x: DEV it913x Error


rarely it succeeds:

[139096.597057] dvb-usb: found a 'ITE 9135(9005) Generic' in cold state, 
will try to load a firmware
[139157.373111] dvb-usb: did not find the firmware file. (dvb-usb-
it9135-01.fw) Please see linux/Documentation/dvb/ for more d
etails on firmware-problems. (-2)
[139157.373125] it913x: DEV it913x Error
[139224.120099] usbcore: deregistering interface driver it913x
[139228.873451] it913x: Chip Version=01 Chip Type=9135
[139228.877562] it913x: Dual mode=0 Remote=5 Tuner Type=0
[139228.883282] dvb-usb: found a 'ITE 9135(9005) Generic' in cold state, 
will try to load a firmware
[139228.897483] dvb-usb: downloading firmware from file 'dvb-usb-
it9135-01.fw'
[139228.897836] it913x: FRM Starting Firmware Download
[139229.406197] it913x: FRM Firmware Download Completed - Resetting Device
[139229.406783] it913x: Chip Version=01 Chip Type=9135
[139229.407307] it913x: Firmware Version 204869120
[139229.440965] dvb-usb: found a 'ITE 9135(9005) Generic' in warm state.
[139229.441147] dvb-usb: will use the device's hardware PID filter (table 
count: 31).
[139229.441630] DVB: registering new adapter (ITE 9135(9005) Generic)
[139229.445429] it913x-fe: ADF table value       :00
[139229.449159] it913x-fe: Crystal Frequency :12000000 Adc Frequency 
:20250000 ADC X2: 01
[139229.481443] it913x-fe: Tuner LNA type :38
[139229.528069] DVB: registering adapter 0 frontend 0 (ITE 9135(9005) 
Generic_1)...
[139229.528347] Registered IR keymap rc-msi-digivox-iii
[139229.528594] input: IR-receiver inside an USB DVB receiver as 
/devices/pci0000:00/0000:00:15.2/0000:05:00.0/usb8/8-2/8-2.2/rc/rc1/input13
[139229.532101] rc1: IR-receiver inside an USB DVB receiver as 
/devices/pci0000:00/0000:00:15.2/0000:05:00.0/usb8/8-2/8-2.2/rc/rc1
[139229.532117] dvb-usb: schedule remote query interval to 250 msecs.
[139229.532129] dvb-usb: ITE 9135(9005) Generic successfully initialized and 
connected.
[139229.532136] it913x: DEV registering device driver
[139229.532213] usbcore: registered new interface driver it913x


-- 
Arkadiusz Mi¶kiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/

