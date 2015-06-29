Return-path: <linux-media-owner@vger.kernel.org>
Received: from baptiste.telenet-ops.be ([195.130.132.51]:49812 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753234AbbF2Nqt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Jun 2015 09:46:49 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 1/3] [media] dvb-frontends: Make all DVB Frontends visible if COMPILE_TEST=y
Date: Mon, 29 Jun 2015 15:46:47 +0200
Message-Id: <1435585609-13784-1-git-send-email-geert@linux-m68k.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Make the DVB Frontends menu visible when compile-testing, to allow
selecting additional drivers on top of the drivers that are already
automatically selected if MEDIA_SUBDRV_AUTOSELECT is enabled.

Without this, many drivers stay disabled during e.g. allmodconfig.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/media/dvb-frontends/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/Kconfig b/drivers/media/dvb-frontends/Kconfig
index 0d35f5850ff1ea8e..c6b2e67c7452f0ac 100644
--- a/drivers/media/dvb-frontends/Kconfig
+++ b/drivers/media/dvb-frontends/Kconfig
@@ -1,5 +1,5 @@
 menu "Customise DVB Frontends"
-	visible if !MEDIA_SUBDRV_AUTOSELECT
+	visible if !MEDIA_SUBDRV_AUTOSELECT || COMPILE_TEST
 
 comment "Multistandard (satellite) frontends"
 	depends on DVB_CORE
-- 
1.9.1

