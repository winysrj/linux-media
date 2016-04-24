Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:37265 "EHLO
	mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbcDXVDf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 24 Apr 2016 17:03:35 -0400
MIME-Version: 1.0
In-Reply-To: <1460682008-17168-1-git-send-email-javier@osg.samsung.com>
References: <1460682008-17168-1-git-send-email-javier@osg.samsung.com>
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date: Sun, 24 Apr 2016 22:03:04 +0100
Message-ID: <CA+V-a8vzCktpXVWq44bZHJiYRe3zPpFhhgVSkk4-tZAxek4gXg@mail.gmail.com>
Subject: Re: [PATCH 1/2] [media] tvp5150: return I2C write operation failure
 to callers
To: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Apr 15, 2016 at 2:00 AM, Javier Martinez Canillas
<javier@osg.samsung.com> wrote:
> The tvp5150_write() function calls i2c_smbus_write_byte_data() that
> can fail but does not propagate the error to the caller. Instead it
> just prints a debug, so callers can't know if the operation failed.
>
> So change the function to return the error code to the caller so it
> knows that the write failed and also print an error instead of just
> printing a debug information.
>
> While being there remove the inline keyword from tvp5150_write() to
> make it consistent with tvp5150_read() and also because it's called
> in a lot of places, so making inline is in fact counter productive
> since it makes the kernel image size to be much bigger (~16 KiB).
>
> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Cheers,
--Prabhakar Lad

> ---
>
>  drivers/media/i2c/tvp5150.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
> index e5003d94f262..4a2e851b6a3b 100644
> --- a/drivers/media/i2c/tvp5150.c
> +++ b/drivers/media/i2c/tvp5150.c
> @@ -83,7 +83,7 @@ static int tvp5150_read(struct v4l2_subdev *sd, unsigned char addr)
>         return rc;
>  }
>
> -static inline void tvp5150_write(struct v4l2_subdev *sd, unsigned char addr,
> +static int tvp5150_write(struct v4l2_subdev *sd, unsigned char addr,
>                                  unsigned char value)
>  {
>         struct i2c_client *c = v4l2_get_subdevdata(sd);
> @@ -92,7 +92,9 @@ static inline void tvp5150_write(struct v4l2_subdev *sd, unsigned char addr,
>         v4l2_dbg(2, debug, sd, "tvp5150: writing 0x%02x 0x%02x\n", addr, value);
>         rc = i2c_smbus_write_byte_data(c, addr, value);
>         if (rc < 0)
> -               v4l2_dbg(0, debug, sd, "i2c i/o error: rc == %d\n", rc);
> +               v4l2_err(sd, "i2c i/o error: rc == %d\n", rc);
> +
> +       return rc;
>  }
>
>  static void dump_reg_range(struct v4l2_subdev *sd, char *s, u8 init,
> --
> 2.5.5
>
