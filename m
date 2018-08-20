Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:37366 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726119AbeHUB5k (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 20 Aug 2018 21:57:40 -0400
Date: Mon, 20 Aug 2018 17:40:10 -0500
From: Rob Herring <robh@kernel.org>
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: laurent.pinchart@ideasonboard.com, geert@linux-m68k.org,
        horms@verge.net.au, robh+dt@kernel.org, mark.rutland@arm.com,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        kieran.bingham+renesas@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se, damm+renesas@opensource.se,
        ulrich.hecht+renesas@gmail.com, linux-renesas-soc@vger.kernel.org,
        linux-media@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [RFT 3/8] dt-bindings: media: rcar-csi2: Add R8A77990
Message-ID: <20180820224010.GA9308@bogus>
References: <1534760202-20114-1-git-send-email-jacopo+renesas@jmondi.org>
 <1534760202-20114-4-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1534760202-20114-4-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 20 Aug 2018 12:16:37 +0200, Jacopo Mondi wrote:
> Add compatible string for R-Car E3 R8A77990 to the list of supported SoCs.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> ---
>  Documentation/devicetree/bindings/media/renesas,rcar-csi2.txt | 1 +
>  1 file changed, 1 insertion(+)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
