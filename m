Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:41386 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935409AbeFRPAW (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 18 Jun 2018 11:00:22 -0400
From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Marco Franchi <marco.franchi@nxp.com>,
        Icenowy Zheng <icenowy@aosc.io>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tom Saeger <tom.saeger@oracle.com>,
        Smitha T Murthy <smitha.t@samsung.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "David S . Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>,
        Jacob Chen <jacob-chen@iotwrt.com>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Todor Tomov <todor.tomov@linaro.org>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Alexandre Courbot <acourbot@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        linux-sunxi@googlegroups.com,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Randy Li <ayaka@soulik.info>
Subject: [PATCH v4 13/19] media: v4l: Add definitions for MPEG2 slice format and header metadata
Date: Mon, 18 Jun 2018 16:58:37 +0200
Message-Id: <20180618145843.14631-14-paul.kocialkowski@bootlin.com>
In-Reply-To: <20180618145843.14631-1-paul.kocialkowski@bootlin.com>
References: <20180618145843.14631-1-paul.kocialkowski@bootlin.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Stateless video decoding engines require both the MPEG slices and
associated metadata from the video stream in order to decode frames.

This introduces definitions for a new pixel format, describing buffers
with MPEG2 slice data, as well as a control structure for passing the
frame header (metadata) to drivers.

This is based on work from both Florent Revest and Hugues Fruchet.

Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>

diff --git a/Documentation/media/uapi/v4l/extended-controls.rst b/Documentation/media/uapi/v4l/extended-controls.rst
index 03931f9b1285..54f0dd396df2 100644
--- a/Documentation/media/uapi/v4l/extended-controls.rst
+++ b/Documentation/media/uapi/v4l/extended-controls.rst
@@ -1497,6 +1497,79 @@ enum v4l2_mpeg_video_h264_hierarchical_coding_type -
 
 
 
+.. _v4l2-mpeg-mpeg2:
+
+``V4L2_CID_MPEG_VIDEO_MPEG2_SLICE_HEADER (struct)``
+    Specifies the slice parameters (also known as slice header) for an
+    associated MPEG-2 slice data. This includes all the necessary
+    parameters for configuring a hardware decoder pipeline for MPEG-2.
+
+.. tabularcolumns:: |p{2.0cm}|p{4.0cm}|p{11.0cm}|
+
+.. c:type:: v4l2_ctrl_mpeg2_slice_header
+
+.. cssclass:: longtable
+
+.. flat-table:: struct v4l2_ctrl_mpeg2_slice_header
+    :header-rows:  0
+    :stub-columns: 0
+    :widths:       1 1 2
+
+    * - __u32
+      - ``slice_len``
+      - Length (in bits) of the current slice data.
+    * - __u32
+      - ``slice_pos``
+      - Position (in bits) of the current slice data, relative to the
+        frame start.
+    * - __u16
+      - ``width``
+      - Width of the corresponding output frame for the current slice.
+    * - __u16
+      - ``height``
+      - Height of the corresponding output frame for the current slice.
+    * - __u8
+      - ``picture_coding_type``
+      - Picture coding type for the frame covered by the current slice
+        (V4L2_SLICE_PCT_I, V4L2_SLICE_PCT_P or V4L2_SLICE_PCT_B).
+    * - __u8
+      - ``f_code[2][2]``
+      - Motion vector codes.
+    * - __u8
+      - ``intra_dc_precision``
+      - Precision of Discrete Cosine transform (0: 8 bits precision,
+        1: 9 bits precision, 2: 10 bits precision, 11: 11 bits precision).
+    * - __u8
+      - ``picture_structure``
+      - Picture structure (1: interlaced top field,
+        2: interlaced bottom field, 3: progressive frame).
+    * - __u8
+      - ``top_field_first``
+      - If set to 1 and interlaced stream, top field is output first.
+    * - __u8
+      - ``frame_pred_frame_dct``
+      - If set to 1, only frame-DCT and frame prediction are used.
+    * - __u8
+      - ``concealment_motion_vectors``
+      -  If set to 1, motion vectors are coded for intra macroblocks.
+    * - __u8
+      - ``q_scale_type``
+      - This flag affects the inverse quantisation process.
+    * - __u8
+      - ``intra_vlc_format``
+      - This flag affects the decoding of transform coefficient data.
+    * - __u8
+      - ``alternate_scan``
+      - This flag affects the decoding of transform coefficient data.
+    * - __u8
+      - ``backward_ref_index``
+      - Index for the V4L2 buffer to use as backward reference, used with
+        B-coded and P-coded frames.
+    * - __u8
+      - ``forward_ref_index``
+      - Index for the V4L2 buffer to use as forward reference, used with
+        P-coded frames.
+    * - :cspan:`2`
 
 MFC 5.1 MPEG Controls
 ---------------------
diff --git a/Documentation/media/uapi/v4l/pixfmt-compressed.rst b/Documentation/media/uapi/v4l/pixfmt-compressed.rst
index abec03937bb3..4e73f62b5163 100644
--- a/Documentation/media/uapi/v4l/pixfmt-compressed.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-compressed.rst
@@ -60,6 +60,11 @@ Compressed Formats
       - ``V4L2_PIX_FMT_MPEG2``
       - 'MPG2'
       - MPEG2 video elementary stream.
+    * .. _V4L2-PIX-FMT-MPEG2-SLICE:
+
+      - ``V4L2_PIX_FMT_MPEG2_SLICE``
+      - 'MG2S'
+      - MPEG2 parsed slice data, as extracted from the MPEG2 bitstream.
     * .. _V4L2-PIX-FMT-MPEG4:
 
       - ``V4L2_PIX_FMT_MPEG4``
diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index a0c7a7fb2ff3..f46584e4d511 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -826,6 +826,7 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_MPEG_VIDEO_MV_V_SEARCH_RANGE:		return "Vertical MV Search Range";
 	case V4L2_CID_MPEG_VIDEO_REPEAT_SEQ_HEADER:		return "Repeat Sequence Header";
 	case V4L2_CID_MPEG_VIDEO_FORCE_KEY_FRAME:		return "Force Key Frame";
+	case V4L2_CID_MPEG_VIDEO_MPEG2_SLICE_HEADER:		return "MPEG2 Slice Header";
 
 	/* VPX controls */
 	case V4L2_CID_MPEG_VIDEO_VPX_NUM_PARTITIONS:		return "VPX Number of Partitions";
@@ -1271,6 +1272,9 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_RDS_TX_ALT_FREQS:
 		*type = V4L2_CTRL_TYPE_U32;
 		break;
+	case V4L2_CID_MPEG_VIDEO_MPEG2_SLICE_HEADER:
+		*type = V4L2_CTRL_TYPE_MPEG2_SLICE_HEADER;
+		break;
 	default:
 		*type = V4L2_CTRL_TYPE_INTEGER;
 		break;
@@ -1529,6 +1533,7 @@ static void std_log(const struct v4l2_ctrl *ctrl)
 static int std_validate(const struct v4l2_ctrl *ctrl, u32 idx,
 			union v4l2_ctrl_ptr ptr)
 {
+	struct v4l2_ctrl_mpeg2_slice_header *p_mpeg2_slice_header;
 	size_t len;
 	u64 offset;
 	s64 val;
@@ -1591,6 +1596,42 @@ static int std_validate(const struct v4l2_ctrl *ctrl, u32 idx,
 			return -ERANGE;
 		return 0;
 
+	case V4L2_CTRL_TYPE_MPEG2_SLICE_HEADER:
+		p_mpeg2_slice_header = ptr.p;
+
+		switch (p_mpeg2_slice_header->intra_dc_precision) {
+		case 0: /* 8 bits */
+		case 1: /* 9 bits */
+		case 11: /* 11 bits */
+			break;
+		default:
+			return -EINVAL;
+		}
+
+		switch (p_mpeg2_slice_header->picture_structure) {
+		case 1: /* interlaced top field */
+		case 2: /* interlaced bottom field */
+		case 3: /* progressive */
+			break;
+		default:
+			return -EINVAL;
+		}
+
+		switch (p_mpeg2_slice_header->picture_coding_type) {
+		case V4L2_SLICE_PCT_I:
+		case V4L2_SLICE_PCT_P:
+		case V4L2_SLICE_PCT_B:
+			break;
+		default:
+			return -EINVAL;
+		}
+
+		if (p_mpeg2_slice_header->backward_ref_index > VIDEO_MAX_FRAME ||
+		    p_mpeg2_slice_header->forward_ref_index > VIDEO_MAX_FRAME)
+			return -EINVAL;
+
+		return 0;
+
 	default:
 		return -EINVAL;
 	}
@@ -2165,6 +2206,9 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
 	case V4L2_CTRL_TYPE_U32:
 		elem_size = sizeof(u32);
 		break;
+	case V4L2_CTRL_TYPE_MPEG2_SLICE_HEADER:
+		elem_size = sizeof(struct v4l2_ctrl_mpeg2_slice_header);
+		break;
 	default:
 		if (type < V4L2_CTRL_COMPOUND_TYPES)
 			elem_size = sizeof(s32);
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index eee04f29f1d3..98961d5acb1a 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -1267,6 +1267,7 @@ static void v4l_fill_fmtdesc(struct v4l2_fmtdesc *fmt)
 		case V4L2_PIX_FMT_H263:		descr = "H.263"; break;
 		case V4L2_PIX_FMT_MPEG1:	descr = "MPEG-1 ES"; break;
 		case V4L2_PIX_FMT_MPEG2:	descr = "MPEG-2 ES"; break;
+		case V4L2_PIX_FMT_MPEG2_SLICE:	descr = "MPEG-2 parsed slice data"; break;
 		case V4L2_PIX_FMT_MPEG4:	descr = "MPEG-4 part 2 ES"; break;
 		case V4L2_PIX_FMT_XVID:		descr = "Xvid"; break;
 		case V4L2_PIX_FMT_VC1_ANNEX_G:	descr = "VC-1 (SMPTE 412M Annex G)"; break;
diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index 8d473c979b61..2caf1f03a293 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -557,6 +557,8 @@ enum v4l2_mpeg_video_mpeg4_profile {
 };
 #define V4L2_CID_MPEG_VIDEO_MPEG4_QPEL		(V4L2_CID_MPEG_BASE+407)
 
+#define V4L2_CID_MPEG_VIDEO_MPEG2_SLICE_HEADER  (V4L2_CID_MPEG_BASE+450)
+
 /*  Control IDs for VP8 streams
  *  Although VP8 is not part of MPEG we add these controls to the MPEG class
  *  as that class is already handling other video compression standards
@@ -1076,4 +1078,32 @@ enum v4l2_detect_md_mode {
 #define V4L2_CID_DETECT_MD_THRESHOLD_GRID	(V4L2_CID_DETECT_CLASS_BASE + 3)
 #define V4L2_CID_DETECT_MD_REGION_GRID		(V4L2_CID_DETECT_CLASS_BASE + 4)
 
+#define V4L2_SLICE_PCT_I			1
+#define V4L2_SLICE_PCT_P			2
+#define V4L2_SLICE_PCT_B			3
+#define V4L2_SLICE_PCT_D			4
+
+struct v4l2_ctrl_mpeg2_slice_header {
+	__u32	slice_len;
+	__u32	slice_pos;
+
+	__u16	width;
+	__u16	height;
+
+	__u8	picture_coding_type;
+	__u8	f_code[2][2];
+
+	__u8	intra_dc_precision;
+	__u8	picture_structure;
+	__u8	top_field_first;
+	__u8	frame_pred_frame_dct;
+	__u8	concealment_motion_vectors;
+	__u8	q_scale_type;
+	__u8	intra_vlc_format;
+	__u8	alternate_scan;
+
+	__u8	backward_ref_index;
+	__u8	forward_ref_index;
+};
+
 #endif
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 1f6c4b52baae..5e950a6f20df 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -629,6 +629,7 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_H263     v4l2_fourcc('H', '2', '6', '3') /* H263          */
 #define V4L2_PIX_FMT_MPEG1    v4l2_fourcc('M', 'P', 'G', '1') /* MPEG-1 ES     */
 #define V4L2_PIX_FMT_MPEG2    v4l2_fourcc('M', 'P', 'G', '2') /* MPEG-2 ES     */
+#define V4L2_PIX_FMT_MPEG2_SLICE v4l2_fourcc('M', 'G', '2', 'S') /* MPEG-2 parsed slice data */
 #define V4L2_PIX_FMT_MPEG4    v4l2_fourcc('M', 'P', 'G', '4') /* MPEG-4 part 2 ES */
 #define V4L2_PIX_FMT_XVID     v4l2_fourcc('X', 'V', 'I', 'D') /* Xvid           */
 #define V4L2_PIX_FMT_VC1_ANNEX_G v4l2_fourcc('V', 'C', '1', 'G') /* SMPTE 421M Annex G compliant stream */
@@ -1587,6 +1588,7 @@ struct v4l2_ext_control {
 		__u8 __user *p_u8;
 		__u16 __user *p_u16;
 		__u32 __user *p_u32;
+		struct v4l2_ctrl_mpeg2_slice_header __user *p_mpeg2_slice_header;
 		void __user *ptr;
 	};
 } __attribute__ ((packed));
@@ -1632,6 +1634,7 @@ enum v4l2_ctrl_type {
 	V4L2_CTRL_TYPE_U8	     = 0x0100,
 	V4L2_CTRL_TYPE_U16	     = 0x0101,
 	V4L2_CTRL_TYPE_U32	     = 0x0102,
+	V4L2_CTRL_TYPE_MPEG2_SLICE_HEADER = 0x0103,
 };
 
 /*  Used in the VIDIOC_QUERYCTRL ioctl for querying controls */
-- 
2.17.0
