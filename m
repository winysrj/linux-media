Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:34194 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754949Ab2FMX3W (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jun 2012 19:29:22 -0400
Message-ID: <4FD9224F.7050809@iki.fi>
Date: Thu, 14 Jun 2012 02:29:19 +0300
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Malcolm Priestley <tvboxspy@gmail.com>
CC: linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/2] [BUG] dvb_usb_v2:  return the download ret in dvb_usb_download_firmware
References: <1339626272.2421.74.camel@Route3278>
In-Reply-To: <1339626272.2421.74.camel@Route3278>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Malcolm,
I was really surprised someone has had interest to test that stuff at 
that phase as I did not even advertised it yet :) It is likely happen 
next Monday or so as there is some issues I would like to check / solve.


On 06/14/2012 01:24 AM, Malcolm Priestley wrote:
> Hi antti
>
> There some issues with dvb_usb_v2 with the lmedm04 driver.
>
> The first being this patch, no return value from dvb_usb_download_firmware
> causes system wide dead lock with COLD disconnect as system attempts to continue
> to warm state.

Hmm, I did not understand what you mean. What I looked lmedm04 driver I 
think it uses single USB ID (no cold + warm IDs). So it downloads 
firmware and then reconnects itself from the USB bus?
For that scenario you should "return RECONNECTS_USB;" from the driver 
.download_firmware().

I tested it using one non-public Cypress FX2 device - it was changing 
USB ID after the FX download, but from the driver perspective it does 
not matter. It is always new device if it reconnects USB.

PS. as I looked that driver I saw many different firmwares. That is now 
supported and you should use .get_firmware_name() (maybe you already did 
it).

> The second is to do with d->props.bInterfaceNumber in patch 2.

See the other mail.

> In get_usb_stream_config there no handing of the struct dvb_frontend.
> ...
> int (*get_usb_stream_config) (struct dvb_frontend *,
> 			struct usb_data_stream_properties *);
>
> ...
> I wonder if it would be better to use adapter instead?

That was something I think many times how to implement. The motivation 
of whole callback is mainly from the MFE. You have one stream (per 
adapter) which is needed to configure dynamically per use case. I left 
still old static stream configuration as it was, but moved it to the 
adapter property. So if you need only one stream configuration use old 
style as it looks simpler.

But back to actual question. It is simple - we need to know used 
frontend that we could return correct settings. Imagine MFE device, FE0 
uses bulk stream and FE1 uses isochronous. Knowing frontend makes it 
possible to reconfigure.

There is one "hack" I did intentionally. At the attach() it is called 
frontend == NULL to signal we need to get maximum buffer size in order 
to alloc big enough USB DMA buffers. Maybe I will add macro for that, 
like BUFFERS(count, size) to clear. Or even add another callback.

>
> I also have a draft patch to use delayed work.
>
> Regards
>
>
> Malcolm
>
>
> Signed-off-by: Malcolm Priestley<tvboxspy@gmail.com>
> ---
>   drivers/media/dvb/dvb-usb/dvb_usb_init.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/media/dvb/dvb-usb/dvb_usb_init.c b/drivers/media/dvb/dvb-usb/dvb_usb_init.c
> index 60aa944..c16a28a 100644
> --- a/drivers/media/dvb/dvb-usb/dvb_usb_init.c
> +++ b/drivers/media/dvb/dvb-usb/dvb_usb_init.c
> @@ -61,7 +61,7 @@ static int dvb_usb_download_firmware(struct dvb_usb_device *d)
>   	if (ret<  0)
>   		goto err;
>
> -	return 0;
> +	return ret;
>   err:
>   	pr_debug("%s: failed=%d\n", __func__, ret);
>   	return ret;

Thank you for the comments and testing, I am happy to answer other 
questions too.

regards
Antti
-- 
http://palosaari.fi/
