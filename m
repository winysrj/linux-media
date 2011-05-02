Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:31838 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751793Ab1EBQjD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 2 May 2011 12:39:03 -0400
Message-ID: <4DBEDE24.2040808@redhat.com>
Date: Mon, 02 May 2011 13:39:00 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Sensoray Linux Development <linux-dev@sensoray.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 2/2] [media] s2255drv: jpeg enable module parameter
References: <4D9A0C87.40309@sensoray.com>
In-Reply-To: <4D9A0C87.40309@sensoray.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 04-04-2011 15:23, Sensoray Linux Development escreveu:
> Adding jpeg enable module parameter.

This one has also some bad whitespacing.

I've applied both. Please next time, double check it before sending me a patch.

Thanks,
Mauro
> 
> Signed-off-by: Dean Anderson <linux-dev@sensoray.com>
> 
> ---
>  drivers/media/video/s2255drv.c |   21 ++++++++++++++++-----
>  1 files changed, 16 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/media/video/s2255drv.c b/drivers/media/video/s2255drv.c
> index 38e5c4b..eb33e1e 100644
> --- a/drivers/media/video/s2255drv.c
> +++ b/drivers/media/video/s2255drv.c
> @@ -389,12 +389,17 @@ static unsigned int vid_limit = 16;    /* Video memory limit, in Mb */
>  /* start video number */
>  static int video_nr = -1;    /* /dev/videoN, -1 for autodetect */
>  
> +/* Enable jpeg capture. */
> +static int jpeg_enable = 1;
> +
>  module_param(debug, int, 0644);
>  MODULE_PARM_DESC(debug, "Debug level(0-100) default 0");
>  module_param(vid_limit, int, 0644);
>  MODULE_PARM_DESC(vid_limit, "video memory limit(Mb)");
>  module_param(video_nr, int, 0644);
>  MODULE_PARM_DESC(video_nr, "start video minor(-1 default autodetect)");
> +module_param(jpeg_enable, int, 0644);
> +MODULE_PARM_DESC(jpeg_enable, "Jpeg enable(1-on 0-off) default 1");
>  
>  /* USB device table */
>  #define USB_SENSORAY_VID    0x1943
> @@ -408,6 +413,7 @@ MODULE_DEVICE_TABLE(usb, s2255_table);
>  #define BUFFER_TIMEOUT msecs_to_jiffies(400)
>  
>  /* image formats.  */
> +/* JPEG formats must be defined last to support jpeg_enable parameter */
>  static const struct s2255_fmt formats[] = {
>      {
>          .name = "4:2:2, planar, YUV422P",
> @@ -424,6 +430,10 @@ static const struct s2255_fmt formats[] = {
>          .fourcc = V4L2_PIX_FMT_UYVY,
>          .depth = 16
>      }, {
> +        .name = "8bpp GREY",
> +        .fourcc = V4L2_PIX_FMT_GREY,
> +        .depth = 8
> +    }, {
>          .name = "JPG",
>          .fourcc = V4L2_PIX_FMT_JPEG,
>          .depth = 24
> @@ -431,10 +441,6 @@ static const struct s2255_fmt formats[] = {
>          .name = "MJPG",
>          .fourcc = V4L2_PIX_FMT_MJPEG,
>          .depth = 24
> -    }, {
> -        .name = "8bpp GREY",
> -        .fourcc = V4L2_PIX_FMT_GREY,
> -        .depth = 8
>      }
>  };
>  
> @@ -609,6 +615,9 @@ static const struct s2255_fmt *format_by_fourcc(int fourcc)
>      for (i = 0; i < ARRAY_SIZE(formats); i++) {
>          if (-1 == formats[i].fourcc)
>              continue;
> +        if (!jpeg_enable && ((formats[i].fourcc == V4L2_PIX_FMT_JPEG) ||
> +                     (formats[i].fourcc == V4L2_PIX_FMT_MJPEG)))
> +            continue;
>          if (formats[i].fourcc == fourcc)
>              return formats + i;
>      }
> @@ -856,7 +865,9 @@ static int vidioc_enum_fmt_vid_cap(struct file *file, void *priv,
>  
>      if (index >= ARRAY_SIZE(formats))
>          return -EINVAL;
> -
> +    if (!jpeg_enable && ((formats[index].fourcc == V4L2_PIX_FMT_JPEG) ||
> +                 (formats[index].fourcc == V4L2_PIX_FMT_MJPEG)))
> +        return -EINVAL;
>      dprintk(4, "name %s\n", formats[index].name);
>      strlcpy(f->description, formats[index].name, sizeof(f->description));
>      f->pixelformat = formats[index].fourcc;

