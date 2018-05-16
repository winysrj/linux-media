Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:45277 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751255AbeEPVQs (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 May 2018 17:16:48 -0400
Received: by mail-wr0-f193.google.com with SMTP id p5-v6so3411731wre.12
        for <linux-media@vger.kernel.org>; Wed, 16 May 2018 14:16:48 -0700 (PDT)
Date: Wed, 16 May 2018 23:16:45 +0200
From: Niklas =?iso-8859-1?Q?S=F6derlund?=
        <niklas.soderlund@ragnatech.se>
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: laurent.pinchart@ideasonboard.com, horms@verge.net.au,
        geert@glider.be, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 0/6] media: rcar-vin: Brush endpoint properties
Message-ID: <20180516211645.GA17948@bigcity.dyn.berto.se>
References: <1526488352-898-1-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1526488352-898-1-git-send-email-jacopo+renesas@jmondi.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

On 2018-05-16 18:32:26 +0200, Jacopo Mondi wrote:
> Hello,
>    this series touches the bindings and the driver handling endpoint
> properties for digital subdevices of the R-Car VIN driver.
> 
> The first patch simply documents what are the endpoint properties supported
> at the moment, then the second one extends them with 'data-active'.
> 
> As the VIN hardware allows to use HSYNC as data enable signal when the CLCKENB
> pin is left unconnected, the 'data-active' property presence determinates
> if HSYNC has to be used or not as data enable signal. As a consequence, when
> running with embedded synchronism, and there is not HSYNC signal, it becomes
> mandatory to specify 'data-active' polarity in DTS.
> 
> To address this, all Gen-2 boards featuring a composite video input and
> running with embedded synchronization, now need that property to be specified
> in DTS. Before adding it, remove un-used properties as 'pclk-sample' and
> 'bus-width' from the Gen-2 bindings, as they are not parsed by the VIN driver
> and only confuse users.
> 
> Niklas, as you already know I don't have any Gen2 board. Could you give this
> a spin on Koelsch if you like the series?

I tested this on my Koelsch and capture is still working :-)

> 
> Thanks
>    j
> 
> Jacopo Mondi (6):
>   dt-bindings: media: rcar-vin: Describe optional ep properties
>   dt-bindings: media: rcar-vin: Document data-active
>   media: rcar-vin: Handle data-active property
>   media: rcar-vin: Handle CLOCKENB pin polarity
>   ARM: dts: rcar-gen2: Remove unused VIN properties
>   ARM: dts: rcar-gen2: Add 'data-active' property
> 
>  Documentation/devicetree/bindings/media/rcar_vin.txt | 18 +++++++++++++++++-
>  arch/arm/boot/dts/r8a7790-lager.dts                  |  4 +---
>  arch/arm/boot/dts/r8a7791-koelsch.dts                |  4 +---
>  arch/arm/boot/dts/r8a7791-porter.dts                 |  2 +-
>  arch/arm/boot/dts/r8a7793-gose.dts                   |  4 +---
>  arch/arm/boot/dts/r8a7794-alt.dts                    |  2 +-
>  arch/arm/boot/dts/r8a7794-silk.dts                   |  2 +-
>  drivers/media/platform/rcar-vin/rcar-core.c          | 10 ++++++++--
>  drivers/media/platform/rcar-vin/rcar-dma.c           | 11 +++++++++++
>  9 files changed, 42 insertions(+), 15 deletions(-)
> 
> --
> 2.7.4
> 

-- 
Regards,
Niklas Söderlund
