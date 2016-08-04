Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:51946 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932914AbcHDJaH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 4 Aug 2016 05:30:07 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 3/7] v4l2-tpg-core: drop SYCC, use higher precision 601 conversion matrix
Date: Thu,  4 Aug 2016 11:28:17 +0200
Message-Id: <1470302901-29281-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1470302901-29281-1-git-send-email-hverkuil@xs4all.nl>
References: <1470302901-29281-1-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The SYCC Y'CbCr encoding is identical to the 601 encoding. Since the
SYCC define is about to be removed for use in the kernel we need to
drop it in the TPG code as well.

This patch also adds a 4th decimal to the 601 conversion matrix.
That was specified by the sYCC spec and it makes sense to use this
across the board.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/media/uapi/v4l/pixfmt-007.rst   | 30 +++++++++++++--------------
 drivers/media/common/v4l2-tpg/v4l2-tpg-core.c | 14 ++++++-------
 2 files changed, 21 insertions(+), 23 deletions(-)

diff --git a/Documentation/media/uapi/v4l/pixfmt-007.rst b/Documentation/media/uapi/v4l/pixfmt-007.rst
index 017f166..1f64477 100644
--- a/Documentation/media/uapi/v4l/pixfmt-007.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-007.rst
@@ -89,11 +89,11 @@ Inverse Transfer function:
 The luminance (Y') and color difference (Cb and Cr) are obtained with
 the following ``V4L2_YCBCR_ENC_601`` encoding:
 
-    Y' = 0.299R' + 0.587G' + 0.114B'
+    Y' = 0.2990R' + 0.5870G' + 0.1140B'
 
-    Cb = -0.169R' - 0.331G' + 0.5B'
+    Cb = -0.1687R' - 0.3313G' + 0.5B'
 
-    Cr = 0.5R' - 0.419G' - 0.081B'
+    Cr = 0.5R' - 0.4187G' - 0.0813B'
 
 Y' is clamped to the range [0…1] and Cb and Cr are clamped to the range
 [-0.5…0.5]. This conversion to Y'CbCr is identical to the one defined in
@@ -221,11 +221,11 @@ similar to the BT.601 encoding, but it allows for R', G' and B' values
 that are outside the range [0…1]. The resulting Y', Cb and Cr values are
 scaled and offset:
 
-    Y' = (219 / 256) * (0.299R' + 0.587G' + 0.114B') + (16 / 256)
+    Y' = (219 / 256) * (0.2990R' + 0.5870G' + 0.1140B') + (16 / 256)
 
