Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:4334 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567AbaBQLo6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Feb 2014 06:44:58 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, g.liakhovetski@gmx.de,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 1/3] v4l2-subdev.h: add g_tvnorms video op
Date: Mon, 17 Feb 2014 12:44:12 +0100
Message-Id: <1392637454-29179-2-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1392637454-29179-1-git-send-email-hverkuil@xs4all.nl>
References: <1392637454-29179-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

While there was already a g_tvnorms_output video op, it's counterpart for
video capture was missing. Add it.

This is necessary for generic bridge drivers like soc-camera to set the
video_device tvnorms field correctly. Otherwise ENUMSTD cannot work.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/media/v4l2-subdev.h | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/media/v4l2-subdev.h b/include/media/v4l2-subdev.h
index d67210a..787d078 100644
--- a/include/media/v4l2-subdev.h
+++ b/include/media/v4l2-subdev.h
@@ -264,8 +264,11 @@ struct v4l2_mbus_frame_desc {
    g_std_output: get current standard for video OUTPUT devices. This is ignored
 	by video input devices.
 
-   g_tvnorms_output: get v4l2_std_id with all standards supported by video
-	OUTPUT device. This is ignored by video input devices.
+   g_tvnorms: get v4l2_std_id with all standards supported by the video
+	CAPTURE device. This is ignored by video output devices.
+
+   g_tvnorms_output: get v4l2_std_id with all standards supported by the video
+	OUTPUT device. This is ignored by video capture devices.
 
    s_crystal_freq: sets the frequency of the crystal used to generate the
 	clocks in Hz. An extra flags field allows device specific configuration
@@ -308,6 +311,7 @@ struct v4l2_subdev_video_ops {
 	int (*s_std_output)(struct v4l2_subdev *sd, v4l2_std_id std);
 	int (*g_std_output)(struct v4l2_subdev *sd, v4l2_std_id *std);
 	int (*querystd)(struct v4l2_subdev *sd, v4l2_std_id *std);
+	int (*g_tvnorms)(struct v4l2_subdev *sd, v4l2_std_id *std);
 	int (*g_tvnorms_output)(struct v4l2_subdev *sd, v4l2_std_id *std);
 	int (*g_input_status)(struct v4l2_subdev *sd, u32 *status);
 	int (*s_stream)(struct v4l2_subdev *sd, int enable);
-- 
1.8.5.2

