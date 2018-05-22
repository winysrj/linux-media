Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:53260 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751236AbeEVPcX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 May 2018 11:32:23 -0400
Received: by mail-wm0-f65.google.com with SMTP id a67-v6so903045wmf.3
        for <linux-media@vger.kernel.org>; Tue, 22 May 2018 08:32:22 -0700 (PDT)
Date: Tue, 22 May 2018 17:32:20 +0200
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: laurent.pinchart@ideasonboard.com, horms@verge.net.au,
        geert@glider.be, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v2 2/4] dt-bindings: media: rcar-vin: Document data-active
Message-ID: <20180522153220.GD5115@bigcity.dyn.berto.se>
References: <1526923663-8179-1-git-send-email-jacopo+renesas@jmondi.org>
 <1526923663-8179-3-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1526923663-8179-3-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

Thanks for your patch.

On 2018-05-21 19:27:41 +0200, Jacopo Mondi wrote:
> Document 'data-active' property in R-Car VIN device tree bindings.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> 
> v1 -> v2:
> - HSYNC is used in place of data enable signal only when running with
>   explicit synchronizations.
> - The property is no more mandatory when running with embedded
>   synchronizations, and default is selected.
> ---
>  Documentation/devicetree/bindings/media/rcar_vin.txt | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/media/rcar_vin.txt b/Documentation/devicetree/bindings/media/rcar_vin.txt
> index dab3118..2c144b4 100644
> --- a/Documentation/devicetree/bindings/media/rcar_vin.txt
> +++ b/Documentation/devicetree/bindings/media/rcar_vin.txt
> @@ -64,6 +64,12 @@ from local SoC CSI-2 receivers (port1) depending on SoC.
>  	If both HSYNC and VSYNC polarities are not specified, embedded
>  	synchronization is selected.
>  
> +        - data-active: data enable signal line polarity (CLKENB pin).
> +          0/1 for LOW/HIGH respectively. If not specified and running with
> +	  embedded synchronization, the default is active high. If not
> +	  specified and running with explicit synchronization, HSYNC is used
> +	  as data enable signal.

This indentation looks funny :-)

If you check the rest of the rcar_vin.txt file only spaces are used for
indentation.

> +
>      - port 1 - sub-nodes describing one or more endpoints connected to
>        the VIN from local SoC CSI-2 receivers. The endpoint numbers must
>        use the following schema.
> -- 
> 2.7.4
> 

-- 
Regards,
Niklas Söderlund
