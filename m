Return-Path: <SRS0=tJec=Q3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0DDEC43381
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 14:55:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 648F22147C
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 14:55:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ideasonboard.com header.i=@ideasonboard.com header.b="JU6BOu6Q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbfBTOzO (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Feb 2019 09:55:14 -0500
Received: from perceval.ideasonboard.com ([213.167.242.64]:40116 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726219AbfBTOzN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Feb 2019 09:55:13 -0500
Received: from pendragon.ideasonboard.com (dfj612yhrgyx302h3jwwy-3.rev.dnainternet.fi [IPv6:2001:14ba:21f5:5b00:ce28:277f:58d7:3ca4])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 5AE742D1;
        Wed, 20 Feb 2019 15:55:11 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1550674511;
        bh=i+64uIQEJQYYGh4SM9c5DBFpSemz7X73pYoa7Ta/kKU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JU6BOu6QHmUuAi86dRR9I3lGw1ApGucCPn+BWvHUZ34wU74peIISAc/nBY6Uw5VJB
         quFwWaANqAcGAtFVjAdPPLdfcW/yINGatshNPP4unzJ1RVfJdCtUG8+/HggzgGPvI6
         NTULB28J1Zkt0WwVKaykdI8Gi5kOTaHGgDmu6HXU=
Date:   Wed, 20 Feb 2019 16:55:06 +0200
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Sakari Ailus <sakari.ailus@iki.fi>
Cc:     linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH yavta 3/7] Implement compound control get support
Message-ID: <20190220145506.GC3516@pendragon.ideasonboard.com>
References: <20190220125123.9410-1-laurent.pinchart@ideasonboard.com>
 <20190220125123.9410-4-laurent.pinchart@ideasonboard.com>
 <20190220140643.fq5gp6dcwgbhfqip@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190220140643.fq5gp6dcwgbhfqip@valkosipuli.retiisi.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Sakari,

