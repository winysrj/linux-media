Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f47.google.com ([209.85.214.47]:63340 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790Ab3GNUdN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Jul 2013 16:33:13 -0400
Message-ID: <51E30B04.8090009@gmail.com>
Date: Sun, 14 Jul 2013 22:33:08 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
CC: LMML <linux-media@vger.kernel.org>,
	DLOS <davinci-linux-open-source@linux.davincidsp.com>,
	LKML <linux-kernel@vger.kernel.org>,
	devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH v2] media: i2c: adv7343: add OF support
References: <1373713959-31066-1-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1373713959-31066-1-git-send-email-prabhakar.csengg@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Prabhakar,

On 07/13/2013 01:12 PM, Prabhakar Lad wrote:
> From: "Lad, Prabhakar"<prabhakar.csengg@gmail.com>
>
> add OF support for the adv7343 driver.
>
> Signed-off-by: Lad, Prabhakar<prabhakar.csengg@gmail.com>
> ---
>   Changes for v2:
>   1: Fixed naming of properties.
>
>   .../devicetree/bindings/media/i2c/adv7343.txt      |   54 ++++++++++++++++
>   drivers/media/i2c/adv7343.c                        |   65 +++++++++++++++++++-
>   2 files changed, 118 insertions(+), 1 deletion(-)
>   create mode 100644 Documentation/devicetree/bindings/media/i2c/adv7343.txt
>
> diff --git a/Documentation/devicetree/bindings/media/i2c/adv7343.txt b/Documentation/devicetree/bindings/media/i2c/adv7343.txt
> new file mode 100644
> index 0000000..1d2e854
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/i2c/adv7343.txt
> @@ -0,0 +1,54 @@
> +* Analog Devices adv7343 video encoder
> +
> +The ADV7343 are high speed, digital-to-analog video encoders in a 64-lead LQFP
> +package. Six high speed, 3.3 V, 11-bit video DACs provide support for composite
> +(CVBS), S-Video (Y-C), and component (YPrPb/RGB) analog outputs in standard
> +definition (SD), enhanced definition (ED), or high definition (HD) video
> +formats.
> +
> +Required Properties :
> +- compatible: Must be "ad,adv7343"

Please have a look at Documentation/devicetree/bindings/vendor-prefixes.txt.
'ad' is a vendor prefix reserved for "Avionic Design GmbH".
For "Analog Devices, Inc." 'adi' should be used.

If I would have to draft a new DT binding proposal checklist checking
vendor-prefixes.txt would certainly be one of the first steps.

> +Optional Properties :
> +- ad,adv7343-power-mode-sleep-mode: on enable the current consumption is
> +				     reduced to micro ampere level. All DACs and
> +				     the internal PLL circuit are disabled.
> +- ad,adv7343-power-mode-pll-ctrl: PLL and oversampling control. This control
> +				   allows internal PLL 1 circuit to be powered
> +				   down and the oversampling to beswitched off.
> +- ad,adv7343-power-mode-dac-1: power on/off DAC 1, 0 = OFF and 1 = ON.
> +- ad,adv7343-power-mode-dac-2: power on/off DAC 2, 0 = OFF and 1 = ON.
> +- ad,adv7343-power-mode-dac-3: power on/off DAC 3, 0 = OFF and 1 = ON.
> +- ad,adv7343-power-mode-dac-4: power on/off DAC 4, 0 = OFF and 1 = ON.
> +- ad,adv7343-power-mode-dac-5: power on/off DAC 5, 0 = OFF and 1 = ON.
> +- ad,adv7343-power-mode-dac-6: power on/off DAC 6, 0 = OFF and 1 = ON.
> +- ad,adv7343-sd-config-dac-out-1: Configure SD DAC Output 1.
> +- ad,adv7343-sd-config-dac-out-2: Configure SD DAC Output 2.

All these properties look more like hardware configuration, rather than
hardware description. So at first sight I would say none of these properties
is suitable for the device tree.

sleep mode and pll ctrl should likely only have default values in the 
driver.
sleep-mode disables all DAC, while power-mode-dac-? does power on/off
(enables / disables?) individual DACs. How those properties interact, 
what's
going on here exactly ? :)

That said, how about only leaving the properties indicating which DACs
(including SD DACs) should be enabled ? E.g.

