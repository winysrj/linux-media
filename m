Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:33772 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753535AbbDCRMz (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 3 Apr 2015 13:12:55 -0400
In-Reply-To: <20150403171149.GC13898@n2100.arm.linux.org.uk>
References: <20150403171149.GC13898@n2100.arm.linux.org.uk>
From: Russell King <rmk+kernel@arm.linux.org.uk>
To: alsa-devel@alsa-project.org, linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-sh@vger.kernel.org
Subject: [PATCH 05/14] clkdev: use clk_hw internally
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1Ye59E-0001BB-7z@rmk-PC.arm.linux.org.uk>
Date: Fri, 03 Apr 2015 18:12:48 +0100
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/clk/clkdev.c   | 24 ++++++++++++++++--------
 include/linux/clkdev.h |  1 +
 2 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/clk/clkdev.c b/drivers/clk/clkdev.c
index 5d7746d19445..8e676eafc823 100644
--- a/drivers/clk/clkdev.c
+++ b/drivers/clk/clkdev.c
@@ -205,7 +205,7 @@ struct clk *clk_get_sys(const char *dev_id, const char *con_id)
 	if (!cl)
 		goto out;
 
-	clk = __clk_create_clk(__clk_get_hw(cl->clk), dev_id, con_id);
+	clk = __clk_create_clk(cl->clk_hw, dev_id, con_id);
 	if (IS_ERR(clk))
 		goto out;
 
@@ -243,18 +243,26 @@ void clk_put(struct clk *clk)
 }
 EXPORT_SYMBOL(clk_put);
 
-void clkdev_add(struct clk_lookup *cl)
+static void __clkdev_add(struct clk_lookup *cl)
 {
 	mutex_lock(&clocks_mutex);
 	list_add_tail(&cl->node, &clocks);
 	mutex_unlock(&clocks_mutex);
 }
+
+void clkdev_add(struct clk_lookup *cl)
+{
+	if (!cl->clk_hw)
+		cl->clk_hw = __clk_get_hw(cl->clk);
+	__clkdev_add(cl);
+}
 EXPORT_SYMBOL(clkdev_add);
 
 void clkdev_add_table(struct clk_lookup *cl, size_t num)
 {
 	mutex_lock(&clocks_mutex);
 	while (num--) {
+		cl->clk_hw = __clk_get_hw(cl->clk);
 		list_add_tail(&cl->node, &clocks);
 		cl++;
 	}
@@ -271,7 +279,7 @@ struct clk_lookup_alloc {
 };
 
 static struct clk_lookup * __init_refok
-vclkdev_alloc(struct clk *clk, const char *con_id, const char *dev_fmt,
+vclkdev_alloc(struct clk_hw *hw, const char *con_id, const char *dev_fmt,
 	va_list ap)
 {
 	struct clk_lookup_alloc *cla;
@@ -280,7 +288,7 @@ vclkdev_alloc(struct clk *clk, const char *con_id, const char *dev_fmt,
 	if (!cla)
 		return NULL;
 
-	cla->cl.clk = clk;
+	cla->cl.clk_hw = hw;
 	if (con_id) {
 		strlcpy(cla->con_id, con_id, sizeof(cla->con_id));
 		cla->cl.con_id = cla->con_id;
@@ -301,7 +309,7 @@ clkdev_alloc(struct clk *clk, const char *con_id, const char *dev_fmt, ...)
 	va_list ap;
 
 	va_start(ap, dev_fmt);
-	cl = vclkdev_alloc(clk, con_id, dev_fmt, ap);
+	cl = vclkdev_alloc(__clk_get_hw(clk), con_id, dev_fmt, ap);
 	va_end(ap);
 
 	return cl;
@@ -362,7 +370,7 @@ int clk_register_clkdev(struct clk *clk, const char *con_id,
 		return PTR_ERR(clk);
 
 	va_start(ap, dev_fmt);
-	cl = vclkdev_alloc(clk, con_id, dev_fmt, ap);
+	cl = vclkdev_alloc(__clk_get_hw(clk), con_id, dev_fmt, ap);
 	va_end(ap);
 
 	if (!cl)
@@ -393,8 +401,8 @@ int clk_register_clkdevs(struct clk *clk, struct clk_lookup *cl, size_t num)
 		return PTR_ERR(clk);
 
 	for (i = 0; i < num; i++, cl++) {
-		cl->clk = clk;
-		clkdev_add(cl);
+		cl->clk_hw = __clk_get_hw(clk);
+		__clkdev_add(cl);
 	}
 
 	return 0;
diff --git a/include/linux/clkdev.h b/include/linux/clkdev.h
index eb9b38a79b43..cd93b215e3af 100644
--- a/include/linux/clkdev.h
+++ b/include/linux/clkdev.h
@@ -22,6 +22,7 @@ struct clk_lookup {
 	const char		*dev_id;
 	const char		*con_id;
 	struct clk		*clk;
+	struct clk_hw		*clk_hw;
 };
 
 #define CLKDEV_INIT(d, n, c)	\
-- 
1.8.3.1

