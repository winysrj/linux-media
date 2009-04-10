Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:57108 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758871AbZDJLbo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 10 Apr 2009 07:31:44 -0400
Message-ID: <49DF2EBB.4020602@redhat.com>
Date: Fri, 10 Apr 2009 13:34:19 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Adam Baker <linux@baker-net.org.uk>
CC: linux-media@vger.kernel.org, Hans de Goede <j.w.r.degoede@hhs.nl>,
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

Thanks,

I've applied this to my tree, it will be part of the next libv4l
release.

Regards,

Hans

On 03/30/2009 12:28 AM, Adam Baker wrote:
> Add check to libv4l of the sensor orientation as reported by
> VIDIOC_ENUMINPUT
>
> Signed-off-by: Adam Baker<linux@baker-net.org.uk>
>
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
