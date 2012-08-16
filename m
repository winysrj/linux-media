Return-path: <linux-media-owner@vger.kernel.org>
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:48514 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754105Ab2HPQTL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Aug 2012 12:19:11 -0400
Date: Thu, 16 Aug 2012 09:19:09 -0700
From: Greg KH <greg@kroah.com>
To: Sean Young <sean@mess.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Jarod Wilson <jarod@wilsonet.com>,
	David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>,
	Alan Cox <alan@linux.intel.com>, linux-media@vger.kernel.org,
	linux-serial@vger.kernel.org, lirc-list@lists.sourceforge.net
Subject: Re: [PATCH] [media] winbond-cir: Fix initialization
Message-ID: <20120816161909.GB29199@kroah.com>
References: <1343731023-9822-1-git-send-email-sean@mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343731023-9822-1-git-send-email-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jul 31, 2012 at 11:37:03AM +0100, Sean Young wrote:
> The serial driver will detect the winbond cir device as a serial port,
> since it looks exactly like a serial port unless you know what it is
> from the PNP ID.
> 
> Winbond CIR 00:04: Region 0x2f8-0x2ff already in use!
> Winbond CIR 00:04: disabled
> Winbond CIR: probe of 00:04 failed with error -16
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

EXPORT_SYMBOL_GPL please.

But can't this be done as a quirk to the 8250 driver so that it just
does not bind to this device in the first place?  Wouldn't that make
more sense?

thanks,

greg k-h
