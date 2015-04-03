Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:33767 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753600AbbDCRMu (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Apr 2015 13:12:50 -0400
In-Reply-To: <20150403171149.GC13898@n2100.arm.linux.org.uk>
References: <20150403171149.GC13898@n2100.arm.linux.org.uk>
From: Russell King <rmk+kernel@arm.linux.org.uk>
To: alsa-devel@alsa-project.org, linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-sh@vger.kernel.org
Subject: [PATCH 04/14] clkdev: const-ify connection id to clk_add_alias()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1Ye599-0001B5-4B@rmk-PC.arm.linux.org.uk>
Date: Fri, 03 Apr 2015 18:12:43 +0100
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The connection id is only passed to clk_get() which is already const.
Const-ify this argument too.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/clk/clkdev.c   | 6 +++---
 include/linux/clkdev.h | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/clkdev.c b/drivers/clk/clkdev.c
index 156f2e2f972c..5d7746d19445 100644
--- a/drivers/clk/clkdev.c
+++ b/drivers/clk/clkdev.c
@@ -308,10 +308,10 @@ clkdev_alloc(struct clk *clk, const char *con_id, const char *dev_fmt, ...)
 }
 EXPORT_SYMBOL(clkdev_alloc);
 
-int clk_add_alias(const char *alias, const char *alias_dev_name, char *id,
-	struct device *dev)
+int clk_add_alias(const char *alias, const char *alias_dev_name,
+	const char *con_id, struct device *dev)
 {
-	struct clk *r = clk_get(dev, id);
+	struct clk *r = clk_get(dev, con_id);
 	struct clk_lookup *l;
 
 	if (IS_ERR(r))
diff --git a/include/linux/clkdev.h b/include/linux/clkdev.h
index 94bad77eeb4a..eb9b38a79b43 100644
--- a/include/linux/clkdev.h
+++ b/include/linux/clkdev.h
@@ -38,7 +38,7 @@ void clkdev_add(struct clk_lookup *cl);
 void clkdev_drop(struct clk_lookup *cl);
 
 void clkdev_add_table(struct clk_lookup *, size_t);
-int clk_add_alias(const char *, const char *, char *, struct device *);
+int clk_add_alias(const char *, const char *, const char *, struct device *);
 
 int clk_register_clkdev(struct clk *, const char *, const char *, ...);
 int clk_register_clkdevs(struct clk *, struct clk_lookup *, size_t);
-- 
1.8.3.1

