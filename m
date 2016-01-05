Return-path: <linux-media-owner@vger.kernel.org>
Received: from bh-25.webhostbox.net ([208.91.199.152]:45990 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044AbcAEQmO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Jan 2016 11:42:14 -0500
Subject: Re: [PATCH v2 1/8] i2c-mux: add common core data for every mux
 instance
To: Peter Rosin <peda@lysator.liu.se>, Wolfram Sang <wsa@the-dreams.de>
References: <1452009438-27347-1-git-send-email-peda@lysator.liu.se>
 <1452009438-27347-2-git-send-email-peda@lysator.liu.se>
Cc: Peter Rosin <peda@axentia.se>, Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	Peter Korsgaard <peter.korsgaard@barco.com>,
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
From: Guenter Roeck <linux@roeck-us.net>
Message-ID: <568BF25B.5030905@roeck-us.net>
Date: Tue, 5 Jan 2016 08:42:03 -0800
MIME-Version: 1.0
In-Reply-To: <1452009438-27347-2-git-send-email-peda@lysator.liu.se>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/05/2016 07:57 AM, Peter Rosin wrote:
> From: Peter Rosin <peda@axentia.se>
>
> The initial core mux structure starts off small with only the parent
> adapter pointer, which all muxes have, and a priv pointer for mux
> driver private data.
>
> Add i2c_mux_alloc function to unify the creation of a mux.
>
> Where appropriate, pass around the mux core structure instead of the
> parent adapter or the driver private data.
>
> Remove the parent adapter pointer from the driver private data for all
> mux drivers.
>
> Signed-off-by: Peter Rosin <peda@axentia.se>
> ---
>   drivers/i2c/i2c-mux.c                        | 28 +++++++++++++++++-----
>   drivers/i2c/muxes/i2c-arb-gpio-challenge.c   | 24 +++++++++----------
>   drivers/i2c/muxes/i2c-mux-gpio.c             | 20 ++++++++--------
>   drivers/i2c/muxes/i2c-mux-pca9541.c          | 35 ++++++++++++++--------------
>   drivers/i2c/muxes/i2c-mux-pca954x.c          | 19 ++++++++++-----
>   drivers/i2c/muxes/i2c-mux-pinctrl.c          | 23 +++++++++---------
>   drivers/i2c/muxes/i2c-mux-reg.c              | 23 ++++++++++--------
>   drivers/iio/imu/inv_mpu6050/inv_mpu_core.c   | 10 +++++++-
>   drivers/iio/imu/inv_mpu6050/inv_mpu_iio.h    |  1 +
>   drivers/media/dvb-frontends/m88ds3103.c      | 10 +++++++-
>   drivers/media/dvb-frontends/m88ds3103_priv.h |  1 +
>   drivers/media/dvb-frontends/rtl2830.c        | 10 +++++++-
>   drivers/media/dvb-frontends/rtl2830_priv.h   |  1 +
>   drivers/media/dvb-frontends/rtl2832.c        | 10 +++++++-
>   drivers/media/dvb-frontends/rtl2832_priv.h   |  1 +
>   drivers/media/dvb-frontends/si2168.c         | 10 +++++++-
>   drivers/media/dvb-frontends/si2168_priv.h    |  1 +
>   drivers/media/usb/cx231xx/cx231xx-core.c     |  3 +++
>   drivers/media/usb/cx231xx/cx231xx-i2c.c      | 13 +++++++++--
>   drivers/media/usb/cx231xx/cx231xx.h          |  2 ++
>   drivers/of/unittest.c                        | 16 +++++++------
>   include/linux/i2c-mux.h                      | 14 ++++++++++-
>   22 files changed, 187 insertions(+), 88 deletions(-)
>
> diff --git a/drivers/i2c/i2c-mux.c b/drivers/i2c/i2c-mux.c
> index 00fc5b1c7b66..c2163f6b51d5 100644
> --- a/drivers/i2c/i2c-mux.c
> +++ b/drivers/i2c/i2c-mux.c
> @@ -31,8 +31,8 @@
>   struct i2c_mux_priv {
>   	struct i2c_adapter adap;
>   	struct i2c_algorithm algo;
> +	struct i2c_mux_core *muxc;
>
> -	struct i2c_adapter *parent;
>   	struct device *mux_dev;
>   	void *mux_priv;
>   	u32 chan_id;
> @@ -45,7 +45,8 @@ static int i2c_mux_master_xfer(struct i2c_adapter *adap,
>   			       struct i2c_msg msgs[], int num)
>   {
>   	struct i2c_mux_priv *priv = adap->algo_data;
> -	struct i2c_adapter *parent = priv->parent;
> +	struct i2c_mux_core *muxc = priv->muxc;
> +	struct i2c_adapter *parent = muxc->parent;
>   	int ret;
>
>   	/* Switch to the right mux port and perform the transfer. */
> @@ -65,7 +66,8 @@ static int i2c_mux_smbus_xfer(struct i2c_adapter *adap,
>   			      int size, union i2c_smbus_data *data)
>   {
>   	struct i2c_mux_priv *priv = adap->algo_data;
> -	struct i2c_adapter *parent = priv->parent;
> +	struct i2c_mux_core *muxc = priv->muxc;
> +	struct i2c_adapter *parent = muxc->parent;
>   	int ret;
>
>   	/* Select the right mux port and perform the transfer. */
> @@ -84,7 +86,7 @@ static int i2c_mux_smbus_xfer(struct i2c_adapter *adap,
>   static u32 i2c_mux_functionality(struct i2c_adapter *adap)
>   {
>   	struct i2c_mux_priv *priv = adap->algo_data;
> -	struct i2c_adapter *parent = priv->parent;
> +	struct i2c_adapter *parent = priv->muxc->parent;
>
>   	return parent->algo->functionality(parent);
>   }
> @@ -102,7 +104,20 @@ static unsigned int i2c_mux_parent_classes(struct i2c_adapter *parent)
>   	return class;
>   }
>
> -struct i2c_adapter *i2c_add_mux_adapter(struct i2c_adapter *parent,
> +struct i2c_mux_core *i2c_mux_alloc(struct device *dev, int sizeof_priv)
> +{
> +	struct i2c_mux_core *muxc;
> +
> +	muxc = devm_kzalloc(dev, sizeof(*muxc) + sizeof_priv, GFP_KERNEL);
> +	if (!muxc)
> +		return NULL;
> +	if (sizeof_priv)
> +		muxc->priv = muxc + 1;
> +	return muxc;
> +}
> +EXPORT_SYMBOL_GPL(i2c_mux_alloc);
> +
> +struct i2c_adapter *i2c_add_mux_adapter(struct i2c_mux_core *muxc,
>   				struct device *mux_dev,
>   				void *mux_priv, u32 force_nr, u32 chan_id,
>   				unsigned int class,
> @@ -111,6 +126,7 @@ struct i2c_adapter *i2c_add_mux_adapter(struct i2c_adapter *parent,
>   				int (*deselect) (struct i2c_adapter *,
>   						 void *, u32))
>   {
> +	struct i2c_adapter *parent = muxc->parent;
>   	struct i2c_mux_priv *priv;
>   	char symlink_name[20];
>   	int ret;
> @@ -120,7 +136,7 @@ struct i2c_adapter *i2c_add_mux_adapter(struct i2c_adapter *parent,
>   		return NULL;
>
>   	/* Set up private adapter data */
> -	priv->parent = parent;
> +	priv->muxc = muxc;
>   	priv->mux_dev = mux_dev;
>   	priv->mux_priv = mux_priv;
>   	priv->chan_id = chan_id;
> diff --git a/drivers/i2c/muxes/i2c-arb-gpio-challenge.c b/drivers/i2c/muxes/i2c-arb-gpio-challenge.c
> index 402e3a6c671a..6e27ea4fb25a 100644
> --- a/drivers/i2c/muxes/i2c-arb-gpio-challenge.c
> +++ b/drivers/i2c/muxes/i2c-arb-gpio-challenge.c
> @@ -42,7 +42,6 @@
>    */
>
>   struct i2c_arbitrator_data {
> -	struct i2c_adapter *parent;
>   	struct i2c_adapter *child;
>   	int our_gpio;
>   	int our_gpio_release;
> @@ -119,6 +118,7 @@ static int i2c_arbitrator_probe(struct platform_device *pdev)
>   	struct device *dev = &pdev->dev;
>   	struct device_node *np = dev->of_node;
>   	struct device_node *parent_np;
> +	struct i2c_mux_core *muxc;
>   	struct i2c_arbitrator_data *arb;
>   	enum of_gpio_flags gpio_flags;
>   	unsigned long out_init;
> @@ -134,13 +134,12 @@ static int i2c_arbitrator_probe(struct platform_device *pdev)
>   		return -EINVAL;
>   	}
>
> -	arb = devm_kzalloc(dev, sizeof(*arb), GFP_KERNEL);
> -	if (!arb) {
> -		dev_err(dev, "Cannot allocate i2c_arbitrator_data\n");
> +	muxc = i2c_mux_alloc(dev, sizeof(*arb));
> +	if (!muxc)
>   		return -ENOMEM;
> -	}
> -	platform_set_drvdata(pdev, arb);
> +	arb = i2c_mux_priv(muxc);
>
> +	platform_set_drvdata(pdev, muxc);
>   	/* Request GPIOs */
>   	ret = of_get_named_gpio_flags(np, "our-claim-gpio", 0, &gpio_flags);
>   	if (!gpio_is_valid(ret)) {
> @@ -196,21 +195,21 @@ static int i2c_arbitrator_probe(struct platform_device *pdev)
>   		dev_err(dev, "Cannot parse i2c-parent\n");
>   		return -EINVAL;
>   	}
> -	arb->parent = of_get_i2c_adapter_by_node(parent_np);
> +	muxc->parent = of_find_i2c_adapter_by_node(parent_np);
>   	of_node_put(parent_np);
> -	if (!arb->parent) {
> +	if (!muxc->parent) {
>   		dev_err(dev, "Cannot find parent bus\n");
>   		return -EPROBE_DEFER;
>   	}
>
>   	/* Actually add the mux adapter */
> -	arb->child = i2c_add_mux_adapter(arb->parent, dev, arb, 0, 0, 0,
> +	arb->child = i2c_add_mux_adapter(muxc, dev, arb, 0, 0, 0,
>   					 i2c_arbitrator_select,
>   					 i2c_arbitrator_deselect);
>   	if (!arb->child) {
>   		dev_err(dev, "Failed to add adapter\n");
>   		ret = -ENODEV;
> -		i2c_put_adapter(arb->parent);
> +		i2c_put_adapter(muxc->parent);
>   	}
>
>   	return ret;
> @@ -218,10 +217,11 @@ static int i2c_arbitrator_probe(struct platform_device *pdev)
>
>   static int i2c_arbitrator_remove(struct platform_device *pdev)
>   {
> -	struct i2c_arbitrator_data *arb = platform_get_drvdata(pdev);
> +	struct i2c_mux_core *muxc = platform_get_drvdata(pdev);
> +	struct i2c_arbitrator_data *arb = i2c_mux_priv(muxc);
>
>   	i2c_del_mux_adapter(arb->child);
> -	i2c_put_adapter(arb->parent);
> +	i2c_put_adapter(muxc->parent);
>
>   	return 0;
>   }
> diff --git a/drivers/i2c/muxes/i2c-mux-gpio.c b/drivers/i2c/muxes/i2c-mux-gpio.c
> index b8e11c16d98c..ee43dd76a4d7 100644
> --- a/drivers/i2c/muxes/i2c-mux-gpio.c
> +++ b/drivers/i2c/muxes/i2c-mux-gpio.c
> @@ -18,7 +18,6 @@
>   #include <linux/of_gpio.h>
>
>   struct gpiomux {
> -	struct i2c_adapter *parent;
>   	struct i2c_adapter **adap; /* child busses */
>   	struct i2c_mux_gpio_platform_data data;
>   	unsigned gpio_base;
> @@ -136,19 +135,19 @@ static int i2c_mux_gpio_probe_dt(struct gpiomux *mux,
>
>   static int i2c_mux_gpio_probe(struct platform_device *pdev)
>   {
> +	struct i2c_mux_core *muxc;
>   	struct gpiomux *mux;
>   	struct i2c_adapter *parent;
>   	int (*deselect) (struct i2c_adapter *, void *, u32);
>   	unsigned initial_state, gpio_base;
>   	int i, ret;
>
> -	mux = devm_kzalloc(&pdev->dev, sizeof(*mux), GFP_KERNEL);
> -	if (!mux) {
> -		dev_err(&pdev->dev, "Cannot allocate gpiomux structure");
> +	muxc = i2c_mux_alloc(&pdev->dev, sizeof(*mux));
> +	if (!muxc)
>   		return -ENOMEM;
> -	}
> +	mux = i2c_mux_priv(muxc);
>
> -	platform_set_drvdata(pdev, mux);
> +	platform_set_drvdata(pdev, muxc);
>
>   	if (!dev_get_platdata(&pdev->dev)) {
>   		ret = i2c_mux_gpio_probe_dt(mux, pdev);
> @@ -180,7 +179,7 @@ static int i2c_mux_gpio_probe(struct platform_device *pdev)
>   	if (!parent)
>   		return -EPROBE_DEFER;
>
> -	mux->parent = parent;
> +	muxc->parent = parent;
>   	mux->gpio_base = gpio_base;
>
>   	mux->adap = devm_kzalloc(&pdev->dev,
> @@ -223,7 +222,7 @@ static int i2c_mux_gpio_probe(struct platform_device *pdev)
>   		u32 nr = mux->data.base_nr ? (mux->data.base_nr + i) : 0;
>   		unsigned int class = mux->data.classes ? mux->data.classes[i] : 0;
>
> -		mux->adap[i] = i2c_add_mux_adapter(parent, &pdev->dev, mux, nr,
> +		mux->adap[i] = i2c_add_mux_adapter(muxc, &pdev->dev, mux, nr,
>   						   mux->data.values[i], class,
>   						   i2c_mux_gpio_select, deselect);
>   		if (!mux->adap[i]) {
> @@ -253,7 +252,8 @@ alloc_failed:
>
>   static int i2c_mux_gpio_remove(struct platform_device *pdev)
>   {
> -	struct gpiomux *mux = platform_get_drvdata(pdev);
> +	struct i2c_mux_core *muxc = platform_get_drvdata(pdev);
> +	struct gpiomux *mux = i2c_mux_priv(muxc);
>   	int i;
>
>   	for (i = 0; i < mux->data.n_values; i++)
> @@ -262,7 +262,7 @@ static int i2c_mux_gpio_remove(struct platform_device *pdev)
>   	for (i = 0; i < mux->data.n_gpios; i++)
>   		gpio_free(mux->gpio_base + mux->data.gpios[i]);
>
> -	i2c_put_adapter(mux->parent);
> +	i2c_put_adapter(muxc->parent);
>
>   	return 0;
>   }
> diff --git a/drivers/i2c/muxes/i2c-mux-pca9541.c b/drivers/i2c/muxes/i2c-mux-pca9541.c
> index d0ba424adebc..47ae2259d1ca 100644
> --- a/drivers/i2c/muxes/i2c-mux-pca9541.c
> +++ b/drivers/i2c/muxes/i2c-mux-pca9541.c
> @@ -73,6 +73,7 @@
>   #define SELECT_DELAY_LONG	1000
>
>   struct pca9541 {
> +	struct i2c_client *client;

I fail to see where this is being used.

>   	struct i2c_adapter *mux_adap;
>   	unsigned long select_timeout;
>   	unsigned long arb_timeout;
> @@ -217,7 +218,8 @@ static const u8 pca9541_control[16] = {
>    */
>   static int pca9541_arbitrate(struct i2c_client *client)
>   {
> -	struct pca9541 *data = i2c_get_clientdata(client);
> +	struct i2c_mux_core *muxc = i2c_get_clientdata(client);
> +	struct pca9541 *data = i2c_mux_priv(muxc);
>   	int reg;
>
>   	reg = pca9541_reg_read(client, PCA9541_CONTROL);
> @@ -324,20 +326,22 @@ static int pca9541_probe(struct i2c_client *client,
>   {
>   	struct i2c_adapter *adap = client->adapter;
>   	struct pca954x_platform_data *pdata = dev_get_platdata(&client->dev);
> +	struct i2c_mux_core *muxc;
>   	struct pca9541 *data;
>   	int force;
> -	int ret = -ENODEV;
>
>   	if (!i2c_check_functionality(adap, I2C_FUNC_SMBUS_BYTE_DATA))
> -		goto err;
> +		return -ENODEV;
>
> -	data = kzalloc(sizeof(struct pca9541), GFP_KERNEL);
> -	if (!data) {
> -		ret = -ENOMEM;
> -		goto err;
> -	}
> +	muxc = i2c_mux_alloc(&client->dev, sizeof(*data));
> +	if (!muxc)
> +		return -ENOMEM;
> +	data = i2c_mux_priv(muxc);
> +
> +	i2c_set_clientdata(client, muxc);
>
> -	i2c_set_clientdata(client, data);
> +	data->client = client;
> +	muxc->parent = adap;
>
>   	/*
>   	 * I2C accesses are unprotected here.
> @@ -352,34 +356,29 @@ static int pca9541_probe(struct i2c_client *client,
>   	force = 0;
>   	if (pdata)
>   		force = pdata->modes[0].adap_id;
> -	data->mux_adap = i2c_add_mux_adapter(adap, &client->dev, client,
> +	data->mux_adap = i2c_add_mux_adapter(muxc, &client->dev, client,
>   					     force, 0, 0,
>   					     pca9541_select_chan,
>   					     pca9541_release_chan);
>
>   	if (data->mux_adap == NULL) {
>   		dev_err(&client->dev, "failed to register master selector\n");
> -		goto exit_free;
> +		return -ENODEV;
>   	}
>
>   	dev_info(&client->dev, "registered master selector for I2C %s\n",
>   		 client->name);
>
>   	return 0;
> -
> -exit_free:
> -	kfree(data);
> -err:
> -	return ret;
>   }
>
>   static int pca9541_remove(struct i2c_client *client)
>   {
> -	struct pca9541 *data = i2c_get_clientdata(client);
> +	struct i2c_mux_core *muxc = i2c_get_clientdata(client);
> +	struct pca9541 *data = i2c_mux_priv(muxc);
>
>   	i2c_del_mux_adapter(data->mux_adap);
>
> -	kfree(data);
>   	return 0;
>   }
>
> diff --git a/drivers/i2c/muxes/i2c-mux-pca954x.c b/drivers/i2c/muxes/i2c-mux-pca954x.c
> index acfcef3d4068..a4df831fae9d 100644
> --- a/drivers/i2c/muxes/i2c-mux-pca954x.c
> +++ b/drivers/i2c/muxes/i2c-mux-pca954x.c
> @@ -63,6 +63,7 @@ struct pca954x {
>   	struct i2c_adapter *virt_adaps[PCA954X_MAX_NCHANS];
>
>   	u8 last_chan;		/* last register value */
> +	struct i2c_client *client;

Same here.

Maybe it starts to be used in a later patch (I did not check), but then it should be defined
where it is used.

Thanks,
Guenter

