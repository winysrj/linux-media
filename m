Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:1361 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754389Ab1J3LYt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Oct 2011 07:24:49 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH 6/6] v4l2-ctrls: Use v4l2_subscribed_event_ops
Date: Sun, 30 Oct 2011 12:24:43 +0100
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
References: <1319714283-3991-1-git-send-email-hdegoede@redhat.com> <1319714283-3991-7-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1319714283-3991-7-git-send-email-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201110301224.43348.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday, October 27, 2011 13:18:03 Hans de Goede wrote:
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

> ---
>  drivers/media/video/ivtv/ivtv-ioctl.c |    3 +-
>  drivers/media/video/pwc/pwc-v4l.c     |    2 +-
>  drivers/media/video/v4l2-ctrls.c      |   56 +++++++++++++++++++++++++++------
>  drivers/media/video/v4l2-event.c      |   39 -----------------------
>  drivers/media/video/vivi.c            |    2 +-
>  include/media/v4l2-ctrls.h            |    7 ++--
>  6 files changed, 53 insertions(+), 56 deletions(-)
> 
> diff --git a/drivers/media/video/ivtv/ivtv-ioctl.c b/drivers/media/video/ivtv/ivtv-ioctl.c
> index 9aec8a0..72fd74f 100644
> --- a/drivers/media/video/ivtv/ivtv-ioctl.c
> +++ b/drivers/media/video/ivtv/ivtv-ioctl.c
> @@ -1455,8 +1455,9 @@ static int ivtv_subscribe_event(struct v4l2_fh *fh, struct v4l2_event_subscripti
>  	switch (sub->type) {
>  	case V4L2_EVENT_VSYNC:
>  	case V4L2_EVENT_EOS:
> -	case V4L2_EVENT_CTRL:
>  		return v4l2_event_subscribe(fh, sub, 0, NULL);
> +	case V4L2_EVENT_CTRL:
> +		return v4l2_event_subscribe(fh, sub, 0, &v4l2_ctrl_sub_ev_ops);
>  	default:
>  		return -EINVAL;
>  	}
> diff --git a/drivers/media/video/pwc/pwc-v4l.c b/drivers/media/video/pwc/pwc-v4l.c
> index 7f159bf..afc5b15 100644
> --- a/drivers/media/video/pwc/pwc-v4l.c
> +++ b/drivers/media/video/pwc/pwc-v4l.c
> @@ -1138,7 +1138,7 @@ static int pwc_subscribe_event(struct v4l2_fh *fh,
>  {
>  	switch (sub->type) {
>  	case V4L2_EVENT_CTRL:
> -		return v4l2_event_subscribe(fh, sub, 0, NULL);
> +		return v4l2_event_subscribe(fh, sub, 0, &v4l2_ctrl_sub_ev_ops);
>  	default:
>  		return -EINVAL;
>  	}
> diff --git a/drivers/media/video/v4l2-ctrls.c b/drivers/media/video/v4l2-ctrls.c
> index 69e24f4..c4dec20 100644
> --- a/drivers/media/video/v4l2-ctrls.c
> +++ b/drivers/media/video/v4l2-ctrls.c
> @@ -2329,10 +2329,22 @@ int v4l2_ctrl_s_ctrl(struct v4l2_ctrl *ctrl, s32 val)
>  }
>  EXPORT_SYMBOL(v4l2_ctrl_s_ctrl);
>  
> -void v4l2_ctrl_add_event(struct v4l2_ctrl *ctrl,
> -				struct v4l2_subscribed_event *sev)
> +static int v4l2_ctrl_add_event(struct v4l2_subscribed_event *sev)
>  {
> -	v4l2_ctrl_lock(ctrl);
> +	struct v4l2_ctrl_handler *hdl = sev->fh->ctrl_handler;
> +	struct v4l2_ctrl_ref *ref;
> +	struct v4l2_ctrl *ctrl;
> +	int ret = 0;
> +
> +	mutex_lock(&hdl->lock);
> +
> +	ref = find_ref(hdl, sev->id);
> +	if (!ref) {
> +		ret = -EINVAL;
> +		goto leave;
> +	}
> +	ctrl = ref->ctrl;
> +
>  	list_add_tail(&sev->node, &ctrl->ev_subs);
>  	if (ctrl->type != V4L2_CTRL_TYPE_CTRL_CLASS &&
>  	    (sev->flags & V4L2_EVENT_SUB_FL_SEND_INITIAL)) {
> @@ -2344,15 +2356,39 @@ void v4l2_ctrl_add_event(struct v4l2_ctrl *ctrl,
>  		fill_event(&ev, ctrl, changes);
>  		v4l2_event_queue_fh(sev->fh, &ev);
>  	}
> -	v4l2_ctrl_unlock(ctrl);
> +leave:
> +	mutex_unlock(&hdl->lock);
> +	return ret;
>  }
> -EXPORT_SYMBOL(v4l2_ctrl_add_event);
>  
> -void v4l2_ctrl_del_event(struct v4l2_ctrl *ctrl,
> -				struct v4l2_subscribed_event *sev)
> +static void v4l2_ctrl_del_event(struct v4l2_subscribed_event *sev)
>  {
> -	v4l2_ctrl_lock(ctrl);
> +	struct v4l2_ctrl_handler *hdl = sev->fh->ctrl_handler;
> +
> +	mutex_lock(&hdl->lock);
>  	list_del(&sev->node);
> -	v4l2_ctrl_unlock(ctrl);
> +	mutex_unlock(&hdl->lock);
>  }
> -EXPORT_SYMBOL(v4l2_ctrl_del_event);
> +
> +void v4l2_ctrl_replace(struct v4l2_event *old, const struct v4l2_event *new)
> +{
> +	u32 old_changes = old->u.ctrl.changes;
> +
> +	old->u.ctrl = new->u.ctrl;
> +	old->u.ctrl.changes |= old_changes;
> +}
> +EXPORT_SYMBOL(v4l2_ctrl_replace);
> +
> +void v4l2_ctrl_merge(const struct v4l2_event *old, struct v4l2_event *new)
> +{
> +	new->u.ctrl.changes |= old->u.ctrl.changes;
> +}
> +EXPORT_SYMBOL(v4l2_ctrl_merge);
> +
> +const struct v4l2_subscribed_event_ops v4l2_ctrl_sub_ev_ops = {
> +	.add = v4l2_ctrl_add_event,
> +	.del = v4l2_ctrl_del_event,
> +	.replace = v4l2_ctrl_replace,
> +	.merge = v4l2_ctrl_merge,
> +};
> +EXPORT_SYMBOL(v4l2_ctrl_sub_ev_ops);
> diff --git a/drivers/media/video/v4l2-event.c b/drivers/media/video/v4l2-event.c
> index 2dd9252..2f5ee7b 100644
> --- a/drivers/media/video/v4l2-event.c
> +++ b/drivers/media/video/v4l2-event.c
> @@ -25,7 +25,6 @@
>  #include <media/v4l2-dev.h>
>  #include <media/v4l2-fh.h>
>  #include <media/v4l2-event.h>
> -#include <media/v4l2-ctrls.h>
>  
>  #include <linux/sched.h>
>  #include <linux/slab.h>
> @@ -194,30 +193,11 @@ int v4l2_event_pending(struct v4l2_fh *fh)
>  }
>  EXPORT_SYMBOL_GPL(v4l2_event_pending);
>  
> -static void ctrls_replace(struct v4l2_event *old, const struct v4l2_event *new)
> -{
> -	u32 old_changes = old->u.ctrl.changes;
> -
> -	old->u.ctrl = new->u.ctrl;
> -	old->u.ctrl.changes |= old_changes;
> -}
> -
> -static void ctrls_merge(const struct v4l2_event *old, struct v4l2_event *new)
> -{
> -	new->u.ctrl.changes |= old->u.ctrl.changes;
> -}
> -
> -const struct v4l2_subscribed_event_ops ctrl_ops = {
> -	.replace = ctrls_replace,
> -	.merge = ctrls_merge,
> -};
> -
>  int v4l2_event_subscribe(struct v4l2_fh *fh,
>  			 struct v4l2_event_subscription *sub, unsigned elems,
>  			 const struct v4l2_subscribed_event_ops *ops)
>  {
>  	struct v4l2_subscribed_event *sev, *found_ev;
> -	struct v4l2_ctrl *ctrl = NULL;
>  	unsigned long flags;
>  	unsigned i;
>  
> @@ -226,11 +206,6 @@ int v4l2_event_subscribe(struct v4l2_fh *fh,
>  
>  	if (elems < 1)
>  		elems = 1;
> -	if (sub->type == V4L2_EVENT_CTRL) {
> -		ctrl = v4l2_ctrl_find(fh->ctrl_handler, sub->id);
> -		if (ctrl == NULL)
> -			return -EINVAL;
> -	}
>  
>  	sev = kzalloc(sizeof(*sev) + sizeof(struct v4l2_kevent) * elems, GFP_KERNEL);
>  	if (!sev)
> @@ -243,9 +218,6 @@ int v4l2_event_subscribe(struct v4l2_fh *fh,
>  	sev->fh = fh;
>  	sev->elems = elems;
>  	sev->ops = ops;
> -	if (ctrl) {
> -		sev->ops = &ctrl_ops;
> -	}
>  
>  	spin_lock_irqsave(&fh->vdev->fh_lock, flags);
>  	found_ev = v4l2_event_subscribed(fh, sub->type, sub->id);
> @@ -267,10 +239,6 @@ int v4l2_event_subscribe(struct v4l2_fh *fh,
>  		}
>  	}
>  
> -	/* v4l2_ctrl_add_event uses a mutex, so do this outside the spin lock */
> -	if (ctrl)
> -		v4l2_ctrl_add_event(ctrl, sev);
> -
>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(v4l2_event_subscribe);
> @@ -329,13 +297,6 @@ int v4l2_event_unsubscribe(struct v4l2_fh *fh,
>  	if (sev && sev->ops && sev->ops->del)
>  		sev->ops->del(sev);
>  
> -	if (sev && sev->type == V4L2_EVENT_CTRL) {
> -		struct v4l2_ctrl *ctrl = v4l2_ctrl_find(fh->ctrl_handler, sev->id);
> -
> -		if (ctrl)
> -			v4l2_ctrl_del_event(ctrl, sev);
> -	}
> -
>  	kfree(sev);
>  
>  	return 0;
> diff --git a/drivers/media/video/vivi.c b/drivers/media/video/vivi.c
> index 74ebbad..ce1783d 100644
> --- a/drivers/media/video/vivi.c
> +++ b/drivers/media/video/vivi.c
> @@ -1013,7 +1013,7 @@ static int vidioc_subscribe_event(struct v4l2_fh *fh,
>  {
>  	switch (sub->type) {
>  	case V4L2_EVENT_CTRL:
> -		return v4l2_event_subscribe(fh, sub, 0, NULL);
> +		return v4l2_event_subscribe(fh, sub, 0, &v4l2_ctrl_sub_ev_ops);
>  	default:
>  		return -EINVAL;
>  	}
> diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
> index eeb3df6..fde17ff 100644
> --- a/include/media/v4l2-ctrls.h
> +++ b/include/media/v4l2-ctrls.h
> @@ -487,10 +487,9 @@ s32 v4l2_ctrl_g_ctrl(struct v4l2_ctrl *ctrl);
>  int v4l2_ctrl_s_ctrl(struct v4l2_ctrl *ctrl, s32 val);
>  
>  /* Internal helper functions that deal with control events. */
> -void v4l2_ctrl_add_event(struct v4l2_ctrl *ctrl,
> -		struct v4l2_subscribed_event *sev);
> -void v4l2_ctrl_del_event(struct v4l2_ctrl *ctrl,
> -		struct v4l2_subscribed_event *sev);
> +extern const struct v4l2_subscribed_event_ops v4l2_ctrl_sub_ev_ops;
> +void v4l2_ctrl_replace(struct v4l2_event *old, const struct v4l2_event *new);
> +void v4l2_ctrl_merge(const struct v4l2_event *old, struct v4l2_event *new);
>  
>  /* Helpers for ioctl_ops. If hdl == NULL then they will all return -EINVAL. */
>  int v4l2_queryctrl(struct v4l2_ctrl_handler *hdl, struct v4l2_queryctrl *qc);
> 
