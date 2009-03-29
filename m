Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr17.xs4all.nl ([194.109.24.37]:2847 "EHLO
	smtp-vbr17.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbZC2JGZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Mar 2009 05:06:25 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org,
	Trent Piepho via Mercurial <xyzzy@speakeasy.org>
Subject: Re: [linuxtv-commits] [hg:v4l-dvb] v4l2-ioctl: Check format for S_PARM and G_PARM
Date: Sun, 29 Mar 2009 11:06:19 +0200
References: <E1LnqiQ-00077f-80@mail.linuxtv.org>
In-Reply-To: <E1LnqiQ-00077f-80@mail.linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903291106.19466.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sunday 29 March 2009 10:50:02 Patch from Trent Piepho wrote:
> The patch number 11260 was added via Trent Piepho <xyzzy@speakeasy.org>
> to http://linuxtv.org/hg/v4l-dvb master development tree.
>
> Kernel patches in this development tree may be modified to be backward
> compatible with older kernels. Compatibility modifications will be
> removed before inclusion into the mainstream Kernel
>
> If anyone has any objections, please let us know by sending a message to:
> 	Linux Media Mailing List <linux-media@vger.kernel.org>
>
> ------
>
> From: Trent Piepho  <xyzzy@speakeasy.org>
> v4l2-ioctl:  Check format for S_PARM and G_PARM
>
>
> Return EINVAL if VIDIOC_S/G_PARM is called for a buffer type that the
> driver doesn't define a ->vidioc_try_fmt_XXX() method for.  Several other
> ioctls, like QUERYBUF, QBUF, and DQBUF, etc.  do this too.  It saves each
> driver from having to check if the buffer type is one that it supports.

Hi Trent,

I wonder whether this change is correct. Looking at the spec I see that 
g/s_parm only supports VIDEO_CAPTURE, VIDEO_OUTPUT and PRIVATE or up.

So what should happen if the type is VIDEO_OVERLAY? I think the g/s_parm 
implementation in v4l2-ioctl.c should first exclude the unsupported types 
before calling check_fmt.

I also wonder whether check_fmt shouldn't check for the presence of the 
s_fmt callbacks instead of try_fmt since try_fmt is an optional ioctl.

Regards,

	Hans

>
> Priority: normal
>
> Signed-off-by: Trent Piepho <xyzzy@speakeasy.org>
>
>
> ---
>
>  linux/drivers/media/video/v4l2-ioctl.c |    7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff -r 346bab8698ea -r 44632c5fe5b2
> linux/drivers/media/video/v4l2-ioctl.c ---
> a/linux/drivers/media/video/v4l2-ioctl.c	Sat Mar 28 18:25:35 2009 -0700
> +++ b/linux/drivers/media/video/v4l2-ioctl.c	Sat Mar 28 18:25:35 2009
> -0700 @@ -1552,6 +1552,9 @@ static long __video_do_ioctl(struct file
>  		struct v4l2_streamparm *p = arg;
>
>  		if (ops->vidioc_g_parm) {
> +			ret = check_fmt(ops, p->type);
> +			if (ret)
> +				break;
>  			ret = ops->vidioc_g_parm(file, fh, p);
>  		} else {
>  			if (p->type != V4L2_BUF_TYPE_VIDEO_CAPTURE)
> @@ -1571,6 +1574,10 @@ static long __video_do_ioctl(struct file
>
>  		if (!ops->vidioc_s_parm)
>  			break;
> +		ret = check_fmt(ops, p->type);
> +		if (ret)
> +			break;
> +
>  		dbgarg(cmd, "type=%d\n", p->type);
>  		ret = ops->vidioc_s_parm(file, fh, p);
>  		break;
>
>
> ---
>
> Patch is available at:
> http://linuxtv.org/hg/v4l-dvb/rev/44632c5fe5b2cd973c75501a88d61b43a39f6c4
>3
>
> _______________________________________________
> linuxtv-commits mailing list
> linuxtv-commits@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linuxtv-commits



-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
