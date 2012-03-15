Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:30616 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031930Ab2COQyv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Mar 2012 12:54:51 -0400
Received: from euspt2 (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTP id <0M0X000J9QZ0AY@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 15 Mar 2012 16:54:36 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M0X00FNVQZ4XT@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 15 Mar 2012 16:54:42 +0000 (GMT)
Date: Thu, 15 Mar 2012 17:54:33 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH/RFC 19/23] m5mols: Add auto focus controls
In-reply-to: <1331830477-12146-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: m.szyprowski@samsung.com, riverful.kim@samsung.com,
	kyungmin.park@samsung.com, s.nawrocki@samsung.com
Message-id: <1331830477-12146-20-git-send-email-s.nawrocki@samsung.com>
MIME-version: 1.0
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1331830477-12146-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/m5mols/m5mols.h          |   19 ++-
 drivers/media/video/m5mols/m5mols_controls.c |  160 +++++++++++++++++++++++++-
 drivers/media/video/m5mols/m5mols_core.c     |   67 ++++++++++-
 drivers/media/video/m5mols/m5mols_reg.h      |    5 +
 4 files changed, 242 insertions(+), 9 deletions(-)

diff --git a/drivers/media/video/m5mols/m5mols.h b/drivers/media/video/m5mols/m5mols.h
index 213b15b..cd70b71 100644
--- a/drivers/media/video/m5mols/m5mols.h
+++ b/drivers/media/video/m5mols/m5mols.h
@@ -150,6 +150,12 @@ struct m5mols_version {
 	u8	af;
 };
 
+struct m5mols_focus {
+	u8 mode;
+	u16 x;
+	u16 y;
+};
+
 /**
  * struct m5mols_info - M-5MOLS driver data structure
  * @pdata: platform data
@@ -204,6 +210,16 @@ struct m5mols_info {
 		struct v4l2_ctrl *auto_wb;
 		struct v4l2_ctrl *wb_preset;
 	};
+	struct {
+		/* continuous auto focus/auto focus cluster */
+		struct v4l2_ctrl *focus_auto;
+		struct v4l2_ctrl *af_start;
+		struct v4l2_ctrl *af_stop;
+		struct v4l2_ctrl *af_status;
+		struct v4l2_ctrl *af_distance;
+		struct v4l2_ctrl *af_area;
+	};
+	struct m5mols_focus focus;
 
 	struct v4l2_ctrl *colorfx;
 	struct v4l2_ctrl *saturation;
@@ -226,7 +242,8 @@ struct m5mols_info {
 	int (*set_power)(struct device *dev, int on);
 };
 
-#define is_available_af(__info)	(__info->ver.af)
+#define m5mols_has_auto_focus(__info)	(__info->ver.af)
+
 #define is_code(__code, __type) (__code == m5mols_default_ffmt[__type].code)
 #define is_manufacturer(__info, __manufacturer)	\
 				(__info->ver.str[0] == __manufacturer[0] && \
diff --git a/drivers/media/video/m5mols/m5mols_controls.c b/drivers/media/video/m5mols/m5mols_controls.c
index 2c7beef..9ee089f 100644
--- a/drivers/media/video/m5mols/m5mols_controls.c
+++ b/drivers/media/video/m5mols/m5mols_controls.c
@@ -161,9 +161,9 @@ int m5mols_do_scenemode(struct m5mols_info *info, u8 mode)
 		ret = m5mols_write(sd, MON_EDGE_EN, scenemode.edge_en);
 	if (!ret)
 		ret = m5mols_write(sd, MON_EDGE_LVL, scenemode.edge_lvl);
-	if (!ret && is_available_af(info))
+	if (!ret && m5mols_has_auto_focus(info))
 		ret = m5mols_write(sd, AF_MODE, scenemode.af_range);
-	if (!ret && is_available_af(info))
+	if (!ret && m5mols_has_auto_focus(info))
 		ret = m5mols_write(sd, FD_CTL, scenemode.fd_mode);
 	if (!ret)
 		ret = m5mols_write(sd, MON_TONE_CTL, scenemode.tone);
@@ -221,11 +221,12 @@ int m5mols_lock_3a(struct m5mols_info *info, bool lock)
 	ret = m5mols_lock_ae(info, lock);
 	if (!ret)
 		ret = m5mols_lock_awb(info, lock);
+
 	/* Don't need to handle unlocking AF */
-	if (!ret && is_available_af(info) && lock)
-		ret = m5mols_write(&info->sd, AF_EXECUTE, REG_AF_STOP);
+	if (!m5mols_has_auto_focus(info) || ret || !lock)
+		return ret;
 
-	return ret;
+	return m5mols_write(&info->sd, AF_EXECUTE, REG_AF_STOP);
 }
 
 /* Set exposure/auto exposure cluster */
