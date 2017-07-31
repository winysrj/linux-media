Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:50415 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751533AbdGaU3K (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 31 Jul 2017 16:29:10 -0400
Date: Mon, 31 Jul 2017 21:29:08 +0100
From: Sean Young <sean@mess.org>
To: Matthias Reichl <hias@horus.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH v2 3/6] [media] rc: gpio-ir-tx: add new driver
Message-ID: <20170731202908.hk7dpclt5m5lhpdd@gofer.mess.org>
References: <cover.1499419624.git.sean@mess.org>
 <92a66fd9852c3143d5726eb3869d58e28d841c84.1499419624.git.sean@mess.org>
 <20170721141245.3uv55fqxa557dmnt@camel2.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170721141245.3uv55fqxa557dmnt@camel2.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Matthias,

On Fri, Jul 21, 2017 at 04:12:45PM +0200, Matthias Reichl wrote:
> Hi Sean,
> 
> On Fri, Jul 07, 2017 at 10:51:59AM +0100, Sean Young wrote:
> > This is a simple bit-banging GPIO IR TX driver.
> 
> thanks a lot for the driver, this is highly appreciated!
> 
> I tested the patch series on a RPi2, against RPi downstream kernel
> 4.13-rc1, and noticed an issue: the polarity of the gpio seems
> to be reversed.
> 
> Other than the polarity issue the driver seems to work fine -
> at least on the scope screen. Didn't have an IR transmitter to
> do some real tests yet.
> 
> I've configured the gpio as active high:
> 
> gpio_ir_tx: gpio-ir-transmitter {
> 	compatible = "gpio-ir-tx";
> 	gpios = <&gpio 18 0>;
> };
> 
> However, when loading the gpio-ir-tx driver the gpio pin changed
> to 3.3V. I did some tests with ir-ctl -S, idle state of the signal
> was 3.3V, active state 0V.
> 
> I think it's better to use the descriptor based gpio functions
> instead of the legacy number based ones. That'll simplify the
> driver and it can delegate polarity handling to gpiod.

You're absolutely right, this is much nicer and makes the driver
shorter.

> Proposed changes and comments are inline. I've also included
> the patch against your patch that I've been testing with at the
> end of the message.

I agree with all your comments. However, we need a Signed-off-by:
line to use your patch, thank you.

Regards,
Sean

