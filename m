Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:35170 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780AbbCGXfs (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 7 Mar 2015 18:35:48 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, devicetree@vger.kernel.org,
	pali.rohar@gmail.com
Subject: Re: [RFC 18/18] omap3isp: Deprecate platform data support
Date: Sun, 08 Mar 2015 01:35:48 +0200
Message-ID: <3221299.J6qFz2skEr@avalon>
In-Reply-To: <1425764475-27691-19-git-send-email-sakari.ailus@iki.fi>
References: <1425764475-27691-1-git-send-email-sakari.ailus@iki.fi> <1425764475-27691-19-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Saturday 07 March 2015 23:41:15 Sakari Ailus wrote:
> Print a warning when the driver is used with platform data. Existing
> platform data user should move to DT now.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/platform/omap3isp/isp.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/media/platform/omap3isp/isp.c
> b/drivers/media/platform/omap3isp/isp.c index 2c9bc0d..e4a78bb 100644
> --- a/drivers/media/platform/omap3isp/isp.c
> +++ b/drivers/media/platform/omap3isp/isp.c
> @@ -2447,6 +2447,8 @@ static int isp_probe(struct platform_device *pdev)
>  		isp->syscon = syscon_regmap_lookup_by_pdevname("syscon.0");
>  		if (IS_ERR(isp->syscon))
>  			return PTR_ERR(isp->syscon);
> +		dev_warn(&pdev->dev,
> +			 "Platform data support is deprecated! Please move to DT now!
\n");
>  	}
> 
>  	isp->autoidle = autoidle;

-- 
Regards,

Laurent Pinchart

