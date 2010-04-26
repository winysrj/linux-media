Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:2682 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754541Ab0DZHeK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Apr 2010 03:34:10 -0400
Message-Id: <ce91bd4e02390341d6dd1f321dc0a28c020b30ef.1272267137.git.hverkuil@xs4all.nl>
In-Reply-To: <cover.1272267136.git.hverkuil@xs4all.nl>
References: <cover.1272267136.git.hverkuil@xs4all.nl>
From: Hans Verkuil <hverkuil@xs4all.nl>
Date: Mon, 26 Apr 2010 09:34:08 +0200
Subject: [PATCH 10/15] [RFC] cx2341x: convert to the control framework
To: linux-media@vger.kernel.org
Cc: laurent.pinchart@ideasonboard.com
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Since this module is also used by drivers that are not yet converted, the old
and new code have to co-exist.

The source is split into three parts: a common part at the top, which is used
by both old and new code, then the old code followed by the new control
framework implementation. This new code is much more readable (and shorter!)
than the original code.

Once all bridge drivers that use this are converted the old code can be
deleted.

Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
---
 drivers/media/video/cx2341x.c |  725 ++++++++++++++++++++++++++++++++++-------
 include/media/cx2341x.h       |   81 +++++
 2 files changed, 694 insertions(+), 112 deletions(-)

diff --git a/drivers/media/video/cx2341x.c b/drivers/media/video/cx2341x.c
index 022b480..9a585e0 100644
--- a/drivers/media/video/cx2341x.c
+++ b/drivers/media/video/cx2341x.c
@@ -38,6 +38,145 @@ static int debug;
 module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug, "Debug level (0-1)");
 
