Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:45035 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbbCQAt3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Mar 2015 20:49:29 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org, linux-omap@vger.kernel.org,
	tony@atomide.com, sre@kernel.org, pali.rohar@gmail.com
Subject: Re: [PATCH 15/15] omap3isp: Deprecate platform data support
Date: Tue, 17 Mar 2015 02:49:35 +0200
Message-ID: <8566060.sCWOJrKQzE@avalon>
In-Reply-To: <1426465570-30295-16-git-send-email-sakari.ailus@iki.fi>
References: <1426465570-30295-1-git-send-email-sakari.ailus@iki.fi> <1426465570-30295-16-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thank you for the patch.

On Monday 16 March 2015 02:26:10 Sakari Ailus wrote:
> Print a warning when the driver is used with platform data. Existing
> platform data user should move to DT now.

s/user/users/

> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/platform/omap3isp/isp.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/media/platform/omap3isp/isp.c
> b/drivers/media/platform/omap3isp/isp.c index 0d6012a..82940fe 100644
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

