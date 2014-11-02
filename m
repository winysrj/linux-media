Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:59117 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752627AbaKBRcz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 2 Nov 2014 12:32:55 -0500
Message-ID: <54566AB5.3020803@iki.fi>
Date: Sun, 02 Nov 2014 19:32:37 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Matthias Schwarzott <zzam@gentoo.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCHv2 12/14] [media] cx231xx: use dev_info() for extension
 load/unload
References: <cover.1414929816.git.mchehab@osg.samsung.com> <58369096f1fee7d71942eae7a40db6d7c1c368bf.1414929816.git.mchehab@osg.samsung.com>
In-Reply-To: <58369096f1fee7d71942eae7a40db6d7c1c368bf.1414929816.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 11/02/2014 02:32 PM, Mauro Carvalho Chehab wrote:
> Now that we're using dev_foo, the logs become like:
>
> 	usb 1-2: DVB: registering adapter 0 frontend 0 (Fujitsu mb86A20s)...
> 	usb 1-2: Successfully loaded cx231xx-dvb
> 	cx231xx: Cx231xx dvb Extension initialized
>
> It is not clear, by the logs, that usb 1-2 name is an alias for
> cx231xx. So, we also need to use dvb_info() at extension load/unload.
>
> After the patch, it will print:
> 	usb 1-2: Cx231xx dvb Extension initialized
>
> With is coherent with the other logs.


That is not correct as wrong device pointer passed to dev_. Go cx231xx 
usb driver probe function and add following test log to see how is 
should look like:
dev_info(&intf->dev, "Hello World\n");

It prints something like
cx231xx 1-2-1: Hello World

regards
Antti

>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>
> diff --git a/drivers/media/usb/cx231xx/cx231xx-core.c b/drivers/media/usb/cx231xx/cx231xx-core.c
> index 36c3ecf204c1..64e907f02a02 100644
> --- a/drivers/media/usb/cx231xx/cx231xx-core.c
> +++ b/drivers/media/usb/cx231xx/cx231xx-core.c
> @@ -98,10 +98,10 @@ int cx231xx_register_extension(struct cx231xx_ops *ops)
>
>   	mutex_lock(&cx231xx_devlist_mutex);
>   	list_add_tail(&ops->next, &cx231xx_extension_devlist);
> -	list_for_each_entry(dev, &cx231xx_devlist, devlist)
> +	list_for_each_entry(dev, &cx231xx_devlist, devlist) {
>   		ops->init(dev);
> -
> -	printk(KERN_INFO DRIVER_NAME ": %s initialized\n", ops->name);
> +		dev_info(&dev->udev->dev, "%s initialized\n", ops->name);
> +	}
>   	mutex_unlock(&cx231xx_devlist_mutex);
>   	return 0;
>   }
> @@ -112,11 +112,11 @@ void cx231xx_unregister_extension(struct cx231xx_ops *ops)
>   	struct cx231xx *dev = NULL;
>
>   	mutex_lock(&cx231xx_devlist_mutex);
> -	list_for_each_entry(dev, &cx231xx_devlist, devlist)
> +	list_for_each_entry(dev, &cx231xx_devlist, devlist) {
>   		ops->fini(dev);
> +		dev_info(&dev->udev->dev, "%s removed\n", ops->name);
> +	}
>
> -
> -	printk(KERN_INFO DRIVER_NAME ": %s removed\n", ops->name);
>   	list_del(&ops->next);
>   	mutex_unlock(&cx231xx_devlist_mutex);
>   }
>

-- 
http://palosaari.fi/
