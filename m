Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f180.google.com ([209.85.217.180]:34011 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756508Ab3DWRQI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Apr 2013 13:16:08 -0400
Received: by mail-lb0-f180.google.com with SMTP id t11so878624lbi.39
        for <linux-media@vger.kernel.org>; Tue, 23 Apr 2013 10:16:07 -0700 (PDT)
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
To: horms@verge.net.au, linux-sh@vger.kernel.org
Subject: [PATCH v3 4/4] ARM: shmobile: Marzen: enable VIN and ADV7180 in defconfig
Date: Tue, 23 Apr 2013 21:15:23 +0400
Cc: magnus.damm@gmail.com, linux@arm.linux.org.uk,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	matsu@igel.co.jp, vladimir.barinov@cogentembedded.com
References: <201304232106.45889.sergei.shtylyov@cogentembedded.com>
In-Reply-To: <201304232106.45889.sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201304232115.24523.sergei.shtylyov@cogentembedded.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Vladimir Barinov <vladimir.barinov@cogentembedded.com>

Add the VIN and ADV7180 drivers to 'marzen_defconfig'.

Signed-off-by: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

---
 arch/arm/configs/marzen_defconfig |    7 +++++++
 1 file changed, 7 insertions(+)

Index: renesas/arch/arm/configs/marzen_defconfig
===================================================================
--- renesas.orig/arch/arm/configs/marzen_defconfig
+++ renesas/arch/arm/configs/marzen_defconfig
@@ -84,6 +84,13 @@ CONFIG_GPIO_RCAR=y
 CONFIG_THERMAL=y
 CONFIG_RCAR_THERMAL=y
 CONFIG_SSB=y
+CONFIG_MEDIA_SUPPORT=y
+CONFIG_MEDIA_CAMERA_SUPPORT=y
+CONFIG_V4L_PLATFORM_DRIVERS=y
+CONFIG_SOC_CAMERA=y
+CONFIG_VIDEO_RCAR_VIN=y
+# CONFIG_MEDIA_SUBDRV_AUTOSELECT is not set
+CONFIG_VIDEO_ADV7180=y
 CONFIG_USB=y
 CONFIG_USB_RCAR_PHY=y
 CONFIG_MMC=y
