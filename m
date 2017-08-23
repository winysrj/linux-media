Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:41853
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753684AbdHWI5G (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Aug 2017 04:57:06 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Kieran Bingham <kieran@bingham.xyz>,
        Andrea Gelmini <andrea.gelmini@gelma.net>,
        Pavel Machek <pavel@ucw.cz>,
        Evgeni Raikhel <evgeni.raikhel@intel.com>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Aviv Greenberg <aviv.d.greenberg@intel.com>,
        Jouni Ukkonen <jouni.ukkonen@intel.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Charles-Antoine Couret <charles-antoine.couret@nexvision.fr>,
        Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH v2 1/4] media: fix pdf build with Spinx 1.6
Date: Wed, 23 Aug 2017 05:56:54 -0300
Message-Id: <73b3ebb6bdce46f1e07369ac4dcee8891829a398.1503477995.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1503477995.git.mchehab@s-opensource.com>
References: <cover.1503477995.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1503477995.git.mchehab@s-opensource.com>
References: <cover.1503477995.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sphinx 1.6 generates some LaTeX code before each table,
starting its own environment before calling tabulary,
apparently to improve table layout.

The problem is that such environment is incompatible with
adjustbox. While, in thesis, it should be possible to override
it or to redefine tabulary, I was unable to produce such patch.

Also, that would likely break on some future Sphinx version.

So, instead, let's just change the font size on bigger tables,
in order for them to fit into the page size. That is not as
good as adjustbox, and require some manual work, but it should
be less sensitive to Sphinx changes.

While here, adjust a few other tables whose text is exceeding
the cell boundaries.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/v4l/dev-meta.rst          |   2 +
 Documentation/media/uapi/v4l/dev-sliced-vbi.rst    |  23 ++-
 Documentation/media/uapi/v4l/dev-subdev.rst        |   6 +-
 Documentation/media/uapi/v4l/extended-controls.rst |   6 +-
 Documentation/media/uapi/v4l/pixfmt-inzi.rst       |   7 +-
 Documentation/media/uapi/v4l/pixfmt-packed-hsv.rst |  30 ++--
 Documentation/media/uapi/v4l/pixfmt-packed-rgb.rst | 186 +++++++++++----------
 Documentation/media/uapi/v4l/pixfmt-packed-yuv.rst |  50 +++---
 Documentation/media/uapi/v4l/pixfmt-srggb10p.rst   |   7 +-
 Documentation/media/uapi/v4l/subdev-formats.rst    |  17 +-
 Documentation/media/uapi/v4l/vidioc-dqevent.rst    |   2 +-
 .../media/uapi/v4l/vidioc-dv-timings-cap.rst       |   2 +-
 .../media/uapi/v4l/vidioc-enum-frameintervals.rst  |   2 +
 Documentation/media/uapi/v4l/vidioc-enumstd.rst    |   9 +-
 .../media/uapi/v4l/vidioc-g-dv-timings.rst         |   4 +-
 .../media/uapi/v4l/vidioc-g-enc-index.rst          |   2 +-
 .../media/uapi/v4l/vidioc-g-ext-ctrls.rst          |   2 +-
 .../media/uapi/v4l/vidioc-g-sliced-vbi-cap.rst     |   6 +-
 Documentation/media/uapi/v4l/vidioc-g-tuner.rst    |   4 +-
 Documentation/media/uapi/v4l/vidioc-queryctrl.rst  |   2 +-
 20 files changed, 202 insertions(+), 167 deletions(-)

diff --git a/Documentation/media/uapi/v4l/dev-meta.rst b/Documentation/media/uapi/v4l/dev-meta.rst
index 62518adfe37b..f7ac8d0d3af1 100644
--- a/Documentation/media/uapi/v4l/dev-meta.rst
+++ b/Documentation/media/uapi/v4l/dev-meta.rst
@@ -42,6 +42,8 @@ the :c:type:`v4l2_format` structure to 0.
 
 .. _v4l2-meta-format:
 
+.. tabularcolumns:: |p{1.4cm}|p{2.2cm}|p{13.9cm}|
+
 .. flat-table:: struct v4l2_meta_format
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/dev-sliced-vbi.rst b/Documentation/media/uapi/v4l/dev-sliced-vbi.rst
index 5f6d534ea73b..23e079787270 100644
--- a/Documentation/media/uapi/v4l/dev-sliced-vbi.rst
+++ b/Documentation/media/uapi/v4l/dev-sliced-vbi.rst
@@ -105,7 +105,13 @@ which may return ``EBUSY`` can be the
 struct v4l2_sliced_vbi_format
 -----------------------------
 
-.. tabularcolumns:: |p{1.0cm}|p{4.5cm}|p{4.0cm}|p{4.0cm}|p{4.0cm}|
+.. raw:: latex
+
+    \begingroup
+    \scriptsize
+    \setlength{\tabcolsep}{2pt}
+
+.. tabularcolumns:: |p{.75cm}|p{3.3cm}|p{3.4cm}|p{3.4cm}|p{3.4cm}|
 
 .. cssclass:: longtable
 
@@ -199,6 +205,8 @@ struct v4l2_sliced_vbi_format
 
 	Applications and drivers must set it to zero.
 
+.. raw:: latex
+    \endgroup
 
 .. _vbi-services2:
 
@@ -206,10 +214,9 @@ Sliced VBI services
 -------------------
 
 .. raw:: latex
+    \footnotesize
 
-    \begin{adjustbox}{width=\columnwidth}
-
-.. tabularcolumns:: |p{5.0cm}|p{1.4cm}|p{3.0cm}|p{2.5cm}|p{9.0cm}|
+.. tabularcolumns:: |p{4.1cm}|p{1.1cm}|p{2.4cm}|p{2.0cm}|p{7.3cm}|
 
 .. flat-table::
     :header-rows:  1
@@ -263,7 +270,7 @@ Sliced VBI services
 
 .. raw:: latex
 
-    \end{adjustbox}\newline\newline
+    \normalsize
 
 
 Drivers may return an ``EINVAL`` error code when applications attempt to
@@ -457,7 +464,7 @@ number).
 struct v4l2_mpeg_vbi_fmt_ivtv
 -----------------------------
 
-.. tabularcolumns:: |p{1.0cm}|p{3.5cm}|p{1.0cm}|p{11.5cm}|
+.. tabularcolumns:: |p{1.0cm}|p{3.8cm}|p{1.0cm}|p{11.2cm}|
 
 .. flat-table::
     :header-rows:  0
@@ -525,7 +532,7 @@ Magic Constants for struct v4l2_mpeg_vbi_fmt_ivtv magic field
 structs v4l2_mpeg_vbi_itv0 and v4l2_mpeg_vbi_ITV0
 -------------------------------------------------
 
-.. tabularcolumns:: |p{4.4cm}|p{2.4cm}|p{10.7cm}|
+.. tabularcolumns:: |p{4.9cm}|p{2.4cm}|p{10.2cm}|
 
 .. flat-table::
     :header-rows:  0
