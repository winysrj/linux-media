Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37550 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725831AbeJaURJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 31 Oct 2018 16:17:09 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20181031104912.s3tqjl3u43ou3kwo@gofer.mess.org>
References: <20181031104912.s3tqjl3u43ou3kwo@gofer.mess.org> <20181030223249.dhwhxdjipzmjxzsy@gofer.mess.org> <153778383104.14867.1567557014782141706.stgit@warthog.procyon.org.uk> <20181030110319.764f33f0@coco.lan> <8474.1540982182@warthog.procyon.org.uk>
To: Sean Young <sean@mess.org>
Cc: dhowells@redhat.com,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Brad Love <brad@nextdimension.cc>, mchehab@kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dvb: Allow MAC addresses to be mapped to stable device names with udev
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <12107.1540984768.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: 8BIT
Date: Wed, 31 Oct 2018 11:19:28 +0000
Message-ID: <12108.1540984768@warthog.procyon.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sean Young <sean@mess.org> wrote:

> > > Devices without a mac address shouldn't have a mac_dvb sysfs attribute,
> > > I think.
> > 
> > I'm not sure that's possible within the core infrastructure.  It's a class
> > attribute set when the class is created; I'm not sure it can be overridden on
> > a per-device basis.
> > 
> > Possibly the file could return "" or "none" in this case?
> 
> That's very ugly. Have a look at, for example, rc-core wakeup filters:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/media/rc/rc-main.c#n1844

By analogy, then, I think the thing to do is to put something like struct
rc_dev::sysfs_groups[] into struct dvb_device (or maybe struct dvb_adapter)
and then the dvb_mac attribute in there during dvb_register_device() based on
whether or not the MAC address is not all zeros at that point.

David
