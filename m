Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41401 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755305AbcGHNEE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jul 2016 09:04:04 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: corbet@lwn.net, markus.heiser@darmarIT.de,
	linux-doc@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 40/54] doc-rst: auto-generate net.h.rst
Date: Fri,  8 Jul 2016 10:03:32 -0300
Message-Id: <0c02966b1338478d6a216824376c2eee0aae78d0.1467981855.git.mchehab@s-opensource.com>
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
 Documentation/linux_tv/Makefile             | 10 +++--
 Documentation/linux_tv/net.h.rst            | 59 -----------------------------
 Documentation/linux_tv/net.h.rst.exceptions | 11 ++++++
 3 files changed, 18 insertions(+), 62 deletions(-)
 delete mode 100644 Documentation/linux_tv/net.h.rst
 create mode 100644 Documentation/linux_tv/net.h.rst.exceptions

diff --git a/Documentation/linux_tv/Makefile b/Documentation/linux_tv/Makefile
index 7ee14195802f..4ec743449776 100644
--- a/Documentation/linux_tv/Makefile
+++ b/Documentation/linux_tv/Makefile
@@ -2,8 +2,9 @@
 
 PARSER = ../sphinx/parse-headers.pl
 UAPI = ../../include/uapi/linux
+TARGETS = audio.h.rst ca.h.rst dmx.h.rst frontend.h.rst net.h.rst
 
-htmldocs: audio.h.rst ca.h.rst dmx.h.rst frontend.h.rst
+htmldocs: ${TARGETS}
 
 audio.h.rst: ${PARSER} ${UAPI}/dvb/audio.h  audio.h.rst.exceptions
 	${PARSER} ${UAPI}/dvb/audio.h $@ audio.h.rst.exceptions
@@ -17,5 +18,8 @@ dmx.h.rst: ${PARSER} ${UAPI}/dvb/dmx.h  dmx.h.rst.exceptions
 frontend.h.rst: ${PARSER} ${UAPI}/dvb/frontend.h  frontend.h.rst.exceptions
 	${PARSER} ${UAPI}/dvb/frontend.h $@ frontend.h.rst.exceptions
 
-clean:
-	-rm frontend.h.rst
+net.h.rst: ${PARSER} ${UAPI}/dvb/net.h  net.h.rst.exceptions
+	${PARSER} ${UAPI}/dvb/net.h $@ net.h.rst.exceptions
+
+cleandocs:
+	-rm ${TARGETS}
diff --git a/Documentation/linux_tv/net.h.rst b/Documentation/linux_tv/net.h.rst
deleted file mode 100644
index 9b0f705c634b..000000000000
--- a/Documentation/linux_tv/net.h.rst
+++ /dev/null
@@ -1,59 +0,0 @@
-.. -*- coding: utf-8; mode: rst -*-
-
-file: net.h
-===========
-
-.. code-block:: c
-
-    /*
-     * net.h
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
-    #ifndef _DVBNET_H_
-    #define _DVBNET_H_
-
-    #include <linux/types.h>
-
-    struct dvb_net_if {
-	    __u16 pid;
-	    __u16 if_num;
-	    __u8  feedtype;
-    #define DVB_NET_FEEDTYPE_MPE 0  /* multi protocol encapsulation */
-    #define DVB_NET_FEEDTYPE_ULE 1  /* ultra lightweight encapsulation */
-    };
-
-
-    #define NET_ADD_IF    _IOWR('o', 52, struct dvb_net_if)
-    #define NET_REMOVE_IF _IO('o', 53)
-    #define NET_GET_IF    _IOWR('o', 54, struct dvb_net_if)
-
-
-    /* binary compatibility cruft: */
-    struct __dvb_net_if_old {
-	    __u16 pid;
-	    __u16 if_num;
-    };
-    #define __NET_ADD_IF_OLD _IOWR('o', 52, struct __dvb_net_if_old)
-    #define __NET_GET_IF_OLD _IOWR('o', 54, struct __dvb_net_if_old)
-
-
-    #endif /*_DVBNET_H_*/
diff --git a/Documentation/linux_tv/net.h.rst.exceptions b/Documentation/linux_tv/net.h.rst.exceptions
new file mode 100644
index 000000000000..30a267483aa9
--- /dev/null
+++ b/Documentation/linux_tv/net.h.rst.exceptions
@@ -0,0 +1,11 @@
+# Ignore header name
+ignore define _DVBNET_H_
+
+# Ignore old ioctls/structs
+ignore ioctl __NET_ADD_IF_OLD
+ignore ioctl __NET_GET_IF_OLD
+ignore struct __dvb_net_if_old
+
+# Macros used at struct dvb_net_if
+replace define DVB_NET_FEEDTYPE_MPE dvb-net-if
+replace define DVB_NET_FEEDTYPE_ULE dvb-net-if
-- 
2.7.4

