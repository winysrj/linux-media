Return-path: <linux-media-owner@vger.kernel.org>
Received: from top.free-electrons.com ([176.31.233.9]:50237 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750980AbaDYVwe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Apr 2014 17:52:34 -0400
Date: Fri, 25 Apr 2014 18:51:53 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Sander Eikelenboom <linux@eikelenboom.it>,
	linux-media@vger.kernel.org
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v2] media: stk1160: Avoid stack-allocated buffer for
 control URBs
Message-ID: <20140425215153.GA1695@arch.cereza>
References: <1397737700-1081-1-git-send-email-ezequiel.garcia@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1397737700-1081-1-git-send-email-ezequiel.garcia@free-electrons.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Apr 17, Ezequiel Garcia wrote:
> Currently stk1160_read_reg() uses a stack-allocated char to get the
> read control value. This is wrong because usb_control_msg() requires
> a kmalloc-ed buffer.
> 
> This commit fixes such issue by kmalloc'ating a 1-byte buffer to receive
> the read value.
> 
> While here, let's remove the urb_buf array which was meant for a similar
> purpose, but never really used.
> 
> Cc: Alan Stern <stern@rowland.harvard.edu>
> Reported-by: Sander Eikelenboom <linux@eikelenboom.it>

Ouch, I forgot to Cc Sander!

Sander, Here's the patch:

https://patchwork.linuxtv.org/patch/23660/

Maybe you can give it a ride and confirm it fixes the warning over there?

Also, have you observed any serious issues caused by this or just the
DMA API debug warning?

> Signed-off-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
> ---
>  drivers/media/usb/stk1160/stk1160-core.c | 10 +++++++++-
>  drivers/media/usb/stk1160/stk1160.h      |  1 -
>  2 files changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/usb/stk1160/stk1160-core.c b/drivers/media/usb/stk1160/stk1160-core.c
> index 34a26e0..03504dc 100644
> --- a/drivers/media/usb/stk1160/stk1160-core.c
> +++ b/drivers/media/usb/stk1160/stk1160-core.c
> @@ -67,17 +67,25 @@ int stk1160_read_reg(struct stk1160 *dev, u16 reg, u8 *value)
>  {
>  	int ret;
>  	int pipe = usb_rcvctrlpipe(dev->udev, 0);
> +	u8 *buf;
>  
>  	*value = 0;
> +
> +	buf = kmalloc(sizeof(u8), GFP_KERNEL);
> +	if (!buf)
> +		return -ENOMEM;
>  	ret = usb_control_msg(dev->udev, pipe, 0x00,
>  			USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
> -			0x00, reg, value, sizeof(u8), HZ);
> +			0x00, reg, buf, sizeof(u8), HZ);
>  	if (ret < 0) {
>  		stk1160_err("read failed on reg 0x%x (%d)\n",
>  			reg, ret);
> +		kfree(buf);
>  		return ret;
>  	}
>  
> +	*value = *buf;
> +	kfree(buf);
>  	return 0;
>  }
>  
> diff --git a/drivers/media/usb/stk1160/stk1160.h b/drivers/media/usb/stk1160/stk1160.h
> index 05b05b1..abdea48 100644
> --- a/drivers/media/usb/stk1160/stk1160.h
> +++ b/drivers/media/usb/stk1160/stk1160.h
> @@ -143,7 +143,6 @@ struct stk1160 {
>  	int num_alt;
>  
>  	struct stk1160_isoc_ctl isoc_ctl;
> -	char urb_buf[255];	 /* urb control msg buffer */
>  
>  	/* frame properties */
>  	int width;		  /* current frame width */
> -- 
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
