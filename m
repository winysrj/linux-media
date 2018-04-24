Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud8.xs4all.net ([194.109.24.21]:60485 "EHLO
        lb1-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751097AbeDXJ11 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 24 Apr 2018 05:27:27 -0400
Subject: Re: [PATCH v3 6/7] drm/i2c: tda998x: add CEC support
To: Russell King <rmk+kernel@armlinux.org.uk>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        devicetree@vger.kernel.org, linux-media@vger.kernel.org
References: <20180409121529.GA31403@n2100.armlinux.org.uk>
 <E1f5Viw-0002Lq-6r@rmk-PC.armlinux.org.uk>
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <da8dc179-cdb8-6ca5-666a-5683172499ec@xs4all.nl>
Date: Tue, 24 Apr 2018 11:27:23 +0200
MIME-Version: 1.0
In-Reply-To: <E1f5Viw-0002Lq-6r@rmk-PC.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 04/09/18 14:16, Russell King wrote:
> The TDA998x is a HDMI transmitter with a TDA9950 CEC engine integrated
> onto the same die.  Add support for the TDA9950 CEC engine to the
> TDA998x driver.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> ---
>  drivers/gpu/drm/i2c/Kconfig       |   1 +
>  drivers/gpu/drm/i2c/tda998x_drv.c | 195 ++++++++++++++++++++++++++++++++++++--
>  2 files changed, 187 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i2c/Kconfig b/drivers/gpu/drm/i2c/Kconfig
> index 3a232f5ff0a1..65d3acb61c03 100644
> --- a/drivers/gpu/drm/i2c/Kconfig
> +++ b/drivers/gpu/drm/i2c/Kconfig
> @@ -22,6 +22,7 @@ config DRM_I2C_SIL164
>  config DRM_I2C_NXP_TDA998X
>  	tristate "NXP Semiconductors TDA998X HDMI encoder"
>  	default m if DRM_TILCDC
> +	select CEC_CORE if CEC_NOTIFIER
>  	select SND_SOC_HDMI_CODEC if SND_SOC
>  	help
>  	  Support for NXP Semiconductors TDA998X HDMI encoders.
> diff --git a/drivers/gpu/drm/i2c/tda998x_drv.c b/drivers/gpu/drm/i2c/tda998x_drv.c
> index 16e0439cad44..eb9916bd84a4 100644
> --- a/drivers/gpu/drm/i2c/tda998x_drv.c
> +++ b/drivers/gpu/drm/i2c/tda998x_drv.c
> @@ -16,8 +16,10 @@
>   */
>  
>  #include <linux/component.h>
> +#include <linux/gpio/consumer.h>
>  #include <linux/hdmi.h>
>  #include <linux/module.h>
> +#include <linux/platform_data/tda9950.h>
>  #include <linux/irq.h>
>  #include <sound/asoundef.h>
>  #include <sound/hdmi-codec.h>
> @@ -29,6 +31,8 @@
>  #include <drm/drm_of.h>
>  #include <drm/i2c/tda998x.h>
>  
> +#include <media/cec-notifier.h>
> +
>  #define DBG(fmt, ...) DRM_DEBUG(fmt"\n", ##__VA_ARGS__)
>  
>  struct tda998x_audio_port {
> @@ -55,6 +59,7 @@ struct tda998x_priv {
>  	struct platform_device *audio_pdev;
>  	struct mutex audio_mutex;
>  
> +	struct mutex edid_mutex;
>  	wait_queue_head_t wq_edid;
>  	volatile int wq_edid_wait;
>  
> @@ -67,6 +72,9 @@ struct tda998x_priv {
>  	struct drm_connector connector;
>  
>  	struct tda998x_audio_port audio_port[2];
> +	struct tda9950_glue cec_glue;
> +	struct gpio_desc *calib;
> +	struct cec_notifier *cec_notify;
>  };
>  
>  #define conn_to_tda998x_priv(x) \
> @@ -345,6 +353,12 @@ struct tda998x_priv {
>  #define REG_CEC_INTSTATUS	  0xee		      /* read */
>  # define CEC_INTSTATUS_CEC	  (1 << 0)
>  # define CEC_INTSTATUS_HDMI	  (1 << 1)
> +#define REG_CEC_CAL_XOSC_CTRL1    0xf2
> +# define CEC_CAL_XOSC_CTRL1_ENA_CAL	BIT(0)
> +#define REG_CEC_DES_FREQ2         0xf5
> +# define CEC_DES_FREQ2_DIS_AUTOCAL BIT(7)
> +#define REG_CEC_CLK               0xf6
> +# define CEC_CLK_FRO              0x11
>  #define REG_CEC_FRO_IM_CLK_CTRL   0xfb                /* read/write */
>  # define CEC_FRO_IM_CLK_CTRL_GHOST_DIS (1 << 7)
>  # define CEC_FRO_IM_CLK_CTRL_ENA_OTP   (1 << 6)
> @@ -359,6 +373,7 @@ struct tda998x_priv {
>  # define CEC_RXSHPDLEV_HPD        (1 << 1)
>  
>  #define REG_CEC_ENAMODS           0xff                /* read/write */
> +# define CEC_ENAMODS_EN_CEC_CLK   (1 << 7)
>  # define CEC_ENAMODS_DIS_FRO      (1 << 6)
>  # define CEC_ENAMODS_DIS_CCLK     (1 << 5)
>  # define CEC_ENAMODS_EN_RXSENS    (1 << 2)
> @@ -417,6 +432,114 @@ cec_read(struct tda998x_priv *priv, u8 addr)
>  	return val;
>  }
>  
> +static void cec_enamods(struct tda998x_priv *priv, u8 mods, bool enable)
> +{
> +	int val = cec_read(priv, REG_CEC_ENAMODS);
> +
> +	if (val < 0)
> +		return;
> +
> +	if (enable)
> +		val |= mods;
> +	else
> +		val &= ~mods;
> +
> +	cec_write(priv, REG_CEC_ENAMODS, val);
> +}
> +
> +static void tda998x_cec_set_calibration(struct tda998x_priv *priv, bool enable)
> +{
> +	if (enable) {
> +		u8 val;
> +
> +		cec_write(priv, 0xf3, 0xc0);
> +		cec_write(priv, 0xf4, 0xd4);
> +
> +		/* Enable automatic calibration mode */
> +		val = cec_read(priv, REG_CEC_DES_FREQ2);
> +		val &= ~CEC_DES_FREQ2_DIS_AUTOCAL;
> +		cec_write(priv, REG_CEC_DES_FREQ2, val);
> +
> +		/* Enable free running oscillator */
> +		cec_write(priv, REG_CEC_CLK, CEC_CLK_FRO);
> +		cec_enamods(priv, CEC_ENAMODS_DIS_FRO, false);
> +
> +		cec_write(priv, REG_CEC_CAL_XOSC_CTRL1,
> +			  CEC_CAL_XOSC_CTRL1_ENA_CAL);
> +	} else {
> +		cec_write(priv, REG_CEC_CAL_XOSC_CTRL1, 0);
> +	}
> +}
> +
> +/*
> + * Calibration for the internal oscillator: we need to set calibration mode,
> + * and then pulse the IRQ line low for a 10ms ± 1% period.
> + */
> +static void tda998x_cec_calibration(struct tda998x_priv *priv)
> +{
> +	struct gpio_desc *calib = priv->calib;
> +
> +	mutex_lock(&priv->edid_mutex);
> +	if (priv->hdmi->irq > 0)
> +		disable_irq(priv->hdmi->irq);
> +	gpiod_direction_output(calib, 1);
> +	tda998x_cec_set_calibration(priv, true);
> +
> +	local_irq_disable();
> +	gpiod_set_value(calib, 0);
> +	mdelay(10);
> +	gpiod_set_value(calib, 1);
> +	local_irq_enable();
> +
> +	tda998x_cec_set_calibration(priv, false);
> +	gpiod_direction_input(calib);
> +	if (priv->hdmi->irq > 0)
> +		enable_irq(priv->hdmi->irq);
> +	mutex_unlock(&priv->edid_mutex);
> +}
> +
> +static int tda998x_cec_hook_init(void *data)
> +{
> +	struct tda998x_priv *priv = data;
> +	struct gpio_desc *calib;
> +
> +	calib = gpiod_get(&priv->hdmi->dev, "nxp,calib", GPIOD_ASIS);
> +	if (IS_ERR(calib)) {
> +		dev_warn(&priv->hdmi->dev, "failed to get calibration gpio: %ld\n",
> +			 PTR_ERR(calib));
> +		return PTR_ERR(calib);
> +	}
> +
> +	priv->calib = calib;
> +
> +	return 0;
> +}
> +
> +static void tda998x_cec_hook_exit(void *data)
> +{
> +	struct tda998x_priv *priv = data;
> +
> +	gpiod_put(priv->calib);
> +	priv->calib = NULL;
> +}
> +
> +static int tda998x_cec_hook_open(void *data)
> +{
> +	struct tda998x_priv *priv = data;
> +
> +	cec_enamods(priv, CEC_ENAMODS_EN_CEC_CLK | CEC_ENAMODS_EN_CEC, true);
> +	tda998x_cec_calibration(priv);
> +
> +	return 0;
> +}
> +
> +static void tda998x_cec_hook_release(void *data)
> +{
> +	struct tda998x_priv *priv = data;
> +
> +	cec_enamods(priv, CEC_ENAMODS_EN_CEC_CLK | CEC_ENAMODS_EN_CEC, false);
> +}
> +
>  static int
>  set_page(struct tda998x_priv *priv, u16 reg)
>  {
> @@ -657,10 +780,13 @@ static irqreturn_t tda998x_irq_thread(int irq, void *data)
>  			sta, cec, lvl, flag0, flag1, flag2);
>  
>  		if (cec & CEC_RXSHPDINT_HPD) {
> -			if (lvl & CEC_RXSHPDLEV_HPD)
> +			if (lvl & CEC_RXSHPDLEV_HPD) {
>  				tda998x_edid_delay_start(priv);
> -			else
> +			} else {
>  				schedule_work(&priv->detect_work);
> +				cec_notifier_set_phys_addr(priv->cec_notify,
> +						   CEC_PHYS_ADDR_INVALID);
> +			}
>  
>  			handled = true;
>  		}
> @@ -981,6 +1107,8 @@ static int tda998x_connector_fill_modes(struct drm_connector *connector,
>  	if (connector->edid_blob_ptr) {
>  		struct edid *edid = (void *)connector->edid_blob_ptr->data;
>  
> +		cec_notifier_set_phys_addr_from_edid(priv->cec_notify, edid);
> +
>  		priv->sink_has_audio = drm_detect_monitor_audio(edid);
>  	} else {
>  		priv->sink_has_audio = false;
> @@ -1024,6 +1152,8 @@ static int read_edid_block(void *data, u8 *buf, unsigned int blk, size_t length)
>  	offset = (blk & 1) ? 128 : 0;
>  	segptr = blk / 2;
>  
> +	mutex_lock(&priv->edid_mutex);
> +
>  	reg_write(priv, REG_DDC_ADDR, 0xa0);
>  	reg_write(priv, REG_DDC_OFFS, offset);
>  	reg_write(priv, REG_DDC_SEGM_ADDR, 0x60);
> @@ -1043,14 +1173,15 @@ static int read_edid_block(void *data, u8 *buf, unsigned int blk, size_t length)
>  					msecs_to_jiffies(100));
>  		if (i < 0) {
>  			dev_err(&priv->hdmi->dev, "read edid wait err %d\n", i);
> -			return i;
> +			ret = i;
> +			goto failed;
>  		}
>  	} else {
>  		for (i = 100; i > 0; i--) {
>  			msleep(1);
>  			ret = reg_read(priv, REG_INT_FLAGS_2);
>  			if (ret < 0)
> -				return ret;
> +				goto failed;
>  			if (ret & INT_FLAGS_2_EDID_BLK_RD)
>  				break;
>  		}
> @@ -1058,17 +1189,22 @@ static int read_edid_block(void *data, u8 *buf, unsigned int blk, size_t length)
>  
>  	if (i == 0) {
>  		dev_err(&priv->hdmi->dev, "read edid timeout\n");
> -		return -ETIMEDOUT;
> +		ret = -ETIMEDOUT;
> +		goto failed;
>  	}
>  
>  	ret = reg_read_range(priv, REG_EDID_DATA_0, buf, length);
>  	if (ret != length) {
>  		dev_err(&priv->hdmi->dev, "failed to read edid block %d: %d\n",
>  			blk, ret);
> -		return ret;
> +		goto failed;
>  	}
>  
> -	return 0;
> +	ret = 0;
> +
> + failed:
> +	mutex_unlock(&priv->edid_mutex);
> +	return ret;
>  }
>  
>  static int tda998x_connector_get_modes(struct drm_connector *connector)
> @@ -1423,6 +1559,9 @@ static void tda998x_destroy(struct tda998x_priv *priv)
>  	cancel_work_sync(&priv->detect_work);
>  
>  	i2c_unregister_device(priv->cec);
> +
> +	if (priv->cec_notify)
> +		cec_notifier_put(priv->cec_notify);
>  }
>  
>  /* I2C driver functions */
> @@ -1472,11 +1611,13 @@ static int tda998x_get_audio_ports(struct tda998x_priv *priv,
>  static int tda998x_create(struct i2c_client *client, struct tda998x_priv *priv)
>  {
>  	struct device_node *np = client->dev.of_node;
> +	struct i2c_board_info cec_info;
>  	u32 video;
>  	int rev_lo, rev_hi, ret;
>  
>  	mutex_init(&priv->mutex);	/* protect the page access */
>  	mutex_init(&priv->audio_mutex); /* protect access from audio thread */
> +	mutex_init(&priv->edid_mutex);
>  	init_waitqueue_head(&priv->edid_delay_waitq);
>  	timer_setup(&priv->edid_delay_timer, tda998x_edid_delay_done, 0);
>  	INIT_WORK(&priv->detect_work, tda998x_detect_work);
> @@ -1564,6 +1705,9 @@ static int tda998x_create(struct i2c_client *client, struct tda998x_priv *priv)
>  
>  		irq_flags =
>  			irqd_get_trigger_type(irq_get_irq_data(client->irq));
> +
> +		priv->cec_glue.irq_flags = irq_flags;
> +
>  		irq_flags |= IRQF_SHARED | IRQF_ONESHOT;
>  		ret = request_threaded_irq(client->irq, NULL,
>  					   tda998x_irq_thread, irq_flags,
> @@ -1579,7 +1723,34 @@ static int tda998x_create(struct i2c_client *client, struct tda998x_priv *priv)
>  		cec_write(priv, REG_CEC_RXSHPDINTENA, CEC_RXSHPDLEV_HPD);
>  	}
>  
> -	priv->cec = i2c_new_dummy(client->adapter, priv->cec_addr);
> +	priv->cec_notify = cec_notifier_get(&client->dev);
> +	if (!priv->cec_notify) {
> +		ret = -ENOMEM;
> +		goto fail;
> +	}
> +
> +	priv->cec_glue.parent = &client->dev;
> +	priv->cec_glue.data = priv;
> +	priv->cec_glue.init = tda998x_cec_hook_init;
> +	priv->cec_glue.exit = tda998x_cec_hook_exit;
> +	priv->cec_glue.open = tda998x_cec_hook_open;
> +	priv->cec_glue.release = tda998x_cec_hook_release;
> +
> +	/*
> +	 * Some TDA998x are actually two I2C devices merged onto one piece
> +	 * of silicon: TDA9989 and TDA19989 combine the HDMI transmitter
> +	 * with a slightly modified TDA9950 CEC device.  The CEC device
> +	 * is at the TDA9950 address, with the address pins strapped across
> +	 * to the TDA998x address pins.  Hence, it always has the same
> +	 * offset.
> +	 */
> +	memset(&cec_info, 0, sizeof(cec_info));
> +	strlcpy(cec_info.type, "tda9950", sizeof(cec_info.type));
> +	cec_info.addr = priv->cec_addr;
> +	cec_info.platform_data = &priv->cec_glue;
> +	cec_info.irq = client->irq;
> +
> +	priv->cec = i2c_new_device(client->adapter, &cec_info);
>  	if (!priv->cec) {
>  		ret = -ENODEV;
>  		goto fail;
> @@ -1609,10 +1780,16 @@ static int tda998x_create(struct i2c_client *client, struct tda998x_priv *priv)
>  	return 0;
>  
>  fail:
> +	/* if encoder_init fails, the encoder slave is never registered,
> +	 * so cleanup here:
> +	 */
> +	if (priv->cec)
> +		i2c_unregister_device(priv->cec);
> +	if (priv->cec_notify)
> +		cec_notifier_put(priv->cec_notify);
>  	if (client->irq)
>  		free_irq(client->irq, priv);
>  err_irq:
> -	i2c_unregister_device(priv->cec);
>  	return ret;
>  }
>  
> 
