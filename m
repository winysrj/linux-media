Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43802 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727852AbeJaTd5 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 Oct 2018 15:33:57 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20181030223249.dhwhxdjipzmjxzsy@gofer.mess.org>
References: <20181030223249.dhwhxdjipzmjxzsy@gofer.mess.org> <153778383104.14867.1567557014782141706.stgit@warthog.procyon.org.uk> <20181030110319.764f33f0@coco.lan>
To: Sean Young <sean@mess.org>
Cc: dhowells@redhat.com,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Brad Love <brad@nextdimension.cc>, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dvb: Allow MAC addresses to be mapped to stable device names with udev
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <8473.1540982182.1@warthog.procyon.org.uk>
Date: Wed, 31 Oct 2018 10:36:22 +0000
Message-ID: <8474.1540982182@warthog.procyon.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sean Young <sean@mess.org> wrote:

> > > Devices have a MAC address available, which is printed during boot:
> 
> Not all dvb devices have a mac address.

How do I tell?  If it's all zeros it's not there?

> Devices without a mac address shouldn't have a mac_dvb sysfs attribute,
> I think.

I'm not sure that's possible within the core infrastructure.  It's a class
attribute set when the class is created; I'm not sure it can be overridden on
a per-device basis.

Possibly the file could return "" or "none" in this case?

> The dvb type and dvb adapter no is already present in the device name,
> I'm not sure why this needs duplicating.

They can be used with ATTR{} in udev rules.  I'm not clear that the name can.

> With this patch, with a usb Hauppauge Nova-T Stick I get:
> ...
> ==> /sys/class/dvb/dvb0.demux0/dvb_mac <==
> 00:00:00:00:00:00

I can't say why that happens.  I don't have access to this hardware.  Should
it have a MAC address there?  Is the MAC address getting stored in
dvbdev->adapter->proposed_mac?  Maybe it's not getting read - on the card I
use it's read by the cx23885 driver... I think...  The nova-t-usb2.c file
doesn't mention proposed_mac.

David
