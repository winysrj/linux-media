Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f176.google.com ([209.85.215.176]:65535 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992AbaAELGA (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 5 Jan 2014 06:06:00 -0500
Received: by mail-ea0-f176.google.com with SMTP id h14so7355926eaj.35
        for <linux-media@vger.kernel.org>; Sun, 05 Jan 2014 03:05:59 -0800 (PST)
Message-ID: <52C93CDB.1050202@googlemail.com>
Date: Sun, 05 Jan 2014 12:07:07 +0100
From: =?ISO-8859-15?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>, unlisted-recipients:;
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH v4 09/22] [media] tvp5150: make read operations atomic
References: <1388832951-11195-1-git-send-email-m.chehab@samsung.com> <1388832951-11195-10-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1388832951-11195-10-git-send-email-m.chehab@samsung.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 04.01.2014 11:55, schrieb Mauro Carvalho Chehab:
> Instead of using two I2C operations between write and read,
> use just one i2c_transfer. That allows I2C mutexes to not
> let any other I2C transfer between the two.
>
> Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
> ---
>  drivers/media/i2c/tvp5150.c | 26 +++++++++++---------------
>  1 file changed, 11 insertions(+), 15 deletions(-)
>
> diff --git a/drivers/media/i2c/tvp5150.c b/drivers/media/i2c/tvp5150.c
> index 89c0b13463b7..2ed05b67218b 100644
> --- a/drivers/media/i2c/tvp5150.c
> +++ b/drivers/media/i2c/tvp5150.c
> @@ -58,21 +58,17 @@ static int tvp5150_read(struct v4l2_subdev *sd, unsigned char addr)
>  	struct i2c_client *c = v4l2_get_subdevdata(sd);
>  	unsigned char buffer[1];
>  	int rc;
> -
> -	buffer[0] = addr;
> -
> -	rc = i2c_master_send(c, buffer, 1);
> -	if (rc < 0) {
> -		v4l2_err(sd, "i2c i/o error: rc == %d (should be 1)\n", rc);
> -		return rc;
> -	}
> -
> -	msleep(10);
> -
> -	rc = i2c_master_recv(c, buffer, 1);
> -	if (rc < 0) {
> -		v4l2_err(sd, "i2c i/o error: rc == %d (should be 1)\n", rc);
> -		return rc;
> +	struct i2c_msg msg[] = {
> +		{ .addr = c->addr, .flags = 0,
> +		  .buf = &addr, .len = 1 },
> +		{ .addr = c->addr, .flags = I2C_M_RD,
> +		  .buf = buffer, .len = 1 }
> +	};
> +
> +	rc = i2c_transfer(c->adapter, msg, 2);
> +	if (rc < 0 || rc != 2) {
> +		v4l2_err(sd, "i2c i/o error: rc == %d (should be 2)\n", rc);
> +		return rc < 0 ? rc : -EIO;
>  	}
>  
>  	v4l2_dbg(2, debug, sd, "tvp5150: read 0x%02x = 0x%02x\n", addr, buffer[0]);

Reviewed-by: Frank Schäfer <fschaefer.oss@googlemail.com>
Tested-by: Frank Schäfer <fschaefer.oss@googlemail.com>


