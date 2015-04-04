Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:36919 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705AbbDDVdj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 4 Apr 2015 17:33:39 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] uvcvideo: add support for VIDIOC_QUERY_EXT_CTRL
Date: Sun, 05 Apr 2015 00:34:01 +0300
Message-ID: <14004237.ITdSdzqiOy@avalon>
In-Reply-To: <55046A00.3070307@xs4all.nl>
References: <55046A00.3070307@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the patch.

On Saturday 14 March 2015 18:04:00 Hans Verkuil wrote:
> Add support for the new VIDIOC_QUERY_EXT_CTRL ioctl. Since uvc doesn't use
> the control framework, support for this ioctl isn't automatic.
> 
> This is makes v4l2-compliance happy as well.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

and applied to my tree with a blank line inserted (I like it when the code has 
room to breathe ;-)).

> ---
>  drivers/media/usb/uvc/uvc_v4l2.c | 28 ++++++++++++++++++++++++++++
>  1 file changed, 28 insertions(+)
> 
> diff --git a/drivers/media/usb/uvc/uvc_v4l2.c
> b/drivers/media/usb/uvc/uvc_v4l2.c index 43e953f..100e5c1 100644
> --- a/drivers/media/usb/uvc/uvc_v4l2.c
> +++ b/drivers/media/usb/uvc/uvc_v4l2.c
> @@ -882,6 +882,33 @@ static int uvc_ioctl_queryctrl(struct file *file, void
> *fh, return uvc_query_v4l2_ctrl(chain, qc);
>  }
> 
> +static int uvc_ioctl_query_ext_ctrl(struct file *file, void *fh,
> +				    struct v4l2_query_ext_ctrl *qec)
> +{
> +	struct uvc_fh *handle = fh;
> +	struct uvc_video_chain *chain = handle->chain;
> +	struct v4l2_queryctrl qc = { qec->id };
> +	int ret;
> +
> +	ret = uvc_query_v4l2_ctrl(chain, &qc);
> +	if (ret)
> +		return ret;
> +	qec->id = qc.id;
> +	qec->type = qc.type;
> +	strlcpy(qec->name, qc.name, sizeof(qec->name));
> +	qec->minimum = qc.minimum;
> +	qec->maximum = qc.maximum;
> +	qec->step = qc.step;
> +	qec->default_value = qc.default_value;
> +	qec->flags = qc.flags;
> +	qec->elem_size = 4;
> +	qec->elems = 1;
> +	qec->nr_of_dims = 0;
> +	memset(qec->dims, 0, sizeof(qec->dims));
> +	memset(qec->reserved, 0, sizeof(qec->reserved));
> +	return 0;
> +}
> +
>  static int uvc_ioctl_g_ctrl(struct file *file, void *fh,
>  			    struct v4l2_control *ctrl)
>  {
> @@ -1443,6 +1470,7 @@ const struct v4l2_ioctl_ops uvc_ioctl_ops = {
>  	.vidioc_g_input = uvc_ioctl_g_input,
>  	.vidioc_s_input = uvc_ioctl_s_input,
>  	.vidioc_queryctrl = uvc_ioctl_queryctrl,
> +	.vidioc_query_ext_ctrl = uvc_ioctl_query_ext_ctrl,
>  	.vidioc_g_ctrl = uvc_ioctl_g_ctrl,
>  	.vidioc_s_ctrl = uvc_ioctl_s_ctrl,
>  	.vidioc_g_ext_ctrls = uvc_ioctl_g_ext_ctrls,

-- 
Regards,

Laurent Pinchart

