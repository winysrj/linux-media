Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:33471 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752204AbeEPVzl (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 May 2018 17:55:41 -0400
Received: by mail-wr0-f195.google.com with SMTP id o4-v6so3599531wrm.0
        for <linux-media@vger.kernel.org>; Wed, 16 May 2018 14:55:41 -0700 (PDT)
Date: Wed, 16 May 2018 23:55:38 +0200
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: laurent.pinchart@ideasonboard.com, horms@verge.net.au,
        geert@glider.be, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/6] dt-bindings: media: rcar-vin: Document data-active
Message-ID: <20180516215538.GC17948@bigcity.dyn.berto.se>
References: <1526488352-898-1-git-send-email-jacopo+renesas@jmondi.org>
 <1526488352-898-3-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1526488352-898-3-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

Thanks for your work.

On 2018-05-16 18:32:28 +0200, Jacopo Mondi wrote:
> Document 'data-active' property in R-Car VIN device tree bindings.
> The property is optional when running with explicit synchronization
> (eg. BT.601) but mandatory when embedded synchronization is in use (eg.
> BT.656) as specified by the hardware manual.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> ---
>  Documentation/devicetree/bindings/media/rcar_vin.txt | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/media/rcar_vin.txt b/Documentation/devicetree/bindings/media/rcar_vin.txt
> index c53ce4e..17eac8a 100644
> --- a/Documentation/devicetree/bindings/media/rcar_vin.txt
> +++ b/Documentation/devicetree/bindings/media/rcar_vin.txt
> @@ -63,6 +63,11 @@ from local SoC CSI-2 receivers (port1) depending on SoC.
>  	If both HSYNC and VSYNC polarities are not specified, embedded
>  	synchronization is selected.
> 
> +        - data-active: active state of data enable signal (CLOCKENB pin).

I'm not sure what you mean by active state here. video-interfaces.txt 
defines data-active as 'similar to HSYNC and VSYNC, specifies data line 
polarity' so I assume this is the polarity of the CLOCKENB pin?

> +          0/1 for LOW/HIGH respectively. If not specified, use HSYNC as
> +          data enable signal. When using embedded synchronization this
> +          property is mandatory.

I'm confused, why is this mandatory if we have no embedded sync (that is 
hsync-active and vsync-active not defined)? I can't find any reference 
to this in the Gen2 datasheet but I'm sure I'm just missing it :-)

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
