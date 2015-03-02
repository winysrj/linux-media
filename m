Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:45375 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755104AbbCBRG3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Mar 2015 12:06:29 -0500
In-Reply-To: <20150302170538.GQ8656@n2100.arm.linux.org.uk>
References: <20150302170538.GQ8656@n2100.arm.linux.org.uk>
From: Russell King <rmk+kernel@arm.linux.org.uk>
To: alsa-devel@alsa-project.org, linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-sh@vger.kernel.org
Cc: Roland Stigge <stigge@antcom.de>
Subject: [PATCH 04/10] ARM: lpc32xx: convert to use clkdev_add_table()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1YSTnR-0001Jg-Pn@rmk-PC.arm.linux.org.uk>
Date: Mon, 02 Mar 2015 17:06:21 +0000
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We have always had an efficient way of registering a table of clock
lookups - it's called clkdev_add_table().  However, some people seem
to really love writing inefficient and unnecessary code.

Convert LPC32xx to use the correct interface.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 arch/arm/mach-lpc32xx/clock.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/arm/mach-lpc32xx/clock.c b/arch/arm/mach-lpc32xx/clock.c
index dd5d6f532e8c..661c8f4b2310 100644
--- a/arch/arm/mach-lpc32xx/clock.c
+++ b/arch/arm/mach-lpc32xx/clock.c
@@ -1238,10 +1238,7 @@ static struct clk_lookup lookups[] = {
 
 static int __init clk_init(void)
 {
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(lookups); i++)
-		clkdev_add(&lookups[i]);
+	clkdev_add_table(lookups, ARRAY_SIZE(lookups));
 
 	/*
 	 * Setup muxed SYSCLK for HCLK PLL base -this selects the
-- 
1.8.3.1

