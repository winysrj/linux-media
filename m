Return-path: <linux-media-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:33628 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754815AbaKNKgF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Nov 2014 05:36:05 -0500
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH] [media] Add RGB444_1X12 and RGB565_1X16 media bus formats
Date: Fri, 14 Nov 2014 11:36:00 +0100
Message-Id: <1415961360-14898-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add RGB444_1X12 and RGB565_1X16 format definitions and update the
documentation.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
Acked-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
---
 Documentation/DocBook/media/v4l/subdev-formats.xml | 40 ++++++++++++++++++++++
 include/uapi/linux/media-bus-format.h              |  4 ++-
 2 files changed, 43 insertions(+), 1 deletion(-)

diff --git a/Documentation/DocBook/media/v4l/subdev-formats.xml b/Documentation/DocBook/media/v4l/subdev-formats.xml
index 18730b9..8c396db 100644
--- a/Documentation/DocBook/media/v4l/subdev-formats.xml
+++ b/Documentation/DocBook/media/v4l/subdev-formats.xml
@@ -563,6 +563,46 @@
 	      <entry>b<subscript>1</subscript></entry>
 	      <entry>b<subscript>0</subscript></entry>
 	    </row>
+	    <row id="MEDIA-BUS-FMT-RGB444-1X12">
+	      <entry>MEDIA_BUS_FMT_RGB444_1X12</entry>
+	      <entry>0x100d</entry>
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
+	    <row id="MEDIA-BUS-FMT-RGB565-1X16">
+	      <entry>MEDIA_BUS_FMT_RGB565_1X16</entry>
+	      <entry>0x100d</entry>
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
 	  </tbody>
 	</tgroup>
       </table>
diff --git a/include/uapi/linux/media-bus-format.h b/include/uapi/linux/media-bus-format.h
index 23b4090..cc7b79e 100644
--- a/include/uapi/linux/media-bus-format.h
+++ b/include/uapi/linux/media-bus-format.h
@@ -33,7 +33,7 @@
 
 #define MEDIA_BUS_FMT_FIXED			0x0001
 
-/* RGB - next is	0x100e */
+/* RGB - next is	0x1010 */
 #define MEDIA_BUS_FMT_RGB444_2X8_PADHI_BE	0x1001
 #define MEDIA_BUS_FMT_RGB444_2X8_PADHI_LE	0x1002
 #define MEDIA_BUS_FMT_RGB555_2X8_PADHI_BE	0x1003
@@ -47,6 +47,8 @@
 #define MEDIA_BUS_FMT_RGB888_2X12_BE		0x100b
 #define MEDIA_BUS_FMT_RGB888_2X12_LE		0x100c
 #define MEDIA_BUS_FMT_ARGB8888_1X32		0x100d
+#define MEDIA_BUS_FMT_RGB444_1X12		0x100e
+#define MEDIA_BUS_FMT_RGB565_1X16		0x100f
 
 /* YUV (including grey) - next is	0x2024 */
 #define MEDIA_BUS_FMT_Y8_1X8			0x2001
-- 
1.9.1

