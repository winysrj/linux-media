Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:53331 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161AbaKBOxd (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 2 Nov 2014 09:53:33 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Michal Simek <michal.simek@xilinx.com>,
	Chris Kohn <christian.kohn@xilinx.com>,
	Hyun Kwon <hyun.kwon@xilinx.com>
Subject: [PATCH v2 02/13] v4l: Add RBG and RGB 8:8:8 media bus formats on 24 and 32 bit busses
Date: Sun,  2 Nov 2014 16:53:27 +0200
Message-Id: <1414940018-3016-3-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1414940018-3016-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1414940018-3016-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 Documentation/DocBook/media/v4l/subdev-formats.xml | 67 ++++++++++++++++++++++
 include/uapi/linux/v4l2-mediabus.h                 |  4 +-
 2 files changed, 70 insertions(+), 1 deletion(-)

diff --git a/Documentation/DocBook/media/v4l/subdev-formats.xml b/Documentation/DocBook/media/v4l/subdev-formats.xml
index b2d5a03..d0fb3c7 100644
--- a/Documentation/DocBook/media/v4l/subdev-formats.xml
+++ b/Documentation/DocBook/media/v4l/subdev-formats.xml
@@ -424,6 +424,36 @@
 	      <entry>b<subscript>1</subscript></entry>
 	      <entry>b<subscript>0</subscript></entry>
 	    </row>
+	    <row id="V4L2-MBUS-FMT-RBG888-1X24">
+	      <entry>V4L2_MBUS_FMT_RBG888_1X24</entry>
+	      <entry>0x100e</entry>
+	      <entry></entry>
+	      &dash-ent-8;
+	      <entry>r<subscript>7</subscript></entry>
+	      <entry>r<subscript>6</subscript></entry>
+	      <entry>r<subscript>5</subscript></entry>
+	      <entry>r<subscript>4</subscript></entry>
+	      <entry>r<subscript>3</subscript></entry>
+	      <entry>r<subscript>2</subscript></entry>
+	      <entry>r<subscript>1</subscript></entry>
+	      <entry>r<subscript>0</subscript></entry>
+	      <entry>b<subscript>7</subscript></entry>
+	      <entry>b<subscript>6</subscript></entry>
+	      <entry>b<subscript>5</subscript></entry>
+	      <entry>b<subscript>4</subscript></entry>
+	      <entry>b<subscript>3</subscript></entry>
+	      <entry>b<subscript>2</subscript></entry>
+	      <entry>b<subscript>1</subscript></entry>
+	      <entry>b<subscript>0</subscript></entry>
+	      <entry>g<subscript>7</subscript></entry>
+	      <entry>g<subscript>6</subscript></entry>
+	      <entry>g<subscript>5</subscript></entry>
+	      <entry>g<subscript>4</subscript></entry>
+	      <entry>g<subscript>3</subscript></entry>
+	      <entry>g<subscript>2</subscript></entry>
+	      <entry>g<subscript>1</subscript></entry>
+	      <entry>g<subscript>0</subscript></entry>
+	    </row>
 	    <row id="V4L2-MBUS-FMT-RGB888-1X24">
 	      <entry>V4L2_MBUS_FMT_RGB888_1X24</entry>
 	      <entry>0x100a</entry>
@@ -563,6 +593,43 @@
 	      <entry>b<subscript>1</subscript></entry>
 	      <entry>b<subscript>0</subscript></entry>
 	    </row>
+	    <row id="V4L2-MBUS-FMT-RGB888-1X32-PADHI">
+	      <entry>V4L2_MBUS_FMT_RGB888_1X32_PADHI</entry>
+	      <entry>0x100f</entry>
+	      <entry></entry>
+	      <entry>0</entry>
+	      <entry>0</entry>
+	      <entry>0</entry>
+	      <entry>0</entry>
+	      <entry>0</entry>
+	      <entry>0</entry>
+	      <entry>0</entry>
+	      <entry>0</entry>
+	      <entry>r<subscript>7</subscript></entry>
+	      <entry>r<subscript>6</subscript></entry>
+	      <entry>r<subscript>5</subscript></entry>
+	      <entry>r<subscript>4</subscript></entry>
+	      <entry>r<subscript>3</subscript></entry>
+	      <entry>r<subscript>2</subscript></entry>
+	      <entry>r<subscript>1</subscript></entry>
+	      <entry>r<subscript>0</subscript></entry>
+	      <entry>g<subscript>7</subscript></entry>
+	      <entry>g<subscript>6</subscript></entry>
+	      <entry>g<subscript>5</subscript></entry>
+	      <entry>g<subscript>4</subscript></entry>
+	      <entry>g<subscript>3</subscript></entry>
+	      <entry>g<subscript>2</subscript></entry>
+	      <entry>g<subscript>1</subscript></entry>
+	      <entry>g<subscript>0</subscript></entry>
+	      <entry>b<subscript>7</subscript></entry>
+	      <entry>b<subscript>6</subscript></entry>
+	      <entry>b<subscript>5</subscript></entry>
+	      <entry>b<subscript>4</subscript></entry>
+	      <entry>b<subscript>3</subscript></entry>
+	      <entry>b<subscript>2</subscript></entry>
+	      <entry>b<subscript>1</subscript></entry>
+	      <entry>b<subscript>0</subscript></entry>
+	    </row>
 	  </tbody>
 	</tgroup>
       </table>
diff --git a/include/uapi/linux/v4l2-mediabus.h b/include/uapi/linux/v4l2-mediabus.h
index 1445e85..8ea4f26 100644
--- a/include/uapi/linux/v4l2-mediabus.h
+++ b/include/uapi/linux/v4l2-mediabus.h
@@ -37,7 +37,7 @@
 enum v4l2_mbus_pixelcode {
 	V4L2_MBUS_FMT_FIXED = 0x0001,
 
-	/* RGB - next is 0x100e */
+	/* RGB - next is 0x1010 */
 	V4L2_MBUS_FMT_RGB444_2X8_PADHI_BE = 0x1001,
 	V4L2_MBUS_FMT_RGB444_2X8_PADHI_LE = 0x1002,
 	V4L2_MBUS_FMT_RGB555_2X8_PADHI_BE = 0x1003,
@@ -47,10 +47,12 @@ enum v4l2_mbus_pixelcode {
 	V4L2_MBUS_FMT_RGB565_2X8_BE = 0x1007,
 	V4L2_MBUS_FMT_RGB565_2X8_LE = 0x1008,
 	V4L2_MBUS_FMT_RGB666_1X18 = 0x1009,
+	V4L2_MBUS_FMT_RBG888_1X24 = 0x100e,
 	V4L2_MBUS_FMT_RGB888_1X24 = 0x100a,
 	V4L2_MBUS_FMT_RGB888_2X12_BE = 0x100b,
 	V4L2_MBUS_FMT_RGB888_2X12_LE = 0x100c,
 	V4L2_MBUS_FMT_ARGB8888_1X32 = 0x100d,
+	V4L2_MBUS_FMT_RGB888_1X32_PADHI = 0x100f,
 
 	/* YUV (including grey) - next is 0x2024 */
 	V4L2_MBUS_FMT_Y8_1X8 = 0x2001,
-- 
2.0.4

