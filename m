Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:49061 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726376AbeJaH2M (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 Oct 2018 03:28:12 -0400
Date: Tue, 30 Oct 2018 22:32:50 +0000
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: David Howells <dhowells@redhat.com>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Brad Love <brad@nextdimension.cc>, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dvb: Allow MAC addresses to be mapped to stable device
 names with udev
Message-ID: <20181030223249.dhwhxdjipzmjxzsy@gofer.mess.org>
References: <153778383104.14867.1567557014782141706.stgit@warthog.procyon.org.uk>
 <20181030110319.764f33f0@coco.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20181030110319.764f33f0@coco.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Oct 30, 2018 at 11:03:19AM -0300, Mauro Carvalho Chehab wrote:
> Em Mon, 24 Sep 2018 11:10:31 +0100
> David Howells <dhowells@redhat.com> escreveu:
> 
> > Some devices, such as the DVBSky S952 and T982 cards, are dual port cards
> > that provide two cx23885 devices on the same PCI device, which means the
> > attributes available for writing udev rules are exactly the same, apart
> > from the adapter number.  Unfortunately, the adapter numbers are dependent
> > on the order in which things are initialised, so this can change over
> > different releases of the kernel.
> > 
> > Devices have a MAC address available, which is printed during boot:

Not all dvb devices have a mac address.

> > 
> > 	[   10.951517] DVBSky T982 port 1 MAC address: 00:11:22:33:44:55
> > 	...
> > 	[   10.984875] DVBSky T982 port 2 MAC address: 00:11:22:33:44:56
> > 
> > To make it possible to distinguish these in udev, provide sysfs attributes
> > to make the MAC address, adapter number and type available.  There are
> > other fields that could perhaps be exported also.  In particular, it would
> > be nice to provide the port number, but somehow that doesn't manage to
> > propagate through the labyrinthine initialisation process.
> > 
> > The new sysfs attributes can be seen from userspace as:
> > 
> > 	[root@deneb ~]# ls /sys/class/dvb/dvb0.frontend0/
> > 	dev  device  dvb_adapter  dvb_mac  dvb_type
> > 	power  subsystem  uevent
> > 	[root@deneb ~]# cat /sys/class/dvb/dvb0.frontend0/dvb_*
> > 	0
> > 	00:11:22:33:44:55
> > 	frontend
> > 
> > They can be used in udev rules:
> > 
> > 	SUBSYSTEM=="dvb", ATTRS{vendor}=="0x14f1", ATTRS{device}=="0x8852", ATTRS{subsystem_device}=="0x0982", ATTR{dvb_mac}=="00:11:22:33:44:55", PROGRAM="/bin/sh -c 'K=%k; K=$${K#dvb}; printf dvb/adapter9820/%%s $${K#*.}'", SYMLINK+="%c"
> > 	SUBSYSTEM=="dvb", ATTRS{vendor}=="0x14f1", ATTRS{device}=="0x8852", ATTRS{subsystem_device}=="0x0982", ATTR{dvb_mac}=="00:11.22.33.44.56", PROGRAM="/bin/sh -c 'K=%k; K=$${K#dvb}; printf dvb/adapter9821/%%s $${K#*.}'", SYMLINK+="%c"
> > 
> > where the match is made with ATTR{dvb_mac} or similar.  The rules above
> > make symlinks from /dev/dvb/adapter982/* to /dev/dvb/adapterXX/*.
> > 
> > Note that binding the dvb-net device to a network interface and changing it
> > there does not reflect back into the the dvb_adapter struct and doesn't
> > change the MAC address here.  This means that a system with two identical
> > cards in it may need to distinguish them by some other means than MAC
> > address.
> > 
> > Signed-off-by: David Howells <dhowells@redhat.com>
> 
> Looks OK to me.
> 
> Michael/Sean/Brad,
> 
> Any comments? If not, I'll probably submit it this week upstream.

With this patch, with a usb Hauppauge Nova-T Stick I get:

$ tail /sys/class/dvb/*/dvb_*
==> /sys/class/dvb/dvb0.demux0/dvb_adapter <==
0

==> /sys/class/dvb/dvb0.demux0/dvb_mac <==
00:00:00:00:00:00

==> /sys/class/dvb/dvb0.demux0/dvb_type <==
demux

==> /sys/class/dvb/dvb0.dvr0/dvb_adapter <==
0

==> /sys/class/dvb/dvb0.dvr0/dvb_mac <==
00:00:00:00:00:00

==> /sys/class/dvb/dvb0.dvr0/dvb_type <==
dvr

==> /sys/class/dvb/dvb0.frontend0/dvb_adapter <==
0

==> /sys/class/dvb/dvb0.frontend0/dvb_mac <==
00:00:00:00:00:00

==> /sys/class/dvb/dvb0.frontend0/dvb_type <==
frontend

==> /sys/class/dvb/dvb0.net0/dvb_adapter <==
0

==> /sys/class/dvb/dvb0.net0/dvb_mac <==
00:00:00:00:00:00

==> /sys/class/dvb/dvb0.net0/dvb_type <==
net


This would mean a stable name is based on a mac of 0, and there are many
more devices don't have a mac so they would all match this stable name.

Devices without a mac address shouldn't have a mac_dvb sysfs attribute,
I think.

The dvb type and dvb adapter no is already present in the device name,
I'm not sure why this needs duplicating.


Sean

> > ---
> > 
> >  Documentation/ABI/testing/sysfs-class-dvb     |   29 +++++++++++
> >  Documentation/media/dvb-drivers/udev.rst      |   29 +++++++++++
> >  Documentation/media/uapi/dvb/intro.rst        |    7 +++
> >  Documentation/media/uapi/dvb/stable_names.rst |   66 +++++++++++++++++++++++++
> >  drivers/media/dvb-core/dvbdev.c               |   36 ++++++++++++++
> >  5 files changed, 167 insertions(+)
> >  create mode 100644 Documentation/ABI/testing/sysfs-class-dvb
> >  create mode 100644 Documentation/media/uapi/dvb/stable_names.rst
> > 
> > diff --git a/Documentation/ABI/testing/sysfs-class-dvb b/Documentation/ABI/testing/sysfs-class-dvb
> > new file mode 100644
> > index 000000000000..09e3be329c92
> > --- /dev/null
> > +++ b/Documentation/ABI/testing/sysfs-class-dvb
> > @@ -0,0 +1,29 @@
> > +What:		/sys/class/dvb/.../dvb_adapter
> > +Date:		September 2018
> > +KernelVersion:	4.20
> > +Contact:	David Howells <dhowells@redhat.com>
> > +Description:
> > +		This displays the assigned adapter number of a DVB device.
> > +
> > +What:		/sys/class/dvb/.../dvb_mac
> > +Date:		September 2018
> > +KernelVersion:	4.20
> > +Contact:	David Howells <dhowells@redhat.com>
> > +Description:
> > +		This displays the mac address of a DVB device.  This can be
> > +		used by udev to name stable device files for DVB devices and
> > +		avoid problems with changes in the order of device
> > +		initialisation changing the assigned device numbers.  See:
> > +
> > +			Documentation/media/dvb-drivers/udev.rst
> > +			Documentation/media/uapi/dvb/stable_names.rst
> > +
> > +		for information on how to actually do this.
> > +
> > +What:		/sys/class/dvb/.../dvb_type
> > +Date:		September 2018
> > +KernelVersion:	4.20
> > +Contact:	David Howells <dhowells@redhat.com>
> > +Description:
> > +		This displays the object type of a DVB device interface, such
> > +		as "frontend" or "demux".
> > diff --git a/Documentation/media/dvb-drivers/udev.rst b/Documentation/media/dvb-drivers/udev.rst
> > index 7d7d5d82108a..df754312f1f4 100644
> > --- a/Documentation/media/dvb-drivers/udev.rst
> > +++ b/Documentation/media/dvb-drivers/udev.rst
> > @@ -59,3 +59,32 @@ have a look at "man udev".
> >  For every device that registers to the sysfs subsystem with a "dvb" prefix,
> >  the helper script /etc/udev/scripts/dvb.sh is invoked, which will then
> >  create the proper device node in your /dev/ directory.
> > +
> > +2. A DVB device's adapter number, type and MAC addresses are exposed through
> > +the sysfs interface as files dvb_adapter, dvb_type and dvb_mac in the various
> > +dvb object directories, e.g. /sys/class/dvb/dvb0.demux0/dvb_mac.
> > +
> > +These can be used to influence the binding of devices to names in /dev to avoid
> > +problems when the order in which names are assigned changes.  This is of
> > +particular interest when you have, say, a PCI card with multiple identical
> > +devices on board under the same PCI function slot.  The only way to distinguish
> > +them is either by the DVB port number or the DVB MAC address.
> > +
> > +To make use of this with udev, a rule needs to be emplaced in a file under
> > +/etc/udev/rules.d/ that has an appropriate ATTR{} clause in it.  Something like
> > +the following, for example::
> > +
> > +	SUBSYSTEM=="dvb", ATTRS{vendor}=="0x14f1", ATTRS{device}=="0x8852", ATTRS{subsystem_device}=="0x0982", ATTR{dvb_mac}=="00:11:22:33:44:55", PROGRAM="/bin/sh -c 'K=%k; K=$${K#dvb}; printf dvb/adapter9820/%%s $${K#*.}'", SYMLINK+="%c"
> > +
> > +Note the 'ATTR{dvb_mac}' clause that indicates the MAC address to look for.
> > +This should be different for every device, even if the devices are otherwise
> > +identical.  The other ATTR{} clauses in this example refer to PCI parameters.
> > +
> > +This example generates a directory called /dev/dvb/adapter9820/ and places
> > +symlinks in it to the device files under the appropriate /dev/dvb/adapterX/
> > +directory - whatever X happens to be today.
> > +
> > +The generated name is then stable and can be relied on by programs that need to
> > +pick it up without user interaction.
> > +
> > +Note that this facility does not exist in v4.19 kernels and earlier.
> > diff --git a/Documentation/media/uapi/dvb/intro.rst b/Documentation/media/uapi/dvb/intro.rst
> > index 79b4d0e4e920..074fb3b3ee21 100644
> > --- a/Documentation/media/uapi/dvb/intro.rst
> > +++ b/Documentation/media/uapi/dvb/intro.rst
> > @@ -153,6 +153,13 @@ where ``N`` enumerates the Digital TV cards in a system starting from 0, and
> >  from 0, too. We will omit the “``/dev/dvb/adapterN/``\ ” in the further
> >  discussion of these devices.
> >  
> > +Note that the automatic numbering of adapters isn't stable and may vary
> > +depending on changes to the order in which devices are initialised, both in
> > +the order in which individual devices get initialised and also the order in
> > +which subdevices get initialised (e.g. a PCI card with multiple identical DVB
> > +devices attached to the same PCI function).  :ref:`stable_names` shows use
> > +udev rules to create stable names.
> > +
> >  More details about the data structures and function calls of all the
> >  devices are described in the following chapters.
> >  
> > diff --git a/Documentation/media/uapi/dvb/stable_names.rst b/Documentation/media/uapi/dvb/stable_names.rst
> > new file mode 100644
> > index 000000000000..1b5dc5171ee3
> > --- /dev/null
> > +++ b/Documentation/media/uapi/dvb/stable_names.rst
> > @@ -0,0 +1,66 @@
> > +.. -*- coding: utf-8; mode: rst -*-
> > +
> > +.. _stable_names:
> > +
> > +*********************************
> > +Creating stable device file names
> > +*********************************
> > +
> > +From time to time the order in which the Linux kernel initialises devices and
> > +initialises subdevices within those devices has changed.  This can cause the
> > +assignment of user-visible device numbers to devices to fluctuate - leading to
> > +the failure of services to operate correctly in non-obvious ways when multiple,
> > +otherwise identical devices are available in a system.
> > +
> > +To counteract this, udev rules can be defined that map devices onto stable
> > +names.  This must, however, be done in relation to attributes of a device that
> > +don't vary, such as the MAC address.
> > +
> > +Take, for example, a PCI DVB card that has two identical DVB devices attached
> > +to the same PCI function.  The devices cannot be distinguished on PCI
> > +parameters and the DVB port number - which could otherwise distinguish these
> > +subdevices - is not easily accessible by userspace.
> > +
> > +The MAC address, however, *is* made available, and this is supposed to be
> > +unique to each individual DVB device, and won't vary even if the device is
> > +moved to another slot.  This is exported to userspace through sysfs.  It can
> > +be found by looking in the dvb_mac file that can be found in a device
> > +interface's directory, for example:
> > +
> > +	/sys/class/dvb/dvb0.demux0/dvb_mac
> > +
> > +Two other files can be found there that export the adapter number and the
> > +interface type:
> > +
> > +	/sys/class/dvb/dvb0.demux0/dvb_adapter
> > +	/sys/class/dvb/dvb0.demux0/dvb_type
> > +
> > +Note that the two numbers in the path are assigned based on the order in which
> > +the devices are registered with the core code, and not necessarily on the
> > +physical arrangement of the device - and thus should not be considered stable.
> > +
> > +
> > +The creation of stable names can be done by writing rules for udev to match on
> > +the MAC addresses of the devices.  Rules needs to be placed in a file in the
> > +/etc/udev/rules.d/ directory for udev to pick up.  They need appropriate
> > +ATTR{} clauses to specify the attribute matches to make.  Any of the above
> > +mentioned files can be used.  For example::
> > +
> > +	SUBSYSTEM=="dvb", ATTRS{vendor}=="0x14f1", ATTRS{device}=="0x8852", ATTRS{subsystem_device}=="0x0982", ATTR{dvb_mac}=="00:11:22:33:44:55", PROGRAM="/bin/sh -c 'K=%k; K=$${K#dvb}; printf dvb/adapter9820/%%s $${K#*.}'", SYMLINK+="%c"
> > +	SUBSYSTEM=="dvb", ATTRS{vendor}=="0x14f1", ATTRS{device}=="0x8852", ATTRS{subsystem_device}=="0x0982", ATTR{dvb_mac}=="00:11.22.33.44.56", PROGRAM="/bin/sh -c 'K=%k; K=$${K#dvb}; printf dvb/adapter9821/%%s $${K#*.}'", SYMLINK+="%c"
> > +
> > +In each of these example rules, the first three ATTR{} clauses specify the PCI
> > +card to match - in this case the same DVBsky T982 dual T2 receiver card.  The
> > +ATTR{dvb_mac} attribute in each specifies the card MAC address of that
> > +receiver unit (the name of the attribute refers to the name of sysfs file to
> > +read).
> > +
> > +This example generates a pair of directories called /dev/dvb/adapter9820/ and
> > +/dev/dvb/adapter9821/ and places in each symlinks to the device files under
> > +the appropriate /dev/dvb/adapterX/ and /dev/dvb/adapterY/ directories -
> > +whatever X and Y happens to be today.
> > +
> > +The generated names are then stable and can be relied on by programs that need
> > +to pick it up without user interaction.
> > +
> > +Note that this facility does not exist in v4.19 kernels and earlier.
> > diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
> > index 64d6793674b9..41be3ba66341 100644
> > --- a/drivers/media/dvb-core/dvbdev.c
> > +++ b/drivers/media/dvb-core/dvbdev.c
> > @@ -995,6 +995,41 @@ void dvb_module_release(struct i2c_client *client)
> >  EXPORT_SYMBOL_GPL(dvb_module_release);
> >  #endif
> >  
> > +static ssize_t dvb_adapter_show(struct device *dev,
> > +				struct device_attribute *attr, char *buf)
> > +{
> > +	struct dvb_device *dvbdev = dev_get_drvdata(dev);
> > +
> > +	return sprintf(buf, "%d\n", dvbdev->adapter->num);
> > +}
> > +static DEVICE_ATTR_RO(dvb_adapter);
> > +
> > +static ssize_t dvb_mac_show(struct device *dev,
> > +			    struct device_attribute *attr, char *buf)
> > +{
> > +	struct dvb_device *dvbdev = dev_get_drvdata(dev);
> > +
> > +	return sprintf(buf, "%pM\n", dvbdev->adapter->proposed_mac);
> > +}
> > +static DEVICE_ATTR_RO(dvb_mac);
> > +
> > +static ssize_t dvb_type_show(struct device *dev,
> > +			     struct device_attribute *attr, char *buf)
> > +{
> > +	struct dvb_device *dvbdev = dev_get_drvdata(dev);
> > +
> > +	return sprintf(buf, "%s\n", dnames[dvbdev->type]);
> > +}
> > +static DEVICE_ATTR_RO(dvb_type);
> > +
> > +static struct attribute *dvb_class_attrs[] = {
> > +	&dev_attr_dvb_adapter.attr,
> > +	&dev_attr_dvb_mac.attr,
> > +	&dev_attr_dvb_type.attr,
> > +	NULL
> > +};
> > +ATTRIBUTE_GROUPS(dvb_class);
> > +
> >  static int dvb_uevent(struct device *dev, struct kobj_uevent_env *env)
> >  {
> >  	struct dvb_device *dvbdev = dev_get_drvdata(dev);
> > @@ -1035,6 +1070,7 @@ static int __init init_dvbdev(void)
> >  		retval = PTR_ERR(dvb_class);
> >  		goto error;
> >  	}
> > +	dvb_class->dev_groups = dvb_class_groups,
> >  	dvb_class->dev_uevent = dvb_uevent;
> >  	dvb_class->devnode = dvb_devnode;
> >  	return 0;
> > 
> 
> 
> 
> Thanks,
> Mauro
