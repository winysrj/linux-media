Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35320 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753393AbcHUSve (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 21 Aug 2016 14:51:34 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Markus Heiser <markus.heiser@darmarit.de>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Markus Heiser <markus.heiser@darmarIT.de>
Subject: [PATCH 1/2] [media] docs-rst: fix some LaTeX errors when in interactive mode
Date: Sun, 21 Aug 2016 15:51:27 -0300
Message-Id: <d3a26c93496a56d76db52297bbead041c3a4a23a.1471805458.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are several minor issues that are seen when building
PDF on interactive mode.

Fix them.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 Documentation/media/uapi/v4l/dev-sliced-vbi.rst          | 2 +-
 Documentation/media/uapi/v4l/dev-subdev.rst              | 2 +-
 Documentation/media/uapi/v4l/pixfmt-packed-rgb.rst       | 3 +--
 Documentation/media/uapi/v4l/subdev-formats.rst          | 6 +++---
 Documentation/media/uapi/v4l/vidioc-enumstd.rst          | 2 +-
 Documentation/media/uapi/v4l/vidioc-g-sliced-vbi-cap.rst | 2 +-
 Documentation/media/uapi/v4l/vidioc-g-tuner.rst          | 4 ++--
 7 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/Documentation/media/uapi/v4l/dev-sliced-vbi.rst b/Documentation/media/uapi/v4l/dev-sliced-vbi.rst
index 074aa3798152..86d2d698d2af 100644
--- a/Documentation/media/uapi/v4l/dev-sliced-vbi.rst
+++ b/Documentation/media/uapi/v4l/dev-sliced-vbi.rst
@@ -255,7 +255,7 @@ Sliced VBI services
 
 .. raw:: latex
 
-    \newline\newline\begin{adjustbox}{width=\columnwidth}
+    \begin{adjustbox}{width=\columnwidth}
 
 .. tabularcolumns:: |p{5.0cm}|p{1.4cm}|p{3.0cm}|p{2.5cm}|p{9.0cm}|
 
diff --git a/Documentation/media/uapi/v4l/dev-subdev.rst b/Documentation/media/uapi/v4l/dev-subdev.rst
index 7d20c725583d..1045b3c61031 100644
--- a/Documentation/media/uapi/v4l/dev-subdev.rst
+++ b/Documentation/media/uapi/v4l/dev-subdev.rst
@@ -204,7 +204,7 @@ list entity names and pad numbers).
 
 .. raw:: latex
 
-    \newline\newline\begin{adjustbox}{width=\columnwidth}
+    \begin{adjustbox}{width=\columnwidth}
 
 .. tabularcolumns:: |p{4.5cm}|p{4.5cm}|p{4.5cm}|p{4.5cm}|p{4.5cm}|p{4.5cm}|p{4.5cm}|
 
diff --git a/Documentation/media/uapi/v4l/pixfmt-packed-rgb.rst b/Documentation/media/uapi/v4l/pixfmt-packed-rgb.rst
index 39875b4158d2..c94e1a5fee4d 100644
--- a/Documentation/media/uapi/v4l/pixfmt-packed-rgb.rst
+++ b/Documentation/media/uapi/v4l/pixfmt-packed-rgb.rst
@@ -16,7 +16,7 @@ next to each other in memory.
 
 .. raw:: latex
 
