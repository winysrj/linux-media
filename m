Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:52269 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753402AbbIMQm6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Sep 2015 12:42:58 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 3/6] videodev2.h: add support for the DCI-P3 colorspace
Date: Sun, 13 Sep 2015 18:41:29 +0200
Message-Id: <1442162492-46238-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1442162492-46238-1-git-send-email-hverkuil@xs4all.nl>
References: <1442162492-46238-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This colorspace is used for cinema projectors and is supported by
the DisplayPort standard.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/uapi/linux/videodev2.h | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 3228fbe..4900e15 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -229,6 +229,9 @@ enum v4l2_colorspace {
 
 	/* Raw colorspace: for RAW unprocessed images */
 	V4L2_COLORSPACE_RAW           = 11,
+
+	/* DCI-P3 colorspace, used by cinema projectors */
+	V4L2_COLORSPACE_DCI_P3        = 12,
 };
 
 /*
@@ -256,6 +259,8 @@ enum v4l2_xfer_func {
 	 * V4L2_COLORSPACE_SMPTE240M: V4L2_XFER_FUNC_SMPTE240M
 	 *
 	 * V4L2_COLORSPACE_RAW: V4L2_XFER_FUNC_NONE
+	 *
+	 * V4L2_COLORSPACE_DCI_P3: V4L2_XFER_FUNC_DCI_P3
 	 */
 	V4L2_XFER_FUNC_DEFAULT     = 0,
 	V4L2_XFER_FUNC_709         = 1,
@@ -263,6 +268,7 @@ enum v4l2_xfer_func {
 	V4L2_XFER_FUNC_ADOBERGB    = 3,
 	V4L2_XFER_FUNC_SMPTE240M   = 4,
 	V4L2_XFER_FUNC_NONE        = 5,
+	V4L2_XFER_FUNC_DCI_P3      = 6,
 };
 
 /*
@@ -272,9 +278,10 @@ enum v4l2_xfer_func {
 #define V4L2_MAP_XFER_FUNC_DEFAULT(colsp) \
 	((colsp) == V4L2_COLORSPACE_ADOBERGB ? V4L2_XFER_FUNC_ADOBERGB : \
 	 ((colsp) == V4L2_COLORSPACE_SMPTE240M ? V4L2_XFER_FUNC_SMPTE240M : \
-	  ((colsp) == V4L2_COLORSPACE_RAW ? V4L2_XFER_FUNC_NONE : \
-	   ((colsp) == V4L2_COLORSPACE_SRGB || (colsp) == V4L2_COLORSPACE_JPEG ? \
-	    V4L2_XFER_FUNC_SRGB : V4L2_XFER_FUNC_709))))
+	  ((colsp) == V4L2_COLORSPACE_DCI_P3 ? V4L2_XFER_FUNC_DCI_P3 : \
+	   ((colsp) == V4L2_COLORSPACE_RAW ? V4L2_XFER_FUNC_NONE : \
+	    ((colsp) == V4L2_COLORSPACE_SRGB || (colsp) == V4L2_COLORSPACE_JPEG ? \
+	     V4L2_XFER_FUNC_SRGB : V4L2_XFER_FUNC_709)))))
 
 enum v4l2_ycbcr_encoding {
 	/*
@@ -285,7 +292,7 @@ enum v4l2_ycbcr_encoding {
 	 * V4L2_COLORSPACE_470_SYSTEM_BG, V4L2_COLORSPACE_ADOBERGB and
 	 * V4L2_COLORSPACE_JPEG: V4L2_YCBCR_ENC_601
 	 *
-	 * V4L2_COLORSPACE_REC709: V4L2_YCBCR_ENC_709
+	 * V4L2_COLORSPACE_REC709 and V4L2_COLORSPACE_DCI_P3: V4L2_YCBCR_ENC_709
 	 *
 	 * V4L2_COLORSPACE_SRGB: V4L2_YCBCR_ENC_SYCC
 	 *
@@ -325,7 +332,8 @@ enum v4l2_ycbcr_encoding {
  * This depends on the colorspace.
  */
 #define V4L2_MAP_YCBCR_ENC_DEFAULT(colsp) \
-	((colsp) == V4L2_COLORSPACE_REC709 ? V4L2_YCBCR_ENC_709 : \
+	(((colsp) == V4L2_COLORSPACE_REC709 || \
+	  (colsp) == V4L2_COLORSPACE_DCI_P3) ? V4L2_YCBCR_ENC_709 : \
 	 ((colsp) == V4L2_COLORSPACE_BT2020 ? V4L2_YCBCR_ENC_BT2020 : \
 	  ((colsp) == V4L2_COLORSPACE_SMPTE240M ? V4L2_YCBCR_ENC_SMPTE240M : \
 	   V4L2_YCBCR_ENC_601)))
-- 
2.1.4

