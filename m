Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:38383 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751085AbeAVKTA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 Jan 2018 05:19:00 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 7/9] staging: atomisp: Drop g_parm and s_parm subdev ops use
Date: Mon, 22 Jan 2018 11:18:55 +0100
Message-Id: <20180122101857.51401-8-hverkuil@xs4all.nl>
In-Reply-To: <20180122101857.51401-1-hverkuil@xs4all.nl>
References: <20180122101857.51401-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sakari Ailus <sakari.ailus@linux.intel.com>

The s_parm and g_parm did nothing. Remove them.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 .../staging/media/atomisp/pci/atomisp2/atomisp_file.c    | 16 ----------------
 drivers/staging/media/atomisp/pci/atomisp2/atomisp_tpg.c | 14 --------------
 2 files changed, 30 deletions(-)

diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_file.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_file.c
index 377ec2a9fa6d..c6d96987561d 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_file.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_file.c
@@ -77,20 +77,6 @@ static int file_input_s_stream(struct v4l2_subdev *sd, int enable)
 	return 0;
 }
 
-static int file_input_g_parm(struct v4l2_subdev *sd,
-		struct v4l2_streamparm *param)
-{
-	/*to fake*/
-	return 0;
-}
-
-static int file_input_s_parm(struct v4l2_subdev *sd,
-		struct v4l2_streamparm *param)
-{
-	/*to fake*/
-	return 0;
-}
-
 static int file_input_get_fmt(struct v4l2_subdev *sd,
 			      struct v4l2_subdev_pad_config *cfg,
 			      struct v4l2_subdev_format *format)
@@ -166,8 +152,6 @@ static int file_input_enum_frame_ival(struct v4l2_subdev *sd,
 
 static const struct v4l2_subdev_video_ops file_input_video_ops = {
 	.s_stream = file_input_s_stream,
-	.g_parm = file_input_g_parm,
-	.s_parm = file_input_s_parm,
 };
 
 static const struct v4l2_subdev_core_ops file_input_core_ops = {
diff --git a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_tpg.c b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_tpg.c
index b71cc7bcdbab..adc900272f6f 100644
--- a/drivers/staging/media/atomisp/pci/atomisp2/atomisp_tpg.c
+++ b/drivers/staging/media/atomisp/pci/atomisp2/atomisp_tpg.c
@@ -27,18 +27,6 @@ static int tpg_s_stream(struct v4l2_subdev *sd, int enable)
 	return 0;
 }
 
-static int tpg_g_parm(struct v4l2_subdev *sd, struct v4l2_streamparm *param)
-{
-	/*to fake*/
-	return 0;
-}
-
-static int tpg_s_parm(struct v4l2_subdev *sd, struct v4l2_streamparm *param)
-{
-	/*to fake*/
-	return 0;
-}
-
 static int tpg_get_fmt(struct v4l2_subdev *sd,
 		       struct v4l2_subdev_pad_config *cfg,
 		       struct v4l2_subdev_format *format)
@@ -101,8 +89,6 @@ static int tpg_enum_frame_ival(struct v4l2_subdev *sd,
 
 static const struct v4l2_subdev_video_ops tpg_video_ops = {
 	.s_stream = tpg_s_stream,
-	.g_parm = tpg_g_parm,
-	.s_parm = tpg_s_parm,
 };
 
 static const struct v4l2_subdev_core_ops tpg_core_ops = {
-- 
2.15.1
