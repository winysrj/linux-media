Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:18663 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753378AbdBHPiN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 8 Feb 2017 10:38:13 -0500
From: Hugues Fruchet <hugues.fruchet@st.com>
To: <linux-media@vger.kernel.org>, Hans Verkuil <hverkuil@xs4all.nl>
CC: <kernel@stlinux.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Jean-Christophe Trotin <jean-christophe.trotin@st.com>
Subject: [PATCH v2 1/3] [media] v4l: add parsed MPEG-2 support
Date: Wed, 8 Feb 2017 16:37:18 +0100
Message-ID: <1486568240-7645-2-git-send-email-hugues.fruchet@st.com>
In-Reply-To: <1486568240-7645-1-git-send-email-hugues.fruchet@st.com>
References: <1486568240-7645-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add "parsed MPEG-2" pixel format & related controls
needed by stateless video decoders.
In order to decode the video bitstream chunk provided
by user on output queue, stateless decoders require
also some extra data resulting from this video bitstream
chunk parsing.
Those parsed extra data have to be set by user through
control framework using the dedicated mpeg video extended
controls introduced in this patchset.

Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
---
 Documentation/media/uapi/v4l/extended-controls.rst | 363 +++++++++++++++++++++
 Documentation/media/uapi/v4l/pixfmt-013.rst        |  10 +
 drivers/media/v4l2-core/v4l2-ctrls.c               |  53 +++
 drivers/media/v4l2-core/v4l2-ioctl.c               |   2 +
 include/uapi/linux/v4l2-controls.h                 |  86 +++++
 include/uapi/linux/videodev2.h                     |   8 +
 6 files changed, 522 insertions(+)

diff --git a/Documentation/media/uapi/v4l/extended-controls.rst b/Documentation/media/uapi/v4l/extended-controls.rst
index abb1057..cd1a8d6 100644
--- a/Documentation/media/uapi/v4l/extended-controls.rst
+++ b/Documentation/media/uapi/v4l/extended-controls.rst
@@ -1827,6 +1827,369 @@ enum v4l2_mpeg_cx2341x_video_median_filter_type -
     not insert, 1 = insert packets.
 
 
