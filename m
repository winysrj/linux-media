Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f172.google.com ([209.85.215.172]:38243 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755729Ab3L3Mt1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Dec 2013 07:49:27 -0500
Received: by mail-ea0-f172.google.com with SMTP id q10so4402569ead.3
        for <linux-media@vger.kernel.org>; Mon, 30 Dec 2013 04:49:26 -0800 (PST)
From: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
To: linux-media@vger.kernel.org
Cc: =?UTF-8?q?Andr=C3=A9=20Roth?= <neolynx@gmail.com>
Subject: [PATCH 04/18] libdvbv5: mpeg elementary stream parsers
Date: Mon, 30 Dec 2013 13:48:37 +0100
Message-Id: <1388407731-24369-4-git-send-email-neolynx@gmail.com>
In-Reply-To: <1388407731-24369-1-git-send-email-neolynx@gmail.com>
References: <1388407731-24369-1-git-send-email-neolynx@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Implement parsers for mpeg TS, PES and ES

Signed-off-by: André Roth <neolynx@gmail.com>
---
 lib/include/descriptors/mpeg_es.h   | 109 ++++++++++++++++++++++++++++++
 lib/include/descriptors/mpeg_pes.h  | 111 ++++++++++++++++++++++++++++++
 lib/include/descriptors/mpeg_ts.h   |  78 +++++++++++++++++++++
 lib/libdvbv5/Makefile.am            |   5 +-
 lib/libdvbv5/descriptors/mpeg_es.c  |  76 +++++++++++++++++++++
 lib/libdvbv5/descriptors/mpeg_pes.c | 131 ++++++++++++++++++++++++++++++++++++
 lib/libdvbv5/descriptors/mpeg_ts.c  |  77 +++++++++++++++++++++
 7 files changed, 586 insertions(+), 1 deletion(-)
 create mode 100644 lib/include/descriptors/mpeg_es.h
 create mode 100644 lib/include/descriptors/mpeg_pes.h
 create mode 100644 lib/include/descriptors/mpeg_ts.h
 create mode 100644 lib/libdvbv5/descriptors/mpeg_es.c
 create mode 100644 lib/libdvbv5/descriptors/mpeg_pes.c
 create mode 100644 lib/libdvbv5/descriptors/mpeg_ts.c

diff --git a/lib/include/descriptors/mpeg_es.h b/lib/include/descriptors/mpeg_es.h
new file mode 100644
index 0000000..4c6a862
--- /dev/null
+++ b/lib/include/descriptors/mpeg_es.h
@@ -0,0 +1,109 @@
+/*
+ * Copyright (c) 2013 - Andre Roth <neolynx@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation version 2
+ * of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
+ * Or, point your browser to http://www.gnu.org/licenses/old-licenses/gpl-2.0.html
+ *
+ */
+
+#ifndef _MPEG_ES_H
+#define _MPEG_ES_H
+
+#include <stdint.h>
+#include <unistd.h> /* ssize_t */
+
+#define DVB_MPEG_ES_PIC_START  0x00
+#define DVB_MPEG_ES_USER_DATA  0xb2
+#define DVB_MPEG_ES_SEQ_START  0xb3
+#define DVB_MPEG_ES_SEQ_EXT    0xb5
+#define DVB_MPEG_ES_GOP        0xb8
+#define DVB_MPEG_ES_SLICES     0x01 ... 0xaf
+
+struct dvb_mpeg_es_seq_start {
+	union {
+		uint32_t bitfield;
+		struct {
+			uint32_t  type:8;
+			uint32_t  sync:24;
+		} __attribute__((packed));
+	} __attribute__((packed));
+	union {
+		uint32_t bitfield2;
+		struct {
+			uint32_t framerate:4;
+			uint32_t aspect:4;
+			uint32_t height:12;
+			uint32_t width:12;
+		} __attribute__((packed));
+	};
+	union {
+		uint32_t bitfield3;
+		struct {
+			uint32_t qm_nonintra:1;
+			uint32_t qm_intra:1;
+			uint32_t constrained:1;
+			uint32_t vbv:10; // Size of video buffer verifier = 16*1024*vbv buf size
+			uint32_t one:1;
+			uint32_t bitrate:18;
+		} __attribute__((packed));
+	};
+} __attribute__((packed));
+
+struct dvb_mpeg_es_pic_start {
+	union {
+		uint32_t bitfield;
+		struct {
+			uint32_t  type:8;
+			uint32_t  sync:24;
+		} __attribute__((packed));
+	} __attribute__((packed));
+	union {
+		uint32_t bitfield2;
+		struct {
+			uint32_t dummy:3;
+			uint32_t vbv_delay:16;
+			uint32_t coding_type:3;
+			uint32_t temporal_ref:10;
+		} __attribute__((packed));
+	};
+} __attribute__((packed));
+
+enum dvb_mpeg_es_frame_t
+{
+	DVB_MPEG_ES_FRAME_UNKNOWN,
+	DVB_MPEG_ES_FRAME_I,
+	DVB_MPEG_ES_FRAME_P,
+	DVB_MPEG_ES_FRAME_B,
+	DVB_MPEG_ES_FRAME_D
+};
+extern const char *dvb_mpeg_es_frame_names[5];
+
+struct dvb_v5_fe_parms;
+
+#ifdef __cplusplus
+extern "C" {
+#endif
+
+int  dvb_mpeg_es_seq_start_init (const uint8_t *buf, ssize_t buflen, struct dvb_mpeg_es_seq_start *seq_start);
+void dvb_mpeg_es_seq_start_print(struct dvb_v5_fe_parms *parms, struct dvb_mpeg_es_seq_start *seq_start);
+
+int  dvb_mpeg_es_pic_start_init (const uint8_t *buf, ssize_t buflen, struct dvb_mpeg_es_pic_start *pic_start);
+void dvb_mpeg_es_pic_start_print(struct dvb_v5_fe_parms *parms, struct dvb_mpeg_es_pic_start *pic_start);
+
+#ifdef __cplusplus
+}
+#endif
+
+#endif
diff --git a/lib/include/descriptors/mpeg_pes.h b/lib/include/descriptors/mpeg_pes.h
new file mode 100644
index 0000000..3a3f8e4
--- /dev/null
+++ b/lib/include/descriptors/mpeg_pes.h
@@ -0,0 +1,111 @@
+/*
+ * Copyright (c) 2013 - Andre Roth <neolynx@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation version 2
+ * of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
+ * Or, point your browser to http://www.gnu.org/licenses/old-licenses/gpl-2.0.html
+ *
+ */
+
+#ifndef _MPEG_PES_H
+#define _MPEG_PES_H
+
+#include <stdint.h>
+#include <unistd.h> /* ssize_t */
+
+#define DVB_MPEG_PES  0x00001
+#define DVB_MPEG_PES_VIDEO  0xe0 ... 0xef
+
+#define DVB_MPEG_STREAM_MAP       0xBC
+#define DVB_MPEG_STREAM_PADDING   0xBE
+#define DVB_MPEG_STREAM_PRIVATE_2 0x5F
+#define DVB_MPEG_STREAM_ECM       0x70
+#define DVB_MPEG_STREAM_EMM       0x71
+#define DVB_MPEG_STREAM_DIRECTORY 0xFF
+#define DVB_MPEG_STREAM_DSMCC     0x7A
+#define DVB_MPEG_STREAM_H222E     0xF8
+
+struct ts_t {
+	uint8_t  one:1;
+	uint8_t  bits30:3;
+	uint8_t  tag:4;
+
+	union {
+		uint16_t bitfield;
+		struct {
+			uint16_t  one1:1;
+			uint16_t  bits15:15;
+		} __attribute__((packed));
+	} __attribute__((packed));
+
+	union {
+		uint16_t bitfield2;
+		struct {
+			uint16_t  one2:1;
+			uint16_t  bits00:15;
+		} __attribute__((packed));
+	} __attribute__((packed));
+} __attribute__((packed));
+
+struct dvb_mpeg_pes_optional {
+	union {
+		uint16_t bitfield;
+		struct {
+			uint16_t PES_extension:1;
+			uint16_t PES_CRC:1;
+			uint16_t additional_copy_info:1;
+			uint16_t DSM_trick_mode:1;
+			uint16_t ES_rate:1;
+			uint16_t ESCR:1;
+			uint16_t PTS_DTS:2;
+			uint16_t original_or_copy:1;
+			uint16_t copyright:1;
+			uint16_t data_alignment_indicator:1;
+			uint16_t PES_priority:1;
+			uint16_t PES_scrambling_control:2;
+			uint16_t two:2;
+		} __attribute__((packed));
+	} __attribute__((packed));
+	uint8_t length;
+	uint64_t pts;
+	uint64_t dts;
+} __attribute__((packed));
+
+struct dvb_mpeg_pes {
+	union {
+		uint32_t bitfield;
+		struct {
+			uint32_t  stream_id:8;
+			uint32_t  sync:24;
+		} __attribute__((packed));
+	} __attribute__((packed));
+	uint16_t length;
+	struct dvb_mpeg_pes_optional optional[];
+} __attribute__((packed));
+
+struct dvb_v5_fe_parms;
+
+#ifdef __cplusplus
+extern "C" {
+#endif
+
+void dvb_mpeg_pes_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, uint8_t *table, ssize_t *table_length);
+void dvb_mpeg_pes_free(struct dvb_mpeg_pes *ts);
+void dvb_mpeg_pes_print(struct dvb_v5_fe_parms *parms, struct dvb_mpeg_pes *ts);
+
+#ifdef __cplusplus
+}
+#endif
+
+#endif
diff --git a/lib/include/descriptors/mpeg_ts.h b/lib/include/descriptors/mpeg_ts.h
new file mode 100644
index 0000000..54fee69
--- /dev/null
+++ b/lib/include/descriptors/mpeg_ts.h
@@ -0,0 +1,78 @@
+/*
+ * Copyright (c) 2013 - Andre Roth <neolynx@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation version 2
+ * of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
+ * Or, point your browser to http://www.gnu.org/licenses/old-licenses/gpl-2.0.html
+ *
+ */
+
+#ifndef _MPEG_TS_H
+#define _MPEG_TS_H
+
+#include <stdint.h>
+#include <unistd.h> /* ssize_t */
+
+#define DVB_MPEG_TS  0x47
+
+struct dvb_mpeg_ts_adaption {
+	uint8_t length;
+	struct {
+		uint8_t extension:1;
+		uint8_t private_data:1;
+		uint8_t splicing_point:1;
+		uint8_t OPCR:1;
+		uint8_t PCR:1;
+		uint8_t priority:1;
+		uint8_t random_access:1;
+		uint8_t discontinued:1;
+	} __attribute__((packed));
+
+} __attribute__((packed));
+
+struct dvb_mpeg_ts {
+	uint8_t sync_byte; // DVB_MPEG_TS
+	union {
+		uint16_t bitfield;
+		struct {
+			uint16_t pid:13;
+			uint16_t priority:1;
+			uint16_t payload_start:1;
+			uint16_t tei:1;
+		} __attribute__((packed));
+	};
+	struct {
+		uint8_t continuity_counter:4;
+		uint8_t adaptation_field:2;
+		uint8_t scrambling:2;
+	} __attribute__((packed));
+	struct dvb_mpeg_ts_adaption adaption[];
+
+} __attribute__((packed));
+
+struct dvb_v5_fe_parms;
+
+#ifdef __cplusplus
+extern "C" {
+#endif
+
+void dvb_mpeg_ts_init (struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, uint8_t *table, ssize_t *table_length);
+void dvb_mpeg_ts_free(struct dvb_mpeg_ts *ts);
+void dvb_mpeg_ts_print(struct dvb_v5_fe_parms *parms, struct dvb_mpeg_ts *ts);
+
+#ifdef __cplusplus
+}
+#endif
+
+#endif
diff --git a/lib/libdvbv5/Makefile.am b/lib/libdvbv5/Makefile.am
index 80e8adb..33693cc 100644
--- a/lib/libdvbv5/Makefile.am
+++ b/lib/libdvbv5/Makefile.am
@@ -49,7 +49,10 @@ libdvbv5_la_SOURCES = \
   descriptors/sdt.c  ../include/descriptors/sdt.h \
   descriptors/vct.c  ../include/descriptors/vct.h \
   descriptors/eit.c  ../include/descriptors/eit.h \
