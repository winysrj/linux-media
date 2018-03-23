Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:38821 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754007AbeCWL51 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 23 Mar 2018 07:57:27 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org
Subject: [PATCH 02/30] media: imx-media-utils: fix a warning
Date: Fri, 23 Mar 2018 07:56:48 -0400
Message-Id: <a23deac60a8683895543c8f335c36e475948716f.1521806166.git.mchehab@s-opensource.com>
In-Reply-To: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
References: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
In-Reply-To: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
References: <39adb4e739050dcdb74c3465d261de8de5f224b7.1521806166.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The logic at find_format() is a little bit confusing even for
humans, and it tricks static code analyzers:

	drivers/staging/media/imx/imx-media-utils.c:259 find_format() error: buffer overflow 'array' 14 <= 20

Rewrite the logic in a way that it makes it clearer to understand,
while prevent static analyzers to produce false positives.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/staging/media/imx/imx-media-utils.c | 81 +++++++++++++++--------------
 1 file changed, 43 insertions(+), 38 deletions(-)

diff --git a/drivers/staging/media/imx/imx-media-utils.c b/drivers/staging/media/imx/imx-media-utils.c
index 40bcb8fb18b9..fab98fc0d6a0 100644
--- a/drivers/staging/media/imx/imx-media-utils.c
+++ b/drivers/staging/media/imx/imx-media-utils.c
@@ -225,58 +225,63 @@ static void init_mbus_colorimetry(struct v4l2_mbus_framefmt *mbus,
 					      mbus->ycbcr_enc);
 }
 
+static const
+struct imx_media_pixfmt *__find_format(u32 fourcc,
+				       u32 code,
+				       bool allow_non_mbus,
+				       bool allow_bayer,
+				       const struct imx_media_pixfmt *array,
+				       u32 array_size)
+{
+	const struct imx_media_pixfmt *fmt;
+	int i, j;
+
+	for (i = 0; i < array_size; i++) {
+		fmt = &array[i];
+
+		if ((!allow_non_mbus && !fmt->codes[0]) ||
+		    (!allow_bayer && fmt->bayer))
+			continue;
+
+		if (fourcc && fmt->fourcc == fourcc)
+			return fmt;
+
+		if (!code)
+			continue;
+
+		for (j = 0; fmt->codes[j]; j++) {
+			if (code == fmt->codes[j])
+				return fmt;
+		}
+	}
+	return NULL;
+}
+
 static const struct imx_media_pixfmt *find_format(u32 fourcc,
 						  u32 code,
 						  enum codespace_sel cs_sel,
 						  bool allow_non_mbus,
 						  bool allow_bayer)
 {
-	const struct imx_media_pixfmt *array, *fmt, *ret = NULL;
-	u32 array_size;
-	int i, j;
+	const struct imx_media_pixfmt *ret;
 
 	switch (cs_sel) {
 	case CS_SEL_YUV:
-		array_size = NUM_YUV_FORMATS;
-		array = yuv_formats;
-		break;
+		return __find_format(fourcc, code, allow_non_mbus, allow_bayer,
+				     yuv_formats, NUM_YUV_FORMATS);
 	case CS_SEL_RGB:
-		array_size = NUM_RGB_FORMATS;
-		array = rgb_formats;
-		break;
+		return __find_format(fourcc, code, allow_non_mbus, allow_bayer,
+				     rgb_formats, NUM_RGB_FORMATS);
 	case CS_SEL_ANY:
-		array_size = NUM_YUV_FORMATS + NUM_RGB_FORMATS;
-		array = yuv_formats;
-		break;
+		ret = __find_format(fourcc, code, allow_non_mbus, allow_bayer,
+				    yuv_formats, NUM_YUV_FORMATS);
+		if (ret)
+			return ret;
+		return __find_format(fourcc, code, allow_non_mbus, allow_bayer,
+				     rgb_formats, NUM_RGB_FORMATS);
 	default:
 		return NULL;
 	}
-
-	for (i = 0; i < array_size; i++) {
-		if (cs_sel == CS_SEL_ANY && i >= NUM_YUV_FORMATS)
-			fmt = &rgb_formats[i - NUM_YUV_FORMATS];
-		else
-			fmt = &array[i];
-
-		if ((!allow_non_mbus && fmt->codes[0] == 0) ||
-		    (!allow_bayer && fmt->bayer))
-			continue;
-
-		if (fourcc && fmt->fourcc == fourcc) {
-			ret = fmt;
-			goto out;
-		}
-
-		for (j = 0; code && fmt->codes[j]; j++) {
-			if (code == fmt->codes[j]) {
-				ret = fmt;
-				goto out;
-			}
-		}
-	}
-
-out:
-	return ret;
 }
 
 static int enum_format(u32 *fourcc, u32 *code, u32 index,
-- 
2.14.3
