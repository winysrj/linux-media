Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47335 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751143AbaKWNiu (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 23 Nov 2014 08:38:50 -0500
From: Hans de Goede <hdegoede@redhat.com>
To: Emilio Lopez <emilio@elopez.com.ar>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	Mike Turquette <mturquette@linaro.org>,
	Lee Jones <lee.jones@linaro.org>,
	Samuel Ortiz <sameo@linux.intel.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	devicetree <devicetree@vger.kernel.org>,
	linux-sunxi@googlegroups.com, Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH v2 1/9] clk: sunxi: Give sunxi_factors_register a registers parameter
Date: Sun, 23 Nov 2014 14:38:07 +0100
Message-Id: <1416749895-25013-2-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1416749895-25013-1-git-send-email-hdegoede@redhat.com>
References: <1416749895-25013-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Before this commit sunxi_factors_register uses of_iomap(node, 0) to get
the clk registers. The sun6i prcm has factor clocks, for which we want to
use sunxi_factors_register, but of_iomap(node, 0) does not work for the prcm
factor clocks, because the prcm uses the mfd framework, so the registers
are not part of the dt-node, instead they are added to the platform_device,
as platform_device resources.

This commit makes getting the registers the callers duty, so that
sunxi_factors_register can be used with mfd instantiated platform device too.

While at it also add error checking to the of_iomap calls.

This commit also drops the __init function from sunxi_factors_register since
platform driver probe functions are not __init.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/clk/sunxi/clk-factors.c    | 10 ++++------
 drivers/clk/sunxi/clk-factors.h    |  7 ++++---
 drivers/clk/sunxi/clk-mod0.c       | 24 ++++++++++++++++++++++--
 drivers/clk/sunxi/clk-sun8i-mbus.c | 13 +++++++++++--
 drivers/clk/sunxi/clk-sunxi.c      | 11 ++++++++++-
 5 files changed, 51 insertions(+), 14 deletions(-)

diff --git a/drivers/clk/sunxi/clk-factors.c b/drivers/clk/sunxi/clk-factors.c
index f83ba09..fc4f4b5 100644
--- a/drivers/clk/sunxi/clk-factors.c
+++ b/drivers/clk/sunxi/clk-factors.c
@@ -156,9 +156,10 @@ static const struct clk_ops clk_factors_ops = {
 	.set_rate = clk_factors_set_rate,
 };
 
