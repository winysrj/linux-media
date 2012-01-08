Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:59095 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754552Ab2AHV6X (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 8 Jan 2012 16:58:23 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH 2/2] uvcvideo: Add support for control events
Date: Sun, 8 Jan 2012 22:58:45 +0100
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	hverkuil@xs4all.nl
References: <1319714392-4406-1-git-send-email-hdegoede@redhat.com> <1319714392-4406-3-git-send-email-hdegoede@redhat.com>
In-Reply-To: <1319714392-4406-3-git-send-email-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201201082258.46464.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for the patch (and sorry for the very late reply).

On Thursday 27 October 2011 13:19:52 Hans de Goede wrote:
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---
>  drivers/media/video/uvc/uvc_ctrl.c |  104 +++++++++++++++++++++++++++++++++
>  drivers/media/video/uvc/uvc_v4l2.c |   51 ++++++++++++++++-
>  drivers/media/video/uvc/uvcvideo.h |    9 +++
>  3 files changed, 161 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/video/uvc/uvc_ctrl.c
> b/drivers/media/video/uvc/uvc_ctrl.c index 1a2c1a3..b9486e5 100644
> --- a/drivers/media/video/uvc/uvc_ctrl.c
> +++ b/drivers/media/video/uvc/uvc_ctrl.c
> @@ -21,6 +21,7 @@
>  #include <linux/vmalloc.h>
>  #include <linux/wait.h>
>  #include <linux/atomic.h>
> +#include <media/v4l2-ctrls.h>
> 
>  #include "uvcvideo.h"
> 
> @@ -1308,6 +1309,107 @@ int uvc_ctrl_set(struct uvc_video_chain *chain,
>  }
> 
>  /*
> --------------------------------------------------------------------------
> + * Ctrl event handling
> + */
> +
> +static void uvc_ctrl_fill_event(struct uvc_video_chain *chain,
> +	struct v4l2_event *ev,
> +	struct uvc_control *ctrl,
> +	struct uvc_control_mapping *mapping,
> +	u32 value, u32 changes)
> +{
> +	struct v4l2_queryctrl v4l2_ctrl;
> +
> +	__uvc_query_v4l2_ctrl(chain, ctrl, mapping, &v4l2_ctrl);
> +
> +	memset(ev->reserved, 0, sizeof(ev->reserved));
> +	ev->type = V4L2_EVENT_CTRL;
> +	ev->id = v4l2_ctrl.id;
> +	ev->u.ctrl.value = value;
> +	ev->u.ctrl.changes = changes;
> +	ev->u.ctrl.type = v4l2_ctrl.type;
> +	ev->u.ctrl.flags = v4l2_ctrl.flags;
> +	ev->u.ctrl.minimum = v4l2_ctrl.minimum;
> +	ev->u.ctrl.maximum = v4l2_ctrl.maximum;
> +	ev->u.ctrl.step = v4l2_ctrl.step;
> +	ev->u.ctrl.default_value = v4l2_ctrl.default_value;
> +}
> +
> +void uvc_ctrl_send_event(struct uvc_fh *handle,
> +	struct v4l2_ext_control *xctrl)
> +{
> +	struct v4l2_event ev;
> +	struct v4l2_subscribed_event *sev;
> +	struct uvc_control *ctrl;
> +	struct uvc_control_mapping *mapping;
> +
> +	ctrl = uvc_find_control(handle->chain, xctrl->id, &mapping);
> +

I suppose that ctrl can't be NULL here, otherwise this function wouldn't have 
been called in the first place, right ?

> +	if (list_empty(&mapping->ev_subs))
> +		return;
> +
> +	uvc_ctrl_fill_event(handle->chain, &ev, ctrl, mapping, xctrl->value,
> +			    V4L2_EVENT_CTRL_CH_VALUE);
> +
> +	list_for_each_entry(sev, &mapping->ev_subs, node)
> +		if (sev->fh && (sev->fh != &handle->vfh ||
> +			     (sev->flags & V4L2_EVENT_SUB_FL_ALLOW_FEEDBACK)))

Please align (sev with sev on the line above.

> +			v4l2_event_queue_fh(sev->fh, &ev);

Shouldn't you protect ev_subs with a lock ? You could reuse chain->ctrl_mutex 
if you called uvc_ctrl_send_event() in __uvc_ctrl_commit(). You would then 
need to pass a pointer to the v4l2_ext_control array and the number of 
controls to __uvc_ctrl_commit().

> +}
> +
> +static int uvc_ctrl_add_event(struct v4l2_subscribed_event *sev)
> +{
> +	struct uvc_fh *handle = container_of(sev->fh, struct uvc_fh, vfh);
> +	struct uvc_control *ctrl;
> +	struct uvc_control_mapping *mapping;

Could you please order variable declarations by line lengths (approximately) 
like in the rest of the driver ?

> +	int ret;
> +
> +	ret = mutex_lock_interruptible(&handle->chain->ctrl_mutex);
> +	if (ret < 0)
> +		return -ERESTARTSYS;
> +
> +	ctrl = uvc_find_control(handle->chain, sev->id, &mapping);
> +	if (ctrl == NULL) {
> +		ret = -EINVAL;
> +		goto done;
> +	}
> +
> +	list_add_tail(&sev->node, &mapping->ev_subs);
> +	if (sev->flags & V4L2_EVENT_SUB_FL_SEND_INITIAL) {
> +		struct v4l2_event ev;
> +		struct v4l2_ext_control xctrl = { .value = 0 };
> +		u32 changes = V4L2_EVENT_CTRL_CH_FLAGS;
> +
> +		if (__uvc_ctrl_get(handle->chain, ctrl, mapping, &xctrl) == 0)
> +			changes |= V4L2_EVENT_CTRL_CH_VALUE;
> +
> +		uvc_ctrl_fill_event(handle->chain, &ev, ctrl, mapping,
> +				    xctrl.value, changes);
> +		v4l2_event_queue_fh(sev->fh, &ev);
> +	}
> +
> +done:
> +	mutex_unlock(&handle->chain->ctrl_mutex);
> +	return ret;
> +}
> +
> +static void uvc_ctrl_del_event(struct v4l2_subscribed_event *sev)
> +{
> +	struct uvc_fh *handle = container_of(sev->fh, struct uvc_fh, vfh);
> +
> +	mutex_lock(&handle->chain->ctrl_mutex);
> +	list_del(&sev->node);
> +	mutex_unlock(&handle->chain->ctrl_mutex);
> +}
> +
> +const struct v4l2_subscribed_event_ops uvc_ctrl_sub_ev_ops = {
> +	.add = uvc_ctrl_add_event,
> +	.del = uvc_ctrl_del_event,
> +	.replace = v4l2_ctrl_replace,
> +	.merge = v4l2_ctrl_merge,
> +};
> +
> +/*
> --------------------------------------------------------------------------
> * Dynamic controls
>   */
> 
> @@ -1652,6 +1754,8 @@ static int __uvc_ctrl_add_mapping(struct uvc_device
> *dev, if (map == NULL)
>  		return -ENOMEM;
> 
> +	INIT_LIST_HEAD(&map->ev_subs);
> +
>  	size = sizeof(*mapping->menu_info) * mapping->menu_count;
>  	map->menu_info = kmemdup(mapping->menu_info, size, GFP_KERNEL);
>  	if (map->menu_info == NULL) {
> diff --git a/drivers/media/video/uvc/uvc_v4l2.c
> b/drivers/media/video/uvc/uvc_v4l2.c index dadf11f..1c577a3 100644
> --- a/drivers/media/video/uvc/uvc_v4l2.c
> +++ b/drivers/media/video/uvc/uvc_v4l2.c
> @@ -25,6 +25,7 @@
> 
>  #include <media/v4l2-common.h>
>  #include <media/v4l2-ioctl.h>
> +#include <media/v4l2-event.h>

Please keep the headers sorted alphabetically.

> 
>  #include "uvcvideo.h"
> 
> @@ -495,6 +496,8 @@ static int uvc_v4l2_open(struct file *file)
>  		}
>  	}
> 
> +	v4l2_fh_init(&handle->vfh, stream->vdev);
> +	v4l2_fh_add(&handle->vfh);
>  	handle->chain = stream->chain;
>  	handle->stream = stream;
>  	handle->state = UVC_HANDLE_PASSIVE;
> @@ -521,6 +524,8 @@ static int uvc_v4l2_release(struct file *file)
> 
>  	/* Release the file handle. */
>  	uvc_dismiss_privileges(handle);
> +	v4l2_fh_del(&handle->vfh);
> +	v4l2_fh_exit(&handle->vfh);
>  	kfree(handle);
>  	file->private_data = NULL;
> 
> @@ -602,8 +607,10 @@ static long uvc_v4l2_do_ioctl(struct file *file,
> unsigned int cmd, void *arg) return ret;
>  		}
>  		ret = uvc_ctrl_commit(chain);
> -		if (ret == 0)
> +		if (ret == 0) {
> +			uvc_ctrl_send_event(handle, &xctrl);
>  			ctrl->value = xctrl.value;
> +		}
>  		break;
>  	}
> 
> @@ -655,8 +662,14 @@ static long uvc_v4l2_do_ioctl(struct file *file,
> unsigned int cmd, void *arg)
> 
>  		ctrls->error_idx = 0;
> 
> -		if (cmd == VIDIOC_S_EXT_CTRLS)
> +		if (cmd == VIDIOC_S_EXT_CTRLS) {
>  			ret = uvc_ctrl_commit(chain);
> +			if (ret == 0) {
> +				ctrl = ctrls->controls;
> +				for (i = 0; i < ctrls->count; ++ctrl, ++i)
> +					uvc_ctrl_send_event(handle, ctrl);
> +			}
> +		}
>  		else
>  			ret = uvc_ctrl_rollback(chain);
>  		break;
> @@ -996,6 +1009,26 @@ static long uvc_v4l2_do_ioctl(struct file *file,
> unsigned int cmd, void *arg) return uvc_video_enable(stream, 0);
>  	}
> 
> +	case VIDIOC_SUBSCRIBE_EVENT:
> +	{
> +		struct v4l2_event_subscription *sub = arg;
> +
> +		switch (sub->type) {
> +		case V4L2_EVENT_CTRL:
> +			return v4l2_event_subscribe(&handle->vfh, sub, 0,
> +						    &uvc_ctrl_sub_ev_ops);
> +		default:
> +			return -EINVAL;
> +		}
> +	}
> +
> +	case VIDIOC_UNSUBSCRIBE_EVENT:
> +		return v4l2_event_unsubscribe(&handle->vfh, arg);
> +
> +	case VIDIOC_DQEVENT:
> +		return v4l2_event_dequeue(&handle->vfh, arg,
> +					  file->f_flags & O_NONBLOCK);
> +
>  	/* Analog video standards make no sense for digital cameras. */
>  	case VIDIOC_ENUMSTD:
>  	case VIDIOC_QUERYSTD:
> @@ -1058,10 +1091,22 @@ static unsigned int uvc_v4l2_poll(struct file
> *file, poll_table *wait) {
>  	struct uvc_fh *handle = file->private_data;
>  	struct uvc_streaming *stream = handle->stream;
> +	unsigned long req_events = poll_requested_events(wait);
> +	unsigned int res = 0;
> 
>  	uvc_trace(UVC_TRACE_CALLS, "uvc_v4l2_poll\n");
> 
> -	return uvc_queue_poll(&stream->queue, file, wait);
> +	if (req_events & POLLPRI) {
> +		if (v4l2_event_pending(&handle->vfh))
> +			res |= POLLPRI;
> +		else
> +			poll_wait(file, &handle->vfh.wait, wait);
> +	}
> +
> +	if (req_events & (POLLIN | POLLRDNORM | POLLOUT | POLLWRNORM))
> +		res |= uvc_queue_poll(&stream->queue, file, wait);
> +
> +	return res;
>  }
> 
>  #ifndef CONFIG_MMU
> diff --git a/drivers/media/video/uvc/uvcvideo.h
> b/drivers/media/video/uvc/uvcvideo.h index 4c1392e..cf3cbe4 100644
> --- a/drivers/media/video/uvc/uvcvideo.h
> +++ b/drivers/media/video/uvc/uvcvideo.h
> @@ -13,6 +13,8 @@
>  #include <linux/videodev2.h>
>  #include <media/media-device.h>
>  #include <media/v4l2-device.h>
> +#include <media/v4l2-fh.h>
> +#include <media/v4l2-event.h>
> 
>  /*
> --------------------------------------------------------------------------
> * UVC constants
> @@ -151,6 +153,7 @@ struct uvc_control_info {
> 
>  struct uvc_control_mapping {
>  	struct list_head list;
> +	struct list_head ev_subs;

Maybe just 'events' ? 'ev_subs' looks a bit confusing to me.

> 
>  	struct uvc_control_info *ctrl;
> 
> @@ -455,6 +458,7 @@ enum uvc_handle_state {
>  };
> 
>  struct uvc_fh {
> +	struct v4l2_fh vfh;
>  	struct uvc_video_chain *chain;
>  	struct uvc_streaming *stream;
>  	enum uvc_handle_state state;
> @@ -570,6 +574,8 @@ extern int uvc_status_suspend(struct uvc_device *dev);
>  extern int uvc_status_resume(struct uvc_device *dev);
> 
>  /* Controls */
> +extern const struct v4l2_subscribed_event_ops uvc_ctrl_sub_ev_ops;
> +
>  extern int uvc_query_v4l2_ctrl(struct uvc_video_chain *chain,
>  		struct v4l2_queryctrl *v4l2_ctrl);
>  extern int uvc_query_v4l2_menu(struct uvc_video_chain *chain,
> @@ -597,6 +603,9 @@ extern int uvc_ctrl_get(struct uvc_video_chain *chain,
>  extern int uvc_ctrl_set(struct uvc_video_chain *chain,
>  		struct v4l2_ext_control *xctrl);
> 
> +extern void uvc_ctrl_send_event(struct uvc_fh *handle,
> +		struct v4l2_ext_control *xctrl);
> +
>  extern int uvc_xu_ctrl_query(struct uvc_video_chain *chain,
>  		struct uvc_xu_control_query *xqry);

-- 
Regards,

Laurent Pinchart
