Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ua0-f179.google.com ([209.85.217.179]:41378 "EHLO
        mail-ua0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751876AbeDKJnt (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Apr 2018 05:43:49 -0400
Received: by mail-ua0-f179.google.com with SMTP id t9so728117uac.8
        for <linux-media@vger.kernel.org>; Wed, 11 Apr 2018 02:43:49 -0700 (PDT)
MIME-Version: 1.0
References: <20180409142026.19369-1-hverkuil@xs4all.nl> <20180409142026.19369-15-hverkuil@xs4all.nl>
In-Reply-To: <20180409142026.19369-15-hverkuil@xs4all.nl>
From: Tomasz Figa <tfiga@google.com>
Date: Wed, 11 Apr 2018 09:43:37 +0000
Message-ID: <CAAFQd5BP7jZVsVC_2ar1wq6iPyHQZ_j-5Lqn+jZotEqhaP-2jQ@mail.gmail.com>
Subject: Re: [RFCv11 PATCH 14/29] v4l2-ctrls: add core request support
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Mon, Apr 9, 2018 at 11:20 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:

> From: Hans Verkuil <hans.verkuil@cisco.com>

> Integrate the request support. This adds the v4l2_ctrl_request_complete
> and v4l2_ctrl_request_setup functions to complete a request and (as a
> helper function) to apply a request to the hardware.

Please see my comments inline.

[snip]
> +static int v4l2_ctrl_request_clone(struct v4l2_ctrl_handler *hdl,
> +                                  const struct v4l2_ctrl_handler *from)
> +{
> +       struct v4l2_ctrl_ref *ref;
> +       int err;
> +
> +       if (WARN_ON(!hdl || hdl == from))
> +               return -EINVAL;
> +
> +       if (hdl->error)
> +               return hdl->error;
> +
> +       WARN_ON(hdl->lock != &hdl->_lock);
> +
> +       mutex_lock(from->lock);
> +       list_for_each_entry(ref, &from->ctrl_refs, node) {
> +               struct v4l2_ctrl *ctrl = ref->ctrl;
> +               struct v4l2_ctrl_ref *new_ref;
> +
> +               /* Skip refs inherited from other devices */
> +               if (ref->from_other_dev)
> +                       continue;
> +               /* And buttons */
> +               if (ctrl->type == V4L2_CTRL_TYPE_BUTTON)
> +                       continue;
> +               err = handler_new_ref(hdl, ctrl, &new_ref, false, true);
> +               if (err) {
> +                       printk("%s: handler_new_ref on control %x (%s)
returned %d\n", __func__, ctrl->id, ctrl->name, err);

Perhaps pr_err()?

> +                       err = 0;
> +                       continue;

Hmm, is it really fine to ignore the error and continue here?

> +               }
> +               if (err)
> +                       break;
> +       }
> +       mutex_unlock(from->lock);
> +       return err;
> +}
> +
> +static void v4l2_ctrl_request_queue(struct media_request_object *obj)
> +{
> +       struct v4l2_ctrl_handler *hdl =
> +               container_of(obj, struct v4l2_ctrl_handler, req_obj);
> +       struct v4l2_ctrl_handler *main_hdl = obj->priv;
> +       struct v4l2_ctrl_handler *prev = NULL;
> +       struct v4l2_ctrl_ref *ref_hdl, *ref_prev = NULL;
> +
> +       if (list_empty(&main_hdl->requests_queued))
> +               goto queue;
> +
> +       prev = list_last_entry(&main_hdl->requests_queued,
> +                              struct v4l2_ctrl_handler, requests_queued);
> +       mutex_lock(prev->lock);
> +       ref_prev = list_first_entry(&prev->ctrl_refs,
> +                                   struct v4l2_ctrl_ref, node);
> +       list_for_each_entry(ref_hdl, &hdl->ctrl_refs, node) {
> +               if (ref_hdl->req)
> +                       continue;
> +               while (ref_prev->ctrl->id < ref_hdl->ctrl->id)
> +                       ref_prev = list_next_entry(ref_prev, node);

Is this really safe? The only stop condition here is the control id.
Perhaps the code below could be better?

list_for_each_entry_from(ref_prev, &prev->ctrl_refs, node)
         if (ref_prev->ctrl->id >= ref_hdl->ctrl->id)
                 break;

> +               if (WARN_ON(ref_prev->ctrl->id != ref_hdl->ctrl->id))
> +                       break;
> +               ref_hdl->req = ref_prev->req;
> +       }
> +       mutex_unlock(prev->lock);
> +queue:
> +       list_add_tail(&hdl->requests_queued, &main_hdl->requests_queued);
> +       hdl->request_is_queued = true;
> +}
> +

[snip]
> +void v4l2_ctrl_request_complete(struct media_request *req,
> +                               struct v4l2_ctrl_handler *main_hdl)
> +{
> +       struct media_request_object *obj;
> +       struct v4l2_ctrl_handler *hdl;
> +       struct v4l2_ctrl_ref *ref;
> +
> +       if (!req || !main_hdl)
> +               return;

Can this happen normally? Perhaps WARN_ON() would make sense?

[snip]
> +void v4l2_ctrl_request_setup(struct media_request *req,
> +                            struct v4l2_ctrl_handler *main_hdl)
> +{
> +       struct media_request_object *obj;
> +       struct v4l2_ctrl_handler *hdl;
> +       struct v4l2_ctrl_ref *ref;
> +
> +       if (!req || !main_hdl)

Can this happen normally? Perhaps WARN_ON() would make sense?

> +               return;
> +
> +       obj = media_request_object_find(req, &req_ops, main_hdl);
> +       if (!obj)
> +               return;
> +       if (obj->completed) {
> +               media_request_object_put(obj);
> +               return;
> +       }
> +       hdl = container_of(obj, struct v4l2_ctrl_handler, req_obj);
> +
> +       mutex_lock(hdl->lock);
> +
> +       list_for_each_entry(ref, &hdl->ctrl_refs, node)
> +               ref->done = false;
> +
> +       list_for_each_entry(ref, &hdl->ctrl_refs, node) {
> +               struct v4l2_ctrl *ctrl = ref->ctrl;
> +               struct v4l2_ctrl *master = ctrl->cluster[0];
> +               bool have_new_data = false;
> +               int i;
> +
> +               /* Skip if this control was already handled by a cluster.
*/
> +               /* Skip button controls and read-only controls. */
> +               if (ref->done || ctrl->type == V4L2_CTRL_TYPE_BUTTON ||
> +                   (ctrl->flags & V4L2_CTRL_FLAG_READ_ONLY))
> +                       continue;
> +
> +               v4l2_ctrl_lock(master);
> +               for (i = 0; i < master->ncontrols; i++) {
> +                       if (master->cluster[i]) {
> +                               struct v4l2_ctrl_ref *r =
> +                                       find_ref(hdl,
master->cluster[i]->id);
> +
> +                               if (r->req && r == r->req) {
> +                                       have_new_data = true;
> +                                       break;
> +                               }
> +                       }
> +               }
> +               if (!have_new_data)
> +                       continue;

No need to call v4l2_ctrl_unlock() here?

[snip]
> @@ -263,6 +267,8 @@ struct v4l2_ctrl_ref {
>          struct v4l2_ctrl *ctrl;
>          struct v4l2_ctrl_helper *helper;
>          bool from_other_dev;
> +       bool done;
> +       struct v4l2_ctrl_ref *req;

Perhaps it could make sense to call this ref_req, which would use the same
convention as p_req below?

>          union v4l2_ctrl_ptr p_req;
>   };

Best regards,
Tomasz
