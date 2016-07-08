Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41423 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755353AbcGHNEE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jul 2016 09:04:04 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: corbet@lwn.net, markus.heiser@darmarIT.de,
	linux-doc@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 37/54] doc-rst: auto-generate dmx.h.rst
Date: Fri,  8 Jul 2016 10:03:29 -0300
Message-Id: <ada66bc10535e16734958862914184d0fa0715ba.1467981855.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467981855.git.mchehab@s-opensource.com>
References: <cover.1467981855.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467981855.git.mchehab@s-opensource.com>
References: <cover.1467981855.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This file should be auto-generated from the header files,
and not hardcoded.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/linux_tv/Makefile             |   5 +-
 Documentation/linux_tv/dmx.h.rst            | 162 ----------------------------
 Documentation/linux_tv/dmx.h.rst.exceptions |  63 +++++++++++
 3 files changed, 67 insertions(+), 163 deletions(-)
 delete mode 100644 Documentation/linux_tv/dmx.h.rst
 create mode 100644 Documentation/linux_tv/dmx.h.rst.exceptions

diff --git a/Documentation/linux_tv/Makefile b/Documentation/linux_tv/Makefile
index d5570193ea30..2ef624e40bd9 100644
--- a/Documentation/linux_tv/Makefile
+++ b/Documentation/linux_tv/Makefile
@@ -3,10 +3,13 @@
 PARSER = ../sphinx/parse-headers.pl
 UAPI = ../../include/uapi/linux
 
-htmldocs: frontend.h.rst
+htmldocs: frontend.h.rst dmx.h.rst
 
 frontend.h.rst: ${PARSER} ${UAPI}/dvb/frontend.h  frontend.h.rst.exceptions
 	${PARSER} ${UAPI}/dvb/frontend.h $@ frontend.h.rst.exceptions
 
+dmx.h.rst: ${PARSER} ${UAPI}/dvb/dmx.h  dmx.h.rst.exceptions
+	${PARSER} ${UAPI}/dvb/dmx.h $@ dmx.h.rst.exceptions
+
 clean:
 	-rm frontend.h.rst
