Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:55457 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751199AbeEVPaG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 May 2018 11:30:06 -0400
Received: by mail-wm0-f65.google.com with SMTP id a8-v6so850689wmg.5
        for <linux-media@vger.kernel.org>; Tue, 22 May 2018 08:30:06 -0700 (PDT)
Date: Tue, 22 May 2018 17:30:03 +0200
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: laurent.pinchart@ideasonboard.com, horms@verge.net.au,
        geert@glider.be, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2 1/4] dt-bindings: media: rcar-vin: Describe optional
 ep properties
Message-ID: <20180522153003.GC5115@bigcity.dyn.berto.se>
References: <1526923663-8179-1-git-send-email-jacopo+renesas@jmondi.org>
 <1526923663-8179-2-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1526923663-8179-2-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

Thanks for your patch.

On 2018-05-21 19:27:40 +0200, Jacopo Mondi wrote:
> Describe the optional properties for endpoint nodes of port@0
> and port@1 of the R-Car VIN driver device tree bindings documentation.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> Acked-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
> ---
>  Documentation/devicetree/bindings/media/rcar_vin.txt | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/devicetree/bindings/media/rcar_vin.txt b/Documentation/devicetree/bindings/media/rcar_vin.txt
> index 5c6f2a7..dab3118 100644
> --- a/Documentation/devicetree/bindings/media/rcar_vin.txt
> +++ b/Documentation/devicetree/bindings/media/rcar_vin.txt
> @@ -54,6 +54,16 @@ from local SoC CSI-2 receivers (port1) depending on SoC.
>        from external SoC pins described in video-interfaces.txt[1].
>        Describing more then one endpoint in port 0 is invalid. Only VIN
>        instances that are connected to external pins should have port 0.
> +
> +      - Optional properties for endpoint nodes of port@0:
> +        - hsync-active: active state of the HSYNC signal, 0/1 for LOW/HIGH
> +	  respectively. Default is active high.
> +        - vsync-active: active state of the VSYNC signal, 0/1 for LOW/HIGH
> +	  respectively. Default is active high.
> +
> +	If both HSYNC and VSYNC polarities are not specified, embedded
> +	synchronization is selected.
> +
>      - port 1 - sub-nodes describing one or more endpoints connected to
>        the VIN from local SoC CSI-2 receivers. The endpoint numbers must
>        use the following schema.
> @@ -63,6 +73,8 @@ from local SoC CSI-2 receivers (port1) depending on SoC.
>          - Endpoint 2 - sub-node describing the endpoint connected to CSI40
>          - Endpoint 3 - sub-node describing the endpoint connected to CSI41
>  
> +      Endpoint nodes of port@1 do not support any optional endpoint property.
> +
>  Device node example for Gen2 platforms
>  --------------------------------------
>  
> @@ -113,7 +125,6 @@ Board setup example for Gen2 platforms (vin1 composite video input)
>  
>                  vin1ep0: endpoint {
>                          remote-endpoint = <&adv7180>;
> -                        bus-width = <8>;

Until we have figured out if we should document or remove the bus-width 
parameter maybe move this to 4/4 ?


>                  };
>          };
>  };
> -- 
> 2.7.4
> 

-- 
Regards,
Niklas Söderlund
