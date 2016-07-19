Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([80.229.237.210]:53317 "EHLO gofer.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752237AbcGSWEv (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jul 2016 18:04:51 -0400
Date: Tue, 19 Jul 2016 23:04:47 +0100
From: Sean Young <sean@mess.org>
To: Andi Shyti <andi.shyti@samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	Andi Shyti <andi@etezian.org>
Subject: Re: [RFC 1/7] [media] rc-main: assign driver type during allocation
Message-ID: <20160719220447.GA24697@gofer.mess.org>
References: <1468943818-26025-1-git-send-email-andi.shyti@samsung.com>
 <1468943818-26025-2-git-send-email-andi.shyti@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1468943818-26025-2-git-send-email-andi.shyti@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Jul 20, 2016 at 12:56:52AM +0900, Andi Shyti wrote:
> The driver type can be assigned immediately when an RC device
> requests to the framework to allocate the device.
> 
> This is an 'enum rc_driver_type' data type and specifies whether
> the device is a raw receiver or scancode receiver. The type will
> be given as parameter to the rc_allocate_device device.

This patch is good, but it does unfortunately break all the other
rc-core drivers, as now rc_allocate_device() needs argument. All
drivers will need a simple change in this patch.

Also note that there lots of issues that checkpatch.pl would pick
in these series.

> 
> Suggested-by: Sean Young <sean@mess.org>
> Signed-off-by: Andi Shyti <andi.shyti@samsung.com>
> ---
>  drivers/media/rc/rc-main.c | 4 +++-
>  include/media/rc-core.h    | 2 +-
>  2 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
> index 7dfc7c2..6403674 100644
> --- a/drivers/media/rc/rc-main.c
> +++ b/drivers/media/rc/rc-main.c
> @@ -1346,7 +1346,7 @@ static struct device_type rc_dev_type = {
>  	.uevent		= rc_dev_uevent,
>  };
>  
> -struct rc_dev *rc_allocate_device(void)
> +struct rc_dev *rc_allocate_device(enum rc_driver_type type)
>  {
>  	struct rc_dev *dev;
>  
> @@ -1373,6 +1373,8 @@ struct rc_dev *rc_allocate_device(void)
>  	dev->dev.class = &rc_class;
>  	device_initialize(&dev->dev);
>  
> +	dev->driver_type = type;
> +
>  	__module_get(THIS_MODULE);
>  	return dev;
>  }
> diff --git a/include/media/rc-core.h b/include/media/rc-core.h
> index b6586a9..c6bf1ef 100644
> --- a/include/media/rc-core.h
> +++ b/include/media/rc-core.h
> @@ -185,7 +185,7 @@ struct rc_dev {
>   * Remote Controller, at sys/class/rc.
>   */
>  
> -struct rc_dev *rc_allocate_device(void);
> +struct rc_dev *rc_allocate_device(enum rc_driver_type);
>  void rc_free_device(struct rc_dev *dev);
>  int rc_register_device(struct rc_dev *dev);
>  void rc_unregister_device(struct rc_dev *dev);
> -- 
> 2.8.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
