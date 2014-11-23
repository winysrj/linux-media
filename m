Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56367 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751116AbaKWNiu (ORCPT <rfc822;linux-media@vger.kernel.org>);
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
Subject: [PATCH v2 2/9] clk: sunxi: Make sun4i_a10_mod0_data available outside of clk-mod0.c
Date: Sun, 23 Nov 2014 14:38:08 +0100
Message-Id: <1416749895-25013-3-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1416749895-25013-1-git-send-email-hdegoede@redhat.com>
References: <1416749895-25013-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The sun6i prcm has mod0 compatible clocks, these need a separate driver
because the prcm uses the mfd framework, but we do want to re-use the
standard mod0 clk handling from clk-mod0.c for this, export
sun4i_a10_mod0_data, so that the prcm mod0 clk driver can use this.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/clk/sunxi/clk-mod0.c | 2 +-
 drivers/clk/sunxi/clk-mod0.h | 8 ++++++++
 2 files changed, 9 insertions(+), 1 deletion(-)
 create mode 100644 drivers/clk/sunxi/clk-mod0.h

diff --git a/drivers/clk/sunxi/clk-mod0.c b/drivers/clk/sunxi/clk-mod0.c
index 5fb1f7e..7c06d42 100644
--- a/drivers/clk/sunxi/clk-mod0.c
+++ b/drivers/clk/sunxi/clk-mod0.c
@@ -67,7 +67,7 @@ static struct clk_factors_config sun4i_a10_mod0_config = {
 	.pwidth = 2,
 };
 
-static const struct factors_data sun4i_a10_mod0_data __initconst = {
+const struct factors_data sun4i_a10_mod0_data = {
 	.enable = 31,
 	.mux = 24,
 	.table = &sun4i_a10_mod0_config,
diff --git a/drivers/clk/sunxi/clk-mod0.h b/drivers/clk/sunxi/clk-mod0.h
new file mode 100644
index 0000000..49aa9ab
--- /dev/null
+++ b/drivers/clk/sunxi/clk-mod0.h
@@ -0,0 +1,8 @@
+#ifndef __MACH_SUNXI_CLK_MOD0_H
+#define __MACH_SUNXI_CLK_MOD0_H
+
+#include "clk-factors.h"
+
+extern const struct factors_data sun4i_a10_mod0_data;
+
+#endif
-- 
2.1.0

