Return-path: <linux-media-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:45380 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755134AbbCBRGg (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Mar 2015 12:06:36 -0500
In-Reply-To: <20150302170538.GQ8656@n2100.arm.linux.org.uk>
References: <20150302170538.GQ8656@n2100.arm.linux.org.uk>
From: Russell King <rmk+kernel@arm.linux.org.uk>
To: alsa-devel@alsa-project.org, linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-sh@vger.kernel.org
Subject: [PATCH 05/10] clkdev: add clkdev_create() helper
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1YSTnW-0001Jk-Tm@rmk-PC.arm.linux.org.uk>
Date: Mon, 02 Mar 2015 17:06:26 +0000
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a helper to allocate and add a clk_lookup structure.  This can not
only be used in several places in clkdev.c to simplify the code, but
more importantly, can be used by callers of the clkdev code to simplify
their clkdev creation and registration.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/clk/clkdev.c   | 52 ++++++++++++++++++++++++++++++++++++++------------
 include/linux/clkdev.h |  3 +++
 2 files changed, 43 insertions(+), 12 deletions(-)

diff --git a/drivers/clk/clkdev.c b/drivers/clk/clkdev.c
index 043fd3633373..611b9acbad78 100644
--- a/drivers/clk/clkdev.c
+++ b/drivers/clk/clkdev.c
@@ -294,6 +294,19 @@ vclkdev_alloc(struct clk *clk, const char *con_id, const char *dev_fmt,
 	return &cla->cl;
 }
 
+static struct clk_lookup *
+vclkdev_create((struct clk *clk, const char *con_id, const char *dev_fmt,
+	va_list ap)
+{
+	struct clk_lookup *cl;
+
+	cl = vclkdev_alloc(clk, con_id, dev_fmt, ap);
+	if (cl)
+		clkdev_add(cl);
+
+	return cl;
+}
+
 struct clk_lookup * __init_refok
 clkdev_alloc(struct clk *clk, const char *con_id, const char *dev_fmt, ...)
 {
@@ -308,6 +321,28 @@ clkdev_alloc(struct clk *clk, const char *con_id, const char *dev_fmt, ...)
 }
 EXPORT_SYMBOL(clkdev_alloc);
 
+/**
+ * clkdev_create - allocate and add a clkdev lookup structure
+ * @clk: struct clk to associate with all clk_lookups
+ * @con_id: connection ID string on device
+ * @dev_fmt: format string describing device name
+ *
+ * Returns a clk_lookup structure, which can be later unregistered and
+ * freed.
+ */
+struct clk_lookup *clkdev_create(struct clk *clk, const char *con_id,
+	const char *dev_fmt, ...)
+{
+	struct clk_lookup *cl;
+	va_list ap;
+
+	va_start(ap, dev_fmt);
+	cl = vclkdev_create(clk, con_id, dev_fmt, ap);
+	va_end(ap);
+
+	return cl;
+}
+
 int clk_add_alias(const char *alias, const char *alias_dev_name, char *id,
 	struct device *dev)
 {
@@ -317,12 +352,10 @@ int clk_add_alias(const char *alias, const char *alias_dev_name, char *id,
 	if (IS_ERR(r))
 		return PTR_ERR(r);
 
-	l = clkdev_alloc(r, alias, alias_dev_name);
+	l = vclkdev_create(r, alias, "%s", alias_dev_name);
 	clk_put(r);
-	if (!l)
-		return -ENODEV;
-	clkdev_add(l);
-	return 0;
+
+	return l ? 0 : -ENODEV;
 }
 EXPORT_SYMBOL(clk_add_alias);
 
@@ -362,15 +395,10 @@ int clk_register_clkdev(struct clk *clk, const char *con_id,
 		return PTR_ERR(clk);
 
 	va_start(ap, dev_fmt);
-	cl = vclkdev_alloc(clk, con_id, dev_fmt, ap);
+	cl = vclkdev_create(clk, con_id, dev_fmt, ap);
 	va_end(ap);
 
-	if (!cl)
-		return -ENOMEM;
-
-	clkdev_add(cl);
-
-	return 0;
+	return cl ? 0 : -ENOMEM;
 }
 EXPORT_SYMBOL(clk_register_clkdev);
 
diff --git a/include/linux/clkdev.h b/include/linux/clkdev.h
index 94bad77eeb4a..6f32f6d8b6ee 100644
--- a/include/linux/clkdev.h
+++ b/include/linux/clkdev.h
@@ -37,6 +37,9 @@ struct clk_lookup *clkdev_alloc(struct clk *clk, const char *con_id,
 void clkdev_add(struct clk_lookup *cl);
 void clkdev_drop(struct clk_lookup *cl);
 
+struct clk_lookup *clkdev_create(struct clk *clk, const char *con_id,
+	const char *dev_fmt, ...);
+
 void clkdev_add_table(struct clk_lookup *, size_t);
 int clk_add_alias(const char *, const char *, char *, struct device *);
 
-- 
1.8.3.1

