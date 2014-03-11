Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:1171 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755822AbaCKUoE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Mar 2014 16:44:04 -0400
Message-ID: <531F7583.2060406@xs4all.nl>
Date: Tue, 11 Mar 2014 21:43:47 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com,
	s.nawrocki@samsung.com, ismael.luceno@corp.bluecherry.net,
	pete@sensoray.com, sakari.ailus@iki.fi,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [REVIEWv3 PATCH 06/35] v4l2-ctrls: add support for complex types.
References: <1392631070-41868-1-git-send-email-hverkuil@xs4all.nl> <1392631070-41868-7-git-send-email-hverkuil@xs4all.nl> <20140311171442.6bda3357@samsung.com>
In-Reply-To: <20140311171442.6bda3357@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On 03/11/2014 09:14 PM, Mauro Carvalho Chehab wrote:
> Em Mon, 17 Feb 2014 10:57:21 +0100
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> This patch implements initial support for complex types.
>>
>> For the most part the changes are fairly obvious (basic support for is_ptr
>> types, the type_is_int function is replaced by a is_int bitfield, and
>> v4l2_query_ext_ctrl is added), but one change needs more explanation:
>>
>> The v4l2_ctrl struct adds a 'new' field and a 'stores' array at the end
>> of the struct. This is in preparation for future patches where each control
>> can have multiple configuration stores. The idea is that stores[0] is the current
>> control value, stores[1] etc. are the control values for each configuration store
>> and the 'new' value can be accessed through 'stores[-1]', i.e. the 'new' field.
>> However, for now only stores[-1] and stores[0] is used.
>>
>> Drivers are not expected to use the stores array (at least not while support
>> for configuration stores is not yet fully added), but the stores array will
>> be used inside the control framework.
>>
>> These new fields use the v4l2_ctrl_ptr union, which is a pointer to a control
>> value.
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
>> ---
>>  drivers/media/v4l2-core/v4l2-ctrls.c | 236 ++++++++++++++++++++++++++---------
>>  include/media/v4l2-ctrls.h           |  38 +++++-
>>  2 files changed, 210 insertions(+), 64 deletions(-)
>>
>> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
>> index df8ed0a..5d1eeea 100644
>> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
>> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
>> @@ -1095,20 +1095,6 @@ void v4l2_ctrl_fill(u32 id, const char **name, const char **unit,
>>  }
>>  EXPORT_SYMBOL(v4l2_ctrl_fill);
>>  
>> -/* Helper function to determine whether the control type is compatible with
>> -   VIDIOC_G/S_CTRL. */
>> -static bool type_is_int(const struct v4l2_ctrl *ctrl)
>> -{
>> -	switch (ctrl->type) {
>> -	case V4L2_CTRL_TYPE_INTEGER64:
>> -	case V4L2_CTRL_TYPE_STRING:
>> -		/* Nope, these need v4l2_ext_control */
>> -		return false;
>> -	default:
>> -		return true;
>> -	}
>> -}
>> -
>>  static void fill_event(struct v4l2_event *ev, struct v4l2_ctrl *ctrl, u32 changes)
>>  {
>>  	memset(ev->reserved, 0, sizeof(ev->reserved));
>> @@ -1117,7 +1103,7 @@ static void fill_event(struct v4l2_event *ev, struct v4l2_ctrl *ctrl, u32 change
>>  	ev->u.ctrl.changes = changes;
>>  	ev->u.ctrl.type = ctrl->type;
>>  	ev->u.ctrl.flags = ctrl->flags;
>> -	if (ctrl->type == V4L2_CTRL_TYPE_STRING)
>> +	if (ctrl->is_ptr)
>>  		ev->u.ctrl.value64 = 0;
>>  	else
>>  		ev->u.ctrl.value64 = ctrl->cur.val64;
>> @@ -1152,6 +1138,9 @@ static int cur_to_user(struct v4l2_ext_control *c,
>>  {
>>  	u32 len;
>>  
>> +	if (ctrl->is_ptr && !ctrl->is_string)
>> +		return copy_to_user(c->p, ctrl->cur.p, ctrl->elem_size);
>> +
>>  	switch (ctrl->type) {
>>  	case V4L2_CTRL_TYPE_STRING:
>>  		len = strlen(ctrl->cur.string);
>> @@ -1179,6 +1168,9 @@ static int user_to_new(struct v4l2_ext_control *c,
>>  	u32 size;
>>  
>>  	ctrl->is_new = 1;
>> +	if (ctrl->is_ptr && !ctrl->is_string)
>> +		return copy_from_user(ctrl->p, c->p, ctrl->elem_size);
>> +
> 
> It is a little hard to follow all copy_*_user and memcpy/memcpy cases.
> 
> On all such calls, the elem_size data is coming from the driver?

Absolutely.

> It doesn't seem right to tust on userspace for that, if this could
> be a border case.
> 
>>  	switch (ctrl->type) {
>>  	case V4L2_CTRL_TYPE_INTEGER64:
>>  		ctrl->val64 = c->value64;
>> @@ -1213,6 +1205,9 @@ static int new_to_user(struct v4l2_ext_control *c,
>>  {
>>  	u32 len;
>>  
>> +	if (ctrl->is_ptr && !ctrl->is_string)
>> +		return copy_to_user(c->p, ctrl->p, ctrl->elem_size);
>> +
>>  	switch (ctrl->type) {
>>  	case V4L2_CTRL_TYPE_STRING:
>>  		len = strlen(ctrl->string);
>> @@ -1239,6 +1234,7 @@ static void new_to_cur(struct v4l2_fh *fh, struct v4l2_ctrl *ctrl, u32 ch_flags)
>>  
>>  	if (ctrl == NULL)
>>  		return;
>> +
>>  	switch (ctrl->type) {
>>  	case V4L2_CTRL_TYPE_BUTTON:
>>  		changed = true;
>> @@ -1253,8 +1249,13 @@ static void new_to_cur(struct v4l2_fh *fh, struct v4l2_ctrl *ctrl, u32 ch_flags)
>>  		ctrl->cur.val64 = ctrl->val64;
>>  		break;
>>  	default:
>> -		changed = ctrl->val != ctrl->cur.val;
>> -		ctrl->cur.val = ctrl->val;
>> +		if (ctrl->is_ptr) {
>> +			changed = memcmp(ctrl->p, ctrl->cur.p, ctrl->elem_size);
>> +			memcpy(ctrl->cur.p, ctrl->p, ctrl->elem_size);
>> +		} else {
>> +			changed = ctrl->val != ctrl->cur.val;
>> +			ctrl->cur.val = ctrl->val;
>> +		}
>>  		break;
>>  	}
>>  	if (ch_flags & V4L2_EVENT_CTRL_CH_FLAGS) {
>> @@ -1294,7 +1295,10 @@ static void cur_to_new(struct v4l2_ctrl *ctrl)
>>  		ctrl->val64 = ctrl->cur.val64;
>>  		break;
>>  	default:
>> -		ctrl->val = ctrl->cur.val;
>> +		if (ctrl->is_ptr)
>> +			memcpy(ctrl->p, ctrl->cur.p, ctrl->elem_size);
>> +		else
>> +			ctrl->val = ctrl->cur.val;
>>  		break;
>>  	}
>>  }
>> @@ -1507,7 +1511,7 @@ static struct v4l2_ctrl_ref *find_private_ref(
>>  		   VIDIOC_G/S_CTRL. */
>>  		if (V4L2_CTRL_ID2CLASS(ref->ctrl->id) == V4L2_CTRL_CLASS_USER &&
>>  		    V4L2_CTRL_DRIVER_PRIV(ref->ctrl->id)) {
>> -			if (!type_is_int(ref->ctrl))
>> +			if (!ref->ctrl->is_int)
>>  				continue;
>>  			if (id == 0)
>>  				return ref;
>> @@ -1577,8 +1581,12 @@ static int handler_new_ref(struct v4l2_ctrl_handler *hdl,
>>  	u32 class_ctrl = V4L2_CTRL_ID2CLASS(id) | 1;
>>  	int bucket = id % hdl->nr_of_buckets;	/* which bucket to use */
>>  
>> -	/* Automatically add the control class if it is not yet present. */
>> -	if (id != class_ctrl && find_ref_lock(hdl, class_ctrl) == NULL)
>> +	/*
>> +	 * Automatically add the control class if it is not yet present and
>> +	 * the new control is not hidden.
>> +	 */
>> +	if (!(ctrl->flags & V4L2_CTRL_FLAG_HIDDEN) &&
>> +	    id != class_ctrl && find_ref_lock(hdl, class_ctrl) == NULL)
>>  		if (!v4l2_ctrl_new_std(hdl, NULL, class_ctrl, 0, 0, 0, 0))
>>  			return hdl->error;
>>  
>> @@ -1640,23 +1648,36 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
>>  			u32 id, const char *name, const char *unit,
>>  			enum v4l2_ctrl_type type,
>>  			s64 min, s64 max, u64 step, s64 def,
>> +			u32 elem_size,
>>  			u32 flags, const char * const *qmenu,
>>  			const s64 *qmenu_int, void *priv)
>>  {
>>  	struct v4l2_ctrl *ctrl;
>> -	unsigned sz_extra = 0;
>> +	unsigned sz_extra;
>> +	void *data;
>>  	int err;
>>  
>>  	if (hdl->error)
>>  		return NULL;
>>  
>> +	if (type == V4L2_CTRL_TYPE_INTEGER64)
>> +		elem_size = sizeof(s64);
>> +	else if (type == V4L2_CTRL_TYPE_STRING)
>> +		elem_size = max + 1;
>> +	else if (type < V4L2_CTRL_COMPLEX_TYPES)
>> +		elem_size = sizeof(s32);
>> +
>>  	/* Sanity checks */
>>  	if (id == 0 || name == NULL || id >= V4L2_CID_PRIVATE_BASE ||
>> +	    elem_size == 0 ||
>>  	    (type == V4L2_CTRL_TYPE_MENU && qmenu == NULL) ||
>>  	    (type == V4L2_CTRL_TYPE_INTEGER_MENU && qmenu_int == NULL)) {
>>  		handler_set_err(hdl, -ERANGE);
>>  		return NULL;
>>  	}
>> +	/* Complex controls are always hidden */
>> +	if (type >= V4L2_CTRL_COMPLEX_TYPES)
>> +		flags |= V4L2_CTRL_FLAG_HIDDEN;
>>  	err = check_range(type, min, max, step, def);
>>  	if (err) {
>>  		handler_set_err(hdl, err);
>> @@ -1667,12 +1688,13 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
>>  		return NULL;
>>  	}
>>  
>> +	sz_extra = sizeof(union v4l2_ctrl_ptr);
>>  	if (type == V4L2_CTRL_TYPE_BUTTON)
>>  		flags |= V4L2_CTRL_FLAG_WRITE_ONLY;
>>  	else if (type == V4L2_CTRL_TYPE_CTRL_CLASS)
>>  		flags |= V4L2_CTRL_FLAG_READ_ONLY;
>> -	else if (type == V4L2_CTRL_TYPE_STRING)
>> -		sz_extra += 2 * (max + 1);
>> +	else if (type == V4L2_CTRL_TYPE_STRING || type >= V4L2_CTRL_COMPLEX_TYPES)
>> +		sz_extra += 2 * elem_size;
>>  
>>  	ctrl = kzalloc(sizeof(*ctrl) + sz_extra, GFP_KERNEL);
>>  	if (ctrl == NULL) {
>> @@ -1692,18 +1714,31 @@ static struct v4l2_ctrl *v4l2_ctrl_new(struct v4l2_ctrl_handler *hdl,
>>  	ctrl->minimum = min;
>>  	ctrl->maximum = max;
>>  	ctrl->step = step;
>> +	ctrl->default_value = def;
>> +	ctrl->is_string = type == V4L2_CTRL_TYPE_STRING;
>> +	ctrl->is_ptr = type >= V4L2_CTRL_COMPLEX_TYPES || ctrl->is_string;
>> +	ctrl->is_int = !ctrl->is_ptr && type != V4L2_CTRL_TYPE_INTEGER64;
>> +	ctrl->elem_size = elem_size;
>>  	if (type == V4L2_CTRL_TYPE_MENU)
>>  		ctrl->qmenu = qmenu;
>>  	else if (type == V4L2_CTRL_TYPE_INTEGER_MENU)
>>  		ctrl->qmenu_int = qmenu_int;
>>  	ctrl->priv = priv;
>> -	ctrl->cur.val = ctrl->val = ctrl->default_value = def;
>> +	ctrl->cur.val = ctrl->val = def;
>> +	data = &ctrl->stores[1];
>> +
>> +	if (ctrl->is_string) {
>> +		ctrl->string = ctrl->new.p_char = data;
>> +		ctrl->stores[0].p_char = data + elem_size;
>>  
>> -	if (ctrl->type == V4L2_CTRL_TYPE_STRING) {
>> -		ctrl->cur.string = (char *)&ctrl[1] + sz_extra - (max + 1);
>> -		ctrl->string = (char *)&ctrl[1] + sz_extra - 2 * (max + 1);
>>  		if (ctrl->minimum)
>>  			memset(ctrl->cur.string, ' ', ctrl->minimum);
>> +	} else if (ctrl->is_ptr) {
>> +		ctrl->p = ctrl->new.p = data;
>> +		ctrl->stores[0].p = data + elem_size;
>> +	} else {
>> +		ctrl->new.p = &ctrl->val;
>> +		ctrl->stores[0].p = &ctrl->cur.val;
>>  	}
>>  	if (handler_new_ref(hdl, ctrl)) {
>>  		kfree(ctrl);
>> @@ -1752,7 +1787,8 @@ struct v4l2_ctrl *v4l2_ctrl_new_custom(struct v4l2_ctrl_handler *hdl,
>>  	ctrl = v4l2_ctrl_new(hdl, cfg->ops, cfg->id, name, unit,
>>  			type, min, max,
>>  			is_menu ? cfg->menu_skip_mask : step,
>> -			def, flags, qmenu, qmenu_int, priv);
>> +			def, cfg->elem_size,
>> +			flags, qmenu, qmenu_int, priv);
>>  	if (ctrl)
>>  		ctrl->is_private = cfg->is_private;
>>  	return ctrl;
>> @@ -1770,13 +1806,15 @@ struct v4l2_ctrl *v4l2_ctrl_new_std(struct v4l2_ctrl_handler *hdl,
>>  	u32 flags;
>>  
>>  	v4l2_ctrl_fill(id, &name, &unit, &type, &min, &max, &step, &def, &flags);
>> -	if (type == V4L2_CTRL_TYPE_MENU
>> -	    || type == V4L2_CTRL_TYPE_INTEGER_MENU) {
>> +	if (type == V4L2_CTRL_TYPE_MENU ||
>> +	    type == V4L2_CTRL_TYPE_INTEGER_MENU ||
>> +	    type >= V4L2_CTRL_COMPLEX_TYPES) {
>>  		handler_set_err(hdl, -EINVAL);
>>  		return NULL;
>>  	}
>>  	return v4l2_ctrl_new(hdl, ops, id, name, unit, type,
>> -			     min, max, step, def, flags, NULL, NULL, NULL);
>> +			     min, max, step, def, 0,
>> +			     flags, NULL, NULL, NULL);
>>  }
>>  EXPORT_SYMBOL(v4l2_ctrl_new_std);
>>  
>> @@ -1809,7 +1847,8 @@ struct v4l2_ctrl *v4l2_ctrl_new_std_menu(struct v4l2_ctrl_handler *hdl,
>>  		return NULL;
>>  	}
>>  	return v4l2_ctrl_new(hdl, ops, id, name, unit, type,
>> -			     0, max, mask, def, flags, qmenu, qmenu_int, NULL);
>> +			     0, max, mask, def, 0,
>> +			     flags, qmenu, qmenu_int, NULL);
>>  }
>>  EXPORT_SYMBOL(v4l2_ctrl_new_std_menu);
>>  
>> @@ -1841,7 +1880,7 @@ struct v4l2_ctrl *v4l2_ctrl_new_std_menu_items(struct v4l2_ctrl_handler *hdl,
>>  		return NULL;
>>  	}
>>  	return v4l2_ctrl_new(hdl, ops, id, name, unit, type, 0, max, mask, def,
>> -			     flags, qmenu, NULL, NULL);
>> +			     0, flags, qmenu, NULL, NULL);
>>  
>>  }
>>  EXPORT_SYMBOL(v4l2_ctrl_new_std_menu_items);
>> @@ -1866,7 +1905,8 @@ struct v4l2_ctrl *v4l2_ctrl_new_int_menu(struct v4l2_ctrl_handler *hdl,
>>  		return NULL;
>>  	}
>>  	return v4l2_ctrl_new(hdl, ops, id, name, unit, type,
>> -			     0, max, 0, def, flags, NULL, qmenu_int, NULL);
>> +			     0, max, 0, def, 0,
>> +			     flags, NULL, qmenu_int, NULL);
>>  }
>>  EXPORT_SYMBOL(v4l2_ctrl_new_int_menu);
>>  
>> @@ -2154,9 +2194,10 @@ int v4l2_ctrl_handler_setup(struct v4l2_ctrl_handler *hdl)
>>  }
>>  EXPORT_SYMBOL(v4l2_ctrl_handler_setup);
>>  
>> -/* Implement VIDIOC_QUERYCTRL */
>> -int v4l2_queryctrl(struct v4l2_ctrl_handler *hdl, struct v4l2_queryctrl *qc)
>> +/* Implement VIDIOC_QUERY_EXT_CTRL */
>> +int v4l2_query_ext_ctrl(struct v4l2_ctrl_handler *hdl, struct v4l2_query_ext_ctrl *qc)
>>  {
>> +	const unsigned next_flags = V4L2_CTRL_FLAG_NEXT_CTRL | V4L2_CTRL_FLAG_NEXT_HIDDEN;
>>  	u32 id = qc->id & V4L2_CTRL_ID_MASK;
>>  	struct v4l2_ctrl_ref *ref;
>>  	struct v4l2_ctrl *ctrl;
>> @@ -2169,7 +2210,22 @@ int v4l2_queryctrl(struct v4l2_ctrl_handler *hdl, struct v4l2_queryctrl *qc)
>>  	/* Try to find it */
>>  	ref = find_ref(hdl, id);
>>  
>> -	if ((qc->id & V4L2_CTRL_FLAG_NEXT_CTRL) && !list_empty(&hdl->ctrl_refs)) {
>> +	if ((qc->id & next_flags) && !list_empty(&hdl->ctrl_refs)) {
>> +		unsigned mask;
>> +		unsigned match;
>> +
>> +		if ((qc->id & next_flags) == V4L2_CTRL_FLAG_NEXT_HIDDEN) {
>> +			/* Match any hidden control */
>> +			mask = match = V4L2_CTRL_FLAG_HIDDEN;
>> +		} else if ((qc->id & next_flags) == next_flags) {
>> +			/* Match any control, hidden or not */
>> +			mask = match = 0;
>> +		} else {
>> +			/* Match any control that is not hidden */
>> +			mask = V4L2_CTRL_FLAG_HIDDEN;
>> +			match = 0;
>> +		}
>> +
>>  		/* Find the next control with ID > qc->id */
>>  
>>  		/* Did we reach the end of the control list? */
>> @@ -2177,19 +2233,28 @@ int v4l2_queryctrl(struct v4l2_ctrl_handler *hdl, struct v4l2_queryctrl *qc)
>>  			ref = NULL; /* Yes, so there is no next control */
>>  		} else if (ref) {
>>  			/* We found a control with the given ID, so just get
>> -			   the next one in the list. */
>> -			ref = list_entry(ref->node.next, typeof(*ref), node);
>> +			   the next valid one in the list. */
>> +			list_for_each_entry_continue(ref, &hdl->ctrl_refs, node)
>> +				if (id < ref->ctrl->id &&
>> +				    (ref->ctrl->flags & mask) == match)
>> +					break;
>> +			if (&ref->node == &hdl->ctrl_refs)
>> +				ref = NULL;
>>  		} else {
>>  			/* No control with the given ID exists, so start
>>  			   searching for the next largest ID. We know there
>>  			   is one, otherwise the first 'if' above would have
>>  			   been true. */
>>  			list_for_each_entry(ref, &hdl->ctrl_refs, node)
>> -				if (id < ref->ctrl->id)
>> +				if (id < ref->ctrl->id &&
>> +				    (ref->ctrl->flags & mask) == match)
>>  					break;
>> +			if (&ref->node == &hdl->ctrl_refs)
>> +				ref = NULL;
>>  		}
>>  	}
>>  	mutex_unlock(hdl->lock);
>> +
>>  	if (!ref)
>>  		return -EINVAL;
>>  
>> @@ -2200,23 +2265,66 @@ int v4l2_queryctrl(struct v4l2_ctrl_handler *hdl, struct v4l2_queryctrl *qc)
>>  	else
>>  		qc->id = ctrl->id;
>>  	strlcpy(qc->name, ctrl->name, sizeof(qc->name));
>> -	qc->minimum = ctrl->minimum;
>> -	qc->maximum = ctrl->maximum;
>> -	qc->default_value = ctrl->default_value;
>> +	qc->flags = ctrl->flags;
>> +	qc->type = ctrl->type;
>> +	if (ctrl->is_ptr)
>> +		qc->flags |= V4L2_CTRL_FLAG_IS_PTR;
>> +	if (ctrl->unit)
>> +		strlcpy(qc->unit, ctrl->unit, sizeof(qc->unit));
>> +	qc->elem_size = ctrl->elem_size;
>> +	qc->min.val = ctrl->minimum;
>> +	qc->max.val = ctrl->maximum;
>> +	qc->def.val = ctrl->default_value;
>> +	qc->cols = qc->rows = 1;
>>  	if (ctrl->type == V4L2_CTRL_TYPE_MENU
>>  	    || ctrl->type == V4L2_CTRL_TYPE_INTEGER_MENU)
>> -		qc->step = 1;
>> +		qc->step.val = 1;
>>  	else
>> -		qc->step = ctrl->step;
>> -	qc->flags = ctrl->flags;
>> -	qc->type = ctrl->type;
>> +		qc->step.val = ctrl->step;
>> +	return 0;
>> +}
>> +EXPORT_SYMBOL(v4l2_query_ext_ctrl);
>> +
>> +/* Implement VIDIOC_QUERYCTRL */
>> +int v4l2_queryctrl(struct v4l2_ctrl_handler *hdl, struct v4l2_queryctrl *qc)
>> +{
>> +	struct v4l2_query_ext_ctrl qec = { qc->id };
>> +	int rc;
>> +
>> +	/* VIDIOC_QUERYCTRL cannot be used to enumerate hidden controls */
> 
> Why not?

Good question, actually. QUERYCTRL cannot properly represent the full information
about compound types (let's call it that for now), so I sort of assumed you
wouldn't want to use it for this anyway. But on the other hand, you can just
fill in what you can and leave it at that. Userspace can call QUERY_EXT_CTRL if
it wants the full information.

I think it would be a good improvement to allow this for queryctrl as well.

> 
>> +	if (qc->id & V4L2_CTRL_FLAG_NEXT_HIDDEN)
>> +		return -EINVAL;
>> +	rc = v4l2_query_ext_ctrl(hdl, &qec);
>> +	if (rc)
>> +		return rc;
>> +
>> +	/* VIDIOC_QUERYCTRL is not allowed to see hidden controls */
>> +	if (qc->flags & V4L2_CTRL_FLAG_HIDDEN)
>> +		return -EINVAL;
>> +	qc->id = qec.id;
>> +	qc->type = qec.type;
>> +	qc->flags = qec.flags;
>> +	strlcpy(qc->name, qec.name, sizeof(qc->name));
>> +	switch (qc->type) {
>> +	case V4L2_CTRL_TYPE_INTEGER:
>> +	case V4L2_CTRL_TYPE_BOOLEAN:
>> +	case V4L2_CTRL_TYPE_MENU:
>> +	case V4L2_CTRL_TYPE_INTEGER_MENU:
>> +	case V4L2_CTRL_TYPE_STRING:
>> +	case V4L2_CTRL_TYPE_BITMASK:
>> +		qc->minimum = qec.min.val;
>> +		qc->maximum = qec.max.val;
>> +		qc->step = qec.step.val;
>> +		qc->default_value = qec.def.val;
>> +		break;
>> +	}
>>  	return 0;
>>  }
>>  EXPORT_SYMBOL(v4l2_queryctrl);
>>  
>>  int v4l2_subdev_queryctrl(struct v4l2_subdev *sd, struct v4l2_queryctrl *qc)
>>  {
>> -	if (qc->id & V4L2_CTRL_FLAG_NEXT_CTRL)
>> +	if (qc->id & (V4L2_CTRL_FLAG_NEXT_CTRL | V4L2_CTRL_FLAG_NEXT_HIDDEN))
>>  		return -EINVAL;
>>  	return v4l2_queryctrl(sd->ctrl_handler, qc);
>>  }
>> @@ -2316,7 +2424,8 @@ EXPORT_SYMBOL(v4l2_subdev_querymenu);
>>     Find the controls in the control array and do some basic checks. */
>>  static int prepare_ext_ctrls(struct v4l2_ctrl_handler *hdl,
>>  			     struct v4l2_ext_controls *cs,
>> -			     struct v4l2_ctrl_helper *helpers)
>> +			     struct v4l2_ctrl_helper *helpers,
>> +			     bool get)
>>  {
>>  	struct v4l2_ctrl_helper *h;
>>  	bool have_clusters = false;
>> @@ -2348,6 +2457,13 @@ static int prepare_ext_ctrls(struct v4l2_ctrl_handler *hdl,
>>  			have_clusters = true;
>>  		if (ctrl->cluster[0] != ctrl)
>>  			ref = find_ref_lock(hdl, ctrl->cluster[0]->id);
>> +		if (ctrl->is_ptr && !ctrl->is_string && c->size < ctrl->elem_size) {
>> +			if (get) {
>> +				c->size = ctrl->elem_size;
>> +				return -ENOSPC;
>> +			}
>> +			return -EFAULT;
>> +		}
>>  		/* Store the ref to the master control of the cluster */
>>  		h->mref = ref;
>>  		h->ctrl = ctrl;
>> @@ -2428,7 +2544,7 @@ int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *cs
>>  			return -ENOMEM;
>>  	}
>>  
>> -	ret = prepare_ext_ctrls(hdl, cs, helpers);
>> +	ret = prepare_ext_ctrls(hdl, cs, helpers, true);
>>  	cs->error_idx = cs->count;
>>  
>>  	for (i = 0; !ret && i < cs->count; i++)
>> @@ -2490,11 +2606,11 @@ static int get_ctrl(struct v4l2_ctrl *ctrl, struct v4l2_ext_control *c)
>>  	int ret = 0;
>>  	int i;
>>  
>> -	/* String controls are not supported. The new_to_user() and
>> +	/* Complex controls are not supported. The new_to_user() and
>>  	 * cur_to_user() calls below would need to be modified not to access
>>  	 * userspace memory when called from get_ctrl().
>>  	 */
>> -	if (ctrl->type == V4L2_CTRL_TYPE_STRING)
>> +	if (!ctrl->is_int)
>>  		return -EINVAL;
>>  
>>  	if (ctrl->flags & V4L2_CTRL_FLAG_WRITE_ONLY)
>> @@ -2520,7 +2636,7 @@ int v4l2_g_ctrl(struct v4l2_ctrl_handler *hdl, struct v4l2_control *control)
>>  	struct v4l2_ext_control c;
>>  	int ret;
>>  
>> -	if (ctrl == NULL || !type_is_int(ctrl))
>> +	if (ctrl == NULL || !ctrl->is_int)
>>  		return -EINVAL;
>>  	ret = get_ctrl(ctrl, &c);
>>  	control->value = c.value;
>> @@ -2539,7 +2655,7 @@ s32 v4l2_ctrl_g_ctrl(struct v4l2_ctrl *ctrl)
>>  	struct v4l2_ext_control c;
>>  
>>  	/* It's a driver bug if this happens. */
>> -	WARN_ON(!type_is_int(ctrl));
>> +	WARN_ON(!ctrl->is_int);
>>  	c.value = 0;
>>  	get_ctrl(ctrl, &c);
>>  	return c.value;
>> @@ -2675,7 +2791,7 @@ static int try_set_ext_ctrls(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
>>  		if (!helpers)
>>  			return -ENOMEM;
>>  	}
>> -	ret = prepare_ext_ctrls(hdl, cs, helpers);
>> +	ret = prepare_ext_ctrls(hdl, cs, helpers, false);
>>  	if (!ret)
>>  		ret = validate_ctrls(cs, helpers, set);
>>  	if (ret && set)
>> @@ -2780,11 +2896,11 @@ static int set_ctrl(struct v4l2_fh *fh, struct v4l2_ctrl *ctrl,
>>  	struct v4l2_ctrl *master = ctrl->cluster[0];
>>  	int i;
>>  
>> -	/* String controls are not supported. The user_to_new() and
>> +	/* Complex controls are not supported. The user_to_new() and
>>  	 * cur_to_user() calls below would need to be modified not to access
>>  	 * userspace memory when called from set_ctrl().
>>  	 */
> 
> The new text also has an error. From the code below, what's not supported
> below are actually non-integer controls.

Well spotted:

>> -	if (ctrl->type == V4L2_CTRL_TYPE_STRING)
>> +	if (!ctrl->is_int)

This should have been 'if (ctrl->is_ptr)'

>>  		return -EINVAL;
>>  
>>  	/* Reset the 'is_new' flags of the cluster */
>> @@ -2826,7 +2942,7 @@ int v4l2_s_ctrl(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
>>  	struct v4l2_ext_control c;
>>  	int ret;
>>  
>> -	if (ctrl == NULL || !type_is_int(ctrl))
>> +	if (ctrl == NULL || !ctrl->is_int)
>>  		return -EINVAL;
>>  
>>  	if (ctrl->flags & V4L2_CTRL_FLAG_READ_ONLY)
>> @@ -2850,7 +2966,7 @@ int v4l2_ctrl_s_ctrl(struct v4l2_ctrl *ctrl, s32 val)
>>  	struct v4l2_ext_control c;
>>  
>>  	/* It's a driver bug if this happens. */
>> -	WARN_ON(!type_is_int(ctrl));
>> +	WARN_ON(!ctrl->is_int);
>>  	c.value = val;
>>  	return set_ctrl_lock(NULL, ctrl, &c);
>>  }
>> diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
>> index 3998049..515c1ba 100644
>> --- a/include/media/v4l2-ctrls.h
>> +++ b/include/media/v4l2-ctrls.h
>> @@ -36,6 +36,19 @@ struct v4l2_subscribed_event;
>>  struct v4l2_fh;
>>  struct poll_table_struct;
>>  
>> +/** union v4l2_ctrl_ptr - A pointer to a control value.
>> + * @p_s32:	Pointer to a 32-bit signed value.
>> + * @p_s64:	Pointer to a 64-bit signed value.
>> + * @p_char:	Pointer to a string.
>> + * @p:		Pointer to a complex value.
>> + */
>> +union v4l2_ctrl_ptr {
>> +	s32 *p_s32;
>> +	s64 *p_s64;
>> +	char *p_char;
>> +	void *p;
>> +};
> 
> I can't see where the above is used.

It's used at the end of the v4l2_ctrl struct.

> 
>> +
>>  /** struct v4l2_ctrl_ops - The control operations that the driver has to provide.
>>    * @g_volatile_ctrl: Get a new value for this control. Generally only relevant
>>    *		for volatile (and usually read-only) controls such as a control
>> @@ -73,6 +86,12 @@ typedef void (*v4l2_ctrl_notify_fnc)(struct v4l2_ctrl *ctrl, void *priv);
>>    *		members are in 'automatic' mode or 'manual' mode. This is
>>    *		used for autogain/gain type clusters. Drivers should never
>>    *		set this flag directly.
>> +  * @is_int:    If set, then this control has a simple integer value (i.e. it
>> +  *		uses ctrl->val).
>> +  * @is_string: If set, then this control has type V4L2_CTRL_TYPE_STRING.
>> +  * @is_ptr:	If set, then this control is a matrix and/or has type >= V4L2_CTRL_COMPLEX_TYPES
>> +  *		and/or has type V4L2_CTRL_TYPE_STRING. In other words, struct
>> +  *		v4l2_ext_control uses field p to point to the data.
>>    * @has_volatiles: If set, then one or more members of the cluster are volatile.
>>    *		Drivers should never touch this flag.
>>    * @call_notify: If set, then call the handler's notify function whenever the
>> @@ -91,6 +110,7 @@ typedef void (*v4l2_ctrl_notify_fnc)(struct v4l2_ctrl *ctrl, void *priv);
>>    * @maximum:	The control's maximum value.
>>    * @default_value: The control's default value.
>>    * @step:	The control's step value for non-menu controls.
>> +  * @elem_size:	The size in bytes of the control.
>>    * @menu_skip_mask: The control's skip mask for menu controls. This makes it
>>    *		easy to skip menu items that are not valid. If bit X is set,
>>    *		then menu item X is skipped. Of course, this only works for
>> @@ -105,7 +125,6 @@ typedef void (*v4l2_ctrl_notify_fnc)(struct v4l2_ctrl *ctrl, void *priv);
>>    * @cur:	The control's current value.
>>    * @val:	The control's new s32 value.
>>    * @val64:	The control's new s64 value.
>> -  * @string:	The control's new string value.
>>    * @priv:	The control's private pointer. For use by the driver. It is
>>    *		untouched by the control framework. Note that this pointer is
>>    *		not freed when the control is deleted. Should this be needed
>> @@ -124,6 +143,9 @@ struct v4l2_ctrl {
>>  	unsigned int is_new:1;
>>  	unsigned int is_private:1;
>>  	unsigned int is_auto:1;
>> +	unsigned int is_int:1;
>> +	unsigned int is_string:1;
>> +	unsigned int is_ptr:1;
>>  	unsigned int has_volatiles:1;
>>  	unsigned int call_notify:1;
>>  	unsigned int manual_mode_value:8;
>> @@ -134,6 +156,7 @@ struct v4l2_ctrl {
>>  	const char *unit;
>>  	enum v4l2_ctrl_type type;
>>  	s64 minimum, maximum, default_value;
>> +	u32 elem_size;
>>  	union {
>>  		u64 step;
>>  		u64 menu_skip_mask;
>> @@ -143,17 +166,21 @@ struct v4l2_ctrl {
>>  		const s64 *qmenu_int;
>>  	};
>>  	unsigned long flags;
>> +	void *priv;
>>  	union {
>>  		s32 val;
>>  		s64 val64;
>>  		char *string;
>> -	} cur;
>> +		void *p;
>> +	};
>>  	union {
>>  		s32 val;
>>  		s64 val64;
>>  		char *string;
>> -	};
>> -	void *priv;
>> +		void *p;
>> +	} cur;
>> +	union v4l2_ctrl_ptr new;
>> +	union v4l2_ctrl_ptr stores[];

^^^^^^^^^^^^^^^^^^^^

Here!

>>  };
>>  
>>  /** struct v4l2_ctrl_ref - The control reference.
>> @@ -215,6 +242,7 @@ struct v4l2_ctrl_handler {
>>    * @max:	The control's maximum value.
>>    * @step:	The control's step value for non-menu controls.
>>    * @def: 	The control's default value.
>> +  * @elem_size:	The size in bytes of the control.
>>    * @flags:	The control's flags.
>>    * @menu_skip_mask: The control's skip mask for menu controls. This makes it
>>    *		easy to skip menu items that are not valid. If bit X is set,
>> @@ -239,6 +267,7 @@ struct v4l2_ctrl_config {
>>  	s64 max;
>>  	u64 step;
>>  	s64 def;
>> +	u32 elem_size;
>>  	u32 flags;
>>  	u64 menu_skip_mask;
>>  	const char * const *qmenu;
>> @@ -664,6 +693,7 @@ unsigned int v4l2_ctrl_poll(struct file *file, struct poll_table_struct *wait);
>>  
>>  /* Helpers for ioctl_ops. If hdl == NULL then they will all return -EINVAL. */
>>  int v4l2_queryctrl(struct v4l2_ctrl_handler *hdl, struct v4l2_queryctrl *qc);
>> +int v4l2_query_ext_ctrl(struct v4l2_ctrl_handler *hdl, struct v4l2_query_ext_ctrl *qc);
>>  int v4l2_querymenu(struct v4l2_ctrl_handler *hdl, struct v4l2_querymenu *qm);
>>  int v4l2_g_ctrl(struct v4l2_ctrl_handler *hdl, struct v4l2_control *ctrl);
>>  int v4l2_s_ctrl(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
> 
> 

Regards,

	Hans
