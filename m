Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.9]:57207 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729AbZA3LvM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Jan 2009 06:51:12 -0500
From: Matthias Schwarzott <zzam@gentoo.org>
To: Carsten Meier <cm@trexity.de>
Subject: Re: Howto obtain sysfs-pathes for DVB devices?
Date: Fri, 30 Jan 2009 12:51:03 +0100
Cc: hermann pitton <hermann-pitton@arcor.de>,
	linux-media@vger.kernel.org
References: <20090128164617.569d5952@tuvok> <1233281227.2688.3.camel@pc10.localdom.local> <20090130121952.787cdf24@tuvok>
In-Reply-To: <20090130121952.787cdf24@tuvok>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901301251.05258.zzam@gentoo.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Freitag, 30. Januar 2009, Carsten Meier wrote:
> Am Fri, 30 Jan 2009 03:07:07 +0100
>
> schrieb hermann pitton <hermann-pitton@arcor.de>:
> > Hi,
> >
> > Am Mittwoch, den 28.01.2009, 16:46 +0100 schrieb Carsten Meier:
> > > Hello again,
> > >
> > > now I've managed to obtain syfs-pathes for v4l2-devices. But what
> > > about dvb? I haven't found something like bus_info in the
> > > dvb-api-docs. (I'm new to it) Any hints for this?
> > >
> > > Thanks,
> > > Carsten
> >
> > I'm also still new on it ...
> >
> > Maybe anything useful here?
> >
> > cat /sys/class/dvb/dvb0.frontend0/uevent
> > MAJOR=212
> > MINOR=0
> > PHYSDEVPATH=/devices/pci0000:00/0000:00:08.0/0000:01:07.0
> > PHYSDEVBUS=pci
> > PHYSDEVDRIVER=saa7134
> >
> > Cheers,
> > Hermann
>
> Hi,
>
> IMHO there is no other way (not counting other daemons) than scanning
> the dvb-device-files, stat() them, and compare major and minor numbers
> with sysfs-contents. Anyway, I think I'll switch to HAL for that...
>

One way of asking udev is this:
udevadm info -q path -n /dev/dvb/adapter0/frontend0

Regards
Matthias
