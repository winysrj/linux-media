Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ea0-f169.google.com ([209.85.215.169]:53101 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708Ab3CWL5A (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Mar 2013 07:57:00 -0400
Message-ID: <514D9888.4090307@gmail.com>
Date: Sat, 23 Mar 2013 12:56:56 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Shaik Ameer Basha <shaik.ameer@samsung.com>
CC: linux-media@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org, s.nawrocki@samsung.com,
	shaik.samsung@gmail.com
Subject: Re: [RFC 11/12] media: m5mols: Adding dt support to m5mols driver
References: <1362570838-4737-1-git-send-email-shaik.ameer@samsung.com> <1362570838-4737-12-git-send-email-shaik.ameer@samsung.com>
In-Reply-To: <1362570838-4737-12-git-send-email-shaik.ameer@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Shaik,

On 03/06/2013 12:53 PM, Shaik Ameer Basha wrote:
> This patch adds the dt support to m5mols driver.
>
> Signed-off-by: Shaik Ameer Basha<shaik.ameer@samsung.com>
> ---
>   drivers/media/i2c/m5mols/m5mols_core.c |   54 +++++++++++++++++++++++++++++++-
>   1 file changed, 53 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/media/i2c/m5mols/m5mols_core.c b/drivers/media/i2c/m5mols/m5mols_core.c
> index d4e7567..21c66ef 100644
> --- a/drivers/media/i2c/m5mols/m5mols_core.c
> +++ b/drivers/media/i2c/m5mols/m5mols_core.c
> @@ -19,6 +19,8 @@
>   #include<linux/interrupt.h>
>   #include<linux/delay.h>
>   #include<linux/gpio.h>
> +#include<linux/of_gpio.h>
> +#include<linux/pinctrl/consumer.h>

What would you need pinctrl for ? In most cases this driver just needs 
one GPIO
(sensor RESET), which is normally passed in gpios property.

>   #include<linux/regulator/consumer.h>
>   #include<linux/videodev2.h>
>   #include<linux/module.h>
> @@ -926,13 +928,38 @@ static irqreturn_t m5mols_irq_handler(int irq, void *data)
>   	return IRQ_HANDLED;
>   }
>
> +static const struct of_device_id m5mols_match[];
> +
>   static int m5mols_probe(struct i2c_client *client,
>   			const struct i2c_device_id *id)
>   {
> -	const struct m5mols_platform_data *pdata = client->dev.platform_data;
> +	struct m5mols_platform_data *pdata;
>   	struct m5mols_info *info;
> +	const struct of_device_id *of_id;
>   	struct v4l2_subdev *sd;
>   	int ret;
> +	struct pinctrl *pctrl;
> +	int eint_gpio = 0;
> +
> +	if (client->dev.of_node) {
> +		of_id = of_match_node(m5mols_match, client->dev.of_node);
> +		if (of_id)
> +			pdata = (struct m5mols_platform_data *)of_id->data;
> +		client->dev.platform_data = pdata;

Oh, no. Probably best thing to do would be to get rid of struct
m5mols_platform_data pointer from struct m5mols_info and just add gpio_reset
field there. That's what we have currently in the driver's platform data
structure.

struct m5mols_platform_data {
	int gpio_reset;
	u8 reset_polarity;
	int (*set_power)(struct device *dev, int on);
};

gpio_reset and reset_polarity are already handled in the driver, and for
this we just need a single entry in 'gpios' property.

set_power callback can't be supported. Luckily there seems to be no board
that needs it any more. So we just drop it. One solution for more complex
power sequence could be the Runtime Interpreted Power Sequences. Once it
is available we might be able to describe what was previously in a board
file in set_power callback in the device tree.

> +	} else {
> +		pdata = client->dev.platform_data;
> +	}
> +
> +	if (!pdata)
> +		return -EINVAL;
> +
> +	pctrl = devm_pinctrl_get_select_default(&client->dev);

Two issues here:

1. m5mols DT node doesn't include pinctrl property, does it ?
2. default pinctrl state is now being handled in the driver core.

Hence this pinctrl set up could well be removed.

> +	if (client->dev.of_node) {
> +		eint_gpio = of_get_named_gpio(client->dev.of_node, "gpios", 0);
> +		client->irq = gpio_to_irq(eint_gpio);
> +		pdata->gpio_reset = of_get_named_gpio(client->dev.of_node,
> +								"gpios", 1);

Err, now when pinctrl and generic GPIO DT bindings are supported on Exynos5
this should not be needed at all. request_irq() should work when you add
relevant properties in this device DT node. Please see exynos4210-trats.dts,
mms114-touchscreen node for an example.

	mms114-touchscreen@48 {
		...	
		interrupt-parent = <&gpx0>;
		interrupts = <4 2>;
		...
	};

You specify GPIO bank in the 'interrupt-parent' property, and the GPIO
index within the bank in first cell of 'interrupts' property. The second
cell are interrupt flags as defined in /Documentation/devicetree/bindings/
interrupt-controller/interrupts.txt. I'm not sure how this interacts with
the interrupt flags passed to request_irq ATM.

It's the pinctrl driver's task to configure the GPIO pinmux into EINT
function, when the above properties are present in device DT node.

> +	}
>
>   	if (pdata == NULL) {
>   		dev_err(&client->dev, "No platform data\n");
> @@ -1040,9 +1067,34 @@ static const struct i2c_device_id m5mols_id[] = {
>   };
>   MODULE_DEVICE_TABLE(i2c, m5mols_id);
>
> +static int m5mols_set_power(struct device *dev, int on)
> +{
> +	struct m5mols_platform_data *pdata =
> +			(struct m5mols_platform_data *)dev->platform_data;
> +	gpio_set_value(pdata->gpio_reset, !on);
> +	gpio_set_value(pdata->gpio_reset, !!on);
> +	return 0;
> +}
> +
> +static struct m5mols_platform_data m5mols_drvdata = {
> +	.gpio_reset	= 0,
> +	.reset_polarity	= 0,
> +	.set_power	= m5mols_set_power,
> +};

Huh, you've got extra bonus points for creativity! :)

Do you have fixed voltage regulators, permanently turned on on your board ?
gpio_reset is already being configured in m5mols_sensor_power() function.

Does so short pulse on RESET line change anything in your case ? If needed
we could modify m5mols_sensor_power() function to properly cover more cases.
Or does it also work when you remove the above m5mols_set_power callback ?

> +static const struct of_device_id m5mols_match[] = {
> +	{
> +		.compatible = "fujitsu,m-5mols",
> +		.data =&m5mols_drvdata,
> +	},
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, m5mols_match);

We already have a patch adding DT support to this driver. I'll probably
send it out for 3.10 next week. An important issue your patch doesn't
address is that in most H/W configurations camera host device provides
master clock to the sensor. It is the case for all our boards. So we
need to ensure that the clocks is enabled for the sensor when it tries
to access hardware. This essentially boils down to performing I2C
communication with the sensor device.

We currently worked around this by moving initial sensor detection to
v4l2 subdev .registered callback. But the preferred approach is to expose
clocks in the host driver so the sensor sub-device drivers can get them
and control as they seem fit. This also allows more fine grained power
management in the sensor driver. That said the asynchronous probing and
clock handling API is still not settled in the media subsystem and I think
it's worth to push the above mentioned patch upstream, even though it's
just an interim solution.

That doesn't mean we don't need the DT binding documentation for this
device though. :-)


Regards,
Sylwester
