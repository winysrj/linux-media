Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:62954 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124AbaHPKFu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Aug 2014 06:05:50 -0400
Received: by mail-we0-f182.google.com with SMTP id k48so3206331wev.27
        for <linux-media@vger.kernel.org>; Sat, 16 Aug 2014 03:05:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1408172250.9865.3.camel@phoenix>
References: <1408172250.9865.3.camel@phoenix>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Sat, 16 Aug 2014 11:05:18 +0100
Message-ID: <CA+V-a8vTCb9D494FyzgheobJq4qy+c0NW5Ey3L7_NHYiF-s+mQ@mail.gmail.com>
Subject: Re: [PATCH] [media] tvp7002: Don't update device->streaming if write
 to register fails
To: Axel Lin <axel.lin@ingics.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Axel,

Thanks for the patch!

On Sat, Aug 16, 2014 at 7:57 AM, Axel Lin <axel.lin@ingics.com> wrote:
> This ensures device->streaming has correct status.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Acked-By: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Regards,
--Prabhakar Lad

> ---
>  drivers/media/i2c/tvp7002.c | 21 ++++++++-------------
>  1 file changed, 8 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/media/i2c/tvp7002.c b/drivers/media/i2c/tvp7002.c
> index 11f2387..51bac76 100644
> --- a/drivers/media/i2c/tvp7002.c
> +++ b/drivers/media/i2c/tvp7002.c
> @@ -775,25 +775,20 @@ static int tvp7002_enum_mbus_fmt(struct v4l2_subdev *sd, unsigned index,
>  static int tvp7002_s_stream(struct v4l2_subdev *sd, int enable)
>  {
>         struct tvp7002 *device = to_tvp7002(sd);
> -       int error = 0;
> +       int error;
>
>         if (device->streaming == enable)
>                 return 0;
>
> -       if (enable) {
> -               /* Set output state on (low impedance means stream on) */
> -               error = tvp7002_write(sd, TVP7002_MISC_CTL_2, 0x00);
> -               device->streaming = enable;
> -       } else {
> -               /* Set output state off (high impedance means stream off) */
> -               error = tvp7002_write(sd, TVP7002_MISC_CTL_2, 0x03);
> -               if (error)
> -                       v4l2_dbg(1, debug, sd, "Unable to stop streaming\n");
> -
> -               device->streaming = enable;
> +       /* low impedance: on, high impedance: off */
> +       error = tvp7002_write(sd, TVP7002_MISC_CTL_2, enable ? 0x00 : 0x03);
> +       if (error) {
> +               v4l2_dbg(1, debug, sd, "Fail to set streaming\n");
> +               return error;
>         }
>
> -       return error;
> +       device->streaming = enable;
> +       return 0;
>  }
>
>  /*
> --
> 1.9.1
>
>
>
