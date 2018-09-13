Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud9.xs4all.net ([194.109.24.26]:42554 "EHLO
        lb2-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727051AbeIMQ4p (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 13 Sep 2018 12:56:45 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, Hans Verkuil <hansverk@cisco.com>
Subject: [PATCH 2/5] media colorspaces*.rst: rename AdobeRGB to opRGB
Date: Thu, 13 Sep 2018 13:47:28 +0200
Message-Id: <20180913114731.16500-3-hverkuil@xs4all.nl>
In-Reply-To: <20180913114731.16500-1-hverkuil@xs4all.nl>
References: <20180913114731.16500-1-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hansverk@cisco.com>

Drop all Adobe references and use the official opRGB standard
instead.

Signed-off-by: Hans Verkuil <hansverk@cisco.com>
---
 Documentation/media/uapi/v4l/biblio.rst             | 10 ----------
 Documentation/media/uapi/v4l/colorspaces-defs.rst   |  8 ++++----
 .../media/uapi/v4l/colorspaces-details.rst          | 13 ++++++-------
 3 files changed, 10 insertions(+), 21 deletions(-)

diff --git a/Documentation/media/uapi/v4l/biblio.rst b/Documentation/media/uapi/v4l/biblio.rst
index 1cedcfc04327..386d6cf83e9c 100644
--- a/Documentation/media/uapi/v4l/biblio.rst
+++ b/Documentation/media/uapi/v4l/biblio.rst
@@ -226,16 +226,6 @@ xvYCC
 
 :author:    International Electrotechnical Commission (http://www.iec.ch)
 
-.. _adobergb:
-
-AdobeRGB
-========
-
-
-:title:     Adobe© RGB (1998) Color Image Encoding Version 2005-05
-
-:author:    Adobe Systems Incorporated (http://www.adobe.com)
-
 .. _oprgb:
 
 opRGB
diff --git a/Documentation/media/uapi/v4l/colorspaces-defs.rst b/Documentation/media/uapi/v4l/colorspaces-defs.rst
index 410907fe9415..f24615544792 100644
--- a/Documentation/media/uapi/v4l/colorspaces-defs.rst
+++ b/Documentation/media/uapi/v4l/colorspaces-defs.rst
@@ -51,8 +51,8 @@ whole range, 0-255, dividing the angular value by 1.41. The enum
       - See :ref:`col-rec709`.
     * - ``V4L2_COLORSPACE_SRGB``
       - See :ref:`col-srgb`.
-    * - ``V4L2_COLORSPACE_ADOBERGB``
-      - See :ref:`col-adobergb`.
+    * - ``V4L2_COLORSPACE_OPRGB``
+      - See :ref:`col-oprgb`.
     * - ``V4L2_COLORSPACE_BT2020``
       - See :ref:`col-bt2020`.
     * - ``V4L2_COLORSPACE_DCI_P3``
@@ -90,8 +90,8 @@ whole range, 0-255, dividing the angular value by 1.41. The enum
       - Use the Rec. 709 transfer function.
     * - ``V4L2_XFER_FUNC_SRGB``
       - Use the sRGB transfer function.
-    * - ``V4L2_XFER_FUNC_ADOBERGB``
-      - Use the AdobeRGB transfer function.
+    * - ``V4L2_XFER_FUNC_OPRGB``
+      - Use the opRGB transfer function.
     * - ``V4L2_XFER_FUNC_SMPTE240M``
       - Use the SMPTE 240M transfer function.
     * - ``V4L2_XFER_FUNC_NONE``
diff --git a/Documentation/media/uapi/v4l/colorspaces-details.rst b/Documentation/media/uapi/v4l/colorspaces-details.rst
index b5d551b9cc8f..09fabf4cd412 100644
--- a/Documentation/media/uapi/v4l/colorspaces-details.rst
+++ b/Documentation/media/uapi/v4l/colorspaces-details.rst
@@ -290,15 +290,14 @@ Y' is clamped to the range [0…1] and Cb and Cr are clamped to the range
 170M/BT.601. The Y'CbCr quantization is limited range.
 
 
-.. _col-adobergb:
+.. _col-oprgb:
 
-Colorspace Adobe RGB (V4L2_COLORSPACE_ADOBERGB)
+Colorspace opRGB (V4L2_COLORSPACE_OPRGB)
 ===============================================
 
-The :ref:`adobergb` standard defines the colorspace used by computer
-graphics that use the AdobeRGB colorspace. This is also known as the
-:ref:`oprgb` standard. The default transfer function is
-``V4L2_XFER_FUNC_ADOBERGB``. The default Y'CbCr encoding is
+The :ref:`oprgb` standard defines the colorspace used by computer
+graphics that use the opRGB colorspace. The default transfer function is
+``V4L2_XFER_FUNC_OPRGB``. The default Y'CbCr encoding is
 ``V4L2_YCBCR_ENC_601``. The default Y'CbCr quantization is limited
 range.
 
@@ -312,7 +311,7 @@ The chromaticities of the primary colors and the white reference are:
 
 .. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
 
-.. flat-table:: Adobe RGB Chromaticities
+.. flat-table:: opRGB Chromaticities
     :header-rows:  1
     :stub-columns: 0
     :widths:       1 1 2
-- 
2.18.0
