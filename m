Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:4862 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753834Ab2D1PKI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Apr 2012 11:10:08 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>,
	Jean-Francois Moine <moinejf@free.fr>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [RFCv1 PATCH 6/7] gspca: add support for control events.
Date: Sat, 28 Apr 2012 17:09:55 +0200
Message-Id: <3f377d04e054457694e15cf8b691d889e7dd36e2.1335625085.git.hans.verkuil@cisco.com>
In-Reply-To: <1335625796-9429-1-git-send-email-hverkuil@xs4all.nl>
References: <1335625796-9429-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <ea7e986dc0fa18da12c22048e9187e9933191d3d.1335625085.git.hans.verkuil@cisco.com>
References: <ea7e986dc0fa18da12c22048e9187e9933191d3d.1335625085.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/gspca/gspca.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/video/gspca/gspca.c b/drivers/media/video/gspca/gspca.c
index 3d3b780..7b03f36 100644
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

