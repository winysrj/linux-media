Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59508 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899AbaBEQlq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 5 Feb 2014 11:41:46 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 03/47] v4l: Add UYVY10_1X20 and VYUY10_1X20 media bus pixel codes
Date: Wed,  5 Feb 2014 17:41:54 +0100
Message-Id: <1391618558-5580-4-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1391618558-5580-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1391618558-5580-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 Documentation/DocBook/media/v4l/subdev-formats.xml | 104 +++++++++++++++++++++
 include/uapi/linux/v4l2-mediabus.h                 |   4 +-
 2 files changed, 107 insertions(+), 1 deletion(-)

diff --git a/Documentation/DocBook/media/v4l/subdev-formats.xml b/Documentation/DocBook/media/v4l/subdev-formats.xml
index 6fb58de..e3cbbb4 100644
--- a/Documentation/DocBook/media/v4l/subdev-formats.xml
+++ b/Documentation/DocBook/media/v4l/subdev-formats.xml
@@ -2436,6 +2436,110 @@
 	      <entry>v<subscript>1</subscript></entry>
 	      <entry>v<subscript>0</subscript></entry>
 	    </row>
+	    <row id="V4L2-MBUS-FMT-UYVY10-1X20">
+	      <entry>V4L2_MBUS_FMT_UYVY10_1X20</entry>
+	      <entry>0x201a</entry>
+	      <entry></entry>
+	      &dash-ent-12;
+	      <entry>u<subscript>9</subscript></entry>
+	      <entry>u<subscript>8</subscript></entry>
+	      <entry>u<subscript>7</subscript></entry>
+	      <entry>u<subscript>6</subscript></entry>
+	      <entry>u<subscript>5</subscript></entry>
+	      <entry>u<subscript>4</subscript></entry>
+	      <entry>u<subscript>3</subscript></entry>
+	      <entry>u<subscript>2</subscript></entry>
+	      <entry>u<subscript>1</subscript></entry>
+	      <entry>u<subscript>0</subscript></entry>
+	      <entry>y<subscript>9</subscript></entry>
+	      <entry>y<subscript>8</subscript></entry>
+	      <entry>y<subscript>7</subscript></entry>
+	      <entry>y<subscript>6</subscript></entry>
+	      <entry>y<subscript>5</subscript></entry>
+	      <entry>y<subscript>4</subscript></entry>
+	      <entry>y<subscript>3</subscript></entry>
+	      <entry>y<subscript>2</subscript></entry>
+	      <entry>y<subscript>1</subscript></entry>
+	      <entry>y<subscript>0</subscript></entry>
+	    </row>
+	    <row>
+	      <entry></entry>
+	      <entry></entry>
+	      <entry></entry>
+	      &dash-ent-12;
+	      <entry>v<subscript>9</subscript></entry>
+	      <entry>v<subscript>8</subscript></entry>
+	      <entry>v<subscript>7</subscript></entry>
+	      <entry>v<subscript>6</subscript></entry>
+	      <entry>v<subscript>5</subscript></entry>
+	      <entry>v<subscript>4</subscript></entry>
+	      <entry>v<subscript>3</subscript></entry>
+	      <entry>v<subscript>2</subscript></entry>
+	      <entry>v<subscript>1</subscript></entry>
+	      <entry>v<subscript>0</subscript></entry>
+	      <entry>y<subscript>9</subscript></entry>
+	      <entry>y<subscript>8</subscript></entry>
+	      <entry>y<subscript>7</subscript></entry>
+	      <entry>y<subscript>6</subscript></entry>
+	      <entry>y<subscript>5</subscript></entry>
+	      <entry>y<subscript>4</subscript></entry>
+	      <entry>y<subscript>3</subscript></entry>
+	      <entry>y<subscript>2</subscript></entry>
+	      <entry>y<subscript>1</subscript></entry>
+	      <entry>y<subscript>0</subscript></entry>
+	    </row>
+	    <row id="V4L2-MBUS-FMT-VYUY10-1X20">
+	      <entry>V4L2_MBUS_FMT_VYUY10_1X20</entry>
+	      <entry>0x201b</entry>
+	      <entry></entry>
+	      &dash-ent-12;
+	      <entry>v<subscript>9</subscript></entry>
+	      <entry>v<subscript>8</subscript></entry>
+	      <entry>v<subscript>7</subscript></entry>
+	      <entry>v<subscript>6</subscript></entry>
+	      <entry>v<subscript>5</subscript></entry>
+	      <entry>v<subscript>4</subscript></entry>
+	      <entry>v<subscript>3</subscript></entry>
+	      <entry>v<subscript>2</subscript></entry>
+	      <entry>v<subscript>1</subscript></entry>
+	      <entry>v<subscript>0</subscript></entry>
+	      <entry>y<subscript>9</subscript></entry>
+	      <entry>y<subscript>8</subscript></entry>
+	      <entry>y<subscript>7</subscript></entry>
+	      <entry>y<subscript>6</subscript></entry>
+	      <entry>y<subscript>5</subscript></entry>
+	      <entry>y<subscript>4</subscript></entry>
+	      <entry>y<subscript>3</subscript></entry>
+	      <entry>y<subscript>2</subscript></entry>
+	      <entry>y<subscript>1</subscript></entry>
+	      <entry>y<subscript>0</subscript></entry>
+	    </row>
+	    <row>
+	      <entry></entry>
+	      <entry></entry>
+	      <entry></entry>
+	      &dash-ent-12;
+	      <entry>u<subscript>9</subscript></entry>
+	      <entry>u<subscript>8</subscript></entry>
+	      <entry>u<subscript>7</subscript></entry>
+	      <entry>u<subscript>6</subscript></entry>
+	      <entry>u<subscript>5</subscript></entry>
+	      <entry>u<subscript>4</subscript></entry>
+	      <entry>u<subscript>3</subscript></entry>
+	      <entry>u<subscript>2</subscript></entry>
+	      <entry>u<subscript>1</subscript></entry>
+	      <entry>u<subscript>0</subscript></entry>
+	      <entry>y<subscript>9</subscript></entry>
+	      <entry>y<subscript>8</subscript></entry>
+	      <entry>y<subscript>7</subscript></entry>
+	      <entry>y<subscript>6</subscript></entry>
+	      <entry>y<subscript>5</subscript></entry>
+	      <entry>y<subscript>4</subscript></entry>
+	      <entry>y<subscript>3</subscript></entry>
+	      <entry>y<subscript>2</subscript></entry>
+	      <entry>y<subscript>1</subscript></entry>
+	      <entry>y<subscript>0</subscript></entry>
+	    </row>
 	    <row id="V4L2-MBUS-FMT-YUYV10-1X20">
 	      <entry>V4L2_MBUS_FMT_YUYV10_1X20</entry>
 	      <entry>0x200d</entry>
