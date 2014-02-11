Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:2724 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914AbaBKJ0n (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Feb 2014 04:26:43 -0500
Message-ID: <52F9EBF7.5020000@xs4all.nl>
Date: Tue, 11 Feb 2014 10:23:03 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
	Lars-Peter Clausen <lars@metafoo.de>,
	devicetree@vger.kernel.org
Subject: Re: [PATCH 45/47] adv7604: Add DT support
References: <1391618558-5580-1-git-send-email-laurent.pinchart@ideasonboard.com> <1391618558-5580-46-git-send-email-laurent.pinchart@ideasonboard.com>
In-Reply-To: <1391618558-5580-46-git-send-email-laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/05/14 17:42, Laurent Pinchart wrote:
> Parse the device tree node to populate platform data.
> 
> Cc: devicetree@vger.kernel.org
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  .../devicetree/bindings/media/i2c/adv7604.txt      |  56 ++++++++++++
>  drivers/media/i2c/adv7604.c                        | 101 ++++++++++++++++++---
>  2 files changed, 143 insertions(+), 14 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/media/i2c/adv7604.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/i2c/adv7604.txt b/Documentation/devicetree/bindings/media/i2c/adv7604.txt
> new file mode 100644
> index 0000000..0845c50
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/i2c/adv7604.txt
> @@ -0,0 +1,56 @@
> +* Analog Devices ADV7604/11 video decoder with HDMI receiver
> +
> +The ADV7604 and ADV7611 are multiformat video decoders with an integrated HDMI
> +receiver. The ADV7604 has four multiplexed HDMI inputs and one analog input,
> +and the ADV7611 has one HDMI input and no analog input.
> +
> +Required Properties:
> +
> +  - compatible: Must contain one of the following
> +    - "adi,adv7604" for the ADV7604
> +    - "adi,adv7611" for the ADV7611
> +
> +  - reg: I2C slave address
> +
> +  - hpd-gpios: References to the GPIOs that control the HDMI hot-plug
> +    detection pins, one per HDMI input. The active flag indicates the GPIO
> +    level that enables hot-plug detection.
> +
> +Optional Properties:
> +
> +  - reset-gpios: Reference to the GPIO connected to the device's reset pin.
> +
> +  - adi,default-input: Index of the input to be configured as default. Valid
> +    values are 0..5 for the ADV7604 and 0 for the ADV7611.
> +
> +  - adi,disable-power-down: Boolean property. When set forces the device to
> +    ignore the power-down pin. The property is valid for the ADV7604 only as
> +    the ADV7611 has no power-down pin.
> +
> +  - adi,disable-cable-reset: Boolean property. When set disables the HDMI
> +    receiver automatic reset when the HDMI cable is unplugged.
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
> +		adi,default-input = <0>;
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
> index e586c1c..cd8a2dc 100644
> --- a/drivers/media/i2c/adv7604.c
> +++ b/drivers/media/i2c/adv7604.c
> @@ -32,6 +32,7 @@
>  #include <linux/i2c.h>
>  #include <linux/kernel.h>
>  #include <linux/module.h>
> +#include <linux/of_gpio.h>
>  #include <linux/slab.h>
>  #include <linux/v4l2-dv-timings.h>
>  #include <linux/videodev2.h>
> @@ -2641,13 +2642,83 @@ static const struct adv7604_chip_info adv7604_chip_info[] = {
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
> +	{ .compatible = "adi,adv7604", .data = &adv7604_chip_info[ADV7604] },
> +	{ .compatible = "adi,adv7611", .data = &adv7604_chip_info[ADV7611] },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(of, adv7604_of_id);
> +
> +static int adv7604_parse_dt(struct adv7604_state *state)

Put this under #ifdef CONFIG_OF. It fails to compile if CONFIG_OF is not set
(as it is in my case since this driver is used with a PCIe card).

Regards,

	Hans

> +{
> +	struct device_node *np;
> +	unsigned int i;
> +	int ret;
> +
> +	np = state->i2c_clients[ADV7604_PAGE_IO]->dev.of_node;
> +	state->info = of_match_node(adv7604_of_id, np)->data;
> +
> +	state->pdata.disable_pwrdnb =
> +		of_property_read_bool(np, "adi,disable-power-down");
> +	state->pdata.disable_cable_det_rst =
> +		of_property_read_bool(np, "adi,disable-cable-reset");
> +
> +	ret = of_property_read_u32(np, "adi,default-input",
> +				   &state->pdata.default_input);
> +	if (ret < 0)
> +		state->pdata.default_input = -1;
> +
> +	for (i = 0; i < state->info->num_dv_ports; ++i) {
> +		enum of_gpio_flags flags;
> +
> +		state->pdata.hpd_gpio[i] =
> +			of_get_named_gpio_flags(np, "hpd-gpios", i, &flags);
> +		if (IS_ERR_VALUE(state->pdata.hpd_gpio[i]))
> +			continue;
> +
> +		state->pdata.hpd_gpio_low[i] = flags == OF_GPIO_ACTIVE_LOW;
> +	}
> +
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
> +	/* HACK: Hardcode the remaining platform data fields. */
> +	state->pdata.blank_data = 1;
> +	state->pdata.op_656_range = 1;
> +	state->pdata.alt_data_sat = 1;
> +	state->pdata.insert_av_codes = 1;
> +	state->pdata.op_format_mode_sel = ADV7604_OP_FORMAT_MODE0;
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
> @@ -2666,19 +2737,27 @@ static int adv7604_probe(struct i2c_client *client,
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
> +	if (client->dev.of_node) {
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
> @@ -2786,7 +2865,7 @@ static int adv7604_probe(struct i2c_client *client,
>  			continue;
>  
>  		state->i2c_clients[i] =
> -			adv7604_dummy_client(sd, pdata->i2c_addresses[i],
> +			adv7604_dummy_client(sd, state->pdata.i2c_addresses[i],
>  					     0xf2 + i);
>  		if (state->i2c_clients[i] == NULL) {
>  			err = -ENOMEM;
> @@ -2860,21 +2939,15 @@ static int adv7604_remove(struct i2c_client *client)
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

