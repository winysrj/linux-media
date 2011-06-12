Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:39762 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753416Ab1FLMmC (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Jun 2011 08:42:02 -0400
Subject: Re: [RFCv4 PATCH 6/8] v4l2-ioctl.c: prefill tuner type for
 g_frequency and g/s_tuner.
From: Andy Walls <awalls@md.metrocast.net>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Mike Isely <isely@isely.net>,
	Hans Verkuil <hans.verkuil@cisco.com>
In-Reply-To: <e2a61ca8e17b7354a69bcb1b5ca35301efb5581e.1307875512.git.hans.verkuil@cisco.com>
References: <1307876389-30347-1-git-send-email-hverkuil@xs4all.nl>
	 <e2a61ca8e17b7354a69bcb1b5ca35301efb5581e.1307875512.git.hans.verkuil@cisco.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 12 Jun 2011 08:41:46 -0400
Message-ID: <1307882506.2592.3.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sun, 2011-06-12 at 12:59 +0200, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> The subdevs are supposed to receive a valid tuner type for the g_frequency
> and g/s_tuner subdev ops. Some drivers do this, others don't. So prefill
> this in v4l2-ioctl.c based on whether the device node from which this is
> called is a radio node or not.
> 
> The spec does not require applications to fill in the type, and if they
> leave it at 0 then the 'supported_mode' call in tuner-core.c will return
> false and the ioctl does nothing.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/video/v4l2-ioctl.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
> index 213ba7d..26bf3bf 100644
> --- a/drivers/media/video/v4l2-ioctl.c
> +++ b/drivers/media/video/v4l2-ioctl.c
> @@ -1822,6 +1822,8 @@ static long __video_do_ioctl(struct file *file,
>  		if (!ops->vidioc_g_tuner)
>  			break;
>  
> +		p->type = (vfd->vfl_type == VFL_TYPE_RADIO) ?
> +			V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
>  		ret = ops->vidioc_g_tuner(file, fh, p);
>  		if (!ret)
>  			dbgarg(cmd, "index=%d, name=%s, type=%d, "
> @@ -1840,6 +1842,8 @@ static long __video_do_ioctl(struct file *file,
>  
>  		if (!ops->vidioc_s_tuner)
>  			break;
> +		p->type = (vfd->vfl_type == VFL_TYPE_RADIO) ?
> +			V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
>  		dbgarg(cmd, "index=%d, name=%s, type=%d, "
>  				"capability=0x%x, rangelow=%d, "
>  				"rangehigh=%d, signal=%d, afc=%d, "
> @@ -1858,6 +1862,8 @@ static long __video_do_ioctl(struct file *file,
>  		if (!ops->vidioc_g_frequency)
>  			break;
>  
> +		p->type = (vfd->vfl_type == VFL_TYPE_RADIO) ?
> +			V4L2_TUNER_RADIO : V4L2_TUNER_ANALOG_TV;
>  		ret = ops->vidioc_g_frequency(file, fh, p);
>  		if (!ret)
>  			dbgarg(cmd, "tuner=%d, type=%d, frequency=%d\n",


Wow, that was easy.  And from what I can tell, it is spec compliant
too. :)

Reviewed-by: Andy Walls <awalls@md.metrocast.net>

-Andy






