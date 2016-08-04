Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:50932 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933209AbcHDJaG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 4 Aug 2016 05:30:06 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 4/7] videodev2.h: put V4L2_YCBCR_ENC_SYCC under #ifndef __KERNEL__
Date: Thu,  4 Aug 2016 11:28:18 +0200
Message-Id: <1470302901-29281-5-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1470302901-29281-1-git-send-email-hverkuil@xs4all.nl>
References: <1470302901-29281-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This define is a duplicate of V4L2_YCBCR_ENC_601. So mark it as
'should not be used' and put it under #ifndef __KERNEL__ to
prevent drivers from referring to it.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/uapi/linux/videodev2.h | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 12773f2..8c5468c 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -292,13 +292,11 @@ enum v4l2_ycbcr_encoding {
 	 * various colorspaces:
 	 *
 	 * V4L2_COLORSPACE_SMPTE170M, V4L2_COLORSPACE_470_SYSTEM_M,
-	 * V4L2_COLORSPACE_470_SYSTEM_BG, V4L2_COLORSPACE_ADOBERGB and
-	 * V4L2_COLORSPACE_JPEG: V4L2_YCBCR_ENC_601
+	 * V4L2_COLORSPACE_470_SYSTEM_BG, V4L2_COLORSPACE_SRGB,
+	 * V4L2_COLORSPACE_ADOBERGB and V4L2_COLORSPACE_JPEG: V4L2_YCBCR_ENC_601
 	 *
 	 * V4L2_COLORSPACE_REC709 and V4L2_COLORSPACE_DCI_P3: V4L2_YCBCR_ENC_709
 	 *
-	 * V4L2_COLORSPACE_SRGB: V4L2_YCBCR_ENC_SYCC
-	 *
 	 * V4L2_COLORSPACE_BT2020: V4L2_YCBCR_ENC_BT2020
 	 *
 	 * V4L2_COLORSPACE_SMPTE240M: V4L2_YCBCR_ENC_SMPTE240M
@@ -317,8 +315,14 @@ enum v4l2_ycbcr_encoding {
 	/* Rec. 709/EN 61966-2-4 Extended Gamut -- HDTV */
 	V4L2_YCBCR_ENC_XV709          = 4,
 
-	/* sYCC (Y'CbCr encoding of sRGB) */
+#ifndef __KERNEL__
+	/*
+	 * sYCC (Y'CbCr encoding of sRGB), identical to ENC_601. It was added
+	 * originally due to a misunderstanding of the sYCC standard. It should
+	 * not be used, instead use V4L2_YCBCR_ENC_601.
+	 */
 	V4L2_YCBCR_ENC_SYCC           = 5,
+#endif
 
 	/* BT.2020 Non-constant Luminance Y'CbCr */
 	V4L2_YCBCR_ENC_BT2020         = 6,
-- 
2.8.1

