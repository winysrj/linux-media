Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:3988 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839Ab0EIN4w (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 9 May 2010 09:56:52 -0400
Message-Id: <18b63854577e200bf55309c88c1e0cab90dcd65a.1273413060.git.hverkuil@xs4all.nl>
In-Reply-To: <cover.1273413060.git.hverkuil@xs4all.nl>
References: <cover.1273413060.git.hverkuil@xs4all.nl>
From: Hans Verkuil <hverkuil@xs4all.nl>
Date: Sun, 09 May 2010 15:57:11 +0200
Subject: [PATCH 4/6] [RFC] tvp514x: add missing newlines
To: linux-media@vger.kernel.org
Cc: hvaibhav@ti.com
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/video/tvp514x.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/media/video/tvp514x.c b/drivers/media/video/tvp514x.c
index 8c1609f..4e22621 100644
--- a/drivers/media/video/tvp514x.c
+++ b/drivers/media/video/tvp514x.c
@@ -610,7 +610,7 @@ static int tvp514x_s_std(struct v4l2_subdev *sd, v4l2_std_id std_id)
 	decoder->tvp514x_regs[REG_VIDEO_STD].val =
 		decoder->std_list[i].video_std;
 
-	v4l2_dbg(1, debug, sd, "Standard set to: %s",
+	v4l2_dbg(1, debug, sd, "Standard set to: %s\n",
 			decoder->std_list[i].standard.name);
 	return 0;
 }
@@ -782,7 +782,7 @@ tvp514x_queryctrl(struct v4l2_subdev *sd, struct v4l2_queryctrl *qctrl)
 		return err;
 	}
 
-	v4l2_dbg(1, debug, sd, "Query Control:%s: Min - %d, Max - %d, Def - %d",
+	v4l2_dbg(1, debug, sd, "Query Control:%s: Min - %d, Max - %d, Def - %d\n",
 			qctrl->name, qctrl->minimum, qctrl->maximum,
 			qctrl->default_value);
 
@@ -839,7 +839,7 @@ tvp514x_g_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 		return -EINVAL;
 	}
 
-	v4l2_dbg(1, debug, sd, "Get Control: ID - %d - %d",
+	v4l2_dbg(1, debug, sd, "Get Control: ID - %d - %d\n",
 			ctrl->id, ctrl->value);
 	return 0;
 }
@@ -939,7 +939,7 @@ tvp514x_s_ctrl(struct v4l2_subdev *sd, struct v4l2_control *ctrl)
 		return err;
 	}
 
-	v4l2_dbg(1, debug, sd, "Set Control: ID - %d - %d",
+	v4l2_dbg(1, debug, sd, "Set Control: ID - %d - %d\n",
 			ctrl->id, ctrl->value);
 
 	return err;
@@ -1008,7 +1008,7 @@ tvp514x_try_fmt_cap(struct v4l2_subdev *sd, struct v4l2_format *f)
 	pix->priv = 0;
 
 	v4l2_dbg(1, debug, sd, "Try FMT: bytesperline - %d"
-			"Width - %d, Height - %d",
+			"Width - %d, Height - %d\n",
 			pix->bytesperline,
 			pix->width, pix->height);
 	return 0;
@@ -1070,7 +1070,7 @@ tvp514x_g_fmt_cap(struct v4l2_subdev *sd, struct v4l2_format *f)
 	f->fmt.pix = decoder->pix;
 
 	v4l2_dbg(1, debug, sd, "Current FMT: bytesperline - %d"
-			"Width - %d, Height - %d",
+			"Width - %d, Height - %d\n",
 			decoder->pix.bytesperline,
 			decoder->pix.width, decoder->pix.height);
 	return 0;
-- 
1.6.4.2

