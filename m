Return-path: <linux-media-owner@vger.kernel.org>
Received: from web33504.mail.mud.yahoo.com ([68.142.206.153]:47567 "HELO
	web33504.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756471Ab0BOUXu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Feb 2010 15:23:50 -0500
Message-ID: <78570.55133.qm@web33504.mail.mud.yahoo.com>
References: <47786.707.qm@web33501.mail.mud.yahoo.com> <1266103739.3067.111.camel@palomino.walls.org>
Date: Mon, 15 Feb 2010 12:23:50 -0800 (PST)
From: Patrick Cairns <patrick_cairns@yahoo.com>
Subject: Re: Leadtek WinFast DVR3100 H zl10353_read_register: readreg error (reg=127, ret==-6)
To: Andy Walls <awalls@radix.net>
Cc: linux-media@vger.kernel.org
In-Reply-To: <1266103739.3067.111.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Thanks!

That patch, unchanged is consistently successful in addressing the Zarlink initialisation error for me.

It also eliminates a no doubt related problem in the lack of detection of some of the Xceive tuners, a problem I had previously overlooked for some reason and later discovered when I wanted to see if analogue tuning worked.   detail: i2c_core:i2c_new_probed_device would fairly consistently fail to find/probe some of the tuners such that 'XX-0061: chip found @ 0xc2 (cx18 i2c driver #X-1)' logs would only appear against roughly half of my cards - a much more obvious problem than the one I originally reported!

Briefly I patched my build to ignore the Zarlink frontend initialisation error and allow the cx18 to proceed to register the v4l device and this helped me meet my main composite video capture project requirement - this is now unnecessary.

I'll be testing over the next few days and report anything unexpected / of interested.

Cheers

Patrick

----- Original Message ----
> From: Andy Walls <awalls@radix.net>
> To: Patrick Cairns <patrick_cairns@yahoo.com>
> Cc: linux-media@vger.kernel.org
> Sent: Sat, 13 February, 2010 23:28:59
> Subject: Re: Leadtek WinFast DVR3100 H zl10353_read_register: readreg error (reg=127, ret==-6)
> 
> On Tue, 2010-02-09 at 07:19 -0800, Patrick Cairns wrote:
> > > On Tue, 2010-02-09 at 03:35 -0800, Patrick Cairns wrote:
> 
> > > > I'm testing use of multiple Leadtek WinFast DVR3100 H cards for a
> > > > project.  I've had large numbers of them working well in the same
> > > > machine as encoders (haven't been using the DVB-T capabilities).
> > > > 
> > > > However if I use more than a few of these cards in the same machine
> > > > then upon startup there are always one or two cards where Zarlink
> > > > zl10353 reading errors are reported preventing their use:-
> > > > 
> 
> 
> > > This was an excellent test to perform.  IIRC, only the ZL10353 and
> > > XC3028 are on the second I2C bus (#10-1 in this case), which likely
> > > means one of those two chips is hung.
> 
> > > > Can anyone advise how to debug this further or know any fixes to try?
> > > > I'm not quite sure what's going on under the hood.
> 
> 
> Patrick,
> 
> Can you test the patch below?  It will reset the XC3028 before the I2C
> bus is first used, and it will try to reset the ZL10353 before the I2C
> bus is first used.
> 
> You'll need to recompile and test until you find the GPIO line that
> appears to reset the ZL10353.
> 
> #define DVR3100_ZL10353_RESET_GPIO    (1 << 8)
>                                               ^
>                                               |
>                                        Change this number
> 
> Try GPIO pins 8-15 first, then 3-7, then 16-31, then 0.
> If that doesn't work then try them again, but change more of the patch
> to assume an active high reset for the ZL10353 GPIO line instead of
> active low.
> 
> 
> There is also an W83601 chip connected to this I2C bus along with the
> XC3028 and ZL10353, but hopefully we won't have to worry about resetting
> that too.
> 
> Please let me know if you find a GPIO pin that reliably has all your
> cards working upon modprobe.  You should *not* need to cycle power
> between each test.
> 
> Regards,
> Andy
> 
> diff -r 14021dfc00f3 linux/drivers/media/video/cx18/cx18-cards.c
> --- a/linux/drivers/media/video/cx18/cx18-cards.c    Thu Feb 11 23:11:30 2010 
> -0200
> +++ b/linux/drivers/media/video/cx18/cx18-cards.c    Sat Feb 13 18:14:32 2010 
> -0500
> @@ -452,10 +452,34 @@
>         .tune_lane = 0,
>         .initial_emrs = 0x2,
>     },
> -    .gpio_init.initial_value = 0x6,
> -    .gpio_init.direction = 0x7,
> -    .gpio_audio_input = { .mask   = 0x7,
> -                  .tuner  = 0x6, .linein = 0x2, .radio  = 0x2 },
> +
> +    /*
> +     *  GPIOs
> +     *  0 0x00000001 Audio/FM related???
> +     *  1 0x00000002 XC3028 reset line, active low
> +     *  2 0x00000004 Audio input multiplexer: 1 - Tuner, 0 - Line-in
> +     */
> +#define DVR3100_XC3028_RESET_GPIO    (1 << 1)
> +
> +    /* FIXME - Try GPIO pins 8-15 first, then 3-7, then 16-31, then 0, */
> +    /* then try them again using active high for the reset, until found */
> +#define DVR3100_ZL10353_RESET_GPIO    (1 << 8)
> +
> +    .gpio_init.direction = 0x5 |
> +                   DVR3100_XC3028_RESET_GPIO |
> +                   DVR3100_ZL10353_RESET_GPIO,
> +    .gpio_init.initial_value = 0x4 |
> +                   DVR3100_XC3028_RESET_GPIO |
> +                   DVR3100_ZL10353_RESET_GPIO,
> +    .gpio_audio_input = { .mask   = 0x4,
> +                  .tuner  = 0x4, .linein = 0x0, .radio  = 0x0 },
> +    .gpio_i2c_slave_reset = {
> +        .active_hi_mask = 0x0,
> +        .active_lo_mask = DVR3100_XC3028_RESET_GPIO |
> +                  DVR3100_ZL10353_RESET_GPIO,
> +        .msecs_asserted = 50, /* ZL10353 requires 50 ms */
> +        .msecs_recovery = 50, /* A guess */
> +    },
>     .xceive_pin = 1,
>     .pci_list = cx18_pci_leadtek_dvr3100h,
>     .i2c = &cx18_i2c_std,



      
