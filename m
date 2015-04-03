Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:33756 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240AbbDCRMh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Apr 2015 13:12:37 -0400
In-Reply-To: <20150403171149.GC13898@n2100.arm.linux.org.uk>
References: <20150403171149.GC13898@n2100.arm.linux.org.uk>
From: Russell King <rmk+kernel@arm.linux.org.uk>
To: alsa-devel@alsa-project.org, linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-sh@vger.kernel.org
Subject: [PATCH 02/14] clkdev: drop __init from clkdev_add_table()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1Ye58y-0001Ax-Qy@rmk-PC.arm.linux.org.uk>
Date: Fri, 03 Apr 2015 18:12:32 +0100
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

We want to be able to call clkdev_add_table() from non-init code, so we
need to drop the __init marker from it.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/clk/clkdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/clkdev.c b/drivers/clk/clkdev.c
index 043fd3633373..156f2e2f972c 100644
--- a/drivers/clk/clkdev.c
+++ b/drivers/clk/clkdev.c
@@ -251,7 +251,7 @@ void clkdev_add(struct clk_lookup *cl)
 }
 EXPORT_SYMBOL(clkdev_add);
 
-void __init clkdev_add_table(struct clk_lookup *cl, size_t num)
+void clkdev_add_table(struct clk_lookup *cl, size_t num)
 {
 	mutex_lock(&clocks_mutex);
 	while (num--) {
-- 
1.8.3.1