+MPEG-2 Parsed Control Reference
+---------------------------------
+
+The MPEG-2 parsed decoding controls are needed by stateless video decoders.
+Those decoders expose :ref:`Compressed formats <compressed-formats>` :ref:`V4L2_PIX_FMT_MPEG1_PARSED<V4L2-PIX-FMT-MPEG1-PARSED>` or :ref:`V4L2_PIX_FMT_MPEG2_PARSED<V4L2-PIX-FMT-MPEG2-PARSED>`.
+In order to decode the video bitstream chunk provided by user on output queue,
+stateless decoders require also some extra data resulting from this video
+bitstream chunk parsing. Those parsed extra data have to be set by user
+through control framework using the mpeg video extended controls defined
+in this section. Those controls have been defined based on MPEG-2 standard
+ISO/IEC 13818-2, and so derive directly from the MPEG-2 video bitstream syntax
+including how it is coded inside bitstream (enumeration values for ex.).
+
+MPEG-2 Parsed Control IDs
+^^^^^^^^^^^^^^^^^^^^^^^^^^^
+
+.. _mpeg2-parsed-control-id:
+
+``V4L2_CID_MPEG_VIDEO_MPEG2_SEQ_HDR``
+    (enum)
+
+.. tabularcolumns:: |p{4.0cm}|p{2.5cm}|p{11.0cm}|
+
+.. c:type:: v4l2_mpeg_video_mpeg2_seq_hdr
+
+.. cssclass:: longtable
+
+.. flat-table:: struct v4l2_mpeg_video_mpeg2_seq_hdr
+    :header-rows:  0
+    :stub-columns: 0
+    :widths:       1 1 2
+
+    * - __u16
+      - ``width``
+      - Video width in pixels.
+    * - __u16
+      - ``height``
+      - Video height in pixels.
+    * - __u8
+      - ``aspect_ratio_info``
+      - Aspect ratio code as in the bitstream (1: 1:1 square pixels,
+        2: 4:3 display, 3: 16:9 display, 4: 2.21:1 display)
+    * - __u8
+      - ``framerate code``
+      - Framerate code as in the bitstream
+        (1: 24000/1001.0 '23.976 fps, 2: 24.0, 3: 25.0,
+        4: 30000/1001.0 '29.97, 5: 30.0, 6: 50.0, 7: 60000/1001.0,
+        8: 60.0)
+    * - __u32
+      - ``bitrate_value``
+      - Bitrate value as in the bitstream, expressed in 400bps unit
+    * - __u16
+      - ``vbv_buffer_size``
+      -  Video Buffering Verifier size, expressed in 16KBytes unit.
+    * - __u8
+      - ``constrained_parameters_flag``
+      - Set to 1 if this bitstream uses constrained parameters.
+    * - __u8
+      - ``load_intra_quantiser_matrix``
+      - If set to 1, ``intra_quantiser_matrix`` table is to be used for
+        decoding.
+    * - __u8
+      - ``load_non_intra_quantiser_matrix``
+      - If set to 1, ``non_intra_quantiser_matrix`` table is to be used for
+        decoding.
+    * - __u8
+      - ``intra_quantiser_matrix[64]``
+      - Intra quantization table, in zig-zag scan order.
+    * - __u8
+      - ``non_intra_quantiser_matrix[64]``
+      - Non-intra quantization table, in zig-zag scan order.
+    * - __u32
+      - ``par_w``
+      - Pixel aspect ratio width in pixels.
+    * - __u32
+      - ``par_h``
+      - Pixel aspect ratio height in pixels.
+    * - __u32
+      - ``fps_n``
+      - Framerate nominator.
+    * - __u32
+      - ``fps_d``
+      - Framerate denominator.
+    * - __u32
+      - ``bitrate``
+      - Bitrate in bps if constant bitrate, 0 otherwise.
+    * - :cspan:`2`
+
+
+``V4L2_CID_MPEG_VIDEO_MPEG2_SEQ_EXT``
+    (enum)
+
+.. tabularcolumns:: |p{4.0cm}|p{2.5cm}|p{11.0cm}|
+
+.. c:type:: v4l2_mpeg_video_mpeg2_seq_ext
+
+.. cssclass:: longtable
+
+.. flat-table:: struct v4l2_mpeg_video_mpeg2_seq_ext
+    :header-rows:  0
+    :stub-columns: 0
+    :widths:       1 1 2
+
+    * - __u8
+      - ``profile``
+      - Encoding profile used to encode this bitstream.
+        (1: High Profile, 2: Spatially Scalable Profile,
+        3: SNR Scalable Profile, 4: Main Profile, 5: Simple Profile).
+    * - __u8
+      - ``level``
+      - Encoding level used to encode this bitstream
+        (4: High Level, 6: High 1440 Level, 8: Main Level, 10: Low Level).
+    * - __u8
+      - ``progressive``
+      - Set to 1 if frames are progressive (vs interlaced).
+    * - __u8
+      - ``chroma_format``
+      - Chrominance format (1: 420, 2: 422, 3: 444).
+    * - __u8
+      - ``horiz_size_ext``
+      - Horizontal size extension. This value is to be shifted 12 bits left
+        and added to ''seq_hdr->width'' to get the final video width:
+        `width = seq_hdr->width + seq_ext->horiz_size_ext << 12`
+    * - __u8
+      - ``vert_size_ext``
+      - Vertical size extension. This value is to be shifted 12 bits left
+        and added to ''seq_hdr->height'' to get the final video height:
+        `height = seq_hdr->height + seq_ext->vert_size_ext << 12`
+    * - __u16
+      - ``bitrate_ext``
+      -  Bitrate extension. This value, expressed in 400bps unit, is to be
+         shifted 18 bits left and added to ''seq_hdr->bitrate'' to get the
+         final bitrate:
+         `bitrate = seq_hdr->bitrate + (seq_ext->bitrate_ext << 18) * 400`
+    * - __u8
+      - ``vbv_buffer_size_ext``
+      -  Video Buffering Verifier size extension in bits.
+    * - __u8
+      - ``low_delay``
+      -  Low delay. Set to 1 if no B pictures are present.
+    * - __u8
+      - ``fps_n_ext``
+      -  Framerate extension nominator. This value is to be incremented and
+         multiplied by ''seq_hdr->fps_n'' to get the final framerate
+         nominator:
+         `fps_n = seq_hdr->fps_n * (seq_ext->fps_n_ext + 1)`
+    * - __u8
+      - ``fps_d_ext``
+      -  Framerate extension denominator. This value is to be incremented and
+         multiplied by ''seq_hdr->fps_d'' to get the final framerate
+         denominator:
+         `fps_d = seq_hdr->fps_d * (seq_ext->fps_d_ext + 1)`
+    * - :cspan:`2`
+
+
+``V4L2_CID_MPEG_VIDEO_MPEG2_SEQ_DISPLAY_EXT``
+    (enum)
+
+.. tabularcolumns:: |p{4.0cm}|p{2.5cm}|p{11.0cm}|
+
+.. c:type:: v4l2_mpeg_video_mpeg2_seq_display_ext
+
+.. cssclass:: longtable
+
+.. flat-table:: struct v4l2_mpeg_video_mpeg2_seq_ext
+    :header-rows:  0
+    :stub-columns: 0
+    :widths:       1 1 2
+
+    * - __u8
+      - ``video_format``
+      - Video standard (0: Components, 1: PAL, 2: NTSC, 3: SECAM, 4:MAC)
+    * - __u8
+      - ``colour_description_flag``
+      - If set to 1, ''colour_primaries'', ''transfer_characteristics'',
+        ''matrix_coefficients'' are to be used for decoding.
+    * - __u8
+      - ``colour_primaries``
+      - Colour coding standard (1: ITU-R Rec. 709 (1990),
+        4: ITU-R Rec. 624-4 System M, 5: ITU-R Rec. 624-4 System B, G,
+        6: SMPTE 170M, 7: SMPTE 240M (1987))
+    * - __u8
+      - ``transfer_characteristics``
+      - Transfer characteristics coding standard (1: ITU-R Rec. 709 (1990),
+        4: ITU-R Rec. 624-4 System M, 5: ITU-R Rec. 624-4 System B, G,
+        6: SMPTE 170M, 7: SMPTE 240M (1987))
+    * - __u8
+      - ``matrix_coefficients``
+      - Matrix coefficients coding standard (1: ITU-R Rec. 709 (1990),
+        4: FCC, 5: ITU-R Rec. 624-4 System B, G, 6: SMPTE 170M,
+        7: SMPTE 240M (1987))
+    * - __u16
+      - ``display_horizontal_size``, ``display_vertical_size``
+      - Dimensions of the video to be displayed. If those dimensions
+        are smaller than the final video dimensions, only this area
+        must be displayed.
+    * - :cspan:`2`
+
+
+``V4L2_CID_MPEG_VIDEO_MPEG2_SEQ_MATRIX_EXT``
+    (enum)
+
+.. tabularcolumns:: |p{4.0cm}|p{2.5cm}|p{11.0cm}|
+
+.. c:type:: v4l2_mpeg_video_mpeg2_seq_matrix_ext
+
+.. cssclass:: longtable
+
+.. flat-table:: struct v4l2_mpeg_video_mpeg2_seq_matrix_ext
+    :header-rows:  0
+    :stub-columns: 0
+    :widths:       1 1 2
+
+    * - __u8
+      - ``load_intra_quantiser_matrix``
+      - If set to 1, ``intra_quantiser_matrix`` table is to be used for
+        decoding.
+    * - __u8
+      - ``intra_quantiser_matrix[64]``
+      - Intra quantization table, in zig-zag scan order.
+    * - __u8
+      - ``load_non_intra_quantiser_matrix``
+      - If set to 1, ``non_intra_quantiser_matrix`` table is to be used for
+        decoding.
+    * - __u8
+      - ``non_intra_quantiser_matrix[64]``
+      - Non-intra quantization table, in zig-zag scan order.
+    * - __u8
+      - ``load_chroma_intra_quantiser_matrix``
+      - If set to 1, ``chroma_intra_quantiser_matrix`` table is to be used for
+        decoding.
+    * - __u8
+      - ``chroma_intra_quantiser_matrix[64]``
+      - Chroma intra quantization table, in zig-zag scan order.
+    * - __u8
+      - ``load_chroma_non_intra_quantiser_matrix``
+      - If set to 1, ``chroma_non_intra_quantiser_matrix`` table is to be used for
+        decoding.
+    * - __u8
+      - ``chroma_non_intra_quantiser_matrix[64]``
+      - Chroma non-intra quantization table, in zig-zag scan order.
+    * - :cspan:`2`
+
+
+``V4L2_CID_MPEG_VIDEO_MPEG2_PIC_HDR``
+    (enum)
+
+.. tabularcolumns:: |p{4.0cm}|p{2.5cm}|p{11.0cm}|
+
+.. c:type:: v4l2_mpeg_video_mpeg2_pic_hdr
+
+.. cssclass:: longtable
+
+.. flat-table:: struct v4l2_mpeg_video_mpeg2_pic_hdr
+    :header-rows:  0
+    :stub-columns: 0
+    :widths:       1 1 2
+
+    * - __u32
+      - ``offset``
+      - Offset in bytes of the slice data from the beginning of packet.
+    * - __u16
+      - ``tsn``
+      - Temporal Sequence Number: order in which the frames must be displayed.
+    * - __u8
+      - ``pic_type``
+      - Picture coding type (1: Intra, 2: Predictive,
+        3: B, Bidirectionally Predictive, 4: D, DC Intra).
+    * - __u16
+      - ``vbv_delay``
+      - Video Buffering Verifier delay, in 90KHz cycles unit.
+    * - __u8
+      - ``full_pel_forward_vector``
+      - If set to 1, forward vectors are expressed in full pixel unit instead
+        half pixel unit.
+    * - __u8
+      - ``full_pel_backward_vector``
+      - If set to 1, backward vectors are expressed in full pixel unit instead
+        half pixel unit.
+    * - __u8
+      - ``f_code[2][2]``
+      - Motion vectors code.
+    * - :cspan:`2`
+
+
+``V4L2_CID_MPEG_VIDEO_MPEG2_PIC_EXT``
+    (enum)
+
+.. tabularcolumns:: |p{4.0cm}|p{2.5cm}|p{11.0cm}|
+
+.. c:type:: v4l2_mpeg_video_mpeg2_pic_ext
+
+.. cssclass:: longtable
+
+.. flat-table:: struct v4l2_mpeg_video_mpeg2_pic_ext
+    :header-rows:  0
+    :stub-columns: 0
+    :widths:       1 1 2
+
+    * - __u8
+      - ``f_code[2][2]``
+      - Motion vectors code.
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
+      - ``repeat_first_field``
+      - This flag affects how the frames or fields are output by decoder.
+    * - __u8
+      - ``chroma_420_type``
+      - Set the same as ``progressive_frame``. Exists for historical reasons.
+    * - __u8
+      - ``progressive_frame``
+      - If this flag is set to 0, the two fields of a frame are two interlaced fields,
+        ``repeat_first_field`` must be 0 (two field duration). If the flag is set to 1,
+        the two fields are merged into one frame, ``picture_structure`` is so set to "Frame"
+        and ``frame_pred_frame_dct`` to 1.
+    * - __u8
+      - ``composite_display``
+      - This flag is set to 1 if pictures are encoded as (analog) composite video.
+    * - __u8
+      - ``v_axis``
+      - Used only when pictures are encoded according to PAL systems. This flag is set to 1
+        on a positive sign, 0 otherwise.
+    * - __u8
+      - ``field_sequence``
+      - Specifies the number of the field of an eight Field Sequence for a PAL system or
+        a five Field Sequence for a NTSC system
+    * - __u8
+      - ``sub_carrier``
+      - If the flag is set to 0, the sub-carrier/line-frequency relationship is correct.
+    * - __u8
+      - ``burst_amplitude``
+      - Specifies the burst amplitude for PAL and NTSC.
+    * - __u8
+      - ``sub_carrier_phase``
+      - Specifies the phase of the reference sub-carrier for the field synchronization.
+    * - :cspan:`2`
+
+
 VPX Control Reference
 ---------------------
 
