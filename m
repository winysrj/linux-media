Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:36603 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752319AbdHAVUQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 1 Aug 2017 17:20:16 -0400
Date: Tue, 1 Aug 2017 22:20:14 +0100
From: Sean Young <sean@mess.org>
To: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org, mchehab@s-opensource.com
Subject: Re: [PATCH 19/19] lirc_dev: consistent device registration printk
Message-ID: <20170801212014.6sb27aurcrvrspux@gofer.mess.org>
References: <149839373103.28811.9486751698665303339.stgit@zeus.hardeman.nu>
 <149839397127.28811.15601147061333876867.stgit@zeus.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <149839397127.28811.15601147061333876867.stgit@zeus.hardeman.nu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Jun 25, 2017 at 02:32:51PM +0200, David Härdeman wrote:
> This patch changes the message that is printed on lirc device registration to
> make it more consistent with the input and rc subsystems.
> 
> Before:
>   rc rc0: rc-core loopback device as /devices/virtual/rc/rc0
>   input: rc-core loopback device as /devices/virtual/rc/rc0/input43
>   lirc lirc0: lirc_dev: driver ir-lirc-codec (rc-loopback) registered at minor = 0
> 
> After:
>   rc rc0: rc-core loopback device as /devices/virtual/rc/rc0
>   input: rc-core loopback device as /devices/virtual/rc/rc0/input23
>   lirc lirc0: rc-core loopback device as /devices/virtual/rc/rc0/lirc0

There is a couple of problems with this.

1. lirc_dev name is 40 bytes, but rc_dev input_name has no limit, so it ends
up truncating which you don't want. For example:

[  106.303589] rc rc2: IguanaWorks USB IR Transceiver version 0x0308 as /devices/pci0000:00/0000:00:1a.1/usb4/4-2/4-2.3/4-2.3:1.0/rc/rc2
[  106.303664] input: IguanaWorks USB IR Transceiver version 0x0308 as /devices/pci0000:00/0000:00:1a.1/usb4/4-2/4-2.3/4-2.3:1.0/rc/rc2/input24
[  106.307272] lirc lirc2: IguanaWorks USB IR Transceiver version  as /devices/pci0000:00/0000:00:1a.1/usb4/4-2/4-2.3/4-2.3:1.0/rc/rc2/lirc2
[  233.005834] rc rc2: Media Center Ed. eHome Infrared Remote Transceiver (0609:031d) as /devices/pci0000:00/0000:00:1a.1/usb4/4-2/4-2.3/4-2.3:1.0/rc/rc2
[  233.005907] input: Media Center Ed. eHome Infrared Remote Transceiver (0609:031d) as /devices/pci0000:00/0000:00:1a.1/usb4/4-2/4-2.3/4-2.3:1.0/rc/rc2/input25
[  233.006307] lirc lirc2: Media Center Ed. eHome Infrared Remote  as /devices/pci0000:00/0000:00:1a.1/usb4/4-2/4-2.3/4-2.3:1.0/rc/rc2/lirc2

2. Documentation/media/uapi/rc/lirc-dev-intro.rst explicitly mentions this 
message, so that will need updating too. On a related note, should we be
changing messages, esp. documented ones? I agree the original message is
a bit ugly.

3. I like have the driver name in the message. As you can see above, you
have no idea you're plugging in an mceusb device (iguanair is a bit
more obvious). Then again none of the other messages mention this, maybe
it be added there.

As it is the patch can't be applied.

Maybe lirc_dev name can be changed to const char* so we avoid the strcpy
and truncation.


Sean

> 
> Signed-off-by: David Härdeman <david@hardeman.nu>
> ---
>  drivers/media/rc/ir-lirc-codec.c |    3 +--
>  drivers/media/rc/lirc_dev.c      |    6 ++++--
>  2 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
> index 05f88401f694..4f33516a95a3 100644
> --- a/drivers/media/rc/ir-lirc-codec.c
> +++ b/drivers/media/rc/ir-lirc-codec.c
> @@ -595,8 +595,7 @@ static int ir_lirc_register(struct rc_dev *dev)
>  	if (dev->max_timeout)
>  		features |= LIRC_CAN_SET_REC_TIMEOUT;
>  
> -	snprintf(ldev->name, sizeof(ldev->name), "ir-lirc-codec (%s)",
> -		 dev->driver_name);
> +	snprintf(ldev->name, sizeof(ldev->name), "%s", dev->input_name);
>  	ldev->features = features;
>  	ldev->data = &dev->raw->lirc;
>  	ldev->buf = NULL;
> diff --git a/drivers/media/rc/lirc_dev.c b/drivers/media/rc/lirc_dev.c
> index c1c917932f7e..03430a1fb192 100644
> --- a/drivers/media/rc/lirc_dev.c
> +++ b/drivers/media/rc/lirc_dev.c
> @@ -105,6 +105,7 @@ int lirc_register_device(struct lirc_dev *d)
>  {
>  	int minor;
>  	int err;
> +	const char *path;
>  
>  	if (!d) {
>  		pr_err("driver pointer must be not NULL!\n");
> @@ -171,8 +172,9 @@ int lirc_register_device(struct lirc_dev *d)
>  		return err;
>  	}
>  
> -	dev_info(&d->dev, "lirc_dev: driver %s registered at minor = %d\n",
> -		 d->name, d->minor);
> +	path = kobject_get_path(&d->dev.kobj, GFP_KERNEL);
> +	dev_info(&d->dev, "%s as %s\n", d->name, path ?: "N/A");
> +	kfree(path);
>  
>  	return 0;
>  }
