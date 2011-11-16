Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:48462 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755394Ab1KPKcl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Nov 2011 05:32:41 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH 2/9] as3645a: print vendor and revision of the chip
Date: Wed, 16 Nov 2011 11:32:43 +0100
Cc: linux-media@vger.kernel.org,
	sakari.ailus@maxwell.research.nokia.com
References: <1321374065-20063-3-git-send-email-laurent.pinchart@ideasonboard.com> <cover.1321379276.git.andriy.shevchenko@linux.intel.com> <461cc7fb0ff5b466b2a53b823241c5792ba7900a.1321379276.git.andriy.shevchenko@linux.intel.com>
In-Reply-To: <461cc7fb0ff5b466b2a53b823241c5792ba7900a.1321379276.git.andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201111161132.48907.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Andy,

Thanks for the patch.

On Tuesday 15 November 2011 18:49:54 Andy Shevchenko wrote:
> The as3645a_registered() is used to detect connected chip. It would be nice
> to print the detected value every time we load the module. The "Vendor" is
> probably better word to use there. For example, lm3555 (NSC) is slightly
> different to as3645a.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/media/video/as3645a.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/video/as3645a.c b/drivers/media/video/as3645a.c
> index ef1226d..8882a14 100644
> --- a/drivers/media/video/as3645a.c
> +++ b/drivers/media/video/as3645a.c
> @@ -602,8 +602,8 @@ static int as3645a_registered(struct v4l2_subdev *sd)
>  		factory = "Unknown";
>  	}
> 
> -	dev_dbg(&client->dev, "Factory: %s(%d) Version: %d\n", factory, man,
> -		version);
> +	dev_info(&client->dev, "Chip vendor: %s(%d) Version: %d\n", factory,
> +			man, version);

I'll rename the factory variable to vendor.

>  	rval = as3645a_write(flash, AS_PASSWORD_REG, AS_PASSWORD_UNLOCK_VALUE);
>  	if (rval < 0)

-- 
Regards,

Laurent Pinchart
