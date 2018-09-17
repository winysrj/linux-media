Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:35564 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727858AbeIQUln (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Sep 2018 16:41:43 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Jacopo Mondi <jacopo+renesas@jmondi.org>
Cc: kieran.bingham+renesas@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se,
        linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH v3 0/4] media: adv748x: Allow probe with a single output endpoint
Date: Mon, 17 Sep 2018 18:14:10 +0300
Message-ID: <14784319.JEm9TEobmr@avalon>
In-Reply-To: <1537183857-29173-1-git-send-email-jacopo+renesas@jmondi.org>
References: <1537183857-29173-1-git-send-email-jacopo+renesas@jmondi.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

Thank you for the patches.

On Monday, 17 September 2018 14:30:53 EEST Jacopo Mondi wrote:
> Hello Laurent, Kieran, Niklas,
>    to address the Ebisu board use case, this series allows the adv748x
> driver to probe with a single output connection defined.
> 
> Compared to v2, I have dropped the last patch, as without any dynamic
> routing support it is not that helpful, and I've fixed most of commit
> messages as suggested by Kieran.
> 
> I have tested in 3 conditions on Salvator-X M3-W:
> - AFE input not registered
> - TXB not registered (Ebisu use case)
> - AFE and TXB not registered
> 
> Let me know if I can help testing this on Ebisu.

For the whole series,

Tested-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

on Ebisu with your "[PATCH/RFT v2 0/8] arm64: dts: renesas: Ebisu: Add HDMI 
and CVBS input" patches.

The driver now probes properly and I can capture frames, but they're all black 
:-S I don't think that's related to this series though.

> v2 -> v3:
> - Drop v2 patch [5/5]
> - Add Kieran's tags and modify commit messages as he suggested
> 
> Jacopo Mondi (4):
>   media: i2c: adv748x: Support probing a single output
>   media: i2c: adv748x: Handle TX[A|B] power management
>   media: i2c: adv748x: Conditionally enable only CSI-2 outputs
>   media: i2c: adv748x: Register only enabled inputs
> 
>  drivers/media/i2c/adv748x/adv748x-afe.c  |  2 +-
>  drivers/media/i2c/adv748x/adv748x-core.c | 83  +++++++++++++++-------------
>  drivers/media/i2c/adv748x/adv748x-csi2.c | 29 ++++-------
>  drivers/media/i2c/adv748x/adv748x-hdmi.c |  2 +-
>  drivers/media/i2c/adv748x/adv748x.h      | 19 ++++++--
>  5 files changed, 68 insertions(+), 67 deletions(-)

-- 
Regards,

Laurent Pinchart
