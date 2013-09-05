Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:65118 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109Ab3IHP2P (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Sep 2013 11:28:15 -0400
Date: Thu, 5 Sep 2013 15:11:26 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
cc: =?ISO-8859-15?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH] em28xx: balance subdevice power-off calls
Message-ID: <Pine.LNX.4.64.1309051459261.785@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The em28xx USB driver powers off its subdevices, by calling their .s_power()
methods to save power, but actually never powers them on. Apparently this
works with currently used subdevice drivers, but is wrong and might break
with some other ones. This patch fixes this issue by adding required
.s_power() calls to turn subdevices on.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
---

Please, test - only compile tested due to lack of hardware

 drivers/media/usb/em28xx/em28xx-cards.c |    1 +
 drivers/media/usb/em28xx/em28xx-video.c |   17 ++++++++++-------
 2 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index dc65742..d2d3b06 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -3066,6 +3066,7 @@ static int em28xx_init_dev(struct em28xx *dev, struct usb_device *udev,
 	}
 
 	/* wake i2c devices */
+	v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_power, 1);
 	em28xx_wake_i2c(dev);
 
 	/* init video dma queues */
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 9d10334..283fa26 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -1589,15 +1589,18 @@ static int em28xx_v4l2_open(struct file *filp)
 	fh->type = fh_type;
 	filp->private_data = fh;
 
-	if (fh->type == V4L2_BUF_TYPE_VIDEO_CAPTURE && dev->users == 0) {
-		em28xx_set_mode(dev, EM28XX_ANALOG_MODE);
-		em28xx_resolution_set(dev);
+	if (dev->users == 0) {
+		v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_power, 1);
 
-		/* Needed, since GPIO might have disabled power of
-		   some i2c device
-		 */
-		em28xx_wake_i2c(dev);
+		if (fh->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
+			em28xx_set_mode(dev, EM28XX_ANALOG_MODE);
+			em28xx_resolution_set(dev);
 
+			/* Needed, since GPIO might have disabled power of
+			   some i2c device
+			*/
+			em28xx_wake_i2c(dev);
+		}
 	}
 
 	if (vdev->vfl_type == VFL_TYPE_RADIO) {
-- 
1.7.2.5

