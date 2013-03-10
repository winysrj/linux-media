Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:54103 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741Ab3CJOM2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Mar 2013 10:12:28 -0400
Received: by mail-la0-f52.google.com with SMTP id fs12so3019449lab.25
        for <linux-media@vger.kernel.org>; Sun, 10 Mar 2013 07:12:27 -0700 (PDT)
From: Volokh Konstantin <volokh84@gmail.com>
To: hverkuil@xs4all.nl, linux-media@vger.kernel.org
Cc: Volokh Konstantin <volokh84@gmail.com>
Subject: [PATCH 4/7] hverkuil/go7007: staging: media: go7007: Add Modet controls
Date: Sun, 10 Mar 2013 18:04:43 +0400
Message-Id: <1362924286-23995-4-git-send-email-volokh84@gmail.com>
In-Reply-To: <1362924286-23995-1-git-send-email-volokh84@gmail.com>
References: <1362924286-23995-1-git-send-email-volokh84@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Volokh Konstantin <volokh84@gmail.com>
---
 drivers/staging/media/go7007/go7007-v4l2.c |   95 ++++++++++++++++++++++++++++
 drivers/staging/media/go7007/go7007.h      |   18 +++++
 2 files changed, 113 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/media/go7007/go7007-v4l2.c b/drivers/staging/media/go7007/go7007-v4l2.c
index 91e5572..c4d0ca2 100644
--- a/drivers/staging/media/go7007/go7007-v4l2.c
+++ b/drivers/staging/media/go7007/go7007-v4l2.c
@@ -1137,6 +1137,101 @@ static struct video_device go7007_template = {
 	.tvnorms	= V4L2_STD_ALL,
 };
 
+static struct v4l2_ctrl_config md_configs[] = {
+	{
+		.ops = &go7007_ctrl_ops
+		,.id = V4L2_CID_USER_MODET_REGION_NUMBER
+		,.name = "Region MD"
+		,.type = V4L2_CTRL_TYPE_INTEGER
+		,.min = 0
+		,.max = 3
+		,.step = 1
+		,.def = 0
+	}
+	,{
+		.ops = &go7007_ctrl_ops
+		,.id = V4L2_CID_USER_MODET_PIXEL_THRESOLD
+		,.name = "Pixel Thresold"
+		,.type = V4L2_CTRL_TYPE_INTEGER
+		,.min = 0
+		,.max = 65535
+		,.step = 1
+		,.def = 32767
+	}
+	,{
+		.ops = &go7007_ctrl_ops
+		,.id = V4L2_CID_USER_MODET_MOTION_THRESOLD
+		,.name = "Motion Thresold"
+		,.type = V4L2_CTRL_TYPE_INTEGER
+		,.min = 0
+		,.max = 65535
+		,.step = 1
+		,.def = 32767
+	}
+	,{
+		.ops = &go7007_ctrl_ops
+		,.id = V4L2_CID_USER_MODET_TRIGGER
+		,.name = "Trigger"
+		,.type = V4L2_CTRL_TYPE_INTEGER
+		,.min = 0
+		,.max = 65535
+		,.step = 1
+		,.def = 32767
+	}
+	,{
+		.ops = &go7007_ctrl_ops
+		,.id = V4L2_CID_USER_MODET_CLIP_LEFT
+		,.name = "Left of Region"
+		,.type = V4L2_CTRL_TYPE_INTEGER
+		,.min = 0
+		,.step = 1
+		,.def = 0
+	}
+	,{
+		.ops = &go7007_ctrl_ops
+		,.id = V4L2_CID_USER_MODET_CLIP_TOP
+		,.name = "Top of Region"
+		,.type = V4L2_CTRL_TYPE_INTEGER
+		,.min = 0
+		,.step = 1
+		,.def = 0
+	}
+	,{
+		.ops = &go7007_ctrl_ops
+		,.id = V4L2_CID_USER_MODET_CLIP_WIDTH
+		,.name = "Width of Region"
+		,.type = V4L2_CTRL_TYPE_INTEGER
+		,.min = 0
+		,.step = 1
+		,.def = 0
+	}
+	,{
+		.ops = &go7007_ctrl_ops
+		,.id = V4L2_CID_USER_MODET_CLIP_HEIGHT
+		,.name = "Height of Region"
+		,.type = V4L2_CTRL_TYPE_INTEGER
+		,.min = 0
+		,.step = 1
+		,.def = 0
+	}
+	,{
+		.ops = &go7007_ctrl_ops
+		,.id = V4L2_CID_USER_MODET_REGION_CONTROL
+		,.name = "Region Control"
+		,.type = V4L2_CTRL_TYPE_MENU
+		,.min = rcAdd
+		,.max = rcClear
+		,.step = 0
+		,.def = rcClear
+		,.qmenu = (const char * const[]){
+			"Add"
+			,"Delete"
+			,"Clear"
+			,NULL
+		}
+	}
+};
+
 int go7007_v4l2_ctrl_init(struct go7007 *go)
 {
 	struct v4l2_ctrl_handler *hdl = &go->hdl;
diff --git a/drivers/staging/media/go7007/go7007.h b/drivers/staging/media/go7007/go7007.h
index 54b9897..fcb45ea 100644
--- a/drivers/staging/media/go7007/go7007.h
+++ b/drivers/staging/media/go7007/go7007.h
@@ -38,3 +38,21 @@ struct go7007_md_region {
 					struct go7007_md_params)
 #define	GO7007IOC_S_MD_REGION	_IOW('V', BASE_VIDIOC_PRIVATE + 8, \
 					struct go7007_md_region)
+
+#define V4L2_CID_USER_GO7007_BASE			(V4L2_CID_USER_BASE + 0x1000)
+#define V4L2_CID_USER_MODET_REGION_NUMBER		(V4L2_CID_USER_GO7007_BASE + 0x01)
+#define V4L2_CID_USER_MODET_PIXEL_THRESOLD		(V4L2_CID_USER_GO7007_BASE + 0x02)
+#define V4L2_CID_USER_MODET_MOTION_THRESOLD		(V4L2_CID_USER_GO7007_BASE + 0x03)
+#define V4L2_CID_USER_MODET_TRIGGER			(V4L2_CID_USER_GO7007_BASE + 0x04)
+#define V4L2_CID_USER_MODET_REGION_CONTROL		(V4L2_CID_USER_GO7007_BASE + 0x05)
+#define V4L2_CID_USER_MODET_CLIP_LEFT			(V4L2_CID_USER_GO7007_BASE + 0x06)
+#define V4L2_CID_USER_MODET_CLIP_TOP			(V4L2_CID_USER_GO7007_BASE + 0x07)
+#define V4L2_CID_USER_MODET_CLIP_WIDTH			(V4L2_CID_USER_GO7007_BASE + 0x08)
+#define V4L2_CID_USER_MODET_CLIP_HEIGHT			(V4L2_CID_USER_GO7007_BASE + 0x09)
+#define V4L2_CID_USER_MODET_ALARM			(V4L2_CID_USER_GO7007_BASE + 0x09)
+
+enum RegionControl {
+	rcAdd = 0
+	,rcDelete = 1
+	,rcClear = 2
+};
-- 
1.7.7.6

