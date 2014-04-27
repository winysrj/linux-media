Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:55927 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386AbaD0SvE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Apr 2014 14:51:04 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH v2] V4L2: fix VIDIOC_CREATE_BUFS in 64- / 32-bit compatibility mode
Date: Sun, 27 Apr 2014 20:51:14 +0200
Message-ID: <9390328.OxhPIEtXXa@avalon>
In-Reply-To: <Pine.LNX.4.64.1404261745450.21367@axis700.grange>
References: <Pine.LNX.4.64.1404261745450.21367@axis700.grange>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

Thank you for the patch.

On Saturday 26 April 2014 17:51:31 Guennadi Liakhovetski wrote:
> If a struct contains 64-bit fields, it is aligned on 64-bit boundaries
> within containing structs in 64-bit compilations. This is the case with
> struct v4l2_window, which contains pointers and is embedded into struct
> v4l2_format, and that one is embedded into struct v4l2_create_buffers.
> Unlike some other structs, used as a part of the kernel ABI as ioctl()
> arguments, that are packed, these structs aren't packed. This isn't a
> problem per se, but the ioctl-compat code for VIDIOC_CREATE_BUFS contains
> a bug, that triggers in such 64-bit builds. That code wrongly assumes,
> that in struct v4l2_create_buffers, struct v4l2_format immediately follows
> the __u32 memory field, which in fact isn't the case. This bug wasn't
> visible until now, because until recently hardly any applications used
> this ioctl() and mostly embedded 32-bit only drivers implemented it. This
> is changing now with addition of this ioctl() to some USB drivers, e.g.
> UVC. This patch fixes the bug by copying parts of struct
> v4l2_create_buffers separately.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

While you're at it, could you fix put_v4l2_format32() and put_v4l2_create32() 
?

> ---
> 
> v2:
> 1. improved patch description
> 2. moved the get_user() check inside __get_v4l2_format32()
> 
> Thanks to Laurent for suggestions
> 
>  drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c index 04b2daf..7e2411c
> 100644
> --- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> +++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
> @@ -178,6 +178,9 @@ struct v4l2_create_buffers32 {
> 
>  static int __get_v4l2_format32(struct v4l2_format *kp, struct v4l2_format32
> __user *up) {
> +	if (get_user(kp->type, &up->type))
> +		return -EFAULT;
> +
>  	switch (kp->type) {
>  	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
>  	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
> @@ -204,17 +207,16 @@ static int __get_v4l2_format32(struct v4l2_format *kp,
> struct v4l2_format32 __us
> 
>  static int get_v4l2_format32(struct v4l2_format *kp, struct v4l2_format32
> __user *up) {
> -	if (!access_ok(VERIFY_READ, up, sizeof(struct v4l2_format32)) ||
> -			get_user(kp->type, &up->type))
> -			return -EFAULT;
> +	if (!access_ok(VERIFY_READ, up, sizeof(struct v4l2_format32)))
> +		return -EFAULT;
>  	return __get_v4l2_format32(kp, up);
>  }
> 
>  static int get_v4l2_create32(struct v4l2_create_buffers *kp, struct
> v4l2_create_buffers32 __user *up) {
>  	if (!access_ok(VERIFY_READ, up, sizeof(struct v4l2_create_buffers32)) ||
> -	    copy_from_user(kp, up, offsetof(struct v4l2_create_buffers32,
> format.fmt)))
> -			return -EFAULT;
> +	    copy_from_user(kp, up, offsetof(struct v4l2_create_buffers32,
> format)))
> +		return -EFAULT;
>  	return __get_v4l2_format32(&kp->format, &up->format);
>  }

-- 
Regards,

Laurent Pinchart

