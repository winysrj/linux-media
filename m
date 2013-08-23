Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:45357 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755924Ab3HWSDW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Aug 2013 14:03:22 -0400
Message-id: <5217A3E7.50706@samsung.com>
Date: Fri, 23 Aug 2013 20:03:19 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Cc: LMML <linux-media@vger.kernel.org>,
	DLOS <davinci-linux-open-source@linux.davincidsp.com>,
	LKML <linux-kernel@vger.kernel.org>,
	devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
	Stephen Warren <swarren@wwwdotorg.org>,
	Mark Rutland <Mark.Rutland@arm.com>,
	Pawel Moll <Pawel.Moll@arm.com>,
	Kumar Gala <galak@codeaurora.org>,
	Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH v3 2/2] media: i2c: adv7343: add OF support
References: <1374301266-26726-1-git-send-email-prabhakar.csengg@gmail.com>
 <1374301266-26726-3-git-send-email-prabhakar.csengg@gmail.com>
In-reply-to: <1374301266-26726-3-git-send-email-prabhakar.csengg@gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Cc: DT binding maintainers

On 07/20/2013 08:21 AM, Lad, Prabhakar wrote:
> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
> 
> add OF support for the adv7343 driver.
> 
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> ---
[...]
>  .../devicetree/bindings/media/i2c/adv7343.txt      |   48 ++++++++++++++++++++
>  drivers/media/i2c/adv7343.c                        |   46 ++++++++++++++++++-
>  2 files changed, 93 insertions(+), 1 deletion(-)
>  create mode 100644 Documentation/devicetree/bindings/media/i2c/adv7343.txt
> 
> diff --git a/Documentation/devicetree/bindings/media/i2c/adv7343.txt b/Documentation/devicetree/bindings/media/i2c/adv7343.txt
> new file mode 100644
> index 0000000..5653bc2
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/i2c/adv7343.txt
> @@ -0,0 +1,48 @@
> +* Analog Devices adv7343 video encoder
> +
> +The ADV7343 are high speed, digital-to-analog video encoders in a 64-lead LQFP
> +package. Six high speed, 3.3 V, 11-bit video DACs provide support for composite
> +(CVBS), S-Video (Y-C), and component (YPrPb/RGB) analog outputs in standard
> +definition (SD), enhanced definition (ED), or high definition (HD) video
> +formats.
> +
> +Required Properties :
> +- compatible: Must be "adi,adv7343"
> +
> +Optional Properties :
> +- adi,power-mode-sleep-mode: on enable the current consumption is reduced to
> +			      micro ampere level. All DACs and the internal PLL
> +			      circuit are disabled.

Sorry for getting back so late to this. I realize this is already queued in 
the media tree. But this binding doesn't look good enough to me. I think it 
will need to be corrected during upcoming -rc period.

It might be hard to figure out only from the chip's datasheet what
adi,power-mode-sleep-mode really refers to. AFAICS it is for assigning some
value to a specific register. If we really need to specify register values
in the device tree then it would probably make sense to describe to which
register this apply. Now the name looks like derived from some structure
member name in the Linux driver of the device.

> +- adi,power-mode-pll-ctrl: PLL and oversampling control. This control allows
> +			   internal PLL 1 circuit to be powered down and the
> +			   oversampling to be switched off.

Similar comments applies to this property.

> +- ad,adv7343-power-mode-dac: array configuring the power on/off DAC's 1..6,
> +			      0 = OFF and 1 = ON, Default value when this
> +			      property is not specified is <0 0 0 0 0 0>.

Name of the property is incorrect here. It has changed to "adi,dac-enable".

> +- ad,adv7343-sd-config-dac-out: array configure SD DAC Output's 1 and 2, 0 = OFF
> +				 and 1 = ON, Default value when this property is
> +				 not specified is <0 0>.

Similarly, "adi,sd-dac-enable.

