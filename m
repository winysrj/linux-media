Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:51218 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966844Ab3DQWSS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Apr 2013 18:18:18 -0400
Received: by mail-la0-f46.google.com with SMTP id ea20so1944094lab.5
        for <linux-media@vger.kernel.org>; Wed, 17 Apr 2013 15:18:17 -0700 (PDT)
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
To: linux@arm.linux.org.uk, linux-sh@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH 4/4] ARM: shmobile: Marzen: enable VIN and ADV7180 in defconfig
Date: Thu, 18 Apr 2013 02:17:27 +0400
Cc: horms@verge.net.au, magnus.damm@gmail.com,
	linux-media@vger.kernel.org, matsu@igel.co.jp
References: <201304180206.39465.sergei.shtylyov@cogentembedded.com>
In-Reply-To: <201304180206.39465.sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201304180217.28176.sergei.shtylyov@cogentembedded.com>
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
