Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:1502 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970Ab2A0Th6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Jan 2012 14:37:58 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 2/2] vivi: use v4l2_ctrl_subscribe_event.
Date: Fri, 27 Jan 2012 20:37:47 +0100
Message-Id: <b68d33f07fb777e5eb016ecbe5c5ff8fdd762027.1327692974.git.hans.verkuil@cisco.com>
In-Reply-To: <1327693067-31914-1-git-send-email-hverkuil@xs4all.nl>
References: <1327693067-31914-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <d337d3b894c22440382a14ea002755e4c8ed247f.1327692974.git.hans.verkuil@cisco.com>
References: <d337d3b894c22440382a14ea002755e4c8ed247f.1327692974.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/video/vivi.c |   13 +------------
 1 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/drivers/media/video/vivi.c b/drivers/media/video/vivi.c
index cef8c91..28d7112 100644
--- a/drivers/media/video/vivi.c
+++ b/drivers/media/video/vivi.c
@@ -1001,17 +1001,6 @@ static int vidioc_s_input(struct file *file, void *priv, unsigned int i)
 	return 0;
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
 /* --- controls ---------------------------------------------- */
 
 static int vivi_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
@@ -1203,7 +1192,7 @@ static const struct v4l2_ioctl_ops vivi_ioctl_ops = {
 	.vidioc_streamon      = vidioc_streamon,
 	.vidioc_streamoff     = vidioc_streamoff,
 	.vidioc_log_status    = v4l2_ctrl_log_status,
-	.vidioc_subscribe_event = vidioc_subscribe_event,
+	.vidioc_subscribe_event = v4l2_ctrl_subscribe_event,
 	.vidioc_unsubscribe_event = v4l2_event_unsubscribe,
 };
 
-- 
1.7.8.3

