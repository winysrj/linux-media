Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:49788 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933212AbcHDJaG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 4 Aug 2016 05:30:06 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 5/7] pixfmt.rst: drop V4L2_YCBCR_ENC_SYCC from the documentation
Date: Thu,  4 Aug 2016 11:28:19 +0200
Message-Id: <1470302901-29281-6-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1470302901-29281-1-git-send-email-hverkuil@xs4all.nl>
References: <1470302901-29281-1-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The V4L2_YCBCR_ENC_SYCC encoding is identical to V4L2_YCBCR_ENC_601.
Remove V4L2_YCBCR_ENC_SYCC from the documentation since it should not
be used.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 Documentation/media/uapi/v4l/pixfmt-006.rst | 10 ++--------
 Documentation/media/uapi/v4l/pixfmt-007.rst | 12 ++++--------
 2 files changed, 6 insertions(+), 16 deletions(-)

diff --git a/Documentation/media/uapi/v4l/pixfmt-006.rst b/Documentation/media/uapi/v4l/pixfmt-006.rst
index 987b9a8..94271c8 100644
--- a/Documentation/media/uapi/v4l/pixfmt-006.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-006.rst
@@ -224,23 +224,17 @@ needs to be filled in.
 
     -  .. row 7
 
-       -  ``V4L2_YCBCR_ENC_SYCC``
-
-       -  Use the extended gamut sYCC encoding.
-
-    -  .. row 8
-
        -  ``V4L2_YCBCR_ENC_BT2020``
 
        -  Use the default non-constant luminance BT.2020 Y'CbCr encoding.
 
-    -  .. row 9
+    -  .. row 8
 
        -  ``V4L2_YCBCR_ENC_BT2020_CONST_LUM``
 
        -  Use the constant luminance BT.2020 Yc'CbcCrc encoding.
 
-    -  .. row 10
+    -  .. row 9
 
        -  ``V4L2_YCBCR_ENC_SMPTE_240M``
 
diff --git a/Documentation/media/uapi/v4l/pixfmt-007.rst b/Documentation/media/uapi/v4l/pixfmt-007.rst
index 1f64477..0f9ce74 100644
--- a/Documentation/media/uapi/v4l/pixfmt-007.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-007.rst
@@ -241,7 +241,7 @@ Colorspace sRGB (V4L2_COLORSPACE_SRGB)
 The :ref:`srgb` standard defines the colorspace used by most webcams
 and computer graphics. The default transfer function is
 ``V4L2_XFER_FUNC_SRGB``. The default Y'CbCr encoding is
-``V4L2_YCBCR_ENC_SYCC``. The default Y'CbCr quantization is full range.
+``V4L2_YCBCR_ENC_601``. The default Y'CbCr quantization is full range.
 The chromaticities of the primary colors and the white reference are:
 
 
@@ -313,8 +313,7 @@ Inverse Transfer function:
     L = ((L' + 0.055) / 1.055) :sup:`2.4` for L' > 0.04045
 
 The luminance (Y') and color difference (Cb and Cr) are obtained with
-the following ``V4L2_YCBCR_ENC_SYCC`` encoding as defined by
-:ref:`sycc`:
+the following ``V4L2_YCBCR_ENC_601`` encoding as defined by :ref:`sycc`:
 
     Y' = 0.2990R' + 0.5870G' + 0.1140B'
 
@@ -323,11 +322,8 @@ the following ``V4L2_YCBCR_ENC_SYCC`` encoding as defined by
     Cr = 0.5R' - 0.4187G' - 0.0813B'
 
 Y' is clamped to the range [0…1] and Cb and Cr are clamped to the range
-[-0.5…0.5]. The ``V4L2_YCBCR_ENC_SYCC`` quantization is always full
-range. Although this Y'CbCr encoding looks very similar to the
-``V4L2_YCBCR_ENC_XV601`` encoding, it is not. The
-``V4L2_YCBCR_ENC_XV601`` scales and offsets the Y'CbCr values before
-quantization, but this encoding does not do that.
+[-0.5…0.5]. This transform is identical to one defined in SMPTE
+170M/BT.601. The Y'CbCr quantization is full range.
 
 
 .. _col-adobergb:
-- 
2.8.1

