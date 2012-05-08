Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:42151 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755917Ab2EHTdv (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 8 May 2012 15:33:51 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-media@vger.kernel.org
Subject: Re: [media-ctl PATCH v2 2/2] Compose rectangle support for libv4l2subdev
Date: Tue, 08 May 2012 21:33:51 +0200
Message-ID: <2306854.DWyd0NlFfV@avalon>
In-Reply-To: <1336398396-31526-2-git-send-email-sakari.ailus@iki.fi>
References: <1336398396-31526-1-git-send-email-sakari.ailus@iki.fi> <1336398396-31526-2-git-send-email-sakari.ailus@iki.fi>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

Thanks for the patch.

On Monday 07 May 2012 16:46:36 Sakari Ailus wrote:
> Signed-off-by: Sakari Ailus <sakari.ailus@iki.fi>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  src/main.c       |   14 ++++++++++++++
>  src/options.c    |    6 ++++--
>  src/v4l2subdev.c |   32 +++++++++++++++++++++++---------
>  3 files changed, 41 insertions(+), 11 deletions(-)
> 
> diff --git a/src/main.c b/src/main.c
> index 2f57352..a989669 100644
> --- a/src/main.c
> +++ b/src/main.c
> @@ -77,6 +77,20 @@ static void v4l2_subdev_print_format(struct media_entity
> *entity, printf("\n\t\t crop:%u,%u/%ux%u", rect.left, rect.top,
>  		       rect.width, rect.height);
> 
> +	ret = v4l2_subdev_get_selection(entity, &rect, pad,
> +					V4L2_SUBDEV_SEL_TGT_COMPOSE_BOUNDS,
> +					which);
> +	if (ret == 0)
> +		printf("\n\t\t compose.bounds:%u,%u/%ux%u",
> +		       rect.left, rect.top, rect.width, rect.height);
> +
> +	ret = v4l2_subdev_get_selection(entity, &rect, pad,
> +					V4L2_SUBDEV_SEL_TGT_COMPOSE_ACTUAL,
> +					which);
> +	if (ret == 0)
> +		printf("\n\t\t compose:%u,%u/%ux%u",
> +		       rect.left, rect.top, rect.width, rect.height);
> +
>  	printf("]");
>  }
> 
> diff --git a/src/options.c b/src/options.c
> index 46f6bef..8e80bd0 100644
> --- a/src/options.c
> +++ b/src/options.c
> @@ -56,12 +56,14 @@ static void usage(const char *argv0, int verbose)
>  	printf("\tv4l2                = pad, '[', v4l2-cfgs ']' ;\n");
>  	printf("\tv4l2-cfgs           = v4l2-cfg [ ',' v4l2-cfg ] ;\n");
>  	printf("\tv4l2-cfg            = v4l2-mbusfmt | v4l2-crop\n");
> -	printf("\t                      | v4l2 frame interval ;\n");
> +	printf("\t                      | v4l2-compose | v4l2 frame interval
> ;\n"); printf("\tv4l2-mbusfmt        = 'fmt:', fcc, '/', size ;\n");
>  	printf("\tpad                 = entity, ':', pad number ;\n");
>  	printf("\tentity              = entity number | ( '\"', entity name, '\"'
> ) ;\n"); printf("\tsize                = width, 'x', height ;\n");
> -	printf("\tv4l2-crop           = 'crop:(', left, ',', top, ')/', size
> ;\n"); +	printf("\tv4l2-crop           = 'crop:', v4l2-rectangle ;\n");
> +	printf("\tv4l2-compose        = 'compose:', v4l2-rectangle ;\n");
> +	printf("\tv4l2-rectangle      = '(', left, ',', top, ')/', size ;\n");
>  	printf("\tv4l2 frame interval = '@', numerator, '/', denominator ;\n");
>  	printf("where the fields are\n");
>  	printf("\tentity number   Entity numeric identifier\n");
> diff --git a/src/v4l2subdev.c b/src/v4l2subdev.c
> index 6881553..0abb4f4 100644
> --- a/src/v4l2subdev.c
> +++ b/src/v4l2subdev.c
> @@ -320,8 +320,8 @@ static int strhazit(const char *str, const char **p)
> 
>  static struct media_pad *v4l2_subdev_parse_pad_format(
>  	struct media_device *media, struct v4l2_mbus_framefmt *format,
> -	struct v4l2_rect *crop, struct v4l2_fract *interval, const char *p,
> -	char **endp)
> +	struct v4l2_rect *crop, struct v4l2_rect *compose,
> +	struct v4l2_fract *interval, const char *p, char **endp)
>  {
>  	struct media_pad *pad;
>  	char *end;
> @@ -358,6 +358,15 @@ static struct media_pad *v4l2_subdev_parse_pad_format(
>  			continue;
>  		}
> 
> +		if (!strhazit("compose:", &p)) {
> +			ret = v4l2_subdev_parse_rectangle(compose, p, &end);
> +			if (ret < 0)
> +				return NULL;
> +
> +			for (p = end; isspace(*p); p++);
> +			continue;
> +		}
> +
>  		if (*p == '@') {
>  			ret = v4l2_subdev_parse_frame_interval(interval, ++p, &end);
>  			if (ret < 0)
> @@ -471,30 +480,35 @@ static int v4l2_subdev_parse_setup_format(struct
> media_device *media, struct v4l2_mbus_framefmt format = { 0, 0, 0 };
>  	struct media_pad *pad;
>  	struct v4l2_rect crop = { -1, -1, -1, -1 };
> +	struct v4l2_rect compose = crop;
>  	struct v4l2_fract interval = { 0, 0 };
>  	unsigned int i;
>  	char *end;
>  	int ret;
> 
> -	pad = v4l2_subdev_parse_pad_format(media, &format, &crop, &interval,
> -					   p, &end);
> +	pad = v4l2_subdev_parse_pad_format(media, &format, &crop, &compose,
> +					   &interval, p, &end);
>  	if (pad == NULL) {
>  		media_dbg(media, "Unable to parse format\n");
>  		return -EINVAL;
>  	}
> 
> -	if (pad->flags & MEDIA_PAD_FL_SOURCE) {
> -		ret = set_selection(pad, V4L2_SUBDEV_SEL_TGT_CROP_ACTUAL, &crop);
> +	if (pad->flags & MEDIA_PAD_FL_SINK) {
> +		ret = set_format(pad, &format);
>  		if (ret < 0)
>  			return ret;
>  	}
> 
> -	ret = set_format(pad, &format);
> +	ret = set_selection(pad, V4L2_SUBDEV_SEL_TGT_CROP_ACTUAL, &crop);
>  	if (ret < 0)
>  		return ret;
> 
> -	if (pad->flags & MEDIA_PAD_FL_SINK) {
> -		ret = set_selection(pad, V4L2_SUBDEV_SEL_TGT_CROP_ACTUAL, &crop);
> +	ret = set_selection(pad, V4L2_SUBDEV_SEL_TGT_COMPOSE_ACTUAL, &compose);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (pad->flags & MEDIA_PAD_FL_SOURCE) {
> +		ret = set_format(pad, &format);
>  		if (ret < 0)
>  			return ret;
>  	}
-- 
Regards,

Laurent Pinchart