@@ -291,6 +292,85 @@ static int m5mols_set_white_balance(struct m5mols_info *info, int awb)
 	return ret;
 }
 
+static int m5mols_set_auto_focus(struct m5mols_info *info, int caf)
+{
+	struct v4l2_subdev *sd = &info->sd;
+	u8 af_mode = REG_AF_NORMAL;
+	int unlock_3a = 0, ret = 0;
+
+	if (info->af_distance->is_new) {
+		switch (info->af_distance->val) {
+		case V4L2_AUTO_FOCUS_DISTANCE_MACRO:
+			af_mode = REG_AF_MACRO;
+			unlock_3a = 1;
+			break;
+		case V4L2_AUTO_FOCUS_DISTANCE_INFINITY:
+			af_mode = REG_AF_INIFINITY;
+			break;
+		case V4L2_AUTO_FOCUS_DISTANCE_NORMAL:
+			af_mode = REG_AF_NORMAL;
+			unlock_3a = 1;
+			break;
+		}
+	}
+
+	if (unlock_3a)
+		m5mols_lock_3a(info, 0);
+
+	if (info->af_area->is_new) {
+		if (info->af_area->val == V4L2_AUTO_FOCUS_AREA_SPOT) {
+			v4l2_ctrl_activate(info->af_distance, 0);
+			af_mode = REG_AF_TOUCH;
+		} else {
+			/*
+			 * Activate the auto focus distance control only if
+			 * auto focus area is set to V4L2_AUTO_FOCUS_AREA_ALL
+			 */
+			v4l2_ctrl_activate(info->af_distance, 1);
+		}
+	}
+
+	pr_info("af_mode= %#x\n", af_mode);
+
+	if (info->focus.mode != af_mode) {
+		ret = m5mols_write(sd, AF_MODE, af_mode);
+		if (ret < 0)
+			return ret;
+		info->focus.mode = af_mode;
+	}
+
+	if (info->af_area->val == V4L2_AUTO_FOCUS_AREA_SPOT) {
+		ret = m5mols_write(sd, AF_TOUCH_POSX, info->focus.x);
+		if (ret < 0)
+			return ret;
+		ret = m5mols_write(sd, AF_TOUCH_POSY, info->focus.y);
+		if (ret < 0)
+			return ret;
+
+		v4l2_dbg(1, m5mols_debug, sd, "Focus position: x: %u, y: %u\n",
+			info->focus.x, info->focus.y);
+	}
+
+	if (info->af_stop->is_new) {
+		ret = m5mols_write(sd, AF_EXECUTE, REG_AF_STOP);
+		if (ret < 0)
+			return ret;
+		v4l2_dbg(1, m5mols_debug, sd, "Auto focus stopped\n");
+	}
+
+	if (info->af_start->is_new || info->focus_auto->is_new) {
+		/* Start continuous or one-shot auto focusing */
+		u8 af = caf ? REG_AF_EXE_CAF : REG_AF_EXE_AUTO;
+		ret = m5mols_write(sd, AF_EXECUTE, af);
+		v4l2_dbg(1, m5mols_debug, sd, "%s auto focus started\n",
+			 caf ? "Continuous" : "One-shot");
+	}
+
+	v4l2_dbg(1, m5mols_debug, sd, "af_mode: %#x (%d)\n", af_mode, ret);
+
+	return ret;
+}
+
 static int m5mols_set_saturation(struct m5mols_info *info, int val)
 {
 	int ret = m5mols_write(&info->sd, MON_CHROMA_LVL, val);
@@ -372,9 +452,10 @@ static int m5mols_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
 {
 	struct v4l2_subdev *sd = to_sd(ctrl);
 	struct m5mols_info *info = to_m5mols(sd);
-	int ret = 0;
+	int val, ret = 0;
 	u8 status;
 
+	pr_info("ctrl: %s\n", ctrl->name);
 
 	if (!info->isp_ready)
 		return -EBUSY;
@@ -385,6 +466,32 @@ static int m5mols_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
 		if (ret == 0)
 			ctrl->val = !status;
 		break;
+
+	case V4L2_CID_FOCUS_AUTO:
+		/* TODO: Also consider M-5MOLS status (mode) here ? */
+		ret = m5mols_read_u8(sd, AF_STATUS, &status);
+		if (ret)
+			return ret;
+		switch (status) {
+		case REG_AF_IDLE:
+			val = V4L2_AUTO_FOCUS_STATUS_IDLE;
+			break;
+		case REG_AF_BUSY:
+			val = V4L2_AUTO_FOCUS_STATUS_BUSY;
+			break;
+		case REG_AF_SUCCESS:
+			val = V4L2_AUTO_FOCUS_STATUS_SUCCESS;
+			break;
+		case REG_AF_FAIL:
+			val = V4L2_AUTO_FOCUS_STATUS_FAIL;
+			break;
+		default:
+			v4l2_err(sd, "Unknown AF state\n");
+			return 0;
+		}
+
+		info->af_status->val = val;
+		v4l2_dbg(1, m5mols_debug, sd, "AF status: %#x\n", val);
 	}
 
 	return ret;
@@ -410,6 +517,9 @@ static int m5mols_s_ctrl(struct v4l2_ctrl *ctrl)
 	v4l2_dbg(1, m5mols_debug, sd, "%s: %s, val: %d, priv: %#x\n",
 		 __func__, ctrl->name, ctrl->val, (int)ctrl->priv);
 
+	if (ctrl->flags & V4L2_CTRL_FLAG_INACTIVE)
+		return -EINVAL;
+
 	if (ctrl_mode && ctrl_mode != info->mode) {
 		ret = m5mols_mode(info, ctrl_mode);
 		if (ret < 0)
@@ -433,6 +543,10 @@ static int m5mols_s_ctrl(struct v4l2_ctrl *ctrl)
 		ret = m5mols_set_white_balance(info, ctrl->val);
 		break;
 
+	case V4L2_CID_FOCUS_AUTO:
+		ret = m5mols_set_auto_focus(info, ctrl->val);
+		break;
+
 	case V4L2_CID_SATURATION:
 		ret = m5mols_set_saturation(info, ctrl->val);
 		break;
@@ -522,6 +636,28 @@ int m5mols_init_controls(struct v4l2_subdev *sd)
 			V4L2_CID_ISO_SENSITIVITY, ARRAY_SIZE(iso_qmenu) - 1,
 			ARRAY_SIZE(iso_qmenu)/2 - 1, iso_qmenu);
 
+	/* Auto focus control cluster */
+	info->focus_auto = v4l2_ctrl_new_std(&info->handle, &m5mols_ctrl_ops,
+			V4L2_CID_FOCUS_AUTO, 0, 1, 1, 0);
+
+	info->af_start = v4l2_ctrl_new_std(&info->handle, &m5mols_ctrl_ops,
+			V4L2_CID_AUTO_FOCUS_START, 0, 1, 1, 0);
+
+	info->af_stop = v4l2_ctrl_new_std(&info->handle, &m5mols_ctrl_ops,
+			V4L2_CID_AUTO_FOCUS_STOP, 0, 1, 1, 0);
+
+	info->af_status = v4l2_ctrl_new_std(&info->handle, &m5mols_ctrl_ops,
+			V4L2_CID_AUTO_FOCUS_STATUS, 0, 0x07, 0, 0);
+
+	info->af_distance = v4l2_ctrl_new_std_menu(&info->handle,
+			&m5mols_ctrl_ops, V4L2_CID_AUTO_FOCUS_DISTANCE,
+			2, 0, V4L2_AUTO_FOCUS_DISTANCE_NORMAL);
+
+	info->af_area = v4l2_ctrl_new_std_menu(&info->handle,
+		       &m5mols_ctrl_ops, V4L2_CID_AUTO_FOCUS_AREA, 1,
+		       ~0x03, /* whole frame and spot */
+			V4L2_AUTO_FOCUS_AREA_ALL);
+
 	info->saturation = v4l2_ctrl_new_std(&info->handle, &m5mols_ctrl_ops,
 			V4L2_CID_SATURATION, 1, 5, 1, 3);
 
@@ -551,6 +687,18 @@ int m5mols_init_controls(struct v4l2_subdev *sd)
 	v4l2_ctrl_auto_cluster(2, &info->auto_iso, 0, false);
 
 	v4l2_ctrl_auto_cluster(2, &info->auto_wb, 0, false);
+
+	info->af_status->flags |= V4L2_CTRL_FLAG_VOLATILE;
+	v4l2_ctrl_cluster(6, &info->focus_auto);
+
+	if (!m5mols_has_auto_focus(info)) {
+		info->af_start->flags |= V4L2_CTRL_FLAG_DISABLED;
+		info->af_stop->flags |= V4L2_CTRL_FLAG_DISABLED;
+		info->af_status->flags |= V4L2_CTRL_FLAG_DISABLED;
+		info->af_distance->flags |= V4L2_CTRL_FLAG_DISABLED;
+		info->af_area->flags |= V4L2_CTRL_FLAG_DISABLED;
+	}
+
 	sd->ctrl_handler = &info->handle;
 
 	return 0;
diff --git a/drivers/media/video/m5mols/m5mols_core.c b/drivers/media/video/m5mols/m5mols_core.c
index 2afe12b..7daf9ae 100644
--- a/drivers/media/video/m5mols/m5mols_core.c
+++ b/drivers/media/video/m5mols/m5mols_core.c
@@ -322,7 +322,7 @@ int m5mols_busy_wait(struct v4l2_subdev *sd, u32 reg, u32 value, u32 mask,
 int m5mols_enable_interrupt(struct v4l2_subdev *sd, u8 reg)
 {
 	struct m5mols_info *info = to_m5mols(sd);
-	u8 mask = is_available_af(info) ? REG_INT_AF : 0;
+	u8 mask = m5mols_has_auto_focus(info) ? REG_INT_AF : 0;
 	u8 dummy;
 	int ret;
 
@@ -469,7 +469,7 @@ static int m5mols_get_version(struct v4l2_subdev *sd)
 	v4l2_info(sd, "Customer/Project\t[0x%02x/0x%02x]\n",
 			info->ver.customer, info->ver.project);
 
-	if (!is_available_af(info))
+	if (!m5mols_has_auto_focus(info))
 		v4l2_info(sd, "No support Auto Focus on this firmware\n");
 
 	return ret;
@@ -587,6 +587,10 @@ static int m5mols_set_fmt(struct v4l2_subdev *sd, struct v4l2_subdev_fh *fh,
 		*sfmt = *format;
 		info->resolution = resolution;
 		info->res_type = type;
+
+		/* Initialize focus spot to center of the frame */
+		info->focus.x = format->width / 2;
+		info->focus.y = format->height / 2;
 	}
 
 	return 0;
@@ -604,10 +608,65 @@ static int m5mols_enum_mbus_code(struct v4l2_subdev *sd,
 	return 0;
 }
 
+static int m5mols_set_selection(struct v4l2_subdev *sd,
+				struct v4l2_subdev_fh *fh,
+				struct v4l2_subdev_selection *sel)
+{
+	struct m5mols_info *info = to_m5mols(sd);
+	struct v4l2_mbus_framefmt *mf = &info->ffmt[M5MOLS_RESTYPE_MONITOR];
+	struct v4l2_rect *r = &sel->r;
+
+	v4l2_dbg(1, m5mols_debug, sd, "%s: (%d,%d) %dx%d, %#x\n", __func__,
+		 r->left, r->top, r->width, r->height, sel->target);
+
+	if (sel->target != V4L2_SUBDEV_SEL_TGT_AUTO_FOCUS_ACTUAL) {
+		v4l2_err(sd, "Unsupported selection target: %#x", sel->target);
+		return -EINVAL;
+	}
+
+	r->left = clamp_t(s32, r->left, 0, mf->width);
+	r->top = clamp_t(s32, r->top, 0, mf->height);
+	r->width = 0;
+	r->height = 0;
+
+	info->focus.x = r->left;
+	info->focus.y = r->top;
+
+	return 0;
+}
+
+static int m5mols_get_selection(struct v4l2_subdev *sd,
+				struct v4l2_subdev_fh *fh,
+				struct v4l2_subdev_selection *sel)
+{
+	struct m5mols_info *info = to_m5mols(sd);
+	struct v4l2_mbus_framefmt *mf = &info->ffmt[M5MOLS_RESTYPE_MONITOR];
+
+	switch (sel->target) {
+	case V4L2_SUBDEV_SEL_TGT_AUTO_FOCUS_ACTUAL:
+		sel->r.left = info->focus.x;
+		sel->r.top = info->focus.y;
+		break;
+	case V4L2_SUBDEV_SEL_TGT_AUTO_FOCUS_BOUNDS:
+		sel->r.width = mf->width;
+		sel->r.height = mf->height;
+		sel->r.left = 0;
+		sel->r.top = 0;
+		break;
+	default:
+		v4l2_err(sd, "Unsupported selection target: %#x", sel->target);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static struct v4l2_subdev_pad_ops m5mols_pad_ops = {
 	.enum_mbus_code	= m5mols_enum_mbus_code,
 	.get_fmt	= m5mols_get_fmt,
 	.set_fmt	= m5mols_set_fmt,
+	.set_selection	= m5mols_set_selection,
+	.get_selection	= m5mols_get_selection,
 };
 
 /**
@@ -706,6 +765,7 @@ static int m5mols_sensor_power(struct m5mols_info *info, bool enable)
 
 		gpio_set_value(pdata->gpio_reset, !pdata->reset_polarity);
 		info->power = 1;
+		info->focus.mode = -1;
 
 		return ret;
 	}
@@ -817,6 +877,9 @@ static int m5mols_log_status(struct v4l2_subdev *sd)
 
 	v4l2_ctrl_handler_log_status(&info->handle, sd->name);
 
+	pr_info("Auto focus position: x: %u, y: %u\n",
+		info->focus.x, info->focus.y);
+
 	return 0;
 }
 
diff --git a/drivers/media/video/m5mols/m5mols_reg.h b/drivers/media/video/m5mols/m5mols_reg.h
index ae4aced..f058c62 100644
--- a/drivers/media/video/m5mols/m5mols_reg.h
+++ b/drivers/media/video/m5mols/m5mols_reg.h
@@ -285,6 +285,8 @@
 #define AF_MODE			I2C_REG(CAT_LENS, 0x01, 1)
 #define REG_AF_NORMAL		0x00	/* Normal AF, one time */
 #define REG_AF_MACRO		0x01	/* Macro AF, one time */
+#define REG_AF_TOUCH		0x04
+#define REG_AF_INIFINITY	0x06
 #define REG_AF_POWEROFF		0x07
 
 #define AF_EXECUTE		I2C_REG(CAT_LENS, 0x02, 1)
@@ -300,6 +302,9 @@
 
 #define AF_VERSION		I2C_REG(CAT_LENS, 0x0a, 1)
 
+#define AF_TOUCH_POSX		I2C_REG(CAT_LENS, 0x30, 2)
+#define AF_TOUCH_POSY		I2C_REG(CAT_LENS, 0x32, 2)
+
 /*
  * Category B - CAPTURE Parameter
  */
-- 
1.7.9.2

