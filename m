Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:38984 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756191AbbFRTWx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 18 Jun 2015 15:22:53 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 1/3] [media] v4l: vsp1: Fix VI6_WPF_SZCLIP_SIZE_MASK macro
Date: Thu, 18 Jun 2015 22:23:41 +0300
Message-ID: <2601266.KYQNBCMI2R@avalon>
In-Reply-To: <1422492835-4398-1-git-send-email-nobuhiro.iwamatsu.yj@renesas.com>
References: <1422492835-4398-1-git-send-email-nobuhiro.iwamatsu.yj@renesas.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Iwamatsu-san,

I've found this patch series in my inbox, my apologies for not having noticed 
it earlier.

On Thursday 29 January 2015 09:53:53 Nobuhiro Iwamatsu wrote:
> Clipping size bit of VI6_WPFn _HSZCLIP and VI6_WPFn _VSZCLIP register are
> from 0 bit to 11 bit. But VI6_WPF_SZCLIP_SIZE_MASK is set to 0x1FFF, this
> will mask until the reserve bits. This fixes size for
> VI6_WPF_SZCLIP_SIZE_MASK.
> 
> Signed-off-by: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>

The three patches look good to me.

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

I've applied them to my tree and will send a pull request to get them merged 
in mainline.

> ---
>  drivers/media/platform/vsp1/vsp1_regs.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_regs.h
> b/drivers/media/platform/vsp1/vsp1_regs.h index da3c573..f61e109 100644
> --- a/drivers/media/platform/vsp1/vsp1_regs.h
> +++ b/drivers/media/platform/vsp1/vsp1_regs.h
> @@ -238,7 +238,7 @@
>  #define VI6_WPF_SZCLIP_EN		(1 << 28)
>  #define VI6_WPF_SZCLIP_OFST_MASK	(0xff << 16)
>  #define VI6_WPF_SZCLIP_OFST_SHIFT	16
> -#define VI6_WPF_SZCLIP_SIZE_MASK	(0x1fff << 0)
> +#define VI6_WPF_SZCLIP_SIZE_MASK	(0xfff << 0)
>  #define VI6_WPF_SZCLIP_SIZE_SHIFT	0
> 
>  #define VI6_WPF_OUTFMT			0x100c

-- 
Regards,

Laurent Pinchart

