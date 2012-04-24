Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11242 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754256Ab2DXNGA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Apr 2012 09:06:00 -0400
Message-ID: <4F96A5C2.3070704@redhat.com>
Date: Tue, 24 Apr 2012 15:08:18 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH v2] uvcvideo: Send control change events for slave ctrls
 when the master changes
References: <25679814.sufWEMM1Zo@avalon> <1335221282-14176-1-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1335221282-14176-1-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Good optimization, ACK.

Regards,

Hans

On 04/24/2012 12:48 AM, Laurent Pinchart wrote:
> From: Hans de Goede<hdegoede@redhat.com>
>
> This allows v4l2 control UI-s to update the inactive state (ie grey-ing
> out of controls) for slave controls when the master control changes.
>
> Signed-off-by: Hans de Goede<hdegoede@redhat.com>
> [Use __uvc_find_control() to find slave controls, as they're always
> located in the same entity as the corresponding master control]
> Signed-off-by: Laurent Pinchart<laurent.pinchart@ideasonboard.com>
> ---
>   drivers/media/video/uvc/uvc_ctrl.c |   58 ++++++++++++++++++++++++++++++++++-
>   1 files changed, 56 insertions(+), 2 deletions(-)
>
> Hi Hans,
>
> This is your 09/10 patch after replacing uvc_find_control() with
> __uvc_find_control(). Could you please test it ?
>
> diff --git a/drivers/media/video/uvc/uvc_ctrl.c b/drivers/media/video/uvc/uvc_ctrl.c
> index ae7371f..03212c7 100644
> --- a/drivers/media/video/uvc/uvc_ctrl.c
> +++ b/drivers/media/video/uvc/uvc_ctrl.c
> @@ -1177,21 +1177,75 @@ static void uvc_ctrl_send_event(struct uvc_fh *handle,
>
>   	list_for_each_entry(sev,&mapping->ev_subs, node)
>   		if (sev->fh&&  (sev->fh !=&handle->vfh ||
> -		    (sev->flags&  V4L2_EVENT_SUB_FL_ALLOW_FEEDBACK)))
> +		    (sev->flags&  V4L2_EVENT_SUB_FL_ALLOW_FEEDBACK) ||
> +		    (changes&  V4L2_EVENT_CTRL_CH_FLAGS)))
>   			v4l2_event_queue_fh(sev->fh,&ev);
>   }
>
> +static void uvc_ctrl_send_slave_event(struct uvc_fh *handle,
> +	struct uvc_control *master, u32 slave_id,
> +	const struct v4l2_ext_control *xctrls, unsigned int xctrls_count)
> +{
> +	struct uvc_control_mapping *mapping = NULL;
> +	struct uvc_control *ctrl = NULL;
> +	u32 changes = V4L2_EVENT_CTRL_CH_FLAGS;
> +	unsigned int i;
> +	s32 val = 0;
> +
> +	/*
> +	 * We can skip sending an event for the slave if the slave
> +	 * is being modified in the same transaction.
> +	 */
> +	for (i = 0; i<  xctrls_count; i++) {
> +		if (xctrls[i].id == slave_id)
> +			return;
> +	}
> +
> +	__uvc_find_control(master->entity, slave_id,&mapping,&ctrl, 0);
> +	if (ctrl == NULL)
> +		return;
> +
> +	if (__uvc_ctrl_get(handle->chain, ctrl, mapping,&val) == 0)
> +		changes |= V4L2_EVENT_CTRL_CH_VALUE;
> +
> +	uvc_ctrl_send_event(handle, ctrl, mapping, val, changes);
> +}
> +
>   static void uvc_ctrl_send_events(struct uvc_fh *handle,
>   	const struct v4l2_ext_control *xctrls, unsigned int xctrls_count)
>   {
>   	struct uvc_control_mapping *mapping;
>   	struct uvc_control *ctrl;
> +	u32 changes = V4L2_EVENT_CTRL_CH_VALUE;
>   	unsigned int i;
> +	unsigned int j;
>
>   	for (i = 0; i<  xctrls_count; ++i) {
>   		ctrl = uvc_find_control(handle->chain, xctrls[i].id,&mapping);
> +
> +		for (j = 0; j<  ARRAY_SIZE(mapping->slave_ids); ++j) {
> +			if (!mapping->slave_ids[j])
> +				break;
> +			uvc_ctrl_send_slave_event(handle, ctrl,
> +						  mapping->slave_ids[j],
> +						  xctrls, xctrls_count);
> +		}
> +
> +		/*
> +		 * If the master is being modified in the same transaction
> +		 * flags may change too.
> +		 */
> +		if (mapping->master_id) {
> +			for (j = 0; j<  xctrls_count; j++) {
> +				if (xctrls[j].id == mapping->master_id) {
> +					changes |= V4L2_EVENT_CTRL_CH_FLAGS;
> +					break;
> +				}
> +			}
> +		}
> +
>   		uvc_ctrl_send_event(handle, ctrl, mapping, xctrls[i].value,
> -				    V4L2_EVENT_CTRL_CH_VALUE);
> +				    changes);
>   	}
>   }
>
