Return-Path: <SRS0=tJec=Q3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FCECC43381
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 13:22:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 518302086C
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 13:22:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725881AbfBTNWG (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Feb 2019 08:22:06 -0500
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:41458 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725826AbfBTNWG (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Feb 2019 08:22:06 -0500
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id 10AF2634C7B;
        Wed, 20 Feb 2019 15:21:57 +0200 (EET)
Received: from sailus by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1gwRoz-0000Sa-LD; Wed, 20 Feb 2019 15:21:57 +0200
Date:   Wed, 20 Feb 2019 15:21:57 +0200
From:   Sakari Ailus <sakari.ailus@iki.fi>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH yavta 1/7] yavta: Refactor video_list_controls()
Message-ID: <20190220132157.g222mjamfuyh5t2l@valkosipuli.retiisi.org.uk>
References: <20190220125123.9410-1-laurent.pinchart@ideasonboard.com>
 <20190220125123.9410-2-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190220125123.9410-2-laurent.pinchart@ideasonboard.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Laurent,

Thanks for the patchset.

On Wed, Feb 20, 2019 at 02:51:17PM +0200, Laurent Pinchart wrote:
> Separate iteration over controls from printing, in order to reuse the
> iteration to implement control reset.
> 
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  yavta.c | 133 ++++++++++++++++++++++++++++++++++----------------------
>  1 file changed, 82 insertions(+), 51 deletions(-)
> 
> diff --git a/yavta.c b/yavta.c
> index 2d3b2d096f7d..98bc09810ff1 100644
> --- a/yavta.c
> +++ b/yavta.c
> @@ -484,9 +484,12 @@ static int query_control(struct device *dev, unsigned int id,
>  	query->id = id;
>  
>  	ret = ioctl(dev->fd, VIDIOC_QUERYCTRL, query);
> -	if (ret < 0 && errno != EINVAL)
> -		printf("unable to query control 0x%8.8x: %s (%d).\n",
> -		       id, strerror(errno), errno);
> +	if (ret < 0) {
> +		ret = -errno;
> +		if (ret != -EINVAL)
> +			printf("unable to query control 0x%8.8x: %s (%d).\n",
> +			       id, strerror(errno), errno);
> +	}
>  
>  	return ret;
>  }
> @@ -1120,7 +1123,45 @@ static int video_enable(struct device *dev, int enable)
>  	return 0;
>  }
>  
> -static void video_query_menu(struct device *dev, struct v4l2_queryctrl *query,
> +static int video_for_each_control(struct device *dev,
> +				  int(*callback)(struct device *dev, const struct v4l2_queryctrl *query))

This is over 80 characters per line. How about wrapping? Also int on the
above line is desperate for some breathing room before the opening
parenthesis.

> +{
> +	struct v4l2_queryctrl query;
> +	unsigned int nctrls = 0;
> +	unsigned int id;
> +	int ret;
> +
> +#ifndef V4L2_CTRL_FLAG_NEXT_CTRL

This was added back in 2012. Do you think it's still worth checking for it?

Not related to this patch though, just a general remark.

> +	unsigned int i;
> +
> +	for (i = V4L2_CID_BASE; i <= V4L2_CID_LASTP1; ++i) {
> +		id = i;
> +#else
> +	id = 0;
> +	while (1) {
> +		id |= V4L2_CTRL_FLAG_NEXT_CTRL;
> +#endif
> +
> +		ret = query_control(dev, id, &query);
> +		if (ret == -EINVAL)
> +			break;
> +		if (ret < 0)
> +			return ret;
> +
> +		id = query.id;
> +
> +		ret = callback(dev, &query);
> +		if (ret < 0)
> +			return ret;
> +
> +		if (ret)
> +			nctrls++;
> +	}
> +
> +	return nctrls;
> +}
> +
> +static void video_query_menu(struct device *dev, const struct v4l2_queryctrl *query,
>  			     unsigned int value)
>  {
>  	struct v4l2_querymenu menu;
> @@ -1142,83 +1183,68 @@ static void video_query_menu(struct device *dev, struct v4l2_queryctrl *query,
>  	};
>  }
>  
> -static int video_print_control(struct device *dev, unsigned int id, bool full)
> +static int video_print_control(struct device *dev,
> +			       const struct v4l2_queryctrl *query, bool full)
>  {
>  	struct v4l2_ext_control ctrl;
> -	struct v4l2_queryctrl query;
>  	char sval[24];
>  	char *current = sval;
>  	int ret;
>  
> -	ret = query_control(dev, id, &query);
> -	if (ret < 0)
> -		return ret;
> +	if (query->flags & V4L2_CTRL_FLAG_DISABLED)
> +		return 0;
>  
> -	if (query.flags & V4L2_CTRL_FLAG_DISABLED)
> -		return query.id;
> -
> -	if (query.type == V4L2_CTRL_TYPE_CTRL_CLASS) {
> -		printf("--- %s (class 0x%08x) ---\n", query.name, query.id);
> -		return query.id;
> +	if (query->type == V4L2_CTRL_TYPE_CTRL_CLASS) {
> +		printf("--- %s (class 0x%08x) ---\n", query->name, query->id);
> +		return 0;
>  	}
>  
> -	ret = get_control(dev, &query, &ctrl);
> +	ret = get_control(dev, query, &ctrl);
>  	if (ret < 0)
>  		strcpy(sval, "n/a");
> -	else if (query.type == V4L2_CTRL_TYPE_INTEGER64)
> +	else if (query->type == V4L2_CTRL_TYPE_INTEGER64)
>  		sprintf(sval, "%lld", ctrl.value64);
> -	else if (query.type == V4L2_CTRL_TYPE_STRING)
> +	else if (query->type == V4L2_CTRL_TYPE_STRING)
>  		current = ctrl.string;
>  	else
>  		sprintf(sval, "%d", ctrl.value);
>  
>  	if (full)
>  		printf("control 0x%08x `%s' min %d max %d step %d default %d current %s.\n",
> -			query.id, query.name, query.minimum, query.maximum,
> -			query.step, query.default_value, current);
> +			query->id, query->name, query->minimum, query->maximum,
> +			query->step, query->default_value, current);
>  	else
> -		printf("control 0x%08x current %s.\n", query.id, current);
> +		printf("control 0x%08x current %s.\n", query->id, current);
>  
> -	if (query.type == V4L2_CTRL_TYPE_STRING)
> +	if (query->type == V4L2_CTRL_TYPE_STRING)
>  		free(ctrl.string);
>  
>  	if (!full)
> -		return query.id;
> +		return 1;
>  
> -	if (query.type == V4L2_CTRL_TYPE_MENU ||
> -	    query.type == V4L2_CTRL_TYPE_INTEGER_MENU)
> -		video_query_menu(dev, &query, ctrl.value);
> +	if (query->type == V4L2_CTRL_TYPE_MENU ||
> +	    query->type == V4L2_CTRL_TYPE_INTEGER_MENU)
> +		video_query_menu(dev, query, ctrl.value);
>  
> -	return query.id;
> +	return 1;
> +}
> +
> +static int __video_print_control(struct device *dev,
> +				 const struct v4l2_queryctrl *query)
> +{
> +	return video_print_control(dev, query, true);
>  }
>  
>  static void video_list_controls(struct device *dev)
>  {
> -	unsigned int nctrls = 0;
> -	unsigned int id;
>  	int ret;
>  
> -#ifndef V4L2_CTRL_FLAG_NEXT_CTRL
> -	unsigned int i;
> +	ret = video_for_each_control(dev, __video_print_control);
> +	if (ret < 0)
> +		return;
>  
> -	for (i = V4L2_CID_BASE; i <= V4L2_CID_LASTP1; ++i) {
> -		id = i;
> -#else
> -	id = 0;
> -	while (1) {
> -		id |= V4L2_CTRL_FLAG_NEXT_CTRL;
> -#endif
> -
> -		ret = video_print_control(dev, id, true);
> -		if (ret < 0)
> -			break;
> -
> -		id = ret;
> -		nctrls++;
> -	}
> -
> -	if (nctrls)
> -		printf("%u control%s found.\n", nctrls, nctrls > 1 ? "s" : "");
> +	if (ret)
> +		printf("%u control%s found.\n", ret, ret > 1 ? "s" : "");
>  	else
>  		printf("No control found.\n");
>  }
> @@ -2184,8 +2210,13 @@ int main(int argc, char *argv[])
>  	if (do_log_status)
>  		video_log_status(&dev);
>  
> -	if (do_get_control)
> -		video_print_control(&dev, ctrl_name, false);
> +	if (do_get_control) {
> +		struct v4l2_queryctrl query;
> +
> +		ret = query_control(&dev, ctrl_name, &query);
> +		if (ret == 0)
> +			video_print_control(&dev, &query, false);
> +	}
>  
>  	if (do_set_control)
>  		set_control(&dev, ctrl_name, ctrl_value);

-- 
Cheers,

Sakari Ailus
