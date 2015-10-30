Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:58643 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539AbbJ3O3u (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Oct 2015 10:29:50 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Mike Isely <isely@pobox.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Steven Toth <stoth@kernellabs.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Vincent Palatin <vpalatin@chromium.org>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/6] usb/uvc: Support for V4L2_CTRL_WHICH_DEF_VAL
Date: Fri, 30 Oct 2015 16:29:51 +0200
Message-ID: <3479394.juLgpLeZDd@avalon>
In-Reply-To: <1446113432-27390-5-git-send-email-ricardo.ribalda@gmail.com>
References: <1446113432-27390-1-git-send-email-ricardo.ribalda@gmail.com> <1446113432-27390-5-git-send-email-ricardo.ribalda@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ricardo,

Thank you for the patch.

On Thursday 29 October 2015 11:10:30 Ricardo Ribalda Delgado wrote:
> This driver does not use the control infrastructure.
> Add support for the new field which on structure
>  v4l2_ext_controls
> 
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/media/usb/uvc/uvc_v4l2.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/drivers/media/usb/uvc/uvc_v4l2.c
> b/drivers/media/usb/uvc/uvc_v4l2.c index 2764f43607c1..d7723ce772b3 100644
> --- a/drivers/media/usb/uvc/uvc_v4l2.c
> +++ b/drivers/media/usb/uvc/uvc_v4l2.c
> @@ -983,6 +983,22 @@ static int uvc_ioctl_g_ext_ctrls(struct file *file,
> void *fh, unsigned int i;
>  	int ret;
> 
> +	if (ctrls->which == V4L2_CTRL_WHICH_DEF_VAL) {
> +		for (i = 0; i < ctrls->count; ++ctrl, ++i) {
> +			struct v4l2_queryctrl qc = { .id = ctrl->id };
> +
> +			ret = uvc_query_v4l2_ctrl(chain, &qc);
> +			if (ret < 0) {
> +				ctrls->error_idx = i;
> +				return ret;
> +			}
> +
> +			ctrl->value = qc.default_value;
> +		}
> +
> +		return 0;
> +	}
> +
>  	ret = uvc_ctrl_begin(chain);
>  	if (ret < 0)
>  		return ret;
> @@ -1010,6 +1026,10 @@ static int uvc_ioctl_s_try_ext_ctrls(struct uvc_fh
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

