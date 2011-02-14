Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:58187 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754238Ab1BNMVq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Feb 2011 07:21:46 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: linux-media@vger.kernel.org
Cc: sakari.ailus@maxwell.research.nokia.com
Subject: [PATCH v2 5/6] v4l: Add missing 12 bits bayer media bus formats
Date: Mon, 14 Feb 2011 13:21:29 +0100
Message-Id: <1297686090-9762-6-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1297686090-9762-1-git-send-email-laurent.pinchart@ideasonboard.com>
References: <1297686090-9762-1-git-send-email-laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Add codes and documentation for the following media bus formats:

- V4L2_MBUS_FMT_SGBRG12_1X12
- V4L2_MBUS_FMT_SGRBG12_1X12
- V4L2_MBUS_FMT_SRGGB12_1X12

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
---
 Documentation/DocBook/v4l/subdev-formats.xml |   51 ++++++++++++++++++++++++++
 include/linux/v4l2-mediabus.h                |    5 ++-
 2 files changed, 55 insertions(+), 1 deletions(-)

diff --git a/Documentation/DocBook/v4l/subdev-formats.xml b/Documentation/DocBook/v4l/subdev-formats.xml
index 0cae572..2fed9be 100644
--- a/Documentation/DocBook/v4l/subdev-formats.xml
+++ b/Documentation/DocBook/v4l/subdev-formats.xml
@@ -490,6 +490,57 @@
 	      <entry>b<subscript>1</subscript></entry>
 	      <entry>b<subscript>0</subscript></entry>
 	    </row>
+	    <row id="V4L2-MBUS-FMT-SGBRG12-1X12">
+	      <entry>V4L2_MBUS_FMT_SGBRG12_1X12</entry>
+	      <entry>0x3010</entry>
+	      <entry></entry>
+	      <entry>g<subscript>11</subscript></entry>
+	      <entry>g<subscript>10</subscript></entry>
+	      <entry>g<subscript>9</subscript></entry>
+	      <entry>g<subscript>8</subscript></entry>
+	      <entry>g<subscript>7</subscript></entry>
+	      <entry>g<subscript>6</subscript></entry>
+	      <entry>g<subscript>5</subscript></entry>
+	      <entry>g<subscript>4</subscript></entry>
+	      <entry>g<subscript>3</subscript></entry>
+	      <entry>g<subscript>2</subscript></entry>
+	      <entry>g<subscript>1</subscript></entry>
+	      <entry>g<subscript>0</subscript></entry>
+	    </row>
+	    <row id="V4L2-MBUS-FMT-SGRBG12-1X12">
+	      <entry>V4L2_MBUS_FMT_SGRBG12_1X12</entry>
+	      <entry>0x3011</entry>
+	      <entry></entry>
+	      <entry>g<subscript>11</subscript></entry>
+	      <entry>g<subscript>10</subscript></entry>
+	      <entry>g<subscript>9</subscript></entry>
+	      <entry>g<subscript>8</subscript></entry>
+	      <entry>g<subscript>7</subscript></entry>
+	      <entry>g<subscript>6</subscript></entry>
+	      <entry>g<subscript>5</subscript></entry>
+	      <entry>g<subscript>4</subscript></entry>
+	      <entry>g<subscript>3</subscript></entry>
+	      <entry>g<subscript>2</subscript></entry>
+	      <entry>g<subscript>1</subscript></entry>
+	      <entry>g<subscript>0</subscript></entry>
+	    </row>
+	    <row id="V4L2-MBUS-FMT-SRGGB12-1X12">
+	      <entry>V4L2_MBUS_FMT_SRGGB12_1X12</entry>
+	      <entry>0x3012</entry>
+	      <entry></entry>
+	      <entry>r<subscript>11</subscript></entry>
+	      <entry>r<subscript>10</subscript></entry>
+	      <entry>r<subscript>9</subscript></entry>
+	      <entry>r<subscript>8</subscript></entry>
+	      <entry>r<subscript>7</subscript></entry>
+	      <entry>r<subscript>6</subscript></entry>
+	      <entry>r<subscript>5</subscript></entry>
+	      <entry>r<subscript>4</subscript></entry>
+	      <entry>r<subscript>3</subscript></entry>
+	      <entry>r<subscript>2</subscript></entry>
+	      <entry>r<subscript>1</subscript></entry>
+	      <entry>r<subscript>0</subscript></entry>
+	    </row>
 	    <row id="V4L2-MBUS-FMT-SGBRG10-DPCM8-1X8">
 	      <entry>V4L2_MBUS_FMT_SGBRG10_DPCM8_1X8</entry>
 	      <entry>0x300c</entry>
diff --git a/include/linux/v4l2-mediabus.h b/include/linux/v4l2-mediabus.h
index 5c64924..7054a7a 100644
--- a/include/linux/v4l2-mediabus.h
+++ b/include/linux/v4l2-mediabus.h
@@ -67,7 +67,7 @@ enum v4l2_mbus_pixelcode {
 	V4L2_MBUS_FMT_YUYV10_1X20 = 0x200d,
 	V4L2_MBUS_FMT_YVYU10_1X20 = 0x200e,
 
-	/* Bayer - next is 0x3010 */
+	/* Bayer - next is 0x3013 */
 	V4L2_MBUS_FMT_SBGGR8_1X8 = 0x3001,
 	V4L2_MBUS_FMT_SGRBG8_1X8 = 0x3002,
 	V4L2_MBUS_FMT_SBGGR10_DPCM8_1X8 = 0x300b,
@@ -83,6 +83,9 @@ enum v4l2_mbus_pixelcode {
 	V4L2_MBUS_FMT_SGRBG10_1X10 = 0x300a,
 	V4L2_MBUS_FMT_SRGGB10_1X10 = 0x300f,
 	V4L2_MBUS_FMT_SBGGR12_1X12 = 0x3008,
+	V4L2_MBUS_FMT_SGBRG12_1X12 = 0x3010,
+	V4L2_MBUS_FMT_SGRBG12_1X12 = 0x3011,
+	V4L2_MBUS_FMT_SRGGB12_1X12 = 0x3012,
 };
 
 /**
-- 
1.7.3.4

