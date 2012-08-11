Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25520 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751595Ab2HKUUg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 11 Aug 2012 16:20:36 -0400
Message-ID: <5026BE78.80902@redhat.com>
Date: Sat, 11 Aug 2012 17:20:08 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?David_H=E4rdeman?= <david@hardeman.nu>
CC: Sean Young <sean@mess.org>, Jarod Wilson <jarod@wilsonet.com>,
	Alan Cox <alan@linux.intel.com>, linux-media@vger.kernel.org,
	linux-serial@vger.kernel.org, lirc-list@lists.sourceforge.net
Subject: Re: [PATCH] [media] winbond-cir: Fix initialization
References: <1343731023-9822-1-git-send-email-sean@mess.org>
In-Reply-To: <1343731023-9822-1-git-send-email-sean@mess.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi David,

Em 31-07-2012 07:37, Sean Young escreveu:
> The serial driver will detect the winbond cir device as a serial port,
> since it looks exactly like a serial port unless you know what it is
> from the PNP ID.
> 
> Winbond CIR 00:04: Region 0x2f8-0x2ff already in use!
> Winbond CIR 00:04: disabled
> Winbond CIR: probe of 00:04 failed with error -16

Please review this patch.

> 
> Signed-off-by: Sean Young <sean@mess.org>
> ---
>  drivers/media/rc/winbond-cir.c | 21 ++++++++++++++++++++-
>  drivers/tty/serial/8250/8250.c |  1 +
>  2 files changed, 21 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/rc/winbond-cir.c b/drivers/media/rc/winbond-cir.c
> index 54ee348..20a0bbb 100644
> --- a/drivers/media/rc/winbond-cir.c
> +++ b/drivers/media/rc/winbond-cir.c
> @@ -55,6 +55,7 @@
>  #include <linux/slab.h>
>  #include <linux/wait.h>
>  #include <linux/sched.h>
> +#include <linux/serial_8250.h>
>  #include <media/rc-core.h>
>  
>  #define DRVNAME "winbond-cir"
> @@ -957,6 +958,7 @@ wbcir_probe(struct pnp_dev *device, const struct pnp_device_id *dev_id)
>  	struct device *dev = &device->dev;
>  	struct wbcir_data *data;
>  	int err;
> +	struct resource *io;
>  
>  	if (!(pnp_port_len(device, 0) == EHFUNC_IOMEM_LEN &&
>  	      pnp_port_len(device, 1) == WAKEUP_IOMEM_LEN &&
> @@ -1049,7 +1051,24 @@ wbcir_probe(struct pnp_dev *device, const struct pnp_device_id *dev_id)
>  		goto exit_release_wbase;
>  	}
>  
> -	if (!request_region(data->sbase, SP_IOMEM_LEN, DRVNAME)) {
> +	io = request_region(data->sbase, SP_IOMEM_LEN, DRVNAME);
> +
> +	/*
> +	 * The winbond cir device looks exactly like an NS16550A serial port
> +	 * unless you know what it is. We've got here via the PNP ID.
> +	 */
> +#ifdef CONFIG_SERIAL_8250
> +	if (!io) {
> +		struct uart_port port = { .iobase = data->sbase };
> +		int line = serial8250_find_port(&port);
> +		if (line >= 0) {
> +			serial8250_unregister_port(line);

Hmm... Not sure if it makes sense, but perhaps the unregistering code
should be reverting serial8250_unregister_port(line).

> +
> +			io = request_region(data->sbase, SP_IOMEM_LEN, DRVNAME);
> +		}
> +	}
> +#endif
> +	if (!io) {
>  		dev_err(dev, "Region 0x%lx-0x%lx already in use!\n",
>  			data->sbase, data->sbase + SP_IOMEM_LEN - 1);
>  		err = -EBUSY;
> diff --git a/drivers/tty/serial/8250/8250.c b/drivers/tty/serial/8250/8250.c
> index 5c27f7e..d38615f 100644
> --- a/drivers/tty/serial/8250/8250.c
> +++ b/drivers/tty/serial/8250/8250.c
> @@ -2914,6 +2914,7 @@ int serial8250_find_port(struct uart_port *p)
>  	}
>  	return -ENODEV;
>  }
> +EXPORT_SYMBOL(serial8250_find_port);
>  
>  #define SERIAL8250_CONSOLE	&serial8250_console
>  #else
> 

