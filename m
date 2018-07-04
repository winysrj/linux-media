Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:58987 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932538AbeGDKQF (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 4 Jul 2018 06:16:05 -0400
From: Jacopo Mondi <jacopo+renesas@jmondi.org>
To: hverkuil@xs4all.nl, mchehab@kernel.org, ysato@users.sourceforge.jp,
        dalias@libc.org
Cc: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/9] sh: defconfig: migor: Enable CEU and sensor drivers
Date: Wed,  4 Jul 2018 12:15:39 +0200
Message-Id: <1530699346-3235-3-git-send-email-jacopo+renesas@jmondi.org>
In-Reply-To: <1530699346-3235-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1530699346-3235-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Enable the new renesas-ceu driver and drivers for the OV7720
image sensor and TW9910 video receiver installed on Migo-R
development board.

Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
---
 arch/sh/configs/migor_defconfig | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/sh/configs/migor_defconfig b/arch/sh/configs/migor_defconfig
index a85a327..446d7bc 100644
--- a/arch/sh/configs/migor_defconfig
+++ b/arch/sh/configs/migor_defconfig
@@ -49,6 +49,12 @@ CONFIG_I2C=y
 CONFIG_I2C_SH_MOBILE=y
 # CONFIG_HWMON is not set
 CONFIG_MEDIA_SUPPORT=y
+CONFIG_MEDIA_CAMERA_SUPPORT=y
+CONFIG_V4L_PLATFORM_DRIVERS=y
+CONFIG_VIDEO_RENESAS_CEU=y
+# CONFIG_MEDIA_SUBDRV_AUTOSELECT is not set
+CONFIG_VIDEO_TW9910=y
+CONFIG_VIDEO_OV772X=y
 CONFIG_FB=y
 CONFIG_FB_SH_MOBILE_LCDC=y
 CONFIG_FRAMEBUFFER_CONSOLE=y
-- 
2.7.4
