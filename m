Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:36726 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754472AbZERGlo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 May 2009 02:41:44 -0400
Date: Mon, 18 May 2009 03:41:39 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Uri Shkolnik <urishk@yahoo.com>
Cc: LinuxML <linux-media@vger.kernel.org>
Subject: Re: [PATCH] [0905_14] Siano: USB - move the device id table to the
 cards module
Message-ID: <20090518034139.2c28fbab@pedra.chehab.org>
In-Reply-To: <521027.71159.qm@web110809.mail.gq1.yahoo.com>
References: <521027.71159.qm@web110809.mail.gq1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 14 May 2009 12:29:35 -0700 (PDT)
Uri Shkolnik <urishk@yahoo.com> escreveu:

> 
> # HG changeset patch
> # User Uri Shkolnik <uris@siano-ms.com>
> # Date 1242325466 -10800
> # Node ID fe5ecbb828340406923d06b4ea93a210aafb5c7e
> # Parent  5a6de44c39c9198bc1af79f5901dc769690885de
> [0905_14] Siano: USB - move the device id table to the cards module
> 
> From: Uri Shkolnik <uris@siano-ms.com>
> 
> The card modules is the component which handles various targets,
> so the IDs table should reside within it.

The idea of moving it to sms-cards.c is interesting, however, I don't think
this will work fine, since having the usb probing code at one module and the
table on another will break for udev.

Also, by applying this patch, module loader would be broken:

WARNING: "smsusb_id_table" [/home/v4l/master/v4l/smsusb.ko] undefined!

I can see a few alternatives:

1) keep as-is;
2) move usb init code to sms-cards;
3) break sms-cards into smaller files, like sms-cards-usb (for usb devices);
4) having the table declared as static into some header file.

Due to that, I'll have to skip a few patches that are ok (the ones that are
just adding newer devices at the table).

Cheers,
Mauro.

