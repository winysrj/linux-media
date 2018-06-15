Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:56852 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754477AbeFOHSP (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Jun 2018 03:18:15 -0400
Subject: Re: [PATCHv15 13/35] v4l2-ctrls: add core request support
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
References: <20180604114648.26159-1-hverkuil@xs4all.nl>
 <20180604114648.26159-14-hverkuil@xs4all.nl>
Message-ID: <2ca15c7e-2965-9bc0-8a8f-40de069a224f@xs4all.nl>
Date: Fri, 15 Jun 2018 09:18:12 +0200
MIME-Version: 1.0
In-Reply-To: <20180604114648.26159-14-hverkuil@xs4all.nl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/06/18 13:46, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Integrate the request support. This adds the v4l2_ctrl_request_complete
> and v4l2_ctrl_request_setup functions to complete a request and (as a
> helper function) to apply a request to the hardware.
> 
> It takes care of queuing requests and correctly chaining control values
> in the request queue.
> 
> Note that when a request is marked completed it will copy control values
> to the internal request state. This can be optimized in the future since
> this is sub-optimal when dealing with large compound and/or array controls.
> 
> For the initial 'stateless codec' use-case the current implementation is
> sufficient.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/v4l2-core/v4l2-ctrls.c | 331 ++++++++++++++++++++++++++-
>  include/media/v4l2-ctrls.h           |  51 +++++
>  2 files changed, 376 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
> index da4cc1485dc4..bd4818507486 100644
> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> @@ -1647,6 +1647,13 @@ static int new_to_user(struct v4l2_ext_control *c,
>  	return ptr_to_user(c, ctrl, ctrl->p_new);
>  }
>  
> +/* Helper function: copy the request value back to the caller */
> +static int req_to_user(struct v4l2_ext_control *c,
> +		       struct v4l2_ctrl_ref *ref)
> +{
> +	return ptr_to_user(c, ref->ctrl, ref->p_req);
> +}
> +
>  /* Helper function: copy the initial control value back to the caller */
>  static int def_to_user(struct v4l2_ext_control *c, struct v4l2_ctrl *ctrl)
>  {
> @@ -1766,6 +1773,26 @@ static void cur_to_new(struct v4l2_ctrl *ctrl)
>  	ptr_to_ptr(ctrl, ctrl->p_cur, ctrl->p_new);
>  }
>  
> +/* Copy the new value to the request value */
> +static void new_to_req(struct v4l2_ctrl_ref *ref)
> +{
> +	if (!ref)
> +		return;
> +	ptr_to_ptr(ref->ctrl, ref->ctrl->p_new, ref->p_req);
> +	ref->req = ref;
> +}
> +
> +/* Copy the request value to the new value */
> +static void req_to_new(struct v4l2_ctrl_ref *ref)
> +{
> +	if (!ref)
> +		return;
> +	if (ref->req)
> +		ptr_to_ptr(ref->ctrl, ref->req->p_req, ref->ctrl->p_new);
> +	else
> +		ptr_to_ptr(ref->ctrl, ref->ctrl->p_cur, ref->ctrl->p_new);
> +}
> +
>  /* Return non-zero if one or more of the controls in the cluster has a new
>     value that differs from the current value. */
>  static int cluster_changed(struct v4l2_ctrl *master)
> @@ -1875,6 +1902,9 @@ int v4l2_ctrl_handler_init_class(struct v4l2_ctrl_handler *hdl,
>  	lockdep_set_class_and_name(hdl->lock, key, name);
>  	INIT_LIST_HEAD(&hdl->ctrls);
>  	INIT_LIST_HEAD(&hdl->ctrl_refs);
> +	INIT_LIST_HEAD(&hdl->requests);
> +	INIT_LIST_HEAD(&hdl->requests_queued);
> +	hdl->request_is_queued = false;
>  	hdl->nr_of_buckets = 1 + nr_of_controls_hint / 8;
>  	hdl->buckets = kvmalloc_array(hdl->nr_of_buckets,
>  				      sizeof(hdl->buckets[0]),
> @@ -1895,6 +1925,14 @@ void v4l2_ctrl_handler_free(struct v4l2_ctrl_handler *hdl)
>  	if (hdl == NULL || hdl->buckets == NULL)
>  		return;
>  
> +	if (!hdl->req_obj.req && !list_empty(&hdl->requests)) {
> +		struct v4l2_ctrl_handler *req, *next_req;
> +
> +		list_for_each_entry_safe(req, next_req, &hdl->requests, requests) {
> +			media_request_object_unbind(&req->req_obj);
> +			media_request_object_put(&req->req_obj);
> +		}
> +	}
>  	mutex_lock(hdl->lock);
>  	/* Free all nodes */
>  	list_for_each_entry_safe(ref, next_ref, &hdl->ctrl_refs, node) {
> @@ -2816,6 +2854,128 @@ int v4l2_querymenu(struct v4l2_ctrl_handler *hdl, struct v4l2_querymenu *qm)
>  }
>  EXPORT_SYMBOL(v4l2_querymenu);
>  
> +static int v4l2_ctrl_request_clone(struct v4l2_ctrl_handler *hdl,
> +				   const struct v4l2_ctrl_handler *from)
> +{
> +	struct v4l2_ctrl_ref *ref;
> +	int err;
> +
> +	if (WARN_ON(!hdl || hdl == from))
> +		return -EINVAL;
> +
> +	if (hdl->error)
> +		return hdl->error;
> +
> +	WARN_ON(hdl->lock != &hdl->_lock);
> +
> +	mutex_lock(from->lock);
> +	list_for_each_entry(ref, &from->ctrl_refs, node) {
> +		struct v4l2_ctrl *ctrl = ref->ctrl;
> +		struct v4l2_ctrl_ref *new_ref;
> +
> +		/* Skip refs inherited from other devices */
> +		if (ref->from_other_dev)
> +			continue;
> +		/* And buttons */
> +		if (ctrl->type == V4L2_CTRL_TYPE_BUTTON)
> +			continue;
> +		err = handler_new_ref(hdl, ctrl, &new_ref, false, true);
> +		if (err) {
> +			printk("%s: handler_new_ref on control %x (%s) returned %d\n", __func__, ctrl->id, ctrl->name, err);
> +			err = 0;
> +			continue;
> +		}
> +		if (err)
> +			break;
> +	}
> +	mutex_unlock(from->lock);
> +	return err;
> +}
> +
> +static void v4l2_ctrl_request_queue(struct media_request_object *obj)
> +{
> +	struct v4l2_ctrl_handler *hdl =
> +		container_of(obj, struct v4l2_ctrl_handler, req_obj);
> +	struct v4l2_ctrl_handler *main_hdl = obj->priv;
> +	struct v4l2_ctrl_handler *prev_hdl = NULL;
> +	struct v4l2_ctrl_ref *ref_ctrl, *ref_ctrl_prev = NULL;
> +
> +	if (list_empty(&main_hdl->requests_queued))
> +		goto queue;
> +
> +	prev_hdl = list_last_entry(&main_hdl->requests_queued,
> +				   struct v4l2_ctrl_handler, requests_queued);
> +	/*
> +	 * Note: prev_hdl and hdl must contain the same list of control
> +	 * references, so if any differences are detected then that is a
> +	 * driver bug and the WARN_ON is triggered.
> +	 */
> +	mutex_lock(prev_hdl->lock);
> +	ref_ctrl_prev = list_first_entry(&prev_hdl->ctrl_refs,
> +					 struct v4l2_ctrl_ref, node);
> +	list_for_each_entry(ref_ctrl, &hdl->ctrl_refs, node) {
> +		if (ref_ctrl->req)
> +			continue;
> +		while (ref_ctrl_prev->ctrl->id < ref_ctrl->ctrl->id) {
> +			/* Should never happen, but just in case... */
> +			if (list_is_last(&ref_ctrl_prev->node,
> +					 &prev_hdl->ctrl_refs))
> +				break;
> +			ref_ctrl_prev = list_next_entry(ref_ctrl_prev, node);
> +		}
> +		if (WARN_ON(ref_ctrl_prev->ctrl->id != ref_ctrl->ctrl->id))
> +			break;
> +		ref_ctrl->req = ref_ctrl_prev->req;
> +	}
> +	mutex_unlock(prev_hdl->lock);
> +queue:
> +	list_add_tail(&hdl->requests_queued, &main_hdl->requests_queued);
> +	hdl->request_is_queued = true;
> +}
> +
> +static void v4l2_ctrl_request_unbind(struct media_request_object *obj)
> +{
> +	struct v4l2_ctrl_handler *hdl =
> +		container_of(obj, struct v4l2_ctrl_handler, req_obj);
> +
> +	list_del_init(&hdl->requests);
> +	if (hdl->request_is_queued) {
> +		list_del_init(&hdl->requests_queued);
> +		hdl->request_is_queued = false;
> +	}
> +}
> +
> +static void v4l2_ctrl_request_release(struct media_request_object *obj)
> +{
> +	struct v4l2_ctrl_handler *hdl =
> +		container_of(obj, struct v4l2_ctrl_handler, req_obj);
> +
> +	v4l2_ctrl_handler_free(hdl);
> +	kfree(hdl);
> +}
> +
> +static const struct media_request_object_ops req_ops = {
> +	.queue = v4l2_ctrl_request_queue,
> +	.unbind = v4l2_ctrl_request_unbind,
> +	.release = v4l2_ctrl_request_release,
> +};
> +
> +static int v4l2_ctrl_request_bind(struct media_request *req,
> +			   struct v4l2_ctrl_handler *hdl,
> +			   struct v4l2_ctrl_handler *from)
> +{
> +	int ret;
> +
> +	ret = v4l2_ctrl_request_clone(hdl, from);
> +
> +	if (!ret) {
> +		ret = media_request_object_bind(req, &req_ops,
> +						from, &hdl->req_obj);
> +		if (!ret)
> +			list_add_tail(&hdl->requests, &from->requests);
> +	}
> +	return ret;
> +}
>  
>  /* Some general notes on the atomic requirements of VIDIOC_G/TRY/S_EXT_CTRLS:
>  
> @@ -2877,6 +3037,7 @@ static int prepare_ext_ctrls(struct v4l2_ctrl_handler *hdl,
>  
>  		if (cs->which &&
>  		    cs->which != V4L2_CTRL_WHICH_DEF_VAL &&
> +		    cs->which != V4L2_CTRL_WHICH_REQUEST_VAL &&
>  		    V4L2_CTRL_ID2WHICH(id) != cs->which)
>  			return -EINVAL;
>  
> @@ -2956,13 +3117,12 @@ static int prepare_ext_ctrls(struct v4l2_ctrl_handler *hdl,
>     whether there are any controls at all. */
>  static int class_check(struct v4l2_ctrl_handler *hdl, u32 which)
>  {
> -	if (which == 0 || which == V4L2_CTRL_WHICH_DEF_VAL)
> +	if (which == 0 || which == V4L2_CTRL_WHICH_DEF_VAL ||
> +	    which == V4L2_CTRL_WHICH_REQUEST_VAL)
>  		return 0;
>  	return find_ref_lock(hdl, which | 1) ? 0 : -EINVAL;
>  }
>  
> -
> -
>  /* Get extended controls. Allocates the helpers array if needed. */
>  int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *cs)
>  {
> @@ -3028,8 +3188,12 @@ int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *cs
>  			u32 idx = i;
>  
>  			do {
> -				ret = ctrl_to_user(cs->controls + idx,
> -						   helpers[idx].ref->ctrl);
> +				if (helpers[idx].ref->req)
> +					ret = req_to_user(cs->controls + idx,
> +						helpers[idx].ref->req);
> +				else
> +					ret = ctrl_to_user(cs->controls + idx,
> +						helpers[idx].ref->ctrl);
>  				idx = helpers[idx].next;
>  			} while (!ret && idx);
>  		}
> @@ -3302,7 +3466,16 @@ static int try_set_ext_ctrls(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
>  		} while (!ret && idx);
>  
>  		if (!ret)
> -			ret = try_or_set_cluster(fh, master, set, 0);
> +			ret = try_or_set_cluster(fh, master,
> +						 !hdl->req_obj.req && set, 0);
> +		if (!ret && hdl->req_obj.req && set) {
> +			for (j = 0; j < master->ncontrols; j++) {
> +				struct v4l2_ctrl_ref *ref =
> +					find_ref(hdl, master->cluster[j]->id);
> +
> +				new_to_req(ref);
> +			}
> +		}
>  
>  		/* Copy the new values back to userspace. */
>  		if (!ret) {
> @@ -3429,6 +3602,152 @@ int __v4l2_ctrl_s_ctrl_string(struct v4l2_ctrl *ctrl, const char *s)
>  }
>  EXPORT_SYMBOL(__v4l2_ctrl_s_ctrl_string);
>  
> +void v4l2_ctrl_request_complete(struct media_request *req,
> +				struct v4l2_ctrl_handler *main_hdl)
> +{
> +	struct media_request_object *obj;
> +	struct v4l2_ctrl_handler *hdl;
> +	struct v4l2_ctrl_ref *ref;
> +
> +	if (!req || !main_hdl)
> +		return;
> +
> +	obj = media_request_object_find(req, &req_ops, main_hdl);
> +	if (!obj)
> +		return;
> +	hdl = container_of(obj, struct v4l2_ctrl_handler, req_obj);
> +
> +	list_for_each_entry(ref, &hdl->ctrl_refs, node) {
> +		struct v4l2_ctrl *ctrl = ref->ctrl;
> +		struct v4l2_ctrl *master = ctrl->cluster[0];
> +		unsigned int i;
> +
> +		if (ctrl->flags & V4L2_CTRL_FLAG_VOLATILE) {
> +			ref->req = ref;
> +
> +			v4l2_ctrl_lock(master);
> +			/* g_volatile_ctrl will update the current control values */
> +			for (i = 0; i < master->ncontrols; i++)
> +				cur_to_new(master->cluster[i]);
> +			call_op(master, g_volatile_ctrl);
> +			new_to_req(ref);
> +			v4l2_ctrl_unlock(master);
> +			continue;
> +		}
> +		if (ref->req == ref)
> +			continue;
> +
> +		v4l2_ctrl_lock(ctrl);
> +		if (ref->req)
> +			ptr_to_ptr(ctrl, ref->req->p_req, ref->p_req);
> +		else
> +			ptr_to_ptr(ctrl, ctrl->p_cur, ref->p_req);
> +		v4l2_ctrl_unlock(ctrl);
> +	}
> +
> +	WARN_ON(!hdl->request_is_queued);
> +	list_del_init(&hdl->requests_queued);
> +	hdl->request_is_queued = false;
> +	media_request_object_complete(obj);
> +	media_request_object_put(obj);
> +}
> +EXPORT_SYMBOL(v4l2_ctrl_request_complete);
> +
> +void v4l2_ctrl_request_setup(struct media_request *req,
> +			     struct v4l2_ctrl_handler *main_hdl)
> +{
> +	struct media_request_object *obj;
> +	struct v4l2_ctrl_handler *hdl;
> +	struct v4l2_ctrl_ref *ref;
> +
> +	if (!req || !main_hdl)
> +		return;
> +

We should check that the request is in QUEUED state to avoid this
function being called at the wrong time. Just WARN and return if
the request is in the wrong state.

> +	obj = media_request_object_find(req, &req_ops, main_hdl);
> +	if (!obj)
> +		return;
> +	if (obj->completed) {
> +		media_request_object_put(obj);
> +		return;
> +	}
> +	hdl = container_of(obj, struct v4l2_ctrl_handler, req_obj);
> +
> +	mutex_lock(hdl->lock);

This lock should be dropped. Since we're in QUEUED state userspace is no
longer allowed to make changes to the request, so we do not need to lock this
control handler.

Locking here causes false lockdep warnings. The real cause of that is that
all control handlers created by v4l2_ctrls_find_req_obj() (next patch) look
as if they use the same mutex to lockdep since they use the same
struct lock_class_key. There is no easy way around that (at least none that I
could find).

The easiest way to solve this is actually to simple not lock. Provided the
request is in state QUEUED that is fine.

Regards,

	Hans

> +
> +	list_for_each_entry(ref, &hdl->ctrl_refs, node)
> +		ref->req_done = false;
> +
> +	list_for_each_entry(ref, &hdl->ctrl_refs, node) {
> +		struct v4l2_ctrl *ctrl = ref->ctrl;
> +		struct v4l2_ctrl *master = ctrl->cluster[0];
> +		bool have_new_data = false;
> +		int i;
> +
> +		/*
> +		 * Skip if this control was already handled by a cluster.
> +		 * Skip button controls and read-only controls.
> +		 */
> +		if (ref->req_done || ctrl->type == V4L2_CTRL_TYPE_BUTTON ||
> +		    (ctrl->flags & V4L2_CTRL_FLAG_READ_ONLY))
> +			continue;
> +
> +		v4l2_ctrl_lock(master);
> +		for (i = 0; i < master->ncontrols; i++) {
> +			if (master->cluster[i]) {
> +				struct v4l2_ctrl_ref *r =
> +					find_ref(hdl, master->cluster[i]->id);
> +
> +				if (r->req && r == r->req) {
> +					have_new_data = true;
> +					break;
> +				}
> +			}
> +		}
> +		if (!have_new_data) {
> +			v4l2_ctrl_unlock(master);
> +			continue;
> +		}
> +
> +		for (i = 0; i < master->ncontrols; i++) {
> +			if (master->cluster[i]) {
> +				struct v4l2_ctrl_ref *r =
> +					find_ref(hdl, master->cluster[i]->id);
> +
> +				req_to_new(r);
> +				master->cluster[i]->is_new = 1;
> +				r->req_done = true;
> +			}
> +		}
> +		/*
> +		 * For volatile autoclusters that are currently in auto mode
> +		 * we need to discover if it will be set to manual mode.
> +		 * If so, then we have to copy the current volatile values
> +		 * first since those will become the new manual values (which
> +		 * may be overwritten by explicit new values from this set
> +		 * of controls).
> +		 */
> +		if (master->is_auto && master->has_volatiles &&
> +		    !is_cur_manual(master)) {
> +			s32 new_auto_val = *master->p_new.p_s32;
> +
> +			/*
> +			 * If the new value == the manual value, then copy
> +			 * the current volatile values.
> +			 */
> +			if (new_auto_val == master->manual_mode_value)
> +				update_from_auto_cluster(master);
> +		}
> +
> +		try_or_set_cluster(NULL, master, true, 0);
> +
> +		v4l2_ctrl_unlock(master);
> +	}
> +
> +	mutex_unlock(hdl->lock);
> +	media_request_object_put(obj);
> +}
> +EXPORT_SYMBOL(v4l2_ctrl_request_setup);
> +
>  void v4l2_ctrl_notify(struct v4l2_ctrl *ctrl, v4l2_ctrl_notify_fnc notify, void *priv)
>  {
>  	if (ctrl == NULL)
> diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
> index 847d6f543e4a..65eade646156 100644
> --- a/include/media/v4l2-ctrls.h
> +++ b/include/media/v4l2-ctrls.h
> @@ -250,6 +250,12 @@ struct v4l2_ctrl {
>   *		``prepare_ext_ctrls`` function at ``v4l2-ctrl.c``.
>   * @from_other_dev: If true, then @ctrl was defined in another
>   *		device than the &struct v4l2_ctrl_handler.
> + * @req_done:	Internal flag: if the control handler containing this control
> + *		reference is bound to a media request, then this is set when
> + *		the control has been applied. This prevents applying controls
> + *		from a cluster with multiple controls twice (when the first
> + *		control of a cluster is applied, they all are).
> + * @req:	If set, this refers to another request that sets this control.
>   * @p_req:	If the control handler containing this control reference
>   *		is bound to a media request, then this points to the
>   *		value of the control that should be applied when the request
> @@ -266,6 +272,8 @@ struct v4l2_ctrl_ref {
>  	struct v4l2_ctrl *ctrl;
>  	struct v4l2_ctrl_helper *helper;
>  	bool from_other_dev;
> +	bool req_done;
> +	struct v4l2_ctrl_ref *req;
>  	union v4l2_ctrl_ptr p_req;
>  };
>  
> @@ -290,6 +298,15 @@ struct v4l2_ctrl_ref {
>   * @notify_priv: Passed as argument to the v4l2_ctrl notify callback.
>   * @nr_of_buckets: Total number of buckets in the array.
>   * @error:	The error code of the first failed control addition.
> + * @request_is_queued: True if the request was queued.
> + * @requests:	List to keep track of open control handler request objects.
> + *		For the parent control handler (@req_obj.req == NULL) this
> + *		is the list header. When the parent control handler is
> + *		removed, it has to unbind and put all these requests since
> + *		they refer to the parent.
> + * @requests_queued: List of the queued requests. This determines the order
> + *		in which these controls are applied. Once the request is
> + *		completed it is removed from this list.
>   * @req_obj:	The &struct media_request_object, used to link into a
>   *		&struct media_request. This request object has a refcount.
>   */
> @@ -304,6 +321,9 @@ struct v4l2_ctrl_handler {
>  	void *notify_priv;
>  	u16 nr_of_buckets;
>  	int error;
> +	bool request_is_queued;
> +	struct list_head requests;
> +	struct list_head requests_queued;
>  	struct media_request_object req_obj;
>  };
>  
> @@ -1062,6 +1082,37 @@ int v4l2_ctrl_subscribe_event(struct v4l2_fh *fh,
>   */
>  __poll_t v4l2_ctrl_poll(struct file *file, struct poll_table_struct *wait);
>  
> +/**
> + * v4l2_ctrl_request_setup - helper function to apply control values in a request
> + *
> + * @req: The request
> + * @hdl: The control handler
> + *
> + * This is a helper function to call the control handler's s_ctrl callback with
> + * the control values contained in the request. Do note that this approach of
> + * applying control values in a request is only applicable to memory-to-memory
> + * devices.
> + */
> +void v4l2_ctrl_request_setup(struct media_request *req,
> +			     struct v4l2_ctrl_handler *hdl);
> +
> +/**
> + * v4l2_ctrl_request_complete - Complete a control handler request object
> + *
> + * @req: The request
> + * @hdl: The control handler
> + *
> + * This function is to be called on each control handler that may have had a
> + * request object associated with it, i.e. control handlers of a driver that
> + * supports requests.
> + *
> + * The function first obtains the values of any volatile controls in the control
> + * handler and attach them to the request. Then, the function completes the
> + * request object.
> + */
> +void v4l2_ctrl_request_complete(struct media_request *req,
> +				struct v4l2_ctrl_handler *hdl);
> +
>  /* Helpers for ioctl_ops */
>  
>  /**
> 
