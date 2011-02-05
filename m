Return-path: <mchehab@pedra>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:3893 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab1BEOsp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 Feb 2011 09:48:45 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [GIT PATCHES FOR 2.6.39] Remove se401, usbvideo, dabusb, firedtv-1394 and VIDIOC_OLD
Date: Sat, 5 Feb 2011 15:48:32 +0100
Cc: linux-media@vger.kernel.org, Deti Fliegl <deti@fliegl.de>
References: <201102051417.22874.hverkuil@xs4all.nl> <20110205152947.43375cb4@stein>
In-Reply-To: <20110205152947.43375cb4@stein>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102051548.32245.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Saturday, February 05, 2011 15:29:47 Stefan Richter wrote:
> On Feb 05 Hans Verkuil wrote:
> > (Second attempt: fixes a link issue with firedtv and adds removal of the old ioctls)
> > 
> > This patch series removes the last V4L1 drivers (Yay!), the obsolete dabusb driver,
> > the ieee1394-stack part of the firedtv driver (the IEEE1394 stack was removed in
> > 2.6.37), and the VIDIOC_*_OLD ioctls.
> > 
> > Stefan, I went ahead with this since after further research I discovered that
> > this driver hasn't been compiled at all since 2.6.37! The Kconfig had a
> > dependency on IEEE1394, so when that config was removed, the driver no longer
> > appeared in the config.
> > 
> > I removed any remaining reference to IEEE1394 and changed the Kconfig dependency
> > to FIREWIRE. At least it compiles again :-)
> 
> Thanks for doing the firedtv cleanup.  However, the effect should just be
> that of dead code elimination.  Was there any build problem that I missed?

You missed something, but it turns out not to be a build problem as such on
closer inspection.

I got confused by this code in drivers/media/dvb/Kconfig:

comment "Supported FireWire (IEEE 1394) Adapters"
        depends on DVB_CORE && IEEE1394
source "drivers/media/dvb/firewire/Kconfig"

Since the comment depends on IEEE1394 it disappeared once IEEE1394 was removed.
So when I looked for this comment in the menu is was no longer there. But the
actual driver still is, and I missed that.

So it was just the comment dependency that was wrong, not the driver itself.

Sorry for the confusion.

Regards,

	Hans

> AFAICS, firedtv builds and works fine in mainline 2.6.37(-rc) and
> 2.6.38(-rc).  From when I implemented the drivers/firewire/ backend of
> firedtv, it should have been possible to build firedtv for a kernel with
> one or both of drivers/{ieee1394,firewire}; controlled by whether
> CONFIG_{IEEE1394,FIREWIRE} are defined or not.
> 
> I will have a look at your changes later.
> 

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
