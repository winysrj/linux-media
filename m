Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:55888 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750807AbeFAK3P (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Fri, 1 Jun 2018 06:29:15 -0400
Date: Fri, 1 Jun 2018 13:29:10 +0300
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: niklas.soderlund@ragnatech.se, laurent.pinchart@ideasonboard.com,
        horms@verge.net.au, geert@glider.be, mchehab@kernel.org,
        hans.verkuil@cisco.com, robh+dt@kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v3 2/8] dt-bindings: media: Document data-enable-active
 property
Message-ID: <20180601102910.3qhe6bhg3w263chq@paasikivi.fi.intel.com>
References: <1527606359-19261-1-git-send-email-jacopo+renesas@jmondi.org>
 <1527606359-19261-3-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1527606359-19261-3-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

Thanks for the patch.

On Tue, May 29, 2018 at 05:05:53PM +0200, Jacopo Mondi wrote:
> Add 'data-enable-active' property to endpoint node properties list.
> 
> The property allows to specify the polarity of the data-enable signal, which
> when in active state determinates when data lanes have to sampled for valid
> pixel data.

Lanes or lines? I understand this is forthe parallel interface.

> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> ---
> v3:
> - new patch
> ---
>  Documentation/devicetree/bindings/media/video-interfaces.txt | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/media/video-interfaces.txt b/Documentation/devicetree/bindings/media/video-interfaces.txt
> index 258b8df..9839d26 100644
> --- a/Documentation/devicetree/bindings/media/video-interfaces.txt
> +++ b/Documentation/devicetree/bindings/media/video-interfaces.txt
> @@ -109,6 +109,8 @@ Optional endpoint properties
>    Note, that if HSYNC and VSYNC polarities are not specified, embedded
>    synchronization may be required, where supported.
>  - data-active: similar to HSYNC and VSYNC, specifies data line polarity.
> +- data-enable-active: similar to HSYNC and VSYNC, specifies the data enable
> +  signal polarity.
>  - field-even-active: field signal level during the even field data transmission.
>  - pclk-sample: sample data on rising (1) or falling (0) edge of the pixel clock
>    signal.

-- 
Sakari Ailus
sakari.ailus@linux.intel.com
