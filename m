Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:39338 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbbCKSl0 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Mar 2015 14:41:26 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, prabhakar.csengg@gmail.com
Subject: Re: [PATCH 2/3] smiapp: Read link-frequencies property from the endpoint node
Date: Wed, 11 Mar 2015 20:41:28 +0200
Message-ID: <3221454.r85COdfNJV@avalon>
In-Reply-To: <1425950282-30548-3-git-send-email-sakari.ailus@iki.fi>
References: <1425950282-30548-1-git-send-email-sakari.ailus@iki.fi> <1425950282-30548-3-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Tuesday 10 March 2015 03:18:01 Sakari Ailus wrote:
> The documentation stated that the link-frequencies property belongs to the
> endpoint node, not to the device's of_node. Fix this.
> 
> There are no DT board descriptions using the driver yet, so a fix in the
> driver is sufficient.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/i2c/smiapp/smiapp-core.c |    5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/i2c/smiapp/smiapp-core.c
> b/drivers/media/i2c/smiapp/smiapp-core.c index 565a00c..ecae76b 100644
> --- a/drivers/media/i2c/smiapp/smiapp-core.c
> +++ b/drivers/media/i2c/smiapp/smiapp-core.c
> @@ -3022,8 +3022,7 @@ static struct smiapp_platform_data
> *smiapp_get_pdata(struct device *dev) dev_dbg(dev, "reset %d, nvm %d, clk
> %d, csi %d\n", pdata->xshutdown, pdata->nvm_size, pdata->ext_clk,
> pdata->csi_signalling_mode);
> 
> -	rval = of_get_property(
> -		dev->of_node, "link-frequencies", &asize) ? 0 : -ENOENT;
> +	rval = of_get_property(ep, "link-frequencies", &asize) ? 0 : -ENOENT;
>  	if (rval) {
>  		dev_warn(dev, "can't get link-frequencies array size\n");
>  		goto out_err;
> @@ -3037,7 +3036,7 @@ static struct smiapp_platform_data
> *smiapp_get_pdata(struct device *dev)
> 
>  	asize /= sizeof(*pdata->op_sys_clock);
>  	rval = of_property_read_u64_array(
> -		dev->of_node, "link-frequencies", pdata->op_sys_clock, asize);
> +		ep, "link-frequencies", pdata->op_sys_clock, asize);
>  	if (rval) {
>  		dev_warn(dev, "can't get link-frequencies\n");
>  		goto out_err;

-- 
Regards,

Laurent Pinchart