adi,dac-enable - an array indicating which DACs are enabled, in order
  		DAC1...DAC6, 1 to enable DAC, 0 to disable.

adi,sd-dac-enable - an array indicating which SD DACs are enabled, in order
  		DAC1...DAC2, 1 to enable SD DAC, 0 to disable.

Please note you don't need ",adv7343-" prefix in each single property
for that device.

> +Example:
> +
> +i2c0@1c22000 {
> +	...
> +	...
> +
> +	adv7343@2a {
> +		compatible = "ad,adv7343";
> +		reg =<0x2a>;
> +
> +		port {
> +			adv7343_1: endpoint {
> +					ad,adv7343-power-mode-sleep-mode;
> +					ad,adv7343-power-mode-pll-ctrl;
> +					ad,adv7343-power-mode-dac-1;
> +					ad,adv7343-power-mode-dac-2;
> +					ad,adv7343-power-mode-dac-3;
> +					ad,adv7343-power-mode-dac-4;
> +					ad,adv7343-power-mode-dac-5;
> +					ad,adv7343-power-mode-dac-6;

Then this would have become:
					adi,dac-enable = <1 1 1 1 1 1>;	

But I would put some disabled DACs in the example as well:

					/* Use DAC1..3, DAC6 */
					adi,dac-enable = <1 1 1 0 0 1>;

> +					ad,adv7343-sd-config-dac-out-1;
> +					ad,adv7343-sd-config-dac-out-2;

And this:	
					adi,sd-dac-enable = <1 1>;	

> +			};
> +		};
> +	};
> +	...
> +};
> diff --git a/drivers/media/i2c/adv7343.c b/drivers/media/i2c/adv7343.c
> index 7606218..22ee6f4 100644
> --- a/drivers/media/i2c/adv7343.c
> +++ b/drivers/media/i2c/adv7343.c
> @@ -29,6 +29,7 @@
>   #include<media/adv7343.h>
>   #include<media/v4l2-device.h>
>   #include<media/v4l2-ctrls.h>
> +#include<media/v4l2-of.h>
>
>   #include "adv7343_regs.h"
>
> @@ -398,6 +399,59 @@ static int adv7343_initialize(struct v4l2_subdev *sd)
>   	return err;
>   }
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
> +	pdata = devm_kzalloc(&client->dev, sizeof(struct adv7343_platform_data),
> +			     GFP_KERNEL);
> +	if (!pdata)
> +		goto done;
> +
> +	pdata->mode_config.sleep_mode =
> +		of_property_read_bool(np, "ad,adv7343-power-mode-sleep-mode");
> +
> +	pdata->mode_config.pll_control =
> +		of_property_read_bool(np, "ad,adv7343-power-mode-pll-ctrl");
> +
> +	pdata->mode_config.dac_1 =
> +		of_property_read_bool(np, "ad,adv7343-power-mode-dac-1");
> +
> +	pdata->mode_config.dac_2 =
> +		of_property_read_bool(np, "ad,adv7343-power-mode-dac-2");
> +
> +	pdata->mode_config.dac_3 =
> +		of_property_read_bool(np, "ad,adv7343-power-mode-dac-3");
> +
> +	pdata->mode_config.dac_4 =
> +		of_property_read_bool(np, "ad,adv7343-power-mode-dac-4");
> +
> +	pdata->mode_config.dac_5 =
> +		of_property_read_bool(np, "ad,adv7343-power-mode-dac-5");
> +
> +	pdata->mode_config.dac_6 =
> +		of_property_read_bool(np, "ad,adv7343-power-mode-dac-6");
> +
> +	pdata->sd_config.sd_dac_out1 =
> +		of_property_read_bool(np, "ad,adv7343-sd-config-dac-out-1");
> +
> +	pdata->sd_config.sd_dac_out2 =
> +		of_property_read_bool(np, "ad,adv7343-sd-config-dac-out-2");

This doesn't look very impressive. IMHO changing 
pdata->mode_config.{dac,sd_dac}
to an array type could simplify this code a little. But you could as 
well use
of_property_read_u32_array() and assign each element to corresponding
mode_config.(sd_)dac field.

> +done:
> +	of_node_put(np);
> +	return pdata;
> +}
> +

--
Thanks,
Sylwester
