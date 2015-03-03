Return-path: <linux-media-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:36807 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755666AbbCCKZe (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Mar 2015 05:25:34 -0500
Date: Tue, 3 Mar 2015 11:25:19 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: alsa-devel@alsa-project.org, linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-sh@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
	Jason Cooper <jason@lakedaemon.net>,
	Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH 08/10] ARM: orion: use clkdev_create()
Message-ID: <20150303112519.557f43ad@free-electrons.com>
In-Reply-To: <E1YSTnm-0001Jx-AM@rmk-PC.arm.linux.org.uk>
References: <20150302170538.GQ8656@n2100.arm.linux.org.uk>
	<E1YSTnm-0001Jx-AM@rmk-PC.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dear Russell King,

On Mon, 02 Mar 2015 17:06:42 +0000, Russell King wrote:
> clkdev_create() is a shorter way to write clkdev_alloc() followed by
> clkdev_add().  Use this instead.
> 
> Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
> ---
>  arch/arm/plat-orion/common.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/arch/arm/plat-orion/common.c b/arch/arm/plat-orion/common.c
> index f5b00f41c4f6..2235081a04ee 100644
> --- a/arch/arm/plat-orion/common.c
> +++ b/arch/arm/plat-orion/common.c
> @@ -28,11 +28,7 @@
>  void __init orion_clkdev_add(const char *con_id, const char *dev_id,
>  			     struct clk *clk)
>  {
> -	struct clk_lookup *cl;
> -
> -	cl = clkdev_alloc(clk, con_id, dev_id);
> -	if (cl)
> -		clkdev_add(cl);
> +	clkdev_create(clk, con_id, "%s", dev_id);
>  }
>  
>  /* Create clkdev entries for all orion platforms except kirkwood.

Looks good, but instead of having orion_clkdev_add() being just an
alias for clkdev_create(), what about going ahead and simply reoving
orion_clkdev_add() entirely? Something like the below patch (not even
compile tested) :

diff --git a/arch/arm/mach-dove/common.c b/arch/arm/mach-dove/common.c
index 0d1a892..ec00183 100644
--- a/arch/arm/mach-dove/common.c
+++ b/arch/arm/mach-dove/common.c
@@ -109,28 +109,28 @@ static void __init dove_clk_init(void)
 	gephy = dove_register_gate("gephy", "tclk", CLOCK_GATING_BIT_GIGA_PHY);
 	ge = dove_register_gate("ge", "gephy", CLOCK_GATING_BIT_GBE);
 
-	orion_clkdev_add(NULL, "orion_spi.0", tclk);
-	orion_clkdev_add(NULL, "orion_spi.1", tclk);
-	orion_clkdev_add(NULL, "orion_wdt", tclk);
-	orion_clkdev_add(NULL, "mv64xxx_i2c.0", tclk);
-
-	orion_clkdev_add(NULL, "orion-ehci.0", usb0);
-	orion_clkdev_add(NULL, "orion-ehci.1", usb1);
-	orion_clkdev_add(NULL, "mv643xx_eth_port.0", ge);
-	orion_clkdev_add(NULL, "sata_mv.0", sata);
-	orion_clkdev_add("0", "pcie", pex0);
-	orion_clkdev_add("1", "pcie", pex1);
-	orion_clkdev_add(NULL, "sdhci-dove.0", sdio0);
-	orion_clkdev_add(NULL, "sdhci-dove.1", sdio1);
-	orion_clkdev_add(NULL, "orion_nand", nand);
-	orion_clkdev_add(NULL, "cafe1000-ccic.0", camera);
-	orion_clkdev_add(NULL, "mvebu-audio.0", i2s0);
-	orion_clkdev_add(NULL, "mvebu-audio.1", i2s1);
-	orion_clkdev_add(NULL, "mv_crypto", crypto);
-	orion_clkdev_add(NULL, "dove-ac97", ac97);
-	orion_clkdev_add(NULL, "dove-pdma", pdma);
-	orion_clkdev_add(NULL, MV_XOR_NAME ".0", xor0);
-	orion_clkdev_add(NULL, MV_XOR_NAME ".1", xor1);
+	clkdev_create(tclk, NULL, "%s", "orion_spi.0");
+	clkdev_create(tclk, NULL, "%s", "orion_spi.1");
+	clkdev_create(tclk, NULL, "%s", "orion_wdt");
+	clkdev_create(tclk, NULL, "%s", "mv64xxx_i2c.0");
+
+	clkdev_create(usb0, NULL, "%s", "orion-ehci.0");
+	clkdev_create(usb1, NULL, "%s", "orion-ehci.1");
+	clkdev_create(ge, NULL, "%s", "mv643xx_eth_port.0");
+	clkdev_create(sata, NULL, "%s", "sata_mv.0");
+	clkdev_create(pex0, "0", "%s", "pcie");
+	clkdev_create(pex1, "1", "%s", "pcie");
+	clkdev_create(sdio0, NULL, "%s", "sdhci-dove.0");
+	clkdev_create(sdio1, NULL, "%s", "sdhci-dove.1");
+	clkdev_create(nand, NULL, "%s", "orion_nand");
+	clkdev_create(camera, NULL, "%s", "cafe1000-ccic.0");
+	clkdev_create(i2s0, NULL, "%s", "mvebu-audio.0");
+	clkdev_create(i2s1, NULL, "%s", "mvebu-audio.1");
+	clkdev_create(crypto, NULL, "%s", "mv_crypto");
+	clkdev_create(ac97, NULL, "%s", "dove-ac97");
+	clkdev_create(pdma, NULL, "%s", "dove-pdma");
+	clkdev_create(xor0, NULL, "%s", MV_XOR_NAME ".0");
+	clkdev_create(xor1, NULL, "%s", MV_XOR_NAME ".1");
 }
 
 /*****************************************************************************
diff --git a/arch/arm/plat-orion/common.c b/arch/arm/plat-orion/common.c
index f5b00f4..6ac3549 100644
--- a/arch/arm/plat-orion/common.c
+++ b/arch/arm/plat-orion/common.c
@@ -24,31 +24,20 @@
 #include <mach/bridge-regs.h>
 #include <plat/common.h>
 
-/* Create a clkdev entry for a given device/clk */
-void __init orion_clkdev_add(const char *con_id, const char *dev_id,
-			     struct clk *clk)
-{
-	struct clk_lookup *cl;
-
-	cl = clkdev_alloc(clk, con_id, dev_id);
-	if (cl)
-		clkdev_add(cl);
-}
-
 /* Create clkdev entries for all orion platforms except kirkwood.
    Kirkwood has gated clocks for some of its peripherals, so creates
    its own clkdev entries. For all the other orion devices, create
    clkdev entries to the tclk. */
 void __init orion_clkdev_init(struct clk *tclk)
 {
-	orion_clkdev_add(NULL, "orion_spi.0", tclk);
-	orion_clkdev_add(NULL, "orion_spi.1", tclk);
-	orion_clkdev_add(NULL, MV643XX_ETH_NAME ".0", tclk);
-	orion_clkdev_add(NULL, MV643XX_ETH_NAME ".1", tclk);
-	orion_clkdev_add(NULL, MV643XX_ETH_NAME ".2", tclk);
-	orion_clkdev_add(NULL, MV643XX_ETH_NAME ".3", tclk);
-	orion_clkdev_add(NULL, "orion_wdt", tclk);
-	orion_clkdev_add(NULL, MV64XXX_I2C_CTLR_NAME ".0", tclk);
+	clkdev_create(tclk, NULL, "%s", "orion_spi.0");
+	clkdev_create(tclk, NULL, "%s", "orion_spi.1");
+	clkdev_create(tclk, NULL, "%s", MV643XX_ETH_NAME ".0");
+	clkdev_create(tclk, NULL, "%s", MV643XX_ETH_NAME ".1");
+	clkdev_create(tclk, NULL, "%s", MV643XX_ETH_NAME ".2");
+	clkdev_create(tclk, NULL, "%s", MV643XX_ETH_NAME ".3");
+	clkdev_create(tclk, NULL, "%s", "orion_wdt");
+	clkdev_create(tclk, NULL, "%s", MV64XXX_I2C_CTLR_NAME ".0");
 }
 
 /* Fill in the resources structure and link it into the platform
diff --git a/arch/arm/plat-orion/include/plat/common.h b/arch/arm/plat-orion/include/plat/common.h
index d9a24f6..7a06b6b 100644
--- a/arch/arm/plat-orion/include/plat/common.h
+++ b/arch/arm/plat-orion/include/plat/common.h
@@ -106,8 +106,5 @@ void __init orion_crypto_init(unsigned long mapbase,
 			      unsigned long sram_size,
 			      unsigned long irq);
 
-void __init orion_clkdev_add(const char *con_id, const char *dev_id,
-			     struct clk *clk);
-
 void __init orion_clkdev_init(struct clk *tclk);
 #endif



-- 
Thomas Petazzoni, CTO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
