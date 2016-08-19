Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43184 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754574AbcHSNFK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 19 Aug 2016 09:05:10 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Markus Heiser <markus.heiser@darmarit.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Markus Heiser <markus.heiser@darmarIT.de>,
        Hans Verkuil <hansverk@cisco.com>
Subject: [PATCH 05/15] [media] adjust some vidioc-*rst tables with wrong columns
Date: Fri, 19 Aug 2016 10:04:55 -0300
Message-Id: <6f65cfea6eae8452be7500e01d8724524719f372.1471611003.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471611003.git.mchehab@s-opensource.com>
References: <cover.1471611003.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1471611003.git.mchehab@s-opensource.com>
References: <cover.1471611003.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Adjust simple cases where the columns on some vidioc files
are overriding their neighbours.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/v4l/vidioc-dqevent.rst         |  2 ++
 Documentation/media/uapi/v4l/vidioc-enum-fmt.rst        |  4 +++-
 Documentation/media/uapi/v4l/vidioc-enum-freq-bands.rst |  5 +++--
 Documentation/media/uapi/v4l/vidioc-enuminput.rst       |  2 ++
 Documentation/media/uapi/v4l/vidioc-enumoutput.rst      |  2 +-
 Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst    | 11 +----------
 Documentation/media/uapi/v4l/vidioc-g-enc-index.rst     |  6 +++---
 Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst     | 14 ++++++++++----
 Documentation/media/uapi/v4l/vidioc-g-fbuf.rst          |  4 ++++
 Documentation/media/uapi/v4l/vidioc-g-fmt.rst           |  2 ++
 Documentation/media/uapi/v4l/vidioc-g-jpegcomp.rst      |  2 +-
 Documentation/media/uapi/v4l/vidioc-g-modulator.rst     | 10 ++++++----
 Documentation/media/uapi/v4l/vidioc-queryctrl.rst       | 16 ++++++++++++----
 13 files changed, 50 insertions(+), 30 deletions(-)

diff --git a/Documentation/media/uapi/v4l/vidioc-dqevent.rst b/Documentation/media/uapi/v4l/vidioc-dqevent.rst
index 6cd5d7068065..ad4b826a2966 100644
--- a/Documentation/media/uapi/v4l/vidioc-dqevent.rst
+++ b/Documentation/media/uapi/v4l/vidioc-dqevent.rst
@@ -183,6 +183,8 @@ call.
 
 .. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
 
+.. cssclass:: longtable
+
 .. flat-table:: Event Types
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/vidioc-enum-fmt.rst b/Documentation/media/uapi/v4l/vidioc-enum-fmt.rst
index 6bb30ade6aad..2d1444b0d017 100644
--- a/Documentation/media/uapi/v4l/vidioc-enum-fmt.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enum-fmt.rst
@@ -108,7 +108,9 @@ one until ``EINVAL`` is returned.
        -  :cspan:`2`
 
 	  .. _v4l2-fourcc:
-	  ``#define v4l2_fourcc(a,b,c,d) (((__u32)(a)<<0)|((__u32)(b)<<8)|((__u32)(c)<<16)|((__u32)(d)<<24))``
+	  ``#define v4l2_fourcc(a,b,c,d)``
+
+	  ``(((__u32)(a)<<0)|((__u32)(b)<<8)|((__u32)(c)<<16)|((__u32)(d)<<24))``
 
 	  Several image formats are already defined by this specification in
 	  :ref:`pixfmt`.
diff --git a/Documentation/media/uapi/v4l/vidioc-enum-freq-bands.rst b/Documentation/media/uapi/v4l/vidioc-enum-freq-bands.rst
index ea1ccfb43e6d..c6ae6f14c9f6 100644
--- a/Documentation/media/uapi/v4l/vidioc-enum-freq-bands.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enum-freq-bands.rst
@@ -146,8 +146,9 @@ of the corresponding tuner/modulator is set.
 
        -  ``reserved``\ [9]
 
-       -  Reserved for future extensions. Applications and drivers must set
-	  the array to zero.
+       -  Reserved for future extensions.
+
+	  Applications and drivers must set the array to zero.
 
 
 
diff --git a/Documentation/media/uapi/v4l/vidioc-enuminput.rst b/Documentation/media/uapi/v4l/vidioc-enuminput.rst
index 6b90a1a3506d..8f0b821bd921 100644
--- a/Documentation/media/uapi/v4l/vidioc-enuminput.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enuminput.rst
@@ -181,6 +181,8 @@ at index zero, incrementing by one until the driver returns ``EINVAL``.
 
 .. _input-status:
 
