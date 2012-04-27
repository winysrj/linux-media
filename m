Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr18.xs4all.nl ([194.109.24.38]:2794 "EHLO
	smtp-vbr18.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759546Ab2D0IVQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Apr 2012 04:21:16 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Antonio Ospite <ospite@studenti.unina.it>
Subject: Re: [RFC PATCH 3/3] [media] gspca - main: implement vidioc_g_ext_ctrls and vidioc_s_ext_ctrls
Date: Fri, 27 Apr 2012 10:20:23 +0200
Cc: linux-media@vger.kernel.org,
	"Jean-Francois Moine" <moinejf@free.fr>,
	Erik =?iso-8859-15?q?Andr=E9n?= <erik.andren@gmail.com>
References: <20120418153720.1359c7d2f2a3efc2c7c17b88@studenti.unina.it> <1334935152-16165-1-git-send-email-ospite@studenti.unina.it> <1334935152-16165-4-git-send-email-ospite@studenti.unina.it>
In-Reply-To: <1334935152-16165-4-git-send-email-ospite@studenti.unina.it>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201204271020.23880.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Antonio,

My apologies for the late review, I missed this the first time around.

Since I am the 'control guy' :-) I thought I should give my view on this.
And that is the real long-term approach to implementing extended controls
in gspca is to add support in gspca for the control framework (see
Documentation/video4linux/v4l2-controls.txt). That will probably simplify
control handling in gspca anyway. The main problem is how to do it in such
a manner that we can convert gspca drivers to the control framework one by
one.

I am inclined to NACK code that adds a driver-specific extended control
implementation instead of going to the control framework because I know
from painful personal experience that it is very hard to get it right.

I might have some time (no guarantees yet) to help with this. It would
certainly be interesting to add support for the control framework in the
gspca core. Hmm, perhaps that's a job for the weekend...

Regards,

	Hans

On Friday, April 20, 2012 17:19:11 Antonio Ospite wrote:
> This makes it possible for applications to handle controls with a class
> different than V4L2_CTRL_CLASS_USER for gspca subdevices, like for
> instance V4L2_CID_EXPOSURE_AUTO which some subdrivers use and which
> can't be controlled right now.
> 
> See
> http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/47010
> for an example of a problem fixed by this change.
> 
> NOTE: gspca currently won't handle control types like
> V4L2_CTRL_TYPE_INTEGER64 or V4L2_CTRL_TYPE_STRING, so just the
> __s32 field 'value' of 'struct v4l2_ext_control' is handled for now.
> 
> Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
> ---
>  drivers/media/video/gspca/gspca.c |   42 +++++++++++++++++++++++++++++++++++++
>  1 file changed, 42 insertions(+)
> 
> diff --git a/drivers/media/video/gspca/gspca.c b/drivers/media/video/gspca/gspca.c
> index ba1bda9..7906093 100644
> --- a/drivers/media/video/gspca/gspca.c
> +++ b/drivers/media/video/gspca/gspca.c
> @@ -1567,6 +1567,46 @@ static int vidioc_g_ctrl(struct file *file, void *priv,
>  	return gspca_get_ctrl(gspca_dev, ctrl->id, &ctrl->value);
>  }
>  
> +static int vidioc_s_ext_ctrls(struct file *file, void *priv,
> +			 struct v4l2_ext_controls *ext_ctrls)
> +{
> +	struct gspca_dev *gspca_dev = priv;
> +	int ret = 0;
> +	int i;
> +
> +	for (i = 0; i < ext_ctrls->count; i++) {
> +		struct v4l2_ext_control *ctrl;
> +
> +		ctrl = ext_ctrls->controls + i;
> +		ret = gspca_set_ctrl(gspca_dev, ctrl->id, ctrl->value);
> +		if (ret < 0) {
> +			ext_ctrls->error_idx = i;
> +			return ret;
> +		}
> +	}
> +	return ret;
> +}
> +
> +static int vidioc_g_ext_ctrls(struct file *file, void *priv,
> +			 struct v4l2_ext_controls *ext_ctrls)
> +{
> +	struct gspca_dev *gspca_dev = priv;
> +	int i;
> +	int ret = 0;
> +
> +	for (i = 0; i < ext_ctrls->count; i++) {
> +		struct v4l2_ext_control *ctrl;
> +
> +		ctrl = ext_ctrls->controls + i;
> +		ret = gspca_get_ctrl(gspca_dev, ctrl->id, &ctrl->value);
> +		if (ret < 0) {
> +			ext_ctrls->error_idx = i;
> +			return ret;
> +		}
> +	}
> +	return ret;
> +}
> +
>  static int vidioc_querymenu(struct file *file, void *priv,
>  			    struct v4l2_querymenu *qmenu)
>  {
> @@ -2260,6 +2300,8 @@ static const struct v4l2_ioctl_ops dev_ioctl_ops = {
>  	.vidioc_queryctrl	= vidioc_queryctrl,
>  	.vidioc_g_ctrl		= vidioc_g_ctrl,
>  	.vidioc_s_ctrl		= vidioc_s_ctrl,
> +	.vidioc_g_ext_ctrls	= vidioc_g_ext_ctrls,
> +	.vidioc_s_ext_ctrls	= vidioc_s_ext_ctrls,
>  	.vidioc_querymenu	= vidioc_querymenu,
>  	.vidioc_enum_input	= vidioc_enum_input,
>  	.vidioc_g_input		= vidioc_g_input,
> 
