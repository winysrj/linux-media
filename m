Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w2.samsung.com ([211.189.100.12]:52335 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548AbaGYXMV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Jul 2014 19:12:21 -0400
Received: from uscpsbgm1.samsung.com
 (u114.gpu85.samsung.co.kr [203.254.195.114]) by mailout2.w2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N9A002NCJ4K3UA0@mailout2.w2.samsung.com> for
 linux-media@vger.kernel.org; Fri, 25 Jul 2014 19:12:20 -0400 (EDT)
Date: Fri, 25 Jul 2014 20:12:15 -0300
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: David =?UTF-8?B?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 41/49] rc-core: rename mutex
Message-id: <20140725201215.0fde3b6a.m.chehab@samsung.com>
In-reply-to: <20140403233443.27099.29952.stgit@zeus.muc.hardeman.nu>
References: <20140403232420.27099.94872.stgit@zeus.muc.hardeman.nu>
 <20140403233443.27099.29952.stgit@zeus.muc.hardeman.nu>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 04 Apr 2014 01:34:43 +0200
David Härdeman <david@hardeman.nu> escreveu:

> Having a mutex named "lock" is a bit misleading.

Please rebase.

> 
> Signed-off-by: David Härdeman <david@hardeman.nu>
> ---
>  drivers/media/rc/img-ir/img-ir-hw.c |    4 ++-
>  drivers/media/rc/rc-main.c          |   42 ++++++++++++++++++-----------------
>  include/media/rc-core.h             |    5 ++--
>  3 files changed, 25 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/media/rc/img-ir/img-ir-hw.c b/drivers/media/rc/img-ir/img-ir-hw.c
> index 5bc7903..a9abbb4 100644
> --- a/drivers/media/rc/img-ir/img-ir-hw.c
> +++ b/drivers/media/rc/img-ir/img-ir-hw.c
> @@ -666,11 +666,11 @@ static void img_ir_set_protocol(struct img_ir_priv *priv, u64 proto)
>  {
>  	struct rc_dev *rdev = priv->hw.rdev;
>  
> -	mutex_lock(&rdev->lock);
> +	mutex_lock(&rdev->mutex);
>  	rdev->enabled_protocols = proto;
>  	rdev->allowed_wakeup_protocols = proto;
>  	rdev->enabled_wakeup_protocols = proto;
> -	mutex_unlock(&rdev->lock);
> +	mutex_unlock(&rdev->mutex);
>  }
>  
>  /* Set up IR decoders */
> diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
> index 7caca4f..bd4dfab 100644
> --- a/drivers/media/rc/rc-main.c
> +++ b/drivers/media/rc/rc-main.c
> @@ -109,7 +109,7 @@ int rc_open(struct rc_dev *dev)
>  {
>  	int err = 0;
>  
> -	mutex_lock(&dev->lock);
> +	mutex_lock(&dev->mutex);
>  
>  	if (dev->dead)
>  		err = -ENODEV;
> @@ -119,7 +119,7 @@ int rc_open(struct rc_dev *dev)
>  			dev->users--;
>  	}
>  
> -	mutex_unlock(&dev->lock);
> +	mutex_unlock(&dev->mutex);
>  
>  	return err;
>  }
> @@ -127,12 +127,12 @@ EXPORT_SYMBOL_GPL(rc_open);
>  
>  void rc_close(struct rc_dev *dev)
>  {
> -	mutex_lock(&dev->lock);
> +	mutex_lock(&dev->mutex);
>  
>  	if (!dev->dead && !--dev->users && dev->close)
>  		dev->close(dev);
>  
> -	mutex_unlock(&dev->lock);
> +	mutex_unlock(&dev->mutex);
>  }
>  EXPORT_SYMBOL_GPL(rc_close);
>  
> @@ -322,7 +322,7 @@ struct rc_filter_attribute {
>   * It returns the protocol names of supported protocols.
>   * Enabled protocols are printed in brackets.
>   *
> - * dev->lock is taken to guard against races between store_protocols and
> + * dev->mutex is taken to guard against races between store_protocols and
>   * show_protocols.
>   */
>  static ssize_t show_protocols(struct device *device,
> @@ -339,7 +339,7 @@ static ssize_t show_protocols(struct device *device,
>  		return -EINVAL;
>  
>  	rc_event(dev, RC_KEY, RC_KEY_REPEAT, 1);
> -	mutex_lock(&dev->lock);
> +	mutex_lock(&dev->mutex);
>  
>  	if (fattr->type == RC_FILTER_NORMAL) {
>  		enabled = dev->enabled_protocols;
> @@ -349,7 +349,7 @@ static ssize_t show_protocols(struct device *device,
>  		allowed = dev->allowed_wakeup_protocols;
>  	}
>  
> -	mutex_unlock(&dev->lock);
> +	mutex_unlock(&dev->mutex);
>  
>  	IR_dprintk(1, "%s: allowed - 0x%llx, enabled - 0x%llx\n",
>  		   __func__, (long long)allowed, (long long)enabled);
> @@ -449,7 +449,7 @@ static int parse_protocol_change(u64 *protocols, const char *buf)
>   * See parse_protocol_change() for the valid commands.
>   * Returns @len on success or a negative error code.
>   *
> - * dev->lock is taken to guard against races between store_protocols and
> + * dev->mutex is taken to guard against races between store_protocols and
>   * show_protocols.
>   */
>  static ssize_t store_protocols(struct device *device,
> @@ -488,7 +488,7 @@ static ssize_t store_protocols(struct device *device,
>  		return -EINVAL;
>  	}
>  
> -	mutex_lock(&dev->lock);
> +	mutex_lock(&dev->mutex);
>  
>  	old_protocols = *current_protocols;
>  	new_protocols = old_protocols;
> @@ -532,7 +532,7 @@ static ssize_t store_protocols(struct device *device,
>  	rc = len;
>  
>  out:
> -	mutex_unlock(&dev->lock);
> +	mutex_unlock(&dev->mutex);
>  	return rc;
>  }
>  
> @@ -550,7 +550,7 @@ out:
>   * Bits of the filter value corresponding to set bits in the filter mask are
>   * compared against input scancodes and non-matching scancodes are discarded.
>   *
> - * dev->lock is taken to guard against races between store_filter and
> + * dev->mutex is taken to guard against races between store_filter and
>   * show_filter.
>   */
>  static ssize_t show_filter(struct device *device,
> @@ -571,12 +571,12 @@ static ssize_t show_filter(struct device *device,
>  	else
>  		filter = &dev->scancode_wakeup_filter;
>  
> -	mutex_lock(&dev->lock);
> +	mutex_lock(&dev->mutex);
>  	if (fattr->mask)
>  		val = filter->mask;
>  	else
>  		val = filter->data;
> -	mutex_unlock(&dev->lock);
> +	mutex_unlock(&dev->mutex);
>  
>  	return sprintf(buf, "%#x\n", val);
>  }
> @@ -597,7 +597,7 @@ static ssize_t show_filter(struct device *device,
>   * Bits of the filter value corresponding to set bits in the filter mask are
>   * compared against input scancodes and non-matching scancodes are discarded.
>   *
> - * dev->lock is taken to guard against races between store_filter and
> + * dev->mutex is taken to guard against races between store_filter and
>   * show_filter.
>   */
>  static ssize_t store_filter(struct device *device,
> @@ -633,7 +633,7 @@ static ssize_t store_filter(struct device *device,
>  	if (!set_filter)
>  		return -EINVAL;
>  
> -	mutex_lock(&dev->lock);
> +	mutex_lock(&dev->mutex);
>  
>  	new_filter = *filter;
>  	if (fattr->mask)
> @@ -654,7 +654,7 @@ static ssize_t store_filter(struct device *device,
>  	*filter = new_filter;
>  
>  unlock:
> -	mutex_unlock(&dev->lock);
> +	mutex_unlock(&dev->mutex);
>  	return (ret < 0) ? ret : len;
>  }
>  
> @@ -1087,7 +1087,7 @@ static long rc_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>  	struct rc_dev *dev = client->dev;
>  	int ret;
>  
> -	ret = mutex_lock_interruptible(&dev->lock);
> +	ret = mutex_lock_interruptible(&dev->mutex);
>  	if (ret)
>  		return ret;
>  
> @@ -1099,7 +1099,7 @@ static long rc_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>  	ret = rc_do_ioctl(dev, cmd, arg);
>  
>  out:
> -	mutex_unlock(&dev->lock);
> +	mutex_unlock(&dev->mutex);
>  	return ret;
>  }
>  
> @@ -1226,7 +1226,7 @@ struct rc_dev *rc_allocate_device(void)
>  	mutex_init(&dev->txmutex);
>  	init_waitqueue_head(&dev->txwait);
>  	init_waitqueue_head(&dev->rxwait);
> -	mutex_init(&dev->lock);
> +	mutex_init(&dev->mutex);
>  
>  	dev->dev.type = &rc_dev_type;
>  	dev->dev.class = &rc_class;
> @@ -1339,9 +1339,9 @@ void rc_unregister_device(struct rc_dev *dev)
>  	if (!dev)
>  		return;
>  
> -	mutex_lock(&dev->lock);
> +	mutex_lock(&dev->mutex);
>  	dev->dead = true;
> -	mutex_unlock(&dev->lock);
> +	mutex_unlock(&dev->mutex);
>  
>  	spin_lock(&dev->client_lock);
>  	list_for_each_entry(client, &dev->client_list, node)
> diff --git a/include/media/rc-core.h b/include/media/rc-core.h
> index 25c1d38..a310e5b 100644
> --- a/include/media/rc-core.h
> +++ b/include/media/rc-core.h
> @@ -268,8 +268,7 @@ enum rc_filter_type {
>   * @driver_name: name of the hardware driver which registered this device
>   * @map_name: name of the default keymap
>   * @rc_kt: current rc_keytable
> - * @lock: used to ensure we've filled in all protocol details before
> - *	anyone can call show_protocols or store_protocols
> + * @mutex: used where a more specific lock/mutex/etc is not available
>   * @dead: used to determine if the device is still alive
>   * @client_list: list of clients (processes which have opened the rc chardev)
>   * @client_lock: protects client_list
> @@ -334,7 +333,7 @@ struct rc_dev {
>  	const char			*map_name;
>  	struct rc_keytable		*keytables[RC_MAX_KEYTABLES];
>  	struct list_head		keytable_list;
> -	struct mutex			lock;
> +	struct mutex			mutex;
>  	bool				dead;
>  	struct list_head		client_list;
>  	spinlock_t			client_lock;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
