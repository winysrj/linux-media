Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:37584 "EHLO
        mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751921AbdHHKcP (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 8 Aug 2017 06:32:15 -0400
Received: by mail-wm0-f48.google.com with SMTP id t201so3525535wmt.0
        for <linux-media@vger.kernel.org>; Tue, 08 Aug 2017 03:32:14 -0700 (PDT)
Date: Tue, 8 Aug 2017 14:32:10 +0400
From: Anton Sviridenko <anton@corp.bluecherry.net>
To: Andrey Utkin <andrey_utkin@fastmail.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org
Subject: Re: [PATCH] [media] solo6x10: export hardware GPIO pins 8:31 to
 gpiolib interface
Message-ID: <20170808103209.GA20000@magpie-gentoo>
References: <20170802141659.GA31617@magpie-gentoo>
 <20170807172644.GA21591@dell-m4800>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170807172644.GA21591@dell-m4800>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Aug 07, 2017 at 06:26:44PM +0100, Andrey Utkin wrote:
> Hi Anton,
> 

Hi

> > @@ -90,16 +93,110 @@ static void solo_gpio_config(struct solo_dev *solo_dev)
> >  
> 
> >  	/* Initially set relay status to 0 */
> 
> Do you mean that relay is initially disabled?
> Maybe a rewording would make it clearer.
> 
> >  	solo_gpio_clear(solo_dev, 0xff00);

Relays could be in any state on system power on. This line just 
sets relay outputs to known default initial state.


> > +
> 
> > +	/* Set input pins direction */
> 
> IMHO "Configure pins 16:31 as inputs" would be easier to read.
> 
> > +	solo_gpio_mode(solo_dev, 0xffff0000, 0);
> > +}
> > +

ok

> > +#ifdef CONFIG_GPIOLIB
> 
> > +/* Pins 0-7 are not exported, because it seems from code above they are
> 
> Comment opening ("/*") is usually left on empty line without text.
> The style you have here is discouraged.

Same comment style is used everywhere in solo6x10 code. So I think if it is
already accepted into Linux kernel, it should be fine. Also

> > +#ifdef CONFIG_GPIOLIB
> > +   /* GPIO */
> > +   struct gpio_chip        gpio_dev;
> > +#endif
>
> The comment is unnecessary.

such comments are everywhere in solo6x10.h, like 
/* General stuff */
/* tw28xx accounting */
/* i2c related items */
/* P2M DMA Engine */

So it would be inconsistent to add comments in a different style.

But you are welcome to post additional patch that fixes comments
everywhere in solo6x10 code and makes it conform to strict coding style standards :P