> 
> > diff --git a/drivers/media/rc/gpio-ir-tx.c b/drivers/media/rc/gpio-ir-tx.c
> > new file mode 100644
> > index 0000000..7a5371d
> > --- /dev/null
> > +++ b/drivers/media/rc/gpio-ir-tx.c
> > @@ -0,0 +1,189 @@
> > +/*
> > + * Copyright (C) 2017 Sean Young <sean@mess.org>
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License version 2, or
> > + * (at your option) any later version.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + */
> > +
> > +#include <linux/kernel.h>
> > +#include <linux/module.h>
> > +#include <linux/gpio.h>
> 
> use linux/gpio/consumer.h instead of linux/gpio.h
> 
> > +#include <linux/delay.h>
> > +#include <linux/slab.h>
> > +#include <linux/of.h>
> > +#include <linux/of_gpio.h>
> 
> of_gpio.h can be dropped
> 
> > +#include <linux/platform_device.h>
> > +#include <media/rc-core.h>
> > +
> > +#define DRIVER_NAME	"gpio-ir-tx"
> > +#define DEVICE_NAME	"GPIO Bit Banging IR Transmitter"
> > +
> > +struct gpio_ir {
> > +	int gpio_nr;
> > +	bool active_low;
> 
> Replace these 2 fields with
> 	struct gpio_desc *gpio;
> 
> > +	unsigned int carrier;
> > +	unsigned int duty_cycle;
> > +	/* we need a spinlock to hold the cpu while transmitting */
> > +	spinlock_t lock;
> > +};
> > +
> > +static const struct of_device_id gpio_ir_tx_of_match[] = {
> > +	{ .compatible = "gpio-ir-tx", },
> > +	{ },
> > +};
> > +MODULE_DEVICE_TABLE(of, gpio_ir_tx_of_match);
> > +
> > +static int gpio_ir_tx_set_duty_cycle(struct rc_dev *dev, u32 duty_cycle)
> > +{
> > +	struct gpio_ir *gpio_ir = dev->priv;
> > +
> > +	gpio_ir->duty_cycle = duty_cycle;
> > +
> > +	return 0;
> > +}
> > +
> > +static int gpio_ir_tx_set_carrier(struct rc_dev *dev, u32 carrier)
> > +{
> > +	struct gpio_ir *gpio_ir = dev->priv;
> > +
> > +	if (!carrier)
> > +		return -EINVAL;
> > +
> > +	gpio_ir->carrier = carrier;
> > +
> > +	return 0;
> > +}
> > +
> > +static int gpio_ir_tx(struct rc_dev *dev, unsigned int *txbuf,
> > +		      unsigned int count)
> > +{
> > +	struct gpio_ir *gpio_ir = dev->priv;
> > +	unsigned long flags;
> > +	ktime_t edge;
> > +	/*
> > +	 * delta should never exceed 0.5 seconds (IR_MAX_DURATION) and on
> > +	 * m68k ndelay(s64) does not compile; so use s32 rather than s64.
> > +	 */
> > +	s32 delta;
> > +	int i;
> > +	unsigned int pulse, space;
> > +
> > +	/* Ensure the dividend fits into 32 bit */
> > +	pulse = DIV_ROUND_CLOSEST(gpio_ir->duty_cycle * (NSEC_PER_SEC / 100),
> > +				  gpio_ir->carrier);
> > +	space = DIV_ROUND_CLOSEST((100 - gpio_ir->duty_cycle) *
> > +				  (NSEC_PER_SEC / 100), gpio_ir->carrier);
> > +
> > +	spin_lock_irqsave(&gpio_ir->lock, flags);
> > +
> > +	edge = ktime_get();
> > +
> > +	for (i = 0; i < count; i++) {
> > +		if (i % 2) {
> > +			// space
> > +			edge = ktime_add_us(edge, txbuf[i]);
> > +			delta = ktime_us_delta(edge, ktime_get());
> > +			if (delta > 10) {
> > +				spin_unlock_irqrestore(&gpio_ir->lock, flags);
> > +				usleep_range(delta, delta + 10);
> > +				spin_lock_irqsave(&gpio_ir->lock, flags);
> > +			} else if (delta > 0) {
> > +				udelay(delta);
> > +			}
> > +		} else {
> > +			// pulse
> > +			ktime_t last = ktime_add_us(edge, txbuf[i]);
> > +
> > +			while (ktime_get() < last) {
> > +				gpio_set_value(gpio_ir->gpio_nr,
> > +					       gpio_ir->active_low);
> 
> 				gpiod_set_value(gpio_ir->gpio, 1);
> 
> > +				edge += pulse;
> > +				delta = edge - ktime_get();
> > +				if (delta > 0)
> > +					ndelay(delta);
> > +				gpio_set_value(gpio_ir->gpio_nr,
> > +					       !gpio_ir->active_low);
> 
> 				gpiod_set_value(gpio_ir->gpio, 0);
> 
> > +				edge += space;
> > +				delta = edge - ktime_get();
> > +				if (delta > 0)
> > +					ndelay(delta);
> > +			}
> > +
> > +			edge = last;
> > +		}
> > +	}
> > +
> > +	spin_unlock_irqrestore(&gpio_ir->lock, flags);
> > +
> > +	return count;
> > +}
> > +
> > +static int gpio_ir_tx_probe(struct platform_device *pdev)
> > +{
> > +	struct gpio_ir *gpio_ir;
> > +	struct rc_dev *rcdev;
> > +	enum of_gpio_flags flags;
> > +	int rc, gpio;
> 
> Flags can be dropped, gpio as well.
> 
> > +
> > +	gpio = of_get_gpio_flags(pdev->dev.of_node, 0, &flags);
> > +	if (gpio < 0) {
> > +		if (gpio != -EPROBE_DEFER)
> > +			dev_err(&pdev->dev, "Failed to get gpio flags (%d)\n",
> > +				gpio);
> > +		return -EINVAL;
> > +	}
> 
> Drop this and move getting the gpio a bit down so we don't need
> a temp variable.
> 
> > +
> > +	gpio_ir = devm_kmalloc(&pdev->dev, sizeof(*gpio_ir), GFP_KERNEL);
> > +	if (!gpio_ir)
> > +		return -ENOMEM;
> > +
> > +	rcdev = devm_rc_allocate_device(&pdev->dev, RC_DRIVER_IR_RAW_TX);
> > +	if (!rcdev)
> > +		return -ENOMEM;
> 
> get the gpio here, configure it to output with logical low (idle)
> level and store it in gpio_ir:
> 
> 	gpio_ir->gpio = devm_gpiod_get(&pdev->dev, NULL, GPIOD_OUT_LOW);
> 	if (IS_ERR(gpio_ir->gpio)) {
> 		if (PTR_ERR(gpio_ir->gpio) != -EPROBE_DEFER)
> 			dev_err(&pdev->dev, "Failed to get gpio (%ld)\n",
> 				PTR_ERR(gpio_ir->gpio));
> 		return PTR_ERR(gpio_ir->gpio);
> 	}
> 
> > +
> > +	rcdev->priv = gpio_ir;
> > +	rcdev->driver_name = DRIVER_NAME;
> > +	rcdev->device_name = DEVICE_NAME;
> > +	rcdev->tx_ir = gpio_ir_tx;
> > +	rcdev->s_tx_duty_cycle = gpio_ir_tx_set_duty_cycle;
> > +	rcdev->s_tx_carrier = gpio_ir_tx_set_carrier;
> > +
> > +	gpio_ir->gpio_nr = gpio;
> > +	gpio_ir->active_low = (flags & OF_GPIO_ACTIVE_LOW) != 0;
> 
> drop gpio_nr and active_low
> 
> > +	gpio_ir->carrier = 38000;
> > +	gpio_ir->duty_cycle = 50;
> > +	spin_lock_init(&gpio_ir->lock);
> > +
> > +	rc = devm_gpio_request(&pdev->dev, gpio, "gpio-ir-tx");
> > +	if (rc < 0)
> > +		return rc;
> > +
> > +	rc = gpio_direction_output(gpio, !gpio_ir->active_low);
> > +	if (rc < 0)
> > +		return rc;
> 
> drop devm_gpio_request and gpio_direction_output, that is already
> handled by devm_gpiod_get.
> 
> > +
> > +	rc = devm_rc_register_device(&pdev->dev, rcdev);
> > +	if (rc < 0)
> > +		dev_err(&pdev->dev, "failed to register rc device\n");
> > +
> > +	return rc;
> > +}
> > +
> > +static struct platform_driver gpio_ir_tx_driver = {
> > +	.probe	= gpio_ir_tx_probe,
> > +	.driver = {
> > +		.name	= DRIVER_NAME,
> > +		.of_match_table = of_match_ptr(gpio_ir_tx_of_match),
> > +	},
> > +};
> > +module_platform_driver(gpio_ir_tx_driver);
> > +
> > +MODULE_DESCRIPTION("GPIO Bit Banging IR Transmitter");
> > +MODULE_AUTHOR("Sean Young <sean@mess.org>");
> > +MODULE_LICENSE("GPL");
> > -- 
> > 2.9.4

