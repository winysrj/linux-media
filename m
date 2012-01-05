Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59689 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932591Ab2AEQCr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Jan 2012 11:02:47 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [yavta PATCH 1/1] Support integer menus.
Date: Thu, 5 Jan 2012 17:03:04 +0100
Cc: linux-media@vger.kernel.org, snjw23@gmail.com, hverkuil@xs4all.nl,
	andriy.shevchenko@linux.intel.com, t.stanislaws@samsung.com,
	tuukkat76@gmail.com, k.debski@samsung.com, riverful@gmail.com
References: <4EF0EFC9.6080501@maxwell.research.nokia.com> <1325065622-18323-1-git-send-email-sakari.ailus@iki.fi>
In-Reply-To: <1325065622-18323-1-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201201051703.05313.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the patch.

On Wednesday 28 December 2011 10:47:01 Sakari Ailus wrote:
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> ---
>  yavta.c |   12 +++++++++---
>  1 files changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/yavta.c b/yavta.c
> index c0e9acb..9b8a80e 100644
> --- a/yavta.c
> +++ b/yavta.c
> @@ -551,6 +551,7 @@ static int video_enable(struct device *dev, int enable)
>  }
> 
>  static void video_query_menu(struct device *dev, unsigned int id,
> +			     unsigned int type,
>  			     unsigned int min, unsigned int max)
>  {
>  	struct v4l2_querymenu menu;
> @@ -562,7 +563,10 @@ static void video_query_menu(struct device *dev,
> unsigned int id, if (ret < 0)
>  			continue;
> 
> -		printf("  %u: %.32s\n", menu.index, menu.name);
> +		if (type == V4L2_CTRL_TYPE_MENU)
> +			printf("  %u: %.32s\n", menu.index, menu.name);
> +		else
> +			printf("  %u: %lld\n", menu.index, menu.value);
>  	};
>  }
> 
> @@ -607,8 +611,10 @@ static void video_list_controls(struct device *dev)
>  			query.id, query.name, query.minimum, query.maximum,
>  			query.step, query.default_value, value);
> 
> -		if (query.type == V4L2_CTRL_TYPE_MENU)
> -			video_query_menu(dev, query.id, query.minimum, query.maximum);
> +		if (query.type == V4L2_CTRL_TYPE_MENU ||
> +		    query.type == V4L2_CTRL_TYPE_INTEGER_MENU)
> +			video_query_menu(dev, query.id, query.type,
> +					 query.minimum, query.maximum);

What about passing &query to the function instead ?

> 
>  		nctrls++;
>  	}

-- 
Regards,

Laurent Pinchart
