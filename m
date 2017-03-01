Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:48219 "EHLO
        lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751563AbdCAPfA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 1 Mar 2017 10:35:00 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] videodev2.h: map xvYCC601/709 to limited range quantization
Message-ID: <3296d5e4-99b7-447b-f58e-223348669e84@xs4all.nl>
Date: Wed, 1 Mar 2017 16:31:20 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The xvYCC601/709 encodings were mapped by default to full range quantization.
This is actually wrong since these encodings use limited range quantization,
but accept values outside of the limited range.

This makes sense since for values within the limited range it behaves exactly
the same as BT.601 or Rec. 709. The only difference is that with the xvYCC
encodings the values outside of the limited range also produce value colors.

Talking to people who know a lot more about this than I do made me realize
that mapping xvYCC to full range quantization was wrong, so this patch corrects
this and also improves the documentation.

These formats are very rare, and since the formula for decoding these Y'CbCr
encodings is actually fixed and independent of the quantization field value
it is safe to make this change.

The main advantage is that keeps the V4L2 specification in sync with the
corresponding colorspace, HDMI and CEA861 standards when it comes to these
xvYCC formats.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/Documentation/media/uapi/v4l/pixfmt-007.rst b/Documentation/media/uapi/v4l/pixfmt-007.rst
index 95a23a28c595..4c322d9df314 100644
--- a/Documentation/media/uapi/v4l/pixfmt-007.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-007.rst
@@ -174,7 +174,7 @@ this colorspace:
  The xvYCC 709 encoding (``V4L2_YCBCR_ENC_XV709``, :ref:`xvycc`) is
  similar to the Rec. 709 encoding, but it allows for R', G' and B' values
  that are outside the range [0…1]. The resulting Y', Cb and Cr values are
-scaled and offset:
+scaled and offset according to the limited range formula:

  .. math::

@@ -187,7 +187,7 @@ scaled and offset:
  The xvYCC 601 encoding (``V4L2_YCBCR_ENC_XV601``, :ref:`xvycc`) is
  similar to the BT.601 encoding, but it allows for R', G' and B' values
  that are outside the range [0…1]. The resulting Y', Cb and Cr values are
-scaled and offset:
+scaled and offset according to the limited range formula:

  .. math::

@@ -198,10 +198,14 @@ scaled and offset:
      Cr = \frac{224}{256} * (0.5R' - 0.4187G' - 0.0813B')

  Y' is clamped to the range [0…1] and Cb and Cr are clamped to the range
-[-0.5…0.5]. The non-standard xvYCC 709 or xvYCC 601 encodings can be
+[-0.5…0.5] and quantized without further scaling or offsets.
+The non-standard xvYCC 709 or xvYCC 601 encodings can be
  used by selecting ``V4L2_YCBCR_ENC_XV709`` or ``V4L2_YCBCR_ENC_XV601``.
-The xvYCC encodings always use full range quantization.
-
+As seen by the xvYCC formulas these encodings always use limited range quantization,
+there is no full range variant. The whole point of these extended gamut encodings
+is that values outside the limited range are still valid, although they
+map to R', G' and B' values outside the [0…1] range and are therefore outside
+the Rec. 709 colorspace gamut.

  .. _col-srgb:

diff --git a/include/uapi/linux/videodev2.h b/include/uapi/linux/videodev2.h
index 45184a2ef66c..316be62f3a45 100644
--- a/include/uapi/linux/videodev2.h
+++ b/include/uapi/linux/videodev2.h
@@ -378,8 +378,7 @@ enum v4l2_quantization {
  #define V4L2_MAP_QUANTIZATION_DEFAULT(is_rgb_or_hsv, colsp, ycbcr_enc) \
  	(((is_rgb_or_hsv) && (colsp) == V4L2_COLORSPACE_BT2020) ? \
  	 V4L2_QUANTIZATION_LIM_RANGE : \
-	 (((is_rgb_or_hsv) || (ycbcr_enc) == V4L2_YCBCR_ENC_XV601 || \
-	  (ycbcr_enc) == V4L2_YCBCR_ENC_XV709 || (colsp) == V4L2_COLORSPACE_JPEG) ? \
+	 (((is_rgb_or_hsv) || (colsp) == V4L2_COLORSPACE_JPEG) ? \
  	 V4L2_QUANTIZATION_FULL_RANGE : V4L2_QUANTIZATION_LIM_RANGE))

  enum v4l2_priority {