I agree with your comments.

> 
> so long,
> 
> Hias
> ---
> diff --git a/drivers/media/rc/gpio-ir-tx.c b/drivers/media/rc/gpio-ir-tx.c
> index 7a5371dbb360..ca6834d09467 100644
> --- a/drivers/media/rc/gpio-ir-tx.c
> +++ b/drivers/media/rc/gpio-ir-tx.c
> @@ -13,11 +13,10 @@
>  
>  #include <linux/kernel.h>
>  #include <linux/module.h>
> -#include <linux/gpio.h>
> +#include <linux/gpio/consumer.h>
>  #include <linux/delay.h>
>  #include <linux/slab.h>
>  #include <linux/of.h>
> -#include <linux/of_gpio.h>
>  #include <linux/platform_device.h>
>  #include <media/rc-core.h>
>  
> @@ -25,8 +24,7 @@
>  #define DEVICE_NAME	"GPIO Bit Banging IR Transmitter"
>  
>  struct gpio_ir {
> -	int gpio_nr;
> -	bool active_low;
> +	struct gpio_desc *gpio;
>  	unsigned int carrier;
>  	unsigned int duty_cycle;
>  	/* we need a spinlock to hold the cpu while transmitting */
> @@ -101,14 +99,12 @@ static int gpio_ir_tx(struct rc_dev *dev, unsigned int *txbuf,
>  			ktime_t last = ktime_add_us(edge, txbuf[i]);
>  
>  			while (ktime_get() < last) {
> -				gpio_set_value(gpio_ir->gpio_nr,
> -					       gpio_ir->active_low);
> +				gpiod_set_value(gpio_ir->gpio, 1);
>  				edge += pulse;
>  				delta = edge - ktime_get();
>  				if (delta > 0)
>  					ndelay(delta);
> -				gpio_set_value(gpio_ir->gpio_nr,
> -					       !gpio_ir->active_low);
> +				gpiod_set_value(gpio_ir->gpio, 0);
>  				edge += space;
>  				delta = edge - ktime_get();
>  				if (delta > 0)
> @@ -128,16 +124,7 @@ static int gpio_ir_tx_probe(struct platform_device *pdev)
>  {
>  	struct gpio_ir *gpio_ir;
>  	struct rc_dev *rcdev;
> -	enum of_gpio_flags flags;
> -	int rc, gpio;
> -
> -	gpio = of_get_gpio_flags(pdev->dev.of_node, 0, &flags);
> -	if (gpio < 0) {
> -		if (gpio != -EPROBE_DEFER)
> -			dev_err(&pdev->dev, "Failed to get gpio flags (%d)\n",
> -				gpio);
> -		return -EINVAL;
> -	}
> +	int rc;
>  
>  	gpio_ir = devm_kmalloc(&pdev->dev, sizeof(*gpio_ir), GFP_KERNEL);
>  	if (!gpio_ir)
> @@ -147,6 +134,14 @@ static int gpio_ir_tx_probe(struct platform_device *pdev)
>  	if (!rcdev)
>  		return -ENOMEM;
>  
> +	gpio_ir->gpio = devm_gpiod_get(&pdev->dev, NULL, GPIOD_OUT_LOW);
> +	if (IS_ERR(gpio_ir->gpio)) {
> +		if (PTR_ERR(gpio_ir->gpio) != -EPROBE_DEFER)
> +			dev_err(&pdev->dev, "Failed to get gpio (%ld)\n",
> +				PTR_ERR(gpio_ir->gpio));
> +		return PTR_ERR(gpio_ir->gpio);
> +	}
> +
>  	rcdev->priv = gpio_ir;
>  	rcdev->driver_name = DRIVER_NAME;
>  	rcdev->device_name = DEVICE_NAME;
> @@ -154,20 +149,10 @@ static int gpio_ir_tx_probe(struct platform_device *pdev)
>  	rcdev->s_tx_duty_cycle = gpio_ir_tx_set_duty_cycle;
>  	rcdev->s_tx_carrier = gpio_ir_tx_set_carrier;
>  
> -	gpio_ir->gpio_nr = gpio;
> -	gpio_ir->active_low = (flags & OF_GPIO_ACTIVE_LOW) != 0;
>  	gpio_ir->carrier = 38000;
>  	gpio_ir->duty_cycle = 50;
>  	spin_lock_init(&gpio_ir->lock);
>  
> -	rc = devm_gpio_request(&pdev->dev, gpio, "gpio-ir-tx");
> -	if (rc < 0)
> -		return rc;
> -
> -	rc = gpio_direction_output(gpio, !gpio_ir->active_low);
> -	if (rc < 0)
> -		return rc;
> -
>  	rc = devm_rc_register_device(&pdev->dev, rcdev);
>  	if (rc < 0)
>  		dev_err(&pdev->dev, "failed to register rc device\n");
