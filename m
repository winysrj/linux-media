Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19160 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750857AbaDRJ6w (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Apr 2014 05:58:52 -0400
Message-ID: <5350F758.5050308@redhat.com>
Date: Fri, 18 Apr 2014 11:58:48 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Robert Butora <robert.butora.fi@gmail.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 1/1] media:gspca:dtcs033 Clean sparse check warnings on
 endianess
References: <1397674009-10271-1-git-send-email-robert.butora.fi@gmail.com>
In-Reply-To: <1397674009-10271-1-git-send-email-robert.butora.fi@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

On 04/16/2014 08:46 PM, Robert Butora wrote:
> Warnings due to __le16 / u16 conversions.
> Replace offending struct and so stay on cpu domain.
> 
> Signed-off-by: Robert Butora <robert.butora.fi@gmail.com>

Thanks, I'll include this in my next pull-req to Mauro.

Regards,

Hans

> ---
>  drivers/media/usb/gspca/dtcs033.c | 15 +++++++++++----
>  1 file changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/usb/gspca/dtcs033.c b/drivers/media/usb/gspca/dtcs033.c
> index 5e42c71..96bfd4e 100644
> --- a/drivers/media/usb/gspca/dtcs033.c
> +++ b/drivers/media/usb/gspca/dtcs033.c
> @@ -22,6 +22,13 @@ MODULE_AUTHOR("Robert Butora <robert.butora.fi@gmail.com>");
>  MODULE_DESCRIPTION("Scopium DTCS033 astro-cam USB Camera Driver");
>  MODULE_LICENSE("GPL");
>  
> +struct dtcs033_usb_requests {
> +	u8 bRequestType;
> +	u8 bRequest;
> +	u16 wValue;
> +	u16 wIndex;
> +	u16 wLength;
> +};
>  
>  /* send a usb request */
>  static void reg_rw(struct gspca_dev *gspca_dev,
> @@ -50,10 +57,10 @@ static void reg_rw(struct gspca_dev *gspca_dev,
>  }
>  /* send several usb in/out requests */
>  static int reg_reqs(struct gspca_dev *gspca_dev,
> -		    const struct usb_ctrlrequest *preqs, int n_reqs)
> +		    const struct dtcs033_usb_requests *preqs, int n_reqs)
>  {
>  	int i = 0;
> -	const struct usb_ctrlrequest *preq;
> +	const struct dtcs033_usb_requests *preq;
>  
>  	while ((i < n_reqs) && (gspca_dev->usb_err >= 0)) {
>  
> @@ -290,7 +297,7 @@ module_usb_driver(sd_driver);
>   0x40 =  USB_DIR_OUT | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
>   0xC0 =  USB_DIR_IN  | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
>  */
> -static const struct usb_ctrlrequest dtcs033_start_reqs[] = {
> +static const struct dtcs033_usb_requests dtcs033_start_reqs[] = {
>  /* -- bRequest,wValue,wIndex,wLength */
>  { 0x40, 0x01, 0x0001, 0x000F, 0x0000 },
>  { 0x40, 0x01, 0x0000, 0x000F, 0x0000 },
> @@ -414,7 +421,7 @@ static const struct usb_ctrlrequest dtcs033_start_reqs[] = {
>  { 0x40, 0x01, 0x0003, 0x000F, 0x0000 }
>  };
>  
> -static const struct usb_ctrlrequest dtcs033_stop_reqs[] = {
> +static const struct dtcs033_usb_requests dtcs033_stop_reqs[] = {
>  /* -- bRequest,wValue,wIndex,wLength */
>  { 0x40, 0x01, 0x0001, 0x000F, 0x0000 },
>  { 0x40, 0x01, 0x0000, 0x000F, 0x0000 },
> 