+.. tabularcolumns:: |p{4.8cm}|p{2.6cm}|p{10.1cm}|
+
 .. flat-table:: Input Status Flags
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/vidioc-enumoutput.rst b/Documentation/media/uapi/v4l/vidioc-enumoutput.rst
index 13939d8d4358..456013fb50a2 100644
--- a/Documentation/media/uapi/v4l/vidioc-enumoutput.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enumoutput.rst
@@ -142,7 +142,7 @@ EINVAL.
 
 .. _output-type:
 
-.. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
+.. tabularcolumns:: |p{7.0cm}|p{1.8cm}|p{8.7cm}|
 
 .. flat-table:: Output Type
     :header-rows:  0
diff --git a/Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst b/Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst
index d2ea3bf01fce..58dec578f54d 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst
@@ -316,11 +316,6 @@ EBUSY
 
        -  Description
 
-    -  .. row 2
-
-       -
-       -
-
     -  .. row 3
 
        -  ``V4L2_DV_BT_STD_CEA861``
@@ -346,6 +341,7 @@ EBUSY
        -  The timings follow the VESA Generalized Timings Formula standard
 
 
+.. tabularcolumns:: |p{6.0cm}|p{11.5cm}|
 
 .. _dv-bt-flags:
 
@@ -360,11 +356,6 @@ EBUSY
 
        -  Description
 
-    -  .. row 2
-
-       -
-       -
-
     -  .. row 3
 
        -  ``V4L2_DV_FL_REDUCED_BLANKING``
diff --git a/Documentation/media/uapi/v4l/vidioc-g-enc-index.rst b/Documentation/media/uapi/v4l/vidioc-g-enc-index.rst
index cb094b589f0e..9cb98a8eaf2d 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-enc-index.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-enc-index.rst
@@ -59,12 +59,12 @@ video elementary streams.
 
 .. _v4l2-enc-idx:
 
-.. tabularcolumns:: |p{2.9cm}|p{2.9cm}|p{5.8cm}|p{2.9cm}|p{3.0cm}|
+.. tabularcolumns:: |p{3.5cm}|p{5.6cm}|p{8.4cm}|
 
 .. flat-table:: struct v4l2_enc_idx
     :header-rows:  0
     :stub-columns: 0
-    :widths:       1 1 2 1 1
+    :widths:       1 3 8
 
 
     -  .. row 1
@@ -90,7 +90,7 @@ video elementary streams.
 
        -  ``reserved``\ [4]
 
-       -  :cspan:`2` Reserved for future extensions. Drivers must set the
+       -  Reserved for future extensions. Drivers must set the
 	  array to zero.
 
     -  .. row 4
diff --git a/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst b/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst
index fee65debfee2..33445c6b6bc2 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst
@@ -97,7 +97,9 @@ still cause this situation.
 
 .. _v4l2-ext-control:
 
-.. tabularcolumns:: |p{3.5cm}|p{3.5cm}|p{3.5cm}|p{7.0cm}|
+.. tabularcolumns:: |p{1.2cm}|p{3.0cm}|p{1.5cm}|p{11.8cm}|
+
+.. cssclass: longtable
 
 .. flat-table:: struct v4l2_ext_control
     :header-rows:  0
@@ -230,7 +232,9 @@ still cause this situation.
 
 .. _v4l2-ext-controls:
 
-.. tabularcolumns:: |p{3.5cm}|p{3.5cm}|p{7.0cm}|p{3.5cm}|
+.. tabularcolumns:: |p{4.0cm}|p{3.0cm}|p{2.0cm}|p{8.5cm}|
+
+.. cssclass:: longtable
 
 .. flat-table:: struct v4l2_ext_controls
     :header-rows:  0
@@ -348,8 +352,9 @@ still cause this situation.
 
        -  ``reserved``\ [2]
 
-       -  Reserved for future extensions. Drivers and applications must set
-	  the array to zero.
+       -  Reserved for future extensions.
+
+	  Drivers and applications must set the array to zero.
 
     -  .. row 7
 
@@ -358,6 +363,7 @@ still cause this situation.
        -  ``controls``
 
        -  Pointer to an array of ``count`` v4l2_ext_control structures.
+
 	  Ignored if ``count`` equals zero.
 
 
diff --git a/Documentation/media/uapi/v4l/vidioc-g-fbuf.rst b/Documentation/media/uapi/v4l/vidioc-g-fbuf.rst
index dc762325be5e..a6cbc532ff05 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-fbuf.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-fbuf.rst
@@ -80,6 +80,8 @@ destructive video overlay.
 
 .. tabularcolumns:: |p{3.5cm}|p{3.5cm}|p{3.5cm}|p{7.0cm}|
 