-struct clk * __init sunxi_factors_register(struct device_node *node,
-					   const struct factors_data *data,
-					   spinlock_t *lock)
+struct clk *sunxi_factors_register(struct device_node *node,
+				   const struct factors_data *data,
+				   spinlock_t *lock,
+				   void __iomem *reg)
 {
 	struct clk *clk;
 	struct clk_factors *factors;
@@ -168,11 +169,8 @@ struct clk * __init sunxi_factors_register(struct device_node *node,
 	struct clk_hw *mux_hw = NULL;
 	const char *clk_name = node->name;
 	const char *parents[FACTORS_MAX_PARENTS];
-	void __iomem *reg;
 	int i = 0;
 
-	reg = of_iomap(node, 0);
-
 	/* if we have a mux, we will have >1 parents */
 	while (i < FACTORS_MAX_PARENTS &&
 	       (parents[i] = of_clk_get_parent_name(node, i)) != NULL)
diff --git a/drivers/clk/sunxi/clk-factors.h b/drivers/clk/sunxi/clk-factors.h
index 9913840..1f5526d 100644
--- a/drivers/clk/sunxi/clk-factors.h
+++ b/drivers/clk/sunxi/clk-factors.h
@@ -37,8 +37,9 @@ struct clk_factors {
 	spinlock_t *lock;
 };
 
-struct clk * __init sunxi_factors_register(struct device_node *node,
-					   const struct factors_data *data,
-					   spinlock_t *lock);
+struct clk *sunxi_factors_register(struct device_node *node,
+				   const struct factors_data *data,
+				   spinlock_t *lock,
+				   void __iomem *reg);
 
 #endif
diff --git a/drivers/clk/sunxi/clk-mod0.c b/drivers/clk/sunxi/clk-mod0.c
index 4a56385..5fb1f7e 100644
--- a/drivers/clk/sunxi/clk-mod0.c
+++ b/drivers/clk/sunxi/clk-mod0.c
@@ -78,7 +78,17 @@ static DEFINE_SPINLOCK(sun4i_a10_mod0_lock);
 
 static void __init sun4i_a10_mod0_setup(struct device_node *node)
 {
-	sunxi_factors_register(node, &sun4i_a10_mod0_data, &sun4i_a10_mod0_lock);
+	void __iomem *reg;
+
+	reg = of_iomap(node, 0);
+	if (!reg) {
+		pr_err("Could not get registers for mod0-clk: %s\n",
+		       node->name);
+		return;
+	}
+
+	sunxi_factors_register(node, &sun4i_a10_mod0_data,
+			       &sun4i_a10_mod0_lock, reg);
 }
 CLK_OF_DECLARE(sun4i_a10_mod0, "allwinner,sun4i-a10-mod0-clk", sun4i_a10_mod0_setup);
 
@@ -86,7 +96,17 @@ static DEFINE_SPINLOCK(sun5i_a13_mbus_lock);
 
 static void __init sun5i_a13_mbus_setup(struct device_node *node)
 {
-	struct clk *mbus = sunxi_factors_register(node, &sun4i_a10_mod0_data, &sun5i_a13_mbus_lock);
+	struct clk *mbus;
+	void __iomem *reg;
+
+	reg = of_iomap(node, 0);
+	if (!reg) {
+		pr_err("Could not get registers for a13-mbus-clk\n");
+		return;
+	}
+
+	mbus = sunxi_factors_register(node, &sun4i_a10_mod0_data,
+				      &sun5i_a13_mbus_lock, reg);
 
 	/* The MBUS clocks needs to be always enabled */
 	__clk_get(mbus);
diff --git a/drivers/clk/sunxi/clk-sun8i-mbus.c b/drivers/clk/sunxi/clk-sun8i-mbus.c
index 8e49b44..c0629ff 100644
--- a/drivers/clk/sunxi/clk-sun8i-mbus.c
+++ b/drivers/clk/sunxi/clk-sun8i-mbus.c
@@ -68,8 +68,17 @@ static DEFINE_SPINLOCK(sun8i_a23_mbus_lock);
 
 static void __init sun8i_a23_mbus_setup(struct device_node *node)
 {
-	struct clk *mbus = sunxi_factors_register(node, &sun8i_a23_mbus_data,
-						  &sun8i_a23_mbus_lock);
+	struct clk *mbus;
+	void __iomem *reg;
+
+	reg = of_iomap(node, 0);
+	if (!reg) {
+		pr_err("Could not get registers for a23-mbus-clk\n");
+		return;
+	}
+
+	mbus = sunxi_factors_register(node, &sun8i_a23_mbus_data,
+				      &sun8i_a23_mbus_lock, reg);
 
 	/* The MBUS clocks needs to be always enabled */
 	__clk_get(mbus);
diff --git a/drivers/clk/sunxi/clk-sunxi.c b/drivers/clk/sunxi/clk-sunxi.c
index b1f66ad..6062a3e 100644
--- a/drivers/clk/sunxi/clk-sunxi.c
+++ b/drivers/clk/sunxi/clk-sunxi.c
@@ -521,7 +521,16 @@ static const struct factors_data sun7i_a20_out_data __initconst = {
 static struct clk * __init sunxi_factors_clk_setup(struct device_node *node,
 						   const struct factors_data *data)
 {
-	return sunxi_factors_register(node, data, &clk_lock);
+	void __iomem *reg;
+
+	reg = of_iomap(node, 0);
+	if (!reg) {
+		pr_err("Could not get registers for factors-clk: %s\n",
+		       node->name);
+		return NULL;
+	}
+
+	return sunxi_factors_register(node, data, &clk_lock, reg);
 }
 
 
-- 
2.1.0

