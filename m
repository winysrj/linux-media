Return-path: <linux-media-owner@vger.kernel.org>
Received: from static-72-93-233-3.bstnma.fios.verizon.net ([72.93.233.3]:54877
	"EHLO mail.wilsonet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbZL2FEJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 29 Dec 2009 00:04:09 -0500
Subject: Re: [PATCH] input: imon driver for SoundGraph iMON/Antec Veris IR devices
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
From: Jarod Wilson <jarod@wilsonet.com>
In-Reply-To: <20091228093106.GA16910@core.coreip.homeip.net>
Date: Tue, 29 Dec 2009 00:04:00 -0500
Cc: Jarod Wilson <jarod@redhat.com>, linux-input@vger.kernel.org,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <671B85F3-6F9E-48FF-8592-E9DBC7FA2F97@wilsonet.com>
References: <20091228051155.GA14301@redhat.com> <20091228093106.GA16910@core.coreip.homeip.net>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hey Dmitry,

Thanks much for the review, comments inline below...

On Dec 28, 2009, at 4:31 AM, Dmitry Torokhov wrote:

> Hi Jarod,
> 
> On Mon, Dec 28, 2009 at 12:11:55AM -0500, Jarod Wilson wrote:
>> This is an input layer driver for the SoundGraph iMON and Antec
>> Veris IR and/or Display (LCD/VFD/VGA touchscreen) devices that
>> do onboard signal decoding.
>> 
>> This driver has been baking for quite a while in the lirc tree, as
>> lirc_imon, which supported both all the current onboard decoding
>> imon devices, as well as some older raw IR ones. I've split support
>> into two different drivers now, this one, a pure input driver with
>> no ties to lirc at all (device can be used with lircd via its
>> userspace devinput driver though) and a pure lirc driver for the
>> older devices that don't do onboard decoding. There's a bit of
>> code duplication between the two, but not much anymore...
>> 
>> I did start using *some* of the new sparse keymap code for this
>> driver, but I quickly found I really needed more access to the
>> raw data (as well as 64-bit hw codes), so I'm really only using
>> sparse_keymap_{setup,free} right now, and I've not had cause to
>> implement {s,g}etkeycode to date. Work for the future.
>> 
>> Heavily tested with an Antec Veris Elite (IR + VFD), lightly tested
>> with an Antec Veris Premiere (IR + LCD), works quite well on both,
>> using both the stock Antec RM-200 remote and a Windows MCE remote
>> (as well as with a Logitech Harmony 880 programmed to emulate the
>> Antec remote).
>> 
>> nb: checkpatch.pl has one warning on this patch:
>>  WARNING: struct file_operations should normally be const
>>  #200: FILE: drivers/input/misc/imon.c:146:
>>  +static struct file_operations display_fops = {
>> 
>>  total: 0 errors, 1 warnings, 2360 lines checked
>> 
>> We don't make the struct const, because we swap in a new write fop
>> if the device has an LCD character display instead of a VFD one.
> 
> Why don't you set up separate fops for LCD and mark both const?

Was mainly to keep things simple, and that's just the way its been for some time... Creating separate fops didn't turn out to be too painful though, was only a 14-line increase, so I've gone ahead and done that.

>> +/* Driver init/exit prototypes */
>> +static int __init imon_init(void);
>> +static void __exit imon_exit(void);
> 
> Why are they needed?

Bah. Legacy crud from lirc_imon. Gone.

>> +
>> +/*** G L O B A L S ***/
>> +
>> +struct imon_context {
>> +	struct device *dev;
>> +	struct usb_device *usbdev_intf0;
>> +	/* Newer devices have two interfaces */
>> +	struct usb_device *usbdev_intf1;
>> +	int display_supported;		/* not all controllers do */
>> +	int display_isopen;		/* display port has been opened */
>> +	int ir_isopen;			/* IR port open	*/
>> +	int ir_isassociating;		/* IR port open for association */
> 
> bools for these?

Crap, yeah, been meaning to get around to changing those for some time, forgot about them. Done. (As well as for all other cases I could find where an int was being used where a bool would suffice).

>> +/* to prevent races between open() and disconnect(), probing, etc */
>> +static DEFINE_MUTEX(driver_lock);
>> +
>> +static int debug;
>> +
>> +/* lcd, vfd, vga or none? should be auto-detected, but can be overridden... */
>> +static int display_type;
>> +
>> +/* IR protocol: native iMON, Windows MCE (RC-6), or iMON w/o PAD stabilize */
>> +static int ir_protocol;
>> +
>> +/*
>> + * In certain use cases, mouse mode isn't really helpful, and could actually
>> + * cause confusion, so allow disabling it when the IR device is open.
>> + */
>> +static int nomouse;
>> +
>> +/* threshold at which a pad push registers as an arrow key in kbd mode */
>> +static int pad_thresh;
>> +
>> +/***  M O D U L E   C O D E ***/
>> +
>> +MODULE_AUTHOR(MOD_AUTHOR);
>> +MODULE_DESCRIPTION(MOD_DESC);
>> +MODULE_VERSION(MOD_VERSION);
>> +MODULE_LICENSE("GPL");
>> +MODULE_DEVICE_TABLE(usb, imon_usb_id_table);
>> +module_param(debug, int, S_IRUGO | S_IWUSR);
>> +MODULE_PARM_DESC(debug, "Debug messages: 0=no, 1=yes(default: no)");
> 
> Bool here. I also prefer keeping module_param() and MODULE_PARM_DESC()
> with the definition of the variable.

Done.

>> +
>> +static void free_imon_context(struct imon_context *context)
>> +{
>> +	usb_free_urb(context->tx_urb);
>> +	usb_free_urb(context->rx_urb_intf0);
>> +	usb_free_urb(context->rx_urb_intf1);
>> +	kfree(context);
>> +
>> +	dev_dbg(context->dev, "%s: iMON context freed\n", __func__);
>> +}

Eeeeeew. Just noticed the above has a nasty little use-after-free possibility with debugging enabled...

>> +/**
>> + * Process the incoming packet
>> + */
>> +static void imon_incoming_packet(struct imon_context *context,
>> +				 struct urb *urb, int intf)
>> +{
>> +	int len = urb->actual_length;
>> +	unsigned char *buf = urb->transfer_buffer;
>> +	struct device *dev = context->dev;
>> +	char rel_x = 0x00, rel_y = 0x00;
>> +	int ts_input = 0;
>> +	int dir = 0;
>> +	u16 timeout, threshold;
>> +	u16 kc;
>> +	u16 norelease = 0;
>> +	int i, k;
>> +	int offset = IMON_KEY_RELEASE_OFFSET;
>> +	u32 remote_key = 0;
>> +	u64 panel_key = 0;
>> +	int mouse_input;
>> +	int right_shift = 1;
>> +	struct input_dev *idev = NULL;
>> +	struct input_dev *touch = NULL;
>> +	int press_type = 0;
>> +	int msec;
>> +	struct timeval t;
>> +	static struct timeval prev_time = { 0, 0 };
>> +	int ksrc = IMON_BUTTON_IMON;
>> +
>> +	idev = context->idev;
>> +	if (context->display_type == IMON_DISPLAY_TYPE_VGA)
>> +		touch = context->touch;
>> +
>> +	/* Figure out what key was pressed */
>> +	if (len == 8 && buf[7] == 0xee) {
>> +		ksrc = IMON_BUTTON_PANEL;
>> +		memcpy(&panel_key, buf, len);
>> +		k = imon_panel_key_lookup(panel_key);
>> +		kc = imon_panel_key_table[k].keycode;
>> +	} else {
>> +		memcpy(&remote_key, buf, sizeof(remote_key));
> 
> Hm, will this work on big-endian?

Good question. Not sure offhand. Probably not. Unfortunately, the only devices I have to test with at the moment are integrated into cases with x86 boards in them, so testing isn't particularly straight-forward. I should probably get ahold of one of the plain external usb devices to play with... Mind if I just add a TODO marker near that for now?

>> +/**
>> + * mce/rc6 keypresses have no distinct release code, use timer
>> + */
>> +static void imon_mce_timeout(unsigned long data)
>> +{
>> +	struct imon_context *context = (struct imon_context *)data;
>> +
>> +	input_report_key(context->idev, context->last_keycode, 0);
>> +	input_sync(context->idev);
>> +
>> +	return;
> 
> No empty returns please.

Nuking all of them.


>> +/**
>> + * Callback function for USB core API: Probe
>> + */
>> +static int __devinit imon_probe(struct usb_interface *interface,
>> +		      const struct usb_device_id *id)
>> +{
>> +	struct usb_device *usbdev = NULL;
>> +	struct usb_host_interface *iface_desc = NULL;
>> +	struct usb_endpoint_descriptor *rx_endpoint = NULL;
>> +	struct usb_endpoint_descriptor *tx_endpoint = NULL;
>> +	struct urb *rx_urb = NULL;
>> +	struct urb *tx_urb = NULL;
>> +	struct usb_interface *first_if;
>> +	struct device *dev = &interface->dev;
>> +	int ifnum;
>> +	int num_endpts;
>> +	int ret = 0;
>> +	int display_ep_found = 0;
>> +	int ir_ep_found = 0;
>> +	int code_length;
>> +	int tx_control = 0;
>> +	struct imon_context *context = NULL;
>> +	struct imon_context *first_if_context = NULL;
>> +	int i, sysfs_err;
>> +	int configured_display_type = IMON_DISPLAY_TYPE_VFD;
>> +	u16 vendor, product;
>> +	const unsigned char fp_packet[] = { 0x40, 0x00, 0x00, 0x00,
>> +					    0x00, 0x00, 0x00, 0x88 };
>> 
<...200 or so lines of monstrous function snipped...>
>> +	/* set IR protocol/remote type */
>> +	imon_set_ir_protocol(context);
>> +
>> +	dev_info(dev, "iMON device (%04x:%04x, intf%d) on "
>> +		 "usb<%d:%d> initialized\n", vendor, product, ifnum,
>> +		 usbdev->bus->busnum, usbdev->devnum);
>> +
>> +	mutex_unlock(&context->lock);
>> +	mutex_unlock(&driver_lock);
> 
> This is one monstrous function... Can it be split somewhat? Iniput
> device registration, display device, etc...

Yeah, that's been a while coming. I'll go ahead and do so.

>> +static void __devexit imon_disconnect(struct usb_interface *interface)
>> +{
>> +	struct imon_context *context;
>> +	int ifnum;
>> +
>> +	/* prevent races with multi-interface device probing and display_open */
>> +	mutex_lock(&driver_lock);
>> +
>> +	context = usb_get_intfdata(interface);
>> +	ifnum = interface->cur_altsetting->desc.bInterfaceNumber;
>> +
>> +	mutex_lock(&context->lock);
>> +
>> +	/*
>> +	 * sysfs_remove_group is safe to call even if sysfs_create_group
>> +	 * hasn't been called
>> +	 */
>> +	sysfs_remove_group(&interface->dev.kobj,
>> +			   &imon_display_attribute_group);
>> +	sysfs_remove_group(&interface->dev.kobj,
>> +			   &imon_rf_attribute_group);
>> +
>> +	usb_set_intfdata(interface, NULL);
>> +
>> +	/* Abort ongoing write */
>> +	if (atomic_read(&context->tx.busy)) {
>> +		usb_kill_urb(context->tx_urb);
>> +		complete_all(&context->tx.finished);
>> +	}
>> +
>> +	if (ifnum == 0) {
>> +		context->dev_present_intf0 = 0;
>> +		usb_kill_urb(context->rx_urb_intf0);
>> +		sparse_keymap_free(context->idev);
>> +		input_unregister_device(context->idev);
>> +		if (context->display_supported)
>> +			usb_deregister_dev(interface, &imon_class);
>> +	} else {
>> +		context->dev_present_intf1 = 0;
>> +		usb_kill_urb(context->rx_urb_intf1);
>> +		if (context->display_type == IMON_DISPLAY_TYPE_VGA)
>> +			input_unregister_device(context->touch);
>> +	}
>> +
>> +	if (!context->ir_isopen && !context->dev_present_intf0 &&
>> +	    !context->dev_present_intf1) {
>> +		if (context->display_type == IMON_DISPLAY_TYPE_VGA)
>> +			del_timer_sync(&context->ttimer);
>> +		mutex_unlock(&context->lock);
>> +		if (!context->display_isopen)
>> +			free_imon_context(context);
>> +	} else {
>> +		if (context->ir_protocol == IMON_IR_PROTOCOL_MCE)
>> +			del_timer_sync(&context->itimer);
>> +		mutex_unlock(&context->lock);
>> +	}
>> +
>> +	mutex_unlock(&driver_lock);
>> +
>> +	printk(KERN_INFO "%s: iMON device (intf%d) disconnected\n",
>> +	       __func__, ifnum);
> 
> dev_dbg().

Ah. I think I was thinking it might not be safe to use at this point in time. Which is what led me to look back at free_imon_context to see what it was doing. Looks like both here and to fix free_imon_context's use-after-free, I'll need to create a local struct device to pass over to dev_dbg().


>> +static int imon_resume(struct usb_interface *intf)
>> +{
>> +	int rc = 0;
>> +	struct imon_context *context = usb_get_intfdata(intf);
>> +	int ifnum = intf->cur_altsetting->desc.bInterfaceNumber;
>> +
>> +	if (ifnum == 0) {
>> +		usb_fill_int_urb(context->rx_urb_intf0, context->usbdev_intf0,
>> +			usb_rcvintpipe(context->usbdev_intf0,
>> +				context->rx_endpoint_intf0->bEndpointAddress),
>> +			context->usb_rx_buf, sizeof(context->usb_rx_buf),
>> +			usb_rx_callback_intf0, context,
>> +			context->rx_endpoint_intf0->bInterval);
>> +
>> +		rc = usb_submit_urb(context->rx_urb_intf0, GFP_ATOMIC);
>> +
>> +	} else {
>> +		usb_fill_int_urb(context->rx_urb_intf1, context->usbdev_intf1,
>> +			usb_rcvintpipe(context->usbdev_intf1,
>> +				context->rx_endpoint_intf1->bEndpointAddress),
>> +			context->usb_rx_buf, sizeof(context->usb_rx_buf),
>> +			usb_rx_callback_intf1, context,
>> +			context->rx_endpoint_intf1->bInterval);
>> +
>> +		rc = usb_submit_urb(context->rx_urb_intf1, GFP_ATOMIC);
>> +	}
> 
> We have pretty different behavior depending on the interface, maybe the
> driver should be split further?

This is what we'll call a "fun" topic... These devices expose two interfaces, and a while back in the lirc_imon days, they actually loaded up as two separate lirc devices. But there's a catch: they can't operate independently. Some keys come in via intf0, some via intf1, even from the very same remote. And the interfaces share a hardware-internal buffer (or something), and if you're only listening to one of the two devices, and a key is decoded and sent via the interface you're not listening to, it wedges the entire device until you flush the other interface. Horribly bad hardware design at play there, imo, but meh. What exactly did you have in mind as far as a split? (And/or does it still apply with the above info taken into consideration? ;).

>> +static int __init imon_init(void)
>> +{
>> +	int rc;
>> +
>> +	printk(KERN_INFO MOD_NAME ": " MOD_DESC ", v" MOD_VERSION "\n");
> 
> Boot is already noisy enoug, loose this message please.
...
>> +static void __exit imon_exit(void)
>> +{
>> +	usb_deregister(&imon_driver);
>> +	printk(KERN_INFO MOD_NAME ": module removed. Goodbye!\n");
> 
> Nobody cares, we have too much messages already.

Done and done.


>> diff --git a/drivers/input/misc/imon.h b/drivers/input/misc/imon.h
>> new file mode 100644
>> index 0000000..aa8883a
>> --- /dev/null
>> +++ b/drivers/input/misc/imon.h
>> @@ -0,0 +1,206 @@
>> +/*
>> + *   imon.h:	LIRC/VFD/LCD driver for SoundGraph iMON IR/VFD/LCD
>> + *		including the iMON PAD model
>> + *
>> + *   Copyright(C) 2009  Jarod Wilson <jarod@wilsonet.com>
>> + *   Portions based on the original lirc_imon driver,
>> + *	Copyright(C) 2004  Venky Raju(dev@venky.ws)
>> + *
>> + *   imon is free software; you can redistribute it and/or modify
>> + *   it under the terms of the GNU General Public License as published by
>> + *   the Free Software Foundation; either version 2 of the License, or
>> + *   (at your option) any later version.
>> + *
>> + *   This program is distributed in the hope that it will be useful,
>> + *   but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + *   GNU General Public License for more details.
>> + *
>> + *   You should have received a copy of the GNU General Public License
>> + *   along with this program; if not, write to the Free Software
>> + *   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
>> + */
>> +
>> +static const struct key_entry imon_remote_key_table[] = {
> 
> Why is this in an .h file and not in the main source?

Being sort of lirc-ish (driver and key mapping in separate locations). I have no problem merging it back into the main source though.

For the record, all of these changes, save the factoring that imon_probe() monster out into smaller functions, can be seen piece by piece up here:

http://git.kernel.org/?p=linux/kernel/git/jarod/linux-2.6-lirc.git;a=summary

Once I've finished breaking up imon_probe() and tested it out a bit, I'll throw an updated combined patch out here...

-- 
Jarod Wilson
jarod@wilsonet.com



