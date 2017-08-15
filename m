Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:55081 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751640AbdHOLpR (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 15 Aug 2017 07:45:17 -0400
Date: Tue, 15 Aug 2017 12:45:15 +0100
From: Sean Young <sean@mess.org>
To: Arvind Yadav <arvind.yadav.cs@gmail.com>
Cc: crope@iki.fi, mchehab@kernel.org, ezequiel@vanguardiasur.com.ar,
        laurent.pinchart@ideasonboard.com, royale@zerezo.com,
        klimov.linux@gmail.com, hverkuil@xs4all.nl,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] [media] rc: constify usb_device_id
Message-ID: <20170815114514.22obm3za3gt3erco@gofer.mess.org>
References: <1502614485-2150-1-git-send-email-arvind.yadav.cs@gmail.com>
 <1502614485-2150-3-git-send-email-arvind.yadav.cs@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1502614485-2150-3-git-send-email-arvind.yadav.cs@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Aug 13, 2017 at 02:24:44PM +0530, Arvind Yadav wrote:
> usb_device_id are not supposed to change at runtime. All functions
> working with usb_device_id provided by <linux/usb.h> work with
> const usb_device_id. So mark the non-const structs as const.
> 
> Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>

Acked-by: Sean Young <sean@mess.org>

Thanks for spotting that.

Sean

> ---
>  drivers/media/rc/ati_remote.c  | 2 +-
>  drivers/media/rc/igorplugusb.c | 2 +-
>  drivers/media/rc/imon.c        | 2 +-
>  drivers/media/rc/mceusb.c      | 2 +-
>  drivers/media/rc/redrat3.c     | 2 +-
>  drivers/media/rc/streamzap.c   | 2 +-
>  6 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/media/rc/ati_remote.c b/drivers/media/rc/ati_remote.c
> index a4c6ad4..d1d0c48 100644
> --- a/drivers/media/rc/ati_remote.c
> +++ b/drivers/media/rc/ati_remote.c
> @@ -198,7 +198,7 @@ static const struct ati_receiver_type type_firefly	= {
>  	.default_keymap = RC_MAP_SNAPSTREAM_FIREFLY
>  };
>  
> -static struct usb_device_id ati_remote_table[] = {
> +static const struct usb_device_id ati_remote_table[] = {
>  	{
>  		USB_DEVICE(ATI_REMOTE_VENDOR_ID, LOLA_REMOTE_PRODUCT_ID),
>  		.driver_info = (unsigned long)&type_ati
> diff --git a/drivers/media/rc/igorplugusb.c b/drivers/media/rc/igorplugusb.c
> index cb6d4f1..c294ec5 100644
> --- a/drivers/media/rc/igorplugusb.c
> +++ b/drivers/media/rc/igorplugusb.c
> @@ -244,7 +244,7 @@ static void igorplugusb_disconnect(struct usb_interface *intf)
>  	usb_free_urb(ir->urb);
>  }
>  
> -static struct usb_device_id igorplugusb_table[] = {
> +static const struct usb_device_id igorplugusb_table[] = {
>  	/* Igor Plug USB (Atmel's Manufact. ID) */
>  	{ USB_DEVICE(0x03eb, 0x0002) },
>  	/* Fit PC2 Infrared Adapter */
> diff --git a/drivers/media/rc/imon.c b/drivers/media/rc/imon.c
> index bd76534..3f414ab 100644
> --- a/drivers/media/rc/imon.c
> +++ b/drivers/media/rc/imon.c
> @@ -346,7 +346,7 @@ static const struct imon_usb_dev_descr imon_ir_raw = {
>   * devices use the SoundGraph vendor ID (0x15c2). This driver only supports
>   * the ffdc and later devices, which do onboard decoding.
>   */
> -static struct usb_device_id imon_usb_id_table[] = {
> +static const struct usb_device_id imon_usb_id_table[] = {
>  	/*
>  	 * Several devices with this same device ID, all use iMON_PAD.inf
>  	 * SoundGraph iMON PAD (IR & VFD)
> diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
> index eb13069..6664d91 100644
> --- a/drivers/media/rc/mceusb.c
> +++ b/drivers/media/rc/mceusb.c
> @@ -249,7 +249,7 @@ static const struct mceusb_model mceusb_model[] = {
>  	},
>  };
>  
> -static struct usb_device_id mceusb_dev_table[] = {
> +static const struct usb_device_id mceusb_dev_table[] = {
>  	/* Original Microsoft MCE IR Transceiver (often HP-branded) */
>  	{ USB_DEVICE(VENDOR_MICROSOFT, 0x006d),
>  	  .driver_info = MCE_GEN1 },
> diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
> index 56d43be..48f27ac 100644
> --- a/drivers/media/rc/redrat3.c
> +++ b/drivers/media/rc/redrat3.c
> @@ -186,7 +186,7 @@ struct redrat3_error {
>  } __packed;
>  
>  /* table of devices that work with this driver */
> -static struct usb_device_id redrat3_dev_table[] = {
> +static const struct usb_device_id redrat3_dev_table[] = {
>  	/* Original version of the RedRat3 */
>  	{USB_DEVICE(USB_RR3USB_VENDOR_ID, USB_RR3USB_PRODUCT_ID)},
>  	/* Second Version/release of the RedRat3 - RetRat3-II */
> diff --git a/drivers/media/rc/streamzap.c b/drivers/media/rc/streamzap.c
> index b09c45a..1f00727 100644
> --- a/drivers/media/rc/streamzap.c
> +++ b/drivers/media/rc/streamzap.c
> @@ -43,7 +43,7 @@
>  #define USB_STREAMZAP_PRODUCT_ID	0x0000
>  
>  /* table of devices that work with this driver */
> -static struct usb_device_id streamzap_table[] = {
> +static const struct usb_device_id streamzap_table[] = {
>  	/* Streamzap Remote Control */
>  	{ USB_DEVICE(USB_STREAMZAP_VENDOR_ID, USB_STREAMZAP_PRODUCT_ID) },
>  	/* Terminating entry */
> -- 
> 2.7.4
