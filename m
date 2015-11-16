Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51569 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbbKPPFL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 16 Nov 2015 10:05:11 -0500
Date: Mon, 16 Nov 2015 18:04:35 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: Jarod Wilson <jarod@wilsonet.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	devel@driverdev.osuosl.org, ldv-project@linuxtesting.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] lirc_imon: do not leave imon_probe() with mutex
 held
Message-ID: <20151116150434.GJ18797@mwanda>
References: <1447525076-12068-1-git-send-email-khoroshilov@ispras.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1447525076-12068-1-git-send-email-khoroshilov@ispras.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Nov 14, 2015 at 09:17:56PM +0300, Alexey Khoroshilov wrote:
> Commit af8a819a2513 ("[media] lirc_imon: simplify error handling code")
> lost mutex_unlock(&context->ctx_lock), so imon_probe() exits with
> the context->ctx_lock mutex acquired.
> 
> The patch adds mutex_unlock(&context->ctx_lock) back.
> 
> Found by Linux Driver Verification project (linuxtesting.org).
> 
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
> Fixes: af8a819a2513 ("[media] lirc_imon: simplify error handling code")

Hm...  This patch is from June and it totally breaks the driver.  It's
dissapointing that no one reported this bug.

> ---
>  drivers/staging/media/lirc/lirc_imon.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/staging/media/lirc/lirc_imon.c b/drivers/staging/media/lirc/lirc_imon.c
> index 534b8103ae80..ff1926ca1f96 100644
> --- a/drivers/staging/media/lirc/lirc_imon.c
> +++ b/drivers/staging/media/lirc/lirc_imon.c
> @@ -885,12 +885,14 @@ static int imon_probe(struct usb_interface *interface,
>  		vendor, product, ifnum, usbdev->bus->busnum, usbdev->devnum);
>  
>  	/* Everything went fine. Just unlock and return retval (with is 0) */
> +	mutex_unlock(&context->ctx_lock);
>  	goto driver_unlock;
>  
>  unregister_lirc:
>  	lirc_unregister_driver(driver->minor);
>  
>  free_tx_urb:
> +	mutex_unlock(&context->ctx_lock);
>  	usb_free_urb(tx_urb);

Now the label name doesn't make sense.  Also this unlock isn't needed
because we are just going to free context anyway.

regards,
dan carpenter