> 
> Priority: normal
> 
> Signed-off-by: Uri Shkolnik <uris@siano-ms.com>
> 
> diff -r 5a6de44c39c9 -r fe5ecbb82834 linux/drivers/media/dvb/siano/sms-cards.c
> --- a/linux/drivers/media/dvb/siano/sms-cards.c	Thu May 14 21:14:46 2009 +0300
> +++ b/linux/drivers/media/dvb/siano/sms-cards.c	Thu May 14 21:24:26 2009 +0300
> @@ -18,6 +18,51 @@
>   */
>  
>  #include "sms-cards.h"
> +
> +struct usb_device_id smsusb_id_table[] = {
> +	{ USB_DEVICE(0x187f, 0x0010),
> +		.driver_info = SMS1XXX_BOARD_SIANO_STELLAR },
> +	{ USB_DEVICE(0x187f, 0x0100),
> +		.driver_info = SMS1XXX_BOARD_SIANO_STELLAR },
> +	{ USB_DEVICE(0x187f, 0x0200),
> +		.driver_info = SMS1XXX_BOARD_SIANO_NOVA_A },
> +	{ USB_DEVICE(0x187f, 0x0201),
> +		.driver_info = SMS1XXX_BOARD_SIANO_NOVA_B },
> +	{ USB_DEVICE(0x187f, 0x0300),
> +		.driver_info = SMS1XXX_BOARD_SIANO_VEGA },
> +	{ USB_DEVICE(0x2040, 0x1700),
> +		.driver_info = SMS1XXX_BOARD_HAUPPAUGE_CATAMOUNT },
> +	{ USB_DEVICE(0x2040, 0x1800),
> +		.driver_info = SMS1XXX_BOARD_HAUPPAUGE_OKEMO_A },
> +	{ USB_DEVICE(0x2040, 0x1801),
> +		.driver_info = SMS1XXX_BOARD_HAUPPAUGE_OKEMO_B },
> +	{ USB_DEVICE(0x2040, 0x2000),
> +		.driver_info = SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD },
> +	{ USB_DEVICE(0x2040, 0x2009),
> +		.driver_info = SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD_R2 },
> +	{ USB_DEVICE(0x2040, 0x200a),
> +		.driver_info = SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD },
> +	{ USB_DEVICE(0x2040, 0x2010),
> +		.driver_info = SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD },
> +	{ USB_DEVICE(0x2040, 0x2011),
> +		.driver_info = SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD },
> +	{ USB_DEVICE(0x2040, 0x2019),
> +		.driver_info = SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD },
> +	{ USB_DEVICE(0x2040, 0x5500),
> +		.driver_info = SMS1XXX_BOARD_HAUPPAUGE_WINDHAM },
> +	{ USB_DEVICE(0x2040, 0x5510),
> +		.driver_info = SMS1XXX_BOARD_HAUPPAUGE_WINDHAM },
> +	{ USB_DEVICE(0x2040, 0x5520),
> +		.driver_info = SMS1XXX_BOARD_HAUPPAUGE_WINDHAM },
> +	{ USB_DEVICE(0x2040, 0x5530),
> +		.driver_info = SMS1XXX_BOARD_HAUPPAUGE_WINDHAM },
> +	{ USB_DEVICE(0x2040, 0x5580),
> +		.driver_info = SMS1XXX_BOARD_HAUPPAUGE_WINDHAM },
> +	{ USB_DEVICE(0x2040, 0x5590),
> +		.driver_info = SMS1XXX_BOARD_HAUPPAUGE_WINDHAM },
> +	{ }		/* Terminating entry */
> +};
> +MODULE_DEVICE_TABLE(usb, smsusb_id_table);
>  
>  static int sms_dbg;
>  module_param_named(cards_dbg, sms_dbg, int, 0644);
> diff -r 5a6de44c39c9 -r fe5ecbb82834 linux/drivers/media/dvb/siano/sms-cards.h
> --- a/linux/drivers/media/dvb/siano/sms-cards.h	Thu May 14 21:14:46 2009 +0300
> +++ b/linux/drivers/media/dvb/siano/sms-cards.h	Thu May 14 21:24:26 2009 +0300
> @@ -45,6 +45,8 @@ struct sms_board {
>  
>  struct sms_board *sms_get_board(int id);
>  
> +extern struct usb_device_id smsusb_id_table[];
> +
>  int sms_board_setup(struct smscore_device_t *coredev);
>  
>  #define SMS_LED_OFF 0
> diff -r 5a6de44c39c9 -r fe5ecbb82834 linux/drivers/media/dvb/siano/smsusb.c
> --- a/linux/drivers/media/dvb/siano/smsusb.c	Thu May 14 21:14:46 2009 +0300
> +++ b/linux/drivers/media/dvb/siano/smsusb.c	Thu May 14 21:24:26 2009 +0300
> @@ -488,53 +488,6 @@ static int smsusb_resume(struct usb_inte
>  	return 0;
>  }
>  
> -struct usb_device_id smsusb_id_table[] = {
> -#ifdef CONFIG_DVB_SIANO_SMS1XXX_SMS_IDS
> -	{ USB_DEVICE(0x187f, 0x0010),
> -		.driver_info = SMS1XXX_BOARD_SIANO_STELLAR },
> -	{ USB_DEVICE(0x187f, 0x0100),
> -		.driver_info = SMS1XXX_BOARD_SIANO_STELLAR },
> -	{ USB_DEVICE(0x187f, 0x0200),
> -		.driver_info = SMS1XXX_BOARD_SIANO_NOVA_A },
> -	{ USB_DEVICE(0x187f, 0x0201),
> -		.driver_info = SMS1XXX_BOARD_SIANO_NOVA_B },
> -	{ USB_DEVICE(0x187f, 0x0300),
> -		.driver_info = SMS1XXX_BOARD_SIANO_VEGA },
> -#endif
> -	{ USB_DEVICE(0x2040, 0x1700),
> -		.driver_info = SMS1XXX_BOARD_HAUPPAUGE_CATAMOUNT },
> -	{ USB_DEVICE(0x2040, 0x1800),
> -		.driver_info = SMS1XXX_BOARD_HAUPPAUGE_OKEMO_A },
> -	{ USB_DEVICE(0x2040, 0x1801),
> -		.driver_info = SMS1XXX_BOARD_HAUPPAUGE_OKEMO_B },
> -	{ USB_DEVICE(0x2040, 0x2000),
> -		.driver_info = SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD },
> -	{ USB_DEVICE(0x2040, 0x2009),
> -		.driver_info = SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD_R2 },
> -	{ USB_DEVICE(0x2040, 0x200a),
> -		.driver_info = SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD },
> -	{ USB_DEVICE(0x2040, 0x2010),
> -		.driver_info = SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD },
> -	{ USB_DEVICE(0x2040, 0x2011),
> -		.driver_info = SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD },
> -	{ USB_DEVICE(0x2040, 0x2019),
> -		.driver_info = SMS1XXX_BOARD_HAUPPAUGE_TIGER_MINICARD },
> -	{ USB_DEVICE(0x2040, 0x5500),
> -		.driver_info = SMS1XXX_BOARD_HAUPPAUGE_WINDHAM },
> -	{ USB_DEVICE(0x2040, 0x5510),
> -		.driver_info = SMS1XXX_BOARD_HAUPPAUGE_WINDHAM },
> -	{ USB_DEVICE(0x2040, 0x5520),
> -		.driver_info = SMS1XXX_BOARD_HAUPPAUGE_WINDHAM },
> -	{ USB_DEVICE(0x2040, 0x5530),
> -		.driver_info = SMS1XXX_BOARD_HAUPPAUGE_WINDHAM },
> -	{ USB_DEVICE(0x2040, 0x5580),
> -		.driver_info = SMS1XXX_BOARD_HAUPPAUGE_WINDHAM },
> -	{ USB_DEVICE(0x2040, 0x5590),
> -		.driver_info = SMS1XXX_BOARD_HAUPPAUGE_WINDHAM },
> -	{ }		/* Terminating entry */
> -};
> -MODULE_DEVICE_TABLE(usb, smsusb_id_table);
> -
>  static struct usb_driver smsusb_driver = {
>  	.name			= "smsusb",
>  	.probe			= smsusb_probe,
> 
> 
> 
>       
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html




Cheers,
Mauro
