Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:1313 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755739AbaFLLyh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Jun 2014 07:54:37 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, s.nawrocki@samsung.com,
	sakari.ailus@iki.fi, Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEWv4 PATCH 10/34] v4l2-ctrls: use ptrs for all but the s32 type.
Date: Thu, 12 Jun 2014 13:52:42 +0200
Message-Id: <58a83e8790b13cb302c4b6b88227ee69f3c4cffe.1402573818.git.hans.verkuil@cisco.com>
In-Reply-To: <1402573986-20794-1-git-send-email-hverkuil@xs4all.nl>
References: <1402573986-20794-1-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <971e25ca71923ba77526326f998227fdfb30f216.1402573818.git.hans.verkuil@cisco.com>
References: <971e25ca71923ba77526326f998227fdfb30f216.1402573818.git.hans.verkuil@cisco.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

Rather than having two unions for all types just keep 'val' and
'cur.val' and use the p_cur and p_new unions to access all others.

The only reason for keeping 'val' and 'cur.val' is that it is used
all over, so converting this as well would be a huge job.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/video4linux/v4l2-controls.txt        |  2 +-
 drivers/media/i2c/mt9v032.c                        |  2 +-
 drivers/media/i2c/smiapp/smiapp-core.c             |  4 ++--
 drivers/media/pci/ivtv/ivtv-controls.c             |  4 ++--
 drivers/media/platform/vivi.c                      |  4 ++--
 drivers/media/radio/si4713/si4713.c                |  4 ++--
 drivers/media/v4l2-core/v4l2-ctrls.c               | 16 +++++++++-------
 drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c |  2 +-
 include/media/v4l2-ctrls.h                         | 12 ++----------
 9 files changed, 22 insertions(+), 28 deletions(-)

diff --git a/Documentation/video4linux/v4l2-controls.txt b/Documentation/video4linux/v4l2-controls.txt
index 06cf3ac..c9ee9a7 100644
--- a/Documentation/video4linux/v4l2-controls.txt
+++ b/Documentation/video4linux/v4l2-controls.txt
@@ -362,7 +362,7 @@ will result in a deadlock since these helpers lock the handler as well.
 You can also take the handler lock yourself:
 
 	mutex_lock(&state->ctrl_handler.lock);
-	printk(KERN_INFO "String value is '%s'\n", ctrl1->cur.string);
+	pr_info("String value is '%s'\n", ctrl1->p_cur.p_char);
 	printk(KERN_INFO "Integer value is '%s'\n", ctrl2->cur.val);
 	mutex_unlock(&state->ctrl_handler.lock);
 
diff --git a/drivers/media/i2c/mt9v032.c b/drivers/media/i2c/mt9v032.c
index 65e6e1a..435e9e6 100644
--- a/drivers/media/i2c/mt9v032.c
+++ b/drivers/media/i2c/mt9v032.c
@@ -667,7 +667,7 @@ static int mt9v032_s_ctrl(struct v4l2_ctrl *ctrl)
 			break;
 
 		freq = mt9v032->pdata->link_freqs[mt9v032->link_freq->val];
-		mt9v032->pixel_rate->val64 = freq;
+		*mt9v032->pixel_rate->p_new.p_s64 = freq;
 		mt9v032->sysclk = freq;
 		break;
 
diff --git a/drivers/media/i2c/smiapp/smiapp-core.c b/drivers/media/i2c/smiapp/smiapp-core.c
index 0e82756..83d506e 100644
--- a/drivers/media/i2c/smiapp/smiapp-core.c
+++ b/drivers/media/i2c/smiapp/smiapp-core.c
@@ -297,8 +297,8 @@ static int smiapp_pll_update(struct smiapp_sensor *sensor)
 	if (rval < 0)
 		return rval;
 
-	sensor->pixel_rate_parray->cur.val64 = pll->vt_pix_clk_freq_hz;
-	sensor->pixel_rate_csi->cur.val64 = pll->pixel_rate_csi;
+	*sensor->pixel_rate_parray->p_cur.p_s64 = pll->vt_pix_clk_freq_hz;
+	*sensor->pixel_rate_csi->p_cur.p_s64 = pll->pixel_rate_csi;
 
 	return 0;
 }
diff --git a/drivers/media/pci/ivtv/ivtv-controls.c b/drivers/media/pci/ivtv/ivtv-controls.c
index c604246..2b0ab26 100644
--- a/drivers/media/pci/ivtv/ivtv-controls.c
+++ b/drivers/media/pci/ivtv/ivtv-controls.c
@@ -135,8 +135,8 @@ static int ivtv_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
 	/* V4L2_CID_MPEG_VIDEO_DEC_PTS and V4L2_CID_MPEG_VIDEO_DEC_FRAME
 	   control cluster */
 	case V4L2_CID_MPEG_VIDEO_DEC_PTS:
-		return ivtv_g_pts_frame(itv, &itv->ctrl_pts->val64,
-					     &itv->ctrl_frame->val64);
+		return ivtv_g_pts_frame(itv, itv->ctrl_pts->p_new.p_s64,
+					     itv->ctrl_frame->p_new.p_s64);
 	}
 	return 0;
 }
