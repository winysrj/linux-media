Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:33103 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725749AbeJIEHB (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 9 Oct 2018 00:07:01 -0400
Date: Mon, 8 Oct 2018 21:53:23 +0100
From: Sean Young <sean@mess.org>
To: Benjamin Valentin <benpicco@googlemail.com>
Cc: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Anssi Hannula <anssi.hannula@iki.fi>,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        linux-input@vger.kernel.org
Subject: Re: [PATCHv2] media: rc: add driver for Xbox DVD Movie Playback Kit
Message-ID: <20181008205322.l3zwlqrcungb7x2u@gofer.mess.org>
References: <20181004035234.08507a71@rechenknecht2k11>
 <20181004135254.07b1b3b3@rechenknecht2k11>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181004135254.07b1b3b3@rechenknecht2k11>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Benjamin,

Thanks for your driver, I have some comments below.

On Thu, Oct 04, 2018 at 01:52:54PM +0200, Benjamin Valentin wrote:
> The Xbox DVD Movie Playback Kit is a USB dongle with an IR remote for the
> Original Xbox.
> 
> Historically it has been supported by the out-of-tree lirc_xbox driver,
> but this one has fallen out of favour and was just dropped from popular
> Kodi (formerly XBMC) distributions.
> 
> This driver is heaviely based on the ati_remote driver where all the
> boilerplate was taken from - I was mostly just removing code.
> 
> Signed-off-by: Benjamin Valentin <benpicco@googlemail.com>
> ---
> Changes since v1:
> 
> I discovered some more dead code leftover from the ati_remote driver.
> I also removed the open_mutex which I think is not needed here since
> this driver, unlike ati_remote, doesn't register both a rc and an input
> device.
> This also allowed me to collapse some functions.
> 
>  MAINTAINERS                            |   6 +
>  drivers/media/rc/Kconfig               |  11 +
>  drivers/media/rc/Makefile              |   1 +
>  drivers/media/rc/keymaps/Makefile      |   1 +
>  drivers/media/rc/keymaps/rc-xbox-dvd.c |  63 +++++
>  drivers/media/rc/xbox_remote.c         | 342 +++++++++++++++++++++++++
>  include/media/rc-map.h                 |   1 +
>  7 files changed, 425 insertions(+)
>  create mode 100644 drivers/media/rc/keymaps/rc-xbox-dvd.c
>  create mode 100644 drivers/media/rc/xbox_remote.c
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 22065048d89d..712a51a1a955 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -15973,6 +15973,12 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86/vdso
>  S:	Maintained
>  F:	arch/x86/entry/vdso/
>  
> +XBOX DVD IR REMOTE
> +M:	Benjamin Valentin <benpicco@googlemail.com>
> +S:	Maintained
> +F:	drivers/media/rc/xbox_remote.c
> +F:	drivers/media/rc/keymaps/rc-xbox-dvd.c
> +
>  XC2028/3028 TUNER DRIVER
>  M:	Mauro Carvalho Chehab <mchehab@kernel.org>
>  L:	linux-media@vger.kernel.org
> diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
> index 1021c08a9ba4..05489294ebbc 100644
> --- a/drivers/media/rc/Kconfig
> +++ b/drivers/media/rc/Kconfig
> @@ -493,6 +493,17 @@ config IR_TANGO
>  	   The HW decoder supports NEC, RC-5, RC-6 IR protocols.
>  	   When compiled as a module, look for tango-ir.
>  
> +config CONFIG_RC_XBOX_DVD

The config option should not include the leading CONFIG_ in Kconfig,
so this is broken.

> +	tristate "Xbox DVD Movie Playback Kit"
> +	depends on RC_CORE

I think you need:

        depends on USB_ARCH_HAS_HCD

As well here.

> +	select USB
> +	help
> +	   Say Y here if you want to use the Xbox DVD Movie Playback Kit.
> +	   These are IR remotes with USB receivers for the Original Xbox (2001).
> +
> +	   To compile this driver as a module, choose M here: the module will be
> +	   called xbox_remote.
> +
>  config IR_ZX
>  	tristate "ZTE ZX IR remote control"
>  	depends on RC_CORE
> diff --git a/drivers/media/rc/Makefile b/drivers/media/rc/Makefile
> index e0340d043fe8..92c163816849 100644
> --- a/drivers/media/rc/Makefile
> +++ b/drivers/media/rc/Makefile
> @@ -48,3 +48,4 @@ obj-$(CONFIG_IR_SIR) += sir_ir.o
>  obj-$(CONFIG_IR_MTK) += mtk-cir.o
>  obj-$(CONFIG_IR_ZX) += zx-irdec.o
>  obj-$(CONFIG_IR_TANGO) += tango-ir.o
> +obj-$(CONFIG_RC_XBOX_DVD) += xbox_remote.o
> diff --git a/drivers/media/rc/keymaps/Makefile b/drivers/media/rc/keymaps/Makefile
> index d6b913a3032d..5b1399af6b3a 100644
> --- a/drivers/media/rc/keymaps/Makefile
> +++ b/drivers/media/rc/keymaps/Makefile
> @@ -116,4 +116,5 @@ obj-$(CONFIG_RC_MAP) += rc-adstech-dvb-t-pci.o \
>  			rc-winfast.o \
>  			rc-winfast-usbii-deluxe.o \
>  			rc-su3000.o \
> +			rc-xbox-dvd.o \
>  			rc-zx-irdec.o
> diff --git a/drivers/media/rc/keymaps/rc-xbox-dvd.c b/drivers/media/rc/keymaps/rc-xbox-dvd.c
> new file mode 100644
> index 000000000000..61da6706715c
> --- /dev/null
> +++ b/drivers/media/rc/keymaps/rc-xbox-dvd.c
> @@ -0,0 +1,63 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +// Keytable for Xbox DVD remote
> +// Copyright (c) 2018 by Benjamin Valentin <benpicco@googlemail.com>
> +
> +#include <media/rc-map.h>
> +#include <linux/module.h>
> +
> +/* based on lircd.conf.xbox */
> +static struct rc_map_table xbox_dvd[] = {
> +	{0x0b, KEY_OK},
> +	{0xa6, KEY_UP},
> +	{0xa7, KEY_DOWN},
> +	{0xa8, KEY_RIGHT},
> +	{0xa9, KEY_LEFT},
> +	{0xc3, KEY_INFO},
> +
> +	{0xc6, KEY_9},
> +	{0xc7, KEY_8},
> +	{0xc8, KEY_7},
> +	{0xc9, KEY_6},
> +	{0xca, KEY_5},
> +	{0xcb, KEY_4},
> +	{0xcc, KEY_3},
> +	{0xcd, KEY_2},
> +	{0xce, KEY_1},
> +	{0xcf, KEY_0},
> +
> +	{0xd5, KEY_ANGLE},
> +	{0xd8, KEY_BACK},
> +	{0xdd, KEY_PREVIOUSSONG},
> +	{0xdf, KEY_NEXTSONG},
> +	{0xe0, KEY_STOP},
> +	{0xe2, KEY_REWIND},
> +	{0xe3, KEY_FASTFORWARD},
> +	{0xe5, KEY_TITLE},
> +	{0xe6, KEY_PAUSE},
> +	{0xea, KEY_PLAY},
> +	{0xf7, KEY_MENU},
> +};
> +
> +static struct rc_map_list xbox_dvd_map = {
> +	.map = {
> +		.scan     = xbox_dvd,
> +		.size     = ARRAY_SIZE(xbox_dvd),
> +		.rc_proto = RC_PROTO_UNKNOWN,
> +		.name     = RC_MAP_XBOX_DVD,
> +	}
> +};
> +
> +static int __init init_rc_map(void)
> +{
> +	return rc_map_register(&xbox_dvd_map);
> +}
> +
> +static void __exit exit_rc_map(void)
> +{
> +	rc_map_unregister(&xbox_dvd_map);
> +}
> +
> +module_init(init_rc_map)
> +module_exit(exit_rc_map)
> +
> +MODULE_LICENSE("GPL");
> diff --git a/drivers/media/rc/xbox_remote.c b/drivers/media/rc/xbox_remote.c
> new file mode 100644
> index 000000000000..c8a7ce7e7f60
> --- /dev/null
> +++ b/drivers/media/rc/xbox_remote.c
> @@ -0,0 +1,342 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +// Driver for Xbox DVD Movie Playback Kit
> +// Copyright (c) 2018 by Benjamin Valentin <benpicco@googlemail.com>
> +
> +/*
> + *  Xbox DVD Movie Playback Kit USB IR dongle support
> + *
> + *  The driver was derived from the ati_remote driver 2.2.1 and used information from lirc_xbox.c

This line is too long, please run checkpatch --strict on your patch and fix the issues.

> + *                Copyright (c) 2011, 2012 Anssi Hannula <anssi.hannula@iki.fi>
> + *                Copyright (c) 2004 Torrey Hoffman <thoffman@arnor.net>
> + *                Copyright (c) 2002 Vladimir Dergachev
> + *                Copyright (c) 2003-2004 Paul Miller <pmiller9@users.sourceforge.net>
> + */
> +
> +#include <linux/slab.h>
> +#include <linux/module.h>
> +#include <linux/mutex.h>

header not needed.

> +#include <linux/usb/input.h>
> +#include <media/rc-core.h>
> +
> +/*
> + * Module and Version Information, Module Parameters
> + */
> +
> +#define DRIVER_VERSION	"1.0.0"
> +#define DRIVER_AUTHOR	"Benjamin Valentin <benpicco@flauschlabor.de>"
> +#define DRIVER_DESC		"Xbox DVD USB Remote Control"
> +
> +#define NAME_BUFSIZE      80    /* size of product name, path buffers */
> +#define DATA_BUFSIZE      16    /* size of URB data buffers */
> +
> +static int debug;
> +module_param(debug, int, 0644);
> +MODULE_PARM_DESC(debug, "Enable extra debug messages and information");
> +
> +#define dbginfo(dev, format, arg...) \
> +	do { if (debug) dev_info(dev, format, ## arg); } while (0)

No need to define dbginfo(), just use dev_dbg() and do away with the debug
module param.

> +#undef err
> +#define err(format, arg...) printk(KERN_ERR format, ## arg)

Please just use pr_err()

> +
> +/* USB vendor ids for XBOX DVD Dongles */
> +#define VENDOR_GAMESTER     0x040b
> +#define VENDOR_MICROSOFT    0x045e
> +
> +static const struct usb_device_id xbox_remote_table[] = {
> +	/* Gamester Xbox DVD Movie Playback Kit IR */
> +	{
> +		USB_DEVICE(VENDOR_GAMESTER, 0x6521),
> +	},
> +	/* Microsoft Xbox DVD Movie Playback Kit IR */
> +	{
> +		USB_DEVICE(VENDOR_MICROSOFT, 0x0284),
> +	},
> +	{}	/* Terminating entry */
> +};
> +
> +MODULE_DEVICE_TABLE(usb, xbox_remote_table);
> +
> +struct xbox_remote {
> +	struct rc_dev *rdev;
> +	struct usb_device *udev;
> +	struct usb_interface *interface;
> +
> +	struct urb *irq_urb;
> +	struct usb_endpoint_descriptor *endpoint_in;

endpoint_in is not used after probe, as far as I can make out.

> +	unsigned char *inbuf;
> +	dma_addr_t inbuf_dma;
> +
> +	char rc_name[NAME_BUFSIZE];
> +	char rc_phys[NAME_BUFSIZE];
> +};
> +
> +static int xbox_remote_rc_open(struct rc_dev *rdev)
> +{
> +	struct xbox_remote *xbox_remote = rdev->priv;
> +
> +	/* On first open, submit the read urb which was set up previously. */
> +	xbox_remote->irq_urb->dev = xbox_remote->udev;
> +	if (usb_submit_urb(xbox_remote->irq_urb, GFP_KERNEL)) {
> +		dev_err(&xbox_remote->interface->dev,
> +			"%s: usb_submit_urb failed!\n", __func__);
> +		return -EIO;
> +	}
> +
> +	return 0;
> +}
> +
> +static void xbox_remote_rc_close(struct rc_dev *rdev)
> +{
> +	struct xbox_remote *xbox_remote = rdev->priv;
> +	usb_kill_urb(xbox_remote->irq_urb);
> +}
> +
> +/*
> + * xbox_remote_report_input
> + */
> +static void xbox_remote_input_report(struct urb *urb)
> +{
> +	struct xbox_remote *xbox_remote = urb->context;
> +	unsigned char *data = xbox_remote->inbuf;
> +
> +	/*
> +	 * data[0] = 0x00
> +	 * data[1] = length - always 0x06
> +	 * data[2] = the key code
> +	 * data[3] = high part of key code? - always 0x0a
> +	 * data[4] = last_press_ms (low)
> +	 * data[5] = last_press_ms (high)
> +	 */
> +
> +	/* Deal with strange looking inputs */
> +	if (urb->actual_length != 6 || urb->actual_length != data[1]) {
> +		dev_warn(&urb->dev->dev, "Weird data, len=%d: %*ph\n", urb->actual_length, urb->actual_length, data);
> +		return;
> +	}
> +
> +	dbginfo(&urb->dev->dev, "got data, len=%d: %*ph\n", urb->actual_length, urb->actual_length, data);
> +	rc_keydown(xbox_remote->rdev, RC_PROTO_UNKNOWN, data[2], 0);
> +}
> +
> +/*
> + * xbox_remote_irq_in
> + */
> +static void xbox_remote_irq_in(struct urb *urb)
> +{
> +	struct xbox_remote *xbox_remote = urb->context;
> +	int retval;
> +
> +	switch (urb->status) {
> +	case 0:			/* success */
> +		xbox_remote_input_report(urb);
> +		break;
> +	case -ECONNRESET:	/* unlink */
> +	case -ENOENT:
> +	case -ESHUTDOWN:
> +		dev_dbg(&xbox_remote->interface->dev,
> +			"%s: urb error status, unlink?\n",
> +			__func__);
> +		return;
> +	default:		/* error */
> +		dev_dbg(&xbox_remote->interface->dev,
> +			"%s: Nonzero urb status %d\n",
> +			__func__, urb->status);
> +	}
> +
> +	retval = usb_submit_urb(urb, GFP_ATOMIC);
> +	if (retval)
> +		dev_err(&xbox_remote->interface->dev,
> +			"%s: usb_submit_urb()=%d\n",
> +			__func__, retval); > +}
> +
> +/*
> + * xbox_remote_alloc_buffers
> + */
> +static int xbox_remote_alloc_buffers(struct usb_device *udev,
> +				    struct xbox_remote *xbox_remote)
> +{
> +	xbox_remote->inbuf = usb_alloc_coherent(udev, DATA_BUFSIZE, GFP_ATOMIC,
> +					       &xbox_remote->inbuf_dma);
> +	if (!xbox_remote->inbuf)
> +		return -1;
> +
> +	xbox_remote->irq_urb = usb_alloc_urb(0, GFP_KERNEL);
> +	if (!xbox_remote->irq_urb)
> +		return -1;
> +
> +	return 0;
> +}
> +
> +/*
> + * xbox_remote_free_buffers
> + */
> +static void xbox_remote_free_buffers(struct xbox_remote *xbox_remote)
> +{
> +	usb_free_urb(xbox_remote->irq_urb);
> +
> +	usb_free_coherent(xbox_remote->udev, DATA_BUFSIZE,
> +		xbox_remote->inbuf, xbox_remote->inbuf_dma);
> +}

If I understand correctly, this device will produce 6 bytes of data for
every key press. I don't think coherent dma is needed for this, and this
can be harmful, see:

https://www.kernel.org/doc/html/v4.16/driver-api/usb/dma.html

Thanks,

Sean

> +
> +static void xbox_remote_rc_init(struct xbox_remote *xbox_remote)
> +{
> +	struct rc_dev *rdev = xbox_remote->rdev;
> +
> +	rdev->priv = xbox_remote;
> +	rdev->allowed_protocols = RC_PROTO_BIT_UNKNOWN;
> +	rdev->driver_name = "xbox_remote";
> +
> +	rdev->open = xbox_remote_rc_open;
> +	rdev->close = xbox_remote_rc_close;
> +
> +	rdev->device_name = xbox_remote->rc_name;
> +	rdev->input_phys = xbox_remote->rc_phys;
> +
> +	usb_to_input_id(xbox_remote->udev, &rdev->input_id);
> +	rdev->dev.parent = &xbox_remote->interface->dev;
> +}
> +
> +static int xbox_remote_initialize(struct xbox_remote *xbox_remote)
> +{
> +	struct usb_device *udev = xbox_remote->udev;
> +	int pipe, maxp;
> +
> +	/* Set up irq_urb */
> +	pipe = usb_rcvintpipe(udev, xbox_remote->endpoint_in->bEndpointAddress);
> +	maxp = usb_maxpacket(udev, pipe, usb_pipeout(pipe));
> +	maxp = (maxp > DATA_BUFSIZE) ? DATA_BUFSIZE : maxp;
> +
> +	usb_fill_int_urb(xbox_remote->irq_urb, udev, pipe, xbox_remote->inbuf,
> +			 maxp, xbox_remote_irq_in, xbox_remote,
> +			 xbox_remote->endpoint_in->bInterval);
> +	xbox_remote->irq_urb->transfer_dma = xbox_remote->inbuf_dma;
> +	xbox_remote->irq_urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
> +
> +	return 0;
> +}
> +
> +/*
> + * xbox_remote_probe
> + */
> +static int xbox_remote_probe(struct usb_interface *interface,
> +	const struct usb_device_id *id)
> +{
> +	struct usb_device *udev = interface_to_usbdev(interface);
> +	struct usb_host_interface *iface_host = interface->cur_altsetting;
> +	struct usb_endpoint_descriptor *endpoint_in;
> +	struct xbox_remote *xbox_remote;
> +	struct rc_dev *rc_dev;
> +	int err = -ENOMEM;
> +
> +	// why is there also a device with no endpoints?
> +	if (iface_host->desc.bNumEndpoints == 0)
> +		return -ENODEV;
> +
> +	if (iface_host->desc.bNumEndpoints != 1) {
> +		err("%s: Unexpected desc.bNumEndpoints: %d\n", __func__, iface_host->desc.bNumEndpoints);
> +		return -ENODEV;
> +	}
> +
> +	endpoint_in = &iface_host->endpoint[0].desc;
> +
> +	if (!usb_endpoint_is_int_in(endpoint_in)) {
> +		err("%s: Unexpected endpoint_in\n", __func__);
> +		return -ENODEV;
> +	}
> +	if (le16_to_cpu(endpoint_in->wMaxPacketSize) == 0) {
> +		err("%s: endpoint_in message size==0?\n", __func__);
> +		return -ENODEV;
> +	}
> +
> +	xbox_remote = kzalloc(sizeof(*xbox_remote), GFP_KERNEL);
> +	rc_dev = rc_allocate_device(RC_DRIVER_SCANCODE);
> +	if (!xbox_remote || !rc_dev)
> +		goto exit_free_dev_rdev;
> +
> +	/* Allocate URB buffers, URBs */
> +	if (xbox_remote_alloc_buffers(udev, xbox_remote))
> +		goto exit_free_buffers;
> +
> +	xbox_remote->endpoint_in = endpoint_in;
> +	xbox_remote->udev = udev;
> +	xbox_remote->rdev = rc_dev;
> +	xbox_remote->interface = interface;
> +
> +	usb_make_path(udev, xbox_remote->rc_phys, sizeof(xbox_remote->rc_phys));
> +
> +	strlcat(xbox_remote->rc_phys, "/input0", sizeof(xbox_remote->rc_phys));
> +
> +	snprintf(xbox_remote->rc_name, sizeof(xbox_remote->rc_name), "%s%s%s",
> +		udev->manufacturer ?: "",
> +		udev->manufacturer && udev->product ? " " : "",
> +		udev->product ?: "");
> +
> +	if (!strlen(xbox_remote->rc_name))
> +		snprintf(xbox_remote->rc_name, sizeof(xbox_remote->rc_name),
> +			DRIVER_DESC "(%04x,%04x)",
> +			le16_to_cpu(xbox_remote->udev->descriptor.idVendor),
> +			le16_to_cpu(xbox_remote->udev->descriptor.idProduct));
> +
> +	rc_dev->map_name = RC_MAP_XBOX_DVD; /* default map */
> +
> +	xbox_remote_rc_init(xbox_remote);
> +
> +	/* Device Hardware Initialization - fills in xbox_remote->idev from udev. */
> +	err = xbox_remote_initialize(xbox_remote);
> +	if (err)
> +		goto exit_kill_urbs;
> +
> +	/* Set up and register rc device */
> +	err = rc_register_device(xbox_remote->rdev);
> +	if (err)
> +		goto exit_kill_urbs;
> +
> +	usb_set_intfdata(interface, xbox_remote);
> +
> +	return 0;
> +
> +exit_kill_urbs:
> +	usb_kill_urb(xbox_remote->irq_urb);
> +exit_free_buffers:
> +	xbox_remote_free_buffers(xbox_remote);
> +exit_free_dev_rdev:
> +	rc_free_device(rc_dev);
> +	kfree(xbox_remote);
> +
> +	return err;
> +}
> +
> +/*
> + * xbox_remote_disconnect
> + */
> +static void xbox_remote_disconnect(struct usb_interface *interface)
> +{
> +	struct xbox_remote *xbox_remote;
> +
> +	xbox_remote = usb_get_intfdata(interface);
> +	usb_set_intfdata(interface, NULL);
> +	if (!xbox_remote) {
> +		dev_warn(&interface->dev, "%s - null device?\n", __func__);
> +		return;
> +	}
> +
> +	usb_kill_urb(xbox_remote->irq_urb);
> +	rc_unregister_device(xbox_remote->rdev);
> +	xbox_remote_free_buffers(xbox_remote);
> +	kfree(xbox_remote);
> +}
> +
> +/* usb specific object to register with the usb subsystem */
> +static struct usb_driver xbox_remote_driver = {
> +	.name         = "xbox_remote",
> +	.probe        = xbox_remote_probe,
> +	.disconnect   = xbox_remote_disconnect,
> +	.id_table     = xbox_remote_table,
> +};
> +
> +module_usb_driver(xbox_remote_driver);
> +
> +MODULE_AUTHOR(DRIVER_AUTHOR);
> +MODULE_DESCRIPTION(DRIVER_DESC);
> +MODULE_LICENSE("GPL");
> diff --git a/include/media/rc-map.h b/include/media/rc-map.h
> index bfa3017cecba..d621acadfbf3 100644
> --- a/include/media/rc-map.h
> +++ b/include/media/rc-map.h
> @@ -277,6 +277,7 @@ struct rc_map *rc_map_get(const char *name);
>  #define RC_MAP_WINFAST                   "rc-winfast"
>  #define RC_MAP_WINFAST_USBII_DELUXE      "rc-winfast-usbii-deluxe"
>  #define RC_MAP_SU3000                    "rc-su3000"
> +#define RC_MAP_XBOX_DVD                  "rc-xbox-dvd"
>  #define RC_MAP_ZX_IRDEC                  "rc-zx-irdec"
>  
>  /*
> -- 
> 2.17.1