-    \newline\newline\begin{adjustbox}{width=\columnwidth}
+    \begin{adjustbox}{width=\columnwidth}
 
 .. tabularcolumns:: |p{4.5cm}|p{3.3cm}|p{0.7cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.2cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.2cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.2cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{1.7cm}|
 
@@ -1114,7 +1114,6 @@ either the corresponding ARGB or XRGB format, depending on the driver.
 
 .. raw:: latex
 
-    \newline\newline
     \begin{adjustbox}{width=\columnwidth}
 
 .. tabularcolumns:: |p{4.2cm}|p{1.0cm}|p{0.7cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.2cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.2cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.2cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{0.4cm}|p{1.7cm}|
diff --git a/Documentation/media/uapi/v4l/subdev-formats.rst b/Documentation/media/uapi/v4l/subdev-formats.rst
index 0b31943bb300..8b1ba4f53b18 100644
--- a/Documentation/media/uapi/v4l/subdev-formats.rst
+++ b/Documentation/media/uapi/v4l/subdev-formats.rst
@@ -159,7 +159,7 @@ The following tables list existing packed RGB formats.
 .. it switches to long table, and there's no way to override it.
 
 
-.. tabularcolumns:: |p{4.0cm}|p{0.7cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22}|
+.. tabularcolumns:: |p{4.0cm}|p{0.7cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|
 
 .. _v4l2-mbus-pixelcode-rgb:
 
@@ -2377,7 +2377,7 @@ JEIDA defined bit mapping will be named
 
 .. raw:: latex
 
-    \newline\newline\begin{adjustbox}{width=\columnwidth}
+    \begin{adjustbox}{width=\columnwidth}
 
 .. _v4l2-mbus-pixelcode-rgb-lvds:
 
@@ -3764,7 +3764,7 @@ the following codes.
 -  d for dummy bits
 
 
-.. tabularcolumns:: |p{4.0cm}|p{0.7cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22}|
+.. tabularcolumns:: |p{4.0cm}|p{0.7cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|
 
 .. _v4l2-mbus-pixelcode-yuv8:
 
diff --git a/Documentation/media/uapi/v4l/vidioc-enumstd.rst b/Documentation/media/uapi/v4l/vidioc-enumstd.rst
index 4c4b61561d85..5bd85932d33b 100644
--- a/Documentation/media/uapi/v4l/vidioc-enumstd.rst
+++ b/Documentation/media/uapi/v4l/vidioc-enumstd.rst
@@ -271,7 +271,7 @@ support digital TV. See also the Linux DVB API at
 
 .. raw:: latex
 
-    \newline\newline\begin{adjustbox}{width=\columnwidth}
+    \begin{adjustbox}{width=\columnwidth}
 
 ..                            NTSC/M   PAL/M    /N       /B       /D       /H       /I        SECAM/B    /D       /K1     /L
 .. tabularcolumns:: |p{2.7cm}|p{2.6cm}|p{3.0cm}|p{3.2cm}|p{3.2cm}|p{2.2cm}|p{1.2cm}|p{3.2cm}|p{3.0cm}|p{2.0cm}|p{2.0cm}|p{2.0cm}|
diff --git a/Documentation/media/uapi/v4l/vidioc-g-sliced-vbi-cap.rst b/Documentation/media/uapi/v4l/vidioc-g-sliced-vbi-cap.rst
index 6913f125c4f8..abda04b07999 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-sliced-vbi-cap.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-sliced-vbi-cap.rst
@@ -179,7 +179,7 @@ the sliced VBI API is unsupported or ``type`` is invalid.
 
 .. raw:: latex
 
-    \newline\newline\begin{adjustbox}{width=\columnwidth}
+    \begin{adjustbox}{width=\columnwidth}
 
 .. tabularcolumns:: |p{5.0cm}|p{1.4cm}|p{3.0cm}|p{2.5cm}|p{9.0cm}|
 
diff --git a/Documentation/media/uapi/v4l/vidioc-g-tuner.rst b/Documentation/media/uapi/v4l/vidioc-g-tuner.rst
index 333457fcdbe0..4658a4715a5e 100644
--- a/Documentation/media/uapi/v4l/vidioc-g-tuner.rst
+++ b/Documentation/media/uapi/v4l/vidioc-g-tuner.rst
@@ -257,7 +257,7 @@ To change the radio frequency the
 
        -  :cspan:`1` Reserved for future extensions.
 
-	   Drivers and applications must set the array to zero.
+	  Drivers and applications must set the array to zero.
 
 
 
@@ -620,7 +620,7 @@ To change the radio frequency the
 
 .. raw:: latex
 
-    \newline\newline\begin{adjustbox}{width=\columnwidth}
+    \begin{adjustbox}{width=\columnwidth}
 
 .. _tuner-matrix:
 
-- 
2.7.4

