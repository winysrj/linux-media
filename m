Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f182.google.com ([209.85.128.182]:34031 "EHLO
        mail-wr0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754167AbdC3JEr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Mar 2017 05:04:47 -0400
Received: by mail-wr0-f182.google.com with SMTP id l43so51881880wre.1
        for <linux-media@vger.kernel.org>; Thu, 30 Mar 2017 02:04:46 -0700 (PDT)
From: Neil Armstrong <narmstrong@baylibre.com>
To: dri-devel@lists.freedesktop.org,
        laurent.pinchart+renesas@ideasonboard.com, architt@codeaurora.org,
        mchehab@kernel.org
Cc: Neil Armstrong <narmstrong@baylibre.com>, Jose.Abreu@synopsys.com,
        kieran.bingham@ideasonboard.com, linux-amlogic@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        hans.verkuil@cisco.com, sakari.ailus@linux.intel.com
Subject: [PATCH v5 2/6] media: uapi: Add RGB and YUV bus formats for Synopsys HDMI TX Controller
Date: Thu, 30 Mar 2017 11:04:31 +0200
Message-Id: <1490864675-17336-3-git-send-email-narmstrong@baylibre.com>
In-Reply-To: <1490864675-17336-1-git-send-email-narmstrong@baylibre.com>
References: <1490864675-17336-1-git-send-email-narmstrong@baylibre.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In order to describe the RGB and YUV bus formats used to feed the
Synopsys DesignWare HDMI TX Controller, add missing formats to the
list of Bus Formats.

Documentation for these formats is added in a separate patch.

Reviewed-by: Archit Taneja <architt@codeaurora.org>
Reviewed-by: Jose Abreu <joabreu@synopsys.com>
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
---
 include/uapi/linux/media-bus-format.h | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/media-bus-format.h b/include/uapi/linux/media-bus-format.h
index 2168759..ef6fb30 100644
--- a/include/uapi/linux/media-bus-format.h
+++ b/include/uapi/linux/media-bus-format.h
@@ -33,7 +33,7 @@
 
 #define MEDIA_BUS_FMT_FIXED			0x0001
 
-/* RGB - next is	0x1018 */
+/* RGB - next is	0x101b */
 #define MEDIA_BUS_FMT_RGB444_1X12		0x1016
 #define MEDIA_BUS_FMT_RGB444_2X8_PADHI_BE	0x1001
 #define MEDIA_BUS_FMT_RGB444_2X8_PADHI_LE	0x1002
@@ -57,8 +57,11 @@
 #define MEDIA_BUS_FMT_RGB888_1X7X4_JEIDA	0x1012
 #define MEDIA_BUS_FMT_ARGB8888_1X32		0x100d
 #define MEDIA_BUS_FMT_RGB888_1X32_PADHI		0x100f
+#define MEDIA_BUS_FMT_RGB101010_1X30		0x1018
+#define MEDIA_BUS_FMT_RGB121212_1X36		0x1019
+#define MEDIA_BUS_FMT_RGB161616_1X48		0x101a
 
-/* YUV (including grey) - next is	0x2026 */
+/* YUV (including grey) - next is	0x202c */
 #define MEDIA_BUS_FMT_Y8_1X8			0x2001
 #define MEDIA_BUS_FMT_UV8_1X8			0x2015
 #define MEDIA_BUS_FMT_UYVY8_1_5X8		0x2002
@@ -90,12 +93,18 @@
 #define MEDIA_BUS_FMT_YVYU10_1X20		0x200e
 #define MEDIA_BUS_FMT_VUY8_1X24			0x2024
 #define MEDIA_BUS_FMT_YUV8_1X24			0x2025
+#define MEDIA_BUS_FMT_UYYVYY8_0_5X24		0x2026
 #define MEDIA_BUS_FMT_UYVY12_1X24		0x2020
 #define MEDIA_BUS_FMT_VYUY12_1X24		0x2021
 #define MEDIA_BUS_FMT_YUYV12_1X24		0x2022
 #define MEDIA_BUS_FMT_YVYU12_1X24		0x2023
 #define MEDIA_BUS_FMT_YUV10_1X30		0x2016
+#define MEDIA_BUS_FMT_UYYVYY10_0_5X30		0x2027
 #define MEDIA_BUS_FMT_AYUV8_1X32		0x2017
+#define MEDIA_BUS_FMT_UYYVYY12_0_5X36		0x2028
+#define MEDIA_BUS_FMT_YUV12_1X36		0x2029
+#define MEDIA_BUS_FMT_YUV16_1X48		0x202a
+#define MEDIA_BUS_FMT_UYYVYY16_0_5X48		0x202b
 
 /* Bayer - next is	0x3021 */
 #define MEDIA_BUS_FMT_SBGGR8_1X8		0x3001
-- 
1.9.1
