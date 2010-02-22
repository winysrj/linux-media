Return-path: <linux-media-owner@vger.kernel.org>
Received: from gateway8.lastspam.com ([72.0.198.36]:52042 "EHLO
	gateway8.lastspam.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754713Ab0BVXb5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Feb 2010 18:31:57 -0500
Message-ID: <4B83076A.3010409@ctecworld.com>
Date: Mon, 22 Feb 2010 17:38:34 -0500
From: j <jlafontaine@ctecworld.com>
MIME-Version: 1.0
To: Dmitri Belimov <d.belimov@gmail.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"video4linux-list@redhat.com" <video4linux-list@redhat.com>
Subject: eb1a:2860 eMPIA em28xx device to usb1 ??? usb hub problem?
References: <20091007101142.3b83dbf2@glory.loctelecom.ru>	<200912160849.17005.hverkuil@xs4all.nl>	<20100112172209.464e88cd@glory.loctelecom.ru>	<201001130838.23949.hverkuil@xs4all.nl> <20100127143637.26465503@glory.loctelecom.ru>
In-Reply-To: <20100127143637.26465503@glory.loctelecom.ru>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi I get trouble with my Kworld em28xx device, anyone can help any 
kernel issue found somewhere about that?

Bus 001 Device 005: ID eb1a:2860 eMPIA Technology, Inc.

The device seems to go to usb1 hub and its usb2

Using kernel : 2.6.27-7-generic

LSUSB

Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 001 Device 005: ID eb1a:2860 eMPIA Technology, Inc.
Bus 001 Device 004: ID 046d:c404 Logitech, Inc. TrackMan Wheel
Bus 001 Device 003: ID 04d9:1603 Holtek Semiconductor, Inc.
Bus 001 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub


DMESG

[    2.429146] usbcore: registered new interface driver usbfs
[    2.429164] usbcore: registered new interface driver hub
[    2.429216] usbcore: registered new device driver usb
[    2.518153] usb usb1: configuration #1 chosen from 1 choice
[    2.900018] usb 1-1: new low speed USB device using ohci_hcd and 
address 2
[    2.912659] usb usb2: configuration #1 chosen from 1 choice
[    3.576015] usb 2-3: new high speed USB device using ehci_hcd and 
address 4
[    4.096019] usb 2-3: device not accepting address 4, error -71
[    4.208015] usb 2-3: new high speed USB device using ehci_hcd and 
address 5
[    4.340706] usb 2-3: configuration #1 chosen from 1 choice
[    4.644571] usb 1-1: new low speed USB device using ohci_hcd and 
address 3
[    4.876163] usb 1-1: configuration #1 chosen from 1 choice
[    5.180015] usb 1-2: new low speed USB device using ohci_hcd and 
address 4
[    5.393407] usb 1-2: configuration #1 chosen from 1 choice
[    5.396625] usb 2-3: USB disconnect, address 5
[    5.636017] usb 2-3: new high speed USB device using ehci_hcd and 
address 6
[    5.768459] usb 2-3: configuration #1 chosen from 1 choice
[    5.768794] usbcore: registered new interface driver hiddev
[    5.772486] usb 2-3: USB disconnect, address 6
[    5.781319] input:   USB Keyboard as 
/devices/pci0000:00/0000:00:02.0/usb1/1-1/1-1:1.0/input/input1
[    5.784136] input,hidraw0: USB HID v1.10 Keyboard [  USB Keyboard] on 
usb-0000:00:02.0-1
[    5.807105] input:   USB Keyboard as 
/devices/pci0000:00/0000:00:02.0/usb1/1-1/1-1:1.1/input/input2
[    5.807351] input,hidraw1: USB HID v1.10 Device [  USB Keyboard] on 
usb-0000:00:02.0-1
[    5.814365] input: Logitech Trackball as 
/devices/pci0000:00/0000:00:02.0/usb1/1-2/1-2:1.0/input/input3
[    5.814594] input,hidraw2: USB HID v1.10 Mouse [Logitech Trackball] 
on usb-0000:00:02.0-2
[    5.814611] usbcore: registered new interface driver usbhid
[    5.814614] usbhid: v2.6:USB HID core driver
[    6.048518] usb 2-3: new high speed USB device using ehci_hcd and 
address 7
[    6.568017] usb 2-3: device not accepting address 7, error -71
[    6.680026] usb 2-3: new high speed USB device using ehci_hcd and 
address 8
[    7.192521] usb 1-3: new full speed USB device using ohci_hcd and 
address 5
[    7.393043] usb 1-3: not running at top speed; connect to a high 
speed hub
[    7.399169] usb 1-3: configuration #1 chosen from 1 choice
[   13.927208] em28xx Doesn't have usb audio class
[   14.934118] input: em28xx snapshot button as 
/devices/pci0000:00/0000:00:02.0/usb1/1-3/input/input7
[   16.785083] usbcore: registered new interface driver em28xx
[   16.909506] em28xx-audio.c: probing for em28x1 non standard usbaudio
[   18.609828] usbcore: usbfs: unrecognised mount option "default" or 
missing value
[   18.609834] usbcore: usbfs: mount parameter error:


LSPCI

00:00.0 RAM memory: nVidia Corporation MCP61 Memory Controller (rev a1)
00:01.0 ISA bridge: nVidia Corporation MCP61 LPC Bridge (rev a2)
00:01.1 SMBus: nVidia Corporation MCP61 SMBus (rev a2)
00:01.2 RAM memory: nVidia Corporation MCP61 Memory Controller (rev a2)
00:02.0 USB Controller: nVidia Corporation MCP61 USB Controller (rev a3)
00:02.1 USB Controller: nVidia Corporation MCP61 USB Controller (rev a3)
00:04.0 PCI bridge: nVidia Corporation MCP61 PCI bridge (rev a1)
00:05.0 Audio device: nVidia Corporation MCP61 High Definition Audio 
(rev a2)
00:07.0 Bridge: nVidia Corporation MCP61 Ethernet (rev a2)
00:08.0 IDE interface: nVidia Corporation MCP61 SATA Controller (rev a2)
00:09.0 PCI bridge: nVidia Corporation MCP61 PCI Express bridge (rev a2)
00:0b.0 PCI bridge: nVidia Corporation MCP61 PCI Express bridge (rev a2)
00:0c.0 PCI bridge: nVidia Corporation MCP61 PCI Express bridge (rev a2)
00:0d.0 VGA compatible controller: nVidia Corporation GeForce 6150SE 
nForce 430 (rev a2)
00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
HyperTransport Technology Configuration
00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
Address Map
00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
DRAM Controller
00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
Miscellaneous Control
01:07.0 Ethernet controller: VIA Technologies, Inc. VT6105/VT6106S 
[Rhine-III] (rev 86)




--
 
This message has been verified by LastSpam (http://www.lastspam.com) eMail security service, provided by SoluLAN 
Ce courriel a ete verifie par le service de securite pour courriels LastSpam (http://www.lastspam.com), fourni par SoluLAN (http://www.solulan.com) 
www.solulan.com

