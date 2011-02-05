Return-path: <mchehab@pedra>
Received: from einhorn.in-berlin.de ([192.109.42.8]:47268 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752052Ab1BEOaM (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 5 Feb 2011 09:30:12 -0500
Date: Sat, 5 Feb 2011 15:29:47 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Deti Fliegl <deti@fliegl.de>
Subject: Re: [GIT PATCHES FOR 2.6.39] Remove se401, usbvideo, dabusb,
 firedtv-1394 and VIDIOC_OLD
Message-ID: <20110205152947.43375cb4@stein>
In-Reply-To: <201102051417.22874.hverkuil@xs4all.nl>
References: <201102051417.22874.hverkuil@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Feb 05 Hans Verkuil wrote:
> (Second attempt: fixes a link issue with firedtv and adds removal of the old ioctls)
> 
> This patch series removes the last V4L1 drivers (Yay!), the obsolete dabusb driver,
> the ieee1394-stack part of the firedtv driver (the IEEE1394 stack was removed in
> 2.6.37), and the VIDIOC_*_OLD ioctls.
> 
> Stefan, I went ahead with this since after further research I discovered that
> this driver hasn't been compiled at all since 2.6.37! The Kconfig had a
> dependency on IEEE1394, so when that config was removed, the driver no longer
> appeared in the config.
> 
> I removed any remaining reference to IEEE1394 and changed the Kconfig dependency
> to FIREWIRE. At least it compiles again :-)

Thanks for doing the firedtv cleanup.  However, the effect should just be
that of dead code elimination.  Was there any build problem that I missed?

AFAICS, firedtv builds and works fine in mainline 2.6.37(-rc) and
2.6.38(-rc).  From when I implemented the drivers/firewire/ backend of
firedtv, it should have been possible to build firedtv for a kernel with
one or both of drivers/{ieee1394,firewire}; controlled by whether
CONFIG_{IEEE1394,FIREWIRE} are defined or not.

I will have a look at your changes later.
-- 
Stefan Richter
-=====-==-== --=- --=-=
http://arcgraph.de/sr/
