Return-path: <linux-media-owner@vger.kernel.org>
Received: from baptiste.telenet-ops.be ([195.130.132.51]:49877 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752944AbbF2Nqu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Jun 2015 09:46:50 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 3/3] [media] tuners: Make all TV tuners visible if COMPILE_TEST=y
Date: Mon, 29 Jun 2015 15:46:49 +0200
Message-Id: <1435585609-13784-3-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1435585609-13784-1-git-send-email-geert@linux-m68k.org>
References: <1435585609-13784-1-git-send-email-geert@linux-m68k.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make the TV tuners menu visible when compile-testing, to allow
selecting additional drivers on top of the drivers that are already
automatically selected if MEDIA_SUBDRV_AUTOSELECT is enabled.

Without this, many drivers stay disabled during e.g. allmodconfig.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/media/tuners/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/tuners/Kconfig b/drivers/media/tuners/Kconfig
index 8294af9091747558..05998f0254c6cb8a 100644
--- a/drivers/media/tuners/Kconfig
+++ b/drivers/media/tuners/Kconfig
@@ -15,7 +15,7 @@ config MEDIA_TUNER
 	select MEDIA_TUNER_MC44S803 if MEDIA_SUBDRV_AUTOSELECT
 
 menu "Customize TV tuners"
-	visible if !MEDIA_SUBDRV_AUTOSELECT
+	visible if !MEDIA_SUBDRV_AUTOSELECT || COMPILE_TEST
 	depends on MEDIA_ANALOG_TV_SUPPORT || MEDIA_DIGITAL_TV_SUPPORT || MEDIA_RADIO_SUPPORT || MEDIA_SDR_SUPPORT
 
 config MEDIA_TUNER_SIMPLE
-- 
1.9.1

