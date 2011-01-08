Return-path: <mchehab@pedra>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:1074 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239Ab1AHR0u (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 8 Jan 2011 12:26:50 -0500
Received: from tschai.localnet (43.80-203-71.nextgentel.com [80.203.71.43])
	(authenticated bits=0)
	by smtp-vbr4.xs4all.nl (8.13.8/8.13.8) with ESMTP id p08HQnwQ051783
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Sat, 8 Jan 2011 18:26:49 +0100 (CET)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Subject: Re: [RFCv3 PATCH 05/16] v4l2-ioctl: add priority handling support.
Date: Sat, 8 Jan 2011 18:26:51 +0100
References: <1294493801-17406-1-git-send-email-hverkuil@xs4all.nl> <09ba25d46c42c9bc1fe46dc29a09840fcdae4af4.1294493428.git.hverkuil@xs4all.nl>
In-Reply-To: <09ba25d46c42c9bc1fe46dc29a09840fcdae4af4.1294493428.git.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201101081826.51095.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Saturday, January 08, 2011 14:36:30 Hans Verkuil wrote:
> Drivers that use v4l2_fh can now use the core framework support of g/s_priority.
> 
> Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
> ---
>  drivers/media/radio/radio-si4713.c         |    3 +-
>  drivers/media/video/cx18/cx18-ioctl.c      |    3 +-
>  drivers/media/video/davinci/vpfe_capture.c |    2 +-
>  drivers/media/video/ivtv/ivtv-ioctl.c      |    3 +-
>  drivers/media/video/meye.c                 |    3 +-
>  drivers/media/video/mxb.c                  |    3 +-
>  drivers/media/video/v4l2-ioctl.c           |   63 ++++++++++++++++++++++++---
>  include/media/v4l2-ioctl.h                 |    2 +-
>  8 files changed, 68 insertions(+), 14 deletions(-)

<snip>

> diff --git a/drivers/media/video/v4l2-ioctl.c b/drivers/media/video/v4l2-ioctl.c
> index 7e47f15..b84ab1f 100644
> --- a/drivers/media/video/v4l2-ioctl.c
> +++ b/drivers/media/video/v4l2-ioctl.c
> @@ -25,6 +25,7 @@
>  #include <media/v4l2-ctrls.h>
>  #include <media/v4l2-fh.h>
>  #include <media/v4l2-event.h>
> +#include <media/v4l2-device.h>
>  #include <media/v4l2-chip-ident.h>
>  
>  #define dbgarg(cmd, fmt, arg...) \
> @@ -565,6 +566,7 @@ static long __video_do_ioctl(struct file *file,
>  	struct video_device *vfd = video_devdata(file);
>  	const struct v4l2_ioctl_ops *ops = vfd->ioctl_ops;
>  	void *fh = file->private_data;
> +	struct v4l2_fh *vfh = NULL;
>  	long ret = -EINVAL;
>  
>  	if (ops == NULL) {
> @@ -579,6 +581,42 @@ static long __video_do_ioctl(struct file *file,
>  		printk(KERN_CONT "\n");
>  	}
>  
> +	if (test_bit(V4L2_FL_USES_V4L2_FH, &vfd->flags))
> +		vfh = file->private_data;
> +
> +	if (vfh) {
> +		switch (cmd) {
> +		case VIDIOC_S_CTRL:
> +		case VIDIOC_S_STD:
> +		case VIDIOC_S_INPUT:
> +		case VIDIOC_S_OUTPUT:
> +		case VIDIOC_S_TUNER:
> +		case VIDIOC_S_FREQUENCY:
> +		case VIDIOC_S_FMT:
> +		case VIDIOC_S_CROP:
> +		case VIDIOC_S_AUDIO:
> +		case VIDIOC_S_AUDOUT:
> +		case VIDIOC_S_EXT_CTRLS:
> +		case VIDIOC_S_FBUF:
> +		case VIDIOC_S_PRIORITY:
> +		case VIDIOC_S_DV_PRESET:
> +		case VIDIOC_S_DV_TIMINGS:
> +		case VIDIOC_S_JPEGCOMP:
> +		case VIDIOC_S_MODULATOR:
> +		case VIDIOC_S_PARM:
> +		case VIDIOC_S_HW_FREQ_SEEK:
> +		case VIDIOC_ENCODER_CMD:
> +		case VIDIOC_OVERLAY:
> +		case VIDIOC_REQBUFS:
> +		case VIDIOC_STREAMON:
> +		case VIDIOC_STREAMOFF:
> +			ret = v4l2_prio_check(vfd->prio, vfh->prio);
> +			if (ret)
> +				goto exit_prio;

Oops, there is a missing 'ret = -EINVAL;' here. Otherwise unsupported ioctls
start returning 0 instead of -EINVAL.

Regards,

	Hans

> +			break;
> +		}
> +	}
> +

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
