Return-path: <linux-media-owner@vger.kernel.org>
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:35522 "EHLO
	smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752452Ab2GZPIA (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Jul 2012 11:08:00 -0400
Message-ID: <50115D4E.6030701@pobox.com>
Date: Thu, 26 Jul 2012 11:07:58 -0400
From: Mark Lord <mlord@pobox.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: linux-media@vger.kernel.org, Jarod Wilson <jarod@wilsonet.com>,
	Jiri Kosina <jkosina@suse.cz>,
	USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] mceusb: Add Twisted Melon USB IDs
References: <4FFE03E8.5040404@pobox.com>
In-Reply-To: <4FFE03E8.5040404@pobox.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12-07-11 06:53 PM, Mark Lord wrote:
> Add USB identifiers for MCE compatible I/R transceivers from Twisted Melon.
> 
> Signed-off-by: Mark Lord <mlord@pobox.com>
> ---
> Mauro, please queue this up for inclusion in linux-3.6.
> Patch is also attached to bypass emailer mangling.
> Thanks.
> 
> --- linux-3.5-rc6/drivers/media/rc/mceusb.c	2012-07-07 20:23:56.000000000 -0400
> +++ new/drivers/media/rc/mceusb.c	2012-07-11 18:44:03.113727658 -0400
> @@ -199,6 +199,7 @@
>  #define VENDOR_REALTEK		0x0bda
>  #define VENDOR_TIVO		0x105a
>  #define VENDOR_CONEXANT		0x0572
> +#define VENDOR_TWISTEDMELON	0x2596
> 
>  enum mceusb_model_type {
>  	MCE_GEN2 = 0,		/* Most boards */
> @@ -391,6 +392,12 @@
>  	/* Conexant Hybrid TV RDU253S Polaris */
>  	{ USB_DEVICE(VENDOR_CONEXANT, 0x58a5),
>  	  .driver_info = CX_HYBRID_TV },
> +	/* Twisted Melon Inc. - Manta Mini Receiver */
> +	{ USB_DEVICE(VENDOR_TWISTEDMELON, 0x8008) },
> +	/* Twisted Melon Inc. - Manta Pico Receiver */
> +	{ USB_DEVICE(VENDOR_TWISTEDMELON, 0x8016) },
> +	/* Twisted Melon Inc. - Manta Transceiver */
> +	{ USB_DEVICE(VENDOR_TWISTEDMELON, 0x8042) },
>  	/* Terminating entry */
>  	{ }
>  };
> 

Mauro, what is the status of this patch?
Is it going upstream through your tree for Linux-3.6?
If not, I'll send it directly to Linus.

Thanks
-- 
Mark Lord
Real-Time Remedies Inc.
mlord@pobox.com
