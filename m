Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-la0-f50.google.com ([209.85.215.50]:51902 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467Ab3EPVeE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 May 2013 17:34:04 -0400
Received: by mail-la0-f50.google.com with SMTP id ed20so3470541lab.23
        for <linux-media@vger.kernel.org>; Thu, 16 May 2013 14:34:02 -0700 (PDT)
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
To: horms@verge.net.au, linux-sh@vger.kernel.org
Subject: [PATCH v4 3/3] ARM: shmobile: BOCK-W: enable VIN and ML86V7667 in defconfig
Date: Fri, 17 May 2013 01:34:04 +0400
Cc: linux-media@vger.kernel.org, magnus.damm@gmail.com,
	linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
	matsu@igel.co.jp, vladimir.barinov@cogentembedded.com
References: <201305170122.33996.sergei.shtylyov@cogentembedded.com>
In-Reply-To: <201305170122.33996.sergei.shtylyov@cogentembedded.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201305170134.05547.sergei.shtylyov@cogentembedded.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Vladimir Barinov <vladimir.barinov@cogentembedded.com>

Add the VIN and ML86V7667 drivers to 'bockw_defconfig'.

Signed-off-by: Vladimir Barinov <vladimir.barinov@cogentembedded.com>
Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

---
 arch/arm/configs/bockw_defconfig |    7 +++++++
 1 file changed, 7 insertions(+)

Index: renesas/arch/arm/configs/bockw_defconfig
===================================================================
--- renesas.orig/arch/arm/configs/bockw_defconfig
+++ renesas/arch/arm/configs/bockw_defconfig
@@ -76,6 +76,13 @@ CONFIG_SERIAL_SH_SCI_CONSOLE=y
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
 CONFIG_USB=y
 CONFIG_USB_ANNOUNCE_NEW_DEVICES=y
 CONFIG_USB_EHCI_HCD=y
