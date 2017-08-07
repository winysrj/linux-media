Return-path: <linux-media-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:33817 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751426AbdHGR0t (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 7 Aug 2017 13:26:49 -0400
Date: Mon, 7 Aug 2017 18:26:44 +0100
From: Andrey Utkin <andrey_utkin@fastmail.com>
To: Anton Sviridenko <anton@corp.bluecherry.net>
Cc: Bluecherry Maintainers <maintainers@bluecherrydvr.com>,
        Andrey Utkin <andrey.utkin@corp.bluecherry.net>,
        Ismael Luceno <ismael@iodev.co.uk>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org
Subject: Re: [PATCH] [media] solo6x10: export hardware GPIO pins 8:31 to
 gpiolib interface
Message-ID: <20170807172644.GA21591@dell-m4800>
References: <20170802141659.GA31617@magpie-gentoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170802141659.GA31617@magpie-gentoo>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Anton,

Nothing serious, just some purist nitpicking below.

On Wed, Aug 02, 2017 at 06:17:02PM +0400, Anton Sviridenko wrote:
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

Do you mean that relay is initially disabled?
Maybe a rewording would make it clearer.

>  	solo_gpio_clear(solo_dev, 0xff00);
> +

> +	/* Set input pins direction */

IMHO "Configure pins 16:31 as inputs" would be easier to read.

> +	solo_gpio_mode(solo_dev, 0xffff0000, 0);
> +}
> +
> +#ifdef CONFIG_GPIOLIB

> +/* Pins 0-7 are not exported, because it seems from code above they are

Comment opening ("/*") is usually left on empty line without text.
The style you have here is discouraged.

Also, the comment reveals that you are not sure ("it seems from the code
above..."). Please research and/or ask somebody to gain confidence, or
state your lack of confidence in cover letter, but keep uncertainity out
of the codebase. That's abstract advice, sorry I can't now check the
actual issue to resolve this uncertainity.

Also, is there a chance that somebody, e.g. you, may want to edit or at
last to check in runtime how first 8 pins are configured, e.g. in
debugging purposes? This is an argument for using offset 0 for physical
pin 0.

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

Mask of 0x3 is used, but result other than 0 and 1 yields "return -1". I
haven't checked the spec, this just looks suspicious. Is the code
correct?

Maybe some comment on meaning of "mode" value would help.

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

line continuation is misaligned

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

line continuation is misaligned

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

my eyeballs as well as 'checkpatch.pl --strict' say:

Concatenated strings should use spaces between elements

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

The comment is unnecessary.

>  
>  	/* tw28xx accounting */
>  	u8			tw2865, tw2864, tw2815;
> -- 
> 2.13.0
> 