diff --git a/drivers/media/platform/vivi.c b/drivers/media/platform/vivi.c
index 2fa05e1..69e65e6 100644
--- a/drivers/media/platform/vivi.c
+++ b/drivers/media/platform/vivi.c
@@ -648,13 +648,13 @@ static void vivi_fillbuff(struct vivi_dev *dev, struct vivi_buffer *buf)
 	gen_text(dev, vbuf, line++ * 16, 16, str);
 	snprintf(str, sizeof(str), " int32 %d, int64 %lld, bitmask %08x ",
 			dev->int32->cur.val,
-			dev->int64->cur.val64,
+			*dev->int64->p_cur.p_s64,
 			dev->bitmask->cur.val);
 	gen_text(dev, vbuf, line++ * 16, 16, str);
 	snprintf(str, sizeof(str), " boolean %d, menu %s, string \"%s\" ",
 			dev->boolean->cur.val,
 			dev->menu->qmenu[dev->menu->cur.val],
-			dev->string->cur.string);
+			dev->string->p_cur.p_char);
 	gen_text(dev, vbuf, line++ * 16, 16, str);
 	snprintf(str, sizeof(str), " integer_menu %lld, value %d ",
 			dev->int_menu->qmenu_int[dev->int_menu->cur.val],
diff --git a/drivers/media/radio/si4713/si4713.c b/drivers/media/radio/si4713/si4713.c
index 07d5153..dbe4726 100644
--- a/drivers/media/radio/si4713/si4713.c
+++ b/drivers/media/radio/si4713/si4713.c
@@ -1098,11 +1098,11 @@ static int si4713_s_ctrl(struct v4l2_ctrl *ctrl)
 
 		switch (ctrl->id) {
 		case V4L2_CID_RDS_TX_PS_NAME:
-			ret = si4713_set_rds_ps_name(sdev, ctrl->string);
+			ret = si4713_set_rds_ps_name(sdev, ctrl->p_new.p_char);
 			break;
 
 		case V4L2_CID_RDS_TX_RADIO_TEXT:
-			ret = si4713_set_rds_radio_text(sdev, ctrl->string);
+			ret = si4713_set_rds_radio_text(sdev, ctrl->p_new.p_char);
 			break;
 
 		case V4L2_CID_TUNE_ANTENNA_CAPACITOR:
diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 1b4d37c..4b10571 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -1135,7 +1135,7 @@ static void fill_event(struct v4l2_event *ev, struct v4l2_ctrl *ctrl, u32 change
 	if (ctrl->is_ptr)
 		ev->u.ctrl.value64 = 0;
 	else
-		ev->u.ctrl.value64 = ctrl->cur.val64;
+		ev->u.ctrl.value64 = *ctrl->p_cur.p_s64;
 	ev->u.ctrl.minimum = ctrl->minimum;
 	ev->u.ctrl.maximum = ctrl->maximum;
 	if (ctrl->type == V4L2_CTRL_TYPE_MENU
@@ -1801,7 +1801,9 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
 		flags |= V4L2_CTRL_FLAG_WRITE_ONLY;
 	else if (type == V4L2_CTRL_TYPE_CTRL_CLASS)
 		flags |= V4L2_CTRL_FLAG_READ_ONLY;
-	else if (type == V4L2_CTRL_TYPE_STRING || type >= V4L2_CTRL_COMPOUND_TYPES)
+	else if (type == V4L2_CTRL_TYPE_INTEGER64 ||
+		 type == V4L2_CTRL_TYPE_STRING ||
+		 type >= V4L2_CTRL_COMPOUND_TYPES)
 		sz_extra += 2 * elem_size;
 
 	ctrl = kzalloc(sizeof(*ctrl) + sz_extra, GFP_KERNEL);
@@ -1833,10 +1835,10 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
 		ctrl->qmenu_int = qmenu_int;
 	ctrl->priv = priv;
 	ctrl->cur.val = ctrl->val = def;
-	data = &ctrl->cur + 1;
+	data = &ctrl[1];
 
-	if (ctrl->is_ptr) {
-		ctrl->p = ctrl->p_new.p = data;
+	if (!ctrl->is_int) {
+		ctrl->p_new.p = data;
 		ctrl->p_cur.p = data + elem_size;
 	} else {
 		ctrl->p_new.p = &ctrl->val;
@@ -3103,10 +3105,10 @@ int v4l2_ctrl_modify_range(struct v4l2_ctrl *ctrl,
 	ctrl->maximum = max;
 	ctrl->step = step;
 	ctrl->default_value = def;
-	c.value = ctrl->cur.val;
+	c.value = *ctrl->p_cur.p_s32;
 	if (validate_new(ctrl, &c))
 		c.value = def;
-	if (c.value != ctrl->cur.val)
+	if (c.value != *ctrl->p_cur.p_s32)
 		ret = set_ctrl(NULL, ctrl, &c, V4L2_EVENT_CTRL_CH_RANGE);
 	else
 		send_event(NULL, ctrl, V4L2_EVENT_CTRL_CH_RANGE);
diff --git a/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c b/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c
index b8ff113..09ce30b 100644
--- a/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c
+++ b/drivers/staging/media/solo6x10/solo6x10-v4l2-enc.c
@@ -1131,7 +1131,7 @@ static int solo_s_ctrl(struct v4l2_ctrl *ctrl)
 		solo_motion_toggle(solo_enc, ctrl->val);
 		return 0;
 	case V4L2_CID_OSD_TEXT:
-		strcpy(solo_enc->osd_text, ctrl->string);
+		strcpy(solo_enc->osd_text, ctrl->p_new.p_char);
 		err = solo_osd_print(solo_enc);
 		return err;
 	default:
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index a38bd55..eb69c52 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -187,17 +187,9 @@ struct v4l2_ctrl {
 	};
 	unsigned long flags;
 	void *priv;
-	union {
-		s32 val;
-		s64 val64;
-		char *string;
-		void *p;
-	};
-	union {
+	s32 val;
+	struct {
 		s32 val;
-		s64 val64;
-		char *string;
-		void *p;
 	} cur;
 
 	union v4l2_ctrl_ptr p_new;
-- 
2.0.0.rc0

