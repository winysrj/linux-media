Return-path: <linux-media-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:38674 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727950AbeJaJba (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 Oct 2018 05:31:30 -0400
Date: Tue, 30 Oct 2018 21:35:31 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Sean Young <sean@mess.org>
Cc: David Howells <dhowells@redhat.com>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Brad Love <brad@nextdimension.cc>, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dvb: Allow MAC addresses to be mapped to stable device
 names with udev
Message-ID: <20181030213513.51922545@coco.lan>
In-Reply-To: <20181030223249.dhwhxdjipzmjxzsy@gofer.mess.org>
References: <153778383104.14867.1567557014782141706.stgit@warthog.procyon.org.uk>
        <20181030110319.764f33f0@coco.lan>
        <20181030223249.dhwhxdjipzmjxzsy@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 30 Oct 2018 22:32:50 +0000
Sean Young <sean@mess.org> escreveu:

Thanks for reviewing it!

> On Tue, Oct 30, 2018 at 11:03:19AM -0300, Mauro Carvalho Chehab wrote:
> > Em Mon, 24 Sep 2018 11:10:31 +0100
> > David Howells <dhowells@redhat.com> escreveu:
> >  =20
> > > Some devices, such as the DVBSky S952 and T982 cards, are dual port c=
ards
> > > that provide two cx23885 devices on the same PCI device, which means =
the
> > > attributes available for writing udev rules are exactly the same, apa=
rt
> > > from the adapter number.  Unfortunately, the adapter numbers are depe=
ndent
> > > on the order in which things are initialised, so this can change over
> > > different releases of the kernel.
> > >=20
> > > Devices have a MAC address available, which is printed during boot: =
=20
>=20
> Not all dvb devices have a mac address.

True. Usually, devices without eeprom don't have, specially the too old one=
s.

On others, the MAC address only appear after the firmware is loaded.

> > >=20
> > > 	[   10.951517] DVBSky T982 port 1 MAC address: 00:11:22:33:44:55
> > > 	...
> > > 	[   10.984875] DVBSky T982 port 2 MAC address: 00:11:22:33:44:56
> > >=20
> > > To make it possible to distinguish these in udev, provide sysfs attri=
butes
> > > to make the MAC address, adapter number and type available.  There are
> > > other fields that could perhaps be exported also.  In particular, it =
would
> > > be nice to provide the port number, but somehow that doesn't manage to
> > > propagate through the labyrinthine initialisation process.
> > >=20
> > > The new sysfs attributes can be seen from userspace as:
> > >=20
> > > 	[root@deneb ~]# ls /sys/class/dvb/dvb0.frontend0/
> > > 	dev  device  dvb_adapter  dvb_mac  dvb_type
> > > 	power  subsystem  uevent
> > > 	[root@deneb ~]# cat /sys/class/dvb/dvb0.frontend0/dvb_*
> > > 	0
> > > 	00:11:22:33:44:55
> > > 	frontend
> > >=20
> > > They can be used in udev rules:
> > >=20
> > > 	SUBSYSTEM=3D=3D"dvb", ATTRS{vendor}=3D=3D"0x14f1", ATTRS{device}=3D=
=3D"0x8852", ATTRS{subsystem_device}=3D=3D"0x0982", ATTR{dvb_mac}=3D=3D"00:=
11:22:33:44:55", PROGRAM=3D"/bin/sh -c 'K=3D%k; K=3D$${K#dvb}; printf dvb/a=
dapter9820/%%s $${K#*.}'", SYMLINK+=3D"%c"
> > > 	SUBSYSTEM=3D=3D"dvb", ATTRS{vendor}=3D=3D"0x14f1", ATTRS{device}=3D=
=3D"0x8852", ATTRS{subsystem_device}=3D=3D"0x0982", ATTR{dvb_mac}=3D=3D"00:=
11.22.33.44.56", PROGRAM=3D"/bin/sh -c 'K=3D%k; K=3D$${K#dvb}; printf dvb/a=
dapter9821/%%s $${K#*.}'", SYMLINK+=3D"%c"
> > >=20
> > > where the match is made with ATTR{dvb_mac} or similar.  The rules abo=
ve
> > > make symlinks from /dev/dvb/adapter982/* to /dev/dvb/adapterXX/*.
> > >=20
> > > Note that binding the dvb-net device to a network interface and chang=
ing it
> > > there does not reflect back into the the dvb_adapter struct and doesn=
't
> > > change the MAC address here.  This means that a system with two ident=
ical
> > > cards in it may need to distinguish them by some other means than MAC
> > > address.
> > >=20
> > > Signed-off-by: David Howells <dhowells@redhat.com> =20
> >=20
> > Looks OK to me.
> >=20
> > Michael/Sean/Brad,
> >=20
> > Any comments? If not, I'll probably submit it this week upstream. =20
>=20
> With this patch, with a usb Hauppauge Nova-T Stick I get:

Weird. Normally, Hauppauge devices have MAC address, as they all have
eeproms. On several models, the MAC is even printed at the label on
its back.

Perhaps the logic didn't wait for the firmware to load?

>=20
> $ tail /sys/class/dvb/*/dvb_*
> =3D=3D> /sys/class/dvb/dvb0.demux0/dvb_adapter <=3D=3D =20
> 0
>=20
> =3D=3D> /sys/class/dvb/dvb0.demux0/dvb_mac <=3D=3D =20
> 00:00:00:00:00:00
>=20
> =3D=3D> /sys/class/dvb/dvb0.demux0/dvb_type <=3D=3D =20
> demux
>=20
> =3D=3D> /sys/class/dvb/dvb0.dvr0/dvb_adapter <=3D=3D =20
> 0
>=20
> =3D=3D> /sys/class/dvb/dvb0.dvr0/dvb_mac <=3D=3D =20
> 00:00:00:00:00:00
>=20
> =3D=3D> /sys/class/dvb/dvb0.dvr0/dvb_type <=3D=3D =20
> dvr
>=20
> =3D=3D> /sys/class/dvb/dvb0.frontend0/dvb_adapter <=3D=3D =20
> 0
>=20
> =3D=3D> /sys/class/dvb/dvb0.frontend0/dvb_mac <=3D=3D =20
> 00:00:00:00:00:00
>=20
> =3D=3D> /sys/class/dvb/dvb0.frontend0/dvb_type <=3D=3D =20
> frontend
>=20
> =3D=3D> /sys/class/dvb/dvb0.net0/dvb_adapter <=3D=3D =20
> 0
>=20
> =3D=3D> /sys/class/dvb/dvb0.net0/dvb_mac <=3D=3D =20
> 00:00:00:00:00:00
>=20
> =3D=3D> /sys/class/dvb/dvb0.net0/dvb_type <=3D=3D =20
> net
>=20
>=20
> This would mean a stable name is based on a mac of 0, and there are many
> more devices don't have a mac so they would all match this stable name.

It can only provide information when the device has it.=20

> Devices without a mac address shouldn't have a mac_dvb sysfs attribute,
> I think.

Hmm... do you mean that, if the mac is reported as 00:00:00:00:00,
then the sysfs node should not be exposed? Makes sense.

> The dvb type and dvb adapter no is already present in the device name,
> I'm not sure why this needs duplicating.

IMO, it helps to write udev rules if those information are exposed.

>=20
>=20
> Sean
>=20
> > > ---
> > >=20
> > >  Documentation/ABI/testing/sysfs-class-dvb     |   29 +++++++++++
> > >  Documentation/media/dvb-drivers/udev.rst      |   29 +++++++++++
> > >  Documentation/media/uapi/dvb/intro.rst        |    7 +++
> > >  Documentation/media/uapi/dvb/stable_names.rst |   66 +++++++++++++++=
++++++++++
> > >  drivers/media/dvb-core/dvbdev.c               |   36 ++++++++++++++
> > >  5 files changed, 167 insertions(+)
> > >  create mode 100644 Documentation/ABI/testing/sysfs-class-dvb
> > >  create mode 100644 Documentation/media/uapi/dvb/stable_names.rst
> > >=20
> > > diff --git a/Documentation/ABI/testing/sysfs-class-dvb b/Documentatio=
n/ABI/testing/sysfs-class-dvb
> > > new file mode 100644
> > > index 000000000000..09e3be329c92
> > > --- /dev/null
> > > +++ b/Documentation/ABI/testing/sysfs-class-dvb
> > > @@ -0,0 +1,29 @@
> > > +What:		/sys/class/dvb/.../dvb_adapter
> > > +Date:		September 2018
> > > +KernelVersion:	4.20
> > > +Contact:	David Howells <dhowells@redhat.com>
> > > +Description:
> > > +		This displays the assigned adapter number of a DVB device.
> > > +
> > > +What:		/sys/class/dvb/.../dvb_mac
> > > +Date:		September 2018
> > > +KernelVersion:	4.20
> > > +Contact:	David Howells <dhowells@redhat.com>
> > > +Description:
> > > +		This displays the mac address of a DVB device.  This can be
> > > +		used by udev to name stable device files for DVB devices and
> > > +		avoid problems with changes in the order of device
> > > +		initialisation changing the assigned device numbers.  See:
> > > +
> > > +			Documentation/media/dvb-drivers/udev.rst
> > > +			Documentation/media/uapi/dvb/stable_names.rst
> > > +
> > > +		for information on how to actually do this.
> > > +
> > > +What:		/sys/class/dvb/.../dvb_type
> > > +Date:		September 2018
> > > +KernelVersion:	4.20
> > > +Contact:	David Howells <dhowells@redhat.com>
> > > +Description:
> > > +		This displays the object type of a DVB device interface, such
> > > +		as "frontend" or "demux".
> > > diff --git a/Documentation/media/dvb-drivers/udev.rst b/Documentation=
/media/dvb-drivers/udev.rst
> > > index 7d7d5d82108a..df754312f1f4 100644
> > > --- a/Documentation/media/dvb-drivers/udev.rst
> > > +++ b/Documentation/media/dvb-drivers/udev.rst
> > > @@ -59,3 +59,32 @@ have a look at "man udev".
> > >  For every device that registers to the sysfs subsystem with a "dvb" =
prefix,
> > >  the helper script /etc/udev/scripts/dvb.sh is invoked, which will th=
en
> > >  create the proper device node in your /dev/ directory.
> > > +
> > > +2. A DVB device's adapter number, type and MAC addresses are exposed=
 through
> > > +the sysfs interface as files dvb_adapter, dvb_type and dvb_mac in th=
e various
> > > +dvb object directories, e.g. /sys/class/dvb/dvb0.demux0/dvb_mac.
> > > +
> > > +These can be used to influence the binding of devices to names in /d=
ev to avoid
> > > +problems when the order in which names are assigned changes.  This i=
s of
> > > +particular interest when you have, say, a PCI card with multiple ide=
ntical
> > > +devices on board under the same PCI function slot.  The only way to =
distinguish
> > > +them is either by the DVB port number or the DVB MAC address.
> > > +
> > > +To make use of this with udev, a rule needs to be emplaced in a file=
 under
> > > +/etc/udev/rules.d/ that has an appropriate ATTR{} clause in it.  Som=
ething like
> > > +the following, for example::
> > > +
> > > +	SUBSYSTEM=3D=3D"dvb", ATTRS{vendor}=3D=3D"0x14f1", ATTRS{device}=3D=
=3D"0x8852", ATTRS{subsystem_device}=3D=3D"0x0982", ATTR{dvb_mac}=3D=3D"00:=
11:22:33:44:55", PROGRAM=3D"/bin/sh -c 'K=3D%k; K=3D$${K#dvb}; printf dvb/a=
dapter9820/%%s $${K#*.}'", SYMLINK+=3D"%c"
> > > +
> > > +Note the 'ATTR{dvb_mac}' clause that indicates the MAC address to lo=
ok for.
> > > +This should be different for every device, even if the devices are o=
therwise
> > > +identical.  The other ATTR{} clauses in this example refer to PCI pa=
rameters.
> > > +
> > > +This example generates a directory called /dev/dvb/adapter9820/ and =
places
> > > +symlinks in it to the device files under the appropriate /dev/dvb/ad=
apterX/
> > > +directory - whatever X happens to be today.
> > > +
> > > +The generated name is then stable and can be relied on by programs t=
hat need to
> > > +pick it up without user interaction.
> > > +
> > > +Note that this facility does not exist in v4.19 kernels and earlier.
> > > diff --git a/Documentation/media/uapi/dvb/intro.rst b/Documentation/m=
edia/uapi/dvb/intro.rst
> > > index 79b4d0e4e920..074fb3b3ee21 100644
> > > --- a/Documentation/media/uapi/dvb/intro.rst
> > > +++ b/Documentation/media/uapi/dvb/intro.rst
> > > @@ -153,6 +153,13 @@ where ``N`` enumerates the Digital TV cards in a=
 system starting from=C2=A00, and
> > >  from=C2=A00, too. We will omit the =E2=80=9C``/dev/dvb/adapterN/``\ =
=E2=80=9D in the further
> > >  discussion of these devices.
> > > =20
> > > +Note that the automatic numbering of adapters isn't stable and may v=
ary
> > > +depending on changes to the order in which devices are initialised, =
both in
> > > +the order in which individual devices get initialised and also the o=
rder in
> > > +which subdevices get initialised (e.g. a PCI card with multiple iden=
tical DVB
> > > +devices attached to the same PCI function).  :ref:`stable_names` sho=
ws use
> > > +udev rules to create stable names.
> > > +
> > >  More details about the data structures and function calls of all the
> > >  devices are described in the following chapters.
> > > =20
> > > diff --git a/Documentation/media/uapi/dvb/stable_names.rst b/Document=
ation/media/uapi/dvb/stable_names.rst
> > > new file mode 100644
> > > index 000000000000..1b5dc5171ee3
> > > --- /dev/null
> > > +++ b/Documentation/media/uapi/dvb/stable_names.rst
> > > @@ -0,0 +1,66 @@
> > > +.. -*- coding: utf-8; mode: rst -*-
> > > +
> > > +.. _stable_names:
> > > +
> > > +*********************************
> > > +Creating stable device file names
> > > +*********************************
> > > +
> > > +From time to time the order in which the Linux kernel initialises de=
vices and
> > > +initialises subdevices within those devices has changed.  This can c=
ause the
> > > +assignment of user-visible device numbers to devices to fluctuate - =
leading to
> > > +the failure of services to operate correctly in non-obvious ways whe=
n multiple,
> > > +otherwise identical devices are available in a system.
> > > +
> > > +To counteract this, udev rules can be defined that map devices onto =
stable
> > > +names.  This must, however, be done in relation to attributes of a d=
evice that
> > > +don't vary, such as the MAC address.
> > > +
> > > +Take, for example, a PCI DVB card that has two identical DVB devices=
 attached
> > > +to the same PCI function.  The devices cannot be distinguished on PCI
> > > +parameters and the DVB port number - which could otherwise distingui=
sh these
> > > +subdevices - is not easily accessible by userspace.
> > > +
> > > +The MAC address, however, *is* made available, and this is supposed =
to be
> > > +unique to each individual DVB device, and won't vary even if the dev=
ice is
> > > +moved to another slot.  This is exported to userspace through sysfs.=
  It can
> > > +be found by looking in the dvb_mac file that can be found in a device
> > > +interface's directory, for example:
> > > +
> > > +	/sys/class/dvb/dvb0.demux0/dvb_mac
> > > +
> > > +Two other files can be found there that export the adapter number an=
d the
> > > +interface type:
> > > +
> > > +	/sys/class/dvb/dvb0.demux0/dvb_adapter
> > > +	/sys/class/dvb/dvb0.demux0/dvb_type
> > > +
> > > +Note that the two numbers in the path are assigned based on the orde=
r in which
> > > +the devices are registered with the core code, and not necessarily o=
n the
> > > +physical arrangement of the device - and thus should not be consider=
ed stable.
> > > +
> > > +
> > > +The creation of stable names can be done by writing rules for udev t=
o match on
> > > +the MAC addresses of the devices.  Rules needs to be placed in a fil=
e in the
> > > +/etc/udev/rules.d/ directory for udev to pick up.  They need appropr=
iate
> > > +ATTR{} clauses to specify the attribute matches to make.  Any of the=
 above
> > > +mentioned files can be used.  For example::
> > > +
> > > +	SUBSYSTEM=3D=3D"dvb", ATTRS{vendor}=3D=3D"0x14f1", ATTRS{device}=3D=
=3D"0x8852", ATTRS{subsystem_device}=3D=3D"0x0982", ATTR{dvb_mac}=3D=3D"00:=
11:22:33:44:55", PROGRAM=3D"/bin/sh -c 'K=3D%k; K=3D$${K#dvb}; printf dvb/a=
dapter9820/%%s $${K#*.}'", SYMLINK+=3D"%c"
> > > +	SUBSYSTEM=3D=3D"dvb", ATTRS{vendor}=3D=3D"0x14f1", ATTRS{device}=3D=
=3D"0x8852", ATTRS{subsystem_device}=3D=3D"0x0982", ATTR{dvb_mac}=3D=3D"00:=
11.22.33.44.56", PROGRAM=3D"/bin/sh -c 'K=3D%k; K=3D$${K#dvb}; printf dvb/a=
dapter9821/%%s $${K#*.}'", SYMLINK+=3D"%c"
> > > +
> > > +In each of these example rules, the first three ATTR{} clauses speci=
fy the PCI
> > > +card to match - in this case the same DVBsky T982 dual T2 receiver c=
ard.  The
> > > +ATTR{dvb_mac} attribute in each specifies the card MAC address of th=
at
> > > +receiver unit (the name of the attribute refers to the name of sysfs=
 file to
> > > +read).
> > > +
> > > +This example generates a pair of directories called /dev/dvb/adapter=
9820/ and
> > > +/dev/dvb/adapter9821/ and places in each symlinks to the device file=
s under
> > > +the appropriate /dev/dvb/adapterX/ and /dev/dvb/adapterY/ directorie=
s -
> > > +whatever X and Y happens to be today.
> > > +
> > > +The generated names are then stable and can be relied on by programs=
 that need
> > > +to pick it up without user interaction.
> > > +
> > > +Note that this facility does not exist in v4.19 kernels and earlier.
> > > diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core=
/dvbdev.c
> > > index 64d6793674b9..41be3ba66341 100644
> > > --- a/drivers/media/dvb-core/dvbdev.c
> > > +++ b/drivers/media/dvb-core/dvbdev.c
> > > @@ -995,6 +995,41 @@ void dvb_module_release(struct i2c_client *clien=
t)
> > >  EXPORT_SYMBOL_GPL(dvb_module_release);
> > >  #endif
> > > =20
> > > +static ssize_t dvb_adapter_show(struct device *dev,
> > > +				struct device_attribute *attr, char *buf)
> > > +{
> > > +	struct dvb_device *dvbdev =3D dev_get_drvdata(dev);
> > > +
> > > +	return sprintf(buf, "%d\n", dvbdev->adapter->num);
> > > +}
> > > +static DEVICE_ATTR_RO(dvb_adapter);
> > > +
> > > +static ssize_t dvb_mac_show(struct device *dev,
> > > +			    struct device_attribute *attr, char *buf)
> > > +{
> > > +	struct dvb_device *dvbdev =3D dev_get_drvdata(dev);
> > > +
> > > +	return sprintf(buf, "%pM\n", dvbdev->adapter->proposed_mac);
> > > +}
> > > +static DEVICE_ATTR_RO(dvb_mac);
> > > +
> > > +static ssize_t dvb_type_show(struct device *dev,
> > > +			     struct device_attribute *attr, char *buf)
> > > +{
> > > +	struct dvb_device *dvbdev =3D dev_get_drvdata(dev);
> > > +
> > > +	return sprintf(buf, "%s\n", dnames[dvbdev->type]);
> > > +}
> > > +static DEVICE_ATTR_RO(dvb_type);
> > > +
> > > +static struct attribute *dvb_class_attrs[] =3D {
> > > +	&dev_attr_dvb_adapter.attr,
> > > +	&dev_attr_dvb_mac.attr,
> > > +	&dev_attr_dvb_type.attr,
> > > +	NULL
> > > +};
> > > +ATTRIBUTE_GROUPS(dvb_class);
> > > +
> > >  static int dvb_uevent(struct device *dev, struct kobj_uevent_env *en=
v)
> > >  {
> > >  	struct dvb_device *dvbdev =3D dev_get_drvdata(dev);
> > > @@ -1035,6 +1070,7 @@ static int __init init_dvbdev(void)
> > >  		retval =3D PTR_ERR(dvb_class);
> > >  		goto error;
> > >  	}
> > > +	dvb_class->dev_groups =3D dvb_class_groups,
> > >  	dvb_class->dev_uevent =3D dvb_uevent;
> > >  	dvb_class->devnode =3D dvb_devnode;
> > >  	return 0;
> > >  =20
> >=20
> >=20
> >=20
> > Thanks,
> > Mauro =20



Thanks,
Mauro
