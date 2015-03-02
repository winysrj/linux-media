Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:45396 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755378AbbCBRGx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Mar 2015 12:06:53 -0500
In-Reply-To: <20150302170538.GQ8656@n2100.arm.linux.org.uk>
References: <20150302170538.GQ8656@n2100.arm.linux.org.uk>
From: Russell King <rmk+kernel@arm.linux.org.uk>
To: alsa-devel@alsa-project.org, linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-sh@vger.kernel.org
Cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
	Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: [PATCH 08/10] ARM: orion: use clkdev_create()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1YSTnm-0001Jx-AM@rmk-PC.arm.linux.org.uk>
Date: Mon, 02 Mar 2015 17:06:42 +0000
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

clkdev_create() is a shorter way to write clkdev_alloc() followed by
clkdev_add().  Use this instead.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 arch/arm/plat-orion/common.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/arch/arm/plat-orion/common.c b/arch/arm/plat-orion/common.c
index f5b00f41c4f6..2235081a04ee 100644
--- a/arch/arm/plat-orion/common.c
+++ b/arch/arm/plat-orion/common.c
@@ -28,11 +28,7 @@
 void __init orion_clkdev_add(const char *con_id, const char *dev_id,
 			     struct clk *clk)
 {
-	struct clk_lookup *cl;
-
-	cl = clkdev_alloc(clk, con_id, dev_id);
-	if (cl)
-		clkdev_add(cl);
+	clkdev_create(clk, con_id, "%s", dev_id);
 }
 
 /* Create clkdev entries for all orion platforms except kirkwood.
-- 
1.8.3.1

