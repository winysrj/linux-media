Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48947 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582AbbCLJ65 (ORCPT
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
Subject: [PATCH v3 04/10] Add YUV8_1X24 media bus format
Date: Thu, 12 Mar 2015 10:58:10 +0100
Message-Id: <1426154296-30665-5-git-send-email-p.zabel@pengutronix.de>
In-Reply-To: <1426154296-30665-1-git-send-email-p.zabel@pengutronix.de>
References: <1426154296-30665-1-git-send-email-p.zabel@pengutronix.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds the media bus format for a 24-bit bus format with three
8-bit YUV components.

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 Documentation/DocBook/media/v4l/subdev-formats.xml | 37 ++++++++++++++++++++++
 include/uapi/linux/media-bus-format.h              |  3 +-
 2 files changed, 39 insertions(+), 1 deletion(-)

diff --git a/Documentation/DocBook/media/v4l/subdev-formats.xml b/Documentation/DocBook/media/v4l/subdev-formats.xml
index 805cbe1..8d1f624 100644
--- a/Documentation/DocBook/media/v4l/subdev-formats.xml
+++ b/Documentation/DocBook/media/v4l/subdev-formats.xml
@@ -3015,6 +3015,43 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry>u<subscript>1</subscript></entry>
 	      <entry>u<subscript>0</subscript></entry>
 	    </row>
+	    <row id="MEDIA-BUS-FMT-YUV8-1X24">
+	      <entry>MEDIA_BUS_FMT_YUV8_1X24</entry>
+	      <entry>0x2024</entry>
+	      <entry></entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>-</entry>
+	      <entry>y<subscript>7</subscript></entry>
+	      <entry>y<subscript>6</subscript></entry>
+	      <entry>y<subscript>5</subscript></entry>
+	      <entry>y<subscript>4</subscript></entry>
+	      <entry>y<subscript>3</subscript></entry>
+	      <entry>y<subscript>2</subscript></entry>
+	      <entry>y<subscript>1</subscript></entry>
+	      <entry>y<subscript>0</subscript></entry>
+	      <entry>u<subscript>7</subscript></entry>
+	      <entry>u<subscript>6</subscript></entry>
+	      <entry>u<subscript>5</subscript></entry>
+	      <entry>u<subscript>4</subscript></entry>
+	      <entry>u<subscript>3</subscript></entry>
+	      <entry>u<subscript>2</subscript></entry>
+	      <entry>u<subscript>1</subscript></entry>
+	      <entry>u<subscript>0</subscript></entry>
+	      <entry>v<subscript>7</subscript></entry>
+	      <entry>v<subscript>6</subscript></entry>
+	      <entry>v<subscript>5</subscript></entry>
+	      <entry>v<subscript>4</subscript></entry>
+	      <entry>v<subscript>3</subscript></entry>
+	      <entry>v<subscript>2</subscript></entry>
+	      <entry>v<subscript>1</subscript></entry>
+	      <entry>v<subscript>0</subscript></entry>
+	    </row>
 	    <row id="MEDIA-BUS-FMT-YUV10-1X30">
 	      <entry>MEDIA_BUS_FMT_YUV10_1X30</entry>
 	      <entry>0x2016</entry>
diff --git a/include/uapi/linux/media-bus-format.h b/include/uapi/linux/media-bus-format.h
index 6f6942e..8dbf16c 100644
--- a/include/uapi/linux/media-bus-format.h
+++ b/include/uapi/linux/media-bus-format.h
@@ -55,7 +55,7 @@
 #define MEDIA_BUS_FMT_RGB888_1X7X4_JEIDA	0x1012
 #define MEDIA_BUS_FMT_ARGB8888_1X32		0x100d
 
-/* YUV (including grey) - next is	0x2024 */
+/* YUV (including grey) - next is	0x2025 */
 #define MEDIA_BUS_FMT_Y8_1X8			0x2001
 #define MEDIA_BUS_FMT_UV8_1X8			0x2015
 #define MEDIA_BUS_FMT_UYVY8_1_5X8		0x2002
@@ -81,6 +81,7 @@
 #define MEDIA_BUS_FMT_VYUY10_1X20		0x201b
 #define MEDIA_BUS_FMT_YUYV10_1X20		0x200d
 #define MEDIA_BUS_FMT_YVYU10_1X20		0x200e
+#define MEDIA_BUS_FMT_YUV8_1X24			0x2024
 #define MEDIA_BUS_FMT_YUV10_1X30		0x2016
 #define MEDIA_BUS_FMT_AYUV8_1X32		0x2017
 #define MEDIA_BUS_FMT_UYVY12_2X12		0x201c
-- 
2.1.4