diff --git a/Documentation/media/uapi/v4l/pixfmt-013.rst b/Documentation/media/uapi/v4l/pixfmt-013.rst
index 728d7ed..32c9ef7 100644
--- a/Documentation/media/uapi/v4l/pixfmt-013.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-013.rst
@@ -55,11 +55,21 @@ Compressed Formats
       - ``V4L2_PIX_FMT_MPEG1``
       - 'MPG1'
       - MPEG1 video elementary stream.
+    * .. _V4L2-PIX-FMT-MPEG1-PARSED:
+
+      - ``V4L2_PIX_FMT_MPEG1_PARSED``
+      - 'MG1P'
+      - MPEG-1 with parsing metadata given through controls, see :ref:`MPEG-2 Parsed Control IDs<mpeg2-parsed-control-id>`.
     * .. _V4L2-PIX-FMT-MPEG2:
 
       - ``V4L2_PIX_FMT_MPEG2``
       - 'MPG2'
       - MPEG2 video elementary stream.
+    * .. _V4L2-PIX-FMT-MPEG2-PARSED:
+
+      - ``V4L2_PIX_FMT_MPEG2_PARSED``
+      - 'MG2P'
+      - MPEG-2 with parsing metadata given through controls, see :ref:`MPEG-2 Parsed Control IDs<mpeg2-parsed-control-id>`.
     * .. _V4L2-PIX-FMT-MPEG4:
 
       - ``V4L2_PIX_FMT_MPEG4``
diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 47001e2..5d02818 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -760,6 +760,13 @@ const char *v4l2_ctrl_get_name(u32 id)
 	case V4L2_CID_MPEG_VIDEO_MV_V_SEARCH_RANGE:		return "Vertical MV Search Range";
 	case V4L2_CID_MPEG_VIDEO_REPEAT_SEQ_HEADER:		return "Repeat Sequence Header";
 	case V4L2_CID_MPEG_VIDEO_FORCE_KEY_FRAME:		return "Force Key Frame";
+	/* parsed MPEG-2 controls */
+	case V4L2_CID_MPEG_VIDEO_MPEG2_SEQ_HDR:			return "MPEG-2 sequence header";
+	case V4L2_CID_MPEG_VIDEO_MPEG2_SEQ_EXT:			return "MPEG-2 sequence extension";
+	case V4L2_CID_MPEG_VIDEO_MPEG2_SEQ_DISPLAY_EXT:		return "MPEG-2 sequence display extension";
+	case V4L2_CID_MPEG_VIDEO_MPEG2_SEQ_MATRIX_EXT:		return "MPEG-2 sequence quantization matrix";
+	case V4L2_CID_MPEG_VIDEO_MPEG2_PIC_HDR:			return "MPEG-2 picture header";
+	case V4L2_CID_MPEG_VIDEO_MPEG2_PIC_EXT:			return "MPEG-2 picture extension";
 
 	/* VPX controls */
 	case V4L2_CID_MPEG_VIDEO_VPX_NUM_PARTITIONS:		return "VPX Number of Partitions";
