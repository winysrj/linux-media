Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:46100 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726119AbeHUB5R (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Aug 2018 21:57:17 -0400
Date: Mon, 20 Aug 2018 17:39:47 -0500
From: Rob Herring <robh@kernel.org>
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: laurent.pinchart@ideasonboard.com, geert@linux-m68k.org,
        horms@verge.net.au, mark.rutland@arm.com,
        kieran.bingham+renesas@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se, damm+renesas@opensource.se,
        ulrich.hecht+renesas@gmail.com, linux-renesas-soc@vger.kernel.org,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [RFT 1/8] media: dt-bindings: media: rcar-vin: Add R8A77990
 support
Message-ID: <20180820223947.GA7090@bogus>
References: <1534760202-20114-1-git-send-email-jacopo+renesas@jmondi.org>
 <1534760202-20114-2-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1534760202-20114-2-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Aug 20, 2018 at 12:16:35PM +0200, Jacopo Mondi wrote:
> Add compatible string for R-Car E3 R8A77990 to the list of SoCs supported by
> rcar-vin driver.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> ---
>  Documentation/devicetree/bindings/media/rcar_vin.txt | 1 +
>  1 file changed, 1 insertion(+)

Why the inconsistent subjects for patches 1 and 3?

Otherwise,

Reviewed-by: Rob Herring <robh@kernel.org>
