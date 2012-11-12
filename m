Return-path: <linux-media-owner@vger.kernel.org>
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:35964 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751685Ab2KLRhQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Nov 2012 12:37:16 -0500
Date: Mon, 12 Nov 2012 09:37:13 -0800
From: Tony Lindgren <tony@atomide.com>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: hvaibhav@ti.com, linux-media@vger.kernel.org,
	linux-omap@vger.kernel.org, Archit Taneja <archit@ti.com>
Subject: Re: [PATCH 0/2] omap_vout: remove cpu_is_* uses
Message-ID: <20121112173713.GI6801@atomide.com>
References: <1352727220-22540-1-git-send-email-tomi.valkeinen@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352727220-22540-1-git-send-email-tomi.valkeinen@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

* Tomi Valkeinen <tomi.valkeinen@ti.com> [121112 05:35]:
> Hi,
> 
> This patch removes use of cpu_is_* funcs from omap_vout, and uses omapdss's
> version instead. The other patch removes an unneeded plat/dma.h include.
> 
> These are based on current omapdss master branch, which has the omapdss version
> code. The omapdss version code is queued for v3.8. I'm not sure which is the
> best way to handle these patches due to the dependency to omapdss. The easiest
> option is to merge these for 3.9.
> 
> There's still the OMAP DMA use in omap_vout_vrfb.c, which is the last OMAP
> dependency in the omap_vout driver. I'm not going to touch that, as it doesn't
> look as trivial as this cpu_is_* removal, and I don't have much knowledge of
> the omap_vout driver.
> 
> Compiled, but not tested.

Thanks for fixing this. Can you please resend with the selected
people cc:d from output of:

$ scripts/get_maintainer.pl -f drivers/media/platform/omap

So we get the necessary acks.

Regards,

Tony 
