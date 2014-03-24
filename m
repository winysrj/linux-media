Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:37038 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659AbaCXWhJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Mar 2014 18:37:09 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: dri-devel@lists.freedesktop.org
Cc: Jean-Francois Moine <moinejf@free.fr>,
	Russell King <rmk+kernel@arm.linux.org.uk>,
	Rob Clark <robdclark@gmail.com>,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH RFC v2 2/6] drm/i2c: tda998x: Move tda998x to a couple encoder/connector
Date: Mon, 24 Mar 2014 23:39:01 +0100
Message-ID: <1458827.cQ6aDWdh1W@avalon>
In-Reply-To: <ad2d43d590302b67121338cfd4f9349a45942104.1395397665.git.moinejf@free.fr>
References: <cover.1395397665.git.moinejf@free.fr> <ad2d43d590302b67121338cfd4f9349a45942104.1395397665.git.moinejf@free.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jean-François,

Thank you for the patch.

On Friday 21 March 2014 09:17:32 Jean-Francois Moine wrote:
> The 'slave encoder' structure of the tda998x driver asks for glue
> between the DRM driver and the encoder/connector structures.
> 
> This patch changes the driver to a normal DRM encoder/connector
> thanks to the infrastructure for componentised subsystems.

I like the idea, but I'm not really happy with the implementation. Let me try 
to explain why below.

> Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
> ---
>  drivers/gpu/drm/i2c/tda998x_drv.c | 323 +++++++++++++++++++----------------
>  1 file changed, 188 insertions(+), 135 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i2c/tda998x_drv.c
> b/drivers/gpu/drm/i2c/tda998x_drv.c index fd6751c..1c25e40 100644
> --- a/drivers/gpu/drm/i2c/tda998x_drv.c
> +++ b/drivers/gpu/drm/i2c/tda998x_drv.c

[snip]

> @@ -44,10 +45,14 @@ struct tda998x_priv {
> 
>  	wait_queue_head_t wq_edid;
>  	volatile int wq_edid_wait;
> -	struct drm_encoder *encoder;
> +	struct drm_encoder encoder;
> +	struct drm_connector connector;
>  };

[snip]

