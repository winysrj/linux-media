Return-path: <linux-media-owner@vger.kernel.org>
Received: from dd18532.kasserver.com ([85.13.139.13]:51505 "EHLO
	dd18532.kasserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100AbZA3MXl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Jan 2009 07:23:41 -0500
Date: Fri, 30 Jan 2009 13:23:39 +0100
From: Carsten Meier <cm@trexity.de>
To: Matthias Schwarzott <zzam@gentoo.org>
Cc: hermann pitton <hermann-pitton@arcor.de>,
	linux-media@vger.kernel.org
Subject: Re: Howto obtain sysfs-pathes for DVB devices?
Message-ID: <20090130132339.3e96df3d@tuvok>
In-Reply-To: <200901301251.05258.zzam@gentoo.org>
References: <20090128164617.569d5952@tuvok>
	<1233281227.2688.3.camel@pc10.localdom.local>
	<20090130121952.787cdf24@tuvok>
	<200901301251.05258.zzam@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Fri, 30 Jan 2009 12:51:03 +0100
schrieb Matthias Schwarzott <zzam@gentoo.org>:

> On Freitag, 30. Januar 2009, Carsten Meier wrote:
> > Am Fri, 30 Jan 2009 03:07:07 +0100
> >
> > schrieb hermann pitton <hermann-pitton@arcor.de>:
> > > Hi,
> > >
> > > Am Mittwoch, den 28.01.2009, 16:46 +0100 schrieb Carsten Meier:
> > > > Hello again,
> > > >
> > > > now I've managed to obtain syfs-pathes for v4l2-devices. But
> > > > what about dvb? I haven't found something like bus_info in the
> > > > dvb-api-docs. (I'm new to it) Any hints for this?
> > > >
> > > > Thanks,
> > > > Carsten
> > >
> > > I'm also still new on it ...
> > >
> > > Maybe anything useful here?
> > >
> > > cat /sys/class/dvb/dvb0.frontend0/uevent
> > > MAJOR=212
> > > MINOR=0
> > > PHYSDEVPATH=/devices/pci0000:00/0000:00:08.0/0000:01:07.0
> > > PHYSDEVBUS=pci
> > > PHYSDEVDRIVER=saa7134
> > >
> > > Cheers,
> > > Hermann
> >
> > Hi,
> >
> > IMHO there is no other way (not counting other daemons) than
> > scanning the dvb-device-files, stat() them, and compare major and
> > minor numbers with sysfs-contents. Anyway, I think I'll switch to
> > HAL for that...
> >
> 
> One way of asking udev is this:
> udevadm info -q path -n /dev/dvb/adapter0/frontend0
> 
> Regards
> Matthias

Ok, then I think I'm gonna use it... :) It's much more simple than
struggling through dbus-/hal-libs and the various unfinished c++
bindings, although I normally don't like to start system-tools from c++.
Or is there any c-api for it? I haven't found one.

Thanks,
Carsten
