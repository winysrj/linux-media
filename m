Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:46395 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726054AbeJaRkj (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 Oct 2018 13:40:39 -0400
Date: Wed, 31 Oct 2018 08:43:27 +0000
From: Sean Young <sean@mess.org>
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: David Howells <dhowells@redhat.com>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Brad Love <brad@nextdimension.cc>, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dvb: Allow MAC addresses to be mapped to stable device
 names with udev
Message-ID: <20181031084327.25bd5654ij37o3b5@gofer.mess.org>
References: <153778383104.14867.1567557014782141706.stgit@warthog.procyon.org.uk>
 <20181030110319.764f33f0@coco.lan>
 <20181030223249.dhwhxdjipzmjxzsy@gofer.mess.org>
 <20181030213513.51922545@coco.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181030213513.51922545@coco.lan>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Oct 30, 2018 at 09:35:31PM -0300, Mauro Carvalho Chehab wrote:
> Em Tue, 30 Oct 2018 22:32:50 +0000
> Sean Young <sean@mess.org> escreveu:
> 
> Thanks for reviewing it!
> 
> > On Tue, Oct 30, 2018 at 11:03:19AM -0300, Mauro Carvalho Chehab wrote:
> > > Em Mon, 24 Sep 2018 11:10:31 +0100
> > > David Howells <dhowells@redhat.com> escreveu:
> > >   
> > > > Some devices, such as the DVBSky S952 and T982 cards, are dual port cards
> > > > that provide two cx23885 devices on the same PCI device, which means the
> > > > attributes available for writing udev rules are exactly the same, apart
> > > > from the adapter number.  Unfortunately, the adapter numbers are dependent
> > > > on the order in which things are initialised, so this can change over
> > > > different releases of the kernel.
> > > > 
> > > > Devices have a MAC address available, which is printed during boot:  
> > 
> > Not all dvb devices have a mac address.
> 
> True. Usually, devices without eeprom don't have, specially the too old ones.
> 
> On others, the MAC address only appear after the firmware is loaded.
> 
> > > > 
> > > > 	[   10.951517] DVBSky T982 port 1 MAC address: 00:11:22:33:44:55
> > > > 	...
> > > > 	[   10.984875] DVBSky T982 port 2 MAC address: 00:11:22:33:44:56
> > > > 
> > > > To make it possible to distinguish these in udev, provide sysfs attributes
> > > > to make the MAC address, adapter number and type available.  There are
> > > > other fields that could perhaps be exported also.  In particular, it would
> > > > be nice to provide the port number, but somehow that doesn't manage to
> > > > propagate through the labyrinthine initialisation process.
> > > > 
> > > > The new sysfs attributes can be seen from userspace as:
> > > > 
> > > > 	[root@deneb ~]# ls /sys/class/dvb/dvb0.frontend0/
> > > > 	dev  device  dvb_adapter  dvb_mac  dvb_type
> > > > 	power  subsystem  uevent
> > > > 	[root@deneb ~]# cat /sys/class/dvb/dvb0.frontend0/dvb_*
> > > > 	0
> > > > 	00:11:22:33:44:55
> > > > 	frontend
> > > > 
> > > > They can be used in udev rules:
> > > > 
> > > > 	SUBSYSTEM=="dvb", ATTRS{vendor}=="0x14f1", ATTRS{device}=="0x8852", ATTRS{subsystem_device}=="0x0982", ATTR{dvb_mac}=="00:11:22:33:44:55", PROGRAM="/bin/sh -c 'K=%k; K=$${K#dvb}; printf dvb/adapter9820/%%s $${K#*.}'", SYMLINK+="%c"
> > > > 	SUBSYSTEM=="dvb", ATTRS{vendor}=="0x14f1", ATTRS{device}=="0x8852", ATTRS{subsystem_device}=="0x0982", ATTR{dvb_mac}=="00:11.22.33.44.56", PROGRAM="/bin/sh -c 'K=%k; K=$${K#dvb}; printf dvb/adapter9821/%%s $${K#*.}'", SYMLINK+="%c"
> > > > 
> > > > where the match is made with ATTR{dvb_mac} or similar.  The rules above
> > > > make symlinks from /dev/dvb/adapter982/* to /dev/dvb/adapterXX/*.
> > > > 
> > > > Note that binding the dvb-net device to a network interface and changing it
> > > > there does not reflect back into the the dvb_adapter struct and doesn't
> > > > change the MAC address here.  This means that a system with two identical
> > > > cards in it may need to distinguish them by some other means than MAC
> > > > address.
> > > > 
> > > > Signed-off-by: David Howells <dhowells@redhat.com>  
> > > 
> > > Looks OK to me.
> > > 
> > > Michael/Sean/Brad,
> > > 
> > > Any comments? If not, I'll probably submit it this week upstream.  
> > 
> > With this patch, with a usb Hauppauge Nova-T Stick I get:
> 
> Weird. Normally, Hauppauge devices have MAC address, as they all have
> eeproms. On several models, the MAC is even printed at the label on
> its back.
> 
> Perhaps the logic didn't wait for the firmware to load?

This is an ancient dib0700 device; the firmware did load but there is no
mac.

> > $ tail /sys/class/dvb/*/dvb_*
> > ==> /sys/class/dvb/dvb0.demux0/dvb_adapter <==  
> > 0
> > 
> > ==> /sys/class/dvb/dvb0.demux0/dvb_mac <==  
> > 00:00:00:00:00:00
> > 
> > ==> /sys/class/dvb/dvb0.demux0/dvb_type <==  
> > demux
> > 
> > ==> /sys/class/dvb/dvb0.dvr0/dvb_adapter <==  
> > 0
> > 
> > ==> /sys/class/dvb/dvb0.dvr0/dvb_mac <==  
> > 00:00:00:00:00:00
> > 
> > ==> /sys/class/dvb/dvb0.dvr0/dvb_type <==  
> > dvr
> > 
> > ==> /sys/class/dvb/dvb0.frontend0/dvb_adapter <==  
> > 0
> > 
> > ==> /sys/class/dvb/dvb0.frontend0/dvb_mac <==  
> > 00:00:00:00:00:00
> > 
> > ==> /sys/class/dvb/dvb0.frontend0/dvb_type <==  
> > frontend
> > 
> > ==> /sys/class/dvb/dvb0.net0/dvb_adapter <==  
> > 0
> > 
> > ==> /sys/class/dvb/dvb0.net0/dvb_mac <==  
> > 00:00:00:00:00:00
> > 
> > ==> /sys/class/dvb/dvb0.net0/dvb_type <==  
> > net
> > 
> > 
> > This would mean a stable name is based on a mac of 0, and there are many
> > more devices don't have a mac so they would all match this stable name.
> 
> It can only provide information when the device has it. 
> 
> > Devices without a mac address shouldn't have a mac_dvb sysfs attribute,
> > I think.
> 
> Hmm... do you mean that, if the mac is reported as 00:00:00:00:00,
> then the sysfs node should not be exposed? Makes sense.

Yes, I do.

> > The dvb type and dvb adapter no is already present in the device name,
> > I'm not sure why this needs duplicating.
> 
> IMO, it helps to write udev rules if those information are exposed.

That is true. There is support for regexs in udev, e.g.:

	KERNEL=="dvd[0-9]*.demux.[0-9]*"

Having said that dvb_type does look a little nicer:

	ATTR{dvb_type}=="demux"


Sean