+.. cssclass:: longtable
+
 .. flat-table:: struct v4l2_framebuffer
     :header-rows:  0
     :stub-columns: 0
@@ -377,6 +379,8 @@ destructive video overlay.
 
 .. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
 
+.. cssclass:: longtable
+
 .. flat-table:: Frame Buffer Flags
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/vidioc-g-fmt.rst b/Documentation/media/uapi/v4l/vidioc-g-fmt.rst
index ee6f11978fd6..94e42ac3d4d8 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-fmt.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-fmt.rst
@@ -84,6 +84,8 @@ The format as returned by :ref:`VIDIOC_TRY_FMT <VIDIOC_G_FMT>` must be identical
 
 .. _v4l2-format:
 
+.. tabularcolumns::  |p{1.2cm}|p{4.3cm}|p{3.0cm}|p{9.0cm}|
+
 .. flat-table:: struct v4l2_format
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/vidioc-g-jpegcomp.rst b/Documentation/media/uapi/v4l/vidioc-g-jpegcomp.rst
index 6f9ee18e005f..9b87c7f4df52 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-jpegcomp.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-jpegcomp.rst
@@ -57,7 +57,7 @@ encoding. You usually do want to add them.
 
 .. _v4l2-jpegcompression:
 
-.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
+.. tabularcolumns:: |p{1.2cm}|p{3.0cm}|p{13.3cm}|
 
 .. flat-table:: struct v4l2_jpegcompression
     :header-rows:  0
diff --git a/Documentation/media/uapi/v4l/vidioc-g-modulator.rst b/Documentation/media/uapi/v4l/vidioc-g-modulator.rst
index eaa62b6bd931..52c7b95de8e6 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-modulator.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-modulator.rst
@@ -85,8 +85,9 @@ To change the radio frequency the
 
        -  ``name``\ [32]
 
-       -  Name of the modulator, a NUL-terminated ASCII string. This
-	  information is intended for the user.
+       -  Name of the modulator, a NUL-terminated ASCII string.
+
+	  This information is intended for the user.
 
     -  .. row 3
 
@@ -155,8 +156,9 @@ To change the radio frequency the
 
        -  ``reserved``\ [3]
 
-       -  Reserved for future extensions. Drivers and applications must set
-	  the array to zero.
+       -  Reserved for future extensions.
+
+	  Drivers and applications must set the array to zero.
 
 
 
diff --git a/Documentation/media/uapi/v4l/vidioc-queryctrl.rst b/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
index b2dba5e0822b..437f0f7e3001 100644
--- a/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
+++ b/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
@@ -96,7 +96,9 @@ See also the examples in :ref:`control`.
 
 .. _v4l2-queryctrl:
 
-.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
+.. tabularcolumns:: |p{1.2cm}|p{3.6cm}|p{12.7cm}|
+
+.. cssclass:: longtable
 
 .. flat-table:: struct v4l2_queryctrl
     :header-rows:  0
@@ -218,7 +220,9 @@ See also the examples in :ref:`control`.
 
 .. _v4l2-query-ext-ctrl:
 
-.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
+.. tabularcolumns:: |p{1.2cm}|p{5.0cm}|p{11.3cm}|
+
+.. cssclass:: longtable
 
 .. flat-table:: struct v4l2_query_ext_ctrl
     :header-rows:  0
@@ -382,7 +386,7 @@ See also the examples in :ref:`control`.
 
 .. _v4l2-querymenu:
 
-.. tabularcolumns:: |p{3.5cm}|p{3.5cm}|p{7.0cm}|p{3.5cm}|
+.. tabularcolumns:: |p{1.2cm}|p{0.6cm}|p{1.6cm}|p{13.5cm}|
 
 .. flat-table:: struct v4l2_querymenu
     :header-rows:  0
@@ -452,7 +456,9 @@ See also the examples in :ref:`control`.
 
 .. _v4l2-ctrl-type:
 
-.. tabularcolumns:: |p{5.3cm}|p{0.9cm}|p{0.9cm}|p{0.9cm}|p{9.5cm}|
+.. tabularcolumns:: |p{5.8cm}|p{1.4cm}|p{1.0cm}|p{1.4cm}|p{6.9cm}|
+
+.. cssclass:: longtable
 
 .. flat-table:: enum v4l2_ctrl_type
     :header-rows:  1
@@ -653,6 +659,8 @@ See also the examples in :ref:`control`.
 
 .. tabularcolumns:: |p{6.6cm}|p{2.2cm}|p{8.7cm}|
 
+.. cssclass:: longtable
+
 .. flat-table:: Control Flags
     :header-rows:  0
     :stub-columns: 0
-- 
2.7.4


