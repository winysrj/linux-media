Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm7-vm3.bullet.mail.ne1.yahoo.com ([98.138.91.137]:42590 "EHLO
	nm7-vm3.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751429Ab3ERODO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 18 May 2013 10:03:14 -0400
Message-ID: <1368885792.49179.YahooMailNeo@web120301.mail.ne1.yahoo.com>
Date: Sat, 18 May 2013 07:03:12 -0700 (PDT)
From: Chris Rankin <rankincj@yahoo.com>
Reply-To: Chris Rankin <rankincj@yahoo.com>
Subject: [3.9.2] Broken IR with em28xx?
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Further to my original email, here is the dmesg log from 3.9.2 when inserting my 290e adapter:


[ 1273.581835] usb 10-4: new high-speed USB device number 6 using ehci-pci
[ 1273.704508] em28xx: New device PCTV Systems PCTV 290e @ 480 Mbps (2013:024f, interface 0, class 0)
[ 1273.712167] em28xx: DVB interface 0 found: isoc
[ 1273.715540] em28xx: chip ID is em28174
[ 1274.011883] em28174 #0: Identified as PCTV nanoStick T2 290e (card=78)
[ 1274.017111] em28174 #0: v4l2 driver version 0.1.3
[ 1274.025554] em28174 #0: V4L2 video device registered as video0
[ 1274.030093] em28174 #0: dvb set to isoc mode.
[ 1274.037116] tda18271 6-0060: creating new instance
[ 1274.045237] TDA18271HD/C2 detected @ 6-0060
[ 1274.216011] DVB: registering new adapter (em28174 #0)
[ 1274.219769] usb 10-4: DVB: registering adapter 0 frontend 0 (Sony CXD2820R)...
[ 1274.226240] em28174 #0: Successfully loaded em28xx-dvb
[ 1274.230632] Registered IR keymap rc-pinnacle-pctv-hd
[ 1274.234529] input: em28xx IR (em28174 #0) as /devices/pci0000:00/0000:00:1d.7/usb10/10-4/rc/rc1/input18
[ 1274.235704] ir-keytable[4661]: segfault at 0 ip 0000000000401cc0 sp 00007fff26dae550 error 4 in ir-keytable[400000+8000]
[ 1274.252304] rc1: em28xx IR (em28174 #0) as /devices/pci0000:00/0000:00:1d.7/usb10/10-4/rc/rc1
[ 1334.876948] tda18271: performing RF tracking filter calibration
[ 1337.231439] tda18271: RF tracking filter calibration complete

The ir-keytable segfault is a userspace error that predates the 3.9.x kernel. Reloading the IR keys manually seems OK:

# ir-keytable --auto-load /etc/rc_maps.cfg  --sysdev=rc1
Old keytable cleared
Wrote 45 keycode(s) to driver
Protocols changed to other 


VDR behaves as if it's just not receiving any events, although as I said, the 3.8.x kernels are OK.


Cheers,
Chris

