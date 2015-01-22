Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:60141 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbbAVQMr (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Jan 2015 11:12:47 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	sadegh abbasi <sadegh612000@yahoo.co.uk>
Subject: Re: [PATCH 3/7] v4l2-ctrls: Make the control type init op initialize the whole control
Date: Thu, 22 Jan 2015 18:13:20 +0200
Message-ID: <1429754.e93IcqsrYI@avalon>
In-Reply-To: <54C1135F.30504@xs4all.nl>
References: <1421938126-17747-1-git-send-email-laurent.pinchart@ideasonboard.com> <1421938126-17747-4-git-send-email-laurent.pinchart@ideasonboard.com> <54C1135F.30504@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the review.

On Thursday 22 January 2015 16:12:31 Hans Verkuil wrote:
> On 01/22/15 15:48, Laurent Pinchart wrote:
> > The control type init operation is called in a loop to initialize all
> > elements of a control. Not only is this inefficient for control types
> > that could use a memset(), it also complicates the implementation of
> > custom control types, for instance when a matrix needs to be initialized
> > with different values for its elements.
> > 
> > Make the init operation initialize the whole control instead, and use
> > memset() when possible.
> > 
> > Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> > ---
> > 
> >  drivers/media/v4l2-core/v4l2-ctrls.c | 40 ++++++++++++++++++++++++-------
> >  include/media/v4l2-ctrls.h           |  3 +--
> >  2 files changed, 34 insertions(+), 9 deletions(-)
> > 
> > diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c
> > b/drivers/media/v4l2-core/v4l2-ctrls.c index adac93e..ba996de 100644
> > --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> > +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> > @@ -1263,8 +1263,8 @@ static bool std_equal(const struct v4l2_ctrl *ctrl,
> > u32 idx,
> >  	}
> >  }
> > 
> > -static void std_init(const struct v4l2_ctrl *ctrl, u32 idx,
> > -		     union v4l2_ctrl_ptr ptr)
> > +static void std_init_one(const struct v4l2_ctrl *ctrl, u32 idx,
> > +			 union v4l2_ctrl_ptr ptr)
> >  {
> >  	switch (ctrl->type) {
> >  	case V4L2_CTRL_TYPE_STRING:
> > @@ -1301,6 +1301,35 @@ static void std_init(const struct v4l2_ctrl *ctrl,
> > u32 idx,
> >  	}
> >  }
> > 
> > +static void std_init(const struct v4l2_ctrl *ctrl, union v4l2_ctrl_ptr
> > ptr)
> > +{
> > +	u32 idx;
> > +
> > +	switch (ctrl->type) {
> > +	case V4L2_CTRL_TYPE_STRING:
> > +	case V4L2_CTRL_TYPE_INTEGER64:
> > +	case V4L2_CTRL_TYPE_INTEGER:
> > +	case V4L2_CTRL_TYPE_INTEGER_MENU:
> > +	case V4L2_CTRL_TYPE_MENU:
> > +	case V4L2_CTRL_TYPE_BITMASK:
> > +	case V4L2_CTRL_TYPE_BOOLEAN:
> > +	case V4L2_CTRL_TYPE_U16:
> > +	case V4L2_CTRL_TYPE_S16:
> > +	case V4L2_CTRL_TYPE_U32:
> > +	case V4L2_CTRL_TYPE_S32:
> > +		for (idx = 0; idx < ctrl->elems; idx++)
> > +			std_init_one(ctrl, idx, ptr);
> 
> std_init_one still contains support for TYPE_U8, which can now be removed,
> and the default case can be removed as well (or reduced to just a break
> statement).

I'll fix that and submit a v2.

> > +		break;
> > +	case V4L2_CTRL_TYPE_U8:
> > +	case V4L2_CTRL_TYPE_S8:
> > +		memset(ptr.p_u8, ctrl->default_value, ctrl->elems);
> > +		break;
> > +	default:
> > +		memset(ptr.p, 0, ctrl->elems * ctrl->elem_size);
> > +		break;
> > +	}
> > +}
> > +
> > 
> >  static void std_log(const struct v4l2_ctrl *ctrl)
> >  {
> >  	union v4l2_ctrl_ptr ptr = ctrl->p_cur;
> > @@ -1929,7 +1958,6 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct
> > v4l2_ctrl_handler *hdl,> 
> >  	unsigned elems = 1;
> >  	bool is_array;
> >  	unsigned tot_ctrl_size;
> > -	unsigned idx;
> >  	void *data;
> >  	int err;
> > 
> > @@ -2049,10 +2077,8 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct
> > v4l2_ctrl_handler *hdl,
> >  		ctrl->p_new.p = &ctrl->val;
> >  		ctrl->p_cur.p = &ctrl->cur.val;
> >  	}
> > -	for (idx = 0; idx < elems; idx++) {
> > -		ctrl->type_ops->init(ctrl, idx, ctrl->p_cur);
> > -		ctrl->type_ops->init(ctrl, idx, ctrl->p_new);
> > -	}
> > +	ctrl->type_ops->init(ctrl, ctrl->p_cur);
> > +	ctrl->type_ops->init(ctrl, ctrl->p_new);
> > 
> >  	if (handler_new_ref(hdl, ctrl)) {
> >  		kfree(ctrl);
> > diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
> > index e1cfb8f..a7280e9 100644
> > --- a/include/media/v4l2-ctrls.h
> > +++ b/include/media/v4l2-ctrls.h
> > @@ -87,8 +87,7 @@ struct v4l2_ctrl_type_ops {
> >  	bool (*equal)(const struct v4l2_ctrl *ctrl, u32 idx,
> >  		      union v4l2_ctrl_ptr ptr1,
> >  		      union v4l2_ctrl_ptr ptr2);
> > -	void (*init)(const struct v4l2_ctrl *ctrl, u32 idx,
> > -		     union v4l2_ctrl_ptr ptr);
> > +	void (*init)(const struct v4l2_ctrl *ctrl, union v4l2_ctrl_ptr ptr);
> >  	void (*log)(const struct v4l2_ctrl *ctrl);
> >  	int (*validate)(const struct v4l2_ctrl *ctrl, u32 idx,
> >  			union v4l2_ctrl_ptr ptr);

-- 
Regards,

Laurent Pinchart

