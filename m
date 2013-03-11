Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:2282 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754137Ab3CKLrC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Mar 2013 07:47:02 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Volokh Konstantin <volokh84@gmail.com>,
	Pete Eberlein <pete@sensoray.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 28/42] go7007: add log_status support.
Date: Mon, 11 Mar 2013 12:46:06 +0100
Message-Id: <5f728e5f0d938172330c4904636153eb1db01d9a.1363000605.git.hans.verkuil@cisco.com>
In-Reply-To: <1363002380-19825-1-git-send-email-hverkuil@xs4all.nl>
References: <1363002380-19825-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <38bc3cc42d0c021432afd29c2c1e22cf380b06e0.1363000605.git.hans.verkuil@cisco.com>
References: <38bc3cc42d0c021432afd29c2c1e22cf380b06e0.1363000605.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/go7007/go7007-v4l2.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/media/go7007/go7007-v4l2.c b/drivers/staging/media/go7007/go7007-v4l2.c
index 186a56b..d3eef8d 100644
--- a/drivers/staging/media/go7007/go7007-v4l2.c
+++ b/drivers/staging/media/go7007/go7007-v4l2.c
@@ -1188,6 +1188,14 @@ static int vidioc_s_frequency(struct file *file, void *priv,
 	return call_all(&go->v4l2_dev, tuner, s_frequency, f);
 }
 
+static int vidioc_log_status(struct file *file, void *priv)
+{
+	struct go7007 *go = ((struct go7007_file *) priv)->go;
+
+	v4l2_ctrl_log_status(file, priv);
+	return call_all(&go->v4l2_dev, core, log_status);
+}
+
 static int vidioc_cropcap(struct file *file, void *priv,
 					struct v4l2_cropcap *cropcap)
 {
@@ -1654,7 +1662,7 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 	.vidioc_cropcap           = vidioc_cropcap,
 	.vidioc_g_crop            = vidioc_g_crop,
 	.vidioc_s_crop            = vidioc_s_crop,
-	.vidioc_log_status        = v4l2_ctrl_log_status,
+	.vidioc_log_status        = vidioc_log_status,
 	.vidioc_subscribe_event   = v4l2_ctrl_subscribe_event,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
-- 
1.7.10.4

