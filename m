Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w2.samsung.com ([211.189.100.14]:34937 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757026AbaIIPhE (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Sep 2014 11:37:04 -0400
Date: Tue, 09 Sep 2014 12:36:54 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Tony Lindgren <tony@atomide.com>,
	Vinod Koul <vinod.koul@intel.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Peter Griffin <peter.griffin@linaro.org>,
	Balaji T K <balajitk@ti.com>, Nishanth Menon <nm@ti.com>,
	linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
	Tony Lindgren <tony@atomide.com>,
	linux-omap <linux-omap@vger.kernel.org>
Subject: Re: [PATCH 1/3] omap-dma: Allow compile-testing omap1_camera driver
Message-id: <20140909123654.37d60f38.m.chehab@samsung.com>
In-reply-to: <20140909144157.GF12361@n2100.arm.linux.org.uk>
References: <20140909124306.2d5a0d76@canb.auug.org.au>
 <6cbd00c5f2d342b573aaf9c0e533778374dd2e1e.1410273306.git.m.chehab@samsung.com>
 <20140909144157.GF12361@n2100.arm.linux.org.uk>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 9 Sep 2014 15:41:58 +0100
Russell King - ARM Linux <linux@arm.linux.org.uk> escreveu:

> On Tue, Sep 09, 2014 at 11:38:17AM -0300, Mauro Carvalho Chehab wrote:
> > We want to be able to COMPILE_TEST the omap1_camera driver.
> > It compiles fine, but it fails linkediting:
> > 
> > ERROR: "omap_stop_dma" [drivers/media/platform/soc_camera/omap1_camera.ko] undefined!
> > ERROR: "omap_start_dma" [drivers/media/platform/soc_camera/omap1_camera.ko] undefined!
> > ERROR: "omap_dma_link_lch" [drivers/media/platform/soc_camera/omap1_camera.ko] undefined!
> > ERROR: "omap_set_dma_dest_burst_mode" [drivers/media/platform/soc_camera/omap1_camera.ko] undefined!
> > ERROR: "omap_set_dma_src_params" [drivers/media/platform/soc_camera/omap1_camera.ko] undefined!
> > ERROR: "omap_request_dma" [drivers/media/platform/soc_camera/omap1_camera.ko] undefined!
> > ERROR: "omap_set_dma_transfer_params" [drivers/media/platform/soc_camera/omap1_camera.ko] undefined!
> > ERROR: "omap_set_dma_dest_params" [drivers/media/platform/soc_camera/omap1_camera.ko] undefined!
> > ERROR: "omap_free_dma" [drivers/media/platform/soc_camera/omap1_camera.ko] undefined!
> > 
> > So, add some stub functions to avoid it.
> 
> The real answer to this is to find someone who still uses it, and convert
> it to the DMA engine API.  If there's no users, the driver might as well
> be killed off.

Hmm... it seems that there are still several drivers still relying on
the functions declared at: omap-dma.h:

$ grep extern include/linux/omap-dma.h |perl -ne 'print "$1\n" if (m/extern\s\S+\s(.*)\(/)' >funcs && git grep -f funcs -l
arch/arm/mach-omap1/pm.c
arch/arm/mach-omap2/pm24xx.c
arch/arm/plat-omap/dma.c
drivers/dma/omap-dma.c
drivers/media/platform/omap/omap_vout_vrfb.c
drivers/media/platform/omap3isp/isphist.c
drivers/media/platform/soc_camera/omap1_camera.c
drivers/mtd/onenand/omap2.c
drivers/usb/gadget/udc/omap_udc.c
drivers/usb/musb/tusb6010_omap.c
drivers/video/fbdev/omap/omapfb_main.c
include/linux/omap-dma.h

Perhaps we can remove the header and mark all the above as BROKEN.

If nobody fixes, we can strip all of them from the Kernel.

Regards,
Mauro
