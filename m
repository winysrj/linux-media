Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:36168 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751435AbdGQMxJ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Jul 2017 08:53:09 -0400
Subject: Re: [PATCH 14/22] [media] usbvision-i2c: fix format overflow warning
To: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>
References: <20170714120720.906842-1-arnd@arndb.de>
 <20170714120720.906842-15-arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>, akpm@linux-foundation.org,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, x86@kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        linux-media@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <f44cbc53-8c95-9fad-04d4-1fbf3708191c@xs4all.nl>
Date: Mon, 17 Jul 2017 14:53:01 +0200
MIME-Version: 1.0
In-Reply-To: <20170714120720.906842-15-arnd@arndb.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 14/07/17 14:07, Arnd Bergmann wrote:
> gcc-7 notices that we copy a fixed length string into another
> string of the same size, with additional characters:
> 
> drivers/media/usb/usbvision/usbvision-i2c.c: In function 'usbvision_i2c_register':
> drivers/media/usb/usbvision/usbvision-i2c.c:190:36: error: '%d' directive writing between 1 and 11 bytes into a region of size between 0 and 47 [-Werror=format-overflow=]
>   sprintf(usbvision->i2c_adap.name, "%s-%d-%s", i2c_adap_template.name,
>                                     ^~~~~~~~~~
> drivers/media/usb/usbvision/usbvision-i2c.c:190:2: note: 'sprintf' output between 4 and 76 bytes into a destination of size 48
> 
> We know this is fine as the template name is always "usbvision", so
> we can easily avoid the warning by using this as the format string
> directly.

Hmm, how about replacing sprintf by snprintf? That feels a lot safer (this is very
old code, it's not surprising it is still using sprintf).

Regards,

	Hans

> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/media/usb/usbvision/usbvision-i2c.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/usb/usbvision/usbvision-i2c.c b/drivers/media/usb/usbvision/usbvision-i2c.c
> index fdf6b6e285da..aae9f69884da 100644
> --- a/drivers/media/usb/usbvision/usbvision-i2c.c
> +++ b/drivers/media/usb/usbvision/usbvision-i2c.c
> @@ -187,8 +187,8 @@ int usbvision_i2c_register(struct usb_usbvision *usbvision)
>  
>  	usbvision->i2c_adap = i2c_adap_template;
>  
> -	sprintf(usbvision->i2c_adap.name, "%s-%d-%s", i2c_adap_template.name,
> -		usbvision->dev->bus->busnum, usbvision->dev->devpath);
> +	sprintf(usbvision->i2c_adap.name, "usbvision-%d-%s",
> +		 usbvision->dev->bus->busnum, usbvision->dev->devpath);
>  	PDEBUG(DBG_I2C, "Adaptername: %s", usbvision->i2c_adap.name);
>  	usbvision->i2c_adap.dev.parent = &usbvision->dev->dev;
>  
> 
