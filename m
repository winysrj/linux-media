Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52921 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924AbaLCK23 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Dec 2014 05:28:29 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Boris Brezillon <boris.brezillon@free-electrons.com>,
	linux-media@vger.kernel.org, kernel@pengutronix.de,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Emil Renner Berthing <kernel@esmil.dk>
Subject: [PATCH 3/3] Add RGB666_1X24_CPADHI media bus format
Date: Wed,  3 Dec 2014 11:28:20 +0100
Message-Id: <1417602500-29152-3-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1417602500-29152-1-git-send-email-p.zabel@pengutronix.de>
References: <1417602500-29152-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Commit 9e74d2926a28 ("staging: imx-drm: add LVDS666 support for parallel
display") describes a 24-bit bus format where three 6-bit components each
take the lower part of 8 bits with the two high bits zero padded. Add a
component-wise padded media bus format RGB666_1X24_CPADHI to support this
connection.

Cc: Emil Renner Berthing <kernel@esmil.dk>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 Documentation/DocBook/media/v4l/subdev-formats.xml | 30 ++++++++++++++++++++++
 include/uapi/linux/media-bus-format.h              |  1 +
 2 files changed, 31 insertions(+)

diff --git a/Documentation/DocBook/media/v4l/subdev-formats.xml b/Documentation/DocBook/media/v4l/subdev-formats.xml
index 9afb846..c259b9e 100644
--- a/Documentation/DocBook/media/v4l/subdev-formats.xml
+++ b/Documentation/DocBook/media/v4l/subdev-formats.xml
@@ -469,6 +469,36 @@
 	      <entry>b<subscript>1</subscript></entry>
 	      <entry>b<subscript>0</subscript></entry>
 	    </row>
+	    <row id="MEDIA-BUS-FMT-RGB666-1X24_CPADHI">
+	      <entry>MEDIA_BUS_FMT_RGB666_1X24_CPADHI</entry>
+	      <entry>0x1015</entry>
+	      <entry></entry>
+	      &dash-ent-8;
+	      <entry>0</entry>
+	      <entry>0</entry>
+	      <entry>r<subscript>5</subscript></entry>
+	      <entry>r<subscript>4</subscript></entry>
+	      <entry>r<subscript>3</subscript></entry>
+	      <entry>r<subscript>2</subscript></entry>
+	      <entry>r<subscript>1</subscript></entry>
+	      <entry>r<subscript>0</subscript></entry>
+	      <entry>0</entry>
+	      <entry>0</entry>
+	      <entry>g<subscript>5</subscript></entry>
+	      <entry>g<subscript>4</subscript></entry>
+	      <entry>g<subscript>3</subscript></entry>
+	      <entry>g<subscript>2</subscript></entry>
+	      <entry>g<subscript>1</subscript></entry>
+	      <entry>g<subscript>0</subscript></entry>
+	      <entry>0</entry>
+	      <entry>0</entry>
+	      <entry>b<subscript>5</subscript></entry>
+	      <entry>b<subscript>4</subscript></entry>
+	      <entry>b<subscript>3</subscript></entry>
+	      <entry>b<subscript>2</subscript></entry>
+	      <entry>b<subscript>1</subscript></entry>
+	      <entry>b<subscript>0</subscript></entry>
+	    </row>
 	    <row id="MEDIA-BUS-FMT-RGB888-1X24">
 	      <entry>MEDIA_BUS_FMT_RGB888_1X24</entry>
 	      <entry>0x100a</entry>
diff --git a/include/uapi/linux/media-bus-format.h b/include/uapi/linux/media-bus-format.h
index 977316e..ec80fb8 100644
--- a/include/uapi/linux/media-bus-format.h
+++ b/include/uapi/linux/media-bus-format.h
@@ -45,6 +45,7 @@
 #define MEDIA_BUS_FMT_RGB565_2X8_BE		0x1007
 #define MEDIA_BUS_FMT_RGB565_2X8_LE		0x1008
 #define MEDIA_BUS_FMT_RGB666_1X18		0x1009
+#define MEDIA_BUS_FMT_RGB666_1X24_CPADHI	0x1015
 #define MEDIA_BUS_FMT_RGB666_LVDS_SPWG		0x1010
 #define MEDIA_BUS_FMT_RGB888_1X24		0x100a
 #define MEDIA_BUS_FMT_BGR888_1X24		0x1013
-- 
2.1.3

