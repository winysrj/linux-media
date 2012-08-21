Return-path: <linux-media-owner@vger.kernel.org>
Received: from ppsw-51.csi.cam.ac.uk ([131.111.8.151]:39142 "EHLO
	ppsw-51.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165Ab2HUOYa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Aug 2012 10:24:30 -0400
Received: from mpf30.sp.phy.cam.ac.uk ([131.111.73.200]:29507 helo=FexBox)
	by ppsw-51.csi.cam.ac.uk (smtp.hermes.cam.ac.uk [131.111.8.158]:465)
	with esmtpsa (LOGIN:mpf30) (TLSv1:AES128-SHA:128)
	id 1T3pNd-00065M-Yw (Exim 4.72) for linux-media@vger.kernel.org
	(return-path <mpf30@cam.ac.uk>); Tue, 21 Aug 2012 15:24:29 +0100
From: "M. Fletcher" <mpf30@cam.ac.uk>
To: <linux-media@vger.kernel.org>
References: 
In-Reply-To: 
Subject: RE: Unable to load dvb-usb-rtl2832u driver in Ubuntu 12.04
Date: Tue, 21 Aug 2012 15:24:43 +0100
Message-ID: <00d701cd7fa8$b592c320$20b84960$@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Language: en-gb
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I am trying to setup a Compro U680F USB DVB-T adaptor in Ubuntu 12.04
(kernel
3.2.0-29-generic).

The compro device ID is given (lsusb) as 185b:0680. The following page
suggests
this device is supported by the RT2832U driver:
http://www.dfragos.me/2011/11/installation-of-the-rt2832u-driver-in-linux/

I successfully built the v4l-dvb package from source following this how to,
using the "Basic Approach": 
http://linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4L-DVB_D
evice_Drivers

After restarting the system the device does not appear to be working. The
output from "lsmod | grep dvb" is as follows:

root@DCTbox:/home/dct# lsmod | grep dvb
dvb_usb                32369  0 
dvb_core              110590  1 dvb_usb
rc_core                26343  1 dvb_usb


If I unplug the device and plug back in, I get the following from "dmesg |
tail":

root@DCTbox:/home/dct# dmesg | tail -n 27
[  160.015155] usb 5-2: new high-speed USB device number 4 using xhci_hcd
[  160.051152] usb 5-2: ep 0x81 - rounding interval to 32768 microframes, ep
desc says 0 microframes
[  160.133825] WARNING: You are using an experimental version of the media
stack.
[  160.133826]     As the driver is backported to an older kernel, it
doesn't
offer
[  160.133827]     enough quality for its usage in production.
[  160.133828]     Use it with care.
[  160.133829] Latest git patches (needed if you report a bug to
linux-media@vger.kernel.org):
[  160.133830]     9b78c5a3007e10a172d4e83bea18509fdff2e8e3 [media] b2c2:
export b2c2_flexcop_debug symbol
[  160.133832]     88f8472c9fc6c08f5113887471f1f4aabf7b2929 [media] Fix some
Makefile rules
[  160.133833]     893430558e5bf116179915de2d3d119ad25c01cf [media]
cx23885-cards: fix netup card default revision
[  160.144374] WARNING: You are using an experimental version of the media
stack.
[  160.144376]     As the driver is backported to an older kernel, it
doesn't
offer
[  160.144377]     enough quality for its usage in production.
[  160.144378]     Use it with care.
[  160.144379] Latest git patches (needed if you report a bug to
linux-media@vger.kernel.org):
[  160.144380]     9b78c5a3007e10a172d4e83bea18509fdff2e8e3 [media] b2c2:
export b2c2_flexcop_debug symbol
[  160.144381]     88f8472c9fc6c08f5113887471f1f4aabf7b2929 [media] Fix some
Makefile rules
[  160.144383]     893430558e5bf116179915de2d3d119ad25c01cf [media]
cx23885-cards: fix netup card default revision
[  160.173311] dvb_usb_rtl2832u: disagrees about version of symbol
dvb_usb_device_init
[  160.173315] dvb_usb_rtl2832u: Unknown symbol dvb_usb_device_init (err
-22)
[  392.860811] dvb_usb_rtl2832u: disagrees about version of symbol
dvb_usb_device_init
[  392.860815] dvb_usb_rtl2832u: Unknown symbol dvb_usb_device_init (err
-22)
[ 1282.328055] usb 5-2: USB disconnect, device number 4
[ 1288.697208] usb 5-2: new high-speed USB device number 5 using xhci_hcd
[ 1288.732785] usb 5-2: ep 0x81 - rounding interval to 32768 microframes, ep
desc says 0 microframes
[ 1288.747585] dvb_usb_rtl2832u: disagrees about version of symbol
dvb_usb_device_init
[ 1288.747589] dvb_usb_rtl2832u: Unknown symbol dvb_usb_device_init (err
-22)



If I attempt to load the driver manually I get the following error message:

root@DCTbox:/home/dct# modprobe dvb_usb_rtl2832u
FATAL: Error inserting dvb_usb_rtl2832u
(/lib/modules/3.2.0-29-generic/kernel/drivers/media/dvb/dvb-usb/dvb-usb-rtl2
832u.ko):
Invalid argument



Any advice on how to get this device working successfully would be greatly
appreciated.

Kind regards,
Marc


