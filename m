Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:33526 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751511AbdJDKaL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 4 Oct 2017 06:30:11 -0400
Date: Wed, 4 Oct 2017 13:30:08 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Todor Tomov <todor.tomov@linaro.org>
Cc: mchehab@kernel.org, laurent.pinchart@ideasonboard.com,
        hansverk@cisco.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [media] ov5645: I2C address change
Message-ID: <20171004103008.g7azpn4a3hfj4fs2@valkosipuli.retiisi.org.uk>
References: <1506950925-13924-1-git-send-email-todor.tomov@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1506950925-13924-1-git-send-email-todor.tomov@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Todor,

On Mon, Oct 02, 2017 at 04:28:45PM +0300, Todor Tomov wrote:
> As soon as the sensor is powered on, change the I2C address to the one
> specified in DT. This allows to use multiple physical sensors connected
> to the same I2C bus.
> 
> Signed-off-by: Todor Tomov <todor.tomov@linaro.org>

The smiapp driver does something similar and I understand Laurent might be
interested in such functionality as well.

It'd be nice to handle this through the I²C framework instead and to define
how the information is specified through DT. That way it could be made
generic, to work with more devices than just this one.

What do you think?

Cc Laurent.

> ---
>  drivers/media/i2c/ov5645.c | 42 ++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 42 insertions(+)
> 
> diff --git a/drivers/media/i2c/ov5645.c b/drivers/media/i2c/ov5645.c
> index d28845f..8541109 100644
> --- a/drivers/media/i2c/ov5645.c
> +++ b/drivers/media/i2c/ov5645.c
> @@ -33,6 +33,7 @@
>  #include <linux/i2c.h>
>  #include <linux/init.h>
>  #include <linux/module.h>
> +#include <linux/mutex.h>
>  #include <linux/of.h>
>  #include <linux/of_graph.h>
>  #include <linux/regulator/consumer.h>
> @@ -42,6 +43,8 @@
>  #include <media/v4l2-fwnode.h>
>  #include <media/v4l2-subdev.h>
>  
> +static DEFINE_MUTEX(ov5645_lock);
> +
>  #define OV5645_VOLTAGE_ANALOG               2800000
>  #define OV5645_VOLTAGE_DIGITAL_CORE         1500000
>  #define OV5645_VOLTAGE_DIGITAL_IO           1800000
> @@ -590,6 +593,31 @@ static void ov5645_regulators_disable(struct ov5645 *ov5645)
>  		dev_err(ov5645->dev, "io regulator disable failed\n");
>  }
>  
> +static int ov5645_write_reg_to(struct ov5645 *ov5645, u16 reg, u8 val,
> +			       u16 i2c_addr)
> +{
> +	u8 regbuf[3] = {
> +		reg >> 8,
> +		reg & 0xff,
> +		val
> +	};
> +	struct i2c_msg msgs = {
> +		.addr = i2c_addr,
> +		.flags = 0,
> +		.len = 3,
> +		.buf = regbuf
> +	};
> +	int ret;
> +
> +	ret = i2c_transfer(ov5645->i2c_client->adapter, &msgs, 1);
> +	if (ret < 0)
> +		dev_err(ov5645->dev,
> +			"%s: write reg error %d on addr 0x%x: reg=0x%x, val=0x%x\n",
> +			__func__, ret, i2c_addr, reg, val);
> +
> +	return ret;
> +}
> +
>  static int ov5645_write_reg(struct ov5645 *ov5645, u16 reg, u8 val)
>  {
>  	u8 regbuf[3];
> @@ -729,10 +757,24 @@ static int ov5645_s_power(struct v4l2_subdev *sd, int on)
>  	 */
>  	if (ov5645->power_count == !on) {
>  		if (on) {
> +			mutex_lock(&ov5645_lock);
> +
>  			ret = ov5645_set_power_on(ov5645);
>  			if (ret < 0)
>  				goto exit;
>  
> +			ret = ov5645_write_reg_to(ov5645, 0x3100,
> +						ov5645->i2c_client->addr, 0x78);
> +			if (ret < 0) {
> +				dev_err(ov5645->dev,
> +					"could not change i2c address\n");
> +				ov5645_set_power_off(ov5645);
> +				mutex_unlock(&ov5645_lock);
> +				goto exit;
> +			}
> +
> +			mutex_unlock(&ov5645_lock);
> +
>  			ret = ov5645_set_register_array(ov5645,
>  					ov5645_global_init_setting,
>  					ARRAY_SIZE(ov5645_global_init_setting));
> -- 
> 2.7.4
> 

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
