Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63674 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754897Ab1KOLOL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Nov 2011 06:14:11 -0500
Received: by bke11 with SMTP id 11so7006706bke.19
        for <linux-media@vger.kernel.org>; Tue, 15 Nov 2011 03:14:10 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 15 Nov 2011 12:14:10 +0100
Message-ID: <CAGa-wNMx7DhppkBQNowuXBKwitkU3tCQYLzNJuhqx=ZcytcjVQ@mail.gmail.com>
Subject: PCTV 290e and 520e
From: Claus Olesen <ceolesen@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

PCTV 290e usb stick - locking issue
===================================
The locking issue with the 290e is not resolved as of
yesterdays auto update to kernel 3.1.1-1.fc16.i686.PAE on Fedora 16.
The symptoms are that no usb stick is usable unless the em28xx_dvb
module is manually unloaded and the 290e unplugged in that order.

PCTV 290e usb stick - dvb-c support
===================================
dvb-c is supported by the 290e (although not advertised)
according to stevekerrison.com/290e/, my tests with dvbviewer on windows and
dmesg on my Fedora 16 as follows (3rd line from the bottom)
[   79.119320] usb 2-3: new high speed USB device number 2 using ehci_hcd
[   79.234598] usb 2-3: New USB device found, idVendor=2013, idProduct=024f
[   79.234608] usb 2-3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[   79.234615] usb 2-3: Product: PCTV 290e
[   79.234622] usb 2-3: Manufacturer: PCTV Systems
[   79.234629] usb 2-3: SerialNumber: 00000006VEJQ
[   79.520459] em28xx: New device PCTV Systems PCTV 290e @ 480 Mbps
(2013:024f, interface 0, class 0)
[   79.520577] em28xx #0: chip ID is em28174
[   79.817101] em28xx #0: Identified as PCTV nanoStick T2 290e (card=78)
[   79.849274] Registered IR keymap rc-pinnacle-pctv-hd
[   79.849563] input: em28xx IR (em28xx #0) as
/devices/pci0000:00/0000:00:1d.7/usb2/2-3/rc/rc1/input19
[   79.850270] rc1: em28xx IR (em28xx #0) as
/devices/pci0000:00/0000:00:1d.7/usb2/2-3/rc/rc1
[   79.850950] em28xx #0: v4l2 driver version 0.1.3
[   79.855863] em28xx #0: V4L2 video device registered as video1
[   79.856426] usbcore: registered new interface driver em28xx
[   79.856428] em28xx driver loaded
[   79.864584] tda18271 18-0060: creating new instance
[   79.866825] TDA18271HD/C2 detected @ 18-0060
[   80.031337] tda18271 18-0060: attaching existing instance
[   80.031340] DVB: registering new adapter (em28xx #0)
[   80.031343] DVB: registering adapter 0 frontend 0 (Sony CXD2820R
(DVB-T/T2))...
[   80.031579] DVB: registering adapter 0 frontend 1 (Sony CXD2820R (DVB-C))...
[   80.034136] em28xx #0: Successfully loaded em28xx-dvb
[   80.034142] Em28xx: Initialized (Em28xx dvb Extension) extension

but not by the latest kernel 3.1.1-1.fc16.i686.PAE of Fedora 16
as the command
find /dev/dvb
outputs
/dev/dvb
/dev/dvb/adapter0
/dev/dvb/adapter0/net0
/dev/dvb/adapter0/dvr0
/dev/dvb/adapter0/demux0
/dev/dvb/adapter0/frontend1
/dev/dvb/adapter0/frontend0
showing all the index-0 (dvb-t) devices but mostly no index-1 (dvb-c) devices

Does anyone know of an intent to add support for dvb-c from the PCTV
290e? in the near future?

PCTV 520e usb stick - dvb-c support
===================================
The 520e supports dvb-c in addition to dvb-t.
Does anyone know of an intent to add support for (dvb-c in particular
from) the 520e? in the near
future?

PCTV 290e and 520e usb sticks - compared
========================================
The 520e applies tda18271 according to
www.mail-archive.com/linux-media@vger.kernel.org/msg38091.html
as also applied by the 290e hinting perhaps that the 290e and 520e are
very alike.

Does that mean that dvb-c support if added for the 520e also will apply to the
290e? thereby making the 290e a better deal as it also supports dvb-t2?

dvb-c usb stick
===============
Does anyone know of any other dvb-c usb sticks that works on Linux
aside from those listed on linuxtv.org/wiki/index.php/DVB-C_USB_Devices?
