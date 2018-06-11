Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:47488 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932515AbeFKKK0 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 11 Jun 2018 06:10:26 -0400
Date: Mon, 11 Jun 2018 13:10:23 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hugues Fruchet <hugues.fruchet@st.com>
Cc: Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, linux-media@vger.kernel.org,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Maxime Ripard <maxime.ripard@bootlin.com>
Subject: Re: [PATCH 2/2] media: ov5640: add support of module orientation
Message-ID: <20180611101023.3dzihbwvwcopiqdh@valkosipuli.retiisi.org.uk>
References: <1528709357-7251-1-git-send-email-hugues.fruchet@st.com>
 <1528709357-7251-3-git-send-email-hugues.fruchet@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1528709357-7251-3-git-send-email-hugues.fruchet@st.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jun 11, 2018 at 11:29:17AM +0200, Hugues Fruchet wrote:
> Add support of module being physically mounted upside down.
> In this case, mirror and flip are enabled to fix captured images
> orientation.
> 
> Signed-off-by: Hugues Fruchet <hugues.fruchet@st.com>
> ---
>  .../devicetree/bindings/media/i2c/ov5640.txt       |  3 +++
>  drivers/media/i2c/ov5640.c                         | 28 ++++++++++++++++++++--
>  2 files changed, 29 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/media/i2c/ov5640.txt b/Documentation/devicetree/bindings/media/i2c/ov5640.txt
> index 8e36da0..f76eb7e 100644
> --- a/Documentation/devicetree/bindings/media/i2c/ov5640.txt
> +++ b/Documentation/devicetree/bindings/media/i2c/ov5640.txt
> @@ -13,6 +13,8 @@ Optional Properties:
>  	       This is an active low signal to the OV5640.
>  - powerdown-gpios: reference to the GPIO connected to the powerdown pin,
>  		   if any. This is an active high signal to the OV5640.
> +- rotation: integer property; valid values are 0 (sensor mounted upright)
> +	    and 180 (sensor mounted upside down).
>  
>  The device node must contain one 'port' child node for its digital output
>  video port, in accordance with the video interface bindings defined in
> @@ -51,6 +53,7 @@ Examples:
>  		DVDD-supply = <&vgen2_reg>;  /* 1.5v */
>  		powerdown-gpios = <&gpio1 19 GPIO_ACTIVE_HIGH>;
>  		reset-gpios = <&gpio1 20 GPIO_ACTIVE_LOW>;
> +		rotation = <180>;
>  
>  		port {
>  			/* MIPI CSI-2 bus endpoint */
> diff --git a/drivers/media/i2c/ov5640.c b/drivers/media/i2c/ov5640.c
> index 41039e5..5529b14 100644
> --- a/drivers/media/i2c/ov5640.c
> +++ b/drivers/media/i2c/ov5640.c
> @@ -215,6 +215,7 @@ struct ov5640_dev {
>  	struct regulator_bulk_data supplies[OV5640_NUM_SUPPLIES];
>  	struct gpio_desc *reset_gpio;
>  	struct gpio_desc *pwdn_gpio;
> +	bool   upside_down;
>  
>  	/* lock to protect all members below */
>  	struct mutex lock;
> @@ -2222,6 +2223,8 @@ static int ov5640_set_ctrl_light_freq(struct ov5640_dev *sensor, int value)
>  static int ov5640_set_ctrl_hflip(struct ov5640_dev *sensor, int value)
>  {
>  	/*
> +	 * If sensor is mounted upside down, mirror logic is inversed.
> +	 *
>  	 * Sensor is a BSI (Back Side Illuminated) one,
>  	 * so image captured is physically mirrored.
>  	 * This is why mirror logic is inversed in
> @@ -2235,11 +2238,14 @@ static int ov5640_set_ctrl_hflip(struct ov5640_dev *sensor, int value)
>  	 */
>  	return ov5640_mod_reg(sensor, OV5640_REG_TIMING_TC_REG21,
>  			      BIT(2) | BIT(1),
> -			      (!value) ? (BIT(2) | BIT(1)) : 0);
> +			      (!(value ^ sensor->upside_down)) ?
> +			      (BIT(2) | BIT(1)) : 0);
>  }
>  
>  static int ov5640_set_ctrl_vflip(struct ov5640_dev *sensor, int value)
>  {
> +	/* If sensor is mounted upside down, flip logic is inversed */
> +
>  	/*
>  	 * TIMING TC REG20:
>  	 * - [2]:	ISP vflip
> @@ -2247,7 +2253,8 @@ static int ov5640_set_ctrl_vflip(struct ov5640_dev *sensor, int value)
>  	 */
>  	return ov5640_mod_reg(sensor, OV5640_REG_TIMING_TC_REG20,
>  			      BIT(2) | BIT(1),
> -			      value ? (BIT(2) | BIT(1)) : 0);
> +			      (value ^ sensor->upside_down) ?
> +			      (BIT(2) | BIT(1)) : 0);
>  }
>  
>  static int ov5640_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
> @@ -2625,6 +2632,7 @@ static int ov5640_probe(struct i2c_client *client,
>  	struct fwnode_handle *endpoint;
>  	struct ov5640_dev *sensor;
>  	struct v4l2_mbus_framefmt *fmt;
> +	u32 rotation;
>  	int ret;
>  
>  	sensor = devm_kzalloc(dev, sizeof(*sensor), GFP_KERNEL);
> @@ -2650,6 +2658,22 @@ static int ov5640_probe(struct i2c_client *client,
>  
>  	sensor->ae_target = 52;
>  
> +	/* optional indication of physical rotation of sensor */
> +	ret = fwnode_property_read_u32(of_fwnode_handle(client->dev.of_node),

Instead of of_fwnode_handle(), please use dev_fwnode(&client->dev) --- as the
driver already does elsewhere.

I can make the change if you're happy with that; the patches seem fine
otherwise.

> +				       "rotation", &rotation);
> +	if (!ret) {
> +		switch (rotation) {
> +		case 180:
> +			sensor->upside_down = true;
> +			/* fall through */
> +		case 0:
> +			break;
> +		default:
> +			dev_warn(dev, "%u degrees rotation is not supported, ignoring...\n",
> +				 rotation);
> +		}
> +	}
> +
>  	endpoint = fwnode_graph_get_next_endpoint(dev_fwnode(&client->dev),
>  						  NULL);
>  	if (!endpoint) {

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi
