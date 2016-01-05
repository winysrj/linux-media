Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.lysator.liu.se ([130.236.254.3]:49220 "EHLO
	mail.lysator.liu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711AbcAEWR1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Jan 2016 17:17:27 -0500
Message-ID: <568C40EB.3030602@lysator.liu.se>
Date: Tue, 05 Jan 2016 23:17:15 +0100
From: Peter Rosin <peda@lysator.liu.se>
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>
CC: Peter Rosin <peda@axentia.se>, Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	Peter Korsgaard <peter.korsgaard@barco.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Jonathan Cameron <jic23@kernel.org>,
	Hartmut Knaack <knaack.h@gmx.de>,
	Lars-Peter Clausen <lars@metafoo.de>,
	Peter Meerwald <pmeerw@pmeerw.net>,
	Antti Palosaari <crope@iki.fi>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Frank Rowand <frowand.list@gmail.com>,
	Grant Likely <grant.likely@linaro.org>,
	Adriana Reus <adriana.reus@intel.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Nicholas Mc Guire <hofrat@osadl.org>,
	Olli Salonen <olli.salonen@iki.fi>, linux-i2c@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-iio@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH v2 3/8] i2c-mux: move the slave side adapter management
 to i2c_mux_core
References: <1452009438-27347-1-git-send-email-peda@lysator.liu.se> <1452009438-27347-4-git-send-email-peda@lysator.liu.se>
In-Reply-To: <1452009438-27347-4-git-send-email-peda@lysator.liu.se>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Ouch, this got lost in the shuffle, don't bother testing without it.
It will be included in v3.

[the reason is that my test hw relies on vendor patches, and I have to
rebase before sending. I.e., I can only compile-test the stuff I'm
actually sending out. Inconvenient.]

diff --git a/drivers/i2c/i2c-mux.c b/drivers/i2c/i2c-mux.c
index c4d4b14a5399..c5a5886d8be1 100644
--- a/drivers/i2c/i2c-mux.c
+++ b/drivers/i2c/i2c-mux.c
@@ -215,10 +215,12 @@ int i2c_mux_reserve_adapters(struct i2c_mux_core *muxc, int adapters)
 	if (!adapter)
 		return -ENOMEM;
 
-	memcpy(adapter, muxc->adapter,
-	       muxc->max_adapters * sizeof(*adapter));
+	if (muxc->adapter) {
+		memcpy(adapter, muxc->adapter,
+		       muxc->max_adapters * sizeof(*adapter));
+		devm_kfree(muxc->dev, muxc->adapter);
+	}
 
-	devm_kfree(muxc->dev, muxc->adapter);
 	muxc->adapter = adapter;
 	muxc->max_adapters = adapters;
 	return 0;
-- 


