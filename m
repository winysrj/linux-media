Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:57978 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754718Ab1IRUKb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 18 Sep 2011 16:10:31 -0400
Date: Sun, 18 Sep 2011 22:10:22 +0200
From: martin@neutronstar.dyndns.org
To: Joe Perches <joe@perches.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH v2] arm: omap3evm: Add support for an MT9M032 based
 camera board.
References: <1316252097-4213-1-git-send-email-martin@neutronstar.dyndns.org>
 <1316291069.1610.23.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316291069.1610.23.camel@Joe-Laptop>
Message-Id: <1316376623.565262.7548@localhost>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Sep 17, 2011 at 01:24:29PM -0700, Joe Perches wrote:
> On Sat, 2011-09-17 at 11:34 +0200, Martin Hostettler wrote:
> > Adds board support for an MT9M032 based camera to omap3evm.
> 
> All of the logging messages could be
> prefixed by the printk subsystem if you
> add #define pr_fmt before any #include

Ah, i didn't really knew about that feature yet. I really have to keep
that in mind when grepping for error messages in the future.

But i don't think it would help much, as i now reducted the total number
of pr_err calls to 2 in this patch.

Thanks for the idea anyway.

 - Martin Hostettler

> 
> > diff --git a/arch/arm/mach-omap2/board-omap3evm-camera.c b/arch/arm/mach-omap2/board-omap3evm-camera.c
> []
> #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> []
> > +static int omap3evm_set_mux(enum omap3evmdc_mux mux_id)
> []
> > +	switch (mux_id) {
> []
> > +	default:
> > +		pr_err("omap3evm-camera: Invalid mux id #%d\n", mux_id);
> 
> 		pr_err("Invalid mux id #%d\n", mux_id);
> []
> > +static int __init camera_init(void)
> []
> > +	if (gpio_request(nCAM_VD_SEL, "nCAM_VD_SEL") < 0) {
> > +		pr_err("omap3evm-camera: Failed to get GPIO nCAM_VD_SEL(%d)\n",
> > +		       nCAM_VD_SEL);
> 
> 		pr_err("Failed to get GPIO nCAM_VD_SEL(%d)\n",
> 		       nCAM_VD_SEL);
> etc.
> 
