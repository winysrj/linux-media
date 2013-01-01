Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:39929 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197Ab3AANBq (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 1 Jan 2013 08:01:46 -0500
Date: Tue, 1 Jan 2013 11:01:13 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: ujhelyi.m@gmail.com
Cc: linux-media@vger.kernel.org, rd@radekdostal.com
Subject: Re: [PATCH] media: rc: gpio-ir-recv.c: change platform_data to DT
 binding
Message-ID: <20130101110113.75e1c626@infradead.org>
In-Reply-To: <1355838101-972-1-git-send-email-ujhelyi.m@gmail.com>
References: <1355838101-972-1-git-send-email-ujhelyi.m@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Matus,

Em Tue, 18 Dec 2012 14:41:41 +0100
ujhelyi.m@gmail.com escreveu:

> From: Matus Ujhelyi <ujhelyi.m@gmail.com>
> 
> Signed-off-by: Matus Ujhelyi <ujhelyi.m@gmail.com>

This email lacks a proper description and doesn't c/c the DT maintainer.

I'm not a DT expert, so I won't comment the specific bits there, but
I'm more concerned if this is the right way of doing it.

The thing is that this driver seems to be generic enough to be used not only
by embedded platforms, but also for normal PCI/USB drivers for consumers
hardware, used on x86 machines.

So, it is what we generally call as an "ancillary driver", like the I2C drivers
are.

Well, I don't think that a PCI or an USB driver should use DT to pass data to 
an ancillary driver like this one. On those non-embedded drivers, the device
detection happens based on the PCI or USB ID, instead of on some DT info.
That's why passing those data through DT seems a bad idea. 

IMHO, all those ancillary drivers should be DT-agnostic. So, there must be an
embedded-specific driver that will handle DT and pass the config information
to the driver using the same way a PCI or USB driver would do (currently, via
platform_data).

As an additional benefit, this will help to avoid lots of #ifdef CONFIG_OF
inside the ancillary driver, with is ugly and obfuscates the driver.

Regards,
Mauro
> ---
>  drivers/media/rc/gpio-ir-recv.c |   84 ++++++++++++++++++++++++++++++---------
>  1 file changed, 66 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/media/rc/gpio-ir-recv.c b/drivers/media/rc/gpio-ir-recv.c
> index ba1a1eb..cfba079 100644
> --- a/drivers/media/rc/gpio-ir-recv.c
> +++ b/drivers/media/rc/gpio-ir-recv.c
> @@ -58,19 +58,49 @@ err_get_value:
>  	return IRQ_HANDLED;
>  }
>  
> +static const struct of_device_id gpio_ir_of_match[] = {
> +	{
> +		.compatible = "gpio-ir-recv",
> +	},
> +};
> +MODULE_DEVICE_TABLE(of, gpio_ir_of_matchof_match);
> +
> +static int __devinit gpio_ir_recv_dt_probe (struct gpio_rc_dev *gpio_dev,
> +		struct rc_dev *rcdev, struct platform_device *pdev) {
> +
> +	struct device_node *node = pdev->dev.of_node;
> +
> +	if (!node) {
> +		pr_err("Missing gpio_nr in the DT\n");
> +		return -EINVAL;
> +	}
> +
> +	if (of_property_read_u32(node, "gpio_nr", &gpio_dev->gpio_nr)) {
> +		pr_err("Missing gpio_nr in the DT\n");
> +		return -EINVAL;
> +	}
> +
> +	if (of_property_read_u64(node, "allowed_protos", &rcdev->allowed_protos))
> +		rcdev->allowed_protos = RC_BIT_ALL;
> +
> +	if (of_property_read_bool(node, "active_low"))
> +		gpio_dev->active_low = true;
> +	else
> +		gpio_dev->active_low = false;
> +
> +	if (of_property_read_string(node, "map_name", &rcdev->map_name))
> +		rcdev->map_name = NULL;
> +
> +	return 0;
> +}
> +
>  static int __devinit gpio_ir_recv_probe(struct platform_device *pdev)
>  {
>  	struct gpio_rc_dev *gpio_dev;
>  	struct rc_dev *rcdev;
>  	const struct gpio_ir_recv_platform_data *pdata =
>  					pdev->dev.platform_data;
> -	int rc;
> -
> -	if (!pdata)
> -		return -EINVAL;
> -
> -	if (pdata->gpio_nr < 0)
> -		return -EINVAL;
> +	int rc = -EINVAL;
>  
>  	gpio_dev = kzalloc(sizeof(struct gpio_rc_dev), GFP_KERNEL);
>  	if (!gpio_dev)
> @@ -82,6 +112,28 @@ static int __devinit gpio_ir_recv_probe(struct platform_device *pdev)
>  		goto err_allocate_device;
>  	}
>  
> +	if (!pdata) {
> +
> +		if (gpio_ir_recv_dt_probe(gpio_dev, rcdev, pdev))
> +			goto err_dt_create_of;
> +
> +	} else {
> +
> +		if (pdata->allowed_protos)
> +			rcdev->allowed_protos = pdata->allowed_protos;
> +		else
> +			rcdev->allowed_protos = RC_BIT_ALL;
> +		rcdev->map_name = pdata->map_name ?: RC_MAP_EMPTY;
> +
> +		gpio_dev->gpio_nr = pdata->gpio_nr;
> +		gpio_dev->active_low = pdata->active_low;
> +
> +	}
> +
> +	if (gpio_dev->gpio_nr < 0) {
> +		goto err_gpio_nr;
> +	}
> +
>  	rcdev->priv = gpio_dev;
>  	rcdev->driver_type = RC_DRIVER_IR_RAW;
>  	rcdev->input_name = GPIO_IR_DEVICE_NAME;
> @@ -92,20 +144,13 @@ static int __devinit gpio_ir_recv_probe(struct platform_device *pdev)
>  	rcdev->input_id.version = 0x0100;
>  	rcdev->dev.parent = &pdev->dev;
>  	rcdev->driver_name = GPIO_IR_DRIVER_NAME;
> -	if (pdata->allowed_protos)
> -		rcdev->allowed_protos = pdata->allowed_protos;
> -	else
> -		rcdev->allowed_protos = RC_BIT_ALL;
> -	rcdev->map_name = pdata->map_name ?: RC_MAP_EMPTY;
>  
>  	gpio_dev->rcdev = rcdev;
> -	gpio_dev->gpio_nr = pdata->gpio_nr;
> -	gpio_dev->active_low = pdata->active_low;
>  
> -	rc = gpio_request(pdata->gpio_nr, "gpio-ir-recv");
> +	rc = gpio_request(gpio_dev->gpio_nr, "gpio-ir-recv");
>  	if (rc < 0)
>  		goto err_gpio_request;
> -	rc  = gpio_direction_input(pdata->gpio_nr);
> +	rc  = gpio_direction_input(gpio_dev->gpio_nr);
>  	if (rc < 0)
>  		goto err_gpio_direction_input;
>  
> @@ -117,7 +162,7 @@ static int __devinit gpio_ir_recv_probe(struct platform_device *pdev)
>  
>  	platform_set_drvdata(pdev, gpio_dev);
>  
> -	rc = request_any_context_irq(gpio_to_irq(pdata->gpio_nr),
> +	rc = request_any_context_irq(gpio_to_irq(gpio_dev->gpio_nr),
>  				gpio_ir_recv_irq,
>  			IRQF_TRIGGER_FALLING | IRQF_TRIGGER_RISING,
>  					"gpio-ir-recv-irq", gpio_dev);
> @@ -131,8 +176,10 @@ err_request_irq:
>  	rc_unregister_device(rcdev);
>  err_register_rc_device:
>  err_gpio_direction_input:
> -	gpio_free(pdata->gpio_nr);
> +	gpio_free(gpio_dev->gpio_nr);
>  err_gpio_request:
> +err_dt_create_of:
> +err_gpio_nr:
>  	rc_free_device(rcdev);
>  	rcdev = NULL;
>  err_allocate_device:
> @@ -195,6 +242,7 @@ static struct platform_driver gpio_ir_recv_driver = {
>  #ifdef CONFIG_PM
>  		.pm	= &gpio_ir_recv_pm_ops,
>  #endif
> +		.of_match_table = of_match_ptr(gpio_ir_of_match),
>  	},
>  };
>  module_platform_driver(gpio_ir_recv_driver);




Cheers,
Mauro
