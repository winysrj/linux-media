Return-path: <mchehab@pedra>
Received: from mail.kapsi.fi ([217.30.184.167]:37104 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757181Ab1CRQgQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 18 Mar 2011 12:36:16 -0400
Message-ID: <4D8389FB.6040707@iki.fi>
Date: Fri, 18 Mar 2011 18:36:11 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Florian Mickler <florian@mickler.org>
CC: mchehab@infradead.org, oliver@neukum.org, jwjstone@fastmail.fm,
	linux-kernel@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 06/16] [media] ce6230: get rid of on-stack dma buffer
References: <20110315093632.5fc9fb77@schatten.dmk.lab> <1300178655-24832-1-git-send-email-florian@mickler.org> <1300178655-24832-6-git-send-email-florian@mickler.org>
In-Reply-To: <1300178655-24832-6-git-send-email-florian@mickler.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 03/15/2011 10:43 AM, Florian Mickler wrote:
> usb_control_msg initiates (and waits for completion of) a dma transfer using
> the supplied buffer. That buffer thus has to be seperately allocated on
> the heap.
>
> In lib/dma_debug.c the function check_for_stack even warns about it:
> 	WARNING: at lib/dma-debug.c:866 check_for_stack
>
> Note: This change is tested to compile only, as I don't have the hardware.
>
> Signed-off-by: Florian Mickler<florian@mickler.org>

Acked-by: Antti Palosaari <crope@iki.fi>
Reviewed-by: Antti Palosaari <crope@iki.fi>
Tested-by: Antti Palosaari <crope@iki.fi>


t. Antti

> ---
>   drivers/media/dvb/dvb-usb/ce6230.c |   11 +++++++++--
>   1 files changed, 9 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/media/dvb/dvb-usb/ce6230.c b/drivers/media/dvb/dvb-usb/ce6230.c
> index 3df2045..6d1a304 100644
> --- a/drivers/media/dvb/dvb-usb/ce6230.c
> +++ b/drivers/media/dvb/dvb-usb/ce6230.c
> @@ -39,7 +39,7 @@ static int ce6230_rw_udev(struct usb_device *udev, struct req_t *req)
>   	u8 requesttype;
>   	u16 value;
>   	u16 index;
> -	u8 buf[req->data_len];
> +	u8 *buf;
>
>   	request = req->cmd;
>   	value = req->value;
> @@ -62,6 +62,12 @@ static int ce6230_rw_udev(struct usb_device *udev, struct req_t *req)
>   		goto error;
>   	}
>
> +	buf = kmalloc(req->data_len, GFP_KERNEL);
> +	if (!buf) {
> +		ret = -ENOMEM;
> +		goto error;
> +	}
> +
>   	if (requesttype == (USB_TYPE_VENDOR | USB_DIR_OUT)) {
>   		/* write */
>   		memcpy(buf, req->data, req->data_len);
> @@ -74,7 +80,7 @@ static int ce6230_rw_udev(struct usb_device *udev, struct req_t *req)
>   	msleep(1); /* avoid I2C errors */
>
>   	ret = usb_control_msg(udev, pipe, request, requesttype, value, index,
> -				buf, sizeof(buf), CE6230_USB_TIMEOUT);
> +				buf, req->data_len, CE6230_USB_TIMEOUT);
>
>   	ce6230_debug_dump(request, requesttype, value, index, buf,
>   		req->data_len, deb_xfer);
> @@ -88,6 +94,7 @@ static int ce6230_rw_udev(struct usb_device *udev, struct req_t *req)
>   	if (!ret&&  requesttype == (USB_TYPE_VENDOR | USB_DIR_IN))
>   		memcpy(req->data, buf, req->data_len);
>
> +	kfree(buf);
>   error:
>   	return ret;
>   }


-- 
http://palosaari.fi/
