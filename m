Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28616 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759875Ab2HIXsX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Aug 2012 19:48:23 -0400
Message-ID: <50244C42.8070303@redhat.com>
Date: Thu, 09 Aug 2012 20:48:18 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Devin Heitmueller <dheitmueller@kernellabs.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 17/24] au0828: fix possible race condition in usage of
 dev->ctrlmsg
References: <1344307634-11673-1-git-send-email-dheitmueller@kernellabs.com> <1344307634-11673-18-git-send-email-dheitmueller@kernellabs.com>
In-Reply-To: <1344307634-11673-18-git-send-email-dheitmueller@kernellabs.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 06-08-2012 23:47, Devin Heitmueller escreveu:
> The register read function is referencing the dev->ctrlmsg structure outside
> of the dev->mutex lock, which can cause corruption of the value if multiple
> callers are invoking au0828_readreg() simultaneously.
> 
> Use a stack variable to hold the result, and copy the buffer returned by
> usb_control_msg() to that variable.

It is NOT OK to use stack to send and/or receive control messages. The USB core
uses DMA transfers for sending/receiving data via USB; the memory used by stack
is not warranted to be at the DMA-able area. This problem is more frequent on
ARM-based machines, but even on Intel, the urb_control_msg() may fail.

> 
> In reality, the whole recv_control_msg() function can probably be collapsed
> into au0288_readreg() since it is the only caller.
> 
> Also get rid of cmd_msg_dump() since the only case in which the function is
> ever called only is ever passed a single byte for the response (and it is
> already logged).
> 
> Signed-off-by: Devin Heitmueller <dheitmueller@kernellabs.com>
> ---
>   drivers/media/video/au0828/au0828-core.c |   40 +++++++++---------------------
>   1 files changed, 12 insertions(+), 28 deletions(-)
> 
> diff --git a/drivers/media/video/au0828/au0828-core.c b/drivers/media/video/au0828/au0828-core.c
> index 65914bc..745a80a 100644
> --- a/drivers/media/video/au0828/au0828-core.c
> +++ b/drivers/media/video/au0828/au0828-core.c
> @@ -56,9 +56,12 @@ static int recv_control_msg(struct au0828_dev *dev, u16 request, u32 value,
>   
>   u32 au0828_readreg(struct au0828_dev *dev, u16 reg)
>   {
> -	recv_control_msg(dev, CMD_REQUEST_IN, 0, reg, dev->ctrlmsg, 1);
> -	dprintk(8, "%s(0x%04x) = 0x%02x\n", __func__, reg, dev->ctrlmsg[0]);
> -	return dev->ctrlmsg[0];
> +	u8 result = 0;
> +
> +	recv_control_msg(dev, CMD_REQUEST_IN, 0, reg, &result, 1);

As explained above, this won't work, as result is at stack, not warranted to be at the
DMA-able area. So, either you could lock this function, or you'll need to allocate
it with kmalloc() and free it after using the data.

> +	dprintk(8, "%s(0x%04x) = 0x%02x\n", __func__, reg, result);
> +
> +	return result;
>   }
>   
>   u32 au0828_writereg(struct au0828_dev *dev, u16 reg, u32 val)
> @@ -67,24 +70,6 @@ u32 au0828_writereg(struct au0828_dev *dev, u16 reg, u32 val)
>   	return send_control_msg(dev, CMD_REQUEST_OUT, val, reg);
>   }
>   
> -static void cmd_msg_dump(struct au0828_dev *dev)
> -{
> -	int i;
> -
> -	for (i = 0; i < sizeof(dev->ctrlmsg); i += 16)
> -		dprintk(2, "%s() %02x %02x %02x %02x %02x %02x %02x %02x "
> -				"%02x %02x %02x %02x %02x %02x %02x %02x\n",
> -			__func__,
> -			dev->ctrlmsg[i+0], dev->ctrlmsg[i+1],
> -			dev->ctrlmsg[i+2], dev->ctrlmsg[i+3],
> -			dev->ctrlmsg[i+4], dev->ctrlmsg[i+5],
> -			dev->ctrlmsg[i+6], dev->ctrlmsg[i+7],
> -			dev->ctrlmsg[i+8], dev->ctrlmsg[i+9],
> -			dev->ctrlmsg[i+10], dev->ctrlmsg[i+11],
> -			dev->ctrlmsg[i+12], dev->ctrlmsg[i+13],
> -			dev->ctrlmsg[i+14], dev->ctrlmsg[i+15]);
> -}
> -
>   static int send_control_msg(struct au0828_dev *dev, u16 request, u32 value,
>   	u16 index)
>   {
> @@ -118,24 +103,23 @@ static int recv_control_msg(struct au0828_dev *dev, u16 request, u32 value,
>   	int status = -ENODEV;
>   	mutex_lock(&dev->mutex);
>   	if (dev->usbdev) {
> -
> -		memset(dev->ctrlmsg, 0, sizeof(dev->ctrlmsg));
> -
> -		/* cp must be memory that has been allocated by kmalloc */
>   		status = usb_control_msg(dev->usbdev,
>   				usb_rcvctrlpipe(dev->usbdev, 0),
>   				request,
>   				USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
>   				value, index,
> -				cp, size, 1000);
> +				dev->ctrlmsg, size, 1000);
>   
>   		status = min(status, 0);
>   
>   		if (status < 0) {
>   			printk(KERN_ERR "%s() Failed receiving control message, error %d.\n",
>   				__func__, status);
> -		} else
> -			cmd_msg_dump(dev);
> +		}
> +
> +		/* the host controller requires heap allocated memory, which
> +		   is why we didn't just pass "cp" into usb_control_msg */
> +		memcpy(cp, dev->ctrlmsg, size);
>   	}
>   	mutex_unlock(&dev->mutex);
>   	return status;
> 

Regards,
Mauro
