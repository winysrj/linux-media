Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:46548 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741Ab3CJOMv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Mar 2013 10:12:51 -0400
Received: by mail-la0-f52.google.com with SMTP id fs12so3091409lab.11
        for <linux-media@vger.kernel.org>; Sun, 10 Mar 2013 07:12:49 -0700 (PDT)
From: Volokh Konstantin <volokh84@gmail.com>
To: hverkuil@xs4all.nl, linux-media@vger.kernel.org
Cc: Volokh Konstantin <volokh84@gmail.com>
Subject: [PATCH 5/7] hverkuil/go7007: staging: media: go7007: Functionality for modet controls
Date: Sun, 10 Mar 2013 18:04:44 +0400
Message-Id: <1362924286-23995-5-git-send-email-volokh84@gmail.com>
In-Reply-To: <1362924286-23995-1-git-send-email-volokh84@gmail.com>
References: <1362924286-23995-1-git-send-email-volokh84@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The idea of modet controls through userspace is:
The first of all need select region number (0..3) (it value stores)
And then config thresolds (pixel,motion,trigger) for that region.
Also it`s available setup regions controls (each of 16x16 rects of the frame,
where detection will be approve).
In user space need only add/delete or clear some rect (set top,left,width,height)
and system automaticaly set up each 16x16 rects for that.
Clear buttom/menu clears all modet region for detection. (idle work)

Signed-off-by: Volokh Konstantin <volokh84@gmail.com>
---
 drivers/staging/media/go7007/go7007-priv.h |    9 ++-
 drivers/staging/media/go7007/go7007-v4l2.c |  120 ++++++++++++++++++++++++++++
 2 files changed, 128 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/media/go7007/go7007-priv.h b/drivers/staging/media/go7007/go7007-priv.h
index fc8aac4..36b271f 100644
--- a/drivers/staging/media/go7007/go7007-priv.h
+++ b/drivers/staging/media/go7007/go7007-priv.h
@@ -226,7 +226,14 @@ struct go7007 {
 	} modet[4];
 	unsigned char modet_map[1624];
 	unsigned char active_map[216];
-
+	struct { /* modet type control cluster */
+		struct v4l2_ctrl *modet_clip_left;
+		struct v4l2_ctrl *modet_clip_top;
+		struct v4l2_ctrl *modet_clip_width;
+		struct v4l2_ctrl *modet_clip_height;
+		struct v4l2_ctrl *modet_region_number;
+		//struct v4l2_ctrl *mpeg_video_b_frames;
+	};
 	/* Video streaming */
 	struct mutex queue_lock;
 	struct vb2_queue vidq;
diff --git a/drivers/staging/media/go7007/go7007-v4l2.c b/drivers/staging/media/go7007/go7007-v4l2.c
index c4d0ca2..7ea0ea1 100644
--- a/drivers/staging/media/go7007/go7007-v4l2.c
+++ b/drivers/staging/media/go7007/go7007-v4l2.c
@@ -1137,6 +1137,86 @@ static struct video_device go7007_template = {
 	.tvnorms	= V4L2_STD_ALL,
 };
 
+static void ClearModetMap(struct go7007 *go, char Region)
+{
+	/* Clear old region macroblocks */
+	int mbnum;
+
+	for (mbnum = 0; mbnum < sizeof(go->modet_map); ++mbnum)
+		if (go->modet_map[mbnum] == Region)
+			go->modet_map[mbnum] = 0;
+}
+
+static int RectToModetMap(struct go7007 *go,unsigned char Region,int Delete)
+{
+	register int x, y, mbnum;
+	struct v4l2_rect Rect;
+
+	Rect.left=v4l2_ctrl_g_ctrl(go->modet_clip_left);
+	Rect.top=v4l2_ctrl_g_ctrl(go->modet_clip_top);
+	Rect.width=v4l2_ctrl_g_ctrl(go->modet_clip_width);
+	Rect.height=v4l2_ctrl_g_ctrl(go->modet_clip_height);
+	/*!
+	 * Check if coordinates are OK and if any macroblocks are already
+	 * used by other regions (besides 0)
+	 */
+
+	if (Rect.left < 0 || (Rect.left & 0xF) || Rect.width <= 0 || (Rect.width & 0xF))
+		return -EINVAL;
+
+	if (Rect.left+Rect.width > go->width)
+		return -EINVAL;
+
+	if (Rect.top < 0 || (Rect.top & 0xF) || Rect.height <= 0 || (Rect.height & 0xF))
+		return -EINVAL;
+
+	if (Rect.top+Rect.height > go->height)
+		return -EINVAL;
+
+	for (y = 0; y < Rect.height; y += 16)
+		for (x = 0; x < Rect.width; x += 16) {
+			mbnum = (go->width>>4)*((Rect.top+y)>>4)+((Rect.left+x)>>4);
+		if (go->modet_map[mbnum] != 0 && go->modet_map[mbnum] != Region)
+			return -EBUSY;
+		else
+		go->modet_map[mbnum] = Delete ? 0 : Region;
+	}
+	return 0;
+}
+
+void go7007_md_ctrl_notify(struct v4l2_ctrl *ctrl, void *priv) {
+	struct go7007 *go=priv;
+	int reg_num=v4l2_ctrl_g_ctrl(go->modet_region_number);
+
+	switch(ctrl->id) {
+	case V4L2_CID_USER_MODET_PIXEL_THRESOLD:
+		go->modet[reg_num].pixel_threshold = v4l2_ctrl_g_ctrl(ctrl) >> 1;
+		break;
+	case V4L2_CID_USER_MODET_MOTION_THRESOLD:
+		go->modet[reg_num].motion_threshold = v4l2_ctrl_g_ctrl(ctrl) >> 1;
+		break;
+	case V4L2_CID_USER_MODET_TRIGGER:
+		go->modet[reg_num].mb_threshold = v4l2_ctrl_g_ctrl(ctrl) >> 1;
+		go->modet[reg_num].enable = v4l2_ctrl_g_ctrl(ctrl) > 0;
+		break;
+	case V4L2_CID_USER_MODET_REGION_CONTROL:
+		switch (v4l2_ctrl_g_ctrl(ctrl)) {
+		case rcAdd:
+			RectToModetMap(go, reg_num, 0);
+			break;
+		case rcDelete:
+			RectToModetMap(go, reg_num, 1);
+			break;
+		case rcClear:
+			ClearModetMap(go, reg_num);
+			break;
+		default:
+			break;
+		}
+		break;
+	}
+}
+
 static struct v4l2_ctrl_config md_configs[] = {
 	{
 		.ops = &go7007_ctrl_ops
@@ -1232,6 +1312,44 @@ static struct v4l2_ctrl_config md_configs[] = {
 	}
 };
 
+static int go7007_md_ctrl_init(struct go7007 *go)
+{
+	struct v4l2_ctrl_handler *hdl = &go->hdl;
+	struct v4l2_ctrl *ctrl;
+
+	go->modet_region_number = v4l2_ctrl_new_custom(hdl, &md_configs[0], go);
+
+	ctrl = v4l2_ctrl_new_custom(hdl, &md_configs[1], go);
+	if(ctrl)
+		v4l2_ctrl_notify(ctrl,go7007_md_ctrl_notify,go);
+
+	ctrl = v4l2_ctrl_new_custom(hdl, &md_configs[2], go);
+	if(ctrl)
+		v4l2_ctrl_notify(ctrl,go7007_md_ctrl_notify,go);
+
+	ctrl = v4l2_ctrl_new_custom(hdl, &md_configs[3], go);
+	if(ctrl)
+		v4l2_ctrl_notify(ctrl,go7007_md_ctrl_notify,go);
+
+	md_configs[4].max = go->width-1;
+	go->modet_clip_left = v4l2_ctrl_new_custom(hdl, &md_configs[4], go);
+
+	md_configs[5].max = go->height-1;
+	go->modet_clip_top = v4l2_ctrl_new_custom(hdl, &md_configs[5], go);
+
+	md_configs[6].max = go->width;
+	go->modet_clip_width = v4l2_ctrl_new_custom(hdl, &md_configs[6], go);
+
+	md_configs[7].max = go->height;
+	go->modet_clip_height = v4l2_ctrl_new_custom(hdl, &md_configs[7], go);
+
+	ctrl = v4l2_ctrl_new_custom(hdl, &md_configs[8], go);
+	if(ctrl)
+		v4l2_ctrl_notify(ctrl,go7007_md_ctrl_notify,go);
+
+	return 0;
+}
+
 int go7007_v4l2_ctrl_init(struct go7007 *go)
 {
 	struct v4l2_ctrl_handler *hdl = &go->hdl;
@@ -1268,6 +1386,8 @@ int go7007_v4l2_ctrl_init(struct go7007 *go)
 			V4L2_JPEG_ACTIVE_MARKER_DQT | V4L2_JPEG_ACTIVE_MARKER_DHT);
 	if (ctrl)
 		ctrl->flags |= V4L2_CTRL_FLAG_READ_ONLY;
+
+	go7007_md_ctrl_init(go);
 	if (hdl->error) {
 		rv = hdl->error;
 		v4l2_err(&go->v4l2_dev, "Could not register controls\n");
-- 
1.7.7.6

