Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf1-f68.google.com ([209.85.167.68]:41102 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726910AbeIQQfX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Sep 2018 12:35:23 -0400
Received: by mail-lf1-f68.google.com with SMTP id l26-v6so13165170lfc.8
        for <linux-media@vger.kernel.org>; Mon, 17 Sep 2018 04:08:31 -0700 (PDT)
Date: Mon, 17 Sep 2018 13:08:28 +0200
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Biju Das <biju.das@bp.renesas.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        Simon Horman <horms@verge.net.au>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Fabrizio Castro <fabrizio.castro@bp.renesas.com>
Subject: Re: [PATCH 4/5] media: rcar-vin: Enable support for r8a774a1
Message-ID: <20180917110828.GS18450@bigcity.dyn.berto.se>
References: <1536589878-26218-1-git-send-email-biju.das@bp.renesas.com>
 <1536589878-26218-5-git-send-email-biju.das@bp.renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1536589878-26218-5-git-send-email-biju.das@bp.renesas.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Biju,

Thanks for your work.

On 2018-09-10 15:31:17 +0100, Biju Das wrote:
> Add the SoC specific information for RZ/G2M(r8a774a1) SoC.
> The VIN module of RZ/G2M is similar to R-Car M3-W.
> 
> Signed-off-by: Biju Das <biju.das@bp.renesas.com>
> Reviewed-by: Fabrizio Castro <fabrizio.castro@bp.renesas.com>

Acked-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

> ---
>  drivers/media/platform/rcar-vin/rcar-core.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
> index d3072e1..c0c84d1 100644
> --- a/drivers/media/platform/rcar-vin/rcar-core.c
> +++ b/drivers/media/platform/rcar-vin/rcar-core.c
> @@ -995,6 +995,10 @@ static const struct rvin_info rcar_info_r8a77970 = {
>  
>  static const struct of_device_id rvin_of_id_table[] = {
>  	{
> +		.compatible = "renesas,vin-r8a774a1",
> +		.data = &rcar_info_r8a7796,
> +	},
> +	{
>  		.compatible = "renesas,vin-r8a7778",
>  		.data = &rcar_info_m1,
>  	},
> -- 
> 2.7.4
> 

-- 
Regards,
Niklas Söderlund
