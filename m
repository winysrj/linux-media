Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:33614 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751590AbeFDMKn (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 4 Jun 2018 08:10:43 -0400
Received: by mail-lf0-f68.google.com with SMTP id y20-v6so24828713lfy.0
        for <linux-media@vger.kernel.org>; Mon, 04 Jun 2018 05:10:43 -0700 (PDT)
Date: Mon, 4 Jun 2018 14:10:41 +0200
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: laurent.pinchart@ideasonboard.com, horms@verge.net.au,
        geert@glider.be, mchehab@kernel.org, sakari.ailus@linux.intel.com,
        hans.verkuil@cisco.com, robh+dt@kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v3 4/8] dt-bindings: media: rcar-vin: Add
 'data-enable-active'
Message-ID: <20180604121041.GE19674@bigcity.dyn.berto.se>
References: <1527606359-19261-1-git-send-email-jacopo+renesas@jmondi.org>
 <1527606359-19261-5-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1527606359-19261-5-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

Thanks for your patch.

On 2018-05-29 17:05:55 +0200, Jacopo Mondi wrote:
> Describe optional endpoint property 'data-enable-active' for R-Car VIN.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>

Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

> ---
> v3:
> - new patch
> ---
> 
>  Documentation/devicetree/bindings/media/rcar_vin.txt | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/media/rcar_vin.txt b/Documentation/devicetree/bindings/media/rcar_vin.txt
> index 4d91a36..ff53226 100644
> --- a/Documentation/devicetree/bindings/media/rcar_vin.txt
> +++ b/Documentation/devicetree/bindings/media/rcar_vin.txt
> @@ -58,6 +58,8 @@ from local SoC CSI-2 receivers (port1) depending on SoC.
>        - Optional properties for endpoint nodes of port@0:
>          - hsync-active: see [1] for description. Default is active high.
>          - vsync-active: see [1] for description. Default is active high.
> +        - data-enable-active: polarity of CLKENB signal, see [1] for
> +          description. Default is active high.
> 
>          If both HSYNC and VSYNC polarities are not specified, embedded
>          synchronization is selected.
> --
> 2.7.4
> 

-- 
Regards,
Niklas Söderlund
