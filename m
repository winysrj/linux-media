Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f206.google.com ([209.85.219.206]:51805 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752878AbZIJHWv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Sep 2009 03:22:51 -0400
Received: by ewy2 with SMTP id 2so103920ewy.17
        for <linux-media@vger.kernel.org>; Thu, 10 Sep 2009 00:22:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090909172938.56cf7105@blackbart.localnet.prv>
References: <20090909172938.56cf7105@blackbart.localnet.prv>
Date: Thu, 10 Sep 2009 09:22:53 +0200
Message-ID: <62e5edd40909100022n4f7e7a26g80de514e2c292e5@mail.gmail.com>
Subject: Re: [Patch 1/2] stv06xx webcams with HDCS 1xxx sensors
From: =?ISO-8859-1?Q?Erik_Andr=E9n?= <erik.andren@gmail.com>
To: James Blanford <jhblanford@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

2009/9/9 James Blanford <jhblanford@gmail.com>:
> Quickcam Express 046d:0840 and maybe others
>
> Driver version:  v 2.60 from 2.6.31-rc7
>
> Initialize image size before it's used to initialize exposure.
> Work around lack of exposure set hardware latch with a sequence of
> register writes in a single I2C command packet.
>
> Signed-off-by: James Blanford <jhblanford@gmail.com>
> --- a/drivers/media/video/gspca/stv06xx/stv06xx_hdcs.c  2009-09-01 09:45:42.000000000 -0400
> +++ b/drivers/media/video/gspca/stv06xx/stv06xx_hdcs.c  2009-09-09 14:59:35.000000000 -0400
> @@ -252,7 +252,7 @@ static int hdcs_set_exposure(struct gspc
>           within the column processing period */
>        int mnct;
>        int cycles, err;
> -       u8 exp[4];
> +       u8 exp[14];
>
>        cycles = val * HDCS_CLK_FREQ_MHZ;
>
> @@ -288,24 +288,37 @@ static int hdcs_set_exposure(struct gspc
>                srowexp = max_srowexp;
>
>        if (IS_1020(sd)) {
> -               exp[0] = rowexp & 0xff;
> -               exp[1] = rowexp >> 8;
> -               exp[2] = (srowexp >> 2) & 0xff;
> -               /* this clears exposure error flag */
> -               exp[3] = 0x1;
> -               err = hdcs_reg_write_seq(sd, HDCS_ROWEXPL, exp, 4);
> +               exp[0] = HDCS20_CONTROL;
> +               exp[1] = 0x00;          /* Stop streaming */
> +               exp[2] = HDCS_ROWEXPL;
> +               exp[3] = rowexp & 0xff;
> +               exp[4] = HDCS_ROWEXPH;
> +               exp[5] = rowexp >> 8;
> +               exp[6] = HDCS20_SROWEXP;
> +               exp[7] = (srowexp >> 2) & 0xff;
> +               exp[8] = HDCS20_ERROR;
> +               exp[9] = 0x10;          /* Clear exposure error flag*/
> +               exp[10] = HDCS20_CONTROL;
> +               exp[11] = 0x04;         /* Restart streaming */
> +               err = stv06xx_write_sensor_bytes(sd, exp, 6);
>        } else {
> -               exp[0] = rowexp & 0xff;
> -               exp[1] = rowexp >> 8;
> -               exp[2] = srowexp & 0xff;
> -               exp[3] = srowexp >> 8;
> -               err = hdcs_reg_write_seq(sd, HDCS_ROWEXPL, exp, 4);
> +               exp[0] = HDCS00_CONTROL;
> +               exp[1] = 0x00;         /* Stop streaming */
> +               exp[2] = HDCS_ROWEXPL;
> +               exp[3] = rowexp & 0xff;
> +               exp[4] = HDCS_ROWEXPH;
> +               exp[5] = rowexp >> 8;
> +               exp[6] = HDCS00_SROWEXPL;
> +               exp[7] = srowexp & 0xff;
> +               exp[8] = HDCS00_SROWEXPH;
> +               exp[9] = srowexp >> 8;
> +               exp[10] = HDCS_STATUS;
> +               exp[11] = 0x10;         /* Clear exposure error flag*/
> +               exp[12] = HDCS00_CONTROL;
> +               exp[13] = 0x04;         /* Restart streaming */
> +               err = stv06xx_write_sensor_bytes(sd, exp, 7);
>                if (err < 0)
>                        return err;
> -
> -               /* clear exposure error flag */
> -               err = stv06xx_write_sensor(sd,
> -                    HDCS_STATUS, BIT(4));
>        }
>        PDEBUG(D_V4L2, "Writing exposure %d, rowexp %d, srowexp %d",
>               val, rowexp, srowexp);
> @@ -577,11 +590,11 @@ static int hdcs_init(struct sd *sd)
>        if (err < 0)
>                return err;
>
> -       err = hdcs_set_exposure(&sd->gspca_dev, HDCS_DEFAULT_EXPOSURE);
> +       err = hdcs_set_size(sd, hdcs->array.width, hdcs->array.height);
>        if (err < 0)
>                return err;
>
> -       err = hdcs_set_size(sd, hdcs->array.width, hdcs->array.height);
> +       err = hdcs_set_exposure(&sd->gspca_dev, HDCS_DEFAULT_EXPOSURE);
>        return err;
>  }
>
>

I don't have the hardware to test this, but looks good to me.
Thanks,
Acked-by: Erik Andrén <erik.andren@gmail.com>
