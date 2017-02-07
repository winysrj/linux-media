Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:37180 "EHLO
        mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755373AbdBGQmG (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 7 Feb 2017 11:42:06 -0500
Received: by mail-wm0-f41.google.com with SMTP id v77so162578237wmv.0
        for <linux-media@vger.kernel.org>; Tue, 07 Feb 2017 08:42:01 -0800 (PST)
From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
To: Kevin Hilman <khilman@kernel.org>, Sekhar Nori <nsekhar@ti.com>,
        Patrick Titiano <ptitiano@baylibre.com>,
        Michael Turquette <mturquette@baylibre.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Russell King <linux@armlinux.org.uk>,
        Alexandre Bailon <abailon@baylibre.com>,
        David Lechner <david@lechnology.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Lad Prabhakar <prabhakar.csengg@gmail.com>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH 08/10] ARM: davinci: fix the DT boot on da850-evm
Date: Tue,  7 Feb 2017 17:41:21 +0100
Message-Id: <1486485683-11427-9-git-send-email-bgolaszewski@baylibre.com>
In-Reply-To: <1486485683-11427-1-git-send-email-bgolaszewski@baylibre.com>
References: <1486485683-11427-1-git-send-email-bgolaszewski@baylibre.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

When we enable vpif capture on the da850-evm we hit a BUG_ON() because
the i2c adapter can't be found. The board file boot uses i2c adapter 1
but in the DT mode it's actually adapter 0. Drop the problematic lines.

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
 arch/arm/mach-davinci/pdata-quirks.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/arm/mach-davinci/pdata-quirks.c b/arch/arm/mach-davinci/pdata-quirks.c
index 94948c1..09f62ac 100644
--- a/arch/arm/mach-davinci/pdata-quirks.c
+++ b/arch/arm/mach-davinci/pdata-quirks.c
@@ -116,10 +116,6 @@ static void __init da850_vpif_legacy_init(void)
 	if (of_machine_is_compatible("ti,da850-lcdk"))
 		da850_vpif_capture_config.subdev_count = 1;
 
-	/* EVM (UI card) uses i2c adapter 1 (not default: zero) */
-	if (of_machine_is_compatible("ti,da850-evm"))
-		da850_vpif_capture_config.i2c_adapter_id = 1;
-
 	ret = da850_register_vpif_capture(&da850_vpif_capture_config);
 	if (ret)
 		pr_warn("%s: VPIF capture setup failed: %d\n",
-- 
2.9.3

