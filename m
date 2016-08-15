Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:51019 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419AbcHOVXR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Aug 2016 17:23:17 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Markus Heiser <markus.heiser@darmarIT.de>,
	linux-doc@vger.kernel.org
Subject: [PATCH RFC v2 4/9] [media] pixfmt-007.rst: use Sphinx math:: expressions
Date: Mon, 15 Aug 2016 18:21:55 -0300
Message-Id: <beea4df7a18fad73f5092728f052ea7ab654a917.1471294965.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471294965.git.mchehab@s-opensource.com>
References: <cover.1471294965.git.mchehab@s-opensource.com>
MIME-Version: 1.0
In-Reply-To: <cover.1471294965.git.mchehab@s-opensource.com>
References: <cover.1471294965.git.mchehab@s-opensource.com>
Content-Type: text/plain; charset=true
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Enrich math formulas by using the Sphinx math. That will allow
using those formulas on pdf documents as well.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/conf.py                       |   9 +-
 Documentation/media/uapi/v4l/pixfmt-007.rst | 175 ++++++++++++++++++----------
 2 files changed, 115 insertions(+), 69 deletions(-)

diff --git a/Documentation/conf.py b/Documentation/conf.py
index f4469cd0340d..e081f56a019c 100644
--- a/Documentation/conf.py
+++ b/Documentation/conf.py
@@ -28,14 +28,7 @@ sys.path.insert(0, os.path.abspath('sphinx'))
 # Add any Sphinx extension module names here, as strings. They can be
 # extensions coming with Sphinx (named 'sphinx.ext.*') or your custom
 # ones.
-extensions = ['kernel-doc', 'rstFlatTable', 'kernel_include']
-
-# Gracefully handle missing rst2pdf.
-try:
-    import rst2pdf
-    extensions += ['rst2pdf.pdfbuilder']
-except ImportError:
-    pass
+extensions = ['sphinx.ext.imgmath', 'kernel-doc', 'rstFlatTable', 'kernel_include']
 
 # Add any paths that contain templates here, relative to this directory.
 templates_path = ['_templates']
diff --git a/Documentation/media/uapi/v4l/pixfmt-007.rst b/Documentation/media/uapi/v4l/pixfmt-007.rst
index 8c946b0c63a0..2ecace31b9f5 100644
--- a/Documentation/media/uapi/v4l/pixfmt-007.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-007.rst
@@ -72,23 +72,29 @@ SMPTE C set, so this colorspace is sometimes called SMPTE C as well.
 The transfer function defined for SMPTE 170M is the same as the one
 defined in Rec. 709.
 
-    L' = -1.099(-L) :sup:`0.45` + 0.099 for L ≤ -0.018
+.. math::
 
-    L' = 4.5L for -0.018 < L < 0.018
+    L' = -1.099(-L)^{0.45} + 0.099 \text{, for } L \le-0.018
 
-    L' = 1.099L :sup:`0.45` - 0.099 for L ≥ 0.018
+    L' = 4.5L \text{, for } -0.018 < L < 0.018
+
+    L' = 1.099L^{0.45} - 0.099 \text{, for } L \ge 0.018
 
 Inverse Transfer function:
 
