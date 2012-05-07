Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21277 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757598Ab2EGTUh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 May 2012 15:20:37 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: hverkuil@xs4all.nl, Hans Verkuil <hans.verkuil@cisco.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 07/23] gspca: add support for control events.
Date: Mon,  7 May 2012 21:01:18 +0200
Message-Id: <1336417294-4566-8-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1336417294-4566-1-git-send-email-hdegoede@redhat.com>
References: <1336417294-4566-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/media/video/gspca/gspca.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/video/gspca/gspca.c b/drivers/media/video/gspca/gspca.c
index 979398b..48e4d34 100644
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

