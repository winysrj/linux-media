Return-path: <linux-media-owner@vger.kernel.org>
Received: from www381.your-server.de ([78.46.137.84]:34178 "EHLO
        www381.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751024AbeAVNA3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 Jan 2018 08:00:29 -0500
Subject: Re: [PATCH 2/2] drm: adv7511: Add support for
 i2c_new_secondary_device
To: Kieran Bingham <kieran.bingham@ideasonboard.com>,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Cc: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>,
        David Airlie <airlied@linux.ie>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Archit Taneja <architt@codeaurora.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        John Stultz <john.stultz@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Bhumika Goyal <bhumirks@gmail.com>,
        Inki Dae <inki.dae@samsung.com>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS"
        <devicetree@vger.kernel.org>
References: <1516625389-6362-1-git-send-email-kieran.bingham@ideasonboard.com>
 <1516625389-6362-3-git-send-email-kieran.bingham@ideasonboard.com>
From: Lars-Peter Clausen <lars@metafoo.de>
Message-ID: <8369b342-e7b2-2519-5dec-424b9c361869@metafoo.de>
Date: Mon, 22 Jan 2018 14:00:12 +0100
MIME-Version: 1.0
In-Reply-To: <1516625389-6362-3-git-send-email-kieran.bingham@ideasonboard.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 01/22/2018 01:50 PM, Kieran Bingham wrote:
> The ADV7511 has four 256-byte maps that can be accessed via the main I²C
> ports. Each map has it own I²C address and acts as a standard slave
> device on the I²C bus.
> 
> Allow a device tree node to override the default addresses so that
> address conflicts with other devices on the same bus may be resolved at
> the board description level.
> 
> Signed-off-by: Kieran Bingham <kieran.bingham@ideasonboard.com>

I've been working on the same thing, but you've beat me to it! Patch looks
mostly OK, but I think you are missing this piece:

https://github.com/analogdevicesinc/linux/commit/ba9b57507cb78724a606eb24104e22fea942437d#diff-2cf1828c644e351adefabe9509410400L553

> ---
>  .../bindings/display/bridge/adi,adv7511.txt        | 10 +++++-
>  drivers/gpu/drm/bridge/adv7511/adv7511.h           |  4 +++
>  drivers/gpu/drm/bridge/adv7511/adv7511_drv.c       | 36 ++++++++++++++--------
>  3 files changed, 37 insertions(+), 13 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/display/bridge/adi,adv7511.txt b/Documentation/devicetree/bindings/display/bridge/adi,adv7511.txt
> index 0047b1394c70..f6bb9f6d3f48 100644
> --- a/Documentation/devicetree/bindings/display/bridge/adi,adv7511.txt
> +++ b/Documentation/devicetree/bindings/display/bridge/adi,adv7511.txt
> @@ -70,6 +70,9 @@ Optional properties:
>    rather than generate its own timings for HDMI output.
>  - clocks: from common clock binding: reference to the CEC clock.
>  - clock-names: from common clock binding: must be "cec".
> +- reg-names : Names of maps with programmable addresses.
> +	It can contain any map needing a non-default address.
> +	Possible maps names are : "main", "edid", "cec", "packet"
>  
>  Required nodes:
>  
> @@ -88,7 +91,12 @@ Example
>  
>  	adv7511w: hdmi@39 {
>  		compatible = "adi,adv7511w";
> -		reg = <39>;
> +		/*
> +		 * The EDID page will be accessible on address 0x66 on the i2c
> +		 * bus. All other maps continue to use their default addresses.
> +		 */
> +		reg = <0x39 0x66>;
> +		reg-names = "main", "edid";
>  		interrupt-parent = <&gpio3>;
>  		interrupts = <29 IRQ_TYPE_EDGE_FALLING>;
>  		clocks = <&cec_clock>;
> diff --git a/drivers/gpu/drm/bridge/adv7511/adv7511.h b/drivers/gpu/drm/bridge/adv7511/adv7511.h
> index d034b2cb5eee..7d81ce3808e0 100644
> --- a/drivers/gpu/drm/bridge/adv7511/adv7511.h
> +++ b/drivers/gpu/drm/bridge/adv7511/adv7511.h
> @@ -53,8 +53,10 @@
>  #define ADV7511_REG_POWER			0x41
>  #define ADV7511_REG_STATUS			0x42
>  #define ADV7511_REG_EDID_I2C_ADDR		0x43
> +#define ADV7511_REG_EDID_I2C_ADDR_DEFAULT	0x3f
>  #define ADV7511_REG_PACKET_ENABLE1		0x44
>  #define ADV7511_REG_PACKET_I2C_ADDR		0x45
> +#define ADV7511_REG_PACKET_I2C_ADDR_DEFAULT	0x38
>  #define ADV7511_REG_DSD_ENABLE			0x46
>  #define ADV7511_REG_VIDEO_INPUT_CFG2		0x48
>  #define ADV7511_REG_INFOFRAME_UPDATE		0x4a
> @@ -89,6 +91,7 @@
>  #define ADV7511_REG_TMDS_CLOCK_INV		0xde
>  #define ADV7511_REG_ARC_CTRL			0xdf
>  #define ADV7511_REG_CEC_I2C_ADDR		0xe1
> +#define ADV7511_REG_CEC_I2C_ADDR_DEFAULT	0x3c
>  #define ADV7511_REG_CEC_CTRL			0xe2
>  #define ADV7511_REG_CHIP_ID_HIGH		0xf5
>  #define ADV7511_REG_CHIP_ID_LOW			0xf6
> @@ -322,6 +325,7 @@ struct adv7511 {
>  	struct i2c_client *i2c_main;
>  	struct i2c_client *i2c_edid;
>  	struct i2c_client *i2c_cec;
> +	struct i2c_client *i2c_packet;
>  
>  	struct regmap *regmap;
>  	struct regmap *regmap_cec;
> diff --git a/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c b/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c
> index efa29db5fc2b..7ec33837752b 100644
> --- a/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c
> +++ b/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c
> @@ -969,8 +969,8 @@ static int adv7511_init_cec_regmap(struct adv7511 *adv)
>  {
>  	int ret;
>  
> -	adv->i2c_cec = i2c_new_dummy(adv->i2c_main->adapter,
> -				     adv->i2c_main->addr - 1);
> +	adv->i2c_cec = i2c_new_secondary_device(adv->i2c_main, "cec",
> +					ADV7511_REG_CEC_I2C_ADDR_DEFAULT);
>  	if (!adv->i2c_cec)
>  		return -ENOMEM;
>  	i2c_set_clientdata(adv->i2c_cec, adv);
> @@ -1082,8 +1082,6 @@ static int adv7511_probe(struct i2c_client *i2c, const struct i2c_device_id *id)
>  	struct adv7511_link_config link_config;
>  	struct adv7511 *adv7511;
>  	struct device *dev = &i2c->dev;
> -	unsigned int main_i2c_addr = i2c->addr << 1;
> -	unsigned int edid_i2c_addr = main_i2c_addr + 4;
>  	unsigned int val;
>  	int ret;
>  
> @@ -1153,24 +1151,35 @@ static int adv7511_probe(struct i2c_client *i2c, const struct i2c_device_id *id)
>  	if (ret)
>  		goto uninit_regulators;
>  
> -	regmap_write(adv7511->regmap, ADV7511_REG_EDID_I2C_ADDR, edid_i2c_addr);
> -	regmap_write(adv7511->regmap, ADV7511_REG_PACKET_I2C_ADDR,
> -		     main_i2c_addr - 0xa);
> -	regmap_write(adv7511->regmap, ADV7511_REG_CEC_I2C_ADDR,
> -		     main_i2c_addr - 2);
> -
>  	adv7511_packet_disable(adv7511, 0xffff);
>  
> -	adv7511->i2c_edid = i2c_new_dummy(i2c->adapter, edid_i2c_addr >> 1);
> +	adv7511->i2c_edid = i2c_new_secondary_device(i2c, "edid",
> +					ADV7511_REG_EDID_I2C_ADDR_DEFAULT);
>  	if (!adv7511->i2c_edid) {
>  		ret = -ENOMEM;
>  		goto uninit_regulators;
>  	}
>  
> +	regmap_write(adv7511->regmap, ADV7511_REG_EDID_I2C_ADDR,
> +		     adv7511->i2c_edid->addr << 1);
> +
>  	ret = adv7511_init_cec_regmap(adv7511);
>  	if (ret)
>  		goto err_i2c_unregister_edid;
>  
> +	regmap_write(adv7511->regmap, ADV7511_REG_CEC_I2C_ADDR,
> +		     adv7511->i2c_cec->addr << 1);
> +
> +	adv7511->i2c_packet = i2c_new_secondary_device(i2c, "packet",
> +					ADV7511_REG_PACKET_I2C_ADDR_DEFAULT);
> +	if (!adv7511->i2c_packet) {
> +		ret = -ENOMEM;
> +		goto err_unregister_cec;
> +	}
> +
> +	regmap_write(adv7511->regmap, ADV7511_REG_PACKET_I2C_ADDR,
> +		     adv7511->i2c_packet->addr << 1);
> +
>  	INIT_WORK(&adv7511->hpd_work, adv7511_hpd_work);
>  
>  	if (i2c->irq) {
> @@ -1181,7 +1190,7 @@ static int adv7511_probe(struct i2c_client *i2c, const struct i2c_device_id *id)
>  						IRQF_ONESHOT, dev_name(dev),
>  						adv7511);
>  		if (ret)
> -			goto err_unregister_cec;
> +			goto err_unregister_packet;
>  	}
>  
>  	adv7511_power_off(adv7511);
> @@ -1203,6 +1212,8 @@ static int adv7511_probe(struct i2c_client *i2c, const struct i2c_device_id *id)
>  	adv7511_audio_init(dev, adv7511);
>  	return 0;
>  
> +err_unregister_packet:
> +	i2c_unregister_device(adv7511->i2c_packet);
>  err_unregister_cec:
>  	i2c_unregister_device(adv7511->i2c_cec);
>  	if (adv7511->cec_clk)
> @@ -1234,6 +1245,7 @@ static int adv7511_remove(struct i2c_client *i2c)
>  	cec_unregister_adapter(adv7511->cec_adap);
>  
>  	i2c_unregister_device(adv7511->i2c_edid);
> +	i2c_unregister_device(adv7511->i2c_packet);
>  
>  	return 0;
>  }
> 
