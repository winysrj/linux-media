Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:42625 "EHLO gofer.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752246AbcGBRTW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 2 Jul 2016 13:19:22 -0400
Date: Sat, 2 Jul 2016 18:10:47 +0100
From: Sean Young <sean@mess.org>
To: Andi Shyti <andi.shyti@samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Joe Perches <joe@perches.com>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, Andi Shyti <andi@etezian.org>
Subject: Re: [PATCH v2 02/15] [media] lirc_dev: allow bufferless driver
 registration
Message-ID: <20160702171047.GA13539@gofer.mess.org>
References: <1467360098-12539-1-git-send-email-andi.shyti@samsung.com>
 <1467360098-12539-3-git-send-email-andi.shyti@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1467360098-12539-3-git-send-email-andi.shyti@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Jul 01, 2016 at 05:01:25PM +0900, Andi Shyti wrote:
> Some drivers don't necessarily need to have a FIFO managed buffer
> for their transfers. Drivers now should call
> lirc_register_bufferless_driver in order to handle the buffer
> themselves.
> 
> The function works exaclty like lirc_register_driver except of
> the buffer allocation.

Indeed transmit-only devices don't need an input buffer, which is
just a waste of memory. However can't lirc_register_driver() figure
out from the features if the driver is capable of receiving, i.e.

int lirc_register_driver(struct lirc_driver *d)
{
	int err, minor;

	minor = lirc_allocate_driver(d);
	if (minor < 0)
		return minor;

	if (d->features & LIRC_CAN_REC_MODE2) {
		err = lirc_allocate_buffer(irctls[minor]);
		if (err)
			lirc_unregister_driver(minor);
	}

	return err ? err : minor;
}


Sean

> 
> Signed-off-by: Andi Shyti <andi.shyti@samsung.com>
> ---
>  drivers/media/rc/lirc_dev.c | 44 ++++++++++++++++++++++++++++++++++----------
>  include/media/lirc_dev.h    | 12 ++++++++++++
>  2 files changed, 46 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
> index 5716978..fa562a3 100644
> --- a/drivers/media/rc/lirc_dev.c
> +++ b/drivers/media/rc/lirc_dev.c
> @@ -205,12 +205,14 @@ err_out:
>  
>  static int lirc_allocate_buffer(struct irctl *ir)
>  {
> -	int err;
> +	int err = 0;
>  	int bytes_in_key;
>  	unsigned int chunk_size;
>  	unsigned int buffer_size;
>  	struct lirc_driver *d = &ir->d;
>  
> +	mutex_lock(&lirc_dev_lock);
> +
>  	bytes_in_key = BITS_TO_LONGS(d->code_length) +
>  						(d->code_length % 8 ? 1 : 0);
>  	buffer_size = d->buffer_size ? d->buffer_size : BUFLEN / bytes_in_key;
> @@ -220,21 +222,26 @@ static int lirc_allocate_buffer(struct irctl *ir)
>  		ir->buf = d->rbuf;
>  	} else {
>  		ir->buf = kmalloc(sizeof(struct lirc_buffer), GFP_KERNEL);
> -		if (!ir->buf)
> -			return -ENOMEM;
> +		if (!ir->buf) {
> +			err = -ENOMEM;
> +			goto out;
> +		}
>  
>  		err = lirc_buffer_init(ir->buf, chunk_size, buffer_size);
>  		if (err) {
>  			kfree(ir->buf);
> -			return err;
> +			goto out;
>  		}
>  	}
>  	ir->chunk_size = ir->buf->chunk_size;
>  
> -	return 0;
> +out:
> +	mutex_unlock(&lirc_dev_lock);
> +
> +	return err;
>  }
>  
> -int lirc_register_driver(struct lirc_driver *d)
> +static int lirc_allocate_driver(struct lirc_driver *d)
>  {
>  	struct irctl *ir;
>  	int minor;
> @@ -342,10 +349,6 @@ int lirc_register_driver(struct lirc_driver *d)
>  	/* some safety check 8-) */
>  	d->name[sizeof(d->name)-1] = '\0';
>  
> -	err = lirc_allocate_buffer(ir);
> -	if (err)
> -		goto out_lock;
> -
>  	if (d->features == 0)
>  		d->features = LIRC_CAN_REC_LIRCCODE;
>  
> @@ -385,8 +388,29 @@ out_lock:
>  out:
>  	return err;
>  }
> +
> +int lirc_register_driver(struct lirc_driver *d)
> +{
> +	int err, minor;
> +
> +	minor = lirc_allocate_driver(d);
> +	if (minor < 0)
> +		return minor;
> +
> +	err = lirc_allocate_buffer(irctls[minor]);
> +	if (err)
> +		lirc_unregister_driver(minor);
> +
> +	return err ? err : minor;
> +}
>  EXPORT_SYMBOL(lirc_register_driver);
>  
> +int lirc_register_bufferless_driver(struct lirc_driver *d)
> +{
> +	return lirc_allocate_driver(d);
> +}
> +EXPORT_SYMBOL(lirc_register_bufferless_driver);
> +
>  int lirc_unregister_driver(int minor)
>  {
>  	struct irctl *ir;
> diff --git a/include/media/lirc_dev.h b/include/media/lirc_dev.h
> index 0ab59a5..8bed57a 100644
> --- a/include/media/lirc_dev.h
> +++ b/include/media/lirc_dev.h
> @@ -214,6 +214,18 @@ struct lirc_driver {
>   */
>  extern int lirc_register_driver(struct lirc_driver *d);
>  
> +/* int lirc_register_bufferless_driver - allocates a lirc bufferless driver
> + * @d: reference to the lirc_driver to initialize
> + *
> + * The difference between lirc_register_driver and
> + * lirc_register_bufferless_driver is that the latter doesn't allocate any
> + * buffer, which means that the driver using the lirc_driver should take care of
> + * it by itself.
> + *
> + * returns 0 on success or a the negative errno number in case of failure.
> + */
> +extern int lirc_register_bufferless_driver(struct lirc_driver *d);
> +
>  /* returns negative value on error or 0 if success
>  */
>  extern int lirc_unregister_driver(int minor);
> -- 
> 2.8.1
