Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:64834 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751236Ab2CYLyw (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Mar 2012 07:54:52 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 02/10] media/radio: use v4l2_ctrl_subscribe_event where possible
Date: Sun, 25 Mar 2012 13:56:42 +0200
Message-Id: <1332676610-14953-3-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1332676610-14953-1-git-send-email-hdegoede@redhat.com>
References: <1332676610-14953-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/media/radio/radio-isa.c   |   10 +---------
 drivers/media/radio/radio-keene.c |   14 +-------------
 2 files changed, 2 insertions(+), 22 deletions(-)

diff --git a/drivers/media/radio/radio-isa.c b/drivers/media/radio/radio-isa.c
index 06f9063..1346046 100644
--- a/drivers/media/radio/radio-isa.c
+++ b/drivers/media/radio/radio-isa.c
@@ -150,14 +150,6 @@ static int radio_isa_log_status(struct file *file, void *priv)
 	return 0;
 }
 
-static int radio_isa_subscribe_event(struct v4l2_fh *fh,
-				struct v4l2_event_subscription *sub)
-{
-	if (sub->type == V4L2_EVENT_CTRL)
-		return v4l2_event_subscribe(fh, sub, 0);
-	return -EINVAL;
-}
-
 static const struct v4l2_ctrl_ops radio_isa_ctrl_ops = {
 	.s_ctrl = radio_isa_s_ctrl,
 };
@@ -177,7 +169,7 @@ static const struct v4l2_ioctl_ops radio_isa_ioctl_ops = {
 	.vidioc_g_frequency = radio_isa_g_frequency,
 	.vidioc_s_frequency = radio_isa_s_frequency,
 	.vidioc_log_status  = radio_isa_log_status,
-	.vidioc_subscribe_event   = radio_isa_subscribe_event,
+	.vidioc_subscribe_event   = v4l2_ctrl_subscribe_event,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
 
diff --git a/drivers/media/radio/radio-keene.c b/drivers/media/radio/radio-keene.c
index 55bd1d2..e1c72b0 100644
--- a/drivers/media/radio/radio-keene.c
+++ b/drivers/media/radio/radio-keene.c
@@ -256,18 +256,6 @@ static int keene_s_ctrl(struct v4l2_ctrl *ctrl)
 	return -EINVAL;
 }
 
-static int vidioc_subscribe_event(struct v4l2_fh *fh,
-				struct v4l2_event_subscription *sub)
-{
-	switch (sub->type) {
-	case V4L2_EVENT_CTRL:
-		return v4l2_event_subscribe(fh, sub, 0);
-	default:
-		return -EINVAL;
-	}
-}
-
-
 /* File system interface */
 static const struct v4l2_file_operations usb_keene_fops = {
 	.owner		= THIS_MODULE,
@@ -288,7 +276,7 @@ static const struct v4l2_ioctl_ops usb_keene_ioctl_ops = {
 	.vidioc_g_frequency = vidioc_g_frequency,
 	.vidioc_s_frequency = vidioc_s_frequency,
 	.vidioc_log_status = v4l2_ctrl_log_status,
-	.vidioc_subscribe_event = vidioc_subscribe_event,
+	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
 
-- 
1.7.9.3

