Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43169 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754496AbcHSNFK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Aug 2016 09:05:10 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Markus Heiser <markus.heiser@darmarit.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Markus Heiser <markus.heiser@darmarIT.de>
Subject: [PATCH 07/15] [media] vidioc-g-tuner.rst: Fix tables to fit at LaTeX output
Date: Fri, 19 Aug 2016 10:04:57 -0300
Message-Id: <20447adf5ee08e29a80ebda9599fad5ee7f12864.1471611003.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471611003.git.mchehab@s-opensource.com>
References: <cover.1471611003.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471611003.git.mchehab@s-opensource.com>
References: <cover.1471611003.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Several tables are missing column definitions and/or are too big
to fit into the page. Adjust them.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/v4l/vidioc-g-tuner.rst | 32 ++++++++++++++++++-------
 1 file changed, 24 insertions(+), 8 deletions(-)

diff --git a/Documentation/media/uapi/v4l/vidioc-g-tuner.rst b/Documentation/media/uapi/v4l/vidioc-g-tuner.rst
index 740a4dd0db00..a52efdf94795 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-tuner.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-tuner.rst
@@ -60,8 +60,12 @@ To change the radio frequency the
 :ref:`VIDIOC_S_FREQUENCY <VIDIOC_G_FREQUENCY>` ioctl is available.
 
 
+ .. tabularcolumns:: |p{1.3cm}|p{3.0cm}|p{6.6cm}|p{6.6cm}|
+
 .. _v4l2-tuner:
 
+.. cssclass:: longtable
+
 .. flat-table:: struct v4l2_tuner
     :header-rows:  0
     :stub-columns: 0
@@ -83,8 +87,9 @@ To change the radio frequency the
 
        -  :cspan:`1`
 
-	  Name of the tuner, a NUL-terminated ASCII string. This information
-	  is intended for the user.
+	  Name of the tuner, a NUL-terminated ASCII string.
+
+	  This information is intended for the user.
 
     -  .. row 3
 
@@ -230,8 +235,9 @@ To change the radio frequency the
 
        -  ``signal``
 
-       -  :cspan:`1` The signal strength if known, ranging from 0 to
-	  65535. Higher values indicate a better signal.
+       -  :cspan:`1` The signal strength if known.
+
+	  Ranging from 0 to 65535. Higher values indicate a better signal.
 
     -  .. row 16
 
@@ -239,8 +245,10 @@ To change the radio frequency the
 
        -  ``afc``
 
-       -  :cspan:`1` Automatic frequency control: When the ``afc`` value
-	  is negative, the frequency is too low, when positive too high.
+       -  :cspan:`1` Automatic frequency control.
+
+	  When the ``afc`` value is negative, the frequency is too
+	  low, when positive too high.
 
     -  .. row 17
 
@@ -248,8 +256,9 @@ To change the radio frequency the
 
        -  ``reserved``\ [4]
 
-       -  :cspan:`1` Reserved for future extensions. Drivers and
-	  applications must set the array to zero.
+       -  :cspan:`1` Reserved for future extensions.
+
+	   Drivers and applications must set the array to zero.
 
 
 
@@ -301,6 +310,8 @@ To change the radio frequency the
 
 .. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
 
+.. cssclass:: longtable
+
 .. flat-table:: Tuner and Modulator Capability Flags
     :header-rows:  0
     :stub-columns: 0
@@ -608,7 +619,9 @@ To change the radio frequency the
 	  ``MODE_MONO``. Only ``V4L2_TUNER_ANALOG_TV`` tuners support this
 	  mode.
 
+.. raw:: latex
 
+    \newline\newline\begin{adjustbox}{width=\columnwidth}
 
 .. _tuner-matrix:
 
@@ -706,6 +719,9 @@ To change the radio frequency the
 
        -  Lang1/Lang2 (preferred) or Lang1/Lang1
 
+.. raw:: latex
+
+    \end{adjustbox}\newline\newline
 
 Return Value
 ============
-- 
2.7.4


