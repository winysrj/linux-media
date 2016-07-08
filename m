Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41414 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755334AbcGHNEE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jul 2016 09:04:04 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: corbet@lwn.net, markus.heiser@darmarIT.de,
	linux-doc@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 39/54] doc-rst: auto-generate ca.h.rst
Date: Fri,  8 Jul 2016 10:03:31 -0300
Message-Id: <34fb803092222d22073a6eed2fd7a7f7d2cda484.1467981855.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467981855.git.mchehab@s-opensource.com>
References: <cover.1467981855.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1467981855.git.mchehab@s-opensource.com>
References: <cover.1467981855.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This file comes from the uAPI definition header, and
should be auto-generated, to be in sync with Kernel changes.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/linux_tv/Makefile            |  5 +-
 Documentation/linux_tv/ca.h.rst            | 97 ------------------------------
 Documentation/linux_tv/ca.h.rst.exceptions | 24 ++++++++
 3 files changed, 28 insertions(+), 98 deletions(-)
 delete mode 100644 Documentation/linux_tv/ca.h.rst
 create mode 100644 Documentation/linux_tv/ca.h.rst.exceptions

diff --git a/Documentation/linux_tv/Makefile b/Documentation/linux_tv/Makefile
index 2eb958e91eab..7ee14195802f 100644
--- a/Documentation/linux_tv/Makefile
+++ b/Documentation/linux_tv/Makefile
@@ -3,11 +3,14 @@
 PARSER = ../sphinx/parse-headers.pl
 UAPI = ../../include/uapi/linux
 
-htmldocs: audio.h.rst dmx.h.rst frontend.h.rst
+htmldocs: audio.h.rst ca.h.rst dmx.h.rst frontend.h.rst
 
 audio.h.rst: ${PARSER} ${UAPI}/dvb/audio.h  audio.h.rst.exceptions
 	${PARSER} ${UAPI}/dvb/audio.h $@ audio.h.rst.exceptions
 
+ca.h.rst: ${PARSER} ${UAPI}/dvb/ca.h  ca.h.rst.exceptions
+	${PARSER} ${UAPI}/dvb/ca.h $@ ca.h.rst.exceptions
+
 dmx.h.rst: ${PARSER} ${UAPI}/dvb/dmx.h  dmx.h.rst.exceptions
 	${PARSER} ${UAPI}/dvb/dmx.h $@ dmx.h.rst.exceptions
 
diff --git a/Documentation/linux_tv/ca.h.rst b/Documentation/linux_tv/ca.h.rst
deleted file mode 100644
index e86e73510ffc..000000000000
--- a/Documentation/linux_tv/ca.h.rst
+++ /dev/null
@@ -1,97 +0,0 @@
-.. -*- coding: utf-8; mode: rst -*-
-
-file: ca.h
-==========
-
-.. code-block:: c
-
-    /*
-     * ca.h
-     *
-     * Copyright (C) 2000 Ralph  Metzler <ralph@convergence.de>
-     *                  & Marcus Metzler <marcus@convergence.de>
-     *                    for convergence integrated media GmbH
-     *
-     * This program is free software; you can redistribute it and/or
-     * modify it under the terms of the GNU General Lesser Public License
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
-    #ifndef _DVBCA_H_
-    #define _DVBCA_H_
-
-    /* slot interface types and info */
-
-    typedef struct ca_slot_info {
-	    int num;               /* slot number */
-
-	    int type;              /* CA interface this slot supports */
-    #define CA_CI            1     /* CI high level interface */
-    #define CA_CI_LINK       2     /* CI link layer level interface */
-    #define CA_CI_PHYS       4     /* CI physical layer level interface */
-    #define CA_DESCR         8     /* built-in descrambler */
-    #define CA_SC          128     /* simple smart card interface */
-
-	    unsigned int flags;
-    #define CA_CI_MODULE_PRESENT 1 /* module (or card) inserted */
-    #define CA_CI_MODULE_READY   2
-    } ca_slot_info_t;
-
-
-    /* descrambler types and info */
-
-    typedef struct ca_descr_info {
-	    unsigned int num;          /* number of available descramblers (keys) */
-	    unsigned int type;         /* type of supported scrambling system */
-    #define CA_ECD           1
-    #define CA_NDS           2
-    #define CA_DSS           4
-    } ca_descr_info_t;
-
-    typedef struct ca_caps {
-	    unsigned int slot_num;     /* total number of CA card and module slots */
-	    unsigned int slot_type;    /* OR of all supported types */
-	    unsigned int descr_num;    /* total number of descrambler slots (keys) */
-	    unsigned int descr_type;   /* OR of all supported types */
-    } ca_caps_t;
-
-    /* a message to/from a CI-CAM */
-    typedef struct ca_msg {
-	    unsigned int index;
-	    unsigned int type;
-	    unsigned int length;
-	    unsigned char msg[256];
-    } ca_msg_t;
-
-    typedef struct ca_descr {
-	    unsigned int index;
-	    unsigned int parity;    /* 0 == even, 1 == odd */
-	    unsigned char cw[8];
-    } ca_descr_t;
-
-    typedef struct ca_pid {
-	    unsigned int pid;
-	    int index;              /* -1 == disable*/
-    } ca_pid_t;
-
-    #define CA_RESET          _IO('o', 128)
-    #define CA_GET_CAP        _IOR('o', 129, ca_caps_t)
-    #define CA_GET_SLOT_INFO  _IOR('o', 130, ca_slot_info_t)
-    #define CA_GET_DESCR_INFO _IOR('o', 131, ca_descr_info_t)
-    #define CA_GET_MSG        _IOR('o', 132, ca_msg_t)
-    #define CA_SEND_MSG       _IOW('o', 133, ca_msg_t)
-    #define CA_SET_DESCR      _IOW('o', 134, ca_descr_t)
-    #define CA_SET_PID        _IOW('o', 135, ca_pid_t)
-
-    #endif
diff --git a/Documentation/linux_tv/ca.h.rst.exceptions b/Documentation/linux_tv/ca.h.rst.exceptions
new file mode 100644
index 000000000000..09c13be67527
--- /dev/null
+++ b/Documentation/linux_tv/ca.h.rst.exceptions
@@ -0,0 +1,24 @@
+# Ignore header name
+ignore define _DVBCA_H_
+
+# struct ca_slot_info defines
+replace define CA_CI ca-slot-info
+replace define CA_CI_LINK ca-slot-info
+replace define CA_CI_PHYS ca-slot-info
+replace define CA_DESCR ca-slot-info
+replace define CA_SC ca-slot-info
+replace define CA_CI_MODULE_PRESENT ca-slot-info
+replace define CA_CI_MODULE_READY ca-slot-info
+
+# struct ca_descr_info defines
+replace define CA_ECD ca-descr-info
+replace define CA_NDS ca-descr-info
+replace define CA_DSS ca-descr-info
+
+# some typedefs should point to struct/enums
+replace typedef ca_pid_t ca-pid
+replace typedef ca_slot_info_t ca-slot-info
+replace typedef ca_descr_info_t ca-descr-info
+replace typedef ca_caps_t ca-caps
+replace typedef ca_msg_t ca-msg
+replace typedef ca_descr_t ca-descr
-- 
2.7.4

