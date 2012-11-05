Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:35046 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785Ab2KEQAN (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 5 Nov 2012 11:00:13 -0500
Received: by mail-wg0-f44.google.com with SMTP id dr13so4061968wgb.1
        for <linux-media@vger.kernel.org>; Mon, 05 Nov 2012 08:00:12 -0800 (PST)
From: Javier Martin <javier.martin@vista-silicon.com>
To: linux-media@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, p.zabel@pengutronix.de,
	s.nawrocki@samsung.com, mchehab@infradead.org,
	kernel@pengutronix.de,
	Javier Martin <javier.martin@vista-silicon.com>
Subject: [PATCH 1/2] ARM: i.MX27: Add platform support for IRAM.
Date: Mon,  5 Nov 2012 16:59:44 +0100
Message-Id: <1352131185-12079-1-git-send-email-javier.martin@vista-silicon.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add support for IRAM to i.MX27 non-DT platforms using
iram_init() function.

Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>
---
 arch/arm/mach-imx/mm-imx27.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/mach-imx/mm-imx27.c b/arch/arm/mach-imx/mm-imx27.c
index e7e24af..fd2416d 100644
--- a/arch/arm/mach-imx/mm-imx27.c
+++ b/arch/arm/mach-imx/mm-imx27.c
@@ -27,6 +27,7 @@
 #include <asm/pgtable.h>
 #include <asm/mach/map.h>
 #include <mach/iomux-v1.h>
+#include <mach/iram.h>
 
 /* MX27 memory map definition */
 static struct map_desc imx27_io_desc[] __initdata = {
@@ -94,4 +95,6 @@ void __init imx27_soc_init(void)
 	/* imx27 has the imx21 type audmux */
 	platform_device_register_simple("imx21-audmux", 0, imx27_audmux_res,
 					ARRAY_SIZE(imx27_audmux_res));
+	/* imx27 has an iram of 46080 bytes size */
+	iram_init(MX27_IRAM_BASE_ADDR, 46080);
 }
-- 
1.7.9.5