@@ -574,7 +581,7 @@ structs v4l2_mpeg_vbi_itv0 and v4l2_mpeg_vbi_ITV0
 struct v4l2_mpeg_vbi_ITV0
 -------------------------
 
-.. tabularcolumns:: |p{4.4cm}|p{4.4cm}|p{8.7cm}|
+.. tabularcolumns:: |p{4.9cm}|p{4.4cm}|p{8.2cm}|
 
 .. flat-table::
     :header-rows:  0
diff --git a/Documentation/media/uapi/v4l/dev-subdev.rst b/Documentation/media/uapi/v4l/dev-subdev.rst
index 2205a3abb2a9..d20d945803a7 100644
--- a/Documentation/media/uapi/v4l/dev-subdev.rst
+++ b/Documentation/media/uapi/v4l/dev-subdev.rst
@@ -204,9 +204,9 @@ list entity names and pad numbers).
 
 .. raw:: latex
 
-    \begin{adjustbox}{width=\columnwidth}
+    \tiny
 
-.. tabularcolumns:: |p{4.5cm}|p{4.5cm}|p{4.5cm}|p{4.5cm}|p{4.5cm}|p{4.5cm}|p{4.5cm}|
+.. tabularcolumns:: |p{2.0cm}|p{2.3cm}|p{2.3cm}|p{2.3cm}|p{2.3cm}|p{2.3cm}|p{2.3cm}|
 
 .. _sample-pipeline-config:
 
@@ -253,7 +253,7 @@ list entity names and pad numbers).
 
 .. raw:: latex
 
-    \end{adjustbox}\newline\newline
+    \normalsize
 
 1. Initial state. The sensor source pad format is set to its native 3MP
    size and V4L2_MBUS_FMT_SGRBG8_1X8 media bus code. Formats on the
diff --git a/Documentation/media/uapi/v4l/extended-controls.rst b/Documentation/media/uapi/v4l/extended-controls.rst
index 667ba882c4cd..a3e81c1d276b 100644
--- a/Documentation/media/uapi/v4l/extended-controls.rst
+++ b/Documentation/media/uapi/v4l/extended-controls.rst
@@ -1922,9 +1922,9 @@ enum v4l2_vp8_golden_frame_sel -
 
 .. raw:: latex
 
-    \begin{adjustbox}{width=\columnwidth}
+    \footnotesize
 
-.. tabularcolumns:: |p{11.0cm}|p{10.0cm}|
+.. tabularcolumns:: |p{9.0cm}|p{8.0cm}|
 
 .. flat-table::
     :header-rows:  0
@@ -1940,7 +1940,7 @@ enum v4l2_vp8_golden_frame_sel -
 
 .. raw:: latex
 
-    \end{adjustbox}
+    \normalsize
 
 
 ``V4L2_CID_MPEG_VIDEO_VPX_MIN_QP (integer)``
diff --git a/Documentation/media/uapi/v4l/pixfmt-inzi.rst b/Documentation/media/uapi/v4l/pixfmt-inzi.rst
index 9849e799f205..75272f80bc8a 100644
--- a/Documentation/media/uapi/v4l/pixfmt-inzi.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-inzi.rst
@@ -34,11 +34,12 @@ The second plane provides 16-bit per-pixel Depth data arranged in
 Each cell is a 16-bit word with more significant data stored at higher
 memory address (byte order is little-endian).
 
+
 .. raw:: latex
 
-    \newline\newline\begin{adjustbox}{width=\columnwidth}
+    \small
 
-.. tabularcolumns:: |p{4.0cm}|p{4.0cm}|p{4.0cm}|p{4.0cm}|p{4.0cm}|p{4.0cm}|
+.. tabularcolumns:: |p{2.5cm}|p{2.5cm}|p{2.5cm}|p{2.5cm}|p{2.5cm}|p{2.5cm}|
 
 .. flat-table::
     :header-rows:  0
@@ -78,4 +79,4 @@ memory address (byte order is little-endian).
 
 .. raw:: latex
 
-    \end{adjustbox}\newline\newline
+    \normalsize
diff --git a/Documentation/media/uapi/v4l/pixfmt-packed-hsv.rst b/Documentation/media/uapi/v4l/pixfmt-packed-hsv.rst
index 3fdb34ce2f09..8edf65c80660 100644
--- a/Documentation/media/uapi/v4l/pixfmt-packed-hsv.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-packed-hsv.rst
@@ -17,11 +17,14 @@ cylinder: 0 being the smallest value and 255 the maximum.
 
 The values are packed in 24 or 32 bit formats.
 
+
 .. raw:: latex
 
-    \newline\begin{adjustbox}{width=\columnwidth}
+    \begingroup
+    \tiny
+    \setlength{\tabcolsep}{2pt}
 
