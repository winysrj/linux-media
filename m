Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:35035 "EHLO
        mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756271AbdCGX4e (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 7 Mar 2017 18:56:34 -0500
Received: by mail-wm0-f46.google.com with SMTP id v186so102515171wmd.0
        for <linux-media@vger.kernel.org>; Tue, 07 Mar 2017 15:54:46 -0800 (PST)
From: Neil Armstrong <narmstrong@baylibre.com>
To: dri-devel@lists.freedesktop.org,
        laurent.pinchart+renesas@ideasonboard.com, architt@codeaurora.org,
        mchehab@kernel.org
Cc: Neil Armstrong <narmstrong@baylibre.com>, Jose.Abreu@synopsys.com,
        kieran.bingham@ideasonboard.com, linux-amlogic@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-media@vger.kernel.org, hans.verkuil@cisco.com,
        sakari.ailus@linux.intel.com
Subject: [PATCH v3 3/6] documentation: media: Add documentation for new RGB and YUV bus formats
Date: Tue,  7 Mar 2017 17:42:21 +0100
Message-Id: <1488904944-14285-4-git-send-email-narmstrong@baylibre.com>
In-Reply-To: <1488904944-14285-1-git-send-email-narmstrong@baylibre.com>
References: <1488904944-14285-1-git-send-email-narmstrong@baylibre.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add documentation for added Bus Formats to describe RGB and YUS formats used
as input to the Synopsys DesignWare HDMI TX Controller.

Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
---
 Documentation/media/uapi/v4l/subdev-formats.rst | 4992 ++++++++++++++++++-----
 1 file changed, 3963 insertions(+), 1029 deletions(-)

diff --git a/Documentation/media/uapi/v4l/subdev-formats.rst b/Documentation/media/uapi/v4l/subdev-formats.rst
index d6152c9..feb55b5 100644
--- a/Documentation/media/uapi/v4l/subdev-formats.rst
+++ b/Documentation/media/uapi/v4l/subdev-formats.rst
@@ -114,7 +114,7 @@ The following tables list existing packed RGB formats.
 .. it switches to long table, and there's no way to override it.
 
 
-.. tabularcolumns:: |p{4.0cm}|p{0.7cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|
+.. tabularcolumns:: |p{4.0cm}|p{0.7cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|
 
 .. _v4l2-mbus-pixelcode-rgb:
 
@@ -127,7 +127,7 @@ The following tables list existing packed RGB formats.
 .. flat-table:: RGB formats
     :header-rows:  2
     :stub-columns: 0
-    :widths: 36 7 3 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2
+    :widths: 36 7 3 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2
 
     * - Identifier
       - Code
@@ -136,6 +136,22 @@ The following tables list existing packed RGB formats.
     * -
       -
       - Bit
+      - 47
+      - 46
+      - 45
+      - 44
+      - 43
+      - 42
+      - 41
+      - 40
+      - 39
+      - 38
+      - 37
+      - 36
+      - 35
+      - 34
+      - 33
+      - 32
       - 31
       - 30
       - 29
@@ -193,6 +209,22 @@ The following tables list existing packed RGB formats.
       -
       -
       -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
       - r\ :sub:`3`
       - r\ :sub:`2`
       - r\ :sub:`1`
@@ -234,6 +266,22 @@ The following tables list existing packed RGB formats.
       -
       -
       -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
       - 0
       - 0
       - 0
@@ -269,6 +317,22 @@ The following tables list existing packed RGB formats.
       -
       -
       -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
       - g\ :sub:`3`
       - g\ :sub:`2`
       - g\ :sub:`1`
@@ -306,6 +370,22 @@ The following tables list existing packed RGB formats.
       -
       -
       -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
       - g\ :sub:`3`
       - g\ :sub:`2`
       - g\ :sub:`1`
@@ -341,6 +421,22 @@ The following tables list existing packed RGB formats.
       -
       -
       -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
       - 0
       - 0
       - 0
@@ -378,6 +474,22 @@ The following tables list existing packed RGB formats.
       -
       -
       -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
       - 0
       - r\ :sub:`4`
       - r\ :sub:`3`
@@ -413,6 +525,22 @@ The following tables list existing packed RGB formats.
       -
       -
       -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
       - g\ :sub:`2`
       - g\ :sub:`1`
       - g\ :sub:`0`
@@ -450,6 +578,22 @@ The following tables list existing packed RGB formats.
       -
       -
       -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
       - g\ :sub:`2`
       - g\ :sub:`1`
       - g\ :sub:`0`
@@ -485,6 +629,22 @@ The following tables list existing packed RGB formats.
       -
       -
       -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
       - 0
       - r\ :sub:`4`
       - r\ :sub:`3`
@@ -514,6 +674,22 @@ The following tables list existing packed RGB formats.
       -
       -
       -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
       - r\ :sub:`4`
       - r\ :sub:`3`
       - r\ :sub:`2`
@@ -559,6 +735,22 @@ The following tables list existing packed RGB formats.
       -
       -
       -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
       - b\ :sub:`4`
       - b\ :sub:`3`
       - b\ :sub:`2`
@@ -594,6 +786,22 @@ The following tables list existing packed RGB formats.
       -
       -
       -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
       - g\ :sub:`2`
       - g\ :sub:`1`
       - g\ :sub:`0`
@@ -631,6 +839,22 @@ The following tables list existing packed RGB formats.
       -
       -
       -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
       - g\ :sub:`2`
       - g\ :sub:`1`
       - g\ :sub:`0`
@@ -666,6 +890,22 @@ The following tables list existing packed RGB formats.
       -
       -
       -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
       - b\ :sub:`4`
       - b\ :sub:`3`
       - b\ :sub:`2`
@@ -703,6 +943,22 @@ The following tables list existing packed RGB formats.
       -
       -
       -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
       - r\ :sub:`4`
       - r\ :sub:`3`
       - r\ :sub:`2`
@@ -738,6 +994,22 @@ The following tables list existing packed RGB formats.
       -
       -
       -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
       - g\ :sub:`2`
       - g\ :sub:`1`
       - g\ :sub:`0`
@@ -775,6 +1047,22 @@ The following tables list existing packed RGB formats.
       -
       -
       -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
       - g\ :sub:`2`
       - g\ :sub:`1`
       - g\ :sub:`0`
@@ -810,6 +1098,22 @@ The following tables list existing packed RGB formats.
       -
       -
       -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
       - r\ :sub:`4`
       - r\ :sub:`3`
       - r\ :sub:`2`
@@ -837,6 +1141,22 @@ The following tables list existing packed RGB formats.
       -
       -
       -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
       - r\ :sub:`5`
       - r\ :sub:`4`
       - r\ :sub:`3`
@@ -868,6 +1188,22 @@ The following tables list existing packed RGB formats.
       -
       -
       -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
       - r\ :sub:`7`
       - r\ :sub:`6`
       - r\ :sub:`5`
@@ -905,6 +1241,22 @@ The following tables list existing packed RGB formats.
       -
       -
       -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
       - 0
       - 0
       - r\ :sub:`5`
@@ -942,6 +1294,22 @@ The following tables list existing packed RGB formats.
       -
       -
       -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
       - b\ :sub:`7`
       - b\ :sub:`6`
       - b\ :sub:`5`
@@ -979,6 +1347,22 @@ The following tables list existing packed RGB formats.
       -
       -
       -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
       - g\ :sub:`7`
       - g\ :sub:`6`
       - g\ :sub:`5`
@@ -1016,6 +1400,22 @@ The following tables list existing packed RGB formats.
       -
       -
       -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
       - r\ :sub:`7`
       - r\ :sub:`6`
       - r\ :sub:`5`
@@ -1065,6 +1465,22 @@ The following tables list existing packed RGB formats.
       -
       -
       -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
       - r\ :sub:`7`
       - r\ :sub:`6`
       - r\ :sub:`5`
@@ -1100,6 +1516,22 @@ The following tables list existing packed RGB formats.
       -
       -
       -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
       - g\ :sub:`3`
       - g\ :sub:`2`
       - g\ :sub:`1`
@@ -1137,6 +1569,22 @@ The following tables list existing packed RGB formats.
       -
       -
       -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
       - g\ :sub:`3`
       - g\ :sub:`2`
       - g\ :sub:`1`
@@ -1172,6 +1620,22 @@ The following tables list existing packed RGB formats.
       -
       -
       -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
       - r\ :sub:`7`
       - r\ :sub:`6`
       - r\ :sub:`5`
@@ -1189,6 +1653,22 @@ The following tables list existing packed RGB formats.
       - MEDIA_BUS_FMT_ARGB888_1X32
       - 0x100d
       -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
       - a\ :sub:`7`
       - a\ :sub:`6`
       - a\ :sub:`5`
@@ -1226,6 +1706,22 @@ The following tables list existing packed RGB formats.
       - MEDIA_BUS_FMT_RGB888_1X32_PADHI
       - 0x100f
       -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
       - 0
       - 0
       - 0
@@ -1258,42 +1754,201 @@ The following tables list existing packed RGB formats.
       - b\ :sub:`2`
       - b\ :sub:`1`
       - b\ :sub:`0`
+    * .. _MEDIA-BUS-FMT-RGB101010-1X30:
 
-.. raw:: latex
-
-    \endgroup
-
-On LVDS buses, usually each sample is transferred serialized in seven
-time slots per pixel clock, on three (18-bit) or four (24-bit)
-differential data pairs at the same time. The remaining bits are used
-for control signals as defined by SPWG/PSWG/VESA or JEIDA standards. The
-24-bit RGB format serialized in seven time slots on four lanes using
-JEIDA defined bit mapping will be named
-``MEDIA_BUS_FMT_RGB888_1X7X4_JEIDA``, for example.
-
-.. raw:: latex
-
-    \begin{adjustbox}{width=\columnwidth}
-
-.. _v4l2-mbus-pixelcode-rgb-lvds:
-
-.. flat-table:: LVDS RGB formats
-    :header-rows:  2
-    :stub-columns: 0
-
-    * - Identifier
-      - Code
+      - MEDIA_BUS_FMT_RGB101010_1X30
+      - 0x1018
       -
       -
-      - :cspan:`3` Data organization
-    * -
       -
-      - Timeslot
-      - Lane
-      - 3
-      - 2
-      - 1
-      - 0
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      - 0
+      - 0
+      - r\ :sub:`9`
+      - r\ :sub:`8`
+      - r\ :sub:`7`
+      - r\ :sub:`6`
+      - r\ :sub:`5`
+      - r\ :sub:`4`
+      - r\ :sub:`3`
+      - r\ :sub:`2`
+      - r\ :sub:`1`
+      - r\ :sub:`0`
+      - g\ :sub:`9`
+      - g\ :sub:`8`
+      - g\ :sub:`7`
+      - g\ :sub:`6`
+      - g\ :sub:`5`
+      - g\ :sub:`4`
+      - g\ :sub:`3`
+      - g\ :sub:`2`
+      - g\ :sub:`1`
+      - g\ :sub:`0`
+      - b\ :sub:`9`
+      - b\ :sub:`8`
+      - b\ :sub:`7`
+      - b\ :sub:`6`
+      - b\ :sub:`5`
+      - b\ :sub:`4`
+      - b\ :sub:`3`
+      - b\ :sub:`2`
+      - b\ :sub:`1`
+      - b\ :sub:`0`
+    * .. _MEDIA-BUS-FMT-RGB121212-1X36:
+
+      - MEDIA_BUS_FMT_RGB121212_1X36
+      - 0x1019
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      - r\ :sub:`11`
+      - r\ :sub:`10`
+      - r\ :sub:`9`
+      - r\ :sub:`8`
+      - r\ :sub:`7`
+      - r\ :sub:`6`
+      - r\ :sub:`5`
+      - r\ :sub:`4`
+      - r\ :sub:`3`
+      - r\ :sub:`2`
+      - r\ :sub:`1`
+      - r\ :sub:`0`
+      - g\ :sub:`11`
+      - g\ :sub:`10`
+      - g\ :sub:`9`
+      - g\ :sub:`8`
+      - g\ :sub:`7`
+      - g\ :sub:`6`
+      - g\ :sub:`5`
+      - g\ :sub:`4`
+      - g\ :sub:`3`
+      - g\ :sub:`2`
+      - g\ :sub:`1`
+      - g\ :sub:`0`
+      - b\ :sub:`11`
+      - b\ :sub:`10`
+      - b\ :sub:`9`
+      - b\ :sub:`8`
+      - b\ :sub:`7`
+      - b\ :sub:`6`
+      - b\ :sub:`5`
+      - b\ :sub:`4`
+      - b\ :sub:`3`
+      - b\ :sub:`2`
+      - b\ :sub:`1`
+      - b\ :sub:`0`
+    * .. _MEDIA-BUS-FMT-RGB161616-1X48:
+
+      - MEDIA_BUS_FMT_RGB161616_1X48
+      - 0x10
+      -
+      - r\ :sub:`15`
+      - r\ :sub:`14`
+      - r\ :sub:`13`
+      - r\ :sub:`12`
+      - r\ :sub:`11`
+      - r\ :sub:`10`
+      - r\ :sub:`9`
+      - r\ :sub:`8`
+      - r\ :sub:`7`
+      - r\ :sub:`6`
+      - r\ :sub:`5`
+      - r\ :sub:`4`
+      - r\ :sub:`3`
+      - r\ :sub:`2`
+      - r\ :sub:`1`
+      - r\ :sub:`0`
+      - g\ :sub:`15`
+      - g\ :sub:`14`
+      - g\ :sub:`13`
+      - g\ :sub:`12`
+      - g\ :sub:`11`
+      - g\ :sub:`10`
+      - g\ :sub:`9`
+      - g\ :sub:`8`
+      - g\ :sub:`7`
+      - g\ :sub:`6`
+      - g\ :sub:`5`
+      - g\ :sub:`4`
+      - g\ :sub:`3`
+      - g\ :sub:`2`
+      - g\ :sub:`1`
+      - g\ :sub:`0`
+      - b\ :sub:`15`
+      - b\ :sub:`14`
+      - b\ :sub:`13`
+      - b\ :sub:`12`
+      - b\ :sub:`11`
+      - b\ :sub:`10`
+      - b\ :sub:`9`
+      - b\ :sub:`8`
+      - b\ :sub:`7`
+      - b\ :sub:`6`
+      - b\ :sub:`5`
+      - b\ :sub:`4`
+      - b\ :sub:`3`
+      - b\ :sub:`2`
+      - b\ :sub:`1`
+      - b\ :sub:`0`
+
+.. raw:: latex
+
+    \endgroup
+
+On LVDS buses, usually each sample is transferred serialized in seven
+time slots per pixel clock, on three (18-bit) or four (24-bit)
+differential data pairs at the same time. The remaining bits are used
+for control signals as defined by SPWG/PSWG/VESA or JEIDA standards. The
+24-bit RGB format serialized in seven time slots on four lanes using
+JEIDA defined bit mapping will be named
+``MEDIA_BUS_FMT_RGB888_1X7X4_JEIDA``, for example.
+
+.. raw:: latex
+
+    \begin{adjustbox}{width=\columnwidth}
+
+.. _v4l2-mbus-pixelcode-rgb-lvds:
+
+.. flat-table:: LVDS RGB formats
+    :header-rows:  2
+    :stub-columns: 0
+
+    * - Identifier
+      - Code
+      -
+      -
+      - :cspan:`3` Data organization
+    * -
+      -
+      - Timeslot
+      - Lane
+      - 3
+      - 2
+      - 1
+      - 0
     * .. _MEDIA-BUS-FMT-RGB666-1X7X3-SPWG:
 
       - MEDIA_BUS_FMT_RGB666_1X7X3_SPWG
@@ -2387,14 +3042,14 @@ the following codes.
     \tiny
     \setlength{\tabcolsep}{2pt}
 
-.. tabularcolumns:: |p{4.0cm}|p{0.7cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|
+.. tabularcolumns:: |p{4.0cm}|p{4.0cm}|p{4.0cm}|p{4.0cm}|p{4.0cm}|p{4.0cm}|p{4.0cm}|p{4.0cm}|p{4.0cm}|p{4.0cm}|p{4.0cm}|p{4.0cm}|p{4.0cm}|p{4.0cm}|p{4.0cm}|p{4.0cm}|p{4.0cm}|p{0.7cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|p{0.22cm}|
 
 .. _v4l2-mbus-pixelcode-yuv8:
 
 .. flat-table:: YUV Formats
     :header-rows:  2
     :stub-columns: 0
-    :widths: 36 7 3 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2
+    :widths: 36 7 3 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2
 
     * - Identifier
       - Code
@@ -2403,6 +3058,22 @@ the following codes.
     * -
       -
       - Bit
+      - 47 
+      - 46
+      - 45
+      - 44
+      - 43
+      - 42
+      - 41
+      - 40
+      - 39
+      - 38
+      - 37
+      - 36
+      - 35
+      - 34
+      - 33
+      - 32
       - 31
       - 30
       - 29
@@ -2464,6 +3135,22 @@ the following codes.
       -
       -
       -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
       - y\ :sub:`7`
       - y\ :sub:`6`
       - y\ :sub:`5`
@@ -2501,6 +3188,22 @@ the following codes.
       -
       -
       -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
       - u\ :sub:`7`
       - u\ :sub:`6`
       - u\ :sub:`5`
@@ -2536,6 +3239,22 @@ the following codes.
       -
       -
       -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
       - v\ :sub:`7`
       - v\ :sub:`6`
       - v\ :sub:`5`
@@ -2573,6 +3292,22 @@ the following codes.
       -
       -
       -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
       - u\ :sub:`7`
       - u\ :sub:`6`
       - u\ :sub:`5`
@@ -2608,25 +3343,6 @@ the following codes.
       -
       -
       -
-      - y\ :sub:`7`
-      - y\ :sub:`6`
-      - y\ :sub:`5`
-      - y\ :sub:`4`
-      - y\ :sub:`3`
-      - y\ :sub:`2`
-      - y\ :sub:`1`
-      - y\ :sub:`0`
-    * -
-      -
-      -
-      -
-      -
-      -
-      -
-      -
-      -
-      -
-      -
       -
       -
       -
@@ -2678,25 +3394,6 @@ the following codes.
       -
       -
       -
-      - v\ :sub:`7`
-      - v\ :sub:`6`
-      - v\ :sub:`5`
-      - v\ :sub:`4`
-      - v\ :sub:`3`
-      - v\ :sub:`2`
-      - v\ :sub:`1`
-      - v\ :sub:`0`
-    * -
-      -
-      -
-      -
-      -
-      -
-      -
-      -
-      -
-      -
-      -
       -
       -
       -
@@ -2748,27 +3445,6 @@ the following codes.
       -
       -
       -
-      - y\ :sub:`7`
-      - y\ :sub:`6`
-      - y\ :sub:`5`
-      - y\ :sub:`4`
-      - y\ :sub:`3`
-      - y\ :sub:`2`
-      - y\ :sub:`1`
-      - y\ :sub:`0`
-    * .. _MEDIA-BUS-FMT-VYUY8-1_5X8:
-
-      - MEDIA_BUS_FMT_VYUY8_1_5X8
-      - 0x2003
-      -
-      -
-      -
-      -
-      -
-      -
-      -
-      -
-      -
       -
       -
       -
@@ -2820,25 +3496,6 @@ the following codes.
       -
       -
       -
-      - y\ :sub:`7`
-      - y\ :sub:`6`
-      - y\ :sub:`5`
-      - y\ :sub:`4`
-      - y\ :sub:`3`
-      - y\ :sub:`2`
-      - y\ :sub:`1`
-      - y\ :sub:`0`
-    * -
-      -
-      -
-      -
-      -
-      -
-      -
-      -
-      -
-      -
-      -
       -
       -
       -
@@ -2890,25 +3547,6 @@ the following codes.
       -
       -
       -
-      - u\ :sub:`7`
-      - u\ :sub:`6`
-      - u\ :sub:`5`
-      - u\ :sub:`4`
-      - u\ :sub:`3`
-      - u\ :sub:`2`
-      - u\ :sub:`1`
-      - u\ :sub:`0`
-    * -
-      -
-      -
-      -
-      -
-      -
-      -
-      -
-      -
-      -
-      -
       -
       -
       -
@@ -2933,7 +3571,10 @@ the following codes.
       - y\ :sub:`2`
       - y\ :sub:`1`
       - y\ :sub:`0`
-    * -
+    * .. _MEDIA-BUS-FMT-VYUY8-1_5X8:
+
+      - MEDIA_BUS_FMT_VYUY8_1_5X8
+      - 0x2003
       -
       -
       -
@@ -2960,18 +3601,6 @@ the following codes.
       -
       -
       -
-      - y\ :sub:`7`
-      - y\ :sub:`6`
-      - y\ :sub:`5`
-      - y\ :sub:`4`
-      - y\ :sub:`3`
-      - y\ :sub:`2`
-      - y\ :sub:`1`
-      - y\ :sub:`0`
-    * .. _MEDIA-BUS-FMT-YUYV8-1_5X8:
-
-      - MEDIA_BUS_FMT_YUYV8_1_5X8
-      - 0x2004
       -
       -
       -
@@ -2987,6 +3616,21 @@ the following codes.
       -
       -
       -
+      - v\ :sub:`7`
+      - v\ :sub:`6`
+      - v\ :sub:`5`
+      - v\ :sub:`4`
+      - v\ :sub:`3`
+      - v\ :sub:`2`
+      - v\ :sub:`1`
+      - v\ :sub:`0`
+    * -
+      -
+      -
+      -
+      -
+      -
+      -
       -
       -
       -
@@ -2997,15 +3641,6 @@ the following codes.
       -
       -
       -
-      - y\ :sub:`7`
-      - y\ :sub:`6`
-      - y\ :sub:`5`
-      - y\ :sub:`4`
-      - y\ :sub:`3`
-      - y\ :sub:`2`
-      - y\ :sub:`1`
-      - y\ :sub:`0`
-    * -
       -
       -
       -
@@ -3067,25 +3702,6 @@ the following codes.
       -
       -
       -
-      - u\ :sub:`7`
-      - u\ :sub:`6`
-      - u\ :sub:`5`
-      - u\ :sub:`4`
-      - u\ :sub:`3`
-      - u\ :sub:`2`
-      - u\ :sub:`1`
-      - u\ :sub:`0`
-    * -
-      -
-      -
-      -
-      -
-      -
-      -
-      -
-      -
-      -
-      -
       -
       -
       -
@@ -3137,15 +3753,6 @@ the following codes.
       -
       -
       -
-      - y\ :sub:`7`
-      - y\ :sub:`6`
-      - y\ :sub:`5`
-      - y\ :sub:`4`
-      - y\ :sub:`3`
-      - y\ :sub:`2`
-      - y\ :sub:`1`
-      - y\ :sub:`0`
-    * -
       -
       -
       -
@@ -3162,6 +3769,22 @@ the following codes.
       -
       -
       -
+      - u\ :sub:`7`
+      - u\ :sub:`6`
+      - u\ :sub:`5`
+      - u\ :sub:`4`
+      - u\ :sub:`3`
+      - u\ :sub:`2`
+      - u\ :sub:`1`
+      - u\ :sub:`0`
+    * -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
       -
       -
       -
@@ -3172,18 +3795,6 @@ the following codes.
       -
       -
       -
-      - v\ :sub:`7`
-      - v\ :sub:`6`
-      - v\ :sub:`5`
-      - v\ :sub:`4`
-      - v\ :sub:`3`
-      - v\ :sub:`2`
-      - v\ :sub:`1`
-      - v\ :sub:`0`
-    * .. _MEDIA-BUS-FMT-YVYU8-1_5X8:
-
-      - MEDIA_BUS_FMT_YVYU8_1_5X8
-      - 0x2005
       -
       -
       -
@@ -3244,15 +3855,6 @@ the following codes.
       -
       -
       -
-      - y\ :sub:`7`
-      - y\ :sub:`6`
-      - y\ :sub:`5`
-      - y\ :sub:`4`
-      - y\ :sub:`3`
-      - y\ :sub:`2`
-      - y\ :sub:`1`
-      - y\ :sub:`0`
-    * -
       -
       -
       -
@@ -3269,6 +3871,23 @@ the following codes.
       -
       -
       -
+      - y\ :sub:`7`
+      - y\ :sub:`6`
+      - y\ :sub:`5`
+      - y\ :sub:`4`
+      - y\ :sub:`3`
+      - y\ :sub:`2`
+      - y\ :sub:`1`
+      - y\ :sub:`0`
+    * .. _MEDIA-BUS-FMT-YUYV8-1_5X8:
+
+      - MEDIA_BUS_FMT_YUYV8_1_5X8
+      - 0x2004
+      -
+      -
+      -
+      -
+      -
       -
       -
       -
@@ -3279,15 +3898,6 @@ the following codes.
       -
       -
       -
-      - v\ :sub:`7`
-      - v\ :sub:`6`
-      - v\ :sub:`5`
-      - v\ :sub:`4`
-      - v\ :sub:`3`
-      - v\ :sub:`2`
-      - v\ :sub:`1`
-      - v\ :sub:`0`
-    * -
       -
       -
       -
@@ -3349,15 +3959,6 @@ the following codes.
       -
       -
       -
-      - y\ :sub:`7`
-      - y\ :sub:`6`
-      - y\ :sub:`5`
-      - y\ :sub:`4`
-      - y\ :sub:`3`
-      - y\ :sub:`2`
-      - y\ :sub:`1`
-      - y\ :sub:`0`
-    * -
       -
       -
       -
@@ -3374,6 +3975,22 @@ the following codes.
       -
       -
       -
+      - y\ :sub:`7`
+      - y\ :sub:`6`
+      - y\ :sub:`5`
+      - y\ :sub:`4`
+      - y\ :sub:`3`
+      - y\ :sub:`2`
+      - y\ :sub:`1`
+      - y\ :sub:`0`
+    * -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
       -
       -
       -
@@ -3384,18 +4001,6 @@ the following codes.
       -
       -
       -
-      - u\ :sub:`7`
-      - u\ :sub:`6`
-      - u\ :sub:`5`
-      - u\ :sub:`4`
-      - u\ :sub:`3`
-      - u\ :sub:`2`
-      - u\ :sub:`1`
-      - u\ :sub:`0`
-    * .. _MEDIA-BUS-FMT-UYVY8-2X8:
-
-      - MEDIA_BUS_FMT_UYVY8_2X8
-      - 0x2006
       -
       -
       -
@@ -3456,6 +4061,22 @@ the following codes.
       -
       -
       -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
       - y\ :sub:`7`
       - y\ :sub:`6`
       - y\ :sub:`5`
@@ -3491,15 +4112,6 @@ the following codes.
       -
       -
       -
-      - v\ :sub:`7`
-      - v\ :sub:`6`
-      - v\ :sub:`5`
-      - v\ :sub:`4`
-      - v\ :sub:`3`
-      - v\ :sub:`2`
-      - v\ :sub:`1`
-      - v\ :sub:`0`
-    * -
       -
       -
       -
@@ -3516,6 +4128,22 @@ the following codes.
       -
       -
       -
+      - y\ :sub:`7`
+      - y\ :sub:`6`
+      - y\ :sub:`5`
+      - y\ :sub:`4`
+      - y\ :sub:`3`
+      - y\ :sub:`2`
+      - y\ :sub:`1`
+      - y\ :sub:`0`
+    * -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
       -
       -
       -
@@ -3526,18 +4154,6 @@ the following codes.
       -
       -
       -
-      - y\ :sub:`7`
-      - y\ :sub:`6`
-      - y\ :sub:`5`
-      - y\ :sub:`4`
-      - y\ :sub:`3`
-      - y\ :sub:`2`
-      - y\ :sub:`1`
-      - y\ :sub:`0`
-    * .. _MEDIA-BUS-FMT-VYUY8-2X8:
-
-      - MEDIA_BUS_FMT_VYUY8_2X8
-      - 0x2007
       -
       -
       -
@@ -3571,7 +4187,10 @@ the following codes.
       - v\ :sub:`2`
       - v\ :sub:`1`
       - v\ :sub:`0`
-    * -
+    * .. _MEDIA-BUS-FMT-YVYU8-1_5X8:
+
+      - MEDIA_BUS_FMT_YVYU8_1_5X8
+      - 0x2005
       -
       -
       -
@@ -3598,15 +4217,6 @@ the following codes.
       -
       -
       -
-      - y\ :sub:`7`
-      - y\ :sub:`6`
-      - y\ :sub:`5`
-      - y\ :sub:`4`
-      - y\ :sub:`3`
-      - y\ :sub:`2`
-      - y\ :sub:`1`
-      - y\ :sub:`0`
-    * -
       -
       -
       -
@@ -3622,6 +4232,20 @@ the following codes.
       -
       -
       -
+      - y\ :sub:`7`
+      - y\ :sub:`6`
+      - y\ :sub:`5`
+      - y\ :sub:`4`
+      - y\ :sub:`3`
+      - y\ :sub:`2`
+      - y\ :sub:`1`
+      - y\ :sub:`0`
+    * -
+      -
+      -
+      -
+      -
+      -
       -
       -
       -
@@ -3633,15 +4257,6 @@ the following codes.
       -
       -
       -
-      - u\ :sub:`7`
-      - u\ :sub:`6`
-      - u\ :sub:`5`
-      - u\ :sub:`4`
-      - u\ :sub:`3`
-      - u\ :sub:`2`
-      - u\ :sub:`1`
-      - u\ :sub:`0`
-    * -
       -
       -
       -
@@ -3676,10 +4291,7 @@ the following codes.
       - y\ :sub:`2`
       - y\ :sub:`1`
       - y\ :sub:`0`
-    * .. _MEDIA-BUS-FMT-YUYV8-2X8:
-
-      - MEDIA_BUS_FMT_YUYV8_2X8
-      - 0x2008
+    * -
       -
       -
       -
@@ -3705,15 +4317,6 @@ the following codes.
       -
       -
       -
-      - y\ :sub:`7`
-      - y\ :sub:`6`
-      - y\ :sub:`5`
-      - y\ :sub:`4`
-      - y\ :sub:`3`
-      - y\ :sub:`2`
-      - y\ :sub:`1`
-      - y\ :sub:`0`
-    * -
       -
       -
       -
@@ -3731,6 +4334,22 @@ the following codes.
       -
       -
       -
+      - v\ :sub:`7`
+      - v\ :sub:`6`
+      - v\ :sub:`5`
+      - v\ :sub:`4`
+      - v\ :sub:`3`
+      - v\ :sub:`2`
+      - v\ :sub:`1`
+      - v\ :sub:`0`
+    * -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
       -
       -
       -
@@ -3740,15 +4359,6 @@ the following codes.
       -
       -
       -
-      - u\ :sub:`7`
-      - u\ :sub:`6`
-      - u\ :sub:`5`
-      - u\ :sub:`4`
-      - u\ :sub:`3`
-      - u\ :sub:`2`
-      - u\ :sub:`1`
-      - u\ :sub:`0`
-    * -
       -
       -
       -
@@ -3810,27 +4420,6 @@ the following codes.
       -
       -
       -
-      - v\ :sub:`7`
-      - v\ :sub:`6`
-      - v\ :sub:`5`
-      - v\ :sub:`4`
-      - v\ :sub:`3`
-      - v\ :sub:`2`
-      - v\ :sub:`1`
-      - v\ :sub:`0`
-    * .. _MEDIA-BUS-FMT-YVYU8-2X8:
-
-      - MEDIA_BUS_FMT_YVYU8_2X8
-      - 0x2009
-      -
-      -
-      -
-      -
-      -
-      -
-      -
-      -
-      -
       -
       -
       -
@@ -3882,15 +4471,6 @@ the following codes.
       -
       -
       -
-      - v\ :sub:`7`
-      - v\ :sub:`6`
-      - v\ :sub:`5`
-      - v\ :sub:`4`
-      - v\ :sub:`3`
-      - v\ :sub:`2`
-      - v\ :sub:`1`
-      - v\ :sub:`0`
-    * -
       -
       -
       -
@@ -3907,6 +4487,23 @@ the following codes.
       -
       -
       -
+      - u\ :sub:`7`
+      - u\ :sub:`6`
+      - u\ :sub:`5`
+      - u\ :sub:`4`
+      - u\ :sub:`3`
+      - u\ :sub:`2`
+      - u\ :sub:`1`
+      - u\ :sub:`0`
+    * .. _MEDIA-BUS-FMT-UYVY8-2X8:
+
+      - MEDIA_BUS_FMT_UYVY8_2X8
+      - 0x2006
+      -
+      -
+      -
+      -
+      -
       -
       -
       -
@@ -3917,15 +4514,6 @@ the following codes.
       -
       -
       -
-      - y\ :sub:`7`
-      - y\ :sub:`6`
-      - y\ :sub:`5`
-      - y\ :sub:`4`
-      - y\ :sub:`3`
-      - y\ :sub:`2`
-      - y\ :sub:`1`
-      - y\ :sub:`0`
-    * -
       -
       -
       -
@@ -3960,14 +4548,7 @@ the following codes.
       - u\ :sub:`2`
       - u\ :sub:`1`
       - u\ :sub:`0`
-    * .. _MEDIA-BUS-FMT-Y10-1X10:
-
-      - MEDIA_BUS_FMT_Y10_1X10
-      - 0x200a
-      -
-      -
-      -
-      -
+    * -
       -
       -
       -
@@ -3987,20 +4568,6 @@ the following codes.
       -
       -
       -
-      - y\ :sub:`9`
-      - y\ :sub:`8`
-      - y\ :sub:`7`
-      - y\ :sub:`6`
-      - y\ :sub:`5`
-      - y\ :sub:`4`
-      - y\ :sub:`3`
-      - y\ :sub:`2`
-      - y\ :sub:`1`
-      - y\ :sub:`0`
-    * .. _MEDIA-BUS-FMT-UYVY10-2X10:
-
-      - MEDIA_BUS_FMT_UYVY10_2X10
-      - 0x2018
       -
       -
       -
@@ -4024,16 +4591,14 @@ the following codes.
       -
       -
       -
-      - u\ :sub:`9`
-      - u\ :sub:`8`
-      - u\ :sub:`7`
-      - u\ :sub:`6`
-      - u\ :sub:`5`
-      - u\ :sub:`4`
-      - u\ :sub:`3`
-      - u\ :sub:`2`
-      - u\ :sub:`1`
-      - u\ :sub:`0`
+      - y\ :sub:`7`
+      - y\ :sub:`6`
+      - y\ :sub:`5`
+      - y\ :sub:`4`
+      - y\ :sub:`3`
+      - y\ :sub:`2`
+      - y\ :sub:`1`
+      - y\ :sub:`0`
     * -
       -
       -
@@ -4059,23 +4624,6 @@ the following codes.
       -
       -
       -
-      - y\ :sub:`9`
-      - y\ :sub:`8`
-      - y\ :sub:`7`
-      - y\ :sub:`6`
-      - y\ :sub:`5`
-      - y\ :sub:`4`
-      - y\ :sub:`3`
-      - y\ :sub:`2`
-      - y\ :sub:`1`
-      - y\ :sub:`0`
-    * -
-      -
-      -
-      -
-      -
-      -
-      -
       -
       -
       -
@@ -4094,8 +4642,6 @@ the following codes.
       -
       -
       -
-      - v\ :sub:`9`
-      - v\ :sub:`8`
       - v\ :sub:`7`
       - v\ :sub:`6`
       - v\ :sub:`5`
@@ -4129,20 +4675,6 @@ the following codes.
       -
       -
       -
-      - y\ :sub:`9`
-      - y\ :sub:`8`
-      - y\ :sub:`7`
-      - y\ :sub:`6`
-      - y\ :sub:`5`
-      - y\ :sub:`4`
-      - y\ :sub:`3`
-      - y\ :sub:`2`
-      - y\ :sub:`1`
-      - y\ :sub:`0`
-    * .. _MEDIA-BUS-FMT-VYUY10-2X10:
-
-      - MEDIA_BUS_FMT_VYUY10_2X10
-      - 0x2019
       -
       -
       -
@@ -4161,22 +4693,23 @@ the following codes.
       -
       -
       -
+      - y\ :sub:`7`
+      - y\ :sub:`6`
+      - y\ :sub:`5`
+      - y\ :sub:`4`
+      - y\ :sub:`3`
+      - y\ :sub:`2`
+      - y\ :sub:`1`
+      - y\ :sub:`0`
+    * .. _MEDIA-BUS-FMT-VYUY8-2X8:
+
+      - MEDIA_BUS_FMT_VYUY8_2X8
+      - 0x2007
       -
       -
       -
       -
       -
-      - v\ :sub:`9`
-      - v\ :sub:`8`
-      - v\ :sub:`7`
-      - v\ :sub:`6`
-      - v\ :sub:`5`
-      - v\ :sub:`4`
-      - v\ :sub:`3`
-      - v\ :sub:`2`
-      - v\ :sub:`1`
-      - v\ :sub:`0`
-    * -
       -
       -
       -
@@ -4201,17 +4734,6 @@ the following codes.
       -
       -
       -
-      - y\ :sub:`9`
-      - y\ :sub:`8`
-      - y\ :sub:`7`
-      - y\ :sub:`6`
-      - y\ :sub:`5`
-      - y\ :sub:`4`
-      - y\ :sub:`3`
-      - y\ :sub:`2`
-      - y\ :sub:`1`
-      - y\ :sub:`0`
-    * -
       -
       -
       -
@@ -4224,6 +4746,21 @@ the following codes.
       -
       -
       -
+      - v\ :sub:`7`
+      - v\ :sub:`6`
+      - v\ :sub:`5`
+      - v\ :sub:`4`
+      - v\ :sub:`3`
+      - v\ :sub:`2`
+      - v\ :sub:`1`
+      - v\ :sub:`0`
+    * -
+      -
+      -
+      -
+      -
+      -
+      -
       -
       -
       -
@@ -4236,17 +4773,6 @@ the following codes.
       -
       -
       -
-      - u\ :sub:`9`
-      - u\ :sub:`8`
-      - u\ :sub:`7`
-      - u\ :sub:`6`
-      - u\ :sub:`5`
-      - u\ :sub:`4`
-      - u\ :sub:`3`
-      - u\ :sub:`2`
-      - u\ :sub:`1`
-      - u\ :sub:`0`
-    * -
       -
       -
       -
@@ -4271,8 +4797,6 @@ the following codes.
       -
       -
       -
-      - y\ :sub:`9`
-      - y\ :sub:`8`
       - y\ :sub:`7`
       - y\ :sub:`6`
       - y\ :sub:`5`
@@ -4281,15 +4805,7 @@ the following codes.
       - y\ :sub:`2`
       - y\ :sub:`1`
       - y\ :sub:`0`
-    * .. _MEDIA-BUS-FMT-YUYV10-2X10:
-
-      - MEDIA_BUS_FMT_YUYV10_2X10
-      - 0x200b
-      -
-      -
-      -
-      -
-      -
+    * -
       -
       -
       -
@@ -4308,17 +4824,6 @@ the following codes.
       -
       -
       -
-      - y\ :sub:`9`
-      - y\ :sub:`8`
-      - y\ :sub:`7`
-      - y\ :sub:`6`
-      - y\ :sub:`5`
-      - y\ :sub:`4`
-      - y\ :sub:`3`
-      - y\ :sub:`2`
-      - y\ :sub:`1`
-      - y\ :sub:`0`
-    * -
       -
       -
       -
@@ -4343,8 +4848,6 @@ the following codes.
       -
       -
       -
-      - u\ :sub:`9`
-      - u\ :sub:`8`
       - u\ :sub:`7`
       - u\ :sub:`6`
       - u\ :sub:`5`
@@ -4378,8 +4881,24 @@ the following codes.
       -
       -
       -
-      - y\ :sub:`9`
-      - y\ :sub:`8`
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
       - y\ :sub:`7`
       - y\ :sub:`6`
       - y\ :sub:`5`
@@ -4388,13 +4907,10 @@ the following codes.
       - y\ :sub:`2`
       - y\ :sub:`1`
       - y\ :sub:`0`
-    * -
-      -
-      -
-      -
-      -
-      -
-      -
+    * .. _MEDIA-BUS-FMT-YUYV8-2X8:
+
+      - MEDIA_BUS_FMT_YUYV8_2X8
+      - 0x2008
       -
       -
       -
@@ -4413,20 +4929,6 @@ the following codes.
       -
       -
       -
-      - v\ :sub:`9`
-      - v\ :sub:`8`
-      - v\ :sub:`7`
-      - v\ :sub:`6`
-      - v\ :sub:`5`
-      - v\ :sub:`4`
-      - v\ :sub:`3`
-      - v\ :sub:`2`
-      - v\ :sub:`1`
-      - v\ :sub:`0`
-    * .. _MEDIA-BUS-FMT-YVYU10-2X10:
-
-      - MEDIA_BUS_FMT_YVYU10_2X10
-      - 0x200c
       -
       -
       -
@@ -4450,8 +4952,6 @@ the following codes.
       -
       -
       -
-      - y\ :sub:`9`
-      - y\ :sub:`8`
       - y\ :sub:`7`
       - y\ :sub:`6`
       - y\ :sub:`5`
@@ -4485,23 +4985,6 @@ the following codes.
       -
       -
       -
-      - v\ :sub:`9`
-      - v\ :sub:`8`
-      - v\ :sub:`7`
-      - v\ :sub:`6`
-      - v\ :sub:`5`
-      - v\ :sub:`4`
-      - v\ :sub:`3`
-      - v\ :sub:`2`
-      - v\ :sub:`1`
-      - v\ :sub:`0`
-    * -
-      -
-      -
-      -
-      -
-      -
-      -
       -
       -
       -
@@ -4520,16 +5003,14 @@ the following codes.
       -
       -
       -
-      - y\ :sub:`9`
-      - y\ :sub:`8`
-      - y\ :sub:`7`
-      - y\ :sub:`6`
-      - y\ :sub:`5`
-      - y\ :sub:`4`
-      - y\ :sub:`3`
-      - y\ :sub:`2`
-      - y\ :sub:`1`
-      - y\ :sub:`0`
+      - u\ :sub:`7`
+      - u\ :sub:`6`
+      - u\ :sub:`5`
+      - u\ :sub:`4`
+      - u\ :sub:`3`
+      - u\ :sub:`2`
+      - u\ :sub:`1`
+      - u\ :sub:`0`
     * -
       -
       -
@@ -4555,23 +5036,6 @@ the following codes.
       -
       -
       -
-      - u\ :sub:`9`
-      - u\ :sub:`8`
-      - u\ :sub:`7`
-      - u\ :sub:`6`
-      - u\ :sub:`5`
-      - u\ :sub:`4`
-      - u\ :sub:`3`
-      - u\ :sub:`2`
-      - u\ :sub:`1`
-      - u\ :sub:`0`
-    * .. _MEDIA-BUS-FMT-Y12-1X12:
-
-      - MEDIA_BUS_FMT_Y12_1X12
-      - 0x2013
-      -
-      -
-      -
       -
       -
       -
@@ -4590,10 +5054,6 @@ the following codes.
       -
       -
       -
-      - y\ :sub:`11`
-      - y\ :sub:`10`
-      - y\ :sub:`9`
-      - y\ :sub:`8`
       - y\ :sub:`7`
       - y\ :sub:`6`
       - y\ :sub:`5`
@@ -4602,14 +5062,7 @@ the following codes.
       - y\ :sub:`2`
       - y\ :sub:`1`
       - y\ :sub:`0`
-    * .. _MEDIA-BUS-FMT-UYVY12-2X12:
-
-      - MEDIA_BUS_FMT_UYVY12_2X12
-      - 0x201c
-      -
-      -
-      -
-      -
+    * -
       -
       -
       -
@@ -4627,19 +5080,6 @@ the following codes.
       -
       -
       -
-      - u\ :sub:`11`
-      - u\ :sub:`10`
-      - u\ :sub:`9`
-      - u\ :sub:`8`
-      - u\ :sub:`7`
-      - u\ :sub:`6`
-      - u\ :sub:`5`
-      - u\ :sub:`4`
-      - u\ :sub:`3`
-      - u\ :sub:`2`
-      - u\ :sub:`1`
-      - u\ :sub:`0`
-    * -
       -
       -
       -
@@ -4662,22 +5102,21 @@ the following codes.
       -
       -
       -
-      - y\ :sub:`11`
-      - y\ :sub:`10`
-      - y\ :sub:`9`
-      - y\ :sub:`8`
-      - y\ :sub:`7`
-      - y\ :sub:`6`
-      - y\ :sub:`5`
-      - y\ :sub:`4`
-      - y\ :sub:`3`
-      - y\ :sub:`2`
-      - y\ :sub:`1`
-      - y\ :sub:`0`
-    * -
       -
       -
       -
+      - v\ :sub:`7`
+      - v\ :sub:`6`
+      - v\ :sub:`5`
+      - v\ :sub:`4`
+      - v\ :sub:`3`
+      - v\ :sub:`2`
+      - v\ :sub:`1`
+      - v\ :sub:`0`
+    * .. _MEDIA-BUS-FMT-YVYU8-2X8:
+
+      - MEDIA_BUS_FMT_YVYU8_2X8
+      - 0x2009
       -
       -
       -
@@ -4697,19 +5136,6 @@ the following codes.
       -
       -
       -
-      - v\ :sub:`11`
-      - v\ :sub:`10`
-      - v\ :sub:`9`
-      - v\ :sub:`8`
-      - v\ :sub:`7`
-      - v\ :sub:`6`
-      - v\ :sub:`5`
-      - v\ :sub:`4`
-      - v\ :sub:`3`
-      - v\ :sub:`2`
-      - v\ :sub:`1`
-      - v\ :sub:`0`
-    * -
       -
       -
       -
@@ -4732,10 +5158,6 @@ the following codes.
       -
       -
       -
-      - y\ :sub:`11`
-      - y\ :sub:`10`
-      - y\ :sub:`9`
-      - y\ :sub:`8`
       - y\ :sub:`7`
       - y\ :sub:`6`
       - y\ :sub:`5`
@@ -4744,10 +5166,28 @@ the following codes.
       - y\ :sub:`2`
       - y\ :sub:`1`
       - y\ :sub:`0`
-    * .. _MEDIA-BUS-FMT-VYUY12-2X12:
-
-      - MEDIA_BUS_FMT_VYUY12_2X12
-      - 0x201d
+    * -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
       -
       -
       -
@@ -4769,10 +5209,6 @@ the following codes.
       -
       -
       -
-      - v\ :sub:`11`
-      - v\ :sub:`10`
-      - v\ :sub:`9`
-      - v\ :sub:`8`
       - v\ :sub:`7`
       - v\ :sub:`6`
       - v\ :sub:`5`
@@ -4804,10 +5240,26 @@ the following codes.
       -
       -
       -
-      - y\ :sub:`11`
-      - y\ :sub:`10`
-      - y\ :sub:`9`
-      - y\ :sub:`8`
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
       - y\ :sub:`7`
       - y\ :sub:`6`
       - y\ :sub:`5`
@@ -4839,10 +5291,26 @@ the following codes.
       -
       -
       -
-      - u\ :sub:`11`
-      - u\ :sub:`10`
-      - u\ :sub:`9`
-      - u\ :sub:`8`
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
       - u\ :sub:`7`
       - u\ :sub:`6`
       - u\ :sub:`5`
@@ -4851,7 +5319,27 @@ the following codes.
       - u\ :sub:`2`
       - u\ :sub:`1`
       - u\ :sub:`0`
-    * -
+    * .. _MEDIA-BUS-FMT-Y10-1X10:
+
+      - MEDIA_BUS_FMT_Y10_1X10
+      - 0x200a
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
       -
       -
       -
@@ -4874,8 +5362,6 @@ the following codes.
       -
       -
       -
-      - y\ :sub:`11`
-      - y\ :sub:`10`
       - y\ :sub:`9`
       - y\ :sub:`8`
       - y\ :sub:`7`
@@ -4886,14 +5372,10 @@ the following codes.
       - y\ :sub:`2`
       - y\ :sub:`1`
       - y\ :sub:`0`
-    * .. _MEDIA-BUS-FMT-YUYV12-2X12:
+    * .. _MEDIA-BUS-FMT-UYVY10-2X10:
 
-      - MEDIA_BUS_FMT_YUYV12_2X12
-      - 0x201e
-      -
-      -
-      -
-      -
+      - MEDIA_BUS_FMT_UYVY10_2X10
+      - 0x2018
       -
       -
       -
@@ -4911,19 +5393,6 @@ the following codes.
       -
       -
       -
-      - y\ :sub:`11`
-      - y\ :sub:`10`
-      - y\ :sub:`9`
-      - y\ :sub:`8`
-      - y\ :sub:`7`
-      - y\ :sub:`6`
-      - y\ :sub:`5`
-      - y\ :sub:`4`
-      - y\ :sub:`3`
-      - y\ :sub:`2`
-      - y\ :sub:`1`
-      - y\ :sub:`0`
-    * -
       -
       -
       -
@@ -4946,8 +5415,6 @@ the following codes.
       -
       -
       -
-      - u\ :sub:`11`
-      - u\ :sub:`10`
       - u\ :sub:`9`
       - u\ :sub:`8`
       - u\ :sub:`7`
@@ -4981,8 +5448,24 @@ the following codes.
       -
       -
       -
-      - y\ :sub:`11`
-      - y\ :sub:`10`
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
       - y\ :sub:`9`
       - y\ :sub:`8`
       - y\ :sub:`7`
@@ -5016,8 +5499,24 @@ the following codes.
       -
       -
       -
-      - v\ :sub:`11`
-      - v\ :sub:`10`
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
       - v\ :sub:`9`
       - v\ :sub:`8`
       - v\ :sub:`7`
@@ -5028,10 +5527,26 @@ the following codes.
       - v\ :sub:`2`
       - v\ :sub:`1`
       - v\ :sub:`0`
-    * .. _MEDIA-BUS-FMT-YVYU12-2X12:
-
-      - MEDIA_BUS_FMT_YVYU12_2X12
-      - 0x201f
+    * -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
       -
       -
       -
@@ -5053,8 +5568,6 @@ the following codes.
       -
       -
       -
-      - y\ :sub:`11`
-      - y\ :sub:`10`
       - y\ :sub:`9`
       - y\ :sub:`8`
       - y\ :sub:`7`
@@ -5065,7 +5578,27 @@ the following codes.
       - y\ :sub:`2`
       - y\ :sub:`1`
       - y\ :sub:`0`
-    * -
+    * .. _MEDIA-BUS-FMT-VYUY10-2X10:
+
+      - MEDIA_BUS_FMT_VYUY10_2X10
+      - 0x2019
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
       -
       -
       -
@@ -5088,8 +5621,6 @@ the following codes.
       -
       -
       -
-      - v\ :sub:`11`
-      - v\ :sub:`10`
       - v\ :sub:`9`
       - v\ :sub:`8`
       - v\ :sub:`7`
@@ -5123,8 +5654,24 @@ the following codes.
       -
       -
       -
-      - y\ :sub:`11`
-      - y\ :sub:`10`
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
       - y\ :sub:`9`
       - y\ :sub:`8`
       - y\ :sub:`7`
@@ -5158,22 +5705,6 @@ the following codes.
       -
       -
       -
-      - u\ :sub:`11`
-      - u\ :sub:`10`
-      - u\ :sub:`9`
-      - u\ :sub:`8`
-      - u\ :sub:`7`
-      - u\ :sub:`6`
-      - u\ :sub:`5`
-      - u\ :sub:`4`
-      - u\ :sub:`3`
-      - u\ :sub:`2`
-      - u\ :sub:`1`
-      - u\ :sub:`0`
-    * .. _MEDIA-BUS-FMT-UYVY8-1X16:
-
-      - MEDIA_BUS_FMT_UYVY8_1X16
-      - 0x200f
       -
       -
       -
@@ -5191,6 +5722,9 @@ the following codes.
       -
       -
       -
+      -
+      - u\ :sub:`9`
+      - u\ :sub:`8`
       - u\ :sub:`7`
       - u\ :sub:`6`
       - u\ :sub:`5`
@@ -5199,14 +5733,6 @@ the following codes.
       - u\ :sub:`2`
       - u\ :sub:`1`
       - u\ :sub:`0`
-      - y\ :sub:`7`
-      - y\ :sub:`6`
-      - y\ :sub:`5`
-      - y\ :sub:`4`
-      - y\ :sub:`3`
-      - y\ :sub:`2`
-      - y\ :sub:`1`
-      - y\ :sub:`0`
     * -
       -
       -
@@ -5226,60 +5752,10 @@ the following codes.
       -
       -
       -
-      - v\ :sub:`7`
-      - v\ :sub:`6`
-      - v\ :sub:`5`
-      - v\ :sub:`4`
-      - v\ :sub:`3`
-      - v\ :sub:`2`
-      - v\ :sub:`1`
-      - v\ :sub:`0`
-      - y\ :sub:`7`
-      - y\ :sub:`6`
-      - y\ :sub:`5`
-      - y\ :sub:`4`
-      - y\ :sub:`3`
-      - y\ :sub:`2`
-      - y\ :sub:`1`
-      - y\ :sub:`0`
-    * .. _MEDIA-BUS-FMT-VYUY8-1X16:
-
-      - MEDIA_BUS_FMT_VYUY8_1X16
-      - 0x2010
-      -
-      -
-      -
-      -
-      -
-      -
-      -
-      -
-      -
-      -
-      -
-      -
-      -
       -
       -
       -
       -
-      - v\ :sub:`7`
-      - v\ :sub:`6`
-      - v\ :sub:`5`
-      - v\ :sub:`4`
-      - v\ :sub:`3`
-      - v\ :sub:`2`
-      - v\ :sub:`1`
-      - v\ :sub:`0`
-      - y\ :sub:`7`
-      - y\ :sub:`6`
-      - y\ :sub:`5`
-      - y\ :sub:`4`
-      - y\ :sub:`3`
-      - y\ :sub:`2`
-      - y\ :sub:`1`
-      - y\ :sub:`0`
-    * -
       -
       -
       -
@@ -5298,14 +5774,8 @@ the following codes.
       -
       -
       -
-      - u\ :sub:`7`
-      - u\ :sub:`6`
-      - u\ :sub:`5`
-      - u\ :sub:`4`
-      - u\ :sub:`3`
-      - u\ :sub:`2`
-      - u\ :sub:`1`
-      - u\ :sub:`0`
+      - y\ :sub:`9`
+      - y\ :sub:`8`
       - y\ :sub:`7`
       - y\ :sub:`6`
       - y\ :sub:`5`
@@ -5314,10 +5784,12 @@ the following codes.
       - y\ :sub:`2`
       - y\ :sub:`1`
       - y\ :sub:`0`
-    * .. _MEDIA-BUS-FMT-YUYV8-1X16:
+    * .. _MEDIA-BUS-FMT-YUYV10-2X10:
 
-      - MEDIA_BUS_FMT_YUYV8_1X16
-      - 0x2011
+      - MEDIA_BUS_FMT_YUYV10_2X10
+      - 0x200b
+      -
+      -
       -
       -
       -
@@ -5335,23 +5807,6 @@ the following codes.
       -
       -
       -
-      - y\ :sub:`7`
-      - y\ :sub:`6`
-      - y\ :sub:`5`
-      - y\ :sub:`4`
-      - y\ :sub:`3`
-      - y\ :sub:`2`
-      - y\ :sub:`1`
-      - y\ :sub:`0`
-      - u\ :sub:`7`
-      - u\ :sub:`6`
-      - u\ :sub:`5`
-      - u\ :sub:`4`
-      - u\ :sub:`3`
-      - u\ :sub:`2`
-      - u\ :sub:`1`
-      - u\ :sub:`0`
-    * -
       -
       -
       -
@@ -5370,6 +5825,10 @@ the following codes.
       -
       -
       -
+      -
+      -
+      - y\ :sub:`9`
+      - y\ :sub:`8`
       - y\ :sub:`7`
       - y\ :sub:`6`
       - y\ :sub:`5`
@@ -5378,18 +5837,7 @@ the following codes.
       - y\ :sub:`2`
       - y\ :sub:`1`
       - y\ :sub:`0`
-      - v\ :sub:`7`
-      - v\ :sub:`6`
-      - v\ :sub:`5`
-      - v\ :sub:`4`
-      - v\ :sub:`3`
-      - v\ :sub:`2`
-      - v\ :sub:`1`
-      - v\ :sub:`0`
-    * .. _MEDIA-BUS-FMT-YVYU8-1X16:
-
-      - MEDIA_BUS_FMT_YVYU8_1X16
-      - 0x2012
+    * -
       -
       -
       -
@@ -5407,23 +5855,6 @@ the following codes.
       -
       -
       -
-      - y\ :sub:`7`
-      - y\ :sub:`6`
-      - y\ :sub:`5`
-      - y\ :sub:`4`
-      - y\ :sub:`3`
-      - y\ :sub:`2`
-      - y\ :sub:`1`
-      - y\ :sub:`0`
-      - v\ :sub:`7`
-      - v\ :sub:`6`
-      - v\ :sub:`5`
-      - v\ :sub:`4`
-      - v\ :sub:`3`
-      - v\ :sub:`2`
-      - v\ :sub:`1`
-      - v\ :sub:`0`
-    * -
       -
       -
       -
@@ -5442,14 +5873,13 @@ the following codes.
       -
       -
       -
-      - y\ :sub:`7`
-      - y\ :sub:`6`
-      - y\ :sub:`5`
-      - y\ :sub:`4`
-      - y\ :sub:`3`
-      - y\ :sub:`2`
-      - y\ :sub:`1`
-      - y\ :sub:`0`
+      -
+      -
+      -
+      -
+      -
+      - u\ :sub:`9`
+      - u\ :sub:`8`
       - u\ :sub:`7`
       - u\ :sub:`6`
       - u\ :sub:`5`
@@ -5458,10 +5888,12 @@ the following codes.
       - u\ :sub:`2`
       - u\ :sub:`1`
       - u\ :sub:`0`
-    * .. _MEDIA-BUS-FMT-YDYUYDYV8-1X16:
-
-      - MEDIA_BUS_FMT_YDYUYDYV8_1X16
-      - 0x2014
+    * -
+      -
+      -
+      -
+      -
+      -
       -
       -
       -
@@ -5479,23 +5911,6 @@ the following codes.
       -
       -
       -
-      - y\ :sub:`7`
-      - y\ :sub:`6`
-      - y\ :sub:`5`
-      - y\ :sub:`4`
-      - y\ :sub:`3`
-      - y\ :sub:`2`
-      - y\ :sub:`1`
-      - y\ :sub:`0`
-      - d
-      - d
-      - d
-      - d
-      - d
-      - d
-      - d
-      - d
-    * -
       -
       -
       -
@@ -5514,6 +5929,8 @@ the following codes.
       -
       -
       -
+      - y\ :sub:`9`
+      - y\ :sub:`8`
       - y\ :sub:`7`
       - y\ :sub:`6`
       - y\ :sub:`5`
@@ -5522,14 +5939,6 @@ the following codes.
       - y\ :sub:`2`
       - y\ :sub:`1`
       - y\ :sub:`0`
-      - u\ :sub:`7`
-      - u\ :sub:`6`
-      - u\ :sub:`5`
-      - u\ :sub:`4`
-      - u\ :sub:`3`
-      - u\ :sub:`2`
-      - u\ :sub:`1`
-      - u\ :sub:`0`
     * -
       -
       -
@@ -5549,23 +5958,6 @@ the following codes.
       -
       -
       -
-      - y\ :sub:`7`
-      - y\ :sub:`6`
-      - y\ :sub:`5`
-      - y\ :sub:`4`
-      - y\ :sub:`3`
-      - y\ :sub:`2`
-      - y\ :sub:`1`
-      - y\ :sub:`0`
-      - d
-      - d
-      - d
-      - d
-      - d
-      - d
-      - d
-      - d
-    * -
       -
       -
       -
@@ -5584,14 +5976,12 @@ the following codes.
       -
       -
       -
-      - y\ :sub:`7`
-      - y\ :sub:`6`
-      - y\ :sub:`5`
-      - y\ :sub:`4`
-      - y\ :sub:`3`
-      - y\ :sub:`2`
-      - y\ :sub:`1`
-      - y\ :sub:`0`
+      -
+      -
+      -
+      -
+      - v\ :sub:`9`
+      - v\ :sub:`8`
       - v\ :sub:`7`
       - v\ :sub:`6`
       - v\ :sub:`5`
@@ -5600,10 +5990,36 @@ the following codes.
       - v\ :sub:`2`
       - v\ :sub:`1`
       - v\ :sub:`0`
-    * .. _MEDIA-BUS-FMT-UYVY10-1X20:
+    * .. _MEDIA-BUS-FMT-YVYU10-2X10:
 
-      - MEDIA_BUS_FMT_UYVY10_1X20
-      - 0x201a
+      - MEDIA_BUS_FMT_YVYU10_2X10
+      - 0x200c
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
       -
       -
       -
@@ -5617,16 +6033,6 @@ the following codes.
       -
       -
       -
-      - u\ :sub:`9`
-      - u\ :sub:`8`
-      - u\ :sub:`7`
-      - u\ :sub:`6`
-      - u\ :sub:`5`
-      - u\ :sub:`4`
-      - u\ :sub:`3`
-      - u\ :sub:`2`
-      - u\ :sub:`1`
-      - u\ :sub:`0`
       - y\ :sub:`9`
       - y\ :sub:`8`
       - y\ :sub:`7`
@@ -5652,16 +6058,2363 @@ the following codes.
       -
       -
       -
-      - v\ :sub:`9`
-      - v\ :sub:`8`
-      - v\ :sub:`7`
-      - v\ :sub:`6`
-      - v\ :sub:`5`
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      - v\ :sub:`9`
+      - v\ :sub:`8`
+      - v\ :sub:`7`
+      - v\ :sub:`6`
+      - v\ :sub:`5`
+      - v\ :sub:`4`
+      - v\ :sub:`3`
+      - v\ :sub:`2`
+      - v\ :sub:`1`
+      - v\ :sub:`0`
+    * -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      - y\ :sub:`9`
+      - y\ :sub:`8`
+      - y\ :sub:`7`
+      - y\ :sub:`6`
+      - y\ :sub:`5`
+      - y\ :sub:`4`
+      - y\ :sub:`3`
+      - y\ :sub:`2`
+      - y\ :sub:`1`
+      - y\ :sub:`0`
+    * -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      - u\ :sub:`9`
+      - u\ :sub:`8`
+      - u\ :sub:`7`
+      - u\ :sub:`6`
+      - u\ :sub:`5`
+      - u\ :sub:`4`
+      - u\ :sub:`3`
+      - u\ :sub:`2`
+      - u\ :sub:`1`
+      - u\ :sub:`0`
+    * .. _MEDIA-BUS-FMT-Y12-1X12:
+
+      - MEDIA_BUS_FMT_Y12_1X12
+      - 0x2013
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      - y\ :sub:`11`
+      - y\ :sub:`10`
+      - y\ :sub:`9`
+      - y\ :sub:`8`
+      - y\ :sub:`7`
+      - y\ :sub:`6`
+      - y\ :sub:`5`
+      - y\ :sub:`4`
+      - y\ :sub:`3`
+      - y\ :sub:`2`
+      - y\ :sub:`1`
+      - y\ :sub:`0`
+    * .. _MEDIA-BUS-FMT-UYVY12-2X12:
+
+      - MEDIA_BUS_FMT_UYVY12_2X12
+      - 0x201c
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      - u\ :sub:`11`
+      - u\ :sub:`10`
+      - u\ :sub:`9`
+      - u\ :sub:`8`
+      - u\ :sub:`7`
+      - u\ :sub:`6`
+      - u\ :sub:`5`
+      - u\ :sub:`4`
+      - u\ :sub:`3`
+      - u\ :sub:`2`
+      - u\ :sub:`1`
+      - u\ :sub:`0`
+    * -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      - y\ :sub:`11`
+      - y\ :sub:`10`
+      - y\ :sub:`9`
+      - y\ :sub:`8`
+      - y\ :sub:`7`
+      - y\ :sub:`6`
+      - y\ :sub:`5`
+      - y\ :sub:`4`
+      - y\ :sub:`3`
+      - y\ :sub:`2`
+      - y\ :sub:`1`
+      - y\ :sub:`0`
+    * -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      - v\ :sub:`11`
+      - v\ :sub:`10`
+      - v\ :sub:`9`
+      - v\ :sub:`8`
+      - v\ :sub:`7`
+      - v\ :sub:`6`
+      - v\ :sub:`5`
+      - v\ :sub:`4`
+      - v\ :sub:`3`
+      - v\ :sub:`2`
+      - v\ :sub:`1`
+      - v\ :sub:`0`
+    * -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      - y\ :sub:`11`
+      - y\ :sub:`10`
+      - y\ :sub:`9`
+      - y\ :sub:`8`
+      - y\ :sub:`7`
+      - y\ :sub:`6`
+      - y\ :sub:`5`
+      - y\ :sub:`4`
+      - y\ :sub:`3`
+      - y\ :sub:`2`
+      - y\ :sub:`1`
+      - y\ :sub:`0`
+    * .. _MEDIA-BUS-FMT-VYUY12-2X12:
+
+      - MEDIA_BUS_FMT_VYUY12_2X12
+      - 0x201d
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      - v\ :sub:`11`
+      - v\ :sub:`10`
+      - v\ :sub:`9`
+      - v\ :sub:`8`
+      - v\ :sub:`7`
+      - v\ :sub:`6`
+      - v\ :sub:`5`
+      - v\ :sub:`4`
+      - v\ :sub:`3`
+      - v\ :sub:`2`
+      - v\ :sub:`1`
+      - v\ :sub:`0`
+    * -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      - y\ :sub:`11`
+      - y\ :sub:`10`
+      - y\ :sub:`9`
+      - y\ :sub:`8`
+      - y\ :sub:`7`
+      - y\ :sub:`6`
+      - y\ :sub:`5`
+      - y\ :sub:`4`
+      - y\ :sub:`3`
+      - y\ :sub:`2`
+      - y\ :sub:`1`
+      - y\ :sub:`0`
+    * -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      - u\ :sub:`11`
+      - u\ :sub:`10`
+      - u\ :sub:`9`
+      - u\ :sub:`8`
+      - u\ :sub:`7`
+      - u\ :sub:`6`
+      - u\ :sub:`5`
+      - u\ :sub:`4`
+      - u\ :sub:`3`
+      - u\ :sub:`2`
+      - u\ :sub:`1`
+      - u\ :sub:`0`
+    * -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      - y\ :sub:`11`
+      - y\ :sub:`10`
+      - y\ :sub:`9`
+      - y\ :sub:`8`
+      - y\ :sub:`7`
+      - y\ :sub:`6`
+      - y\ :sub:`5`
+      - y\ :sub:`4`
+      - y\ :sub:`3`
+      - y\ :sub:`2`
+      - y\ :sub:`1`
+      - y\ :sub:`0`
+    * .. _MEDIA-BUS-FMT-YUYV12-2X12:
+
+      - MEDIA_BUS_FMT_YUYV12_2X12
+      - 0x201e
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      - y\ :sub:`11`
+      - y\ :sub:`10`
+      - y\ :sub:`9`
+      - y\ :sub:`8`
+      - y\ :sub:`7`
+      - y\ :sub:`6`
+      - y\ :sub:`5`
+      - y\ :sub:`4`
+      - y\ :sub:`3`
+      - y\ :sub:`2`
+      - y\ :sub:`1`
+      - y\ :sub:`0`
+    * -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      - u\ :sub:`11`
+      - u\ :sub:`10`
+      - u\ :sub:`9`
+      - u\ :sub:`8`
+      - u\ :sub:`7`
+      - u\ :sub:`6`
+      - u\ :sub:`5`
+      - u\ :sub:`4`
+      - u\ :sub:`3`
+      - u\ :sub:`2`
+      - u\ :sub:`1`
+      - u\ :sub:`0`
+    * -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      - y\ :sub:`11`
+      - y\ :sub:`10`
+      - y\ :sub:`9`
+      - y\ :sub:`8`
+      - y\ :sub:`7`
+      - y\ :sub:`6`
+      - y\ :sub:`5`
+      - y\ :sub:`4`
+      - y\ :sub:`3`
+      - y\ :sub:`2`
+      - y\ :sub:`1`
+      - y\ :sub:`0`
+    * -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      - v\ :sub:`11`
+      - v\ :sub:`10`
+      - v\ :sub:`9`
+      - v\ :sub:`8`
+      - v\ :sub:`7`
+      - v\ :sub:`6`
+      - v\ :sub:`5`
+      - v\ :sub:`4`
+      - v\ :sub:`3`
+      - v\ :sub:`2`
+      - v\ :sub:`1`
+      - v\ :sub:`0`
+    * .. _MEDIA-BUS-FMT-YVYU12-2X12:
+
+      - MEDIA_BUS_FMT_YVYU12_2X12
+      - 0x201f
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      - y\ :sub:`11`
+      - y\ :sub:`10`
+      - y\ :sub:`9`
+      - y\ :sub:`8`
+      - y\ :sub:`7`
+      - y\ :sub:`6`
+      - y\ :sub:`5`
+      - y\ :sub:`4`
+      - y\ :sub:`3`
+      - y\ :sub:`2`
+      - y\ :sub:`1`
+      - y\ :sub:`0`
+    * -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      - v\ :sub:`11`
+      - v\ :sub:`10`
+      - v\ :sub:`9`
+      - v\ :sub:`8`
+      - v\ :sub:`7`
+      - v\ :sub:`6`
+      - v\ :sub:`5`
+      - v\ :sub:`4`
+      - v\ :sub:`3`
+      - v\ :sub:`2`
+      - v\ :sub:`1`
+      - v\ :sub:`0`
+    * -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      - y\ :sub:`11`
+      - y\ :sub:`10`
+      - y\ :sub:`9`
+      - y\ :sub:`8`
+      - y\ :sub:`7`
+      - y\ :sub:`6`
+      - y\ :sub:`5`
+      - y\ :sub:`4`
+      - y\ :sub:`3`
+      - y\ :sub:`2`
+      - y\ :sub:`1`
+      - y\ :sub:`0`
+    * -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      - u\ :sub:`11`
+      - u\ :sub:`10`
+      - u\ :sub:`9`
+      - u\ :sub:`8`
+      - u\ :sub:`7`
+      - u\ :sub:`6`
+      - u\ :sub:`5`
+      - u\ :sub:`4`
+      - u\ :sub:`3`
+      - u\ :sub:`2`
+      - u\ :sub:`1`
+      - u\ :sub:`0`
+    * .. _MEDIA-BUS-FMT-UYVY8-1X16:
+
+      - MEDIA_BUS_FMT_UYVY8_1X16
+      - 0x200f
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      - u\ :sub:`7`
+      - u\ :sub:`6`
+      - u\ :sub:`5`
+      - u\ :sub:`4`
+      - u\ :sub:`3`
+      - u\ :sub:`2`
+      - u\ :sub:`1`
+      - u\ :sub:`0`
+      - y\ :sub:`7`
+      - y\ :sub:`6`
+      - y\ :sub:`5`
+      - y\ :sub:`4`
+      - y\ :sub:`3`
+      - y\ :sub:`2`
+      - y\ :sub:`1`
+      - y\ :sub:`0`
+    * -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      - v\ :sub:`7`
+      - v\ :sub:`6`
+      - v\ :sub:`5`
+      - v\ :sub:`4`
+      - v\ :sub:`3`
+      - v\ :sub:`2`
+      - v\ :sub:`1`
+      - v\ :sub:`0`
+      - y\ :sub:`7`
+      - y\ :sub:`6`
+      - y\ :sub:`5`
+      - y\ :sub:`4`
+      - y\ :sub:`3`
+      - y\ :sub:`2`
+      - y\ :sub:`1`
+      - y\ :sub:`0`
+    * .. _MEDIA-BUS-FMT-VYUY8-1X16:
+
+      - MEDIA_BUS_FMT_VYUY8_1X16
+      - 0x2010
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      - v\ :sub:`7`
+      - v\ :sub:`6`
+      - v\ :sub:`5`
+      - v\ :sub:`4`
+      - v\ :sub:`3`
+      - v\ :sub:`2`
+      - v\ :sub:`1`
+      - v\ :sub:`0`
+      - y\ :sub:`7`
+      - y\ :sub:`6`
+      - y\ :sub:`5`
+      - y\ :sub:`4`
+      - y\ :sub:`3`
+      - y\ :sub:`2`
+      - y\ :sub:`1`
+      - y\ :sub:`0`
+    * -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      - u\ :sub:`7`
+      - u\ :sub:`6`
+      - u\ :sub:`5`
+      - u\ :sub:`4`
+      - u\ :sub:`3`
+      - u\ :sub:`2`
+      - u\ :sub:`1`
+      - u\ :sub:`0`
+      - y\ :sub:`7`
+      - y\ :sub:`6`
+      - y\ :sub:`5`
+      - y\ :sub:`4`
+      - y\ :sub:`3`
+      - y\ :sub:`2`
+      - y\ :sub:`1`
+      - y\ :sub:`0`
+    * .. _MEDIA-BUS-FMT-YUYV8-1X16:
+
+      - MEDIA_BUS_FMT_YUYV8_1X16
+      - 0x2011
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      - y\ :sub:`7`
+      - y\ :sub:`6`
+      - y\ :sub:`5`
+      - y\ :sub:`4`
+      - y\ :sub:`3`
+      - y\ :sub:`2`
+      - y\ :sub:`1`
+      - y\ :sub:`0`
+      - u\ :sub:`7`
+      - u\ :sub:`6`
+      - u\ :sub:`5`
+      - u\ :sub:`4`
+      - u\ :sub:`3`
+      - u\ :sub:`2`
+      - u\ :sub:`1`
+      - u\ :sub:`0`
+    * -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      - y\ :sub:`7`
+      - y\ :sub:`6`
+      - y\ :sub:`5`
+      - y\ :sub:`4`
+      - y\ :sub:`3`
+      - y\ :sub:`2`
+      - y\ :sub:`1`
+      - y\ :sub:`0`
+      - v\ :sub:`7`
+      - v\ :sub:`6`
+      - v\ :sub:`5`
+      - v\ :sub:`4`
+      - v\ :sub:`3`
+      - v\ :sub:`2`
+      - v\ :sub:`1`
+      - v\ :sub:`0`
+    * .. _MEDIA-BUS-FMT-YVYU8-1X16:
+
+      - MEDIA_BUS_FMT_YVYU8_1X16
+      - 0x2012
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      - y\ :sub:`7`
+      - y\ :sub:`6`
+      - y\ :sub:`5`
+      - y\ :sub:`4`
+      - y\ :sub:`3`
+      - y\ :sub:`2`
+      - y\ :sub:`1`
+      - y\ :sub:`0`
+      - v\ :sub:`7`
+      - v\ :sub:`6`
+      - v\ :sub:`5`
+      - v\ :sub:`4`
+      - v\ :sub:`3`
+      - v\ :sub:`2`
+      - v\ :sub:`1`
+      - v\ :sub:`0`
+    * -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      - y\ :sub:`7`
+      - y\ :sub:`6`
+      - y\ :sub:`5`
+      - y\ :sub:`4`
+      - y\ :sub:`3`
+      - y\ :sub:`2`
+      - y\ :sub:`1`
+      - y\ :sub:`0`
+      - u\ :sub:`7`
+      - u\ :sub:`6`
+      - u\ :sub:`5`
+      - u\ :sub:`4`
+      - u\ :sub:`3`
+      - u\ :sub:`2`
+      - u\ :sub:`1`
+      - u\ :sub:`0`
+    * .. _MEDIA-BUS-FMT-YDYUYDYV8-1X16:
+
+      - MEDIA_BUS_FMT_YDYUYDYV8_1X16
+      - 0x2014
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      - y\ :sub:`7`
+      - y\ :sub:`6`
+      - y\ :sub:`5`
+      - y\ :sub:`4`
+      - y\ :sub:`3`
+      - y\ :sub:`2`
+      - y\ :sub:`1`
+      - y\ :sub:`0`
+      - d
+      - d
+      - d
+      - d
+      - d
+      - d
+      - d
+      - d
+    * -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      - y\ :sub:`7`
+      - y\ :sub:`6`
+      - y\ :sub:`5`
+      - y\ :sub:`4`
+      - y\ :sub:`3`
+      - y\ :sub:`2`
+      - y\ :sub:`1`
+      - y\ :sub:`0`
+      - u\ :sub:`7`
+      - u\ :sub:`6`
+      - u\ :sub:`5`
+      - u\ :sub:`4`
+      - u\ :sub:`3`
+      - u\ :sub:`2`
+      - u\ :sub:`1`
+      - u\ :sub:`0`
+    * -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      - y\ :sub:`7`
+      - y\ :sub:`6`
+      - y\ :sub:`5`
+      - y\ :sub:`4`
+      - y\ :sub:`3`
+      - y\ :sub:`2`
+      - y\ :sub:`1`
+      - y\ :sub:`0`
+      - d
+      - d
+      - d
+      - d
+      - d
+      - d
+      - d
+      - d
+    * -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      - y\ :sub:`7`
+      - y\ :sub:`6`
+      - y\ :sub:`5`
+      - y\ :sub:`4`
+      - y\ :sub:`3`
+      - y\ :sub:`2`
+      - y\ :sub:`1`
+      - y\ :sub:`0`
+      - v\ :sub:`7`
+      - v\ :sub:`6`
+      - v\ :sub:`5`
+      - v\ :sub:`4`
+      - v\ :sub:`3`
+      - v\ :sub:`2`
+      - v\ :sub:`1`
+      - v\ :sub:`0`
+    * .. _MEDIA-BUS-FMT-UYVY10-1X20:
+
+      - MEDIA_BUS_FMT_UYVY10_1X20
+      - 0x201a
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      - u\ :sub:`9`
+      - u\ :sub:`8`
+      - u\ :sub:`7`
+      - u\ :sub:`6`
+      - u\ :sub:`5`
+      - u\ :sub:`4`
+      - u\ :sub:`3`
+      - u\ :sub:`2`
+      - u\ :sub:`1`
+      - u\ :sub:`0`
+      - y\ :sub:`9`
+      - y\ :sub:`8`
+      - y\ :sub:`7`
+      - y\ :sub:`6`
+      - y\ :sub:`5`
+      - y\ :sub:`4`
+      - y\ :sub:`3`
+      - y\ :sub:`2`
+      - y\ :sub:`1`
+      - y\ :sub:`0`
+    * -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      - v\ :sub:`9`
+      - v\ :sub:`8`
+      - v\ :sub:`7`
+      - v\ :sub:`6`
+      - v\ :sub:`5`
+      - v\ :sub:`4`
+      - v\ :sub:`3`
+      - v\ :sub:`2`
+      - v\ :sub:`1`
+      - v\ :sub:`0`
+      - y\ :sub:`9`
+      - y\ :sub:`8`
+      - y\ :sub:`7`
+      - y\ :sub:`6`
+      - y\ :sub:`5`
+      - y\ :sub:`4`
+      - y\ :sub:`3`
+      - y\ :sub:`2`
+      - y\ :sub:`1`
+      - y\ :sub:`0`
+    * .. _MEDIA-BUS-FMT-VYUY10-1X20:
+
+      - MEDIA_BUS_FMT_VYUY10_1X20
+      - 0x201b
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      - v\ :sub:`9`
+      - v\ :sub:`8`
+      - v\ :sub:`7`
+      - v\ :sub:`6`
+      - v\ :sub:`5`
+      - v\ :sub:`4`
+      - v\ :sub:`3`
+      - v\ :sub:`2`
+      - v\ :sub:`1`
+      - v\ :sub:`0`
+      - y\ :sub:`9`
+      - y\ :sub:`8`
+      - y\ :sub:`7`
+      - y\ :sub:`6`
+      - y\ :sub:`5`
+      - y\ :sub:`4`
+      - y\ :sub:`3`
+      - y\ :sub:`2`
+      - y\ :sub:`1`
+      - y\ :sub:`0`
+    * -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      - u\ :sub:`9`
+      - u\ :sub:`8`
+      - u\ :sub:`7`
+      - u\ :sub:`6`
+      - u\ :sub:`5`
+      - u\ :sub:`4`
+      - u\ :sub:`3`
+      - u\ :sub:`2`
+      - u\ :sub:`1`
+      - u\ :sub:`0`
+      - y\ :sub:`9`
+      - y\ :sub:`8`
+      - y\ :sub:`7`
+      - y\ :sub:`6`
+      - y\ :sub:`5`
+      - y\ :sub:`4`
+      - y\ :sub:`3`
+      - y\ :sub:`2`
+      - y\ :sub:`1`
+      - y\ :sub:`0`
+    * .. _MEDIA-BUS-FMT-YUYV10-1X20:
+
+      - MEDIA_BUS_FMT_YUYV10_1X20
+      - 0x200d
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      - y\ :sub:`9`
+      - y\ :sub:`8`
+      - y\ :sub:`7`
+      - y\ :sub:`6`
+      - y\ :sub:`5`
+      - y\ :sub:`4`
+      - y\ :sub:`3`
+      - y\ :sub:`2`
+      - y\ :sub:`1`
+      - y\ :sub:`0`
+      - u\ :sub:`9`
+      - u\ :sub:`8`
+      - u\ :sub:`7`
+      - u\ :sub:`6`
+      - u\ :sub:`5`
+      - u\ :sub:`4`
+      - u\ :sub:`3`
+      - u\ :sub:`2`
+      - u\ :sub:`1`
+      - u\ :sub:`0`
+    * -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      - y\ :sub:`9`
+      - y\ :sub:`8`
+      - y\ :sub:`7`
+      - y\ :sub:`6`
+      - y\ :sub:`5`
+      - y\ :sub:`4`
+      - y\ :sub:`3`
+      - y\ :sub:`2`
+      - y\ :sub:`1`
+      - y\ :sub:`0`
+      - v\ :sub:`9`
+      - v\ :sub:`8`
+      - v\ :sub:`7`
+      - v\ :sub:`6`
+      - v\ :sub:`5`
+      - v\ :sub:`4`
+      - v\ :sub:`3`
+      - v\ :sub:`2`
+      - v\ :sub:`1`
+      - v\ :sub:`0`
+    * .. _MEDIA-BUS-FMT-YVYU10-1X20:
+
+      - MEDIA_BUS_FMT_YVYU10_1X20
+      - 0x200e
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      - y\ :sub:`9`
+      - y\ :sub:`8`
+      - y\ :sub:`7`
+      - y\ :sub:`6`
+      - y\ :sub:`5`
+      - y\ :sub:`4`
+      - y\ :sub:`3`
+      - y\ :sub:`2`
+      - y\ :sub:`1`
+      - y\ :sub:`0`
+      - v\ :sub:`9`
+      - v\ :sub:`8`
+      - v\ :sub:`7`
+      - v\ :sub:`6`
+      - v\ :sub:`5`
+      - v\ :sub:`4`
+      - v\ :sub:`3`
+      - v\ :sub:`2`
+      - v\ :sub:`1`
+      - v\ :sub:`0`
+    * -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      - y\ :sub:`9`
+      - y\ :sub:`8`
+      - y\ :sub:`7`
+      - y\ :sub:`6`
+      - y\ :sub:`5`
+      - y\ :sub:`4`
+      - y\ :sub:`3`
+      - y\ :sub:`2`
+      - y\ :sub:`1`
+      - y\ :sub:`0`
+      - u\ :sub:`9`
+      - u\ :sub:`8`
+      - u\ :sub:`7`
+      - u\ :sub:`6`
+      - u\ :sub:`5`
+      - u\ :sub:`4`
+      - u\ :sub:`3`
+      - u\ :sub:`2`
+      - u\ :sub:`1`
+      - u\ :sub:`0`
+    * .. _MEDIA-BUS-FMT-VUY8-1X24:
+
+      - MEDIA_BUS_FMT_VUY8_1X24
+      - 0x201a
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      - v\ :sub:`7`
+      - v\ :sub:`6`
+      - v\ :sub:`5`
+      - v\ :sub:`4`
+      - v\ :sub:`3`
+      - v\ :sub:`2`
+      - v\ :sub:`1`
+      - v\ :sub:`0`
+      - u\ :sub:`7`
+      - u\ :sub:`6`
+      - u\ :sub:`5`
+      - u\ :sub:`4`
+      - u\ :sub:`3`
+      - u\ :sub:`2`
+      - u\ :sub:`1`
+      - u\ :sub:`0`
+      - y\ :sub:`7`
+      - y\ :sub:`6`
+      - y\ :sub:`5`
+      - y\ :sub:`4`
+      - y\ :sub:`3`
+      - y\ :sub:`2`
+      - y\ :sub:`1`
+      - y\ :sub:`0`
+    * .. _MEDIA-BUS-FMT-YUV8-1X24:
+
+      - MEDIA_BUS_FMT_YUV8_1X24
+      - 0x2025
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      - y\ :sub:`7`
+      - y\ :sub:`6`
+      - y\ :sub:`5`
+      - y\ :sub:`4`
+      - y\ :sub:`3`
+      - y\ :sub:`2`
+      - y\ :sub:`1`
+      - y\ :sub:`0`
+      - u\ :sub:`7`
+      - u\ :sub:`6`
+      - u\ :sub:`5`
+      - u\ :sub:`4`
+      - u\ :sub:`3`
+      - u\ :sub:`2`
+      - u\ :sub:`1`
+      - u\ :sub:`0`
+      - v\ :sub:`7`
+      - v\ :sub:`6`
+      - v\ :sub:`5`
+      - v\ :sub:`4`
+      - v\ :sub:`3`
+      - v\ :sub:`2`
+      - v\ :sub:`1`
+      - v\ :sub:`0`
+    * .. _MEDIA-BUS-FMT-UYVY8-1-1X24:
+
+      - MEDIA_BUS_FMT_UYVY8_1_1X24
+      - 0x2026
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      - u\ :sub:`7`
+      - u\ :sub:`6`
+      - u\ :sub:`5`
+      - u\ :sub:`4`
+      - u\ :sub:`3`
+      - u\ :sub:`2`
+      - u\ :sub:`1`
+      - u\ :sub:`0`
+      - y\ :sub:`7`
+      - y\ :sub:`6`
+      - y\ :sub:`5`
+      - y\ :sub:`4`
+      - y\ :sub:`3`
+      - y\ :sub:`2`
+      - y\ :sub:`1`
+      - y\ :sub:`0`
+      - y\ :sub:`7`
+      - y\ :sub:`6`
+      - y\ :sub:`5`
+      - y\ :sub:`4`
+      - y\ :sub:`3`
+      - y\ :sub:`2`
+      - y\ :sub:`1`
+      - y\ :sub:`0`
+    * -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      - v\ :sub:`7`
+      - v\ :sub:`6`
+      - v\ :sub:`5`
+      - v\ :sub:`4`
+      - v\ :sub:`3`
+      - v\ :sub:`2`
+      - v\ :sub:`1`
+      - v\ :sub:`0`
+      - y\ :sub:`7`
+      - y\ :sub:`6`
+      - y\ :sub:`5`
+      - y\ :sub:`4`
+      - y\ :sub:`3`
+      - y\ :sub:`2`
+      - y\ :sub:`1`
+      - y\ :sub:`0`
+      - y\ :sub:`7`
+      - y\ :sub:`6`
+      - y\ :sub:`5`
+      - y\ :sub:`4`
+      - y\ :sub:`3`
+      - y\ :sub:`2`
+      - y\ :sub:`1`
+      - y\ :sub:`0`
+    * .. _MEDIA-BUS-FMT-UYVY12-1X24:
+
+      - MEDIA_BUS_FMT_UYVY12_1X24
+      - 0x2020
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      - u\ :sub:`11`
+      - u\ :sub:`10`
+      - u\ :sub:`9`
+      - u\ :sub:`8`
+      - u\ :sub:`7`
+      - u\ :sub:`6`
+      - u\ :sub:`5`
+      - u\ :sub:`4`
+      - u\ :sub:`3`
+      - u\ :sub:`2`
+      - u\ :sub:`1`
+      - u\ :sub:`0`
+      - y\ :sub:`11`
+      - y\ :sub:`10`
+      - y\ :sub:`9`
+      - y\ :sub:`8`
+      - y\ :sub:`7`
+      - y\ :sub:`6`
+      - y\ :sub:`5`
+      - y\ :sub:`4`
+      - y\ :sub:`3`
+      - y\ :sub:`2`
+      - y\ :sub:`1`
+      - y\ :sub:`0`
+    * -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      - v\ :sub:`11`
+      - v\ :sub:`10`
+      - v\ :sub:`9`
+      - v\ :sub:`8`
+      - v\ :sub:`7`
+      - v\ :sub:`6`
+      - v\ :sub:`5`
       - v\ :sub:`4`
       - v\ :sub:`3`
       - v\ :sub:`2`
       - v\ :sub:`1`
       - v\ :sub:`0`
+      - y\ :sub:`11`
+      - y\ :sub:`10`
       - y\ :sub:`9`
       - y\ :sub:`8`
       - y\ :sub:`7`
@@ -5672,10 +8425,14 @@ the following codes.
       - y\ :sub:`2`
       - y\ :sub:`1`
       - y\ :sub:`0`
-    * .. _MEDIA-BUS-FMT-VYUY10-1X20:
+    * .. _MEDIA-BUS-FMT-VYUY12-1X24:
 
-      - MEDIA_BUS_FMT_VYUY10_1X20
-      - 0x201b
+      - MEDIA_BUS_FMT_VYUY12_1X24
+      - 0x2021
+      -
+      -
+      -
+      -
       -
       -
       -
@@ -5689,6 +8446,16 @@ the following codes.
       -
       -
       -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      - v\ :sub:`11`
+      - v\ :sub:`10`
       - v\ :sub:`9`
       - v\ :sub:`8`
       - v\ :sub:`7`
@@ -5699,6 +8466,8 @@ the following codes.
       - v\ :sub:`2`
       - v\ :sub:`1`
       - v\ :sub:`0`
+      - y\ :sub:`11`
+      - y\ :sub:`10`
       - y\ :sub:`9`
       - y\ :sub:`8`
       - y\ :sub:`7`
@@ -5724,6 +8493,20 @@ the following codes.
       -
       -
       -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      - u\ :sub:`11`
+      - u\ :sub:`10`
       - u\ :sub:`9`
       - u\ :sub:`8`
       - u\ :sub:`7`
@@ -5734,6 +8517,8 @@ the following codes.
       - u\ :sub:`2`
       - u\ :sub:`1`
       - u\ :sub:`0`
+      - y\ :sub:`11`
+      - y\ :sub:`10`
       - y\ :sub:`9`
       - y\ :sub:`8`
       - y\ :sub:`7`
@@ -5744,10 +8529,16 @@ the following codes.
       - y\ :sub:`2`
       - y\ :sub:`1`
       - y\ :sub:`0`
-    * .. _MEDIA-BUS-FMT-YUYV10-1X20:
+    * .. _MEDIA-BUS-FMT-YUYV12-1X24:
 
-      - MEDIA_BUS_FMT_YUYV10_1X20
-      - 0x200d
+      - MEDIA_BUS_FMT_YUYV12_1X24
+      - 0x2022
+      -
+      -
+      -
+      -
+      -
+      -
       -
       -
       -
@@ -5761,6 +8552,14 @@ the following codes.
       -
       -
       -
+      -
+      -
+      -
+      -
+      -
+      -
+      - y\ :sub:`11`
+      - y\ :sub:`10`
       - y\ :sub:`9`
       - y\ :sub:`8`
       - y\ :sub:`7`
@@ -5771,6 +8570,8 @@ the following codes.
       - y\ :sub:`2`
       - y\ :sub:`1`
       - y\ :sub:`0`
+      - u\ :sub:`11`
+      - u\ :sub:`10`
       - u\ :sub:`9`
       - u\ :sub:`8`
       - u\ :sub:`7`
@@ -5796,6 +8597,20 @@ the following codes.
       -
       -
       -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      - y\ :sub:`11`
+      - y\ :sub:`10`
       - y\ :sub:`9`
       - y\ :sub:`8`
       - y\ :sub:`7`
@@ -5806,6 +8621,8 @@ the following codes.
       - y\ :sub:`2`
       - y\ :sub:`1`
       - y\ :sub:`0`
+      - v\ :sub:`11`
+      - v\ :sub:`10`
       - v\ :sub:`9`
       - v\ :sub:`8`
       - v\ :sub:`7`
@@ -5816,10 +8633,18 @@ the following codes.
       - v\ :sub:`2`
       - v\ :sub:`1`
       - v\ :sub:`0`
-    * .. _MEDIA-BUS-FMT-YVYU10-1X20:
+    * .. _MEDIA-BUS-FMT-YVYU12-1X24:
 
-      - MEDIA_BUS_FMT_YVYU10_1X20
-      - 0x200e
+      - MEDIA_BUS_FMT_YVYU12_1X24
+      - 0x2023
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
       -
       -
       -
@@ -5833,6 +8658,12 @@ the following codes.
       -
       -
       -
+      -
+      -
+      -
+      -
+      - y\ :sub:`11`
+      - y\ :sub:`10`
       - y\ :sub:`9`
       - y\ :sub:`8`
       - y\ :sub:`7`
@@ -5843,6 +8674,8 @@ the following codes.
       - y\ :sub:`2`
       - y\ :sub:`1`
       - y\ :sub:`0`
+      - v\ :sub:`11`
+      - v\ :sub:`10`
       - v\ :sub:`9`
       - v\ :sub:`8`
       - v\ :sub:`7`
@@ -5868,6 +8701,20 @@ the following codes.
       -
       -
       -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      - y\ :sub:`11`
+      - y\ :sub:`10`
       - y\ :sub:`9`
       - y\ :sub:`8`
       - y\ :sub:`7`
@@ -5878,6 +8725,8 @@ the following codes.
       - y\ :sub:`2`
       - y\ :sub:`1`
       - y\ :sub:`0`
+      - u\ :sub:`11`
+      - u\ :sub:`10`
       - u\ :sub:`9`
       - u\ :sub:`8`
       - u\ :sub:`7`
@@ -5888,10 +8737,12 @@ the following codes.
       - u\ :sub:`2`
       - u\ :sub:`1`
       - u\ :sub:`0`
-    * .. _MEDIA-BUS-FMT-VUY8-1X24:
+    * .. _MEDIA-BUS-FMT-YUV10-1X30:
 
-      - MEDIA_BUS_FMT_VUY8_1X24
-      - 0x201a
+      - MEDIA_BUS_FMT_YUV10_1X30
+      - 0x2016
+      -
+      -
       -
       -
       -
@@ -5901,6 +8752,36 @@ the following codes.
       -
       -
       -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      - y\ :sub:`9`
+      - y\ :sub:`8`
+      - y\ :sub:`7`
+      - y\ :sub:`6`
+      - y\ :sub:`5`
+      - y\ :sub:`4`
+      - y\ :sub:`3`
+      - y\ :sub:`2`
+      - y\ :sub:`1`
+      - y\ :sub:`0`
+      - u\ :sub:`9`
+      - u\ :sub:`8`
+      - u\ :sub:`7`
+      - u\ :sub:`6`
+      - u\ :sub:`5`
+      - u\ :sub:`4`
+      - u\ :sub:`3`
+      - u\ :sub:`2`
+      - u\ :sub:`1`
+      - u\ :sub:`0`
+      - v\ :sub:`9`
+      - v\ :sub:`8`
       - v\ :sub:`7`
       - v\ :sub:`6`
       - v\ :sub:`5`
@@ -5909,6 +8790,31 @@ the following codes.
       - v\ :sub:`2`
       - v\ :sub:`1`
       - v\ :sub:`0`
+    * .. _MEDIA-BUS-FMT-UYVY10-1-1X30:
+
+      - MEDIA_BUS_FMT_UYVY10_1_1X30
+      - 0x2027
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      - u\ :sub:`9`
+      - u\ :sub:`8`
       - u\ :sub:`7`
       - u\ :sub:`6`
       - u\ :sub:`5`
@@ -5917,6 +8823,69 @@ the following codes.
       - u\ :sub:`2`
       - u\ :sub:`1`
       - u\ :sub:`0`
+      - y\ :sub:`9`
+      - y\ :sub:`8`
+      - y\ :sub:`7`
+      - y\ :sub:`6`
+      - y\ :sub:`5`
+      - y\ :sub:`4`
+      - y\ :sub:`3`
+      - y\ :sub:`2`
+      - y\ :sub:`1`
+      - y\ :sub:`0`
+      - y\ :sub:`9`
+      - y\ :sub:`8`
+      - y\ :sub:`7`
+      - y\ :sub:`6`
+      - y\ :sub:`5`
+      - y\ :sub:`4`
+      - y\ :sub:`3`
+      - y\ :sub:`2`
+      - y\ :sub:`1`
+      - y\ :sub:`0`
+    * -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      -
+      - v\ :sub:`9`
+      - v\ :sub:`8`
+      - v\ :sub:`7`
+      - v\ :sub:`6`
+      - v\ :sub:`5`
+      - v\ :sub:`4`
+      - v\ :sub:`3`
+      - v\ :sub:`2`
+      - v\ :sub:`1`
+      - v\ :sub:`0`
+      - y\ :sub:`9`
+      - y\ :sub:`8`
+      - y\ :sub:`7`
+      - y\ :sub:`6`
+      - y\ :sub:`5`
+      - y\ :sub:`4`
+      - y\ :sub:`3`
+      - y\ :sub:`2`
+      - y\ :sub:`1`
+      - y\ :sub:`0`
+      - y\ :sub:`9`
+      - y\ :sub:`8`
       - y\ :sub:`7`
       - y\ :sub:`6`
       - y\ :sub:`5`
@@ -5925,10 +8894,17 @@ the following codes.
       - y\ :sub:`2`
       - y\ :sub:`1`
       - y\ :sub:`0`
-    * .. _MEDIA-BUS-FMT-YUV8-1X24:
+    * .. _MEDIA-BUS-FMT-AYUV8-1X32:
 
-      - MEDIA_BUS_FMT_YUV8_1X24
-      - 0x2025
+      - MEDIA_BUS_FMT_AYUV8_1X32
+      - 0x2017
+      -
+      -
+      -
+      -
+      -
+      -
+      -
       -
       -
       -
@@ -5938,6 +8914,15 @@ the following codes.
       -
       -
       -
+      -
+      - a\ :sub:`7`
+      - a\ :sub:`6`
+      - a\ :sub:`5`
+      - a\ :sub:`4`
+      - a\ :sub:`3`
+      - a\ :sub:`2`
+      - a\ :sub:`1`
+      - a\ :sub:`0`
       - y\ :sub:`7`
       - y\ :sub:`6`
       - y\ :sub:`5`
@@ -5962,10 +8947,14 @@ the following codes.
       - v\ :sub:`2`
       - v\ :sub:`1`
       - v\ :sub:`0`
-    * .. _MEDIA-BUS-FMT-UYVY12-1X24:
+    * .. _MEDIA-BUS-FMT-UYVY12-1-1X36:
 
-      - MEDIA_BUS_FMT_UYVY12_1X24
-      - 0x2020
+      - MEDIA_BUS_FMT_UYVY12_1_1X36
+      - 0x2028
+      -
+      -
+      -
+      -
       -
       -
       -
@@ -5999,32 +8988,9 @@ the following codes.
       - y\ :sub:`2`
       - y\ :sub:`1`
       - y\ :sub:`0`
-    * -
-      -
-      -
-      -
-      -
-      -
-      -
-      -
-      -
-      -
-      -
-      - v\ :sub:`11`
-      - v\ :sub:`10`
-      - v\ :sub:`9`
-      - v\ :sub:`8`
-      - v\ :sub:`7`
-      - v\ :sub:`6`
-      - v\ :sub:`5`
-      - v\ :sub:`4`
-      - v\ :sub:`3`
-      - v\ :sub:`2`
-      - v\ :sub:`1`
-      - v\ :sub:`0`
       - y\ :sub:`11`
       - y\ :sub:`10`
-      - y\ :sub:`9`
+      - y\ :sub:`8`
       - y\ :sub:`8`
       - y\ :sub:`7`
       - y\ :sub:`6`
@@ -6034,10 +9000,12 @@ the following codes.
       - y\ :sub:`2`
       - y\ :sub:`1`
       - y\ :sub:`0`
-    * .. _MEDIA-BUS-FMT-VYUY12-1X24:
-
-      - MEDIA_BUS_FMT_VYUY12_1X24
-      - 0x2021
+    * -
+      -
+      -
+      -
+      -
+      -
       -
       -
       -
@@ -6071,32 +9039,9 @@ the following codes.
       - y\ :sub:`2`
       - y\ :sub:`1`
       - y\ :sub:`0`
-    * -
-      -
-      -
-      -
-      -
-      -
-      -
-      -
-      -
-      -
-      -
-      - u\ :sub:`11`
-      - u\ :sub:`10`
-      - u\ :sub:`9`
-      - u\ :sub:`8`
-      - u\ :sub:`7`
-      - u\ :sub:`6`
-      - u\ :sub:`5`
-      - u\ :sub:`4`
-      - u\ :sub:`3`
-      - u\ :sub:`2`
-      - u\ :sub:`1`
-      - u\ :sub:`0`
       - y\ :sub:`11`
       - y\ :sub:`10`
-      - y\ :sub:`9`
+      - y\ :sub:`8`
       - y\ :sub:`8`
       - y\ :sub:`7`
       - y\ :sub:`6`
@@ -6106,10 +9051,14 @@ the following codes.
       - y\ :sub:`2`
       - y\ :sub:`1`
       - y\ :sub:`0`
-    * .. _MEDIA-BUS-FMT-YUYV12-1X24:
+    * .. _MEDIA-BUS-FMT-YUV12-1X36:
 
-      - MEDIA_BUS_FMT_YUYV12_1X24
-      - 0x2022
+      - MEDIA_BUS_FMT_YUV12_1X36
+      - 0x2029
+      -
+      -
+      -
+      -
       -
       -
       -
@@ -6121,7 +9070,7 @@ the following codes.
       -
       - y\ :sub:`11`
       - y\ :sub:`10`
-      - y\ :sub:`9`
+      - y\ :sub:`8`
       - y\ :sub:`8`
       - y\ :sub:`7`
       - y\ :sub:`6`
@@ -6131,6 +9080,7 @@ the following codes.
       - y\ :sub:`2`
       - y\ :sub:`1`
       - y\ :sub:`0`
+      - v\ :sub:`11`
       - u\ :sub:`11`
       - u\ :sub:`10`
       - u\ :sub:`9`
@@ -6143,30 +9093,6 @@ the following codes.
       - u\ :sub:`2`
       - u\ :sub:`1`
       - u\ :sub:`0`
-    * -
-      -
-      -
-      -
-      -
-      -
-      -
-      -
-      -
-      -
-      -
-      - y\ :sub:`11`
-      - y\ :sub:`10`
-      - y\ :sub:`9`
-      - y\ :sub:`8`
-      - y\ :sub:`7`
-      - y\ :sub:`6`
-      - y\ :sub:`5`
-      - y\ :sub:`4`
-      - y\ :sub:`3`
-      - y\ :sub:`2`
-      - y\ :sub:`1`
-      - y\ :sub:`0`
-      - v\ :sub:`11`
       - v\ :sub:`10`
       - v\ :sub:`9`
       - v\ :sub:`8`
@@ -6178,22 +9104,17 @@ the following codes.
       - v\ :sub:`2`
       - v\ :sub:`1`
       - v\ :sub:`0`
-    * .. _MEDIA-BUS-FMT-YVYU12-1X24:
-
-      - MEDIA_BUS_FMT_YVYU12_1X24
-      - 0x2023
-      -
-      -
-      -
-      -
-      -
-      -
-      -
-      -
-      -
+    * .. _MEDIA-BUS-FMT-YUV16-1X48:
+
+      - MEDIA_BUS_FMT_YUV16_1X48
+      - 0x202a
+      - y\ :sub:`15`
+      - y\ :sub:`14`
+      - y\ :sub:`13`
+      - y\ :sub:`12`
       - y\ :sub:`11`
       - y\ :sub:`10`
-      - y\ :sub:`9`
+      - y\ :sub:`8`
       - y\ :sub:`8`
       - y\ :sub:`7`
       - y\ :sub:`6`
@@ -6203,6 +9124,26 @@ the following codes.
       - y\ :sub:`2`
       - y\ :sub:`1`
       - y\ :sub:`0`
+      - u\ :sub:`15`
+      - u\ :sub:`14`
+      - u\ :sub:`13`
+      - u\ :sub:`12`
+      - u\ :sub:`11`
+      - u\ :sub:`10`
+      - u\ :sub:`9`
+      - u\ :sub:`8`
+      - u\ :sub:`7`
+      - u\ :sub:`6`
+      - u\ :sub:`5`
+      - u\ :sub:`4`
+      - u\ :sub:`3`
+      - u\ :sub:`2`
+      - u\ :sub:`1`
+      - u\ :sub:`0`
+      - v\ :sub:`15`
+      - v\ :sub:`14`
+      - v\ :sub:`13`
+      - v\ :sub:`12`
       - v\ :sub:`11`
       - v\ :sub:`10`
       - v\ :sub:`9`
@@ -6215,29 +9156,14 @@ the following codes.
       - v\ :sub:`2`
       - v\ :sub:`1`
       - v\ :sub:`0`
-    * -
-      -
-      -
-      -
-      -
-      -
-      -
-      -
-      -
-      -
-      -
-      - y\ :sub:`11`
-      - y\ :sub:`10`
-      - y\ :sub:`9`
-      - y\ :sub:`8`
-      - y\ :sub:`7`
-      - y\ :sub:`6`
-      - y\ :sub:`5`
-      - y\ :sub:`4`
-      - y\ :sub:`3`
-      - y\ :sub:`2`
-      - y\ :sub:`1`
-      - y\ :sub:`0`
+    * .. _MEDIA-BUS-FMT-UYVY16-1-1X48:
+
+      - MEDIA_BUS_FMT_UYVY16_1_1X48
+      - 0x202b
+      - u\ :sub:`15`
+      - u\ :sub:`14`
+      - u\ :sub:`13`
+      - u\ :sub:`12`
       - u\ :sub:`11`
       - u\ :sub:`10`
       - u\ :sub:`9`
@@ -6250,13 +9176,12 @@ the following codes.
       - u\ :sub:`2`
       - u\ :sub:`1`
       - u\ :sub:`0`
-    * .. _MEDIA-BUS-FMT-YUV10-1X30:
-
-      - MEDIA_BUS_FMT_YUV10_1X30
-      - 0x2016
-      -
-      -
-      -
+      - y\ :sub:`15`
+      - y\ :sub:`14`
+      - y\ :sub:`13`
+      - y\ :sub:`12`
+      - y\ :sub:`11`
+      - y\ :sub:`10`
       - y\ :sub:`9`
       - y\ :sub:`8`
       - y\ :sub:`7`
@@ -6267,16 +9192,30 @@ the following codes.
       - y\ :sub:`2`
       - y\ :sub:`1`
       - y\ :sub:`0`
-      - u\ :sub:`9`
-      - u\ :sub:`8`
-      - u\ :sub:`7`
-      - u\ :sub:`6`
-      - u\ :sub:`5`
-      - u\ :sub:`4`
-      - u\ :sub:`3`
-      - u\ :sub:`2`
-      - u\ :sub:`1`
-      - u\ :sub:`0`
+      - y\ :sub:`15`
+      - y\ :sub:`14`
+      - y\ :sub:`13`
+      - y\ :sub:`12`
+      - y\ :sub:`11`
+      - y\ :sub:`10`
+      - y\ :sub:`8`
+      - y\ :sub:`8`
+      - y\ :sub:`7`
+      - y\ :sub:`6`
+      - y\ :sub:`5`
+      - y\ :sub:`4`
+      - y\ :sub:`3`
+      - y\ :sub:`2`
+      - y\ :sub:`1`
+      - y\ :sub:`0`
+    * -
+      -
+      - v\ :sub:`15`
+      - v\ :sub:`14`
+      - v\ :sub:`13`
+      - v\ :sub:`12`
+      - v\ :sub:`11`
+      - v\ :sub:`10`
       - v\ :sub:`9`
       - v\ :sub:`8`
       - v\ :sub:`7`
@@ -6287,19 +9226,30 @@ the following codes.
       - v\ :sub:`2`
       - v\ :sub:`1`
       - v\ :sub:`0`
-    * .. _MEDIA-BUS-FMT-AYUV8-1X32:
-
-      - MEDIA_BUS_FMT_AYUV8_1X32
-      - 0x2017
-      -
-      - a\ :sub:`7`
-      - a\ :sub:`6`
-      - a\ :sub:`5`
-      - a\ :sub:`4`
-      - a\ :sub:`3`
-      - a\ :sub:`2`
-      - a\ :sub:`1`
-      - a\ :sub:`0`
+      - y\ :sub:`15`
+      - y\ :sub:`14`
+      - y\ :sub:`13`
+      - y\ :sub:`12`
+      - y\ :sub:`11`
+      - y\ :sub:`10`
+      - y\ :sub:`9`
+      - y\ :sub:`8`
+      - y\ :sub:`7`
+      - y\ :sub:`6`
+      - y\ :sub:`5`
+      - y\ :sub:`4`
+      - y\ :sub:`3`
+      - y\ :sub:`2`
+      - y\ :sub:`1`
+      - y\ :sub:`0`
+      - y\ :sub:`15`
+      - y\ :sub:`14`
+      - y\ :sub:`13`
+      - y\ :sub:`12`
+      - y\ :sub:`11`
+      - y\ :sub:`10`
+      - y\ :sub:`8`
+      - y\ :sub:`8`
       - y\ :sub:`7`
       - y\ :sub:`6`
       - y\ :sub:`5`
@@ -6308,22 +9258,6 @@ the following codes.
       - y\ :sub:`2`
       - y\ :sub:`1`
       - y\ :sub:`0`
-      - u\ :sub:`7`
-      - u\ :sub:`6`
-      - u\ :sub:`5`
-      - u\ :sub:`4`
-      - u\ :sub:`3`
-      - u\ :sub:`2`
-      - u\ :sub:`1`
-      - u\ :sub:`0`
-      - v\ :sub:`7`
-      - v\ :sub:`6`
-      - v\ :sub:`5`
-      - v\ :sub:`4`
-      - v\ :sub:`3`
-      - v\ :sub:`2`
-      - v\ :sub:`1`
-      - v\ :sub:`0`
 
 
 .. raw:: latex
-- 
1.9.1
