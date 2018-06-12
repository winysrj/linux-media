Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:12750 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754056AbeFLPqA (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Jun 2018 11:46:00 -0400
Date: Tue, 12 Jun 2018 18:45:53 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: niklas.soderlund@ragnatech.se, laurent.pinchart@ideasonboard.com,
        horms@verge.net.au, geert@glider.be, mchehab@kernel.org,
        hans.verkuil@cisco.com, robh+dt@kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v4 6/6] dt-bindings: media: rcar-vin: Clarify optional
 props
Message-ID: <20180612154553.kgqnqkwv3y6srivg@kekkonen.localdomain>
References: <1528813566-17927-1-git-send-email-jacopo+renesas@jmondi.org>
 <1528813566-17927-7-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1528813566-17927-7-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

On Tue, Jun 12, 2018 at 04:26:06PM +0200, Jacopo Mondi wrote:
> Add a note to the R-Car VIN interface bindings to clarify that all
> properties listed as generic properties in video-interfaces.txt can
> be included in port@0 endpoint, but if not explicitly listed in the
> interface bindings documentation, they do not modify it behaviour.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> ---
>  Documentation/devicetree/bindings/media/rcar_vin.txt | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/media/rcar_vin.txt b/Documentation/devicetree/bindings/media/rcar_vin.txt
> index 8130849..03544c7 100644
> --- a/Documentation/devicetree/bindings/media/rcar_vin.txt
> +++ b/Documentation/devicetree/bindings/media/rcar_vin.txt
> @@ -55,6 +55,12 @@ from local SoC CSI-2 receivers (port1) depending on SoC.
>        instances that are connected to external pins should have port 0.
>  
>        - Optional properties for endpoint nodes of port@0:
> +
> +        All properties described in [1] and which apply to the selected
> +        media bus type could be optionally listed here to better describe
> +        the current hardware configuration, but only the following ones do
> +        actually modify the VIN interface behaviour:
> +

I don't think this should be needed. You should only have properties that
describe the hardware configuration in a given system.

>          - hsync-active: see [1] for description. Default is active high.
>          - vsync-active: see [1] for description. Default is active high.
>          - data-enable-active: polarity of CLKENB signal, see [1] for
> -- 
> 2.7.4
> 

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
