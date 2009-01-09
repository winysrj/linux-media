Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rv-out-0506.google.com ([209.85.198.238])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <pjb.belin@gmail.com>) id 1LLO51-00019e-Hs
	for linux-dvb@linuxtv.org; Fri, 09 Jan 2009 21:35:46 +0100
Received: by rv-out-0506.google.com with SMTP id b25so9738840rvf.41
	for <linux-dvb@linuxtv.org>; Fri, 09 Jan 2009 12:35:38 -0800 (PST)
Message-ID: <c54d87990901091235k1a1736dfka0bda9d720f2667@mail.gmail.com>
Date: Fri, 9 Jan 2009 21:35:38 +0100
From: "Pierre-Jean BELIN" <pjb.belin@gmail.com>
To: linux-dvb@linuxtv.org
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] Post:/dev directory not populated while trying to use a
	Cinergy DT USB XS Diversity USB TV tuner
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

Hello

I am trying to use a TerraTec Cinergy DT USB XS Diversity USB key to
broadcast video on my private network.

I have followed tutorials from www.linuxtv.org but impossible to start
the device.

The key works correctly on Vista, so I am sure that the device is not
out of order.

My OS is a Fedora Sulfur ; kernel version : 2.6.27.9-73.fc9; my box is a 64bits

1) I describe hereunder all the steps I followed to (unsuccessfully)
start the key.

Everything is based on www.linuxtv.org tutos.

a) Installation of Mercurial and download of all the sources to
compile the modules.
b) As mentioned in the description of the key
(http://www.linuxtv.org/wiki/index.php/TerraTec_Cinergy_DT_USB_XS_Diversity#Firmware)
my device id is 0081 instead of 005a. Thus, I have modified (only
replace 005a by 0081) the file
linux/drivers/media/dvb/dvb-usb/dvb-usb-ids.h to take into account
this change.

Old line
==================================================================
 #define USB_PID_TERRATEC_CINERGY_DT_XS_DIVERSITY        0x005a
==================================================================
New line
==================================================================
 #define USB_PID_TERRATEC_CINERGY_DT_XS_DIVERSITY        0x0081
==================================================================

c) Compilation and installation

d) In /etc/sysconfig/modules, creation of the file load.modules. It contains :
====================================================
#!/bin/bash

modprobe dvb_usb_dib0700
====================================================

e) Reboot

The key is pluged and detected as mentioned by lsusb :
========================================================
Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 008 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 007 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 006 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 001 Device 002: ID 0ccd:0081 TerraTec Electronic GmbH
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
========================================================

A lsmod|grep dvb shows that all modules mentioned in the LinuxTV page
related to the Terratec key are loaded.
========================================================
dvb_usb_dib0700        46472  0
dib7000p               23688  1 dvb_usb_dib0700
dib7000m               22660  1 dvb_usb_dib0700
dvb_usb                24588  1 dvb_usb_dib0700
dvb_core               84252  1 dvb_usb
dib3000mc              20232  1 dvb_usb_dib0700
dib0070                15108  1 dvb_usb_dib0700
i2c_core               29216  9
mt2060,dvb_usb_dib0700,dib7000p,dib7000m,dvb_usb,dib3000mc,dibx000_common,dib0070,i2c_i801
========================================================

I should have in my /dev directory a dvb entry with two devices
adapter0 and adapter1 with subdirectories linked to them. /dev/dvb is
missing and this is my problem.

If I could have some help I would appreciate a lot.
Thanks in anticipation.

Pierre

An extract from the /var/log/dmesg file for information :

================================================================================
...
USB Universal Host Controller Interface driver v3.0
uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1a.0: setting latency timer to 64
uhci_hcd 0000:00:1a.0: UHCI Host Controller
uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000a800
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
usb 1-3: configuration #1 chosen from 1 choice
usb 1-3: New USB device found, idVendor=0ccd, idProduct=0081
usb 1-3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-3: Product: Cinergy DT XS
usb 1-3: Manufacturer: TerraTec
usb 1-3: SerialNumber: 080402001904
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.27.9-73.fc9.x86_64 uhci_hcd
usb usb3: SerialNumber: 0000:00:1a.0
uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:1a.1: setting latency timer to 64
uhci_hcd 0000:00:1a.1: UHCI Host Controller
uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1a.1: irq 21, io base 0x0000a880
...
dib0700: loaded with support for 7 different device-types
...
usbcore: registered new interface driver dvb_usb_dib0700
...
================================================================

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
