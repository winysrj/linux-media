Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:53169 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750990AbeDSJbg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 19 Apr 2018 05:31:36 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: architt@codeaurora.org, a.hajda@samsung.com,
        Laurent.pinchart@ideasonboard.com, airlied@linux.ie
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>, daniel@ffwll.ch,
        peda@axentia.se, linux-renesas-soc@vger.kernel.org,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/8] media: Add LE version of RGB LVDS formats
Date: Thu, 19 Apr 2018 11:31:06 +0200
Message-Id: <1524130269-32688-6-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1524130269-32688-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1524130269-32688-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Some LVDS controller can output swapped versions of LVDS RGB formats.
Define and document them in the list of supported media bus formats

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 Documentation/media/uapi/v4l/subdev-formats.rst | 174 ++++++++++++++++++++++++
 include/uapi/linux/media-bus-format.h           |   5 +-
 2 files changed, 178 insertions(+), 1 deletion(-)

diff --git a/Documentation/media/uapi/v4l/subdev-formats.rst b/Documentation/media/uapi/v4l/subdev-formats.rst
index 9fcabe7..9a5263c 100644
--- a/Documentation/media/uapi/v4l/subdev-formats.rst
+++ b/Documentation/media/uapi/v4l/subdev-formats.rst
@@ -1669,6 +1669,64 @@ JEIDA defined bit mapping will be named
       - b\ :sub:`2`
       - g\ :sub:`1`
       - r\ :sub:`0`
+    * .. _MEDIA-BUS-FMT-RGB666-1X7X3-SPWG_LE:
+
+      - MEDIA_BUS_FMT_RGB666_1X7X3_SPWG_LE
+      - 0x101b
+      - 0
+      -
+      -
+      - b\ :sub:`2`
+      - g\ :sub:`1`
+      - r\ :sub:`0`
+    * -
+      -
+      - 1
+      -
+      -
+      - b\ :sub:`3`
+      - g\ :sub:`2`
+      - r\ :sub:`1`
+    * -
+      -
+      - 2
+      -
+      -
+      - b\ :sub:`4`
+      - g\ :sub:`3`
+      - r\ :sub:`2`
+    * -
+      -
+      - 3
+      -
+      -
+      - b\ :sub:`5`
+      - g\ :sub:`4`
+      - r\ :sub:`3`
+    * -
+      -
+      - 4
+      -
+      -
+      - d
+      - g\ :sub:`5`
+      - r\ :sub:`4`
+    * -
+      -
+      - 5
+      -
+      -
+      - d
+      - b\ :sub:`0`
+      - r\ :sub:`5`
+    * -
+      -
+      - 6
+      -
+      -
+      - d
+      - b\ :sub:`1`
+      - g\ :sub:`0`
     * .. _MEDIA-BUS-FMT-RGB888-1X7X4-SPWG:
 
       - MEDIA_BUS_FMT_RGB888_1X7X4_SPWG
@@ -1727,6 +1785,64 @@ JEIDA defined bit mapping will be named
       - b\ :sub:`2`
       - g\ :sub:`1`
       - r\ :sub:`0`
+    * .. _MEDIA-BUS-FMT-RGB888-1X7X4-SPWG_LE:
+
+      - MEDIA_BUS_FMT_RGB888_1X7X4_SPWG_LE
+      - 0x101c
+      - 0
+      -
+      - r\ :sub:`6`
+      - b\ :sub:`2`
+      - g\ :sub:`1`
+      - r\ :sub:`0`
+    * -
+      -
+      - 1
+      -
+      - r\ :sub:`7`
+      - b\ :sub:`3`
+      - g\ :sub:`2`
+      - r\ :sub:`1`
+    * -
+      -
+      - 2
+      -
+      - g\ :sub:`6`
+      - b\ :sub:`4`
+      - g\ :sub:`3`
+      - r\ :sub:`2`
+    * -
+      -
+      - 3
+      -
+      - g\ :sub:`7`
+      - b\ :sub:`5`
+      - g\ :sub:`4`
+      - r\ :sub:`3`
+    * -
+      -
+      - 4
+      -
+      - b\ :sub:`6`
+      - d
+      - g\ :sub:`5`
+      - r\ :sub:`4`
+    * -
+      -
+      - 5
+      -
+      - b\ :sub:`7`
+      - d
+      - b\ :sub:`0`
+      - r\ :sub:`5`
+    * -
+      -
+      - 6
+      -
+      - d
+      - d
+      - b\ :sub:`1`
+      - g\ :sub:`0`
     * .. _MEDIA-BUS-FMT-RGB888-1X7X4-JEIDA:
 
       - MEDIA_BUS_FMT_RGB888_1X7X4_JEIDA
