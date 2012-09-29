Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:54414 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756873Ab2I2R0D (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 29 Sep 2012 13:26:03 -0400
Date: Sat, 29 Sep 2012 19:25:58 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Albert Wang <twang13@marvell.com>
cc: corbet@lwn.net, linux-media@vger.kernel.org,
	Libin Yang <lbyang@marvell.com>
Subject: Re: [PATCH 1/4] [media] mmp: add register definition for marvell
 ccic
In-Reply-To: <1348840031-21357-1-git-send-email-twang13@marvell.com>
Message-ID: <Pine.LNX.4.64.1209291922550.20390@axis700.grange>
References: <1348840031-21357-1-git-send-email-twang13@marvell.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, 28 Sep 2012, Albert Wang wrote:

> From: Libin Yang <lbyang@marvell.com>
> 
> This patch adds the definition of CCIC1/2 Clock Reset register address
> 
> Signed-off-by: Albert Wang <twang13@marvell.com>
> Signed-off-by: Libin Yang <lbyang@marvell.com>
> ---
>  arch/arm/mach-mmp/include/mach/regs-apmu.h |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/arm/mach-mmp/include/mach/regs-apmu.h b/arch/arm/mach-mmp/include/mach/regs-apmu.h
> index 7af8deb..f2cf231 100755
> --- a/arch/arm/mach-mmp/include/mach/regs-apmu.h
> +++ b/arch/arm/mach-mmp/include/mach/regs-apmu.h
> @@ -16,7 +16,8 @@
>  /* Clock Reset Control */
>  #define APMU_IRE	APMU_REG(0x048)
>  #define APMU_LCD	APMU_REG(0x04c)
> -#define APMU_CCIC	APMU_REG(0x050)
> +#define APMU_CCIC_RST	APMU_REG(0x050)
> +#define APMU_CCIC2_RST	APMU_REG(0x0f4)

Assuming APMU_CCIC hasn't been used until now, changing its name is ok, 
but I think, registers in this list are ordered by their addresses, so, 
your addition should go between

#define APMU_SDH3	APMU_REG(0x0ec)
#define APMU_ETH	APMU_REG(0x0fc)

Thanks
Guennadi

>  #define APMU_SDH0	APMU_REG(0x054)
>  #define APMU_SDH1	APMU_REG(0x058)
>  #define APMU_USB	APMU_REG(0x05c)
> -- 
> 1.7.0.4
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
