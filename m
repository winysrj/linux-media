Return-path: <linux-media-owner@vger.kernel.org>
Received: from aer-iport-2.cisco.com ([173.38.203.52]:14485 "EHLO
	aer-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754924AbcGLObR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jul 2016 10:31:17 -0400
Received: from [10.47.79.81] ([10.47.79.81])
	(authenticated bits=0)
	by aer-core-3.cisco.com (8.14.5/8.14.5) with ESMTP id u6CEVFgO014421
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-media@vger.kernel.org>; Tue, 12 Jul 2016 14:31:15 GMT
To: linux-media <linux-media@vger.kernel.org>
From: Hans Verkuil <hansverk@cisco.com>
Subject: [PATCH] pixfmt-006.rst: add missing V4L2_YCBCR_ENC_SMPTE240M
Message-ID: <5784FF33.6000309@cisco.com>
Date: Tue, 12 Jul 2016 16:31:15 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Fix missing reference.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/Documentation/media/uapi/v4l/pixfmt-006.rst b/Documentation/media/uapi/v4l/pixfmt-006.rst
index 9a0f494..987b9a8 100644
--- a/Documentation/media/uapi/v4l/pixfmt-006.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-006.rst
@@ -240,6 +240,12 @@ needs to be filled in.

        -  Use the constant luminance BT.2020 Yc'CbcCrc encoding.

+    -  .. row 10
+
+       -  ``V4L2_YCBCR_ENC_SMPTE_240M``
+
+       -  Use the SMPTE 240M Y'CbCr encoding.
+


 .. _v4l2-quantization:
diff --git a/Documentation/media/videodev2.h.rst.exceptions b/Documentation/media/videodev2.h.rst.exceptions
index c15660f..8852b99 100644
--- a/Documentation/media/videodev2.h.rst.exceptions
+++ b/Documentation/media/videodev2.h.rst.exceptions
@@ -85,9 +85,7 @@ replace symbol V4L2_YCBCR_ENC_DEFAULT v4l2-ycbcr-encoding
 replace symbol V4L2_YCBCR_ENC_SYCC v4l2-ycbcr-encoding
 replace symbol V4L2_YCBCR_ENC_XV601 v4l2-ycbcr-encoding
 replace symbol V4L2_YCBCR_ENC_XV709 v4l2-ycbcr-encoding
-
-# Is this deprecated, or just a missing reference?
-replace symbol V4L2_YCBCR_ENC_SMPTE240M v4l2-ycbcr-encoding-FIXME
+replace symbol V4L2_YCBCR_ENC_SMPTE240M v4l2-ycbcr-encoding

 # Documented enum v4l2_quantization
 replace symbol V4L2_QUANTIZATION_DEFAULT v4l2-quantization
