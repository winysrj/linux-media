Return-path: <linux-media-owner@vger.kernel.org>
Received: from slow1-d.mail.gandi.net ([217.70.178.86]:40065 "EHLO
        slow1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752073AbdKQSPd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Nov 2017 13:15:33 -0500
Received: from relay3-d.mail.gandi.net (relay3-d.mail.gandi.net [217.70.183.195])
        by slow1-d.mail.gandi.net (Postfix) with ESMTP id B768D487600
        for <linux-media@vger.kernel.org>; Fri, 17 Nov 2017 19:14:34 +0100 (CET)
Date: Fri, 17 Nov 2017 19:14:31 +0100
From: jacopo mondi <jacopo@jmondi.org>
To: Romain Reignier <r.reignier@robopec.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] media: cx231xx: add support for TheImagingSource
 DFG/USB2pro
Message-ID: <20171117181431.GG4668@w540>
References: <1674718.MAKsif4q92@xps-rre>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1674718.MAKsif4q92@xps-rre>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Romain,

On Fri, Nov 17, 2017 at 04:38:55PM +0100, Romain Reignier wrote:
> Hello,
>
> This is my first patch to the kernel so please be indulgent if I have done
> anything wrong and help me produce a better submission.

With this formatting (email text + patch below) applying with 'git am'
results in having the whole email text as commit message, which is not
what you want.

My suggestion is to amend your patch and insert a meaningful commit
message after the commit title (I think you should rework title a bit
as well, eg. captial 'A' on 'Add', space in between 'TheImagingSource'
if needed etc)

Then you can generate patch with 'git format-patch -s' and insert all
text you want -after- the commit message (everything after the
three dashes '---' gets ignored when git applies the patch)

Eg:
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
commit title

multi line commit message:
blah blah blah
blah blah blah

Your sign-off
---
The email text you sent us

---
The actual patch

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Run checkpatch.pl on the resulting patch and then, once checkpatch is happy,
you can send your v2 with git send-email.

When you'll be sending a series of multiple patches instead, please use
--cover-letter option with 'git format-patch' and place your email text there.

Thanks
  j


>
> This is a patch to add the support for The Imaging Source DFG/USB2pro USB
> capture device. It is based on the Conexant CX23102 chip do the patch only
> consists in adding one entry in the devices list.
>
> Note that the inputs for the Composite and S-Video are inverted in regard to
> most of the other boards.
>
> I could test the Composite input that is working for several months in some of
> our products. But did not have the chance to try the S-Video input because I
> do not own any device with that standard (I have tried a simple Composite to
> S-Video cable but it does not work, even on Windows). So I have applied the
> same settings as the Windows driver.
>
> I have created a page on the Wiki to describe the board:
> https://www.linuxtv.org/wiki/index.php/The_Imaging_Source_DFG-USB2pro
>
> Sincerely,
>
> Romain Reignier
>
> ---
>
> From 13d83af3e6e5c01b43875d67cdcc3312ebbc6c7a Mon Sep 17 00:00:00 2001
> From: Romain Reignier <r.reignier@robopec.com>
> Date: Fri, 17 Nov 2017 15:52:40 +0100
> Subject: [PATCH] media: cx231xx: add support for TheImagingSource DFG/USB2pro
>
> Signed-off-by: Romain Reignier <r.reignier@robopec.com>
> ---
>  drivers/media/usb/cx231xx/cx231xx-cards.c | 28 ++++++++++++++++++++++++++++
>  drivers/media/usb/cx231xx/cx231xx.h       |  1 +
>  2 files changed, 29 insertions(+)
>
> diff --git a/drivers/media/usb/cx231xx/cx231xx-cards.c b/drivers/media/usb/cx231xx/cx231xx-cards.c
> index 54d9d0c..99c8b1a 100644
> --- a/drivers/media/usb/cx231xx/cx231xx-cards.c
> +++ b/drivers/media/usb/cx231xx/cx231xx-cards.c
> @@ -896,6 +896,32 @@ struct cx231xx_board cx231xx_boards[] = {
>  			},
>  		},
>  	},
> +	[CX231XX_BOARD_THE_IMAGING_SOURCE_DFG_USB2_PRO] = {
> +		.name = "The Imaging Source DFG/USB2pro",
> +		.tuner_type = TUNER_ABSENT,
> +		.decoder = CX231XX_AVDECODER,
> +		.output_mode = OUT_MODE_VIP11,
> +		.demod_xfer_mode = 0,
> +		.ctl_pin_status_mask = 0xFFFFFFC4,
> +		.agc_analog_digital_select_gpio = 0x0c,
> +		.gpio_pin_status_mask = 0x4001000,
> +		.norm = V4L2_STD_PAL,
> +		.no_alt_vanc = 1,
> +		.external_av = 1,
> +		.input = {{
> +			.type = CX231XX_VMUX_COMPOSITE1,
> +			.vmux = CX231XX_VIN_1_1,
> +			.amux = CX231XX_AMUX_LINE_IN,
> +			.gpio = NULL,
> +		}, {
> +			.type = CX231XX_VMUX_SVIDEO,
> +			.vmux = CX231XX_VIN_2_1 |
> +				(CX231XX_VIN_2_2 << 8) |
> +				CX25840_SVIDEO_ON,
> +			.amux = CX231XX_AMUX_LINE_IN,
> +			.gpio = NULL,
> +		} },
> +	},
>  };
>  const unsigned int cx231xx_bcount = ARRAY_SIZE(cx231xx_boards);
>
> @@ -967,6 +993,8 @@ struct usb_device_id cx231xx_id_table[] = {
>  	.driver_info = CX231XX_BOARD_EVROMEDIA_FULL_HYBRID_FULLHD},
>  	{USB_DEVICE(0x15f4, 0x0135),
>  	.driver_info = CX231XX_BOARD_ASTROMETA_T2HYBRID},
> +	{USB_DEVICE(0x199e, 0x8002),
> +	 .driver_info = CX231XX_BOARD_THE_IMAGING_SOURCE_DFG_USB2_PRO},
>  	{},
>  };
>
> diff --git a/drivers/media/usb/cx231xx/cx231xx.h b/drivers/media/usb/cx231xx/cx231xx.h
> index 72d5937..65b039c 100644
> --- a/drivers/media/usb/cx231xx/cx231xx.h
> +++ b/drivers/media/usb/cx231xx/cx231xx.h
> @@ -80,6 +80,7 @@
>  #define CX231XX_BOARD_TERRATEC_GRABBY 22
>  #define CX231XX_BOARD_EVROMEDIA_FULL_HYBRID_FULLHD 23
>  #define CX231XX_BOARD_ASTROMETA_T2HYBRID 24
> +#define CX231XX_BOARD_THE_IMAGING_SOURCE_DFG_USB2_PRO 25
>
>  /* Limits minimum and default number of buffers */
>  #define CX231XX_MIN_BUF                 4
> --
> 2.7.4
>
