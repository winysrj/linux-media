Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:43415 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2992797AbdEAKgP (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 1 May 2017 06:36:15 -0400
Date: Mon, 1 May 2017 11:36:13 +0100
From: Sean Young <sean@mess.org>
To: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
Cc: linux-media@vger.kernel.org, mchehab@s-opensource.com
Subject: Re: [PATCH] rc-core: export the hardware type to sysfs
Message-ID: <20170501103613.GA10867@gofer.mess.org>
References: <149346020957.4157.4374621534433639100.stgit@zeus.hardeman.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <149346020957.4157.4374621534433639100.stgit@zeus.hardeman.nu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Apr 29, 2017 at 12:03:29PM +0200, David Härdeman wrote:
> Exporting the hardware type makes it possible for userspace applications
> to know what to expect from the hardware.
> 
> This makes it possible to write more user-friendly userspace apps.

This duplicates lirc features (LIRC_GET_FEATURES ioctl); the one exception
is that the scancode-only devices which have no lirc device, but there
are patches which change that.

https://patchwork.linuxtv.org/patch/39593/


Sean

> 
> Note that the size of sysfs_groups[] in struct rc_dev is not changed
> by this patch because it was already large enough for one more group.
> 
> Signed-off-by: David Härdeman <david@hardeman.nu>
> ---
>  drivers/media/rc/rc-main.c |   43 +++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 43 insertions(+)
> 
> diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
> index 85f95441b85b..e0f9b322ab02 100644
> --- a/drivers/media/rc/rc-main.c
> +++ b/drivers/media/rc/rc-main.c
> @@ -1294,6 +1294,38 @@ static ssize_t store_protocols(struct device *device,
>  }
>  
>  /**
> + * show_hwtype() - shows the hardware type in sysfs
> + * @device:	the &struct device descriptor
> + * @attr:	the &struct device_attribute
> + * @buf:	a pointer to the output buffer
> + *
> + * This callback function is used to get the hardware type of an rc device.
> + * It is triggered by reading /sys/class/rc/rc?/hwtype.
> + *
> + * Return: the number of bytes read or a negative error code.
> + */
> +static ssize_t show_hwtype(struct device *device,
> +			   struct device_attribute *attr,
> +			   char *buf)
> +{
> +	struct rc_dev *dev = to_rc_dev(device);
> +
> +	switch (dev->driver_type) {
> +	case RC_DRIVER_SCANCODE:
> +		return sprintf(buf, "scancode\n");
> +	case RC_DRIVER_IR_RAW_TX:
> +		return sprintf(buf, "ir-tx\n");
> +	case RC_DRIVER_IR_RAW:
> +		if (dev->tx_ir)
> +			return sprintf(buf, "ir-tx-rx\n");
> +		else
> +			return sprintf(buf, "ir-rx\n");
> +	default:
> +		return sprintf(buf, "<unknown>\n");
> +	}
> +}
> +
> +/**
>   * show_filter() - shows the current scancode filter value or mask
>   * @device:	the device descriptor
>   * @attr:	the device attribute struct
> @@ -1613,6 +1645,7 @@ static int rc_dev_uevent(struct device *device, struct kobj_uevent_env *env)
>   * Static device attribute struct with the sysfs attributes for IR's
>   */
>  static DEVICE_ATTR(protocols, 0644, show_protocols, store_protocols);
> +static DEVICE_ATTR(hwtype, 0444, show_hwtype, NULL);
>  static DEVICE_ATTR(wakeup_protocols, 0644, show_wakeup_protocols,
>  		   store_wakeup_protocols);
>  static RC_FILTER_ATTR(filter, S_IRUGO|S_IWUSR,
> @@ -1633,6 +1666,15 @@ static struct attribute_group rc_dev_protocol_attr_grp = {
>  	.attrs	= rc_dev_protocol_attrs,
>  };
>  
> +static struct attribute *rc_dev_hwtype_attrs[] = {
> +	&dev_attr_hwtype.attr,
> +	NULL,
> +};
> +
> +static struct attribute_group rc_dev_hwtype_attr_grp = {
> +	.attrs = rc_dev_hwtype_attrs,
> +};
> +
>  static struct attribute *rc_dev_filter_attrs[] = {
>  	&dev_attr_filter.attr.attr,
>  	&dev_attr_filter_mask.attr.attr,
> @@ -1863,6 +1905,7 @@ int rc_register_device(struct rc_dev *dev)
>  		dev->sysfs_groups[attr++] = &rc_dev_filter_attr_grp;
>  	if (dev->s_wakeup_filter)
>  		dev->sysfs_groups[attr++] = &rc_dev_wakeup_filter_attr_grp;
> +	dev->sysfs_groups[attr++] = &rc_dev_hwtype_attr_grp;
>  	dev->sysfs_groups[attr++] = NULL;
>  
>  	if (dev->driver_type != RC_DRIVER_IR_RAW_TX) {
