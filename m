Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1.mentorg.com ([192.94.38.131]:42384 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685Ab3LPOuZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Dec 2013 09:50:25 -0500
Message-ID: <52AF1321.80606@mentor.com>
Date: Mon, 16 Dec 2013 07:50:09 -0700
From: Wade Farnsworth <wade_farnsworth@mentor.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [PATCH] v4l2: move tracepoints to video_usercopy
References: <52AEBDB1.2030206@xs4all.nl>
In-Reply-To: <52AEBDB1.2030206@xs4all.nl>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans Verkuil wrote:
> The (d)qbuf ioctls were traced in the low-level v4l2 ioctl function. The
> trace was outside the serialization lock, so that can affect the usefulness
> of the timing. In addition, the __user pointer was expected instead of a
> proper kernel pointer.
> 
> By moving the tracepoints to video_usercopy we ensure that the trace calls
> use the correct kernel pointer, and that it happens right after the ioctl
> call to the driver, so certainly inside the serialization lock.
> 
> In addition, we only trace if the call was successful.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Looks good to me.

Acked-by: Wade Farnsworth <wade_farnsworth@mentor.com>

> ---
>  drivers/media/v4l2-core/v4l2-dev.c   | 9 ---------
>  drivers/media/v4l2-core/v4l2-ioctl.c | 9 +++++++++
>  2 files changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-dev.c b/drivers/media/v4l2-core/v4l2-dev.c
> index 1cc1749..b5aaaac 100644
> --- a/drivers/media/v4l2-core/v4l2-dev.c
> +++ b/drivers/media/v4l2-core/v4l2-dev.c
> @@ -31,10 +31,6 @@
>  #include <media/v4l2-device.h>
>  #include <media/v4l2-ioctl.h>
>  
> -
> -#define CREATE_TRACE_POINTS
> -#include <trace/events/v4l2.h>
> -
>  #define VIDEO_NUM_DEVICES	256
>  #define VIDEO_NAME              "video4linux"
>  
> @@ -395,11 +391,6 @@ static long v4l2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>  	} else
>  		ret = -ENOTTY;
>  
> -	if (cmd == VIDIOC_DQBUF)
> -		trace_v4l2_dqbuf(vdev->minor, (struct v4l2_buffer *)arg);
> -	else if (cmd == VIDIOC_QBUF)
> -		trace_v4l2_qbuf(vdev->minor, (struct v4l2_buffer *)arg);
> -
>  	return ret;
>  }
>  
> diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
> index 68e6b5e..707aef7 100644
> --- a/drivers/media/v4l2-core/v4l2-ioctl.c
> +++ b/drivers/media/v4l2-core/v4l2-ioctl.c
> @@ -28,6 +28,9 @@
>  #include <media/v4l2-device.h>
>  #include <media/videobuf2-core.h>
>  
> +#define CREATE_TRACE_POINTS
> +#include <trace/events/v4l2.h>
> +
>  /* Zero out the end of the struct pointed to by p.  Everything after, but
>   * not including, the specified field is cleared. */
>  #define CLEAR_AFTER_FIELD(p, field) \
> @@ -2338,6 +2341,12 @@ video_usercopy(struct file *file, unsigned int cmd, unsigned long arg,
>  	err = func(file, cmd, parg);
>  	if (err == -ENOIOCTLCMD)
>  		err = -ENOTTY;
> +	if (err == 0) {
> +		if (cmd == VIDIOC_DQBUF)
> +			trace_v4l2_dqbuf(video_devdata(file)->minor, parg);
> +		else if (cmd == VIDIOC_QBUF)
> +			trace_v4l2_qbuf(video_devdata(file)->minor, parg);
> +	}
>  
>  	if (has_array_args) {
>  		*kernel_ptr = user_ptr;


-- 
Wade Farnsworth | Sr. Embedded Linux Dev. Engr.
Mentor Embedded™
Nucleus® | Linux® | Android™ | Services | UI | Multi-OS
Android is a trademark of Google Inc. Use of this trademark is subject
to Google Permissions.
Linux is the registered trademark of Linus Torvalds in the U.S. and
other countries