-.. tabularcolumns:: |p{4.2cm}|p{1.0cm}|p{0.7cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.2cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.2cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.2cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{1.7cm}|
+.. tabularcolumns:: |p{2.0cm}|p{0.54cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|
 
 .. _packed-hsv-formats:
 
@@ -33,11 +36,8 @@ The values are packed in 24 or 32 bit formats.
       - Code
       -
       - :cspan:`7` Byte 0 in memory
-      -
       - :cspan:`7` Byte 1
-      -
       - :cspan:`7` Byte 2
-      -
       - :cspan:`7` Byte 3
     * -
       -
@@ -50,7 +50,7 @@ The values are packed in 24 or 32 bit formats.
       - 2
       - 1
       - 0
-      -
+
       - 7
       - 6
       - 5
@@ -59,7 +59,7 @@ The values are packed in 24 or 32 bit formats.
       - 2
       - 1
       - 0
-      -
+
       - 7
       - 6
       - 5
@@ -68,7 +68,7 @@ The values are packed in 24 or 32 bit formats.
       - 2
       - 1
       - 0
-      -
+
       - 7
       - 6
       - 5
@@ -90,7 +90,7 @@ The values are packed in 24 or 32 bit formats.
       -
       -
       -
-      -
+
       - h\ :sub:`7`
       - h\ :sub:`6`
       - h\ :sub:`5`
@@ -99,7 +99,7 @@ The values are packed in 24 or 32 bit formats.
       - h\ :sub:`2`
       - h\ :sub:`1`
       - h\ :sub:`0`
-      -
+
       - s\ :sub:`7`
       - s\ :sub:`6`
       - s\ :sub:`5`
@@ -108,7 +108,7 @@ The values are packed in 24 or 32 bit formats.
       - s\ :sub:`2`
       - s\ :sub:`1`
       - s\ :sub:`0`
-      -
+
       - v\ :sub:`7`
       - v\ :sub:`6`
       - v\ :sub:`5`
@@ -130,7 +130,7 @@ The values are packed in 24 or 32 bit formats.
       - h\ :sub:`2`
       - h\ :sub:`1`
       - h\ :sub:`0`
-      -
+
       - s\ :sub:`7`
       - s\ :sub:`6`
       - s\ :sub:`5`
@@ -139,7 +139,7 @@ The values are packed in 24 or 32 bit formats.
       - s\ :sub:`2`
       - s\ :sub:`1`
       - s\ :sub:`0`
-      -
+
       - v\ :sub:`7`
       - v\ :sub:`6`
       - v\ :sub:`5`
@@ -149,9 +149,9 @@ The values are packed in 24 or 32 bit formats.
       - v\ :sub:`1`
       - v\ :sub:`0`
       -
-      -
+
 .. raw:: latex
 
-    \end{adjustbox}\newline\newline
+    \endgroup
 
 Bit 7 is the most significant bit.
diff --git a/Documentation/media/uapi/v4l/pixfmt-packed-rgb.rst b/Documentation/media/uapi/v4l/pixfmt-packed-rgb.rst
index 84fcbcb74171..d4b9b525e44f 100644
--- a/Documentation/media/uapi/v4l/pixfmt-packed-rgb.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-packed-rgb.rst
@@ -16,9 +16,12 @@ next to each other in memory.
 
 .. raw:: latex
 
-    \begin{adjustbox}{width=\columnwidth}
+    \begingroup
+    \tiny
+    \setlength{\tabcolsep}{2pt}
+
+.. tabularcolumns:: |p{2.3cm}|p{1.6cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|
 
-.. tabularcolumns:: |p{4.5cm}|p{3.3cm}|p{0.7cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.2cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.2cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.2cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{1.7cm}|
 
 .. _rgb-formats:
 
@@ -28,17 +31,11 @@ next to each other in memory.
 
     * - Identifier
       - Code
-      -
       - :cspan:`7` Byte 0 in memory
-      -
       - :cspan:`7` Byte 1
-      -
       - :cspan:`7` Byte 2
-      -
       - :cspan:`7` Byte 3
-    * -
-      -
-      - Bit
+    * - :cspan:`1`
       - 7
       - 6
       - 5
@@ -47,7 +44,7 @@ next to each other in memory.
       - 2
       - 1
       - 0
-      -
+
       - 7
       - 6
       - 5
@@ -56,7 +53,7 @@ next to each other in memory.
       - 2
       - 1
       - 0
-      -
+
       - 7
       - 6
       - 5
@@ -65,7 +62,7 @@ next to each other in memory.
       - 2
       - 1
       - 0
-      -
+
       - 7
       - 6
       - 5
@@ -78,7 +75,7 @@ next to each other in memory.
 
       - ``V4L2_PIX_FMT_RGB332``
       - 'RGB1'
-      -
+
       - r\ :sub:`2`
       - r\ :sub:`1`
       - r\ :sub:`0`
@@ -87,11 +84,12 @@ next to each other in memory.
       - g\ :sub:`0`
       - b\ :sub:`1`
       - b\ :sub:`0`
+      -
     * .. _V4L2-PIX-FMT-ARGB444:
 
       - ``V4L2_PIX_FMT_ARGB444``
       - 'AR12'
-      -
+
       - g\ :sub:`3`
       - g\ :sub:`2`
       - g\ :sub:`1`
@@ -100,7 +98,7 @@ next to each other in memory.
       - b\ :sub:`2`
       - b\ :sub:`1`
       - b\ :sub:`0`
-      -
+
       - a\ :sub:`3`
       - a\ :sub:`2`
       - a\ :sub:`1`
@@ -109,11 +107,12 @@ next to each other in memory.
       - r\ :sub:`2`
       - r\ :sub:`1`
       - r\ :sub:`0`
+      -
     * .. _V4L2-PIX-FMT-XRGB444:
 
       - ``V4L2_PIX_FMT_XRGB444``
       - 'XR12'
-      -
+
       - g\ :sub:`3`
       - g\ :sub:`2`
       - g\ :sub:`1`
@@ -122,7 +121,7 @@ next to each other in memory.
       - b\ :sub:`2`
       - b\ :sub:`1`
       - b\ :sub:`0`
-      -
+
       -
       -
       -
@@ -131,11 +130,12 @@ next to each other in memory.
       - r\ :sub:`2`
       - r\ :sub:`1`
       - r\ :sub:`0`
+      -
     * .. _V4L2-PIX-FMT-ARGB555:
 
       - ``V4L2_PIX_FMT_ARGB555``
       - 'AR15'
-      -
+
       - g\ :sub:`2`
       - g\ :sub:`1`
       - g\ :sub:`0`
@@ -144,7 +144,7 @@ next to each other in memory.
       - b\ :sub:`2`
       - b\ :sub:`1`
       - b\ :sub:`0`
-      -
+
       - a
       - r\ :sub:`4`
       - r\ :sub:`3`
@@ -153,11 +153,12 @@ next to each other in memory.
       - r\ :sub:`0`
       - g\ :sub:`4`
       - g\ :sub:`3`
+      -
     * .. _V4L2-PIX-FMT-XRGB555:
 
       - ``V4L2_PIX_FMT_XRGB555``
       - 'XR15'
-      -
+
       - g\ :sub:`2`
       - g\ :sub:`1`
       - g\ :sub:`0`
@@ -166,7 +167,7 @@ next to each other in memory.
       - b\ :sub:`2`
       - b\ :sub:`1`
       - b\ :sub:`0`
-      -
+
       -
       - r\ :sub:`4`
       - r\ :sub:`3`
@@ -175,11 +176,12 @@ next to each other in memory.
       - r\ :sub:`0`
       - g\ :sub:`4`
       - g\ :sub:`3`
+      -
     * .. _V4L2-PIX-FMT-RGB565:
 
       - ``V4L2_PIX_FMT_RGB565``
       - 'RGBP'
-      -
+
       - g\ :sub:`2`
       - g\ :sub:`1`
       - g\ :sub:`0`
@@ -188,7 +190,7 @@ next to each other in memory.
       - b\ :sub:`2`
       - b\ :sub:`1`
       - b\ :sub:`0`
-      -
+
       - r\ :sub:`4`
       - r\ :sub:`3`
       - r\ :sub:`2`
@@ -197,11 +199,12 @@ next to each other in memory.
       - g\ :sub:`5`
       - g\ :sub:`4`
       - g\ :sub:`3`
+      -
     * .. _V4L2-PIX-FMT-ARGB555X:
 
       - ``V4L2_PIX_FMT_ARGB555X``
       - 'AR15' | (1 << 31)
-      -
+
       - a
       - r\ :sub:`4`
       - r\ :sub:`3`
@@ -210,7 +213,7 @@ next to each other in memory.
       - r\ :sub:`0`
       - g\ :sub:`4`
       - g\ :sub:`3`
-      -
+
       - g\ :sub:`2`
       - g\ :sub:`1`
       - g\ :sub:`0`
@@ -219,11 +222,12 @@ next to each other in memory.
       - b\ :sub:`2`
       - b\ :sub:`1`
       - b\ :sub:`0`
+      -
     * .. _V4L2-PIX-FMT-XRGB555X:
 
       - ``V4L2_PIX_FMT_XRGB555X``
       - 'XR15' | (1 << 31)
-      -
+
       -
       - r\ :sub:`4`
       - r\ :sub:`3`
@@ -232,7 +236,7 @@ next to each other in memory.
       - r\ :sub:`0`
       - g\ :sub:`4`
       - g\ :sub:`3`
-      -
+
       - g\ :sub:`2`
       - g\ :sub:`1`
       - g\ :sub:`0`
@@ -241,11 +245,12 @@ next to each other in memory.
       - b\ :sub:`2`
       - b\ :sub:`1`
       - b\ :sub:`0`
+      -
     * .. _V4L2-PIX-FMT-RGB565X:
 
       - ``V4L2_PIX_FMT_RGB565X``
       - 'RGBR'
-      -
+
       - r\ :sub:`4`
       - r\ :sub:`3`
       - r\ :sub:`2`
@@ -254,7 +259,7 @@ next to each other in memory.
       - g\ :sub:`5`
       - g\ :sub:`4`
       - g\ :sub:`3`
-      -
+
       - g\ :sub:`2`
       - g\ :sub:`1`
       - g\ :sub:`0`
@@ -263,11 +268,12 @@ next to each other in memory.
       - b\ :sub:`2`
       - b\ :sub:`1`
       - b\ :sub:`0`
+      -
     * .. _V4L2-PIX-FMT-BGR24:
 
       - ``V4L2_PIX_FMT_BGR24``
       - 'BGR3'
-      -
+
       - b\ :sub:`7`
       - b\ :sub:`6`
       - b\ :sub:`5`
@@ -276,7 +282,7 @@ next to each other in memory.
       - b\ :sub:`2`
       - b\ :sub:`1`
       - b\ :sub:`0`
-      -
+
       - g\ :sub:`7`
       - g\ :sub:`6`
       - g\ :sub:`5`
@@ -285,7 +291,7 @@ next to each other in memory.
       - g\ :sub:`2`
       - g\ :sub:`1`
       - g\ :sub:`0`
-      -
+
       - r\ :sub:`7`
       - r\ :sub:`6`
       - r\ :sub:`5`
@@ -294,11 +300,12 @@ next to each other in memory.
       - r\ :sub:`2`
       - r\ :sub:`1`
       - r\ :sub:`0`
+      -
     * .. _V4L2-PIX-FMT-RGB24:
 
       - ``V4L2_PIX_FMT_RGB24``
       - 'RGB3'
-      -
+
       - r\ :sub:`7`
       - r\ :sub:`6`
       - r\ :sub:`5`
@@ -307,7 +314,7 @@ next to each other in memory.
       - r\ :sub:`2`
       - r\ :sub:`1`
       - r\ :sub:`0`
-      -
+
       - g\ :sub:`7`
       - g\ :sub:`6`
       - g\ :sub:`5`
@@ -316,7 +323,7 @@ next to each other in memory.
       - g\ :sub:`2`
       - g\ :sub:`1`
       - g\ :sub:`0`
-      -
+
       - b\ :sub:`7`
       - b\ :sub:`6`
       - b\ :sub:`5`
@@ -325,11 +332,12 @@ next to each other in memory.
       - b\ :sub:`2`
       - b\ :sub:`1`
       - b\ :sub:`0`
+      -
     * .. _V4L2-PIX-FMT-BGR666:
 
       - ``V4L2_PIX_FMT_BGR666``
       - 'BGRH'
-      -
+
       - b\ :sub:`5`
       - b\ :sub:`4`
       - b\ :sub:`3`
@@ -338,7 +346,7 @@ next to each other in memory.
       - b\ :sub:`0`
       - g\ :sub:`5`
       - g\ :sub:`4`
-      -
+
       - g\ :sub:`3`
       - g\ :sub:`2`
       - g\ :sub:`1`
@@ -347,7 +355,7 @@ next to each other in memory.
       - r\ :sub:`4`
       - r\ :sub:`3`
       - r\ :sub:`2`
-      -
+
       - r\ :sub:`1`
       - r\ :sub:`0`
       -
@@ -356,7 +364,7 @@ next to each other in memory.
       -
       -
       -
-      -
+
       -
       -
       -
@@ -369,7 +377,7 @@ next to each other in memory.
 
       - ``V4L2_PIX_FMT_ABGR32``
       - 'AR24'
-      -
+
       - b\ :sub:`7`
       - b\ :sub:`6`
       - b\ :sub:`5`
@@ -378,7 +386,7 @@ next to each other in memory.
       - b\ :sub:`2`
       - b\ :sub:`1`
       - b\ :sub:`0`
-      -
+
       - g\ :sub:`7`
       - g\ :sub:`6`
       - g\ :sub:`5`
@@ -387,7 +395,7 @@ next to each other in memory.
       - g\ :sub:`2`
       - g\ :sub:`1`
       - g\ :sub:`0`
-      -
+
       - r\ :sub:`7`
       - r\ :sub:`6`
       - r\ :sub:`5`
@@ -396,7 +404,7 @@ next to each other in memory.
       - r\ :sub:`2`
       - r\ :sub:`1`
       - r\ :sub:`0`
-      -
+
       - a\ :sub:`7`
       - a\ :sub:`6`
       - a\ :sub:`5`
@@ -409,7 +417,7 @@ next to each other in memory.
 
       - ``V4L2_PIX_FMT_XBGR32``
       - 'XR24'
-      -
+
       - b\ :sub:`7`
       - b\ :sub:`6`
       - b\ :sub:`5`
@@ -418,7 +426,7 @@ next to each other in memory.
       - b\ :sub:`2`
       - b\ :sub:`1`
       - b\ :sub:`0`
-      -
+
       - g\ :sub:`7`
       - g\ :sub:`6`
       - g\ :sub:`5`
@@ -427,7 +435,7 @@ next to each other in memory.
       - g\ :sub:`2`
       - g\ :sub:`1`
       - g\ :sub:`0`
-      -
+
       - r\ :sub:`7`
       - r\ :sub:`6`
       - r\ :sub:`5`
@@ -436,7 +444,7 @@ next to each other in memory.
       - r\ :sub:`2`
       - r\ :sub:`1`
       - r\ :sub:`0`
-      -
+
       -
       -
       -
@@ -449,7 +457,7 @@ next to each other in memory.
 
       - ``V4L2_PIX_FMT_ARGB32``
       - 'BA24'
-      -
+
       - a\ :sub:`7`
       - a\ :sub:`6`
       - a\ :sub:`5`
@@ -458,7 +466,7 @@ next to each other in memory.
       - a\ :sub:`2`
       - a\ :sub:`1`
       - a\ :sub:`0`
-      -
+
       - r\ :sub:`7`
       - r\ :sub:`6`
       - r\ :sub:`5`
@@ -467,7 +475,7 @@ next to each other in memory.
       - r\ :sub:`2`
       - r\ :sub:`1`
       - r\ :sub:`0`
-      -
+
       - g\ :sub:`7`
       - g\ :sub:`6`
       - g\ :sub:`5`
@@ -476,7 +484,7 @@ next to each other in memory.
       - g\ :sub:`2`
       - g\ :sub:`1`
       - g\ :sub:`0`
-      -
+
       - b\ :sub:`7`
       - b\ :sub:`6`
       - b\ :sub:`5`
@@ -489,6 +497,7 @@ next to each other in memory.
 
       - ``V4L2_PIX_FMT_XRGB32``
       - 'BX24'
+
       -
       -
       -
@@ -497,8 +506,7 @@ next to each other in memory.
       -
       -
       -
-      -
-      -
+
       - r\ :sub:`7`
       - r\ :sub:`6`
       - r\ :sub:`5`
@@ -507,7 +515,7 @@ next to each other in memory.
       - r\ :sub:`2`
       - r\ :sub:`1`
       - r\ :sub:`0`
-      -
+
       - g\ :sub:`7`
       - g\ :sub:`6`
       - g\ :sub:`5`
@@ -516,7 +524,7 @@ next to each other in memory.
       - g\ :sub:`2`
       - g\ :sub:`1`
       - g\ :sub:`0`
-      -
+
       - b\ :sub:`7`
       - b\ :sub:`6`
       - b\ :sub:`5`
@@ -528,7 +536,7 @@ next to each other in memory.
 
 .. raw:: latex
 
-    \end{adjustbox}\newline\newline
+    \endgroup
 
 .. note:: Bit 7 is the most significant bit.
 
@@ -562,9 +570,9 @@ Each cell is one byte.
 
 .. raw:: latex
 
-    \newline\newline\begin{adjustbox}{width=\columnwidth}
+    \small
 
-.. tabularcolumns:: |p{4.1cm}|p{1.1cm}|p{1.1cm}|p{1.1cm}|p{1.1cm}|p{1.1cm}|p{1.1cm}|p{1.1cm}|p{1.1cm}|p{1.1cm}|p{1.1cm}|p{1.1cm}|p{1.3cm}|
+.. tabularcolumns:: |p{3.1cm}|p{0.8cm}|p{0.8cm}|p{0.8cm}|p{0.8cm}|p{0.8cm}|p{0.8cm}|p{0.8cm}|p{0.8cm}|p{0.8cm}|p{0.8cm}|p{0.8cm}|p{0.8cm}|
 
 .. flat-table:: RGB byte order
     :header-rows:  0
@@ -626,19 +634,23 @@ Each cell is one byte.
 
 .. raw:: latex
 
-    \end{adjustbox}\newline\newline
+    \normalsize
 
 Formats defined in :ref:`rgb-formats-deprecated` are deprecated and
 must not be used by new drivers. They are documented here for reference.
-The meaning of their alpha bits (a) is ill-defined and interpreted as in
+The meaning of their alpha bits ``(a)`` are ill-defined and interpreted as in
 either the corresponding ARGB or XRGB format, depending on the driver.
 
 
 .. raw:: latex
 
-    \begin{adjustbox}{width=\columnwidth}
+.. raw:: latex
 
-.. tabularcolumns:: |p{4.2cm}|p{1.0cm}|p{0.7cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.2cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.2cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.2cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{1.7cm}|
+    \begingroup
+    \tiny
+    \setlength{\tabcolsep}{2pt}
+
+.. tabularcolumns:: |p{2.2cm}|p{0.60cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|
 
 .. _rgb-formats-deprecated:
 
@@ -648,17 +660,14 @@ either the corresponding ARGB or XRGB format, depending on the driver.
 
     * - Identifier
       - Code
-      -
       - :cspan:`7` Byte 0 in memory
-      -
+
       - :cspan:`7` Byte 1
-      -
+
       - :cspan:`7` Byte 2
-      -
+
       - :cspan:`7` Byte 3
-    * -
-      -
-      - Bit
+    * - :cspan:`1`
       - 7
       - 6
       - 5
@@ -667,7 +676,7 @@ either the corresponding ARGB or XRGB format, depending on the driver.
       - 2
       - 1
       - 0
-      -
+
       - 7
       - 6
       - 5
@@ -676,7 +685,7 @@ either the corresponding ARGB or XRGB format, depending on the driver.
       - 2
       - 1
       - 0
-      -
+
       - 7
       - 6
       - 5
@@ -685,7 +694,7 @@ either the corresponding ARGB or XRGB format, depending on the driver.
       - 2
       - 1
       - 0
-      -
+
       - 7
       - 6
       - 5
@@ -698,7 +707,7 @@ either the corresponding ARGB or XRGB format, depending on the driver.
 
       - ``V4L2_PIX_FMT_RGB444``
       - 'R444'
-      -
+
       - g\ :sub:`3`
       - g\ :sub:`2`
       - g\ :sub:`1`
@@ -707,7 +716,7 @@ either the corresponding ARGB or XRGB format, depending on the driver.
       - b\ :sub:`2`
       - b\ :sub:`1`
       - b\ :sub:`0`
-      -
+
       - a\ :sub:`3`
       - a\ :sub:`2`
       - a\ :sub:`1`
@@ -716,11 +725,12 @@ either the corresponding ARGB or XRGB format, depending on the driver.
       - r\ :sub:`2`
       - r\ :sub:`1`
       - r\ :sub:`0`
+      -
     * .. _V4L2-PIX-FMT-RGB555:
 
       - ``V4L2_PIX_FMT_RGB555``
       - 'RGBO'
-      -
+
       - g\ :sub:`2`
       - g\ :sub:`1`
       - g\ :sub:`0`
@@ -729,7 +739,7 @@ either the corresponding ARGB or XRGB format, depending on the driver.
       - b\ :sub:`2`
       - b\ :sub:`1`
       - b\ :sub:`0`
-      -
+
       - a
       - r\ :sub:`4`
       - r\ :sub:`3`
@@ -738,11 +748,12 @@ either the corresponding ARGB or XRGB format, depending on the driver.
       - r\ :sub:`0`
       - g\ :sub:`4`
       - g\ :sub:`3`
+      -
     * .. _V4L2-PIX-FMT-RGB555X:
 
       - ``V4L2_PIX_FMT_RGB555X``
       - 'RGBQ'
-      -
+
       - a
       - r\ :sub:`4`
       - r\ :sub:`3`
@@ -751,7 +762,7 @@ either the corresponding ARGB or XRGB format, depending on the driver.
       - r\ :sub:`0`
       - g\ :sub:`4`
       - g\ :sub:`3`
-      -
+
       - g\ :sub:`2`
       - g\ :sub:`1`
       - g\ :sub:`0`
@@ -760,11 +771,12 @@ either the corresponding ARGB or XRGB format, depending on the driver.
       - b\ :sub:`2`
       - b\ :sub:`1`
       - b\ :sub:`0`
+      -
     * .. _V4L2-PIX-FMT-BGR32:
 
       - ``V4L2_PIX_FMT_BGR32``
       - 'BGR4'
-      -
+
       - b\ :sub:`7`
       - b\ :sub:`6`
       - b\ :sub:`5`
@@ -773,7 +785,7 @@ either the corresponding ARGB or XRGB format, depending on the driver.
       - b\ :sub:`2`
       - b\ :sub:`1`
       - b\ :sub:`0`
-      -
+
       - g\ :sub:`7`
       - g\ :sub:`6`
       - g\ :sub:`5`
@@ -782,7 +794,7 @@ either the corresponding ARGB or XRGB format, depending on the driver.
       - g\ :sub:`2`
       - g\ :sub:`1`
       - g\ :sub:`0`
-      -
+
       - r\ :sub:`7`
       - r\ :sub:`6`
       - r\ :sub:`5`
@@ -791,7 +803,7 @@ either the corresponding ARGB or XRGB format, depending on the driver.
       - r\ :sub:`2`
       - r\ :sub:`1`
       - r\ :sub:`0`
-      -
+
       - a\ :sub:`7`
       - a\ :sub:`6`
       - a\ :sub:`5`
@@ -804,7 +816,7 @@ either the corresponding ARGB or XRGB format, depending on the driver.
 
       - ``V4L2_PIX_FMT_RGB32``
       - 'RGB4'
-      -
+
       - a\ :sub:`7`
       - a\ :sub:`6`
       - a\ :sub:`5`
@@ -813,7 +825,7 @@ either the corresponding ARGB or XRGB format, depending on the driver.
       - a\ :sub:`2`
       - a\ :sub:`1`
       - a\ :sub:`0`
-      -
+
       - r\ :sub:`7`
       - r\ :sub:`6`
       - r\ :sub:`5`
@@ -822,7 +834,7 @@ either the corresponding ARGB or XRGB format, depending on the driver.
       - r\ :sub:`2`
       - r\ :sub:`1`
       - r\ :sub:`0`
-      -
+
       - g\ :sub:`7`
       - g\ :sub:`6`
       - g\ :sub:`5`
@@ -831,7 +843,7 @@ either the corresponding ARGB or XRGB format, depending on the driver.
       - g\ :sub:`2`
       - g\ :sub:`1`
       - g\ :sub:`0`
-      -
+
       - b\ :sub:`7`
       - b\ :sub:`6`
       - b\ :sub:`5`
@@ -843,7 +855,7 @@ either the corresponding ARGB or XRGB format, depending on the driver.
 
 .. raw:: latex
 
-    \end{adjustbox}\newline\newline
+    \endgroup
 
 A test utility to determine which RGB formats a driver actually supports
 is available from the LinuxTV v4l-dvb repository. See
diff --git a/Documentation/media/uapi/v4l/pixfmt-packed-yuv.rst b/Documentation/media/uapi/v4l/pixfmt-packed-yuv.rst
index ebc8fcc937ad..d6a6e890f5a9 100644
--- a/Documentation/media/uapi/v4l/pixfmt-packed-yuv.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-packed-yuv.rst
@@ -12,13 +12,16 @@ Description
 Similar to the packed RGB formats these formats store the Y, Cb and Cr
 component of each pixel in one 16 or 32 bit word.
 
+
 .. raw:: latex
 
-    \newline\newline\begin{adjustbox}{width=\columnwidth}
+    \begingroup
+    \tiny
+    \setlength{\tabcolsep}{2pt}
 
 .. _packed-yuv-formats:
 
-.. tabularcolumns:: |p{4.5cm}|p{3.3cm}|p{0.7cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.2cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.2cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.2cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{1.7cm}|
+.. tabularcolumns:: |p{2.0cm}|p{0.67cm}|p{0.29cm}|p{0.29cm}|p{0.29cm}|p{0.29cm}|p{0.29cm}|p{0.29cm}|p{0.29cm}|p{0.29cm}|p{0.29cm}|p{0.29cm}|p{0.29cm}|p{0.29cm}|p{0.29cm}|p{0.29cm}|p{0.29cm}|p{0.29cm}|p{0.29cm}|p{0.29cm}|p{0.29cm}|p{0.29cm}|p{0.29cm}|p{0.29cm}|p{0.29cm}|p{0.29cm}|p{0.29cm}|p{0.29cm}|p{0.29cm}|p{0.29cm}|p{0.29cm}|p{0.29cm}|p{0.29cm}|p{0.29cm}|
 
 .. flat-table:: Packed YUV Image Formats
     :header-rows:  2
@@ -26,17 +29,15 @@ component of each pixel in one 16 or 32 bit word.
 
     * - Identifier
       - Code
-      -
+
       - :cspan:`7` Byte 0 in memory
-      -
+
       - :cspan:`7` Byte 1
-      -
+
       - :cspan:`7` Byte 2
-      -
+
       - :cspan:`7` Byte 3
-    * -
-      -
-      - Bit
+    * - :cspan:`1`
       - 7
       - 6
       - 5
@@ -45,7 +46,7 @@ component of each pixel in one 16 or 32 bit word.
       - 2
       - 1
       - 0
-      -
+
       - 7
       - 6
       - 5
@@ -54,7 +55,7 @@ component of each pixel in one 16 or 32 bit word.
       - 2
       - 1
       - 0
-      -
+
       - 7
       - 6
       - 5
@@ -63,7 +64,7 @@ component of each pixel in one 16 or 32 bit word.
       - 2
       - 1
       - 0
-      -
+
       - 7
       - 6
       - 5
@@ -76,7 +77,7 @@ component of each pixel in one 16 or 32 bit word.
 
       - ``V4L2_PIX_FMT_YUV444``
       - 'Y444'
-      -
+
       - Cb\ :sub:`3`
       - Cb\ :sub:`2`
       - Cb\ :sub:`1`
@@ -85,7 +86,7 @@ component of each pixel in one 16 or 32 bit word.
       - Cr\ :sub:`2`
       - Cr\ :sub:`1`
       - Cr\ :sub:`0`
-      -
+
       - a\ :sub:`3`
       - a\ :sub:`2`
       - a\ :sub:`1`
@@ -94,11 +95,12 @@ component of each pixel in one 16 or 32 bit word.
       - Y'\ :sub:`2`
       - Y'\ :sub:`1`
       - Y'\ :sub:`0`
+      -
     * .. _V4L2-PIX-FMT-YUV555:
 
       - ``V4L2_PIX_FMT_YUV555``
       - 'YUVO'
-      -
+
       - Cb\ :sub:`2`
       - Cb\ :sub:`1`
       - Cb\ :sub:`0`
@@ -107,7 +109,7 @@ component of each pixel in one 16 or 32 bit word.
       - Cr\ :sub:`2`
       - Cr\ :sub:`1`
       - Cr\ :sub:`0`
-      -
+
       - a
       - Y'\ :sub:`4`
       - Y'\ :sub:`3`
@@ -116,11 +118,12 @@ component of each pixel in one 16 or 32 bit word.
       - Y'\ :sub:`0`
       - Cb\ :sub:`4`
       - Cb\ :sub:`3`
+      -
     * .. _V4L2-PIX-FMT-YUV565:
 
       - ``V4L2_PIX_FMT_YUV565``
       - 'YUVP'
-      -
+
       - Cb\ :sub:`2`
       - Cb\ :sub:`1`
       - Cb\ :sub:`0`
@@ -129,7 +132,7 @@ component of each pixel in one 16 or 32 bit word.
       - Cr\ :sub:`2`
       - Cr\ :sub:`1`
       - Cr\ :sub:`0`
-      -
+
       - Y'\ :sub:`4`
       - Y'\ :sub:`3`
       - Y'\ :sub:`2`
@@ -138,11 +141,12 @@ component of each pixel in one 16 or 32 bit word.
       - Cb\ :sub:`5`
       - Cb\ :sub:`4`
       - Cb\ :sub:`3`
+      -
     * .. _V4L2-PIX-FMT-YUV32:
 
       - ``V4L2_PIX_FMT_YUV32``
       - 'YUV4'
-      -
+
       - a\ :sub:`7`
       - a\ :sub:`6`
       - a\ :sub:`5`
@@ -151,7 +155,7 @@ component of each pixel in one 16 or 32 bit word.
       - a\ :sub:`2`
       - a\ :sub:`1`
       - a\ :sub:`0`
-      -
+
       - Y'\ :sub:`7`
       - Y'\ :sub:`6`
       - Y'\ :sub:`5`
@@ -160,7 +164,7 @@ component of each pixel in one 16 or 32 bit word.
       - Y'\ :sub:`2`
       - Y'\ :sub:`1`
       - Y'\ :sub:`0`
-      -
+
       - Cb\ :sub:`7`
       - Cb\ :sub:`6`
       - Cb\ :sub:`5`
@@ -169,7 +173,7 @@ component of each pixel in one 16 or 32 bit word.
       - Cb\ :sub:`2`
       - Cb\ :sub:`1`
       - Cb\ :sub:`0`
-      -
+
       - Cr\ :sub:`7`
       - Cr\ :sub:`6`
       - Cr\ :sub:`5`
@@ -181,7 +185,7 @@ component of each pixel in one 16 or 32 bit word.
 
 .. raw:: latex
 
-    \end{adjustbox}\newline\newline
+    \endgroup
 
 .. note::
 
diff --git a/Documentation/media/uapi/v4l/pixfmt-srggb10p.rst b/Documentation/media/uapi/v4l/pixfmt-srggb10p.rst
index b6d426c70ccd..86cd07e5bfa3 100644
--- a/Documentation/media/uapi/v4l/pixfmt-srggb10p.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-srggb10p.rst
@@ -33,11 +33,12 @@ of a small V4L2_PIX_FMT_SBGGR10P image:
 **Byte Order.**
 Each cell is one byte.
 
+
 .. raw:: latex
 
-    \newline\newline\begin{adjustbox}{width=\columnwidth}
+    \small
 
-.. tabularcolumns:: |p{2.0cm}|p{1.3cm}|p{1.3cm}|p{1.3cm}|p{1.3cm}|p{10.9cm}|
+.. tabularcolumns:: |p{2.0cm}|p{1.0cm}|p{1.0cm}|p{1.0cm}|p{1.0cm}|p{10.0cm}|
 
 .. flat-table::
     :header-rows:  0
@@ -75,4 +76,4 @@ Each cell is one byte.
 
 .. raw:: latex
 
-    \end{adjustbox}\newline\newline
+    \normalsize
diff --git a/Documentation/media/uapi/v4l/subdev-formats.rst b/Documentation/media/uapi/v4l/subdev-formats.rst
index 8e73bb00c0d5..b1eea44550e1 100644
--- a/Documentation/media/uapi/v4l/subdev-formats.rst
+++ b/Documentation/media/uapi/v4l/subdev-formats.rst
@@ -1586,7 +1586,7 @@ JEIDA defined bit mapping will be named
 
 .. raw:: latex
 
-    \begin{adjustbox}{width=\columnwidth}
+    \tiny
 
 .. _v4l2-mbus-pixelcode-rgb-lvds:
 
@@ -1784,7 +1784,7 @@ JEIDA defined bit mapping will be named
 
 .. raw:: latex
 
-    \end{adjustbox}\newline\newline
+    \normalsize
 
 
 Bayer Formats
@@ -7321,11 +7321,14 @@ following information.
 
 The following table lists existing HSV/HSL formats.
 
+
 .. raw:: latex
 
-    \newline\newline\begin{adjustbox}{width=\columnwidth}
+    \begingroup
+    \tiny
+    \setlength{\tabcolsep}{2pt}
 
-.. tabularcolumns:: |p{6.2cm}|p{1.6cm}|p{0.7cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|p{0.5cm}|
+.. tabularcolumns:: |p{3.0cm}|p{0.60cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|
 
 .. _v4l2-mbus-pixelcode-hsv:
 
@@ -7413,7 +7416,7 @@ The following table lists existing HSV/HSL formats.
 
 .. raw:: latex
 
-    \end{adjustbox}\newline\newline
+    \normalsize
 
 
 JPEG Compressed Formats
@@ -7435,7 +7438,7 @@ The following table lists existing JPEG compressed formats.
 
 .. _v4l2-mbus-pixelcode-jpeg:
 
-.. tabularcolumns:: |p{5.6cm}|p{1.2cm}|p{10.7cm}|
+.. tabularcolumns:: |p{5.4cm}|p{1.4cm}|p{10.7cm}|
 
 .. flat-table:: JPEG Formats
     :header-rows:  1
@@ -7468,7 +7471,7 @@ formats.
 
 .. _v4l2-mbus-pixelcode-vendor-specific:
 
-.. tabularcolumns:: |p{6.6cm}|p{1.2cm}|p{9.7cm}|
+.. tabularcolumns:: |p{6.8cm}|p{1.4cm}|p{9.3cm}|
 
 .. flat-table:: Vendor and device specific formats
     :header-rows:  1
diff --git a/Documentation/media/uapi/v4l/vidioc-dqevent.rst b/Documentation/media/uapi/v4l/vidioc-dqevent.rst
index 8d663a73818e..fcd9c933870d 100644
--- a/Documentation/media/uapi/v4l/vidioc-dqevent.rst
+++ b/Documentation/media/uapi/v4l/vidioc-dqevent.rst
@@ -38,7 +38,7 @@ exceptions which the application may get by e.g. using the select system
 call.
 
 
-.. tabularcolumns:: |p{3.0cm}|p{4.3cm}|p{2.5cm}|p{7.7cm}|
+.. tabularcolumns:: |p{3.0cm}|p{4.4cm}|p{2.4cm}|p{7.7cm}|
 
 .. c:type:: v4l2_event
 
diff --git a/Documentation/media/uapi/v4l/vidioc-dv-timings-cap.rst b/Documentation/media/uapi/v4l/vidioc-dv-timings-cap.rst
index 424f3a1c7f56..5156b6ce4ce1 100644
--- a/Documentation/media/uapi/v4l/vidioc-dv-timings-cap.rst
+++ b/Documentation/media/uapi/v4l/vidioc-dv-timings-cap.rst
@@ -97,7 +97,7 @@ that doesn't support them will return an ``EINVAL`` error code.
 
 
 
-.. tabularcolumns:: |p{1.0cm}|p{3.5cm}|p{3.5cm}|p{9.5cm}|
+.. tabularcolumns:: |p{1.0cm}|p{4.0cm}|p{3.5cm}|p{9.2cm}|
 
 .. c:type:: v4l2_dv_timings_cap
 
diff --git a/Documentation/media/uapi/v4l/vidioc-enum-frameintervals.rst b/Documentation/media/uapi/v4l/vidioc-enum-frameintervals.rst
index 39492453f02d..146b75d63736 100644
--- a/Documentation/media/uapi/v4l/vidioc-enum-frameintervals.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enum-frameintervals.rst
@@ -124,6 +124,8 @@ application should zero out all members except for the *IN* fields.
 
 .. c:type:: v4l2_frmivalenum
 
+.. tabularcolumns:: |p{1.8cm}|p{4.4cm}|p{2.4cm}|p{8.9cm}|
+
 .. flat-table:: struct v4l2_frmivalenum
     :header-rows:  0
     :stub-columns: 0
diff --git a/Documentation/media/uapi/v4l/vidioc-enumstd.rst b/Documentation/media/uapi/v4l/vidioc-enumstd.rst
index f2bdd45cfa0d..19ada126b651 100644
--- a/Documentation/media/uapi/v4l/vidioc-enumstd.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enumstd.rst
@@ -224,12 +224,15 @@ support digital TV. See also the Linux DVB API at
     #define V4L2_STD_ALL            (V4L2_STD_525_60        |
 		     V4L2_STD_625_50)
 
+
 .. raw:: latex
 
-    \begin{adjustbox}{width=\columnwidth}
+    \begingroup
+    \tiny
+    \setlength{\tabcolsep}{2pt}
 
 ..                            NTSC/M   PAL/M    /N       /B       /D       /H       /I        SECAM/B    /D       /K1     /L
-.. tabularcolumns:: |p{2.7cm}|p{2.6cm}|p{3.0cm}|p{3.2cm}|p{3.2cm}|p{2.2cm}|p{1.2cm}|p{3.2cm}|p{3.0cm}|p{2.0cm}|p{2.0cm}|p{2.0cm}|
+.. tabularcolumns:: |p{1.43cm}|p{1.38cm}|p{1.59cm}|p{1.7cm}|p{1.7cm}|p{1.17cm}|p{0.64cm}|p{1.71cm}|p{1.6cm}|p{1.07cm}|p{1.07cm}|p{1.07cm}|
 
 .. _video-standards:
 
@@ -293,7 +296,7 @@ support digital TV. See also the Linux DVB API at
 
 .. raw:: latex
 
-    \end{adjustbox}\newline\newline
+    \endgroup
 
 
 
diff --git a/Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst b/Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst
index e573c74138de..5b8e2fcb9c3a 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-dv-timings.rst
@@ -208,7 +208,7 @@ EBUSY
       - 0
       - BT.656/1120 timings
 
-
+.. tabularcolumns:: |p{4.5cm}|p{12.8cm}|
 
 .. _dv-bt-standards:
 
@@ -231,7 +231,7 @@ EBUSY
 	There are no horizontal syncs/porches at all in this format.
 	Total blanking timings must be set in hsync or vsync fields only.
 
-.. tabularcolumns:: |p{6.0cm}|p{11.5cm}|
+.. tabularcolumns:: |p{7.0cm}|p{10.5cm}|
 
 .. _dv-bt-flags:
 
diff --git a/Documentation/media/uapi/v4l/vidioc-g-enc-index.rst b/Documentation/media/uapi/v4l/vidioc-g-enc-index.rst
index 418e886fd44b..af0737fe4b32 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-enc-index.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-enc-index.rst
@@ -55,7 +55,7 @@ Currently this ioctl is only defined for MPEG-2 program streams and
 video elementary streams.
 
 
-.. tabularcolumns:: |p{3.5cm}|p{5.6cm}|p{8.4cm}|
+.. tabularcolumns:: |p{3.8cm}|p{5.6cm}|p{8.1cm}|
 
 .. c:type:: v4l2_enc_idx
 
diff --git a/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst b/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst
index 5ab8d2ac27b9..59a3bde8c1a3 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-ext-ctrls.rst
@@ -180,7 +180,7 @@ still cause this situation.
 	``V4L2_CTRL_FLAG_HAS_PAYLOAD`` is set for this control.
 
 
-.. tabularcolumns:: |p{4.0cm}|p{2.0cm}|p{2.0cm}|p{8.5cm}|
+.. tabularcolumns:: |p{4.0cm}|p{2.2cm}|p{2.1cm}|p{8.2cm}|
 
 .. c:type:: v4l2_ext_controls
 
diff --git a/Documentation/media/uapi/v4l/vidioc-g-sliced-vbi-cap.rst b/Documentation/media/uapi/v4l/vidioc-g-sliced-vbi-cap.rst
index d7e2b2fa8b88..f26650b6d409 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-sliced-vbi-cap.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-sliced-vbi-cap.rst
@@ -122,9 +122,9 @@ the sliced VBI API is unsupported or ``type`` is invalid.
 
 .. raw:: latex
 
-    \begin{adjustbox}{width=\columnwidth}
+    \scriptsize
 
-.. tabularcolumns:: |p{5.0cm}|p{1.4cm}|p{3.0cm}|p{2.5cm}|p{9.0cm}|
+.. tabularcolumns:: |p{3.5cm}|p{1.0cm}|p{2.0cm}|p{2.0cm}|p{8.0cm}|
 
 .. _vbi-services:
 
@@ -180,7 +180,7 @@ the sliced VBI API is unsupported or ``type`` is invalid.
 
 .. raw:: latex
 
-    \end{adjustbox}\newline\newline
+    \normalsize
 
 
 Return Value
diff --git a/Documentation/media/uapi/v4l/vidioc-g-tuner.rst b/Documentation/media/uapi/v4l/vidioc-g-tuner.rst
index 57c79fa43866..9278267f5e9a 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-tuner.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-tuner.rst
@@ -392,7 +392,7 @@ To change the radio frequency the
 
 .. raw:: latex
 
-    \begin{adjustbox}{width=\columnwidth}
+    \scriptsize
 
 .. _tuner-matrix:
 
@@ -441,7 +441,7 @@ To change the radio frequency the
 
 .. raw:: latex
 
-    \end{adjustbox}\newline\newline
+    \normalsize
 
 Return Value
 ============
diff --git a/Documentation/media/uapi/v4l/vidioc-queryctrl.rst b/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
index 41c5744a1239..518739ff40eb 100644
--- a/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
+++ b/Documentation/media/uapi/v4l/vidioc-queryctrl.rst
@@ -274,7 +274,7 @@ See also the examples in :ref:`control`.
 
 
 
-.. tabularcolumns:: |p{1.2cm}|p{0.6cm}|p{1.6cm}|p{13.5cm}|
+.. tabularcolumns:: |p{1.2cm}|p{1.0cm}|p{1.7cm}|p{13.0cm}|
 
 .. _v4l2-querymenu:
 
-- 
2.13.3
