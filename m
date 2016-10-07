Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:1402 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S936586AbcJGRA2 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 7 Oct 2016 13:00:28 -0400
From: Hugues Fruchet <hugues.fruchet@st.com>
To: <linux-media@vger.kernel.org>, Hans Verkuil <hverkuil@xs4all.nl>
CC: <kernel@stlinux.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Hugues Fruchet <hugues.fruchet@st.com>,
        Jean-Christophe Trotin <jean-christophe.trotin@st.com>
Subject: [PATCH v1 2/3] libv4l-delta: add GStreamer mpeg codecparser
Date: Fri, 7 Oct 2016 19:00:17 +0200
Message-ID: <1475859618-829-3-git-send-email-hugues.fruchet@st.com>
In-Reply-To: <1475859618-829-1-git-send-email-hugues.fruchet@st.com>
References: <1475859618-829-1-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Tiphaine Inguere <tifaine.inguere@st.com>

The mpeg related files from gst-plugins-bad codecparser are added to
the libv4l-delta plugin.
This is a proof of concept which aims to validate the
interoperability of a standard mpeg parser with ST DELTA video decoder.
An implementation based on a common codecparser library shared
between GStreamer and V4L2 would be a far better implementation.

Change-Id: I7722c64e80101d833bbf9c973df846f60c3b8ee7
signed-off-by: Tiphaine Inguere <tifaine.inguere@st.com>
Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
---
 configure.ac                                       |    1 +
 lib/libv4l-delta/Makefile.am                       |   12 +-
 lib/libv4l-delta/codecparsers/Makefile.am          |   40 +
 lib/libv4l-delta/codecparsers/gstmpegvideoparser.c | 1304 ++++++++++++++++++++
 lib/libv4l-delta/codecparsers/gstmpegvideoparser.h |  560 +++++++++
 lib/libv4l-delta/codecparsers/parserutils.c        |   57 +
 lib/libv4l-delta/codecparsers/parserutils.h        |  108 ++
 7 files changed, 2081 insertions(+), 1 deletion(-)
 create mode 100644 lib/libv4l-delta/codecparsers/Makefile.am
 create mode 100644 lib/libv4l-delta/codecparsers/gstmpegvideoparser.c
 create mode 100644 lib/libv4l-delta/codecparsers/gstmpegvideoparser.h
 create mode 100644 lib/libv4l-delta/codecparsers/parserutils.c
 create mode 100644 lib/libv4l-delta/codecparsers/parserutils.h