> +Example:
> +
> +i2c0@1c22000 {
> +	...
> +	...
> +
> +	adv7343@2a {
> +		compatible = "adi,adv7343";
> +		reg = <0x2a>;
> +
> +		port {
> +			adv7343_1: endpoint {
> +					adi,power-mode-sleep-mode;
> +					adi,power-mode-pll-ctrl;
> +					/* Use DAC1..3, DAC6 */
> +					adi,dac-enable = <1 1 1 0 0 1>;
> +					/* Use SD DAC output 1 */
> +					adi,sd-dac-enable = <1 0>;
> +			};
> +		};
> +	};
> +	...
> +};
> diff --git a/drivers/media/i2c/adv7343.c b/drivers/media/i2c/adv7343.c
> index f0238fb..aeb56c5 100644
> --- a/drivers/media/i2c/adv7343.c
> +++ b/drivers/media/i2c/adv7343.c
> @@ -30,6 +30,7 @@
>  #include <media/v4l2-async.h>
>  #include <media/v4l2-device.h>
>  #include <media/v4l2-ctrls.h>
> +#include <media/v4l2-of.h>
>  
>  #include "adv7343_regs.h"
>  
> @@ -399,6 +400,40 @@ static int adv7343_initialize(struct v4l2_subdev *sd)
>  	return err;
>  }
>  
> +static struct adv7343_platform_data *
> +adv7343_get_pdata(struct i2c_client *client)
> +{
> +	struct adv7343_platform_data *pdata;
> +	struct device_node *np;
> +
> +	if (!IS_ENABLED(CONFIG_OF) || !client->dev.of_node)
> +		return client->dev.platform_data;
> +
> +	np = v4l2_of_get_next_endpoint(client->dev.of_node, NULL);
> +	if (!np)
> +		return NULL;
> +
> +	pdata = devm_kzalloc(&client->dev, sizeof(*pdata), GFP_KERNEL);
> +	if (!pdata)
> +		goto done;
> +
> +	pdata->mode_config.sleep_mode =
> +			of_property_read_bool(np, "adi,power-mode-sleep-mode");
> +
> +	pdata->mode_config.pll_control =
> +			of_property_read_bool(np, "adi,power-mode-pll-ctrl");
> +
> +	of_property_read_u32_array(np, "adi,dac-enable",
> +				   pdata->mode_config.dac, 6);
> +
> +	of_property_read_u32_array(np, "adi,sd-dac-enable",
> +				   pdata->sd_config.sd_dac_out, 2);
> +
> +done:
> +	of_node_put(np);
> +	return pdata;
> +}
> +
>  static int adv7343_probe(struct i2c_client *client,
>  				const struct i2c_device_id *id)
>  {
> @@ -417,7 +452,7 @@ static int adv7343_probe(struct i2c_client *client,
>  		return -ENOMEM;
>  
>  	/* Copy board specific information here */
> -	state->pdata = client->dev.platform_data;
> +	state->pdata = adv7343_get_pdata(client);
>  
>  	state->reg00	= 0x80;
>  	state->reg01	= 0x00;
> @@ -483,8 +518,17 @@ static const struct i2c_device_id adv7343_id[] = {
>  
>  MODULE_DEVICE_TABLE(i2c, adv7343_id);
>  
> +#if IS_ENABLED(CONFIG_OF)
> +static const struct of_device_id adv7343_of_match[] = {
> +	{.compatible = "adi,adv7343", },
> +	{ /* sentinel */ },
> +};
> +MODULE_DEVICE_TABLE(of, adv7343_of_match);
> +#endif
> +
>  static struct i2c_driver adv7343_driver = {
>  	.driver = {
> +		.of_match_table = of_match_ptr(adv7343_of_match),
>  		.owner	= THIS_MODULE,
>  		.name	= "adv7343",
>  	},


-- 
Sylwester Nawrocki
Samsung R&D Institute Poland
