Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:53420 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752409Ab1FLOgR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Jun 2011 10:36:17 -0400
Message-ID: <4DF4CEDB.9070501@redhat.com>
Date: Sun, 12 Jun 2011 11:36:11 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org, Mike Isely <isely@isely.net>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv4 PATCH 6/8] v4l2-ioctl.c: prefill tuner type for g_frequency
 and g/s_tuner.
References: <1307876389-30347-1-git-send-email-hverkuil@xs4all.nl> <e2a61ca8e17b7354a69bcb1b5ca35301efb5581e.1307875512.git.hans.verkuil@cisco.com>
In-Reply-To: <e2a61ca8e17b7354a69bcb1b5ca35301efb5581e.1307875512.git.hans.verkuil@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 12-06-2011 07:59, Hans Verkuil escreveu:
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

Interesting solution. Yes, this is the proper fix, but only after being sure
that no drivers allow switch to radio using the video device, and vice-versa.

Unfortunately, this is not the case, currently.

Most drivers allow this, following the previous V4L2 specs. Changing such
behavior will probably require to write something at 
Documentation/feature-removal-schedule.txt, as we're changing the behavior.


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