-    L = -((L' - 0.099) / -1.099) :sup:`1/0.45` for L' ≤ -0.081
+.. math::
 
-    L = L' / 4.5 for -0.081 < L' < 0.081
+    L = -\left( \frac{L' - 0.099}{-1.099} \right) ^{\frac{1}{0.45}} \text{, for } L' \le -0.081
 
-    L = ((L' + 0.099) / 1.099) :sup:`1/0.45` for L' ≥ 0.081
+    L = \frac{L'}{4.5} \text{, for } -0.081 < L' < 0.081
+
+    L = \left(\frac{L' + 0.099}{1.099}\right)^{\frac{1}{0.45} } \text{, for } L' \ge 0.081
 
 The luminance (Y') and color difference (Cb and Cr) are obtained with
 the following ``V4L2_YCBCR_ENC_601`` encoding:
 
+.. math::
+
     Y' = 0.299R' + 0.587G' + 0.114B'
 
     Cb = -0.169R' - 0.331G' + 0.5B'
@@ -169,23 +175,29 @@ The full name of this standard is Rec. ITU-R BT.709-5.
 Transfer function. Normally L is in the range [0…1], but for the
 extended gamut xvYCC encoding values outside that range are allowed.
 
-    L' = -1.099(-L) :sup:`0.45` + 0.099 for L ≤ -0.018
+.. math::
 
-    L' = 4.5L for -0.018 < L < 0.018
+    L' = -1.099(-L)^{0.45} + 0.099 \text{, for } L \le -0.018
 
-    L' = 1.099L :sup:`0.45` - 0.099 for L ≥ 0.018
+    L' = 4.5L \text{, for } -0.018 < L < 0.018
+
+    L' = 1.099L^{0.45} - 0.099 \text{, for } L \ge 0.018
 
 Inverse Transfer function:
 
-    L = -((L' - 0.099) / -1.099) :sup:`1/0.45` for L' ≤ -0.081
+.. math::
 
-    L = L' / 4.5 for -0.081 < L' < 0.081
+    L = -\left( \frac{L' - 0.099}{-1.099} \right)^\frac{1}{0.45} \text{, for } L' \le -0.081
 
-    L = ((L' + 0.099) / 1.099) :sup:`1/0.45` for L' ≥ 0.081
+    L = \frac{L'}{4.5}\text{, for } -0.081 < L' < 0.081
+
+    L = \left(\frac{L' + 0.099}{1.099}\right)^{\frac{1}{0.45} } \text{, for } L' \ge 0.081
 
 The luminance (Y') and color difference (Cb and Cr) are obtained with
 the following ``V4L2_YCBCR_ENC_709`` encoding:
 
+.. math::
+
     Y' = 0.2126R' + 0.7152G' + 0.0722B'
 
     Cb = -0.1146R' - 0.3854G' + 0.5B'
@@ -210,22 +222,26 @@ similar to the Rec. 709 encoding, but it allows for R', G' and B' values
 that are outside the range [0…1]. The resulting Y', Cb and Cr values are
 scaled and offset:
 
-    Y' = (219 / 256) * (0.2126R' + 0.7152G' + 0.0722B') + (16 / 256)
+.. math::
 
-    Cb = (224 / 256) * (-0.1146R' - 0.3854G' + 0.5B')
+    Y' = \frac{219}{256} * (0.2126R' + 0.7152G' + 0.0722B') + \frac{16}{256}
 
-    Cr = (224 / 256) * (0.5R' - 0.4542G' - 0.0458B')
+    Cb = \frac{224}{256} * (-0.1146R' - 0.3854G' + 0.5B')
+
+    Cr = \frac{224}{256} * (0.5R' - 0.4542G' - 0.0458B')
 
 The xvYCC 601 encoding (``V4L2_YCBCR_ENC_XV601``, :ref:`xvycc`) is
 similar to the BT.601 encoding, but it allows for R', G' and B' values
 that are outside the range [0…1]. The resulting Y', Cb and Cr values are
 scaled and offset:
 
-    Y' = (219 / 256) * (0.299R' + 0.587G' + 0.114B') + (16 / 256)
+.. math::
 
-    Cb = (224 / 256) * (-0.169R' - 0.331G' + 0.5B')
+    Y' = \frac{219}{256} * (0.299R' + 0.587G' + 0.114B') + \frac{16}{256}
 
-    Cr = (224 / 256) * (0.5R' - 0.419G' - 0.081B')
+    Cb = \frac{224}{256} * (-0.169R' - 0.331G' + 0.5B')
+
+    Cr = \frac{224}{256} * (0.5R' - 0.419G' - 0.081B')
 
 Y' is clamped to the range [0…1] and Cb and Cr are clamped to the range
 [-0.5…0.5]. The non-standard xvYCC 709 or xvYCC 601 encodings can be
@@ -298,24 +314,30 @@ These chromaticities are identical to the Rec. 709 colorspace.
 Transfer function. Note that negative values for L are only used by the
 Y'CbCr conversion.
 
-    L' = -1.055(-L) :sup:`1/2.4` + 0.055 for L < -0.0031308
+.. math::
 
-    L' = 12.92L for -0.0031308 ≤ L ≤ 0.0031308
+    L' = -1.055(-L)^{\frac{1}{2.4} } + 0.055\text{, for }L < -0.0031308
 
-    L' = 1.055L :sup:`1/2.4` - 0.055 for 0.0031308 < L ≤ 1
+    L' = 12.92L\text{, for }-0.0031308 \le L \le 0.0031308
+
+    L' = 1.055L ^{\frac{1}{2.4} } - 0.055\text{, for }0.0031308 < L \le 1
 
 Inverse Transfer function:
 
-    L = -((-L' + 0.055) / 1.055) :sup:`2.4` for L' < -0.04045
+.. math::
 
-    L = L' / 12.92 for -0.04045 ≤ L' ≤ 0.04045
+    L = -((-L' + 0.055) / 1.055) ^{2.4}\text{, for }L' < -0.04045
 
-    L = ((L' + 0.055) / 1.055) :sup:`2.4` for L' > 0.04045
+    L = L' / 12.92\text{, for }-0.04045 \le L' \le 0.04045
+
+    L = ((L' + 0.055) / 1.055) ^{2.4}\text{, for }L' > 0.04045
 
 The luminance (Y') and color difference (Cb and Cr) are obtained with
 the following ``V4L2_YCBCR_ENC_SYCC`` encoding as defined by
 :ref:`sycc`:
 
+.. math::
+
     Y' = 0.2990R' + 0.5870G' + 0.1140B'
 
     Cb = -0.1687R' - 0.3313G' + 0.5B'
@@ -395,15 +417,21 @@ are:
 
 Transfer function:
 
-    L' = L :sup:`1/2.19921875`
+.. math::
+
+    L' = L ^{\frac{1}{2.19921875}}
 
 Inverse Transfer function:
 
-    L = L' :sup:`2.19921875`
+.. math::
+
+    L = L'^{(2.19921875)}
 
 The luminance (Y') and color difference (Cb and Cr) are obtained with
 the following ``V4L2_YCBCR_ENC_601`` encoding:
 
+.. math::
+
     Y' = 0.299R' + 0.587G' + 0.114B'
 
     Cb = -0.169R' - 0.331G' + 0.5B'
@@ -479,19 +507,25 @@ of the primary colors and the white reference are:
 
 Transfer function (same as Rec. 709):
 
-    L' = 4.5L for 0 ≤ L < 0.018
+.. math::
 
-    L' = 1.099L :sup:`0.45` - 0.099 for 0.018 ≤ L ≤ 1
+    L' = 4.5L\text{, for }0 \le L < 0.018
+
+    L' = 1.099L ^{0.45} - 0.099\text{, for } 0.018 \le L \le 1
 
 Inverse Transfer function:
 
-    L = L' / 4.5 for L' < 0.081
+.. math::
 
-    L = ((L' + 0.099) / 1.099) :sup:`1/0.45` for L' ≥ 0.081
+    L = L' / 4.5\text{, for } L' < 0.081
+
+    L = \left( \frac{L' + 0.099}{1.099}\right) ^{\frac{1}{0.45} }\text{, for } L' \ge 0.081
 
 The luminance (Y') and color difference (Cb and Cr) are obtained with
 the following ``V4L2_YCBCR_ENC_BT2020`` encoding:
 
+.. math::
+
     Y' = 0.2627R' + 0.6780G' + 0.0593B'
 
     Cb = -0.1396R' - 0.3604G' + 0.5B'
@@ -506,23 +540,20 @@ There is also an alternate constant luminance R'G'B' to Yc'CbcCrc
 
 Luma:
 
-    Yc' = (0.2627R + 0.6780G + 0.0593B)'
-
-B' - Yc' ≤ 0:
-
-    Cbc = (B' - Yc') / 1.9404
-
-B' - Yc' > 0:
-
-    Cbc = (B' - Yc') / 1.5816
-
-R' - Yc' ≤ 0:
-
-    Crc = (R' - Y') / 1.7184
-
-R' - Yc' > 0:
-
-    Crc = (R' - Y') / 0.9936
+.. math::
+    :nowrap:
+
+    \begin{align*}
+    Yc' = (0.2627R + 0.6780G + 0.0593B)'& \\
+    B' - Yc' \le 0:& \\
+        &Cbc = (B' - Yc') / 1.9404 \\
+    B' - Yc' > 0: & \\
+        &Cbc = (B' - Yc') / 1.5816 \\
+    R' - Yc' \le 0:& \\
+        &Crc = (R' - Y') / 1.7184 \\
+    R' - Yc' > 0:& \\
+        &Crc = (R' - Y') / 0.9936
+    \end{align*}
 
 Yc' is clamped to the range [0…1] and Cbc and Crc are clamped to the
 range [-0.5…0.5]. The Yc'CbcCrc quantization is limited range.
@@ -596,11 +627,15 @@ is ``V4L2_XFER_FUNC_DCI_P3``. The default Y'CbCr encoding is
 
 Transfer function:
 
-    L' = L :sup:`1/2.6`
+.. math::
+
+    L' = L^{\frac{1}{2.6}}
 
 Inverse Transfer function:
 
-    L = L' :sup:`2.6`
+.. math::
+
+    L = L'^{(2.6)}
 
 Y'CbCr encoding is not specified. V4L2 defaults to Rec. 709.
 
@@ -670,19 +705,25 @@ These chromaticities are identical to the SMPTE 170M colorspace.
 
 Transfer function:
 
-    L' = 4L for 0 ≤ L < 0.0228
+.. math::
 
-    L' = 1.1115L :sup:`0.45` - 0.1115 for 0.0228 ≤ L ≤ 1
+    L' = 4L\text{, for } 0 \le L < 0.0228
+
+    L' = 1.1115L ^{0.45} - 0.1115\text{, for } 0.0228 \le L \le 1
 
 Inverse Transfer function:
 
-    L = L' / 4 for 0 ≤ L' < 0.0913
+.. math::
 
-    L = ((L' + 0.1115) / 1.1115) :sup:`1/0.45` for L' ≥ 0.0913
+    L = \frac{L'}{4}\text{, for } 0 \le L' < 0.0913
+
+    L = \left( \frac{L' + 0.1115}{1.1115}\right) ^{\frac{1}{0.45} }\text{, for } L' \ge 0.0913
 
 The luminance (Y') and color difference (Cb and Cr) are obtained with
 the following ``V4L2_YCBCR_ENC_SMPTE240M`` encoding:
 
+.. math::
+
     Y' = 0.2122R' + 0.7013G' + 0.0865B'
 
     Cb = -0.1161R' - 0.3839G' + 0.5B'
@@ -762,19 +803,25 @@ reference are:
 The transfer function was never properly defined for NTSC 1953. The Rec.
 709 transfer function is recommended in the literature:
 
-    L' = 4.5L for 0 ≤ L < 0.018
+.. math::
 
-    L' = 1.099L :sup:`0.45` - 0.099 for 0.018 ≤ L ≤ 1
+    L' = 4.5L\text{, for } 0 \le L < 0.018
+
+    L' = 1.099L ^{0.45} - 0.099\text{, for } 0.018 \le L \le 1
 
 Inverse Transfer function:
 
-    L = L' / 4.5 for L' < 0.081
+.. math::
 
-    L = ((L' + 0.099) / 1.099) :sup:`1/0.45` for L' ≥ 0.081
+    L = \frac{L'}{4.5} \text{, for } L' < 0.081
+
+    L = \left( \frac{L' + 0.099}{1.099}\right) ^{\frac{1}{0.45} }\text{, for } L' \ge 0.081
 
 The luminance (Y') and color difference (Cb and Cr) are obtained with
 the following ``V4L2_YCBCR_ENC_601`` encoding:
 
+.. math::
+
     Y' = 0.299R' + 0.587G' + 0.114B'
 
     Cb = -0.169R' - 0.331G' + 0.5B'
@@ -852,19 +899,25 @@ are:
 The transfer function was never properly defined for this colorspace.
 The Rec. 709 transfer function is recommended in the literature:
 
-    L' = 4.5L for 0 ≤ L < 0.018
+.. math::
 
-    L' = 1.099L :sup:`0.45` - 0.099 for 0.018 ≤ L ≤ 1
+    L' = 4.5L\text{, for } 0 \le L < 0.018
+
+    L' = 1.099L ^{0.45} - 0.099\text{, for } 0.018 \le L \le 1
 
 Inverse Transfer function:
 
-    L = L' / 4.5 for L' < 0.081
+.. math::
 
-    L = ((L' + 0.099) / 1.099) :sup:`1/0.45` for L' ≥ 0.081
+    L = \frac{L'}{4.5} \text{, for } L' < 0.081
+
+    L = \left(\frac{L' + 0.099}{1.099} \right) ^{\frac{1}{0.45} }\text{, for } L' \ge 0.081
 
 The luminance (Y') and color difference (Cb and Cr) are obtained with
 the following ``V4L2_YCBCR_ENC_601`` encoding:
 
+.. math::
+
     Y' = 0.299R' + 0.587G' + 0.114B'
 
     Cb = -0.169R' - 0.331G' + 0.5B'
-- 
2.7.4


