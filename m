Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.131]:59333 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035AbaERVwS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 18 May 2014 17:52:18 -0400
Date: Sun, 18 May 2014 23:51:59 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Josh Wu <josh.wu@atmel.com>
cc: linux-media@vger.kernel.org, m.chehab@samsung.com,
	nicolas.ferre@atmel.com, linux-arm-kernel@lists.infradead.org,
	grant.likely@linaro.org, galak@codeaurora.org, rob@landley.net,
	mark.rutland@arm.com, robh+dt@kernel.org,
	ijc+devicetree@hellion.org.uk, pawel.moll@arm.com,
	devicetree@vger.kernel.org, laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH v2 3/3] [media] atmel-isi: add primary DT support
In-Reply-To: <1395744320-15025-1-git-send-email-josh.wu@atmel.com>
Message-ID: <Pine.LNX.4.64.1405182308110.23804@axis700.grange>
References: <1395744087-5753-1-git-send-email-josh.wu@atmel.com>
 <1395744320-15025-1-git-send-email-josh.wu@atmel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 25 Mar 2014, Josh Wu wrote:

> This patch add the DT support for Atmel ISI driver.
> It use the same v4l2 DT interface that defined in video-interfaces.txt.
> 
> Signed-off-by: Josh Wu <josh.wu@atmel.com>
> Cc: devicetree@vger.kernel.org
> ---
> v1 --> v2:
>  refine the binding document.
>  add port node description.
>  removed the optional property.
> 
>  .../devicetree/bindings/media/atmel-isi.txt        |   50 ++++++++++++++++++++
>  drivers/media/platform/soc_camera/atmel-isi.c      |   31 +++++++++++-
>  2 files changed, 79 insertions(+), 2 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/media/atmel-isi.txt

[snip]

> diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
> index f4add0a..d6a1f7b 100644
> --- a/drivers/media/platform/soc_camera/atmel-isi.c
> +++ b/drivers/media/platform/soc_camera/atmel-isi.c

[snip]

> @@ -885,6 +887,20 @@ static int atmel_isi_remove(struct platform_device *pdev)
>  	return 0;
>  }
>  
> +static int atmel_isi_probe_dt(struct atmel_isi *isi,
> +			struct platform_device *pdev)
> +{
> +	struct device_node *node = pdev->dev.of_node;
> +
> +	/* Default settings for ISI */
> +	isi->pdata.full_mode = 1;
> +	isi->pdata.mck_hz = ISI_DEFAULT_MCLK_FREQ;
> +	isi->pdata.frate = ISI_CFG1_FRATE_CAPTURE_ALL;

The above flags eventually should probably partially be added as new 
driver-specific DT properties, partially derived from DT clock bindings. 
But I'm ok to have them fixed like this in the initial version.

> +	isi->pdata.data_width_flags = ISI_DATAWIDTH_8 | ISI_DATAWIDTH_10;

Whereas these flags, I think, should already now be derived from the 
bus-width standard property? v4l2_of_parse_parallel_bus() will extract 
them for you and I just asked Ben to add a call to 
v4l2_of_parse_endpoint() to his patch. Consequently you'll have to 
rearrange bus-width interpretation in isi_camera_try_bus_param() a bit and 
use OF parsing results there directly if available? Or maybe you find a 
better way. It would certainly be better to extend your probing code and 
just use OF results to initialise isi->width_flags, but that might be 
impossible, because OF parsing would be performed inside 
soc_camera_host_register() and your isi_camera_try_bus_param() can also be 
called immediately from it if all required I2C devices are already 
available? If your I2C subdevice drivers defer probing until the host has 
probed, then you could initialise .width_flags after 
soc_camera_host_register(), but you cannot rely on that.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
