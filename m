Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:46700
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091AbcGOPOH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jul 2016 11:14:07 -0400
Date: Fri, 15 Jul 2016 12:13:57 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Sean Young <sean@mess.org>
Cc: Chris Dodge <chris@redrat.co.uk>, linux-media@vger.kernel.org
Subject: Re: [PATCH 5/5] [media] redrat3: add sysfs attributes for hardware
 specific options
Message-ID: <20160715121357.7b7be7a1@recife.lan>
In-Reply-To: <1468168479-27543-3-git-send-email-sean@mess.org>
References: <1468168479-27543-3-git-send-email-sean@mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sean,

Em Sun, 10 Jul 2016 17:34:39 +0100
Sean Young <sean@mess.org> escreveu:

> Signed-off-by: Sean Young <sean@mess.org>

Please always add a description on your patches.

That's said, I'm not sure about this patch.

I don't like adding private APIs, as different hardware manufacturers tend 
to implement the same features on other hardware. Also, this makes userspace
apps full of per-device hacks, with is not a good idea.

So, why adding those as a redrat3-specific sysfs API? Can't we make them
generic enough and add at the LIRC API instead?

The other patches in this series are OK, and were applied already.

Regards,
Mauro

> ---
>  Documentation/ABI/testing/sysfs-class-rc-redrat3 |  33 ++++
>  drivers/media/rc/redrat3.c                       | 200 +++++++++++++++++++++++
>  2 files changed, 233 insertions(+)
>  create mode 100644 Documentation/ABI/testing/sysfs-class-rc-redrat3
> 
> diff --git a/Documentation/ABI/testing/sysfs-class-rc-redrat3 b/Documentation/ABI/testing/sysfs-class-rc-redrat3
> new file mode 100644
> index 0000000..33a24fa
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-class-rc-redrat3
> @@ -0,0 +1,33 @@
> +What:		/sys/class/rc/rcN/length_fuzz
> +Date:		Jul 2016
> +KernelVersion:	4.8
> +Contact:	Mauro Carvalho Chehab <m.chehab@samsung.com>
> +Description:
> +		The redrat3 encodes an IR signal as set of different lengths
> +		and a set of indices into those lengths. Writing this file
> +		sets how much two lengths must differ before they are
> +		considered distinct, the value is specified in microseconds.
> +		Default 5, value 0 to 127.
> +
> +What:		/sys/class/rc/rcN/min_pause
> +Date:		Jul 2016
> +KernelVersion:	4.8
> +Contact:	Mauro Carvalho Chehab <m.chehab@samsung.com>
> +Description:
> +		When receiving a continuous ir stream (for example when a user
> +		is holding a button down on a remote), this specifies the
> +		minimum size of a space when the redrat3 sends a irdata packet
> +		to the host. Specified in miliseconds. Default value 18ms.
> +		The value can be between 2 and 30 inclusive.
> +
> +What:		/sys/class/rc/rcN/periods_measure_carrier
> +Date:		Jul 2016
> +KernelVersion:	4.8
> +Contact:	Mauro Carvalho Chehab <m.chehab@samsung.com>
> +Description:
> +		The carrier frequency is measured during the first pulse of
> +		the IR signal. The larger the number of periods used To
> +		measure, the more accurate the result is likely to be, however
> +		some signals have short initial pulses, so in some case it
> +		may be necessary for applications to reduce this value.
> +		Default 8, value 1 to 255.
> diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
> index 399f44d..8365547 100644
> --- a/drivers/media/rc/redrat3.c
> +++ b/drivers/media/rc/redrat3.c
> @@ -860,6 +860,195 @@ static void redrat3_led_complete(struct urb *urb)
>  	atomic_dec(&rr3->flash);
>  }
>  
> +static ssize_t min_pause_store(struct device *dev,
> +				 struct device_attribute *attr,
> +				 const char *buf, size_t len)
> +{
> +	struct rc_dev *rc_dev = to_rc_dev(dev);
> +	struct redrat3_dev *rr3 = rc_dev->priv;
> +	struct usb_device *udev = rr3->udev;
> +	long value;
> +	u8 *pause;
> +	int rc;
> +
> +	rc = kstrtol(buf, 0, &value);
> +	if (rc)
> +		return rc;
> +
> +	if (value < 2 || value > 30)
> +		return -EINVAL;
> +
> +	pause = kmalloc(sizeof(*pause), GFP_KERNEL);
> +	if (!pause)
> +		return -ENOMEM;
> +
> +	*pause = (65536 - (value * 2000)) / 256;
> +	rc = usb_control_msg(udev, usb_sndctrlpipe(udev, 0), RR3_SET_IR_PARAM,
> +		     USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_OUT,
> +		     RR3_IR_IO_MIN_PAUSE, 0, pause, sizeof(*pause), HZ * 25);
> +	dev_dbg(dev, "set ir parm min pause %d rc 0x%02x\n", *pause, rc);
> +	if (rc == sizeof(*pause))
> +		rc = len;
> +
> +	kfree(pause);
> +
> +	return rc;
> +}
> +
> +static ssize_t min_pause_show(struct device *dev,
> +				struct device_attribute *attr, char *buf)
> +{
> +	struct rc_dev *rc_dev = to_rc_dev(dev);
> +	struct redrat3_dev *rr3 = rc_dev->priv;
> +	struct usb_device *udev = rr3->udev;
> +	int rc;
> +	u8 *pause;
> +
> +	pause = kmalloc(sizeof(*pause), GFP_KERNEL);
> +	if (!pause)
> +		return -ENOMEM;
> +
> +	rc = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0), RR3_GET_IR_PARAM,
> +		     USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
> +		     RR3_IR_IO_MIN_PAUSE, 0, pause, sizeof(*pause), HZ * 25);
> +	dev_dbg(dev, "get ir parm len pause %d rc 0x%02x\n", *pause, rc);
> +	if (rc == sizeof(*pause))
> +		rc = sprintf(buf, "%d\n", (65536 - 256 * *pause) / 2000);
> +
> +	kfree(pause);
> +
> +	return rc;
> +}
> +
> +static ssize_t length_fuzz_store(struct device *dev,
> +				 struct device_attribute *attr,
> +				 const char *buf, size_t len)
> +{
> +	struct rc_dev *rc_dev = to_rc_dev(dev);
> +	struct redrat3_dev *rr3 = rc_dev->priv;
> +	struct usb_device *udev = rr3->udev;
> +	long value;
> +	u8 *fuzz;
> +	int rc;
> +
> +	rc = kstrtol(buf, 0, &value);
> +	if (rc)
> +		return rc;
> +
> +	if (value < 0 || value > 127)
> +		return -EINVAL;
> +
> +	fuzz = kmalloc(sizeof(*fuzz), GFP_KERNEL);
> +	if (!fuzz)
> +		return -ENOMEM;
> +
> +	*fuzz = value * 2;
> +	rc = usb_control_msg(udev, usb_sndctrlpipe(udev, 0), RR3_SET_IR_PARAM,
> +		     USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_OUT,
> +		     RR3_IR_IO_LENGTH_FUZZ, 0, fuzz, sizeof(*fuzz), HZ * 25);
> +	dev_dbg(dev, "set ir parm len fuzz %d rc 0x%02x\n", *fuzz, rc);
> +	if (rc == sizeof(*fuzz))
> +		rc = len;
> +
> +	kfree(fuzz);
> +
> +	return rc;
> +}
> +
> +static ssize_t length_fuzz_show(struct device *dev,
> +				struct device_attribute *attr, char *buf)
> +{
> +	struct rc_dev *rc_dev = to_rc_dev(dev);
> +	struct redrat3_dev *rr3 = rc_dev->priv;
> +	struct usb_device *udev = rr3->udev;
> +	int rc;
> +	u8 *fuzz;
> +
> +	fuzz = kmalloc(sizeof(*fuzz), GFP_KERNEL);
> +	if (!fuzz)
> +		return -ENOMEM;
> +
> +	rc = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0), RR3_GET_IR_PARAM,
> +		     USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
> +		     RR3_IR_IO_LENGTH_FUZZ, 0, fuzz, sizeof(*fuzz), HZ * 25);
> +	dev_dbg(dev, "get ir parm len fuzz %d rc 0x%02x\n", *fuzz, rc);
> +	if (rc == sizeof(*fuzz))
> +		rc = sprintf(buf, "%d\n", *fuzz / 2);
> +
> +	kfree(fuzz);
> +
> +	return rc;
> +}
> +
> +static ssize_t periods_measure_carrier_store(struct device *dev,
> +				 struct device_attribute *attr,
> +				 const char *buf, size_t len)
> +{
> +	struct rc_dev *rc_dev = to_rc_dev(dev);
> +	struct redrat3_dev *rr3 = rc_dev->priv;
> +	struct usb_device *udev = rr3->udev;
> +	long value;
> +	u8 *periods;
> +	int rc;
> +
> +	rc = kstrtol(buf, 0, &value);
> +	if (rc)
> +		return rc;
> +
> +	if (value < 1 || value > 255)
> +		return -EINVAL;
> +
> +	periods = kmalloc(sizeof(*periods), GFP_KERNEL);
> +	if (!periods)
> +		return -ENOMEM;
> +
> +	*periods = value;
> +	rc = usb_control_msg(udev, usb_sndctrlpipe(udev, 0), RR3_SET_IR_PARAM,
> +			     USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_OUT,
> +			     RR3_IR_IO_LENGTH_FUZZ, 0, periods,
> +			     sizeof(*periods), HZ * 25);
> +	dev_dbg(dev, "set ir parm periods to measure carrier %d rc 0x%02x\n",
> +								*periods, rc);
> +	if (rc == sizeof(*periods))
> +		rc = len;
> +
> +	kfree(periods);
> +
> +	return rc;
> +}
> +
> +static ssize_t periods_measure_carrier_show(struct device *dev,
> +				struct device_attribute *attr, char *buf)
> +{
> +	struct rc_dev *rc_dev = to_rc_dev(dev);
> +	struct redrat3_dev *rr3 = rc_dev->priv;
> +	struct usb_device *udev = rr3->udev;
> +	u8 *periods;
> +	int rc;
> +
> +	periods = kmalloc(sizeof(*periods), GFP_KERNEL);
> +	if (!periods)
> +		return -ENOMEM;
> +
> +	rc = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0), RR3_GET_IR_PARAM,
> +			     USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
> +			     RR3_IR_IO_LENGTH_FUZZ, 0, periods,
> +			     sizeof(*periods), HZ * 25);
> +	dev_dbg(dev, "get ir parm periods to measure carrier %d rc 0x%02x\n",
> +								*periods, rc);
> +	if (rc == sizeof(*periods))
> +		rc = sprintf(buf, "%d\n", *periods);
> +
> +	kfree(periods);
> +
> +	return rc;
> +}
> +
> +static struct device_attribute redrat3_attrs[] = {
> +	__ATTR_RW(length_fuzz), __ATTR_RW(min_pause),
> +	__ATTR_RW(periods_measure_carrier)
> +};
> +
>  static struct rc_dev *redrat3_init_rc_dev(struct redrat3_dev *rr3)
>  {
>  	struct device *dev = rr3->dev;
> @@ -1036,6 +1225,13 @@ static int redrat3_dev_probe(struct usb_interface *intf,
>  		retval = -ENOMEM;
>  		goto led_free_error;
>  	}
> +	for (i = 0; i < ARRAY_SIZE(redrat3_attrs); i++) {
> +		retval = device_create_file(&rr3->rc->dev, &redrat3_attrs[i]);
> +		if (retval) {
> +			rc_unregister_device(rr3->rc);
> +			goto led_free_error;
> +		}
> +	}
>  
>  	/* we can register the device now, as it is ready */
>  	usb_set_intfdata(intf, rr3);
> @@ -1057,10 +1253,14 @@ static void redrat3_dev_disconnect(struct usb_interface *intf)
>  {
>  	struct usb_device *udev = interface_to_usbdev(intf);
>  	struct redrat3_dev *rr3 = usb_get_intfdata(intf);
> +	int i;
>  
>  	if (!rr3)
>  		return;
>  
> +	for (i = 0; i < ARRAY_SIZE(redrat3_attrs); i++)
> +		device_remove_file(&rr3->rc->dev, &redrat3_attrs[i]);
> +
>  	usb_set_intfdata(intf, NULL);
>  	rc_unregister_device(rr3->rc);
>  	led_classdev_unregister(&rr3->led);



Thanks,
Mauro