> -static int
> -tda998x_probe(struct i2c_client *client, const struct i2c_device_id *id)
> +static int tda_bind(struct device *dev, struct device *master, void *data)
>  {
> +	struct drm_device *drm = data;

This is the part that bothers me. You're making two assumptions here, that the 
DRM driver will pass a struct drm_device pointer to the bind operation, and 
that the I2C encoder driver can take control of DRM encoder and connector 
creation. Although it could become problematic later, the first assumption 
isn't too much of an issue for now. I'll thus focus on the second one.

The component framework isolate the encoder and DRM master drivers as far as 
component creation and binding is concerned, but doesn't provide a way for the 
two drivers to communicate together (nor should it). You're solving this by 
passing a pointer to the DRM device to the encoder bind operation, making the 
encoder driver create a DRM encoder and connector, and relying on the DRM core 
to orchestrate CRTCs, encoders and connectors. You thus assume that the 
encoder hardware should be represented by a DRM encoder object, and that its 
output is connected to a connector that should be represented by a DRM 
connector object. While this can work in your use case, that won't always hold 
true. Hardware encoders can be chained together, while DRM encoders can't. The 
DRM core has recently received support for bridge objects to overcome that 
limitation. Depending on the hardware topology, a given hardware encoder 
should be modeled as a DRM encoder or as a DRM bridge. That decision shouldn't 
be taken by the encoder driver but by the DRM master driver. The I2C encoder 
driver thus shouldn't create the DRM encoder and DRM connector itself.

I believe the encoder/master communication problem should be solved 
differently. Instead of passing a pointer to the DRM device to the encoder 
driver and making the encoder driver control DRM encoder and connector 
creation, the encoder driver should instead create an object not visible to 
userspace that can be retrieved by the DRM master driver (possibly through 
registration with the DRM core, or by going through drvdata in the encoder's 
struct device). The DRM master could use that object to communicate with the 
encoder, and would register the DRM encoder and DRM connector itself based on 
hardware topology.

> +	struct i2c_client *i2c_client = to_i2c_client(dev);
> +	struct tda998x_priv *priv = i2c_get_clientdata(i2c_client);
> +	struct drm_connector *connector = &priv->connector;
> +	struct drm_encoder *encoder = &priv->encoder;
> +	int ret;
> +
> +	if (!try_module_get(THIS_MODULE)) {
> +		dev_err(dev, "cannot get module %s\n", THIS_MODULE->name);
> +		return -EINVAL;
> +	}
> +
> +	ret = drm_connector_init(drm, connector,
> +				&connector_funcs,
> +				DRM_MODE_CONNECTOR_HDMIA);

This is one example of the shortcomings I've explained above. An encoder 
driver can't always know what connector type it is connected to. If I'm not 
mistaken possible options here are DVII, DVID, HDMIA and HDMIB. It should be 
up to the master driver to select the connector type based on its overall view 
of the hardware, or even to a connector driver that would be bound to a 
connector DT node (as proposed in https://www.mail-archive.com/devicetree@vger.kernel.org/msg16585.html).

> +	if (ret < 0)
> +		return ret;
> +	drm_connector_helper_add(connector, &connector_helper_funcs);
> +
> +	ret = drm_encoder_init(drm, encoder,
> +				&encoder_funcs,
> +				DRM_MODE_ENCODER_TMDS);
> +
> +	encoder->possible_crtcs = 1;	// 1 << lcd_num
> +
> +	if (ret < 0)
> +		goto err;
> +	drm_encoder_helper_add(encoder, &encoder_helper_funcs);
> +
> +	ret = drm_mode_connector_attach_encoder(connector, encoder);
> +	if (ret < 0)
> +		goto err;
> +	connector->encoder = encoder;
> +
> +	drm_sysfs_connector_add(connector);
> +
> +	drm_helper_connector_dpms(connector, DRM_MODE_DPMS_OFF);
> +	ret = drm_object_property_set_value(&connector->base,
> +					drm->mode_config.dpms_property,
> +					DRM_MODE_DPMS_OFF);
> +
> +	if (priv->hdmi->irq)
> +		connector->polled = DRM_CONNECTOR_POLL_HPD;
> +	else
> +		connector->polled = DRM_CONNECTOR_POLL_CONNECT |
> +			DRM_CONNECTOR_POLL_DISCONNECT;
>  	return 0;
> +
> +err:
> +	if (encoder->dev)
> +		drm_encoder_cleanup(encoder);
> +	if (connector->dev)
> +		drm_connector_cleanup(connector);
> +	return ret;
>  }
> 
> -static int
> -tda998x_remove(struct i2c_client *client)
> +static void tda_unbind(struct device *dev, struct device *master, void
> *data) {
> -	return 0;
> +	module_put(THIS_MODULE);
>  }
> 
> +static const struct component_ops comp_ops = {
> +	.bind = tda_bind,
> +	.unbind = tda_unbind,
> +};
> +
>  static int
> -tda998x_encoder_init(struct i2c_client *client,
> -		    struct drm_device *dev,
> -		    struct drm_encoder_slave *encoder_slave)
> +tda998x_probe(struct i2c_client *client, const struct i2c_device_id *id)
>  {
>  	struct tda998x_priv *priv;
>  	struct device_node *np = client->dev.of_node;
> @@ -1239,6 +1291,8 @@ tda998x_encoder_init(struct i2c_client *client,
>  	if (!priv)
>  		return -ENOMEM;
> 
> +	i2c_set_clientdata(client, priv);
> +
>  	priv->vip_cntrl_0 = VIP_CNTRL_0_SWAP_A(2) | VIP_CNTRL_0_SWAP_B(3);
>  	priv->vip_cntrl_1 = VIP_CNTRL_1_SWAP_C(0) | VIP_CNTRL_1_SWAP_D(1);
>  	priv->vip_cntrl_2 = VIP_CNTRL_2_SWAP_E(4) | VIP_CNTRL_2_SWAP_F(5);
> @@ -1250,13 +1304,8 @@ tda998x_encoder_init(struct i2c_client *client,
>  		kfree(priv);
>  		return -ENODEV;
>  	}
> -
> -	priv->encoder = &encoder_slave->base;
>  	priv->dpms = DRM_MODE_DPMS_OFF;
> 
> -	encoder_slave->slave_priv = priv;
> -	encoder_slave->slave_funcs = &tda998x_encoder_funcs;
> -
>  	/* wake up the device: */
>  	cec_write(priv, REG_CEC_ENAMODS,
>  			CEC_ENAMODS_EN_RXSENS | CEC_ENAMODS_EN_HDMI);
> @@ -1340,31 +1389,55 @@ tda998x_encoder_init(struct i2c_client *client,
>  	/* enable EDID read irq: */
>  	reg_set(priv, REG_INT_FLAGS_2, INT_FLAGS_2_EDID_BLK_RD);
> 
> -	if (!np)
> -		return 0;		/* non-DT */
> +	if (np) {				/* if DT */
> 
> -	/* get the optional video properties */
> -	ret = of_property_read_u32(np, "video-ports", &video);
> -	if (ret == 0) {
> -		priv->vip_cntrl_0 = video >> 16;
> -		priv->vip_cntrl_1 = video >> 8;
> -		priv->vip_cntrl_2 = video;
> +		/* get the optional video properties */
> +		ret = of_property_read_u32(np, "video-ports", &video);
> +		if (ret == 0) {
> +			priv->vip_cntrl_0 = video >> 16;
> +			priv->vip_cntrl_1 = video >> 8;
> +			priv->vip_cntrl_2 = video;
> +		}
> +	} else {
> +		struct tda998x_encoder_params *params =
> +				(struct tda998x_encoder_params)
> +						client->dev.platform_data;
> +
> +		if (params)
> +			tda998x_encoder_set_config(priv, params);
>  	}
> 
> +	/* tda998x video component ready */
> +	component_add(&client->dev, &comp_ops);
> +
>  	return 0;
> 
>  fail:
> -	/* if encoder_init fails, the encoder slave is never registered,
> -	 * so cleanup here:
> -	 */
>  	if (priv->cec)
>  		i2c_unregister_device(priv->cec);
>  	kfree(priv);
> -	encoder_slave->slave_priv = NULL;
> -	encoder_slave->slave_funcs = NULL;
>  	return -ENXIO;
>  }
> 
> +static int
> +tda998x_remove(struct i2c_client *client)
> +{
> +	struct tda998x_priv *priv = i2c_get_clientdata(client);
> +
> +	/* disable all IRQs and free the IRQ handler */
> +	cec_write(priv, REG_CEC_RXSHPDINTENA, 0);
> +	reg_clear(priv, REG_INT_FLAGS_2, INT_FLAGS_2_EDID_BLK_RD);
> +	if (priv->hdmi->irq)
> +		free_irq(priv->hdmi->irq, priv);
> +
> +	component_del(&client->dev, &comp_ops);
> +
> +	if (priv->cec)
> +		i2c_unregister_device(priv->cec);
> +	kfree(priv);
> +	return 0;
> +}
> +
>  #ifdef CONFIG_OF
>  static const struct of_device_id tda998x_dt_ids[] = {
>  	{ .compatible = "nxp,tda9989", },
> @@ -1381,38 +1454,18 @@ static struct i2c_device_id tda998x_ids[] = {
>  };
>  MODULE_DEVICE_TABLE(i2c, tda998x_ids);
> 
> -static struct drm_i2c_encoder_driver tda998x_driver = {
> -	.i2c_driver = {
> -		.probe = tda998x_probe,
> -		.remove = tda998x_remove,
> -		.driver = {
> -			.name = "tda998x",
> -			.of_match_table = of_match_ptr(tda998x_dt_ids),
> -		},
> -		.id_table = tda998x_ids,
> +static struct i2c_driver tda998x_driver = {
> +	.probe = tda998x_probe,
> +	.remove = tda998x_remove,
> +	.driver = {
> +		.name = "tda998x",
> +		.of_match_table = of_match_ptr(tda998x_dt_ids),
>  	},
> -	.encoder_init = tda998x_encoder_init,
> +	.id_table = tda998x_ids,
>  };

-- 
Regards,

Laurent Pinchart
