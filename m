Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:42956 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756025Ab2DMTrE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Apr 2012 15:47:04 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org
Subject: Re: [yavta PATCH 1/3] Support integer menus.
Date: Fri, 13 Apr 2012 21:47:14 +0200
Message-ID: <2967674.Tm7K8VO7YX@avalon>
In-Reply-To: <1334220095-1698-1-git-send-email-sakari.ailus@iki.fi>
References: <1334220095-1698-1-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the patch.

The code looks fine, but unfortunately breaks compilation when using kernel 
headers < v3.5 (which is a pretty common case as of today ;-)).

V4L2_CTRL_TYPE_INTEGER_MENU is an enumerated value, not a pre-processor 
#define, so it's difficult to test for it using conditional compilation.

Maybe including a copy of videodev2.h in the yavta repository is the best 
option ?

On Thursday 12 April 2012 11:41:33 Sakari Ailus wrote:
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> ---
>  yavta.c |   18 +++++++++++-------
>  1 files changed, 11 insertions(+), 7 deletions(-)
> 
> diff --git a/yavta.c b/yavta.c
> index 72679c2..8db6e1e 100644
> --- a/yavta.c
> +++ b/yavta.c
> @@ -564,19 +564,22 @@ static int video_enable(struct device *dev, int
> enable) return 0;
>  }
> 
> -static void video_query_menu(struct device *dev, unsigned int id,
> -			     unsigned int min, unsigned int max)
> +static void video_query_menu(struct device *dev, struct v4l2_queryctrl
> *query) {
>  	struct v4l2_querymenu menu;
>  	int ret;
> 
> -	for (menu.index = min; menu.index <= max; menu.index++) {
> -		menu.id = id;
> +	for (menu.index = query->minimum; menu.index <= query->maximum;
> +	     menu.index++) {
> +		menu.id = query->id;
>  		ret = ioctl(dev->fd, VIDIOC_QUERYMENU, &menu);
>  		if (ret < 0)
>  			continue;
> 
> -		printf("  %u: %.32s\n", menu.index, menu.name);
> +		if (query->type == V4L2_CTRL_TYPE_MENU)
> +			printf("  %u: %.32s\n", menu.index, menu.name);
> +		else
> +			printf("  %u: %lld\n", menu.index, menu.value);
>  	};
>  }
> 
> @@ -621,8 +624,9 @@ static void video_list_controls(struct device *dev)
>  			query.id, query.name, query.minimum, query.maximum,
>  			query.step, query.default_value, value);
> 
> -		if (query.type == V4L2_CTRL_TYPE_MENU)
> -			video_query_menu(dev, query.id, query.minimum, query.maximum);
> +		if (query.type == V4L2_CTRL_TYPE_MENU ||
> +		    query.type == V4L2_CTRL_TYPE_INTEGER_MENU)
> +			video_query_menu(dev, &query);
> 
>  		nctrls++;
>  	}
-- 
Regards,

Laurent Pinchart

