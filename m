Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:16100 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759274AbaJ3NEU (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Oct 2014 09:04:20 -0400
Date: Thu, 30 Oct 2014 11:04:13 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Behan Webster <behanw@converseincode.com>
Cc: archit@ti.com, b.zolnierkie@samsung.com, hans.verkuil@cisco.com,
	k.debski@samsung.com, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] media, platform,
 LLVMLinux: Remove nested function from ti-vpe
Message-id: <20141030110413.6a71631e.m.chehab@samsung.com>
In-reply-to: <1411780305-5685-1-git-send-email-behanw@converseincode.com>
References: <1411780305-5685-1-git-send-email-behanw@converseincode.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 26 Sep 2014 18:11:45 -0700
Behan Webster <behanw@converseincode.com> escreveu:

> Replace the use of nested functions where a normal function will suffice.
> 
> Nested functions are not liked by upstream kernel developers in general. Their
> use breaks the use of clang as a compiler, and doesn't make the code any
> better.
> 
> This code now works for both gcc and clang.

I'm ok with this patch, as it makes the code cleaner, but in a few
cases, such functions could be useful, for example for doing things
like typecasting or when we need to use multiple versions of the same
code, one to be used internally and another to be used externally
with a different set of arguments inside the function call
(none of this applies here, it seems).

So, I think clang should be fixed anyway to support it.

Anyway, I'll be applying this patch.

Regards,
Mauro

> 
> Signed-off-by: Behan Webster <behanw@converseincode.com>
> Suggested-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/media/platform/ti-vpe/csc.c | 8 ++------
>  drivers/media/platform/ti-vpe/sc.c  | 8 ++------
>  2 files changed, 4 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/media/platform/ti-vpe/csc.c b/drivers/media/platform/ti-vpe/csc.c
> index 940df40..44fbf41 100644
> --- a/drivers/media/platform/ti-vpe/csc.c
> +++ b/drivers/media/platform/ti-vpe/csc.c
> @@ -93,12 +93,8 @@ void csc_dump_regs(struct csc_data *csc)
>  {
>  	struct device *dev = &csc->pdev->dev;
>  
> -	u32 read_reg(struct csc_data *csc, int offset)
> -	{
> -		return ioread32(csc->base + offset);
> -	}
> -
> -#define DUMPREG(r) dev_dbg(dev, "%-35s %08x\n", #r, read_reg(csc, CSC_##r))
> +#define DUMPREG(r) dev_dbg(dev, "%-35s %08x\n", #r, \
> +	ioread32(csc->base + CSC_##r))
>  
>  	DUMPREG(CSC00);
>  	DUMPREG(CSC01);
> diff --git a/drivers/media/platform/ti-vpe/sc.c b/drivers/media/platform/ti-vpe/sc.c
> index 6314171..1088381 100644
> --- a/drivers/media/platform/ti-vpe/sc.c
> +++ b/drivers/media/platform/ti-vpe/sc.c
> @@ -24,12 +24,8 @@ void sc_dump_regs(struct sc_data *sc)
>  {
>  	struct device *dev = &sc->pdev->dev;
>  
> -	u32 read_reg(struct sc_data *sc, int offset)
> -	{
> -		return ioread32(sc->base + offset);
> -	}
> -
> -#define DUMPREG(r) dev_dbg(dev, "%-35s %08x\n", #r, read_reg(sc, CFG_##r))
> +#define DUMPREG(r) dev_dbg(dev, "%-35s %08x\n", #r, \
> +	ioread32(sc->base + CFG_##r))
>  
>  	DUMPREG(SC0);
>  	DUMPREG(SC1);
