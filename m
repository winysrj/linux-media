Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:54607 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681AbaHaSSm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 31 Aug 2014 14:18:42 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
Cc: devicetree@vger.kernel.org, linux-media@vger.kernel.org,
	linux-i2c@vger.kernel.org, lars@metafoo.de, w.sang@pengutronix.de,
	hverkuil@xs4all.nl, mark.rutland@arm.com
Subject: Re: [PATCH v2 2/2] adv7604: Use DT parsing in dummy creation
Date: Sun, 31 Aug 2014 20:18:58 +0300
Message-ID: <2204455.3fKSNVsp04@avalon>
In-Reply-To: <1409325303-15906-2-git-send-email-jean-michel.hautbois@vodalys.com>
References: <1409325303-15906-1-git-send-email-jean-michel.hautbois@vodalys.com> <1409325303-15906-2-git-send-email-jean-michel.hautbois@vodalys.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jean-Michel,

Thank you for the patch.

On Friday 29 August 2014 17:15:03 Jean-Michel Hautbois wrote:
> This patch uses DT in order to parse addresses for dummy devices of adv7604.
> The ADV7604 has thirteen 256-byte maps that can be accessed via the main
> I²C ports. Each map has it own I²C address and acts
> as a standard slave device on the I²C bus.
> 
> If nothing is defined, it uses default addresses.
> The main prupose is using two adv76xx on the same i2c bus.
> 
> Signed-off-by: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
> ---
>  .../devicetree/bindings/media/i2c/adv7604.txt      | 17 +++++-
>  drivers/media/i2c/adv7604.c                        | 60 ++++++++++++-------
>  2 files changed, 55 insertions(+), 22 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/media/i2c/adv7604.txt
> b/Documentation/devicetree/bindings/media/i2c/adv7604.txt index
> c27cede..8486b5c 100644
> --- a/Documentation/devicetree/bindings/media/i2c/adv7604.txt
> +++ b/Documentation/devicetree/bindings/media/i2c/adv7604.txt
> @@ -10,8 +10,12 @@ Required Properties:
> 
>    - compatible: Must contain one of the following
>      - "adi,adv7611" for the ADV7611
> +    - "adi,adv7604" for the ADV7604

Addition of ADV7604 support is unrelated to the subject and needs to be split 
into a separate patch.

