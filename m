Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f54.google.com ([209.85.215.54]:33254 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499Ab3CJOMP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Mar 2013 10:12:15 -0400
Received: by mail-la0-f54.google.com with SMTP id gw10so3008160lab.41
        for <linux-media@vger.kernel.org>; Sun, 10 Mar 2013 07:12:14 -0700 (PDT)
From: Volokh Konstantin <volokh84@gmail.com>
To: hverkuil@xs4all.nl, linux-media@vger.kernel.org
Cc: Volokh Konstantin <volokh84@gmail.com>
Subject: [PATCH 3/7] hverkuil/go7007: staging: media: go7007: Restore b_frame control
Date: Sun, 10 Mar 2013 18:04:42 +0400
Message-Id: <1362924286-23995-3-git-send-email-volokh84@gmail.com>
In-Reply-To: <1362924286-23995-1-git-send-email-volokh84@gmail.com>
References: <1362924286-23995-1-git-send-email-volokh84@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Volokh Konstantin <volokh84@gmail.com>
---
 drivers/staging/media/go7007/go7007-priv.h |    1 +
 drivers/staging/media/go7007/go7007-v4l2.c |    7 +++++--
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/go7007/go7007-priv.h b/drivers/staging/media/go7007/go7007-priv.h
index e969df1..fc8aac4 100644
--- a/drivers/staging/media/go7007/go7007-priv.h
+++ b/drivers/staging/media/go7007/go7007-priv.h
@@ -174,6 +174,7 @@ struct go7007 {
 		struct v4l2_ctrl *mpeg_video_gop_size;
 		struct v4l2_ctrl *mpeg_video_gop_closure;
 		struct v4l2_ctrl *mpeg_video_bitrate;
+		struct v4l2_ctrl *mpeg_video_b_frames;
 	};
 	struct v4l2_ctrl *mpeg_video_aspect_ratio;
 	enum { STATUS_INIT, STATUS_ONLINE, STATUS_SHUTDOWN } status;
diff --git a/drivers/staging/media/go7007/go7007-v4l2.c b/drivers/staging/media/go7007/go7007-v4l2.c
index 96538f6..91e5572 100644
--- a/drivers/staging/media/go7007/go7007-v4l2.c
+++ b/drivers/staging/media/go7007/go7007-v4l2.c
@@ -155,7 +155,7 @@ static void set_formatting(struct go7007 *go)
 	go->gop_header_enable = 1;
 	go->repeat_seqhead = 0;
 	go->dvd_mode = 0;
-	go->ipb = 0;
+	go->ipb = v4l2_ctrl_g_ctrl(go->mpeg_video_b_frames);
 
 	switch (v4l2_ctrl_g_ctrl(go->mpeg_video_aspect_ratio)) {
 	default:
@@ -1143,7 +1143,7 @@ int go7007_v4l2_ctrl_init(struct go7007 *go)
 	struct v4l2_ctrl *ctrl;
 	int rv;
 
-	v4l2_ctrl_handler_init(hdl, 12);
+	v4l2_ctrl_handler_init(hdl, 24);
 	go->mpeg_stream_type = v4l2_ctrl_new_std_menu(hdl, &go7007_ctrl_ops,
 			V4L2_CID_MPEG_STREAM_TYPE,
 			V4L2_MPEG_STREAM_TYPE_MPEG2_DVD,
@@ -1160,6 +1160,9 @@ int go7007_v4l2_ctrl_init(struct go7007 *go)
 	go->mpeg_video_bitrate = v4l2_ctrl_new_std(hdl, &go7007_ctrl_ops,
 			V4L2_CID_MPEG_VIDEO_BITRATE,
 			64000, 10000000, 1, 1500000);
+	go->mpeg_video_b_frames = v4l2_ctrl_new_std(hdl, &go7007_ctrl_ops,
+			V4L2_CID_MPEG_VIDEO_B_FRAMES,
+			0, 2, 1, 0);
 	go->mpeg_video_aspect_ratio = v4l2_ctrl_new_std_menu(hdl, &go7007_ctrl_ops,
 			V4L2_CID_MPEG_VIDEO_ASPECT,
 			V4L2_MPEG_VIDEO_ASPECT_16x9, 0,
-- 
1.7.7.6

