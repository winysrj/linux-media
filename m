Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:39351 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751277AbdCZK2A (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 26 Mar 2017 06:28:00 -0400
Date: Sun, 26 Mar 2017 11:27:49 +0100
From: Sean Young <sean@mess.org>
To: A Sun <as1033x@comcast.net>
Cc: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: Re: [PATCH] mceusb: RX -EPIPE lockup fault and more
Message-ID: <20170326102748.GA1672@gofer.mess.org>
References: <58D6A1DD.2030405@comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <58D6A1DD.2030405@comcast.net>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Mar 25, 2017 at 12:59:09PM -0400, A Sun wrote:
> commit https://github.com/asunxx/linux/commit/e557c1d737462961f2aadfbfb0836ffa3c778518
> Author: A Sun <as1033x@comcast.net>
> Date:   Sat Mar 25 02:42:03 2017 -0400
> 
> [PATCH] mceusb RX -EPIPE fault and more
> 
> Patch for mceusb driver tested with
> 
> [    8.627769] mceusb 1-1.2:1.0: Registered Pinnacle Systems PCTV Remote USB with mce emulator interface version 1
> [    8.627797] mceusb 1-1.2:1.0: 2 tx ports (0x1 cabled) and 2 rx sensors (0x1 active)
> 
> running on
> 
> pi@raspberrypi:~ $ uname -a
> Linux raspberrypi 4.4.50-v7+ #970 SMP Mon Feb 20 19:18:29 GMT 2017 armv7l GNU/Linux
> pi@raspberrypi:~ $
> 
> This patch is bug fix and debug messages fix (used for troubleshooting) for

Patches should be against media_tree. Also, one change per commit; please
split this into multiple commits.

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
> Bug:
> 
> Intermittent RX truncation and loss of IR received data. Results in receive data stream synchronization errors where driver attempts to incorrectly parse IR data as command responses.
> 
> Mar 22 12:01:40 raspberrypi kernel: [ 3969.139898] mceusb 1-1.2:1.0: processed IR data
> Mar 22 12:01:40 raspberrypi kernel: [ 3969.151315] mceusb 1-1.2:1.0: rx data: 00 90 (length=2)
> Mar 22 12:01:40 raspberrypi kernel: [ 3969.151321] mceusb 1-1.2:1.0: Unknown command 0x00 0x90
> Mar 22 12:01:40 raspberrypi kernel: [ 3969.151336] mceusb 1-1.2:1.0: rx data: 98 0a 8d 0a 8e 0a 8e 0a 8e 0a 8e 0a 9a 0a 8e 0a 0b 3a 8e 00 80 41 59 00 00 (length=25)
> Mar 22 12:01:40 raspberrypi kernel: [ 3969.151341] mceusb 1-1.2:1.0: Raw IR data, 24 pulse/space samples
> Mar 22 12:01:40 raspberrypi kernel: [ 3969.151348] mceusb 1-1.2:1.0: Storing space with duration 500000
> 
> Bug trigger appears to be normal, but heavy, IR receiver use.
> 
> Fix:
> 
> Cause may be receiver with ep_in bulk endpoint incorrectly bound to usb_fill_int_urb() urb for interrupt endpoint.
> In mceusb_dev_probe(), test ep_in endpoint for int versus bulk and use usb_fill_bulk_urb() as appropriate.
> 
> Bug:
> 
> Memory leak on disconnect for rc = rc_allocate_device().
> 
> Fix:
> 
> Add call rc_free_device() to mceusb_dev_disconnect()

rc_unregister_device() will call rc_free_device() for you.

> Bug:
> 
> mceusb_dev_printdata() prints incorrect window of bytes (0 to len) that are of interest and will be processed next.
> 
> Fix:
> 
> Add size of received data argument to mceusb_dev_printdata().
> Revise buffer print window (offset to offset+len).
> Remove static USB_BUFLEN = 32, which is variable depending on device
> (my receiver buffer size is 64 for Pinnacle IR transceiver).
> Revise bound test to prevent reporting data beyond end of read or end of buffer.
> 
> Bug:
> 
> Debug messages; some misleading.
> 
> Fix:
> 
> Drop "\n" use from dev_dbg().
> References to "receive request" should read "send request".
> Various syntax and other corrections.
> 
> Signed-off-by: A Sun <as1033x@comcast.net>
> 
> diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
> index 238d8ea..48e942e 100644
> --- a/drivers/media/rc/mceusb.c
> +++ b/drivers/media/rc/mceusb.c
> @@ -36,18 +36,18 @@
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
>  #define DRIVER_NAME	"mceusb"
>  
> -#define USB_BUFLEN		32 /* USB reception buffer length */
>  #define USB_CTRL_MSG_SZ		2  /* Size of usb ctrl msg on gen1 hw */
>  #define MCE_G1_INIT_MSGS	40 /* Init messages on gen1 hw to throw out */
>  
> @@ -417,6 +417,7 @@ struct mceusb_dev {
>  	/* usb */
>  	struct usb_device *usbdev;
>  	struct urb *urb_in;
> +	unsigned int pipe_in;
>  	struct usb_endpoint_descriptor *usb_ep_out;
>  
>  	/* buffers and dma */
> @@ -454,6 +455,12 @@ struct mceusb_dev {
>  	u8 num_rxports;		/* number of receive sensors */
>  	u8 txports_cabled;	/* bitmask of transmitters with cable */
>  	u8 rxports_active;	/* bitmask of active receive sensors */
> +
> +	/* kevent support */
> +	struct work_struct kevent;
> +	unsigned long kevent_flags;
> +#		define EVENT_TX_HALT	0
> +#		define EVENT_RX_HALT	1
>  };
>  
>  /* MCE Device Command Strings, generally a port and command pair */
> @@ -527,7 +534,7 @@ static int mceusb_cmd_datasize(u8 cmd, u8 subcmd)
>  }
>  
>  static void mceusb_dev_printdata(struct mceusb_dev *ir, char *buf,
> -				 int offset, int len, bool out)
> +				 int buf_len, int offset, int len, bool out)
>  {
>  #if defined(DEBUG) || defined(CONFIG_DYNAMIC_DEBUG)
>  	char *inout;
> @@ -544,7 +551,8 @@ static void mceusb_dev_printdata(struct mceusb_dev *ir, char *buf,
>  		return;
>  
>  	dev_dbg(dev, "%cx data: %*ph (length=%d)",
> -		(out ? 't' : 'r'), min(len, USB_BUFLEN), buf, len);
> +		(out ? 't' : 'r'),
> +		min(len, buf_len - offset), buf + offset, len);
>  
>  	inout = out ? "Request" : "Got";
>  
> @@ -701,7 +709,8 @@ static void mce_async_callback(struct urb *urb)
>  	case 0:
>  		len = urb->actual_length;
>  
> -		mceusb_dev_printdata(ir, urb->transfer_buffer, 0, len, true);
> +		mceusb_dev_printdata(ir, urb->transfer_buffer, len,
> +				     0, len, true);
>  		break;
>  
>  	case -ECONNRESET:
> @@ -721,7 +730,7 @@ static void mce_async_callback(struct urb *urb)
>  	usb_free_urb(urb);
>  }
>  
> -/* request incoming or send outgoing usb packet - used to initialize remote */
> +/* request outgoing (send) usb packet - used to initialize remote */
>  static void mce_request_packet(struct mceusb_dev *ir, unsigned char *data,
>  								int size)
>  {
> @@ -732,7 +741,7 @@ static void mce_request_packet(struct mceusb_dev *ir, unsigned char *data,
>  
>  	async_urb = usb_alloc_urb(0, GFP_KERNEL);
>  	if (unlikely(!async_urb)) {
> -		dev_err(dev, "Error, couldn't allocate urb!\n");
> +		dev_err(dev, "Error, couldn't allocate urb!");
>  		return;
>  	}
>  
> @@ -758,17 +767,17 @@ static void mce_request_packet(struct mceusb_dev *ir, unsigned char *data,
>  	}
>  	memcpy(async_buf, data, size);
>  
> -	dev_dbg(dev, "receive request called (size=%#x)", size);
> +	dev_dbg(dev, "send request called (size=%#x)", size);
>  
>  	async_urb->transfer_buffer_length = size;
>  	async_urb->dev = ir->usbdev;
>  
>  	res = usb_submit_urb(async_urb, GFP_ATOMIC);
>  	if (res) {
> -		dev_err(dev, "receive request FAILED! (res=%d)", res);
> +		dev_err(dev, "send request FAILED! (res=%d)", res);
>  		return;
>  	}
> -	dev_dbg(dev, "receive request complete (res=%d)", res);
> +	dev_dbg(dev, "send request complete (res=%d)", res);
>  }
>  
>  static void mce_async_out(struct mceusb_dev *ir, unsigned char *data, int size)
> @@ -974,7 +983,7 @@ static void mceusb_process_ir_data(struct mceusb_dev *ir, int buf_len)
>  		switch (ir->parser_state) {
>  		case SUBCMD:
>  			ir->rem = mceusb_cmd_datasize(ir->cmd, ir->buf_in[i]);
> -			mceusb_dev_printdata(ir, ir->buf_in, i - 1,
> +			mceusb_dev_printdata(ir, ir->buf_in, buf_len, i - 1,
>  					     ir->rem + 2, false);
>  			mceusb_handle_command(ir, i);
>  			ir->parser_state = CMD_DATA;
> @@ -986,7 +995,7 @@ static void mceusb_process_ir_data(struct mceusb_dev *ir, int buf_len)
>  			rawir.duration = (ir->buf_in[i] & MCE_PULSE_MASK)
>  					 * US_TO_NS(MCE_TIME_UNIT);
>  
> -			dev_dbg(ir->dev, "Storing %s with duration %d",
> +			dev_dbg(ir->dev, "Storing %s with duration %u",
>  				rawir.pulse ? "pulse" : "space",
>  				rawir.duration);
>  
> @@ -1007,7 +1016,7 @@ static void mceusb_process_ir_data(struct mceusb_dev *ir, int buf_len)
>  				continue;
>  			}
>  			ir->rem = (ir->cmd & MCE_PACKET_LENGTH_MASK);
> -			mceusb_dev_printdata(ir, ir->buf_in,
> +			mceusb_dev_printdata(ir, ir->buf_in, buf_len,
>  					     i, ir->rem + 1, false);
>  			if (ir->rem)
>  				ir->parser_state = PARSE_IRDATA;
> @@ -1025,6 +1034,23 @@ static void mceusb_process_ir_data(struct mceusb_dev *ir, int buf_len)
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
> +
>  static void mceusb_dev_recv(struct urb *urb)
>  {
>  	struct mceusb_dev *ir;
> @@ -1052,6 +1078,11 @@ static void mceusb_dev_recv(struct urb *urb)
>  		return;
>  
>  	case -EPIPE:
> +		dev_err(ir->dev, "Error: urb status = %d (RX HALT)",
> +			urb->status);
> +		mceusb_defer_kevent(ir, EVENT_RX_HALT);
> +		return;
> +
>  	default:
>  		dev_err(ir->dev, "Error: urb status = %d", urb->status);
>  		break;
> @@ -1170,6 +1201,37 @@ static void mceusb_flash_led(struct mceusb_dev *ir)
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
> +		usb_unlink_urb(ir->urb_in);
> +		status = usb_clear_halt(ir->usbdev, ir->pipe_in);
> +		if (status < 0) {
> +			dev_err(ir->dev, "rx clear halt error %d",
> +				status);
> +			return;
> +		}
> +		clear_bit(EVENT_RX_HALT, &ir->kevent_flags);
> +		status = usb_submit_urb(ir->urb_in, GFP_ATOMIC);

This can be GFP_KERNEL.

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
> @@ -1336,17 +1398,25 @@ static int mceusb_dev_probe(struct usb_interface *intf,
>  	if (!ir->rc)
>  		goto rc_dev_fail;
>  
> +	ir->pipe_in = pipe;
> +	INIT_WORK(&ir->kevent, mceusb_deferred_kevent);
> +
>  	/* wire up inbound data handler */
> -	usb_fill_int_urb(ir->urb_in, dev, pipe, ir->buf_in, maxp,
> +	if (usb_endpoint_xfer_int(ep_in)) {
> +		usb_fill_int_urb(ir->urb_in, dev, pipe, ir->buf_in, maxp,
>  				mceusb_dev_recv, ir, ep_in->bInterval);
> +	} else {
> +		usb_fill_bulk_urb(ir->urb_in, dev, pipe, ir->buf_in, maxp,
> +				mceusb_dev_recv, ir);
> +	}
>  	ir->urb_in->transfer_dma = ir->dma_in;
>  	ir->urb_in->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
>  
>  	/* flush buffers on the device */
> -	dev_dbg(&intf->dev, "Flushing receive buffers\n");
> +	dev_dbg(&intf->dev, "Flushing receive buffers");
>  	res = usb_submit_urb(ir->urb_in, GFP_KERNEL);
>  	if (res)
> -		dev_err(&intf->dev, "failed to flush buffers: %d\n", res);
> +		dev_err(&intf->dev, "failed to flush buffers: %d", res);
>  
>  	/* figure out which firmware/emulator version this hardware has */
>  	mceusb_get_emulator_version(ir);
> @@ -1405,7 +1475,9 @@ static void mceusb_dev_disconnect(struct usb_interface *intf)
>  		return;
>  
>  	ir->usbdev = NULL;
> +	cancel_work_sync(&ir->kevent);
>  	rc_unregister_device(ir->rc);
> +	rc_free_device(ir->rc);

That change is wrong and will cause a double free.

>  	usb_kill_urb(ir->urb_in);
>  	usb_free_urb(ir->urb_in);
>  	usb_free_coherent(dev, ir->len_in, ir->buf_in, ir->dma_in);

Would you be able to split this into multiple commits please?

Thanks,
Sean
