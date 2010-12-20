Return-path: <mchehab@gaivota>
Received: from perceval.ideasonboard.com ([95.142.166.194]:51317 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932243Ab0LTLiE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Dec 2010 06:38:04 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com
Subject: [RFC/PATCH v4 4/7] v4l: Fix a use-before-set in the control framework
Date: Mon, 20 Dec 2010 12:37:52 +0100
Message-Id: <1292845075-7991-5-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1292845075-7991-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1292845075-7991-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

v4l2_queryctrl sets the step value based on the control type. That would
be fine if it used the control type stored in the V4L2 kernel control
object, not the one stored in the userspace ioctl structure that has
just been memset to 0. Fix this.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/video/v4l2-ctrls.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
index 9d2502c..5f74fec0 100644
--- a/drivers/media/video/v4l2-ctrls.c
+++ b/drivers/media/video/v4l2-ctrls.c
@@ -1338,7 +1338,7 @@ int v4l2_queryctrl(struct v4l2_ctrl_handler *hdl, struct v4l2_queryctrl *qc)
 	qc->minimum = ctrl->minimum;
 	qc->maximum = ctrl->maximum;
 	qc->default_value = ctrl->default_value;
-	if (qc->type == V4L2_CTRL_TYPE_MENU)
+	if (ctrl->type == V4L2_CTRL_TYPE_MENU)
 		qc->step = 1;
 	else
 		qc->step = ctrl->step;
-- 
1.7.2.2

