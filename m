Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:59843 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbbAVLrz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Jan 2015 06:47:55 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/2] [media] v4l: vsp1: Fix VI6_DISP_IRQ_ENB_LNEE macro
Date: Thu, 22 Jan 2015 13:48:29 +0200
Message-ID: <2102436.0XzGPfAmkn@avalon>
In-Reply-To: <1420616274-15018-1-git-send-email-nobuhiro.iwamatsu.yj@renesas.com>
References: <1420616274-15018-1-git-send-email-nobuhiro.iwamatsu.yj@renesas.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Iwamatsu-san,

Thank you for the patches.

On Wednesday 07 January 2015 16:37:53 Nobuhiro Iwamatsu wrote:
> LNEE bit in VI6_DISP_IRQ_ENB register are from the 0 bit to 4 bit.
> This fixes bit position specified by VI6_DISP_IRQ_ENB_LNEE.
> 
> Signed-off-by: Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>

For the whole series,

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

I've applied the patches to my tree.

> ---
>  drivers/media/platform/vsp1/vsp1_regs.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/media/platform/vsp1/vsp1_regs.h
> b/drivers/media/platform/vsp1/vsp1_regs.h index 55f163d..79d4063 100644
> --- a/drivers/media/platform/vsp1/vsp1_regs.h
> +++ b/drivers/media/platform/vsp1/vsp1_regs.h
> @@ -43,7 +43,7 @@
>  #define VI6_DISP_IRQ_ENB		0x0078
>  #define VI6_DISP_IRQ_ENB_DSTE		(1 << 8)
>  #define VI6_DISP_IRQ_ENB_MAEE		(1 << 5)
> -#define VI6_DISP_IRQ_ENB_LNEE(n)	(1 << ((n) + 4))
> +#define VI6_DISP_IRQ_ENB_LNEE(n)	(1 << (n))
> 
>  #define VI6_DISP_IRQ_STA		0x007c
>  #define VI6_DISP_IRQ_STA_DSE		(1 << 8)

-- 
Regards,

Laurent Pinchart

