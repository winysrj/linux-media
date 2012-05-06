Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:4019 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446Ab2EFM2m (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 6 May 2012 08:28:42 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv2 PATCH 06/17] gspca: add support for control events.
Date: Sun,  6 May 2012 14:28:20 +0200
Message-Id: <6f5d62ab4b8cfd3f5fd54637962bbcd3618abeff.1336305565.git.hans.verkuil@cisco.com>
In-Reply-To: <1336307311-10227-1-git-send-email-hverkuil@xs4all.nl>
References: <1336307311-10227-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <a5a075c580858f4484be5c4cfadd195492858505.1336305565.git.hans.verkuil@cisco.com>
References: <a5a075c580858f4484be5c4cfadd195492858505.1336305565.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/gspca/gspca.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/video/gspca/gspca.c b/drivers/media/video/gspca/gspca.c
index 1d76504..b2ddfc6 100644
--- a/drivers/media/video/gspca/gspca.c
+++ b/drivers/media/video/gspca/gspca.c
@@ -40,6 +40,7 @@
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-ctrls.h>
 #include <media/v4l2-fh.h>
+#include <media/v4l2-event.h>
 
 #include "gspca.h"
 
@@ -2158,6 +2159,7 @@ static unsigned int dev_poll(struct file *file, poll_table *wait)
 		ret = POLLIN | POLLRDNORM;	/* yes */
 	else
 		ret = 0;
+	ret |= v4l2_ctrl_poll(file, wait);
 	mutex_unlock(&gspca_dev->queue_lock);
 	if (!gspca_dev->present)
 		return POLLHUP;
@@ -2269,6 +2271,8 @@ static const struct v4l2_ioctl_ops dev_ioctl_ops = {
 	.vidioc_s_register	= vidioc_s_register,
 #endif
 	.vidioc_g_chip_ident	= vidioc_g_chip_ident,
+	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
+	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
 
 static const struct video_device gspca_template = {
-- 
1.7.10

