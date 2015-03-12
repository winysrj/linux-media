Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48951 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753334AbbCLJ65 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Mar 2015 05:58:57 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: dri-devel@lists.freedesktop.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: David Airlie <airlied@linux.ie>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Boris Brezillion <boris.brezillon@free-electrons.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Steve Longerbeam <slongerbeam@gmail.com>,
	Russell King <rmk+kernel@arm.linux.org.uk>,
	Emil Renner Berthing <kernel@esmil.dk>,
	linux-media@vger.kernel.org, kernel@pengutronix.de,
	Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH v3 05/10] Add RGB666_1X24_CPADHI media bus format
Date: Thu, 12 Mar 2015 10:58:11 +0100
Message-Id: <1426154296-30665-6-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1426154296-30665-1-git-send-email-p.zabel@pengutronix.de>
References: <1426154296-30665-1-git-send-email-p.zabel@pengutronix.de>
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
Changes since v2:
 - Added explanation for component-wise padded format names (CPADHI/LO)
---
 Documentation/DocBook/media/v4l/subdev-formats.xml | 34 +++++++++++++++++++++-
 include/uapi/linux/media-bus-format.h              |  3 +-
 2 files changed, 35 insertions(+), 2 deletions(-)

diff --git a/Documentation/DocBook/media/v4l/subdev-formats.xml b/Documentation/DocBook/media/v4l/subdev-formats.xml
index 8d1f624..18b71af 100644
--- a/Documentation/DocBook/media/v4l/subdev-formats.xml
+++ b/Documentation/DocBook/media/v4l/subdev-formats.xml
@@ -91,7 +91,9 @@ see <xref linkend="colorspaces" />.</entry>
 	<listitem><para>For formats where the total number of bits per pixel is smaller
 	than the number of bus samples per pixel times the bus width, a padding
 	value stating if the bytes are padded in their most high order bits
-	(PADHI) or low order bits (PADLO).</para></listitem>
+	(PADHI) or low order bits (PADLO). A "C" prefix is used for component-wise
+	padding in the most high order bits (CPADHI) or low order bits (CPADLO)
+	of each separate component.</para></listitem>
 	<listitem><para>For formats where the number of bus samples per pixel is larger
 	than 1, an endianness value stating if the pixel is transferred MSB first
 	(BE) or LSB first (LE).</para></listitem>
@@ -480,6 +482,36 @@ see <xref linkend="colorspaces" />.</entry>
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
 	    <row id="MEDIA-BUS-FMT-BGR888-1X24">
 	      <entry>MEDIA_BUS_FMT_BGR888_1X24</entry>
 	      <entry>0x1013</entry>
diff --git a/include/uapi/linux/media-bus-format.h b/include/uapi/linux/media-bus-format.h
index 8dbf16c..83ea46f 100644
--- a/include/uapi/linux/media-bus-format.h
+++ b/include/uapi/linux/media-bus-format.h
@@ -33,7 +33,7 @@
 
 #define MEDIA_BUS_FMT_FIXED			0x0001
 
-/* RGB - next is	0x1015 */
+/* RGB - next is	0x1016 */
 #define MEDIA_BUS_FMT_RGB444_1X12		0x100e
 #define MEDIA_BUS_FMT_RGB444_2X8_PADHI_BE	0x1001
 #define MEDIA_BUS_FMT_RGB444_2X8_PADHI_LE	0x1002
@@ -45,6 +45,7 @@
 #define MEDIA_BUS_FMT_RGB565_2X8_BE		0x1007
 #define MEDIA_BUS_FMT_RGB565_2X8_LE		0x1008
 #define MEDIA_BUS_FMT_RGB666_1X18		0x1009
+#define MEDIA_BUS_FMT_RGB666_1X24_CPADHI	0x1015
 #define MEDIA_BUS_FMT_RGB666_1X7X3_SPWG		0x1010
 #define MEDIA_BUS_FMT_BGR888_1X24		0x1013
 #define MEDIA_BUS_FMT_GBR888_1X24		0x1014
-- 
2.1.4

