Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:54534 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932719AbcJGRA2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Oct 2016 13:00:28 -0400
From: Hugues Fruchet <hugues.fruchet@st.com>
To: <linux-media@vger.kernel.org>, Hans Verkuil <hverkuil@xs4all.nl>
CC: <kernel@stlinux.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Jean-Christophe Trotin <jean-christophe.trotin@st.com>
Subject: [PATCH v1 3/3] libv4l-delta: add mpeg header parser
Date: Fri, 7 Oct 2016 19:00:18 +0200
Message-ID: <1475859618-829-4-git-send-email-hugues.fruchet@st.com>
In-Reply-To: <1475859618-829-1-git-send-email-hugues.fruchet@st.com>
References: <1475859618-829-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Tiphaine Inguere <tifaine.inguere@st.com>

If the input stream format is MPEG1 or MPEG2, the stream is parsed
using mpeg parser library to build mpeg metadata.

Change-Id: I767cd0a8ea546755bcdc031ca4a2808690cccf63
signed-off-by: Tiphaine Inguere <tifaine.inguere@st.com>
Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
---
 lib/libv4l-delta/Makefile.am          |   4 +
 lib/libv4l-delta/libv4l-delta-mpeg2.c | 211 ++++++++++++++++++++++++++++++++++
 lib/libv4l-delta/libv4l-delta.c       |   6 +-
 3 files changed, 220 insertions(+), 1 deletion(-)
 create mode 100644 lib/libv4l-delta/libv4l-delta-mpeg2.c

diff --git a/lib/libv4l-delta/Makefile.am b/lib/libv4l-delta/Makefile.am
index fa401b6..3812de5 100644
--- a/lib/libv4l-delta/Makefile.am
+++ b/lib/libv4l-delta/Makefile.am
@@ -6,6 +6,10 @@ SUBDIRS = codecparsers
 
 libv4l_delta_la_SOURCES = libv4l-delta.c libv4l-delta.h
 
+##### MPEG2 decoder #####
+libv4l_delta_la_SOURCES += libv4l-delta-mpeg2.c
+
+##### Codecparser interface  #####
 libv4l_delta_la_CPPFLAGS = $(CFLAG_VISIBILITY)
 libv4l_delta_la_CFLAGS =	$(GST_CFLAGS)	-DGST_USE_UNSTABLE_API
 libv4l_delta_la_LDFLAGS = -avoid-version -module -shared -export-dynamic -lpthread
