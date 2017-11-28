Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:45801 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751942AbdK1NfC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 28 Nov 2017 08:35:02 -0500
Received: by mail-lf0-f67.google.com with SMTP id f131so429800lff.12
        for <linux-media@vger.kernel.org>; Tue, 28 Nov 2017 05:35:01 -0800 (PST)
Date: Tue, 28 Nov 2017 14:34:59 +0100
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Fabrizio Castro <fabrizio.castro@bp.renesas.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <robh+dt@kernel.org>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, devicetree@vger.kernel.org,
        Simon Horman <horms+renesas@verge.net.au>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>
Subject: Re: [PATCH v2 1/4] dt-bindings: media: rcar_vin: Reverse SoC part
 number list
Message-ID: <20171128133459.GI23832@bigcity.dyn.berto.se>
References: <1510856571-30281-1-git-send-email-fabrizio.castro@bp.renesas.com>
 <1510856571-30281-2-git-send-email-fabrizio.castro@bp.renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1510856571-30281-2-git-send-email-fabrizio.castro@bp.renesas.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 2017-11-16 18:22:48 +0000, Fabrizio Castro wrote:
> Change the sorting of the part numbers from descending to ascending to
> match with other documentation.
> 
> Signed-off-by: Fabrizio Castro <fabrizio.castro@bp.renesas.com>
> Reviewed-by: Biju Das <biju.das@bp.renesas.com>

Acked-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

> ---
> v1->v2:
> * new patch triggered by Geert's comment, see the below link for details:
>   https://www.mail-archive.com/linux-media@vger.kernel.org/msg121992.html
> 
>  Documentation/devicetree/bindings/media/rcar_vin.txt | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/media/rcar_vin.txt b/Documentation/devicetree/bindings/media/rcar_vin.txt
> index 6e4ef8c..98931f5 100644
> --- a/Documentation/devicetree/bindings/media/rcar_vin.txt
> +++ b/Documentation/devicetree/bindings/media/rcar_vin.txt
> @@ -6,14 +6,14 @@ family of devices. The current blocks are always slaves and suppot one input
>  channel which can be either RGB, YUYV or BT656.
>  
>   - compatible: Must be one or more of the following
> -   - "renesas,vin-r8a7795" for the R8A7795 device
> -   - "renesas,vin-r8a7794" for the R8A7794 device
> -   - "renesas,vin-r8a7793" for the R8A7793 device
> -   - "renesas,vin-r8a7792" for the R8A7792 device
> -   - "renesas,vin-r8a7791" for the R8A7791 device
> -   - "renesas,vin-r8a7790" for the R8A7790 device
> -   - "renesas,vin-r8a7779" for the R8A7779 device
>     - "renesas,vin-r8a7778" for the R8A7778 device
> +   - "renesas,vin-r8a7779" for the R8A7779 device
> +   - "renesas,vin-r8a7790" for the R8A7790 device
> +   - "renesas,vin-r8a7791" for the R8A7791 device
> +   - "renesas,vin-r8a7792" for the R8A7792 device
> +   - "renesas,vin-r8a7793" for the R8A7793 device
> +   - "renesas,vin-r8a7794" for the R8A7794 device
> +   - "renesas,vin-r8a7795" for the R8A7795 device
>     - "renesas,rcar-gen2-vin" for a generic R-Car Gen2 compatible device.
>     - "renesas,rcar-gen3-vin" for a generic R-Car Gen3 compatible device.
>  
> -- 
> 2.7.4
> 

-- 
Regards,
Niklas Söderlund
