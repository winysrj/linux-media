Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:52658 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754265AbdBGOGr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 7 Feb 2017 09:06:47 -0500
From: Hugues Fruchet <hugues.fruchet@st.com>
To: <linux-media@vger.kernel.org>, Hans Verkuil <hverkuil@xs4all.nl>
CC: <kernel@stlinux.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Jean-Christophe Trotin <jean-christophe.trotin@st.com>
Subject: [PATCH v1 3/3] libv4l-codecparsers: add GStreamer mpeg2 parser
Date: Tue, 7 Feb 2017 15:06:27 +0100
Message-ID: <1486476387-8069-4-git-send-email-hugues.fruchet@st.com>
In-Reply-To: <1486476387-8069-1-git-send-email-hugues.fruchet@st.com>
References: <1486476387-8069-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add the mpeg2 codecparser backend glue which will
call the GStreamer parsing functions.

Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
---
 configure.ac                                    |  21 ++
 lib/libv4l-codecparsers/Makefile.am             |  14 +-
 lib/libv4l-codecparsers/libv4l-cparsers-mpeg2.c | 375 ++++++++++++++++++++++++
 lib/libv4l-codecparsers/libv4l-cparsers.c       |   4 +
 4 files changed, 413 insertions(+), 1 deletion(-)
 create mode 100644 lib/libv4l-codecparsers/libv4l-cparsers-mpeg2.c

diff --git a/configure.ac b/configure.ac
index af38e6d..72150be 100644
--- a/configure.ac
+++ b/configure.ac
@@ -272,6 +272,25 @@ fi
 
 AC_SUBST([JPEG_LIBS])
 
