Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:63374 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759691Ab2D0OXl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Apr 2012 10:23:41 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Received: from euspt1 ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0M3500DJK6NLWC30@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 27 Apr 2012 15:23:45 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt1.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0M35004UO6NA3L@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 27 Apr 2012 15:23:35 +0100 (BST)
Date: Fri, 27 Apr 2012 16:23:31 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH/RFC v3 14/14] vivi: Add controls
In-reply-to: <1335536611-4298-1-git-send-email-s.nawrocki@samsung.com>
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com, sakari.ailus@iki.fi,
	g.liakhovetski@gmx.de, hdegoede@redhat.com, moinejf@free.fr,
	hverkuil@xs4all.nl, m.szyprowski@samsung.com,
	riverful.kim@samsung.com, sw0312.kim@samsung.com,
	s.nawrocki@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <1335536611-4298-15-git-send-email-s.nawrocki@samsung.com>
References: <1335536611-4298-1-git-send-email-s.nawrocki@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch is just for testing the new controls, it is NOT
intended for merging upstream.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/media/video/vivi.c |  111 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 110 insertions(+), 1 deletion(-)

diff --git a/drivers/media/video/vivi.c b/drivers/media/video/vivi.c
index d64d482..cbe103e 100644
--- a/drivers/media/video/vivi.c
+++ b/drivers/media/video/vivi.c
@@ -179,6 +179,29 @@ struct vivi_dev {
 	struct v4l2_ctrl	   *bitmask;
 	struct v4l2_ctrl	   *int_menu;
 
+	struct v4l2_ctrl	   *exposure_bias;
+	struct v4l2_ctrl	   *metering;
+	struct v4l2_ctrl	   *wb_preset;
+	struct {
+		/* iso/auto iso cluster */
+		struct v4l2_ctrl  *auto_iso;
+		struct v4l2_ctrl  *iso;
+	};
+	struct {
+		/* continuous auto focus/auto focus cluster */
+		struct v4l2_ctrl  *focus_auto;
+		struct v4l2_ctrl  *af_start;
+		struct v4l2_ctrl  *af_stop;
+		struct v4l2_ctrl  *af_status;
+		struct v4l2_ctrl  *af_distance;
+		struct v4l2_ctrl  *af_area;
+	};
+	struct v4l2_ctrl	  *scene_mode;
+	struct v4l2_ctrl	  *lock_3a;
+	struct v4l2_ctrl	  *colorfx;
+	struct v4l2_ctrl	  *wdr;
+	struct v4l2_ctrl	  *stabilization;
+
 	spinlock_t                 slock;
 	struct mutex		   mutex;
 
@@ -208,6 +231,14 @@ struct vivi_dev {
 	u8 			   line[MAX_WIDTH * 4];
 };
 
+static const s64 vivi_iso_qmenu[] = {
+	50, 100, 200, 400, 800, 1600
+};
+
+static const s64 vivi_ev_bias_qmenu[] = {
+	-1500, -1000, -500, 0, 500, 1000, 1500
+};
+
 /* ------------------------------------------------------------------
 	DMA and thread functions
    ------------------------------------------------------------------*/
@@ -516,6 +547,10 @@ static void vivi_fillbuff(struct vivi_dev *dev, struct vivi_buffer *buf)
 		gen_text(dev, vbuf, line++ * 16, 16, str);
 	}
 
+	snprintf(str, sizeof(str), " auto iso: %s, iso: %lld ",
+		 dev->auto_iso->cur.val ? "on" : "off",
+		 vivi_iso_qmenu[dev->iso->cur.val]);
+
 	dev->mv_count += 2;
 
 	buf->vb.v4l2_buf.field = dev->field;
@@ -1023,6 +1058,13 @@ static int vivi_s_ctrl(struct v4l2_ctrl *ctrl)
 
 	if (ctrl == dev->button)
 		dev->button_pressed = 30;
+
+	if (ctrl->type == V4L2_CTRL_TYPE_STRING)
+		return 0;
+
+	dprintk(dev, 1, "%s: control: %s, val: %d, val64: %lld",
+		__func__, ctrl->name, ctrl->val, ctrl->val64);
+
 	return 0;
 }
 
@@ -1267,7 +1309,8 @@ static int __init vivi_create_instance(int inst)
 	dev->width = 640;
 	dev->height = 480;
 	hdl = &dev->ctrl_handler;
