Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:50964 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727043AbeIZUAg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 26 Sep 2018 16:00:36 -0400
Reply-To: kieran.bingham+renesas@ideasonboard.com
Subject: Re: [PATCH v3 0/4] media: adv748x: Allow probe with a single output
 endpoint
To: Jacopo Mondi <jacopo+renesas@jmondi.org>,
        laurent.pinchart@ideasonboard.com,
        niklas.soderlund+renesas@ragnatech.se
Cc: linux-renesas-soc@vger.kernel.org, linux-media@vger.kernel.org
References: <1537183857-29173-1-git-send-email-jacopo+renesas@jmondi.org>
From: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Message-ID: <a46b39b4-6844-1835-95d6-9c0469302020@ideasonboard.com>
Date: Wed, 26 Sep 2018 14:47:29 +0100
MIME-Version: 1.0
In-Reply-To: <1537183857-29173-1-git-send-email-jacopo+renesas@jmondi.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jacopo,

On 17/09/18 12:30, Jacopo Mondi wrote:
> Hello Laurent, Kieran, Niklas,
>    to address the Ebisu board use case, this series allows the adv748x driver
> to probe with a single output connection defined.
> 
> Compared to v2, I have dropped the last patch, as without any dynamic routing
> support it is not that helpful, and I've fixed most of commit messages as
> suggested by Kieran.

Thank you,

I've applied all of these patches to my tree and submitted as a pull
request to Hans.

--
Regards

Kieran


> 
> I have tested in 3 conditions on Salvator-X M3-W:
> - AFE input not registered
> - TXB not registered (Ebisu use case)
> - AFE and TXB not registered
> 
> Let me know if I can help testing this on Ebisu.
> 
> Thanks
>    j
> 
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
>  drivers/media/i2c/adv748x/adv748x-core.c | 83 +++++++++++++++++---------------
>  drivers/media/i2c/adv748x/adv748x-csi2.c | 29 ++++-------
>  drivers/media/i2c/adv748x/adv748x-hdmi.c |  2 +-
>  drivers/media/i2c/adv748x/adv748x.h      | 19 ++++++--
>  5 files changed, 68 insertions(+), 67 deletions(-)
> 
> --
> 2.7.4
> 