+# Check for GStreamer codecparsers
+
+gst_codecparsers_pkgconfig=false
+PKG_CHECK_MODULES([GST], [gstreamer-1.0 >= 1.8.0], [gst_pkgconfig=true], [gst_pkgconfig=false])
+if test "x$gst_pkgconfig" = "xfalse"; then
+   AC_MSG_WARN(GStreamer library is not available)
+else
+   PKG_CHECK_MODULES([GST_BASE], [gstreamer-base-1.0 >= 1.8.0], [gst_base_pkgconfig=true], [gst_base_pkgconfig=false])
+   if test "x$gst_base_pkgconfig" = "xfalse"; then
+      AC_MSG_WARN(GStreamer base library is not available)
+   else
+      PKG_CHECK_MODULES(GST_CODEC_PARSERS, [gstreamer-codecparsers-1.0 >= 1.8.0], [gst_codecparsers_pkgconfig=true], [gst_codecparsers_pkgconfig=false])
+      if test "x$gst_codecparsers_pkgconfig" = "xfalse"; then
+         AC_MSG_WARN(GStreamer codecparser library is not available)
+      fi
+   fi
+fi
+AM_CONDITIONAL([HAVE_GST_CODEC_PARSERS], [test x$gst_codecparsers_pkgconfig = xtrue])
+
 # Check for pthread
 
 AS_IF([test x$enable_shared != xno],
@@ -466,6 +485,7 @@ AM_COND_IF([WITH_GCONV], [USE_GCONV="yes"], [USE_GCONV="no"])
 AM_COND_IF([WITH_V4L2_CTL_LIBV4L], [USE_V4L2_CTL="yes"], [USE_V4L2_CTL="no"])
 AM_COND_IF([WITH_V4L2_COMPLIANCE_LIBV4L], [USE_V4L2_COMPLIANCE="yes"], [USE_V4L2_COMPLIANCE="no"])
 AS_IF([test "x$alsa_pkgconfig" = "xtrue"], [USE_ALSA="yes"], [USE_ALSA="no"])
+AS_IF([test "x$gst_codecparsers_pkgconfig" = "xtrue"], [USE_GST_CODECPARSERS="yes"], [USE_GST_CODECPARSERS="no"])
 
 AC_OUTPUT
 
@@ -486,6 +506,7 @@ compile time options summary
     pthread             : $have_pthread
     QT version          : $QT_VERSION
     ALSA support        : $USE_ALSA
+    GST codecparsers    : $USE_GST_CODECPARSERS
 
     build dynamic libs  : $enable_shared
     build static libs   : $enable_static
diff --git a/lib/libv4l-codecparsers/Makefile.am b/lib/libv4l-codecparsers/Makefile.am
index a9d6c8b..61f4730 100644
--- a/lib/libv4l-codecparsers/Makefile.am
+++ b/lib/libv4l-codecparsers/Makefile.am
@@ -1,9 +1,21 @@
 if WITH_V4L_PLUGINS
+if HAVE_GST_CODEC_PARSERS
+
 libv4l2plugin_LTLIBRARIES = libv4l-codecparsers.la
-endif
 
 libv4l_codecparsers_la_SOURCES = libv4l-cparsers.c libv4l-cparsers.h
 
 libv4l_codecparsers_la_CPPFLAGS = $(CFLAG_VISIBILITY) -I$(top_srcdir)/lib/libv4l2/ -I$(top_srcdir)/lib/libv4lconvert/
 libv4l_codecparsers_la_LDFLAGS = -avoid-version -module -shared -export-dynamic -lpthread
 libv4l_codecparsers_la_LIBADD = ../libv4l2/libv4l2.la
+
+# GStreamer codecparsers library
+libv4l_codecparsers_la_CFLAGS = $(GST_CFLAGS) -DGST_USE_UNSTABLE_API
+libv4l_codecparsers_la_LDFLAGS += $(GST_LIB_LDFLAGS)
+libv4l_codecparsers_la_LIBADD += $(GLIB_LIBS) $(GST_LIBS) $(GST_BASE_LIBS) $(GST_CODEC_PARSERS_LIBS) $(NULL)
+
+# MPEG-2 parser back-end
+libv4l_codecparsers_la_SOURCES += libv4l-cparsers-mpeg2.c
+
+endif
+endif
diff --git a/lib/libv4l-codecparsers/libv4l-cparsers-mpeg2.c b/lib/libv4l-codecparsers/libv4l-cparsers-mpeg2.c
new file mode 100644
index 0000000..3456b73
--- /dev/null
+++ b/lib/libv4l-codecparsers/libv4l-cparsers-mpeg2.c
@@ -0,0 +1,375 @@
+/*
+ * libv4l-cparsers-mpeg2.c
+ *
+ * Copyright (C) STMicroelectronics SA 2017
+ * Authors: Hugues Fruchet <hugues.fruchet@st.com>
+ *          Tifaine Inguere <tifaine.inguere@st.com>
+ *          for STMicroelectronics.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU Lesser General Public License as published by
+ * the Free Software Foundation; either version 2.1 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * Lesser General Public License for more details.
+ *
+ * You should have received a copy of the GNU Lesser General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Suite 500, Boston, MA  02110-1335  USA
+ */
+
+#include <errno.h>
+#include <stdlib.h>
+#include <string.h>
+#include <stdbool.h>
+
+#include "libv4l2.h"
+#include "libv4l2-priv.h"
+#include "libv4l-cparsers.h"
+
+#include <gst/codecparsers/gstmpegvideoparser.h>
+#include <gst/base/gstbitreader.h>
+
+/*
+ * parsing metadata ids and their associated control ids.
+ * keep in sync both enum and array, this is used to index metas[<meta id>]
+ */
+enum mpeg2_meta_id {
+	SEQ_HDR,
+	SEQ_EXT,
+	SEQ_DISPLAY_EXT,
+	SEQ_MATRIX_EXT,
+	PIC_HDR,
+	PIC_HDR1,/* 2nd field decoding of interlaced stream */
+	PIC_EXT,
+	PIC_EXT1,/* 2nd field decoding of interlaced stream */
+};
+
+static const struct v4l2_ext_control mpeg2_metas_store[] = {
+	{
+	.id = V4L2_CID_MPEG_VIDEO_MPEG2_SEQ_HDR,
+	.size = sizeof(struct v4l2_mpeg_video_mpeg2_seq_hdr),
+	},
+	{
+	.id = V4L2_CID_MPEG_VIDEO_MPEG2_SEQ_EXT,
+	.size = sizeof(struct v4l2_mpeg_video_mpeg2_seq_ext),
+	},
+	{
+	.id = V4L2_CID_MPEG_VIDEO_MPEG2_SEQ_DISPLAY_EXT,
+	.size = sizeof(struct v4l2_mpeg_video_mpeg2_seq_display_ext),
+	},
+	{
+	.id = V4L2_CID_MPEG_VIDEO_MPEG2_SEQ_MATRIX_EXT,
+	.size = sizeof(struct v4l2_mpeg_video_mpeg2_seq_matrix_ext),
+	},
+	{
+	.id = V4L2_CID_MPEG_VIDEO_MPEG2_PIC_HDR,
+	.size = sizeof(struct v4l2_mpeg_video_mpeg2_pic_hdr),
+	},
+	{/* 2nd field decoding of interlaced stream */
+	.id = V4L2_CID_MPEG_VIDEO_MPEG2_PIC_HDR,
+	.size = sizeof(struct v4l2_mpeg_video_mpeg2_pic_hdr),
+	},
+	{
+	.id = V4L2_CID_MPEG_VIDEO_MPEG2_PIC_EXT,
+	.size = sizeof(struct v4l2_mpeg_video_mpeg2_pic_ext),
+	},
+	{/* 2nd field decoding of interlaced stream */
+	.id = V4L2_CID_MPEG_VIDEO_MPEG2_PIC_EXT,
+	.size = sizeof(struct v4l2_mpeg_video_mpeg2_pic_ext),
+	},
+};
+
+guint8 get_extension_code(const GstMpegVideoPacket *packet)
+{
+	GstBitReader br;
+	unsigned char extension_code;
+
+	gst_bit_reader_init(&br, &packet->data[packet->offset], packet->size);
+	if (!gst_bit_reader_get_bits_uint8(&br, &extension_code, 4)) {
+		V4L2_LOG_ERR("failed to read extension code");
+		return GST_MPEG_VIDEO_PACKET_NONE;
+	}
+
+	return extension_code;
+}
+
+unsigned int mpeg2_parse_metas(struct cparsers_au *au,
+			       struct v4l2_ext_control *metas,
+			       unsigned int *nb_of_metas)
+{
+	unsigned char extension_code;
+	bool startcode_found = false;
+	bool meta_found = false;
+	GstMpegVideoPacket packet_data;
+	unsigned int slice_index = 0;
+	GstMpegVideoSequenceHdr gst_seq_hdr;
+	GstMpegVideoSequenceExt gst_seq_ext;
+	GstMpegVideoSequenceDisplayExt gst_seq_display_ext;
+	GstMpegVideoQuantMatrixExt gst_seq_matrix_ext;
+	GstMpegVideoPictureHdr gst_pic_hdr;
+	GstMpegVideoPictureExt gst_pic_ext;
+	struct v4l2_mpeg_video_mpeg2_seq_hdr *seq_hdr;
+	struct v4l2_mpeg_video_mpeg2_seq_ext *seq_ext;
+	struct v4l2_mpeg_video_mpeg2_seq_display_ext *seq_display_ext;
+	struct v4l2_mpeg_video_mpeg2_seq_matrix_ext *seq_matrix_ext;
+	struct v4l2_mpeg_video_mpeg2_pic_hdr *pic_hdrs[2];
+	struct v4l2_mpeg_video_mpeg2_pic_ext *pic_exts[2];
+
+	if ((!au->addr) || (!au->bytesused) || (!au->metas_store) || (!metas)) {
+		V4L2_LOG_ERR("%s: invalid input: au->addr=%p, au->bytesused=%d, au->metas_store=%p, metas=%p\n",
+			     __func__, au->addr, au->bytesused, au->metas_store, metas);
+		return 0;
+	}
+
+	seq_hdr = au->metas_store[SEQ_HDR].ptr;
+	seq_ext = au->metas_store[SEQ_EXT].ptr;
+	seq_display_ext = au->metas_store[SEQ_DISPLAY_EXT].ptr;
+	seq_matrix_ext = au->metas_store[SEQ_MATRIX_EXT].ptr;
+	pic_hdrs[0] = au->metas_store[PIC_HDR].ptr;
+	pic_hdrs[1] = au->metas_store[PIC_HDR + 1].ptr;
+	pic_exts[0] = au->metas_store[PIC_EXT].ptr;
+	pic_exts[1] = au->metas_store[PIC_EXT + 1].ptr;
+
+	memset(&packet_data, 0, sizeof(packet_data));
+
+	while (((packet_data.offset + 4) < au->bytesused)) {
+		V4L2_LOG("%s: parsing input from offset=%d\n", __func__,
+			 packet_data.offset);
+		startcode_found = gst_mpeg_video_parse(&packet_data, au->addr, au->bytesused, packet_data.offset);
+		if (!startcode_found) {
+			V4L2_LOG("%s: parsing is over\n", __func__);
+			break;
+		}
+		/*
+		 * gst_mpeg_video_parse compute packet size by searching for next
+		 * startcode, but if next startcode is not found (end of access unit),
+		 * packet size is set to -1. We fix this here and set packet size
+		 * to remaining size in this case.
+		 */
+		if (packet_data.size < 0)
+			packet_data.size = au->bytesused - packet_data.offset;
+
+		V4L2_LOG("%s: found startcode 0x%02x @offset=%u, size=%d\n",
+			 __func__, packet_data.type, packet_data.offset - 4, packet_data.size);
+
+		switch (packet_data.type) {
+		case GST_MPEG_VIDEO_PACKET_PICTURE:
+			if (gst_mpeg_video_packet_parse_picture_header
+			    (&packet_data, &gst_pic_hdr)) {
+				struct v4l2_mpeg_video_mpeg2_pic_hdr *pic_hdr = pic_hdrs[slice_index];
+
+				metas[(*nb_of_metas)++] = au->metas_store[PIC_HDR + slice_index];
+
+				memset(pic_hdr, 0, sizeof(*pic_hdr));
+				pic_hdr->tsn = gst_pic_hdr.tsn;
+				pic_hdr->pic_type = gst_pic_hdr.pic_type;
+				pic_hdr->full_pel_forward_vector = gst_pic_hdr.full_pel_forward_vector;
+				pic_hdr->full_pel_backward_vector = gst_pic_hdr.full_pel_backward_vector;
+				memcpy(&pic_hdr->f_code, &gst_pic_hdr.f_code, sizeof(pic_hdr->f_code));
+
+				V4L2_LOG("%s: PICTURE HEADER\n", __func__);
+				meta_found = true;
+			}
+			break;
+
+		case GST_MPEG_VIDEO_PACKET_SLICE_MIN:
+			/* New slice encountered */
+			if (slice_index > 1) {
+				V4L2_LOG_ERR("%s: more than 2 slices detected @offset=%d, ignoring this slice...\n",
+					     __func__, packet_data.offset);
+				break;
+			}
+			/* store its offset, including startcode */
+			pic_hdrs[slice_index]->offset = packet_data.offset - 4;
+			slice_index++;
+
+			V4L2_LOG("%s: START OF SLICE @ offset=%d\n", __func__, packet_data.offset);
+			meta_found = true;
+			goto done;
+
+			break;
+
+		case GST_MPEG_VIDEO_PACKET_USER_DATA:
+			/* not implemented : do nothing */
+			V4L2_LOG("%s: USER DATA, not implemented\n", __func__);
+			break;
+
+		case GST_MPEG_VIDEO_PACKET_SEQUENCE:
+			if (gst_mpeg_video_packet_parse_sequence_header
+			    (&packet_data, &gst_seq_hdr)) {
+				metas[(*nb_of_metas)++] = au->metas_store[SEQ_HDR];
+
+				memset(seq_hdr, 0, sizeof(*seq_hdr));
+				seq_hdr->width = gst_seq_hdr.width;
+				seq_hdr->height = gst_seq_hdr.height;
+				seq_hdr->load_intra_quantiser_matrix = 1;
+				memcpy(&seq_hdr->intra_quantiser_matrix,
+				       &gst_seq_hdr.intra_quantizer_matrix,
+				       sizeof(seq_hdr->intra_quantiser_matrix));
+				seq_hdr->load_non_intra_quantiser_matrix = 1;
+				memcpy(&seq_hdr->non_intra_quantiser_matrix,
+				       &gst_seq_hdr.non_intra_quantizer_matrix,
+				       sizeof(seq_hdr->non_intra_quantiser_matrix));
+
+				V4L2_LOG("%s: SEQUENCE HEADER\n", __func__);
+				meta_found = true;
+			}
+			break;
+
+		case GST_MPEG_VIDEO_PACKET_EXTENSION:
+			extension_code = get_extension_code(&packet_data);
+			V4L2_LOG("%s: extension code=0x%02x  \n", __func__, extension_code);
+
+			switch (extension_code) {
+			case GST_MPEG_VIDEO_PACKET_EXT_SEQUENCE:
+				if (gst_mpeg_video_packet_parse_sequence_extension
+				    (&packet_data, &gst_seq_ext)) {
+					metas[(*nb_of_metas)++] = au->metas_store[SEQ_EXT];
+
+					memset(seq_ext, 0, sizeof(*seq_ext));
+					seq_ext->profile = gst_seq_ext.profile;
+					seq_ext->level = gst_seq_ext.level;
+					seq_ext->progressive = gst_seq_ext.progressive;
+					seq_ext->chroma_format = gst_seq_ext.chroma_format;
+					seq_ext->horiz_size_ext = gst_seq_ext.horiz_size_ext;
+					seq_ext->vert_size_ext = gst_seq_ext.vert_size_ext;
+
+					V4L2_LOG("%s: SEQUENCE EXTENSION\n", __func__);
+					meta_found = true;
+				}
+				break;
+
+			case GST_MPEG_VIDEO_PACKET_EXT_SEQUENCE_DISPLAY:
+				if (gst_mpeg_video_packet_parse_sequence_display_extension
+				    (&packet_data, &gst_seq_display_ext)) {
+					metas[(*nb_of_metas)++] = au->metas_store[SEQ_DISPLAY_EXT];
+
+					memset(seq_display_ext, 0, sizeof(*seq_display_ext));
+					seq_display_ext->video_format = gst_seq_display_ext.video_format;
+					seq_display_ext->colour_description_flag = gst_seq_display_ext.colour_description_flag;
+					seq_display_ext->colour_primaries = gst_seq_display_ext.colour_primaries;
+					seq_display_ext->transfer_characteristics = gst_seq_display_ext.transfer_characteristics;
+					seq_display_ext->matrix_coefficients = gst_seq_display_ext.matrix_coefficients;
+					seq_display_ext->display_horizontal_size = gst_seq_display_ext.display_horizontal_size;
+					seq_display_ext->display_vertical_size = gst_seq_display_ext.display_vertical_size;
+
+					V4L2_LOG("%s: SEQUENCE DISPLAY EXTENSION\n", __func__);
+					meta_found = true;
+				}
+				break;
+
+			case GST_MPEG_VIDEO_PACKET_EXT_QUANT_MATRIX:
+				if (gst_mpeg_video_packet_parse_quant_matrix_extension
+				    (&packet_data, &gst_seq_matrix_ext)) {
+					metas[(*nb_of_metas)++] = au->metas_store[SEQ_DISPLAY_EXT];
+
+					memset(seq_matrix_ext, 0, sizeof(*seq_matrix_ext));
+					seq_matrix_ext->load_intra_quantiser_matrix =
+						gst_seq_matrix_ext.load_intra_quantiser_matrix;
+					memcpy(&seq_matrix_ext->intra_quantiser_matrix,
+					       &gst_seq_matrix_ext.intra_quantiser_matrix,
+					       sizeof(seq_matrix_ext->intra_quantiser_matrix));
+					seq_matrix_ext->load_non_intra_quantiser_matrix =
+						gst_seq_matrix_ext.load_non_intra_quantiser_matrix;
+					memcpy(&seq_matrix_ext->non_intra_quantiser_matrix,
+					       &gst_seq_matrix_ext.non_intra_quantiser_matrix,
+					       sizeof(seq_matrix_ext->non_intra_quantiser_matrix));
+					seq_matrix_ext->load_chroma_intra_quantiser_matrix =
+						gst_seq_matrix_ext.load_chroma_intra_quantiser_matrix;
+					memcpy(&seq_matrix_ext->chroma_intra_quantiser_matrix,
+					       &gst_seq_matrix_ext.chroma_intra_quantiser_matrix,
+					       sizeof(seq_matrix_ext->chroma_intra_quantiser_matrix));
+					seq_matrix_ext->load_chroma_non_intra_quantiser_matrix =
+						gst_seq_matrix_ext.load_chroma_non_intra_quantiser_matrix;
+					memcpy(&seq_matrix_ext->chroma_non_intra_quantiser_matrix,
+					       &gst_seq_matrix_ext.chroma_non_intra_quantiser_matrix,
+					       sizeof(seq_matrix_ext->chroma_non_intra_quantiser_matrix));
+
+					V4L2_LOG("%s: SEQUENCE MATRIX EXTENSION\n", __func__);
+					meta_found = true;
+				}
+				break;
+
+			case GST_MPEG_VIDEO_PACKET_EXT_SEQUENCE_SCALABLE:
+				/* not implemented : do nothing */
+				V4L2_LOG("%s: SEQUENCE SCALABLE EXTENSION, not implemented\n", __func__);
+				break;
+
+			case GST_MPEG_VIDEO_PACKET_EXT_PICTURE:
+				if (gst_mpeg_video_packet_parse_picture_extension
+				    (&packet_data, &gst_pic_ext)) {
+					struct v4l2_mpeg_video_mpeg2_pic_ext *pic_ext = pic_exts[slice_index];
+
+					metas[(*nb_of_metas)++] = au->metas_store[PIC_EXT + slice_index];
+
+					memset(pic_ext, 0, sizeof(*pic_ext));
+					memcpy(&pic_ext->f_code, &gst_pic_ext.f_code, sizeof(pic_ext->f_code));
+					pic_ext->intra_dc_precision = gst_pic_ext.intra_dc_precision;
+					pic_ext->picture_structure = gst_pic_ext.picture_structure;
+					pic_ext->top_field_first = gst_pic_ext.top_field_first;
+					pic_ext->frame_pred_frame_dct = gst_pic_ext.frame_pred_frame_dct;
+					pic_ext->concealment_motion_vectors = gst_pic_ext.concealment_motion_vectors;
+					pic_ext->q_scale_type = gst_pic_ext.q_scale_type;
+					pic_ext->intra_vlc_format = gst_pic_ext.intra_vlc_format;
+					pic_ext->alternate_scan = gst_pic_ext.alternate_scan;
+					pic_ext->repeat_first_field = gst_pic_ext.repeat_first_field;
+					pic_ext->chroma_420_type = gst_pic_ext.chroma_420_type;
+					pic_ext->progressive_frame = gst_pic_ext.progressive_frame;
+					pic_ext->composite_display = gst_pic_ext.composite_display;
+					pic_ext->v_axis = gst_pic_ext.v_axis;
+					pic_ext->field_sequence = gst_pic_ext.field_sequence;
+					pic_ext->sub_carrier = gst_pic_ext.sub_carrier;
+					pic_ext->burst_amplitude = gst_pic_ext.burst_amplitude;
+					pic_ext->sub_carrier_phase = gst_pic_ext.sub_carrier_phase;
+
+					V4L2_LOG("%s: PICTURE EXTENSION, top_field_first=%d\n",
+						 __func__, pic_exts[slice_index]->top_field_first);
+					meta_found = true;
+				}
+				break;
+
+			default:
+				break;
+			}
+			break;
+
+		case GST_MPEG_VIDEO_PACKET_SEQUENCE_END:
+			V4L2_LOG("%s: END OF PACKET SEQUENCE\n", __func__);
+			break;
+
+		case GST_MPEG_VIDEO_PACKET_GOP:
+			V4L2_LOG("%s: GOP\n", __func__);
+			break;
+
+		default:
+			V4L2_LOG("%s: unknown/unsupported header %02x\n",
+				 __func__, packet_data.type);
+			break;
+		}
+	}
+
+done:
+	return meta_found;
+}
+
+const struct meta_parser mpeg2parse = {
+	.name = "mpeg2",
+	.streamformat = V4L2_PIX_FMT_MPEG2,
+	.parsedformat = V4L2_PIX_FMT_MPEG2_PARSED,
+	.nb_of_metas = sizeof(mpeg2_metas_store) / sizeof(mpeg2_metas_store[0]),
+	.metas_store = mpeg2_metas_store,
+	.parse_metas = mpeg2_parse_metas,
+};
+
+const struct meta_parser mpeg1parse = {
+	.name = "mpeg1",
+	.streamformat = V4L2_PIX_FMT_MPEG1,
+	.parsedformat = V4L2_PIX_FMT_MPEG1_PARSED,
+	.nb_of_metas = sizeof(mpeg2_metas_store) / sizeof(mpeg2_metas_store[0]),
+	.metas_store = mpeg2_metas_store,
+	.parse_metas = mpeg2_parse_metas,
+};
diff --git a/lib/libv4l-codecparsers/libv4l-cparsers.c b/lib/libv4l-codecparsers/libv4l-cparsers.c
index af59f50..4e8ae31 100644
--- a/lib/libv4l-codecparsers/libv4l-cparsers.c
+++ b/lib/libv4l-codecparsers/libv4l-cparsers.c
@@ -46,7 +46,11 @@
 #endif
 
 /* available parsers */
+extern const struct meta_parser mpeg1parse;
+extern const struct meta_parser mpeg2parse;
 const struct meta_parser *parsers[] = {
+	&mpeg1parse,
+	&mpeg2parse,
 };
 
 static void *plugin_init(int fd)
-- 
1.9.1

