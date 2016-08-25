Return-path: <linux-media-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:34231 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1759034AbcHYJka (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 25 Aug 2016 05:40:30 -0400
From: Florent Revest <florent.revest@free-electrons.com>
To: linux-media@vger.kernel.org
Cc: florent.revest@free-electrons.com, linux-sunxi@googlegroups.com,
        maxime.ripard@free-electrons.com, posciak@chromium.org,
        hans.verkuil@cisco.com, thomas.petazzoni@free-electrons.com,
        mchehab@kernel.org, linux-kernel@vger.kernel.org, wens@csie.org
Subject: [RFC 05/10] v4l: Add MPEG4 low-level decoder API control
Date: Thu, 25 Aug 2016 11:39:44 +0200
Message-Id: <1472117989-21455-6-git-send-email-florent.revest@free-electrons.com>
In-Reply-To: <1472117989-21455-1-git-send-email-florent.revest@free-electrons.com>
References: <1472117989-21455-1-git-send-email-florent.revest@free-electrons.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This control is to be used with the new low-level decoder API for MPEG4
to provide additional parameters for the hardware that cannot parse the
input stream.

Some fields are still missing for this structure to be complete.

Signed-off-by: Florent Revest <florent.revest@free-electrons.com>
---
 drivers/media/v4l2-core/v4l2-ctrls.c |  8 +++++++
 drivers/media/v4l2-core/v4l2-ioctl.c |  1 +
 include/uapi/linux/v4l2-controls.h   | 42 ++++++++++++++++++++++++++++++++++++
 include/uapi/linux/videodev2.h       |  3 +++
 4 files changed, 54 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 331d009..302c744 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -761,6 +761,7 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_MPEG_VIDEO_FORCE_KEY_FRAME:		return "Force Key Frame";
 
 	case V4L2_CID_MPEG_VIDEO_MPEG2_FRAME_HDR:		return "MPEG2 Frame Header";
+	case V4L2_CID_MPEG_VIDEO_MPEG4_FRAME_HDR:		return "MPEG4 Frame Header";
 
 	/* VPX controls */
 	case V4L2_CID_MPEG_VIDEO_VPX_NUM_PARTITIONS:		return "VPX Number of Partitions";
@@ -1148,6 +1149,9 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_MPEG_VIDEO_MPEG2_FRAME_HDR:
 		*type = V4L2_CTRL_TYPE_MPEG2_FRAME_HDR;
 		break;
+	case V4L2_CID_MPEG_VIDEO_MPEG4_FRAME_HDR:
+		*type = V4L2_CTRL_TYPE_MPEG4_FRAME_HDR;
+		break;
 	default:
 		*type = V4L2_CTRL_TYPE_INTEGER;
 		break;
@@ -1549,6 +1553,7 @@ static int std_validate(const struct v4l2_ctrl *ctrl, u32 idx,
 		return 0;
 
 	case V4L2_CTRL_TYPE_MPEG2_FRAME_HDR:
+	case V4L2_CTRL_TYPE_MPEG4_FRAME_HDR:
 		return 0;
 
 	/* FIXME:just return 0 for now */
@@ -2107,6 +2112,9 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
 	case V4L2_CTRL_TYPE_MPEG2_FRAME_HDR:
 		elem_size = sizeof(struct v4l2_ctrl_mpeg2_frame_hdr);
 		break;
+	case V4L2_CTRL_TYPE_MPEG4_FRAME_HDR:
+		elem_size = sizeof(struct v4l2_ctrl_mpeg4_frame_hdr);
+		break;
 	default:
 		if (type < V4L2_CTRL_COMPOUND_TYPES)
 			elem_size = sizeof(s32);
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index de382a1..be7973e 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -1274,6 +1274,7 @@ static void v4l_fill_fmtdesc(struct v4l2_fmtdesc *fmt)
 		case V4L2_PIX_FMT_VC1_ANNEX_L:	descr = "VC-1 (SMPTE 412M Annex L)"; break;
 		case V4L2_PIX_FMT_VP8:		descr = "VP8"; break;
 		case V4L2_PIX_FMT_MPEG2_FRAME:	descr = "MPEG2 FRAME"; break;
+		case V4L2_PIX_FMT_MPEG4_FRAME:	descr = "MPEG4 FRAME"; break;
 		case V4L2_PIX_FMT_CPIA1:	descr = "GSPCA CPiA YUV"; break;
 		case V4L2_PIX_FMT_WNVA:		descr = "WNVA"; break;
 		case V4L2_PIX_FMT_SN9C10X:	descr = "GSPCA SN9C10X"; break;
diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index cdf9497..af466ca 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -548,6 +548,7 @@ enum v4l2_mpeg_video_mpeg4_profile {
 #define V4L2_CID_MPEG_VIDEO_MPEG4_QPEL		(V4L2_CID_MPEG_BASE+407)
 
 #define V4L2_CID_MPEG_VIDEO_MPEG2_FRAME_HDR     (V4L2_CID_MPEG_BASE+450)
+#define V4L2_CID_MPEG_VIDEO_MPEG4_FRAME_HDR     (V4L2_CID_MPEG_BASE+451)
 
 /*  Control IDs for VP8 streams
  *  Although VP8 is not part of MPEG we add these controls to the MPEG class
@@ -1000,4 +1001,45 @@ struct v4l2_ctrl_mpeg2_frame_hdr {
 	__u8 forward_index;
 };
 
+struct v4l2_ctrl_mpeg4_frame_hdr {
+	__u32 slice_len;
+	__u32 slice_pos;
+	unsigned char quant_scale;
+
+	__u16 width;
+	__u16 height;
+
+	struct {
+		unsigned int short_video_header		: 1;
+		unsigned int chroma_format			: 2;
+		unsigned int interlaced			: 1;
+		unsigned int obmc_disable			: 1;
+		unsigned int sprite_enable			: 2;
+		unsigned int sprite_warping_accuracy	: 2;
+		unsigned int quant_type			: 1;
+		unsigned int quarter_sample			: 1;
+		unsigned int data_partitioned		: 1;
+		unsigned int reversible_vlc			: 1;
+		unsigned int resync_marker_disable		: 1;
+	} vol_fields;
+
+	struct {
+		unsigned int vop_coding_type		: 2;
+		unsigned int backward_reference_vop_coding_type	: 2;
+		unsigned int vop_rounding_type		: 1;
+		unsigned int intra_dc_vlc_thr		: 3;
+		unsigned int top_field_first		: 1;
+		unsigned int alternate_vertical_scan_flag	: 1;
+	} vop_fields;
+
+	unsigned char vop_fcode_forward;
+	unsigned char vop_fcode_backward;
+
+	short trb;
+	short trd;
+
+	__u8 backward_index;
+	__u8 forward_index;
+};
+
 #endif
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index feff200..18958e2 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -597,6 +597,7 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_VC1_ANNEX_L v4l2_fourcc('V', 'C', '1', 'L') /* SMPTE 421M Annex L compliant stream */
 #define V4L2_PIX_FMT_VP8      v4l2_fourcc('V', 'P', '8', '0') /* VP8 */
 #define V4L2_PIX_FMT_MPEG2_FRAME  v4l2_fourcc('M', 'G', '2', 'F') /* MPEG2 frame */
+#define V4L2_PIX_FMT_MPEG4_FRAME  v4l2_fourcc('M', 'G', '4', 'F') /* MPEG4 frame */
 
 /*  Vendor-specific formats   */
 #define V4L2_PIX_FMT_CPIA1    v4l2_fourcc('C', 'P', 'I', 'A') /* cpia1 YUV */
@@ -1480,6 +1481,7 @@ struct v4l2_ext_control {
 		__u16 __user *p_u16;
 		__u32 __user *p_u32;
 		struct v4l2_ctrl_mpeg2_frame_hdr __user *p_mpeg2_frame_hdr;
+		struct v4l2_ctrl_mpeg4_frame_hdr __user *p_mpeg4_frame_hdr;
 		void __user *ptr;
 	};
 } __attribute__ ((packed));
@@ -1525,6 +1527,7 @@ enum v4l2_ctrl_type {
 	V4L2_CTRL_TYPE_U16	     = 0x0101,
 	V4L2_CTRL_TYPE_U32	     = 0x0102,
 	V4L2_CTRL_TYPE_MPEG2_FRAME_HDR  = 0x0109,
+	V4L2_CTRL_TYPE_MPEG4_FRAME_HDR  = 0x010A,
 
 	V4L2_CTRL_TYPE_PRIVATE       = 0xffff,
 };
-- 
2.7.4

