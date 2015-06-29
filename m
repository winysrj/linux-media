Return-path: <linux-media-owner@vger.kernel.org>
Received: from andre.telenet-ops.be ([195.130.132.53]:57263 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181AbbF2Nqt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Jun 2015 09:46:49 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 2/3] [media] i2c: Make all i2c devices visible if COMPILE_TEST=y
Date: Mon, 29 Jun 2015 15:46:48 +0200
Message-Id: <1435585609-13784-2-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1435585609-13784-1-git-send-email-geert@linux-m68k.org>
References: <1435585609-13784-1-git-send-email-geert@linux-m68k.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make the i2c devices menu visible when compile-testing, to allow
selecting additional drivers on top of the drivers that are already
automatically selected if MEDIA_SUBDRV_AUTOSELECT is enabled.

Without this, many drivers stay disabled during e.g. allmodconfig.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/media/i2c/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index 8d1268648fe0b291..36b979f0bc056969 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -22,7 +22,7 @@ config VIDEO_IR_I2C
 #
 
 menu "Encoders, decoders, sensors and other helper chips"
-	visible if !MEDIA_SUBDRV_AUTOSELECT
+	visible if !MEDIA_SUBDRV_AUTOSELECT || COMPILE_TEST
 
 comment "Audio decoders, processors and mixers"
 
-- 
1.9.1

