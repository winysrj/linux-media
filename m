Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:63792 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756206Ab0ERMuZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 18 May 2010 08:50:25 -0400
Date: Tue, 18 May 2010 15:55:27 +0300
From: Eduardo Valentin <eduardo.valentin@nokia.com>
To: ext Jarkko Nikula <jhnikula@gmail.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Valentin Eduardo (Nokia-D/Helsinki)" <eduardo.valentin@nokia.com>
Subject: Re: [PATCH] si4713: Fix oops when si4713_platform_data is marked
 as __initdata
Message-ID: <20100518125527.GB4265@besouro.research.nokia.com>
Reply-To: eduardo.valentin@nokia.com
References: <1274029466-17456-1-git-send-email-jhnikula@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274029466-17456-1-git-send-email-jhnikula@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Sun, May 16, 2010 at 07:04:26PM +0200, Jarkko Nikula wrote:
> This driver can cause an oops if si4713_platform_data holding pointer to
> set_power function is marked as __initdata and when trying to power up the
> chip after booting e.g. with 'v4l2-ctl -d /dev/radio0 --set-ctrl=mute=0'.
> 
> This happens because the sdev->platform_data doesn't point to valid data
> anymore after kernel is initialized.
> 
> Fix this by taking local copy of si4713_platform_data->set_power. Add also
> NULL check for this function pointer.

I'm probably fine with this patch, and the driver must check for the pointer
before using it, indeed.

But, I'm a bit skeptic about marking its platform data as __initdata. Would it make sense?
What happens if driver is built as module and loaded / unload / loaded again?

Maybe the initdata flag does not apply in this case. Not sure (and not tested the above case).

BR,

> 
> Signed-off-by: Jarkko Nikula <jhnikula@gmail.com>
> Cc: Eduardo Valentin <eduardo.valentin@nokia.com>
> ---
>  drivers/media/radio/si4713-i2c.c |   15 +++++++++------
>  drivers/media/radio/si4713-i2c.h |    2 +-
>  2 files changed, 10 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/media/radio/si4713-i2c.c b/drivers/media/radio/si4713-i2c.c
> index ab63dd5..cf9858d 100644
> --- a/drivers/media/radio/si4713-i2c.c
> +++ b/drivers/media/radio/si4713-i2c.c
> @@ -369,7 +369,8 @@ static int si4713_powerup(struct si4713_device *sdev)
>  	if (sdev->power_state)
>  		return 0;
>  
> -	sdev->platform_data->set_power(1);
> +	if (sdev->set_power)
> +		sdev->set_power(1);
>  	err = si4713_send_command(sdev, SI4713_CMD_POWER_UP,
>  					args, ARRAY_SIZE(args),
>  					resp, ARRAY_SIZE(resp),
> @@ -383,8 +384,8 @@ static int si4713_powerup(struct si4713_device *sdev)
>  
>  		err = si4713_write_property(sdev, SI4713_GPO_IEN,
>  						SI4713_STC_INT | SI4713_CTS);
> -	} else {
> -		sdev->platform_data->set_power(0);
> +	} else if (sdev->set_power) {
> +		sdev->set_power(0);
>  	}
>  
>  	return err;
> @@ -411,7 +412,8 @@ static int si4713_powerdown(struct si4713_device *sdev)
>  		v4l2_dbg(1, debug, &sdev->sd, "Power down response: 0x%02x\n",
>  				resp[0]);
>  		v4l2_dbg(1, debug, &sdev->sd, "Device in reset mode\n");
> -		sdev->platform_data->set_power(0);
> +		if (sdev->set_power)
> +			sdev->set_power(0);
>  		sdev->power_state = POWER_OFF;
>  	}
>  
> @@ -1959,6 +1961,7 @@ static int si4713_probe(struct i2c_client *client,
>  					const struct i2c_device_id *id)
>  {
>  	struct si4713_device *sdev;
> +	struct si4713_platform_data *pdata = client->dev.platform_data;
>  	int rval;
>  
>  	sdev = kzalloc(sizeof *sdev, GFP_KERNEL);
> @@ -1968,12 +1971,12 @@ static int si4713_probe(struct i2c_client *client,
>  		goto exit;
>  	}
>  
> -	sdev->platform_data = client->dev.platform_data;
> -	if (!sdev->platform_data) {
> +	if (!pdata) {
>  		v4l2_err(&sdev->sd, "No platform data registered.\n");
>  		rval = -ENODEV;
>  		goto free_sdev;
>  	}
> +	sdev->set_power = pdata->set_power;
>  
>  	v4l2_i2c_subdev_init(&sdev->sd, client, &si4713_subdev_ops);
>  
> diff --git a/drivers/media/radio/si4713-i2c.h b/drivers/media/radio/si4713-i2c.h
> index faf8cff..d1af889 100644
> --- a/drivers/media/radio/si4713-i2c.h
> +++ b/drivers/media/radio/si4713-i2c.h
> @@ -220,7 +220,7 @@ struct si4713_device {
>  	/* private data structures */
>  	struct mutex mutex;
>  	struct completion work;
> -	struct si4713_platform_data *platform_data;
> +	int (*set_power)(int power);
>  	struct rds_info rds_info;
>  	struct limiter_info limiter_info;
>  	struct pilot_info pilot_info;
> -- 
> 1.7.1