diff --git a/configure.ac b/configure.ac
index bb656fd..c1c290a 100644
--- a/configure.ac
+++ b/configure.ac
@@ -19,6 +19,7 @@ AC_CONFIG_FILES([Makefile
 	lib/libv4l-mplane/Makefile
 	lib/libv4l-hva/Makefile
 	lib/libv4l-delta/Makefile
+	lib/libv4l-delta/codecparsers/Makefile
 
 	utils/Makefile
 	utils/libv4l2util/Makefile
diff --git a/lib/libv4l-delta/Makefile.am b/lib/libv4l-delta/Makefile.am
index 0ec1dd7..fa401b6 100644
--- a/lib/libv4l-delta/Makefile.am
+++ b/lib/libv4l-delta/Makefile.am
@@ -2,8 +2,18 @@ if WITH_V4L_PLUGINS
 libv4l2plugin_LTLIBRARIES = libv4l-delta.la
 endif
 
+SUBDIRS = codecparsers
+
 libv4l_delta_la_SOURCES = libv4l-delta.c libv4l-delta.h
 
 libv4l_delta_la_CPPFLAGS = $(CFLAG_VISIBILITY)
+libv4l_delta_la_CFLAGS =	$(GST_CFLAGS)	-DGST_USE_UNSTABLE_API
 libv4l_delta_la_LDFLAGS = -avoid-version -module -shared -export-dynamic -lpthread
-libv4l_delta_la_LIBADD = ../libv4l2/libv4l2.la
+libv4l_delta_la_LDFLAGS +=	$(GST_LIB_LDFLAGS)
+
+libv4l_delta_la_LIBADD = ../libv4l2/libv4l2.la	\
+	$(GLIB_LIBS)				\
+	$(GST_BASE_LIBS) \
+	$(GST_LIBS)				\
+	codecparsers/libgstcodecparsers.la	\
+	$(NULL)
diff --git a/lib/libv4l-delta/codecparsers/Makefile.am b/lib/libv4l-delta/codecparsers/Makefile.am
new file mode 100644
index 0000000..bd77573
--- /dev/null
+++ b/lib/libv4l-delta/codecparsers/Makefile.am
@@ -0,0 +1,40 @@
+lib_LTLIBRARIES = libgstcodecparsers.la
+
+libgstcodecparsers_la_SOURCES = \
+	gstmpegvideoparser.c \
+	parserutils.c \
+	gstmpegvideoparser.h \
+	$(NULL)
+
+noinst_HEADERS = parserutils.h
+
+libgstcodecparsers_la_CFLAGS = \
+	$(GST_BASE_CFLAGS) \
+	-DGST_USE_UNSTABLE_API \
+	$(GST_CFLAGS)
+
+libgstcodecparsers_la_LIBADD = \
+	$(GST_BASE_LIBS) \
+	$(GST_LIBS) \
+	$(LIBM)
+
+libgstcodecparsers_la_LDFLAGS = \
+	$(GST_LIB_LDFLAGS) \
+	$(GST_ALL_LDFLAGS) \
+	$(GST_LT_LDFLAGS)
+
+Android.mk:  $(BUILT_SOURCES) Makefile.am
+	androgenizer -:PROJECT libgstcodecparsers -:STATIC libgstcodecparsers-@GST_API_VERSION@ \
+	 -:TAGS eng debug \
+         -:REL_TOP $(top_srcdir) -:ABS_TOP $(abs_top_srcdir) \
+	 -:SOURCES $(libgstcodecparsers_@GST_API_VERSION@_la_SOURCES) \
+         $(built_sources) \
+	 -:CFLAGS $(DEFS) $(libgstcodecparsers_@GST_API_VERSION@_la_CFLAGS) \
+	 -:LDFLAGS $(libgstcodecparsers_@GST_API_VERSION@_la_LDFLAGS) \
+	           $(libgstcodecparsers@GST_API_VERSION@_la_LIBADD) \
+	           -ldl \
+	 -:HEADER_TARGET gstreamer-@GST_API_VERSION@/gst/codecparsers \
+	 -:HEADERS $(libgstcodecparsersinclude_HEADERS) \
+         $(built_headers) \
+	 -:PASSTHROUGH LOCAL_ARM_MODE:=arm \
+	> $@
diff --git a/lib/libv4l-delta/codecparsers/gstmpegvideoparser.c b/lib/libv4l-delta/codecparsers/gstmpegvideoparser.c
new file mode 100644
index 0000000..cd0533e
--- /dev/null
+++ b/lib/libv4l-delta/codecparsers/gstmpegvideoparser.c
@@ -0,0 +1,1304 @@
+/* Gstreamer
+ * Copyright (C) <2011> Intel Corporation
+ * Copyright (C) <2011> Collabora Ltd.
+ * Copyright (C) <2011> Thibault Saunier <thibault.saunier@collabora.com>
+ *
+ * From bad/sys/vdpau/mpeg/mpegutil.c:
+ *   Copyright (C) <2007> Jan Schmidt <thaytan@mad.scientist.com>
+ *   Copyright (C) <2009> Carl-Anton Ingmarsson <ca.ingmarsson@gmail.com>
+ *
+ * This library is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU Library General Public
+ * License as published by the Free Software Foundation; either
+ * version 2 of the License, or (at your option) any later version.
+ *
+ * This library is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * Library General Public License for more details.
+ *
+ * You should have received a copy of the GNU Library General Public
+ * License along with this library; if not, write to the
+ * Free Software Foundation, Inc., 51 Franklin St, Fifth Floor,
+ * Boston, MA 02110-1301, USA.
+ */
+
+/**
+ * SECTION:gstmpegvideoparser
+ * @short_description: Convenience library for mpeg1 and 2 video
+ * bitstream parsing.
+ *
+ * <refsect2>
+ * <para>
+ * Provides useful functions for mpeg videos bitstream parsing.
+ * </para>
+ * </refsect2>
+ */
+
+#ifdef HAVE_CONFIG_H
+#  include "config.h"
+#endif
+
+#include "gstmpegvideoparser.h"
+#include "parserutils.h"
+
+#include <string.h>
+#include <gst/base/gstbitreader.h>
+#include <gst/base/gstbytereader.h>
+
+#define MARKER_BIT 0x1
+
+/* default intra quant matrix, in zig-zag order */
+static const guint8 default_intra_quantizer_matrix[64] = {
+  8,
+  16, 16,
+  19, 16, 19,
+  22, 22, 22, 22,
+  22, 22, 26, 24, 26,
+  27, 27, 27, 26, 26, 26,
+  26, 27, 27, 27, 29, 29, 29,
+  34, 34, 34, 29, 29, 29, 27, 27,
+  29, 29, 32, 32, 34, 34, 37,
+  38, 37, 35, 35, 34, 35,
+  38, 38, 40, 40, 40,
+  48, 48, 46, 46,
+  56, 56, 58,
+  69, 69,
+  83
+};
+
+static const guint8 mpeg_zigzag_8x8[64] = {
+  0, 1, 8, 16, 9, 2, 3, 10,
+  17, 24, 32, 25, 18, 11, 4, 5,
+  12, 19, 26, 33, 40, 48, 41, 34,
+  27, 20, 13, 6, 7, 14, 21, 28,
+  35, 42, 49, 56, 57, 50, 43, 36,
+  29, 22, 15, 23, 30, 37, 44, 51,
+  58, 59, 52, 45, 38, 31, 39, 46,
+  53, 60, 61, 54, 47, 55, 62, 63
+};
+
+enum
+{
+  GST_MPEG_VIDEO_MACROBLOCK_ESCAPE = G_MAXUINT,
+};
+
+/* Table B-1: Variable length codes for macroblock_address_increment */
+static const VLCTable mpeg2_mbaddr_vlc_table[] = {
+  {1, 0x01, 1},
+  {2, 0x03, 3},
+  {3, 0x02, 3},
+  {4, 0x03, 4},
+  {5, 0x02, 4},
+  {6, 0x03, 5},
+  {7, 0x02, 5},
+  {8, 0x07, 7},
+  {9, 0x06, 7},
+  {10, 0x0b, 8},
+  {11, 0x0a, 8},
+  {12, 0x09, 8},
+  {13, 0x08, 8},
+  {14, 0x07, 8},
+  {15, 0x06, 8},
+  {16, 0x17, 10},
+  {17, 0x16, 10},
+  {18, 0x15, 10},
+  {19, 0x14, 10},
+  {20, 0x13, 10},
+  {21, 0x12, 10},
+  {22, 0x23, 11},
+  {23, 0x22, 11},
+  {24, 0x21, 11},
+  {25, 0x20, 11},
+  {26, 0x1f, 11},
+  {27, 0x1e, 11},
+  {28, 0x1d, 11},
+  {29, 0x1c, 11},
+  {30, 0x1b, 11},
+  {31, 0x1a, 11},
+  {32, 0x19, 11},
+  {33, 0x18, 11},
+  {GST_MPEG_VIDEO_MACROBLOCK_ESCAPE, 0x08, 11}
+};
+
+GST_DEBUG_CATEGORY (mpegvideo_parser_debug);
+#define GST_CAT_DEFAULT mpegvideo_parser_debug
+
+#define INITIALIZE_DEBUG_CATEGORY \
+  GST_DEBUG_CATEGORY_INIT (mpegvideo_parser_debug, "codecparsers_mpegvideo", \
+      0, "Mpegvideo parser library");
+
+
+/* Set the Pixel Aspect Ratio in our hdr from a ASR code in the data */
+static void
+set_par_from_asr_mpeg1 (GstMpegVideoSequenceHdr * seqhdr, guint8 asr_code)
+{
+  int ratios[16][2] = {
+    {0, 0},                     /* 0, Invalid */
+    {1, 1},                     /* 1, 1.0 */
+    {10000, 6735},              /* 2, 0.6735 */
+    {64, 45},                   /* 3, 0.7031 16:9 625 line */
+    {10000, 7615},              /* 4, 0.7615 */
+    {10000, 8055},              /* 5, 0.8055 */
+    {32, 27},                   /* 6, 0.8437 */
+    {10000, 8935},              /* 7, 0.8935 */
+    {10000, 9375},              /* 8, 0.9375 */
+    {10000, 9815},              /* 9, 0.9815 */
+    {10000, 10255},             /* 10, 1.0255 */
+    {10000, 10695},             /* 11, 1.0695 */
+    {8, 9},                     /* 12, 1.125 */
+    {10000, 11575},             /* 13, 1.1575 */
+    {10000, 12015},             /* 14, 1.2015 */
+    {0, 0},                     /* 15, invalid */
+  };
+  asr_code &= 0xf;
+
+  seqhdr->par_w = ratios[asr_code][0];
+  seqhdr->par_h = ratios[asr_code][1];
+}
+
+static void
+set_fps_from_code (GstMpegVideoSequenceHdr * seqhdr, guint8 fps_code)
+{
+  const gint framerates[][2] = {
+    {30, 1}, {24000, 1001}, {24, 1}, {25, 1},
+    {30000, 1001}, {30, 1}, {50, 1}, {60000, 1001},
+    {60, 1}, {30, 1}
+  };
+
+  if (fps_code && fps_code < 10) {
+    seqhdr->fps_n = framerates[fps_code][0];
+    seqhdr->fps_d = framerates[fps_code][1];
+  } else {
+    GST_DEBUG ("unknown/invalid frame_rate_code %d", fps_code);
+    /* Force a valid framerate */
+    /* FIXME or should this be kept unknown ?? */
+    seqhdr->fps_n = 30000;
+    seqhdr->fps_d = 1001;
+  }
+}
+
+/* @size and @offset are wrt current reader position */
+static inline gint
+scan_for_start_codes (const GstByteReader * reader, guint offset, guint size)
+{
+  const guint8 *data;
+  guint i = 0;
+
+  g_assert ((guint64) offset + size <= reader->size - reader->byte);
+
+  /* we can't find the pattern with less than 4 bytes */
+  if (G_UNLIKELY (size < 4))
+    return -1;
+
+  data = reader->data + reader->byte + offset;
+
+  while (i <= (size - 4)) {
+    if (data[i + 2] > 1) {
+      i += 3;
+    } else if (data[i + 1]) {
+      i += 2;
+    } else if (data[i] || data[i + 2] != 1) {
+      i++;
+    } else {
+      break;
+    }
+  }
+
+  if (i <= (size - 4))
+    return offset + i;
+
+  /* nothing found */
+  return -1;
+}
+
+/****** API *******/
+
+/*little function to get the extension code from a sequence extension header*/
+unsigned char get_extension_code(const GstMpegVideoPacket * packet)
+{
+  GstBitReader br;
+  unsigned char  ExtensionCode;
+
+  gst_bit_reader_init (&br, &packet->data[packet->offset], packet->size);
+  READ_UINT8 (&br,  ExtensionCode, 4);
+
+  return ExtensionCode;
+
+  /* ERRORS */
+failed:
+  {
+    GST_WARNING ("Failed to get extension code");
+    return 0;
+  }
+}
+
+
+/**
+ * gst_mpeg_video_parse:
+ * @packet: a #GstMpegVideoPacket to fill with the data and offset of the
+ *     next packet found
+ * @data: The data to parse
+ * @size: The size of @data
+ * @offset: The offset from which to start parsing
+ *
+ * Parses the MPEG 1/2 video bitstream contained in @data, and returns the
+ * offset, and if known also the size, in @packet. This function will scan
+ * the data to find the next packet if needed.
+ *
+ * Returns: TRUE if a packet start code was found, otherwise FALSE.
+ */
+gboolean
+gst_mpeg_video_parse (GstMpegVideoPacket * packet,
+    const guint8 * data, gsize size, guint offset)
+{
+  gint off;
+  GstByteReader br;
+
+  INITIALIZE_DEBUG_CATEGORY;
+
+  if (size <= offset) {
+    GST_DEBUG ("Can't parse from offset %d, buffer is to small", offset);
+    return FALSE;
+  }
+
+  size -= offset;
+  gst_byte_reader_init (&br, &data[offset], size);
+
+  off = scan_for_start_codes (&br, 0, size);
+
+  if (off < 0) {
+    GST_DEBUG ("No start code prefix in this buffer");
+    return FALSE;
+  }
+
+  if (gst_byte_reader_skip (&br, off + 3) == FALSE)
+    goto failed;
+
+  if (gst_byte_reader_get_uint8 (&br, &packet->type) == FALSE)
+    goto failed;
+
+  packet->data = data;
+  packet->offset = offset + off + 4;
+  packet->size = -1;
+
+  /* try to find end of packet */
+  size -= off + 4;
+  off = scan_for_start_codes (&br, 0, size);
+
+  if (off > 0)
+    packet->size = off;
+
+  return TRUE;
+
+failed:
+  {
+    GST_DEBUG ("Failed to parse");
+    return FALSE;
+  }
+}
+
+/**
+ * gst_mpeg_video_packet_parse_sequence_header:
+ * @packet: The #GstMpegVideoPacket that carries the data
+ * @seqhdr: (out): The #GstMpegVideoSequenceHdr structure to fill
+ *
+ * Parses the @seqhdr MPEG Video Sequence Header structure members
+ * from video @packet
+ *
+ * Returns: %TRUE if the seqhdr could be parsed correctly, %FALSE otherwize.
+ *
+ * Since: 1.2
+ */
+gboolean
+gst_mpeg_video_packet_parse_sequence_header (const GstMpegVideoPacket * packet,
+    GstMpegVideoSequenceHdr * seqhdr)
+{
+  GstBitReader br;
+  guint8 bits;
+
+  g_return_val_if_fail (seqhdr != NULL, FALSE);
+
+  if (packet->size < 8)
+    return FALSE;
+
+  INITIALIZE_DEBUG_CATEGORY;
+
+  gst_bit_reader_init (&br, &packet->data[packet->offset], packet->size);
+
+  /* Setting the height/width codes */
+  READ_UINT16 (&br, seqhdr->width, 12);
+  READ_UINT16 (&br, seqhdr->height, 12);
+
+  READ_UINT8 (&br, seqhdr->aspect_ratio_info, 4);
+  /* Interpret PAR according to MPEG-1. Needs to be reinterpreted
+   * later, if a sequence_display extension is seen */
+  set_par_from_asr_mpeg1 (seqhdr, seqhdr->aspect_ratio_info);
+
+  READ_UINT8 (&br, seqhdr->frame_rate_code, 4);
+  set_fps_from_code (seqhdr, seqhdr->frame_rate_code);
+
+  READ_UINT32 (&br, seqhdr->bitrate_value, 18);
+  if (seqhdr->bitrate_value == 0x3ffff) {
+    /* VBR stream */
+    seqhdr->bitrate = 0;
+  } else {
+    /* Value in header is in units of 400 bps */
+    seqhdr->bitrate = seqhdr->bitrate_value * 400;
+  }
+
+  READ_UINT8 (&br, bits, 1);
+  if (bits != MARKER_BIT)
+    goto failed;
+
+  /* VBV buffer size */
+  READ_UINT16 (&br, seqhdr->vbv_buffer_size_value, 10);
+
+  /* constrained_parameters_flag */
+  READ_UINT8 (&br, seqhdr->constrained_parameters_flag, 1);
+
+  /* load_intra_quantiser_matrix */
+  READ_UINT8 (&br, seqhdr->load_intra_flag, 1);
+  if (seqhdr->load_intra_flag) {
+    gint i;
+    for (i = 0; i < 64; i++)
+      READ_UINT8 (&br, seqhdr->intra_quantizer_matrix[i], 8);
+  } else
+    memcpy (seqhdr->intra_quantizer_matrix, default_intra_quantizer_matrix, 64);
+
+  /* non intra quantizer matrix */
+  READ_UINT8 (&br, seqhdr->load_non_intra_flag, 1);
+  if (seqhdr->load_non_intra_flag) {
+    gint i;
+    for (i = 0; i < 64; i++)
+      READ_UINT8 (&br, seqhdr->non_intra_quantizer_matrix[i], 8);
+  } else
+    memset (seqhdr->non_intra_quantizer_matrix, 16, 64);
+
+  /* dump some info */
+  GST_LOG ("width x height: %d x %d", seqhdr->width, seqhdr->height);
+  GST_LOG ("fps: %d/%d", seqhdr->fps_n, seqhdr->fps_d);
+  GST_LOG ("par: %d/%d", seqhdr->par_w, seqhdr->par_h);
+  GST_LOG ("bitrate: %d", seqhdr->bitrate);
+
+  return TRUE;
+
+  /* ERRORS */
+failed:
+  {
+    GST_WARNING ("Failed to parse sequence header");
+    /* clear out stuff */
+    memset (seqhdr, 0, sizeof (*seqhdr));
+    return FALSE;
+  }
+}
+
+/**
+ * gst_mpeg_video_packet_parse_sequence_extension:
+ * @packet: The #GstMpegVideoPacket that carries the data
+ * @seqext: (out): The #GstMpegVideoSequenceExt structure to fill
+ *
+ * Parses the @seqext MPEG Video Sequence Extension structure members
+ * from video @packet
+ *
+ * Returns: %TRUE if the seqext could be parsed correctly, %FALSE otherwize.
+ *
+ * Since: 1.2
+ */
+gboolean
+gst_mpeg_video_packet_parse_sequence_extension (const GstMpegVideoPacket *
+    packet, GstMpegVideoSequenceExt * seqext)
+{
+  GstBitReader br;
+
+  g_return_val_if_fail (seqext != NULL, FALSE);
+
+  if (packet->size < 6) {
+    GST_DEBUG ("not enough bytes to parse the extension");
+    return FALSE;
+  }
+
+  gst_bit_reader_init (&br, &packet->data[packet->offset], packet->size);
+
+  if (gst_bit_reader_get_bits_uint8_unchecked (&br, 4) !=
+      GST_MPEG_VIDEO_PACKET_EXT_SEQUENCE) {
+    GST_DEBUG ("Not parsing a sequence extension");
+    return FALSE;
+  }
+
+  /* skip profile and level escape bit */
+  gst_bit_reader_skip_unchecked (&br, 1);
+
+  seqext->profile_and_level = gst_bit_reader_get_bits_uint8_unchecked (&br, 7);
+
+  /* progressive */
+  seqext->progressive = gst_bit_reader_get_bits_uint8_unchecked (&br, 1);
+
+  /* chroma format */
+  seqext->chroma_format = gst_bit_reader_get_bits_uint8_unchecked (&br, 2);
+
+  /* resolution extension */
+  seqext->horiz_size_ext = gst_bit_reader_get_bits_uint8_unchecked (&br, 2);
+  seqext->vert_size_ext = gst_bit_reader_get_bits_uint8_unchecked (&br, 2);
+
+  seqext->bitrate_ext = gst_bit_reader_get_bits_uint16_unchecked (&br, 12);
+
+  /* skip marker bits */
+  gst_bit_reader_skip_unchecked (&br, 1);
+
+  seqext->vbv_buffer_size_extension =
+      gst_bit_reader_get_bits_uint8_unchecked (&br, 8);
+  seqext->low_delay = gst_bit_reader_get_bits_uint8_unchecked (&br, 1);
+
+  /* framerate extension */
+  seqext->fps_n_ext = gst_bit_reader_get_bits_uint8_unchecked (&br, 2);
+  seqext->fps_d_ext = gst_bit_reader_get_bits_uint8_unchecked (&br, 2);
+
+  return TRUE;
+}
+
+/**
+ * gst_mpeg_video_packet_parse_sequence_display_extension:
+ * @packet: The #GstMpegVideoPacket that carries the data
+ * @seqdisplayext: (out): The #GstMpegVideoSequenceDisplayExt
+ *   structure to fill
+ *
+ * Parses the @seqext MPEG Video Sequence Display Extension structure
+ * members from video @packet
+ *
+ * Returns: %TRUE if the seqext could be parsed correctly, %FALSE otherwize.
+ *
+ * Since: 1.2
+ */
+gboolean
+gst_mpeg_video_packet_parse_sequence_display_extension (const GstMpegVideoPacket
+    * packet, GstMpegVideoSequenceDisplayExt * seqdisplayext)
+{
+  GstBitReader br;
+
+  g_return_val_if_fail (seqdisplayext != NULL, FALSE);
+
+  if (packet->size < 5) {
+    GST_DEBUG ("not enough bytes to parse the extension");
+    return FALSE;
+  }
+
+  gst_bit_reader_init (&br, &packet->data[packet->offset], packet->size);
+
+  if (gst_bit_reader_get_bits_uint8_unchecked (&br, 4) !=
+      GST_MPEG_VIDEO_PACKET_EXT_SEQUENCE_DISPLAY) {
+    GST_DEBUG ("Not parsing a sequence display extension");
+    return FALSE;
+  }
+
+  seqdisplayext->video_format =
+      gst_bit_reader_get_bits_uint8_unchecked (&br, 3);
+  seqdisplayext->colour_description_flag =
+      gst_bit_reader_get_bits_uint8_unchecked (&br, 1);
+
+  if (seqdisplayext->colour_description_flag) {
+    seqdisplayext->colour_primaries =
+        gst_bit_reader_get_bits_uint8_unchecked (&br, 8);
+    seqdisplayext->transfer_characteristics =
+        gst_bit_reader_get_bits_uint8_unchecked (&br, 8);
+    seqdisplayext->matrix_coefficients =
+        gst_bit_reader_get_bits_uint8_unchecked (&br, 8);
+  }
+
+  if (gst_bit_reader_get_remaining (&br) < 29) {
+    GST_DEBUG ("Not enough remaining bytes to parse the extension");
+    return FALSE;
+  }
+
+  seqdisplayext->display_horizontal_size =
+      gst_bit_reader_get_bits_uint16_unchecked (&br, 14);
+  /* skip marker bit */
+  gst_bit_reader_skip_unchecked (&br, 1);
+  seqdisplayext->display_vertical_size =
+      gst_bit_reader_get_bits_uint16_unchecked (&br, 14);
+
+  return TRUE;
+}
+
+/**
+ * gst_mpeg_video_packet_parse_sequence_scalable_extension:
+ * @packet: The #GstMpegVideoPacket that carries the data
+ * @seqscaleext: (out): The #GstMpegVideoSequenceScalableExt structure to fill
+ *
+ * Parses the @seqscaleext MPEG Video Sequence Scalable Extension structure
+ * members from video @packet
+ *
+ * Returns: %TRUE if the seqext could be parsed correctly, %FALSE otherwize.
+ *
+ * Since: 1.2
+ */
+gboolean
+    gst_mpeg_video_packet_parse_sequence_scalable_extension
+    (const GstMpegVideoPacket * packet,
+    GstMpegVideoSequenceScalableExt * seqscaleext) {
+  GstBitReader br;
+
+  g_return_val_if_fail (seqscaleext != NULL, FALSE);
+
+  if (packet->size < 2) {
+    GST_DEBUG ("not enough bytes to parse the extension");
+    return FALSE;
+  }
+
+  gst_bit_reader_init (&br, &packet->data[packet->offset], packet->size);
+
+  if (gst_bit_reader_get_bits_uint8_unchecked (&br, 4) !=
+      GST_MPEG_VIDEO_PACKET_EXT_SEQUENCE_SCALABLE) {
+    GST_DEBUG ("Not parsing a sequence scalable extension");
+    return FALSE;
+  }
+
+  READ_UINT8 (&br, seqscaleext->scalable_mode, 2);
+  READ_UINT8 (&br, seqscaleext->layer_id, 4);
+
+  if (seqscaleext->scalable_mode == GST_MPEG_VIDEO_SEQ_SCALABLE_MODE_SPATIAL) {
+    READ_UINT16 (&br, seqscaleext->lower_layer_prediction_horizontal_size, 14);
+
+    SKIP (&br, 1);
+
+    READ_UINT16 (&br, seqscaleext->lower_layer_prediction_vertical_size, 14);
+
+    READ_UINT8 (&br, seqscaleext->horizontal_subsampling_factor_m, 5);
+    READ_UINT8 (&br, seqscaleext->horizontal_subsampling_factor_n, 5);
+    READ_UINT8 (&br, seqscaleext->vertical_subsampling_factor_m, 5);
+    READ_UINT8 (&br, seqscaleext->vertical_subsampling_factor_n, 5);
+  }
+
+  if (seqscaleext->scalable_mode == GST_MPEG_VIDEO_SEQ_SCALABLE_MODE_TEMPORAL) {
+    READ_UINT8 (&br, seqscaleext->picture_mux_enable, 1);
+    if (seqscaleext->picture_mux_enable)
+      READ_UINT8 (&br, seqscaleext->mux_to_progressive_sequence, 1);
+    READ_UINT8 (&br, seqscaleext->picture_mux_order, 3);
+    READ_UINT8 (&br, seqscaleext->picture_mux_factor, 3);
+  }
+
+  return TRUE;
+
+failed:
+  GST_WARNING ("error parsing \"Sequence Scalable Extension\"");
+  return FALSE;
+}
+
+gboolean
+gst_mpeg_video_finalise_mpeg2_sequence_header (GstMpegVideoSequenceHdr * seqhdr,
+    GstMpegVideoSequenceExt * seqext,
+    GstMpegVideoSequenceDisplayExt * displayext)
+{
+  guint32 w;
+  guint32 h;
+
+  if (seqext) {
+    seqhdr->fps_n = seqhdr->fps_n * (seqext->fps_n_ext + 1);
+    seqhdr->fps_d = seqhdr->fps_d * (seqext->fps_d_ext + 1);
+    /* Extend width and height to 14 bits by adding the extension bits */
+    seqhdr->width |= (seqext->horiz_size_ext << 12);
+    seqhdr->height |= (seqext->vert_size_ext << 12);
+    seqhdr->bitrate += (seqext->bitrate_ext << 18) * 400;
+  }
+
+  w = seqhdr->width;
+  h = seqhdr->height;
+  if (displayext) {
+    /* Use the display size for calculating PAR when display ext present.
+     * But we are handling this like what DVD players are doing. Which means,
+     * ignore the display extension values if they are greater than the width/height
+     * values provided by seqhdr and calculate the PAR based on the seqhdr values. */
+    if (displayext->display_horizontal_size < w)
+      w = displayext->display_horizontal_size;
+    if (displayext->display_vertical_size < h)
+      h = displayext->display_vertical_size;
+  }
+
+  /* Pixel_width = DAR_width * display_vertical_size */
+  /* Pixel_height = DAR_height * display_horizontal_size */
+  switch (seqhdr->aspect_ratio_info) {
+    case 0x01:                 /* Square pixels */
+      seqhdr->par_w = seqhdr->par_h = 1;
+      break;
+    case 0x02:                 /* 3:4 DAR = 4:3 pixels */
+      seqhdr->par_w = 4 * h;
+      seqhdr->par_h = 3 * w;
+      break;
+    case 0x03:                 /* 9:16 DAR */
+      seqhdr->par_w = 16 * h;
+      seqhdr->par_h = 9 * w;
+      break;
+    case 0x04:                 /* 1:2.21 DAR */
+      seqhdr->par_w = 221 * h;
+      seqhdr->par_h = 100 * w;
+      break;
+    default:
+      GST_DEBUG ("unknown/invalid aspect_ratio_information %d",
+          seqhdr->aspect_ratio_info);
+      break;
+  }
+
+  return TRUE;
+}
+
+/**
+ * gst_mpeg_video_packet_parse_quant_matrix_extension:
+ * @packet: The #GstMpegVideoPacket that carries the data
+ * @quant: (out): The #GstMpegVideoQuantMatrixExt structure to fill
+ *
+ * Parses the @quant MPEG Video Quantization Matrix Extension
+ * structure members from video @packet
+ *
+ * Returns: %TRUE if the quant matrix extension could be parsed correctly,
+ * %FALSE otherwize.
+ *
+ * Since: 1.2
+ */
+gboolean
+gst_mpeg_video_packet_parse_quant_matrix_extension (const GstMpegVideoPacket *
+    packet, GstMpegVideoQuantMatrixExt * quant)
+{
+  guint8 i;
+  GstBitReader br;
+
+  g_return_val_if_fail (quant != NULL, FALSE);
+
+  if (packet->size < 1) {
+    GST_DEBUG ("not enough bytes to parse the extension");
+    return FALSE;
+  }
+
+  gst_bit_reader_init (&br, &packet->data[packet->offset], packet->size);
+
+  if (gst_bit_reader_get_bits_uint8_unchecked (&br, 4) !=
+      GST_MPEG_VIDEO_PACKET_EXT_QUANT_MATRIX) {
+    GST_DEBUG ("Not parsing a quant matrix extension");
+    return FALSE;
+  }
+
+  READ_UINT8 (&br, quant->load_intra_quantiser_matrix, 1);
+  if (quant->load_intra_quantiser_matrix) {
+    for (i = 0; i < 64; i++) {
+      READ_UINT8 (&br, quant->intra_quantiser_matrix[i], 8);
+    }
+  }
+
+  READ_UINT8 (&br, quant->load_non_intra_quantiser_matrix, 1);
+  if (quant->load_non_intra_quantiser_matrix) {
+    for (i = 0; i < 64; i++) {
+      READ_UINT8 (&br, quant->non_intra_quantiser_matrix[i], 8);
+    }
+  }
+
+  READ_UINT8 (&br, quant->load_chroma_intra_quantiser_matrix, 1);
+  if (quant->load_chroma_intra_quantiser_matrix) {
+    for (i = 0; i < 64; i++) {
+      READ_UINT8 (&br, quant->chroma_intra_quantiser_matrix[i], 8);
+    }
+  }
+
+  READ_UINT8 (&br, quant->load_chroma_non_intra_quantiser_matrix, 1);
+  if (quant->load_chroma_non_intra_quantiser_matrix) {
+    for (i = 0; i < 64; i++) {
+      READ_UINT8 (&br, quant->chroma_non_intra_quantiser_matrix[i], 8);
+    }
+  }
+
+  return TRUE;
+
+failed:
+  GST_WARNING ("error parsing \"Quant Matrix Extension\"");
+  return FALSE;
+}
+
+/**
+ * gst_mpeg_video_packet_parse_picture_extension:
+ * @packet: The #GstMpegVideoPacket that carries the data
+ * @ext: (out): The #GstMpegVideoPictureExt structure to fill
+ *
+ * Parse the @ext MPEG Video Picture Extension structure members from
+ * video @packet
+ *
+ * Returns: %TRUE if the picture extension could be parsed correctly,
+ * %FALSE otherwize.
+ *
+ * Since: 1.2
+ */
+gboolean
+gst_mpeg_video_packet_parse_picture_extension (const GstMpegVideoPacket *
+    packet, GstMpegVideoPictureExt * ext)
+{
+  GstBitReader br;
+
+  g_return_val_if_fail (ext != NULL, FALSE);
+
+  if (packet->size < 5)
+    return FALSE;
+
+  gst_bit_reader_init (&br, &packet->data[packet->offset], packet->size);
+
+  if (gst_bit_reader_get_bits_uint8_unchecked (&br, 4) !=
+      GST_MPEG_VIDEO_PACKET_EXT_PICTURE) {
+    GST_DEBUG ("Extension is not a picture extension");
+    return FALSE;
+  }
+
+  /* f_code */
+  READ_UINT8 (&br, ext->f_code[0][0], 4);
+  READ_UINT8 (&br, ext->f_code[0][1], 4);
+  READ_UINT8 (&br, ext->f_code[1][0], 4);
+  READ_UINT8 (&br, ext->f_code[1][1], 4);
+
+  /* intra DC precision */
+  READ_UINT8 (&br, ext->intra_dc_precision, 2);
+
+  /* picture structure */
+  READ_UINT8 (&br, ext->picture_structure, 2);
+
+  /* top field first */
+  READ_UINT8 (&br, ext->top_field_first, 1);
+
+  /* frame pred frame dct */
+  READ_UINT8 (&br, ext->frame_pred_frame_dct, 1);
+
+  /* concealment motion vectors */
+  READ_UINT8 (&br, ext->concealment_motion_vectors, 1);
+
+  /* q scale type */
+  READ_UINT8 (&br, ext->q_scale_type, 1);
+
+  /* intra vlc format */
+  READ_UINT8 (&br, ext->intra_vlc_format, 1);
+
+  /* alternate scan */
+  READ_UINT8 (&br, ext->alternate_scan, 1);
+
+  /* repeat first field */
+  READ_UINT8 (&br, ext->repeat_first_field, 1);
+
+  /* chroma_420_type */
+  READ_UINT8 (&br, ext->chroma_420_type, 1);
+
+  /* progressive_frame */
+  READ_UINT8 (&br, ext->progressive_frame, 1);
+
+  /* composite display */
+  READ_UINT8 (&br, ext->composite_display, 1);
+
+  if (ext->composite_display) {
+
+    /* v axis */
+    READ_UINT8 (&br, ext->v_axis, 1);
+
+    /* field sequence */
+    READ_UINT8 (&br, ext->field_sequence, 3);
+
+    /* sub carrier */
+    READ_UINT8 (&br, ext->sub_carrier, 1);
+
+    /* burst amplitude */
+    READ_UINT8 (&br, ext->burst_amplitude, 7);
+
+    /* sub_carrier phase */
+    READ_UINT8 (&br, ext->sub_carrier_phase, 8);
+  }
+
+  return TRUE;
+
+failed:
+  GST_WARNING ("error parsing \"Picture Coding Extension\"");
+  return FALSE;
+
+}
+
+/**
+ * gst_mpeg_video_packet_parse_picture_header:
+ * @packet: The #GstMpegVideoPacket that carries the data
+ * @pichdr: (out): The #GstMpegVideoPictureHdr structure to fill
+ *
+ * Parsers the @pichdr MPEG Video Picture Header structure members
+ * from video @packet
+ *
+ * Returns: %TRUE if the picture sequence could be parsed correctly, %FALSE
+ * otherwize.
+ *
+ * Since: 1.2
+ */
+gboolean
+gst_mpeg_video_packet_parse_picture_header (const GstMpegVideoPacket * packet,
+    GstMpegVideoPictureHdr * hdr)
+{
+  GstBitReader br;
+
+  if (packet->size < 4)
+    goto failed;
+
+  gst_bit_reader_init (&br, &packet->data[packet->offset], packet->size);
+
+  /* temperal sequence number */
+  if (!gst_bit_reader_get_bits_uint16 (&br, &hdr->tsn, 10))
+    goto failed;
+
+
+  /* frame type */
+  if (!gst_bit_reader_get_bits_uint8 (&br, (guint8 *) & hdr->pic_type, 3))
+    goto failed;
+
+
+  if (hdr->pic_type == 0 || hdr->pic_type > 4)
+    goto bad_pic_type;          /* Corrupted picture packet */
+
+  /* VBV delay */
+  READ_UINT16 (&br, hdr->vbv_delay, 16);
+
+/*  if (!gst_bit_reader_skip (&br, 16))
+    goto failed;*/
+
+  if (hdr->pic_type == GST_MPEG_VIDEO_PICTURE_TYPE_P
+      || hdr->pic_type == GST_MPEG_VIDEO_PICTURE_TYPE_B) {
+
+    READ_UINT8 (&br, hdr->full_pel_forward_vector, 1);
+
+    READ_UINT8 (&br, hdr->f_f_code, 3);
+  } else {
+    hdr->full_pel_forward_vector = 0;
+    hdr->f_f_code = 0;
+  }
+
+  if (hdr->pic_type == GST_MPEG_VIDEO_PICTURE_TYPE_B) {
+    READ_UINT8 (&br, hdr->full_pel_backward_vector, 1);
+
+    READ_UINT8 (&br, hdr->b_f_code, 3);
+  } else {
+    hdr->full_pel_backward_vector = 0;
+    hdr->b_f_code = 0;
+  }
+
+  return TRUE;
+
+bad_pic_type:
+  {
+    GST_WARNING ("Unsupported picture type : %d", hdr->pic_type);
+    return FALSE;
+  }
+
+failed:
+  {
+    GST_WARNING ("Not enough data to parse picture header");
+    return FALSE;
+  }
+}
+
+/**
+ * gst_mpeg_video_packet_parse_gop:
+ * @packet: The #GstMpegVideoPacket that carries the data
+ * @gop: (out): The #GstMpegVideoGop structure to fill
+ *
+ * Parses the @gop MPEG Video Group of Picture structure members from
+ * video @packet
+ *
+ * Returns: %TRUE if the gop could be parsed correctly, %FALSE otherwize.
+ *
+ * Since: 1.2
+ */
+gboolean
+gst_mpeg_video_packet_parse_gop (const GstMpegVideoPacket * packet,
+    GstMpegVideoGop * gop)
+{
+  GstBitReader br;
+
+  g_return_val_if_fail (gop != NULL, FALSE);
+
+  if (packet->size < 4)
+    return FALSE;
+
+  gst_bit_reader_init (&br, &packet->data[packet->offset], packet->size);
+
+  READ_UINT8 (&br, gop->drop_frame_flag, 1);
+
+  READ_UINT8 (&br, gop->hour, 5);
+
+  READ_UINT8 (&br, gop->minute, 6);
+
+  /* skip unused bit */
+  if (!gst_bit_reader_skip (&br, 1))
+    return FALSE;
+
+  READ_UINT8 (&br, gop->second, 6);
+
+  READ_UINT8 (&br, gop->frame, 6);
+
+  READ_UINT8 (&br, gop->closed_gop, 1);
+
+  READ_UINT8 (&br, gop->broken_link, 1);
+
+  return TRUE;
+
+failed:
+  GST_WARNING ("error parsing \"GOP\"");
+  return FALSE;
+}
+
+/**
+ * gst_mpeg_video_packet_parse_slice_header:
+ * @packet: The #GstMpegVideoPacket that carries the data
+ * @slice_hdr: (out): The #GstMpegVideoSliceHdr structure to fill
+ * @seqhdr: The #GstMpegVideoSequenceHdr header
+ * @seqscaleext: The #GstMpegVideoSequenceScalableExt header
+ *
+ * Parses the @GstMpegVideoSliceHdr  structure members from @data
+ *
+ * Returns: %TRUE if the slice could be parsed correctly, %FALSE otherwize.
+ *
+ * Since: 1.2
+ */
+gboolean
+gst_mpeg_video_packet_parse_slice_header (const GstMpegVideoPacket * packet,
+    GstMpegVideoSliceHdr * slice_hdr, GstMpegVideoSequenceHdr * seqhdr,
+    GstMpegVideoSequenceScalableExt * seqscaleext)
+{
+  GstBitReader br;
+  guint height;
+  guint mb_inc;
+  guint8 bits, extra_bits;
+  guint8 vertical_position, vertical_position_extension = 0;
+
+  g_return_val_if_fail (seqhdr != NULL, FALSE);
+
+  if (packet->size < 1)
+    return FALSE;
+
+  gst_bit_reader_init (&br, &packet->data[packet->offset], packet->size);
+
+  if (packet->type < GST_MPEG_VIDEO_PACKET_SLICE_MIN ||
+      packet->type > GST_MPEG_VIDEO_PACKET_SLICE_MAX) {
+    GST_DEBUG ("Not parsing a slice");
+    return FALSE;
+  }
+  vertical_position = packet->type - GST_MPEG_VIDEO_PACKET_SLICE_MIN;
+
+  height = seqhdr->height;
+  if (height > 2800)
+    READ_UINT8 (&br, vertical_position_extension, 3);
+
+  if (seqscaleext)
+    if (seqscaleext->scalable_mode ==
+        GST_MPEG_VIDEO_SEQ_SCALABLE_MODE_DATA_PARTITIONING)
+      READ_UINT8 (&br, slice_hdr->priority_breakpoint, 7);
+
+  READ_UINT8 (&br, slice_hdr->quantiser_scale_code, 5);
+
+  READ_UINT8 (&br, extra_bits, 1);
+  if (!extra_bits)
+    slice_hdr->intra_slice = 0;
+  else {
+    READ_UINT8 (&br, slice_hdr->intra_slice, 1);
+    SKIP (&br, 1);
+    READ_UINT8 (&br, slice_hdr->slice_picture_id, 6);
+
+    READ_UINT8 (&br, bits, 1);
+    while (bits) {
+      READ_UINT8 (&br, extra_bits, 8);
+      READ_UINT8 (&br, bits, 1);
+    }
+  }
+
+  slice_hdr->header_size = gst_bit_reader_get_pos (&br);
+
+  if (height > 2800)
+    slice_hdr->mb_row = (vertical_position_extension << 7) + vertical_position;
+  else
+    slice_hdr->mb_row = vertical_position;
+
+  slice_hdr->mb_column = -1;
+  do {
+    if (!decode_vlc (&br, &mb_inc, mpeg2_mbaddr_vlc_table,
+            G_N_ELEMENTS (mpeg2_mbaddr_vlc_table))) {
+      GST_WARNING ("failed to decode first macroblock_address_increment");
+      goto failed;
+    }
+    slice_hdr->mb_column +=
+        mb_inc == GST_MPEG_VIDEO_MACROBLOCK_ESCAPE ? 33 : mb_inc;
+  } while (mb_inc == GST_MPEG_VIDEO_MACROBLOCK_ESCAPE);
+
+  return TRUE;
+
+failed:
+  GST_WARNING ("error parsing \"Slice\"");
+  return FALSE;
+}
+
+/**
+ * gst_mpeg_video_quant_matrix_get_raster_from_zigzag:
+ * @out_quant: (out): The resulting quantization matrix
+ * @quant: The source quantization matrix
+ *
+ * Converts quantization matrix @quant from zigzag scan order to
+ * raster scan order and store the resulting factors into @out_quant.
+ *
+ * Note: it is an error to pass the same table in both @quant and
+ * @out_quant arguments.
+ *
+ * Since: 1.2
+ */
+void
+gst_mpeg_video_quant_matrix_get_raster_from_zigzag (guint8 out_quant[64],
+    const guint8 quant[64])
+{
+  guint i;
+
+  g_return_if_fail (out_quant != quant);
+
+  for (i = 0; i < 64; i++)
+    out_quant[mpeg_zigzag_8x8[i]] = quant[i];
+}
+
+/**
+ * gst_mpeg_video_quant_matrix_get_zigzag_from_raster:
+ * @out_quant: (out): The resulting quantization matrix
+ * @quant: The source quantization matrix
+ *
+ * Converts quantization matrix @quant from raster scan order to
+ * zigzag scan order and store the resulting factors into @out_quant.
+ *
+ * Note: it is an error to pass the same table in both @quant and
+ * @out_quant arguments.
+ *
+ * Since: 1.2
+ */
+void
+gst_mpeg_video_quant_matrix_get_zigzag_from_raster (guint8 out_quant[64],
+    const guint8 quant[64])
+{
+  guint i;
+
+  g_return_if_fail (out_quant != quant);
+
+  for (i = 0; i < 64; i++)
+    out_quant[i] = quant[mpeg_zigzag_8x8[i]];
+}
+
+/****** Deprecated API *******/
+
+/**
+ * gst_mpeg_video_parse_sequence_header:
+ * @seqhdr: (out): The #GstMpegVideoSequenceHdr structure to fill
+ * @data: The data from which to parse the sequence header
+ * @size: The size of @data
+ * @offset: The offset in byte from which to start parsing @data
+ *
+ * Parses the @seqhdr Mpeg Video Sequence Header structure members from @data
+ *
+ * Returns: %TRUE if the seqhdr could be parsed correctly, %FALSE otherwize.
+ *
+ * Deprecated: Use gst_mpeg_video_packet_parse_sequence_header() instead.
+ */
+#ifndef GST_REMOVE_DEPRECATED
+#ifdef GST_DISABLE_DEPRECATED
+gboolean
+gst_mpeg_video_parse_sequence_header (GstMpegVideoSequenceHdr * seqhdr,
+    const guint8 * data, gsize size, guint offset);
+#endif
+gboolean
+gst_mpeg_video_parse_sequence_header (GstMpegVideoSequenceHdr * seqhdr,
+    const guint8 * data, gsize size, guint offset)
+{
+  GstMpegVideoPacket packet;
+
+  packet.data = data;
+  packet.type = GST_MPEG_VIDEO_PACKET_SEQUENCE;
+  packet.offset = offset;
+  packet.size = size - offset;
+  return gst_mpeg_video_packet_parse_sequence_header (&packet, seqhdr);
+}
+#endif
+
+/**
+ * gst_mpeg_video_parse_sequence_extension:
+ * @seqext: (out): The #GstMpegVideoSequenceExt structure to fill
+ * @data: The data from which to parse the sequence extension
+ * @size: The size of @data
+ * @offset: The offset in byte from which to start parsing @data
+ *
+ * Parses the @seqext Mpeg Video Sequence Extension structure members from @data
+ *
+ * Returns: %TRUE if the seqext could be parsed correctly, %FALSE otherwize.
+ *
+ * Deprecated: Use gst_mpeg_video_packet_parse_sequence_extension() instead.
+ */
+#ifndef GST_REMOVE_DEPRECATED
+#ifdef GST_DISABLE_DEPRECATED
+gboolean
+gst_mpeg_video_parse_sequence_extension (GstMpegVideoSequenceExt * seqext,
+    const guint8 * data, gsize size, guint offset);
+#endif
+gboolean
+gst_mpeg_video_parse_sequence_extension (GstMpegVideoSequenceExt * seqext,
+    const guint8 * data, gsize size, guint offset)
+{
+  GstMpegVideoPacket packet;
+
+  packet.data = data;
+  packet.type = GST_MPEG_VIDEO_PACKET_EXTENSION;
+  packet.offset = offset;
+  packet.size = size - offset;
+  return gst_mpeg_video_packet_parse_sequence_extension (&packet, seqext);
+}
+#endif
+
+#ifndef GST_REMOVE_DEPRECATED
+#ifdef GST_DISABLE_DEPRECATED
+gboolean
+gst_mpeg_video_parse_sequence_display_extension (GstMpegVideoSequenceDisplayExt
+    * seqdisplayext, const guint8 * data, gsize size, guint offset);
+#endif
+gboolean
+gst_mpeg_video_parse_sequence_display_extension (GstMpegVideoSequenceDisplayExt
+    * seqdisplayext, const guint8 * data, gsize size, guint offset)
+{
+  GstMpegVideoPacket packet;
+
+  packet.data = data;
+  packet.type = GST_MPEG_VIDEO_PACKET_EXTENSION;
+  packet.offset = offset;
+  packet.size = size - offset;
+  return gst_mpeg_video_packet_parse_sequence_display_extension (&packet,
+      seqdisplayext);
+}
+#endif
+
+/**
+ * gst_mpeg_video_parse_quant_matrix_extension:
+ * @quant: (out): The #GstMpegVideoQuantMatrixExt structure to fill
+ * @data: The data from which to parse the Quantization Matrix extension
+ * @size: The size of @data
+ * @offset: The offset in byte from which to start the parsing
+ *
+ * Parses the @quant Mpeg Video Quant Matrix Extension structure members from
+ * @data
+ *
+ * Returns: %TRUE if the quant matrix extension could be parsed correctly,
+ * %FALSE otherwize.
+ *
+ * Deprecated: Use gst_mpeg_video_packet_parse_quant_matrix_extension() instead.
+ */
+#ifndef GST_REMOVE_DEPRECATED
+#ifdef GST_DISABLE_DEPRECATED
+gboolean
+gst_mpeg_video_parse_quant_matrix_extension (GstMpegVideoQuantMatrixExt * quant,
+    const guint8 * data, gsize size, guint offset);
+#endif
+gboolean
+gst_mpeg_video_parse_quant_matrix_extension (GstMpegVideoQuantMatrixExt * quant,
+    const guint8 * data, gsize size, guint offset)
+{
+  GstMpegVideoPacket packet;
+
+  packet.data = data;
+  packet.type = GST_MPEG_VIDEO_PACKET_EXTENSION;
+  packet.offset = offset;
+  packet.size = size - offset;
+  return gst_mpeg_video_packet_parse_quant_matrix_extension (&packet, quant);
+}
+#endif
+
+/**
+ * gst_mpeg_video_parse_picture_header:
+ * @hdr: (out): The #GstMpegVideoPictureHdr structure to fill
+ * @data: The data from which to parse the picture header
+ * @size: The size of @data
+ * @offset: The offset in byte from which to start the parsing
+ *
+ * Parsers the @hdr Mpeg Video Picture Header structure members from @data
+ *
+ * Returns: %TRUE if the picture sequence could be parsed correctly, %FALSE
+ * otherwize.
+ *
+ * Deprecated: Use gst_mpeg_video_packet_parse_picture_header() instead.
+ */
+#ifndef GST_REMOVE_DEPRECATED
+#ifdef GST_DISABLE_DEPRECATED
+gboolean
+gst_mpeg_video_parse_picture_header (GstMpegVideoPictureHdr * hdr,
+    const guint8 * data, gsize size, guint offset);
+#endif
+gboolean
+gst_mpeg_video_parse_picture_header (GstMpegVideoPictureHdr * hdr,
+    const guint8 * data, gsize size, guint offset)
+{
+  GstMpegVideoPacket packet;
+
+  packet.data = data;
+  packet.type = GST_MPEG_VIDEO_PACKET_PICTURE;
+  packet.offset = offset;
+  packet.size = size - offset;
+  return gst_mpeg_video_packet_parse_picture_header (&packet, hdr);
+}
+#endif
+
+/**
+ * gst_mpeg_video_parse_picture_extension:
+ * @ext: (out): The #GstMpegVideoPictureExt structure to fill
+ * @data: The data from which to parse the picture extension
+ * @size: The size of @data
+ * @offset: The offset in byte from which to start the parsing
+ *
+ * Parse the @ext Mpeg Video Picture Extension structure members from @data
+ *
+ * Returns: %TRUE if the picture extension could be parsed correctly,
+ * %FALSE otherwize.
+ *
+ * Deprecated: Use gst_mpeg_video_packet_parse_picture_extension() instead.
+ */
+#ifndef GST_REMOVE_DEPRECATED
+#ifdef GST_DISABLE_DEPRECATED
+gboolean
+gst_mpeg_video_parse_picture_extension (GstMpegVideoPictureExt * ext,
+    const guint8 * data, gsize size, guint offset);
+#endif
+gboolean
+gst_mpeg_video_parse_picture_extension (GstMpegVideoPictureExt * ext,
+    const guint8 * data, gsize size, guint offset)
+{
+  GstMpegVideoPacket packet;
+
+  packet.data = data;
+  packet.type = GST_MPEG_VIDEO_PACKET_EXTENSION;
+  packet.offset = offset;
+  packet.size = size - offset;
+  return gst_mpeg_video_packet_parse_picture_extension (&packet, ext);
+}
+#endif
+
+/**
+ * gst_mpeg_video_parse_gop:
+ * @gop: (out): The #GstMpegVideoGop structure to fill
+ * @data: The data from which to parse the gop
+ * @size: The size of @data
+ * @offset: The offset in byte from which to start the parsing
+ *
+ * Parses the @gop Mpeg Video Group of Picture structure members from @data
+ *
+ * Returns: %TRUE if the gop could be parsed correctly, %FALSE otherwize.
+ *
+ * Deprecated: Use gst_mpeg_video_packet_parse_gop() instead.
+ */
+#ifndef GST_REMOVE_DEPRECATED
+#ifdef GST_DISABLE_DEPRECATED
+gboolean
+gst_mpeg_video_parse_gop (GstMpegVideoGop * gop, const guint8 * data,
+    gsize size, guint offset);
+#endif
+gboolean
+gst_mpeg_video_parse_gop (GstMpegVideoGop * gop, const guint8 * data,
+    gsize size, guint offset)
+{
+  GstMpegVideoPacket packet;
+
+  packet.data = data;
+  packet.type = GST_MPEG_VIDEO_PACKET_GOP;
+  packet.offset = offset;
+  packet.size = size - offset;
+  return gst_mpeg_video_packet_parse_gop (&packet, gop);
+}
+#endif
diff --git a/lib/libv4l-delta/codecparsers/gstmpegvideoparser.h b/lib/libv4l-delta/codecparsers/gstmpegvideoparser.h
new file mode 100644
index 0000000..8791147
--- /dev/null
+++ b/lib/libv4l-delta/codecparsers/gstmpegvideoparser.h
@@ -0,0 +1,560 @@
+/* Gstreamer
+ * Copyright (C) <2011> Intel Corporation
+ * Copyright (C) <2011> Collabora Ltd.
+ * Copyright (C) <2011> Thibault Saunier <thibault.saunier@collabora.com>
+ *
+ * From bad/sys/vdpau/mpeg/mpegutil.c:
+ *   Copyright (C) <2007> Jan Schmidt <thaytan@mad.scientist.com>
+ *   Copyright (C) <2009> Carl-Anton Ingmarsson <ca.ingmarsson@gmail.com>
+ *
+ * This library is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU Library General Public
+ * License as published by the Free Software Foundation; either
+ * version 2 of the License, or (at your option) any later version.
+ *
+ * This library is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * Library General Public License for more details.
+ *
+ * You should have received a copy of the GNU Library General Public
+ * License along with this library; if not, write to the
+ * Free Software Foundation, Inc., 51 Franklin St, Fifth Floor,
+ * Boston, MA 02110-1301, USA.
+ */
+
+#ifndef __GST_MPEG_VIDEO_UTILS_H__
+#define __GST_MPEG_VIDEO_UTILS_H__
+
+#ifndef GST_USE_UNSTABLE_API
+#warning "The Mpeg video parsing library is unstable API and may change in future."
+#warning "You can define GST_USE_UNSTABLE_API to avoid this warning."
+#endif
+
+
+#include <gst/gst.h>
+
+G_BEGIN_DECLS
+
+/**
+ * GstMpegVideoPacketTypeCode:
+ * @GST_MPEG_VIDEO_PACKET_PICTURE: Picture packet starting code
+ * @GST_MPEG_VIDEO_PACKET_SLICE_MIN: Slice min packet starting code
+ * @GST_MPEG_VIDEO_PACKET_SLICE_MAX: Slice max packet starting code
+ * @GST_MPEG_VIDEO_PACKET_USER_DATA: User data packet starting code
+ * @GST_MPEG_VIDEO_PACKET_SEQUENCE : Sequence packet starting code
+ * @GST_MPEG_VIDEO_PACKET_EXTENSION: Extension packet starting code
+ * @GST_MPEG_VIDEO_PACKET_SEQUENCE_END: Sequence end packet code
+ * @GST_MPEG_VIDEO_PACKET_GOP: Group of Picture packet starting code
+ * @GST_MPEG_VIDEO_PACKET_NONE: None packet code
+ *
+ * Indicates the type of MPEG packet
+ */
+typedef enum {
+  GST_MPEG_VIDEO_PACKET_PICTURE      = 0x00,
+  GST_MPEG_VIDEO_PACKET_SLICE_MIN    = 0x01,
+  GST_MPEG_VIDEO_PACKET_SLICE_MAX    = 0xaf,
+  GST_MPEG_VIDEO_PACKET_USER_DATA    = 0xb2,
+  GST_MPEG_VIDEO_PACKET_SEQUENCE     = 0xb3,
+  GST_MPEG_VIDEO_PACKET_EXTENSION    = 0xb5,
+  GST_MPEG_VIDEO_PACKET_SEQUENCE_END = 0xb7,
+  GST_MPEG_VIDEO_PACKET_GOP          = 0xb8,
+  GST_MPEG_VIDEO_PACKET_NONE         = 0xff
+} GstMpegVideoPacketTypeCode;
+
+/**
+ * GST_MPEG_VIDEO_PACKET_IS_SLICE:
+ * @typecode: The MPEG video packet type code
+ *
+ * Checks whether a packet type code is a slice.
+ *
+ * Returns: %TRUE if the packet type code corresponds to a slice,
+ * else %FALSE.
+ */
+#define GST_MPEG_VIDEO_PACKET_IS_SLICE(typecode) ((typecode) >= GST_MPEG_VIDEO_PACKET_SLICE_MIN && \
+						  (typecode) <= GST_MPEG_VIDEO_PACKET_SLICE_MAX)
+
+/**
+ * GstMpegVideoPacketExtensionCode:
+ * @GST_MPEG_VIDEO_PACKET_EXT_SEQUENCE: Sequence extension code
+ * @GST_MPEG_VIDEO_PACKET_EXT_SEQUENCE_DISPLAY: Sequence Display extension code
+ * @GST_MPEG_VIDEO_PACKET_EXT_QUANT_MATRIX: Quantization Matrix extension code
+ * @GST_MPEG_VIDEO_PACKET_EXT_SEQUENCE_SCALABLE: Sequence Scalable extension code
+ * @GST_MPEG_VIDEO_PACKET_EXT_PICTURE: Picture coding extension
+ *
+ * Indicates what type of packets are in this block, some are mutually
+ * exclusive though - ie, sequence packs are accumulated separately. GOP &
+ * Picture may occur together or separately.
+ */
+typedef enum {
+  GST_MPEG_VIDEO_PACKET_EXT_SEQUENCE          = 0x01,
+  GST_MPEG_VIDEO_PACKET_EXT_SEQUENCE_DISPLAY  = 0x02,
+  GST_MPEG_VIDEO_PACKET_EXT_QUANT_MATRIX      = 0x03,
+  GST_MPEG_VIDEO_PACKET_EXT_SEQUENCE_SCALABLE = 0x05,
+  GST_MPEG_VIDEO_PACKET_EXT_PICTURE           = 0x08
+} GstMpegVideoPacketExtensionCode;
+
+/**
+ * GstMpegVideoSequenceScalableMode:
+ * GST_MPEG_VIDEO_SEQ_SCALABLE_MODE_DATA_PARTITIONING: Data partitioning
+ * GST_MPEG_VIDEO_SEQ_SCALABLE_MODE_SPATIAL: Spatial Scalability            
+ * GST_MPEG_VIDEO_SEQ_SCALABLE_MODE_SNR: SNR Scalability                
+ * GST_MPEG_VIDEO_SEQ_SCALABLE_MODE_TEMPORAL: Temporal Scalability   
+ */
+typedef enum {
+  GST_MPEG_VIDEO_SEQ_SCALABLE_MODE_DATA_PARTITIONING  = 0x00,
+  GST_MPEG_VIDEO_SEQ_SCALABLE_MODE_SPATIAL            = 0x01,
+  GST_MPEG_VIDEO_SEQ_SCALABLE_MODE_SNR                = 0x02,
+  GST_MPEG_VIDEO_SEQ_SCALABLE_MODE_TEMPORAL           = 0x03
+} GstMpegVideoSequenceScalableMode;
+
+/**
+ * GstMpegVideoLevel:
+ * @GST_MPEG_VIDEO_LEVEL_LOW: Low level (LL)
+ * @GST_MPEG_VIDEO_LEVEL_MAIN: Main level (ML)
+ * @GST_MPEG_VIDEO_LEVEL_HIGH_1440: High 1440 level (H-14)
+ * @GST_MPEG_VIDEO_LEVEL_HIGH: High level (HL)
+ *
+ * Mpeg-2 Levels.
+ **/
+typedef enum {
+ GST_MPEG_VIDEO_LEVEL_HIGH      = 0x04,
+ GST_MPEG_VIDEO_LEVEL_HIGH_1440 = 0x06,
+ GST_MPEG_VIDEO_LEVEL_MAIN      = 0x08,
+ GST_MPEG_VIDEO_LEVEL_LOW       = 0x0a
+} GstMpegVideoLevel;
+
+/**
+ * GstMpegVideoProfile:
+ * @GST_MPEG_VIDEO_PROFILE_422: 4:2:2 profile (422)
+ * @GST_MPEG_VIDEO_PROFILE_HIGH: High profile (HP)
+ * @GST_MPEG_VIDEO_PROFILE_SPATIALLY_SCALABLE: Spatially Scalable profile (Spatial)
+ * @GST_MPEG_VIDEO_PROFILE_SNR_SCALABLE: SNR Scalable profile (SNR)
+ * @GST_MPEG_VIDEO_PROFILE_MAIN: Main profile (MP)
+ * @GST_MPEG_VIDEO_PROFILE_SIMPLE: Simple profile (SP)
+ *
+ * Mpeg-2 Profiles.
+ **/
+typedef enum {
+  GST_MPEG_VIDEO_PROFILE_422                 = 0x00,
+  GST_MPEG_VIDEO_PROFILE_HIGH                = 0x01,
+  GST_MPEG_VIDEO_PROFILE_SPATIALLY_SCALABLE  = 0x02,
+  GST_MPEG_VIDEO_PROFILE_SNR_SCALABLE        = 0x03,
+  GST_MPEG_VIDEO_PROFILE_MAIN                = 0x04,
+  GST_MPEG_VIDEO_PROFILE_SIMPLE              = 0x05
+} GstMpegVideoProfile;
+
+/**
+ * GstMpegVideoChromaFormat:
+ * @GST_MPEG_VIDEO_CHROMA_RES: Invalid (reserved for future use)
+ * @GST_MPEG_VIDEO_CHROMA_420: 4:2:0 subsampling
+ * @GST_MPEG_VIDEO_CHROMA_422: 4:2:2 subsampling
+ * @GST_MPEG_VIDEO_CHROMA_444: 4:4:4 (non-subsampled)
+ *
+ * Chroma subsampling type.
+ */
+typedef enum {
+  GST_MPEG_VIDEO_CHROMA_RES = 0x00,
+  GST_MPEG_VIDEO_CHROMA_420 = 0x01,
+  GST_MPEG_VIDEO_CHROMA_422 = 0x02,
+  GST_MPEG_VIDEO_CHROMA_444 = 0x03,
+} GstMpegVideoChromaFormat;
+
+/**
+ * GstMpegVideoPictureType:
+ * @GST_MPEG_VIDEO_PICTURE_TYPE_I: Intra-coded (I) frame
+ * @GST_MPEG_VIDEO_PICTURE_TYPE_P: Predictive-codec (P) frame
+ * @GST_MPEG_VIDEO_PICTURE_TYPE_B: Bidirectionally predictive-coded (B) frame
+ * @GST_MPEG_VIDEO_PICTURE_TYPE_D: D frame
+ *
+ * Picture type.
+ */
+typedef enum {
+  GST_MPEG_VIDEO_PICTURE_TYPE_I = 0x01,
+  GST_MPEG_VIDEO_PICTURE_TYPE_P = 0x02,
+  GST_MPEG_VIDEO_PICTURE_TYPE_B = 0x03,
+  GST_MPEG_VIDEO_PICTURE_TYPE_D = 0x04
+} GstMpegVideoPictureType;
+
+/**
+ * GstMpegVideoPictureStructure:
+ * @GST_MPEG_VIDEO_PICTURE_STRUCTURE_TOP_FIELD: Top field
+ * @GST_MPEG_VIDEO_PICTURE_STRUCTURE_BOTTOM_FIELD: Bottom field
+ * @GST_MPEG_VIDEO_PICTURE_STRUCTURE_FRAME: Frame picture
+ *
+ * Picture structure type.
+ */
+typedef enum {
+    GST_MPEG_VIDEO_PICTURE_STRUCTURE_TOP_FIELD    = 0x01,
+    GST_MPEG_VIDEO_PICTURE_STRUCTURE_BOTTOM_FIELD = 0x02,
+    GST_MPEG_VIDEO_PICTURE_STRUCTURE_FRAME        = 0x03
+} GstMpegVideoPictureStructure;
+
+typedef struct _GstMpegVideoSequenceHdr     GstMpegVideoSequenceHdr;
+typedef struct _GstMpegVideoSequenceExt     GstMpegVideoSequenceExt;
+typedef struct _GstMpegVideoSequenceDisplayExt GstMpegVideoSequenceDisplayExt;
+typedef struct _GstMpegVideoSequenceScalableExt GstMpegVideoSequenceScalableExt;
+typedef struct _GstMpegVideoPictureHdr      GstMpegVideoPictureHdr;
+typedef struct _GstMpegVideoGop             GstMpegVideoGop;
+typedef struct _GstMpegVideoPictureExt      GstMpegVideoPictureExt;
+typedef struct _GstMpegVideoQuantMatrixExt  GstMpegVideoQuantMatrixExt;
+typedef struct _GstMpegVideoSliceHdr        GstMpegVideoSliceHdr;
+typedef struct _GstMpegVideoPacket          GstMpegVideoPacket;
+
+/**
+ * GstMpegVideoSequenceHdr:
+ * @width: Width of each frame
+ * @height: Height of each frame
+ * @par_w: Calculated Pixel Aspect Ratio width
+ * @par_h: Calculated Pixel Aspect Ratio height
+ * @fps_n: Calculated Framrate nominator
+ * @fps_d: Calculated Framerate denominator
+ * @bitrate_value: Value of the bitrate as is in the stream (400bps unit)
+ * @bitrate: the real bitrate of the Mpeg video stream in bits per second, 0 if VBR stream
+ * @constrained_parameters_flag: %TRUE if this stream uses contrained parameters.
+ * @intra_quantizer_matrix: intra-quantization table, in zigzag scan order
+ * @non_intra_quantizer_matrix: non-intra quantization table, in zigzag scan order
+ *
+ * The Mpeg2 Video Sequence Header structure.
+ */
+struct _GstMpegVideoSequenceHdr
+{
+  guint16 width, height;
+  guint8  aspect_ratio_info;
+  guint8  frame_rate_code;
+  guint32 bitrate_value;
+  guint16 vbv_buffer_size_value;
+
+  guint8  constrained_parameters_flag;
+
+  guint8 load_intra_flag, load_non_intra_flag;
+  guint8  intra_quantizer_matrix[64];
+  guint8  non_intra_quantizer_matrix[64];
+
+  /* Calculated values */
+  guint   par_w, par_h;
+  guint   fps_n, fps_d;
+  guint   bitrate;
+};
+
+/**
+ * GstMpegVideoSequenceExt:
+ * @profile: mpeg2 decoder profile
+ * @level: mpeg2 decoder level
+ * @progressive: %TRUE if the frames are progressive %FALSE otherwise
+ * @chroma_format: indicates the chrominance format
+ * @horiz_size_ext: Horizontal size
+ * @vert_size_ext: Vertical size
+ * @bitrate_ext: The bitrate
+ * @vbv_buffer_size_extension: VBV vuffer size
+ * @low_delay: %TRUE if the sequence doesn't contain any B-pictures, %FALSE
+ * otherwise
+ * @fps_n_ext: Framerate nominator code
+ * @fps_d_ext: Framerate denominator code
+ *
+ * The Mpeg2 Video Sequence Extension structure.
+ **/
+struct _GstMpegVideoSequenceExt
+{
+  /* mpeg2 decoder profile */
+  guint8 profile_and_level;
+
+  guint8 progressive;
+  guint8 chroma_format;
+
+  guint8 horiz_size_ext, vert_size_ext;
+
+  guint16 bitrate_ext;
+  guint8 vbv_buffer_size_extension;
+  guint8 low_delay;
+  guint8 fps_n_ext, fps_d_ext;
+
+};
+
+/**
+ * GstMpegVideoSequenceDisplayExt:
+ * @profile: mpeg2 decoder profil
+
+ */
+struct _GstMpegVideoSequenceDisplayExt
+{
+  guint8 video_format;
+  guint8 colour_description_flag;
+
+  /* if colour_description_flag: */
+    guint8 colour_primaries;
+    guint8 transfer_characteristics;
+    guint8 matrix_coefficients;
+
+  guint16 display_horizontal_size;
+  guint16 display_vertical_size;
+};
+
+/**
+ * GstMpegVideoSequenceScalableExt:
+ * @scalable_mode:
+ * @layer_id:
+ * @lower_layer_prediction_horizontal_size:
+ * @lower_layer_prediction_vertical_size:
+ * @horizontal_subsampling_factor_m:
+ * @horizontal_subsampling_factor_n:
+ * @vertical_subsampling_factor_m:
+ * @vertical_subsampling_factor_n:
+ * @picture_mux_enable:
+ * @mux_to_progressive_sequence:
+ * @picture_mux_order:
+ * @picture_mux_factor:
+ *
+ * The Sequence Scalable Extension structure.
+ *
+ * Since: 1.2
+ */
+struct _GstMpegVideoSequenceScalableExt
+{
+  guint8 scalable_mode;
+  guint8 layer_id;
+
+  /* if spatial scalability */
+  guint16 lower_layer_prediction_horizontal_size;
+  guint16 lower_layer_prediction_vertical_size;
+  guint8 horizontal_subsampling_factor_m;
+  guint8 horizontal_subsampling_factor_n;
+  guint8 vertical_subsampling_factor_m;
+  guint8 vertical_subsampling_factor_n;
+
+  /* if temporal scalability */
+  guint8 picture_mux_enable;
+  guint8 mux_to_progressive_sequence;
+  guint8 picture_mux_order;
+  guint8 picture_mux_factor;
+};
+
+/**
+ * GstMpegVideoQuantMatrixExt:
+ * @load_intra_quantiser_matrix:
+ * @intra_quantiser_matrix:
+ * @load_non_intra_quantiser_matrix:
+ * @non_intra_quantiser_matrix:
+ * @load_chroma_intra_quantiser_matrix:
+ * @chroma_intra_quantiser_matrix:
+ * @load_chroma_non_intra_quantiser_matrix:
+ * @chroma_non_intra_quantiser_matrix:
+ *
+ * The Quant Matrix Extension structure that exposes quantization
+ * matrices in zigzag scan order. i.e. the original encoded scan
+ * order.
+ */
+struct _GstMpegVideoQuantMatrixExt
+{
+ guint8 load_intra_quantiser_matrix;
+ guint8 intra_quantiser_matrix[64];
+ guint8 load_non_intra_quantiser_matrix;
+ guint8 non_intra_quantiser_matrix[64];
+ guint8 load_chroma_intra_quantiser_matrix;
+ guint8 chroma_intra_quantiser_matrix[64];
+ guint8 load_chroma_non_intra_quantiser_matrix;
+ guint8 chroma_non_intra_quantiser_matrix[64];
+};
+
+/**
+ * GstMpegVideoPictureHdr:
+ * @tsn: Temporal Sequence Number
+ * @pic_type: Type of the frame
+ * @full_pel_forward_vector: the full pel forward flag of
+ *  the frame: 0 or 1.
+ * @full_pel_backward_vector: the full pel backward flag
+ *  of the frame: 0 or 1.
+ * @f_code: F code forward and backward
+ *
+ * The Mpeg2 Video Picture Header structure.
+ */
+struct _GstMpegVideoPictureHdr
+{
+  guint16 tsn;
+  guint8 pic_type;
+  guint16 vbv_delay;
+
+  guint8 full_pel_forward_vector, full_pel_backward_vector;
+
+  guint8 f_f_code;
+  guint8 b_f_code;
+};
+
+/**
+ * GstMpegVideoPictureExt:
+ * @intra_dc_precision: Intra DC precision
+ * @picture_structure: Structure of the picture
+ * @top_field_first: Top field first
+ * @frame_pred_frame_dct: Frame
+ * @concealment_motion_vectors: Concealment Motion Vectors
+ * @q_scale_type: Q Scale Type
+ * @intra_vlc_format: Intra Vlc Format
+ * @alternate_scan: Alternate Scan
+ * @repeat_first_field: Repeat First Field
+ * @chroma_420_type: Chroma 420 Type
+ * @progressive_frame: %TRUE if the frame is progressive %FALSE otherwize
+ *
+ * The Mpeg2 Video Picture Extension structure.
+ */
+struct _GstMpegVideoPictureExt
+{
+  guint8 f_code[2][2];
+
+  guint8 intra_dc_precision;
+  guint8 picture_structure;
+  guint8 top_field_first;
+  guint8 frame_pred_frame_dct;
+  guint8 concealment_motion_vectors;
+  guint8 q_scale_type;
+  guint8 intra_vlc_format;
+  guint8 alternate_scan;
+  guint8 repeat_first_field;
+  guint8 chroma_420_type;
+  guint8 progressive_frame;
+  guint8 composite_display;
+  guint8 v_axis;
+  guint8 field_sequence;
+  guint8 sub_carrier;
+  guint8 burst_amplitude;
+  guint8 sub_carrier_phase;
+};
+
+/**
+ * GstMpegVideoGop:
+ * @drop_frame_flag: Drop Frame Flag
+ * @hour: Hour (0-23)
+ * @minute: Minute (O-59)
+ * @second: Second (0-59)
+ * @frame: Frame (0-59)
+ * @closed_gop: Closed Gop
+ * @broken_link: Broken link
+ *
+ * The Mpeg Video Group of Picture structure.
+ */
+struct _GstMpegVideoGop
+{
+  guint8 drop_frame_flag;
+
+  guint8 hour, minute, second, frame;
+
+  guint8 closed_gop;
+  guint8 broken_link;
+};
+
+/**
+ * GstMpegVideoSliceHdr:
+ * @slice_vertical_position_extension: Extension to slice_vertical_position
+ * @priority_breakpoint: Point where the bitstream shall be partitioned
+ * @quantiser_scale_code: Quantiser value (range: 1-31)
+ * @intra_slice: Equal to one if all the macroblocks are intra macro blocks.
+ * @slice_picture_id: Intended to aid recovery on severe bursts of
+ *   errors for certain types of applications
+ *
+ * The Mpeg2 Video Slice Header structure.
+ *
+ * Since: 1.2
+ */
+struct _GstMpegVideoSliceHdr
+{
+  guint8 priority_breakpoint;
+  guint8 quantiser_scale_code;
+  guint8 intra_slice;
+  guint8 slice_picture_id;
+
+  /* Calculated values */
+  guint header_size;            /* slice_header size in bits */
+  gint mb_row;                  /* macroblock row */
+  gint mb_column;               /* macroblock column */
+};
+
+/**
+ * GstMpegVideoPacket:
+ * @type: the type of the packet that start at @offset, as a #GstMpegVideoPacketTypeCode
+ * @data: the data containing the packet starting at @offset
+ * @offset: the offset of the packet start in bytes from @data. This is the
+ *     start of the packet itself without the sync code
+ * @size: The size in bytes of the packet or -1 if the end wasn't found. This
+ *     is the size of the packet itself without the sync code
+ *
+ * A structure that contains the type of a packet, its offset and its size
+ */
+struct _GstMpegVideoPacket
+{
+  const guint8 *data;
+  guint8 type;
+  guint  offset;
+  gint   size;
+};
+
+
+unsigned char get_extension_code(const GstMpegVideoPacket * packet);
+
+
+gboolean gst_mpeg_video_parse                         (GstMpegVideoPacket * packet,
+                                                       const guint8 * data, gsize size, guint offset);
+
+gboolean gst_mpeg_video_packet_parse_sequence_header    (const GstMpegVideoPacket * packet,
+                                                         GstMpegVideoSequenceHdr * seqhdr);
+
+gboolean gst_mpeg_video_packet_parse_sequence_extension (const GstMpegVideoPacket * packet,
+                                                         GstMpegVideoSequenceExt * seqext);
+
+gboolean gst_mpeg_video_packet_parse_sequence_display_extension (const GstMpegVideoPacket * packet,
+                                                         GstMpegVideoSequenceDisplayExt * seqdisplayext);
+
+gboolean gst_mpeg_video_packet_parse_sequence_scalable_extension (const GstMpegVideoPacket * packet,
+                                                         GstMpegVideoSequenceScalableExt * seqscaleext);
+
+gboolean gst_mpeg_video_packet_parse_picture_header     (const GstMpegVideoPacket * packet,
+                                                         GstMpegVideoPictureHdr* pichdr);
+
+gboolean gst_mpeg_video_packet_parse_picture_extension  (const GstMpegVideoPacket * packet,
+                                                         GstMpegVideoPictureExt *picext);
+
+gboolean gst_mpeg_video_packet_parse_gop                (const GstMpegVideoPacket * packet,
+                                                         GstMpegVideoGop * gop);
+
+gboolean gst_mpeg_video_packet_parse_slice_header       (const GstMpegVideoPacket * packet,
+                                                         GstMpegVideoSliceHdr * slice_hdr,
+                                                         GstMpegVideoSequenceHdr * seq_hdr,
+                                                         GstMpegVideoSequenceScalableExt * seqscaleext);
+
+gboolean gst_mpeg_video_packet_parse_quant_matrix_extension (const GstMpegVideoPacket * packet,
+                                                         GstMpegVideoQuantMatrixExt * quant);
+
+/* seqext and displayext may be NULL if not received */
+gboolean gst_mpeg_video_finalise_mpeg2_sequence_header (GstMpegVideoSequenceHdr *hdr,
+   GstMpegVideoSequenceExt *seqext, GstMpegVideoSequenceDisplayExt *displayext);
+
+#ifndef GST_DISABLE_DEPRECATED
+gboolean gst_mpeg_video_parse_picture_header          (GstMpegVideoPictureHdr* hdr,
+                                                       const guint8 * data, gsize size, guint offset);
+
+gboolean gst_mpeg_video_parse_picture_extension       (GstMpegVideoPictureExt *ext,
+                                                       const guint8 * data, gsize size, guint offset);
+
+gboolean gst_mpeg_video_parse_gop                     (GstMpegVideoGop * gop,
+                                                       const guint8 * data, gsize size, guint offset);
+
+gboolean gst_mpeg_video_parse_sequence_header         (GstMpegVideoSequenceHdr * seqhdr,
+                                                       const guint8 * data, gsize size, guint offset);
+
+gboolean gst_mpeg_video_parse_sequence_extension      (GstMpegVideoSequenceExt * seqext,
+                                                       const guint8 * data, gsize size, guint offset);
+
+gboolean gst_mpeg_video_parse_sequence_display_extension (GstMpegVideoSequenceDisplayExt * seqdisplayext,
+                                                       const guint8 * data, gsize size, guint offset);
+
+gboolean gst_mpeg_video_parse_quant_matrix_extension  (GstMpegVideoQuantMatrixExt * quant,
+                                                       const guint8 * data, gsize size, guint offset);
+#endif
+
+void     gst_mpeg_video_quant_matrix_get_raster_from_zigzag (guint8 out_quant[64],
+                                                             const guint8 quant[64]);
+
+void     gst_mpeg_video_quant_matrix_get_zigzag_from_raster (guint8 out_quant[64],
+                                                             const guint8 quant[64]);
+
+G_END_DECLS
+
+#endif
diff --git a/lib/libv4l-delta/codecparsers/parserutils.c b/lib/libv4l-delta/codecparsers/parserutils.c
new file mode 100644
index 0000000..d4a3f40
--- /dev/null
+++ b/lib/libv4l-delta/codecparsers/parserutils.c
@@ -0,0 +1,57 @@
+/* Gstreamer
+ * Copyright (C) <2011> Intel Corporation
+ * Copyright (C) <2011> Collabora Ltd.
+ * Copyright (C) <2011> Thibault Saunier <thibault.saunier@collabora.com>
+ *
+ * This library is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU Library General Public
+ * License as published by the Free Software Foundation; either
+ * version 2 of the License, or (at your option) any later version.
+ *
+ * This library is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * Library General Public License for more details.
+ *
+ * You should have received a copy of the GNU Library General Public
+ * License along with this library; if not, write to the
+ * Free Software Foundation, Inc., 51 Franklin St, Fifth Floor,
+ * Boston, MA 02110-1301, USA.
+ */
+
+#include "parserutils.h"
+
+gboolean
+decode_vlc (GstBitReader * br, guint * res, const VLCTable * table,
+    guint length)
+{
+  guint8 i;
+  guint cbits = 0;
+  guint32 value = 0;
+
+  for (i = 0; i < length; i++) {
+    if (cbits != table[i].cbits) {
+      cbits = table[i].cbits;
+      if (!gst_bit_reader_peek_bits_uint32 (br, &value, cbits)) {
+        goto failed;
+      }
+    }
+
+    if (value == table[i].cword) {
+      SKIP (br, cbits);
+      if (res)
+        *res = table[i].value;
+
+      return TRUE;
+    }
+  }
+
+  GST_DEBUG ("Did not find code");
+
+failed:
+  {
+    GST_WARNING ("Could not decode VLC returning");
+
+    return FALSE;
+  }
+}
diff --git a/lib/libv4l-delta/codecparsers/parserutils.h b/lib/libv4l-delta/codecparsers/parserutils.h
new file mode 100644
index 0000000..6b54ded
--- /dev/null
+++ b/lib/libv4l-delta/codecparsers/parserutils.h
@@ -0,0 +1,108 @@
+/* Gstreamer
+ * Copyright (C) <2011> Intel
+ * Copyright (C) <2011> Collabora Ltd.
+ * Copyright (C) <2011> Thibault Saunier <thibault.saunier@collabora.com>
+ *
+ * This library is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU Library General Public
+ * License as published by the Free Software Foundation; either
+ * version 2 of the License, or (at your option) any later version.
+ *
+ * This library is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * Library General Public License for more details.
+ *
+ * You should have received a copy of the GNU Library General Public
+ * License along with this library; if not, write to the
+ * Free Software Foundation, Inc., 51 Franklin St, Fifth Floor,
+ * Boston, MA 02110-1301, USA.
+ */
+
+#ifndef __PARSER_UTILS__
+#define __PARSER_UTILS__
+
+#include <gst/gst.h>
+#include <gst/base/gstbitreader.h>
+
+/* Parsing utils */
+#define GET_BITS(b, num, bits) G_STMT_START {        \
+  if (!gst_bit_reader_get_bits_uint32(b, bits, num)) \
+    goto failed;                                     \
+  GST_TRACE ("parsed %d bits: %d", num, *(bits));    \
+} G_STMT_END
+
+#define CHECK_ALLOWED(val, min, max) G_STMT_START { \
+  if (val < min || val > max) { \
+    GST_WARNING ("value not in allowed range. value: %d, range %d-%d", \
+                     val, min, max); \
+    goto failed; \
+  } \
+} G_STMT_END
+
+#define READ_UINT8(reader, val, nbits) G_STMT_START { \
+  if (!gst_bit_reader_get_bits_uint8 (reader, &val, nbits)) { \
+    GST_WARNING ("failed to read uint8, nbits: %d", nbits); \
+    goto failed; \
+  } \
+} G_STMT_END
+
+#define READ_UINT16(reader, val, nbits) G_STMT_START { \
+  if (!gst_bit_reader_get_bits_uint16 (reader, &val, nbits)) { \
+    GST_WARNING ("failed to read uint16, nbits: %d", nbits); \
+    goto failed; \
+  } \
+} G_STMT_END
+
+#define READ_UINT32(reader, val, nbits) G_STMT_START { \
+  if (!gst_bit_reader_get_bits_uint32 (reader, &val, nbits)) { \
+    GST_WARNING ("failed to read uint32, nbits: %d", nbits); \
+    goto failed; \
+  } \
+} G_STMT_END
+
+#define READ_UINT64(reader, val, nbits) G_STMT_START { \
+  if (!gst_bit_reader_get_bits_uint64 (reader, &val, nbits)) { \
+    GST_WARNING ("failed to read uint64, nbits: %d", nbits); \
+    goto failed; \
+  } \
+} G_STMT_END
+
+
+#define U_READ_UINT8(reader, val, nbits) G_STMT_START { \
+  val = gst_bit_reader_get_bits_uint8_unchecked (reader, nbits); \
+} G_STMT_END
+
+#define U_READ_UINT16(reader, val, nbits) G_STMT_START { \
+  val = gst_bit_reader_get_bits_uint16_unchecked (reader, nbits); \
+} G_STMT_END
+
+#define U_READ_UINT32(reader, val, nbits) G_STMT_START { \
+  val = gst_bit_reader_get_bits_uint32_unchecked (reader, nbits); \
+} G_STMT_END
+
+#define U_READ_UINT64(reader, val, nbits) G_STMT_START { \
+  val = gst_bit_reader_get_bits_uint64_unchecked (reader, nbits); \
+} G_STMT_END
+
+#define SKIP(reader, nbits) G_STMT_START { \
+  if (!gst_bit_reader_skip (reader, nbits)) { \
+    GST_WARNING ("failed to skip nbits: %d", nbits); \
+    goto failed; \
+  } \
+} G_STMT_END
+
+typedef struct _VLCTable VLCTable;
+
+struct _VLCTable
+{
+  guint value;
+  guint cword;
+  guint cbits;
+};
+
+gboolean
+decode_vlc (GstBitReader * br, guint * res, const VLCTable * table,
+    guint length);
+
+#endif /* __PARSER_UTILS__ */
-- 
1.9.1

