Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35633 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753982AbcHSDqJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 Aug 2016 23:46:09 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Markus Heiser <markus.heiser@darmarit.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Markus Heiser <markus.heiser@darmarIT.de>
Subject: [PATCH 08/20] [media] pixfmt-packed-yuv.rst: adjust tables to fit in LaTeX
Date: Thu, 18 Aug 2016 13:15:37 -0300
Message-Id: <ef5c1b9cec4a8ab3de20c2f13593775745cb77b1.1471532123.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471532122.git.mchehab@s-opensource.com>
References: <cover.1471532122.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471532122.git.mchehab@s-opensource.com>
References: <cover.1471532122.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adjust the table to fit at the LaTeX and PDF outputs, just like
what was done with pixfmt-packed-rgb.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/v4l/pixfmt-packed-yuv.rst | 26 ++++++++++++++--------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/Documentation/media/uapi/v4l/pixfmt-packed-yuv.rst b/Documentation/media/uapi/v4l/pixfmt-packed-yuv.rst
index 54716455f453..2ffcee5b383b 100644
--- a/Documentation/media/uapi/v4l/pixfmt-packed-yuv.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-packed-yuv.rst
@@ -6,18 +6,19 @@
 Packed YUV formats
 ******************
 
-*man Packed YUV formats(2)*
-
-Packed YUV formats
-
-
 Description
 ===========
 
 Similar to the packed RGB formats these formats store the Y, Cb and Cr
 component of each pixel in one 16 or 32 bit word.
 
+.. raw:: latex
 
+    \newline\newline\begin{adjustbox}{width=\columnwidth}
+
+.. _rgb-formats:
+
+.. tabularcolumns:: |p{4.5cm}|p{3.3cm}|p{0.7cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.2cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.2cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.2cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{1.7cm}|
 
 .. flat-table:: Packed YUV Image Formats
     :header-rows:  2
@@ -309,8 +310,15 @@ component of each pixel in one 16 or 32 bit word.
 
        -  Cr\ :sub:`0`
 
+.. raw:: latex
 
-Bit 7 is the most significant bit. The value of a = alpha bits is
-undefined when reading from the driver, ignored when writing to the
-driver, except when alpha blending has been negotiated for a
-:ref:`Video Overlay <overlay>` or :ref:`Video Output Overlay <osd>`.
+    \end{adjustbox}\newline\newline
+
+.. note::
+
+    #) Bit 7 is the most significant bit;
+
+    #) The value of a = alpha bits is undefined when reading from the driver,
+       ignored when writing to the driver, except when alpha blending has
+       been negotiated for a :ref:`Video Overlay <overlay>` or
+       :ref:`Video Output Overlay <osd>`.
-- 
2.7.4


