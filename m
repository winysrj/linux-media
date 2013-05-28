Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:2221 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933383Ab3E1I2Z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 May 2013 04:28:25 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: leo@lumanate.com, Mauro Carvalho Chehab <mchehab@redhat.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 2/3] hdpvr: code cleanup
Date: Tue, 28 May 2013 10:27:53 +0200
Message-Id: <1369729674-1802-3-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1369729674-1802-1-git-send-email-hverkuil@xs4all.nl>
References: <1369729674-1802-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Remove an unnecessary 'else' and invert a condition which makes the code
more readable.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/hdpvr/hdpvr-video.c |   54 ++++++++++++++++-----------------
 1 file changed, 27 insertions(+), 27 deletions(-)

diff --git a/drivers/media/usb/hdpvr/hdpvr-video.c b/drivers/media/usb/hdpvr/hdpvr-video.c
index 81018c4..e947105 100644
--- a/drivers/media/usb/hdpvr/hdpvr-video.c
+++ b/drivers/media/usb/hdpvr/hdpvr-video.c
@@ -281,43 +281,43 @@ static int hdpvr_start_streaming(struct hdpvr_device *dev)
 
 	if (dev->status == STATUS_STREAMING)
 		return 0;
-	else if (dev->status != STATUS_IDLE)
+	if (dev->status != STATUS_IDLE)
 		return -EAGAIN;
 
 	ret = get_video_info(dev, &vidinf);
+	if (ret) {
+		msleep(250);
+		v4l2_dbg(MSG_INFO, hdpvr_debug, &dev->v4l2_dev,
+				"no video signal at input %d\n", dev->options.video_input);
+		return -EAGAIN;
+	}
 
-	if (!ret) {
-		v4l2_dbg(MSG_BUFFER, hdpvr_debug, &dev->v4l2_dev,
-			 "video signal: %dx%d@%dhz\n", vidinf.width,
-			 vidinf.height, vidinf.fps);
+	v4l2_dbg(MSG_BUFFER, hdpvr_debug, &dev->v4l2_dev,
+			"video signal: %dx%d@%dhz\n", vidinf.width,
+			vidinf.height, vidinf.fps);
 
-		/* start streaming 2 request */
-		ret = usb_control_msg(dev->udev,
-				      usb_sndctrlpipe(dev->udev, 0),
-				      0xb8, 0x38, 0x1, 0, NULL, 0, 8000);
-		v4l2_dbg(MSG_BUFFER, hdpvr_debug, &dev->v4l2_dev,
-			 "encoder start control request returned %d\n", ret);
-		if (ret < 0)
-			return ret;
+	/* start streaming 2 request */
+	ret = usb_control_msg(dev->udev,
+			usb_sndctrlpipe(dev->udev, 0),
+			0xb8, 0x38, 0x1, 0, NULL, 0, 8000);
+	v4l2_dbg(MSG_BUFFER, hdpvr_debug, &dev->v4l2_dev,
+			"encoder start control request returned %d\n", ret);
+	if (ret < 0)
+		return ret;
 
-		ret = hdpvr_config_call(dev, CTRL_START_STREAMING_VALUE, 0x00);
-		if (ret)
-			return ret;
+	ret = hdpvr_config_call(dev, CTRL_START_STREAMING_VALUE, 0x00);
+	if (ret)
+		return ret;
 
-		dev->status = STATUS_STREAMING;
+	dev->status = STATUS_STREAMING;
 
-		INIT_WORK(&dev->worker, hdpvr_transmit_buffers);
-		queue_work(dev->workqueue, &dev->worker);
+	INIT_WORK(&dev->worker, hdpvr_transmit_buffers);
+	queue_work(dev->workqueue, &dev->worker);
 
-		v4l2_dbg(MSG_BUFFER, hdpvr_debug, &dev->v4l2_dev,
-			 "streaming started\n");
+	v4l2_dbg(MSG_BUFFER, hdpvr_debug, &dev->v4l2_dev,
+			"streaming started\n");
 
-		return 0;
-	}
-	msleep(250);
-	v4l2_dbg(MSG_INFO, hdpvr_debug, &dev->v4l2_dev,
-		 "no video signal at input %d\n", dev->options.video_input);
-	return -EAGAIN;
+	return 0;
 }
 
 
-- 
1.7.10.4