diff --git a/Documentation/linux_tv/dmx.h.rst b/Documentation/linux_tv/dmx.h.rst
deleted file mode 100644
index 05686c09aebc..000000000000
--- a/Documentation/linux_tv/dmx.h.rst
+++ /dev/null
@@ -1,162 +0,0 @@
-.. -*- coding: utf-8; mode: rst -*-
-
-file: dmx.h
-===========
-
-.. code-block:: c
-
-    /*
-     * dmx.h
-     *
-     * Copyright (C) 2000 Marcus Metzler <marcus@convergence.de>
-     *                  & Ralph  Metzler <ralph@convergence.de>
-     *                    for convergence integrated media GmbH
-     *
-     * This program is free software; you can redistribute it and/or
-     * modify it under the terms of the GNU Lesser General Public License
-     * as published by the Free Software Foundation; either version 2.1
-     * of the License, or (at your option) any later version.
-     *
-     * This program is distributed in the hope that it will be useful,
-     * but WITHOUT ANY WARRANTY; without even the implied warranty of
-     * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-     * GNU General Public License for more details.
-     *
-     * You should have received a copy of the GNU Lesser General Public License
-     * along with this program; if not, write to the Free Software
-     * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
-     *
-     */
-
-    #ifndef _UAPI_DVBDMX_H_
-    #define _UAPI_DVBDMX_H_
-
-    #include <linux/types.h>
-    #ifndef __KERNEL__
-    #include <time.h>
-    #endif
-
-
-    #define DMX_FILTER_SIZE 16
-
-    enum dmx_output
-    {
-	    DMX_OUT_DECODER, /* Streaming directly to decoder. */
-	    DMX_OUT_TAP,     /* Output going to a memory buffer */
-			     /* (to be retrieved via the read command).*/
-	    DMX_OUT_TS_TAP,  /* Output multiplexed into a new TS  */
-			     /* (to be retrieved by reading from the */
-			     /* logical DVR device).                 */
-	    DMX_OUT_TSDEMUX_TAP /* Like TS_TAP but retrieved from the DMX device */
-    };
-
-    typedef enum dmx_output dmx_output_t;
-
-    typedef enum dmx_input
-    {
-	    DMX_IN_FRONTEND, /* Input from a front-end device.  */
-	    DMX_IN_DVR       /* Input from the logical DVR device.  */
-    } dmx_input_t;
-
-
-    typedef enum dmx_ts_pes
-    {
-	    DMX_PES_AUDIO0,
-	    DMX_PES_VIDEO0,
-	    DMX_PES_TELETEXT0,
-	    DMX_PES_SUBTITLE0,
-	    DMX_PES_PCR0,
-
-	    DMX_PES_AUDIO1,
-	    DMX_PES_VIDEO1,
-	    DMX_PES_TELETEXT1,
-	    DMX_PES_SUBTITLE1,
-	    DMX_PES_PCR1,
-
-	    DMX_PES_AUDIO2,
-	    DMX_PES_VIDEO2,
-	    DMX_PES_TELETEXT2,
-	    DMX_PES_SUBTITLE2,
-	    DMX_PES_PCR2,
-
-	    DMX_PES_AUDIO3,
-	    DMX_PES_VIDEO3,
-	    DMX_PES_TELETEXT3,
-	    DMX_PES_SUBTITLE3,
-	    DMX_PES_PCR3,
-
-	    DMX_PES_OTHER
-    } dmx_pes_type_t;
-
-    #define DMX_PES_AUDIO    DMX_PES_AUDIO0
-    #define DMX_PES_VIDEO    DMX_PES_VIDEO0
-    #define DMX_PES_TELETEXT DMX_PES_TELETEXT0
-    #define DMX_PES_SUBTITLE DMX_PES_SUBTITLE0
-    #define DMX_PES_PCR      DMX_PES_PCR0
-
-
-    typedef struct dmx_filter
-    {
-	    __u8  filter[DMX_FILTER_SIZE];
-	    __u8  mask[DMX_FILTER_SIZE];
-	    __u8  mode[DMX_FILTER_SIZE];
-    } dmx_filter_t;
-
-
-    struct dmx_sct_filter_params
-    {
-	    __u16          pid;
-	    dmx_filter_t   filter;
-	    __u32          timeout;
-	    __u32          flags;
-    #define DMX_CHECK_CRC       1
-    #define DMX_ONESHOT         2
-    #define DMX_IMMEDIATE_START 4
-    #define DMX_KERNEL_CLIENT   0x8000
-    };
-
-
-    struct dmx_pes_filter_params
-    {
-	    __u16          pid;
-	    dmx_input_t    input;
-	    dmx_output_t   output;
-	    dmx_pes_type_t pes_type;
-	    __u32          flags;
-    };
-
-    typedef struct dmx_caps {
-	    __u32 caps;
-	    int num_decoders;
-    } dmx_caps_t;
-
-    typedef enum dmx_source {
-	    DMX_SOURCE_FRONT0 = 0,
-	    DMX_SOURCE_FRONT1,
-	    DMX_SOURCE_FRONT2,
-	    DMX_SOURCE_FRONT3,
-	    DMX_SOURCE_DVR0   = 16,
-	    DMX_SOURCE_DVR1,
-	    DMX_SOURCE_DVR2,
-	    DMX_SOURCE_DVR3
-    } dmx_source_t;
-
-    struct dmx_stc {
-	    unsigned int num;       /* input : which STC? 0..N */
-	    unsigned int base;      /* output: divisor for stc to get 90 kHz clock */
-	    __u64 stc;              /* output: stc in 'base'*90 kHz units */
-    };
-
-    #define DMX_START                _IO('o', 41)
-    #define DMX_STOP                 _IO('o', 42)
-    #define DMX_SET_FILTER           _IOW('o', 43, struct dmx_sct_filter_params)
-    #define DMX_SET_PES_FILTER       _IOW('o', 44, struct dmx_pes_filter_params)
-    #define DMX_SET_BUFFER_SIZE      _IO('o', 45)
-    #define DMX_GET_PES_PIDS         _IOR('o', 47, __u16[5])
-    #define DMX_GET_CAPS             _IOR('o', 48, dmx_caps_t)
-    #define DMX_SET_SOURCE           _IOW('o', 49, dmx_source_t)
-    #define DMX_GET_STC              _IOWR('o', 50, struct dmx_stc)
-    #define DMX_ADD_PID              _IOW('o', 51, __u16)
-    #define DMX_REMOVE_PID           _IOW('o', 52, __u16)
-
-    #endif /* _UAPI_DVBDMX_H_ */
diff --git a/Documentation/linux_tv/dmx.h.rst.exceptions b/Documentation/linux_tv/dmx.h.rst.exceptions
new file mode 100644
index 000000000000..8200653839d2
--- /dev/null
+++ b/Documentation/linux_tv/dmx.h.rst.exceptions
@@ -0,0 +1,63 @@
+# Ignore header name
+ignore define _UAPI_DVBDMX_H_
+
+# Ignore limit constants
+ignore define DMX_FILTER_SIZE
+
+# dmx-pes-type-t enum symbols
+replace enum dmx_ts_pes dmx-pes-type-t
+replace symbol DMX_PES_AUDIO0 dmx-pes-type-t
+replace symbol DMX_PES_VIDEO0 dmx-pes-type-t
+replace symbol DMX_PES_TELETEXT0 dmx-pes-type-t
+replace symbol DMX_PES_SUBTITLE0 dmx-pes-type-t
+replace symbol DMX_PES_PCR0 dmx-pes-type-t
+replace symbol DMX_PES_AUDIO1 dmx-pes-type-t
+replace symbol DMX_PES_VIDEO1 dmx-pes-type-t
+replace symbol DMX_PES_TELETEXT1 dmx-pes-type-t
+replace symbol DMX_PES_SUBTITLE1 dmx-pes-type-t
+replace symbol DMX_PES_PCR1 dmx-pes-type-t
+replace symbol DMX_PES_AUDIO2 dmx-pes-type-t
+replace symbol DMX_PES_VIDEO2 dmx-pes-type-t
+replace symbol DMX_PES_TELETEXT2 dmx-pes-type-t
+replace symbol DMX_PES_SUBTITLE2 dmx-pes-type-t
+replace symbol DMX_PES_PCR2 dmx-pes-type-t
+replace symbol DMX_PES_AUDIO3 dmx-pes-type-t
+replace symbol DMX_PES_VIDEO3 dmx-pes-type-t
+replace symbol DMX_PES_TELETEXT3 dmx-pes-type-t
+replace symbol DMX_PES_SUBTITLE3 dmx-pes-type-t
+replace symbol DMX_PES_PCR3 dmx-pes-type-t
+replace symbol DMX_PES_OTHER dmx-pes-type-t
+
+# Ignore obsolete symbols
+ignore define DMX_PES_AUDIO
+ignore define DMX_PES_VIDEO
+ignore define DMX_PES_TELETEXT
+ignore define DMX_PES_SUBTITLE
+ignore define DMX_PES_PCR
+
+# dmx_input_t symbols
+replace enum dmx_input dmx-input-t
+replace symbol DMX_IN_FRONTEND dmx-input-t
+replace symbol DMX_IN_DVR dmx-input-t
+
+# dmx_source_t symbols
+replace enum dmx_source dmx-source-t
+replace symbol DMX_SOURCE_FRONT0 dmx-source-t
+replace symbol DMX_SOURCE_FRONT1 dmx-source-t
+replace symbol DMX_SOURCE_FRONT2 dmx-source-t
+replace symbol DMX_SOURCE_FRONT3 dmx-source-t
+replace symbol DMX_SOURCE_DVR0 dmx-source-t
+replace symbol DMX_SOURCE_DVR1 dmx-source-t
+replace symbol DMX_SOURCE_DVR2 dmx-source-t
+replace symbol DMX_SOURCE_DVR3 dmx-source-t
+
+
+# Flags for struct dmx_sct_filter_params
+replace define DMX_CHECK_CRC dmx-sct-filter-params
+replace define DMX_ONESHOT dmx-sct-filter-params
+replace define DMX_IMMEDIATE_START dmx-sct-filter-params
+replace define DMX_KERNEL_CLIENT dmx-sct-filter-params
+
+# some typedefs should point to struct/enums
+replace typedef dmx_caps_t dmx-caps
+replace typedef dmx_filter_t dmx-filter
-- 
2.7.4

