Return-path: <linux-media-owner@vger.kernel.org>
Received: from mk-outboundfilter-2.mail.uk.tiscali.com ([212.74.114.38]:47451
	"EHLO mk-outboundfilter-2.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752220AbZDBWya (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Apr 2009 18:54:30 -0400
From: Adam Baker <linux@baker-net.org.uk>
To: "Stian Skjelstad" <stian@nixia.no>
Subject: Re: gpsca kernel BUG when disconnecting camera while streaming with mmap (2.6.29-rc8)
Date: Thu, 2 Apr 2009 23:54:24 +0100
Cc: "'Jean-Francois Moine'" <moinejf@free.fr>,
	linux-media@vger.kernel.org
References: <1238347504.5232.17.camel@laptop> <20090402091112.5411b711@free.fr> <000301c9b363$d0533ce0$70f9b6a0$@no>
In-Reply-To: <000301c9b363$d0533ce0$70f9b6a0$@no>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904022354.24951.linux@baker-net.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 02 Apr 2009, Stian Skjelstad wrote:
> > Stian Skjelstad <stian@nixia.no> wrote:
> > 	[snip]
> >
> > > usb 2-2: USB disconnect, address 47
> >>
> >> gspca: urb status: -108
> >> gspca: urb status: -108
> >> gspca: disconnect complete
> >> BUG: unable to handle kernel NULL pointer dereference at 00000014
> >> IP: [<c02bc98e>] usb_set_interface+0x1e/0x1e0
> >> *pde = 00000000
> >> Oops: 0000 [#1] PREEMPT
> >
> >	[snip]
> >
> >You did not tell which version of gspca you use. If it is the one of a
> >kernel older than 2.6.30, you should update. Also, may this problem
> >be reproduced?
>
> I'm using the built in one. I'm going to upgrade to 2.6.29 very soon. And
> if problem still persists, I can build gspca outside the kernel instead.
>

2.6.29 isn't good enough, you need the patch at
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=d08e2ce0ebb38f2b66d875a09ebab3ed548354ee
which only hit Linus' tree 3 days ago.

I'm not sure whether it is appropriate for that patch to go to -stable. There 
are other patches that affect the relevant code but that one looks like it is 
a fix for a real bug that should apply cleanly to 2.6.29.

I guess if you are able to confirm if it fixes 2.6.29 for you that would be a 
good indication it is appropriate for -stable.

Adam

