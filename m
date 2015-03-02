Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:56470 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753507AbbCBBtG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 1 Mar 2015 20:49:06 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Michal Simek <michal.simek@xilinx.com>,
	Chris Kohn <christian.kohn@xilinx.com>,
	Hyun Kwon <hyun.kwon@xilinx.com>
Subject: [PATCH v5 4/8] v4l: Add VUY8 24 bits bus format
Date: Mon,  2 Mar 2015 03:48:41 +0200
Message-Id: <1425260925-12064-5-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1425260925-12064-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1425260925-12064-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hyun Kwon <hyun.kwon@xilinx.com>

Add VUY8 24 bits bus format, V4L2_MBUS_FMT_VUY8_1X24.

Signed-off-by: Hyun Kwon <hyun.kwon@xilinx.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/DocBook/media/v4l/subdev-formats.xml | 30 ++++++++++++++++++++++
 include/uapi/linux/media-bus-format.h              |  3 ++-
 2 files changed, 32 insertions(+), 1 deletion(-)

diff --git a/Documentation/DocBook/media/v4l/subdev-formats.xml b/Documentation/DocBook/media/v4l/subdev-formats.xml
index 9bfd468..bc8d3fb 100644
--- a/Documentation/DocBook/media/v4l/subdev-formats.xml
+++ b/Documentation/DocBook/media/v4l/subdev-formats.xml
@@ -3015,6 +3015,36 @@ see <xref linkend="colorspaces" />.</entry>
 	      <entry>u<subscript>1</subscript></entry>
 	      <entry>u<subscript>0</subscript></entry>
 	    </row>
+	    <row id="MEDIA-BUS-FMT-VUY8-1X24">
+	      <entry>MEDIA_BUS_FMT_VUY8_1X24</entry>
+	      <entry>0x201a</entry>
+	      <entry></entry>
+	      &dash-ent-8;
+	      <entry>v<subscript>7</subscript></entry>
+	      <entry>v<subscript>6</subscript></entry>
+	      <entry>v<subscript>5</subscript></entry>
+	      <entry>v<subscript>4</subscript></entry>
+	      <entry>v<subscript>3</subscript></entry>
+	      <entry>v<subscript>2</subscript></entry>
+	      <entry>v<subscript>1</subscript></entry>
+	      <entry>v<subscript>0</subscript></entry>
+	      <entry>u<subscript>7</subscript></entry>
+	      <entry>u<subscript>6</subscript></entry>
+	      <entry>u<subscript>5</subscript></entry>
+	      <entry>u<subscript>4</subscript></entry>
+	      <entry>u<subscript>3</subscript></entry>
+	      <entry>u<subscript>2</subscript></entry>
+	      <entry>u<subscript>1</subscript></entry>
+	      <entry>u<subscript>0</subscript></entry>
+	      <entry>y<subscript>7</subscript></entry>
+	      <entry>y<subscript>6</subscript></entry>
+	      <entry>y<subscript>5</subscript></entry>
+	      <entry>y<subscript>4</subscript></entry>
+	      <entry>y<subscript>3</subscript></entry>
+	      <entry>y<subscript>2</subscript></entry>
+	      <entry>y<subscript>1</subscript></entry>
+	      <entry>y<subscript>0</subscript></entry>
+	    </row>
 	    <row id="MEDIA-BUS-FMT-UYVY12-1X24">
 	      <entry>MEDIA_BUS_FMT_UYVY12_1X24</entry>
 	      <entry>0x2020</entry>
diff --git a/include/uapi/linux/media-bus-format.h b/include/uapi/linux/media-bus-format.h
index 363a30f..d391893 100644
--- a/include/uapi/linux/media-bus-format.h
+++ b/include/uapi/linux/media-bus-format.h
@@ -50,7 +50,7 @@
 #define MEDIA_BUS_FMT_ARGB8888_1X32		0x100d
 #define MEDIA_BUS_FMT_RGB888_1X32_PADHI		0x100f
 
-/* YUV (including grey) - next is	0x2024 */
+/* YUV (including grey) - next is	0x2025 */
 #define MEDIA_BUS_FMT_Y8_1X8			0x2001
 #define MEDIA_BUS_FMT_UV8_1X8			0x2015
 #define MEDIA_BUS_FMT_UYVY8_1_5X8		0x2002
@@ -80,6 +80,7 @@
 #define MEDIA_BUS_FMT_VYUY10_1X20		0x201b
 #define MEDIA_BUS_FMT_YUYV10_1X20		0x200d
 #define MEDIA_BUS_FMT_YVYU10_1X20		0x200e
+#define MEDIA_BUS_FMT_VUY8_1X24			0x2024
 #define MEDIA_BUS_FMT_UYVY12_1X24		0x2020
 #define MEDIA_BUS_FMT_VYUY12_1X24		0x2021
 #define MEDIA_BUS_FMT_YUYV12_1X24		0x2022
-- 
2.0.5

