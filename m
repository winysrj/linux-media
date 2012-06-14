Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:47276 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756085Ab2FNR7b (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jun 2012 13:59:31 -0400
Received: by mail-gg0-f174.google.com with SMTP id u4so1627280ggl.19
        for <linux-media@vger.kernel.org>; Thu, 14 Jun 2012 10:59:31 -0700 (PDT)
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Mike Isely <isely@pobox.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org
Cc: Peter Senna Tschudin <peter.senna@gmail.com>
Subject: [PATCH 2/8] [RESEND] pvrusb2: Variables set but not used
Date: Thu, 14 Jun 2012 14:58:10 -0300
Message-Id: <1339696716-14373-2-git-send-email-peter.senna@gmail.com>
In-Reply-To: <1339696716-14373-1-git-send-email-peter.senna@gmail.com>
References: <1339696716-14373-1-git-send-email-peter.senna@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Tested by compilation only.

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
---
 drivers/media/video/pvrusb2/pvrusb2-v4l2.c |    8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/media/video/pvrusb2/pvrusb2-v4l2.c b/drivers/media/video/pvrusb2/pvrusb2-v4l2.c
index 7bddfae..cbe4080 100644
--- a/drivers/media/video/pvrusb2/pvrusb2-v4l2.c
+++ b/drivers/media/video/pvrusb2/pvrusb2-v4l2.c
@@ -226,13 +226,11 @@ static int pvr2_enum_input(struct file *file, void *priv, struct v4l2_input *vi)
 	struct v4l2_input tmp;
 	unsigned int cnt;
 	int val;
-	int ret;
 
 	cptr = pvr2_hdw_get_ctrl_by_id(hdw, PVR2_CID_INPUT);
 
 	memset(&tmp, 0, sizeof(tmp));
 	tmp.index = vi->index;
-	ret = 0;
 	if (vi->index >= fh->input_cnt)
 		return -EINVAL;
 	val = fh->input_map[vi->index];
@@ -556,9 +554,7 @@ static int pvr2_queryctrl(struct file *file, void *priv,
 	struct pvr2_hdw *hdw = fh->channel.mc_head->hdw;
 	struct pvr2_ctrl *cptr;
 	int val;
-	int ret;
 
-	ret = 0;
 	if (vc->id & V4L2_CTRL_FLAG_NEXT_CTRL) {
 		cptr = pvr2_hdw_get_ctrl_nextv4l(
 				hdw, (vc->id & ~V4L2_CTRL_FLAG_NEXT_CTRL));
@@ -705,11 +701,9 @@ static int pvr2_try_ext_ctrls(struct file *file, void *priv,
 	struct v4l2_ext_control *ctrl;
 	struct pvr2_ctrl *pctl;
 	unsigned int idx;
-	int ret;
 
 	/* For the moment just validate that the requested control
 	   actually exists. */
-	ret = 0;
 	for (idx = 0; idx < ctls->count; idx++) {
 		ctrl = ctls->controls + idx;
 		pctl = pvr2_hdw_get_ctrl_v4l(hdw, ctrl->id);
@@ -770,12 +764,10 @@ static int pvr2_s_crop(struct file *file, void *priv, struct v4l2_crop *crop)
 {
 	struct pvr2_v4l2_fh *fh = file->private_data;
 	struct pvr2_hdw *hdw = fh->channel.mc_head->hdw;
-	struct v4l2_cropcap cap;
 	int ret;
 
 	if (crop->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		return -EINVAL;
-	cap.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 	ret = pvr2_ctrl_set_value(
 			pvr2_hdw_get_ctrl_by_id(hdw, PVR2_CID_CROPL),
 			crop->c.left);
-- 
1.7.10.2

