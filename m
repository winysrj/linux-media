Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:50481 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751490AbdCZUcc (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 26 Mar 2017 16:32:32 -0400
Date: Sun, 26 Mar 2017 21:31:31 +0100
From: Sean Young <sean@mess.org>
To: A Sun <as1033x@comcast.net>
Cc: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: Re: [PATCH 1/3] [media] mceusb: RX -EPIPE (urb status = -32) lockup
 failure fix
Message-ID: <20170326203130.GA6070@gofer.mess.org>
References: <58D6A1DD.2030405@comcast.net>
 <20170326102748.GA1672@gofer.mess.org>
 <58D80838.8050809@comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <58D80838.8050809@comcast.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Mar 26, 2017 at 02:28:08PM -0400, A Sun wrote:
> commit https://github.com/asunxx/linux/commit/17fe3b51f4ad5202a876ea4c92b5d99d4e166823
> Author: A Sun <as1033x@comcast.net>
> Date:   Sun, 26 Mar 2017 13:24:18 -0400 

Please don't include this.

> 
> Bug:
> 
> RX -EPIPE failure with infinite loop and flooding of
> Mar 20 22:24:56 raspberrypi kernel: [ 2851.966506] mceusb 1-1.2:1.0: Error: urb status = -32
> log message at 8000 messages per second.
> Bug trigger appears to be normal, but heavy, IR receiver use.
> Driver and Linux host become unusable after error.
> Also seen at https://sourceforge.net/p/lirc/mailman/message/34886165/
> 
> Fix:
> 
> Message reports RX usb halt (stall) condition requiring usb_clear_halt() call in non-interrupt context to recover.
> Add driver workqueue call to perform this recovery based on method in use for the usbnet device driver.
> 
> Tested with:
> 
> Linux raspberrypi 4.4.50-v7+ #970 SMP Mon Feb 20 19:18:29 GMT 2017 armv7l GNU/Linux
> mceusb 1-1.2:1.0: Registered Pinnacle Systems PCTV Remote USB with mce emulator interface version 1
> mceusb 1-1.2:1.0: 2 tx ports (0x1 cabled) and 2 rx sensors (0x1 active)

It would be nice to have this tested against a mainline kernel. I thought
that was entirely possible on raspberry pis nowadays.
> 
> Signed-off-by: A Sun <as1033x@comcast.net>
> ---
>  drivers/media/rc/mceusb.c | 67 ++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 66 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
> index 238d8ea..7b6f9e5 100644
> --- a/drivers/media/rc/mceusb.c
> +++ b/drivers/media/rc/mceusb.c
> @@ -36,12 +36,13 @@
>  #include <linux/device.h>
>  #include <linux/module.h>
>  #include <linux/slab.h>
> +#include <linux/workqueue.h>
>  #include <linux/usb.h>
>  #include <linux/usb/input.h>
>  #include <linux/pm_wakeup.h>
>  #include <media/rc-core.h>
>  
> -#define DRIVER_VERSION	"1.92"
> +#define DRIVER_VERSION	"1.93"
>  #define DRIVER_AUTHOR	"Jarod Wilson <jarod@redhat.com>"
>  #define DRIVER_DESC	"Windows Media Center Ed. eHome Infrared Transceiver " \
>  			"device driver"
> @@ -417,6 +418,7 @@ struct mceusb_dev {
>  	/* usb */
>  	struct usb_device *usbdev;
>  	struct urb *urb_in;
> +	unsigned int pipe_in;
>  	struct usb_endpoint_descriptor *usb_ep_out;
>  
>  	/* buffers and dma */
> @@ -454,6 +456,12 @@ struct mceusb_dev {
>  	u8 num_rxports;		/* number of receive sensors */
>  	u8 txports_cabled;	/* bitmask of transmitters with cable */
>  	u8 rxports_active;	/* bitmask of active receive sensors */
> +
> +	/* kevent support */
> +	struct work_struct kevent;

kevent is not a descriptive name. How about something like clear_halt?

> +	unsigned long kevent_flags;
> +#		define EVENT_TX_HALT	0
> +#		define EVENT_RX_HALT	1

EVENT_TX_HALT is never used, so kevent_flags is only ever set to 1. The
entire field can be dropped.

>  };
>  
>  /* MCE Device Command Strings, generally a port and command pair */
> @@ -1025,6 +1033,23 @@ static void mceusb_process_ir_data(struct mceusb_dev *ir, int buf_len)
>  	}
>  }
>  
> +/*
> + * Workqueue task dispatcher
> + * for work that can't be done in interrupt handlers
> + * (mceusb_dev_recv() and mce_async_callback()) nor tasklets.
> + * Invokes mceusb_deferred_kevent() for recovering from
> + * error events specified by the kevent bit field.
> + */
> +static void mceusb_defer_kevent(struct mceusb_dev *ir, int kevent)
> +{
> +	set_bit(kevent, &ir->kevent_flags);
> +	if (!schedule_work(&ir->kevent)) {
> +		dev_err(ir->dev, "kevent %d may have been dropped", kevent);
> +	} else {
> +		dev_dbg(ir->dev, "kevent %d scheduled", kevent);
> +	}
> +}

