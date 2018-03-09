Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:39650 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750898AbeCIMVv (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 9 Mar 2018 07:21:51 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Brad Love <brad@nextdimension.cc>
Subject: [PATCH] media: em28xx: fix a regression with HVR-950
Date: Fri,  9 Mar 2018 09:21:45 -0300
Message-Id: <41857a8224110ed8044d5fbbdded8998129e5d7e.1520598094.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Changeset be7fd3c3a8c5 ("media: em28xx: Hauppauge DualHD second tuner
functionality") removed the logic with sets the alternate for the DVB
device. Without setting the right alternate, the device won't be
able to submit URBs, and userspace fails with -EMSGSIZE:

	ERROR     DMX_SET_PES_FILTER failed (PID = 0x2000): 90 Message too long

Tested with Hauppauge HVR-950 model A1C0.

Cc: Brad Love <brad@nextdimension.cc>
Fixes: be7fd3c3a8c5 ("media: em28xx: Hauppauge DualHD second tuner functionality")
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/usb/em28xx/em28xx-dvb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index a54cb8dc52c9..2ce7de1c7cce 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -199,6 +199,7 @@ static int em28xx_start_streaming(struct em28xx_dvb *dvb)
 	int rc;
 	struct em28xx_i2c_bus *i2c_bus = dvb->adapter.priv;
 	struct em28xx *dev = i2c_bus->dev;
+	struct usb_device *udev = interface_to_usbdev(dev->intf);
 	int dvb_max_packet_size, packet_multiplier, dvb_alt;
 
 	if (dev->dvb_xfer_bulk) {
@@ -217,6 +218,7 @@ static int em28xx_start_streaming(struct em28xx_dvb *dvb)
 		dvb_alt = dev->dvb_alt_isoc;
 	}
 
+	usb_set_interface(udev, dev->ifnum, dvb_alt);
 	rc = em28xx_set_mode(dev, EM28XX_DIGITAL_MODE);
 	if (rc < 0)
 		return rc;
-- 
2.14.3