-  descriptors/desc_service_location.c  ../include/descriptors/desc_service_location.h
+  descriptors/desc_service_location.c  ../include/descriptors/desc_service_location.h \
+  descriptors/mpeg_ts.c  ../include/descriptors/mpeg_ts.h \
+  descriptors/mpeg_pes.c  ../include/descriptors/mpeg_pes.h \
+  descriptors/mpeg_es.c  ../include/descriptors/mpeg_es.h
 
 libdvbv5_la_CPPFLAGS = $(ENFORCE_LIBDVBV5_STATIC)
 libdvbv5_la_LDFLAGS = $(LIBDVBV5_VERSION) $(ENFORCE_LIBDVBV5_STATIC) -lm
diff --git a/lib/libdvbv5/descriptors/mpeg_es.c b/lib/libdvbv5/descriptors/mpeg_es.c
new file mode 100644
index 0000000..9fcb5ca
--- /dev/null
+++ b/lib/libdvbv5/descriptors/mpeg_es.c
@@ -0,0 +1,76 @@
+/*
+ * Copyright (c) 2013 - Andre Roth <neolynx@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation version 2
+ * of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
+ * Or, point your browser to http://www.gnu.org/licenses/old-licenses/gpl-2.0.html
+ *
+ */
+
+#include "descriptors/mpeg_es.h"
+#include "descriptors.h"
+#include "dvb-fe.h"
+
+int dvb_mpeg_es_seq_start_init(const uint8_t *buf, ssize_t buflen, struct dvb_mpeg_es_seq_start *seq_start)
+{
+	if(buflen < sizeof(struct dvb_mpeg_es_seq_start))
+		return -1;
+	memcpy(seq_start, buf, sizeof(struct dvb_mpeg_es_seq_start));
+	bswap32(seq_start->bitfield);
+	bswap32(seq_start->bitfield2);
+	bswap32(seq_start->bitfield3);
+	return 0;
+}
+
+void dvb_mpeg_es_seq_start_print(struct dvb_v5_fe_parms *parms, struct dvb_mpeg_es_seq_start *seq_start)
+{
+	dvb_log("MPEG ES SEQ START");
+        dvb_log(" - width       %d", seq_start->width);
+        dvb_log(" - height      %d", seq_start->height);
+        dvb_log(" - aspect      %d", seq_start->aspect);
+        dvb_log(" - framerate   %d", seq_start->framerate);
+        dvb_log(" - bitrate     %d", seq_start->bitrate);
+        dvb_log(" - one         %d", seq_start->one);
+        dvb_log(" - vbv         %d", seq_start->vbv);
+        dvb_log(" - constrained %d", seq_start->constrained);
+        dvb_log(" - qm_intra    %d", seq_start->qm_intra);
+        dvb_log(" - qm_nonintra %d", seq_start->qm_nonintra);
+}
+
+const char *dvb_mpeg_es_frame_names[5] = {
+	"?",
+	"I",
+	"P",
+	"B",
+	"D"
+};
+
+int dvb_mpeg_es_pic_start_init(const uint8_t *buf, ssize_t buflen, struct dvb_mpeg_es_pic_start *pic_start)
+{
+	if(buflen < sizeof(struct dvb_mpeg_es_pic_start))
+		return -1;
+	memcpy(pic_start, buf, sizeof(struct dvb_mpeg_es_pic_start));
+	bswap32(pic_start->bitfield);
+	bswap32(pic_start->bitfield2);
+	return 0;
+}
+
+void dvb_mpeg_es_pic_start_print(struct dvb_v5_fe_parms *parms, struct dvb_mpeg_es_pic_start *pic_start)
+{
+	dvb_log("MPEG ES PIC START");
+        dvb_log(" - temporal_ref %d", pic_start->temporal_ref);
+        dvb_log(" - coding_type  %d (%s-frame)", pic_start->coding_type, dvb_mpeg_es_frame_names[pic_start->coding_type]);
+        dvb_log(" - vbv_delay    %d", pic_start->vbv_delay);
+}
+
diff --git a/lib/libdvbv5/descriptors/mpeg_pes.c b/lib/libdvbv5/descriptors/mpeg_pes.c
new file mode 100644
index 0000000..1b518a3
--- /dev/null
+++ b/lib/libdvbv5/descriptors/mpeg_pes.c
@@ -0,0 +1,131 @@
+/*
+ * Copyright (c) 2013 - Andre Roth <neolynx@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation version 2
+ * of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
+ * Or, point your browser to http://www.gnu.org/licenses/old-licenses/gpl-2.0.html
+ *
+ */
+
+#include "descriptors/mpeg_pes.h"
+#include "descriptors.h"
+#include "dvb-fe.h"
+
+void dvb_mpeg_pes_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, uint8_t *table, ssize_t *table_length)
+{
+	struct dvb_mpeg_pes *pes = (struct dvb_mpeg_pes *) (table + *table_length);
+	const uint8_t *p = buf;
+	memcpy(table + *table_length, p, sizeof(struct dvb_mpeg_pes));
+	p += sizeof(struct dvb_mpeg_pes);
+	*table_length += sizeof(struct dvb_mpeg_pes);
+
+	bswap32(pes->bitfield);
+	bswap16(pes->length);
+
+	if (pes->sync != 0x000001 ) {
+		dvb_logerr("mpeg pes invalid");
+		return;
+	}
+
+	if (pes->stream_id == DVB_MPEG_STREAM_PADDING) {
+		dvb_logwarn("mpeg pes padding stream ignored");
+	} else if (pes->stream_id == DVB_MPEG_STREAM_MAP ||
+		   pes->stream_id == DVB_MPEG_STREAM_PRIVATE_2 ||
+		   pes->stream_id == DVB_MPEG_STREAM_ECM ||
+		   pes->stream_id == DVB_MPEG_STREAM_EMM ||
+		   pes->stream_id == DVB_MPEG_STREAM_DIRECTORY ||
+		   pes->stream_id == DVB_MPEG_STREAM_DSMCC ||
+		   pes->stream_id == DVB_MPEG_STREAM_H222E ) {
+		dvb_logerr("mpeg pes: unsupported stream type %#04x", pes->stream_id);
+	} else {
+		memcpy(pes->optional, p, sizeof(struct dvb_mpeg_pes_optional) -
+					 sizeof(pes->optional->pts) -
+					 sizeof(pes->optional->dts));
+		p += sizeof(struct dvb_mpeg_pes_optional) -
+		     sizeof(pes->optional->pts) -
+		     sizeof(pes->optional->dts);
+		bswap16(pes->optional->bitfield);
+		pes->optional->pts = 0;
+		pes->optional->dts = 0;
+		if (pes->optional->PTS_DTS & 2) {
+			struct ts_t pts;
+			memcpy(&pts, p, sizeof(pts));
+			p += sizeof(pts);
+			bswap16(pts.bitfield);
+			bswap16(pts.bitfield2);
+			if (pts.one != 1 || pts.one1 != 1 || pts.one2 != 1)
+				dvb_logwarn("mpeg pes: invalid pts");
+			else {
+				pes->optional->pts |= (uint64_t) pts.bits00;
+				pes->optional->pts |= (uint64_t) pts.bits15 << 15;
+				pes->optional->pts |= (uint64_t) pts.bits30 << 30;
+			}
+		}
+		if (pes->optional->PTS_DTS & 1) {
+			struct ts_t dts;
+			memcpy(&dts, p, sizeof(dts));
+			p += sizeof(dts);
+			bswap16(dts.bitfield);
+			bswap16(dts.bitfield2);
+			pes->optional->dts |= (uint64_t) dts.bits00;
+			pes->optional->dts |= (uint64_t) dts.bits15 << 15;
+			pes->optional->dts |= (uint64_t) dts.bits30 << 30;
+		}
+		*table_length += sizeof(struct dvb_mpeg_pes_optional);
+	}
+}
+
+void dvb_mpeg_pes_free(struct dvb_mpeg_pes *ts)
+{
+	free(ts);
+}
+
+void dvb_mpeg_pes_print(struct dvb_v5_fe_parms *parms, struct dvb_mpeg_pes *pes)
+{
+	dvb_log("MPEG PES");
+	dvb_log(" - sync      %#08x", pes->sync);
+	dvb_log(" - stream_id %#04x", pes->stream_id);
+	dvb_log(" - length    %d", pes->length);
+	if (pes->stream_id == DVB_MPEG_STREAM_PADDING) {
+	} else if (pes->stream_id == DVB_MPEG_STREAM_MAP ||
+		   pes->stream_id == DVB_MPEG_STREAM_PRIVATE_2 ||
+		   pes->stream_id == DVB_MPEG_STREAM_ECM ||
+		   pes->stream_id == DVB_MPEG_STREAM_EMM ||
+		   pes->stream_id == DVB_MPEG_STREAM_DIRECTORY ||
+		   pes->stream_id == DVB_MPEG_STREAM_DSMCC ||
+		   pes->stream_id == DVB_MPEG_STREAM_H222E ) {
+		dvb_log("  mpeg pes unsupported stream type %#04x", pes->stream_id);
+	} else {
+		dvb_log("  mpeg pes optional");
+		dvb_log("   - two                      %d", pes->optional->two);
+		dvb_log("   - PES_scrambling_control   %d", pes->optional->PES_scrambling_control);
+		dvb_log("   - PES_priority             %d", pes->optional->PES_priority);
+		dvb_log("   - data_alignment_indicator %d", pes->optional->data_alignment_indicator);
+		dvb_log("   - copyright                %d", pes->optional->copyright);
+		dvb_log("   - original_or_copy         %d", pes->optional->original_or_copy);
+		dvb_log("   - PTS_DTS                  %d", pes->optional->PTS_DTS);
+		dvb_log("   - ESCR                     %d", pes->optional->ESCR);
+		dvb_log("   - ES_rate                  %d", pes->optional->ES_rate);
+		dvb_log("   - DSM_trick_mode           %d", pes->optional->DSM_trick_mode);
+		dvb_log("   - additional_copy_info     %d", pes->optional->additional_copy_info);
+		dvb_log("   - PES_CRC                  %d", pes->optional->PES_CRC);
+		dvb_log("   - PES_extension            %d", pes->optional->PES_extension);
+		dvb_log("   - length                   %d", pes->optional->length);
+		if (pes->optional->PTS_DTS & 2)
+			dvb_log("   - pts                      %lx (%fs)", pes->optional->pts, (float) pes->optional->pts / 90000.0);
+		if (pes->optional->PTS_DTS & 1)
+			dvb_log("   - dts                      %lx (%fs)", pes->optional->dts, (float) pes->optional->dts/ 90000.0);
+	}
+}
+
diff --git a/lib/libdvbv5/descriptors/mpeg_ts.c b/lib/libdvbv5/descriptors/mpeg_ts.c
new file mode 100644
index 0000000..d7ec2c4
--- /dev/null
+++ b/lib/libdvbv5/descriptors/mpeg_ts.c
@@ -0,0 +1,77 @@
+/*
+ * Copyright (c) 2013 - Andre Roth <neolynx@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation version 2
+ * of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
+ * Or, point your browser to http://www.gnu.org/licenses/old-licenses/gpl-2.0.html
+ *
+ */
+
+#include "descriptors/mpeg_ts.h"
+#include "descriptors.h"
+#include "dvb-fe.h"
+
+void dvb_mpeg_ts_init(struct dvb_v5_fe_parms *parms, const uint8_t *buf, ssize_t buflen, uint8_t *table, ssize_t *table_length)
+{
+	if (buf[0] != DVB_MPEG_TS) {
+		dvb_logerr("mpeg ts invalid marker %#02x, sould be %#02x", buf[0], DVB_MPEG_TS);
+		*table_length = 0;
+		return;
+	}
+	struct dvb_mpeg_ts *ts = (struct dvb_mpeg_ts *) table;
+	const uint8_t *p = buf;
+	memcpy(table, p, sizeof(struct dvb_mpeg_ts));
+	p += sizeof(struct dvb_mpeg_ts);
+	*table_length = sizeof(struct dvb_mpeg_ts);
+
+	bswap16(ts->bitfield);
+
+	if (ts->adaptation_field & 0x2) {
+		memcpy(table + *table_length, p, sizeof(struct dvb_mpeg_ts_adaption));
+		p += sizeof(struct dvb_mpeg_ts);
+		*table_length += ts->adaption->length + 1;
+	}
+	/*hexdump(parms, "TS: ", buf, buflen);*/
+}
+
+void dvb_mpeg_ts_free(struct dvb_mpeg_ts *ts)
+{
+	free(ts);
+}
+
+void dvb_mpeg_ts_print(struct dvb_v5_fe_parms *parms, struct dvb_mpeg_ts *ts)
+{
+	dvb_log("MPEG TS");
+	dvb_log(" - sync byte          %#02x", ts->sync_byte);
+	dvb_log(" - tei                %d", ts->tei);
+	dvb_log(" - payload_start      %d", ts->payload_start);
+	dvb_log(" - priority           %d", ts->priority);
+	dvb_log(" - pid                %d", ts->pid);
+	dvb_log(" - scrambling         %d", ts->scrambling);
+	dvb_log(" - adaptation_field   %d", ts->adaptation_field);
+	dvb_log(" - continuity_counter %d", ts->continuity_counter);
+	if (ts->adaptation_field & 0x2) {
+		dvb_log(" Adaption Field");
+                dvb_log("   - length         %d", ts->adaption->length);
+                dvb_log("   - discontinued   %d", ts->adaption->discontinued);
+                dvb_log("   - random_access  %d", ts->adaption->random_access);
+                dvb_log("   - priority       %d", ts->adaption->priority);
+                dvb_log("   - PCR            %d", ts->adaption->PCR);
+                dvb_log("   - OPCR           %d", ts->adaption->OPCR);
+                dvb_log("   - splicing_point %d", ts->adaption->splicing_point);
+                dvb_log("   - private_data   %d", ts->adaption->private_data);
+                dvb_log("   - extension      %d", ts->adaption->extension);
+	}
+}
+
-- 
1.8.3.2

