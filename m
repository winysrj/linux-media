Return-path: <linux-media-owner@vger.kernel.org>
Received: from vserver.eikelenboom.it ([84.200.39.61]:38913 "EHLO
	smtp.eikelenboom.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754072AbaDNQzR (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Apr 2014 12:55:17 -0400
Date: Mon, 14 Apr 2014 18:55:13 +0200
From: Sander Eikelenboom <linux@eikelenboom.it>
Message-ID: <180763328.20140414185513@eikelenboom.it>
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
CC: linux-media@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] media: stk1160: Avoid stack-allocated buffer for control URBs
In-Reply-To: <1397493665-912-1-git-send-email-ezequiel.garcia@free-electrons.com>
References: <1397493665-912-1-git-send-email-ezequiel.garcia@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Monday, April 14, 2014, 6:41:05 PM, you wrote:

> Currently stk1160_read_reg() uses a stack-allocated char to get the
> read control value. This is wrong because usb_control_msg() requires
> a kmalloc-ed buffer, and a DMA-API warning is produced:

> WARNING: CPU: 0 PID: 1376 at lib/dma-debug.c:1153 check_for_stack+0xa0/0x100()
> ehci-pci 0000:00:0a.0: DMA-API: device driver maps memory fromstack [addr=ffff88003d0b56bf]

> This commit fixes such issue by using a 'usb_ctrl_read' field embedded
> in the device's struct to pass the value. In addition, we introduce a
> mutex to protect the value.

> While here, let's remove the urb_buf array which was meant for a similar
> purpose, but never really used.

> Reported-by: Sander Eikelenboom <linux@eikelenboom.it>
> Signed-off-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
> ---
> Sander, Hans:
> Does this cause any regressions, other than the DMA-API warning?
> In that case, we can consider this as suitable for -stable.

Thanks !

Will test and report back later.

--
Sander

>  drivers/media/usb/stk1160/stk1160-core.c | 8 +++++++-
>  drivers/media/usb/stk1160/stk1160.h      | 3 ++-
>  2 files changed, 9 insertions(+), 2 deletions(-)

> diff --git a/drivers/media/usb/stk1160/stk1160-core.c b/drivers/media/usb/stk1160/stk1160-core.c
> index 34a26e0..cce91e7 100644
> --- a/drivers/media/usb/stk1160/stk1160-core.c
> +++ b/drivers/media/usb/stk1160/stk1160-core.c
> @@ -69,15 +69,20 @@ int stk1160_read_reg(struct stk1160 *dev, u16 reg, u8 *value)
>         int pipe = usb_rcvctrlpipe(dev->udev, 0);
>  
>         *value = 0;
> +
> +       mutex_lock(&dev->urb_ctrl_lock);
>         ret = usb_control_msg(dev->udev, pipe, 0x00,
>                         USB_DIR_IN | USB_TYPE_VENDOR | USB_RECIP_DEVICE,
> -                       0x00, reg, value, sizeof(u8), HZ);
> +                       0x00, reg, &dev->urb_ctrl_read, sizeof(u8), HZ);
>         if (ret < 0) {
>                 stk1160_err("read failed on reg 0x%x (%d)\n",
>                         reg, ret);
> +               mutex_unlock(&dev->urb_ctrl_lock);
>                 return ret;
>         }
>  
> +       *value = dev->urb_ctrl_read;
> +       mutex_unlock(&dev->urb_ctrl_lock);
>         return 0;
>  }
>  
> @@ -322,6 +327,7 @@ static int stk1160_probe(struct usb_interface *interface,
>          * because we register the device node as the *last* thing.
>          */
>         spin_lock_init(&dev->buf_lock);
> +       mutex_init(&dev->urb_ctrl_lock);
>         mutex_init(&dev->v4l_lock);
>         mutex_init(&dev->vb_queue_lock);
>  
> diff --git a/drivers/media/usb/stk1160/stk1160.h b/drivers/media/usb/stk1160/stk1160.h
> index 05b05b1..8886be4 100644
> --- a/drivers/media/usb/stk1160/stk1160.h
> +++ b/drivers/media/usb/stk1160/stk1160.h
> @@ -143,7 +143,7 @@ struct stk1160 {
>         int num_alt;
>  
>         struct stk1160_isoc_ctl isoc_ctl;
> -       char urb_buf[255];       /* urb control msg buffer */
> +       char urb_ctrl_read;
>  
>         /* frame properties */
>         int width;                /* current frame width */
> @@ -159,6 +159,7 @@ struct stk1160 {
>         struct i2c_adapter i2c_adap;
>         struct i2c_client i2c_client;
>  
> +       struct mutex urb_ctrl_lock;     /* protects urb_ctrl_read */
>         struct mutex v4l_lock;
>         struct mutex vb_queue_lock;
>         spinlock_t buf_lock;

