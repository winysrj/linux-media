Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:49454 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbaDQOje (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Apr 2014 10:39:34 -0400
Message-id: <534FE7A1.8060800@samsung.com>
Date: Thu, 17 Apr 2014 16:39:29 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>,
	devicetree@vger.kernel.org
Subject: Re: [PATCH v4 45/49] adv7604: Add DT support
References: <1397744000-23967-1-git-send-email-laurent.pinchart@ideasonboard.com>
 <1397744000-23967-46-git-send-email-laurent.pinchart@ideasonboard.com>
In-reply-to: <1397744000-23967-46-git-send-email-laurent.pinchart@ideasonboard.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

On 17/04/14 16:13, Laurent Pinchart wrote:
> Parse the device tree node to populate platform data. Only the ADV7611
> is currently support with DT.
> 
> Cc: devicetree@vger.kernel.org
> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

The patch looks good to me.

Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>

Just one comment below...
> ---
>  .../devicetree/bindings/media/i2c/adv7604.txt      | 57 +++++++++++++++
>  drivers/media/i2c/adv7604.c                        | 80 ++++++++++++++++++----
>  2 files changed, 123 insertions(+), 14 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/media/i2c/adv7604.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/i2c/adv7604.txt b/Documentation/devicetree/bindings/media/i2c/adv7604.txt
> new file mode 100644
> index 0000000..2efb48f
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/i2c/adv7604.txt
> @@ -0,0 +1,57 @@
> +* Analog Devices ADV7604/11 video decoder with HDMI receiver
> +
> +The ADV7604 and ADV7611 are multiformat video decoders with an integrated HDMI
> +receiver. The ADV7604 has four multiplexed HDMI inputs and one analog input,
> +and the ADV7611 has one HDMI input and no analog input.
> +
> +These device tree bindings support the ADV7611 only at the moment.
> +
> +Required Properties:
> +
> +  - compatible: Must contain one of the following
> +    - "adi,adv7611" for the ADV7611
> +
> +  - reg: I2C slave address
> +
> +  - hpd-gpios: References to the GPIOs that control the HDMI hot-plug
> +    detection pins, one per HDMI input. The active flag indicates the GPIO
> +    level that enables hot-plug detection.
> +
> +The device node must contain one 'port' child node per device input and output
> +port, in accordance with the video interface bindings defined in
> +Documentation/devicetree/bindings/media/video-interfaces.txt. The port nodes
> +are numbered as follows.
> +
> +  Port			ADV7611
> +------------------------------------------------------------
> +  HDMI			0
> +  Digital output	1
> +
> +The digital output port node must contain at least one endpoint.
> +
> +Optional Properties:
> +
> +  - reset-gpios: Reference to the GPIO connected to the device's reset pin.
> +
> +Example:
> +
> +	hdmi_receiver@4c {
> +		compatible = "adi,adv7611";
> +		reg = <0x4c>;
> +
> +		reset-gpios = <&ioexp 0 GPIO_ACTIVE_LOW>;
> +		hpd-gpios = <&ioexp 2 GPIO_ACTIVE_HIGH>;
> +
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +
> +		port@0 {
> +			reg = <0>;
> +		};
> +		port@1 {
> +			reg = <1>;
> +			hdmi_in: endpoint {
> +				remote-endpoint = <&ccdc_in>;
> +			};
> +		};
> +	};
> diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
> index 342d73d..061794e 100644
> --- a/drivers/media/i2c/adv7604.c
> +++ b/drivers/media/i2c/adv7604.c
> @@ -2663,13 +2663,58 @@ static const struct adv7604_chip_info adv7604_chip_info[] = {
>  	},
>  };
>  
> +static struct i2c_device_id adv7604_i2c_id[] = {
> +	{ "adv7604", (kernel_ulong_t)&adv7604_chip_info[ADV7604] },
> +	{ "adv7611", (kernel_ulong_t)&adv7604_chip_info[ADV7611] },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(i2c, adv7604_i2c_id);
> +
> +static struct of_device_id adv7604_of_id[] = {

Not adding __maybe_unused attribute to this one ?

> +	{ .compatible = "adi,adv7611", .data = &adv7604_chip_info[ADV7611] },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(of, adv7604_of_id);
> +
> +static int adv7604_parse_dt(struct adv7604_state *state)
> +{
> +	/* Disable the interrupt for now as no DT-based board uses it. */
> +	state->pdata.int1_config = ADV7604_INT1_CONFIG_DISABLED;
> +
> +	/* Use the default I2C addresses. */
> +	state->pdata.i2c_addresses[ADV7604_PAGE_AVLINK] = 0x42;
> +	state->pdata.i2c_addresses[ADV7604_PAGE_CEC] = 0x40;
> +	state->pdata.i2c_addresses[ADV7604_PAGE_INFOFRAME] = 0x3e;
> +	state->pdata.i2c_addresses[ADV7604_PAGE_ESDP] = 0x38;
> +	state->pdata.i2c_addresses[ADV7604_PAGE_DPP] = 0x3c;
> +	state->pdata.i2c_addresses[ADV7604_PAGE_AFE] = 0x26;
> +	state->pdata.i2c_addresses[ADV7604_PAGE_REP] = 0x32;
> +	state->pdata.i2c_addresses[ADV7604_PAGE_EDID] = 0x36;
> +	state->pdata.i2c_addresses[ADV7604_PAGE_HDMI] = 0x34;
> +	state->pdata.i2c_addresses[ADV7604_PAGE_TEST] = 0x30;
> +	state->pdata.i2c_addresses[ADV7604_PAGE_CP] = 0x22;
> +	state->pdata.i2c_addresses[ADV7604_PAGE_VDP] = 0x24;
> +
> +	/* Hardcode the remaining platform data fields. */
> +	state->pdata.disable_pwrdnb = 0;
> +	state->pdata.disable_cable_det_rst = 0;
> +	state->pdata.default_input = -1;
> +	state->pdata.blank_data = 1;
> +	state->pdata.op_656_range = 1;
> +	state->pdata.alt_data_sat = 1;
> +	state->pdata.insert_av_codes = 1;
> +	state->pdata.op_format_mode_sel = ADV7604_OP_FORMAT_MODE0;
> +	state->pdata.bus_order = ADV7604_BUS_ORDER_RGB;
> +
> +	return 0;
> +}
> +
>  static int adv7604_probe(struct i2c_client *client,
>  			 const struct i2c_device_id *id)
>  {
>  	static const struct v4l2_dv_timings cea640x480 =
>  		V4L2_DV_BT_CEA_640X480P59_94;
>  	struct adv7604_state *state;
> -	struct adv7604_platform_data *pdata = client->dev.platform_data;
>  	struct v4l2_ctrl_handler *hdl;
>  	struct v4l2_subdev *sd;
>  	unsigned int i;
> @@ -2688,19 +2733,32 @@ static int adv7604_probe(struct i2c_client *client,
>  		return -ENOMEM;
>  	}
>  
> -	state->info = &adv7604_chip_info[id->driver_data];
>  	state->i2c_clients[ADV7604_PAGE_IO] = client;
>  
>  	/* initialize variables */
>  	state->restart_stdi_once = true;
>  	state->selected_input = ~0;
>  
> -	/* platform data */
> -	if (!pdata) {
> +	if (IS_ENABLED(CONFIG_OF) && client->dev.of_node) {
> +		const struct of_device_id *oid;
> +
> +		oid = of_match_node(adv7604_of_id, client->dev.of_node);
> +		state->info = oid->data;
> +
> +		err = adv7604_parse_dt(state);
> +		if (err < 0) {
> +			v4l_err(client, "DT parsing error\n");
> +			return err;
> +		}
> +	} else if (client->dev.platform_data) {
> +		struct adv7604_platform_data *pdata = client->dev.platform_data;
> +
> +		state->info = (const struct adv7604_chip_info *)id->driver_data;
> +		state->pdata = *pdata;
> +	} else {
>  		v4l_err(client, "No platform data!\n");
>  		return -ENODEV;
>  	}
> -	state->pdata = *pdata;
>  
>  	/* Request GPIOs. */
>  	for (i = 0; i < state->info->num_dv_ports; ++i) {
> @@ -2799,7 +2857,7 @@ static int adv7604_probe(struct i2c_client *client,
>  			continue;
>  
>  		state->i2c_clients[i] =
> -			adv7604_dummy_client(sd, pdata->i2c_addresses[i],
> +			adv7604_dummy_client(sd, state->pdata.i2c_addresses[i],
>  					     0xf2 + i);
>  		if (state->i2c_clients[i] == NULL) {
>  			err = -ENOMEM;
> @@ -2873,21 +2931,15 @@ static int adv7604_remove(struct i2c_client *client)
>  
>  /* ----------------------------------------------------------------------- */
>  
> -static struct i2c_device_id adv7604_id[] = {
> -	{ "adv7604", ADV7604 },
> -	{ "adv7611", ADV7611 },
> -	{ }
> -};
> -MODULE_DEVICE_TABLE(i2c, adv7604_id);
> -
>  static struct i2c_driver adv7604_driver = {
>  	.driver = {
>  		.owner = THIS_MODULE,
>  		.name = "adv7604",
> +		.of_match_table = of_match_ptr(adv7604_of_id),
>  	},
>  	.probe = adv7604_probe,
>  	.remove = adv7604_remove,
> -	.id_table = adv7604_id,
> +	.id_table = adv7604_i2c_id,
>  };
>  
>  module_i2c_driver(adv7604_driver);
> 

-- 
Regards,
Sylwester