@@ -1146,6 +1153,24 @@ void v4l2_ctrl_fill(u32 id, const char **name, enum v4l2_ctrl_type *type,
 	case V4L2_CID_RDS_TX_ALT_FREQS:
 		*type = V4L2_CTRL_TYPE_U32;
 		break;
+	case V4L2_CID_MPEG_VIDEO_MPEG2_SEQ_HDR:
+		*type = V4L2_CTRL_TYPE_MPEG2_SEQ_HDR;
+		break;
+	case V4L2_CID_MPEG_VIDEO_MPEG2_SEQ_EXT:
+		*type = V4L2_CTRL_TYPE_MPEG2_SEQ_EXT;
+		break;
+	case V4L2_CID_MPEG_VIDEO_MPEG2_SEQ_DISPLAY_EXT:
+		*type = V4L2_CTRL_TYPE_MPEG2_SEQ_DISPLAY_EXT;
+		break;
+	case V4L2_CID_MPEG_VIDEO_MPEG2_SEQ_MATRIX_EXT:
+		*type = V4L2_CTRL_TYPE_MPEG2_SEQ_MATRIX_EXT;
+		break;
+	case V4L2_CID_MPEG_VIDEO_MPEG2_PIC_HDR:
+		*type = V4L2_CTRL_TYPE_MPEG2_PIC_HDR;
+		break;
+	case V4L2_CID_MPEG_VIDEO_MPEG2_PIC_EXT:
+		*type = V4L2_CTRL_TYPE_MPEG2_PIC_EXT;
+		break;
 	default:
 		*type = V4L2_CTRL_TYPE_INTEGER;
 		break;
@@ -1456,6 +1481,14 @@ static int std_validate(const struct v4l2_ctrl *ctrl, u32 idx,
 			return -ERANGE;
 		return 0;
 
+	case V4L2_CTRL_TYPE_MPEG2_SEQ_HDR:
+	case V4L2_CTRL_TYPE_MPEG2_SEQ_EXT:
+	case V4L2_CTRL_TYPE_MPEG2_SEQ_DISPLAY_EXT:
+	case V4L2_CTRL_TYPE_MPEG2_SEQ_MATRIX_EXT:
+	case V4L2_CTRL_TYPE_MPEG2_PIC_HDR:
+	case V4L2_CTRL_TYPE_MPEG2_PIC_EXT:
+		return 0;
+
 	default:
 		return -EINVAL;
 	}
@@ -1975,6 +2008,26 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
 	case V4L2_CTRL_TYPE_U32:
 		elem_size = sizeof(u32);
 		break;
+	case V4L2_CTRL_TYPE_MPEG2_SEQ_HDR:
+		elem_size = sizeof(struct v4l2_mpeg_video_mpeg2_seq_hdr);
+		break;
+	case V4L2_CTRL_TYPE_MPEG2_SEQ_EXT:
+		elem_size = sizeof(struct v4l2_mpeg_video_mpeg2_seq_ext);
+		break;
+	case V4L2_CTRL_TYPE_MPEG2_SEQ_DISPLAY_EXT:
+		elem_size =
+			sizeof(struct v4l2_mpeg_video_mpeg2_seq_display_ext);
+		break;
+	case V4L2_CTRL_TYPE_MPEG2_SEQ_MATRIX_EXT:
+		elem_size =
+			sizeof(struct v4l2_mpeg_video_mpeg2_seq_matrix_ext);
+		break;
+	case V4L2_CTRL_TYPE_MPEG2_PIC_HDR:
+		elem_size = sizeof(struct v4l2_mpeg_video_mpeg2_pic_hdr);
+		break;
+	case V4L2_CTRL_TYPE_MPEG2_PIC_EXT:
+		elem_size = sizeof(struct v4l2_mpeg_video_mpeg2_pic_ext);
+		break;
 	default:
 		if (type < V4L2_CTRL_COMPOUND_TYPES)
 			elem_size = sizeof(s32);
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 0c3f238..55be85d 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -1232,7 +1232,9 @@ static void v4l_fill_fmtdesc(struct v4l2_fmtdesc *fmt)
 		case V4L2_PIX_FMT_H264_MVC:	descr = "H.264 MVC"; break;
 		case V4L2_PIX_FMT_H263:		descr = "H.263"; break;
 		case V4L2_PIX_FMT_MPEG1:	descr = "MPEG-1 ES"; break;
+		case V4L2_PIX_FMT_MPEG1_PARSED:	descr = "MPEG-1 with parsing metadata"; break;
 		case V4L2_PIX_FMT_MPEG2:	descr = "MPEG-2 ES"; break;
+		case V4L2_PIX_FMT_MPEG2_PARSED:	descr = "MPEG-2 with parsing metadata"; break;
 		case V4L2_PIX_FMT_MPEG4:	descr = "MPEG-4 part 2 ES"; break;
 		case V4L2_PIX_FMT_XVID:		descr = "Xvid"; break;
 		case V4L2_PIX_FMT_VC1_ANNEX_G:	descr = "VC-1 (SMPTE 412M Annex G)"; break;
diff --git a/include/uapi/linux/v4l2-controls.h b/include/uapi/linux/v4l2-controls.h
index 0d2e1e0..deff646 100644
--- a/include/uapi/linux/v4l2-controls.h
+++ b/include/uapi/linux/v4l2-controls.h
@@ -547,6 +547,92 @@ enum v4l2_mpeg_video_mpeg4_profile {
 };
 #define V4L2_CID_MPEG_VIDEO_MPEG4_QPEL		(V4L2_CID_MPEG_BASE+407)
 
+/* parsed MPEG-2 controls
+ * (needed by stateless video decoders)
+ * Those controls have been defined based on MPEG-2 standard ISO/IEC 13818-2,
+ * and so derive directly from the MPEG-2 video bitstream syntax including
+ * how it is coded inside bitstream (enumeration values for ex.).
+ */
+#define MPEG2_QUANTISER_MATRIX_SIZE	64
+#define V4L2_CID_MPEG_VIDEO_MPEG2_SEQ_HDR		(V4L2_CID_MPEG_BASE+450)
+struct v4l2_mpeg_video_mpeg2_seq_hdr {
+	__u16	width, height;
+	__u8	aspect_ratio_info;
+	__u8	frame_rate_code;
+	__u32	bitrate_value;
+	__u16	vbv_buffer_size;
+	__u8	constrained_parameters_flag;
+	__u8	load_intra_quantiser_matrix, load_non_intra_quantiser_matrix;
+	__u8	intra_quantiser_matrix[MPEG2_QUANTISER_MATRIX_SIZE];
+	__u8	non_intra_quantiser_matrix[MPEG2_QUANTISER_MATRIX_SIZE];
+	__u32	par_w, par_h;
+	__u32	fps_n, fps_d;
+	__u32	bitrate;
+};
+#define V4L2_CID_MPEG_VIDEO_MPEG2_SEQ_EXT		(V4L2_CID_MPEG_BASE+451)
+struct v4l2_mpeg_video_mpeg2_seq_ext {
+	__u8	profile;
+	__u8	level;
+	__u8	progressive;
+	__u8	chroma_format;
+	__u8	horiz_size_ext, vert_size_ext;
+	__u16	bitrate_ext;
+	__u8	vbv_buffer_size_ext;
+	__u8	low_delay;
+	__u8	fps_n_ext, fps_d_ext;
+};
+#define V4L2_CID_MPEG_VIDEO_MPEG2_SEQ_DISPLAY_EXT	(V4L2_CID_MPEG_BASE+452)
+struct v4l2_mpeg_video_mpeg2_seq_display_ext {
+	__u8	video_format;
+	__u8	colour_description_flag;
+	__u8	colour_primaries;
+	__u8	transfer_characteristics;
+	__u8	matrix_coefficients;
+	__u16	display_horizontal_size;
+	__u16	display_vertical_size;
+};
+#define V4L2_CID_MPEG_VIDEO_MPEG2_SEQ_MATRIX_EXT	(V4L2_CID_MPEG_BASE+453)
+struct v4l2_mpeg_video_mpeg2_seq_matrix_ext {
+	__u8	load_intra_quantiser_matrix;
+	__u8	intra_quantiser_matrix[MPEG2_QUANTISER_MATRIX_SIZE];
+	__u8	load_non_intra_quantiser_matrix;
+	__u8	non_intra_quantiser_matrix[MPEG2_QUANTISER_MATRIX_SIZE];
+	__u8	load_chroma_intra_quantiser_matrix;
+	__u8	chroma_intra_quantiser_matrix[MPEG2_QUANTISER_MATRIX_SIZE];
+	__u8	load_chroma_non_intra_quantiser_matrix;
+	__u8	chroma_non_intra_quantiser_matrix[MPEG2_QUANTISER_MATRIX_SIZE];
+};
+#define V4L2_CID_MPEG_VIDEO_MPEG2_PIC_HDR		(V4L2_CID_MPEG_BASE+454)
+struct v4l2_mpeg_video_mpeg2_pic_hdr {
+	__u32	offset;
+	__u16	tsn;
+	__u8	pic_type;
+	__u16	vbv_delay;
+	__u8	full_pel_forward_vector, full_pel_backward_vector;
+	__u8	f_code[2][2];
+};
+#define V4L2_CID_MPEG_VIDEO_MPEG2_PIC_EXT		(V4L2_CID_MPEG_BASE+455)
+struct v4l2_mpeg_video_mpeg2_pic_ext {
+	__u8	f_code[2][2];
+	__u8	intra_dc_precision;
+	__u8	picture_structure;
+	__u8	top_field_first;
+	__u8	frame_pred_frame_dct;
+	__u8	concealment_motion_vectors;
+	__u8	q_scale_type;
+	__u8	intra_vlc_format;
+	__u8	alternate_scan;
+	__u8	repeat_first_field;
+	__u8	chroma_420_type;
+	__u8	progressive_frame;
+	__u8	composite_display;
+	__u8	v_axis;
+	__u8	field_sequence;
+	__u8	sub_carrier;
+	__u8	burst_amplitude;
+	__u8	sub_carrier_phase;
+};
+
 /*  Control IDs for VP8 streams
  *  Although VP8 is not part of MPEG we add these controls to the MPEG class
  *  as that class is already handling other video compression standards
diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 46e8a2e3..ada8a62 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -623,7 +623,9 @@ struct v4l2_pix_format {
 #define V4L2_PIX_FMT_H264_MVC v4l2_fourcc('M', '2', '6', '4') /* H264 MVC */
 #define V4L2_PIX_FMT_H263     v4l2_fourcc('H', '2', '6', '3') /* H263          */
 #define V4L2_PIX_FMT_MPEG1    v4l2_fourcc('M', 'P', 'G', '1') /* MPEG-1 ES     */
+#define V4L2_PIX_FMT_MPEG1_PARSED v4l2_fourcc('M', 'G', '1', 'P') /* MPEG1 with parsing metadata given through controls */
 #define V4L2_PIX_FMT_MPEG2    v4l2_fourcc('M', 'P', 'G', '2') /* MPEG-2 ES     */
+#define V4L2_PIX_FMT_MPEG2_PARSED v4l2_fourcc('M', 'G', '2', 'P') /* MPEG2 with parsing metadata given through controls */
 #define V4L2_PIX_FMT_MPEG4    v4l2_fourcc('M', 'P', 'G', '4') /* MPEG-4 part 2 ES */
 #define V4L2_PIX_FMT_XVID     v4l2_fourcc('X', 'V', 'I', 'D') /* Xvid           */
 #define V4L2_PIX_FMT_VC1_ANNEX_G v4l2_fourcc('V', 'C', '1', 'G') /* SMPTE 421M Annex G compliant stream */
@@ -1601,6 +1603,12 @@ enum v4l2_ctrl_type {
 	V4L2_CTRL_TYPE_U8	     = 0x0100,
 	V4L2_CTRL_TYPE_U16	     = 0x0101,
 	V4L2_CTRL_TYPE_U32	     = 0x0102,
+	V4L2_CTRL_TYPE_MPEG2_SEQ_HDR  = 0x0109,
+	V4L2_CTRL_TYPE_MPEG2_SEQ_EXT  = 0x010A,
+	V4L2_CTRL_TYPE_MPEG2_SEQ_DISPLAY_EXT  = 0x010B,
+	V4L2_CTRL_TYPE_MPEG2_SEQ_MATRIX_EXT  = 0x010C,
+	V4L2_CTRL_TYPE_MPEG2_PIC_HDR  = 0x010D,
+	V4L2_CTRL_TYPE_MPEG2_PIC_EXT  = 0x010E,
 };
 
 /*  Used in the VIDIOC_QUERYCTRL ioctl for querying controls */
-- 
1.9.1

