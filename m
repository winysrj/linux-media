Return-path: <linux-media-owner@vger.kernel.org>
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:49248 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419AbcDCKyI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Apr 2016 06:54:08 -0400
Subject: Re: [PATCH v6 20/24] iio: imu: inv_mpu6050: change the i2c gate to be
 mux-locked
To: Peter Rosin <peda@lysator.liu.se>, linux-kernel@vger.kernel.org
References: <1459673574-11440-1-git-send-email-peda@lysator.liu.se>
 <1459673574-11440-21-git-send-email-peda@lysator.liu.se>
Cc: Peter Rosin <peda@axentia.se>, Wolfram Sang <wsa@the-dreams.de>,
	Jonathan Corbet <corbet@lwn.net>,
	Peter Korsgaard <peter.korsgaard@barco.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Hartmut Knaack <knaack.h@gmx.de>,
	Lars-Peter Clausen <lars@metafoo.de>,
	Peter Meerwald <pmeerw@pmeerw.net>,
	Antti Palosaari <crope@iki.fi>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Rob Herring <robh+dt@kernel.org>,
	Frank Rowand <frowand.list@gmail.com>,
	Grant Likely <grant.likely@linaro.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Kalle Valo <kvalo@codeaurora.org>,
	Joe Perches <joe@perches.com>, Jiri Slaby <jslaby@suse.com>,
	Daniel Baluta <daniel.baluta@intel.com>,
	Adriana Reus <adriana.reus@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Matt Ranostay <matt.ranostay@intel.com>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Terry Heo <terryheo@google.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Tommi Rantala <tt.rantala@gmail.com>,
	linux-i2c@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-iio@vger.kernel.org, linux-media@vger.kernel.org,
	devicetree@vger.kernel.org
