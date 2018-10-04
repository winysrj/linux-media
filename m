Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf1-f66.google.com ([209.85.167.66]:34237 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727523AbeJEDDI (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 4 Oct 2018 23:03:08 -0400
Received: by mail-lf1-f66.google.com with SMTP id y10-v6so7747284lfj.1
        for <linux-media@vger.kernel.org>; Thu, 04 Oct 2018 13:08:18 -0700 (PDT)
Date: Thu, 4 Oct 2018 22:08:15 +0200
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Biju Das <biju.das@bp.renesas.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        devicetree@vger.kernel.org, Simon Horman <horms@verge.net.au>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Fabrizio Castro <fabrizio.castro@bp.renesas.com>
Subject: Re: [PATCH] media: dt-bindings: media: rcar_vin: add device tree
 support for r8a7744
Message-ID: <20181004200815.GP24305@bigcity.dyn.berto.se>
References: <1538668691-1780-1-git-send-email-biju.das@bp.renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1538668691-1780-1-git-send-email-biju.das@bp.renesas.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Biju-san,

Thanks for your patch.

On 2018-10-04 16:58:11 +0100, Biju Das wrote:
> Add compatible strings for r8a7744. No driver change is needed as
> "renesas,rcar-gen2-vin" will activate the right code.However, it is good
> practice to document compatible strings for the specific SoC as this
> allows SoC specific changes to the driver if needed, in addition to
> document SoC support and therefore allow checkpatch.pl to validate
> compatible string values.
> 
> Signed-off-by: Biju Das <biju.das@bp.renesas.com>
> Reviewed-by: Chris Paterson <Chris.Paterson2@renesas.com>

Acked-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

> ---
> This patch is tested against linux-next next next-20181004 & media_tree
> ---
>  Documentation/devicetree/bindings/media/rcar_vin.txt | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/Documentation/devicetree/bindings/media/rcar_vin.txt b/Documentation/devicetree/bindings/media/rcar_vin.txt
> index 2f42005..d329a4e 100644
> --- a/Documentation/devicetree/bindings/media/rcar_vin.txt
> +++ b/Documentation/devicetree/bindings/media/rcar_vin.txt
> @@ -11,6 +11,7 @@ on Gen3 platforms to a CSI-2 receiver.
>  
>   - compatible: Must be one or more of the following
>     - "renesas,vin-r8a7743" for the R8A7743 device
> +   - "renesas,vin-r8a7744" for the R8A7744 device
>     - "renesas,vin-r8a7745" for the R8A7745 device
>     - "renesas,vin-r8a7778" for the R8A7778 device
>     - "renesas,vin-r8a7779" for the R8A7779 device
> -- 
> 2.7.4
> 

-- 
Regards,
Niklas Söderlund
