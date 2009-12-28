Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-px0-f189.google.com ([209.85.216.189]:45998 "EHLO
	mail-px0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975AbZL1JbN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Dec 2009 04:31:13 -0500
Date: Mon, 28 Dec 2009 01:31:06 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jarod Wilson <jarod@redhat.com>
Cc: linux-input@vger.kernel.org, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: imon driver for SoundGraph iMON/Antec Veris IR
 devices
Message-ID: <20091228093106.GA16910@core.coreip.homeip.net>
References: <20091228051155.GA14301@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091228051155.GA14301@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jarod,

On Mon, Dec 28, 2009 at 12:11:55AM -0500, Jarod Wilson wrote:
> This is an input layer driver for the SoundGraph iMON and Antec
> Veris IR and/or Display (LCD/VFD/VGA touchscreen) devices that
> do onboard signal decoding.
> 
> This driver has been baking for quite a while in the lirc tree, as
> lirc_imon, which supported both all the current onboard decoding
> imon devices, as well as some older raw IR ones. I've split support
> into two different drivers now, this one, a pure input driver with
> no ties to lirc at all (device can be used with lircd via its
> userspace devinput driver though) and a pure lirc driver for the
> older devices that don't do onboard decoding. There's a bit of
> code duplication between the two, but not much anymore...
> 
> I did start using *some* of the new sparse keymap code for this
> driver, but I quickly found I really needed more access to the
> raw data (as well as 64-bit hw codes), so I'm really only using
> sparse_keymap_{setup,free} right now, and I've not had cause to
> implement {s,g}etkeycode to date. Work for the future.
> 
> Heavily tested with an Antec Veris Elite (IR + VFD), lightly tested
> with an Antec Veris Premiere (IR + LCD), works quite well on both,
> using both the stock Antec RM-200 remote and a Windows MCE remote
> (as well as with a Logitech Harmony 880 programmed to emulate the
> Antec remote).
> 
> nb: checkpatch.pl has one warning on this patch:
>   WARNING: struct file_operations should normally be const
>   #200: FILE: drivers/input/misc/imon.c:146:
>   +static struct file_operations display_fops = {
> 
>   total: 0 errors, 1 warnings, 2360 lines checked
> 
> We don't make the struct const, because we swap in a new write fop
> if the device has an LCD character display instead of a VFD one.

Why don't you set up separate fops for LCD and mark both const?

> 
> Signed-off-by: Jarod Wilson <jarod@redhat.com>
> 
> ---
>  drivers/input/misc/Kconfig  |   12 +
>  drivers/input/misc/Makefile |    1 +
>  drivers/input/misc/imon.c   | 2131 +++++++++++++++++++++++++++++++++++++++++++
>  drivers/input/misc/imon.h   |  206 +++++
>  4 files changed, 2350 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
> index 16ec523..c0d5f80 100644
> --- a/drivers/input/misc/Kconfig
> +++ b/drivers/input/misc/Kconfig
> @@ -319,4 +319,16 @@ config INPUT_PCAP
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called pcap_keys.
>  
> +config INPUT_IMON
> +	tristate "SoundGraph iMON Receiver and Display"
> +	depends on USB_ARCH_HAS_HCD
> +	select USB
> +	select INPUT_SPARSEKMAP
> +	help
> +	  Say Y here if you want to use a SoundGraph iMON (aka Antec Veris)
> +	  IR Receiver and/or LCD/VFD/VGA display.
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called imon.
> +
>  endif
> diff --git a/drivers/input/misc/Makefile b/drivers/input/misc/Makefile
> index a8b8485..79358ff 100644
> --- a/drivers/input/misc/Makefile
> +++ b/drivers/input/misc/Makefile
> @@ -13,6 +13,7 @@ obj-$(CONFIG_INPUT_CM109)		+= cm109.o
>  obj-$(CONFIG_INPUT_COBALT_BTNS)		+= cobalt_btns.o
>  obj-$(CONFIG_INPUT_DM355EVM)		+= dm355evm_keys.o
>  obj-$(CONFIG_HP_SDC_RTC)		+= hp_sdc_rtc.o
> +obj-$(CONFIG_INPUT_IMON)		+= imon.o
>  obj-$(CONFIG_INPUT_IXP4XX_BEEPER)	+= ixp4xx-beeper.o
>  obj-$(CONFIG_INPUT_KEYSPAN_REMOTE)	+= keyspan_remote.o
>  obj-$(CONFIG_INPUT_M68K_BEEP)		+= m68kspkr.o
> diff --git a/drivers/input/misc/imon.c b/drivers/input/misc/imon.c
> new file mode 100644
> index 0000000..0d7e4ff
> --- /dev/null
> +++ b/drivers/input/misc/imon.c
> @@ -0,0 +1,2131 @@
> +/*
> + *   imon.c:	input and display driver for SoundGraph iMON IR/VFD/LCD
> + *
> + *   Copyright(C) 2009  Jarod Wilson <jarod@wilsonet.com>
> + *   Portions based on the original lirc_imon driver,
> + *	Copyright(C) 2004  Venky Raju(dev@venky.ws)
> + *
> + *   imon is free software; you can redistribute it and/or modify
> + *   it under the terms of the GNU General Public License as published by
> + *   the Free Software Foundation; either version 2 of the License, or
> + *   (at your option) any later version.
> + *
> + *   This program is distributed in the hope that it will be useful,
> + *   but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *   GNU General Public License for more details.
> + *
> + *   You should have received a copy of the GNU General Public License
> + *   along with this program; if not, write to the Free Software
> + *   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> + */
> +
> +#include <linux/errno.h>
> +#include <linux/init.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/slab.h>
> +#include <linux/uaccess.h>
> +#include <linux/input.h>
> +#include <linux/input/sparse-keymap.h>
> +#include <linux/usb.h>
> +#include <linux/usb/input.h>
> +#include <linux/time.h>
> +#include <linux/timer.h>
> +
> +#include "imon.h"
> +
> +
> +#define MOD_AUTHOR	"Jarod Wilson <jarod@wilsonet.com>"
> +#define MOD_DESC	"Driver for SoundGraph iMON MultiMedia IR/Display"
> +#define MOD_NAME	"imon"
> +#define MOD_VERSION	"0.8"
> +
> +#define DISPLAY_MINOR_BASE	144
> +#define DEVICE_NAME	"lcd%d"
> +
> +#define BUF_CHUNK_SIZE	8
> +#define BUF_SIZE	128
> +
> +#define BIT_DURATION	250	/* each bit received is 250us */
> +
> +#define IMON_CLOCK_ENABLE_PACKETS	2
> +#define IMON_KEY_RELEASE_OFFSET		1000
> +
> +/*** P R O T O T Y P E S ***/
> +
> +/* USB Callback prototypes */
> +static int imon_probe(struct usb_interface *interface,
> +		      const struct usb_device_id *id);
> +static void imon_disconnect(struct usb_interface *interface);
> +static void usb_rx_callback_intf0(struct urb *urb);
> +static void usb_rx_callback_intf1(struct urb *urb);
> +static void usb_tx_callback(struct urb *urb);
> +
> +/* suspend/resume support */
> +static int imon_resume(struct usb_interface *intf);
> +static int imon_suspend(struct usb_interface *intf, pm_message_t message);
> +
> +/* Display file_operations function prototypes */
> +static int display_open(struct inode *inode, struct file *file);
> +static int display_close(struct inode *inode, struct file *file);
> +
> +/* VFD write operation */
> +static ssize_t vfd_write(struct file *file, const char *buf,
> +			 size_t n_bytes, loff_t *pos);
> +
> +/* LCD file_operations override function prototypes */
> +static ssize_t lcd_write(struct file *file, const char *buf,
> +			 size_t n_bytes, loff_t *pos);
> +
> +/* Driver init/exit prototypes */
> +static int __init imon_init(void);
> +static void __exit imon_exit(void);

Why are they needed?

> +
> +/*** G L O B A L S ***/
> +
> +struct imon_context {
> +	struct device *dev;
> +	struct usb_device *usbdev_intf0;
> +	/* Newer devices have two interfaces */
> +	struct usb_device *usbdev_intf1;
> +	int display_supported;		/* not all controllers do */
> +	int display_isopen;		/* display port has been opened */
> +	int ir_isopen;			/* IR port open	*/
> +	int ir_isassociating;		/* IR port open for association */

bools for these?

> +	int dev_present_intf0;		/* USB device presence, interface 0 */
> +	int dev_present_intf1;		/* USB device presence, interface 1 */
> +	struct mutex lock;		/* to lock this object */
> +	wait_queue_head_t remove_ok;	/* For unexpected USB disconnects */
> +
> +	struct usb_endpoint_descriptor *rx_endpoint_intf0;
> +	struct usb_endpoint_descriptor *rx_endpoint_intf1;
> +	struct usb_endpoint_descriptor *tx_endpoint;
> +	struct urb *rx_urb_intf0;
> +	struct urb *rx_urb_intf1;
> +	struct urb *tx_urb;
> +	int tx_control;
> +	unsigned char usb_rx_buf[8];
> +	unsigned char usb_tx_buf[8];
> +
> +	struct rx_data {
> +		int count;		/* length of 0 or 1 sequence */
> +		int prev_bit;		/* logic level of sequence */
> +		int initial_space;	/* initial space flag */
> +	} rx;
> +
> +	struct tx_t {
> +		unsigned char data_buf[35];	/* user data buffer */
> +		struct completion finished;	/* wait for write to finish */
> +		atomic_t busy;			/* write in progress */
> +		int status;			/* status of tx completion */
> +	} tx;
> +
> +	int ffdc_dev;			/* is this the overused ffdc ID? */
> +	int ir_protocol;		/* iMON or MCE (RC6) IR protocol? */
> +	struct input_dev *idev;		/* input device for remote */
> +	struct input_dev *touch;	/* input device for touchscreen */
> +	u16 last_keycode;		/* last reported input keycode */
> +	u8 mce_toggle_bit;		/* last mce toggle bit */
> +	int display_type;		/* store the display type */
> +	int pad_mouse;			/* toggle kbd(0)/mouse(1) mode */
> +	int touch_x;			/* x coordinate on touchscreen */
> +	int touch_y;			/* y coordinate on touchscreen */
> +	char name_idev[128];		/* input device name */
> +	char phys_idev[64];		/* input device phys path */
> +	struct timer_list itimer;	/* input device timer, need for rc6 */
> +	char name_touch[128];		/* touch screen name */
> +	char phys_touch[64];		/* touch screen phys path */
> +	struct timer_list ttimer;	/* touch screen timer */
> +};
> +
> +#define TOUCH_TIMEOUT	(HZ/30)
> +#define MCE_TIMEOUT_MS	200
> +
> +/* display file operations. Nb: lcd_write will be subbed in as needed later */
> +static struct file_operations display_fops = {
> +	.owner		= THIS_MODULE,
> +	.open		= &display_open,
> +	.write		= &vfd_write,
> +	.release	= &display_close
> +};
> +
> +enum {
> +	IMON_DISPLAY_TYPE_AUTO = 0,
> +	IMON_DISPLAY_TYPE_VFD  = 1,
> +	IMON_DISPLAY_TYPE_LCD  = 2,
> +	IMON_DISPLAY_TYPE_VGA  = 3,
> +	IMON_DISPLAY_TYPE_NONE = 4,
> +};
> +
> +enum {
> +	IMON_IR_PROTOCOL_IMON       = 0,
> +	IMON_IR_PROTOCOL_MCE        = 1,
> +	IMON_IR_PROTOCOL_IMON_NOPAD = 2,
> +};
> +
> +enum {
> +	IMON_BUTTON_IMON	= 0,
> +	IMON_BUTTON_MCE		= 1,
> +	IMON_BUTTON_PANEL	= 2,
> +};
> +
> +/*
> + * USB Device ID for iMON USB Control Boards
> + *
> + * The Windows drivers contain 6 different inf files, more or less one for
> + * each new device until the 0x0034-0x0046 devices, which all use the same
> + * driver. Some of the devices in the 34-46 range haven't been definitively
> + * identified yet. Early devices have either a TriGem Computer, Inc. or a
> + * Samsung vendor ID (0x0aa8 and 0x04e8 respectively), while all later
> + * devices use the SoundGraph vendor ID (0x15c2). This driver only supports
> + * the ffdc and later devices, which do onboard decoding.
> + */
> +static struct usb_device_id imon_usb_id_table[] = {
> +	/*
> +	 * Several devices with this same device ID, all use iMON_PAD.inf
> +	 * SoundGraph iMON PAD (IR & VFD)
> +	 * SoundGraph iMON PAD (IR & LCD)
> +	 * SoundGraph iMON Knob (IR only)
> +	 */
> +	{ USB_DEVICE(0x15c2, 0xffdc) },
> +
> +	/*
> +	 * Newer devices, all driven by the latest iMON Windows driver, full
> +	 * list of device IDs extracted via 'strings Setup/data1.hdr |grep 15c2'
> +	 * Need user input to fill in details on unknown devices.
> +	 */
> +	/* SoundGraph iMON OEM Touch LCD (IR & 7" VGA LCD) */
> +	{ USB_DEVICE(0x15c2, 0x0034) },
> +	/* SoundGraph iMON OEM Touch LCD (IR & 4.3" VGA LCD) */
> +	{ USB_DEVICE(0x15c2, 0x0035) },
> +	/* SoundGraph iMON OEM VFD (IR & VFD) */
> +	{ USB_DEVICE(0x15c2, 0x0036) },
> +	/* device specifics unknown */
> +	{ USB_DEVICE(0x15c2, 0x0037) },
> +	/* SoundGraph iMON OEM LCD (IR & LCD) */
> +	{ USB_DEVICE(0x15c2, 0x0038) },
> +	/* device specifics unknown */
> +	{ USB_DEVICE(0x15c2, 0x0039) },
> +	/* device specifics unknown */
> +	{ USB_DEVICE(0x15c2, 0x003a) },
> +	/* device specifics unknown */
> +	{ USB_DEVICE(0x15c2, 0x003b) },
> +	/* SoundGraph iMON OEM Inside (IR only) */
> +	{ USB_DEVICE(0x15c2, 0x003c) },
> +	/* device specifics unknown */
> +	{ USB_DEVICE(0x15c2, 0x003d) },
> +	/* device specifics unknown */
> +	{ USB_DEVICE(0x15c2, 0x003e) },
> +	/* device specifics unknown */
> +	{ USB_DEVICE(0x15c2, 0x003f) },
> +	/* device specifics unknown */
> +	{ USB_DEVICE(0x15c2, 0x0040) },
> +	/* SoundGraph iMON MINI (IR only) */
> +	{ USB_DEVICE(0x15c2, 0x0041) },
> +	/* Antec Veris Multimedia Station EZ External (IR only) */
> +	{ USB_DEVICE(0x15c2, 0x0042) },
> +	/* Antec Veris Multimedia Station Basic Internal (IR only) */
> +	{ USB_DEVICE(0x15c2, 0x0043) },
> +	/* Antec Veris Multimedia Station Elite (IR & VFD) */
> +	{ USB_DEVICE(0x15c2, 0x0044) },
> +	/* Antec Veris Multimedia Station Premiere (IR & LCD) */
> +	{ USB_DEVICE(0x15c2, 0x0045) },
> +	/* device specifics unknown */
> +	{ USB_DEVICE(0x15c2, 0x0046) },
> +	{}
> +};
> +
> +/* iMON LCD models use a different write op */
> +static struct usb_device_id lcd_device_list[] = {
> +	{ USB_DEVICE(0x15c2, 0xffdc) },
> +	{ USB_DEVICE(0x15c2, 0x0038) },
> +	{ USB_DEVICE(0x15c2, 0x0045) },
> +	{}
> +};
> +
> +/* Some iMON devices have no lcd/vfd, don't set one up */
> +static struct usb_device_id ir_only_list[] = {
> +	/* the first imon lcd and the knob share this device id. :\ */
> +	/*{ USB_DEVICE(0x15c2, 0xffdc) },*/
> +	{ USB_DEVICE(0x15c2, 0x003c) },
> +	{ USB_DEVICE(0x15c2, 0x0041) },
> +	{ USB_DEVICE(0x15c2, 0x0042) },
> +	{ USB_DEVICE(0x15c2, 0x0043) },
> +	{}
> +};
> +
> +/* iMON devices with VGA touchscreens */
> +static struct usb_device_id imon_touchscreen_list[] = {
> +	{ USB_DEVICE(0x15c2, 0x0034) },
> +	{ USB_DEVICE(0x15c2, 0x0035) },
> +	{}
> +};
> +
> +/* USB Device data */
> +static struct usb_driver imon_driver = {
> +	.name		= MOD_NAME,
> +	.probe		= imon_probe,
> +	.disconnect	= imon_disconnect,
> +	.suspend	= imon_suspend,
> +	.resume		= imon_resume,
> +	.id_table	= imon_usb_id_table,
> +};
> +
> +static struct usb_class_driver imon_class = {
> +	.name		= DEVICE_NAME,
> +	.fops		= &display_fops,
> +	.minor_base	= DISPLAY_MINOR_BASE,
> +};
> +
> +/* to prevent races between open() and disconnect(), probing, etc */
> +static DEFINE_MUTEX(driver_lock);
> +
> +static int debug;
> +
> +/* lcd, vfd, vga or none? should be auto-detected, but can be overridden... */
> +static int display_type;
> +
> +/* IR protocol: native iMON, Windows MCE (RC-6), or iMON w/o PAD stabilize */
> +static int ir_protocol;
> +
> +/*
> + * In certain use cases, mouse mode isn't really helpful, and could actually
> + * cause confusion, so allow disabling it when the IR device is open.
> + */
> +static int nomouse;
> +
> +/* threshold at which a pad push registers as an arrow key in kbd mode */
> +static int pad_thresh;
> +
> +/***  M O D U L E   C O D E ***/
> +
> +MODULE_AUTHOR(MOD_AUTHOR);
> +MODULE_DESCRIPTION(MOD_DESC);
> +MODULE_VERSION(MOD_VERSION);
> +MODULE_LICENSE("GPL");
> +MODULE_DEVICE_TABLE(usb, imon_usb_id_table);
> +module_param(debug, int, S_IRUGO | S_IWUSR);
> +MODULE_PARM_DESC(debug, "Debug messages: 0=no, 1=yes(default: no)");

Bool here. I also prefer keeping module_param() and MODULE_PARM_DESC()
with the definition of the variable.

> +module_param(display_type, int, S_IRUGO);
> +MODULE_PARM_DESC(display_type, "Type of attached display. 0=autodetect, "
> +		 "1=vfd, 2=lcd, 3=vga, 4=none (default: autodetect)");
> +module_param(ir_protocol, int, S_IRUGO | S_IWUSR);
> +MODULE_PARM_DESC(ir_protocol, "Which IR protocol to use. 0=native iMON, "
> +		 "1=Windows Media Center Ed. (RC-6), 2=iMON w/o PAD stabilize "
> +		 "(default: native iMON)");
> +module_param(nomouse, int, S_IRUGO | S_IWUSR);
> +MODULE_PARM_DESC(nomouse, "Disable mouse input device mode when IR device is "
> +		 "open. 0=don't disable, 1=disable. (default: don't disable)");

Bool again.

> +module_param(pad_thresh, int, S_IRUGO | S_IWUSR);
> +MODULE_PARM_DESC(pad_thresh, "Threshold at which a pad push registers as an "
> +		 "arrow key in kbd mode (default: 28)");
> +
> +static void free_imon_context(struct imon_context *context)
> +{
> +	usb_free_urb(context->tx_urb);
> +	usb_free_urb(context->rx_urb_intf0);
> +	usb_free_urb(context->rx_urb_intf1);
> +	kfree(context);
> +
> +	dev_dbg(context->dev, "%s: iMON context freed\n", __func__);
> +}
> +
> +/**
> + * Called when the Display device (e.g. /dev/lcd0)
> + * is opened by the application.
> + */
> +static int display_open(struct inode *inode, struct file *file)
> +{
> +	struct usb_interface *interface;
> +	struct imon_context *context = NULL;
> +	int subminor;
> +	int retval = 0;
> +
> +	/* prevent races with disconnect */
> +	mutex_lock(&driver_lock);
> +
> +	subminor = iminor(inode);
> +	interface = usb_find_interface(&imon_driver, subminor);
> +	if (!interface) {
> +		err("%s: could not find interface for minor %d",
> +		    __func__, subminor);
> +		retval = -ENODEV;
> +		goto exit;
> +	}
> +	context = usb_get_intfdata(interface);
> +
> +	if (!context) {
> +		err("%s: no context found for minor %d",
> +					__func__, subminor);
> +		retval = -ENODEV;
> +		goto exit;
> +	}
> +
> +	mutex_lock(&context->lock);
> +
> +	if (!context->display_supported) {
> +		err("%s: display not supported by device", __func__);
> +		retval = -ENODEV;
> +	} else if (context->display_isopen) {
> +		err("%s: display port is already open", __func__);
> +		retval = -EBUSY;
> +	} else {
> +		context->display_isopen = 1;
> +		file->private_data = context;
> +		dev_info(context->dev, "display port opened\n");
> +	}
> +
> +	mutex_unlock(&context->lock);
> +
> +exit:
> +	mutex_unlock(&driver_lock);
> +	return retval;
> +}
> +
> +/**
> + * Called when the display device (e.g. /dev/lcd0)
> + * is closed by the application.
> + */
> +static int display_close(struct inode *inode, struct file *file)
> +{
> +	struct imon_context *context = NULL;
> +	int retval = 0;
> +
> +	context = (struct imon_context *)file->private_data;
> +
> +	if (!context) {
> +		err("%s: no context for device", __func__);
> +		return -ENODEV;
> +	}
> +
> +	mutex_lock(&context->lock);
> +
> +	if (!context->display_supported) {
> +		err("%s: display not supported by device", __func__);
> +		retval = -ENODEV;
> +	} else if (!context->display_isopen) {
> +		err("%s: display is not open", __func__);
> +		retval = -EIO;
> +	} else {
> +		context->display_isopen = 0;
> +		dev_info(context->dev, "display port closed\n");
> +		if (!context->dev_present_intf0 && !context->ir_isopen) {
> +			/*
> +			 * Device disconnected before close and IR port is not
> +			 * open. If IR port is open, context will be deleted by
> +			 * ir_close.
> +			 */
> +			mutex_unlock(&context->lock);
> +			free_imon_context(context);
> +			return retval;
> +		}
> +	}
> +
> +	mutex_unlock(&context->lock);
> +	return retval;
> +}
> +
> +/**
> + * Sends a packet to the device -- this function must be called
> + * with context->lock held.
> + */
> +static int send_packet(struct imon_context *context)
> +{
> +	unsigned int pipe;
> +	int interval = 0;
> +	int retval = 0;
> +	struct usb_ctrlrequest *control_req = NULL;
> +
> +	/* Check if we need to use control or interrupt urb */
> +	if (!context->tx_control) {
> +		pipe = usb_sndintpipe(context->usbdev_intf0,
> +				      context->tx_endpoint->bEndpointAddress);
> +		interval = context->tx_endpoint->bInterval;
> +
> +		usb_fill_int_urb(context->tx_urb, context->usbdev_intf0, pipe,
> +				 context->usb_tx_buf,
> +				 sizeof(context->usb_tx_buf),
> +				 usb_tx_callback, context, interval);
> +
> +		context->tx_urb->actual_length = 0;
> +	} else {
> +		/* fill request into kmalloc'ed space: */
> +		control_req = kmalloc(sizeof(struct usb_ctrlrequest),
> +				      GFP_KERNEL);
> +		if (control_req == NULL)
> +			return -ENOMEM;
> +
> +		/* setup packet is '21 09 0200 0001 0008' */
> +		control_req->bRequestType = 0x21;
> +		control_req->bRequest = 0x09;
> +		control_req->wValue = cpu_to_le16(0x0200);
> +		control_req->wIndex = cpu_to_le16(0x0001);
> +		control_req->wLength = cpu_to_le16(0x0008);
> +
> +		/* control pipe is endpoint 0x00 */
> +		pipe = usb_sndctrlpipe(context->usbdev_intf0, 0);
> +
> +		/* build the control urb */
> +		usb_fill_control_urb(context->tx_urb, context->usbdev_intf0,
> +				     pipe, (unsigned char *)control_req,
> +				     context->usb_tx_buf,
> +				     sizeof(context->usb_tx_buf),
> +				     usb_tx_callback, context);
> +		context->tx_urb->actual_length = 0;
> +	}
> +
> +	init_completion(&context->tx.finished);
> +	atomic_set(&(context->tx.busy), 1);

What does this atomic give you? Atomic operations do not imply memory
barriers IIRC...

> +
> +	retval = usb_submit_urb(context->tx_urb, GFP_KERNEL);
> +	if (retval) {
> +		atomic_set(&(context->tx.busy), 0);
> +		err("%s: error submitting urb(%d)", __func__, retval);
> +	} else {
> +		/* Wait for transmission to complete (or abort) */
> +		mutex_unlock(&context->lock);
> +		retval = wait_for_completion_interruptible(
> +				&context->tx.finished);
> +		if (retval)
> +			err("%s: task interrupted", __func__);
> +		mutex_lock(&context->lock);
> +
> +		retval = context->tx.status;
> +		if (retval)
> +			err("%s: packet tx failed (%d)", __func__, retval);
> +	}
> +
> +	kfree(control_req);
> +
> +	return retval;
> +}
> +
> +/**
> + * Sends an associate packet to the iMON 2.4G.
> + *
> + * This might not be such a good idea, since it has an id collision with
> + * some versions of the "IR & VFD" combo. The only way to determine if it
> + * is an RF version is to look at the product description string. (Which
> + * we currently do not fetch).
> + */
> +static int send_associate_24g(struct imon_context *context)
> +{
> +	int retval;
> +	const unsigned char packet[8] = { 0x01, 0x00, 0x00, 0x00,
> +					  0x00, 0x00, 0x00, 0x20 };
> +
> +	if (!context) {
> +		err("%s: no context for device", __func__);
> +		return -ENODEV;
> +	}
> +
> +	if (!context->dev_present_intf0) {
> +		err("%s: no iMON device present", __func__);
> +		return -ENODEV;
> +	}
> +
> +	memcpy(context->usb_tx_buf, packet, sizeof(packet));
> +	retval = send_packet(context);
> +
> +	return retval;
> +}
> +
> +/**
> + * Sends packets to setup and show clock on iMON display
> + *
> + * Arguments: year - last 2 digits of year, month - 1..12,
> + * day - 1..31, dow - day of the week (0-Sun...6-Sat),
> + * hour - 0..23, minute - 0..59, second - 0..59
> + */
> +static int send_set_imon_clock(struct imon_context *context,
> +			       unsigned int year, unsigned int month,
> +			       unsigned int day, unsigned int dow,
> +			       unsigned int hour, unsigned int minute,
> +			       unsigned int second)
> +{
> +	unsigned char clock_enable_pkt[IMON_CLOCK_ENABLE_PACKETS][8];
> +	int retval = 0;
> +	int i;
> +
> +	if (!context) {
> +		err("%s: no context for device", __func__);
> +		return -ENODEV;
> +	}
> +
> +	switch (context->display_type) {
> +	case IMON_DISPLAY_TYPE_LCD:
> +		clock_enable_pkt[0][0] = 0x80;
> +		clock_enable_pkt[0][1] = year;
> +		clock_enable_pkt[0][2] = month-1;
> +		clock_enable_pkt[0][3] = day;
> +		clock_enable_pkt[0][4] = hour;
> +		clock_enable_pkt[0][5] = minute;
> +		clock_enable_pkt[0][6] = second;
> +
> +		clock_enable_pkt[1][0] = 0x80;
> +		clock_enable_pkt[1][1] = 0;
> +		clock_enable_pkt[1][2] = 0;
> +		clock_enable_pkt[1][3] = 0;
> +		clock_enable_pkt[1][4] = 0;
> +		clock_enable_pkt[1][5] = 0;
> +		clock_enable_pkt[1][6] = 0;
> +
> +		if (context->ffdc_dev) {
> +			clock_enable_pkt[0][7] = 0x50;
> +			clock_enable_pkt[1][7] = 0x51;
> +		} else {
> +			clock_enable_pkt[0][7] = 0x88;
> +			clock_enable_pkt[1][7] = 0x8a;
> +		}
> +
> +		break;
> +
> +	case IMON_DISPLAY_TYPE_VFD:
> +		clock_enable_pkt[0][0] = year;
> +		clock_enable_pkt[0][1] = month-1;
> +		clock_enable_pkt[0][2] = day;
> +		clock_enable_pkt[0][3] = dow;
> +		clock_enable_pkt[0][4] = hour;
> +		clock_enable_pkt[0][5] = minute;
> +		clock_enable_pkt[0][6] = second;
> +		clock_enable_pkt[0][7] = 0x40;
> +
> +		clock_enable_pkt[1][0] = 0;
> +		clock_enable_pkt[1][1] = 0;
> +		clock_enable_pkt[1][2] = 1;
> +		clock_enable_pkt[1][3] = 0;
> +		clock_enable_pkt[1][4] = 0;
> +		clock_enable_pkt[1][5] = 0;
> +		clock_enable_pkt[1][6] = 0;
> +		clock_enable_pkt[1][7] = 0x42;
> +
> +		break;
> +
> +	default:
> +		return -ENODEV;
> +	}
> +
> +	for (i = 0; i < IMON_CLOCK_ENABLE_PACKETS; i++) {
> +		memcpy(context->usb_tx_buf, clock_enable_pkt[i], 8);
> +		retval = send_packet(context);
> +		if (retval) {
> +			err("%s: send_packet failed for packet %d",
> +			    __func__, i);
> +			break;
> +		}
> +	}
> +
> +	return retval;
> +}
> +
> +/**
> + * These are the sysfs functions to handle the association on the iMON 2.4G LT.
> + */
> +static ssize_t show_associate_remote(struct device *d,
> +				     struct device_attribute *attr,
> +				     char *buf)
> +{
> +	struct imon_context *context = dev_get_drvdata(d);
> +
> +	if (!context)
> +		return -ENODEV;
> +
> +	mutex_lock(&context->lock);
> +	if (context->ir_isassociating)
> +		strcpy(buf, "associating\n");
> +	else if (context->ir_isopen)
> +		strcpy(buf, "open\n");
> +	else
> +		strcpy(buf, "closed\n");
> +
> +	dev_info(d, "Visit http://www.lirc.org/html/imon-24g.html for "
> +		 "instructions on how to associate your iMON 2.4G DT/LT "
> +		 "remote\n");
> +	mutex_unlock(&context->lock);
> +	return strlen(buf);
> +}
> +
> +static ssize_t store_associate_remote(struct device *d,
> +				      struct device_attribute *attr,
> +				      const char *buf, size_t count)
> +{
> +	struct imon_context *context;
> +
> +	context = dev_get_drvdata(d);
> +
> +	if (!context)
> +		return -ENODEV;
> +
> +	mutex_lock(&context->lock);
> +	if (!context->ir_isopen) {
> +		mutex_unlock(&context->lock);
> +		return -EINVAL;
> +	}
> +
> +	if (context->ir_isopen) {
> +		context->ir_isassociating = 1;
> +		send_associate_24g(context);
> +	}
> +	mutex_unlock(&context->lock);
> +
> +	return count;
> +}
> +
> +/**
> + * sysfs functions to control internal imon clock
> + */
> +static ssize_t show_imon_clock(struct device *d,
> +			       struct device_attribute *attr, char *buf)
> +{
> +	struct imon_context *context = dev_get_drvdata(d);
> +	size_t len;
> +
> +	if (!context)
> +		return -ENODEV;
> +
> +	mutex_lock(&context->lock);
> +
> +	if (!context->display_supported) {
> +		len = snprintf(buf, PAGE_SIZE, "Not supported.");
> +	} else {
> +		len = snprintf(buf, PAGE_SIZE,
> +			"To set the clock on your iMON display:\n"
> +			"# date \"+%%y %%m %%d %%w %%H %%M %%S\" > imon_clock\n"
> +			"%s", context->display_isopen ?
> +			"\nNOTE: imon device must be closed\n" : "");
> +	}
> +
> +	mutex_unlock(&context->lock);
> +
> +	return len;
> +}
> +
> +static ssize_t store_imon_clock(struct device *d,
> +				struct device_attribute *attr,
> +				const char *buf, size_t count)
> +{
> +	struct imon_context *context = dev_get_drvdata(d);
> +	ssize_t retval;
> +	unsigned int year, month, day, dow, hour, minute, second;
> +
> +	if (!context)
> +		return -ENODEV;
> +
> +	mutex_lock(&context->lock);
> +
> +	if (!context->display_supported) {
> +		retval = -ENODEV;
> +		goto exit;
> +	} else if (context->display_isopen) {
> +		retval = -EBUSY;
> +		goto exit;
> +	}
> +
> +	if (sscanf(buf, "%u %u %u %u %u %u %u",	&year, &month, &day, &dow,
> +		   &hour, &minute, &second) != 7) {
> +		retval = -EINVAL;
> +		goto exit;
> +	}
> +
> +	if ((month < 1 || month > 12) ||
> +	    (day < 1 || day > 31) || (dow > 6) ||
> +	    (hour > 23) || (minute > 59) || (second > 59)) {
> +		retval = -EINVAL;
> +		goto exit;
> +	}
> +
> +	retval = send_set_imon_clock(context, year, month, day, dow,
> +				     hour, minute, second);
> +	if (retval)
> +		goto exit;
> +
> +	retval = count;
> +exit:
> +	mutex_unlock(&context->lock);
> +
> +	return retval;
> +}
> +
> +
> +static DEVICE_ATTR(imon_clock, S_IWUSR | S_IRUGO, show_imon_clock,
> +		   store_imon_clock);
> +
> +static DEVICE_ATTR(associate_remote, S_IWUSR | S_IRUGO, show_associate_remote,
> +		   store_associate_remote);
> +
> +static struct attribute *imon_display_sysfs_entries[] = {
> +	&dev_attr_imon_clock.attr,
> +	NULL
> +};
> +
> +static struct attribute_group imon_display_attribute_group = {
> +	.attrs = imon_display_sysfs_entries
> +};
> +
> +static struct attribute *imon_rf_sysfs_entries[] = {
> +	&dev_attr_associate_remote.attr,
> +	NULL
> +};
> +
> +static struct attribute_group imon_rf_attribute_group = {
> +	.attrs = imon_rf_sysfs_entries
> +};
> +
> +/**
> + * Writes data to the VFD.  The iMON VFD is 2x16 characters
> + * and requires data in 5 consecutive USB interrupt packets,
> + * each packet but the last carrying 7 bytes.
> + *
> + * I don't know if the VFD board supports features such as
> + * scrolling, clearing rows, blanking, etc. so at
> + * the caller must provide a full screen of data.  If fewer
> + * than 32 bytes are provided spaces will be appended to
> + * generate a full screen.
> + */
> +static ssize_t vfd_write(struct file *file, const char *buf,
> +			 size_t n_bytes, loff_t *pos)
> +{
> +	int i;
> +	int offset;
> +	int seq;
> +	int retval = 0;
> +	struct imon_context *context;
> +	const unsigned char vfd_packet6[] = {
> +		0x01, 0x00, 0x00, 0x00, 0x00, 0xFF, 0xFF };
> +
> +	context = (struct imon_context *)file->private_data;
> +	if (!context) {
> +		err("%s: no context for device", __func__);
> +		return -ENODEV;
> +	}
> +
> +	mutex_lock(&context->lock);
> +
> +	if (!context->dev_present_intf0) {
> +		err("%s: no iMON device present", __func__);
> +		retval = -ENODEV;
> +		goto exit;
> +	}
> +
> +	if (n_bytes <= 0 || n_bytes > 32) {
> +		err("%s: invalid payload size", __func__);
> +		retval = -EINVAL;
> +		goto exit;
> +	}
> +
> +	if (copy_from_user(context->tx.data_buf, buf, n_bytes)) {
> +		retval = -EFAULT;
> +		goto exit;
> +	}
> +
> +	/* Pad with spaces */
> +	for (i = n_bytes; i < 32; ++i)
> +		context->tx.data_buf[i] = ' ';
> +
> +	for (i = 32; i < 35; ++i)
> +		context->tx.data_buf[i] = 0xFF;
> +
> +	offset = 0;
> +	seq = 0;
> +
> +	do {
> +		memcpy(context->usb_tx_buf, context->tx.data_buf + offset, 7);
> +		context->usb_tx_buf[7] = (unsigned char) seq;
> +
> +		retval = send_packet(context);
> +		if (retval) {
> +			err("%s: send packet failed for packet #%d",
> +					__func__, seq/2);
> +			goto exit;
> +		} else {
> +			seq += 2;
> +			offset += 7;
> +		}
> +
> +	} while (offset < 35);
> +
> +	/* Send packet #6 */
> +	memcpy(context->usb_tx_buf, &vfd_packet6, sizeof(vfd_packet6));
> +	context->usb_tx_buf[7] = (unsigned char) seq;
> +	retval = send_packet(context);
> +	if (retval)
> +		err("%s: send packet failed for packet #%d",
> +		    __func__, seq / 2);
> +
> +exit:
> +	mutex_unlock(&context->lock);
> +
> +	return (!retval) ? n_bytes : retval;
> +}
> +
> +/**
> + * Writes data to the LCD.  The iMON OEM LCD screen excepts 8-byte
> + * packets. We accept data as 16 hexadecimal digits, followed by a
> + * newline (to make it easy to drive the device from a command-line
> + * -- even though the actual binary data is a bit complicated).
> + *
> + * The device itself is not a "traditional" text-mode display. It's
> + * actually a 16x96 pixel bitmap display. That means if you want to
> + * display text, you've got to have your own "font" and translate the
> + * text into bitmaps for display. This is really flexible (you can
> + * display whatever diacritics you need, and so on), but it's also
> + * a lot more complicated than most LCDs...
> + */
> +static ssize_t lcd_write(struct file *file, const char *buf,
> +			 size_t n_bytes, loff_t *pos)
> +{
> +	int retval = 0;
> +	struct imon_context *context;
> +
> +	context = (struct imon_context *)file->private_data;
> +	if (!context) {
> +		err("%s: no context for device", __func__);
> +		return -ENODEV;
> +	}
> +
> +	mutex_lock(&context->lock);
> +
> +	if (!context->display_supported) {
> +		err("%s: no iMON display present", __func__);
> +		retval = -ENODEV;
> +		goto exit;
> +	}
> +
> +	if (n_bytes != 8) {
> +		err("%s: invalid payload size: %d (expecting 8)",
> +		    __func__, (int) n_bytes);
> +		retval = -EINVAL;
> +		goto exit;
> +	}
> +
> +	if (copy_from_user(context->usb_tx_buf, buf, 8)) {
> +		retval = -EFAULT;
> +		goto exit;
> +	}
> +
> +	retval = send_packet(context);
> +	if (retval) {
> +		err("%s: send packet failed!", __func__);
> +		goto exit;
> +	} else {
> +		dev_dbg(context->dev, "%s: write %d bytes to LCD\n",
> +			__func__, (int) n_bytes);
> +	}
> +exit:
> +	mutex_unlock(&context->lock);
> +	return (!retval) ? n_bytes : retval;
> +}
> +
> +/**
> + * Callback function for USB core API: transmit data
> + */
> +static void usb_tx_callback(struct urb *urb)
> +{
> +	struct imon_context *context;
> +
> +	if (!urb)
> +		return;
> +	context = (struct imon_context *)urb->context;
> +	if (!context)
> +		return;
> +
> +	context->tx.status = urb->status;
> +
> +	/* notify waiters that write has finished */
> +	atomic_set(&context->tx.busy, 0);
> +	complete(&context->tx.finished);
> +
> +	return;
> +}
> +
> +/**
> + * iMON IR receivers support two different signal sets -- those used by
> + * the iMON remotes, and those used by the Windows MCE remotes (which is
> + * really just RC-6), but only one or the other at a time, as the signals
> + * are decoded onboard the receiver.
> + */
> +static void imon_set_ir_protocol(struct imon_context *context)
> +{
> +	int retval;
> +	struct device *dev = context->dev;
> +	unsigned char ir_proto_packet[] = {
> +		0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x86 };
> +
> +	switch (ir_protocol) {
> +	case IMON_IR_PROTOCOL_MCE:
> +		dev_dbg(dev, "Configuring IR receiver for MCE protocol\n");
> +		ir_proto_packet[0] = 0x01;
> +		context->ir_protocol = IMON_IR_PROTOCOL_MCE;
> +		context->pad_mouse = 0;
> +		break;
> +	case IMON_IR_PROTOCOL_IMON:
> +		dev_dbg(dev, "Configuring IR receiver for iMON protocol\n");
> +		/* ir_proto_packet[0] = 0x00; // already the default */
> +		context->ir_protocol = IMON_IR_PROTOCOL_IMON;
> +		context->pad_mouse = 1;
> +		break;
> +	case IMON_IR_PROTOCOL_IMON_NOPAD:
> +		dev_dbg(dev, "Configuring IR receiver for iMON protocol "
> +			"without PAD stabilize function enabled\n");
> +		/* ir_proto_packet[0] = 0x00; // already the default */
> +		context->ir_protocol = IMON_IR_PROTOCOL_IMON_NOPAD;
> +		context->pad_mouse = 0;
> +		break;
> +	default:
> +		dev_info(dev, "%s: unknown IR protocol specified, will "
> +			 "just default to iMON protocol\n", __func__);
> +		context->ir_protocol = IMON_IR_PROTOCOL_IMON;
> +		context->pad_mouse = 1;
> +		break;
> +	}
> +
> +	memcpy(context->usb_tx_buf, &ir_proto_packet, sizeof(ir_proto_packet));
> +
> +	retval = send_packet(context);
> +	if (retval) {
> +		dev_info(dev, "%s: failed to set IR protocol, falling back "
> +			 "to standard iMON protocol mode\n", __func__);
> +		ir_protocol = IMON_IR_PROTOCOL_IMON;
> +		context->ir_protocol = IMON_IR_PROTOCOL_IMON;
> +	}
> +
> +	return;
> +}
> +
> +static inline int tv2int(const struct timeval *a, const struct timeval *b)
> +{
> +	int usecs = 0;
> +	int sec   = 0;
> +
> +	if (b->tv_usec > a->tv_usec) {
> +		usecs = 1000000;
> +		sec--;
> +	}
> +
> +	usecs += a->tv_usec - b->tv_usec;
> +
> +	sec += a->tv_sec - b->tv_sec;
> +	sec *= 1000;
> +	usecs /= 1000;
> +	sec += usecs;
> +
> +	if (sec < 0)
> +		sec = 1000;
> +
> +	return sec;
> +}
> +
> +/**
> + * The directional pad behaves a bit differently, depending on whether this is
> + * one of the older ffdc devices or a newer device. Newer devices appear to
> + * have a higher resolution matrix for more precise mouse movement, but it
> + * makes things overly sensitive in keyboard mode, so we do some interesting
> + * contortions to make it less touchy. Older devices run through the same
> + * routine with shorter timeout and a smaller threshold.
> + */
> +static int stabilize(int a, int b, u16 timeout, u16 threshold)
> +{
> +	struct timeval ct;
> +	static struct timeval prev_time = {0, 0};
> +	static struct timeval hit_time  = {0, 0};
> +	static int x, y, prev_result, hits;
> +	int result = 0;
> +	int msec, msec_hit;
> +
> +	do_gettimeofday(&ct);
> +	msec = tv2int(&ct, &prev_time);
> +	msec_hit = tv2int(&ct, &hit_time);
> +
> +	if (msec > 100) {
> +		x = 0;
> +		y = 0;
> +		hits = 0;
> +	}
> +
> +	x += a;
> +	y += b;
> +
> +	prev_time = ct;
> +
> +	if (abs(x) > threshold || abs(y) > threshold) {
> +		if (abs(y) > abs(x))
> +			result = (y > 0) ? 0x7F : 0x80;
> +		else
> +			result = (x > 0) ? 0x7F00 : 0x8000;
> +
> +		x = 0;
> +		y = 0;
> +
> +		if (result == prev_result) {
> +			hits++;
> +
> +			if (hits > 3) {
> +				switch (result) {
> +				case 0x7F:
> +					y = 17 * threshold / 30;
> +					break;
> +				case 0x80:
> +					y -= 17 * threshold / 30;
> +					break;
> +				case 0x7F00:
> +					x = 17 * threshold / 30;
> +					break;
> +				case 0x8000:
> +					x -= 17 * threshold / 30;
> +					break;
> +				}
> +			}
> +
> +			if (hits == 2 && msec_hit < timeout) {
> +				result = 0;
> +				hits = 1;
> +			}
> +		} else {
> +			prev_result = result;
> +			hits = 1;
> +			hit_time = ct;
> +		}
> +	}
> +
> +	return result;
> +}
> +
> +static int imon_remote_key_lookup(u32 hw_code)
> +{
> +	int i;
> +	u32 code = be32_to_cpu(hw_code);
> +
> +	/* Look for the initial press of a button */
> +	for (i = 0; i < ARRAY_SIZE(imon_remote_key_table); i++)
> +		if (imon_remote_key_table[i].code == code)
> +			return i;
> +
> +	/* Look for the release of a button, return index + offset */
> +	for (i = 0; i < ARRAY_SIZE(imon_remote_key_table); i++)
> +		if ((imon_remote_key_table[i].code | 0x4000) == code)
> +			return i + IMON_KEY_RELEASE_OFFSET;
> +
> +	return -1;
> +}
> +
> +static int imon_mce_key_lookup(u32 hw_code)
> +{
> +	int i;
> +	u32 code = be32_to_cpu(hw_code);
> +
> +	for (i = 0; i < ARRAY_SIZE(imon_mce_key_table); i++)
> +		if (imon_mce_key_table[i].code == code)
> +			return i;
> +
> +	for (i = 0; i < ARRAY_SIZE(imon_mce_key_table); i++)
> +		if (imon_mce_key_table[i].code == (code | 0x8000))
> +			return i;
> +
> +	return -1;
> +}
> +
> +static int imon_panel_key_lookup(u64 hw_code)
> +{
> +	int i;
> +	u64 code = be64_to_cpu(hw_code);
> +
> +	for (i = 0; i < ARRAY_SIZE(imon_panel_key_table); i++)
> +		if (imon_panel_key_table[i].hw_code == (code | 0xfee))
> +			return i;
> +
> +	return -1;
> +}
> +
> +/**
> + * Process the incoming packet
> + */
> +static void imon_incoming_packet(struct imon_context *context,
> +				 struct urb *urb, int intf)
> +{
> +	int len = urb->actual_length;
> +	unsigned char *buf = urb->transfer_buffer;
> +	struct device *dev = context->dev;
> +	char rel_x = 0x00, rel_y = 0x00;
> +	int ts_input = 0;
> +	int dir = 0;
> +	u16 timeout, threshold;
> +	u16 kc;
> +	u16 norelease = 0;
> +	int i, k;
> +	int offset = IMON_KEY_RELEASE_OFFSET;
> +	u32 remote_key = 0;
> +	u64 panel_key = 0;
> +	int mouse_input;
> +	int right_shift = 1;
> +	struct input_dev *idev = NULL;
> +	struct input_dev *touch = NULL;
> +	int press_type = 0;
> +	int msec;
> +	struct timeval t;
> +	static struct timeval prev_time = { 0, 0 };
> +	int ksrc = IMON_BUTTON_IMON;
> +
> +	idev = context->idev;
> +	if (context->display_type == IMON_DISPLAY_TYPE_VGA)
> +		touch = context->touch;
> +
> +	/* Figure out what key was pressed */
> +	if (len == 8 && buf[7] == 0xee) {
> +		ksrc = IMON_BUTTON_PANEL;
> +		memcpy(&panel_key, buf, len);
> +		k = imon_panel_key_lookup(panel_key);
> +		kc = imon_panel_key_table[k].keycode;
> +	} else {
> +		memcpy(&remote_key, buf, sizeof(remote_key));

Hm, will this work on big-endian?

> +		if (context->ir_protocol == IMON_IR_PROTOCOL_MCE) {
> +			if (buf[0] == 0x80)
> +				ksrc = IMON_BUTTON_MCE;
> +			k = imon_mce_key_lookup(remote_key);
> +			kc = imon_mce_key_table[k].keycode;
> +		} else {
> +			k = imon_remote_key_lookup(remote_key);
> +			kc = imon_remote_key_table[k % offset].keycode;
> +		}
> +	}
> +
> +	/* keyboard/mouse mode toggle button */
> +	if (kc == KEY_KEYBOARD && k < offset) {
> +		if (!nomouse) {
> +			context->pad_mouse = ~(context->pad_mouse) & 0x1;
> +			dev_dbg(dev, "toggling to %s mode\n",
> +				context->pad_mouse ? "mouse" : "keyboard");
> +		} else {
> +			context->pad_mouse = 0;
> +			dev_dbg(dev, "mouse mode was disabled by modparam\n");
> +		}
> +		context->last_keycode = kc;
> +		return;
> +	}
> +
> +	/* send touchscreen events through input subsystem if touchpad data */
> +	if (context->display_type == IMON_DISPLAY_TYPE_VGA && len == 8 &&
> +	    buf[7] == 0x86) {
> +		if (touch == NULL) {
> +			dev_warn(dev, "%s: touchscreen input device is "
> +				 "NULL!\n", __func__);
> +			return;
> +		}
> +		mod_timer(&context->ttimer, jiffies + TOUCH_TIMEOUT);
> +		context->touch_x = (buf[0] << 4) | (buf[1] >> 4);
> +		context->touch_y = 0xfff - ((buf[2] << 4) | (buf[1] & 0xf));
> +		input_report_abs(touch, ABS_X, context->touch_x);
> +		input_report_abs(touch, ABS_Y, context->touch_y);
> +		input_report_key(touch, BTN_TOUCH, 0x01);
> +		input_sync(touch);
> +		ts_input = 1;
> +
> +	/* send mouse events through input subsystem in mouse mode */
> +	} else if (context->pad_mouse) {
> +		/* newer iMON device PAD or mouse button */
> +		if (!context->ffdc_dev && (buf[0] & 0x01) && len == 5) {
> +			mouse_input = 1;
> +			rel_x = buf[2];
> +			rel_y = buf[3];
> +			right_shift = 1;
> +		/* 0xffdc iMON PAD or mouse button input */
> +		} else if (context->ffdc_dev && (buf[0] & 0x40) &&
> +			   !((buf[1] & 0x01) || ((buf[1] >> 2) & 0x01))) {
> +			mouse_input = 1;
> +			rel_x = (buf[1] & 0x08) | (buf[1] & 0x10) >> 2 |
> +				(buf[1] & 0x20) >> 4 | (buf[1] & 0x40) >> 6;
> +			if (buf[0] & 0x02)
> +				rel_x |= ~0x0f;
> +			rel_x = rel_x + rel_x / 2;
> +			rel_y = (buf[2] & 0x08) | (buf[2] & 0x10) >> 2 |
> +				(buf[2] & 0x20) >> 4 | (buf[2] & 0x40) >> 6;
> +			if (buf[0] & 0x01)
> +				rel_y |= ~0x0f;
> +			rel_y = rel_y + rel_y / 2;
> +			right_shift = 2;
> +		/* some ffdc devices decode mouse buttons differently... */
> +		} else if (context->ffdc_dev && (buf[0] == 0x68)) {
> +			mouse_input = 1;
> +			right_shift = 2;
> +		/* ch+/- buttons, which we use for an emulated scroll wheel */
> +		} else if (kc == KEY_CHANNELUP && (buf[2] & 0x40) != 0x40) {
> +			mouse_input = 1;
> +			dir = 1;
> +		} else if (kc == KEY_CHANNELDOWN && (buf[2] & 0x40) != 0x40) {
> +			mouse_input = 1;
> +			dir = -1;
> +		} else
> +			mouse_input = 0;
> +
> +		if (mouse_input) {
> +			if (idev == NULL) {
> +				dev_warn(dev, "%s: idev input device "
> +					 "is NULL!\n", __func__);
> +				return;
> +			}
> +			dev_dbg(context->dev,
> +				"sending mouse data via input subsystem\n");
> +
> +			if (dir) {
> +				input_report_rel(idev, REL_WHEEL, dir);
> +			} else if (rel_x || rel_y) {
> +				input_report_rel(idev, REL_X, rel_x);
> +				input_report_rel(idev, REL_Y, rel_y);
> +			} else {
> +				input_report_key(idev, BTN_LEFT, buf[1] & 0x1);
> +				input_report_key(idev, BTN_RIGHT,
> +						 buf[1] >> right_shift & 0x1);
> +			}
> +			input_sync(idev);
> +			context->last_keycode = kc;
> +			return;
> +		}
> +	}
> +
> +	/* Now for some special handling to convert pad input to arrow keys */
> +	if ((len == 5) && (buf[0] == 0x01) && (buf[4] == 0x00)) {
> +		/* first, pad to 8 bytes so it conforms with everything else */
> +		buf[5] = buf[6] = buf[7] = 0;
> +		len = 8;
> +		timeout = 500;	/* in msecs */
> +		/* (2*threshold) x (2*threshold) square */
> +		threshold = pad_thresh ? pad_thresh : 28;
> +		rel_x = buf[2];
> +		rel_y = buf[3];
> +
> +		/*
> +		 * the imon directional pad functions more like a touchpad.
> +		 * Bytes 3 & 4 contain a position coordinate (x,y), with each
> +		 * component ranging from -14 to 14. Since this doesn't
> +		 * cooperate well with the way lirc works (it would appear to
> +		 * lirc as more than 100 different buttons) we need to map it
> +		 * to 4 discrete values. Also, when you get too close to
> +		 * diagonals, it has a tendancy to jump back and forth, so lets
> +		 * try to ignore when they get too close
> +		 */
> +		if (context->ir_protocol == IMON_IR_PROTOCOL_IMON) {
> +			if ((buf[1] == 0) && ((rel_x != 0) || (rel_y != 0))) {
> +				dir = stabilize((int)rel_x, (int)rel_y,
> +						timeout, threshold);
> +				if (!dir)
> +					return;
> +				buf[2] = dir & 0xFF;
> +				buf[3] = (dir >> 8) & 0xFF;
> +				memcpy(&remote_key, buf, sizeof(remote_key));
> +				k = imon_remote_key_lookup(remote_key);
> +				kc = imon_remote_key_table[k % offset].keycode;
> +			}
> +		} else {
> +			if (abs(rel_y) > abs(rel_x)) {
> +				buf[2] = (rel_y > 0) ? 0x7F : 0x80;
> +				buf[3] = 0;
> +				kc = (rel_y > 0) ? KEY_DOWN : KEY_UP;
> +			} else {
> +				buf[2] = 0;
> +				buf[3] = (rel_x > 0) ? 0x7F : 0x80;
> +				kc = (rel_x > 0) ? KEY_RIGHT : KEY_LEFT;
> +			}
> +		}
> +		norelease = 1;
> +
> +	} else if ((len == 8) && (buf[0] & 0x40) &&
> +		   !(buf[1] & 0x01 || buf[1] >> 2 & 0x01)) {
> +		/*
> +		 * Handle on-board decoded pad events for e.g. older
> +		 * VFD/iMON-Pad (15c2:ffdc). The remote generates various codes
> +		 * from 0x68nnnnB7 to 0x6AnnnnB7, the left mouse button
> +		 * generates 0x688301b7 and the right one 0x688481b7. All other
> +		 * keys generate 0x2nnnnnnn. Length has been padded to 8
> +		 * already, position coordinate is encoded in buf[1] and buf[2]
> +		 * with reversed endianess. Extract direction from buffer,
> +		 * rotate endianess, adjust sign and feed the values into
> +		 * stabilize(). The resulting codes will be 0x01008000,
> +		 * 0x01007F00, ..., so one can use the normal imon-pad config
> +		 * from the remotes dir.
> +		 */
> +		timeout = 10;	/* in msecs */
> +		/* (2*threshold) x (2*threshold) square */
> +		threshold = pad_thresh ? pad_thresh : 15;
> +
> +		/* buf[1] is x */
> +		rel_x = (buf[1] & 0x08) | (buf[1] & 0x10) >> 2 |
> +			(buf[1] & 0x20) >> 4 | (buf[1] & 0x40) >> 6;
> +		if (buf[0] & 0x02)
> +			rel_x |= ~0x10+1;
> +		/* buf[2] is y */
> +		rel_y = (buf[2] & 0x08) | (buf[2] & 0x10) >> 2 |
> +			(buf[2] & 0x20) >> 4 | (buf[2] & 0x40) >> 6;
> +		if (buf[0] & 0x01)
> +			rel_y |= ~0x10+1;
> +
> +		buf[0] = 0x01;
> +		buf[1] = buf[4] = buf[5] = buf[6] = buf[7] = 0;
> +
> +		if (context->ir_protocol == IMON_IR_PROTOCOL_IMON) {
> +			dir = stabilize((int)rel_x, (int)rel_y,
> +					timeout, threshold);
> +			if (!dir)
> +				return;
> +			buf[2] = dir & 0xFF;
> +			buf[3] = (dir >> 8) & 0xFF;
> +		} else {
> +			if (abs(rel_y) > abs(rel_x)) {
> +				buf[2] = (rel_y > 0) ? 0x7F : 0x80;
> +				buf[3] = 0;
> +				kc = (rel_y > 0) ? KEY_DOWN : KEY_UP;
> +			} else {
> +				buf[2] = 0;
> +				buf[3] = (rel_x > 0) ? 0x7F : 0x80;
> +				kc = (rel_x > 0) ? KEY_RIGHT : KEY_LEFT;
> +			}
> +		}
> +		norelease = 1;
> +
> +	} else if (ts_input) {
> +		/*
> +		 * this is touchscreen input, which we need to down-sample
> +		 * to a 64 button matrix at the moment...
> +		 */
> +		buf[0] = buf[0] >> 5;
> +		buf[1] = 0x00;
> +		buf[2] = buf[2] >> 5;
> +		buf[3] = 0x00;
> +		buf[4] = 0x00;
> +		buf[5] = 0x00;
> +		buf[6] = 0x14;
> +		buf[7] = 0xff;
> +	}
> +
> +	if (debug) {
> +		printk(KERN_INFO "intf%d decoded packet: ", intf);
> +		for (i = 0; i < len; ++i)
> +			printk("%02x ", buf[i]);
> +		printk("\n");
> +	}
> +
> +	/* key release of 0x02XXXXXX key */
> +	if (k == -1 && buf[0] == 0x02 && buf[3] == 0x00)
> +		kc = context->last_keycode;
> +
> +	/* mce-specific button handling */
> +	else if (ksrc == IMON_BUTTON_MCE) {
> +		/* initial press */
> +		if (kc != context->last_keycode
> +		    || buf[2] != context->mce_toggle_bit) {
> +			context->last_keycode = kc;
> +			context->mce_toggle_bit = buf[2];
> +			press_type = 1;
> +			mod_timer(&context->itimer,
> +				  jiffies + msecs_to_jiffies(MCE_TIMEOUT_MS));
> +		/* repeat */
> +		} else {
> +			press_type = 2;
> +			mod_timer(&context->itimer,
> +				  jiffies + msecs_to_jiffies(MCE_TIMEOUT_MS));
> +		}
> +
> +	/* incoherent or irrelevant data */
> +	} else if (k == -1)
> +		goto not_input_data;
> +
> +	/* key release of 0xXXXXXXb7 key */
> +	else if (k >= IMON_KEY_RELEASE_OFFSET)
> +		press_type = 0;
> +
> +	/* this is a button press */
> +	else
> +		press_type = 1;
> +
> +	/* KEY_MUTE repeats from MCE and knob need to be suppressed */
> +	if ((kc == KEY_MUTE && kc == context->last_keycode)
> +	    && (buf[7] == 0xee || ksrc == IMON_BUTTON_MCE)) {
> +		do_gettimeofday(&t);
> +		msec = tv2int(&t, &prev_time);
> +		prev_time = t;
> +		if (msec < 200)
> +			return;
> +	}
> +
> +	input_report_key(idev, kc, press_type);
> +	input_sync(idev);
> +
> +	/* panel keys and some remote keys don't generate a release */
> +	if (panel_key || norelease) {
> +		input_report_key(idev, kc, 0);
> +		input_sync(idev);
> +	}
> +
> +	context->last_keycode = kc;
> +
> +	return;
> +
> +not_input_data:
> +	if (len != 8) {
> +		dev_warn(dev, "imon %s: invalid incoming packet "
> +			 "size (len = %d, intf%d)\n", __func__, len, intf);
> +		return;
> +	}
> +
> +	/* iMON 2.4G associate frame */
> +	if (buf[0] == 0x00 &&
> +	    buf[2] == 0xFF &&				/* REFID */
> +	    buf[3] == 0xFF &&
> +	    buf[4] == 0xFF &&
> +	    buf[5] == 0xFF &&				/* iMON 2.4G */
> +	   ((buf[6] == 0x4E && buf[7] == 0xDF) ||	/* LT */
> +	    (buf[6] == 0x5E && buf[7] == 0xDF))) {	/* DT */
> +		dev_warn(dev, "%s: remote associated refid=%02X\n",
> +			 __func__, buf[1]);
> +		context->ir_isassociating = 0;
> +	}
> +
> +	return;
> +}
> +
> +/**
> + * mce/rc6 keypresses have no distinct release code, use timer
> + */
> +static void imon_mce_timeout(unsigned long data)
> +{
> +	struct imon_context *context = (struct imon_context *)data;
> +
> +	input_report_key(context->idev, context->last_keycode, 0);
> +	input_sync(context->idev);
> +
> +	return;

No empty returns please.

> +}
> +
> +/**
> + * report touchscreen input
> + */
> +static void imon_touch_display_timeout(unsigned long data)
> +{
> +	struct imon_context *context = (struct imon_context *)data;
> +	struct input_dev *touch;
> +
> +	if (!context->display_type == IMON_DISPLAY_TYPE_VGA)
> +		return;
> +
> +	touch = context->touch;
> +	input_report_abs(touch, ABS_X, context->touch_x);
> +	input_report_abs(touch, ABS_Y, context->touch_y);
> +	input_report_key(touch, BTN_TOUCH, 0x00);
> +	input_sync(touch);
> +
> +	return;
> +}
> +
> +/**
> + * Callback function for USB core API: receive data
> + */
> +static void usb_rx_callback_intf0(struct urb *urb)
> +{
> +	struct imon_context *context;
> +	unsigned char *buf;
> +	int len;
> +	int intfnum = 0;
> +
> +	if (!urb)
> +		return;
> +
> +	context = (struct imon_context *)urb->context;
> +	if (!context)
> +		return;
> +
> +	buf = urb->transfer_buffer;
> +	len = urb->actual_length;
> +
> +	switch (urb->status) {
> +	case -ENOENT:		/* usbcore unlink successful! */
> +		return;
> +
> +	case 0:
> +		imon_incoming_packet(context, urb, intfnum);
> +		break;
> +
> +	default:
> +		dev_warn(context->dev, "imon %s: status(%d): ignored\n",
> +			 __func__, urb->status);
> +		break;
> +	}
> +
> +	usb_submit_urb(context->rx_urb_intf0, GFP_ATOMIC);
> +
> +	return;
> +}
> +
> +static void usb_rx_callback_intf1(struct urb *urb)
> +{
> +	struct imon_context *context;
> +	unsigned char *buf;
> +	int len;
> +	int intfnum = 1;
> +
> +	if (!urb)
> +		return;
> +
> +	context = (struct imon_context *)urb->context;
> +	if (!context)
> +		return;
> +
> +	buf = urb->transfer_buffer;
> +	len = urb->actual_length;
> +
> +	switch (urb->status) {
> +	case -ENOENT:		/* usbcore unlink successful! */
> +		return;
> +
> +	case 0:
> +		imon_incoming_packet(context, urb, intfnum);
> +		break;
> +
> +	default:
> +		dev_warn(context->dev, "imon %s: status(%d): ignored\n",
> +			 __func__, urb->status);
> +		break;
> +	}
> +
> +	usb_submit_urb(context->rx_urb_intf1, GFP_ATOMIC);
> +
> +	return;
> +}
> +
> +/**
> + * Callback function for USB core API: Probe
> + */
> +static int __devinit imon_probe(struct usb_interface *interface,
> +		      const struct usb_device_id *id)
> +{
> +	struct usb_device *usbdev = NULL;
> +	struct usb_host_interface *iface_desc = NULL;
> +	struct usb_endpoint_descriptor *rx_endpoint = NULL;
> +	struct usb_endpoint_descriptor *tx_endpoint = NULL;
> +	struct urb *rx_urb = NULL;
> +	struct urb *tx_urb = NULL;
> +	struct usb_interface *first_if;
> +	struct device *dev = &interface->dev;
> +	int ifnum;
> +	int num_endpts;
> +	int ret = 0;
> +	int display_ep_found = 0;
> +	int ir_ep_found = 0;
> +	int code_length;
> +	int tx_control = 0;
> +	struct imon_context *context = NULL;
> +	struct imon_context *first_if_context = NULL;
> +	int i, sysfs_err;
> +	int configured_display_type = IMON_DISPLAY_TYPE_VFD;
> +	u16 vendor, product;
> +	const unsigned char fp_packet[] = { 0x40, 0x00, 0x00, 0x00,
> +					    0x00, 0x00, 0x00, 0x88 };
> +
> +	/*
> +	 * Try to auto-detect the type of display if the user hasn't set
> +	 * it by hand via the display_type modparam. Default is VFD.
> +	 */
> +	if (display_type == IMON_DISPLAY_TYPE_AUTO) {
> +		if (usb_match_id(interface, lcd_device_list))
> +			configured_display_type = IMON_DISPLAY_TYPE_LCD;
> +		else if (usb_match_id(interface, imon_touchscreen_list))
> +			configured_display_type = IMON_DISPLAY_TYPE_VGA;
> +		else if (usb_match_id(interface, ir_only_list))
> +			configured_display_type = IMON_DISPLAY_TYPE_NONE;
> +		else
> +			configured_display_type = IMON_DISPLAY_TYPE_VFD;
> +	} else {
> +		configured_display_type = display_type;
> +		dev_dbg(dev, "%s: overriding display type to %d via "
> +			"modparam\n", __func__, display_type);
> +	}
> +
> +	/*
> +	 * If it's the LCD, as opposed to the VFD, we just need to replace
> +	 * the "write" file op.
> +	 */
> +	if (configured_display_type == IMON_DISPLAY_TYPE_LCD)
> +		display_fops.write = &lcd_write;
> +
> +	code_length = BUF_CHUNK_SIZE * 8;
> +
> +	usbdev     = usb_get_dev(interface_to_usbdev(interface));
> +	iface_desc = interface->cur_altsetting;
> +	num_endpts = iface_desc->desc.bNumEndpoints;
> +	ifnum      = iface_desc->desc.bInterfaceNumber;
> +	vendor     = le16_to_cpu(usbdev->descriptor.idVendor);
> +	product    = le16_to_cpu(usbdev->descriptor.idProduct);
> +
> +	dev_dbg(dev, "%s: found iMON device (%04x:%04x, intf%d)\n",
> +		__func__, vendor, product, ifnum);
> +
> +	/* prevent races probing devices w/multiple interfaces */
> +	mutex_lock(&driver_lock);
> +
> +	first_if = usb_ifnum_to_if(usbdev, 0);
> +	first_if_context = (struct imon_context *)usb_get_intfdata(first_if);
> +
> +	/*
> +	 * Scan the endpoint list and set:
> +	 *	first input endpoint = IR endpoint
> +	 *	first output endpoint = display endpoint
> +	 */
> +	for (i = 0; i < num_endpts && !(ir_ep_found && display_ep_found); ++i) {
> +		struct usb_endpoint_descriptor *ep;
> +		int ep_dir;
> +		int ep_type;
> +		ep = &iface_desc->endpoint[i].desc;
> +		ep_dir = ep->bEndpointAddress & USB_ENDPOINT_DIR_MASK;
> +		ep_type = ep->bmAttributes & USB_ENDPOINT_XFERTYPE_MASK;
> +
> +		if (!ir_ep_found &&
> +			ep_dir == USB_DIR_IN &&
> +			ep_type == USB_ENDPOINT_XFER_INT) {
> +
> +			rx_endpoint = ep;
> +			ir_ep_found = 1;
> +			dev_dbg(dev, "%s: found IR endpoint\n", __func__);
> +
> +		} else if (!display_ep_found &&
> +			   ep_dir == USB_DIR_OUT &&
> +			   ep_type == USB_ENDPOINT_XFER_INT) {
> +			tx_endpoint = ep;
> +			display_ep_found = 1;
> +			dev_dbg(dev, "%s: found display endpoint\n", __func__);
> +		}
> +	}
> +
> +	/*
> +	 * If we didn't find a display endpoint, this is probably one of the
> +	 * newer iMON devices that use control urb instead of interrupt
> +	 */
> +	if (!display_ep_found) {
> +		tx_control = 1;
> +		display_ep_found = 1;
> +		dev_dbg(dev, "%s: device uses control endpoint, not "
> +			"interface OUT endpoint\n", __func__);
> +	}
> +
> +	/*
> +	 * Some iMON receivers have no display. Unfortunately, it seems
> +	 * that SoundGraph recycles device IDs between devices both with
> +	 * and without... :\
> +	 */
> +	if (configured_display_type == IMON_DISPLAY_TYPE_NONE) {
> +		display_ep_found = 0;
> +		dev_dbg(dev, "%s: device has no display\n", __func__);
> +	}
> +
> +	/*
> +	 * iMON Touch devices have a VGA touchscreen, but no "display", as
> +	 * that refers to e.g. /dev/lcd0 (a character device LCD or VFD).
> +	 */
> +	if (configured_display_type == IMON_DISPLAY_TYPE_VGA) {
> +		display_ep_found = 0;
> +		dev_dbg(dev, "%s: iMON Touch device found\n", __func__);
> +	}
> +
> +	/* Input endpoint is mandatory */
> +	if (!ir_ep_found) {
> +		err("%s: no valid input (IR) endpoint found.", __func__);
> +		ret = -ENODEV;
> +		goto exit;
> +	}
> +
> +	if (ifnum == 0) {
> +		context = kzalloc(sizeof(struct imon_context), GFP_KERNEL);
> +		if (!context) {
> +			err("%s: kzalloc failed for context", __func__);
> +			ret = -ENOMEM;
> +			goto exit;
> +		}
> +		rx_urb = usb_alloc_urb(0, GFP_KERNEL);
> +		if (!rx_urb) {
> +			err("%s: usb_alloc_urb failed for IR urb", __func__);
> +			ret = -ENOMEM;
> +			goto rx_urb_alloc_failed;
> +		}
> +		tx_urb = usb_alloc_urb(0, GFP_KERNEL);
> +		if (!tx_urb) {
> +			err("%s: usb_alloc_urb failed for display urb",
> +			    __func__);
> +			ret = -ENOMEM;
> +			goto tx_urb_alloc_failed;
> +		}
> +
> +		mutex_init(&context->lock);
> +
> +		mutex_lock(&context->lock);
> +
> +		if (ir_protocol == IMON_IR_PROTOCOL_MCE) {
> +			init_timer(&context->itimer);
> +			context->itimer.data = (unsigned long)context;
> +			context->itimer.function = imon_mce_timeout;
> +		}
> +
> +	} else {
> +	/* this is the secondary interface on the device */
> +		rx_urb = usb_alloc_urb(0, GFP_KERNEL);
> +		if (!rx_urb) {
> +			err("%s: usb_alloc_urb failed for IR urb", __func__);
> +			ret = -ENOMEM;
> +			goto rx_urb_alloc_failed;
> +		}
> +
> +		context = first_if_context;
> +
> +		mutex_lock(&context->lock);
> +
> +		if (context->display_type == IMON_DISPLAY_TYPE_VGA) {
> +			init_timer(&context->ttimer);
> +			context->ttimer.data = (unsigned long)context;
> +			context->ttimer.function = imon_touch_display_timeout;
> +		}
> +	}
> +
> +	if (ifnum == 0) {
> +		context->dev = &interface->dev;
> +		context->usbdev_intf0 = usbdev;
> +		context->dev_present_intf0 = 1;
> +		context->rx_endpoint_intf0 = rx_endpoint;
> +		context->rx_urb_intf0 = rx_urb;
> +
> +		/*
> +		 * tx is used to send characters to lcd/vfd, associate RF
> +		 * remotes, set IR protocol, and maybe more...
> +		 */
> +		context->tx_endpoint = tx_endpoint;
> +		context->tx_urb = tx_urb;
> +		context->tx_control = tx_control;
> +
> +		if (display_ep_found)
> +			context->display_supported = 1;
> +
> +		if (product == 0xffdc)
> +			context->ffdc_dev = 1;
> +
> +		context->display_type = configured_display_type;
> +
> +		context->idev = input_allocate_device();
> +		input_set_drvdata(context->idev, context);
> +
> +		snprintf(context->name_idev, sizeof(context->name_idev),
> +			 "iMON Remote (%04x:%04x)", vendor, product);
> +		context->idev->name = context->name_idev;
> +
> +		usb_make_path(usbdev, context->phys_idev,
> +			      sizeof(context->phys_idev));
> +		strlcat(context->phys_idev, "/input0",
> +			sizeof(context->phys_idev));
> +		context->idev->phys = context->phys_idev;
> +
> +		context->idev->evbit[0] = BIT_MASK(EV_KEY) | BIT_MASK(EV_REL);
> +
> +		context->idev->keybit[BIT_WORD(BTN_MOUSE)] =
> +			BIT_MASK(BTN_LEFT) | BIT_MASK(BTN_RIGHT);
> +		context->idev->relbit[0] = BIT_MASK(REL_X) | BIT_MASK(REL_Y) |
> +			BIT_MASK(REL_WHEEL);
> +
> +		if (ir_protocol == IMON_IR_PROTOCOL_MCE)
> +			ret = sparse_keymap_setup(context->idev,
> +						  imon_mce_key_table, NULL);
> +		else
> +			ret = sparse_keymap_setup(context->idev,
> +						  imon_remote_key_table, NULL);
> +		if (ret)
> +			goto keymap_failed;
> +
> +		/* can't use sparse keymap atm, 64-bit keycodes */
> +		for (i = 0; i < ARRAY_SIZE(imon_panel_key_table); i++) {
> +			u16 kc = imon_panel_key_table[i].keycode;
> +			__set_bit(kc, context->idev->keybit);
> +		}
> +
> +		usb_to_input_id(usbdev, &context->idev->id);
> +		context->idev->dev.parent = &interface->dev;
> +		ret = input_register_device(context->idev);
> +		if (ret < 0)
> +			goto register_failed;
> +
> +		usb_fill_int_urb(context->rx_urb_intf0, context->usbdev_intf0,
> +			usb_rcvintpipe(context->usbdev_intf0,
> +				context->rx_endpoint_intf0->bEndpointAddress),
> +			context->usb_rx_buf, sizeof(context->usb_rx_buf),
> +			usb_rx_callback_intf0, context,
> +			context->rx_endpoint_intf0->bInterval);
> +
> +		ret = usb_submit_urb(context->rx_urb_intf0, GFP_KERNEL);
> +		if (ret) {
> +			err("%s: usb_submit_urb failed for intf0 (%d)",
> +			    __func__, ret);
> +			mutex_unlock(&context->lock);
> +			goto urb_submit_failed;
> +		}
> +
> +	} else {
> +		context->usbdev_intf1 = usbdev;
> +		context->dev_present_intf1 = 1;
> +		context->rx_endpoint_intf1 = rx_endpoint;
> +		context->rx_urb_intf1 = rx_urb;
> +
> +		if (context->display_type == IMON_DISPLAY_TYPE_VGA) {
> +			context->touch = input_allocate_device();
> +
> +			snprintf(context->name_touch,
> +				 sizeof(context->name_touch),
> +				 "iMON USB Touchscreen (%04x:%04x)",
> +				 vendor, product);
> +			context->touch->name = context->name_touch;
> +
> +			usb_make_path(usbdev, context->phys_touch,
> +				      sizeof(context->phys_touch));
> +			strlcat(context->phys_touch, "/input1",
> +				sizeof(context->phys_touch));
> +			context->touch->phys = context->phys_touch;
> +
> +			context->touch->evbit[0] =
> +				BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS);
> +			context->touch->keybit[BIT_WORD(BTN_TOUCH)] =
> +				BIT_MASK(BTN_TOUCH);
> +			input_set_abs_params(context->touch, ABS_X,
> +					     0x00, 0xfff, 0, 0);
> +			input_set_abs_params(context->touch, ABS_Y,
> +					     0x00, 0xfff, 0, 0);
> +
> +			input_set_drvdata(context->touch, context);
> +
> +			usb_to_input_id(usbdev, &context->touch->id);
> +			context->touch->dev.parent = &interface->dev;
> +			ret = input_register_device(context->touch);
> +			if (ret)
> +				dev_info(dev, "%s: touchscreen input device "
> +					 "setup failed\n", __func__);
> +		} else
> +			context->touch = NULL;
> +
> +		usb_fill_int_urb(context->rx_urb_intf1, context->usbdev_intf1,
> +			usb_rcvintpipe(context->usbdev_intf1,
> +				context->rx_endpoint_intf1->bEndpointAddress),
> +			context->usb_rx_buf, sizeof(context->usb_rx_buf),
> +			usb_rx_callback_intf1, context,
> +			context->rx_endpoint_intf1->bInterval);
> +
> +		ret = usb_submit_urb(context->rx_urb_intf1, GFP_KERNEL);
> +
> +		if (ret) {
> +			err("%s: usb_submit_urb failed for intf1 (%d)",
> +			    __func__, ret);
> +			mutex_unlock(&context->lock);
> +			goto urb_submit_failed;
> +		}
> +	}
> +
> +	usb_set_intfdata(interface, context);
> +
> +	/* RF products *also* use 0xffdc... sigh... */
> +	if (context->ffdc_dev) {
> +		sysfs_err = sysfs_create_group(&interface->dev.kobj,
> +					       &imon_rf_attribute_group);
> +		if (sysfs_err)
> +			err("%s: Could not create RF sysfs entries(%d)",
> +			    __func__, sysfs_err);
> +	}
> +
> +	if (context->display_supported && ifnum == 0) {
> +		dev_dbg(dev, "%s: Registering iMON display with sysfs\n",
> +			__func__);
> +
> +		/* set up sysfs entry for built-in clock */
> +		sysfs_err = sysfs_create_group(&interface->dev.kobj,
> +					       &imon_display_attribute_group);
> +		if (sysfs_err)
> +			err("%s: Could not create display sysfs entries(%d)",
> +			    __func__, sysfs_err);
> +
> +		if (usb_register_dev(interface, &imon_class)) {
> +			/* Not a fatal error, so ignore */
> +			dev_info(dev, "%s: could not get a minor number for "
> +				 "display\n", __func__);
> +		}
> +
> +		/* Enable front-panel buttons and/or knobs */
> +		memcpy(context->usb_tx_buf, &fp_packet, sizeof(fp_packet));
> +		ret = send_packet(context);
> +		/* Not fatal, but warn about it */
> +		if (ret)
> +			dev_info(dev, "%s: failed to enable front-panel "
> +				 "buttons and/or knobs\n", __func__);
> +	}
> +
> +	/* set IR protocol/remote type */
> +	imon_set_ir_protocol(context);
> +
> +	dev_info(dev, "iMON device (%04x:%04x, intf%d) on "
> +		 "usb<%d:%d> initialized\n", vendor, product, ifnum,
> +		 usbdev->bus->busnum, usbdev->devnum);
> +
> +	mutex_unlock(&context->lock);
> +	mutex_unlock(&driver_lock);

This is one monstrous function... Can it be split somewhat? Iniput
device registration, display device, etc...

> +	return 0;
> +
> +urb_submit_failed:
> +	if (ifnum == 0)
> +		input_free_device(context->idev);
> +	else if (context->display_type == IMON_DISPLAY_TYPE_VGA)
> +		input_free_device(context->touch);
> +
> +register_failed:
> +	if (ifnum == 0)
> +		sparse_keymap_free(context->idev);
> +	else
> +		mutex_unlock(&context->lock);
> +
> +keymap_failed:
> +	if (ifnum == 0) {
> +		mutex_unlock(&context->lock);
> +		usb_free_urb(tx_urb);
> +	}
> +tx_urb_alloc_failed:
> +	usb_free_urb(rx_urb);
> +rx_urb_alloc_failed:
> +	if (ifnum == 0) {
> +		kfree(context);
> +		context = NULL;
> +	}
> +exit:
> +	mutex_unlock(&driver_lock);
> +	dev_err(dev, "unable to register, err %d\n", ret);
> +
> +	return ret;
> +}
> +
> +/**
> + * Callback function for USB core API: disconnect
> + */
> +static void __devexit imon_disconnect(struct usb_interface *interface)
> +{
> +	struct imon_context *context;
> +	int ifnum;
> +
> +	/* prevent races with multi-interface device probing and display_open */
> +	mutex_lock(&driver_lock);
> +
> +	context = usb_get_intfdata(interface);
> +	ifnum = interface->cur_altsetting->desc.bInterfaceNumber;
> +
> +	mutex_lock(&context->lock);
> +
> +	/*
> +	 * sysfs_remove_group is safe to call even if sysfs_create_group
> +	 * hasn't been called
> +	 */
> +	sysfs_remove_group(&interface->dev.kobj,
> +			   &imon_display_attribute_group);
> +	sysfs_remove_group(&interface->dev.kobj,
> +			   &imon_rf_attribute_group);
> +
> +	usb_set_intfdata(interface, NULL);
> +
> +	/* Abort ongoing write */
> +	if (atomic_read(&context->tx.busy)) {
> +		usb_kill_urb(context->tx_urb);
> +		complete_all(&context->tx.finished);
> +	}
> +
> +	if (ifnum == 0) {
> +		context->dev_present_intf0 = 0;
> +		usb_kill_urb(context->rx_urb_intf0);
> +		sparse_keymap_free(context->idev);
> +		input_unregister_device(context->idev);
> +		if (context->display_supported)
> +			usb_deregister_dev(interface, &imon_class);
> +	} else {
> +		context->dev_present_intf1 = 0;
> +		usb_kill_urb(context->rx_urb_intf1);
> +		if (context->display_type == IMON_DISPLAY_TYPE_VGA)
> +			input_unregister_device(context->touch);
> +	}
> +
> +	if (!context->ir_isopen && !context->dev_present_intf0 &&
> +	    !context->dev_present_intf1) {
> +		if (context->display_type == IMON_DISPLAY_TYPE_VGA)
> +			del_timer_sync(&context->ttimer);
> +		mutex_unlock(&context->lock);
> +		if (!context->display_isopen)
> +			free_imon_context(context);
> +	} else {
> +		if (context->ir_protocol == IMON_IR_PROTOCOL_MCE)
> +			del_timer_sync(&context->itimer);
> +		mutex_unlock(&context->lock);
> +	}
> +
> +	mutex_unlock(&driver_lock);
> +
> +	printk(KERN_INFO "%s: iMON device (intf%d) disconnected\n",
> +	       __func__, ifnum);

dev_dbg().

> +}
> +
> +static int imon_suspend(struct usb_interface *intf, pm_message_t message)
> +{
> +	struct imon_context *context = usb_get_intfdata(intf);
> +	int ifnum = intf->cur_altsetting->desc.bInterfaceNumber;
> +
> +	if (ifnum == 0)
> +		usb_kill_urb(context->rx_urb_intf0);
> +	else
> +		usb_kill_urb(context->rx_urb_intf1);
> +
> +	return 0;
> +}
> +
> +static int imon_resume(struct usb_interface *intf)
> +{
> +	int rc = 0;
> +	struct imon_context *context = usb_get_intfdata(intf);
> +	int ifnum = intf->cur_altsetting->desc.bInterfaceNumber;
> +
> +	if (ifnum == 0) {
> +		usb_fill_int_urb(context->rx_urb_intf0, context->usbdev_intf0,
> +			usb_rcvintpipe(context->usbdev_intf0,
> +				context->rx_endpoint_intf0->bEndpointAddress),
> +			context->usb_rx_buf, sizeof(context->usb_rx_buf),
> +			usb_rx_callback_intf0, context,
> +			context->rx_endpoint_intf0->bInterval);
> +
> +		rc = usb_submit_urb(context->rx_urb_intf0, GFP_ATOMIC);
> +
> +	} else {
> +		usb_fill_int_urb(context->rx_urb_intf1, context->usbdev_intf1,
> +			usb_rcvintpipe(context->usbdev_intf1,
> +				context->rx_endpoint_intf1->bEndpointAddress),
> +			context->usb_rx_buf, sizeof(context->usb_rx_buf),
> +			usb_rx_callback_intf1, context,
> +			context->rx_endpoint_intf1->bInterval);
> +
> +		rc = usb_submit_urb(context->rx_urb_intf1, GFP_ATOMIC);
> +	}

We have pretty different behavior depending on the interface, maybe the
driver should be split further?

> +
> +	return rc;
> +}
> +
> +static int __init imon_init(void)
> +{
> +	int rc;
> +
> +	printk(KERN_INFO MOD_NAME ": " MOD_DESC ", v" MOD_VERSION "\n");

Boot is already noisy enoug, loose this message please.

> +
> +	rc = usb_register(&imon_driver);
> +	if (rc) {
> +		err("%s: usb register failed(%d)", __func__, rc);
> +		return -ENODEV;
> +	}
> +
> +	return 0;
> +}
> +
> +static void __exit imon_exit(void)
> +{
> +	usb_deregister(&imon_driver);
> +	printk(KERN_INFO MOD_NAME ": module removed. Goodbye!\n");

Nobody cares, we have too much messages already.

> +}
> +
> +module_init(imon_init);
> +module_exit(imon_exit);
> diff --git a/drivers/input/misc/imon.h b/drivers/input/misc/imon.h
> new file mode 100644
> index 0000000..aa8883a
> --- /dev/null
> +++ b/drivers/input/misc/imon.h
> @@ -0,0 +1,206 @@
> +/*
> + *   imon.h:	LIRC/VFD/LCD driver for SoundGraph iMON IR/VFD/LCD
> + *		including the iMON PAD model
> + *
> + *   Copyright(C) 2009  Jarod Wilson <jarod@wilsonet.com>
> + *   Portions based on the original lirc_imon driver,
> + *	Copyright(C) 2004  Venky Raju(dev@venky.ws)
> + *
> + *   imon is free software; you can redistribute it and/or modify
> + *   it under the terms of the GNU General Public License as published by
> + *   the Free Software Foundation; either version 2 of the License, or
> + *   (at your option) any later version.
> + *
> + *   This program is distributed in the hope that it will be useful,
> + *   but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *   GNU General Public License for more details.
> + *
> + *   You should have received a copy of the GNU General Public License
> + *   along with this program; if not, write to the Free Software
> + *   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> + */
> +
> +static const struct key_entry imon_remote_key_table[] = {

Why is this in an .h file and not in the main source?

> +	/* keys sorted mostly by frequency of use to optimize lookups */
> +	{ KE_KEY, 0x2a8195b7, { KEY_REWIND } },
> +	{ KE_KEY, 0x298315b7, { KEY_REWIND } },
> +	{ KE_KEY, 0x2b8115b7, { KEY_FASTFORWARD } },
> +	{ KE_KEY, 0x2b8315b7, { KEY_FASTFORWARD } },
> +	{ KE_KEY, 0x2b9115b7, { KEY_PREVIOUS } },
> +	{ KE_KEY, 0x298195b7, { KEY_NEXT } },
> +
> +	{ KE_KEY, 0x2a8115b7, { KEY_PLAY } },
> +	{ KE_KEY, 0x2a8315b7, { KEY_PLAY } },
> +	{ KE_KEY, 0x2a9115b7, { KEY_PAUSE } },
> +	{ KE_KEY, 0x2b9715b7, { KEY_STOP } },
> +	{ KE_KEY, 0x298115b7, { KEY_RECORD } },
> +
> +	{ KE_KEY, 0x01008000, { KEY_UP } },
> +	{ KE_KEY, 0x01007f00, { KEY_DOWN } },
> +	{ KE_KEY, 0x01000080, { KEY_LEFT } },
> +	{ KE_KEY, 0x0100007f, { KEY_RIGHT } },
> +
> +	{ KE_KEY, 0x2aa515b7, { KEY_UP } },
> +	{ KE_KEY, 0x289515b7, { KEY_DOWN } },
> +	{ KE_KEY, 0x29a515b7, { KEY_LEFT } },
> +	{ KE_KEY, 0x2ba515b7, { KEY_RIGHT } },
> +
> +	{ KE_KEY, 0x0200002c, { KEY_SPACE } }, /* Select/Space */
> +	{ KE_KEY, 0x02000028, { KEY_ENTER } },
> +	{ KE_KEY, 0x288195b7, { KEY_EXIT } },
> +	{ KE_KEY, 0x02000029, { KEY_ESC } },
> +	{ KE_KEY, 0x0200002a, { KEY_BACKSPACE } },
> +
> +	{ KE_KEY, 0x2b9595b7, { KEY_MUTE } },
> +	{ KE_KEY, 0x28a395b7, { KEY_VOLUMEUP } },
> +	{ KE_KEY, 0x28a595b7, { KEY_VOLUMEDOWN } },
> +	{ KE_KEY, 0x289395b7, { KEY_CHANNELUP } },
> +	{ KE_KEY, 0x288795b7, { KEY_CHANNELDOWN } },
> +
> +	{ KE_KEY, 0x0200001e, { KEY_NUMERIC_1 } },
> +	{ KE_KEY, 0x0200001f, { KEY_NUMERIC_2 } },
> +	{ KE_KEY, 0x02000020, { KEY_NUMERIC_3 } },
> +	{ KE_KEY, 0x02000021, { KEY_NUMERIC_4 } },
> +	{ KE_KEY, 0x02000022, { KEY_NUMERIC_5 } },
> +	{ KE_KEY, 0x02000023, { KEY_NUMERIC_6 } },
> +	{ KE_KEY, 0x02000024, { KEY_NUMERIC_7 } },
> +	{ KE_KEY, 0x02000025, { KEY_NUMERIC_8 } },
> +	{ KE_KEY, 0x02000026, { KEY_NUMERIC_9 } },
> +	{ KE_KEY, 0x02000027, { KEY_NUMERIC_0 } },
> +
> +	{ KE_KEY, 0x02200025, { KEY_NUMERIC_STAR } },
> +	{ KE_KEY, 0x02200020, { KEY_NUMERIC_POUND } },
> +
> +	{ KE_KEY, 0x2b8515b7, { KEY_VIDEO } },
> +	{ KE_KEY, 0x299195b7, { KEY_AUDIO } },
> +	{ KE_KEY, 0x2ba115b7, { KEY_CAMERA } },
> +	{ KE_KEY, 0x28a515b7, { KEY_TV } },
> +	{ KE_KEY, 0x29a395b7, { KEY_DVD } },
> +	{ KE_KEY, 0x29a295b7, { KEY_DVD } },
> +
> +	/* the Menu key between DVD and Subtitle on the RM-200... */
> +	{ KE_KEY, 0x2ba385b7, { KEY_MENU } },
> +	{ KE_KEY, 0x2ba395b7, { KEY_MENU } },
> +
> +	{ KE_KEY, 0x288515b7, { KEY_BOOKMARKS } },
> +	{ KE_KEY, 0x2ab715b7, { KEY_MEDIA } }, /* Thumbnail */
> +	{ KE_KEY, 0x298595b7, { KEY_SUBTITLE } },
> +	{ KE_KEY, 0x2b8595b7, { KEY_LANGUAGE } },
> +
> +	{ KE_KEY, 0x29a595b7, { KEY_ZOOM } },
> +	{ KE_KEY, 0x2aa395b7, { KEY_SCREEN } }, /* FullScreen */
> +
> +	{ KE_KEY, 0x299115b7, { KEY_KEYBOARD } },
> +	{ KE_KEY, 0x299135b7, { KEY_KEYBOARD } },
> +
> +	{ KE_KEY, 0x01010000, { BTN_LEFT } },
> +	{ KE_KEY, 0x01020000, { BTN_RIGHT } },
> +	{ KE_KEY, 0x01010080, { BTN_LEFT } },
> +	{ KE_KEY, 0x01020080, { BTN_RIGHT } },
> +
> +	{ KE_KEY, 0x2a9395b7, { KEY_CYCLEWINDOWS } }, /* TaskSwitcher */
> +	{ KE_KEY, 0x2b8395b7, { KEY_TIME } }, /* Timer */
> +
> +	{ KE_KEY, 0x289115b7, { KEY_POWER } },
> +	{ KE_KEY, 0x29b195b7, { KEY_EJECTCD } }, /* the one next to play */
> +	{ KE_KEY, 0x299395b7, { KEY_EJECTCLOSECD } }, /* eject (by TaskSw) */
> +
> +	{ KE_KEY, 0x02800000, { KEY_MENU } }, /* Left Menu */
> +	{ KE_KEY, 0x02000065, { KEY_COMPOSE } }, /* RightMenu */
> +	{ KE_KEY, 0x2ab195b7, { KEY_PROG1 } }, /* Go */
> +	{ KE_KEY, 0x29b715b7, { KEY_DASHBOARD } }, /* AppLauncher */
> +	{ KE_END, 0 }
> +};
> +
> +static const struct key_entry imon_mce_key_table[] = {
> +	/* keys sorted mostly by frequency of use to optimize lookups */
> +	{ KE_KEY, 0x800f8415, { KEY_REWIND } },
> +	{ KE_KEY, 0x800f8414, { KEY_FASTFORWARD } },
> +	{ KE_KEY, 0x800f841b, { KEY_PREVIOUS } },
> +	{ KE_KEY, 0x800f841a, { KEY_NEXT } },
> +
> +	{ KE_KEY, 0x800f8416, { KEY_PLAY } },
> +	{ KE_KEY, 0x800f8418, { KEY_PAUSE } },
> +	{ KE_KEY, 0x800f8418, { KEY_PAUSE } },
> +	{ KE_KEY, 0x800f8419, { KEY_STOP } },
> +	{ KE_KEY, 0x800f8417, { KEY_RECORD } },
> +
> +	{ KE_KEY, 0x02000052, { KEY_UP } },
> +	{ KE_KEY, 0x02000051, { KEY_DOWN } },
> +	{ KE_KEY, 0x02000050, { KEY_LEFT } },
> +	{ KE_KEY, 0x0200004f, { KEY_RIGHT } },
> +
> +	{ KE_KEY, 0x02000028, { KEY_ENTER } },
> +/* the OK and Enter buttons decode to the same value
> +	{ KE_KEY, 0x02000028, { KEY_OK } }, */
> +	{ KE_KEY, 0x0200002a, { KEY_EXIT } },
> +	{ KE_KEY, 0x02000029, { KEY_DELETE } },
> +
> +	{ KE_KEY, 0x800f840e, { KEY_MUTE } },
> +	{ KE_KEY, 0x800f8410, { KEY_VOLUMEUP } },
> +	{ KE_KEY, 0x800f8411, { KEY_VOLUMEDOWN } },
> +	{ KE_KEY, 0x800f8412, { KEY_CHANNELUP } },
> +	{ KE_KEY, 0x800f8413, { KEY_CHANNELDOWN } },
> +
> +	{ KE_KEY, 0x0200001e, { KEY_NUMERIC_1 } },
> +	{ KE_KEY, 0x0200001f, { KEY_NUMERIC_2 } },
> +	{ KE_KEY, 0x02000020, { KEY_NUMERIC_3 } },
> +	{ KE_KEY, 0x02000021, { KEY_NUMERIC_4 } },
> +	{ KE_KEY, 0x02000022, { KEY_NUMERIC_5 } },
> +	{ KE_KEY, 0x02000023, { KEY_NUMERIC_6 } },
> +	{ KE_KEY, 0x02000024, { KEY_NUMERIC_7 } },
> +	{ KE_KEY, 0x02000025, { KEY_NUMERIC_8 } },
> +	{ KE_KEY, 0x02000026, { KEY_NUMERIC_9 } },
> +	{ KE_KEY, 0x02000027, { KEY_NUMERIC_0 } },
> +
> +	{ KE_KEY, 0x02200025, { KEY_NUMERIC_STAR } },
> +	{ KE_KEY, 0x02200020, { KEY_NUMERIC_POUND } },
> +
> +	{ KE_KEY, 0x800f8446, { KEY_TV } },
> +	{ KE_KEY, 0x800f8447, { KEY_AUDIO } },
> +	{ KE_KEY, 0x800f8448, { KEY_PVR } }, /* RecordedTV */
> +	{ KE_KEY, 0x800f8449, { KEY_CAMERA } },
> +	{ KE_KEY, 0x800f844a, { KEY_VIDEO } },
> +	{ KE_KEY, 0x800f8424, { KEY_DVD } },
> +	{ KE_KEY, 0x800f8425, { KEY_TUNER } }, /* LiveTV */
> +
> +	{ KE_KEY, 0x800f845b, { KEY_RED } },
> +	{ KE_KEY, 0x800f845c, { KEY_GREEN } },
> +	{ KE_KEY, 0x800f845d, { KEY_YELLOW } },
> +	{ KE_KEY, 0x800f845e, { KEY_BLUE } },
> +
> +	{ KE_KEY, 0x800f840f, { KEY_INFO } },
> +	{ KE_KEY, 0x800f8426, { KEY_EPG } }, /* Guide */
> +	{ KE_KEY, 0x800f845a, { KEY_SUBTITLE } }, /* Caption */
> +
> +	{ KE_KEY, 0x800f840c, { KEY_POWER } },
> +	{ KE_KEY, 0x800f840d, { KEY_PROG1 } }, /* Windows MCE button */
> +	{ KE_END, 0 }
> +
> +};
> +
> +static const struct {
> +	u64 hw_code;
> +	u16 keycode;
> +} imon_panel_key_table[] = {
> +	{ 0x000000000f000fee, KEY_PROG1 }, /* Go */
> +	{ 0x000000001f000fee, KEY_AUDIO },
> +	{ 0x0000000020000fee, KEY_VIDEO },
> +	{ 0x0000000021000fee, KEY_CAMERA },
> +	{ 0x0000000027000fee, KEY_DVD },
> +/* the TV key on my panel is broken, doesn't work under any OS
> +	{ 0x0000000000000fee, KEY_TV }, */
> +	{ 0x0000000005000fee, KEY_PREVIOUS },
> +	{ 0x0000000007000fee, KEY_REWIND },
> +	{ 0x0000000004000fee, KEY_STOP },
> +	{ 0x000000003c000fee, KEY_PLAYPAUSE },
> +	{ 0x0000000008000fee, KEY_FASTFORWARD },
> +	{ 0x0000000006000fee, KEY_NEXT },
> +	{ 0x0000000100000fee, KEY_RIGHT },
> +	{ 0x0000010000000fee, KEY_LEFT },
> +	{ 0x000000003d000fee, KEY_SELECT },
> +	{ 0x0001000000000fee, KEY_VOLUMEUP },
> +	{ 0x0100000000000fee, KEY_VOLUMEDOWN },
> +	{ 0x0000000001000fee, KEY_MUTE },
> +};

-- 
Dmitry