Again name is not very descriptive.

> +
>  static void mceusb_dev_recv(struct urb *urb)
>  {
>  	struct mceusb_dev *ir;
> @@ -1052,6 +1077,11 @@ static void mceusb_dev_recv(struct urb *urb)
>  		return;
>  
>  	case -EPIPE:
> +		dev_err(ir->dev, "Error: urb status = %d (RX HALT)",
> +			urb->status);
> +		mceusb_defer_kevent(ir, EVENT_RX_HALT);

Here you could simply call schedule_work(). Note that EPIPE might also
be returned for device disconnect for some host controllers.

> +		return;
> +
>  	default:
>  		dev_err(ir->dev, "Error: urb status = %d", urb->status);
>  		break;
> @@ -1170,6 +1200,37 @@ static void mceusb_flash_led(struct mceusb_dev *ir)
>  	mce_async_out(ir, FLASH_LED, sizeof(FLASH_LED));
>  }
>  
> +/*
> + * Workqueue function
> + * for resetting or recovering device after occurrence of error events
> + * specified in ir->kevent bit field.
> + * Function runs (via schedule_work()) in non-interrupt context, for
> + * calls here (such as usb_clear_halt()) requiring non-interrupt context.
> + */
> +static void mceusb_deferred_kevent(struct work_struct *work)
> +{
> +	struct mceusb_dev *ir =
> +		container_of(work, struct mceusb_dev, kevent);
> +	int status;
> +
> +	if (test_bit(EVENT_RX_HALT, &ir->kevent_flags)) {

If condition can go.

> +		usb_unlink_urb(ir->urb_in);
> +		status = usb_clear_halt(ir->usbdev, ir->pipe_in);
> +		if (status < 0) {
> +			dev_err(ir->dev, "rx clear halt error %d",
> +				status);
> +			return;
> +		}
> +		clear_bit(EVENT_RX_HALT, &ir->kevent_flags);
> +		status = usb_submit_urb(ir->urb_in, GFP_KERNEL);
> +		if (status < 0) {
> +			dev_err(ir->dev, "rx unhalt submit urb error %d",
> +				status);
> +			return;
> +		}
> +	}
> +}
> +
>  static struct rc_dev *mceusb_init_rc_dev(struct mceusb_dev *ir)
>  {
>  	struct usb_device *udev = ir->usbdev;
> @@ -1336,6 +1397,9 @@ static int mceusb_dev_probe(struct usb_interface *intf,
>  	if (!ir->rc)
>  		goto rc_dev_fail;
>  
> +	ir->pipe_in = pipe;
> +	INIT_WORK(&ir->kevent, mceusb_deferred_kevent);
> +
>  	/* wire up inbound data handler */
>  	usb_fill_int_urb(ir->urb_in, dev, pipe, ir->buf_in, maxp,
>  				mceusb_dev_recv, ir, ep_in->bInterval);
> @@ -1405,6 +1469,7 @@ static void mceusb_dev_disconnect(struct usb_interface *intf)
>  		return;
>  
>  	ir->usbdev = NULL;
> +	cancel_work_sync(&ir->kevent);
>  	rc_unregister_device(ir->rc);
>  	usb_kill_urb(ir->urb_in);
>  	usb_free_urb(ir->urb_in);
> -- 
> 2.1.4
> 
