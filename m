Return-path: <linux-media-owner@vger.kernel.org>
Received: from kozue.soulik.info ([108.61.200.231]:56854 "EHLO
        kozue.soulik.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754535AbcIDUSz (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 4 Sep 2016 16:18:55 -0400
From: Randy Li <ayaka@soulik.info>
To: linux-media@vger.kernel.org
Cc: posciak@chromium.org, hverkuil@xs4all.nl,
        linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org,
        intel-gfx@lists.freedesktop.org, Randy Li <ayaka@soulik.info>
Subject: [PATCH 1/2] [media] v4l2-ctrls: add H.264 decoder settings controls
Date: Mon,  5 Sep 2016 04:18:35 +0800
Message-Id: <1473020316-7325-2-git-send-email-ayaka@soulik.info>
In-Reply-To: <1473020316-7325-1-git-send-email-ayaka@soulik.info>
References: <1473020316-7325-1-git-send-email-ayaka@soulik.info>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

These two controls would be used to set the H.264 codec settings
for decoder.

Signed-off-by: Randy Li <ayaka@soulik.info>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 2 ++
 include/uapi/linux/v4l2-controls.h   | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 60056b0..789a5fc 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -740,6 +740,8 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_MPEG_VIDEO_H264_HIERARCHICAL_CODING_LAYER:return "H264 Number of HC Layers";
 	case V4L2_CID_MPEG_VIDEO_H264_HIERARCHICAL_CODING_LAYER_QP:
 								return "H264 Set QP Value for HC Layers";
+	case V4L2_CID_MPEG_VIDEO_H264_PICTURE_PARAM:		return "H264 Picture Parameter";
+	case V4L2_CID_MPEG_VIDEO_H264_SLICE_PARAM:		return "H264 Slice Parameter";
 	case V4L2_CID_MPEG_VIDEO_MPEG4_I_FRAME_QP:		return "MPEG4 I-Frame QP Value";
 	case V4L2_CID_MPEG_VIDEO_MPEG4_P_FRAME_QP:		return "MPEG4 P-Frame QP Value";
 	case V4L2_CID_MPEG_VIDEO_MPEG4_B_FRAME_QP:		return "MPEG4 B-Frame QP Value";
diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index b6a357a..5b0bdc5 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -521,6 +521,8 @@ enum v4l2_mpeg_video_h264_hierarchical_coding_type {
 };
 #define V4L2_CID_MPEG_VIDEO_H264_HIERARCHICAL_CODING_LAYER	(V4L2_CID_MPEG_BASE+381)
 #define V4L2_CID_MPEG_VIDEO_H264_HIERARCHICAL_CODING_LAYER_QP	(V4L2_CID_MPEG_BASE+382)
+#define V4L2_CID_MPEG_VIDEO_H264_PICTURE_PARAM			(V4L2_CID_MPEG_BASE+383)
+#define V4L2_CID_MPEG_VIDEO_H264_SLICE_PARAM			(V4L2_CID_MPEG_BASE+384)
 #define V4L2_CID_MPEG_VIDEO_MPEG4_I_FRAME_QP	(V4L2_CID_MPEG_BASE+400)
 #define V4L2_CID_MPEG_VIDEO_MPEG4_P_FRAME_QP	(V4L2_CID_MPEG_BASE+401)
 #define V4L2_CID_MPEG_VIDEO_MPEG4_B_FRAME_QP	(V4L2_CID_MPEG_BASE+402)
-- 
2.7.4