> -  - reg: I2C slave address
> +  - reg: I2C slave addresses
> +    The ADV7604 has thirteen 256-byte maps that can be accessed via the
> main
> +    I²C ports. Each map has it own I²C address and acts
> +    as a standard slave device on the I²C bus.
> 
>    - hpd-gpios: References to the GPIOs that control the HDMI hot-plug
>      detection pins, one per HDMI input. The active flag indicates the GPIO
> @@ -32,6 +36,12 @@ The digital output port node must contain at least one
> endpoint. Optional Properties:
> 
>    - reset-gpios: Reference to the GPIO connected to the device's reset pin.
> +  - reg-names : Names of maps with programmable addresses.
> +		It can contain any map needing another address than default one.
> +		Possible maps names are :
> +ADV7604 : "main", "avlink", "cec", "infoframe", "esdp", "dpp", "afe",
> "rep",
> +		"edid", "hdmi", "test", "cp", "vdp"
> +ADV7611 : "main", "cec", "infoframe", "afe", "rep", "edid", "hdmi", "cp"
> 
>  Optional Endpoint Properties:
> 
> @@ -50,7 +60,10 @@ Example:
> 
>  	hdmi_receiver@4c {
>  		compatible = "adi,adv7611";
> -		reg = <0x4c>;
> +		/* edid page will be accessible @ 0x66 on i2c bus */
> +		/* other maps keep their default addresses */
> +		reg = <0x4c 0x66>;
> +		reg-names = "main", "edid";
> 
>  		reset-gpios = <&ioexp 0 GPIO_ACTIVE_LOW>;
>  		hpd-gpios = <&ioexp 2 GPIO_ACTIVE_HIGH>;
> diff --git a/drivers/media/i2c/adv7604.c b/drivers/media/i2c/adv7604.c
> index d4fa213..56037dd 100644
> --- a/drivers/media/i2c/adv7604.c
> +++ b/drivers/media/i2c/adv7604.c
> @@ -326,6 +326,22 @@ static const struct adv7604_video_standards
> adv7604_prim_mode_hdmi_gr[] = { { },
>  };
> 
> +static const char const *adv7604_secondary_names[] = {
> +	"main", /* ADV7604_PAGE_IO */
> +	"avlink", /* ADV7604_PAGE_AVLINK */
> +	"cec", /* ADV7604_PAGE_CEC */
> +	"infoframe", /* ADV7604_PAGE_INFOFRAME */
> +	"esdp", /* ADV7604_PAGE_ESDP */
> +	"dpp", /* ADV7604_PAGE_DPP */
> +	"afe", /* ADV7604_PAGE_AFE */
> +	"rep", /* ADV7604_PAGE_REP */
> +	"edid", /* ADV7604_PAGE_EDID */
> +	"hdmi", /* ADV7604_PAGE_HDMI */
> +	"test", /* ADV7604_PAGE_TEST */
> +	"cp", /* ADV7604_PAGE_CP */
> +	"vdp" /* ADV7604_PAGE_VDP */
> +};
> +
>  /* -----------------------------------------------------------------------
> */
> 
>  static inline struct adv7604_state *to_state(struct v4l2_subdev *sd)
> @@ -2528,13 +2544,31 @@ static void adv7604_unregister_clients(struct
> adv7604_state *state) }
> 
>  static struct i2c_client *adv7604_dummy_client(struct v4l2_subdev *sd,
> -							u8 addr, u8 io_reg)
> +						unsigned int i)
>  {
>  	struct i2c_client *client = v4l2_get_subdevdata(sd);
> +	struct adv7604_platform_data *pdata = client->dev.platform_data;
> +	unsigned int io_reg = 0xf2 + i;
> +	unsigned int default_addr = io_read(sd, io_reg) >> 1;

This modifies the behaviour of the driver. It previously used fixed default 
addresses in the DT case, and now defaults to whatever has been programmed in 
the chip. This might not be an issue in itself, but it should be documented in 
the commit message (and possibly split to a separate patch).

> +	struct i2c_client *new_client;
> +
> +	if (IS_ENABLED(CONFIG_OF)) {
> +		/* Try to find it in DT */
> +		new_client = i2c_new_secondary_device(client,
> +			adv7604_secondary_names[i], default_addr);
> +	} else if (pdata) {
> +		if (pdata->i2c_addresses[i])
> +			new_client = i2c_new_dummy(client->adapter,
> +						pdata->i2c_addresses[i]);
> +		else
> +			new_client = i2c_new_dummy(client->adapter,
> +						default_addr);
> +	}
> 
> -	if (addr)
> -		io_write(sd, io_reg, addr << 1);
> -	return i2c_new_dummy(client->adapter, io_read(sd, io_reg) >> 1);
> +	if (new_client)
> +		io_write(sd, io_reg, new_client->addr << 1);
> +
> +	return new_client;
>  }
> 
>  static const struct adv7604_reg_seq adv7604_recommended_settings_afe[] = {
> @@ -2677,6 +2711,7 @@ MODULE_DEVICE_TABLE(i2c, adv7604_i2c_id);
> 
>  static struct of_device_id adv7604_of_id[] __maybe_unused = {
>  	{ .compatible = "adi,adv7611", .data = &adv7604_chip_info[ADV7611] },
> +	{ .compatible = "adi,adv7604", .data = &adv7604_chip_info[ADV7604] },
>  	{ }
>  };
>  MODULE_DEVICE_TABLE(of, adv7604_of_id);
> @@ -2717,20 +2752,6 @@ static int adv7604_parse_dt(struct adv7604_state
> *state) /* Disable the interrupt for now as no DT-based board uses it. */
> state->pdata.int1_config = ADV7604_INT1_CONFIG_DISABLED;
> 
> -	/* Use the default I2C addresses. */
> -	state->pdata.i2c_addresses[ADV7604_PAGE_AVLINK] = 0x42;
> -	state->pdata.i2c_addresses[ADV7604_PAGE_CEC] = 0x40;
> -	state->pdata.i2c_addresses[ADV7604_PAGE_INFOFRAME] = 0x3e;
> -	state->pdata.i2c_addresses[ADV7604_PAGE_ESDP] = 0x38;
> -	state->pdata.i2c_addresses[ADV7604_PAGE_DPP] = 0x3c;
> -	state->pdata.i2c_addresses[ADV7604_PAGE_AFE] = 0x26;
> -	state->pdata.i2c_addresses[ADV7604_PAGE_REP] = 0x32;
> -	state->pdata.i2c_addresses[ADV7604_PAGE_EDID] = 0x36;
> -	state->pdata.i2c_addresses[ADV7604_PAGE_HDMI] = 0x34;
> -	state->pdata.i2c_addresses[ADV7604_PAGE_TEST] = 0x30;
> -	state->pdata.i2c_addresses[ADV7604_PAGE_CP] = 0x22;
> -	state->pdata.i2c_addresses[ADV7604_PAGE_VDP] = 0x24;
> -
>  	/* Hardcode the remaining platform data fields. */
>  	state->pdata.disable_pwrdnb = 0;
>  	state->pdata.disable_cable_det_rst = 0;
> @@ -2891,8 +2912,7 @@ static int adv7604_probe(struct i2c_client *client,
>  			continue;
> 
>  		state->i2c_clients[i] =
> -			adv7604_dummy_client(sd, state->pdata.i2c_addresses[i],
> -					     0xf2 + i);
> +			adv7604_dummy_client(sd, i);
>  		if (state->i2c_clients[i] == NULL) {
>  			err = -ENOMEM;
>  			v4l2_err(sd, "failed to create i2c client %u\n", i);

-- 
Regards,

Laurent Pinchart

