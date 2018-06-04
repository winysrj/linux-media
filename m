Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:35117 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750868AbeFDMTg (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 4 Jun 2018 08:19:36 -0400
Received: by mail-lf0-f67.google.com with SMTP id y72-v6so24846169lfd.2
        for <linux-media@vger.kernel.org>; Mon, 04 Jun 2018 05:19:36 -0700 (PDT)
Date: Mon, 4 Jun 2018 14:19:33 +0200
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: laurent.pinchart@ideasonboard.com, horms@verge.net.au,
        geert@glider.be, mchehab@kernel.org, sakari.ailus@linux.intel.com,
        hans.verkuil@cisco.com, robh+dt@kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v3 6/8] dt-bindings: rcar-vin: Add 'hsync-as-de' custom
 prop
Message-ID: <20180604121933.GG19674@bigcity.dyn.berto.se>
References: <1527606359-19261-1-git-send-email-jacopo+renesas@jmondi.org>
 <1527606359-19261-7-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1527606359-19261-7-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

Thanks for your work.

On 2018-05-29 17:05:57 +0200, Jacopo Mondi wrote:
> Document the boolean custom property 'renesas,hsync-as-de' that indicates
> that the HSYNC signal is internally used as data-enable, when the
> CLKENB signal is not connected.
> 
> As this is a VIN specificity create a custom property specific to the R-Car
> VIN driver.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> ---
> v3:
> - new patch
> ---
>  Documentation/devicetree/bindings/media/rcar_vin.txt | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/media/rcar_vin.txt b/Documentation/devicetree/bindings/media/rcar_vin.txt
> index ff53226..024c109 100644
> --- a/Documentation/devicetree/bindings/media/rcar_vin.txt
> +++ b/Documentation/devicetree/bindings/media/rcar_vin.txt
> @@ -60,6 +60,9 @@ from local SoC CSI-2 receivers (port1) depending on SoC.
>          - vsync-active: see [1] for description. Default is active high.
>          - data-enable-active: polarity of CLKENB signal, see [1] for
>            description. Default is active high.
> +        - renesas,hsync-as-de: a boolean property to indicate that HSYNC signal
> +          is internally used as data-enable when the CLKENB signal is
> +          not available.

I'm not sure I like this, is there really a need to add a custom 
property for this? The datasheet states that when the CLKENB pin is not 
connected the driver should enable 'Clock Enable Hsync Select (CHS)'.  
With the new generic property 'data-enable-active' which describes the 
polarity of the CLKENB pin we also gain the knowledge if the CLKENB pin 
is connected or not.

I propose we drop this custom property and instead let the driver check 
if the CLKENB polarity is described or not and use that to determine if 
CHS bit should be set or not. IMHO that is much simpler then having two 
properties describing the same pin.

> 
>          If both HSYNC and VSYNC polarities are not specified, embedded
>          synchronization is selected.
> --
> 2.7.4
> 

-- 
Regards,
Niklas Söderlund
