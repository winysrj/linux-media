Return-path: <linux-media-owner@vger.kernel.org>
Received: from pmta2.delivery9.ore.mailhop.org ([54.148.30.215]:60782 "EHLO
	pmta2.delivery9.ore.mailhop.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755479AbbCCBTT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 2 Mar 2015 20:19:19 -0500
Date: Mon, 2 Mar 2015 16:13:42 -0800
From: Tony Lindgren <tony@atomide.com>
To: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: alsa-devel@alsa-project.org, linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	linux-sh@vger.kernel.org
Subject: Re: [PATCH 10/10] ARM: omap2: use clkdev_add_alias()
Message-ID: <20150303001341.GD3756@atomide.com>
References: <20150302170538.GQ8656@n2100.arm.linux.org.uk>
 <E1YSTnw-0001K5-IQ@rmk-PC.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <E1YSTnw-0001K5-IQ@rmk-PC.arm.linux.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

* Russell King <rmk+kernel@arm.linux.org.uk> [150302 09:10]:
> When creating aliases of existing clkdev clocks, use clkdev_add_alias()
> isntead of open coding the lookup and clk_lookup creation.

Gave this series a quick try but I get these build errors:

arch/arm/mach-omap2/omap_device.c: In function ‘_add_clkdev’:
arch/arm/mach-omap2/omap_device.c:65:58: warning: passing argument 3 of ‘clk_add_alias’ discards ‘const’ qualifier from pointer target type
  rc = clk_add_alias(clk_alias, dev_name(&od->pdev->dev), clk_name, NULL);
                                                          ^
In file included from arch/arm/mach-omap2/omap_device.c:34:0:
include/linux/clkdev.h:44:5: note: expected ‘char *’ but argument is of type ‘const char *’
 int clk_add_alias(const char *, const char *, char *, struct device *);
     ^
drivers/clk/clkdev.c:298:16: error: expected declaration specifiers or ‘...’ before ‘(’ token
 vclkdev_create((struct clk *clk, const char *con_id, const char *dev_fmt,
                ^
drivers/clk/clkdev.c:322:92: error: storage class specified for parameter ‘__crc_clkdev_alloc’
 EXPORT_SYMBOL(clkdev_alloc);
                                                                                            ^
drivers/clk/clkdev.c:322:1: warning: ‘weak’ attribute ignored [-Wattributes]
 EXPORT_SYMBOL(clkdev_alloc);
 ^
drivers/clk/clkdev.c:322:1: warning: ‘externally_visible’ attribute ignored [-Wattributes]
drivers/clk/clkdev.c:322:161: error: storage class specified for parameter ‘__kcrctab_clkdev_alloc’
 EXPORT_SYMBOL(clkdev_alloc);
                                                                                                                                                                 ^
drivers/clk/clkdev.c:322:1: warning: ‘__used__’ attribute ignored [-Wattributes]
 EXPORT_SYMBOL(clkdev_alloc);
 ^
drivers/clk/clkdev.c:322:161: error: section attribute not allowed for ‘__kcrctab_clkdev_alloc’
 EXPORT_SYMBOL(clkdev_alloc);
                                                                                                                                                                 ^
drivers/clk/clkdev.c:322:279: error: expected ‘;’, ‘,’ or ‘)’ before ‘=’ token
 EXPORT_SYMBOL(clkdev_alloc);

drivers/clk/clkdev.c:274:1: warning: ‘vclkdev_alloc’ defined but not used [-Wunused-function]
 vclkdev_alloc(struct clk *clk, const char *con_id, const char *dev_fmt,

Regards,

Tony
