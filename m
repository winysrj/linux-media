Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f174.google.com ([209.85.128.174]:35676 "EHLO
        mail-wr0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755596AbdCGTeQ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 7 Mar 2017 14:34:16 -0500
Received: by mail-wr0-f174.google.com with SMTP id g10so8769506wrg.2
        for <linux-media@vger.kernel.org>; Tue, 07 Mar 2017 11:34:15 -0800 (PST)
From: Neil Armstrong <narmstrong@baylibre.com>
To: dri-devel@lists.freedesktop.org,
        laurent.pinchart+renesas@ideasonboard.com, architt@codeaurora.org,
        mchehab@kernel.org
Cc: Neil Armstrong <narmstrong@baylibre.com>, Jose.Abreu@synopsys.com,
        kieran.bingham@ideasonboard.com, linux-amlogic@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        hans.verkuil@cisco.com, sakari.ailus@linux.intel.com
Subject: [PATCH v3 2/6] media: uapi: Add RGB and YUV bus formats for Synopsys HDMI TX Controller
Date: Tue,  7 Mar 2017 17:42:20 +0100
Message-Id: <1488904944-14285-3-git-send-email-narmstrong@baylibre.com>
In-Reply-To: <1488904944-14285-1-git-send-email-narmstrong@baylibre.com>
References: <1488904944-14285-1-git-send-email-narmstrong@baylibre.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In order to describe the RGB and YUB bus formats used to feed the
Synopsys DesignWare HDMI TX Controller, add missing formats to the
list of Bus Formats.

Documentation for these formats is added in a separate patch.

Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
---
 include/uapi/linux/media-bus-format.h | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/media-bus-format.h b/include/uapi/linux/media-bus-format.h
index 2168759..7cc820b 100644
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
+#define MEDIA_BUS_FMT_UYVY8_1_1X24		0x2026
 #define MEDIA_BUS_FMT_UYVY12_1X24		0x2020
 #define MEDIA_BUS_FMT_VYUY12_1X24		0x2021
 #define MEDIA_BUS_FMT_YUYV12_1X24		0x2022
 #define MEDIA_BUS_FMT_YVYU12_1X24		0x2023
 #define MEDIA_BUS_FMT_YUV10_1X30		0x2016
+#define MEDIA_BUS_FMT_UYVY10_1_1X30		0x2027
 #define MEDIA_BUS_FMT_AYUV8_1X32		0x2017
+#define MEDIA_BUS_FMT_UYVY12_1_1X36		0x2028
+#define MEDIA_BUS_FMT_YUV12_1X36		0x2029
+#define MEDIA_BUS_FMT_YUV16_1X48		0x202a
+#define MEDIA_BUS_FMT_UYVY16_1_1X48		0x202b
 
 /* Bayer - next is	0x3021 */
 #define MEDIA_BUS_FMT_SBGGR8_1X8		0x3001
-- 
1.9.1
