Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:34695 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751268AbaKJNQW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Nov 2014 08:16:22 -0500
Date: Mon, 10 Nov 2014 15:06:59 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Marina Vasilevsky <marinavasilevsky@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1] v4l: omap4iss: Fix dual lane camera mode problem
Message-ID: <20141110130659.GA8214@valkosipuli.retiisi.org.uk>
References: <CAGU7XX3ODOJ+xRk9GAJi8Wk8bj5LONR7WVFh3ujVM1oL=HBL7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGU7XX3ODOJ+xRk9GAJi8Wk8bj5LONR7WVFh3ujVM1oL=HBL7g@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Marina,

On Mon, Nov 10, 2014 at 10:11:31AM +0200, Marina Vasilevsky wrote:
> ---
>  drivers/staging/media/omap4iss/iss_csiphy.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/media/omap4iss/iss_csiphy.c
> b/drivers/staging/media/omap4iss/iss_csiphy.c
> index 7c3d55d..b6e0b32 100644
> --- a/drivers/staging/media/omap4iss/iss_csiphy.c
> +++ b/drivers/staging/media/omap4iss/iss_csiphy.c
> @@ -196,8 +196,7 @@ int omap4iss_csiphy_config(struct iss_device *iss,
>          return -EINVAL;
> 
>      csi2_ddrclk_khz = pipe->external_rate / 1000
> -        / (2 * csi2->phy->used_data_lanes)
> -        * pipe->external_bpp;
> +        / 2 * pipe->external_bpp;
> 
>      /*
>       * THS_TERM: Programmed value = ceil(12.5 ns/DDRClk period) - 1.
> -- 
> 
> Hello,
> 
> I tested this fix with OMAP4 connected to OV5640 camera using 2 lanes.
> Have anybody tested other camera with 2 lanes connected to OMAP?
> 
> The value csi2_ddrclk_khz is different per camera.
> I have also driver for OV7695. Current iss params structure does not
> allow to configure it properly from board file.

Are you certain the pixel rate value provided by the sensor driver is
correct?

The formula in iss_csiphy.c is fine as far as I understand.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
