Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm2-vm0.bt.bullet.mail.ukl.yahoo.com ([217.146.182.242]:29080
	"HELO nm2-vm0.bt.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752649Ab1IYNcc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Sep 2011 09:32:32 -0400
Message-ID: <4E7F2D6B.5000603@yahoo.com>
Date: Sun, 25 Sep 2011 14:32:27 +0100
From: Chris Rankin <rankincj@yahoo.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH v3] EM28xx - fix deadlock when unplugging and replugging
 a DVB adapter
References: <4E7E43A2.3020905@yahoo.com> <4E7F25D4.2080504@redhat.com>
In-Reply-To: <4E7F25D4.2080504@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 25/09/11 14:00, Mauro Carvalho Chehab wrote:
> Hmm... This would probably work better (not tested). Could you please test it
> on your hardware?

Hmm, I don't understand this. The deadlock isn't about taking 
em28xx_devlist_mutex, but happens because em28xx_dvb_init() tries to retake 
dev->lock when em28xx_usb_probe() is already holding it. That's why I unlocked 
dev->lock before calling em28xx_init_extension().

So why are you avoiding locking em28xx_devlist_mutex?

Cheers,
Chris

> diff --git a/drivers/media/video/em28xx/em28xx-cards.c b/drivers/media/video/em28xx/em28xx-cards.c
> index 7297d90..c92c177 100644
> --- a/drivers/media/video/em28xx/em28xx-cards.c
> +++ b/drivers/media/video/em28xx/em28xx-cards.c
> @@ -3005,7 +3005,8 @@ static int em28xx_init_dev(struct em28xx **devhandle, struct usb_device *udev,
>   		goto fail;
>   	}
>
> -	em28xx_init_extension(dev);
> +	/* dev->lock needs to be holded */
> +	__em28xx_init_extension(dev);
>
>   	/* Save some power by putting tuner to sleep */
>   	v4l2_device_call_all(&dev->v4l2_dev, 0, core, s_power, 0);
> @@ -3301,10 +3302,10 @@ static void em28xx_usb_disconnect(struct usb_interface *interface)
>   		em28xx_release_resources(dev);
>   	}
>
> -	em28xx_close_extension(dev);
> -
>   	mutex_unlock(&dev->lock);
>
> +	em28xx_close_extension(dev);
> +
>   	if (!dev->users) {
>   		kfree(dev->alt_max_pkt_size);
>   		kfree(dev);
> diff --git a/drivers/media/video/em28xx/em28xx-core.c b/drivers/media/video/em28xx/em28xx-core.c
> index 804a4ab..afddfea 100644
> --- a/drivers/media/video/em28xx/em28xx-core.c
> +++ b/drivers/media/video/em28xx/em28xx-core.c
> @@ -1218,16 +1218,22 @@ void em28xx_unregister_extension(struct em28xx_ops *ops)
>   }
>   EXPORT_SYMBOL(em28xx_unregister_extension);
>
> -void em28xx_init_extension(struct em28xx *dev)
> +/* Need to take the mutex lock before calling it */
> +void __em28xx_init_extension(struct em28xx *dev)
>   {
>   	const struct em28xx_ops *ops = NULL;
>
> -	mutex_lock(&em28xx_devlist_mutex);
>   	list_add_tail(&dev->devlist,&em28xx_devlist);
>   	list_for_each_entry(ops,&em28xx_extension_devlist, next) {
>   		if (ops->init)
>   			ops->init(dev);
>   	}
> +}
> +
> +void em28xx_init_extension(struct em28xx *dev)
> +{
> +	mutex_lock(&em28xx_devlist_mutex);
> +	__em28xx_init_extension(dev);
>   	mutex_unlock(&em28xx_devlist_mutex);
>   }
>
> diff --git a/drivers/media/video/em28xx/em28xx.h b/drivers/media/video/em28xx/em28xx.h
> index 1626e4a..a5c1ba2 100644
> --- a/drivers/media/video/em28xx/em28xx.h
> +++ b/drivers/media/video/em28xx/em28xx.h
> @@ -682,6 +682,7 @@ void em28xx_remove_from_devlist(struct em28xx *dev);
>   void em28xx_add_into_devlist(struct em28xx *dev);
>   int em28xx_register_extension(struct em28xx_ops *dev);
>   void em28xx_unregister_extension(struct em28xx_ops *dev);
> +void __em28xx_init_extension(struct em28xx *dev);
>   void em28xx_init_extension(struct em28xx *dev);
>   void em28xx_close_extension(struct em28xx *dev);
>

