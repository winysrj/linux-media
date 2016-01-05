Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:36038 "EHLO
	mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631AbcAERcw (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Jan 2016 12:32:52 -0500
MIME-Version: 1.0
In-Reply-To: <1450706086-6801-1-git-send-email-grygorii.strashko@ti.com>
References: <1450706086-6801-1-git-send-email-grygorii.strashko@ti.com>
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Date: Tue, 5 Jan 2016 17:32:21 +0000
Message-ID: <CA+V-a8v-STaDCcpVLm3XkZHrH-JQfZfm7L2R+86myx=v1+0x+A@mail.gmail.com>
Subject: Re: [PATCH] media: i2c: ov2659: speedup probe if no device connected
To: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media <linux-media@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Benoit Parrot <bparrot@ti.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Dec 21, 2015 at 1:54 PM, Grygorii Strashko
<grygorii.strashko@ti.com> wrote:
> The ov2659 driver performs device detection and initialization in the
> following way:
>  - send reset command REG_SOFTWARE_RESET
>  - load array of predefined register's setting (~150 values)
>  - read device version REG_SC_CHIP_ID_H/REG_SC_CHIP_ID_L
>  - check version and exit if invalid.
>
> As result, for not connected device there will be >~150 i2c transactions
> executed before device version checking and exit (there are no
> failures detected because ov2659 declared as I2C_CLIENT_SCCB and NACKs
> are ignored in this case).
>
> Let's fix that by checking the chip version first and start
> initialization only if it's supported.
>
> Cc: Benoit Parrot <bparrot@ti.com>
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>

Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Cheers,
--Prabhakar Lad

> ---
>  drivers/media/i2c/ov2659.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/media/i2c/ov2659.c b/drivers/media/i2c/ov2659.c
> index 49109f4..9b7b78c 100644
> --- a/drivers/media/i2c/ov2659.c
> +++ b/drivers/media/i2c/ov2659.c
> @@ -1321,10 +1321,6 @@ static int ov2659_detect(struct v4l2_subdev *sd)
>         }
>         usleep_range(1000, 2000);
>
> -       ret = ov2659_init(sd, 0);
> -       if (ret < 0)
> -               return ret;
> -
>         /* Check sensor revision */
>         ret = ov2659_read(client, REG_SC_CHIP_ID_H, &pid);
>         if (!ret)
> @@ -1338,8 +1334,10 @@ static int ov2659_detect(struct v4l2_subdev *sd)
>                         dev_err(&client->dev,
>                                 "Sensor detection failed (%04X, %d)\n",
>                                 id, ret);
> -               else
> +               else {
>                         dev_info(&client->dev, "Found OV%04X sensor\n", id);
> +                       ret = ov2659_init(sd, 0);
> +               }
>         }
>
>         return ret;
> --
> 2.6.4
>
