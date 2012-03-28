Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:39193 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628Ab2C1JeW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Mar 2012 05:34:22 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 10/10] uvcvideo: Send control change events for slave ctrls when the master changes
Date: Wed, 28 Mar 2012 11:34:21 +0200
Message-ID: <3644368.eZXM6sk7Z1@avalon>
In-Reply-To: <1332676610-14953-11-git-send-email-hdegoede@redhat.com>
References: <1332676610-14953-1-git-send-email-hdegoede@redhat.com> <1332676610-14953-11-git-send-email-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thanks for the patch.

On Sunday 25 March 2012 13:56:50 Hans de Goede wrote:
> This allows v4l2 control UI-s to update the inactive state (ie grey-ing
> out of controls) for slave controls when the master control changes.
> 
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---
>  drivers/media/video/uvc/uvc_ctrl.c |   55 +++++++++++++++++++++++++++++++--
>  1 file changed, 52 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/video/uvc/uvc_ctrl.c
> b/drivers/media/video/uvc/uvc_ctrl.c index 91d9007..2d06fd8 100644
> --- a/drivers/media/video/uvc/uvc_ctrl.c
> +++ b/drivers/media/video/uvc/uvc_ctrl.c

[snip]

> +static void uvc_ctrl_send_events(struct uvc_fh *handle,
> +	struct v4l2_ext_control *xctrls, int xctrls_count)
> +{
> +	struct uvc_control_mapping *mapping;
> +	struct uvc_control *ctrl;
> +	u32 changes = V4L2_EVENT_CTRL_CH_VALUE;
> +	int i, j;
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
> +		if (mapping->master_id)
> +			for (j = 0; j < xctrls_count; j++)
> +				if (xctrls[j].id == mapping->master_id) {
> +					changes |= V4L2_EVENT_CTRL_CH_FLAGS;

Should you verify that the modification to the master control actually caused 
a slave control flags change, or would that be overkill ?

> +					break;
> +				}

Could you please put brackets around the for and the if ?

> +
>  		uvc_ctrl_send_event(handle, ctrl, mapping, xctrls[i].value,
> -				    V4L2_EVENT_CTRL_CH_VALUE);
> +				    changes);
>  	}
>  }

-- 
Regards,

Laurent Pinchart

