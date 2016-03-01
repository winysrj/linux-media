Return-path: <linux-media-owner@vger.kernel.org>
Received: from sg-smtp01.263.net ([54.255.195.220]:34211 "EHLO
	sg-smtp01.263.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764AbcCACaE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Feb 2016 21:30:04 -0500
From: Jung Zhao <jung.zhao@rock-chips.com>
To: tfiga@chromium.org, posciak@chromium.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-rockchip@lists.infradead.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, Pawel Osciak <posciak@google.com>,
	eddie.cai@rock-chips.com, alpha.lin@rock-chips.com,
	jeffy.chen@rock-chips.com, herman.chen@rock-chips.com
Subject: [PATCH v3 2/3] [NOT FOR REVIEW] v4l: Add VP8 low-level decoder API controls.
Date: Tue,  1 Mar 2016 10:23:37 +0800
Message-Id: <1456799017-8612-1-git-send-email-jung.zhao@rock-chips.com>
In-Reply-To: <1456798977-8514-1-git-send-email-jung.zhao@rock-chips.com>
References: <1456798977-8514-1-git-send-email-jung.zhao@rock-chips.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Pawel Osciak <posciak@chromium.org>

These controls are to be used with the new low-level decoder API for VP8
to provide additional parameters for the hardware that cannot parse the
input stream.

Signed-off-by: Pawel Osciak <posciak@chromium.org>
Signed-off-by: Jeffy Chen <jeffy.chen@rock-chips.com>
Signed-off-by: Jung Zhao <jung.zhao@rock-chips.com>
---
Changes in v3: None
Changes in v2: None

 drivers/media/v4l2-core/v4l2-ctrls.c |  9 ++++
 drivers/media/v4l2-core/v4l2-ioctl.c |  1 +
 include/media/v4l2-ctrls.h           |  2 +
 include/uapi/linux/v4l2-controls.h   | 94 ++++++++++++++++++++++++++++++++++++
 include/uapi/linux/videodev2.h       |  3 ++
 5 files changed, 109 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 527d65c..ffc513e 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -762,6 +762,8 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_MPEG_VIDEO_VPX_P_FRAME_QP:		return "VPX P-Frame QP Value";
 	case V4L2_CID_MPEG_VIDEO_VPX_PROFILE:			return "VPX Profile";
 
+	case V4L2_CID_MPEG_VIDEO_VP8_FRAME_HDR:			return "VP8 Frame Header";
+
 	/* CAMERA controls */
 	/* Keep the order of the 'case's the same as in v4l2-controls.h! */
 	case V4L2_CID_CAMERA_CLASS:		return "Camera Controls";
@@ -1126,6 +1128,9 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_RDS_TX_ALT_FREQS:
 		*type = V4L2_CTRL_TYPE_U32;
 		break;
+	case V4L2_CID_MPEG_VIDEO_VP8_FRAME_HDR:
+		*type = V4L2_CTRL_TYPE_VP8_FRAME_HDR;
+		break;
 	default:
 		*type = V4L2_CTRL_TYPE_INTEGER;
 		break;
@@ -1529,6 +1534,7 @@ static int std_validate(const struct v4l2_ctrl *ctrl, u32 idx,
 	case V4L2_CTRL_TYPE_PRIVATE:
 		return 0;
 
+	case V4L2_CTRL_TYPE_VP8_FRAME_HDR:
 	default:
 		return -EINVAL;
 	}
@@ -2078,6 +2084,9 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
 	case V4L2_CTRL_TYPE_U32:
 		elem_size = sizeof(u32);
 		break;
+	case V4L2_CTRL_TYPE_VP8_FRAME_HDR:
+		elem_size = sizeof(struct v4l2_ctrl_vp8_frame_hdr);
+		break;
 	default:
 		if (type < V4L2_CTRL_COMPOUND_TYPES)
 			elem_size = sizeof(s32);
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 7d028d1..915dc2c 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -1259,6 +1259,7 @@ static void v4l_fill_fmtdesc(struct v4l2_fmtdesc *fmt)
 		case V4L2_PIX_FMT_VC1_ANNEX_G:	descr = "VC-1 (SMPTE 412M Annex G)"; break;
 		case V4L2_PIX_FMT_VC1_ANNEX_L:	descr = "VC-1 (SMPTE 412M Annex L)"; break;
 		case V4L2_PIX_FMT_VP8:		descr = "VP8"; break;
+		case V4L2_PIX_FMT_VP8_FRAME:	descr = "VP8 FRAME"; break;
 		case V4L2_PIX_FMT_CPIA1:	descr = "GSPCA CPiA YUV"; break;
 		case V4L2_PIX_FMT_WNVA:		descr = "WNVA"; break;
 		case V4L2_PIX_FMT_SN9C10X:	descr = "GSPCA SN9C10X"; break;
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index 5f9526f..0424cdc 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -46,6 +46,7 @@ struct poll_table_struct;
  * @p_u16:	Pointer to a 16-bit unsigned value.
  * @p_u32:	Pointer to a 32-bit unsigned value.
  * @p_char:	Pointer to a string.
+ * @p_vp8_frame_hdr:	Pointer to a struct v4l2_ctrl_vp8_frame_hdr.
  * @p:		Pointer to a compound value.
  */
 union v4l2_ctrl_ptr {
@@ -55,6 +56,7 @@ union v4l2_ctrl_ptr {
 	u16 *p_u16;
 	u32 *p_u32;
 	char *p_char;
+	struct v4l2_ctrl_vp8_frame_hdr *p_vp8_frame_hdr;
 	void *p;
 };
 
diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index 2d225bc..894de37 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -578,6 +578,8 @@ enum v4l2_vp8_golden_frame_sel {
 #define V4L2_CID_MPEG_VIDEO_VPX_P_FRAME_QP		(V4L2_CID_MPEG_BASE+510)
 #define V4L2_CID_MPEG_VIDEO_VPX_PROFILE			(V4L2_CID_MPEG_BASE+511)
 
+#define V4L2_CID_MPEG_VIDEO_VP8_FRAME_HDR		(V4L2_CID_MPEG_BASE+512)
+
 /*  MPEG-class control IDs specific to the CX2341x driver as defined by V4L2 */
 #define V4L2_CID_MPEG_CX2341X_BASE 				(V4L2_CTRL_CLASS_MPEG | 0x1000)
 #define V4L2_CID_MPEG_CX2341X_VIDEO_SPATIAL_FILTER_MODE 	(V4L2_CID_MPEG_CX2341X_BASE+0)
@@ -963,4 +965,96 @@ enum v4l2_detect_md_mode {
 #define V4L2_CID_DETECT_MD_THRESHOLD_GRID	(V4L2_CID_DETECT_CLASS_BASE + 3)
 #define V4L2_CID_DETECT_MD_REGION_GRID		(V4L2_CID_DETECT_CLASS_BASE + 4)
 
+#define V4L2_VP8_SEGMNT_HDR_FLAG_ENABLED              0x01
+#define V4L2_VP8_SEGMNT_HDR_FLAG_UPDATE_MAP           0x02
+#define V4L2_VP8_SEGMNT_HDR_FLAG_UPDATE_FEATURE_DATA  0x04
+struct v4l2_vp8_sgmnt_hdr {
+	__u8 segment_feature_mode;
+
+	__s8 quant_update[4];
+	__s8 lf_update[4];
+	__u8 segment_probs[3];
+
+	__u8 flags;
+};
+
+#define V4L2_VP8_LF_HDR_ADJ_ENABLE	0x01
+#define V4L2_VP8_LF_HDR_DELTA_UPDATE	0x02
+struct v4l2_vp8_loopfilter_hdr {
+	__u8 type;
+	__u8 level;
+	__u8 sharpness_level;
+	__s8 ref_frm_delta_magnitude[4];
+	__s8 mb_mode_delta_magnitude[4];
+
+	__u8 flags;
+};
+
+struct v4l2_vp8_quantization_hdr {
+	__u8 y_ac_qi;
+	__s8 y_dc_delta;
+	__s8 y2_dc_delta;
+	__s8 y2_ac_delta;
+	__s8 uv_dc_delta;
+	__s8 uv_ac_delta;
+	__u16 dequant_factors[4][3][2];
+};
+
+struct v4l2_vp8_entropy_hdr {
+	__u8 coeff_probs[4][8][3][11];
+	__u8 y_mode_probs[4];
+	__u8 uv_mode_probs[3];
+	__u8 mv_probs[2][19];
+};
+
+#define V4L2_VP8_FRAME_HDR_FLAG_EXPERIMENTAL		0x01
+#define V4L2_VP8_FRAME_HDR_FLAG_SHOW_FRAME		0x02
+#define V4L2_VP8_FRAME_HDR_FLAG_MB_NO_SKIP_COEFF	0x04
+struct v4l2_ctrl_vp8_frame_hdr {
+	/* 0: keyframe, 1: not a keyframe */
+	__u8 key_frame;
+	__u8 version;
+
+	/* Populated also if not a key frame */
+	__u16 width;
+	__u8 horizontal_scale;
+	__u16 height;
+	__u8 vertical_scale;
+
+	struct v4l2_vp8_sgmnt_hdr sgmnt_hdr;
+	struct v4l2_vp8_loopfilter_hdr lf_hdr;
+	struct v4l2_vp8_quantization_hdr quant_hdr;
+	struct v4l2_vp8_entropy_hdr entropy_hdr;
+
+	__u8 sign_bias_golden;
+	__u8 sign_bias_alternate;
+
+	__u8 prob_skip_false;
+	__u8 prob_intra;
+	__u8 prob_last;
+	__u8 prob_gf;
+
+	__u32 first_part_size;
+	__u32 first_part_offset;
+	/*
+	 * Offset in bits of MB data in first partition,
+	 * i.e. bit offset starting from first_part_offset.
+	 */
+	__u32 macroblock_bit_offset;
+
+	__u8 num_dct_parts;
+	__u32 dct_part_sizes[8];
+
+	__u8 bool_dec_range;
+	__u8 bool_dec_value;
+	__u8 bool_dec_count;
+
+	/* v4l2_buffer indices of reference frames */
+	__u32 last_frame;
+	__u32 golden_frame;
+	__u32 alt_frame;
+
+	__u8 flags;
+};
+
 #endif
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 53ac896..1493ec4 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -593,6 +593,7 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_VC1_ANNEX_G v4l2_fourcc('V', 'C', '1', 'G') /* SMPTE 421M Annex G compliant stream */
 #define V4L2_PIX_FMT_VC1_ANNEX_L v4l2_fourcc('V', 'C', '1', 'L') /* SMPTE 421M Annex L compliant stream */
 #define V4L2_PIX_FMT_VP8      v4l2_fourcc('V', 'P', '8', '0') /* VP8 */
+#define V4L2_PIX_FMT_VP8_FRAME v4l2_fourcc('V', 'P', '8', 'F') /* VP8 parsed frames */
 
 /*  Vendor-specific formats   */
 #define V4L2_PIX_FMT_CPIA1    v4l2_fourcc('C', 'P', 'I', 'A') /* cpia1 YUV */
@@ -1473,6 +1474,7 @@ struct v4l2_ext_control {
 		__u8 __user *p_u8;
 		__u16 __user *p_u16;
 		__u32 __user *p_u32;
+		struct v4l2_ctrl_vp8_frame_hdr __user *p_vp8_frame_hdr;
 		void __user *ptr;
 	};
 } __attribute__ ((packed));
@@ -1517,6 +1519,7 @@ enum v4l2_ctrl_type {
 	V4L2_CTRL_TYPE_U8	     = 0x0100,
 	V4L2_CTRL_TYPE_U16	     = 0x0101,
 	V4L2_CTRL_TYPE_U32	     = 0x0102,
+	V4L2_CTRL_TYPE_VP8_FRAME_HDR	= 0x108,
 
 	V4L2_CTRL_TYPE_PRIVATE       = 0xffff,
 };
-- 
1.9.1

