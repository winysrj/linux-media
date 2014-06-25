Return-path: <linux-media-owner@vger.kernel.org>
Received: from cnc.isely.net ([75.149.91.89]:49493 "EHLO cnc.isely.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757096AbaFYXPn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Jun 2014 19:15:43 -0400
Date: Wed, 25 Jun 2014 18:10:41 -0500 (CDT)
From: isely@isely.net
To: Matthew Thode <prometheanfire@gentoo.org>
cc: Linux-Media <linux-media@vger.kernel.org>
Subject: Re: pvrusb2 has a new device (wintv-hvr-1955)
In-Reply-To: <08c06a97-d24b-4eeb-9c3e-d7a923ec1ea1@email.android.com>
Message-ID: <alpine.DEB.2.02.1406251809230.5681@ivanova.isely.net>
References: <53A3CB23.2000209@gentoo.org> <CALzAhNUb_J+tcqaaRLm_x=pAVDNWZp6EFuPBGKiS4VMiVtRwag@mail.gmail.com> <08c06a97-d24b-4eeb-9c3e-d7a923ec1ea1@email.android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


On Fri, 20 Jun 2014, Matthew Thode wrote:

> On June 20, 2014 7:29:42 AM CDT, Steven Toth <stoth@kernellabs.com> wrote:
> >On Fri, Jun 20, 2014 at 1:48 AM, Matthew Thode
> ><prometheanfire@gentoo.org> wrote:
> >> Just bought a wintv-hvr-1955 (sold as a wintv-hvr-1950)
> >> 160111 LF
> >> Rev B1|7
> >
> >Talk to Hauppauge, they've already announced that they have a working
> >Linux driver.
> 
> I talked to them and they did say that the driver hasn't been upstreamed, also gave me some hardware info.  They wouldn't give me a driver/firmware that worked though and offered to RMA for an older device.
> 
> The demodulator is a Si2177, can't find anything about it in the kernel though.
> 
> They also mentioned a LG3306a, wasn't able to find anything on it (might have misheard a character).

That would explain why the pvrusb2 driver errored out the way it did...

Without support for those parts in V4L, there's probably little else to 
be done in the pvrusb2 driver.  I am curious however to know if anyone 
has heard anything more about Hauppauge's driver...

  -Mike Isely
   <isely@pobox.com>


-- 

Mike Isely
isely @ isely (dot) net
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8
