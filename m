Return-path: <linux-media-owner@vger.kernel.org>
Received: from dd18532.kasserver.com ([85.13.139.13]:56775 "EHLO
	dd18532.kasserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255AbZA3LTz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Jan 2009 06:19:55 -0500
Date: Fri, 30 Jan 2009 12:19:52 +0100
From: Carsten Meier <cm@trexity.de>
To: hermann pitton <hermann-pitton@arcor.de>
Cc: linux-media@vger.kernel.org
Subject: Re: Howto obtain sysfs-pathes for DVB devices?
Message-ID: <20090130121952.787cdf24@tuvok>
In-Reply-To: <1233281227.2688.3.camel@pc10.localdom.local>
References: <20090128164617.569d5952@tuvok>
	<1233281227.2688.3.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Fri, 30 Jan 2009 03:07:07 +0100
schrieb hermann pitton <hermann-pitton@arcor.de>:

> Hi,
> 
> Am Mittwoch, den 28.01.2009, 16:46 +0100 schrieb Carsten Meier:
> > Hello again,
> > 
> > now I've managed to obtain syfs-pathes for v4l2-devices. But what
> > about dvb? I haven't found something like bus_info in the
> > dvb-api-docs. (I'm new to it) Any hints for this?
> > 
> > Thanks,
> > Carsten
> 
> I'm also still new on it ...
> 
> Maybe anything useful here?
> 
> cat /sys/class/dvb/dvb0.frontend0/uevent
> MAJOR=212
> MINOR=0
> PHYSDEVPATH=/devices/pci0000:00/0000:00:08.0/0000:01:07.0
> PHYSDEVBUS=pci
> PHYSDEVDRIVER=saa7134
> 
> Cheers,
> Hermann
> 
Hi,

IMHO there is no other way (not counting other daemons) than scanning
the dvb-device-files, stat() them, and compare major and minor numbers
with sysfs-contents. Anyway, I think I'll switch to HAL for that...

Cheers,
Carsten
