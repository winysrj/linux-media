Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48972 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523AbbCLJ7c (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Mar 2015 05:59:32 -0400
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
Subject: [PATCH v3 01/10] Add RGB444_1X12 and RGB565_1X16 media bus formats
Date: Thu, 12 Mar 2015 10:58:07 +0100
Message-Id: <1426154296-30665-2-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1426154296-30665-1-git-send-email-p.zabel@pengutronix.de>
References: <1426154296-30665-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Boris Brezillion <boris.brezillon@free-electrons.com>

Add RGB444_1X12 and RGB565_1X16 format definitions and update the
documentation.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
Acked-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
---
 Documentation/DocBook/media/v4l/subdev-formats.xml | 40 ++++++++++++++++++++++
 include/uapi/linux/media-bus-format.h              |  4 ++-
 2 files changed, 43 insertions(+), 1 deletion(-)

diff --git a/Documentation/DocBook/media/v4l/subdev-formats.xml b/Documentation/DocBook/media/v4l/subdev-formats.xml
index c5ea868..29fe601 100644
--- a/Documentation/DocBook/media/v4l/subdev-formats.xml
+++ b/Documentation/DocBook/media/v4l/subdev-formats.xml
@@ -192,6 +192,24 @@ see <xref linkend="colorspaces" />.</entry>
 	    </row>
 	  </thead>
 	  <tbody valign="top">
+	    <row id="MEDIA-BUS-FMT-RGB444-1X12">
+	      <entry>MEDIA_BUS_FMT_RGB444_1X12</entry>
+	      <entry>0x100e</entry>
+	      <entry></entry>
+	      &dash-ent-20;
+	      <entry>r<subscript>3</subscript></entry>
+	      <entry>r<subscript>2</subscript></entry>
+	      <entry>r<subscript>1</subscript></entry>
+	      <entry>r<subscript>0</subscript></entry>
+	      <entry>g<subscript>3</subscript></entry>
+	      <entry>g<subscript>2</subscript></entry>
+	      <entry>g<subscript>1</subscript></entry>
+	      <entry>g<subscript>0</subscript></entry>
+	      <entry>b<subscript>3</subscript></entry>
+	      <entry>b<subscript>2</subscript></entry>
+	      <entry>b<subscript>1</subscript></entry>
+	      <entry>b<subscript>0</subscript></entry>
+	    </row>
 	    <row id="MEDIA-BUS-FMT-RGB444-2X8-PADHI-BE">
 	      <entry>MEDIA_BUS_FMT_RGB444_2X8_PADHI_BE</entry>
 	      <entry>0x1001</entry>
@@ -304,6 +322,28 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry>g<subscript>4</subscript></entry>
 	      <entry>g<subscript>3</subscript></entry>
 	    </row>
+	    <row id="MEDIA-BUS-FMT-RGB565-1X16">
+	      <entry>MEDIA_BUS_FMT_RGB565_1X16</entry>
+	      <entry>0x100f</entry>
+	      <entry></entry>
+	      &dash-ent-16;
+	      <entry>r<subscript>4</subscript></entry>
+	      <entry>r<subscript>3</subscript></entry>
+	      <entry>r<subscript>2</subscript></entry>
+	      <entry>r<subscript>1</subscript></entry>
+	      <entry>r<subscript>0</subscript></entry>
+	      <entry>g<subscript>5</subscript></entry>
+	      <entry>g<subscript>4</subscript></entry>
+	      <entry>g<subscript>3</subscript></entry>
+	      <entry>g<subscript>2</subscript></entry>
+	      <entry>g<subscript>1</subscript></entry>
+	      <entry>g<subscript>0</subscript></entry>
+	      <entry>b<subscript>4</subscript></entry>
+	      <entry>b<subscript>3</subscript></entry>
+	      <entry>b<subscript>2</subscript></entry>
+	      <entry>b<subscript>1</subscript></entry>
+	      <entry>b<subscript>0</subscript></entry>
+	    </row>
 	    <row id="MEDIA-BUS-FMT-BGR565-2X8-BE">
 	      <entry>MEDIA_BUS_FMT_BGR565_2X8_BE</entry>
 	      <entry>0x1005</entry>
diff --git a/include/uapi/linux/media-bus-format.h b/include/uapi/linux/media-bus-format.h
index 23b4090..37091c6 100644
--- a/include/uapi/linux/media-bus-format.h
+++ b/include/uapi/linux/media-bus-format.h
@@ -33,11 +33,13 @@
 
 #define MEDIA_BUS_FMT_FIXED			0x0001
 
-/* RGB - next is	0x100e */
+/* RGB - next is	0x1010 */
+#define MEDIA_BUS_FMT_RGB444_1X12		0x100e
 #define MEDIA_BUS_FMT_RGB444_2X8_PADHI_BE	0x1001
 #define MEDIA_BUS_FMT_RGB444_2X8_PADHI_LE	0x1002
 #define MEDIA_BUS_FMT_RGB555_2X8_PADHI_BE	0x1003
 #define MEDIA_BUS_FMT_RGB555_2X8_PADHI_LE	0x1004
+#define MEDIA_BUS_FMT_RGB565_1X16		0x100f
 #define MEDIA_BUS_FMT_BGR565_2X8_BE		0x1005
 #define MEDIA_BUS_FMT_BGR565_2X8_LE		0x1006
 #define MEDIA_BUS_FMT_RGB565_2X8_BE		0x1007
-- 
2.1.4

