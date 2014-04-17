Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:38905 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753825AbaDQONd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Apr 2014 10:13:33 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH v4 26/49] v4l: Validate fields in the core code for subdev EDID ioctls
Date: Thu, 17 Apr 2014 16:12:57 +0200
Message-Id: <1397744000-23967-27-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1397744000-23967-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1397744000-23967-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The subdev EDID ioctls receive a pad field that must reference an
existing pad and an EDID field that must point to a buffer. Validate
both fields in the core code instead of duplicating validation in all
drivers.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/i2c/ad9389b.c           |  2 --
 drivers/media/i2c/adv7511.c           |  2 --
 drivers/media/i2c/adv7604.c           |  4 ----
 drivers/media/i2c/adv7842.c           |  4 ----
 drivers/media/v4l2-core/v4l2-subdev.c | 24 ++++++++++++++++++++----
 5 files changed, 20 insertions(+), 16 deletions(-)

diff --git a/drivers/media/i2c/ad9389b.c b/drivers/media/i2c/ad9389b.c
index f00b3dd..fada175 100644
--- a/drivers/media/i2c/ad9389b.c
+++ b/drivers/media/i2c/ad9389b.c
@@ -682,8 +682,6 @@ static int ad9389b_get_edid(struct v4l2_subdev *sd, struct v4l2_edid *edid)
 		return -EINVAL;
 	if (edid->blocks == 0 || edid->blocks > 256)
 		return -EINVAL;
-	if (!edid->edid)
-		return -EINVAL;
 	if (!state->edid.segments) {
 		v4l2_dbg(1, debug, sd, "EDID segment 0 not found\n");
 		return -ENODATA;
diff --git a/drivers/media/i2c/adv7511.c b/drivers/media/i2c/adv7511.c
index d77a1db..f98acf4 100644
--- a/drivers/media/i2c/adv7511.c
+++ b/drivers/media/i2c/adv7511.c
@@ -783,8 +783,6 @@ static int adv7511_get_edid(struct v4l2_subdev *sd, struct v4l2_edid *edid)
 		return -EINVAL;
 	if ((edid->blocks == 0) || (edid->blocks > 256))
 		return -EINVAL;
-	if (!edid->edid)
-		return -EINVAL;
 	if (!state->edid.segments) {
 		v4l2_dbg(1, debug, sd, "EDID segment 0 not found\n");
 		return -ENODATA;
diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
index 98cc540..338baa4 100644
--- a/drivers/media/i2c/adv7604.c
+++ b/drivers/media/i2c/adv7604.c
@@ -1673,8 +1673,6 @@ static int adv7604_get_edid(struct v4l2_subdev *sd, struct v4l2_edid *edid)
 		return -EINVAL;
 	if (edid->start_block == 1)
 		edid->blocks = 1;
-	if (!edid->edid)
-		return -EINVAL;
 
 	if (edid->blocks > state->edid.blocks)
 		edid->blocks = state->edid.blocks;
@@ -1761,8 +1759,6 @@ static int adv7604_set_edid(struct v4l2_subdev *sd, struct v4l2_edid *edid)
 		edid->blocks = 2;
 		return -E2BIG;
 	}
-	if (!edid->edid)
-		return -EINVAL;
 
 	v4l2_dbg(2, debug, sd, "%s: write EDID pad %d, edid.present = 0x%x\n",
 			__func__, edid->pad, state->edid.present);
diff --git a/drivers/media/i2c/adv7842.c b/drivers/media/i2c/adv7842.c
index c3165ea..56b127a 100644
--- a/drivers/media/i2c/adv7842.c
+++ b/drivers/media/i2c/adv7842.c
@@ -2036,8 +2036,6 @@ static int adv7842_get_edid(struct v4l2_subdev *sd, struct v4l2_edid *edid)
 		return -EINVAL;
 	if (edid->start_block == 1)
 		edid->blocks = 1;
-	if (!edid->edid)
-		return -EINVAL;
 
 	switch (edid->pad) {
 	case ADV7842_EDID_PORT_A:
@@ -2072,8 +2070,6 @@ static int adv7842_set_edid(struct v4l2_subdev *sd, struct v4l2_edid *e)
 		return -EINVAL;
 	if (e->blocks > 2)
 		return -E2BIG;
-	if (!e->edid)
-		return -EINVAL;
 
 	/* todo, per edid */
 	state->aspect_ratio = v4l2_calc_aspect_ratio(e->edid[0x15],
diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
index 12f25cc..ad9aaae7 100644
--- a/drivers/media/v4l2-core/v4l2-subdev.c
+++ b/drivers/media/v4l2-core/v4l2-subdev.c
@@ -349,11 +349,27 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 			sd, pad, set_selection, subdev_fh, sel);
 	}
 
-	case VIDIOC_G_EDID:
-		return v4l2_subdev_call(sd, pad, get_edid, arg);
+	case VIDIOC_G_EDID: {
+		struct v4l2_subdev_edid *edid = arg;
 
-	case VIDIOC_S_EDID:
-		return v4l2_subdev_call(sd, pad, set_edid, arg);
+		if (edid->pad >= sd->entity.num_pads)
+			return -EINVAL;
+		if (edid->blocks && edid->edid == NULL)
+			return -EINVAL;
+
+		return v4l2_subdev_call(sd, pad, get_edid, edid);
+	}
+
+	case VIDIOC_S_EDID: {
+		struct v4l2_subdev_edid *edid = arg;
+
+		if (edid->pad >= sd->entity.num_pads)
+			return -EINVAL;
+		if (edid->blocks && edid->edid == NULL)
+			return -EINVAL;
+
+		return v4l2_subdev_call(sd, pad, set_edid, edid);
+	}
 
 	case VIDIOC_SUBDEV_DV_TIMINGS_CAP: {
 		struct v4l2_dv_timings_cap *cap = arg;
-- 
1.8.3.2