diff --git a/lib/libv4l-delta/libv4l-delta-mpeg2.c b/lib/libv4l-delta/libv4l-delta-mpeg2.c
new file mode 100644
index 0000000..7f69dd4
--- /dev/null
+++ b/lib/libv4l-delta/libv4l-delta-mpeg2.c
@@ -0,0 +1,211 @@
+/*
+ * libv4l-delta-mpeg2.c
+ *
+ * Copyright (C) STMicroelectronics SA 2014
+ * Authors: Tifaine Inguere <tifaine.inguere@st.com>
+ *          Hugues Fruchet <hugues.fruchet@st.com>
+ */
+#include <errno.h>
+#include <stdlib.h>
+#include <string.h>
+
+#include "codecparsers/gstmpegvideoparser.h"
+#include "libv4l-delta.h"
+
+/* FIXME
+ * - meta coherency check (what is mandatory vs optional)
+ * - meta compatibility check (GST types must be aligned with V4L2 ones)
+ * - parsing errors tracing (trace in case of gst_parse_xxx fails)
+ * - do not parse all access unit (currently needed to detect the
+ *   second slice of a field interlaced bitstream)
+ */
+
+unsigned int delta_mpeg2_decode_header(void *au_addr,
+									   unsigned int au_size,
+									   struct v4l2_ctrl_mpeg2_meta *meta)
+{
+	unsigned char ExtensionCode;
+	unsigned int startcode_found = 0;
+	unsigned int header_found = 0;
+	GstMpegVideoPacket packet_data;
+	unsigned int slice_index = 0;
+
+	DELTA_LOG_DEBUG("> %s\n", __func__);
+
+	if ((!au_addr) || (!au_size) || (!meta)) {
+		DELTA_LOG_ERR("%s: invalid input: au_addr=%p, au_size=%d, meta=%p\n",
+					  __func__, au_addr, au_size, meta);
+		return 0;
+	}
+
+	memset(meta, 0, sizeof(*meta));
+	meta->struct_size = sizeof(*meta);
+
+	memset(&packet_data, 0, sizeof(packet_data));
+
+	while (((packet_data.offset + 4) < au_size)) {
+		DELTA_LOG_DEBUG("%s: parsing input from offset=%d\n", __func__,
+						packet_data.offset);
+		startcode_found = gst_mpeg_video_parse(&packet_data, au_addr, au_size,
+											   packet_data.offset);
+		if (!startcode_found) {
+			DELTA_LOG_DEBUG("%s: parsing is over\n", __func__);
+            break;
+		}
+		DELTA_LOG_DEBUG("%s: found starcode @offset=%u, code=0x%02x\n",
+						__func__, packet_data.offset - 4, packet_data.type);
+
+		switch (packet_data.type) {
+		case GST_MPEG_VIDEO_PACKET_PICTURE:
+			if (gst_mpeg_video_packet_parse_picture_header
+			    (&packet_data,
+				 (GstMpegVideoPictureHdr *)&(meta->pic[slice_index].pic_h))) {
+				meta->flags |= V4L2_CTRL_MPEG2_FLAG_PIC;
+				meta->pic[slice_index].flags |= MPEG2_META_PIC_FLAG_HDR;
+				DELTA_LOG_DEBUG("%s: MPEG2_META_PIC_FLAG_HDR\n", __func__);
+				header_found = 1;
+			}
+			break;
+
+		case GST_MPEG_VIDEO_PACKET_SLICE_MIN:
+			/* new slice encountered */
+			/* FIXME we can avoid to parse too much data here by stopping
+			* at first slice encountered but not in the case of field
+			* interlaced where 2 slices are expected
+			*/
+			if (slice_index > 1) {
+				DELTA_LOG_ERR("%s: more than 2 slices detected @offset=%d, ignoring this slice...\n",
+							  __func__, packet_data.offset);
+				break;
+			}
+
+			/* store its offset & size, including startcode */
+			meta->pic[slice_index].offset = packet_data.offset - 4;
+
+			slice_index++;
+
+			DELTA_LOG_DEBUG("%s: start of slice @ offset=%d\n", __func__, packet_data.offset);
+			header_found = 1;
+			break;
+
+		case GST_MPEG_VIDEO_PACKET_USER_DATA:
+			/* not implemented : do nothing */
+			DELTA_LOG_DEBUG("%s: user-data case not implemented\n", __func__);
+			break;
+
+		case GST_MPEG_VIDEO_PACKET_SEQUENCE:
+			if (gst_mpeg_video_packet_parse_sequence_header
+			    (&packet_data,
+				 (GstMpegVideoSequenceHdr *)&(meta->seq.seq_h))) {
+				meta->flags |= V4L2_CTRL_MPEG2_FLAG_SEQ;
+				meta->seq.flags |= MPEG2_META_SEQ_FLAG_HDR;
+				DELTA_LOG_DEBUG("%s: MPEG2_META_SEQ_FLAG_HDR\n", __func__);
+				header_found = 1;
+			}
+			break;
+
+		case GST_MPEG_VIDEO_PACKET_EXTENSION:
+			ExtensionCode = get_extension_code(&packet_data);
+			DELTA_LOG_DEBUG("%s: ExtensionCode=0x%02x  \n", __func__, ExtensionCode);
+
+			switch (ExtensionCode) {
+			case GST_MPEG_VIDEO_PACKET_EXT_SEQUENCE:
+				if (gst_mpeg_video_packet_parse_sequence_extension
+				    (&packet_data,
+					 (GstMpegVideoSequenceExt *)&(meta->seq.seq_e))) {
+					meta->flags |= V4L2_CTRL_MPEG2_FLAG_SEQ;
+					meta->seq.flags |= MPEG2_META_SEQ_FLAG_EXT;
+					DELTA_LOG_DEBUG("%s: MPEG2_META_SEQ_FLAG_EXT\n", __func__);
+					header_found = 1;
+				}
+				break;
+
+			case GST_MPEG_VIDEO_PACKET_EXT_SEQUENCE_DISPLAY:
+				if (gst_mpeg_video_packet_parse_sequence_display_extension
+				    (&packet_data,
+					 (GstMpegVideoSequenceDisplayExt *)&(meta->seq.seq_d))) {
+					meta->flags |= V4L2_CTRL_MPEG2_FLAG_SEQ;
+					meta->seq.flags |= MPEG2_META_SEQ_FLAG_DISPLAY_EXT;
+					DELTA_LOG_DEBUG("%s: MPEG2_META_SEQ_FLAG_DISPLAY_EXT\n", __func__);
+					header_found = 1;
+				}
+				break;
+
+			case GST_MPEG_VIDEO_PACKET_EXT_QUANT_MATRIX:
+				if (gst_mpeg_video_packet_parse_quant_matrix_extension
+				    (&packet_data,
+					 (GstMpegVideoQuantMatrixExt *)&(meta->seq.qua_m))) {
+					meta->flags |= V4L2_CTRL_MPEG2_FLAG_SEQ;
+					meta->seq.flags |= MPEG2_META_SEQ_FLAG_MATRIX_EXT;
+					DELTA_LOG_DEBUG("%s: MPEG2_META_SEQ_FLAG_MATRIX_EXT\n", __func__);
+					header_found = 1;
+				}
+				break;
+
+			case GST_MPEG_VIDEO_PACKET_EXT_SEQUENCE_SCALABLE:
+				if (gst_mpeg_video_packet_parse_sequence_scalable_extension
+				    (&packet_data,
+					 (GstMpegVideoSequenceScalableExt *)&(meta->seq.seq_s))) {
+					meta->flags |= V4L2_CTRL_MPEG2_FLAG_SEQ;
+					meta->seq.flags |= MPEG2_META_SEQ_FLAG_SCALABLE_EXT;
+					DELTA_LOG_DEBUG("%s: MPEG2_META_SEQ_FLAG_SCALABLE_EXT\n", __func__);
+					header_found = 1;
+				}
+				break;
+
+			case GST_MPEG_VIDEO_PACKET_EXT_PICTURE:
+				if (gst_mpeg_video_packet_parse_picture_extension
+				    (&packet_data,
+					 (GstMpegVideoPictureExt *)&(meta->pic[slice_index].pic_e))) {
+					meta->flags |= V4L2_CTRL_MPEG2_FLAG_PIC;
+					meta->pic[slice_index].flags |= MPEG2_META_PIC_FLAG_EXT;
+					DELTA_LOG_DEBUG("%s: MPEG2_META_PIC_FLAG_EXT top_field_first=%d\n",
+									__func__, meta->pic[slice_index].pic_e.top_field_first);
+					header_found = 1;
+				}
+				break;
+
+			default:
+				break;
+			}
+			break;
+
+		case GST_MPEG_VIDEO_PACKET_SEQUENCE_END:
+			DELTA_LOG_DEBUG("%s: end of packet sequence\n", __func__);
+			break;
+
+		case GST_MPEG_VIDEO_PACKET_GOP:
+			if (gst_mpeg_video_packet_parse_gop
+			    (&packet_data,
+				 (GstMpegVideoGop *)&(meta->pic[slice_index].g_o_p))) {
+				meta->flags |= V4L2_CTRL_MPEG2_FLAG_PIC;
+				meta->pic[slice_index].flags |= MPEG2_META_PIC_FLAG_GOP;
+				DELTA_LOG_DEBUG("%s: MPEG2_META_PIC_FLAG_GOP\n", __func__);
+				header_found = 1;
+			}
+			break;
+
+		default:
+			DELTA_LOG_DEBUG("%s: unknown/unsupported header %02x\n",
+							__func__, packet_data.type);
+			break;
+		}
+	}
+
+	DELTA_LOG_DEBUG("< %s\n", __func__);
+	return header_found;
+}
+
+const struct delta_metadata mpeg2meta = {
+	.name = "mpeg2",
+	.stream_format = V4L2_PIX_FMT_MPEG2,
+	.meta_size = sizeof(struct v4l2_ctrl_mpeg2_meta),
+	.decode_header = delta_mpeg2_decode_header,
+};
+
+const struct delta_metadata mpeg1meta = {
+	.name = "mpeg1",
+	.stream_format = V4L2_PIX_FMT_MPEG1,
+	.meta_size = sizeof(struct v4l2_ctrl_mpeg2_meta),
+	.decode_header = delta_mpeg2_decode_header,
+};
diff --git a/lib/libv4l-delta/libv4l-delta.c b/lib/libv4l-delta/libv4l-delta.c
index aa33e94..97e709a 100644
--- a/lib/libv4l-delta/libv4l-delta.c
+++ b/lib/libv4l-delta/libv4l-delta.c
@@ -50,8 +50,12 @@
 	((type == V4L2_BUF_TYPE_VIDEO_CAPTURE) ? "CAPTURE" : "?"))
 
 /* available metadata builders */
-const struct delta_metadata *delta_meta[] = {
+extern const struct delta_metadata mpeg2meta;
+extern const struct delta_metadata mpeg1meta;
 
+const struct delta_metadata *delta_meta[] = {
+	&mpeg2meta,
+	&mpeg1meta,
 };
 
 static void *delta_plugin_init(int fd)
-- 
1.9.1

