Return-Path: <SRS0=tJec=Q3=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB4D7C43381
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 21:16:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8FCA72147A
	for <linux-media@archiver.kernel.org>; Wed, 20 Feb 2019 21:16:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726013AbfBTVQv (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 20 Feb 2019 16:16:51 -0500
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:45872 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725869AbfBTVQv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 20 Feb 2019 16:16:51 -0500
Received: from valkosipuli.localdomain (valkosipuli.retiisi.org.uk [IPv6:2001:1bc8:1a6:d3d5::80:2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by hillosipuli.retiisi.org.uk (Postfix) with ESMTPS id E3690634C7B;
        Wed, 20 Feb 2019 23:16:40 +0200 (EET)
Received: from sailus by valkosipuli.localdomain with local (Exim 4.89)
        (envelope-from <sakari.ailus@retiisi.org.uk>)
        id 1gwZEP-0000UF-I9; Wed, 20 Feb 2019 23:16:41 +0200
Date:   Wed, 20 Feb 2019 23:16:41 +0200
From:   Sakari Ailus <sakari.ailus@iki.fi>
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc:     linux-media@vger.kernel.org,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Subject: Re: [PATCH yavta 3/7] Implement compound control get support
Message-ID: <20190220211641.soxcui772sd4zidy@valkosipuli.retiisi.org.uk>
References: <20190220125123.9410-1-laurent.pinchart@ideasonboard.com>
 <20190220125123.9410-4-laurent.pinchart@ideasonboard.com>
 <20190220140643.fq5gp6dcwgbhfqip@valkosipuli.retiisi.org.uk>
 <20190220145506.GC3516@pendragon.ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190220145506.GC3516@pendragon.ideasonboard.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Laurent,

On Wed, Feb 20, 2019 at 04:55:06PM +0200, Laurent Pinchart wrote:
> Hi Sakari,
> 
> On Wed, Feb 20, 2019 at 04:06:43PM +0200, Sakari Ailus wrote:
> > On Wed, Feb 20, 2019 at 02:51:19PM +0200, Laurent Pinchart wrote:
> > > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > > ---
> > >  yavta.c | 154 ++++++++++++++++++++++++++++++++++++++++++--------------
> > >  1 file changed, 115 insertions(+), 39 deletions(-)
> > > 
> > > diff --git a/yavta.c b/yavta.c
> > > index eb50d592736f..6428c22f88d7 100644
> > > --- a/yavta.c
> > > +++ b/yavta.c
> > > @@ -529,6 +529,7 @@ static int get_control(struct device *dev,
> > >  		       struct v4l2_ext_control *ctrl)
> > >  {
> > >  	struct v4l2_ext_controls ctrls;
> > > +	struct v4l2_control old;
> > >  	int ret;
> > >  
> > >  	memset(&ctrls, 0, sizeof(ctrls));
> > > @@ -540,34 +541,32 @@ static int get_control(struct device *dev,
> > >  
> > >  	ctrl->id = query->id;
> > >  
> > > -	if (query->type == V4L2_CTRL_TYPE_STRING) {
> > > -		ctrl->string = malloc(query->maximum + 1);
> > > -		if (ctrl->string == NULL)
> > > +	if (query->flags & V4L2_CTRL_FLAG_HAS_PAYLOAD) {
> > 
> > This breaks string controls for kernels that don't have
> > V4L2_CTRL_FLAG_HAS_PAYLOAD. As you still support kernels that have no
> > V4L2_CTRL_FLAG_NEXT_CTRL, how about checking for string type specifically?
> 
> Nasty one :-( I'll do so.

Ack!

> 
> > > +		ctrl->size = query->elems * query->elem_size;
> > > +		ctrl->ptr = malloc(ctrl->size);
> > > +		if (ctrl->ptr == NULL)
> > >  			return -ENOMEM;
> > > -
> > > -		ctrl->size = query->maximum + 1;
> > >  	}
> > >  
> > >  	ret = ioctl(dev->fd, VIDIOC_G_EXT_CTRLS, &ctrls);
> > >  	if (ret != -1)
> > >  		return 0;
> > >  
> > > -	if (query->type != V4L2_CTRL_TYPE_INTEGER64 &&
> > > -	    query->type != V4L2_CTRL_TYPE_STRING &&
> > > -	    (errno == EINVAL || errno == ENOTTY)) {
> > > -		struct v4l2_control old;
> > > +	if (query->flags & V4L2_CTRL_FLAG_HAS_PAYLOAD)
> > > +		free(ctrl->ptr);
> > >  
> > > -		old.id = query->id;
> > > -		ret = ioctl(dev->fd, VIDIOC_G_CTRL, &old);
> > > -		if (ret != -1) {
> > > -			ctrl->value = old.value;
> > > -			return 0;
> > > -		}
> > > -	}
> > > +	if (query->flags & V4L2_CTRL_FLAG_HAS_PAYLOAD ||
> > > +	    query->type == V4L2_CTRL_TYPE_INTEGER64 ||
> > > +	    (errno != EINVAL && errno != ENOTTY))
> > > +		return -errno;
> > >  
> > > -	printf("unable to get control 0x%8.8x: %s (%d).\n",
> > > -		query->id, strerror(errno), errno);
> > > -	return -1;
> > > +	old.id = query->id;
> > > +	ret = ioctl(dev->fd, VIDIOC_G_CTRL, &old);
> > > +	if (ret < 0)
> > > +		return -errno;
> > > +
> > > +	ctrl->value = old.value;
> > > +	return 0;
> > >  }
> > >  
> > >  static void set_control(struct device *dev, unsigned int id,
> > > @@ -1170,7 +1169,7 @@ static int video_for_each_control(struct device *dev,
> > >  #else
> > >  	id = 0;
> > >  	while (1) {
> > > -		id |= V4L2_CTRL_FLAG_NEXT_CTRL;
> > > +		id |= V4L2_CTRL_FLAG_NEXT_CTRL | V4L2_CTRL_FLAG_NEXT_COMPOUND;
> > >  #endif
> > >  
> > >  		ret = query_control(dev, id, &query);
> > > @@ -1215,13 +1214,76 @@ static void video_query_menu(struct device *dev,
> > >  	};
> > >  }
> > >  
> > > +static void video_print_control_array(const struct v4l2_query_ext_ctrl *query,
> > > +				      struct v4l2_ext_control *ctrl)
> > > +{
> > > +	unsigned int i;
> > > +
> > > +	printf("{");
> > 
> > A space would be nice after the opening brace, also before the closing one.
> 
> Isn't that a matter of taste ? :-)

Could be, but the vast majority of the kernel code does that. And I think
it's part of the coding style, therefore I'd do the same here. I like it
that way, too. :-)

> 
> > > +
> > > +	for (i = 0; i < query->elems; ++i) {
> > > +		switch (query->type) {
> > > +		case V4L2_CTRL_TYPE_U8:
> > > +			printf("%u", ctrl->p_u8[i]);
> > > +			break;
> > > +		case V4L2_CTRL_TYPE_U16:
> > > +			printf("%u", ctrl->p_u16[i]);
> > > +			break;
> > > +		case V4L2_CTRL_TYPE_U32:
> > > +			printf("%u", ctrl->p_u32[i]);
> > > +			break;
> > > +		}
> > > +
> > > +		if (i != query->elems - 1)
> > > +			printf(", ");
> > > +	}
> > > +
> > > +	printf("}");
> > > +}
> > > +
> > > +static void video_print_control_value(const struct v4l2_query_ext_ctrl *query,
> > > +				      struct v4l2_ext_control *ctrl)
> > > +{
> > > +	if (query->nr_of_dims == 0) {
> > > +		switch (query->type) {
> > > +		case V4L2_CTRL_TYPE_INTEGER:
> > > +		case V4L2_CTRL_TYPE_BOOLEAN:
> > > +		case V4L2_CTRL_TYPE_MENU:
> > > +		case V4L2_CTRL_TYPE_INTEGER_MENU:
> > > +			printf("%d", ctrl->value);
> > > +			break;
> > > +		case V4L2_CTRL_TYPE_BITMASK:
> > > +			printf("0x%08x", ctrl->value);
> > 
> > A cast to unsigned here?
> 
> Does your compiler warn ?

I've reviewed the patch, not compiled it. :-)

-- 
Regards,

Sakari Ailus
