Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:46227 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755694AbcAYQ3M (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 25 Jan 2016 11:29:12 -0500
Date: Mon, 25 Jan 2016 14:29:06 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Jarod Wilson <jarod@wilsonet.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	devel@driverdev.osuosl.org
Subject: Re: [PATCH 5/5] staging: media: lirc: use new parport device model
Message-ID: <20160125142906.184a4cb5@recife.lan>
In-Reply-To: <1450443929-15305-5-git-send-email-sudipm.mukherjee@gmail.com>
References: <1450443929-15305-1-git-send-email-sudipm.mukherjee@gmail.com>
	<1450443929-15305-5-git-send-email-sudipm.mukherjee@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 18 Dec 2015 18:35:29 +0530
Sudip Mukherjee <sudipm.mukherjee@gmail.com> escreveu:

> Modify lirc_parallel driver to use the new parallel port device model.

Did you or someone else tested this patch?

Regards,
Mauro

> 
> Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
> ---
>  drivers/staging/media/lirc/lirc_parallel.c | 100 +++++++++++++++++++----------
>  1 file changed, 65 insertions(+), 35 deletions(-)
> 
> diff --git a/drivers/staging/media/lirc/lirc_parallel.c b/drivers/staging/media/lirc/lirc_parallel.c
> index 0156114..20ec9b6 100644
> --- a/drivers/staging/media/lirc/lirc_parallel.c
> +++ b/drivers/staging/media/lirc/lirc_parallel.c
> @@ -629,43 +629,26 @@ static void kf(void *handle)
>  	*/
>  }
>  
> -/*** module initialization and cleanup ***/
> -
> -static int __init lirc_parallel_init(void)
> +static void lirc_parallel_attach(struct parport *port)
>  {
> -	int result;
> +	struct pardev_cb lirc_parallel_cb;
>  
> -	result = platform_driver_register(&lirc_parallel_driver);
> -	if (result) {
> -		pr_notice("platform_driver_register returned %d\n", result);
> -		return result;
> -	}
> +	if (port->base != io)
> +		return;
>  
> -	lirc_parallel_dev = platform_device_alloc(LIRC_DRIVER_NAME, 0);
> -	if (!lirc_parallel_dev) {
> -		result = -ENOMEM;
> -		goto exit_driver_unregister;
> -	}
> +	pport = port;
> +	memset(&lirc_parallel_cb, 0, sizeof(lirc_parallel_cb));
> +	lirc_parallel_cb.preempt = pf;
> +	lirc_parallel_cb.wakeup = kf;
> +	lirc_parallel_cb.irq_func = lirc_lirc_irq_handler;
>  
> -	result = platform_device_add(lirc_parallel_dev);
> -	if (result)
> -		goto exit_device_put;
> -
> -	pport = parport_find_base(io);
> -	if (!pport) {
> -		pr_notice("no port at %x found\n", io);
> -		result = -ENXIO;
> -		goto exit_device_put;
> -	}
> -	ppdevice = parport_register_device(pport, LIRC_DRIVER_NAME,
> -					   pf, kf, lirc_lirc_irq_handler, 0,
> -					   NULL);
> -	parport_put_port(pport);
> +	ppdevice = parport_register_dev_model(port, LIRC_DRIVER_NAME,
> +					      &lirc_parallel_cb, 0);
>  	if (!ppdevice) {
>  		pr_notice("parport_register_device() failed\n");
> -		result = -ENXIO;
> -		goto exit_device_put;
> +		return;
>  	}
> +
>  	if (parport_claim(ppdevice) != 0)
>  		goto skip_init;
>  	is_claimed = 1;
> @@ -693,18 +676,66 @@ static int __init lirc_parallel_init(void)
>  
>  	is_claimed = 0;
>  	parport_release(ppdevice);
> - skip_init:
> +
> +skip_init:
> +	return;
> +}
> +
> +static void lirc_parallel_detach(struct parport *port)
> +{
> +	if (port->base != io)
> +		return;
> +
> +	parport_unregister_device(ppdevice);
> +}
> +
> +static struct parport_driver lirc_parport_driver = {
> +	.name = LIRC_DRIVER_NAME,
> +	.match_port = lirc_parallel_attach,
> +	.detach = lirc_parallel_detach,
> +	.devmodel = true,
> +};
> +
> +/*** module initialization and cleanup ***/
> +
> +static int __init lirc_parallel_init(void)
> +{
> +	int result;
> +
> +	result = platform_driver_register(&lirc_parallel_driver);
> +	if (result) {
> +		pr_notice("platform_driver_register returned %d\n", result);
> +		return result;
> +	}
> +
> +	lirc_parallel_dev = platform_device_alloc(LIRC_DRIVER_NAME, 0);
> +	if (!lirc_parallel_dev) {
> +		result = -ENOMEM;
> +		goto exit_driver_unregister;
> +	}
> +
> +	result = platform_device_add(lirc_parallel_dev);
> +	if (result)
> +		goto exit_device_put;
> +
> +	result = parport_register_driver(&lirc_parport_driver);
> +	if (result) {
> +		pr_notice("parport_register_driver returned %d\n", result);
> +		goto exit_device_put;
> +	}
> +
>  	driver.dev = &lirc_parallel_dev->dev;
>  	driver.minor = lirc_register_driver(&driver);
>  	if (driver.minor < 0) {
>  		pr_notice("register_chrdev() failed\n");
> -		parport_unregister_device(ppdevice);
>  		result = -EIO;
> -		goto exit_device_put;
> +		goto exit_unregister;
>  	}
>  	pr_info("installed using port 0x%04x irq %d\n", io, irq);
>  	return 0;
>  
> +exit_unregister:
> +	parport_unregister_driver(&lirc_parport_driver);
>  exit_device_put:
>  	platform_device_put(lirc_parallel_dev);
>  exit_driver_unregister:
> @@ -714,9 +745,8 @@ exit_driver_unregister:
>  
>  static void __exit lirc_parallel_exit(void)
>  {
> -	parport_unregister_device(ppdevice);
>  	lirc_unregister_driver(driver.minor);
> -
> +	parport_unregister_driver(&lirc_parport_driver);
>  	platform_device_unregister(lirc_parallel_dev);
>  	platform_driver_unregister(&lirc_parallel_driver);
>  }
