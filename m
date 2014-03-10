Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr7.xs4all.nl ([194.109.24.27]:4137 "EHLO
	smtp-vbr7.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035AbaCJOhp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Mar 2014 10:37:45 -0400
Message-ID: <531DCE2E.5030807@xs4all.nl>
Date: Mon, 10 Mar 2014 15:37:34 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>,
	Hans Verkuil <hans.verkuil@cisco.com>
CC: Vladimir Barinov <vladimir.barinov@cogentembedded.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 7/7] [media] adv7180: Add support for power down
References: <1394208873-23260-1-git-send-email-lars@metafoo.de> <1394208873-23260-7-git-send-email-lars@metafoo.de>
In-Reply-To: <1394208873-23260-7-git-send-email-lars@metafoo.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Lars-Peter,

See some comments below:

On 03/07/2014 05:14 PM, Lars-Peter Clausen wrote:
> The adv7180 has a low power mode in which the analog and the digital processing
> section are shut down. Implement the s_power callback to let bridge drivers put
> the part into low power mode when not needed.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> ---
>  drivers/media/i2c/adv7180.c | 52 ++++++++++++++++++++++++++++++++++++---------
>  1 file changed, 42 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
> index 623cec5..8271362 100644
> --- a/drivers/media/i2c/adv7180.c
> +++ b/drivers/media/i2c/adv7180.c
> @@ -127,6 +127,7 @@ struct adv7180_state {
>  	int			irq;
>  	v4l2_std_id		curr_norm;
>  	bool			autodetect;
> +	bool			powered;
>  	u8			input;
>  };
>  #define to_adv7180_sd(_ctrl) (&container_of(_ctrl->handler,		\
> @@ -311,6 +312,39 @@ out:
>  	return ret;
>  }
>  
> +static int adv7180_set_power(struct adv7180_state *state,
> +	struct i2c_client *client, bool on)
> +{
> +	u8 val;
> +
> +	if (on)
> +		val = ADV7180_PWR_MAN_ON;
> +	else
> +		val = ADV7180_PWR_MAN_OFF;
> +
> +	return i2c_smbus_write_byte_data(client, ADV7180_PWR_MAN_REG, val);
> +}
> +
> +static int adv7180_s_power(struct v4l2_subdev *sd, int on)
> +{
> +	struct adv7180_state *state = to_state(sd);
> +	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +	int ret;
> +
> +	ret = mutex_lock_interruptible(&state->mutex);
> +	if (ret)
> +		return ret;
> +
> +	ret = adv7180_set_power(state, client, on);
> +	if (ret)
> +		goto out;
> +
> +	state->powered = on;
> +out:

I would change this to:

	if (!ret)
		state->powered = on;

and drop the 'goto'.

> +	mutex_unlock(&state->mutex);
> +	return ret;
> +}
> +
>  static int adv7180_s_ctrl(struct v4l2_ctrl *ctrl)
>  {
>  	struct v4l2_subdev *sd = to_adv7180_sd(ctrl);
> @@ -441,6 +475,7 @@ static const struct v4l2_subdev_video_ops adv7180_video_ops = {
>  
>  static const struct v4l2_subdev_core_ops adv7180_core_ops = {
>  	.s_std = adv7180_s_std,
> +	.s_power = adv7180_s_power,
>  };
>  
>  static const struct v4l2_subdev_ops adv7180_ops = {
> @@ -640,13 +675,9 @@ static const struct i2c_device_id adv7180_id[] = {
>  static int adv7180_suspend(struct device *dev)
>  {
>  	struct i2c_client *client = to_i2c_client(dev);
> -	int ret;
> +	struct adv7180_state *state = to_state(sd);
>  
> -	ret = i2c_smbus_write_byte_data(client, ADV7180_PWR_MAN_REG,
> -					ADV7180_PWR_MAN_OFF);
> -	if (ret < 0)
> -		return ret;
> -	return 0;
> +	return adv7180_set_power(state, client, false);
>  }
>  
>  static int adv7180_resume(struct device *dev)
> @@ -656,10 +687,11 @@ static int adv7180_resume(struct device *dev)
>  	struct adv7180_state *state = to_state(sd);
>  	int ret;
>  
> -	ret = i2c_smbus_write_byte_data(client, ADV7180_PWR_MAN_REG,
> -					ADV7180_PWR_MAN_ON);
> -	if (ret < 0)
> -		return ret;
> +	if (state->powered) {
> +		ret = adv7180_set_power(state, client, true);
> +		if (ret)
> +			return ret;
> +	}
>  	ret = init_device(client, state);
>  	if (ret < 0)
>  		return ret;
> 

What is the initial state of the driver when loaded? Shouldn't probe() set the
'powered' variable to true initially?

Regards,

	Hans
