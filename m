Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr19.xs4all.nl ([194.109.24.39]:3633 "EHLO
	smtp-vbr19.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696Ab3CAHwr (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 1 Mar 2013 02:52:47 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Matt Gomboc" <gomboc0@gmail.com>
Subject: Re: cx231xx : Add support for OTG102 aka EZGrabber2
Date: Fri, 1 Mar 2013 08:52:36 +0100
Cc: linux-media@vger.kernel.org
References: <4B487EF5847E47F0A8C1E96B9CA6B6D6@ucdenver.pvt>
In-Reply-To: <4B487EF5847E47F0A8C1E96B9CA6B6D6@ucdenver.pvt>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201303010852.36574.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri March 1 2013 00:34:38 Matt Gomboc wrote:
> This is a patch I have created that enables basic support for a product
> marketed as EZGrabber2, which is identified as an OTG102 board by dmesg and
> lsusb.
> 
> I have documented some detail about the product and this patch at
> http://linuxtv.org/wiki/index.php/OTG102. In summary, it has a peculiarly
> marked chipset, CX78921-11z, although the packaged windows drivers looked
> similar enough to the cx23100 series. With some experimentation, was able to
> get the device to operate properly by replicating much of the code for the
> CX231XX_BOARD_CNXT_VIDEO_GRABBER, but with the
> agc_analog_digital_select_gpio information from the windows driver inf file
> and defining .dont_use_port_3.
> 
> The vendor documentation states the device supports hardware encoding of
> MPEG1/2/4. If I don't include the .has_417=1 option in the device
> definition, it creates a single /dev/video0 device which works and provides
> uncompressed video. If I do include that option, the working device is moved
> to video1, and video0 is created but no data comes out of it. The Geniatech
> driver also contains a firmware image called cx416enc.rom which is very
> similar (in binary comparison) to the v4l-cx23885-enc.fw/ hcw85enc.rom. 

Yeah, I never was able to get the 417 part working either. The code for
that seems to be highly unstable.

> The patch is against my local gentoo-3.6 kernel. As I am a first time
> contributor to this mailing list, and only have a superficial understanding
> of the cx231xx and related drivers and the v4l2 framework (and c programming
> in general), any stylistic or procedural guidance for improving the patch
> for eventual submission, information posted to the linuxtv wiki, etc, would
> be welcome.

It's not bad for a first time :-)

The main thing to remember is to post the patch as part of the email, not as
an attachment. That makes it easier for us to review.

I also need a 'Signed-of-by' line before a patch can be submitted. See:

http://linuxtv.org/wiki/index.php/Development:_How_to_submit_patches

> Also considering the recently submitted patch for the "Elgato Video Capture
> V2" which also adds device 16 to cx2311.h and the many recent patches by
> Hans Verkuil, this may take some further working to align it with a moving
> target.

It shouldn't be too bad, but it probably makes life easier if we wait with
applying this patch until after my patch series has been merged.

> If you desire any further information, let me know. Thanks.
> 
> Matt 

Some small comments regarding this patch:

> diff -uprN linux-3.6/drivers/media/video/cx231xx/cx231xx-avcore.c linux-3.6.new/drivers/media/video/cx231xx/cx231xx-avcore.c
> --- linux-3.6/drivers/media/video/cx231xx/cx231xx-avcore.c	2012-09-30 17:47:46.000000000 -0600
> +++ linux-3.6.new/drivers/media/video/cx231xx/cx231xx-avcore.c	2013-02-26 19:58:51.096793077 -0700
> @@ -352,6 +352,7 @@ int cx231xx_afe_update_power_control(str
>  	case CX231XX_BOARD_CNXT_RDE_253S:
>  	case CX231XX_BOARD_CNXT_RDU_253S:
>  	case CX231XX_BOARD_CNXT_VIDEO_GRABBER:
> +	case CX231XX_BOARD_OTG102:
>  	case CX231XX_BOARD_HAUPPAUGE_EXETER:
>  	case CX231XX_BOARD_HAUPPAUGE_USBLIVE2:
>  	case CX231XX_BOARD_PV_PLAYTV_USB_HYBRID:
> @@ -1719,6 +1720,7 @@ int cx231xx_dif_set_standard(struct cx23
>  	case CX231XX_BOARD_CNXT_SHELBY:
>  	case CX231XX_BOARD_CNXT_RDU_250:
>  	case CX231XX_BOARD_CNXT_VIDEO_GRABBER:
> +	case CX231XX_BOARD_OTG102:
>  	case CX231XX_BOARD_HAUPPAUGE_EXETER:
>  		func_mode = 0x03;
>  		break;
> diff -uprN linux-3.6/drivers/media/video/cx231xx/cx231xx-cards.c linux-3.6.new/drivers/media/video/cx231xx/cx231xx-cards.c
> --- linux-3.6/drivers/media/video/cx231xx/cx231xx-cards.c	2012-09-30 17:47:46.000000000 -0600
> +++ linux-3.6.new/drivers/media/video/cx231xx/cx231xx-cards.c	2013-02-28 12:23:58.925869674 -0700
> @@ -280,6 +280,37 @@ struct cx231xx_board cx231xx_boards[] =
>  			}
>  		},
>  	},
> +	[CX231XX_BOARD_OTG102] = {
> +                .name = "Geniatech OTG102",
> +                .tuner_type = TUNER_ABSENT,
> +                .decoder = CX231XX_AVDECODER,
> +                .output_mode = OUT_MODE_VIP11,
> +                .ctl_pin_status_mask = 0xFFFFFFC4,
> +                .agc_analog_digital_select_gpio = 0x0c, /* According with PV CxPlrCAP.inf file */
> +                .gpio_pin_status_mask = 0x4001000,
> +                .norm = V4L2_STD_NTSC,
> +                .no_alt_vanc = 1,
> +                .external_av = 1,
> +                .dont_use_port_3 = 1,
> +		//.has_417 = 1,

Don't use //, always use /* */ (coding style issue).

> +		/* this board has hardware encoding chip supporting mpeg1/2/4, but as the 417 is apparently not working for the
> +		   reference board it is not on this one either. building the driver with this option and then loading the module
> +		   creates a second video device node, but nothing comes out of it.  */

These comments shouldn't go over column 80.


> +                .input = {{
> +                                .type = CX231XX_VMUX_COMPOSITE1,
> +                                .vmux = CX231XX_VIN_2_1,
> +                                .amux = CX231XX_AMUX_LINE_IN,
> +                                .gpio = NULL,
> +                        }, {
> +                                .type = CX231XX_VMUX_SVIDEO,
> +                                .vmux = CX231XX_VIN_1_1 |
> +                                        (CX231XX_VIN_1_2 << 8) |
> +                                        CX25840_SVIDEO_ON,
> +                                .amux = CX231XX_AMUX_LINE_IN,
> +                                .gpio = NULL,
> +                        }
> +                },
> +        },
>  	[CX231XX_BOARD_CNXT_RDE_250] = {
>  		.name = "Conexant Hybrid TV - rde 250",
>  		.tuner_type = TUNER_XC5000,
> @@ -620,6 +651,8 @@ struct usb_device_id cx231xx_id_table[]
>  	 .driver_info = CX231XX_BOARD_CNXT_RDU_253S},
>  	{USB_DEVICE(0x0572, 0x58A6),
>  	 .driver_info = CX231XX_BOARD_CNXT_VIDEO_GRABBER},
> +	{USB_DEVICE(0x1F4D, 0x0102),
> +	 .driver_info = CX231XX_BOARD_OTG102},
>  	{USB_DEVICE(0x0572, 0x589E),
>  	 .driver_info = CX231XX_BOARD_CNXT_RDE_250},
>  	{USB_DEVICE(0x0572, 0x58A0),
> @@ -904,6 +937,12 @@ static int cx231xx_init_dev(struct cx231
>  		cx231xx_set_alt_setting(dev, INDEX_VIDEO, 3);
>  		cx231xx_set_alt_setting(dev, INDEX_VANC, 1);
>  	}
> +/*

Why is this commented out? Can't this just be removed?

> +	if (dev->model == CX231XX_OTG102) {
> +		cx231xx_set_alt_setting(dev, INDEX_VIDEO, 3);
> +		cx231xx_set_alt_setting(dev, INDEX_VANC, 1);
> +	}
> +*/
>  	/* Cx231xx pre card setup */
>  	cx231xx_pre_card_setup(dev);
>  
> @@ -1295,6 +1334,12 @@ static int cx231xx_usb_probe(struct usb_
>  		cx231xx_enable_OSC(dev);
>  		cx231xx_reset_out(dev);
>  		cx231xx_set_alt_setting(dev, INDEX_VIDEO, 3);
> +	}
> +	
> +	if (dev->model == CX231XX_BOARD_OTG102) {
> +		cx231xx_enable_OSC(dev);
> +		cx231xx_reset_out(dev);
> +		cx231xx_set_alt_setting(dev, INDEX_VIDEO, 3);
>  	}
>  
>  	if (dev->model == CX231XX_BOARD_CNXT_RDE_253S)
> diff -uprN linux-3.6/drivers/media/video/cx231xx/cx231xx.h linux-3.6.new/drivers/media/video/cx231xx/cx231xx.h
> --- linux-3.6/drivers/media/video/cx231xx/cx231xx.h	2012-09-30 17:47:46.000000000 -0600
> +++ linux-3.6.new/drivers/media/video/cx231xx/cx231xx.h	2013-02-26 16:01:58.924653199 -0700
> @@ -68,6 +68,7 @@
>  #define CX231XX_BOARD_ICONBIT_U100 13
>  #define CX231XX_BOARD_HAUPPAUGE_USB2_FM_PAL 14
>  #define CX231XX_BOARD_HAUPPAUGE_USB2_FM_NTSC 15
> +#define CX231XX_BOARD_OTG102 16
>  
>  /* Limits minimum and default number of buffers */
>  #define CX231XX_MIN_BUF                 4

I recommend creating your patch on top of my patch series which is available
here: http://git.linuxtv.org/hverkuil/media_tree.git/shortlog/refs/heads/cx231xx

That way I can just add your patch to my patch series and the whole lot will
be merged in one go by Mauro.

Regards,

	Hans
