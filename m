Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:38196 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750838AbeCFLzf (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Mar 2018 06:55:35 -0500
Date: Tue, 6 Mar 2018 08:55:30 -0300
From: Mauro Carvalho Chehab <mchehab@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] dvb: Save port number and provide sysfs attributes to
 pass values to udev
Message-ID: <20180306085530.7b51aa29@vento.lan>
In-Reply-To: <151559583569.13545.12649741692530472663.stgit@warthog.procyon.org.uk>
References: <151559583569.13545.12649741692530472663.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi David,

Em Wed, 10 Jan 2018 14:50:35 +0000
David Howells <dhowells@redhat.com> escreveu:

> Some devices, such as the DVBSky S952 and T982 cards, are dual port cards
> that provide two cx23885 devices on the same PCI device, which means the
> attributes available for writing udev rules are exactly the same, apart
> from the adapter number.  Unfortunately, the adapter numbers are dependent
> on the order in which things are initialised, so this can change over
> different releases of the kernel.
> 
> The struct cx23885_tsport has a port number available, which is printed
> during boot:
> 
> 	[   10.951517] DVBSky T982 port 1 MAC address: 00:17:42:54:09:87
> 	...
> 	[   10.984875] DVBSky T982 port 2 MAC address: 00:17:42:54:09:88
> 
> To make it possible to distinguish these in udev, do the following steps:
> 
>  (1) Save the port number into struct dvb_adapter.
> 
>  (2) Provide sysfs attributes to export port number and also MAC address,
>      adapter number and type.  There are other fields that could perhaps be
>      exported also.
> 
> The new sysfs attributes can be seen from userspace as:
> 
> 	[root@deneb ~]# ls /sys/class/dvb/dvb0.frontend0/
> 	dev  device  dvb_adapter  dvb_mac  dvb_port  dvb_type
> 	power  subsystem  uevent
> 	[root@deneb ~]# cat /sys/class/dvb/dvb0.frontend0/dvb_*
> 	0
> 	00:17:42:54:09:87
> 	0
> 	frontend
> 
> They can be used in udev rules:
> 
> 	SUBSYSTEM=="dvb", ATTRS{vendor}=="0x14f1", ATTRS{device}=="0x8852", ATTRS{subsystem_device}=="0x0982", ATTR{dvb_mac}=="00:17:42:54:09:87", PROGRAM="/bin/sh -c 'K=%k; K=$${K#dvb}; printf dvb/adapter9820/%%s $${K#*.}'", SYMLINK+="%c"
> 	SUBSYSTEM=="dvb", ATTRS{vendor}=="0x14f1", ATTRS{device}=="0x8852", ATTRS{subsystem_device}=="0x0982", ATTR{dvb_mac}=="00:17:42:54:09:88", PROGRAM="/bin/sh -c 'K=%k; K=$${K#dvb}; printf dvb/adapter9821/%%s $${K#*.}'", SYMLINK+="%c"
> 
> where the match is made with ATTR{dvb_mac} or similar.  The rules above
> make symlinks from /dev/dvb/adapter982/* to /dev/dvb/adapterXX/*.
> 
> Note that binding the dvb-net device to a network interface and changing it
> there does not reflect back into the the dvb_adapter struct and doesn't
> change the MAC address here.  This means that a system with two identical
> cards in it may need to distinguish them by some other means than MAC
> address.

Sorry for not looking on it earlier... Has been very busy those days,
and the dvb sub-maintainer has not been responsive lately, due to some
personal issues.

> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
> 
>  drivers/media/dvb-core/dvbdev.c         |   46 +++++++++++++++++++++++++++++++
>  drivers/media/dvb-core/dvbdev.h         |    2 +
>  drivers/media/pci/cx23885/cx23885-dvb.c |    2 +
>  3 files changed, 50 insertions(+)
> 
> diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
> index 060c60ddfcc3..b3aa5ae3d57f 100644
> --- a/drivers/media/dvb-core/dvbdev.c
> +++ b/drivers/media/dvb-core/dvbdev.c
> @@ -941,6 +941,51 @@ int dvb_usercopy(struct file *file,
>  	return err;
>  }
>  
> +static ssize_t dvb_adapter_show(struct device *dev,
> +				struct device_attribute *attr, char *buf)
> +{
> +	struct dvb_device *dvbdev = dev_get_drvdata(dev);
> +
> +	return sprintf(buf, "%d\n", dvbdev->adapter->num);
> +}
> +static DEVICE_ATTR_RO(dvb_adapter);
> +
> +static ssize_t dvb_mac_show(struct device *dev,
> +			    struct device_attribute *attr, char *buf)
> +{
> +	struct dvb_device *dvbdev = dev_get_drvdata(dev);
> +
> +	return sprintf(buf, "%pM\n", dvbdev->adapter->proposed_mac);
> +}
> +static DEVICE_ATTR_RO(dvb_mac);
> +
> +static ssize_t dvb_port_show(struct device *dev,
> +			     struct device_attribute *attr, char *buf)
> +{
> +	struct dvb_device *dvbdev = dev_get_drvdata(dev);
> +
> +	return sprintf(buf, "%d\n", dvbdev->adapter->port_num);
> +}
> +static DEVICE_ATTR_RO(dvb_port);
> +
> +static ssize_t dvb_type_show(struct device *dev,
> +			     struct device_attribute *attr, char *buf)
> +{
> +	struct dvb_device *dvbdev = dev_get_drvdata(dev);
> +
> +	return sprintf(buf, "%s\n", dnames[dvbdev->type]);
> +}
> +static DEVICE_ATTR_RO(dvb_type);
> +
> +static struct attribute *dvb_class_attrs[] = {
> +	&dev_attr_dvb_adapter.attr,
> +	&dev_attr_dvb_mac.attr,
> +	&dev_attr_dvb_port.attr,
> +	&dev_attr_dvb_type.attr,
> +	NULL
> +};
> +ATTRIBUTE_GROUPS(dvb_class);
> +
>  static int dvb_uevent(struct device *dev, struct kobj_uevent_env *env)
>  {
>  	struct dvb_device *dvbdev = dev_get_drvdata(dev);
> @@ -981,6 +1026,7 @@ static int __init init_dvbdev(void)
>  		retval = PTR_ERR(dvb_class);
>  		goto error;
>  	}
> +	dvb_class->dev_groups = dvb_class_groups,
>  	dvb_class->dev_uevent = dvb_uevent;
>  	dvb_class->devnode = dvb_devnode;
>  	return 0;

The patch itself looks good, but I'm not seeing any documentation.

You should likely add something to Documentation/ABI and to the
DVB uAPI (Documentation/media/uapi/dvb).


> diff --git a/drivers/media/dvb-core/dvbdev.h b/drivers/media/dvb-core/dvbdev.h
> index bbc1c20c0529..1d5a170e279a 100644
> --- a/drivers/media/dvb-core/dvbdev.h
> +++ b/drivers/media/dvb-core/dvbdev.h
> @@ -83,6 +83,7 @@ struct dvb_frontend;
>   * @device_list:	List with the DVB devices
>   * @name:		Name of the adapter
>   * @proposed_mac:	proposed MAC address for the adapter
> + * @port_num:		Port number for multi-adapter devices
>   * @priv:		private data
>   * @device:		pointer to struct device
>   * @module:		pointer to struct module
> @@ -103,6 +104,7 @@ struct dvb_adapter {
>  	struct list_head device_list;
>  	const char *name;
>  	u8 proposed_mac [6];
> +	u8 port_num;
>  	void* priv;
>  
>  	struct device *device;
> diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c b/drivers/media/pci/cx23885/cx23885-dvb.c
> index e795ddeb7fe2..19c72c66d7e0 100644
> --- a/drivers/media/pci/cx23885/cx23885-dvb.c
> +++ b/drivers/media/pci/cx23885/cx23885-dvb.c
> @@ -1217,6 +1217,8 @@ static int dvb_register(struct cx23885_tsport *port)
>  	/* Sets the gate control callback to be used by i2c command calls */
>  	port->gate_ctrl = cx23885_dvb_gate_ctrl;
>  
> +	port->frontends.adapter.port_num = port->nr;
> +

Doing it for each multi-adapter device is something that bothers
me. The better would be if we could move this to the DVB Kernel,
in order to not need to check/fix every driver. If, otherwise,
this is not possible, then we need a patch fixing port_num for
all drivers that support multiple adapters.

Also, the risk of forgetting it seems high. So, perhaps we should
add a new parameter to some function (like at dvb_register_device
or at dvb_register_frontend), in order to make the port number
a mandatory attribute.


>  	/* init frontend */
>  	switch (dev->board) {
>  	case CX23885_BOARD_HAUPPAUGE_HVR1250:
> 



Thanks,
Mauro
