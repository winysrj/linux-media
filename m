Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf1-f67.google.com ([209.85.167.67]:33986 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727988AbeIQQcw (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Sep 2018 12:32:52 -0400
Received: by mail-lf1-f67.google.com with SMTP id c29-v6so13176179lfj.1
        for <linux-media@vger.kernel.org>; Mon, 17 Sep 2018 04:05:59 -0700 (PDT)
Date: Mon, 17 Sep 2018 13:05:57 +0200
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Biju Das <biju.das@bp.renesas.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Simon Horman <horms@verge.net.au>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Fabrizio Castro <fabrizio.castro@bp.renesas.com>
Subject: Re: [PATCH 2/5] media: rcar-csi2: Enable support for r8a774a1
Message-ID: <20180917110557.GQ18450@bigcity.dyn.berto.se>
References: <1536589878-26218-1-git-send-email-biju.das@bp.renesas.com>
 <1536589878-26218-3-git-send-email-biju.das@bp.renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1536589878-26218-3-git-send-email-biju.das@bp.renesas.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Biju,

Thanks for your work.

On 2018-09-10 15:31:15 +0100, Biju Das wrote:
> Add the MIPI CSI-2 driver support for RZ/G2M(r8a774a1) SoC.
> The CSI-2 module of RZ/G2M is similar to R-Car M3-W.
> 
> Signed-off-by: Biju Das <biju.das@bp.renesas.com>
> Reviewed-by: Fabrizio Castro <fabrizio.castro@bp.renesas.com>

Acked-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

> ---
>  drivers/media/platform/rcar-vin/rcar-csi2.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/media/platform/rcar-vin/rcar-csi2.c b/drivers/media/platform/rcar-vin/rcar-csi2.c
> index daef72d..65c7efb 100644
> --- a/drivers/media/platform/rcar-vin/rcar-csi2.c
> +++ b/drivers/media/platform/rcar-vin/rcar-csi2.c
> @@ -953,6 +953,10 @@ static const struct rcar_csi2_info rcar_csi2_info_r8a77970 = {
>  
>  static const struct of_device_id rcar_csi2_of_table[] = {
>  	{
> +		.compatible = "renesas,r8a774a1-csi2",
> +		.data = &rcar_csi2_info_r8a7796,
> +	},
> +	{
>  		.compatible = "renesas,r8a7795-csi2",
>  		.data = &rcar_csi2_info_r8a7795,
>  	},
> -- 
> 2.7.4
> 

-- 
Regards,
Niklas Söderlund
