Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:57337 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750895AbcGDIfY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Jul 2016 04:35:24 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 04/14] pvrusb2: use v4l2_s_ctrl instead of the s_ctrl op.
Date: Mon,  4 Jul 2016 10:35:00 +0200
Message-Id: <1467621310-8203-5-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1467621310-8203-1-git-send-email-hverkuil@xs4all.nl>
References: <1467621310-8203-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This op is deprecated and should not be used anymore.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/pvrusb2/pvrusb2-hdw.c b/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
index 83e9a3e..fe20fe4 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
@@ -2856,11 +2856,15 @@ static void pvr2_subdev_set_control(struct pvr2_hdw *hdw, int id,
 				    const char *name, int val)
 {
 	struct v4l2_control ctrl;
+	struct v4l2_subdev *sd;
+
 	pvr2_trace(PVR2_TRACE_CHIPS, "subdev v4l2 %s=%d", name, val);
 	memset(&ctrl, 0, sizeof(ctrl));
 	ctrl.id = id;
 	ctrl.value = val;
-	v4l2_device_call_all(&hdw->v4l2_dev, 0, core, s_ctrl, &ctrl);
+
+	v4l2_device_for_each_subdev(sd, &hdw->v4l2_dev)
+		v4l2_s_ctrl(NULL, sd->ctrl_handler, &ctrl);
 }
 
 #define PVR2_SUBDEV_SET_CONTROL(hdw, id, lab) \
-- 
2.8.1

