Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56190 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756862AbaKTP4G (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 20 Nov 2014 10:56:06 -0500
From: Hans de Goede <hdegoede@redhat.com>
To: Emilio Lopez <emilio@elopez.com.ar>,
	Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Mike Turquette <mturquette@linaro.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	devicetree <devicetree@vger.kernel.org>,
	linux-sunxi@googlegroups.com, Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 2/9] clk: sunxi: Make sun4i_a10_mod0_data available outside of clk-mod0.c
Date: Thu, 20 Nov 2014 16:55:21 +0100
Message-Id: <1416498928-1300-3-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1416498928-1300-1-git-send-email-hdegoede@redhat.com>
References: <1416498928-1300-1-git-send-email-hdegoede@redhat.com>
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
index 9530833..0989502 100644
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

