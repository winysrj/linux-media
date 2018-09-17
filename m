Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lj1-f193.google.com ([209.85.208.193]:36109 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728084AbeIQQeH (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Sep 2018 12:34:07 -0400
Received: by mail-lj1-f193.google.com with SMTP id v26-v6so12774869ljj.3
        for <linux-media@vger.kernel.org>; Mon, 17 Sep 2018 04:07:14 -0700 (PDT)
Date: Mon, 17 Sep 2018 13:07:12 +0200
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
Subject: Re: [PATCH 3/5] media: dt-bindings: media: rcar_vin: Add r8a774a1
 support
Message-ID: <20180917110712.GR18450@bigcity.dyn.berto.se>
References: <1536589878-26218-1-git-send-email-biju.das@bp.renesas.com>
 <1536589878-26218-4-git-send-email-biju.das@bp.renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1536589878-26218-4-git-send-email-biju.das@bp.renesas.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Biju,

Thanks for your patch.

On 2018-09-10 15:31:16 +0100, Biju Das wrote:
> Document RZ/G2M (R8A774A1) SoC bindings.
> 
> The RZ/G2M SoC is similar to R-Car M3-W (R8A7796).
> 
> Signed-off-by: Biju Das <biju.das@bp.renesas.com>
> Reviewed-by: Fabrizio Castro <fabrizio.castro@bp.renesas.com>

Acked-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

> ---
>  Documentation/devicetree/bindings/media/rcar_vin.txt | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/media/rcar_vin.txt b/Documentation/devicetree/bindings/media/rcar_vin.txt
> index 2f42005..8c81689 100644
> --- a/Documentation/devicetree/bindings/media/rcar_vin.txt
> +++ b/Documentation/devicetree/bindings/media/rcar_vin.txt
> @@ -12,6 +12,7 @@ on Gen3 platforms to a CSI-2 receiver.
>   - compatible: Must be one or more of the following
>     - "renesas,vin-r8a7743" for the R8A7743 device
>     - "renesas,vin-r8a7745" for the R8A7745 device
> +   - "renesas,vin-r8a774a1" for the R8A774A1 device
>     - "renesas,vin-r8a7778" for the R8A7778 device
>     - "renesas,vin-r8a7779" for the R8A7779 device
>     - "renesas,vin-r8a7790" for the R8A7790 device
> @@ -58,9 +59,9 @@ The per-board settings Gen2 platforms:
>      - data-enable-active: polarity of CLKENB signal, see [1] for
>        description. Default is active high.
>  
> -The per-board settings Gen3 platforms:
> +The per-board settings Gen3 and RZ/G2 platforms:
>  
> -Gen3 platforms can support both a single connected parallel input source
> +Gen3 and RZ/G2 platforms can support both a single connected parallel input source
>  from external SoC pins (port@0) and/or multiple parallel input sources
>  from local SoC CSI-2 receivers (port@1) depending on SoC.
>  
> -- 
> 2.7.4
> 

-- 
Regards,
Niklas Söderlund
