Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qk0-f174.google.com ([209.85.220.174]:36745 "EHLO
	mail-qk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753913AbbGCTPT (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Jul 2015 15:15:19 -0400
Received: by qkei195 with SMTP id i195so78334495qke.3
        for <linux-media@vger.kernel.org>; Fri, 03 Jul 2015 12:15:19 -0700 (PDT)
From: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
To: <linux-media@vger.kernel.org>, Hans Verkuil <hverkuil@xs4all.nl>
Cc: dale.hamel@srvthe.net, michael@stegemann.it,
	Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Subject: [PATCH v3 1/2] stk1160: Reduce driver verbosity
Date: Fri,  3 Jul 2015 16:11:41 -0300
Message-Id: <1435950702-2462-2-git-send-email-ezequiel@vanguardiasur.com.ar>
In-Reply-To: <1435950702-2462-1-git-send-email-ezequiel@vanguardiasur.com.ar>
References: <1435950702-2462-1-git-send-email-ezequiel@vanguardiasur.com.ar>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These messages are not really informational, and just makes the driver's
output too verbose. This commit changes some messages to a debug level,
removes a really useless "driver loaded" message and finally undefines
the DEBUG macro.

Signed-off-by: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
---
 drivers/media/usb/stk1160/stk1160-core.c |  5 +----
 drivers/media/usb/stk1160/stk1160-v4l.c  | 16 ++++++++--------
 drivers/media/usb/stk1160/stk1160.h      |  1 -
 3 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/media/usb/stk1160/stk1160-core.c b/drivers/media/usb/stk1160/stk1160-core.c
index 03504dc..1b6836f 100644
--- a/drivers/media/usb/stk1160/stk1160-core.c
+++ b/drivers/media/usb/stk1160/stk1160-core.c
@@ -162,7 +162,7 @@ static void stk1160_release(struct v4l2_device *v4l2_dev)
 {
 	struct stk1160 *dev = container_of(v4l2_dev, struct stk1160, v4l2_dev);
 
-	stk1160_info("releasing all resources\n");
+	stk1160_dbg("releasing all resources\n");
 
 	stk1160_i2c_unregister(dev);
 
@@ -363,9 +363,6 @@ static int stk1160_probe(struct usb_interface *interface,
 	dev->sd_saa7115 = v4l2_i2c_new_subdev(&dev->v4l2_dev, &dev->i2c_adap,
 		"saa7115_auto", 0, saa7113_addrs);
 
-	stk1160_info("driver ver %s successfully loaded\n",
-		STK1160_VERSION);
-
 	/* i2c reset saa711x */
 	v4l2_device_call_all(&dev->v4l2_dev, 0, core, reset, 0);
 	v4l2_device_call_all(&dev->v4l2_dev, 0, video, s_stream, 0);
diff --git a/drivers/media/usb/stk1160/stk1160-v4l.c b/drivers/media/usb/stk1160/stk1160-v4l.c
index 7291cca..b4b737b 100644
--- a/drivers/media/usb/stk1160/stk1160-v4l.c
+++ b/drivers/media/usb/stk1160/stk1160-v4l.c
@@ -136,7 +136,7 @@ static bool stk1160_set_alternate(struct stk1160 *dev)
 			dev->alt = i;
 	}
 
-	stk1160_info("setting alternate %d\n", dev->alt);
+	stk1160_dbg("setting alternate %d\n", dev->alt);
 
 	if (dev->alt != prev_alt) {
 		stk1160_dbg("minimum isoc packet size: %u (alt=%d)\n",
@@ -226,7 +226,7 @@ static void stk1160_stop_hw(struct stk1160 *dev)
 
 	/* set alternate 0 */
 	dev->alt = 0;
-	stk1160_info("setting alternate %d\n", dev->alt);
+	stk1160_dbg("setting alternate %d\n", dev->alt);
 	usb_set_interface(dev->udev, 0, 0);
 
 	/* Stop stk1160 */
@@ -540,8 +540,8 @@ static int queue_setup(struct vb2_queue *vq, const struct v4l2_format *v4l_fmt,
 
 	sizes[0] = size;
 
-	stk1160_info("%s: buffer count %d, each %ld bytes\n",
-			__func__, *nbuffers, size);
+	stk1160_dbg("%s: buffer count %d, each %ld bytes\n",
+		    __func__, *nbuffers, size);
 
 	return 0;
 }
@@ -625,8 +625,8 @@ void stk1160_clear_queue(struct stk1160 *dev)
 			struct stk1160_buffer, list);
 		list_del(&buf->list);
 		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
-		stk1160_info("buffer [%p/%d] aborted\n",
-				buf, buf->vb.v4l2_buf.index);
+		stk1160_dbg("buffer [%p/%d] aborted\n",
+			    buf, buf->vb.v4l2_buf.index);
 	}
 
 	/* It's important to release the current buffer */
@@ -635,8 +635,8 @@ void stk1160_clear_queue(struct stk1160 *dev)
 		dev->isoc_ctl.buf = NULL;
 
 		vb2_buffer_done(&buf->vb, VB2_BUF_STATE_ERROR);
-		stk1160_info("buffer [%p/%d] aborted\n",
-				buf, buf->vb.v4l2_buf.index);
+		stk1160_dbg("buffer [%p/%d] aborted\n",
+			    buf, buf->vb.v4l2_buf.index);
 	}
 	spin_unlock_irqrestore(&dev->buf_lock, flags);
 }
diff --git a/drivers/media/usb/stk1160/stk1160.h b/drivers/media/usb/stk1160/stk1160.h
index 3922a6c..72cc8e8 100644
--- a/drivers/media/usb/stk1160/stk1160.h
+++ b/drivers/media/usb/stk1160/stk1160.h
@@ -58,7 +58,6 @@
  * new drivers should use.
  *
  */
-#define DEBUG
 #ifdef DEBUG
 #define stk1160_dbg(fmt, args...) \
 	printk(KERN_DEBUG "stk1160: " fmt,  ## args)
-- 
2.4.3

