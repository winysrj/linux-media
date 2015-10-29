Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:56261 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003AbbJ2AIJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Oct 2015 20:08:09 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mike Isely <isely@pobox.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Steven Toth <stoth@kernellabs.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Vincent Palatin <vpalatin@chromium.org>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 06/10] usb/uvc: Support for V4L2_CTRL_WHICH_DEF_VAL
Date: Thu, 29 Oct 2015 02:08:07 +0200
Message-ID: <1643612.KeQ8I7KJtY@avalon>
In-Reply-To: <1440163169-18047-7-git-send-email-ricardo.ribalda@gmail.com>
References: <1440163169-18047-1-git-send-email-ricardo.ribalda@gmail.com> <1440163169-18047-7-git-send-email-ricardo.ribalda@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ricardo,

Thank you for the patch.

On Friday 21 August 2015 15:19:25 Ricardo Ribalda Delgado wrote:
> This driver does not use the control infrastructure.
> Add support for the new field which on structure
>  v4l2_ext_controls
> 
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> ---
>  drivers/media/usb/uvc/uvc_v4l2.c | 14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/usb/uvc/uvc_v4l2.c
> b/drivers/media/usb/uvc/uvc_v4l2.c index 2764f43607c1..e6d3a1bcfa2f 100644
> --- a/drivers/media/usb/uvc/uvc_v4l2.c
> +++ b/drivers/media/usb/uvc/uvc_v4l2.c
> @@ -980,6 +980,7 @@ static int uvc_ioctl_g_ext_ctrls(struct file *file, void
> *fh, struct uvc_fh *handle = fh;
>  	struct uvc_video_chain *chain = handle->chain;
>  	struct v4l2_ext_control *ctrl = ctrls->controls;
> +	struct v4l2_queryctrl qc;
>  	unsigned int i;
>  	int ret;
> 
> @@ -988,7 +989,14 @@ static int uvc_ioctl_g_ext_ctrls(struct file *file,
> void *fh, return ret;
> 
>  	for (i = 0; i < ctrls->count; ++ctrl, ++i) {
> -		ret = uvc_ctrl_get(chain, ctrl);
> +		if (ctrls->which == V4L2_CTRL_WHICH_DEF_VAL) {
> +			qc.id = ctrl->id;
> +			ret = uvc_query_v4l2_ctrl(chain, &qc);

The uvc_ctrl_begin() call above locks chain->ctrl_mutex, and 
uvc_query_v4l2_ctrl() will then try to acquire the same lock. That's not a 
good idea :-)

I propose moving the ctrls->which check before the uvc_ctrl_begin() call and 
implement it as

	if (ctrls->which == V4L2_CTRL_WHICH_DEF_VAL) {
		for (i = 0; i < ctrls->count; ++ctrl, ++i) {
			struct v4l2_queryctrl qc = { .id = ctrl->id };

			ret = uvc_query_v4l2_ctrl(chain, &qc);
			if (ret < 0) {
				ctrls->error_idx = i;
				return ret;
			}

			ctrl->value = qc.default_value;
		}

		return 0;
	}

> +			if (!ret)
> +				ctrl->value = qc.default_value;
> +		} else
> +			ret = uvc_ctrl_get(chain, ctrl);
> +
>  		if (ret < 0) {
>  			uvc_ctrl_rollback(handle);
>  			ctrls->error_idx = i;
> @@ -1010,6 +1018,10 @@ static int uvc_ioctl_s_try_ext_ctrls(struct uvc_fh
> *handle, unsigned int i;
>  	int ret;
> 
> +	/* Default value cannot be changed */
> +	if (ctrls->which == V4L2_CTRL_WHICH_DEF_VAL)
> +		return -EINVAL;
> +
>  	ret = uvc_ctrl_begin(chain);
>  	if (ret < 0)
>  		return ret;

-- 
Regards,

Laurent Pinchart

