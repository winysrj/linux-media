Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:47547 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753891Ab3HVVkd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Aug 2013 17:40:33 -0400
Received: by mail-la0-f52.google.com with SMTP id ev20so1935564lab.11
        for <linux-media@vger.kernel.org>; Thu, 22 Aug 2013 14:40:31 -0700 (PDT)
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
To: horms@verge.net.au, linux-sh@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, m.chehab@samsung.com,
	linux-media@vger.kernel.org
Subject: [PATCH v6 3/3] ARM: shmobile: BOCK-W: enable VIN and ML86V7667 in defconfig
Date: Fri, 23 Aug 2013 01:40:36 +0400
Cc: magnus.damm@gmail.com, linux@arm.linux.org.uk,
	vladimir.barinov@cogentembedded.com
References: <201308230134.26092.sergei.shtylyov@cogentembedded.com>
In-Reply-To: <201308230134.26092.sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201308230140.37614.sergei.shtylyov@cogentembedded.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Vladimir Barinov <vladimir.barinov@cogentembedded.com>

Add the VIN and ML86V7667 drivers to 'bockw_defconfig'.

Signed-off-by: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

---
Changes since version 4:
- resolved reject.

 arch/arm/configs/bockw_defconfig |    7 +++++++
 1 file changed, 7 insertions(+)

Index: media_tree/arch/arm/configs/bockw_defconfig
===================================================================
--- media_tree.orig/arch/arm/configs/bockw_defconfig
+++ media_tree/arch/arm/configs/bockw_defconfig
@@ -82,6 +82,13 @@ CONFIG_SERIAL_SH_SCI_CONSOLE=y
 # CONFIG_HWMON is not set
 CONFIG_I2C=y
 CONFIG_I2C_RCAR=y
+CONFIG_MEDIA_SUPPORT=y
+CONFIG_MEDIA_CAMERA_SUPPORT=y
+CONFIG_V4L_PLATFORM_DRIVERS=y
+CONFIG_SOC_CAMERA=y
+CONFIG_VIDEO_RCAR_VIN=y
+# CONFIG_MEDIA_SUBDRV_AUTOSELECT is not set
+CONFIG_VIDEO_ML86V7667=y
 CONFIG_SPI=y
 CONFIG_SPI_SH_HSPI=y
 CONFIG_USB=y
