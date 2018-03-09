Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:40307 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750800AbeCIJ7g (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 9 Mar 2018 04:59:36 -0500
Received: by mail-lf0-f68.google.com with SMTP id 37-v6so12412504lfs.7
        for <linux-media@vger.kernel.org>; Fri, 09 Mar 2018 01:59:35 -0800 (PST)
Date: Fri, 9 Mar 2018 10:59:33 +0100
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Andy Whitcroft <apw@canonical.com>,
        Joe Perches <joe@perches.com>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: media: rcar_vin: Use status "okay"
Message-ID: <20180309095933.GG2205@bigcity.dyn.berto.se>
References: <1520588080-31264-1-git-send-email-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1520588080-31264-1-git-send-email-geert+renesas@glider.be>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Geert,

Thanks for your patch.

On 2018-03-09 10:34:40 +0100, Geert Uytterhoeven wrote:
> According to the Devicetree Specification, "ok" is not a valid status.
> 
> Fixes: 47c71bd61b772cd7 ("[media] rcar_vin: add devicetree support")
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

> ---
> For the checkpatch TODO list?
> https://www.devicetree.org/
> 
>  Documentation/devicetree/bindings/media/rcar_vin.txt | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/media/rcar_vin.txt b/Documentation/devicetree/bindings/media/rcar_vin.txt
> index 68c5c497b7fa5551..a19517e1c669eb35 100644
> --- a/Documentation/devicetree/bindings/media/rcar_vin.txt
> +++ b/Documentation/devicetree/bindings/media/rcar_vin.txt
> @@ -81,7 +81,7 @@ Board setup example for Gen2 platforms (vin1 composite video input)
>  -------------------------------------------------------------------
>  
>  &i2c2   {
> -        status = "ok";
> +        status = "okay";
>          pinctrl-0 = <&i2c2_pins>;
>          pinctrl-names = "default";
>  
> @@ -104,7 +104,7 @@ Board setup example for Gen2 platforms (vin1 composite video input)
>          pinctrl-0 = <&vin1_pins>;
>          pinctrl-names = "default";
>  
> -        status = "ok";
> +        status = "okay";
>  
>          port {
>                  #address-cells = <1>;
> -- 
> 2.7.4
> 

-- 
Regards,
Niklas Söderlund
