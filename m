Return-path: <linux-media-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:34187 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1757887AbcHYJkI (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 25 Aug 2016 05:40:08 -0400
From: Florent Revest <florent.revest@free-electrons.com>
To: linux-media@vger.kernel.org
Cc: florent.revest@free-electrons.com, linux-sunxi@googlegroups.com,
        maxime.ripard@free-electrons.com, posciak@chromium.org,
        hans.verkuil@cisco.com, thomas.petazzoni@free-electrons.com,
        mchehab@kernel.org, linux-kernel@vger.kernel.org, wens@csie.org
Subject: [RFC 04/10] v4l: Add MPEG2 low-level decoder API control
Date: Thu, 25 Aug 2016 11:39:43 +0200
Message-Id: <1472117989-21455-5-git-send-email-florent.revest@free-electrons.com>
In-Reply-To: <1472117989-21455-1-git-send-email-florent.revest@free-electrons.com>
References: <1472117989-21455-1-git-send-email-florent.revest@free-electrons.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This control is to be used with the new low-level decoder API for
MPEG2 to provide additional parameters for the hardware that cannot parse
the input stream.

Signed-off-by: Florent Revest <florent.revest@free-electrons.com>
---
 drivers/media/v4l2-core/v4l2-ctrls.c | 11 +++++++++++
 drivers/media/v4l2-core/v4l2-ioctl.c |  1 +
 include/uapi/linux/v4l2-controls.h   | 26 ++++++++++++++++++++++++++
 include/uapi/linux/videodev2.h       |  3 +++
 4 files changed, 41 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 60056b0..331d009 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -760,6 +760,8 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_MPEG_VIDEO_REPEAT_SEQ_HEADER:		return "Repeat Sequence Header";
 	case V4L2_CID_MPEG_VIDEO_FORCE_KEY_FRAME:		return "Force Key Frame";
 
+	case V4L2_CID_MPEG_VIDEO_MPEG2_FRAME_HDR:		return "MPEG2 Frame Header";
+
 	/* VPX controls */
 	case V4L2_CID_MPEG_VIDEO_VPX_NUM_PARTITIONS:		return "VPX Number of Partitions";
 	case V4L2_CID_MPEG_VIDEO_VPX_IMD_DISABLE_4X4:		return "VPX Intra Mode Decision Disable";
@@ -1143,6 +1145,9 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_RDS_TX_ALT_FREQS:
 		*type = V4L2_CTRL_TYPE_U32;
 		break;
+	case V4L2_CID_MPEG_VIDEO_MPEG2_FRAME_HDR:
+		*type = V4L2_CTRL_TYPE_MPEG2_FRAME_HDR;
+		break;
 	default:
 		*type = V4L2_CTRL_TYPE_INTEGER;
 		break;
@@ -1543,6 +1548,9 @@ static int std_validate(const struct v4l2_ctrl *ctrl, u32 idx,
 			return -ERANGE;
 		return 0;
 
+	case V4L2_CTRL_TYPE_MPEG2_FRAME_HDR:
+		return 0;
+
 	/* FIXME:just return 0 for now */
 	case V4L2_CTRL_TYPE_PRIVATE:
 		return 0;
@@ -2096,6 +2104,9 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
 	case V4L2_CTRL_TYPE_U32:
 		elem_size = sizeof(u32);
 		break;
+	case V4L2_CTRL_TYPE_MPEG2_FRAME_HDR:
+		elem_size = sizeof(struct v4l2_ctrl_mpeg2_frame_hdr);
+		break;
 	default:
 		if (type < V4L2_CTRL_COMPOUND_TYPES)
 			elem_size = sizeof(s32);
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index f19b666..de382a1 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -1273,6 +1273,7 @@ static void v4l_fill_fmtdesc(struct v4l2_fmtdesc *fmt)
 		case V4L2_PIX_FMT_VC1_ANNEX_G:	descr = "VC-1 (SMPTE 412M Annex G)"; break;
 		case V4L2_PIX_FMT_VC1_ANNEX_L:	descr = "VC-1 (SMPTE 412M Annex L)"; break;
 		case V4L2_PIX_FMT_VP8:		descr = "VP8"; break;
+		case V4L2_PIX_FMT_MPEG2_FRAME:	descr = "MPEG2 FRAME"; break;
 		case V4L2_PIX_FMT_CPIA1:	descr = "GSPCA CPiA YUV"; break;
 		case V4L2_PIX_FMT_WNVA:		descr = "WNVA"; break;
 		case V4L2_PIX_FMT_SN9C10X:	descr = "GSPCA SN9C10X"; break;
diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index b6a357a..cdf9497 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -547,6 +547,8 @@ enum v4l2_mpeg_video_mpeg4_profile {
 };
 #define V4L2_CID_MPEG_VIDEO_MPEG4_QPEL		(V4L2_CID_MPEG_BASE+407)
 
+#define V4L2_CID_MPEG_VIDEO_MPEG2_FRAME_HDR     (V4L2_CID_MPEG_BASE+450)
+
 /*  Control IDs for VP8 streams
  *  Although VP8 is not part of MPEG we add these controls to the MPEG class
  *  as that class is already handling other video compression standards
@@ -974,4 +976,28 @@ enum v4l2_detect_md_mode {
 #define V4L2_CID_DETECT_MD_THRESHOLD_GRID	(V4L2_CID_DETECT_CLASS_BASE + 3)
 #define V4L2_CID_DETECT_MD_REGION_GRID		(V4L2_CID_DETECT_CLASS_BASE + 4)
 
+struct v4l2_ctrl_mpeg2_frame_hdr {
+	__u32 slice_len;
+	__u32 slice_pos;
+	enum { MPEG1, MPEG2 } type;
+
+	__u16 width;
+	__u16 height;
+
+	enum { PCT_I = 1, PCT_P, PCT_B, PCT_D } picture_coding_type;
+	__u8 f_code[2][2];
+
+	__u8 intra_dc_precision;
+	__u8 picture_structure;
+	__u8 top_field_first;
+	__u8 frame_pred_frame_dct;
+	__u8 concealment_motion_vectors;
+	__u8 q_scale_type;
+	__u8 intra_vlc_format;
+	__u8 alternate_scan;
+
+	__u8 backward_index;
+	__u8 forward_index;
+};
+
 #endif
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 96e034d..feff200 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -596,6 +596,7 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_VC1_ANNEX_G v4l2_fourcc('V', 'C', '1', 'G') /* SMPTE 421M Annex G compliant stream */
 #define V4L2_PIX_FMT_VC1_ANNEX_L v4l2_fourcc('V', 'C', '1', 'L') /* SMPTE 421M Annex L compliant stream */
 #define V4L2_PIX_FMT_VP8      v4l2_fourcc('V', 'P', '8', '0') /* VP8 */
+#define V4L2_PIX_FMT_MPEG2_FRAME  v4l2_fourcc('M', 'G', '2', 'F') /* MPEG2 frame */
 
 /*  Vendor-specific formats   */
 #define V4L2_PIX_FMT_CPIA1    v4l2_fourcc('C', 'P', 'I', 'A') /* cpia1 YUV */
@@ -1478,6 +1479,7 @@ struct v4l2_ext_control {
 		__u8 __user *p_u8;
 		__u16 __user *p_u16;
 		__u32 __user *p_u32;
+		struct v4l2_ctrl_mpeg2_frame_hdr __user *p_mpeg2_frame_hdr;
 		void __user *ptr;
 	};
 } __attribute__ ((packed));
@@ -1522,6 +1524,7 @@ enum v4l2_ctrl_type {
 	V4L2_CTRL_TYPE_U8	     = 0x0100,
 	V4L2_CTRL_TYPE_U16	     = 0x0101,
 	V4L2_CTRL_TYPE_U32	     = 0x0102,
+	V4L2_CTRL_TYPE_MPEG2_FRAME_HDR  = 0x0109,
 
 	V4L2_CTRL_TYPE_PRIVATE       = 0xffff,
 };
-- 
2.7.4

