Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:53978 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752489AbeEPKTg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 May 2018 06:19:36 -0400
Date: Wed, 16 May 2018 13:19:34 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv13 12/28] v4l2-ctrls: add core request support
Message-ID: <20180516101934.dekzi6zlyzqbs5t6@valkosipuli.retiisi.org.uk>
References: <20180503145318.128315-1-hverkuil@xs4all.nl>
 <20180503145318.128315-13-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180503145318.128315-13-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Thu, May 03, 2018 at 04:53:02PM +0200, Hans Verkuil wrote:
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
>  include/media/v4l2-ctrls.h           |  23 ++
>  2 files changed, 348 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
> index da4cc1485dc4..56b986185463 100644
> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
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

Drivers are expected to use this function internally to make use of the
control values in the request. Is that your thinking as well?

The problem with this implementation is that once a driver eventually gets
a callback (s_ctrl), the callback doesn't have the information on the
request. That means the driver has no means to associate the control value
to the request anymore --- and that is against the very purpose of the
function.

Instead, I'd add a new argument to the callback function --- the request
--- or add another callback function to be used for applying control values
for requests. Or alternatively, provide an easy way to enumerate the
controls and their values in a control handler. For the driver must store
that value in the request itself to be able to use it: the current
implementation in vim2m is such that controls are simply set to the driver
as they'd arrive from the uAPI directly. This way also anyone having access
to the video device could set whatever control values that would end up
being used in processing the request.

Feel free to point out if I'm mistaken in my analysis.

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
> +	if (obj->completed) {
> +		media_request_object_put(obj);
> +		return;
> +	}
> +	hdl = container_of(obj, struct v4l2_ctrl_handler, req_obj);
> +
> +	mutex_lock(hdl->lock);
> +
> +	list_for_each_entry(ref, &hdl->ctrl_refs, node)
> +		ref->done = false;
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
> +		if (ref->done || ctrl->type == V4L2_CTRL_TYPE_BUTTON ||
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
> +				r->done = true;
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
> index 76352eb59f14..a0f7c38d1a90 100644
> --- a/include/media/v4l2-ctrls.h
> +++ b/include/media/v4l2-ctrls.h
> @@ -250,6 +250,10 @@ struct v4l2_ctrl {
>   *		``prepare_ext_ctrls`` function at ``v4l2-ctrl.c``.
>   * @from_other_dev: If true, then @ctrl was defined in another
>   *		device than the &struct v4l2_ctrl_handler.
> + * @done:	If true, then this control reference is part of a
> + *		control cluster that was already set while applying
> + *		the controls in this media request object.
> + * @req:	If set, this refers to another request that sets this control.
>   * @p_req:	The request value. Only used if the control handler
>   *		is bound to a media request.
>   *
> @@ -263,6 +267,8 @@ struct v4l2_ctrl_ref {
>  	struct v4l2_ctrl *ctrl;
>  	struct v4l2_ctrl_helper *helper;
>  	bool from_other_dev;
> +	bool done;
> +	struct v4l2_ctrl_ref *req;
>  	union v4l2_ctrl_ptr p_req;
>  };
>  
> @@ -287,6 +293,15 @@ struct v4l2_ctrl_ref {
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
>   *		&struct media_request.
>   */
> @@ -301,6 +316,9 @@ struct v4l2_ctrl_handler {
>  	void *notify_priv;
>  	u16 nr_of_buckets;
>  	int error;
> +	bool request_is_queued;
> +	struct list_head requests;
> +	struct list_head requests_queued;
>  	struct media_request_object req_obj;
>  };
>  
> @@ -1059,6 +1077,11 @@ int v4l2_ctrl_subscribe_event(struct v4l2_fh *fh,
>   */
>  __poll_t v4l2_ctrl_poll(struct file *file, struct poll_table_struct *wait);
>  
> +void v4l2_ctrl_request_setup(struct media_request *req,
> +			     struct v4l2_ctrl_handler *hdl);
> +void v4l2_ctrl_request_complete(struct media_request *req,
> +				struct v4l2_ctrl_handler *hdl);
> +
>  /* Helpers for ioctl_ops */
>  
>  /**
> -- 
> 2.17.0
> 

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
