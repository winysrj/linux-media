Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:56232 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753360Ab2E1P6u (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 May 2012 11:58:50 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org
Subject: Re: [media-ctl PATCH 1/1] media-ctl: Compose print fixes
Date: Mon, 28 May 2012 17:58:35 +0200
Message-ID: <1370836.N3WTkptTkm@avalon>
In-Reply-To: <1338050597-19251-1-git-send-email-sakari.ailus@iki.fi>
References: <1338050597-19251-1-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Saturday 26 May 2012 19:43:16 Sakari Ailus wrote:
> The compose rectangles were printed incorrectly in my recent patch "Compose
> rectangle support for libv4l2subdev" without parenthesis. Fix this.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>
> ---
> Hi Laurent,
> 
> Could you apply this simple fix to your tree? Currently the compose
> rectangles are printed differently than the crop rectangles which certainly
> isn't the intention.

Done, thank you.

>  src/main.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/src/main.c b/src/main.c
> index af16818..d10094b 100644
> --- a/src/main.c
> +++ b/src/main.c
> @@ -81,14 +81,14 @@ static void v4l2_subdev_print_format(struct media_entity
> *entity, V4L2_SUBDEV_SEL_TGT_COMPOSE_BOUNDS,
>  					which);
>  	if (ret == 0)
> -		printf("\n\t\t compose.bounds:%u,%u/%ux%u",
> +		printf("\n\t\t compose.bounds:(%u,%u)/%ux%u",
>  		       rect.left, rect.top, rect.width, rect.height);
> 
>  	ret = v4l2_subdev_get_selection(entity, &rect, pad,
>  					V4L2_SUBDEV_SEL_TGT_COMPOSE_ACTUAL,
>  					which);
>  	if (ret == 0)
> -		printf("\n\t\t compose:%u,%u/%ux%u",
> +		printf("\n\t\t compose:(%u,%u)/%ux%u",
>  		       rect.left, rect.top, rect.width, rect.height);
> 
>  	printf("]\n");

-- 
Regards,

Laurent Pinchart

