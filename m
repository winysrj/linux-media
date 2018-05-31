Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yw0-f196.google.com ([209.85.161.196]:33427 "EHLO
        mail-yw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932646AbeEaDRp (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 30 May 2018 23:17:45 -0400
Date: Wed, 30 May 2018 22:17:43 -0500
From: Rob Herring <robh@kernel.org>
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: niklas.soderlund@ragnatech.se, laurent.pinchart@ideasonboard.com,
        horms@verge.net.au, geert@glider.be, mchehab@kernel.org,
        sakari.ailus@linux.intel.com, hans.verkuil@cisco.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH v3 8/8] ARM: dts: rcar-gen2: Remove unused VIN properties
Message-ID: <20180531031743.GA8607@rob-hp-laptop>
References: <1527606359-19261-1-git-send-email-jacopo+renesas@jmondi.org>
 <1527606359-19261-9-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1527606359-19261-9-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, May 29, 2018 at 05:05:59PM +0200, Jacopo Mondi wrote:
> The 'bus-width' and 'pclk-sample' properties are not parsed by the VIN
> driver and only confuse users. Remove them in all Gen2 SoC that use
> them.
> 
> Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> ---
> v3:
> - remove bus-width from dt-bindings example
> ---
>  Documentation/devicetree/bindings/media/rcar_vin.txt | 1 -
>  arch/arm/boot/dts/r8a7790-lager.dts                  | 3 ---
>  arch/arm/boot/dts/r8a7791-koelsch.dts                | 3 ---
>  arch/arm/boot/dts/r8a7791-porter.dts                 | 1 -
>  arch/arm/boot/dts/r8a7793-gose.dts                   | 3 ---
>  arch/arm/boot/dts/r8a7794-alt.dts                    | 1 -
>  arch/arm/boot/dts/r8a7794-silk.dts                   | 1 -
>  7 files changed, 13 deletions(-)

Reviewed-by: Rob Herring <robh@kernel.org>
