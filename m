Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.bootlin.com ([62.4.15.54]:43698 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750730AbeDKIjV (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Apr 2018 04:39:21 -0400
Message-ID: <69d1b6927c05c76d14eeb69e2ca611f18a1232b1.camel@bootlin.com>
Subject: Re: [RFCv11 PATCH 14/29] v4l2-ctrls: add core request support
From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Date: Wed, 11 Apr 2018 10:37:59 +0200
In-Reply-To: <20180409142026.19369-15-hverkuil@xs4all.nl>
References: <20180409142026.19369-1-hverkuil@xs4all.nl>
         <20180409142026.19369-15-hverkuil@xs4all.nl>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-R57eZo9AzNLA3mStqevy"
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--=-R57eZo9AzNLA3mStqevy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, 2018-04-09 at 16:20 +0200, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>=20
> Integrate the request support. This adds the
> v4l2_ctrl_request_complete
> and v4l2_ctrl_request_setup functions to complete a request and (as a
> helper function) to apply a request to the hardware.
>=20
> It takes care of queuing requests and correctly chaining control
> values
> in the request queue.
>=20
> Note that when a request is marked completed it will copy control
> values
> to the internal request state. This can be optimized in the future
> since
> this is sub-optimal when dealing with large compound and/or array
> controls.
>=20
> For the initial 'stateless codec' use-case the current implementation
> is
> sufficient.

See one comment about a missing unlock below.

> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/v4l2-core/v4l2-ctrls.c | 325
> ++++++++++++++++++++++++++++++++++-
>  include/media/v4l2-ctrls.h           |  23 +++
>  2 files changed, 342 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c
> b/drivers/media/v4l2-core/v4l2-ctrls.c
> index da4cc1485dc4..6e2c5e24734f 100644
> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> @@ -1647,6 +1647,13 @@ static int new_to_user(struct v4l2_ext_control
> *c,
>  	return ptr_to_user(c, ctrl, ctrl->p_new);
>  }
> =20
> +/* Helper function: copy the request value back to the caller */
> +static int req_to_user(struct v4l2_ext_control *c,
> +		       struct v4l2_ctrl_ref *ref)
> +{
> +	return ptr_to_user(c, ref->ctrl, ref->p_req);
> +}
> +
>  /* Helper function: copy the initial control value back to the caller
> */
>  static int def_to_user(struct v4l2_ext_control *c, struct v4l2_ctrl
> *ctrl)
>  {
> @@ -1766,6 +1773,26 @@ static void cur_to_new(struct v4l2_ctrl *ctrl)
>  	ptr_to_ptr(ctrl, ctrl->p_cur, ctrl->p_new);
>  }
> =20
> +/* Copy the new value to the request value */
> +static void new_to_req(struct v4l2_ctrl_ref *ref)
> +{
> +	if (!ref)
> +		return;
> +	ptr_to_ptr(ref->ctrl, ref->ctrl->p_new, ref->p_req);
> +	ref->req =3D ref;
> +}
> +
> +/* Copy the request value to the new value */
> +static void req_to_new(struct v4l2_ctrl_ref *ref)
> +{
> +	if (!ref)
> +		return;
> +	if (ref->req)
> +		ptr_to_ptr(ref->ctrl, ref->req->p_req, ref->ctrl-
> >p_new);
> +	else
> +		ptr_to_ptr(ref->ctrl, ref->ctrl->p_cur, ref->ctrl-
> >p_new);
> +}
> +
>  /* Return non-zero if one or more of the controls in the cluster has
> a new
>     value that differs from the current value. */
>  static int cluster_changed(struct v4l2_ctrl *master)
> @@ -1875,6 +1902,9 @@ int v4l2_ctrl_handler_init_class(struct
> v4l2_ctrl_handler *hdl,
>  	lockdep_set_class_and_name(hdl->lock, key, name);
>  	INIT_LIST_HEAD(&hdl->ctrls);
>  	INIT_LIST_HEAD(&hdl->ctrl_refs);
> +	INIT_LIST_HEAD(&hdl->requests);
> +	INIT_LIST_HEAD(&hdl->requests_queued);
> +	hdl->request_is_queued =3D false;
>  	hdl->nr_of_buckets =3D 1 + nr_of_controls_hint / 8;
>  	hdl->buckets =3D kvmalloc_array(hdl->nr_of_buckets,
>  				      sizeof(hdl->buckets[0]),
> @@ -1895,6 +1925,14 @@ void v4l2_ctrl_handler_free(struct
> v4l2_ctrl_handler *hdl)
>  	if (hdl =3D=3D NULL || hdl->buckets =3D=3D NULL)
>  		return;
> =20
> +	if (!hdl->req_obj.req && !list_empty(&hdl->requests)) {
> +		struct v4l2_ctrl_handler *req, *next_req;
> +
> +		list_for_each_entry_safe(req, next_req, &hdl-
> >requests, requests) {
> +			media_request_object_unbind(&req->req_obj);
> +			media_request_object_put(&req->req_obj);
> +		}
> +	}
>  	mutex_lock(hdl->lock);
>  	/* Free all nodes */
>  	list_for_each_entry_safe(ref, next_ref, &hdl->ctrl_refs,
> node) {
> @@ -2816,6 +2854,126 @@ int v4l2_querymenu(struct v4l2_ctrl_handler
> *hdl, struct v4l2_querymenu *qm)
>  }
>  EXPORT_SYMBOL(v4l2_querymenu);
> =20
> +static int v4l2_ctrl_request_clone(struct v4l2_ctrl_handler *hdl,
> +				   const struct v4l2_ctrl_handler
> *from)
> +{
> +	struct v4l2_ctrl_ref *ref;
> +	int err;
> +
> +	if (WARN_ON(!hdl || hdl =3D=3D from))
> +		return -EINVAL;
> +
> +	if (hdl->error)
> +		return hdl->error;
> +
> +	WARN_ON(hdl->lock !=3D &hdl->_lock);
> +
> +	mutex_lock(from->lock);
> +	list_for_each_entry(ref, &from->ctrl_refs, node) {
> +		struct v4l2_ctrl *ctrl =3D ref->ctrl;
> +		struct v4l2_ctrl_ref *new_ref;
> +
> +		/* Skip refs inherited from other devices */
> +		if (ref->from_other_dev)
> +			continue;
> +		/* And buttons */
> +		if (ctrl->type =3D=3D V4L2_CTRL_TYPE_BUTTON)
> +			continue;
> +		err =3D handler_new_ref(hdl, ctrl, &new_ref, false,
> true);
> +		if (err) {
> +			printk("%s: handler_new_ref on control %x
> (%s) returned %d\n", __func__, ctrl->id, ctrl->name, err);
> +			err =3D 0;
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
> +	struct v4l2_ctrl_handler *hdl =3D
> +		container_of(obj, struct v4l2_ctrl_handler, req_obj);
> +	struct v4l2_ctrl_handler *main_hdl =3D obj->priv;
> +	struct v4l2_ctrl_handler *prev =3D NULL;
> +	struct v4l2_ctrl_ref *ref_hdl, *ref_prev =3D NULL;
> +
> +	if (list_empty(&main_hdl->requests_queued))
> +		goto queue;
> +
> +	prev =3D list_last_entry(&main_hdl->requests_queued,
> +			       struct v4l2_ctrl_handler,
> requests_queued);
> +	mutex_lock(prev->lock);
> +	ref_prev =3D list_first_entry(&prev->ctrl_refs,
> +				    struct v4l2_ctrl_ref, node);
> +	list_for_each_entry(ref_hdl, &hdl->ctrl_refs, node) {
> +		if (ref_hdl->req)
> +			continue;
> +		while (ref_prev->ctrl->id < ref_hdl->ctrl->id)
> +			ref_prev =3D list_next_entry(ref_prev, node);
> +		if (WARN_ON(ref_prev->ctrl->id !=3D ref_hdl->ctrl->id))
> +			break;
> +		ref_hdl->req =3D ref_prev->req;
> +	}
> +	mutex_unlock(prev->lock);
> +queue:
> +	list_add_tail(&hdl->requests_queued, &main_hdl-
> >requests_queued);
> +	hdl->request_is_queued =3D true;
> +}
> +
> +static void v4l2_ctrl_request_unbind(struct media_request_object
> *obj)
> +{
> +	struct v4l2_ctrl_handler *hdl =3D
> +		container_of(obj, struct v4l2_ctrl_handler, req_obj);
> +
> +	list_del_init(&hdl->requests);
> +	if (hdl->request_is_queued) {
> +		list_del_init(&hdl->requests_queued);
> +		hdl->request_is_queued =3D false;
> +	}
> +}
> +
> +static void v4l2_ctrl_request_cancel(struct media_request_object
> *obj)
> +{
> +	struct v4l2_ctrl_handler *hdl =3D
> +		container_of(obj, struct v4l2_ctrl_handler, req_obj);
> +
> +	if (hdl->request_is_queued)
> +		v4l2_ctrl_request_complete(hdl->req_obj.req, hdl-
> >req_obj.priv);
> +}
> +
> +static void v4l2_ctrl_request_release(struct media_request_object
> *obj)
> +{
> +	struct v4l2_ctrl_handler *hdl =3D
> +		container_of(obj, struct v4l2_ctrl_handler, req_obj);
> +
> +	v4l2_ctrl_handler_free(hdl);
> +	kfree(hdl);
> +}
> +
> +static const struct media_request_object_ops req_ops =3D {
> +	.queue =3D v4l2_ctrl_request_queue,
> +	.unbind =3D v4l2_ctrl_request_unbind,
> +	.cancel =3D v4l2_ctrl_request_cancel,
> +	.release =3D v4l2_ctrl_request_release,
> +};
> +
> +static int v4l2_ctrl_request_bind(struct media_request *req,
> +			   struct v4l2_ctrl_handler *hdl,
> +			   struct v4l2_ctrl_handler *from)
> +{
> +	int ret;
> +
> +	ret =3D v4l2_ctrl_request_clone(hdl, from);
> +
> +	if (!ret) {
> +		list_add_tail(&hdl->requests, &from->requests);
> +		media_request_object_bind(req, &req_ops, from, &hdl-
> >req_obj);
> +	}
> +	return ret;
> +}
> =20
>  /* Some general notes on the atomic requirements of
> VIDIOC_G/TRY/S_EXT_CTRLS:
> =20
> @@ -2877,6 +3035,7 @@ static int prepare_ext_ctrls(struct
> v4l2_ctrl_handler *hdl,
> =20
>  		if (cs->which &&
>  		    cs->which !=3D V4L2_CTRL_WHICH_DEF_VAL &&
> +		    cs->which !=3D V4L2_CTRL_WHICH_REQUEST &&
>  		    V4L2_CTRL_ID2WHICH(id) !=3D cs->which)
>  			return -EINVAL;
> =20
> @@ -2956,13 +3115,12 @@ static int prepare_ext_ctrls(struct
> v4l2_ctrl_handler *hdl,
>     whether there are any controls at all. */
>  static int class_check(struct v4l2_ctrl_handler *hdl, u32 which)
>  {
> -	if (which =3D=3D 0 || which =3D=3D V4L2_CTRL_WHICH_DEF_VAL)
> +	if (which =3D=3D 0 || which =3D=3D V4L2_CTRL_WHICH_DEF_VAL ||
> +	    which =3D=3D V4L2_CTRL_WHICH_REQUEST)
>  		return 0;
>  	return find_ref_lock(hdl, which | 1) ? 0 : -EINVAL;
>  }
> =20
> -
> -
>  /* Get extended controls. Allocates the helpers array if needed. */
>  int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler *hdl, struct
> v4l2_ext_controls *cs)
>  {
> @@ -3028,8 +3186,12 @@ int v4l2_g_ext_ctrls(struct v4l2_ctrl_handler
> *hdl, struct v4l2_ext_controls *cs
>  			u32 idx =3D i;
> =20
>  			do {
> -				ret =3D ctrl_to_user(cs->controls +
> idx,
> -						   helpers[idx].ref-
> >ctrl);
> +				if (helpers[idx].ref->req)
> +					ret =3D req_to_user(cs-
> >controls + idx,
> +						helpers[idx].ref-
> >req);
> +				else
> +					ret =3D ctrl_to_user(cs-
> >controls + idx,
> +						helpers[idx].ref-
> >ctrl);
>  				idx =3D helpers[idx].next;
>  			} while (!ret && idx);
>  		}
> @@ -3302,7 +3464,16 @@ static int try_set_ext_ctrls(struct v4l2_fh
> *fh, struct v4l2_ctrl_handler *hdl,
>  		} while (!ret && idx);
> =20
>  		if (!ret)
> -			ret =3D try_or_set_cluster(fh, master, set, 0);
> +			ret =3D try_or_set_cluster(fh, master,
> +						 !hdl->req_obj.req &&
> set, 0);
> +		if (!ret && hdl->req_obj.req && set) {
> +			for (j =3D 0; j < master->ncontrols; j++) {
> +				struct v4l2_ctrl_ref *ref =3D
> +					find_ref(hdl, master-
> >cluster[j]->id);
> +
> +				new_to_req(ref);
> +			}
> +		}
> =20
>  		/* Copy the new values back to userspace. */
>  		if (!ret) {
> @@ -3429,6 +3600,148 @@ int __v4l2_ctrl_s_ctrl_string(struct v4l2_ctrl
> *ctrl, const char *s)
>  }
>  EXPORT_SYMBOL(__v4l2_ctrl_s_ctrl_string);
> =20
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
> +	obj =3D media_request_object_find(req, &req_ops, main_hdl);
> +	if (!obj)
> +		return;
> +	hdl =3D container_of(obj, struct v4l2_ctrl_handler, req_obj);
> +
> +	list_for_each_entry(ref, &hdl->ctrl_refs, node) {
> +		struct v4l2_ctrl *ctrl =3D ref->ctrl;
> +		struct v4l2_ctrl *master =3D ctrl->cluster[0];
> +		unsigned int i;
> +
> +		if (ctrl->flags & V4L2_CTRL_FLAG_VOLATILE) {
> +			ref->req =3D ref;
> +
> +			v4l2_ctrl_lock(master);
> +			/* g_volatile_ctrl will update the current
> control values */
> +			for (i =3D 0; i < master->ncontrols; i++)
> +				cur_to_new(master->cluster[i]);
> +			call_op(master, g_volatile_ctrl);
> +			new_to_req(ref);
> +			v4l2_ctrl_unlock(master);
> +			continue;
> +		}
> +		if (ref->req =3D=3D ref)
> +			continue;
> +
> +		v4l2_ctrl_lock(ctrl);
> +		if (ref->req)
> +			ptr_to_ptr(ctrl, ref->req->p_req, ref-
> >p_req);
> +		else
> +			ptr_to_ptr(ctrl, ctrl->p_cur, ref->p_req);
> +		v4l2_ctrl_unlock(ctrl);
> +	}
> +
> +	WARN_ON(!hdl->request_is_queued);
> +	list_del_init(&hdl->requests_queued);
> +	hdl->request_is_queued =3D false;
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
> +	obj =3D media_request_object_find(req, &req_ops, main_hdl);
> +	if (!obj)
> +		return;
> +	if (obj->completed) {
> +		media_request_object_put(obj);
> +		return;
> +	}
> +	hdl =3D container_of(obj, struct v4l2_ctrl_handler, req_obj);
> +
> +	mutex_lock(hdl->lock);
> +
> +	list_for_each_entry(ref, &hdl->ctrl_refs, node)
> +		ref->done =3D false;
> +
> +	list_for_each_entry(ref, &hdl->ctrl_refs, node) {
> +		struct v4l2_ctrl *ctrl =3D ref->ctrl;
> +		struct v4l2_ctrl *master =3D ctrl->cluster[0];
> +		bool have_new_data =3D false;
> +		int i;
> +
> +		/* Skip if this control was already handled by a
> cluster. */
> +		/* Skip button controls and read-only controls. */
> +		if (ref->done || ctrl->type =3D=3D V4L2_CTRL_TYPE_BUTTON
> ||
> +		    (ctrl->flags & V4L2_CTRL_FLAG_READ_ONLY))
> +			continue;
> +
> +		v4l2_ctrl_lock(master);
> +		for (i =3D 0; i < master->ncontrols; i++) {
> +			if (master->cluster[i]) {
> +				struct v4l2_ctrl_ref *r =3D
> +					find_ref(hdl, master-
> >cluster[i]->id);
> +
> +				if (r->req && r =3D=3D r->req) {
> +					have_new_data =3D true;
> +					break;
> +				}
> +			}
> +		}
> +		if (!have_new_data)

The v4l2 control lock has not been unlocked here, so a call to
v4l2_ctrl_unlock is required before continue.

> +			continue;
> +
> +		for (i =3D 0; i < master->ncontrols; i++) {
> +			if (master->cluster[i]) {
> +				struct v4l2_ctrl_ref *r =3D
> +					find_ref(hdl, master-
> >cluster[i]->id);
> +
> +				req_to_new(r);
> +				master->cluster[i]->is_new =3D 1;
> +				r->done =3D true;
> +			}
> +		}
> +		/*
> +		 * For volatile autoclusters that are currently in
> auto mode
> +		 * we need to discover if it will be set to manual
> mode.
> +		 * If so, then we have to copy the current volatile
> values
> +		 * first since those will become the new manual
> values (which
> +		 * may be overwritten by explicit new values from
> this set
> +		 * of controls).
> +		 */
> +		if (master->is_auto && master->has_volatiles &&
> +		    !is_cur_manual(master)) {
> +			s32 new_auto_val =3D *master->p_new.p_s32;
> +
> +			/*
> +			 * If the new value =3D=3D the manual value, then
> copy
> +			 * the current volatile values.
> +			 */
> +			if (new_auto_val =3D=3D master-
> >manual_mode_value)
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
>  void v4l2_ctrl_notify(struct v4l2_ctrl *ctrl, v4l2_ctrl_notify_fnc
> notify, void *priv)
>  {
>  	if (ctrl =3D=3D NULL)
> diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
> index 89a985607126..9499846aa1d1 100644
> --- a/include/media/v4l2-ctrls.h
> +++ b/include/media/v4l2-ctrls.h
> @@ -250,6 +250,10 @@ struct v4l2_ctrl {
>   *		``prepare_ext_ctrls`` function at ``v4l2-ctrl.c``.
>   * @from_other_dev: If true, then @ctrl was defined in another
>   *		device then the &struct v4l2_ctrl_handler.
> + * @done:	If true, then this control reference is part of a
> + *		control cluster that was already set while applying
> + *		the controls in this media request object.
> + * @req:	If set, this refers to another request that sets this
> control.
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
> =20
> @@ -287,6 +293,15 @@ struct v4l2_ctrl_ref {
>   * @notify_priv: Passed as argument to the v4l2_ctrl notify callback.
>   * @nr_of_buckets: Total number of buckets in the array.
>   * @error:	The error code of the first failed control
> addition.
> + * @request_is_queued: True if the request was queued.
> + * @requests:	List to keep track of open control handler
> request objects.
> + *		For the parent control handler (@req_obj.req =3D=3D
> NULL) this
> + *		is the list header. When the parent control handler
> is
> + *		removed, it has to unbind and put all these
> requests since
> + *		they refer to the parent.
> + * @requests_queued: List of the queued requests. This determines the
> order
> + *		in which these controls are applied. Once the
> request is
> + *		completed it is removed from this list.
>   * @req_obj:	The &struct media_request_object, used to link
> into a
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
> =20
> @@ -1059,6 +1077,11 @@ int v4l2_ctrl_subscribe_event(struct v4l2_fh
> *fh,
>   */
>  __poll_t v4l2_ctrl_poll(struct file *file, struct poll_table_struct
> *wait);
> =20
> +void v4l2_ctrl_request_setup(struct media_request *req,
> +			     struct v4l2_ctrl_handler *hdl);
> +void v4l2_ctrl_request_complete(struct media_request *req,
> +				struct v4l2_ctrl_handler *hdl);
> +
>  /* Helpers for ioctl_ops */
> =20
>  /**
--=20
Paul Kocialkowski, Bootlin (formerly Free Electrons)
Embedded Linux and kernel engineering
https://bootlin.com
--=-R57eZo9AzNLA3mStqevy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEJZpWjZeIetVBefti3cLmz3+fv9EFAlrNyWcACgkQ3cLmz3+f
v9H98wf/dLQ6ztPi8olN9d66I0Dt6LkZ9XCz+gIoKXtPSC6Dl+OUeFtZNqYXW5Tz
L3+bSDwGHiKw+N+XfmWGx5xPQFXwOmFgxwtNjqTmscuXPZAnD0OohUCRYpQb5KtW
/ZuCNaNCljfYq22NXQQdPFHrFqAVxYncheIhx62+Z0Uom7zdOsMsRc9L5h0ET0un
/UBA+ZwnacyzzqY8rOUonhs/ewoFgAoBo9zcKT1ORp3kOWbKHXC3DWqioZS4BXWx
OskQS5E8p743Hxb1QHiRt0NT++j/o4yScyYkH4TURKziV0P4Ra5D6kkLZ7ELUfZZ
zcHkvAGY04Dh07ITNyqx5UaU+ihLjg==
=XUtV
-----END PGP SIGNATURE-----

--=-R57eZo9AzNLA3mStqevy--
