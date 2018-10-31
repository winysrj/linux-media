Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:37415 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727980AbeJaTqt (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 Oct 2018 15:46:49 -0400
Date: Wed, 31 Oct 2018 10:49:12 +0000
From: Sean Young <sean@mess.org>
To: David Howells <dhowells@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Brad Love <brad@nextdimension.cc>, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dvb: Allow MAC addresses to be mapped to stable device
 names with udev
Message-ID: <20181031104912.s3tqjl3u43ou3kwo@gofer.mess.org>
References: <20181030223249.dhwhxdjipzmjxzsy@gofer.mess.org>
 <153778383104.14867.1567557014782141706.stgit@warthog.procyon.org.uk>
 <20181030110319.764f33f0@coco.lan>
 <8474.1540982182@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8474.1540982182@warthog.procyon.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Oct 31, 2018 at 10:36:22AM +0000, David Howells wrote:
> Sean Young <sean@mess.org> wrote:
> 
> > > > Devices have a MAC address available, which is printed during boot:
> > 
> > Not all dvb devices have a mac address.
> 
> How do I tell?  If it's all zeros it's not there?

The mac gets populated through read_mac_address member of
dvb_usb_device_properties. If that's not called (or does not succeed), then
there is no mac address. I think you can safely assume that if it's all 0's
then it was not read.

> > Devices without a mac address shouldn't have a mac_dvb sysfs attribute,
> > I think.
> 
> I'm not sure that's possible within the core infrastructure.  It's a class
> attribute set when the class is created; I'm not sure it can be overridden on
> a per-device basis.
> 
> Possibly the file could return "" or "none" in this case?

That's very ugly. Have a look at, for example, rc-core wakeup filters:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/media/rc/rc-main.c#n1844

> > The dvb type and dvb adapter no is already present in the device name,
> > I'm not sure why this needs duplicating.
> 
> They can be used with ATTR{} in udev rules.  I'm not clear that the name can.

See my other email.

KERNEL=="dvb[0-9]+\.demux\.[0-9]+"

> > With this patch, with a usb Hauppauge Nova-T Stick I get:
> > ...
> > ==> /sys/class/dvb/dvb0.demux0/dvb_mac <==
> > 00:00:00:00:00:00
> 
> I can't say why that happens.  I don't have access to this hardware.  Should
> it have a MAC address there?  Is the MAC address getting stored in
> dvbdev->adapter->proposed_mac?  Maybe it's not getting read - on the card I
> use it's read by the cx23885 driver... I think...  The nova-t-usb2.c file
> doesn't mention proposed_mac.

This is a dib0700-type device (much older).


Sean
