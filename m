Return-path: <linux-media-owner@vger.kernel.org>
Received: from michel.telenet-ops.be ([195.130.137.88]:54800 "EHLO
	michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761329AbbEEQcz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 May 2015 12:32:55 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Walleij <linus.walleij@linaro.org>,
	Alexandre Courbot <gnurou@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>
Cc: linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Subject: [PATCH 10/27] [media] wl128x: Allow compile test of GPIO consumers if !GPIOLIB
Date: Tue,  5 May 2015 18:32:26 +0200
Message-Id: <1430843563-18615-10-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1430843563-18615-1-git-send-email-geert@linux-m68k.org>
References: <1430836404-15513-1-git-send-email-geert@linux-m68k.org>
 <1430843563-18615-1-git-send-email-geert@linux-m68k.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The GPIO subsystem provides dummy GPIO consumer functions if GPIOLIB is
not enabled. Hence drivers that depend on GPIOLIB, but use GPIO consumer
functionality only, can still be compiled if GPIOLIB is not enabled.

Relax the dependency on GPIOLIB if COMPILE_TEST is enabled, where
appropriate.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-media@vger.kernel.org
---
 drivers/media/radio/wl128x/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/radio/wl128x/Kconfig b/drivers/media/radio/wl128x/Kconfig
index 9d6574bebf78b4f6..c9e349b169c44c07 100644
--- a/drivers/media/radio/wl128x/Kconfig
+++ b/drivers/media/radio/wl128x/Kconfig
@@ -4,8 +4,8 @@
 menu "Texas Instruments WL128x FM driver (ST based)"
 config RADIO_WL128X
 	tristate "Texas Instruments WL128x FM Radio"
-	depends on VIDEO_V4L2 && RFKILL && GPIOLIB && TTY
-	depends on TI_ST
+	depends on VIDEO_V4L2 && RFKILL && TTY && TI_ST
+	depends on GPIOLIB || COMPILE_TEST
 	help
 	Choose Y here if you have this FM radio chip.
 
-- 
1.9.1