diff --git a/include/uapi/linux/v4l2-mediabus.h b/include/uapi/linux/v4l2-mediabus.h
index 20a99b1..43707b2 100644
--- a/include/uapi/linux/v4l2-mediabus.h
+++ b/include/uapi/linux/v4l2-mediabus.h
@@ -52,7 +52,7 @@ enum v4l2_mbus_pixelcode {
 	V4L2_MBUS_FMT_RGB888_2X12_LE = 0x100c,
 	V4L2_MBUS_FMT_ARGB8888_1X32 = 0x100d,
 
-	/* YUV (including grey) - next is 0x201a */
+	/* YUV (including grey) - next is 0x201c */
 	V4L2_MBUS_FMT_Y8_1X8 = 0x2001,
 	V4L2_MBUS_FMT_UV8_1X8 = 0x2015,
 	V4L2_MBUS_FMT_UYVY8_1_5X8 = 0x2002,
@@ -74,6 +74,8 @@ enum v4l2_mbus_pixelcode {
 	V4L2_MBUS_FMT_YUYV8_1X16 = 0x2011,
 	V4L2_MBUS_FMT_YVYU8_1X16 = 0x2012,
 	V4L2_MBUS_FMT_YDYUYDYV8_1X16 = 0x2014,
+	V4L2_MBUS_FMT_UYVY10_1X20 = 0x201a,
+	V4L2_MBUS_FMT_VYUY10_1X20 = 0x201b,
 	V4L2_MBUS_FMT_YUYV10_1X20 = 0x200d,
 	V4L2_MBUS_FMT_YVYU10_1X20 = 0x200e,
 	V4L2_MBUS_FMT_YUV10_1X30 = 0x2016,
-- 
1.8.3.2