On Wed, Feb 20, 2019 at 04:06:43PM +0200, Sakari Ailus wrote:
> On Wed, Feb 20, 2019 at 02:51:19PM +0200, Laurent Pinchart wrote:
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > ---
> >  yavta.c | 154 ++++++++++++++++++++++++++++++++++++++++++--------------
> >  1 file changed, 115 insertions(+), 39 deletions(-)
> > 
> > diff --git a/yavta.c b/yavta.c
> > index eb50d592736f..6428c22f88d7 100644
> > --- a/yavta.c
> > +++ b/yavta.c
> > @@ -529,6 +529,7 @@ static int get_control(struct device *dev,
> >  		       struct v4l2_ext_control *ctrl)
> >  {
> >  	struct v4l2_ext_controls ctrls;
> > +	struct v4l2_control old;
> >  	int ret;
> >  
> >  	memset(&ctrls, 0, sizeof(ctrls));
> > @@ -540,34 +541,32 @@ static int get_control(struct device *dev,
> >  
> >  	ctrl->id = query->id;
> >  
> > -	if (query->type == V4L2_CTRL_TYPE_STRING) {
> > -		ctrl->string = malloc(query->maximum + 1);
> > -		if (ctrl->string == NULL)
> > +	if (query->flags & V4L2_CTRL_FLAG_HAS_PAYLOAD) {
> 
> This breaks string controls for kernels that don't have
> V4L2_CTRL_FLAG_HAS_PAYLOAD. As you still support kernels that have no
> V4L2_CTRL_FLAG_NEXT_CTRL, how about checking for string type specifically?

Nasty one :-( I'll do so.

> > +		ctrl->size = query->elems * query->elem_size;
> > +		ctrl->ptr = malloc(ctrl->size);
> > +		if (ctrl->ptr == NULL)
> >  			return -ENOMEM;
> > -
> > -		ctrl->size = query->maximum + 1;
> >  	}
> >  
> >  	ret = ioctl(dev->fd, VIDIOC_G_EXT_CTRLS, &ctrls);
> >  	if (ret != -1)
> >  		return 0;
> >  
> > -	if (query->type != V4L2_CTRL_TYPE_INTEGER64 &&
> > -	    query->type != V4L2_CTRL_TYPE_STRING &&
> > -	    (errno == EINVAL || errno == ENOTTY)) {
> > -		struct v4l2_control old;
> > +	if (query->flags & V4L2_CTRL_FLAG_HAS_PAYLOAD)
> > +		free(ctrl->ptr);
> >  
> > -		old.id = query->id;
> > -		ret = ioctl(dev->fd, VIDIOC_G_CTRL, &old);
> > -		if (ret != -1) {
> > -			ctrl->value = old.value;
> > -			return 0;
> > -		}
> > -	}
> > +	if (query->flags & V4L2_CTRL_FLAG_HAS_PAYLOAD ||
> > +	    query->type == V4L2_CTRL_TYPE_INTEGER64 ||
> > +	    (errno != EINVAL && errno != ENOTTY))
> > +		return -errno;
> >  
> > -	printf("unable to get control 0x%8.8x: %s (%d).\n",
> > -		query->id, strerror(errno), errno);
> > -	return -1;
> > +	old.id = query->id;
> > +	ret = ioctl(dev->fd, VIDIOC_G_CTRL, &old);
> > +	if (ret < 0)
> > +		return -errno;
> > +
> > +	ctrl->value = old.value;
> > +	return 0;
> >  }
> >  
> >  static void set_control(struct device *dev, unsigned int id,
> > @@ -1170,7 +1169,7 @@ static int video_for_each_control(struct device *dev,
> >  #else
> >  	id = 0;
> >  	while (1) {
> > -		id |= V4L2_CTRL_FLAG_NEXT_CTRL;
> > +		id |= V4L2_CTRL_FLAG_NEXT_CTRL | V4L2_CTRL_FLAG_NEXT_COMPOUND;
> >  #endif
> >  
> >  		ret = query_control(dev, id, &query);
> > @@ -1215,13 +1214,76 @@ static void video_query_menu(struct device *dev,
> >  	};
> >  }
> >  
> > +static void video_print_control_array(const struct v4l2_query_ext_ctrl *query,
> > +				      struct v4l2_ext_control *ctrl)
> > +{
> > +	unsigned int i;
> > +
> > +	printf("{");
> 
> A space would be nice after the opening brace, also before the closing one.

Isn't that a matter of taste ? :-)

> > +
> > +	for (i = 0; i < query->elems; ++i) {
> > +		switch (query->type) {
> > +		case V4L2_CTRL_TYPE_U8:
> > +			printf("%u", ctrl->p_u8[i]);
> > +			break;
> > +		case V4L2_CTRL_TYPE_U16:
> > +			printf("%u", ctrl->p_u16[i]);
> > +			break;
> > +		case V4L2_CTRL_TYPE_U32:
> > +			printf("%u", ctrl->p_u32[i]);
> > +			break;
> > +		}
> > +
> > +		if (i != query->elems - 1)
> > +			printf(", ");
> > +	}
> > +
> > +	printf("}");
> > +}
> > +
> > +static void video_print_control_value(const struct v4l2_query_ext_ctrl *query,
> > +				      struct v4l2_ext_control *ctrl)
> > +{
> > +	if (query->nr_of_dims == 0) {
> > +		switch (query->type) {
> > +		case V4L2_CTRL_TYPE_INTEGER:
> > +		case V4L2_CTRL_TYPE_BOOLEAN:
> > +		case V4L2_CTRL_TYPE_MENU:
> > +		case V4L2_CTRL_TYPE_INTEGER_MENU:
> > +			printf("%d", ctrl->value);
> > +			break;
> > +		case V4L2_CTRL_TYPE_BITMASK:
> > +			printf("0x%08x", ctrl->value);
> 
> A cast to unsigned here?

Does your compiler warn ?

> > +			break;
> > +		case V4L2_CTRL_TYPE_INTEGER64:
> > +			printf("%lld", ctrl->value64);
> > +			break;
> > +		case V4L2_CTRL_TYPE_STRING:
> > +			printf("%s", ctrl->string);
> > +			break;
> > +		}
> > +
> > +		return;
> > +	}
> > +
> > +	switch (query->type) {
> > +	case V4L2_CTRL_TYPE_U8:
> > +	case V4L2_CTRL_TYPE_U16:
> > +	case V4L2_CTRL_TYPE_U32:
> > +		video_print_control_array(query, ctrl);
> > +		break;
> > +	default:
> > +		printf("unsupported");
> 
> How about printing the unsupported type?

Good idea.

> > +		break;
> > +	}
> > +}
> > +
> >  static int video_print_control(struct device *dev,
> >  			       const struct v4l2_query_ext_ctrl *query,
> >  			       bool full)
> >  {
> >  	struct v4l2_ext_control ctrl;
> > -	char sval[24];
> > -	char *current = sval;
> > +	unsigned int i;
> >  	int ret;
> >  
> >  	if (query->flags & V4L2_CTRL_FLAG_DISABLED)
> > @@ -1232,25 +1294,39 @@ static int video_print_control(struct device *dev,
> >  		return 0;
> >  	}
> >  
> > -	ret = get_control(dev, query, &ctrl);
> > -	if (ret < 0)
> > -		strcpy(sval, "n/a");
> > -	else if (query->type == V4L2_CTRL_TYPE_INTEGER64)
> > -		sprintf(sval, "%lld", ctrl.value64);
> > -	else if (query->type == V4L2_CTRL_TYPE_STRING)
> > -		current = ctrl.string;
> > -	else
> > -		sprintf(sval, "%d", ctrl.value);
> > -
> > -	if (full)
> > -		printf("control 0x%08x `%s' min %lld max %lld step %lld default %lld current %s.\n",
> > +	if (full) {
> > +		printf("control 0x%08x `%s' min %lld max %lld step %lld default %lld ",
> >  			query->id, query->name, query->minimum, query->maximum,
> > -			query->step, query->default_value, current);
> > -	else
> > -		printf("control 0x%08x current %s.\n", query->id, current);
> > +			query->step, query->default_value);
> > +		if (query->nr_of_dims) {
> > +			for (i = 0; i < query->nr_of_dims; ++i)
> > +				printf("[%u]", query->dims[i]);
> > +			printf(" ");
> > +		}
> > +	} else {
> > +		printf("control 0x%08x ", query->id);
> > +	}
> >  
> > -	if (query->type == V4L2_CTRL_TYPE_STRING)
> > -		free(ctrl.string);
> > +	if (query->type == V4L2_CTRL_TYPE_BUTTON) {
> > +		/* Button controls have no current value. */
> > +		printf("\n");
> > +		return 1;
> > +	}
> > +
> > +	printf("current ");
> > +
> > +	ret = get_control(dev, query, &ctrl);
> > +	if (ret < 0) {
> > +		printf("n/a\n");
> > +		printf("unable to get control 0x%8.8x: %s (%d).\n",
> > +			query->id, strerror(errno), errno);
> > +	} else {
> > +		video_print_control_value(query, &ctrl);
> > +		printf("\n");
> > +	}
> > +
> > +	if (query->flags & V4L2_CTRL_FLAG_HAS_PAYLOAD)
> > +		free(ctrl.ptr);
> >  
> >  	if (!full)
> >  		return 1;

-- 
Regards,

Laurent Pinchart