From: Jonathan Cameron <jic23@kernel.org>
Message-ID: <5700F648.1010804@kernel.org>
Date: Sun, 3 Apr 2016 11:54:00 +0100
MIME-Version: 1.0
In-Reply-To: <1459673574-11440-21-git-send-email-peda@lysator.liu.se>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/04/16 09:52, Peter Rosin wrote:
> From: Peter Rosin <peda@axentia.se>
> 
> The root i2c adapter lock is then no longer held by the i2c mux during
> accesses behind the i2c gate, and such accesses need to take that lock
> just like any other ordinary i2c accesses do.
> 
> So, declare the i2c gate mux-locked, and zap the code that makes the
> unlocked i2c accesses and just use ordinary regmap_write accesses.
> 
> This also happens to fix the deadlock described in
> http://patchwork.ozlabs.org/patch/584776/ authored by
> Adriana Reus <adriana.reus@intel.com> and submitted by
> Daniel Baluta <daniel.baluta@intel.com>
> 
> ----------8<----------
> iio: imu: inv_mpu6050: Fix deadlock between i2c adapter lock and mpu lock
> 
> This deadlock occurs if the accel/gyro and the sensor on the auxiliary
> I2C (in my setup it's an ak8975) are working at the same time.
> 
> Scenario:
> 
>       T1					T2
>      ====				       ====
> inv_mpu6050_read_fifo                  aux sensor op (eg. ak8975_read_raw)
>         |                                     |
> mutex_lock(&indio_dev->mlock)           i2c_transfer
>         |                                     |
> i2c transaction                         i2c adapter lock
>         |                                     |
> i2c adapter lock                        i2c_mux_master_xfer
>                                               |
>                                         inv_mpu6050_select_bypass
>                                               |
>                                         mutex_lock(&indio_dev->mlock)
> 
> When we operate on an mpu sensor the order of locking is mpu lock
> followed by the i2c adapter lock. However, when we operate the auxiliary
> sensor the order of locking is the other way around.
> 
> ...
> ----------8<----------
> 
> The reason this patch fixes the deadlock is that T2 does not grab the
> i2c adapter lock until the very end (and grabs the newfangled i2c mux
> lock where it previously grabbed the i2c adapter lock).
> 
> Signed-off-by: Peter Rosin <peda@axentia.se>
This one obviously wants a ack from Adriana or Daniel in addition to mine.
I'm more than happy for these to go through the i2c tree btw.

Acked-by: Jonathan Cameron <jic23@kernel.org>
> ---
>  Documentation/i2c/i2c-topology            |  2 +-
>  drivers/iio/imu/inv_mpu6050/inv_mpu_i2c.c | 56 +++++++------------------------
>  2 files changed, 13 insertions(+), 45 deletions(-)
> 
> diff --git a/Documentation/i2c/i2c-topology b/Documentation/i2c/i2c-topology
> index 7a10edd0874f..346623a80bd1 100644
> --- a/Documentation/i2c/i2c-topology
> +++ b/Documentation/i2c/i2c-topology
> @@ -50,7 +50,7 @@ i2c-mux-pinctrl           Normally parent-locked, mux-locked iff
>  i2c-mux-reg               Parent-locked
>  
>  In drivers/iio/
> -imu/inv_mpu6050/          Parent-locked
> +imu/inv_mpu6050/          Mux-locked
>  
>  In drivers/media/
>  dvb-frontends/m88ds3103   Parent-locked
> diff --git a/drivers/iio/imu/inv_mpu6050/inv_mpu_i2c.c b/drivers/iio/imu/inv_mpu6050/inv_mpu_i2c.c
> index 0d429d788106..71ad31a275c9 100644
> --- a/drivers/iio/imu/inv_mpu6050/inv_mpu_i2c.c
> +++ b/drivers/iio/imu/inv_mpu6050/inv_mpu_i2c.c
> @@ -24,45 +24,16 @@ static const struct regmap_config inv_mpu_regmap_config = {
>  	.val_bits = 8,
>  };
>  
> -/*
> - * The i2c read/write needs to happen in unlocked mode. As the parent
> - * adapter is common. If we use locked versions, it will fail as
> - * the mux adapter will lock the parent i2c adapter, while calling
> - * select/deselect functions.
> - */
> -static int inv_mpu6050_write_reg_unlocked(struct i2c_client *client,
> -					  u8 reg, u8 d)
> -{
> -	int ret;
> -	u8 buf[2] = {reg, d};
> -	struct i2c_msg msg[1] = {
> -		{
> -			.addr = client->addr,
> -			.flags = 0,
> -			.len = sizeof(buf),
> -			.buf = buf,
> -		}
> -	};
> -
> -	ret = __i2c_transfer(client->adapter, msg, 1);
> -	if (ret != 1)
> -		return ret;
> -
> -	return 0;
> -}
> -
>  static int inv_mpu6050_select_bypass(struct i2c_mux_core *muxc, u32 chan_id)
>  {
> -	struct i2c_client *client = i2c_mux_priv(muxc);
> -	struct iio_dev *indio_dev = dev_get_drvdata(&client->dev);
> +	struct iio_dev *indio_dev = i2c_mux_priv(muxc);
>  	struct inv_mpu6050_state *st = iio_priv(indio_dev);
>  	int ret = 0;
>  
>  	/* Use the same mutex which was used everywhere to protect power-op */
>  	mutex_lock(&indio_dev->mlock);
>  	if (!st->powerup_count) {
> -		ret = inv_mpu6050_write_reg_unlocked(client,
> -						     st->reg->pwr_mgmt_1, 0);
> +		ret = regmap_write(st->map, st->reg->pwr_mgmt_1, 0);
>  		if (ret)
>  			goto write_error;
>  
> @@ -71,10 +42,9 @@ static int inv_mpu6050_select_bypass(struct i2c_mux_core *muxc, u32 chan_id)
>  	}
>  	if (!ret) {
>  		st->powerup_count++;
> -		ret = inv_mpu6050_write_reg_unlocked(client,
> -						     st->reg->int_pin_cfg,
> -						     INV_MPU6050_INT_PIN_CFG |
> -						     INV_MPU6050_BIT_BYPASS_EN);
> +		ret = regmap_write(st->map, st->reg->int_pin_cfg,
> +				   INV_MPU6050_INT_PIN_CFG |
> +				   INV_MPU6050_BIT_BYPASS_EN);
>  	}
>  write_error:
>  	mutex_unlock(&indio_dev->mlock);
> @@ -84,18 +54,16 @@ write_error:
>  
>  static int inv_mpu6050_deselect_bypass(struct i2c_mux_core *muxc, u32 chan_id)
>  {
> -	struct i2c_client *client = i2c_mux_priv(muxc);
> -	struct iio_dev *indio_dev = dev_get_drvdata(&client->dev);
> +	struct iio_dev *indio_dev = i2c_mux_priv(muxc);
>  	struct inv_mpu6050_state *st = iio_priv(indio_dev);
>  
>  	mutex_lock(&indio_dev->mlock);
>  	/* It doesn't really mattter, if any of the calls fails */
> -	inv_mpu6050_write_reg_unlocked(client, st->reg->int_pin_cfg,
> -				       INV_MPU6050_INT_PIN_CFG);
> +	regmap_write(st->map, st->reg->int_pin_cfg, INV_MPU6050_INT_PIN_CFG);
>  	st->powerup_count--;
>  	if (!st->powerup_count)
> -		inv_mpu6050_write_reg_unlocked(client, st->reg->pwr_mgmt_1,
> -					       INV_MPU6050_BIT_SLEEP);
> +		regmap_write(st->map, st->reg->pwr_mgmt_1,
> +			     INV_MPU6050_BIT_SLEEP);
>  	mutex_unlock(&indio_dev->mlock);
>  
>  	return 0;
> @@ -133,15 +101,15 @@ static int inv_mpu_probe(struct i2c_client *client,
>  		return result;
>  
>  	st = iio_priv(dev_get_drvdata(&client->dev));
> -	st->muxc = i2c_mux_one_adapter(client->adapter, &client->dev, 0, 0,
> -				       0, 0, 0,
> +	st->muxc = i2c_mux_one_adapter(client->adapter, &client->dev, 0,
> +				       I2C_MUX_LOCKED, 0, 0, 0,
>  				       inv_mpu6050_select_bypass,
>  				       inv_mpu6050_deselect_bypass);
>  	if (IS_ERR(st->muxc)) {
>  		result = PTR_ERR(st->muxc);
>  		goto out_unreg_device;
>  	}
> -	st->muxc->priv = client;
> +	st->muxc->priv = dev_get_drvdata(&client->dev);
>  
>  	result = inv_mpu_acpi_create_mux_client(client);
>  	if (result)
> 

