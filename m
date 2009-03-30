Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2.versatel.nl ([62.58.50.89]:33150 "EHLO smtp2.versatel.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752323AbZC3I2Y (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Mar 2009 04:28:24 -0400
Message-ID: <49D0831E.4090707@hhs.nl>
Date: Mon, 30 Mar 2009 10:30:22 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Adam Baker <linux@baker-net.org.uk>
CC: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jean-Francois Moine <moinejf@free.fr>,
	kilgota@banach.math.auburn.edu, Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH v2 4/4] Add support to libv4l to use orientation from
 VIDIOC_ENUMINPUT
References: <200903292309.31267.linux@baker-net.org.uk> <200903292322.08660.linux@baker-net.org.uk> <200903292325.16499.linux@baker-net.org.uk> <200903292328.09957.linux@baker-net.org.uk>
In-Reply-To: <200903292328.09957.linux@baker-net.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/30/2009 12:28 AM, Adam Baker wrote:
> Add check to libv4l of the sensor orientation as reported by
> VIDIOC_ENUMINPUT
>
> Signed-off-by: Adam Baker<linux@baker-net.org.uk>
>

Looks good, thanks. I'll apply this to my libv4l tree, as soon
as its certain that the matching kernel changes will go in to
the kernel without any API changes.

Thanks & Regards,

Hans

> ---
> diff -r a647c2dfa989 v4l2-apps/lib/libv4l/libv4lconvert/libv4lconvert.c
> --- a/v4l2-apps/lib/libv4l/libv4lconvert/libv4lconvert.c	Tue Jan 20 11:25:54 2009 +0100
> +++ b/v4l2-apps/lib/libv4l/libv4lconvert/libv4lconvert.c	Sun Mar 29 22:59:56 2009 +0100
> @@ -29,6 +29,11 @@
>   #define MIN(a,b) (((a)<(b))?(a):(b))
>   #define ARRAY_SIZE(x) ((int)sizeof(x)/(int)sizeof((x)[0]))
>
> +/* Workaround this potentially being missing from videodev2.h */
> +#ifndef V4L2_IN_ST_VFLIP
> +#define V4L2_IN_ST_VFLIP       0x00000020 /* Output is flipped vertically */
> +#endif
> +
>   /* Note for proper functioning of v4lconvert_enum_fmt the first entries in
>     supported_src_pixfmts must match with the entries in supported_dst_pixfmts */
>   #define SUPPORTED_DST_PIXFMTS \
> @@ -134,6 +139,7 @@
>     int i, j;
>     struct v4lconvert_data *data = calloc(1, sizeof(struct v4lconvert_data));
>     struct v4l2_capability cap;
> +  struct v4l2_input input;
>
>     if (!data)
>       return NULL;
> @@ -161,6 +167,13 @@
>
>     /* Check if this cam has any special flags */
>     data->flags = v4lconvert_get_flags(data->fd);
> +  if ((syscall(SYS_ioctl, fd, VIDIOC_G_INPUT,&input.index) == 0)&&
> +      (syscall(SYS_ioctl, fd, VIDIOC_ENUMINPUT,&input) == 0)) {
> +    /* Don't yet support independent HFLIP and VFLIP so getting
> +     * image the right way up is highest priority. */
> +    if (input.status&  V4L2_IN_ST_VFLIP)
> +      data->flags |= V4LCONVERT_ROTATE_180;
> +  }
>     if (syscall(SYS_ioctl, fd, VIDIOC_QUERYCAP,&cap) == 0) {
>       if (!strcmp((char *)cap.driver, "uvcvideo"))
>         data->flags |= V4LCONVERT_IS_UVC;
>
>

