Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:35446 "EHLO
	lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751283AbaKQIq4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Nov 2014 03:46:56 -0500
Message-ID: <5469B5EF.6070408@xs4all.nl>
Date: Mon, 17 Nov 2014 09:46:39 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Sakari Ailus <sakari.ailus@iki.fi>
CC: linux-media@vger.kernel.org, pawel@osciak.com,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC PATCH 04/11] v4l2-ctrls: add config store support
References: <1411310909-32825-1-git-send-email-hverkuil@xs4all.nl> <1411310909-32825-5-git-send-email-hverkuil@xs4all.nl> <20141114154433.GF8907@valkosipuli.retiisi.org.uk>
In-Reply-To: <20141114154433.GF8907@valkosipuli.retiisi.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/14/2014 04:44 PM, Sakari Ailus wrote:
> Hi Hans,
> 
> Some comments below.
> 
> On Sun, Sep 21, 2014 at 04:48:22PM +0200, Hans Verkuil wrote:
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>>  drivers/media/v4l2-core/v4l2-ctrls.c | 150 +++++++++++++++++++++++++++++------
>>  drivers/media/v4l2-core/v4l2-ioctl.c |   4 +-
>>  include/media/v4l2-ctrls.h           |  14 ++++
>>  3 files changed, 141 insertions(+), 27 deletions(-)
>>
>> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
>> index 35d1f3d..df0f3ee 100644
>> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
>> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
>> @@ -1478,6 +1478,15 @@ static int cur_to_user(struct v4l2_ext_control *c,
>>  	return ptr_to_user(c, ctrl, ctrl->p_cur);
>>  }
>>  
>> +/* Helper function: copy the store's control value back to the caller */
>> +static int store_to_user(struct v4l2_ext_control *c,
>> +		       struct v4l2_ctrl *ctrl, unsigned store)
>> +{
>> +	if (store == 0)
>> +		return ptr_to_user(c, ctrl, ctrl->p_new);
>> +	return ptr_to_user(c, ctrl, ctrl->p_stores[store - 1]);
>> +}
>> +
>>  /* Helper function: copy the new control value back to the caller */
>>  static int new_to_user(struct v4l2_ext_control *c,
>>  		       struct v4l2_ctrl *ctrl)
>> @@ -1585,6 +1594,14 @@ static void new_to_cur(struct v4l2_fh *fh, struct v4l2_ctrl *ctrl, u32 ch_flags)
>>  	}
>>  }
>>  
>> +/* Helper function: copy the new control value to the store */
>> +static void new_to_store(struct v4l2_ctrl *ctrl)
>> +{
>> +	/* has_changed is set by cluster_changed */
>> +	if (ctrl && ctrl->has_changed)
>> +		ptr_to_ptr(ctrl, ctrl->p_new, ctrl->p_stores[ctrl->store - 1]);
>> +}
>> +
>>  /* Copy the current value to the new value */
>>  static void cur_to_new(struct v4l2_ctrl *ctrl)
>>  {
>> @@ -1603,13 +1620,18 @@ static int cluster_changed(struct v4l2_ctrl *master)
>>  
>>  	for (i = 0; i < master->ncontrols; i++) {
>>  		struct v4l2_ctrl *ctrl = master->cluster[i];
>> +		union v4l2_ctrl_ptr ptr;
>>  		bool ctrl_changed = false;
>>  
>>  		if (ctrl == NULL)
>>  			continue;
>> +		if (ctrl->store)
>> +			ptr = ctrl->p_stores[ctrl->store - 1];
>> +		else
>> +			ptr = ctrl->p_cur;
>>  		for (idx = 0; !ctrl_changed && idx < ctrl->elems; idx++)
>>  			ctrl_changed = !ctrl->type_ops->equal(ctrl, idx,
>> -				ctrl->p_cur, ctrl->p_new);
>> +				ptr, ctrl->p_new);
>>  		ctrl->has_changed = ctrl_changed;
>>  		changed |= ctrl->has_changed;
>>  	}
>> @@ -1740,6 +1762,13 @@ void v4l2_ctrl_handler_free(struct v4l2_ctrl_handler *hdl)
>>  		list_del(&ctrl->node);
>>  		list_for_each_entry_safe(sev, next_sev, &ctrl->ev_subs, node)
>>  			list_del(&sev->node);
>> +		if (ctrl->p_stores) {
>> +			unsigned s;
>> +
>> +			for (s = 0; s < ctrl->nr_of_stores; s++)
>> +				kfree(ctrl->p_stores[s].p);
>> +		}
>> +		kfree(ctrl->p_stores);
>>  		kfree(ctrl);
>>  	}
>>  	kfree(hdl->buckets);
>> @@ -1970,7 +1999,7 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
>>  		handler_set_err(hdl, -ERANGE);
>>  		return NULL;
>>  	}
>> -	if (is_array &&
>> +	if ((is_array || (flags & V4L2_CTRL_FLAG_CAN_STORE)) &&
>>  	    (type == V4L2_CTRL_TYPE_BUTTON ||
>>  	     type == V4L2_CTRL_TYPE_CTRL_CLASS)) {
>>  		handler_set_err(hdl, -EINVAL);
>> @@ -2084,8 +2113,10 @@ struct v4l2_ctrl *v4l2_ctrl_new_custom(struct v4l2_ctrl_handler *hdl,
>>  			is_menu ? cfg->menu_skip_mask : step, def,
>>  			cfg->dims, cfg->elem_size,
>>  			flags, qmenu, qmenu_int, priv);
>> -	if (ctrl)
>> +	if (ctrl) {
> 
> I think it'd be cleaner to return NULL here if ctrl == NULL. Up to you.

Agreed.

> 
>>  		ctrl->is_private = cfg->is_private;
>> +		ctrl->can_store = cfg->can_store;
>> +	}
>>  	return ctrl;
>>  }
>>  EXPORT_SYMBOL(v4l2_ctrl_new_custom);
>> @@ -2452,6 +2483,7 @@ int v4l2_ctrl_handler_setup(struct v4l2_ctrl_handler *hdl)
>>  				cur_to_new(master->cluster[i]);
>>  				master->cluster[i]->is_new = 1;
>>  				master->cluster[i]->done = true;
>> +				master->cluster[i]->store = 0;
>>  			}
>>  		}
>>  		ret = call_op(master, s_ctrl);
>> @@ -2539,6 +2571,8 @@ int v4l2_query_ext_ctrl(struct v4l2_ctrl_handler *hdl, struct v4l2_query_ext_ctr
>>  		qc->id = ctrl->id;
>>  	strlcpy(qc->name, ctrl->name, sizeof(qc->name));
>>  	qc->flags = ctrl->flags;
>> +	if (ctrl->can_store)
>> +		qc->flags |= V4L2_CTRL_FLAG_CAN_STORE;
>>  	qc->type = ctrl->type;
>>  	if (ctrl->is_ptr)
>>  		qc->flags |= V4L2_CTRL_FLAG_HAS_PAYLOAD;
>> @@ -2700,6 +2734,8 @@ static int prepare_ext_ctrls(struct v4l2_ctrl_handler *hdl,
>>  			     struct v4l2_ctrl_helper *helpers,
>>  			     bool get)
>>  {
>> +	u32 ctrl_class = V4L2_CTRL_ID2CLASS(cs->ctrl_class);
>> +	unsigned store = cs->config_store & 0xffff;
>>  	struct v4l2_ctrl_helper *h;
>>  	bool have_clusters = false;
>>  	u32 i;
>> @@ -2712,7 +2748,7 @@ static int prepare_ext_ctrls(struct v4l2_ctrl_handler *hdl,
>>  
>>  		cs->error_idx = i;
>>  
>> -		if (cs->ctrl_class && V4L2_CTRL_ID2CLASS(id) != cs->ctrl_class)
>> +		if (ctrl_class && V4L2_CTRL_ID2CLASS(id) != ctrl_class)
>>  			return -EINVAL;
>>  
>>  		/* Old-style private controls are not allowed for
>> @@ -2725,6 +2761,8 @@ static int prepare_ext_ctrls(struct v4l2_ctrl_handler *hdl,
>>  		ctrl = ref->ctrl;
>>  		if (ctrl->flags & V4L2_CTRL_FLAG_DISABLED)
>>  			return -EINVAL;
>> +		if (store && !ctrl->can_store)
>> +			return -EINVAL;
>>  
>>  		if (ctrl->cluster[0]->ncontrols > 1)
>>  			have_clusters = true;
>> @@ -2796,6 +2834,32 @@ static int class_check(struct v4l2_ctrl_handler *hdl, u32 ctrl_class)
>>  	return find_ref_lock(hdl, ctrl_class | 1) ? 0 : -EINVAL;
>>  }
>>  
>> +static int extend_store(struct v4l2_ctrl *ctrl, unsigned stores)
> 
> What limits the number of stores? In my opinion 2^16 - 1 is just a tad too
> many... I think it'll be always easier to extend this rather than shrink it.
> Also the user shouldn't be allowed to allocate obscene amounts of memory for
> something like this.
> 
> I might limit this to 255 for instance.

My plan (not part of this patch series) was to have a default limit (probably
VIDEO_MAX_FRAME) that drivers can override. I suspect that bridge drivers may
need to be able to set this limit for all subdev drivers as well, but we'll
see how that will work out. All the information necessary is available, so if
we need it, it wouldn't be too difficult.

But it certainly will have to be limited.

> 
>> +{
>> +	unsigned s, idx;
>> +	union v4l2_ctrl_ptr *p;
>> +
>> +	p = kcalloc(stores, sizeof(union v4l2_ctrl_ptr), GFP_KERNEL);
>> +	if (p == NULL)
>> +		return -ENOMEM;
>> +	for (s = ctrl->nr_of_stores; s < stores; s++) {
>> +		p[s].p = kcalloc(ctrl->elems, ctrl->elem_size, GFP_KERNEL);
>> +		if (p[s].p == NULL) {
>> +			while (s > ctrl->nr_of_stores)
>> +				kfree(p[--s].p);
>> +			kfree(p);
>> +			return -ENOMEM;
>> +		}
>> +		for (idx = 0; idx < ctrl->elems; idx++)
>> +			ctrl->type_ops->init(ctrl, idx, p[s]);
>> +	}
>> +	if (ctrl->p_stores)
>> +		memcpy(p, ctrl->p_stores, ctrl->nr_of_stores * sizeof(union v4l2_ctrl_ptr));
> 
> Please consider wrapping the line. I'd might use sizeof(*p) instead.

Agreed.

> 
>> +	kfree(ctrl->p_stores);
>> +	ctrl->p_stores = p;
>> +	ctrl->nr_of_stores = stores;
>> +	return 0;
>> +}

Regards,

	Hans

