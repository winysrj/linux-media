Return-path: <linux-media-owner@vger.kernel.org>
Received: from iodev.co.uk ([82.211.30.53]:52618 "EHLO iodev.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751133AbdHBPhE (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 2 Aug 2017 11:37:04 -0400
Date: Wed, 2 Aug 2017 12:36:43 -0300
From: Ismael Luceno <ismael@iodev.co.uk>
To: Anton Sviridenko <anton@corp.bluecherry.net>
Cc: Bluecherry Maintainers <maintainers@bluecherrydvr.com>,
        Andrey Utkin <andrey.utkin@corp.bluecherry.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org
Subject: Re: [PATCH] [media] solo6x10: export hardware GPIO pins 8:31 to
 gpiolib interface
Message-ID: <20170802153642.GQ854@pirotess.bf.iodev.co.uk>
References: <20170802141659.GA31617@magpie-gentoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170802141659.GA31617@magpie-gentoo>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/Aug/2017 18:17, Anton Sviridenko wrote:
> 24 GPIO pins from 32 available on solo6x10 chips are exported
> to gpiolib. First 8 GPIOs are reserved for internal use on capture card
> boards, GPIOs in range 8:15 are configured as outputs to control relays,
> remaining 16:31 are configured as inputs to read sensor states.
> Now with this patch userspace DVR software can switch relays and read
> sensor states when GPIO extension cards are attached to Softlogic solo6x10
> based video capture cards.
> 
> Signed-off-by: Anton Sviridenko <anton@corp.bluecherry.net>
> ---
>  drivers/media/pci/solo6x10/solo6x10-gpio.c | 97 ++++++++++++++++++++++++++++++
>  drivers/media/pci/solo6x10/solo6x10.h      |  5 ++
>  2 files changed, 102 insertions(+)
> 
> diff --git a/drivers/media/pci/solo6x10/solo6x10-gpio.c b/drivers/media/pci/solo6x10/solo6x10-gpio.c
> index 6d3b4a36bc11..3d0d1aa2f6a8 100644
> --- a/drivers/media/pci/solo6x10/solo6x10-gpio.c
> +++ b/drivers/media/pci/solo6x10/solo6x10-gpio.c
> @@ -57,6 +57,9 @@ static void solo_gpio_mode(struct solo_dev *solo_dev,
>  			ret |= 1 << port;
>  	}
>  
> +	/* Enable GPIO[31:16] */
> +	ret |= 0xffff0000;
> +
>  	solo_reg_write(solo_dev, SOLO_GPIO_CONFIG_1, ret);
>  }
>  
> @@ -90,16 +93,110 @@ static void solo_gpio_config(struct solo_dev *solo_dev)
>  
>  	/* Initially set relay status to 0 */
>  	solo_gpio_clear(solo_dev, 0xff00);
> +
> +	/* Set input pins direction */
> +	solo_gpio_mode(solo_dev, 0xffff0000, 0);
> +}
> +
> +#ifdef CONFIG_GPIOLIB
> +/* Pins 0-7 are not exported, because it seems from code above they are
> + * used for internal purposes. So offset 0 corresponds to pin 8, therefore
> + * offsets 0-7 are relay GPIOs, 8-23 - input GPIOs.
> + */
> +static int solo_gpiochip_get_direction(struct gpio_chip *chip,
> +				       unsigned int offset)
> +{
> +	int ret, mode;
> +	struct solo_dev *solo_dev = gpiochip_get_data(chip);
> +
> +	if (offset < 8) {
> +		ret = solo_reg_read(solo_dev, SOLO_GPIO_CONFIG_0);
> +		mode = 3 & (ret >> ((offset + 8) * 2));
> +	} else {
> +		ret = solo_reg_read(solo_dev, SOLO_GPIO_CONFIG_1);
> +		mode =  1 & (ret >> (offset - 8));
> +	}
> +
> +	if (!mode)
> +		return 1;
> +	else if (mode == 1)
> +		return 0;
> +
> +	return -1;
>  }
>  
> +static int solo_gpiochip_direction_input(struct gpio_chip *chip,
> +					 unsigned int offset)
> +{
> +	return -1;
> +}
> +
> +static int solo_gpiochip_direction_output(struct gpio_chip *chip,
> +					  unsigned int offset, int value)
> +{
> +	return -1;
> +}
> +
> +static int solo_gpiochip_get(struct gpio_chip *chip,
> +						unsigned int offset)
> +{
> +	int ret;
> +	struct solo_dev *solo_dev = gpiochip_get_data(chip);
> +
> +	ret = solo_reg_read(solo_dev, SOLO_GPIO_DATA_IN);
> +
> +	return 1 & (ret >> (offset + 8));
> +}
> +
> +static void solo_gpiochip_set(struct gpio_chip *chip,
> +						unsigned int offset, int value)
> +{
> +	struct solo_dev *solo_dev = gpiochip_get_data(chip);
> +
> +	if (value)
> +		solo_gpio_set(solo_dev, 1 << (offset + 8));
> +	else
> +		solo_gpio_clear(solo_dev, 1 << (offset + 8));
> +}
> +#endif
> +
>  int solo_gpio_init(struct solo_dev *solo_dev)
>  {
> +	int ret;
> +
>  	solo_gpio_config(solo_dev);
> +#ifdef CONFIG_GPIOLIB
> +	solo_dev->gpio_dev.label = SOLO6X10_NAME"_gpio";
> +	solo_dev->gpio_dev.parent = &solo_dev->pdev->dev;
> +	solo_dev->gpio_dev.owner = THIS_MODULE;
> +	solo_dev->gpio_dev.base = -1;
> +	solo_dev->gpio_dev.ngpio = 24;
> +	solo_dev->gpio_dev.can_sleep = 0;
> +
> +	solo_dev->gpio_dev.get_direction = solo_gpiochip_get_direction;
> +	solo_dev->gpio_dev.direction_input = solo_gpiochip_direction_input;
> +	solo_dev->gpio_dev.direction_output = solo_gpiochip_direction_output;
> +	solo_dev->gpio_dev.get = solo_gpiochip_get;
> +	solo_dev->gpio_dev.set = solo_gpiochip_set;
> +
> +	ret = gpiochip_add_data(&solo_dev->gpio_dev, solo_dev);
> +
> +	if (ret) {
> +		solo_dev->gpio_dev.label = NULL;
> +		return -1;
> +	}
> +#endif
>  	return 0;
>  }
>  
>  void solo_gpio_exit(struct solo_dev *solo_dev)
>  {
> +#ifdef CONFIG_GPIOLIB
> +	if (solo_dev->gpio_dev.label) {
> +		gpiochip_remove(&solo_dev->gpio_dev);
> +		solo_dev->gpio_dev.label = NULL;
> +	}
> +#endif
>  	solo_gpio_clear(solo_dev, 0x30);
>  	solo_gpio_config(solo_dev);
>  }
> diff --git a/drivers/media/pci/solo6x10/solo6x10.h b/drivers/media/pci/solo6x10/solo6x10.h
> index 3f8da5e8c430..3a1893ae2dad 100644
> --- a/drivers/media/pci/solo6x10/solo6x10.h
> +++ b/drivers/media/pci/solo6x10/solo6x10.h
> @@ -31,6 +31,7 @@
>  #include <linux/atomic.h>
>  #include <linux/slab.h>
>  #include <linux/videodev2.h>
> +#include <linux/gpio/driver.h>
>  
>  #include <media/v4l2-dev.h>
>  #include <media/v4l2-device.h>
> @@ -199,6 +200,10 @@ struct solo_dev {
>  	u32			irq_mask;
>  	u32			motion_mask;
>  	struct v4l2_device	v4l2_dev;
> +#ifdef CONFIG_GPIOLIB
> +	/* GPIO */
> +	struct gpio_chip	gpio_dev;
> +#endif
>  
>  	/* tw28xx accounting */
>  	u8			tw2865, tw2864, tw2815;
> -- 
> 2.13.0
> 

Signed-off-by: Ismael Luceno <ismael@iodev.co.uk>
