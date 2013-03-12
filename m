Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:35216 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754038Ab3CLPQu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Mar 2013 11:16:50 -0400
Received: by mail-lb0-f169.google.com with SMTP id m4so73890lbo.28
        for <linux-media@vger.kernel.org>; Tue, 12 Mar 2013 08:16:48 -0700 (PDT)
From: Volokh Konstantin <volokh84@gmail.com>
To: hverkuil@xs4all.nl, linux-media@vger.kernel.org
Cc: Volokh Konstantin <volokh84@gmail.com>
Subject: [PATCH 1/2] hverkuil/go7007: staging: media: go7007: Restore b_frame control
Date: Tue, 12 Mar 2013 19:09:29 +0400
Message-Id: <1363100970-11080-1-git-send-email-volokh84@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Volokh Konstantin <volokh84@gmail.com>
---
 drivers/staging/media/go7007/go7007-priv.h |    1 +
 drivers/staging/media/go7007/go7007-v4l2.c |    7 +++++--
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/go7007/go7007-priv.h b/drivers/staging/media/go7007/go7007-priv.h
index 0914fa3..5f9b389 100644
--- a/drivers/staging/media/go7007/go7007-priv.h
+++ b/drivers/staging/media/go7007/go7007-priv.h
@@ -166,6 +166,7 @@ struct go7007 {
 	struct v4l2_ctrl *mpeg_video_gop_closure;
 	struct v4l2_ctrl *mpeg_video_bitrate;
 	struct v4l2_ctrl *mpeg_video_aspect_ratio;
+	struct v4l2_ctrl *mpeg_video_b_frames;
 	enum { STATUS_INIT, STATUS_ONLINE, STATUS_SHUTDOWN } status;
 	spinlock_t spinlock;
 	struct mutex hw_lock;
diff --git a/drivers/staging/media/go7007/go7007-v4l2.c b/drivers/staging/media/go7007/go7007-v4l2.c
index 3634580..06fc930 100644
--- a/drivers/staging/media/go7007/go7007-v4l2.c
+++ b/drivers/staging/media/go7007/go7007-v4l2.c
@@ -170,7 +170,7 @@ static void set_formatting(struct go7007 *go)
 			go->gop_size == 15 &&
 			go->closed_gop;
 	go->repeat_seqhead = go->dvd_mode;
-	go->ipb = 0;
+	go->ipb = v4l2_ctrl_g_ctrl(go->mpeg_video_b_frames);
 
 	switch (v4l2_ctrl_g_ctrl(go->mpeg_video_aspect_ratio)) {
 	default:
@@ -935,7 +935,7 @@ int go7007_v4l2_ctrl_init(struct go7007 *go)
 	struct v4l2_ctrl_handler *hdl = &go->hdl;
 	struct v4l2_ctrl *ctrl;
 
-	v4l2_ctrl_handler_init(hdl, 12);
+	v4l2_ctrl_handler_init(hdl, 13);
 	go->mpeg_video_gop_size = v4l2_ctrl_new_std(hdl, NULL,
 			V4L2_CID_MPEG_VIDEO_GOP_SIZE, 0, 34, 1, 15);
 	go->mpeg_video_gop_closure = v4l2_ctrl_new_std(hdl, NULL,
@@ -943,6 +943,9 @@ int go7007_v4l2_ctrl_init(struct go7007 *go)
 	go->mpeg_video_bitrate = v4l2_ctrl_new_std(hdl, NULL,
 			V4L2_CID_MPEG_VIDEO_BITRATE,
 			64000, 10000000, 1, 9800000);
+	go->mpeg_video_b_frames = v4l2_ctrl_new_std(hdl, NULL,
+			V4L2_CID_MPEG_VIDEO_B_FRAMES, 0, 2, 1, 0);
+
 	go->mpeg_video_aspect_ratio = v4l2_ctrl_new_std_menu(hdl, NULL,
 			V4L2_CID_MPEG_VIDEO_ASPECT,
 			V4L2_MPEG_VIDEO_ASPECT_16x9, 0,
-- 
1.7.7.6

