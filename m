Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43929 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751416AbaLQRTE (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Dec 2014 12:19:04 -0500
From: Hans de Goede <hdegoede@redhat.com>
To: Linus Walleij <linus.walleij@linaro.org>,
	Maxime Ripard <maxime.ripard@free-electrons.com>,
	Lee Jones <lee.jones@linaro.org>,
	Samuel Ortiz <sameo@linux.intel.com>
Cc: Mike Turquette <mturquette@linaro.org>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	devicetree <devicetree@vger.kernel.org>,
	linux-sunxi@googlegroups.com, Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH v2 03/13] ARM: sunxi: Add "allwinner,sun6i-a31s" to mach-sunxi
Date: Wed, 17 Dec 2014 18:18:14 +0100
Message-Id: <1418836704-15689-4-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1418836704-15689-1-git-send-email-hdegoede@redhat.com>
References: <1418836704-15689-1-git-send-email-hdegoede@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

So far the A31s is 100% compatible with the A31, still lets do the same
as what we've done for the A13 / A10s and give it its own compatible string,
in case we need to differentiate later.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 Documentation/arm/sunxi/README | 1 -
 arch/arm/mach-sunxi/platsmp.c  | 3 ++-
 arch/arm/mach-sunxi/sunxi.c    | 1 +
 drivers/clk/sunxi/clk-sunxi.c  | 1 +
 4 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/Documentation/arm/sunxi/README b/Documentation/arm/sunxi/README
index e68d163..1fe2d7f 100644
--- a/Documentation/arm/sunxi/README
+++ b/Documentation/arm/sunxi/README
@@ -50,7 +50,6 @@ SunXi family
           http://dl.linux-sunxi.org/A31/A3x_release_document/A31/IC/A31%20user%20manual%20V1.1%2020130630.pdf
 
       - Allwinner A31s (sun6i)
-        + Not Supported
         + Datasheet
           http://dl.linux-sunxi.org/A31/A3x_release_document/A31s/IC/A31s%20datasheet%20V1.3%2020131106.pdf
         + User Manual
diff --git a/arch/arm/mach-sunxi/platsmp.c b/arch/arm/mach-sunxi/platsmp.c
index e44d028..b1b5b7c 100644
--- a/arch/arm/mach-sunxi/platsmp.c
+++ b/arch/arm/mach-sunxi/platsmp.c
@@ -120,4 +120,5 @@ static struct smp_operations sun6i_smp_ops __initdata = {
 	.smp_prepare_cpus	= sun6i_smp_prepare_cpus,
 	.smp_boot_secondary	= sun6i_smp_boot_secondary,
 };
-CPU_METHOD_OF_DECLARE(sun6i_smp, "allwinner,sun6i-a31", &sun6i_smp_ops);
+CPU_METHOD_OF_DECLARE(sun6i_a31_smp, "allwinner,sun6i-a31", &sun6i_smp_ops);
+CPU_METHOD_OF_DECLARE(sun6i_a31s_smp, "allwinner,sun6i-a31s", &sun6i_smp_ops);
diff --git a/arch/arm/mach-sunxi/sunxi.c b/arch/arm/mach-sunxi/sunxi.c
index 1f98675..d4bb239 100644
--- a/arch/arm/mach-sunxi/sunxi.c
+++ b/arch/arm/mach-sunxi/sunxi.c
@@ -29,6 +29,7 @@ MACHINE_END
 
 static const char * const sun6i_board_dt_compat[] = {
 	"allwinner,sun6i-a31",
+	"allwinner,sun6i-a31s",
 	NULL,
 };
 
diff --git a/drivers/clk/sunxi/clk-sunxi.c b/drivers/clk/sunxi/clk-sunxi.c
index a9d10b9..ee9d7f2 100644
--- a/drivers/clk/sunxi/clk-sunxi.c
+++ b/drivers/clk/sunxi/clk-sunxi.c
@@ -1235,6 +1235,7 @@ static void __init sun6i_init_clocks(struct device_node *node)
 			  ARRAY_SIZE(sun6i_critical_clocks));
 }
 CLK_OF_DECLARE(sun6i_a31_clk_init, "allwinner,sun6i-a31", sun6i_init_clocks);
+CLK_OF_DECLARE(sun6i_a31s_clk_init, "allwinner,sun6i-a31s", sun6i_init_clocks);
 CLK_OF_DECLARE(sun8i_a23_clk_init, "allwinner,sun8i-a23", sun6i_init_clocks);
 
 static void __init sun9i_init_clocks(struct device_node *node)
-- 
2.1.0

