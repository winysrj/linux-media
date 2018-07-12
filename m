Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lj1-f196.google.com ([209.85.208.196]:33242 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727714AbeGLIWA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 12 Jul 2018 04:22:00 -0400
Received: by mail-lj1-f196.google.com with SMTP id t21-v6so21328906lji.0
        for <linux-media@vger.kernel.org>; Thu, 12 Jul 2018 01:13:30 -0700 (PDT)
Date: Thu, 12 Jul 2018 10:13:28 +0200
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: laurent.pinchart@ideasonboard.com, horms@verge.net.au,
        geert@glider.be, mchehab@kernel.org, sakari.ailus@linux.intel.com,
        hans.verkuil@cisco.com, robh+dt@kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v5 3/6] dt-bindings: media: Document data-enable-active
 property
Message-ID: <20180712081328.GT5237@bigcity.dyn.berto.se>
References: <1531145962-1540-1-git-send-email-jacopo+renesas@jmondi.org>
 <1531145962-1540-4-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1531145962-1540-4-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

On 2018-07-09 16:19:18 +0200, Jacopo Mondi wrote:
> Add 'data-enable-active' property to endpoint node properties list.
> 
> The property allows to specify the polarity of the data-enable signal, which
> when in active state determinates when data lines have to sampled for valid
> pixel data.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> Reviewed-by: Rob Herring <robh@kernel.org>

Acked-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

> ---
>  Documentation/devicetree/bindings/media/video-interfaces.txt | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/media/video-interfaces.txt b/Documentation/devicetree/bindings/media/video-interfaces.txt
> index 52b7c7b..baf9d97 100644
> --- a/Documentation/devicetree/bindings/media/video-interfaces.txt
> +++ b/Documentation/devicetree/bindings/media/video-interfaces.txt
> @@ -113,6 +113,8 @@ Optional endpoint properties
>    Note, that if HSYNC and VSYNC polarities are not specified, embedded
>    synchronization may be required, where supported.
>  - data-active: similar to HSYNC and VSYNC, specifies data line polarity.
> +- data-enable-active: similar to HSYNC and VSYNC, specifies the data enable
> +  signal polarity.
>  - field-even-active: field signal level during the even field data transmission.
>  - pclk-sample: sample data on rising (1) or falling (0) edge of the pixel clock
>    signal.
> -- 
> 2.7.4
> 

-- 
Regards,
Niklas Söderlund
