Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:53429 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751114AbdEAQck (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 1 May 2017 12:32:40 -0400
Date: Mon, 1 May 2017 17:32:38 +0100
From: Sean Young <sean@mess.org>
To: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org, mchehab@s-opensource.com
Subject: Re: [PATCH] ir-lirc-codec: let lirc_dev handle the lirc_buffer (v3)
Message-ID: <20170501163238.GA14550@gofer.mess.org>
References: <149364555461.1324.6080400542211564159.stgit@zeus.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <149364555461.1324.6080400542211564159.stgit@zeus.hardeman.nu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, May 01, 2017 at 03:32:34PM +0200, David Härdeman wrote:
> ir_lirc_register() currently creates its own lirc_buffer before
> passing the lirc_driver to lirc_register_driver().
> 
> When a module is later unloaded, ir_lirc_unregister() gets called
> which performs a call to lirc_unregister_driver() and then free():s
> the lirc_buffer.
> 
> The problem is that:
> 
> a) there can still be a userspace app holding an open lirc fd
>    when lirc_unregister_driver() returns; and
> 
> b) the lirc_buffer contains "wait_queue_head_t wait_poll" which
>    is potentially used as long as any userspace app is still around.
> 
> The result is an oops which can be triggered quite easily by a
> userspace app monitoring its lirc fd using epoll() and not closing
> the fd promptly on device removal.
> 
> The minimalistic fix is to let lirc_dev create the lirc_buffer since
> lirc_dev will then also free the buffer once it believes it is safe to
> do so.
> 
> Version 2: make sure that the allocated buffer is communicated back to
> ir-lirc-codec so that ir_lirc_decode() can use it.
> 
> Version 3: set chunk_size and buffer_size in ir-lirc-codec.

Great, this version works fine.

> CC: stable@vger.kernel.org

I don't think this change make sense before
"74c839b [media] lirc: use refcounting for lirc devices", so I've removed
the stable cc.

Thanks,
Sean

> Signed-off-by: David Härdeman <david@hardeman.nu>
> ---
>  drivers/media/rc/ir-lirc-codec.c |   25 +++++++------------------
>  drivers/media/rc/lirc_dev.c      |   13 ++++++++++++-
>  2 files changed, 19 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
> index de85f1d7ce43..8f0669c9894c 100644
> --- a/drivers/media/rc/ir-lirc-codec.c
> +++ b/drivers/media/rc/ir-lirc-codec.c
> @@ -354,7 +354,6 @@ static const struct file_operations lirc_fops = {
>  static int ir_lirc_register(struct rc_dev *dev)
>  {
>  	struct lirc_driver *drv;
> -	struct lirc_buffer *rbuf;
>  	int rc = -ENOMEM;
>  	unsigned long features = 0;
>  
> @@ -362,19 +361,12 @@ static int ir_lirc_register(struct rc_dev *dev)
>  	if (!drv)
>  		return rc;
>  
> -	rbuf = kzalloc(sizeof(struct lirc_buffer), GFP_KERNEL);
> -	if (!rbuf)
> -		goto rbuf_alloc_failed;
> -
> -	rc = lirc_buffer_init(rbuf, sizeof(int), LIRCBUF_SIZE);
> -	if (rc)
> -		goto rbuf_init_failed;
> -
>  	if (dev->driver_type != RC_DRIVER_IR_RAW_TX) {
>  		features |= LIRC_CAN_REC_MODE2;
>  		if (dev->rx_resolution)
>  			features |= LIRC_CAN_GET_REC_RESOLUTION;
>  	}
> +
>  	if (dev->tx_ir) {
>  		features |= LIRC_CAN_SEND_PULSE;
>  		if (dev->s_tx_mask)
> @@ -403,10 +395,12 @@ static int ir_lirc_register(struct rc_dev *dev)
>  	drv->minor = -1;
>  	drv->features = features;
>  	drv->data = &dev->raw->lirc;
> -	drv->rbuf = rbuf;
> +	drv->rbuf = NULL;
>  	drv->set_use_inc = &ir_lirc_open;
>  	drv->set_use_dec = &ir_lirc_close;
>  	drv->code_length = sizeof(struct ir_raw_event) * 8;
> +	drv->chunk_size = sizeof(int);
> +	drv->buffer_size = LIRCBUF_SIZE;
>  	drv->fops = &lirc_fops;
>  	drv->dev = &dev->dev;
>  	drv->rdev = dev;
> @@ -415,19 +409,15 @@ static int ir_lirc_register(struct rc_dev *dev)
>  	drv->minor = lirc_register_driver(drv);
>  	if (drv->minor < 0) {
>  		rc = -ENODEV;
> -		goto lirc_register_failed;
> +		goto out;
>  	}
>  
>  	dev->raw->lirc.drv = drv;
>  	dev->raw->lirc.dev = dev;
>  	return 0;
>  
> -lirc_register_failed:
> -rbuf_init_failed:
> -	kfree(rbuf);
> -rbuf_alloc_failed:
> +out:
>  	kfree(drv);
> -
>  	return rc;
>  }
>  
> @@ -436,9 +426,8 @@ static int ir_lirc_unregister(struct rc_dev *dev)
>  	struct lirc_codec *lirc = &dev->raw->lirc;
>  
>  	lirc_unregister_driver(lirc->drv->minor);
> -	lirc_buffer_free(lirc->drv->rbuf);
> -	kfree(lirc->drv->rbuf);
>  	kfree(lirc->drv);
> +	lirc->drv = NULL;
>  
>  	return 0;
>  }
> diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
> index 8d60c9f00df9..42704552b005 100644
> --- a/drivers/media/rc/lirc_dev.c
> +++ b/drivers/media/rc/lirc_dev.c
> @@ -52,6 +52,7 @@ struct irctl {
>  
>  	struct mutex irctl_lock;
>  	struct lirc_buffer *buf;
> +	bool buf_internal;
>  	unsigned int chunk_size;
>  
>  	struct device dev;
> @@ -83,7 +84,7 @@ static void lirc_release(struct device *ld)
>  
>  	put_device(ir->dev.parent);
>  
> -	if (ir->buf != ir->d.rbuf) {
> +	if (ir->buf_internal) {
>  		lirc_buffer_free(ir->buf);
>  		kfree(ir->buf);
>  	}
> @@ -198,6 +199,7 @@ static int lirc_allocate_buffer(struct irctl *ir)
>  
>  	if (d->rbuf) {
>  		ir->buf = d->rbuf;
> +		ir->buf_internal = false;
>  	} else {
>  		ir->buf = kmalloc(sizeof(struct lirc_buffer), GFP_KERNEL);
>  		if (!ir->buf) {
> @@ -208,8 +210,11 @@ static int lirc_allocate_buffer(struct irctl *ir)
>  		err = lirc_buffer_init(ir->buf, chunk_size, buffer_size);
>  		if (err) {
>  			kfree(ir->buf);
> +			ir->buf = NULL;
>  			goto out;
>  		}
> +
> +		ir->buf_internal = true;
>  	}
>  	ir->chunk_size = ir->buf->chunk_size;
>  
> @@ -362,6 +367,12 @@ int lirc_register_driver(struct lirc_driver *d)
>  		err = lirc_allocate_buffer(irctls[minor]);
>  		if (err)
>  			lirc_unregister_driver(minor);
> +		else
> +			/*
> +			 * This is kind of a hack but ir-lirc-codec needs
> +			 * access to the buffer that lirc_dev allocated.
> +			 */
> +			d->rbuf = irctls[minor]->buf;
>  	}
>  
>  	return err ? err : minor;