-	v4l2_ctrl_handler_init(hdl, 11);
+	v4l2_ctrl_handler_init(hdl, 26);
+
 	dev->volume = v4l2_ctrl_new_std(hdl, &vivi_ctrl_ops,
 			V4L2_CID_AUDIO_VOLUME, 0, 255, 1, 200);
 	dev->brightness = v4l2_ctrl_new_std(hdl, &vivi_ctrl_ops,
@@ -1290,11 +1333,77 @@ static int __init vivi_create_instance(int inst)
 	dev->string = v4l2_ctrl_new_custom(hdl, &vivi_ctrl_string, NULL);
 	dev->bitmask = v4l2_ctrl_new_custom(hdl, &vivi_ctrl_bitmask, NULL);
 	dev->int_menu = v4l2_ctrl_new_custom(hdl, &vivi_ctrl_int_menu, NULL);
+
+	dev->wb_preset = v4l2_ctrl_new_std_menu(hdl,
+			&vivi_ctrl_ops, V4L2_CID_AUTO_N_PRESET_WHITE_BALANCE,
+			9, ~0x3ff, V4L2_WHITE_BALANCE_AUTO);
+
+	dev->exposure_bias = v4l2_ctrl_new_std_int_menu(hdl,
+			&vivi_ctrl_ops, V4L2_CID_AUTO_EXPOSURE_BIAS,
+			ARRAY_SIZE(vivi_ev_bias_qmenu) - 1,
+			ARRAY_SIZE(vivi_ev_bias_qmenu)/2 - 1,
+			vivi_ev_bias_qmenu);
+
+	dev->metering = v4l2_ctrl_new_std_menu(hdl,
+			&vivi_ctrl_ops, V4L2_CID_EXPOSURE_METERING,
+			2, ~0x7, V4L2_EXPOSURE_METERING_AVERAGE);
+
+	/* ISO cluster */
+	dev->auto_iso = v4l2_ctrl_new_std(hdl, &vivi_ctrl_ops,
+			V4L2_CID_ISO_SENSITIVITY_AUTO, 0, 1, 1, 1);
+
+	dev->iso = v4l2_ctrl_new_std_int_menu(hdl, &vivi_ctrl_ops,
+			V4L2_CID_ISO_SENSITIVITY, ARRAY_SIZE(vivi_iso_qmenu) - 1,
+			ARRAY_SIZE(vivi_iso_qmenu)/2 - 1, vivi_iso_qmenu);
+
+	/* Auto focus cluster */
+	dev->focus_auto = v4l2_ctrl_new_std(hdl, &vivi_ctrl_ops,
+			V4L2_CID_FOCUS_AUTO, 0, 1, 1, 0);
+
+	dev->af_start = v4l2_ctrl_new_std(hdl, &vivi_ctrl_ops,
+			V4L2_CID_AUTO_FOCUS_START, 0, 1, 1, 0);
+
+	dev->af_stop = v4l2_ctrl_new_std(hdl, &vivi_ctrl_ops,
+			V4L2_CID_AUTO_FOCUS_STOP, 0, 1, 1, 0);
+
+	dev->af_status = v4l2_ctrl_new_std(hdl, &vivi_ctrl_ops,
+			V4L2_CID_AUTO_FOCUS_STATUS, 0, 0x07, 0, 0);
+
+	dev->af_distance = v4l2_ctrl_new_std_menu(hdl, &vivi_ctrl_ops,
+			V4L2_CID_AUTO_FOCUS_DISTANCE,
+			2, 0, V4L2_AUTO_FOCUS_DISTANCE_NORMAL);
+
+	dev->af_area = v4l2_ctrl_new_std_menu(hdl, &vivi_ctrl_ops,
+			V4L2_CID_AUTO_FOCUS_AREA, 1, 0,
+			V4L2_AUTO_FOCUS_AREA_ALL);
+
+	dev->colorfx = v4l2_ctrl_new_std_menu(hdl, &vivi_ctrl_ops,
+			V4L2_CID_COLORFX, 15, 0, V4L2_COLORFX_NONE);
+
+	dev->wdr = v4l2_ctrl_new_std_menu(hdl, &vivi_ctrl_ops,
+			V4L2_CID_WIDE_DYNAMIC_RANGE, 1, 0, 0);
+
+	dev->stabilization = v4l2_ctrl_new_std_menu(hdl, &vivi_ctrl_ops,
+			V4L2_CID_IMAGE_STABILIZATION, 1, 0, 0);
+
+	dev->lock_3a = v4l2_ctrl_new_std(hdl, &vivi_ctrl_ops,
+			V4L2_CID_3A_LOCK, 0, 0x7, 0, 0);
+
+	dev->scene_mode = v4l2_ctrl_new_std_menu(hdl, &vivi_ctrl_ops,
+			V4L2_CID_SCENE_MODE, 13, ~0x1fff,
+			V4L2_SCENE_MODE_NONE);
+
 	if (hdl->error) {
 		ret = hdl->error;
 		goto unreg_dev;
 	}
 	v4l2_ctrl_auto_cluster(2, &dev->autogain, 0, true);
+
+	v4l2_ctrl_auto_cluster(2, &dev->auto_iso, 0, false);
+	dev->af_status->flags |= V4L2_CTRL_FLAG_VOLATILE;
+	v4l2_ctrl_cluster(6, &dev->focus_auto);
+	dev->lock_3a->flags |= V4L2_CTRL_FLAG_VOLATILE;
+
 	dev->v4l2_dev.ctrl_handler = hdl;
 
 	/* initialize locks */
-- 
1.7.10

