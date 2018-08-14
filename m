Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud7.xs4all.net ([194.109.24.24]:54876 "EHLO
        lb1-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727986AbeHNLU6 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Aug 2018 07:20:58 -0400
Subject: Re: [PATCHv17 14/34] v4l2-ctrls: add core request support
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
References: <20180804124526.46206-1-hverkuil@xs4all.nl>
 <20180804124526.46206-15-hverkuil@xs4all.nl>
 <20180813075530.1b3c7fe7@coco.lan>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <18a32cb5-0cb8-164b-2112-8b76760a01fa@xs4all.nl>
Date: Tue, 14 Aug 2018 10:34:47 +0200
MIME-Version: 1.0
In-Reply-To: <20180813075530.1b3c7fe7@coco.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 13/08/18 12:55, Mauro Carvalho Chehab wrote:
> Em Sat,  4 Aug 2018 14:45:06 +0200
> Hans Verkuil <hverkuil@xs4all.nl> escreveu:
> 
>> From: Hans Verkuil <hans.verkuil@cisco.com>
>>
>> Integrate the request support. This adds the v4l2_ctrl_request_complete
>> and v4l2_ctrl_request_setup functions to complete a request and (as a
>> helper function) to apply a request to the hardware.
>>
>> It takes care of queuing requests and correctly chaining control values
>> in the request queue.
>>
>> Note that when a request is marked completed it will copy control values
>> to the internal request state. This can be optimized in the future since
>> this is sub-optimal when dealing with large compound and/or array controls.
>>
>> For the initial 'stateless codec' use-case the current implementation is
>> sufficient.
>>
>> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
>> ---
>>  drivers/media/v4l2-core/v4l2-ctrls.c | 326 ++++++++++++++++++++++++++-
>>  include/media/v4l2-ctrls.h           |  51 +++++
>>  2 files changed, 371 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
>> index 570b6f8ae46a..b8ff6d6b14cd 100644
>> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
>> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
>> @@ -1668,6 +1668,13 @@ static int new_to_user(struct v4l2_ext_control *c,
>>  	return ptr_to_user(c, ctrl, ctrl->p_new);
>>  }
>>  
>> +/* Helper function: copy the request value back to the caller */
>> +static int req_to_user(struct v4l2_ext_control *c,
>> +		       struct v4l2_ctrl_ref *ref)
>> +{
>> +	return ptr_to_user(c, ref->ctrl, ref->p_req);
>> +}
>> +
>>  /* Helper function: copy the initial control value back to the caller */
>>  static int def_to_user(struct v4l2_ext_control *c, struct v4l2_ctrl *ctrl)
>>  {
>> @@ -1787,6 +1794,26 @@ static void cur_to_new(struct v4l2_ctrl *ctrl)
>>  	ptr_to_ptr(ctrl, ctrl->p_cur, ctrl->p_new);
>>  }
>>  
>> +/* Copy the new value to the request value */
>> +static void new_to_req(struct v4l2_ctrl_ref *ref)
>> +{
>> +	if (!ref)
>> +		return;
>> +	ptr_to_ptr(ref->ctrl, ref->ctrl->p_new, ref->p_req);
>> +	ref->req = ref;
>> +}
>> +
>> +/* Copy the request value to the new value */
>> +static void req_to_new(struct v4l2_ctrl_ref *ref)
>> +{
>> +	if (!ref)
>> +		return;
>> +	if (ref->req)
>> +		ptr_to_ptr(ref->ctrl, ref->req->p_req, ref->ctrl->p_new);
>> +	else
>> +		ptr_to_ptr(ref->ctrl, ref->ctrl->p_cur, ref->ctrl->p_new);
>> +}
>> +
>>  /* Return non-zero if one or more of the controls in the cluster has a new
>>     value that differs from the current value. */
>>  static int cluster_changed(struct v4l2_ctrl *master)
>> @@ -1896,6 +1923,9 @@ int v4l2_ctrl_handler_init_class(struct v4l2_ctrl_handler *hdl,
>>  	lockdep_set_class_and_name(hdl->lock, key, name);
>>  	INIT_LIST_HEAD(&hdl->ctrls);
>>  	INIT_LIST_HEAD(&hdl->ctrl_refs);
>> +	INIT_LIST_HEAD(&hdl->requests);
>> +	INIT_LIST_HEAD(&hdl->requests_queued);
>> +	hdl->request_is_queued = false;
>>  	hdl->nr_of_buckets = 1 + nr_of_controls_hint / 8;
>>  	hdl->buckets = kvmalloc_array(hdl->nr_of_buckets,
>>  				      sizeof(hdl->buckets[0]),
>> @@ -1916,6 +1946,14 @@ void v4l2_ctrl_handler_free(struct v4l2_ctrl_handler *hdl)
>>  	if (hdl == NULL || hdl->buckets == NULL)
>>  		return;
>>  
>> +	if (!hdl->req_obj.req && !list_empty(&hdl->requests)) {
>> +		struct v4l2_ctrl_handler *req, *next_req;
>> +
>> +		list_for_each_entry_safe(req, next_req, &hdl->requests, requests) {
>> +			media_request_object_unbind(&req->req_obj);
>> +			media_request_object_put(&req->req_obj);
> 
> Hmm... while this would work for the trivial case where object_put()
> would just drop the object from the list if nobody else is using it,
> nothing prevents that, if v4l2_ctrl_handler_free() is called twice,
> it would do the wrong thing... as the only test here is if req_obj.reg 
> is not NULL, and not if the control framework is already done with the
> object.

v4l2_ctrl_handler_free sets hdl->buckets to NULL when done. And if it is
called twice it will detect that hdl->buckets == NULL and return.

So this isn't an issue.

> 
>> +		}
>> +	}
>>  	mutex_lock(hdl->lock);
>>  	/* Free all nodes */
>>  	list_for_each_entry_safe(ref, next_ref, &hdl->ctrl_refs, node) {
>> @@ -2837,6 +2875,123 @@ int v4l2_querymenu(struct v4l2_ctrl_handler *hdl, struct v4l2_querymenu *qm)
>>  }
>>  EXPORT_SYMBOL(v4l2_querymenu);
>>  
>> +static int v4l2_ctrl_request_clone(struct v4l2_ctrl_handler *hdl,
>> +				   const struct v4l2_ctrl_handler *from)
>> +{
>> +	struct v4l2_ctrl_ref *ref;
>> +	int err;
>> +
>> +	if (WARN_ON(!hdl || hdl == from))
>> +		return -EINVAL;
>> +
>> +	if (hdl->error)
>> +		return hdl->error;
>> +
>> +	WARN_ON(hdl->lock != &hdl->_lock);
>> +
>> +	mutex_lock(from->lock);
>> +	list_for_each_entry(ref, &from->ctrl_refs, node) {
>> +		struct v4l2_ctrl *ctrl = ref->ctrl;
>> +		struct v4l2_ctrl_ref *new_ref;
>> +
>> +		/* Skip refs inherited from other devices */
>> +		if (ref->from_other_dev)
>> +			continue;
>> +		/* And buttons */
>> +		if (ctrl->type == V4L2_CTRL_TYPE_BUTTON)
>> +			continue;
>> +		err = handler_new_ref(hdl, ctrl, &new_ref, false, true);
>> +		if (err)
>> +			break;
>> +	}
>> +	mutex_unlock(from->lock);
>> +	return err;
>> +}
>> +
>> +static void v4l2_ctrl_request_queue(struct media_request_object *obj)
>> +{
>> +	struct v4l2_ctrl_handler *hdl =
>> +		container_of(obj, struct v4l2_ctrl_handler, req_obj);
>> +	struct v4l2_ctrl_handler *main_hdl = obj->priv;
>> +	struct v4l2_ctrl_handler *prev_hdl = NULL;
>> +	struct v4l2_ctrl_ref *ref_ctrl, *ref_ctrl_prev = NULL;
>> +
>> +	if (list_empty(&main_hdl->requests_queued))
>> +		goto queue;
>> +
>> +	prev_hdl = list_last_entry(&main_hdl->requests_queued,
>> +				   struct v4l2_ctrl_handler, requests_queued);
>> +	/*
>> +	 * Note: prev_hdl and hdl must contain the same list of control
>> +	 * references, so if any differences are detected then that is a
>> +	 * driver bug and the WARN_ON is triggered.
>> +	 */
>> +	mutex_lock(prev_hdl->lock);
>> +	ref_ctrl_prev = list_first_entry(&prev_hdl->ctrl_refs,
>> +					 struct v4l2_ctrl_ref, node);
>> +	list_for_each_entry(ref_ctrl, &hdl->ctrl_refs, node) {
>> +		if (ref_ctrl->req)
>> +			continue;
>> +		while (ref_ctrl_prev->ctrl->id < ref_ctrl->ctrl->id) {
>> +			/* Should never happen, but just in case... */
>> +			if (list_is_last(&ref_ctrl_prev->node,
>> +					 &prev_hdl->ctrl_refs))
> 
> If should never happen, please use unlikely(). That makes clearer
> while doing some speed optimization).

Sorry, I won't make this change. There is no optimization benefit from
using unlikely (there almost never is) and it just pollutes the code.

> 
>> +				break;
>> +			ref_ctrl_prev = list_next_entry(ref_ctrl_prev, node);
>> +		}
>> +		if (WARN_ON(ref_ctrl_prev->ctrl->id != ref_ctrl->ctrl->id))
>> +			break;
>> +		ref_ctrl->req = ref_ctrl_prev->req;
>> +	}
>> +	mutex_unlock(prev_hdl->lock);
>> +queue:
>> +	list_add_tail(&hdl->requests_queued, &main_hdl->requests_queued);
> 
> Shouldn't list changes be serialized? Ok, the ioctls are serialized, but
> device removal/unbind can happen any time for hot-plugged devices[1].

They are serialized. This function is (indirectly) called from
media_request_ioctl_queue() which has req_queue_mutex locked. This should all
be safe.

> 
> [1] yeah, I know that, right now, the framework is meant to be used only
> by codecs that are on SoC, but I'm pretty sure we'll end by using it on
> other use cases in the future. As this is core code, we should be sure 
> that it will not cause troubles due to the lack of a proper locking, as
> I doubt we'll review the locks when adding other use cases.
> 
>> +	hdl->request_is_queued = true;
>> +}
>> +
>> +static void v4l2_ctrl_request_unbind(struct media_request_object *obj)
>> +{
>> +	struct v4l2_ctrl_handler *hdl =
>> +		container_of(obj, struct v4l2_ctrl_handler, req_obj);
>> +
>> +	list_del_init(&hdl->requests);
>> +	if (hdl->request_is_queued) {
>> +		list_del_init(&hdl->requests_queued);
>> +		hdl->request_is_queued = false;
>> +	}
>> +}
>> +
>> +static void v4l2_ctrl_request_release(struct media_request_object *obj)
>> +{
>> +	struct v4l2_ctrl_handler *hdl =
>> +		container_of(obj, struct v4l2_ctrl_handler, req_obj);
>> +
>> +	v4l2_ctrl_handler_free(hdl);
>> +	kfree(hdl);
>> +}
>> +
>> +static const struct media_request_object_ops req_ops = {
>> +	.queue = v4l2_ctrl_request_queue,
>> +	.unbind = v4l2_ctrl_request_unbind,
>> +	.release = v4l2_ctrl_request_release,
>> +};
>> +
>> +static int v4l2_ctrl_request_bind(struct media_request *req,
>> +			   struct v4l2_ctrl_handler *hdl,
>> +			   struct v4l2_ctrl_handler *from)
>> +{
>> +	int ret;
>> +
>> +	ret = v4l2_ctrl_request_clone(hdl, from);
>> +
>> +	if (!ret) {
>> +		ret = media_request_object_bind(req, &req_ops,
>> +						from, &hdl->req_obj);
>> +		if (!ret)
>> +			list_add_tail(&hdl->requests, &from->requests);
>> +	}
>> +	return ret;
>> +}
>>  
>>  /* Some general notes on the atomic requirements of VIDIOC_G/TRY/S_EXT_CTRLS:
>>  
>> @@ -2898,6 +3053,7 @@ static int prepare_ext_ctrls(struct v4l2_ctrl_handler *hdl,
>>  
>>  		if (cs->which &&
>>  		    cs->which != V4L2_CTRL_WHICH_DEF_VAL &&
>> +		    cs->which != V4L2_CTRL_WHICH_REQUEST_VAL &&
>>  		    V4L2_CTRL_ID2WHICH(id) != cs->which)
>>  			return -EINVAL;
>>  
>> @@ -2977,13 +3133,12 @@ static int prepare_ext_ctrls(struct v4l2_ctrl_handler *hdl,
>>     whether there are any controls at all. */
>>  static int class_check(struct v4l2_ctrl_handler *hdl, u32 which)
>>  {
>> -	if (which == 0 || which == V4L2_CTRL_WHICH_DEF_VAL)
>> +	if (which == 0 || which == V4L2_CTRL_WHICH_DEF_VAL ||
>> +	    which == V4L2_CTRL_WHICH_REQUEST_VAL)
>>  		return 0;
>>  	return find_ref_lock(hdl, which | 1) ? 0 : -EINVAL;
>>  }
>>  
>> -
>> -
>>  /* Get extended controls. Allocates the helpers array if needed. */
>>  int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *cs)
>>  {
>> @@ -3049,8 +3204,12 @@ int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct v4l2_ext_controls *cs
>>  			u32 idx = i;
>>  
>>  			do {
>> -				ret = ctrl_to_user(cs->controls + idx,
>> -						   helpers[idx].ref->ctrl);
>> +				if (helpers[idx].ref->req)
>> +					ret = req_to_user(cs->controls + idx,
>> +						helpers[idx].ref->req);
>> +				else
>> +					ret = ctrl_to_user(cs->controls + idx,
>> +						helpers[idx].ref->ctrl);
>>  				idx = helpers[idx].next;
>>  			} while (!ret && idx);
>>  		}
>> @@ -3336,7 +3495,16 @@ static int try_set_ext_ctrls(struct v4l2_fh *fh, struct v4l2_ctrl_handler *hdl,
>>  		} while (!ret && idx);
>>  
>>  		if (!ret)
>> -			ret = try_or_set_cluster(fh, master, set, 0);
>> +			ret = try_or_set_cluster(fh, master,
>> +						 !hdl->req_obj.req && set, 0);
>> +		if (!ret && hdl->req_obj.req && set) {
>> +			for (j = 0; j < master->ncontrols; j++) {
>> +				struct v4l2_ctrl_ref *ref =
>> +					find_ref(hdl, master->cluster[j]->id);
>> +
>> +				new_to_req(ref);
>> +			}
>> +		}
>>  
>>  		/* Copy the new values back to userspace. */
>>  		if (!ret) {
>> @@ -3463,6 +3631,152 @@ int __v4l2_ctrl_s_ctrl_string(struct v4l2_ctrl *ctrl, const char *s)
>>  }
>>  EXPORT_SYMBOL(__v4l2_ctrl_s_ctrl_string);
>>  
>> +void v4l2_ctrl_request_complete(struct media_request *req,
>> +				struct v4l2_ctrl_handler *main_hdl)
>> +{
>> +	struct media_request_object *obj;
>> +	struct v4l2_ctrl_handler *hdl;
>> +	struct v4l2_ctrl_ref *ref;
>> +
>> +	if (!req || !main_hdl)
>> +		return;
>> +
>> +	obj = media_request_object_find(req, &req_ops, main_hdl);
>> +	if (!obj)
>> +		return;
>> +	hdl = container_of(obj, struct v4l2_ctrl_handler, req_obj);
>> +
>> +	list_for_each_entry(ref, &hdl->ctrl_refs, node) {
>> +		struct v4l2_ctrl *ctrl = ref->ctrl;
>> +		struct v4l2_ctrl *master = ctrl->cluster[0];
>> +		unsigned int i;
>> +
>> +		if (ctrl->flags & V4L2_CTRL_FLAG_VOLATILE) {
>> +			ref->req = ref;
>> +
>> +			v4l2_ctrl_lock(master);
>> +			/* g_volatile_ctrl will update the current control values */
>> +			for (i = 0; i < master->ncontrols; i++)
>> +				cur_to_new(master->cluster[i]);
>> +			call_op(master, g_volatile_ctrl);
>> +			new_to_req(ref);
>> +			v4l2_ctrl_unlock(master);
>> +			continue;
>> +		}
>> +		if (ref->req == ref)
>> +			continue;
>> +
>> +		v4l2_ctrl_lock(ctrl);
>> +		if (ref->req)
>> +			ptr_to_ptr(ctrl, ref->req->p_req, ref->p_req);
>> +		else
>> +			ptr_to_ptr(ctrl, ctrl->p_cur, ref->p_req);
>> +		v4l2_ctrl_unlock(ctrl);
>> +	}
>> +
>> +	WARN_ON(!hdl->request_is_queued);
>> +	list_del_init(&hdl->requests_queued);
>> +	hdl->request_is_queued = false;
>> +	media_request_object_complete(obj);
>> +	media_request_object_put(obj);
> 
> Hmm... nothing prevents that this would race with v4l2_ctrl_handler_free()
> and cause double-free (actually double object_put).

That would be a driver bug: complete is called when completing a request, and if
this happens after v4l2_ctrl_handler_free is called, then the driver got the
cleanup sequence wrong (and this won't be the only problem that driver has!).

> 
>> +}
>> +EXPORT_SYMBOL(v4l2_ctrl_request_complete);
>> +
>> +void v4l2_ctrl_request_setup(struct media_request *req,
>> +			     struct v4l2_ctrl_handler *main_hdl)
>> +{
>> +	struct media_request_object *obj;
>> +	struct v4l2_ctrl_handler *hdl;
>> +	struct v4l2_ctrl_ref *ref;
>> +
>> +	if (!req || !main_hdl)
>> +		return;
>> +
>> +	if (WARN_ON(req->state != MEDIA_REQUEST_STATE_QUEUED))
>> +		return;
>> +
>> +	obj = media_request_object_find(req, &req_ops, main_hdl);
>> +	if (!obj)
>> +		return;
> 
> Shouldn't the above checks produce an error or print something at
> the logs?

Good question.

I think not. This situation would occur if the applications makes a request
with only a buffer but no controls, thus making no changes to the controls in
this request.

This is perfectly legal, so nothing needs to be logged here.

Regards,

	Hans
