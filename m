Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w2.samsung.com ([211.189.100.13]:10735 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754744Ab3LCPfV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 3 Dec 2013 10:35:21 -0500
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by usmailout3.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MX8000BILYWSY10@usmailout3.samsung.com> for
 linux-media@vger.kernel.org; Tue, 03 Dec 2013 10:35:20 -0500 (EST)
Date: Tue, 03 Dec 2013 13:35:14 -0200
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Dinesh Ram <dinesh.ram@cern.ch>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
	edubezval@gmail.com, dinesh.ram086@gmail.com
Subject: Re: [REVIEW PATCH 2/9] si4713 : Modified i2c driver to handle cases
 where interrupts are not used
Message-id: <20131203133514.4a4da7d1.m.chehab@samsung.com>
In-reply-to: <2f90947b4ca40f9a5c6d87cecd7bc0b7a5f27d22.1381850640.git.dinesh.ram@cern.ch>
References: <1e0bb141e349db9335a7d874cb3d900ec5837c66.1381850640.git.dinesh.ram@cern.ch>
 <2f90947b4ca40f9a5c6d87cecd7bc0b7a5f27d22.1381850640.git.dinesh.ram@cern.ch>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 15 Oct 2013 17:24:38 +0200
Dinesh Ram <dinesh.ram@cern.ch> escreveu:

> Checks have been introduced at several places in the code to test if an interrupt is set or not.
> For devices which do not use the interrupt, to get a valid response, within a specified timeout,
> the device is polled instead.
> 
> Signed-off-by: Dinesh Ram <dinesh.ram@cern.ch>
> ---
>  drivers/media/radio/si4713/si4713.c |  108 +++++++++++++++++++++--------------
>  1 file changed, 64 insertions(+), 44 deletions(-)
> 
> diff --git a/drivers/media/radio/si4713/si4713.c b/drivers/media/radio/si4713/si4713.c
> index ac727e3..24ae41d 100644
> --- a/drivers/media/radio/si4713/si4713.c
> +++ b/drivers/media/radio/si4713/si4713.c
> @@ -27,11 +27,11 @@
>  #include <linux/i2c.h>
>  #include <linux/slab.h>
>  #include <linux/gpio.h>
> -#include <linux/regulator/consumer.h>
>  #include <linux/module.h>
>  #include <media/v4l2-device.h>
>  #include <media/v4l2-ioctl.h>
>  #include <media/v4l2-common.h>
> +#include <linux/regulator/consumer.h>
>  
>  #include "si4713.h"
>  
> @@ -213,6 +213,7 @@ static int si4713_send_command(struct si4713_device *sdev, const u8 command,
>  				u8 response[], const int respn, const int usecs)
>  {
>  	struct i2c_client *client = v4l2_get_subdevdata(&sdev->sd);
> +	unsigned long until_jiffies;
>  	u8 data1[MAX_ARGS + 1];
>  	int err;
>  
> @@ -228,30 +229,39 @@ static int si4713_send_command(struct si4713_device *sdev, const u8 command,
>  	if (err != argn + 1) {
>  		v4l2_err(&sdev->sd, "Error while sending command 0x%02x\n",
>  			command);
> -		return (err > 0) ? -EIO : err;
> +		return err < 0 ? err : -EIO;
>  	}
>  
> +	until_jiffies = jiffies + usecs_to_jiffies(usecs) + 1;
> +
>  	/* Wait response from interrupt */
> -	if (!wait_for_completion_timeout(&sdev->work,
> +	if (client->irq) {
> +		if (!wait_for_completion_timeout(&sdev->work,
>  				usecs_to_jiffies(usecs) + 1))
> -		v4l2_warn(&sdev->sd,
> +			v4l2_warn(&sdev->sd,
>  				"(%s) Device took too much time to answer.\n",
>  				__func__);
> -
> -	/* Then get the response */
> -	err = i2c_master_recv(client, response, respn);
> -	if (err != respn) {
> -		v4l2_err(&sdev->sd,
> -			"Error while reading response for command 0x%02x\n",
> -			command);
> -		return (err > 0) ? -EIO : err;
>  	}
>  
> -	DBG_BUFFER(&sdev->sd, "Response", response, respn);
> -	if (check_command_failed(response[0]))
> -		return -EBUSY;
> +	do {
> +		err = i2c_master_recv(client, response, respn);
> +		if (err != respn) {
> +			v4l2_err(&sdev->sd,
> +				"Error %d while reading response for command 0x%02x\n",
> +				err, command);
> +			return err < 0 ? err : -EIO;
> +		}
> +
> +		DBG_BUFFER(&sdev->sd, "Response", response, respn);
> +		if (!check_command_failed(response[0]))
> +			return 0;
>  
> -	return 0;
> +		if (client->irq)
> +			return -EBUSY;
> +		msleep(1);
> +	} while (jiffies <= until_jiffies);

This could result on an endless loop due to the limited space for jiffies.
You should, instead, use the proper macros (time_after, time_before, ...).

> +
> +	return -EBUSY;
>  }
>  
>  /*
> @@ -344,14 +354,15 @@ static int si4713_write_property(struct si4713_device *sdev, u16 prop, u16 val)
>   */
>  static int si4713_powerup(struct si4713_device *sdev)
>  {
> +	struct i2c_client *client = v4l2_get_subdevdata(&sdev->sd);
>  	int err;
>  	u8 resp[SI4713_PWUP_NRESP];
>  	/*
>  	 * 	.First byte = Enabled interrupts and boot function
>  	 * 	.Second byte = Input operation mode
>  	 */
> -	const u8 args[SI4713_PWUP_NARGS] = {
> -		SI4713_PWUP_CTSIEN | SI4713_PWUP_GPO2OEN | SI4713_PWUP_FUNC_TX,
> +	u8 args[SI4713_PWUP_NARGS] = {
> +		SI4713_PWUP_GPO2OEN | SI4713_PWUP_FUNC_TX,
>  		SI4713_PWUP_OPMOD_ANALOG,
>  	};
>  
> @@ -369,6 +380,9 @@ static int si4713_powerup(struct si4713_device *sdev)
>  		gpio_set_value(sdev->gpio_reset, 1);
>  	}
>  
> +	if (client->irq)
> +		args[0] |= SI4713_PWUP_CTSIEN;
> +
>  	err = si4713_send_command(sdev, SI4713_CMD_POWER_UP,
>  					args, ARRAY_SIZE(args),
>  					resp, ARRAY_SIZE(resp),
> @@ -380,7 +394,8 @@ static int si4713_powerup(struct si4713_device *sdev)
>  		v4l2_dbg(1, debug, &sdev->sd, "Device in power up mode\n");
>  		sdev->power_state = POWER_ON;
>  
> -		err = si4713_write_property(sdev, SI4713_GPO_IEN,
> +		if (client->irq)
> +			err = si4713_write_property(sdev, SI4713_GPO_IEN,
>  						SI4713_STC_INT | SI4713_CTS);
>  	} else {
>  		if (gpio_is_valid(sdev->gpio_reset))
> @@ -465,33 +480,39 @@ static int si4713_checkrev(struct si4713_device *sdev)
>   */
>  static int si4713_wait_stc(struct si4713_device *sdev, const int usecs)
>  {
> -	int err;
> +	struct i2c_client *client = v4l2_get_subdevdata(&sdev->sd);
>  	u8 resp[SI4713_GET_STATUS_NRESP];
> +	unsigned long start_jiffies = jiffies;
> +	int err;
>  
> -	/* Wait response from STC interrupt */
> -	if (!wait_for_completion_timeout(&sdev->work,
> -			usecs_to_jiffies(usecs) + 1))
> +	if (client->irq &&
> +	    !wait_for_completion_timeout(&sdev->work, usecs_to_jiffies(usecs) + 1))
>  		v4l2_warn(&sdev->sd,
> -			"%s: device took too much time to answer (%d usec).\n",
> -				__func__, usecs);
> -
> -	/* Clear status bits */
> -	err = si4713_send_command(sdev, SI4713_CMD_GET_INT_STATUS,
> -					NULL, 0,
> -					resp, ARRAY_SIZE(resp),
> -					DEFAULT_TIMEOUT);
> -
> -	if (err < 0)
> -		goto exit;
> -
> -	v4l2_dbg(1, debug, &sdev->sd,
> -			"%s: status bits: 0x%02x\n", __func__, resp[0]);
> -
> -	if (!(resp[0] & SI4713_STC_INT))
> -		err = -EIO;
> -
> -exit:
> -	return err;
> +			"(%s) Device took too much time to answer.\n", __func__);
> +
> +	for (;;) {
> +		/* Clear status bits */
> +		err = si4713_send_command(sdev, SI4713_CMD_GET_INT_STATUS,
> +				NULL, 0,
> +				resp, ARRAY_SIZE(resp),
> +				DEFAULT_TIMEOUT);
> +		/* The USB device returns errors when it waits for the
> +		 * STC bit to be set. Hence polling */
> +		if (err >= 0) {
> +			v4l2_dbg(1, debug, &sdev->sd,
> +				"%s: status bits: 0x%02x\n", __func__, resp[0]);
> +
> +			if (resp[0] & SI4713_STC_INT)
> +				return 0;
> +		}
> +		if (jiffies_to_usecs(jiffies - start_jiffies) > usecs)

Same here: use the proper macro to check time after/before.

> +			return err < 0 ? err : -EIO;
> +		/* We sleep here for 3 ms in order to avoid flooding the device
> +		 * with USB requests. The si4713 USB driver was developed
> +		 * by reverse engineering the Windows USB driver. The windows
> +		 * driver also has a ~2.5 ms delay between responses. */
> +		msleep(3);
> +	}
>  }
>  
>  /*
> @@ -1024,7 +1045,6 @@ static int si4713_initialize(struct si4713_device *sdev)
>  	if (rval < 0)
>  		return rval;
>  
> -
>  	sdev->frequency = DEFAULT_FREQUENCY;
>  	sdev->stereo = 1;
>  	sdev->tune_rnl = DEFAULT_TUNE_RNL;


-- 

Cheers,
Mauro
