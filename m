Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-vb0-f45.google.com ([209.85.212.45]:34833 "EHLO
	mail-vb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754865Ab3ADVAB (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 4 Jan 2013 16:00:01 -0500
Received: by mail-vb0-f45.google.com with SMTP id p1so17128666vbi.32
        for <linux-media@vger.kernel.org>; Fri, 04 Jan 2013 13:00:00 -0800 (PST)
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: linux-media@vger.kernel.org
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 08/15] em28xx: add support for control events.
Date: Fri,  4 Jan 2013 15:59:38 -0500
Message-Id: <1357333186-8466-9-git-send-email-dheitmueller@kernellabs.com>
In-Reply-To: <1357333186-8466-1-git-send-email-dheitmueller@kernellabs.com>
References: <1357333186-8466-1-git-send-email-dheitmueller@kernellabs.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
---
 drivers/media/usb/em28xx/em28xx-video.c |   38 +++++++++++++++++++++----------
 1 file changed, 26 insertions(+), 12 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index c67ff8d..acdb434 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -40,6 +40,7 @@
 #include "em28xx.h"
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
+#include <media/v4l2-event.h>
 #include <media/v4l2-chip-ident.h>
 #include <media/msp3400.h>
 #include <media/tuner.h>
@@ -1927,24 +1928,33 @@ em28xx_v4l2_read(struct file *filp, char __user *buf, size_t count,
 static unsigned int em28xx_poll(struct file *filp, poll_table *wait)
 {
 	struct em28xx_fh *fh = filp->private_data;
+	unsigned long req_events = poll_requested_events(wait);
 	struct em28xx *dev = fh->dev;
+	unsigned int res = 0;
 	int rc;
 
 	rc = check_dev(dev);
 	if (rc < 0)
-		return rc;
-
-	if (fh->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
-		if (!res_get(fh, EM28XX_RESOURCE_VIDEO))
-			return POLLERR;
-		return videobuf_poll_stream(filp, &fh->vb_vidq, wait);
-	} else if (fh->type == V4L2_BUF_TYPE_VBI_CAPTURE) {
-		if (!res_get(fh, EM28XX_RESOURCE_VBI))
-			return POLLERR;
-		return videobuf_poll_stream(filp, &fh->vb_vbiq, wait);
-	} else {
-		return POLLERR;
+		return DEFAULT_POLLMASK;
+
+	if (v4l2_event_pending(&fh->fh))
+		res = POLLPRI;
+	else if (req_events & POLLPRI)
+		poll_wait(filp, &fh->fh.wait, wait);
+
+	if (req_events & (POLLIN | POLLRDNORM)) {
+		if (fh->type == V4L2_BUF_TYPE_VIDEO_CAPTURE) {
+			if (!res_get(fh, EM28XX_RESOURCE_VIDEO))
+				return res | POLLERR;
+			return videobuf_poll_stream(filp, &fh->vb_vidq, wait);
+		}
+		if (fh->type == V4L2_BUF_TYPE_VBI_CAPTURE) {
+			if (!res_get(fh, EM28XX_RESOURCE_VBI))
+				return res | POLLERR;
+			return res | videobuf_poll_stream(filp, &fh->vb_vbiq, wait);
+		}
 	}
+	return res;
 }
 
 static unsigned int em28xx_v4l2_poll(struct file *filp, poll_table *wait)
@@ -2032,6 +2042,8 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_s_tuner             = vidioc_s_tuner,
 	.vidioc_g_frequency         = vidioc_g_frequency,
 	.vidioc_s_frequency         = vidioc_s_frequency,
+	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
+	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.vidioc_g_register          = vidioc_g_register,
 	.vidioc_s_register          = vidioc_s_register,
@@ -2061,6 +2073,8 @@ static const struct v4l2_ioctl_ops radio_ioctl_ops = {
 	.vidioc_s_tuner       = radio_s_tuner,
 	.vidioc_g_frequency   = vidioc_g_frequency,
 	.vidioc_s_frequency   = vidioc_s_frequency,
+	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
+	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 #ifdef CONFIG_VIDEO_ADV_DEBUG
 	.vidioc_g_register    = vidioc_g_register,
 	.vidioc_s_register    = vidioc_s_register,
-- 
1.7.9.5

