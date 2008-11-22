Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from relay14.mail.uk.clara.net ([80.168.70.194])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <news@onastick.clara.co.uk>) id 1L40IF-00024y-R9
	for linux-dvb@linuxtv.org; Sat, 22 Nov 2008 22:45:33 +0100
Received: from [79.123.73.181] (port=10986 helo=mail.onasticksoftware.net)
	by relay14.mail.uk.clara.net with esmtp (Exim 4.69)
	(envelope-from <news@onastick.clara.co.uk>) id 1L40IA-0001QV-NA
	for linux-dvb@linuxtv.org; Sat, 22 Nov 2008 21:45:27 +0000
Received: from onasticksoftware.net (lapdog.onasticksoftware.net [192.168.0.3])
	by mail.onasticksoftware.net (Postfix) with ESMTP id BB2E18C884
	for <linux-dvb@linuxtv.org>; Sat, 22 Nov 2008 21:45:19 +0000 (GMT)
Message-ID: <RCbI1iFQ0HKJFw8A@onasticksoftware.net>
Date: Sat, 22 Nov 2008 21:43:44 +0000
To: linux-dvb@linuxtv.org
From: jon bird <news@onastick.clara.co.uk>
MIME-Version: 1.0
Subject: [linux-dvb] Nova/dib0700/i2C write failed
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

Just to provide a bit more info on what seems to be an ongoing issue 
with these devices, I updated my kernel (2.6.26) dvb drivers with a 
snapshot from here on 19/11/08 (v4l-dvb-5dc4a6b381f6), it has marginally 
improved the behaviour but only slightly. Previously, sporadic 'usb 1-4: 
USB disconnect, address 2' followed by 'mt2060 I2C write failed' 
cropping up generally put the khubd into a spin with repeated messages 
of the form:

Nov 22 20:12:13 fridge kernel: usb 1-4: USB disconnect, address 2
Nov 22 20:12:13 fridge kernel: mt2060 I2C write failed
...

Nov 22 20:14:22 fridge kernel: INFO: task khubd:1823 blocked for more 
than 120 seconds.
Nov 22 20:14:22 fridge kernel: "echo 0 > 
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
Nov 22 20:14:22 fridge kernel: khubd         D f7f5d000     0  1823 2
Nov 22 20:14:22 fridge kernel:        f74c8740 00000046 f7dfe000 
f7f5d000 f74a0dc0 f74a0dc0 f7cc0e00 f768f360
Nov 22 20:14:22 fridge kernel:        00000001 f7cc0f8c f7cc0e00 
f7f39e58 f7f39e6c 00000001 f896724d 00000000
Nov 22 20:14:22 fridge kernel:        f74a0dc0 c0124fde f7f39e64 
f7f39e64 f7c0b200 c0186c21 f7f39ea4 00000000
Nov 22 20:14:22 fridge kernel: Call Trace:
Nov 22 20:14:22 fridge kernel:  [<f896724d>] 
dvb_unregister_frontend+0xa3/0xda [dvb_core]
Nov 22 20:14:22 fridge kernel:  [autoremove_wake_function+0/45] 
autoremove_wake_function+0x0/0x2d
Nov 22 20:14:22 fridge kernel:  [<c0124fde>] 
autoremove_wake_function+0x0/0x2d
Nov 22 20:14:22 fridge kernel:  [sysfs_ilookup_test+0/13] 
sysfs_ilookup_test+0x0/0xd

requiring a complete shutdown and reboot to recover even after killing 
of any dvb applications.

With the latest drivers, this lock of khubd still occurs but only for 
the lifetime of the active dvb application - it then partially recovers 
as follows:

Nov 22 21:02:36 fridge kernel: dvb-usb: error while stopping stream.
Nov 22 21:02:36 fridge kernel: dvb-usb: Hauppauge Nova-T Stick 
successfully deinitialized and disconnected.
Nov 22 21:02:36 fridge kernel: usb 1-4: new high speed USB device using 
ehci_hcd and address 3
Nov 22 21:02:36 fridge /USR/SBIN/CRON[8929]: (wwwrun) MAIL (mailed 947 
bytes of output but got status 0xffffffff )
Nov 22 21:02:51 fridge kernel: hub 1-0:1.0: unable to enumerate USB 
device on port 4
Nov 22 21:02:51 fridge kernel: usb 3-2: new full speed USB device using 
uhci_hcd and address 2
Nov 22 21:02:52 fridge kernel: usb 3-2: not running at top speed; 
connect to a high speed hub
Nov 22 21:02:52 fridge kernel: usb 3-2: configuration #1 chosen from 1 
choice
Nov 22 21:02:52 fridge kernel: dvb-usb: found a 'Hauppauge Nova-T Stick' 
in warm state.
Nov 22 21:02:52 fridge kernel: dvb-usb: This USB2.0 device cannot be run 
on a USB1.1 port. (it lacks a hardware PID filter)
Nov 22 21:02:52 fridge kernel: dvb-usb: Hauppauge Nova-T Stick error 
while loading driver (-19)
Nov 22 21:02:52 fridge kernel: usb 3-2: New USB device found, 
idVendor=2040, idProduct=7060
Nov 22 21:02:52 fridge kernel: usb 3-2: New USB device strings: Mfr=1, 
Product=2, SerialNumber=3
Nov 22 21:02:52 fridge kernel: usb 3-2: Product: Nova-T Stick
Nov 22 21:02:52 fridge kernel: usb 3-2: Manufacturer: Hauppauge
Nov 22 21:02:52 fridge kernel: usb 3-2: SerialNumber: 4030521095

Physically disconnecting and reconnecting the device has the same 
effect. So it looks like the driver is recovering but the USB2 hub has 
been stuffed in some way.

-- 
== jon bird - software engineer
== <reply to address _may_ be invalid, real mail below>
== <reduce rsi, stop using the shift key>
== posted as: news 'at' onastick 'dot' clara.co.uk


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