+/********************** COMMON CODE *********************/
+
+/* definitions for audio properties bits 29-28 */
+#define CX2341X_AUDIO_ENCODING_METHOD_MPEG	0
+#define CX2341X_AUDIO_ENCODING_METHOD_AC3	1
+#define CX2341X_AUDIO_ENCODING_METHOD_LPCM	2
+
+static const char *cx2341x_get_name(u32 id)
+{
+	switch (id) {
+	case V4L2_CID_MPEG_CX2341X_VIDEO_SPATIAL_FILTER_MODE:
+		return "Spatial Filter Mode";
+	case V4L2_CID_MPEG_CX2341X_VIDEO_SPATIAL_FILTER:
+		return "Spatial Filter";
+	case V4L2_CID_MPEG_CX2341X_VIDEO_LUMA_SPATIAL_FILTER_TYPE:
+		return "Spatial Luma Filter Type";
+	case V4L2_CID_MPEG_CX2341X_VIDEO_CHROMA_SPATIAL_FILTER_TYPE:
+		return "Spatial Chroma Filter Type";
+	case V4L2_CID_MPEG_CX2341X_VIDEO_TEMPORAL_FILTER_MODE:
+		return "Temporal Filter Mode";
+	case V4L2_CID_MPEG_CX2341X_VIDEO_TEMPORAL_FILTER:
+		return "Temporal Filter";
+	case V4L2_CID_MPEG_CX2341X_VIDEO_MEDIAN_FILTER_TYPE:
+		return "Median Filter Type";
+	case V4L2_CID_MPEG_CX2341X_VIDEO_LUMA_MEDIAN_FILTER_TOP:
+		return "Median Luma Filter Maximum";
+	case V4L2_CID_MPEG_CX2341X_VIDEO_LUMA_MEDIAN_FILTER_BOTTOM:
+		return "Median Luma Filter Minimum";
+	case V4L2_CID_MPEG_CX2341X_VIDEO_CHROMA_MEDIAN_FILTER_TOP:
+		return "Median Chroma Filter Maximum";
+	case V4L2_CID_MPEG_CX2341X_VIDEO_CHROMA_MEDIAN_FILTER_BOTTOM:
+		return "Median Chroma Filter Minimum";
+	case V4L2_CID_MPEG_CX2341X_STREAM_INSERT_NAV_PACKETS:
+		return "Insert Navigation Packets";
+	}
+	return NULL;
+}
+
+static const char **cx2341x_get_menu(u32 id)
+{
+	static const char *cx2341x_video_spatial_filter_mode_menu[] = {
+		"Manual",
+		"Auto",
+		NULL
+	};
+
+	static const char *cx2341x_video_luma_spatial_filter_type_menu[] = {
+		"Off",
+		"1D Horizontal",
+		"1D Vertical",
+		"2D H/V Separable",
+		"2D Symmetric non-separable",
+		NULL
+	};
+
+	static const char *cx2341x_video_chroma_spatial_filter_type_menu[] = {
+		"Off",
+		"1D Horizontal",
+		NULL
+	};
+
+	static const char *cx2341x_video_temporal_filter_mode_menu[] = {
+		"Manual",
+		"Auto",
+		NULL
+	};
+
+	static const char *cx2341x_video_median_filter_type_menu[] = {
+		"Off",
+		"Horizontal",
+		"Vertical",
+		"Horizontal/Vertical",
+		"Diagonal",
+		NULL
+	};
+
+	switch (id) {
+	case V4L2_CID_MPEG_CX2341X_VIDEO_SPATIAL_FILTER_MODE:
+		return cx2341x_video_spatial_filter_mode_menu;
+	case V4L2_CID_MPEG_CX2341X_VIDEO_LUMA_SPATIAL_FILTER_TYPE:
+		return cx2341x_video_luma_spatial_filter_type_menu;
+	case V4L2_CID_MPEG_CX2341X_VIDEO_CHROMA_SPATIAL_FILTER_TYPE:
+		return cx2341x_video_chroma_spatial_filter_type_menu;
+	case V4L2_CID_MPEG_CX2341X_VIDEO_TEMPORAL_FILTER_MODE:
+		return cx2341x_video_temporal_filter_mode_menu;
+	case V4L2_CID_MPEG_CX2341X_VIDEO_MEDIAN_FILTER_TYPE:
+		return cx2341x_video_median_filter_type_menu;
+	}
+	return NULL;
+}
+
+static void cx2341x_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
+		    s32 *min, s32 *max, s32 *step, s32 *def, u32 *flags)
+{
+	*name = cx2341x_get_name(id);
+	*flags = 0;
+
+	switch (id) {
+	case V4L2_CID_MPEG_CX2341X_VIDEO_SPATIAL_FILTER_MODE:
+	case V4L2_CID_MPEG_CX2341X_VIDEO_LUMA_SPATIAL_FILTER_TYPE:
+	case V4L2_CID_MPEG_CX2341X_VIDEO_CHROMA_SPATIAL_FILTER_TYPE:
+	case V4L2_CID_MPEG_CX2341X_VIDEO_TEMPORAL_FILTER_MODE:
+	case V4L2_CID_MPEG_CX2341X_VIDEO_MEDIAN_FILTER_TYPE:
+		*type = V4L2_CTRL_TYPE_MENU;
+		*min = 0;
+		*step = 0;
+		break;
+	case V4L2_CID_MPEG_CX2341X_STREAM_INSERT_NAV_PACKETS:
+		*type = V4L2_CTRL_TYPE_BOOLEAN;
+		*min = 0;
+		*max = *step = 1;
+		break;
+	default:
+		*type = V4L2_CTRL_TYPE_INTEGER;
+		break;
+	}
+	switch (id) {
+	case V4L2_CID_MPEG_CX2341X_VIDEO_SPATIAL_FILTER_MODE:
+	case V4L2_CID_MPEG_CX2341X_VIDEO_TEMPORAL_FILTER_MODE:
+	case V4L2_CID_MPEG_CX2341X_VIDEO_MEDIAN_FILTER_TYPE:
+		*flags |= V4L2_CTRL_FLAG_UPDATE;
+		break;
+	case V4L2_CID_MPEG_CX2341X_VIDEO_SPATIAL_FILTER:
+	case V4L2_CID_MPEG_CX2341X_VIDEO_TEMPORAL_FILTER:
+	case V4L2_CID_MPEG_CX2341X_VIDEO_LUMA_MEDIAN_FILTER_TOP:
+	case V4L2_CID_MPEG_CX2341X_VIDEO_LUMA_MEDIAN_FILTER_BOTTOM:
+	case V4L2_CID_MPEG_CX2341X_VIDEO_CHROMA_MEDIAN_FILTER_TOP:
+	case V4L2_CID_MPEG_CX2341X_VIDEO_CHROMA_MEDIAN_FILTER_BOTTOM:
+		*flags |= V4L2_CTRL_FLAG_SLIDER;
+		break;
+	case V4L2_CID_MPEG_VIDEO_ENCODING:
+		*flags |= V4L2_CTRL_FLAG_READ_ONLY;
+		break;
+	}
+}
+
+
+/********************** OLD CODE *********************/
+
 /* Must be sorted from low to high control ID! */
 const u32 cx2341x_mpeg_ctrls[] = {
 	V4L2_CID_MPEG_CLASS,
@@ -134,8 +273,6 @@ static const struct cx2341x_mpeg_params default_params = {
 	.video_chroma_median_filter_top = 255,
 	.video_chroma_median_filter_bottom = 0,
 };
-
-
 /* Map the control ID to the correct field in the cx2341x_mpeg_params
    struct. Return -EINVAL if the ID is unknown, else return 0. */
 static int cx2341x_get_ctrl(const struct cx2341x_mpeg_params *params,
@@ -415,83 +552,33 @@ static int cx2341x_ctrl_query_fill(struct v4l2_queryctrl *qctrl,
 {
 	const char *name;
 
-	qctrl->flags = 0;
 	switch (qctrl->id) {
 	/* MPEG controls */
 	case V4L2_CID_MPEG_CX2341X_VIDEO_SPATIAL_FILTER_MODE:
-		name = "Spatial Filter Mode";
-		break;
 	case V4L2_CID_MPEG_CX2341X_VIDEO_SPATIAL_FILTER:
-		name = "Spatial Filter";
-		break;
 	case V4L2_CID_MPEG_CX2341X_VIDEO_LUMA_SPATIAL_FILTER_TYPE:
-		name = "Spatial Luma Filter Type";
-		break;
 	case V4L2_CID_MPEG_CX2341X_VIDEO_CHROMA_SPATIAL_FILTER_TYPE:
-		name = "Spatial Chroma Filter Type";
-		break;
 	case V4L2_CID_MPEG_CX2341X_VIDEO_TEMPORAL_FILTER_MODE:
-		name = "Temporal Filter Mode";
-		break;
 	case V4L2_CID_MPEG_CX2341X_VIDEO_TEMPORAL_FILTER:
-		name = "Temporal Filter";
-		break;
 	case V4L2_CID_MPEG_CX2341X_VIDEO_MEDIAN_FILTER_TYPE:
-		name = "Median Filter Type";
-		break;
 	case V4L2_CID_MPEG_CX2341X_VIDEO_LUMA_MEDIAN_FILTER_TOP:
-		name = "Median Luma Filter Maximum";
-		break;
 	case V4L2_CID_MPEG_CX2341X_VIDEO_LUMA_MEDIAN_FILTER_BOTTOM:
-		name = "Median Luma Filter Minimum";
-		break;
 	case V4L2_CID_MPEG_CX2341X_VIDEO_CHROMA_MEDIAN_FILTER_TOP:
-		name = "Median Chroma Filter Maximum";
-		break;
 	case V4L2_CID_MPEG_CX2341X_VIDEO_CHROMA_MEDIAN_FILTER_BOTTOM:
-		name = "Median Chroma Filter Minimum";
-		break;
 	case V4L2_CID_MPEG_CX2341X_STREAM_INSERT_NAV_PACKETS:
-		name = "Insert Navigation Packets";
-		break;
+		cx2341x_ctrl_fill(qctrl->id, &name, &qctrl->type,
+				&min, &max, &step, &def, &qctrl->flags);
+		qctrl->minimum = min;
+		qctrl->maximum = max;
+		qctrl->step = step;
+		qctrl->default_value = def;
+		qctrl->reserved[0] = qctrl->reserved[1] = 0;
+		strlcpy(qctrl->name, name, sizeof(qctrl->name));
+		return 0;
 
 	default:
 		return v4l2_ctrl_query_fill(qctrl, min, max, step, def);
 	}
-	switch (qctrl->id) {
-	case V4L2_CID_MPEG_CX2341X_VIDEO_SPATIAL_FILTER_MODE:
-	case V4L2_CID_MPEG_CX2341X_VIDEO_LUMA_SPATIAL_FILTER_TYPE:
-	case V4L2_CID_MPEG_CX2341X_VIDEO_CHROMA_SPATIAL_FILTER_TYPE:
-	case V4L2_CID_MPEG_CX2341X_VIDEO_TEMPORAL_FILTER_MODE:
-	case V4L2_CID_MPEG_CX2341X_VIDEO_MEDIAN_FILTER_TYPE:
-		qctrl->type = V4L2_CTRL_TYPE_MENU;
-		min = 0;
-		step = 1;
-		break;
-	case V4L2_CID_MPEG_CX2341X_STREAM_INSERT_NAV_PACKETS:
-		qctrl->type = V4L2_CTRL_TYPE_BOOLEAN;
-		min = 0;
-		max = 1;
-		step = 1;
-		break;
-	default:
-		qctrl->type = V4L2_CTRL_TYPE_INTEGER;
-		break;
-	}
-	switch (qctrl->id) {
-	case V4L2_CID_MPEG_CX2341X_VIDEO_SPATIAL_FILTER_MODE:
-	case V4L2_CID_MPEG_CX2341X_VIDEO_TEMPORAL_FILTER_MODE:
-	case V4L2_CID_MPEG_CX2341X_VIDEO_MEDIAN_FILTER_TYPE:
-		qctrl->flags |= V4L2_CTRL_FLAG_UPDATE;
-		break;
-	}
-	qctrl->minimum = min;
-	qctrl->maximum = max;
-	qctrl->step = step;
-	qctrl->default_value = def;
-	qctrl->reserved[0] = qctrl->reserved[1] = 0;
-	snprintf(qctrl->name, sizeof(qctrl->name), name);
-	return 0;
 }
 
 int cx2341x_ctrl_query(const struct cx2341x_mpeg_params *params,
@@ -797,42 +884,6 @@ const char **cx2341x_ctrl_get_menu(const struct cx2341x_mpeg_params *p, u32 id)
 		NULL
 	};
 
-	static const char *cx2341x_video_spatial_filter_mode_menu[] = {
-		"Manual",
-		"Auto",
-		NULL
-	};
-
-	static const char *cx2341x_video_luma_spatial_filter_type_menu[] = {
-		"Off",
-		"1D Horizontal",
-		"1D Vertical",
-		"2D H/V Separable",
-		"2D Symmetric non-separable",
-		NULL
-	};
-
-	static const char *cx2341x_video_chroma_spatial_filter_type_menu[] = {
-		"Off",
-		"1D Horizontal",
-		NULL
-	};
-
-	static const char *cx2341x_video_temporal_filter_mode_menu[] = {
-		"Manual",
-		"Auto",
-		NULL
-	};
-
-	static const char *cx2341x_video_median_filter_type_menu[] = {
-		"Off",
-		"Horizontal",
-		"Vertical",
-		"Horizontal/Vertical",
-		"Diagonal",
-		NULL
-	};
-
 	switch (id) {
 	case V4L2_CID_MPEG_STREAM_TYPE:
 		return (p->capabilities & CX2341X_CAP_HAS_TS) ?
@@ -844,26 +895,17 @@ const char **cx2341x_ctrl_get_menu(const struct cx2341x_mpeg_params *p, u32 id)
 	case V4L2_CID_MPEG_AUDIO_L3_BITRATE:
 		return NULL;
 	case V4L2_CID_MPEG_CX2341X_VIDEO_SPATIAL_FILTER_MODE:
-		return cx2341x_video_spatial_filter_mode_menu;
 	case V4L2_CID_MPEG_CX2341X_VIDEO_LUMA_SPATIAL_FILTER_TYPE:
-		return cx2341x_video_luma_spatial_filter_type_menu;
 	case V4L2_CID_MPEG_CX2341X_VIDEO_CHROMA_SPATIAL_FILTER_TYPE:
-		return cx2341x_video_chroma_spatial_filter_type_menu;
 	case V4L2_CID_MPEG_CX2341X_VIDEO_TEMPORAL_FILTER_MODE:
-		return cx2341x_video_temporal_filter_mode_menu;
 	case V4L2_CID_MPEG_CX2341X_VIDEO_MEDIAN_FILTER_TYPE:
-		return cx2341x_video_median_filter_type_menu;
+		return cx2341x_get_menu(id);
 	default:
 		return v4l2_ctrl_get_menu(id);
 	}
 }
 EXPORT_SYMBOL(cx2341x_ctrl_get_menu);
 
-/* definitions for audio properties bits 29-28 */
-#define CX2341X_AUDIO_ENCODING_METHOD_MPEG	0
-#define CX2341X_AUDIO_ENCODING_METHOD_AC3	1
-#define CX2341X_AUDIO_ENCODING_METHOD_LPCM	2
-
 static void cx2341x_calc_audio_properties(struct cx2341x_mpeg_params *params)
 {
 	params->audio_properties =
@@ -1199,9 +1241,468 @@ void cx2341x_log_status(const struct cx2341x_mpeg_params *p, const char *prefix)
 }
 EXPORT_SYMBOL(cx2341x_log_status);
 
-/*
- * Local variables:
- * c-basic-offset: 8
- * End:
- */
 
+
+/********************** NEW CODE *********************/
+
+static inline struct cx2341x_handler *to_cxhdl(struct v4l2_ctrl *ctrl)
+{
+	return container_of(ctrl->handler, struct cx2341x_handler, hdl);
+}
+
+static int cx2341x_hdl_api(struct cx2341x_handler *hdl,
+		       u32 cmd, int args, ...)
+{
+	u32 data[CX2341X_MBOX_MAX_DATA];
+	va_list vargs;
+	int i;
+
+	va_start(vargs, args);
+
+	for (i = 0; i < args; i++)
+		data[i] = va_arg(vargs, int);
+	va_end(vargs);
+	return hdl->func(hdl->priv, cmd, args, 0, data);
+}
+
+/* ctrl->handler->lock is held, so it is safe to access cur.val */
+static inline int cx2341x_neq(struct v4l2_ctrl *ctrl)
+{
+	return ctrl && ctrl->val != ctrl->cur.val;
+}
+
+static int cx2341x_try_ctrl(struct v4l2_ctrl *ctrl)
+{
+	struct cx2341x_handler *hdl = to_cxhdl(ctrl);
+	s32 val = ctrl->val;
+
+	switch (ctrl->id) {
+	case V4L2_CID_MPEG_VIDEO_B_FRAMES: {
+		/* video gop cluster */
+		int b = val + 1;
+		int gop = hdl->video_gop_size->val;
+
+		gop = b * ((gop + b - 1) / b);
+
+		/* Max GOP size = 34 */
+		while (gop > 34)
+			gop -= b;
+		hdl->video_gop_size->val = gop;
+		break;
+	}
+
+	case V4L2_CID_MPEG_STREAM_TYPE:
+		/* stream type cluster */
+		hdl->video_encoding->val =
+		    (hdl->stream_type->val == V4L2_MPEG_STREAM_TYPE_MPEG1_SS ||
+		     hdl->stream_type->val == V4L2_MPEG_STREAM_TYPE_MPEG1_VCD) ?
+			V4L2_MPEG_VIDEO_ENCODING_MPEG_1 :
+			V4L2_MPEG_VIDEO_ENCODING_MPEG_2;
+		if (hdl->video_encoding->val == V4L2_MPEG_VIDEO_ENCODING_MPEG_1)
+			/* MPEG-1 implies CBR */
+			hdl->video_bitrate_mode->val =
+				V4L2_MPEG_VIDEO_BITRATE_MODE_CBR;
+		/* peak bitrate shall be >= normal bitrate */
+		if (hdl->video_bitrate_mode->val == V4L2_MPEG_VIDEO_BITRATE_MODE_VBR &&
+		    hdl->video_bitrate_peak->val < hdl->video_bitrate->val)
+			hdl->video_bitrate_peak->val = hdl->video_bitrate->val;
+		break;
+	}
+	return 0;
+}
+
+static int cx2341x_s_ctrl(struct v4l2_ctrl *ctrl)
+{
+	static const int mpeg_stream_type[] = {
+		0,	/* MPEG-2 PS */
+		1,	/* MPEG-2 TS */
+		2,	/* MPEG-1 SS */
+		14,	/* DVD */
+		11,	/* VCD */
+		12,	/* SVCD */
+	};
+	struct cx2341x_handler *hdl = to_cxhdl(ctrl);
+	s32 val = ctrl->val;
+	u32 props;
+	int err;
+
+	switch (ctrl->id) {
+	case V4L2_CID_MPEG_STREAM_VBI_FMT:
+		if (hdl->ops && hdl->ops->s_stream_vbi_fmt)
+			return hdl->ops->s_stream_vbi_fmt(hdl, val);
+		return 0;
+
+	case V4L2_CID_MPEG_VIDEO_ASPECT:
+		return cx2341x_hdl_api(hdl,
+			CX2341X_ENC_SET_ASPECT_RATIO, 1, val + 1);
+
+	case V4L2_CID_MPEG_VIDEO_GOP_CLOSURE:
+		return cx2341x_hdl_api(hdl, CX2341X_ENC_SET_GOP_CLOSURE, 1, val);
+
+	case V4L2_CID_MPEG_AUDIO_MUTE:
+		return cx2341x_hdl_api(hdl, CX2341X_ENC_MUTE_AUDIO, 1, val);
+
+	case V4L2_CID_MPEG_VIDEO_TEMPORAL_DECIMATION:
+		return cx2341x_hdl_api(hdl,
+			CX2341X_ENC_SET_FRAME_DROP_RATE, 1, val);
+
+	case V4L2_CID_MPEG_CX2341X_STREAM_INSERT_NAV_PACKETS:
+		return cx2341x_hdl_api(hdl, CX2341X_ENC_MISC, 2, 7, val);
+
+	case V4L2_CID_MPEG_AUDIO_SAMPLING_FREQ:
+		/* audio properties cluster */
+		props = (hdl->audio_sampling_freq->val << 0) |
+			(hdl->audio_mode->val << 8) |
+			(hdl->audio_mode_extension->val << 10) |
+			(hdl->audio_crc->val << 14);
+		if (hdl->audio_emphasis->val == V4L2_MPEG_AUDIO_EMPHASIS_CCITT_J17)
+			props |= 3 << 12;
+		else
+			props |= hdl->audio_emphasis->val << 12;
+
+		if (hdl->audio_encoding->val == V4L2_MPEG_AUDIO_ENCODING_AC3) {
+			props |=
+#if 1
+				/* Not sure if this MPEG Layer II setting is required */
+				((3 - V4L2_MPEG_AUDIO_ENCODING_LAYER_2) << 2) |
+#endif
+				(hdl->audio_ac3_bitrate->val << 4) |
+				(CX2341X_AUDIO_ENCODING_METHOD_AC3 << 28);
+		} else {
+			/* Assuming MPEG Layer II */
+			props |=
+				((3 - hdl->audio_encoding->val) << 2) |
+				((1 + hdl->audio_l2_bitrate->val) << 4);
+		}
+		err = cx2341x_hdl_api(hdl,
+				CX2341X_ENC_SET_AUDIO_PROPERTIES, 1, props);
+		if (err)
+			return err;
+
+		hdl->audio_properties = props;
+		if (hdl->audio_ac3_bitrate) {
+			int is_ac3 = hdl->audio_encoding->val ==
+						V4L2_MPEG_AUDIO_ENCODING_AC3;
+
+			v4l2_ctrl_activate(hdl->audio_ac3_bitrate, is_ac3);
+			v4l2_ctrl_activate(hdl->audio_l2_bitrate, !is_ac3);
+		}
+		v4l2_ctrl_activate(hdl->audio_mode_extension,
+			hdl->audio_mode->val == V4L2_MPEG_AUDIO_MODE_JOINT_STEREO);
+		if (cx2341x_neq(hdl->audio_sampling_freq) &&
+		    hdl->ops && hdl->ops->s_audio_sampling_freq)
+			return hdl->ops->s_audio_sampling_freq(hdl, hdl->audio_sampling_freq->val);
+		if (cx2341x_neq(hdl->audio_mode) &&
+		    hdl->ops && hdl->ops->s_audio_mode)
+			return hdl->ops->s_audio_mode(hdl, hdl->audio_mode->val);
+		return 0;
+
+	case V4L2_CID_MPEG_VIDEO_B_FRAMES:
+		/* video gop cluster */
+		return cx2341x_hdl_api(hdl, CX2341X_ENC_SET_GOP_PROPERTIES, 2,
+				hdl->video_gop_size->val,
+				hdl->video_b_frames->val + 1);
+
+	case V4L2_CID_MPEG_STREAM_TYPE:
+		/* stream type cluster */
+		err = cx2341x_hdl_api(hdl,
+			CX2341X_ENC_SET_STREAM_TYPE, 1, mpeg_stream_type[val]);
+		if (err)
+			return err;
+
+		err = cx2341x_hdl_api(hdl, CX2341X_ENC_SET_BIT_RATE, 5,
+				hdl->video_bitrate_mode->val,
+				hdl->video_bitrate->val,
+				hdl->video_bitrate_peak->val / 400, 0, 0);
+		if (err)
+			return err;
+
+		v4l2_ctrl_activate(hdl->video_bitrate_mode,
+			hdl->video_encoding->val != V4L2_MPEG_VIDEO_ENCODING_MPEG_1);
+		v4l2_ctrl_activate(hdl->video_bitrate_peak,
+			hdl->video_bitrate_mode->val != V4L2_MPEG_VIDEO_BITRATE_MODE_CBR);
+		if (cx2341x_neq(hdl->video_encoding) &&
+		    hdl->ops && hdl->ops->s_video_encoding)
+			return hdl->ops->s_video_encoding(hdl, hdl->video_encoding->val);
+		return 0;
+
+	case V4L2_CID_MPEG_VIDEO_MUTE:
+		/* video mute cluster */
+		return cx2341x_hdl_api(hdl, CX2341X_ENC_MUTE_VIDEO, 1,
+				hdl->video_mute->val |
+					(hdl->video_mute_yuv->val << 8));
+
+	case V4L2_CID_MPEG_CX2341X_VIDEO_SPATIAL_FILTER_MODE: {
+		int active_filter;
+
+		/* video filter mode */
+		err = cx2341x_hdl_api(hdl, CX2341X_ENC_SET_DNR_FILTER_MODE, 2,
+				hdl->video_spatial_filter_mode->val |
+					(hdl->video_temporal_filter_mode->val << 1),
+				hdl->video_median_filter_type->val);
+		if (err)
+			return err;
+
+		active_filter = hdl->video_spatial_filter_mode->val !=
+				V4L2_MPEG_CX2341X_VIDEO_SPATIAL_FILTER_MODE_AUTO;
+		v4l2_ctrl_activate(hdl->video_spatial_filter, active_filter);
+		v4l2_ctrl_activate(hdl->video_luma_spatial_filter_type, active_filter);
+		v4l2_ctrl_activate(hdl->video_chroma_spatial_filter_type, active_filter);
+		active_filter = hdl->video_temporal_filter_mode->val !=
+				V4L2_MPEG_CX2341X_VIDEO_TEMPORAL_FILTER_MODE_AUTO;
+		v4l2_ctrl_activate(hdl->video_temporal_filter, active_filter);
+		active_filter = hdl->video_median_filter_type->val !=
+				V4L2_MPEG_CX2341X_VIDEO_MEDIAN_FILTER_TYPE_OFF;
+		v4l2_ctrl_activate(hdl->video_luma_median_filter_bottom, active_filter);
+		v4l2_ctrl_activate(hdl->video_luma_median_filter_top, active_filter);
+		v4l2_ctrl_activate(hdl->video_chroma_median_filter_bottom, active_filter);
+		v4l2_ctrl_activate(hdl->video_chroma_median_filter_top, active_filter);
+		return 0;
+	}
+
+	case V4L2_CID_MPEG_CX2341X_VIDEO_LUMA_SPATIAL_FILTER_TYPE:
+		/* video filter type cluster */
+		return cx2341x_hdl_api(hdl,
+				CX2341X_ENC_SET_SPATIAL_FILTER_TYPE, 2,
+				hdl->video_luma_spatial_filter_type->val,
+				hdl->video_chroma_spatial_filter_type->val);
+
+	case V4L2_CID_MPEG_CX2341X_VIDEO_SPATIAL_FILTER:
+		/* video filter cluster */
+		return cx2341x_hdl_api(hdl, CX2341X_ENC_SET_DNR_FILTER_PROPS, 2,
+				hdl->video_spatial_filter->val,
+				hdl->video_temporal_filter->val);
+
+	case V4L2_CID_MPEG_CX2341X_VIDEO_LUMA_MEDIAN_FILTER_TOP:
+		/* video median cluster */
+		return cx2341x_hdl_api(hdl, CX2341X_ENC_SET_CORING_LEVELS, 4,
+				hdl->video_luma_median_filter_bottom->val,
+				hdl->video_luma_median_filter_top->val,
+				hdl->video_chroma_median_filter_bottom->val,
+				hdl->video_chroma_median_filter_top->val);
+	}
+	return -EINVAL;
+}
+
+static const struct v4l2_ctrl_ops cx2341x_ops = {
+	.try_ctrl = cx2341x_try_ctrl,
+	.s_ctrl = cx2341x_s_ctrl,
+};
+
+static struct v4l2_ctrl *cx2341x_ctrl_new_custom(struct v4l2_ctrl_handler *hdl,
+			u32 id, s32 min, s32 max, s32 step, s32 def)
+{
+	enum v4l2_ctrl_type type;
+	const char *name;
+	u32 flags;
+
+	cx2341x_ctrl_fill(id, &name, &type, &min, &max, &step, &def, &flags);
+	return v4l2_ctrl_new_custom(hdl, &cx2341x_ops, id,
+			name, type, min, max, step, def, flags,
+			cx2341x_get_menu(id), NULL);
+}
+
+static struct v4l2_ctrl *cx2341x_ctrl_new_std(struct v4l2_ctrl_handler *hdl,
+			u32 id, s32 min, s32 max, s32 step, s32 def)
+{
+	return v4l2_ctrl_new_std(hdl, &cx2341x_ops, id, min, max, step, def);
+}
+
+static struct v4l2_ctrl *cx2341x_ctrl_new_menu(struct v4l2_ctrl_handler *hdl,
+			u32 id, s32 mask, s32 def)
+{
+	return v4l2_ctrl_new_std_menu(hdl, &cx2341x_ops, id, mask, def);
+}
+
+int cx2341x_handler_init(struct cx2341x_handler *cxhdl,
+			 unsigned nr_of_controls_hint)
+{
+	struct v4l2_ctrl_handler *hdl = &cxhdl->hdl;
+	u32 caps = cxhdl->capabilities;
+	int has_sliced_vbi = caps & CX2341X_CAP_HAS_SLICED_VBI;
+	int has_ac3 = caps & CX2341X_CAP_HAS_AC3;
+	int has_ts = caps & CX2341X_CAP_HAS_TS;
+
+	cxhdl->width = 720;
+	cxhdl->height = 480;
+
+	v4l2_ctrl_handler_init(hdl, nr_of_controls_hint);
+
+	/* Add controls in ascending control ID order for fastest
+	   insertion time. */
+	cxhdl->stream_type = cx2341x_ctrl_new_menu(hdl,
+			V4L2_CID_MPEG_STREAM_TYPE, has_ts ? 0 : 2, 0);
+	cxhdl->stream_vbi_fmt = cx2341x_ctrl_new_menu(hdl,
+			V4L2_CID_MPEG_STREAM_VBI_FMT, has_sliced_vbi ? 0 : 2, 0);
+	cxhdl->audio_sampling_freq = cx2341x_ctrl_new_menu(hdl,
+			V4L2_CID_MPEG_AUDIO_SAMPLING_FREQ,
+			0, V4L2_MPEG_AUDIO_SAMPLING_FREQ_48000);
+	cxhdl->audio_encoding = cx2341x_ctrl_new_menu(hdl,
+			V4L2_CID_MPEG_AUDIO_ENCODING,
+			has_ac3 ? ~0x12 : ~0x2, V4L2_MPEG_AUDIO_ENCODING_LAYER_2);
+	cxhdl->audio_l2_bitrate = cx2341x_ctrl_new_std(hdl,
+			V4L2_CID_MPEG_AUDIO_L2_BITRATE,
+			V4L2_MPEG_AUDIO_L2_BITRATE_192K,
+			V4L2_MPEG_AUDIO_L2_BITRATE_384K, 0,
+			V4L2_MPEG_AUDIO_L2_BITRATE_224K);
+	cxhdl->audio_mode = cx2341x_ctrl_new_menu(hdl,
+			V4L2_CID_MPEG_AUDIO_MODE, 0, 0);
+	cxhdl->audio_mode_extension = cx2341x_ctrl_new_menu(hdl,
+			V4L2_CID_MPEG_AUDIO_MODE_EXTENSION, 0, 0);
+	cxhdl->audio_emphasis = cx2341x_ctrl_new_menu(hdl,
+			V4L2_CID_MPEG_AUDIO_EMPHASIS, 0, 0);
+	cxhdl->audio_crc = cx2341x_ctrl_new_menu(hdl,
+			V4L2_CID_MPEG_AUDIO_CRC, 0, 0);
+
+	cx2341x_ctrl_new_std(hdl, V4L2_CID_MPEG_AUDIO_MUTE, 0, 1, 1, 0);
+	if (has_ac3)
+		cxhdl->audio_ac3_bitrate = cx2341x_ctrl_new_std(hdl,
+				V4L2_CID_MPEG_AUDIO_AC3_BITRATE,
+				V4L2_MPEG_AUDIO_AC3_BITRATE_48K,
+				V4L2_MPEG_AUDIO_AC3_BITRATE_448K, 1,
+				V4L2_MPEG_AUDIO_AC3_BITRATE_224K);
+	cxhdl->video_encoding = cx2341x_ctrl_new_std(hdl,
+			V4L2_CID_MPEG_VIDEO_ENCODING,
+			V4L2_MPEG_VIDEO_ENCODING_MPEG_1,
+			V4L2_MPEG_VIDEO_ENCODING_MPEG_2, 0,
+			V4L2_MPEG_VIDEO_ENCODING_MPEG_2);
+	cx2341x_ctrl_new_menu(hdl,
+			V4L2_CID_MPEG_VIDEO_ASPECT,
+			0, V4L2_MPEG_VIDEO_ASPECT_4x3);
+	cxhdl->video_b_frames = cx2341x_ctrl_new_std(hdl,
+			V4L2_CID_MPEG_VIDEO_B_FRAMES, 0, 33, 1, 2);
+	cxhdl->video_gop_size = cx2341x_ctrl_new_std(hdl,
+			V4L2_CID_MPEG_VIDEO_GOP_SIZE,
+			1, 34, 1, cxhdl->is_50hz ? 12 : 15);
+	cx2341x_ctrl_new_std(hdl, V4L2_CID_MPEG_VIDEO_GOP_CLOSURE, 0, 1, 1, 1);
+	cxhdl->video_bitrate_mode = cx2341x_ctrl_new_menu(hdl,
+			V4L2_CID_MPEG_VIDEO_BITRATE_MODE,
+			0, V4L2_MPEG_VIDEO_BITRATE_MODE_VBR);
+	cxhdl->video_bitrate = cx2341x_ctrl_new_std(hdl,
+			V4L2_CID_MPEG_VIDEO_BITRATE,
+			0, 27000000, 1, 6000000);
+	cxhdl->video_bitrate_peak = cx2341x_ctrl_new_std(hdl,
+			V4L2_CID_MPEG_VIDEO_BITRATE_PEAK,
+			0, 27000000, 1, 8000000);
+	cx2341x_ctrl_new_std(hdl,
+			V4L2_CID_MPEG_VIDEO_TEMPORAL_DECIMATION, 0, 255, 1, 0);
+	cxhdl->video_mute = cx2341x_ctrl_new_std(hdl,
+			V4L2_CID_MPEG_VIDEO_MUTE, 0, 1, 1, 0);
+	cxhdl->video_mute_yuv = cx2341x_ctrl_new_std(hdl,
+			V4L2_CID_MPEG_VIDEO_MUTE_YUV, 0, 0xffffff, 1, 0x008080);
+
+	/* CX23415/6 specific */
+	cxhdl->video_spatial_filter_mode = cx2341x_ctrl_new_custom(hdl,
+			V4L2_CID_MPEG_CX2341X_VIDEO_SPATIAL_FILTER_MODE,
+			V4L2_MPEG_CX2341X_VIDEO_SPATIAL_FILTER_MODE_MANUAL,
+			V4L2_MPEG_CX2341X_VIDEO_SPATIAL_FILTER_MODE_AUTO, 0,
+			V4L2_MPEG_CX2341X_VIDEO_SPATIAL_FILTER_MODE_MANUAL);
+	cxhdl->video_spatial_filter = cx2341x_ctrl_new_custom(hdl,
+			V4L2_CID_MPEG_CX2341X_VIDEO_SPATIAL_FILTER,
+			0, 15, 1, 0);
+	cxhdl->video_luma_spatial_filter_type = cx2341x_ctrl_new_custom(hdl,
+			V4L2_CID_MPEG_CX2341X_VIDEO_LUMA_SPATIAL_FILTER_TYPE,
+			V4L2_MPEG_CX2341X_VIDEO_LUMA_SPATIAL_FILTER_TYPE_OFF,
+			V4L2_MPEG_CX2341X_VIDEO_LUMA_SPATIAL_FILTER_TYPE_2D_SYM_NON_SEPARABLE,
+			0,
+			V4L2_MPEG_CX2341X_VIDEO_LUMA_SPATIAL_FILTER_TYPE_1D_HOR);
+	cxhdl->video_chroma_spatial_filter_type = cx2341x_ctrl_new_custom(hdl,
+			V4L2_CID_MPEG_CX2341X_VIDEO_CHROMA_SPATIAL_FILTER_TYPE,
+			V4L2_MPEG_CX2341X_VIDEO_CHROMA_SPATIAL_FILTER_TYPE_OFF,
+			V4L2_MPEG_CX2341X_VIDEO_CHROMA_SPATIAL_FILTER_TYPE_1D_HOR,
+			0,
+			V4L2_MPEG_CX2341X_VIDEO_CHROMA_SPATIAL_FILTER_TYPE_1D_HOR);
+	cxhdl->video_temporal_filter_mode = cx2341x_ctrl_new_custom(hdl,
+			V4L2_CID_MPEG_CX2341X_VIDEO_TEMPORAL_FILTER_MODE,
+			V4L2_MPEG_CX2341X_VIDEO_TEMPORAL_FILTER_MODE_MANUAL,
+			V4L2_MPEG_CX2341X_VIDEO_TEMPORAL_FILTER_MODE_AUTO,
+			0,
+			V4L2_MPEG_CX2341X_VIDEO_TEMPORAL_FILTER_MODE_MANUAL);
+	cxhdl->video_temporal_filter = cx2341x_ctrl_new_custom(hdl,
+			V4L2_CID_MPEG_CX2341X_VIDEO_TEMPORAL_FILTER,
+			0, 31, 1, 8);
+	cxhdl->video_median_filter_type = cx2341x_ctrl_new_custom(hdl,
+			V4L2_CID_MPEG_CX2341X_VIDEO_MEDIAN_FILTER_TYPE,
+			V4L2_MPEG_CX2341X_VIDEO_MEDIAN_FILTER_TYPE_OFF,
+			V4L2_MPEG_CX2341X_VIDEO_MEDIAN_FILTER_TYPE_DIAG,
+			0,
+			V4L2_MPEG_CX2341X_VIDEO_MEDIAN_FILTER_TYPE_OFF);
+	cxhdl->video_luma_median_filter_bottom = cx2341x_ctrl_new_custom(hdl,
+			V4L2_CID_MPEG_CX2341X_VIDEO_LUMA_MEDIAN_FILTER_BOTTOM,
+			0, 255, 1, 0);
+	cxhdl->video_luma_median_filter_top = cx2341x_ctrl_new_custom(hdl,
+			V4L2_CID_MPEG_CX2341X_VIDEO_LUMA_MEDIAN_FILTER_TOP,
+			0, 255, 1, 255);
+	cxhdl->video_chroma_median_filter_bottom = cx2341x_ctrl_new_custom(hdl,
+			V4L2_CID_MPEG_CX2341X_VIDEO_CHROMA_MEDIAN_FILTER_BOTTOM,
+			0, 255, 1, 0);
+	cxhdl->video_chroma_median_filter_top = cx2341x_ctrl_new_custom(hdl,
+			V4L2_CID_MPEG_CX2341X_VIDEO_CHROMA_MEDIAN_FILTER_TOP,
+			0, 255, 1, 255);
+	cx2341x_ctrl_new_custom(hdl, V4L2_CID_MPEG_CX2341X_STREAM_INSERT_NAV_PACKETS,
+			0, 1, 1, 0);
+
+	if (hdl->error) {
+		int err = hdl->error;
+
+		v4l2_ctrl_handler_free(hdl);
+		return err;
+	}
+
+	v4l2_ctrl_cluster(8, &cxhdl->audio_sampling_freq);
+	v4l2_ctrl_cluster(2, &cxhdl->video_b_frames);
+	v4l2_ctrl_cluster(5, &cxhdl->stream_type);
+	v4l2_ctrl_cluster(2, &cxhdl->video_mute);
+	v4l2_ctrl_cluster(3, &cxhdl->video_spatial_filter_mode);
+	v4l2_ctrl_cluster(2, &cxhdl->video_luma_spatial_filter_type);
+	v4l2_ctrl_cluster(2, &cxhdl->video_spatial_filter);
+	v4l2_ctrl_cluster(4, &cxhdl->video_luma_median_filter_top);
+
+	return 0;
+}
+EXPORT_SYMBOL(cx2341x_handler_init);
+
+void cx2341x_handler_set_50hz(struct cx2341x_handler *cxhdl, int is_50hz)
+{
+	cxhdl->is_50hz = is_50hz;
+	cxhdl->video_gop_size->default_value = cxhdl->is_50hz ? 12 : 15;
+}
+EXPORT_SYMBOL(cx2341x_handler_set_50hz);
+
+int cx2341x_handler_setup(struct cx2341x_handler *cxhdl)
+{
+	int h = cxhdl->height;
+	int w = cxhdl->width;
+	int err;
+
+	err = cx2341x_hdl_api(cxhdl, CX2341X_ENC_SET_OUTPUT_PORT, 2, cxhdl->port, 0);
+	if (err)
+		return err;
+	err = cx2341x_hdl_api(cxhdl, CX2341X_ENC_SET_FRAME_RATE, 1, cxhdl->is_50hz);
+	if (err)
+		return err;
+
+	if (v4l2_ctrl_g(cxhdl->video_encoding) == V4L2_MPEG_VIDEO_ENCODING_MPEG_1) {
+		w /= 2;
+		h /= 2;
+	}
+	err = cx2341x_hdl_api(cxhdl, CX2341X_ENC_SET_FRAME_SIZE, 2, h, w);
+	if (err)
+		return err;
+	return v4l2_ctrl_handler_setup(&cxhdl->hdl);
+}
+EXPORT_SYMBOL(cx2341x_handler_setup);
+
+void cx2341x_handler_set_busy(struct cx2341x_handler *cxhdl, int busy)
+{
+	v4l2_ctrl_grab(cxhdl->audio_sampling_freq, busy);
+	v4l2_ctrl_grab(cxhdl->audio_encoding, busy);
+	v4l2_ctrl_grab(cxhdl->audio_l2_bitrate, busy);
+	v4l2_ctrl_grab(cxhdl->audio_ac3_bitrate, busy);
+	v4l2_ctrl_grab(cxhdl->stream_vbi_fmt, busy);
+	v4l2_ctrl_grab(cxhdl->stream_type, busy);
+	v4l2_ctrl_grab(cxhdl->video_bitrate_mode, busy);
+	v4l2_ctrl_grab(cxhdl->video_bitrate, busy);
+	v4l2_ctrl_grab(cxhdl->video_bitrate_peak, busy);
+}
+EXPORT_SYMBOL(cx2341x_handler_set_busy);
diff --git a/include/media/cx2341x.h b/include/media/cx2341x.h
index 9ebe855..91cdd07 100644
--- a/include/media/cx2341x.h
+++ b/include/media/cx2341x.h
@@ -19,6 +19,8 @@
 #ifndef CX2341X_H
 #define CX2341X_H
 
+#include <media/v4l2-ctrls.h>
+
 enum cx2341x_port {
 	CX2341X_PORT_MEMORY    = 0,
 	CX2341X_PORT_STREAMING = 1,
@@ -99,6 +101,85 @@ int cx2341x_ext_ctrls(struct cx2341x_mpeg_params *params, int busy,
 void cx2341x_fill_defaults(struct cx2341x_mpeg_params *p);
 void cx2341x_log_status(const struct cx2341x_mpeg_params *p, const char *prefix);
 
+struct cx2341x_handler;
+
+struct cx2341x_handler_ops {
+	/* needed for the video clock freq */
+	int (*s_audio_sampling_freq)(struct cx2341x_handler *hdl, u32 val);
+	/* needed for dualwatch */
+	int (*s_audio_mode)(struct cx2341x_handler *hdl, u32 val);
+	/* needed for setting up the video resolution */
+	int (*s_video_encoding)(struct cx2341x_handler *hdl, u32 val);
+	/* needed for setting up the sliced vbi insertion data structures */
+	int (*s_stream_vbi_fmt)(struct cx2341x_handler *hdl, u32 val);
+};
+
+struct cx2341x_handler {
+	u32 capabilities;
+	enum cx2341x_port port;
+	u16 width;
+	u16 height;
+	u16 is_50hz;
+	u32 audio_properties;
+
+	struct v4l2_ctrl_handler hdl;
+	void *priv;
+	cx2341x_mbox_func func;
+	const struct cx2341x_handler_ops *ops;
+
+	struct v4l2_ctrl *stream_vbi_fmt;
+
+	/* audio cluster */
+	struct v4l2_ctrl *audio_sampling_freq;
+	struct v4l2_ctrl *audio_encoding;
+	struct v4l2_ctrl *audio_l2_bitrate;
+	struct v4l2_ctrl *audio_mode;
+	struct v4l2_ctrl *audio_mode_extension;
+	struct v4l2_ctrl *audio_emphasis;
+	struct v4l2_ctrl *audio_crc;
+	struct v4l2_ctrl *audio_ac3_bitrate;
+
+	/* video gop cluster */
+	struct v4l2_ctrl *video_b_frames;
+	struct v4l2_ctrl *video_gop_size;
+
+	/* stream type cluster */
+	struct v4l2_ctrl *stream_type;
+	struct v4l2_ctrl *video_encoding;
+	struct v4l2_ctrl *video_bitrate_mode;
+	struct v4l2_ctrl *video_bitrate;
+	struct v4l2_ctrl *video_bitrate_peak;
+
+	/* video mute cluster */
+	struct v4l2_ctrl *video_mute;
+	struct v4l2_ctrl *video_mute_yuv;
+
+	/* video filter mode cluster */
+	struct v4l2_ctrl *video_spatial_filter_mode;
+	struct v4l2_ctrl *video_temporal_filter_mode;
+	struct v4l2_ctrl *video_median_filter_type;
+
+	/* video filter type cluster */
+	struct v4l2_ctrl *video_luma_spatial_filter_type;
+	struct v4l2_ctrl *video_chroma_spatial_filter_type;
+
+	/* video filter cluster */
+	struct v4l2_ctrl *video_spatial_filter;
+	struct v4l2_ctrl *video_temporal_filter;
+
+	/* video median cluster */
+	struct v4l2_ctrl *video_luma_median_filter_top;
+	struct v4l2_ctrl *video_luma_median_filter_bottom;
+	struct v4l2_ctrl *video_chroma_median_filter_top;
+	struct v4l2_ctrl *video_chroma_median_filter_bottom;
+};
+
+int cx2341x_handler_init(struct cx2341x_handler *cxhdl,
+			 unsigned nr_of_controls_hint);
+void cx2341x_handler_set_50hz(struct cx2341x_handler *cxhdl, int is_50hz);
+int cx2341x_handler_setup(struct cx2341x_handler *cxhdl);
+void cx2341x_handler_set_busy(struct cx2341x_handler *cxhdl, int busy);
+
 /* Firmware names */
 #define CX2341X_FIRM_ENC_FILENAME "v4l-cx2341x-enc.fw"
 /* Decoder firmware for the cx23415 only */
-- 
1.6.4.2

