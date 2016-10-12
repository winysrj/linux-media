Return-path: <linux-media-owner@vger.kernel.org>
Received: from relmlor3.renesas.com ([210.160.252.173]:47882 "EHLO
        relmlie2.idc.renesas.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932983AbcJLO0E (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Oct 2016 10:26:04 -0400
From: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
To: robh+dt@kernel.org, mark.rutland@arm.com, mchehab@kernel.org,
        hverkuil@xs4all.nl, sakari.ailus@linux.intel.com, crope@iki.fi
Cc: chris.paterson2@renesas.com, laurent.pinchart@ideasonboard.com,
        geert@linux-m68k.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
Subject: [RFC 5/5] doc_rst: media: New SDR formats SC16, SC18 & SC20
Date: Wed, 12 Oct 2016 15:10:29 +0100
Message-Id: <1476281429-27603-6-git-send-email-ramesh.shanmugasundaram@bp.renesas.com>
In-Reply-To: <1476281429-27603-1-git-send-email-ramesh.shanmugasundaram@bp.renesas.com>
References: <1476281429-27603-1-git-send-email-ramesh.shanmugasundaram@bp.renesas.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch adds documentation for the three new SDR formats

V4L2_SDR_FMT_SCU16BE
V4L2_SDR_FMT_SCU18BE
V4L2_SDR_FMT_SCU20BE

Signed-off-by: Ramesh Shanmugasundaram <ramesh.shanmugasundaram@bp.renesas.com>
---
 .../media/uapi/v4l/pixfmt-sdr-scu16be.rst          | 44 ++++++++++++++++++++
 .../media/uapi/v4l/pixfmt-sdr-scu18be.rst          | 48 ++++++++++++++++++++++
 .../media/uapi/v4l/pixfmt-sdr-scu20be.rst          | 48 ++++++++++++++++++++++
 Documentation/media/uapi/v4l/sdr-formats.rst       |  3 ++
 4 files changed, 143 insertions(+)
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-sdr-scu16be.rst
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-sdr-scu18be.rst
 create mode 100644 Documentation/media/uapi/v4l/pixfmt-sdr-scu20be.rst

diff --git a/Documentation/media/uapi/v4l/pixfmt-sdr-scu16be.rst b/Documentation/media/uapi/v4l/pixfmt-sdr-scu16be.rst
new file mode 100644
index 0000000..d6c2123
--- /dev/null
+++ b/Documentation/media/uapi/v4l/pixfmt-sdr-scu16be.rst
@@ -0,0 +1,44 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _V4L2-SDR-FMT-SCU16BE:
+
+******************************
+V4L2_SDR_FMT_SCU16BE ('SCU16')
+******************************
+
+Sliced complex unsigned 16-bit big endian IQ sample
+
+
+Description
+===========
+
+This format contains a sequence of complex number samples. Each complex
+number consist of two parts called In-phase and Quadrature (IQ). Both I
+and Q are represented as a 16 bit unsigned big endian number. I value
+starts first and Q value starts at an offset equalling half of the buffer
+size. 14 bit data is stored in 16 bit space with unused stuffed bits
+padded with 0.
+
+**Byte Order.**
+Each cell is one byte.
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+    -  .. row 1
+
+       -  start + 0:
+
+       -  I'\ :sub:`0[D13:D6]`
+
+       -  I'\ :sub:`0[D5:D0]`
+
+    -  .. row 2
+
+       -  start + buffer_size/2:
+
+       -  Q'\ :sub:`0[D13:D6]`
+
+       -  Q'\ :sub:`0[D5:D0]`
diff --git a/Documentation/media/uapi/v4l/pixfmt-sdr-scu18be.rst b/Documentation/media/uapi/v4l/pixfmt-sdr-scu18be.rst
new file mode 100644
index 0000000..e6e0aff
--- /dev/null
+++ b/Documentation/media/uapi/v4l/pixfmt-sdr-scu18be.rst
@@ -0,0 +1,48 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _V4L2-SDR-FMT-SCU18BE:
+
+******************************
+V4L2_SDR_FMT_SCU18BE ('SCU18')
+******************************
+
+Sliced complex unsigned 18-bit big endian IQ sample
+
+
+Description
+===========
+
+This format contains a sequence of complex number samples. Each complex
+number consist of two parts called In-phase and Quadrature (IQ). Both I
+and Q are represented as a 18 bit unsigned big endian number. I value
+starts first and Q value starts at an offset equalling half of the buffer
+size. 16 bit data is stored in 18 bit space with unused stuffed bits
+padded with 0.
+
+**Byte Order.**
+Each cell is one byte.
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+    -  .. row 1
+
+       -  start + 0:
+
+       -  I'\ :sub:`0[D17:D10]`
+
+       -  I'\ :sub:`0[D9:D2]`
+
+       -  I'\ :sub:`0[D1:D0]`
+
+    -  .. row 2
+
+       -  start + buffer_size/2:
+
+       -  Q'\ :sub:`0[D17:D10]`
+
+       -  Q'\ :sub:`0[D9:D2]`
+
+       -  Q'\ :sub:`0[D1:D0]`
diff --git a/Documentation/media/uapi/v4l/pixfmt-sdr-scu20be.rst b/Documentation/media/uapi/v4l/pixfmt-sdr-scu20be.rst
new file mode 100644
index 0000000..374e0a3
--- /dev/null
+++ b/Documentation/media/uapi/v4l/pixfmt-sdr-scu20be.rst
@@ -0,0 +1,48 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _V4L2-SDR-FMT-SCU20BE:
+
+******************************
+V4L2_SDR_FMT_SCU20BE ('SCU20')
+******************************
+
+Sliced complex unsigned 20-bit big endian IQ sample
+
+
+Description
+===========
+
+This format contains a sequence of complex number samples. Each complex
+number consist of two parts called In-phase and Quadrature (IQ). Both I
+and Q are represented as a 20 bit unsigned big endian number. I value
+starts first and Q value starts at an offset equalling half of the buffer
+size. 18 bit data is stored in 20 bit space with unused stuffed bits
+padded with 0.
+
+**Byte Order.**
+Each cell is one byte.
+
+
+.. flat-table::
+    :header-rows:  0
+    :stub-columns: 0
+
+    -  .. row 1
+
+       -  start + 0:
+
+       -  I'\ :sub:`0[D19:D12]`
+
+       -  I'\ :sub:`0[D11:D4]`
+
+       -  I'\ :sub:`0[D3:D0]`
+
+    -  .. row 2
+
+       -  start + buffer_size/2:
+
+       -  Q'\ :sub:`0[D19:D12]`
+
+       -  Q'\ :sub:`0[D11:D4]`
+
+       -  Q'\ :sub:`0[D3:D0]`
diff --git a/Documentation/media/uapi/v4l/sdr-formats.rst b/Documentation/media/uapi/v4l/sdr-formats.rst
index f863c08..4c01cf9 100644
--- a/Documentation/media/uapi/v4l/sdr-formats.rst
+++ b/Documentation/media/uapi/v4l/sdr-formats.rst
@@ -17,3 +17,6 @@ These formats are used for :ref:`SDR <sdr>` interface only.
     pixfmt-sdr-cs08
     pixfmt-sdr-cs14le
     pixfmt-sdr-ru12le
+    pixfmt-sdr-scu16be
+    pixfmt-sdr-scu18be
+    pixfmt-sdr-scu20be
-- 
1.9.1

