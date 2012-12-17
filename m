Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59863 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448Ab2LQJhU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Dec 2012 04:37:20 -0500
Date: Mon, 17 Dec 2012 10:37:14 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Fabio Estevam <fabio.estevam@freescale.com>
Cc: mchehab@infradead.org, kernel@pengutronix.de,
	p.zabel@pengutronix.de, javier.martin@vista-silicon.com,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [media] coda: Fix build due to iram.h rename
Message-ID: <20121217093714.GI26326@pengutronix.de>
References: <1352898282-21576-1-git-send-email-fabio.estevam@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352898282-21576-1-git-send-email-fabio.estevam@freescale.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Nov 14, 2012 at 11:04:42AM -0200, Fabio Estevam wrote:
> commit c045e3f13 (ARM: imx: include iram.h rather than mach/iram.h) changed the
> location of iram.h, which causes the following build error when building the coda
> driver:
> 
> drivers/media/platform/coda.c:27:23: error: mach/iram.h: No such file or directory
> drivers/media/platform/coda.c: In function 'coda_probe':
> drivers/media/platform/coda.c:2000: error: implicit declaration of function 'iram_alloc'
> drivers/media/platform/coda.c:2001: warning: assignment makes pointer from integer without a cast
> drivers/media/platform/coda.c: In function 'coda_remove':
> drivers/media/platform/coda.c:2024: error: implicit declaration of function 'iram_free
> 
> Since the content of iram.h is not imx specific, move it to include/linux/iram.h
> instead.

Generally we need a fix for this, but:

> diff --git a/arch/arm/mach-imx/iram.h b/include/linux/iram.h
> similarity index 100%
> rename from arch/arm/mach-imx/iram.h
> rename to include/linux/iram.h

We shouldn't introduce a file include/linux/iram.h which is purely i.MX
specific. The name is far too generic. I would rather suggest
include/linux/platform_data/imx-iram.h (Although it's not exactly
platform_data, so I'm open for better suggestions).

As a side note this i.MX specific iram stuff (hopefully) is obsolete
after the next merge window as Philip already has patches for a generic
iram allocator which didn't make it into this merge window.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
