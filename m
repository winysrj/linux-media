Return-path: <linux-media-owner@vger.kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:9129 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752606AbeFZI3X (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Jun 2018 04:29:23 -0400
Date: Tue, 26 Jun 2018 09:28:41 +0100
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Peter Rosin <peda@axentia.se>
CC: <linux-kernel@vger.kernel.org>, Peter Huewe <peterhuewe@gmx.de>,
        "Jarkko Sakkinen" <jarkko.sakkinen@linux.intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Gregory Fong <gregory.0xf0@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        <bcm-kernel-feedback-list@broadcom.com>,
        "Sekhar Nori" <nsekhar@ti.com>, Kevin Hilman <khilman@kernel.org>,
        "Haavard Skinnemoen" <hskinnemoen@gmail.com>,
        Kukjin Kim <kgene@kernel.org>,
        "Krzysztof Kozlowski" <krzk@kernel.org>,
        Orson Zhai <orsonzhai@gmail.com>,
        Baolin Wang <baolin.wang@linaro.org>,
        Chunyan Zhang <zhang.lyra@gmail.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Guenter Roeck <linux@roeck-us.net>, Crt Mori <cmo@melexis.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Hartmut Knaack <knaack.h@gmx.de>,
        Lars-Peter Clausen <lars@metafoo.de>,
        "Peter Meerwald-Stadler" <pmeerw@pmeerw.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Antti Palosaari <crope@iki.fi>,
        "Mauro Carvalho Chehab" <mchehab@kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Lee Jones <lee.jones@linaro.org>,
        <linux-integrity@vger.kernel.org>, <linux-i2c@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-samsung-soc@vger.kernel.org>, <linux-iio@vger.kernel.org>,
        <linux-input@vger.kernel.org>, <linux-media@vger.kernel.org>
Subject: Re: [PATCH v2 10/10] i2c: remove i2c_lock_adapter and use
 i2c_lock_bus directly
Message-ID: <20180626092841.00003277@huawei.com>
In-Reply-To: <20180620051803.12206-11-peda@axentia.se>
References: <20180620051803.12206-1-peda@axentia.se>
        <20180620051803.12206-11-peda@axentia.se>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 20 Jun 2018 07:18:03 +0200
Peter Rosin <peda@axentia.se> wrote:

> The i2c_lock_adapter name is ambiguous since it is unclear if it
> refers to the root adapter or the adapter you name in the argument.
> The natural interpretation is the adapter you name in the argument,
> but there are historical reasons for that not being the case; it
> in fact locks the root adapter. Just remove the function and force
> users to spell out the I2C_LOCK_ROOT_ADAPTER name to indicate what
> is really going on. Also remove i2c_unlock_adapter, of course.
> 
> This patch was generated with
> 
> git grep -l 'i2c_\(un\)\?lock_adapter' \
> | xargs sed -i 's/i2c_\(un\)\?lock_adapter(\([^)]*\))/'\
> 'i2c_\1lock_bus(\2, I2C_LOCK_ROOT_ADAPTER)/g'
> 
> followed by white-space touch-up.
> 
> Signed-off-by: Peter Rosin <peda@axentia.se>

For IIO: Acked-by: Jonathan Cameron <jonathan.cameron@huawei.com>

> ---
>  drivers/i2c/busses/i2c-brcmstb.c   |  8 ++++----
>  drivers/i2c/busses/i2c-davinci.c   |  4 ++--
>  drivers/i2c/busses/i2c-gpio.c      | 40 +++++++++++++++++++-------------------
>  drivers/i2c/busses/i2c-s3c2410.c   |  4 ++--
>  drivers/i2c/busses/i2c-sprd.c      |  8 ++++----
>  drivers/i2c/i2c-core-slave.c       |  8 ++++----
>  drivers/iio/temperature/mlx90614.c |  4 ++--
>  include/linux/i2c.h                | 12 ------------
>  8 files changed, 38 insertions(+), 50 deletions(-)
> 
> diff --git a/drivers/i2c/busses/i2c-brcmstb.c b/drivers/i2c/busses/i2c-brcmstb.c
> index 78792b4d6437..826d32049996 100644
> --- a/drivers/i2c/busses/i2c-brcmstb.c
> +++ b/drivers/i2c/busses/i2c-brcmstb.c
> @@ -689,9 +689,9 @@ static int brcmstb_i2c_suspend(struct device *dev)
>  {
>  	struct brcmstb_i2c_dev *i2c_dev = dev_get_drvdata(dev);
>  
> -	i2c_lock_adapter(&i2c_dev->adapter);
> +	i2c_lock_bus(&i2c_dev->adapter, I2C_LOCK_ROOT_ADAPTER);
>  	i2c_dev->is_suspended = true;
> -	i2c_unlock_adapter(&i2c_dev->adapter);
> +	i2c_unlock_bus(&i2c_dev->adapter, I2C_LOCK_ROOT_ADAPTER);
>  
>  	return 0;
>  }
> @@ -700,10 +700,10 @@ static int brcmstb_i2c_resume(struct device *dev)
>  {
>  	struct brcmstb_i2c_dev *i2c_dev = dev_get_drvdata(dev);
>  
> -	i2c_lock_adapter(&i2c_dev->adapter);
> +	i2c_lock_bus(&i2c_dev->adapter, I2C_LOCK_ROOT_ADAPTER);
>  	brcmstb_i2c_set_bsc_reg_defaults(i2c_dev);
>  	i2c_dev->is_suspended = false;
> -	i2c_unlock_adapter(&i2c_dev->adapter);
> +	i2c_unlock_bus(&i2c_dev->adapter, I2C_LOCK_ROOT_ADAPTER);
>  
>  	return 0;
>  }
> diff --git a/drivers/i2c/busses/i2c-davinci.c b/drivers/i2c/busses/i2c-davinci.c
> index 75d6ab177055..d945a2654c2f 100644
> --- a/drivers/i2c/busses/i2c-davinci.c
> +++ b/drivers/i2c/busses/i2c-davinci.c
> @@ -714,14 +714,14 @@ static int i2c_davinci_cpufreq_transition(struct notifier_block *nb,
>  
>  	dev = container_of(nb, struct davinci_i2c_dev, freq_transition);
>  
> -	i2c_lock_adapter(&dev->adapter);
> +	i2c_lock_bus(&dev->adapter, I2C_LOCK_ROOT_ADAPTER);
>  	if (val == CPUFREQ_PRECHANGE) {
>  		davinci_i2c_reset_ctrl(dev, 0);
>  	} else if (val == CPUFREQ_POSTCHANGE) {
>  		i2c_davinci_calc_clk_dividers(dev);
>  		davinci_i2c_reset_ctrl(dev, 1);
>  	}
> -	i2c_unlock_adapter(&dev->adapter);
> +	i2c_unlock_bus(&dev->adapter, I2C_LOCK_ROOT_ADAPTER);
>  
>  	return 0;
>  }
> diff --git a/drivers/i2c/busses/i2c-gpio.c b/drivers/i2c/busses/i2c-gpio.c
> index 005e6e0330c2..9d63337efa82 100644
> --- a/drivers/i2c/busses/i2c-gpio.c
> +++ b/drivers/i2c/busses/i2c-gpio.c
> @@ -78,24 +78,24 @@ static struct dentry *i2c_gpio_debug_dir;
>  #define getscl(bd)	((bd)->getscl((bd)->data))
>  
>  #define WIRE_ATTRIBUTE(wire) \
> -static int fops_##wire##_get(void *data, u64 *val)	\
> -{							\
> -	struct i2c_gpio_private_data *priv = data;	\
> -							\
> -	i2c_lock_adapter(&priv->adap);			\
> -	*val = get##wire(&priv->bit_data);		\
> -	i2c_unlock_adapter(&priv->adap);		\
> -	return 0;					\
> -}							\
> -static int fops_##wire##_set(void *data, u64 val)	\
> -{							\
> -	struct i2c_gpio_private_data *priv = data;	\
> -							\
> -	i2c_lock_adapter(&priv->adap);			\
> -	set##wire(&priv->bit_data, val);		\
> -	i2c_unlock_adapter(&priv->adap);		\
> -	return 0;					\
> -}							\
> +static int fops_##wire##_get(void *data, u64 *val)		\
> +{								\
> +	struct i2c_gpio_private_data *priv = data;		\
> +								\
> +	i2c_lock_bus(&priv->adap, I2C_LOCK_ROOT_ADAPTER);	\
> +	*val = get##wire(&priv->bit_data);			\
> +	i2c_unlock_bus(&priv->adap, I2C_LOCK_ROOT_ADAPTER);	\
> +	return 0;						\
> +}								\
> +static int fops_##wire##_set(void *data, u64 val)		\
> +{								\
> +	struct i2c_gpio_private_data *priv = data;		\
> +								\
> +	i2c_lock_bus(&priv->adap, I2C_LOCK_ROOT_ADAPTER);	\
> +	set##wire(&priv->bit_data, val);			\
> +	i2c_unlock_bus(&priv->adap, I2C_LOCK_ROOT_ADAPTER);	\
> +	return 0;						\
> +}								\
>  DEFINE_DEBUGFS_ATTRIBUTE(fops_##wire, fops_##wire##_get, fops_##wire##_set, "%llu\n")
>  
>  WIRE_ATTRIBUTE(scl);
> @@ -113,7 +113,7 @@ static int fops_incomplete_transfer_set(void *data, u64 addr)
>  	/* ADDR (7 bit) + RD (1 bit) + SDA hi (1 bit) */
>  	pattern = (addr << 2) | 3;
>  
> -	i2c_lock_adapter(&priv->adap);
> +	i2c_lock_bus(&priv->adap, I2C_LOCK_ROOT_ADAPTER);
>  
>  	/* START condition */
>  	setsda(bit_data, 0);
> @@ -129,7 +129,7 @@ static int fops_incomplete_transfer_set(void *data, u64 addr)
>  		udelay(bit_data->udelay);
>  	}
>  
> -	i2c_unlock_adapter(&priv->adap);
> +	i2c_unlock_bus(&priv->adap, I2C_LOCK_ROOT_ADAPTER);
>  
>  	return 0;
>  }
> diff --git a/drivers/i2c/busses/i2c-s3c2410.c b/drivers/i2c/busses/i2c-s3c2410.c
> index 9fe2b6951895..2f2e28d60ef5 100644
> --- a/drivers/i2c/busses/i2c-s3c2410.c
> +++ b/drivers/i2c/busses/i2c-s3c2410.c
> @@ -919,9 +919,9 @@ static int s3c24xx_i2c_cpufreq_transition(struct notifier_block *nb,
>  
>  	if ((val == CPUFREQ_POSTCHANGE && delta_f < 0) ||
>  	    (val == CPUFREQ_PRECHANGE && delta_f > 0)) {
> -		i2c_lock_adapter(&i2c->adap);
> +		i2c_lock_bus(&i2c->adap, I2C_LOCK_ROOT_ADAPTER);
>  		ret = s3c24xx_i2c_clockrate(i2c, &got);
> -		i2c_unlock_adapter(&i2c->adap);
> +		i2c_unlock_bus(&i2c->adap, I2C_LOCK_ROOT_ADAPTER);
>  
>  		if (ret < 0)
>  			dev_err(i2c->dev, "cannot find frequency (%d)\n", ret);
> diff --git a/drivers/i2c/busses/i2c-sprd.c b/drivers/i2c/busses/i2c-sprd.c
> index 4053259bccb8..a94e724f51dc 100644
> --- a/drivers/i2c/busses/i2c-sprd.c
> +++ b/drivers/i2c/busses/i2c-sprd.c
> @@ -590,9 +590,9 @@ static int __maybe_unused sprd_i2c_suspend_noirq(struct device *pdev)
>  {
>  	struct sprd_i2c *i2c_dev = dev_get_drvdata(pdev);
>  
> -	i2c_lock_adapter(&i2c_dev->adap);
> +	i2c_lock_bus(&i2c_dev->adap, I2C_LOCK_ROOT_ADAPTER);
>  	i2c_dev->is_suspended = true;
> -	i2c_unlock_adapter(&i2c_dev->adap);
> +	i2c_unlock_bus(&i2c_dev->adap, I2C_LOCK_ROOT_ADAPTER);
>  
>  	return pm_runtime_force_suspend(pdev);
>  }
> @@ -601,9 +601,9 @@ static int __maybe_unused sprd_i2c_resume_noirq(struct device *pdev)
>  {
>  	struct sprd_i2c *i2c_dev = dev_get_drvdata(pdev);
>  
> -	i2c_lock_adapter(&i2c_dev->adap);
> +	i2c_lock_bus(&i2c_dev->adap, I2C_LOCK_ROOT_ADAPTER);
>  	i2c_dev->is_suspended = false;
> -	i2c_unlock_adapter(&i2c_dev->adap);
> +	i2c_unlock_bus(&i2c_dev->adap, I2C_LOCK_ROOT_ADAPTER);
>  
>  	return pm_runtime_force_resume(pdev);
>  }
> diff --git a/drivers/i2c/i2c-core-slave.c b/drivers/i2c/i2c-core-slave.c
> index 4a78c65e9971..47a9f70a24a9 100644
> --- a/drivers/i2c/i2c-core-slave.c
> +++ b/drivers/i2c/i2c-core-slave.c
> @@ -47,9 +47,9 @@ int i2c_slave_register(struct i2c_client *client, i2c_slave_cb_t slave_cb)
>  
>  	client->slave_cb = slave_cb;
>  
> -	i2c_lock_adapter(client->adapter);
> +	i2c_lock_bus(client->adapter, I2C_LOCK_ROOT_ADAPTER);
>  	ret = client->adapter->algo->reg_slave(client);
> -	i2c_unlock_adapter(client->adapter);
> +	i2c_unlock_bus(client->adapter, I2C_LOCK_ROOT_ADAPTER);
>  
>  	if (ret) {
>  		client->slave_cb = NULL;
> @@ -69,9 +69,9 @@ int i2c_slave_unregister(struct i2c_client *client)
>  		return -EOPNOTSUPP;
>  	}
>  
> -	i2c_lock_adapter(client->adapter);
> +	i2c_lock_bus(client->adapter, I2C_LOCK_ROOT_ADAPTER);
>  	ret = client->adapter->algo->unreg_slave(client);
> -	i2c_unlock_adapter(client->adapter);
> +	i2c_unlock_bus(client->adapter, I2C_LOCK_ROOT_ADAPTER);
>  
>  	if (ret == 0)
>  		client->slave_cb = NULL;
> diff --git a/drivers/iio/temperature/mlx90614.c b/drivers/iio/temperature/mlx90614.c
> index d619e8634a00..13a4cec64ea8 100644
> --- a/drivers/iio/temperature/mlx90614.c
> +++ b/drivers/iio/temperature/mlx90614.c
> @@ -433,11 +433,11 @@ static int mlx90614_wakeup(struct mlx90614_data *data)
>  
>  	dev_dbg(&data->client->dev, "Requesting wake-up");
>  
> -	i2c_lock_adapter(data->client->adapter);
> +	i2c_lock_bus(data->client->adapter, I2C_LOCK_ROOT_ADAPTER);
>  	gpiod_direction_output(data->wakeup_gpio, 0);
>  	msleep(MLX90614_TIMING_WAKEUP);
>  	gpiod_direction_input(data->wakeup_gpio);
> -	i2c_unlock_adapter(data->client->adapter);
> +	i2c_unlock_bus(data->client->adapter, I2C_LOCK_ROOT_ADAPTER);
>  
>  	data->ready_timestamp = jiffies +
>  			msecs_to_jiffies(MLX90614_TIMING_STARTUP);
> diff --git a/include/linux/i2c.h b/include/linux/i2c.h
> index 254cd34eeae2..795e3a860afe 100644
> --- a/include/linux/i2c.h
> +++ b/include/linux/i2c.h
> @@ -754,18 +754,6 @@ i2c_unlock_bus(struct i2c_adapter *adapter, unsigned int flags)
>  	adapter->lock_ops->unlock_bus(adapter, flags);
>  }
>  
> -static inline void
> -i2c_lock_adapter(struct i2c_adapter *adapter)
> -{
> -	i2c_lock_bus(adapter, I2C_LOCK_ROOT_ADAPTER);
> -}
> -
> -static inline void
> -i2c_unlock_adapter(struct i2c_adapter *adapter)
> -{
> -	i2c_unlock_bus(adapter, I2C_LOCK_ROOT_ADAPTER);
> -}
> -
>  /*flags for the client struct: */
>  #define I2C_CLIENT_PEC		0x04	/* Use Packet Error Checking */
>  #define I2C_CLIENT_TEN		0x10	/* we have a ten bit chip address */