> Also, the comment reveals that you are not sure ("it seems from the code
> above..."). Please research and/or ask somebody to gain confidence, or
> state your lack of confidence in cover letter, but keep uncertainity out
> of the codebase. That's abstract advice, sorry I can't now check the
> actual issue to resolve this uncertainity.

"code above" actually refers to this comment

/* Warning: Don't touch the next line unless you're sure of what
 * you're doing: first four gpio [0-3] are used for video. */
solo_gpio_mode(solo_dev, 0x0f, 2);

So first four gpios are definitely used internally as I2C bus lines.
I'm not sure about remaining 4 pins, I don't have board schematics to
be sure if these pins are connected to something or used for something.
Also solo gpio pin 8 corresponds to relay output 0 on first GPIO
extension module, and solo pin 16 corresponds to input pin 0 on GPIO
module, there are no other inputs/outputs on these modules, only
24 pins can be used externally for relays/sensors.

> Also, is there a chance that somebody, e.g. you, may want to edit or at
> last to check in runtime how first 8 pins are configured, e.g. in
> debugging purposes? This is an argument for using offset 0 for physical
> pin 0.

No. Messing with first 4 GPIOs from userspace could interfere with 
video capturing process, and offset shifted to 8 pins perfectly maps
to external GPIO extension module pinout.

> 
> > + * used for internal purposes. So offset 0 corresponds to pin 8, therefore
> > + * offsets 0-7 are relay GPIOs, 8-23 - input GPIOs.
> > + */
> > +static int solo_gpiochip_get_direction(struct gpio_chip *chip,
> > +				       unsigned int offset)
> > +{
> > +	int ret, mode;
> > +	struct solo_dev *solo_dev = gpiochip_get_data(chip);
> > +
> > +	if (offset < 8) {
> > +		ret = solo_reg_read(solo_dev, SOLO_GPIO_CONFIG_0);
> 
> > +		mode = 3 & (ret >> ((offset + 8) * 2));
> 
> Mask of 0x3 is used, but result other than 0 and 1 yields "return -1". I
> haven't checked the spec, this just looks suspicious. Is the code
> correct?
> 
> Maybe some comment on meaning of "mode" value would help.

According to solo6110 datasheet, register SOLO_GPIO_CONFIG_0 contains
two configuration bits per each GPIO pin in range 0:15. 0 means "input",
1 - "output", and values 2 and 3 mean that pin is not in used in GPIO
mode, but in some other configuration, like I2C, SPI, serial port, etc.
So it is justified to return error code in this case.

> 
> > +	} else {
> > +		ret = solo_reg_read(solo_dev, SOLO_GPIO_CONFIG_1);
> > +		mode =  1 & (ret >> (offset - 8));
> > +	}
> > +
> > +	if (!mode)
> > +		return 1;
> > +	else if (mode == 1)
> > +		return 0;
> > +
> > +	return -1;
> >  }
> >  
> > +static int solo_gpiochip_direction_input(struct gpio_chip *chip,
> > +					 unsigned int offset)
> > +{
> > +	return -1;
> > +}
> > +
> > +static int solo_gpiochip_direction_output(struct gpio_chip *chip,
> > +					  unsigned int offset, int value)
> > +{
> > +	return -1;
> > +}
> > +
> 
> > +static int solo_gpiochip_get(struct gpio_chip *chip,
> > +						unsigned int offset)
> 
> line continuation is misaligned
> 
> > +{
> > +	int ret;
> > +	struct solo_dev *solo_dev = gpiochip_get_data(chip);
> > +
> > +	ret = solo_reg_read(solo_dev, SOLO_GPIO_DATA_IN);
> > +
> > +	return 1 & (ret >> (offset + 8));
> > +}
> > +
> 
> > +static void solo_gpiochip_set(struct gpio_chip *chip,
> > +						unsigned int offset, int value)
> 
> line continuation is misaligned
> 
> > +{
> > +	struct solo_dev *solo_dev = gpiochip_get_data(chip);
> > +
> > +	if (value)
> > +		solo_gpio_set(solo_dev, 1 << (offset + 8));
> > +	else
> > +		solo_gpio_clear(solo_dev, 1 << (offset + 8));
> > +}
> > +#endif
> > +
> >  int solo_gpio_init(struct solo_dev *solo_dev)
> >  {
> > +	int ret;
> > +
> >  	solo_gpio_config(solo_dev);
> > +#ifdef CONFIG_GPIOLIB
> 
> > +	solo_dev->gpio_dev.label = SOLO6X10_NAME"_gpio";
> 
> my eyeballs as well as 'checkpatch.pl --strict' say:
> 
> Concatenated strings should use spaces between elements
> 
> > diff --git a/drivers/media/pci/solo6x10/solo6x10.h b/drivers/media/pci/solo6x10/solo6x10.h
> > index 3f8da5e8c430..3a1893ae2dad 100644
> > --- a/drivers/media/pci/solo6x10/solo6x10.h
> > +++ b/drivers/media/pci/solo6x10/solo6x10.h
> > @@ -31,6 +31,7 @@
> >  #include <linux/atomic.h>
> >  #include <linux/slab.h>
> >  #include <linux/videodev2.h>
> > +#include <linux/gpio/driver.h>
> >  
> >  #include <media/v4l2-dev.h>
> >  #include <media/v4l2-device.h>
> > @@ -199,6 +200,10 @@ struct solo_dev {
> >  	u32			irq_mask;
> >  	u32			motion_mask;
> >  	struct v4l2_device	v4l2_dev;
> 
> > +#ifdef CONFIG_GPIOLIB
> > +	/* GPIO */
> > +	struct gpio_chip	gpio_dev;
> > +#endif
> 
> The comment is unnecessary.
> 
> >  
> >  	/* tw28xx accounting */
> >  	u8			tw2865, tw2864, tw2815;
> > -- 
> > 2.13.0
> > 
