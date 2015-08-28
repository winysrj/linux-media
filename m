Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:43934 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751898AbbH1Ltf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Aug 2015 07:49:35 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: stoth@kernellabs.com, ricardo.ribalda@gmail.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCHv2 4/8] saa7164: add support for control events
Date: Fri, 28 Aug 2015 13:48:29 +0200
Message-Id: <1440762513-30457-5-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1440762513-30457-1-git-send-email-hverkuil@xs4all.nl>
References: <1440762513-30457-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Now that saa7164 uses v4l2_fh and that poll() has been fixed, it is
trivial to add support for control events.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Tested-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/saa7164/saa7164-encoder.c | 8 ++++++--
 drivers/media/pci/saa7164/saa7164.h         | 1 +
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/saa7164/saa7164-encoder.c b/drivers/media/pci/saa7164/saa7164-encoder.c
index fd32fa0..3bd76c4 100644
--- a/drivers/media/pci/saa7164/saa7164-encoder.c
+++ b/drivers/media/pci/saa7164/saa7164-encoder.c
@@ -919,7 +919,7 @@ static unsigned int fops_poll(struct file *file, poll_table *wait)
 	struct saa7164_encoder_fh *fh =
 		(struct saa7164_encoder_fh *)file->private_data;
 	struct saa7164_port *port = fh->port;
-	unsigned int mask = 0;
+	unsigned int mask = v4l2_ctrl_poll(file, wait);
 
 	port->last_poll_msecs_diff = port->last_poll_msecs;
 	port->last_poll_msecs = jiffies_to_msecs(jiffies);
@@ -935,7 +935,7 @@ static unsigned int fops_poll(struct file *file, poll_table *wait)
 	if (atomic_cmpxchg(&fh->v4l_reading, 0, 1) == 0) {
 		if (atomic_inc_return(&port->v4l_reader_count) == 1) {
 			if (saa7164_encoder_initialize(port) < 0)
-				return POLLERR;
+				return mask | POLLERR;
 			saa7164_encoder_start_streaming(port);
 			msleep(200);
 		}
@@ -976,6 +976,10 @@ static const struct v4l2_ioctl_ops mpeg_ioctl_ops = {
 	.vidioc_g_fmt_vid_cap	 = vidioc_g_fmt_vid_cap,
 	.vidioc_try_fmt_vid_cap	 = vidioc_try_fmt_vid_cap,
 	.vidioc_s_fmt_vid_cap	 = vidioc_s_fmt_vid_cap,
+	.vidioc_s_fmt_vid_cap	 = vidioc_s_fmt_vid_cap,
+	.vidioc_log_status	 = v4l2_ctrl_log_status,
+	.vidioc_subscribe_event  = v4l2_ctrl_subscribe_event,
+	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
 
 static struct video_device saa7164_mpeg_template = {
diff --git a/drivers/media/pci/saa7164/saa7164.h b/drivers/media/pci/saa7164/saa7164.h
index 05707e3..1d8e95d 100644
--- a/drivers/media/pci/saa7164/saa7164.h
+++ b/drivers/media/pci/saa7164/saa7164.h
@@ -65,6 +65,7 @@
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-device.h>
 #include <media/v4l2-ctrls.h>
+#include <media/v4l2-event.h>
 
 #include "saa7164-reg.h"
 #include "saa7164-types.h"
-- 
2.1.4

