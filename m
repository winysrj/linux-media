Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:3068 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755200AbaEIKek (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 May 2014 06:34:40 -0400
Message-ID: <536CAF29.4030200@xs4all.nl>
Date: Fri, 09 May 2014 12:34:17 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
	linux-media@vger.kernel.org
CC: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v2] media: stk1160: Avoid stack-allocated buffer for control
 URBs
References: <1397737700-1081-1-git-send-email-ezequiel.garcia@free-electrons.com>
In-Reply-To: <1397737700-1081-1-git-send-email-ezequiel.garcia@free-electrons.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ezequiel,

On 04/17/2014 02:28 PM, Ezequiel Garcia wrote:
> Currently stk1160_read_reg() uses a stack-allocated char to get the
> read control value. This is wrong because usb_control_msg() requires
> a kmalloc-ed buffer.
> 
> This commit fixes such issue by kmalloc'ating a 1-byte buffer to receive
> the read value.
> 
> While here, let's remove the urb_buf array which was meant for a similar
> purpose, but never really used.

Rather than allocating and freeing a buffer for every read_reg I would allocate
this buffer in the probe function.

That way this allocation is done only once.

Regards,

	Hans

> 
> Cc: Alan Stern <stern@rowland.harvard.edu>
> Reported-by: Sander Eikelenboom <linux@eikelenboom.it>
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
> 

