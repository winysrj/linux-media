Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:38084 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752967Ab2DWWSR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Apr 2012 18:18:17 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 09/10] uvcvideo: Send control change events for slave ctrls when the master changes
Date: Tue, 24 Apr 2012 00:18:34 +0200
Message-ID: <25679814.sufWEMM1Zo@avalon>
In-Reply-To: <1333900794-1932-10-git-send-email-hdegoede@redhat.com>
References: <1333900794-1932-1-git-send-email-hdegoede@redhat.com> <1333900794-1932-10-git-send-email-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for the patch.

On Sunday 08 April 2012 17:59:53 Hans de Goede wrote:
> This allows v4l2 control UI-s to update the inactive state (ie grey-ing
> out of controls) for slave controls when the master control changes.
> 
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---
>  drivers/media/video/uvc/uvc_ctrl.c |   57 +++++++++++++++++++++++++++++++--
>  1 file changed, 54 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/video/uvc/uvc_ctrl.c
> b/drivers/media/video/uvc/uvc_ctrl.c index 75a4995..38d633a 100644
> --- a/drivers/media/video/uvc/uvc_ctrl.c
> +++ b/drivers/media/video/uvc/uvc_ctrl.c
> @@ -1177,21 +1177,72 @@ static void uvc_ctrl_send_event(struct uvc_fh
> *handle,
> 
>  	list_for_each_entry(sev, &mapping->ev_subs, node)
>  		if (sev->fh && (sev->fh != &handle->vfh ||
> -		    (sev->flags & V4L2_EVENT_SUB_FL_ALLOW_FEEDBACK)))
> +		    (sev->flags & V4L2_EVENT_SUB_FL_ALLOW_FEEDBACK) ||
> +		    (changes & V4L2_EVENT_CTRL_CH_FLAGS)))
>  			v4l2_event_queue_fh(sev->fh, &ev);
>  }
> 
> -static void uvc_ctrl_send_events(struct uvc_fh *handle,
> +static void uvc_ctrl_send_slave_event(struct uvc_fh *handle, u32 slave_id,
>  	const struct v4l2_ext_control *xctrls, unsigned int xctrls_count)
>  {
>  	struct uvc_control_mapping *mapping;
>  	struct uvc_control *ctrl;
> +	u32 changes = V4L2_EVENT_CTRL_CH_FLAGS;
> +	s32 val = 0;
>  	unsigned int i;
> 
> +	/*
> +	 * We can skip sending an event for the slave if the slave
> +	 * is being modified in the same transaction.
> +	 */
> +	for (i = 0; i < xctrls_count; i++)
> +		if (xctrls[i].id == slave_id)
> +			return;
> +
> +	ctrl = uvc_find_control(handle->chain, slave_id, &mapping);

As an optimization, what do you think about calling __uvc_find_control() 
instead (with the master control being passed as an argument to 
uvc_ctrl_send_slave_event() to get the entity) ? There's no need to resubmit, 
I can modify the patch myself.

> +	if (ctrl == NULL)
> +		return;
> +
> +	if (__uvc_ctrl_get(handle->chain, ctrl, mapping, &val) == 0)
> +		changes |= V4L2_EVENT_CTRL_CH_VALUE;
> +
> +	uvc_ctrl_send_event(handle, ctrl, mapping, val, changes);
> +}
> +
> +static void uvc_ctrl_send_events(struct uvc_fh *handle,
> +	const struct v4l2_ext_control *xctrls, unsigned int xctrls_count)
> +{
> +	struct uvc_control_mapping *mapping;
> +	struct uvc_control *ctrl;
> +	u32 changes = V4L2_EVENT_CTRL_CH_VALUE;
> +	unsigned int i, j;
> +
>  	for (i = 0; i < xctrls_count; ++i) {
>  		ctrl = uvc_find_control(handle->chain, xctrls[i].id, &mapping);
> +
> +		for (j = 0; j < ARRAY_SIZE(mapping->slave_ids); ++j) {
> +			if (!mapping->slave_ids[j])
> +				break;
> +			uvc_ctrl_send_slave_event(handle,
> +						  mapping->slave_ids[j],
> +						  xctrls, xctrls_count);
> +		}
> +
> +		/*
> +		 * If the master is being modified in the same transaction
> +		 * flags may change too.
> +		 */
> +		if (mapping->master_id) {
> +			for (j = 0; j < xctrls_count; j++) {
> +				if (xctrls[j].id == mapping->master_id) {
> +					changes |= V4L2_EVENT_CTRL_CH_FLAGS;
> +					break;
> +				}
> +			}
> +		}
> +
>  		uvc_ctrl_send_event(handle, ctrl, mapping, xctrls[i].value,
> -				    V4L2_EVENT_CTRL_CH_VALUE);
> +				    changes);
>  	}
>  }

-- 
Regards,

Laurent Pinchart

