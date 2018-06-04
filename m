Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:37208 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750999AbeFDRSy (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 4 Jun 2018 13:18:54 -0400
Received: by mail-pg0-f66.google.com with SMTP id a13-v6so14726101pgu.4
        for <linux-media@vger.kernel.org>; Mon, 04 Jun 2018 10:18:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180604114648.26159-14-hverkuil@xs4all.nl>
References: <20180604114648.26159-1-hverkuil@xs4all.nl> <20180604114648.26159-14-hverkuil@xs4all.nl>
From: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Date: Mon, 4 Jun 2018 14:18:53 -0300
Message-ID: <CAAEAJfDSeAmGssBpnu6RUH8nq4PPCSUU2nQND-UXFpgLoWWEtw@mail.gmail.com>
Subject: Re: [PATCHv15 13/35] v4l2-ctrls: add core request support
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media <linux-media@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 4 June 2018 at 08:46, Hans Verkuil <hverkuil@xs4all.nl> wrote:
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
> this is sub-optimal when dealing with large compound and/or array control=
s.
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
> diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-co=
re/v4l2-ctrls.c
> index da4cc1485dc4..bd4818507486 100644
> --- a/drivers/media/v4l2-core/v4l2-ctrls.c
> +++ b/drivers/media/v4l2-core/v4l2-ctrls.c
> @@ -1647,6 +1647,13 @@ static int new_to_user(struct v4l2_ext_control *c,
>         return ptr_to_user(c, ctrl, ctrl->p_new);
>  }
>
> +/* Helper function: copy the request value back to the caller */
> +static int req_to_user(struct v4l2_ext_control *c,
> +                      struct v4l2_ctrl_ref *ref)
> +{
> +       return ptr_to_user(c, ref->ctrl, ref->p_req);
> +}
> +
>  /* Helper function: copy the initial control value back to the caller */
>  static int def_to_user(struct v4l2_ext_control *c, struct v4l2_ctrl *ctr=
l)
>  {
> @@ -1766,6 +1773,26 @@ static void cur_to_new(struct v4l2_ctrl *ctrl)
>         ptr_to_ptr(ctrl, ctrl->p_cur, ctrl->p_new);
>  }
>
> +/* Copy the new value to the request value */
> +static void new_to_req(struct v4l2_ctrl_ref *ref)
> +{
> +       if (!ref)
> +               return;
> +       ptr_to_ptr(ref->ctrl, ref->ctrl->p_new, ref->p_req);
> +       ref->req =3D ref;
> +}
> +
> +/* Copy the request value to the new value */
> +static void req_to_new(struct v4l2_ctrl_ref *ref)
> +{
> +       if (!ref)
> +               return;
> +       if (ref->req)
> +               ptr_to_ptr(ref->ctrl, ref->req->p_req, ref->ctrl->p_new);
> +       else
> +               ptr_to_ptr(ref->ctrl, ref->ctrl->p_cur, ref->ctrl->p_new)=
;
> +}
> +
>  /* Return non-zero if one or more of the controls in the cluster has a n=
ew
>     value that differs from the current value. */
>  static int cluster_changed(struct v4l2_ctrl *master)
> @@ -1875,6 +1902,9 @@ int v4l2_ctrl_handler_init_class(struct v4l2_ctrl_h=
andler *hdl,
>         lockdep_set_class_and_name(hdl->lock, key, name);
>         INIT_LIST_HEAD(&hdl->ctrls);
>         INIT_LIST_HEAD(&hdl->ctrl_refs);
> +       INIT_LIST_HEAD(&hdl->requests);
> +       INIT_LIST_HEAD(&hdl->requests_queued);
> +       hdl->request_is_queued =3D false;
>         hdl->nr_of_buckets =3D 1 + nr_of_controls_hint / 8;
>         hdl->buckets =3D kvmalloc_array(hdl->nr_of_buckets,
>                                       sizeof(hdl->buckets[0]),
> @@ -1895,6 +1925,14 @@ void v4l2_ctrl_handler_free(struct v4l2_ctrl_handl=
er *hdl)
>         if (hdl =3D=3D NULL || hdl->buckets =3D=3D NULL)
>                 return;
>
> +       if (!hdl->req_obj.req && !list_empty(&hdl->requests)) {
> +               struct v4l2_ctrl_handler *req, *next_req;
> +
> +               list_for_each_entry_safe(req, next_req, &hdl->requests, r=
equests) {
> +                       media_request_object_unbind(&req->req_obj);
> +                       media_request_object_put(&req->req_obj);
> +               }
> +       }
>         mutex_lock(hdl->lock);
>         /* Free all nodes */
>         list_for_each_entry_safe(ref, next_ref, &hdl->ctrl_refs, node) {
> @@ -2816,6 +2854,128 @@ int v4l2_querymenu(struct v4l2_ctrl_handler *hdl,=
 struct v4l2_querymenu *qm)
>  }
>  EXPORT_SYMBOL(v4l2_querymenu);
>
> +static int v4l2_ctrl_request_clone(struct v4l2_ctrl_handler *hdl,
> +                                  const struct v4l2_ctrl_handler *from)
> +{
> +       struct v4l2_ctrl_ref *ref;
> +       int err;
> +
> +       if (WARN_ON(!hdl || hdl =3D=3D from))
> +               return -EINVAL;
> +
> +       if (hdl->error)
> +               return hdl->error;
> +
> +       WARN_ON(hdl->lock !=3D &hdl->_lock);
> +
> +       mutex_lock(from->lock);
> +       list_for_each_entry(ref, &from->ctrl_refs, node) {
> +               struct v4l2_ctrl *ctrl =3D ref->ctrl;
> +               struct v4l2_ctrl_ref *new_ref;
> +
> +               /* Skip refs inherited from other devices */
> +               if (ref->from_other_dev)
> +                       continue;
> +               /* And buttons */
> +               if (ctrl->type =3D=3D V4L2_CTRL_TYPE_BUTTON)
> +                       continue;
> +               err =3D handler_new_ref(hdl, ctrl, &new_ref, false, true)=
;
> +               if (err) {
> +                       printk("%s: handler_new_ref on control %x (%s) re=
turned %d\n", __func__, ctrl->id, ctrl->name, err);

Nit: pr_err + pr_fmt above?
--=20
Ezequiel Garc=C3=ADa, VanguardiaSur
www.vanguardiasur.com.ar
