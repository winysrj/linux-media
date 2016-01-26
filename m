Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:34419 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007AbcAZJQB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 26 Jan 2016 04:16:01 -0500
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 1/2] [media] em28xx: fix implementation of s_stream
Date: Tue, 26 Jan 2016 07:14:55 -0200
Message-Id: <13d52fe40f1f7bbad49128e8ee6a2fe5e13dd18d.1453799688.git.mchehab@osg.samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On em28xx driver, s_stream subdev ops was not implemented
properly. It was used only to disable stream, never enabling it.
That was the root cause of the regression when we added support
for s_stream on tvp5150 driver.

With that, we can get rid of the changes on tvp5150 side,
e. g. changeset 47de9bf8931e ('[media] tvp5150: Fix breakage for serial usage').

Tested video output on em2820+tvp5150 on WinTV USB2 and
video and/or vbi output on em288x+tvp5150 on HVR 950.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 drivers/media/usb/em28xx/em28xx-video.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 0e86ff423c49..6a015e8e8655 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -196,7 +196,6 @@ static void em28xx_wake_i2c(struct em28xx *dev)
 	v4l2_device_call_all(v4l2_dev, 0, core,  reset, 0);
 	v4l2_device_call_all(v4l2_dev, 0, video, s_routing,
 			     INPUT(dev->ctl_input)->vmux, 0, 0);
-	v4l2_device_call_all(v4l2_dev, 0, video, s_stream, 0);
 }
 
 static int em28xx_colorlevels_set_default(struct em28xx *dev)
@@ -962,6 +961,9 @@ int em28xx_start_analog_streaming(struct vb2_queue *vq, unsigned int count)
 			f.type = V4L2_TUNER_ANALOG_TV;
 		v4l2_device_call_all(&v4l2->v4l2_dev,
 				     0, tuner, s_frequency, &f);
+
+		/* Enable video stream at TV decoder */
+		v4l2_device_call_all(&v4l2->v4l2_dev, 0, video, s_stream, 1);
 	}
 
 	v4l2->streaming_users++;
@@ -981,6 +983,9 @@ static void em28xx_stop_streaming(struct vb2_queue *vq)
 	res_free(dev, vq->type);
 
 	if (v4l2->streaming_users-- == 1) {
+		/* Disable video stream at TV decoder */
+		v4l2_device_call_all(&v4l2->v4l2_dev, 0, video, s_stream, 0);
+
 		/* Last active user, so shutdown all the URBS */
 		em28xx_uninit_usb_xfer(dev, EM28XX_ANALOG_MODE);
 	}
@@ -1013,6 +1018,9 @@ void em28xx_stop_vbi_streaming(struct vb2_queue *vq)
 	res_free(dev, vq->type);
 
 	if (v4l2->streaming_users-- == 1) {
+		/* Disable video stream at TV decoder */
+		v4l2_device_call_all(&v4l2->v4l2_dev, 0, video, s_stream, 0);
+
 		/* Last active user, so shutdown all the URBS */
 		em28xx_uninit_usb_xfer(dev, EM28XX_ANALOG_MODE);
 	}
-- 
2.5.0