@@ -1785,6 +1901,64 @@ JEIDA defined bit mapping will be named
       - b\ :sub:`4`
       - g\ :sub:`3`
       - r\ :sub:`2`
+    * .. _MEDIA-BUS-FMT-RGB888-1X7X4-JEIDA_LE:
+
+      - MEDIA_BUS_FMT_RGB888_1X7X4_JEIDA_LE
+      - 0x101d
+      - 0
+      -
+      - r\ :sub:`0`
+      - b\ :sub:`4`
+      - g\ :sub:`3`
+      - r\ :sub:`2`
+    * -
+      -
+      - 1
+      -
+      - r\ :sub:`1`
+      - b\ :sub:`5`
+      - g\ :sub:`4`
+      - r\ :sub:`3`
+    * -
+      -
+      - 2
+      -
+      - g\ :sub:`0`
+      - b\ :sub:`6`
+      - g\ :sub:`5`
+      - r\ :sub:`4`
+    * -
+      -
+      - 3
+      -
+      - g\ :sub:`1`
+      - b\ :sub:`7`
+      - g\ :sub:`6`
+      - r\ :sub:`5`
+    * -
+      -
+      - 4
+      -
+      - b\ :sub:`0`
+      - d
+      - g\ :sub:`7`
+      - r\ :sub:`6`
+    * -
+      -
+      - 5
+      -
+      - b\ :sub:`1`
+      - d
+      - b\ :sub:`2`
+      - r\ :sub:`7`
+    * -
+      -
+      - 6
+      -
+      - d
+      - d
+      - b\ :sub:`3`
+      - g\ :sub:`2`
 
 .. raw:: latex
 
diff --git a/include/uapi/linux/media-bus-format.h b/include/uapi/linux/media-bus-format.h
index 9e35117..5bea7c0 100644
--- a/include/uapi/linux/media-bus-format.h
+++ b/include/uapi/linux/media-bus-format.h
@@ -34,7 +34,7 @@
 
 #define MEDIA_BUS_FMT_FIXED			0x0001
 
-/* RGB - next is	0x101b */
+/* RGB - next is	0x101f */
 #define MEDIA_BUS_FMT_RGB444_1X12		0x1016
 #define MEDIA_BUS_FMT_RGB444_2X8_PADHI_BE	0x1001
 #define MEDIA_BUS_FMT_RGB444_2X8_PADHI_LE	0x1002
@@ -49,13 +49,16 @@
 #define MEDIA_BUS_FMT_RBG888_1X24		0x100e
 #define MEDIA_BUS_FMT_RGB666_1X24_CPADHI	0x1015
 #define MEDIA_BUS_FMT_RGB666_1X7X3_SPWG		0x1010
+#define MEDIA_BUS_FMT_RGB666_1X7X3_SPWG_LE	0x101b
 #define MEDIA_BUS_FMT_BGR888_1X24		0x1013
 #define MEDIA_BUS_FMT_GBR888_1X24		0x1014
 #define MEDIA_BUS_FMT_RGB888_1X24		0x100a
 #define MEDIA_BUS_FMT_RGB888_2X12_BE		0x100b
 #define MEDIA_BUS_FMT_RGB888_2X12_LE		0x100c
 #define MEDIA_BUS_FMT_RGB888_1X7X4_SPWG		0x1011
+#define MEDIA_BUS_FMT_RGB888_1X7X4_SPWG_LE	0x101c
 #define MEDIA_BUS_FMT_RGB888_1X7X4_JEIDA	0x1012
+#define MEDIA_BUS_FMT_RGB888_1X7X4_JEIDA_LE	0x101d
 #define MEDIA_BUS_FMT_ARGB8888_1X32		0x100d
 #define MEDIA_BUS_FMT_RGB888_1X32_PADHI		0x100f
 #define MEDIA_BUS_FMT_RGB101010_1X30		0x1018
-- 
2.7.4
