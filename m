Return-path: <linux-media-owner@vger.kernel.org>
Received: from relmlor1.renesas.com ([210.160.252.171]:43763 "EHLO
        relmlie4.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750745AbcLUIZr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 21 Dec 2016 03:25:47 -0500
From: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
To: robh+dt@kernel.org, mark.rutland@arm.com, mchehab@kernel.org,
        hverkuil@xs4all.nl, sakari.ailus@linux.intel.com, crope@iki.fi
Cc: chris.paterson2@renesas.com, laurent.pinchart@ideasonboard.com,
        geert+renesas@glider.be, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
Subject: [PATCH v2 5/7] doc_rst: media: New SDR formats PC16, PC18 & PC20
Date: Wed, 21 Dec 2016 08:10:36 +0000
Message-Id: <1482307838-47415-6-git-send-email-ramesh.shanmugasundaram@bp.renesas.com>
In-Reply-To: <1482307838-47415-1-git-send-email-ramesh.shanmugasundaram@bp.renesas.com>
References: <1478706284-59134-1-git-send-email-ramesh.shanmugasundaram@bp.renesas.com>
 <1482307838-47415-1-git-send-email-ramesh.shanmugasundaram@bp.renesas.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds documentation for the three new SDR formats

V4L2_SDR_FMT_PCU16BE
V4L2_SDR_FMT_PCU18BE
V4L2_SDR_FMT_PCU20BE

Signed-off-by: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
---
 .../media/uapi/v4l/pixfmt-sdr-pcu16be.rst          | 55 ++++++++++++++++++++++
 .../media/uapi/v4l/pixfmt-sdr-pcu18be.rst          | 55 ++++++++++++++++++++++
 .../media/uapi/v4l/pixfmt-sdr-pcu20be.rst          | 55 ++++++++++++++++++++++
 Documentation/media/uapi/v4l/sdr-formats.rst       |  3 ++
 4 files changed, 168 insertions(+)
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-sdr-pcu16be.rst
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-sdr-pcu18be.rst
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-sdr-pcu20be.rst

diff --git a/Documentation/media/uapi/v4l/pixfmt-sdr-pcu16be.rst b/Documentation/media/uapi/v4l/pixfmt-sdr-pcu16be.rst
new file mode 100644
index 0000000..2de1b1a
--- /dev/null
+++ b/Documentation/media/uapi/v4l/pixfmt-sdr-pcu16be.rst
@@ -0,0 +1,55 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _V4L2-SDR-FMT-PCU16BE:
+
+******************************
+V4L2_SDR_FMT_PCU16BE ('PC16')
+******************************
+
+Planar complex unsigned 16-bit big endian IQ sample
+
+Description
+===========
+
+This format contains a sequence of complex number samples. Each complex
+number consist of two parts called In-phase and Quadrature (IQ). Both I
+and Q are represented as a 16 bit unsigned big endian number stored in
+32 bit space. The remaining unused bits within the 32 bit space will be
+padded with 0. I value starts first and Q value starts at an offset
+equalling half of the buffer size (i.e.) offset = buffersize/2. Out of
+the 16 bits, bit 15:2 (14 bit) is data and bit 1:0 (2 bit) can be any
+value.
+
+**Byte Order.**
+Each cell is one byte.
+
+.. flat-table::
+    :header-rows:  1
+    :stub-columns: 0
+
+    * -  Offset:
+      -  Byte B0
+      -  Byte B1
+      -  Byte B2
+      -  Byte B3
+    * -  start + 0:
+      -  I'\ :sub:`0[13:6]`
+      -  I'\ :sub:`0[5:0]; B1[1:0]=pad`
+      -  pad
+      -  pad
+    * -  start + 4:
+      -  I'\ :sub:`1[13:6]`
+      -  I'\ :sub:`1[5:0]; B1[1:0]=pad`
+      -  pad
+      -  pad
+    * -  ...
+    * - start + offset:
+      -  Q'\ :sub:`0[13:6]`
+      -  Q'\ :sub:`0[5:0]; B1[1:0]=pad`
+      -  pad
+      -  pad
+    * - start + offset + 4:
+      -  Q'\ :sub:`1[13:6]`
+      -  Q'\ :sub:`1[5:0]; B1[1:0]=pad`
+      -  pad
+      -  pad
diff --git a/Documentation/media/uapi/v4l/pixfmt-sdr-pcu18be.rst b/Documentation/media/uapi/v4l/pixfmt-sdr-pcu18be.rst
new file mode 100644
index 0000000..da8b26b
--- /dev/null
+++ b/Documentation/media/uapi/v4l/pixfmt-sdr-pcu18be.rst
@@ -0,0 +1,55 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _V4L2-SDR-FMT-PCU18BE:
+
+******************************
+V4L2_SDR_FMT_PCU18BE ('PC18')
+******************************
+
+Planar complex unsigned 18-bit big endian IQ sample
+
+Description
+===========
+
+This format contains a sequence of complex number samples. Each complex
+number consist of two parts called In-phase and Quadrature (IQ). Both I
+and Q are represented as a 18 bit unsigned big endian number stored in
+32 bit space. The remaining unused bits within the 32 bit space will be
+padded with 0. I value starts first and Q value starts at an offset
+equalling half of the buffer size (i.e.) offset = buffersize/2. Out of
+the 18 bits, bit 17:2 (16 bit) is data and bit 1:0 (2 bit) can be any
+value.
+
+**Byte Order.**
+Each cell is one byte.
+
+.. flat-table::
+    :header-rows:  1
+    :stub-columns: 0
+
+    * -  Offset:
+      -  Byte B0
+      -  Byte B1
+      -  Byte B2
+      -  Byte B3
+    * -  start + 0:
+      -  I'\ :sub:`0[17:10]`
+      -  I'\ :sub:`0[9:2]`
+      -  I'\ :sub:`0[1:0]; B2[5:0]=pad`
+      -  pad
+    * -  start + 4:
+      -  I'\ :sub:`1[17:10]`
+      -  I'\ :sub:`1[9:2]`
+      -  I'\ :sub:`1[1:0]; B2[5:0]=pad`
+      -  pad
+    * -  ...
+    * - start + offset:
+      -  Q'\ :sub:`0[17:10]`
+      -  Q'\ :sub:`0[9:2]`
+      -  Q'\ :sub:`0[1:0]; B2[5:0]=pad`
+      -  pad
+    * - start + offset + 4:
+      -  Q'\ :sub:`1[17:10]`
+      -  Q'\ :sub:`1[9:2]`
+      -  Q'\ :sub:`1[1:0]; B2[5:0]=pad`
+      -  pad
diff --git a/Documentation/media/uapi/v4l/pixfmt-sdr-pcu20be.rst b/Documentation/media/uapi/v4l/pixfmt-sdr-pcu20be.rst
new file mode 100644
index 0000000..b073be5
--- /dev/null
+++ b/Documentation/media/uapi/v4l/pixfmt-sdr-pcu20be.rst
@@ -0,0 +1,55 @@
+.. -*- coding: utf-8; mode: rst -*-
+.. _V4L2-SDR-FMT-PCU20BE:
+
+******************************
+V4L2_SDR_FMT_PCU20BE ('PC20')
+******************************
+
+Planar complex unsigned 20-bit big endian IQ sample
+
+Description
+===========
+
+This format contains a sequence of complex number samples. Each complex
+number consist of two parts called In-phase and Quadrature (IQ). Both I
+and Q are represented as a 20 bit unsigned big endian number stored in
+32 bit space. The remaining unused bits within the 32 bit space will be
+padded with 0. I value starts first and Q value starts at an offset
+equalling half of the buffer size (i.e.) offset = buffersize/2. Out of
+the 20 bits, bit 19:2 (18 bit) is data and bit 1:0 (2 bit) can be any
+value.
+
+**Byte Order.**
+Each cell is one byte.
+
+.. flat-table::
+    :header-rows:  1
+    :stub-columns: 0
+
+    * -  Offset:
+      -  Byte B0
+      -  Byte B1
+      -  Byte B2
+      -  Byte B3
+    * -  start + 0:
+      -  I'\ :sub:`0[19:12]`
+      -  I'\ :sub:`0[11:4]`
+      -  I'\ :sub:`0[3:0]; B2[3:0]=pad`
+      -  pad
+    * -  start + 4:
+      -  I'\ :sub:`1[19:12]`
+      -  I'\ :sub:`1[11:4]`
+      -  I'\ :sub:`1[3:0]; B2[3:0]=pad`
+      -  pad
+    * -  ...
+    * - start + offset:
+      -  Q'\ :sub:`0[19:12]`
+      -  Q'\ :sub:`0[11:4]`
+      -  Q'\ :sub:`0[3:0]; B2[3:0]=pad`
+      -  pad
+    * - start + offset + 4:
+      -  Q'\ :sub:`1[19:12]`
+      -  Q'\ :sub:`1[11:4]`
+      -  Q'\ :sub:`1[3:0]; B2[3:0]=pad`
+      -  pad
+
diff --git a/Documentation/media/uapi/v4l/sdr-formats.rst b/Documentation/media/uapi/v4l/sdr-formats.rst
index f863c08..2037f5b 100644
--- a/Documentation/media/uapi/v4l/sdr-formats.rst
+++ b/Documentation/media/uapi/v4l/sdr-formats.rst
@@ -17,3 +17,6 @@ These formats are used for :ref:`SDR <sdr>` interface only.
     pixfmt-sdr-cs08
     pixfmt-sdr-cs14le
     pixfmt-sdr-ru12le
+    pixfmt-sdr-pcu16be
+    pixfmt-sdr-pcu18be
+    pixfmt-sdr-pcu20be
-- 
1.9.1