-    Cb = (224 / 256) * (-0.169R' - 0.331G' + 0.5B')
+    Cb = (224 / 256) * (-0.1687R' - 0.3313G' + 0.5B')
 
-    Cr = (224 / 256) * (0.5R' - 0.419G' - 0.081B')
+    Cr = (224 / 256) * (0.5R' - 0.4187G' - 0.0813B')
 
 Y' is clamped to the range [0…1] and Cb and Cr are clamped to the range
 [-0.5…0.5]. The non-standard xvYCC 709 or xvYCC 601 encodings can be
@@ -404,11 +404,11 @@ Inverse Transfer function:
 The luminance (Y') and color difference (Cb and Cr) are obtained with
 the following ``V4L2_YCBCR_ENC_601`` encoding:
 
-    Y' = 0.299R' + 0.587G' + 0.114B'
+    Y' = 0.2990R' + 0.5870G' + 0.1140B'
 
-    Cb = -0.169R' - 0.331G' + 0.5B'
+    Cb = -0.1687R' - 0.3313G' + 0.5B'
 
-    Cr = 0.5R' - 0.419G' - 0.081B'
+    Cr = 0.5R' - 0.4187G' - 0.0813B'
 
 Y' is clamped to the range [0…1] and Cb and Cr are clamped to the range
 [-0.5…0.5]. This transform is identical to one defined in SMPTE
@@ -775,11 +775,11 @@ Inverse Transfer function:
 The luminance (Y') and color difference (Cb and Cr) are obtained with
 the following ``V4L2_YCBCR_ENC_601`` encoding:
 
-    Y' = 0.299R' + 0.587G' + 0.114B'
+    Y' = 0.2990R' + 0.5870G' + 0.1140B'
 
-    Cb = -0.169R' - 0.331G' + 0.5B'
+    Cb = -0.1687R' - 0.3313G' + 0.5B'
 
-    Cr = 0.5R' - 0.419G' - 0.081B'
+    Cr = 0.5R' - 0.4187G' - 0.0813B'
 
 Y' is clamped to the range [0…1] and Cb and Cr are clamped to the range
 [-0.5…0.5]. The Y'CbCr quantization is limited range. This transform is
@@ -865,11 +865,11 @@ Inverse Transfer function:
 The luminance (Y') and color difference (Cb and Cr) are obtained with
 the following ``V4L2_YCBCR_ENC_601`` encoding:
 
-    Y' = 0.299R' + 0.587G' + 0.114B'
+    Y' = 0.2990R' + 0.5870G' + 0.1140B'
 
-    Cb = -0.169R' - 0.331G' + 0.5B'
+    Cb = -0.1687R' - 0.3313G' + 0.5B'
 
-    Cr = 0.5R' - 0.419G' - 0.081B'
+    Cr = 0.5R' - 0.4187G' - 0.0813B'
 
 Y' is clamped to the range [0…1] and Cb and Cr are clamped to the range
 [-0.5…0.5]. The Y'CbCr quantization is limited range. This transform is
diff --git a/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c b/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
index 3ec3ceb..1684810 100644
--- a/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
+++ b/drivers/media/common/v4l2-tpg/v4l2-tpg-core.c
@@ -504,14 +504,14 @@ static void color_to_ycbcr(struct tpg_data *tpg, int r, int g, int b,
 #define COEFF(v, r) ((int)(0.5 + (v) * (r) * 256.0))
 
 	static const int bt601[3][3] = {
-		{ COEFF(0.299, 219),  COEFF(0.587, 219),  COEFF(0.114, 219)  },
-		{ COEFF(-0.169, 224), COEFF(-0.331, 224), COEFF(0.5, 224)    },
-		{ COEFF(0.5, 224),    COEFF(-0.419, 224), COEFF(-0.081, 224) },
+		{ COEFF(0.299, 219),   COEFF(0.587, 219),   COEFF(0.114, 219)   },
+		{ COEFF(-0.1687, 224), COEFF(-0.3313, 224), COEFF(0.5, 224)     },
+		{ COEFF(0.5, 224),     COEFF(-0.4187, 224), COEFF(-0.0813, 224) },
 	};
 	static const int bt601_full[3][3] = {
-		{ COEFF(0.299, 255),  COEFF(0.587, 255),  COEFF(0.114, 255)  },
-		{ COEFF(-0.169, 255), COEFF(-0.331, 255), COEFF(0.5, 255)    },
-		{ COEFF(0.5, 255),    COEFF(-0.419, 255), COEFF(-0.081, 255) },
+		{ COEFF(0.299, 255),   COEFF(0.587, 255),   COEFF(0.114, 255)   },
+		{ COEFF(-0.1687, 255), COEFF(-0.3313, 255), COEFF(0.5, 255)     },
+		{ COEFF(0.5, 255),     COEFF(-0.4187, 255), COEFF(-0.0813, 255) },
 	};
 	static const int rec709[3][3] = {
 		{ COEFF(0.2126, 219),  COEFF(0.7152, 219),  COEFF(0.0722, 219)  },
@@ -558,7 +558,6 @@ static void color_to_ycbcr(struct tpg_data *tpg, int r, int g, int b,
 
 	switch (tpg->real_ycbcr_enc) {
 	case V4L2_YCBCR_ENC_601:
-	case V4L2_YCBCR_ENC_SYCC:
 		rgb2ycbcr(full ? bt601_full : bt601, r, g, b, y_offset, y, cb, cr);
 		break;
 	case V4L2_YCBCR_ENC_XV601:
@@ -674,7 +673,6 @@ static void ycbcr_to_color(struct tpg_data *tpg, int y, int cb, int cr,
 
 	switch (tpg->real_ycbcr_enc) {
 	case V4L2_YCBCR_ENC_601:
-	case V4L2_YCBCR_ENC_SYCC:
 		ycbcr2rgb(full ? bt601_full : bt601, y, cb, cr, y_offset, r, g, b);
 		break;
 	case V4L2_YCBCR_ENC_XV601:
-- 
2.8.1

