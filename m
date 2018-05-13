Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:41897 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751263AbeEMNLU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 13 May 2018 09:11:20 -0400
Received: by mail-lf0-f67.google.com with SMTP id m17-v6so8980246lfj.8
        for <linux-media@vger.kernel.org>; Sun, 13 May 2018 06:11:19 -0700 (PDT)
Date: Sun, 13 May 2018 15:11:17 +0200
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Simon Horman <horms+renesas@verge.net.au>
Cc: linux-renesas-soc@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Magnus Damm <magnus.damm@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH] media: rcar-vin:  Drop unnecessary register properties
 from example vin port
Message-ID: <20180513131117.GR18974@bigcity.dyn.berto.se>
References: <20180509184558.14960-1-horms+renesas@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20180509184558.14960-1-horms+renesas@verge.net.au>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Simon,

Thanks for your patch.

On 2018-05-09 20:45:58 +0200, Simon Horman wrote:
> The example vin port node does not have an address and thus does not
> need address-cells or address size-properties.
> 
> Signed-off-by: Simon Horman <horms+renesas@verge.net.au>

Acked-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

> ---
>  Documentation/devicetree/bindings/media/rcar_vin.txt | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/media/rcar_vin.txt b/Documentation/devicetree/bindings/media/rcar_vin.txt
> index a19517e1c669..2a0c59e97f40 100644
> --- a/Documentation/devicetree/bindings/media/rcar_vin.txt
> +++ b/Documentation/devicetree/bindings/media/rcar_vin.txt
> @@ -107,9 +107,6 @@ Board setup example for Gen2 platforms (vin1 composite video input)
>          status = "okay";
>  
>          port {
> -                #address-cells = <1>;
> -                #size-cells = <0>;
> -
>                  vin1ep0: endpoint {
>                          remote-endpoint = <&adv7180>;
>                          bus-width = <8>;
> -- 
> 2.11.0
> 

-- 
Regards,
Niklas Söderlund
