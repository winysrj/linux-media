Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:62118 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951Ab2E2IYq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 May 2012 04:24:46 -0400
Received: by ghrr11 with SMTP id r11so1569794ghr.19
        for <linux-media@vger.kernel.org>; Tue, 29 May 2012 01:24:45 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 29 May 2012 10:24:45 +0200
Message-ID: <CAGGh5h3jNpbPty6Qzrz9XhmBJci2GcHZhaF8w3dmG_Ce9dpSRQ@mail.gmail.com>
Subject: [RFC PATCH] omap3isp : fix cfa demosaicing for format other than GRBG
From: jean-philippe francois <jp.francois@cynove.com>
To: linux-media <linux-media@vger.kernel.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

omap3 ISP previewer block can convert a raw bayer image
into a UYVY image. Debayering coefficient are stored in
an undocumented table. In the current form, only
GRBG format are converted correctly.

However, the other CFA arrangement can be transformed
in GRBG arrangement by shifting the image window one pixel
to the left or to the bottom.

Here is a patch against vanilla 3.2.17, that was only tested with a
BGGR arrangement.
Is it the right way to fix this issue ?

Thank you,

Jean-Philippe François


Index: b/drivers/media/video/omap3isp/isppreview.c
===================================================================
--- a/drivers/media/video/omap3isp/isppreview.c
+++ b/drivers/media/video/omap3isp/isppreview.c
@@ -96,21 +96,26 @@
  *					  2 lines in other modes
  * Color suppression		2 pixels
  * or luma enhancement
+ *
+ * Bayer pattern shifting 2 pixels, 1 line
  * -------------------------------------------------------------
- * Maximum total		14 pixels, 8 lines
+ * Maximum total		18 pixels, 9 lines
  *
  * The color suppression and luma enhancement filters are applied
after bayer to
  * YUV conversion. They thus can crop one pixel on the left and one
pixel on the
  * right side of the image without changing the color pattern. When both those
  * filters are disabled, the driver must crop the two pixels on the
same side of
- * the image to avoid changing the bayer pattern. The left margin is
thus set to
- * 8 pixels and the right margin to 6 pixels.
+ * the image to avoid changing the bayer pattern.
+ *
+ * Bayer pattern shifting is needed for some bayer pattern. Shifting
+ * will be in the right and bottom direction.
+ * The left margin is thus set to 8 pixels and the right margin to 10 pixels.
  */

 #define PREV_MARGIN_LEFT	8
-#define PREV_MARGIN_RIGHT	6
+#define PREV_MARGIN_RIGHT	10
 #define PREV_MARGIN_TOP		4
-#define PREV_MARGIN_BOTTOM	4
+#define PREV_MARGIN_BOTTOM	5

 #define PREV_MIN_IN_WIDTH	64
 #define PREV_MIN_IN_HEIGHT	8
@@ -1038,6 +1043,34 @@
 		eph += 2;
 		slv -= 2;
 		elv += 2;
+		/* CFA table coef only handle GRBG format. Other format
+		 * can be transformed in GRBG by shifting the pattern :
+		 * BGGR -> GRBG is obtained by a 1 row shift
+		 * RGGB -> GRBG is obtained by a 1 column shift
+		 * GBRG -> GRBG is obtained by a row and column shift
+		 */
+		switch(prev->formats[PREV_PAD_SINK].code) {
+		case V4L2_MBUS_FMT_SRGGB10_1X10:
+			sph += 1;
+			eph += 1;
+			break;
+
+		case V4L2_MBUS_FMT_SBGGR10_1X10:
+			slv += 1;
+			elv += 1;
+			break;
+
+		case V4L2_MBUS_FMT_SGBRG10_1X10:
+			sph += 1;
+			eph += 1;
+			slv += 1;
+			elv += 1;
+			break;
+
+		default:
+			break;
+		}
+
 	}
 	if (params->features & (PREV_DEFECT_COR | PREV_NOISE_FILTER)) {
 		sph -= 2;