On 2016-01-05 16:57, Peter Rosin wrote:
> From: Peter Rosin <peda@axentia.se>
> 
> All muxes have slave side adapters, many have some arbitrary number of
> them. Handle this in the mux core, so that drivers are simplified.
> 
> Add i2c_mux_reserve_adapter that can be used when it is known in advance
> how many child adapters that is to be added. This avoids reallocating
> memory.
> 
> Drop i2c_del_mux_adapter and replace it with i2c_del_mux_adapters, since
> no mux driver is dynamically deleting individual child adapters anyway.
> 
> Signed-off-by: Peter Rosin <peda@axentia.se>
> ---
>  drivers/i2c/i2c-mux.c                        | 71 ++++++++++++++++++++++------
>  drivers/i2c/muxes/i2c-arb-gpio-challenge.c   | 10 ++--
>  drivers/i2c/muxes/i2c-mux-gpio.c             | 23 +++------
>  drivers/i2c/muxes/i2c-mux-pca9541.c          | 13 ++---
>  drivers/i2c/muxes/i2c-mux-pca954x.c          | 26 ++++------
>  drivers/i2c/muxes/i2c-mux-pinctrl.c          | 27 +++--------
>  drivers/i2c/muxes/i2c-mux-reg.c              | 28 ++++-------
>  drivers/iio/imu/inv_mpu6050/inv_mpu_core.c   | 12 ++---
>  drivers/iio/imu/inv_mpu6050/inv_mpu_iio.h    |  1 -
>  drivers/media/dvb-frontends/m88ds3103.c      | 11 ++---
>  drivers/media/dvb-frontends/m88ds3103_priv.h |  1 -
>  drivers/media/dvb-frontends/rtl2830.c        | 10 ++--
>  drivers/media/dvb-frontends/rtl2830_priv.h   |  1 -
>  drivers/media/dvb-frontends/rtl2832.c        | 11 ++---
>  drivers/media/dvb-frontends/rtl2832_priv.h   |  1 -
>  drivers/media/dvb-frontends/si2168.c         | 10 ++--
>  drivers/media/dvb-frontends/si2168_priv.h    |  1 -
>  drivers/media/usb/cx231xx/cx231xx-core.c     |  3 +-
>  drivers/media/usb/cx231xx/cx231xx-i2c.c      | 26 +++++-----
>  drivers/media/usb/cx231xx/cx231xx.h          |  2 +-
>  drivers/of/unittest.c                        | 28 ++++-------
>  include/linux/i2c-mux.h                      | 15 ++++--
>  22 files changed, 149 insertions(+), 182 deletions(-)
> 
> diff --git a/drivers/i2c/i2c-mux.c b/drivers/i2c/i2c-mux.c
> index 6c5cb9f7649b..7ba0308537a8 100644
> --- a/drivers/i2c/i2c-mux.c
> +++ b/drivers/i2c/i2c-mux.c
> @@ -99,6 +99,29 @@ static unsigned int i2c_mux_parent_classes(struct i2c_adapter *parent)
>  	return class;
>  }
>  
> +int i2c_mux_reserve_adapters(struct i2c_mux_core *muxc, int adapters)
> +{
> +	struct i2c_adapter **adapter;
> +
> +	if (adapters <= muxc->max_adapters)
> +		return 0;
> +
> +	adapter = devm_kmalloc_array(muxc->dev,
> +				     adapters, sizeof(*adapter),
> +				     GFP_KERNEL);
> +	if (!adapter)
> +		return -ENOMEM;
> +
> +	memcpy(adapter, muxc->adapter,
> +	       muxc->max_adapters * sizeof(*adapter));
> +
> +	devm_kfree(muxc->dev, muxc->adapter);
> +	muxc->adapter = adapter;
> +	muxc->max_adapters = adapters;
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(i2c_mux_reserve_adapters);
> +
>  struct i2c_mux_core *i2c_mux_alloc(struct device *dev, int sizeof_priv)
>  {
>  	struct i2c_mux_core *muxc;
> @@ -113,19 +136,29 @@ struct i2c_mux_core *i2c_mux_alloc(struct device *dev, int sizeof_priv)
>  }
>  EXPORT_SYMBOL_GPL(i2c_mux_alloc);
>  
> -struct i2c_adapter *i2c_add_mux_adapter(struct i2c_mux_core *muxc,
> -					struct device *mux_dev,
> -					u32 force_nr, u32 chan_id,
> -					unsigned int class)
> +int i2c_add_mux_adapter(struct i2c_mux_core *muxc,
> +			struct device *mux_dev,
> +			u32 force_nr, u32 chan_id,
> +			unsigned int class)
>  {
>  	struct i2c_adapter *parent = muxc->parent;
>  	struct i2c_mux_priv *priv;
>  	char symlink_name[20];
>  	int ret;
>  
> +	if (muxc->adapters >= muxc->max_adapters) {
> +		int new_max = 2 * muxc->max_adapters;
> +
> +		if (!new_max)
> +			new_max = 1;
> +		ret = i2c_mux_reserve_adapters(muxc, new_max);
> +		if (ret)
> +			return ret;
> +	}
> +
>  	priv = kzalloc(sizeof(struct i2c_mux_priv), GFP_KERNEL);
>  	if (!priv)
> -		return NULL;
> +		return -ENOMEM;
>  
>  	/* Set up private adapter data */
>  	priv->muxc = muxc;
> @@ -197,7 +230,7 @@ struct i2c_adapter *i2c_add_mux_adapter(struct i2c_mux_core *muxc,
>  			"failed to add mux-adapter (error=%d)\n",
>  			ret);
>  		kfree(priv);
> -		return NULL;
> +		return ret;
>  	}
>  
>  	WARN(sysfs_create_link(&priv->adap.dev.kobj, &mux_dev->kobj, "mux_device"),
> @@ -209,23 +242,31 @@ struct i2c_adapter *i2c_add_mux_adapter(struct i2c_mux_core *muxc,
>  	dev_info(&parent->dev, "Added multiplexed i2c bus %d\n",
>  		 i2c_adapter_id(&priv->adap));
>  
> -	return &priv->adap;
> +	muxc->adapter[muxc->adapters++] = &priv->adap;
> +	return 0;
>  }
>  EXPORT_SYMBOL_GPL(i2c_add_mux_adapter);
>  
> -void i2c_del_mux_adapter(struct i2c_adapter *adap)
> +void i2c_del_mux_adapters(struct i2c_mux_core *muxc)
>  {
> -	struct i2c_mux_priv *priv = adap->algo_data;
>  	char symlink_name[20];
>  
> -	snprintf(symlink_name, sizeof(symlink_name), "channel-%u", priv->chan_id);
> -	sysfs_remove_link(&priv->mux_dev->kobj, symlink_name);
> +	while (muxc->adapters) {
> +		struct i2c_adapter *adap = muxc->adapter[--muxc->adapters];
> +		struct i2c_mux_priv *priv = adap->algo_data;
>  
> -	sysfs_remove_link(&priv->adap.dev.kobj, "mux_device");
> -	i2c_del_adapter(adap);
> -	kfree(priv);
> +		muxc->adapter[muxc->adapters] = NULL;
> +
> +		snprintf(symlink_name, sizeof(symlink_name),
> +			 "channel-%u", priv->chan_id);
> +		sysfs_remove_link(&priv->mux_dev->kobj, symlink_name);
> +
> +		sysfs_remove_link(&priv->adap.dev.kobj, "mux_device");
> +		i2c_del_adapter(adap);
> +		kfree(priv);
> +	}
>  }
> -EXPORT_SYMBOL_GPL(i2c_del_mux_adapter);
> +EXPORT_SYMBOL_GPL(i2c_del_mux_adapters);
>  
>  MODULE_AUTHOR("Rodolfo Giometti <giometti@linux.it>");
>  MODULE_DESCRIPTION("I2C driver for multiplexed I2C busses");
> diff --git a/drivers/i2c/muxes/i2c-arb-gpio-challenge.c b/drivers/i2c/muxes/i2c-arb-gpio-challenge.c
> index 1e1a479d5b61..e0558e8a0e74 100644
> --- a/drivers/i2c/muxes/i2c-arb-gpio-challenge.c
> +++ b/drivers/i2c/muxes/i2c-arb-gpio-challenge.c
> @@ -42,7 +42,6 @@
>   */
>  
>  struct i2c_arbitrator_data {
> -	struct i2c_adapter *child;
>  	int our_gpio;
>  	int our_gpio_release;
>  	int their_gpio;
> @@ -205,10 +204,9 @@ static int i2c_arbitrator_probe(struct platform_device *pdev)
>  	}
>  
>  	/* Actually add the mux adapter */
> -	arb->child = i2c_add_mux_adapter(muxc, dev, 0, 0, 0);
> -	if (!arb->child) {
> +	ret = i2c_add_mux_adapter(muxc, dev, 0, 0, 0);
> +	if (ret) {
>  		dev_err(dev, "Failed to add adapter\n");
> -		ret = -ENODEV;
>  		i2c_put_adapter(muxc->parent);
>  	}
>  
> @@ -218,11 +216,9 @@ static int i2c_arbitrator_probe(struct platform_device *pdev)
>  static int i2c_arbitrator_remove(struct platform_device *pdev)
>  {
>  	struct i2c_mux_core *muxc = platform_get_drvdata(pdev);
> -	struct i2c_arbitrator_data *arb = i2c_mux_priv(muxc);
>  
> -	i2c_del_mux_adapter(arb->child);
> +	i2c_del_mux_adapters(muxc);
>  	i2c_put_adapter(muxc->parent);
> -
>  	return 0;
>  }
>  
> diff --git a/drivers/i2c/muxes/i2c-mux-gpio.c b/drivers/i2c/muxes/i2c-mux-gpio.c
> index d89a0fbca4bc..6bd41ace81d4 100644
> --- a/drivers/i2c/muxes/i2c-mux-gpio.c
> +++ b/drivers/i2c/muxes/i2c-mux-gpio.c
> @@ -18,7 +18,6 @@
>  #include <linux/of_gpio.h>
>  
>  struct gpiomux {
> -	struct i2c_adapter **adap; /* child busses */
>  	struct i2c_mux_gpio_platform_data data;
>  	unsigned gpio_base;
>  };
> @@ -182,14 +181,9 @@ static int i2c_mux_gpio_probe(struct platform_device *pdev)
>  	muxc->select = i2c_mux_gpio_select;
>  	mux->gpio_base = gpio_base;
>  
> -	mux->adap = devm_kzalloc(&pdev->dev,
> -				 sizeof(*mux->adap) * mux->data.n_values,
> -				 GFP_KERNEL);
> -	if (!mux->adap) {
> -		dev_err(&pdev->dev, "Cannot allocate i2c_adapter structure");
> -		ret = -ENOMEM;
> +	ret = i2c_mux_reserve_adapters(muxc, mux->data.n_values);
> +	if (ret)
>  		goto alloc_failed;
> -	}
>  
>  	if (mux->data.idle != I2C_MUX_GPIO_NO_IDLE) {
>  		initial_state = mux->data.idle;
> @@ -222,10 +216,9 @@ static int i2c_mux_gpio_probe(struct platform_device *pdev)
>  		u32 nr = mux->data.base_nr ? (mux->data.base_nr + i) : 0;
>  		unsigned int class = mux->data.classes ? mux->data.classes[i] : 0;
>  
> -		mux->adap[i] = i2c_add_mux_adapter(muxc, &pdev->dev, nr,
> -						   mux->data.values[i], class);
> -		if (!mux->adap[i]) {
> -			ret = -ENODEV;
> +		ret = i2c_add_mux_adapter(muxc, &pdev->dev, nr,
> +					  mux->data.values[i], class);
> +		if (ret) {
>  			dev_err(&pdev->dev, "Failed to add adapter %d\n", i);
>  			goto add_adapter_failed;
>  		}
> @@ -237,8 +230,7 @@ static int i2c_mux_gpio_probe(struct platform_device *pdev)
>  	return 0;
>  
>  add_adapter_failed:
> -	for (; i > 0; i--)
> -		i2c_del_mux_adapter(mux->adap[i - 1]);
> +	i2c_del_mux_adapters(muxc);
>  	i = mux->data.n_gpios;
>  err_request_gpio:
>  	for (; i > 0; i--)
> @@ -255,8 +247,7 @@ static int i2c_mux_gpio_remove(struct platform_device *pdev)
>  	struct gpiomux *mux = i2c_mux_priv(muxc);
>  	int i;
>  
> -	for (i = 0; i < mux->data.n_values; i++)
> -		i2c_del_mux_adapter(mux->adap[i]);
> +	i2c_del_mux_adapters(muxc);
>  
>  	for (i = 0; i < mux->data.n_gpios; i++)
>  		gpio_free(mux->gpio_base + mux->data.gpios[i]);
> diff --git a/drivers/i2c/muxes/i2c-mux-pca9541.c b/drivers/i2c/muxes/i2c-mux-pca9541.c
> index ae42039459d0..80de0a0977a5 100644
> --- a/drivers/i2c/muxes/i2c-mux-pca9541.c
> +++ b/drivers/i2c/muxes/i2c-mux-pca9541.c
> @@ -74,7 +74,6 @@
>  
>  struct pca9541 {
>  	struct i2c_client *client;
> -	struct i2c_adapter *mux_adap;
>  	unsigned long select_timeout;
>  	unsigned long arb_timeout;
>  };
> @@ -332,6 +331,7 @@ static int pca9541_probe(struct i2c_client *client,
>  	struct i2c_mux_core *muxc;
>  	struct pca9541 *data;
>  	int force;
> +	int ret;
>  
>  	if (!i2c_check_functionality(adap, I2C_FUNC_SMBUS_BYTE_DATA))
>  		return -ENODEV;
> @@ -361,11 +361,10 @@ static int pca9541_probe(struct i2c_client *client,
>  	force = 0;
>  	if (pdata)
>  		force = pdata->modes[0].adap_id;
> -	data->mux_adap = i2c_add_mux_adapter(muxc, &client->dev, force, 0, 0);
> -
> -	if (data->mux_adap == NULL) {
> +	ret = i2c_add_mux_adapter(muxc, &client->dev, force, 0, 0);
> +	if (ret) {
>  		dev_err(&client->dev, "failed to register master selector\n");
> -		return -ENODEV;
> +		return ret;
>  	}
>  
>  	dev_info(&client->dev, "registered master selector for I2C %s\n",
> @@ -377,10 +376,8 @@ static int pca9541_probe(struct i2c_client *client,
>  static int pca9541_remove(struct i2c_client *client)
>  {
>  	struct i2c_mux_core *muxc = i2c_get_clientdata(client);
> -	struct pca9541 *data = i2c_mux_priv(muxc);
> -
> -	i2c_del_mux_adapter(data->mux_adap);
>  
> +	i2c_del_mux_adapters(muxc);
>  	return 0;
>  }
>  
> diff --git a/drivers/i2c/muxes/i2c-mux-pca954x.c b/drivers/i2c/muxes/i2c-mux-pca954x.c
> index 9e9d708fb2cb..640670b604f5 100644
> --- a/drivers/i2c/muxes/i2c-mux-pca954x.c
> +++ b/drivers/i2c/muxes/i2c-mux-pca954x.c
> @@ -60,7 +60,6 @@ enum pca_type {
>  
>  struct pca954x {
>  	enum pca_type type;
> -	struct i2c_adapter *virt_adaps[PCA954X_MAX_NCHANS];
>  
>  	u8 last_chan;		/* last register value */
>  	u8 deselect;
> @@ -231,6 +230,10 @@ static int pca954x_probe(struct i2c_client *client,
>  	data->type = id->driver_data;
>  	data->last_chan = 0;		   /* force the first selection */
>  
> +	ret = i2c_mux_reserve_adapters(muxc, chips[data->type].nchans);
> +	if (ret)
> +		return ret;
> +
>  	idle_disconnect_dt = of_node &&
>  		of_property_read_bool(of_node, "i2c-mux-idle-disconnect");
>  
> @@ -253,12 +256,10 @@ static int pca954x_probe(struct i2c_client *client,
>  					   || idle_disconnect_dt) << num;
>  		}
>  
> -		data->virt_adaps[num] =
> -			i2c_add_mux_adapter(muxc, &client->dev,
> -					    force, num, class);
> +		ret = i2c_add_mux_adapter(muxc, &client->dev,
> +					  force, num, class);
>  
> -		if (data->virt_adaps[num] == NULL) {
> -			ret = -ENODEV;
> +		if (ret) {
>  			dev_err(&client->dev,
>  				"failed to register multiplexed adapter"
>  				" %d as bus %d\n", num, force);
> @@ -274,24 +275,15 @@ static int pca954x_probe(struct i2c_client *client,
>  	return 0;
>  
>  virt_reg_failed:
> -	for (num--; num >= 0; num--)
> -		i2c_del_mux_adapter(data->virt_adaps[num]);
> +	i2c_del_mux_adapters(muxc);
>  	return ret;
>  }
>  
>  static int pca954x_remove(struct i2c_client *client)
>  {
>  	struct i2c_mux_core *muxc = i2c_get_clientdata(client);
> -	struct pca954x *data = i2c_mux_priv(muxc);
> -	const struct chip_desc *chip = &chips[data->type];
> -	int i;
> -
> -	for (i = 0; i < chip->nchans; ++i)
> -		if (data->virt_adaps[i]) {
> -			i2c_del_mux_adapter(data->virt_adaps[i]);
> -			data->virt_adaps[i] = NULL;
> -		}
>  
> +	i2c_del_mux_adapters(muxc);
>  	return 0;
>  }
>  
> diff --git a/drivers/i2c/muxes/i2c-mux-pinctrl.c b/drivers/i2c/muxes/i2c-mux-pinctrl.c
> index e87c8f77037a..3bbb3fb1d693 100644
> --- a/drivers/i2c/muxes/i2c-mux-pinctrl.c
> +++ b/drivers/i2c/muxes/i2c-mux-pinctrl.c
> @@ -31,7 +31,6 @@ struct i2c_mux_pinctrl {
>  	struct pinctrl *pinctrl;
>  	struct pinctrl_state **states;
>  	struct pinctrl_state *state_idle;
> -	struct i2c_adapter **busses;
>  };
>  
>  static int i2c_mux_pinctrl_select(struct i2c_mux_core *muxc, u32 chan)
> @@ -163,14 +162,9 @@ static int i2c_mux_pinctrl_probe(struct platform_device *pdev)
>  		goto err;
>  	}
>  
> -	mux->busses = devm_kzalloc(&pdev->dev,
> -				   sizeof(*mux->busses) * mux->pdata->bus_count,
> -				   GFP_KERNEL);
> -	if (!mux->busses) {
> -		dev_err(&pdev->dev, "Cannot allocate busses\n");
> -		ret = -ENOMEM;
> +	ret = i2c_mux_reserve_adapters(muxc, mux->pdata->bus_count);
> +	if (ret)
>  		goto err;
> -	}
>  
>  	mux->pinctrl = devm_pinctrl_get(&pdev->dev);
>  	if (IS_ERR(mux->pinctrl)) {
> @@ -218,10 +212,9 @@ static int i2c_mux_pinctrl_probe(struct platform_device *pdev)
>  		u32 bus = mux->pdata->base_bus_num ?
>  				(mux->pdata->base_bus_num + i) : 0;
>  
> -		mux->busses[i] = i2c_add_mux_adapter(muxc, &pdev->dev,
> -						     bus, i, 0);
> -		if (!mux->busses[i]) {
> -			ret = -ENODEV;
> +		ret = i2c_add_mux_adapter(muxc, &pdev->dev,
> +					  bus, i, 0);
> +		if (ret) {
>  			dev_err(&pdev->dev, "Failed to add adapter %d\n", i);
>  			goto err_del_adapter;
>  		}
> @@ -230,8 +223,7 @@ static int i2c_mux_pinctrl_probe(struct platform_device *pdev)
>  	return 0;
>  
>  err_del_adapter:
> -	for (; i > 0; i--)
> -		i2c_del_mux_adapter(mux->busses[i - 1]);
> +	i2c_del_mux_adapters(muxc);
>  	i2c_put_adapter(muxc->parent);
>  err:
>  	return ret;
> @@ -240,14 +232,9 @@ err:
>  static int i2c_mux_pinctrl_remove(struct platform_device *pdev)
>  {
>  	struct i2c_mux_core *muxc = platform_get_drvdata(pdev);
> -	struct i2c_mux_pinctrl *mux = i2c_mux_priv(muxc);
> -	int i;
> -
> -	for (i = 0; i < mux->pdata->bus_count; i++)
> -		i2c_del_mux_adapter(mux->busses[i]);
>  
> +	i2c_del_mux_adapters(muxc);
>  	i2c_put_adapter(muxc->parent);
> -
>  	return 0;
>  }
>  
> diff --git a/drivers/i2c/muxes/i2c-mux-reg.c b/drivers/i2c/muxes/i2c-mux-reg.c
> index 3b01e7809a66..5c004ff5b6ad 100644
> --- a/drivers/i2c/muxes/i2c-mux-reg.c
> +++ b/drivers/i2c/muxes/i2c-mux-reg.c
> @@ -21,7 +21,6 @@
>  #include <linux/slab.h>
>  
>  struct regmux {
> -	struct i2c_adapter **adap; /* child busses */
>  	struct i2c_mux_reg_platform_data data;
>  };
>  
> @@ -214,13 +213,9 @@ static int i2c_mux_reg_probe(struct platform_device *pdev)
>  		return -EINVAL;
>  	}
>  
> -	mux->adap = devm_kzalloc(&pdev->dev,
> -				 sizeof(*mux->adap) * mux->data.n_values,
> -				 GFP_KERNEL);
> -	if (!mux->adap) {
> -		dev_err(&pdev->dev, "Cannot allocate i2c_adapter structure");
> -		return -ENOMEM;
> -	}
> +	ret = i2c_mux_reserve_adapters(muxc, mux->data.n_values);
> +	if (ret)
> +		return ret;
>  
>  	muxc->select = i2c_mux_reg_select;
>  	if (mux->data.idle_in_use)
> @@ -232,11 +227,9 @@ static int i2c_mux_reg_probe(struct platform_device *pdev)
>  		nr = mux->data.base_nr ? (mux->data.base_nr + i) : 0;
>  		class = mux->data.classes ? mux->data.classes[i] : 0;
>  
> -		mux->adap[i] = i2c_add_mux_adapter(muxc, &pdev->dev,
> -						   nr, mux->data.values[i],
> -						   class);
> -		if (!mux->adap[i]) {
> -			ret = -ENODEV;
> +		ret = i2c_add_mux_adapter(muxc, &pdev->dev, nr,
> +					  mux->data.values[i], class);
> +		if (ret) {
>  			dev_err(&pdev->dev, "Failed to add adapter %d\n", i);
>  			goto add_adapter_failed;
>  		}
> @@ -248,8 +241,7 @@ static int i2c_mux_reg_probe(struct platform_device *pdev)
>  	return 0;
>  
>  add_adapter_failed:
> -	for (; i > 0; i--)
> -		i2c_del_mux_adapter(mux->adap[i - 1]);
> +	i2c_del_mux_adapters(muxc);
>  
>  	return ret;
>  }
> @@ -257,12 +249,8 @@ add_adapter_failed:
>  static int i2c_mux_reg_remove(struct platform_device *pdev)
>  {
>  	struct i2c_mux_core *muxc = platform_get_drvdata(pdev);
> -	struct regmux *mux = i2c_mux_priv(muxc);
> -	int i;
> -
> -	for (i = 0; i < mux->data.n_values; i++)
> -		i2c_del_mux_adapter(mux->adap[i]);
>  
> +	i2c_del_mux_adapters(muxc);
>  	i2c_put_adapter(muxc->parent);
>  
>  	return 0;
> diff --git a/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c b/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c
> index 0a47396bc5be..a9a163c1c22c 100644
> --- a/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c
> +++ b/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c
> @@ -850,13 +850,9 @@ static int inv_mpu_probe(struct i2c_client *client,
>  	st->muxc->select = inv_mpu6050_select_bypass;
>  	st->muxc->deselect = inv_mpu6050_deselect_bypass;
>  
> -	st->mux_adapter = i2c_add_mux_adapter(st->muxc,
> -					      &client->dev,
> -					      0, 0, 0);
> -	if (!st->mux_adapter) {
> -		result = -ENODEV;
> +	result = i2c_add_mux_adapter(st->muxc, &client->dev, 0, 0, 0);
> +	if (result)
>  		goto out_unreg_device;
> -	}
>  
>  	result = inv_mpu_acpi_create_mux_client(st);
>  	if (result)
> @@ -865,7 +861,7 @@ static int inv_mpu_probe(struct i2c_client *client,
>  	return 0;
>  
>  out_del_mux:
> -	i2c_del_mux_adapter(st->mux_adapter);
> +	i2c_del_mux_adapters(st->muxc);
>  out_unreg_device:
>  	iio_device_unregister(indio_dev);
>  out_remove_trigger:
> @@ -881,7 +877,7 @@ static int inv_mpu_remove(struct i2c_client *client)
>  	struct inv_mpu6050_state *st = iio_priv(indio_dev);
>  
>  	inv_mpu_acpi_delete_mux_client(st);
> -	i2c_del_mux_adapter(st->mux_adapter);
> +	i2c_del_mux_adapters(st->muxc);
>  	iio_device_unregister(indio_dev);
>  	inv_mpu6050_remove_trigger(st);
>  	iio_triggered_buffer_cleanup(indio_dev);
> diff --git a/drivers/iio/imu/inv_mpu6050/inv_mpu_iio.h b/drivers/iio/imu/inv_mpu6050/inv_mpu_iio.h
> index d4929db4b40e..72113b59132e 100644
> --- a/drivers/iio/imu/inv_mpu6050/inv_mpu_iio.h
> +++ b/drivers/iio/imu/inv_mpu6050/inv_mpu_iio.h
> @@ -121,7 +121,6 @@ struct inv_mpu6050_state {
>  	spinlock_t time_stamp_lock;
>  	struct i2c_client *client;
>  	struct i2c_mux_core *muxc;
> -	struct i2c_adapter *mux_adapter;
>  	struct i2c_client *mux_client;
>  	unsigned int powerup_count;
>  	struct inv_mpu6050_platform_data plat_data;
> diff --git a/drivers/media/dvb-frontends/m88ds3103.c b/drivers/media/dvb-frontends/m88ds3103.c
> index c9f8296ea421..deab5cdba01f 100644
> --- a/drivers/media/dvb-frontends/m88ds3103.c
> +++ b/drivers/media/dvb-frontends/m88ds3103.c
> @@ -1374,7 +1374,7 @@ static struct i2c_adapter *m88ds3103_get_i2c_adapter(struct i2c_client *client)
>  
>  	dev_dbg(&client->dev, "\n");
>  
> -	return dev->i2c_adapter;
> +	return dev->muxc->adapter[0];
>  }
>  
>  static int m88ds3103_probe(struct i2c_client *client,
> @@ -1476,12 +1476,9 @@ static int m88ds3103_probe(struct i2c_client *client,
>  	dev->muxc->select = m88ds3103_select;
>  
>  	/* create mux i2c adapter for tuner */
> -	dev->i2c_adapter = i2c_add_mux_adapter(dev->muxc, &client->dev,
> -					       0, 0, 0);
> -	if (dev->i2c_adapter == NULL) {
> -		ret = -ENOMEM;
> +	ret = i2c_add_mux_adapter(dev->muxc, &client->dev, 0, 0, 0);
> +	if (ret)
>  		goto err_kfree;
> -	}
>  
>  	/* create dvb_frontend */
>  	memcpy(&dev->fe.ops, &m88ds3103_ops, sizeof(struct dvb_frontend_ops));
> @@ -1510,7 +1507,7 @@ static int m88ds3103_remove(struct i2c_client *client)
>  
>  	dev_dbg(&client->dev, "\n");
>  
> -	i2c_del_mux_adapter(dev->i2c_adapter);
> +	i2c_del_mux_adapters(dev->muxc);
>  
>  	kfree(dev);
>  	return 0;
> diff --git a/drivers/media/dvb-frontends/m88ds3103_priv.h b/drivers/media/dvb-frontends/m88ds3103_priv.h
> index 52d66c566ac1..c5b4e177c6ea 100644
> --- a/drivers/media/dvb-frontends/m88ds3103_priv.h
> +++ b/drivers/media/dvb-frontends/m88ds3103_priv.h
> @@ -43,7 +43,6 @@ struct m88ds3103_dev {
>  	u32 dvbv3_ber; /* for old DVBv3 API read_ber */
>  	bool warm; /* FW running */
>  	struct i2c_mux_core *muxc;
> -	struct i2c_adapter *i2c_adapter;
>  	/* auto detect chip id to do different config */
>  	u8 chip_id;
>  	/* main mclk is calculated for M88RS6000 dynamically */
> diff --git a/drivers/media/dvb-frontends/rtl2830.c b/drivers/media/dvb-frontends/rtl2830.c
> index d6330e8d5fa4..9864740722dd 100644
> --- a/drivers/media/dvb-frontends/rtl2830.c
> +++ b/drivers/media/dvb-frontends/rtl2830.c
> @@ -712,7 +712,7 @@ static struct i2c_adapter *rtl2830_get_i2c_adapter(struct i2c_client *client)
>  
>  	dev_dbg(&client->dev, "\n");
>  
> -	return dev->adapter;
> +	return dev->muxc->adapter[0];
>  }
>  
>  /*
> @@ -874,11 +874,9 @@ static int rtl2830_probe(struct i2c_client *client,
>  	dev->muxc->select = rtl2830_select;
>  
>  	/* create muxed i2c adapter for tuner */
> -	dev->adapter = i2c_add_mux_adapter(dev->muxc, &client->dev, 0, 0, 0);
> -	if (dev->adapter == NULL) {
> -		ret = -ENODEV;
> +	ret = i2c_add_mux_adapter(dev->muxc, &client->dev, 0, 0, 0);
> +	if (ret)
>  		goto err_regmap_exit;
> -	}
>  
>  	/* create dvb frontend */
>  	memcpy(&dev->fe.ops, &rtl2830_ops, sizeof(dev->fe.ops));
> @@ -908,7 +906,7 @@ static int rtl2830_remove(struct i2c_client *client)
>  
>  	dev_dbg(&client->dev, "\n");
>  
> -	i2c_del_mux_adapter(dev->adapter);
> +	i2c_del_mux_adapters(dev->muxc);
>  	regmap_exit(dev->regmap);
>  	kfree(dev);
>  
> diff --git a/drivers/media/dvb-frontends/rtl2830_priv.h b/drivers/media/dvb-frontends/rtl2830_priv.h
> index 2169c8d9c99c..da4909543da2 100644
> --- a/drivers/media/dvb-frontends/rtl2830_priv.h
> +++ b/drivers/media/dvb-frontends/rtl2830_priv.h
> @@ -30,7 +30,6 @@ struct rtl2830_dev {
>  	struct i2c_client *client;
>  	struct regmap *regmap;
>  	struct i2c_mux_core *muxc;
> -	struct i2c_adapter *adapter;
>  	struct dvb_frontend fe;
>  	bool sleeping;
>  	unsigned long filters;
> diff --git a/drivers/media/dvb-frontends/rtl2832.c b/drivers/media/dvb-frontends/rtl2832.c
> index c8fd990fdae8..99d8dbf66fd7 100644
> --- a/drivers/media/dvb-frontends/rtl2832.c
> +++ b/drivers/media/dvb-frontends/rtl2832.c
> @@ -1074,7 +1074,7 @@ static struct i2c_adapter *rtl2832_get_i2c_adapter(struct i2c_client *client)
>  	struct rtl2832_dev *dev = i2c_get_clientdata(client);
>  
>  	dev_dbg(&client->dev, "\n");
> -	return dev->i2c_adapter_tuner;
> +	return dev->muxc->adapter[0];
>  }
>  
>  static int rtl2832_enable_slave_ts(struct i2c_client *client)
> @@ -1271,12 +1271,9 @@ static int rtl2832_probe(struct i2c_client *client,
>  	dev->muxc->deselect = rtl2832_deselect;
>  
>  	/* create muxed i2c adapter for demod tuner bus */
> -	dev->i2c_adapter_tuner = i2c_add_mux_adapter(dev->muxc, &i2c->dev,
> -						     0, 0, 0);
> -	if (dev->i2c_adapter_tuner == NULL) {
> -		ret = -ENODEV;
> +	ret = i2c_add_mux_adapter(dev->muxc, &i2c->dev, 0, 0, 0);
> +	if (ret)
>  		goto err_regmap_exit;
> -	}
>  
>  	/* create dvb_frontend */
>  	memcpy(&dev->fe.ops, &rtl2832_ops, sizeof(struct dvb_frontend_ops));
> @@ -1311,7 +1308,7 @@ static int rtl2832_remove(struct i2c_client *client)
>  
>  	cancel_delayed_work_sync(&dev->i2c_gate_work);
>  
> -	i2c_del_mux_adapter(dev->i2c_adapter_tuner);
> +	i2c_del_mux_adapters(dev->muxc);
>  
>  	regmap_exit(dev->regmap);
>  
> diff --git a/drivers/media/dvb-frontends/rtl2832_priv.h b/drivers/media/dvb-frontends/rtl2832_priv.h
> index 2d252bd5b8b1..6b3cd23a2c26 100644
> --- a/drivers/media/dvb-frontends/rtl2832_priv.h
> +++ b/drivers/media/dvb-frontends/rtl2832_priv.h
> @@ -37,7 +37,6 @@ struct rtl2832_dev {
>  	struct regmap_config regmap_config;
>  	struct regmap *regmap;
>  	struct i2c_mux_core *muxc;
> -	struct i2c_adapter *i2c_adapter_tuner;
>  	struct dvb_frontend fe;
>  	struct delayed_work stat_work;
>  	enum fe_status fe_status;
> diff --git a/drivers/media/dvb-frontends/si2168.c b/drivers/media/dvb-frontends/si2168.c
> index 5b1872b1bbf4..06aa496cc42c 100644
> --- a/drivers/media/dvb-frontends/si2168.c
> +++ b/drivers/media/dvb-frontends/si2168.c
> @@ -719,16 +719,14 @@ static int si2168_probe(struct i2c_client *client,
>  	dev->muxc->deselect = si2168_deselect;
>  
>  	/* create mux i2c adapter for tuner */
> -	dev->adapter = i2c_add_mux_adapter(dev->muxc, &client->dev, 0, 0, 0);
> -	if (dev->adapter == NULL) {
> -		ret = -ENODEV;
> +	ret = i2c_add_mux_adapter(dev->muxc, &client->dev, 0, 0, 0);
> +	if (ret)
>  		goto err_kfree;
> -	}
>  
>  	/* create dvb_frontend */
>  	memcpy(&dev->fe.ops, &si2168_ops, sizeof(struct dvb_frontend_ops));
>  	dev->fe.demodulator_priv = client;
> -	*config->i2c_adapter = dev->adapter;
> +	*config->i2c_adapter = dev->muxc->adapter[0];
>  	*config->fe = &dev->fe;
>  	dev->ts_mode = config->ts_mode;
>  	dev->ts_clock_inv = config->ts_clock_inv;
> @@ -752,7 +750,7 @@ static int si2168_remove(struct i2c_client *client)
>  
>  	dev_dbg(&client->dev, "\n");
>  
> -	i2c_del_mux_adapter(dev->adapter);
> +	i2c_del_mux_adapters(dev->muxc);
>  
>  	dev->fe.ops.release = NULL;
>  	dev->fe.demodulator_priv = NULL;
> diff --git a/drivers/media/dvb-frontends/si2168_priv.h b/drivers/media/dvb-frontends/si2168_priv.h
> index 53efb9d562da..165bf1412063 100644
> --- a/drivers/media/dvb-frontends/si2168_priv.h
> +++ b/drivers/media/dvb-frontends/si2168_priv.h
> @@ -30,7 +30,6 @@
>  /* state struct */
>  struct si2168_dev {
>  	struct i2c_mux_core *muxc;
> -	struct i2c_adapter *adapter;
>  	struct dvb_frontend fe;
>  	enum fe_delivery_system delivery_system;
>  	enum fe_status fe_status;
> diff --git a/drivers/media/usb/cx231xx/cx231xx-core.c b/drivers/media/usb/cx231xx/cx231xx-core.c
> index d805e192e4ca..7d7b04df6a22 100644
> --- a/drivers/media/usb/cx231xx/cx231xx-core.c
> +++ b/drivers/media/usb/cx231xx/cx231xx-core.c
> @@ -1416,8 +1416,7 @@ EXPORT_SYMBOL_GPL(cx231xx_dev_init);
>  void cx231xx_dev_uninit(struct cx231xx *dev)
>  {
>  	/* Un Initialize I2C bus */
> -	cx231xx_i2c_mux_unregister(dev, 1);
> -	cx231xx_i2c_mux_unregister(dev, 0);
> +	cx231xx_i2c_mux_unregister(dev);
>  	cx231xx_i2c_unregister(&dev->i2c_bus[2]);
>  	cx231xx_i2c_unregister(&dev->i2c_bus[1]);
>  	cx231xx_i2c_unregister(&dev->i2c_bus[0]);
> diff --git a/drivers/media/usb/cx231xx/cx231xx-i2c.c b/drivers/media/usb/cx231xx/cx231xx-i2c.c
> index 51760bfc7cbc..2b5adb056827 100644
> --- a/drivers/media/usb/cx231xx/cx231xx-i2c.c
> +++ b/drivers/media/usb/cx231xx/cx231xx-i2c.c
> @@ -579,23 +579,23 @@ int cx231xx_i2c_mux_register(struct cx231xx *dev, int mux_no)
>  {
>  	/* what is the correct mux_dev? */
>  	struct device *mux_dev = dev->dev;
> -
> -	dev->i2c_mux_adap[mux_no] = i2c_add_mux_adapter(dev->muxc,
> -				mux_dev,
> -				0,
> -				mux_no /* chan_id */,
> -				0 /* class */);
> -	if (!dev->i2c_mux_adap[mux_no])
> +	int rc;
> +
> +	rc = i2c_add_mux_adapter(dev->muxc,
> +				 mux_dev,
> +				 0,
> +				 mux_no /* chan_id */,
> +				 0 /* class */);
> +	if (rc)
>  		dev_warn(dev->dev,
>  			 "i2c mux %d register FAILED\n", mux_no);
>  
> -	return 0;
> +	return rc;
>  }
>  
> -void cx231xx_i2c_mux_unregister(struct cx231xx *dev, int mux_no)
> +void cx231xx_i2c_mux_unregister(struct cx231xx *dev)
>  {
> -	i2c_del_mux_adapter(dev->i2c_mux_adap[mux_no]);
> -	dev->i2c_mux_adap[mux_no] = NULL;
> +	i2c_del_mux_adapters(dev->muxc);
>  }
>  
>  struct i2c_adapter *cx231xx_get_i2c_adap(struct cx231xx *dev, int i2c_port)
> @@ -608,9 +608,9 @@ struct i2c_adapter *cx231xx_get_i2c_adap(struct cx231xx *dev, int i2c_port)
>  	case I2C_2:
>  		return &dev->i2c_bus[2].i2c_adap;
>  	case I2C_1_MUX_1:
> -		return dev->i2c_mux_adap[0];
> +		return dev->muxc->adapter[0];
>  	case I2C_1_MUX_3:
> -		return dev->i2c_mux_adap[1];
> +		return dev->muxc->adapter[1];
>  	default:
>  		return NULL;
>  	}
> diff --git a/drivers/media/usb/cx231xx/cx231xx.h b/drivers/media/usb/cx231xx/cx231xx.h
> index 72f8188e0b01..8c71fa8d777c 100644
> --- a/drivers/media/usb/cx231xx/cx231xx.h
> +++ b/drivers/media/usb/cx231xx/cx231xx.h
> @@ -762,7 +762,7 @@ int cx231xx_i2c_register(struct cx231xx_i2c *bus);
>  int cx231xx_i2c_unregister(struct cx231xx_i2c *bus);
>  int cx231xx_i2c_mux_create(struct cx231xx *dev);
>  int cx231xx_i2c_mux_register(struct cx231xx *dev, int mux_no);
> -void cx231xx_i2c_mux_unregister(struct cx231xx *dev, int mux_no);
> +void cx231xx_i2c_mux_unregister(struct cx231xx *dev);
>  struct i2c_adapter *cx231xx_get_i2c_adap(struct cx231xx *dev, int i2c_port);
>  
>  /* Internal block control functions */
> diff --git a/drivers/of/unittest.c b/drivers/of/unittest.c
> index a4abd9b588b9..77ccc54cfdc9 100644
> --- a/drivers/of/unittest.c
> +++ b/drivers/of/unittest.c
> @@ -1677,11 +1677,6 @@ static struct i2c_driver unittest_i2c_dev_driver = {
>  
>  #if IS_BUILTIN(CONFIG_I2C_MUX)
>  
> -struct unittest_i2c_mux_data {
> -	int nchans;
> -	struct i2c_adapter *adap[];
> -};
> -
>  static int unittest_i2c_mux_select_chan(struct i2c_mux_core *muxc, u32 chan)
>  {
>  	return 0;
> @@ -1690,12 +1685,11 @@ static int unittest_i2c_mux_select_chan(struct i2c_mux_core *muxc, u32 chan)
>  static int unittest_i2c_mux_probe(struct i2c_client *client,
>  		const struct i2c_device_id *id)
>  {
> -	int ret, i, nchans, size;
> +	int ret, i, nchans;
>  	struct device *dev = &client->dev;
>  	struct i2c_adapter *adap = to_i2c_adapter(dev->parent);
>  	struct device_node *np = client->dev.of_node, *child;
>  	struct i2c_mux_core *muxc;
> -	struct unittest_i2c_mux_data *stm;
>  	u32 reg, max_reg;
>  
>  	dev_dbg(dev, "%s for node @%s\n", __func__, np->full_name);
> @@ -1719,20 +1713,19 @@ static int unittest_i2c_mux_probe(struct i2c_client *client,
>  		return -EINVAL;
>  	}
>  
> -	size = offsetof(struct unittest_i2c_mux_data, adap[nchans]);
> -	muxc = i2c_mux_alloc(dev, size);
> +	muxc = i2c_mux_alloc(dev, 0);
>  	if (!muxc)
>  		return -ENOMEM;
>  	muxc->parent = adap;
>  	muxc->select = unittest_i2c_mux_select_chan;
> -	stm = i2c_mux_priv(muxc);
> -	stm->nchans = nchans;
> +	ret = i2c_mux_reserve_adapters(muxc, nchans);
> +	if (ret)
> +		return ret;
>  	for (i = 0; i < nchans; i++) {
> -		stm->adap[i] = i2c_add_mux_adapter(muxc, dev, 0, i, 0);
> -		if (!stm->adap[i]) {
> +		ret = i2c_add_mux_adapter(muxc, dev, 0, i, 0);
> +		if (ret) {
>  			dev_err(dev, "Failed to register mux #%d\n", i);
> -			for (i--; i >= 0; i--)
> -				i2c_del_mux_adapter(stm->adap[i]);
> +			i2c_del_mux_adapters(muxc);
>  			return -ENODEV;
>  		}
>  	}
> @@ -1747,12 +1740,9 @@ static int unittest_i2c_mux_remove(struct i2c_client *client)
>  	struct device *dev = &client->dev;
>  	struct device_node *np = client->dev.of_node;
>  	struct i2c_mux_core *muxc = i2c_get_clientdata(client);
> -	struct unittest_i2c_mux_data *stm = i2c_mux_priv(muxc);
> -	int i;
>  
>  	dev_dbg(dev, "%s for node @%s\n", __func__, np->full_name);
> -	for (i = stm->nchans - 1; i >= 0; i--)
> -		i2c_del_mux_adapter(stm->adap[i]);
> +	i2c_del_mux_adapters(muxc);
>  	return 0;
>  }
>  
> diff --git a/include/linux/i2c-mux.h b/include/linux/i2c-mux.h
> index 5cd6e1e664e0..bfcdcc46f2a6 100644
> --- a/include/linux/i2c-mux.h
> +++ b/include/linux/i2c-mux.h
> @@ -29,6 +29,9 @@
>  
>  struct i2c_mux_core {
>  	struct i2c_adapter *parent;
> +	struct i2c_adapter **adapter;
> +	int adapters;
> +	int max_adapters;
>  	struct device *dev;
>  
>  	void *priv;
> @@ -44,18 +47,20 @@ static inline void *i2c_mux_priv(struct i2c_mux_core *muxc)
>  	return muxc->priv;
>  }
>  
> +int i2c_mux_reserve_adapters(struct i2c_mux_core *muxc, int adapters);
> +
>  /*
>   * Called to create a i2c bus on a multiplexed bus segment.
>   * The mux_dev and chan_id parameters are passed to the select
>   * and deselect callback functions to perform hardware-specific
>   * mux control.
>   */
> -struct i2c_adapter *i2c_add_mux_adapter(struct i2c_mux_core *muxc,
> -					struct device *mux_dev,
> -					u32 force_nr, u32 chan_id,
> -					unsigned int class);
> +int i2c_add_mux_adapter(struct i2c_mux_core *muxc,
> +			struct device *mux_dev,
> +			u32 force_nr, u32 chan_id,
> +			unsigned int class);
>  
> -void i2c_del_mux_adapter(struct i2c_adapter *adap);
> +void i2c_del_mux_adapters(struct i2c_mux_core *muxc);
>  
>  #endif /* __KERNEL__ */
>  
> 
