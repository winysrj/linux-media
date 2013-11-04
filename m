Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:38513 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134Ab3KDLni (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 4 Nov 2013 06:43:38 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Mikael Starvik <starvik@axis.com>,
	Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Ben Hutchings <ben@decadent.org.uk>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Corey Minyard <cminyard@mvista.com>,
	linux-cris-kernel@axis.com, stable@vger.kernel.org
Subject: [PATCH] media platform drivers: Fix build on cris arch
Date: Mon,  4 Nov 2013 06:40:19 -0200
Message-Id: <1383554419-22591-1-git-send-email-m.chehab@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On cris arch, the functions below aren't defined:

        drivers/media/platform/sh_veu.c: In function 'sh_veu_reg_read':

        drivers/media/platform/sh_veu.c:228:2: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]
        drivers/media/platform/sh_veu.c: In function 'sh_veu_reg_write':

        drivers/media/platform/sh_veu.c:234:2: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]
        drivers/media/platform/vsp1/vsp1.h: In function 'vsp1_read':
        drivers/media/platform/vsp1/vsp1.h:66:2: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]
        drivers/media/platform/vsp1/vsp1.h: In function 'vsp1_write':
        drivers/media/platform/vsp1/vsp1.h:71:2: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]
        drivers/media/platform/vsp1/vsp1.h: In function 'vsp1_read':
        drivers/media/platform/vsp1/vsp1.h:66:2: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]
        drivers/media/platform/vsp1/vsp1.h: In function 'vsp1_write':
        drivers/media/platform/vsp1/vsp1.h:71:2: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]
        drivers/media/platform/soc_camera/rcar_vin.c: In function 'rcar_vin_setup':
        drivers/media/platform/soc_camera/rcar_vin.c:284:3: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]

        drivers/media/platform/soc_camera/rcar_vin.c: In function 'rcar_vin_request_capture_stop':
        drivers/media/platform/soc_camera/rcar_vin.c:353:2: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]

Yet, they're available, as CONFIG_GENERIC_IOMAP is defined. What
happens is that asm/io.h was not including asm-generic/iomap.h.

Suggested-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: stable@vger.kernel.org

---
 arch/cris/include/asm/io.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/cris/include/asm/io.h b/arch/cris/include/asm/io.h
index 5d3047e5563b..4353cf239a13 100644
--- a/arch/cris/include/asm/io.h
+++ b/arch/cris/include/asm/io.h
@@ -3,6 +3,7 @@
 
 #include <asm/page.h>   /* for __va, __pa */
 #include <arch/io.h>
+#include <asm-generic/iomap.h>
 #include <linux/kernel.h>
 
 struct cris_io_operations
-- 
1.8.3.1

