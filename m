Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:50036 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751097AbaIUO0g (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 21 Sep 2014 10:26:36 -0400
Received: from [192.168.1.21] ([79.215.138.24]) by mail.gmx.com (mrgmx002)
 with ESMTPSA (Nemesis) id 0MFdPZ-1XZH0J1ZmH-00Eh6Q for
 <linux-media@vger.kernel.org>; Sun, 21 Sep 2014 16:26:34 +0200
Message-ID: <541EE016.9030504@gmx.net>
Date: Sun, 21 Sep 2014 16:26:30 +0200
From: JPT <j-p-t@gmx.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Running Technisat DVB-S2 on ARM-NAS
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I want to turn my Netgear ReadyNAS RN104 into a VDR.
I already run a self made kernel 3.16.3) and plain debian on it.
For hardware and software details see http://natisbad.org/NAS3/

I recently compiled those DVB modules into the kernel.
And after a lot of struggle to get a clean build, I succeeded in loading
the modules:
dvb_usb_technisat_usb2, dvb_usb, dvb_core, stv090x, rc_core

but device recognition somehow does not fully work.

usb 2-1: new high-speed USB device number 3 using xhci_hcd
usb 2-1: New USB device found, idVendor=14f7, idProduct=0500
usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 2-1: Product: TechniSat USB device
usb 2-1: Manufacturer: TechniSat Digital
usb 2-1: SerialNumber: ************
technisat-usb2: set alternate setting
technisat-usb2: firmware version: 17.63
dvb-usb: found a 'Technisat SkyStar USB HD (DVB-S/S2)' in warm state.
dvb-usb: will pass the complete MPEG2 transport stream to the software
demuxer.
dvb-usb: Technisat SkyStar USB HD (DVB-S/S2) error while loading driver
(-12)
usbcore: registered new interface driver dvb_usb_technisat_usb2


How my I find out more about the error -12? It's a lot of wrapped
"return ret" in the code...
Is there any way of enabling more logging?

I believe it comes from the dvb-usb-technisat-usb2 module, but there is
no c file?

thanks.

Jan
