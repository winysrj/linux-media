Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:40468 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932253AbcBZKzZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Feb 2016 05:55:25 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: kuninori.morimoto.gx@renesas.com
Cc: linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH/RFC 1/9] clk: shmobile: r8a7795: Add FCP clocks
Date: Fri, 26 Feb 2016 12:55:26 +0200
Message-ID: <3970801.5TWghEBfCF@avalon>
In-Reply-To: <1455242450-24493-2-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
References: <1455242450-24493-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <1455242450-24493-2-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Morimoto-san,

On Friday 12 February 2016 04:00:42 Laurent Pinchart wrote:
> The parent clock isn't documented in the datasheet, use S2D1 as a best
> guess for now.

Would you be able to find out what the parent clock is for the FCP and LVDS 
(patch 2/9) clocks ?

Feel free to tell the documentation team that your life would be easier if the 
information was included in the datasheets ;-)

> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> ---
>  drivers/clk/shmobile/r8a7795-cpg-mssr.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/drivers/clk/shmobile/r8a7795-cpg-mssr.c
> b/drivers/clk/shmobile/r8a7795-cpg-mssr.c index 13e994772dfd..ae5004ee7bdd
> 100644
> --- a/drivers/clk/shmobile/r8a7795-cpg-mssr.c
> +++ b/drivers/clk/shmobile/r8a7795-cpg-mssr.c
> @@ -130,6 +130,21 @@ static const struct mssr_mod_clk r8a7795_mod_clks[]
> __initconst = { DEF_MOD("hscif2",		 518,	R8A7795_CLK_S3D1),
>  	DEF_MOD("hscif1",		 519,	R8A7795_CLK_S3D1),
>  	DEF_MOD("hscif0",		 520,	R8A7795_CLK_S3D1),
> +	DEF_MOD("fcpvd3",		 600,	R8A7795_CLK_S2D1),
> +	DEF_MOD("fcpvd2",		 601,	R8A7795_CLK_S2D1),
> +	DEF_MOD("fcpvd1",		 602,	R8A7795_CLK_S2D1),
> +	DEF_MOD("fcpvd0",		 603,	R8A7795_CLK_S2D1),
> +	DEF_MOD("fcpvb1",		 606,	R8A7795_CLK_S2D1),
> +	DEF_MOD("fcpvb0",		 607,	R8A7795_CLK_S2D1),
> +	DEF_MOD("fcpvi2",		 609,	R8A7795_CLK_S2D1),
> +	DEF_MOD("fcpvi1",		 610,	R8A7795_CLK_S2D1),
> +	DEF_MOD("fcpvi0",		 611,	R8A7795_CLK_S2D1),
> +	DEF_MOD("fcpf2",		 613,	R8A7795_CLK_S2D1),
> +	DEF_MOD("fcpf1",		 614,	R8A7795_CLK_S2D1),
> +	DEF_MOD("fcpf0",		 615,	R8A7795_CLK_S2D1),
> +	DEF_MOD("fcpci1",		 616,	R8A7795_CLK_S2D1),
> +	DEF_MOD("fcpci0",		 617,	R8A7795_CLK_S2D1),
> +	DEF_MOD("fcpcs",		 619,	R8A7795_CLK_S2D1),
>  	DEF_MOD("vspd3",		 620,	R8A7795_CLK_S2D1),
>  	DEF_MOD("vspd2",		 621,	R8A7795_CLK_S2D1),
>  	DEF_MOD("vspd1",		 622,	R8A7795_CLK_S2D1),

-- 
Regards,

Laurent Pinchart

