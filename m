Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:53552 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750836AbdG0Jam (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Jul 2017 05:30:42 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hansverk@cisco.com>
Subject: [PATCH 1/3] media/doc: rename and reorder pixfmt files
Date: Thu, 27 Jul 2017 11:30:30 +0200
Message-Id: <20170727093032.12663-2-hverkuil@xs4all.nl>
In-Reply-To: <20170727093032.12663-1-hverkuil@xs4all.nl>
References: <20170727093032.12663-1-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hansverk@cisco.com>

After the DocBook conversion a number of pixfmt description files just had
a number in the filename (pix-fmt-004, 006, etc) which was not very descriptive.

Rename them.

Note that pixfmt-008.rst was folded into colorspaces-details.rst, so that
file is deleted. It's easier to maintain that way.

Also moved the colorspace sections to the end of the chapter. The old order
was weird: the "Standard Image Formats" section (an intro into pixel formats)
was followed by the colorspace sections instead of the pixel format descriptions.

Moving it to the end resolved that issue.

Signed-off-by: Hans Verkuil <hansverk@cisco.com>
---
 .../v4l/{pixfmt-006.rst => colorspaces-defs.rst}   |  0
 .../{pixfmt-007.rst => colorspaces-details.rst}    | 30 ++++++++++++++++++++
 Documentation/media/uapi/v4l/pixfmt-008.rst        | 32 ----------------------
 .../v4l/{pixfmt-013.rst => pixfmt-compressed.rst}  |  0
 .../uapi/v4l/{pixfmt-004.rst => pixfmt-intro.rst}  |  0
 .../v4l/{pixfmt-003.rst => pixfmt-v4l2-mplane.rst} |  0
 .../uapi/v4l/{pixfmt-002.rst => pixfmt-v4l2.rst}   |  0
 Documentation/media/uapi/v4l/pixfmt.rst            | 15 +++++-----
 8 files changed, 37 insertions(+), 40 deletions(-)
 rename Documentation/media/uapi/v4l/{pixfmt-006.rst => colorspaces-defs.rst} (100%)
 rename Documentation/media/uapi/v4l/{pixfmt-007.rst => colorspaces-details.rst} (96%)
 delete mode 100644 Documentation/media/uapi/v4l/pixfmt-008.rst
 rename Documentation/media/uapi/v4l/{pixfmt-013.rst => pixfmt-compressed.rst} (100%)
 rename Documentation/media/uapi/v4l/{pixfmt-004.rst => pixfmt-intro.rst} (100%)
 rename Documentation/media/uapi/v4l/{pixfmt-003.rst => pixfmt-v4l2-mplane.rst} (100%)
 rename Documentation/media/uapi/v4l/{pixfmt-002.rst => pixfmt-v4l2.rst} (100%)

diff --git a/Documentation/media/uapi/v4l/pixfmt-006.rst b/Documentation/media/uapi/v4l/colorspaces-defs.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/pixfmt-006.rst
rename to Documentation/media/uapi/v4l/colorspaces-defs.rst
diff --git a/Documentation/media/uapi/v4l/pixfmt-007.rst b/Documentation/media/uapi/v4l/colorspaces-details.rst
similarity index 96%
rename from Documentation/media/uapi/v4l/pixfmt-007.rst
rename to Documentation/media/uapi/v4l/colorspaces-details.rst
index 0c30ee2577d3..128b2acbe824 100644
--- a/Documentation/media/uapi/v4l/pixfmt-007.rst
+++ b/Documentation/media/uapi/v4l/colorspaces-details.rst
@@ -758,3 +758,33 @@ scaled to [-128…128] and then clipped to [-128…127].
    ``V4L2_COLORSPACE_JPEG`` can be considered to be an abbreviation for
    ``V4L2_COLORSPACE_SRGB``, ``V4L2_YCBCR_ENC_601`` and
    ``V4L2_QUANTIZATION_FULL_RANGE``.
+
+***************************************
+Detailed Transfer Function Descriptions
+***************************************
+
+.. _xf-smpte-2084:
+
+Transfer Function SMPTE 2084 (V4L2_XFER_FUNC_SMPTE2084)
+=======================================================
+
+The :ref:`smpte2084` standard defines the transfer function used by
+High Dynamic Range content.
+
+Constants:
+    m1 = (2610 / 4096) / 4
+
+    m2 = (2523 / 4096) * 128
+
+    c1 = 3424 / 4096
+
+    c2 = (2413 / 4096) * 32
+
+    c3 = (2392 / 4096) * 32
+
+Transfer function:
+    L' = ((c1 + c2 * L\ :sup:`m1`) / (1 + c3 * L\ :sup:`m1`))\ :sup:`m2`
+
+Inverse Transfer function:
+    L = (max(L':sup:`1/m2` - c1, 0) / (c2 - c3 *
+    L'\ :sup:`1/m2`))\ :sup:`1/m1`
diff --git a/Documentation/media/uapi/v4l/pixfmt-008.rst b/Documentation/media/uapi/v4l/pixfmt-008.rst
deleted file mode 100644
index 4bec79784bdd..000000000000
--- a/Documentation/media/uapi/v4l/pixfmt-008.rst
+++ /dev/null
@@ -1,32 +0,0 @@
-.. -*- coding: utf-8; mode: rst -*-
-
-***************************************
-Detailed Transfer Function Descriptions
-***************************************
-
-
-.. _xf-smpte-2084:
-
-Transfer Function SMPTE 2084 (V4L2_XFER_FUNC_SMPTE2084)
-=======================================================
-
-The :ref:`smpte2084` standard defines the transfer function used by
-High Dynamic Range content.
-
-Constants:
-    m1 = (2610 / 4096) / 4
-
-    m2 = (2523 / 4096) * 128
-
-    c1 = 3424 / 4096
-
-    c2 = (2413 / 4096) * 32
-
-    c3 = (2392 / 4096) * 32
-
-Transfer function:
-    L' = ((c1 + c2 * L\ :sup:`m1`) / (1 + c3 * L\ :sup:`m1`))\ :sup:`m2`
-
-Inverse Transfer function:
-    L = (max(L':sup:`1/m2` - c1, 0) / (c2 - c3 *
-    L'\ :sup:`1/m2`))\ :sup:`1/m1`
diff --git a/Documentation/media/uapi/v4l/pixfmt-013.rst b/Documentation/media/uapi/v4l/pixfmt-compressed.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/pixfmt-013.rst
rename to Documentation/media/uapi/v4l/pixfmt-compressed.rst
diff --git a/Documentation/media/uapi/v4l/pixfmt-004.rst b/Documentation/media/uapi/v4l/pixfmt-intro.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/pixfmt-004.rst
rename to Documentation/media/uapi/v4l/pixfmt-intro.rst
diff --git a/Documentation/media/uapi/v4l/pixfmt-003.rst b/Documentation/media/uapi/v4l/pixfmt-v4l2-mplane.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/pixfmt-003.rst
rename to Documentation/media/uapi/v4l/pixfmt-v4l2-mplane.rst
diff --git a/Documentation/media/uapi/v4l/pixfmt-002.rst b/Documentation/media/uapi/v4l/pixfmt-v4l2.rst
similarity index 100%
rename from Documentation/media/uapi/v4l/pixfmt-002.rst
rename to Documentation/media/uapi/v4l/pixfmt-v4l2.rst
diff --git a/Documentation/media/uapi/v4l/pixfmt.rst b/Documentation/media/uapi/v4l/pixfmt.rst
index 00737152497b..2aa449e2da67 100644
--- a/Documentation/media/uapi/v4l/pixfmt.rst
+++ b/Documentation/media/uapi/v4l/pixfmt.rst
@@ -19,20 +19,19 @@ see also :ref:`VIDIOC_G_FBUF <VIDIOC_G_FBUF>`.)
 .. toctree::
     :maxdepth: 1
 
-    pixfmt-002
-    pixfmt-003
-    pixfmt-004
-    colorspaces
-    pixfmt-006
-    pixfmt-007
-    pixfmt-008
+    pixfmt-v4l2
+    pixfmt-v4l2-mplane
+    pixfmt-intro
     pixfmt-indexed
     pixfmt-rgb
     yuv-formats
     hsv-formats
     depth-formats
-    pixfmt-013
+    pixfmt-compressed
     sdr-formats
     tch-formats
     meta-formats
     pixfmt-reserved
+    colorspaces
+    colorspaces-defs
+    colorspaces-details
-- 
2.13.1
