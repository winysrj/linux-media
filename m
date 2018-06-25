Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:42921 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755094AbeFYKWB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Jun 2018 06:22:01 -0400
MIME-Version: 1.0
Message-ID: <trinity-55d2d67c-cd7f-4b5e-ac9e-24b8f5080570-1529922119674@3c-app-gmx-bs15>
From: "Robert Schlabbach" <Robert.Schlabbach@gmx.net>
To: linux-media@vger.kernel.org
Subject: [PATCH] em28xx: fix dual transport stream capture hanging
Content-Type: text/plain; charset=UTF-8
Date: Mon, 25 Jun 2018 12:21:59 +0200
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On my Marvell Kirkwood system with a Hauppauge WinTV dualHD USB, trying
to use both tuners at the same time always resulted in the device not
delivering any stream at all anymore, no matter in which order the
tuners were started.

I tracked this down to the usb_set_interface() call in the function
em28xx_start_streaming() in em28xx_dvb.c. This call appears to be
superfluous, as the alternate setting is already set in
em28xx_dvb_init(). But even more importantly, this call is in violation
of the USB API, which states for usb_set_interface():

"Also, drivers must not change altsettings while urbs are scheduled for
endpoints in that interface; all such urbs must first be completed
(perhaps forced by unlinking)."

As URBs _are_ scheduled when a transport stream capture is already
running, this call must not be made.

This patch removes the call, which makes the dual transport stream
capture work for me.

Signed-off-by: Robert Schlabbach <Robert.Schlabbach@gmx.net>
---
 drivers/media/usb/em28xx/em28xx-dvb.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index b778d8a1..13c57dbc 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -199,7 +199,6 @@ static int em28xx_start_streaming(struct em28xx_dvb *dvb)
 	int rc;
 	struct em28xx_i2c_bus *i2c_bus = dvb->adapter.priv;
 	struct em28xx *dev = i2c_bus->dev;
-	struct usb_device *udev = interface_to_usbdev(dev->intf);
 	int dvb_max_packet_size, packet_multiplier, dvb_alt;
 
 	if (dev->dvb_xfer_bulk) {
@@ -218,7 +217,6 @@ static int em28xx_start_streaming(struct em28xx_dvb *dvb)
 		dvb_alt = dev->dvb_alt_isoc;
 	}
 
-	usb_set_interface(udev, dev->ifnum, dvb_alt);
 	rc = em28xx_set_mode(dev, EM28XX_DIGITAL_MODE);
 	if (rc < 0)
 		return rc;
-- 
2.17.1
