Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-05.arcor-online.net ([151.189.21.45]:54889 "EHLO
	mail-in-05.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933861Ab0BEVqe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Feb 2010 16:46:34 -0500
Subject: Re: Need to discuss method for multiple, multiple-PID TS's from
 same demux (Re: Videotext application crashes the kernel due to DVB-demux
 patch)
From: hermann pitton <hermann-pitton@arcor.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Andreas Oberritter <obi@linuxtv.org>,
	Andy Walls <awalls@radix.net>,
	Chicken Shack <chicken.shack@gmx.de>,
	linux-media@vger.kernel.org, akpm@linux-foundation.org,
	torvalds@linux-foundation.org
In-Reply-To: <4B6C88AD.4010708@redhat.com>
References: <1265018173.2449.19.camel@brian.bconsult.de>
	 <1265028110.3098.3.camel@palomino.walls.org>
	 <1265076008.3120.96.camel@palomino.walls.org>
	 <1265101869.1721.28.camel@brian.bconsult.de>
	 <1265115172.3104.17.camel@palomino.walls.org>
	 <1265158862.3194.22.camel@pc07.localdom.local>
	 <1265288042.3928.9.camel@palomino.walls.org>
	 <1265292421.3258.53.camel@brian.bconsult.de>
	 <1265336477.3071.29.camel@palomino.walls.org>
	 <4B6C1AF7.2090503@linuxtv.org>
	 <1265397736.6310.98.camel@palomino.walls.org>
	 <4B6C7F1B.7080100@linuxtv.org>  <4B6C88AD.4010708@redhat.com>
Content-Type: text/plain
Date: Fri, 05 Feb 2010 22:46:20 +0100
Message-Id: <1265406380.4064.9.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Am Freitag, den 05.02.2010, 19:07 -0200 schrieb Mauro Carvalho Chehab:
> Andreas Oberritter wrote:
> > Andy Walls wrote:
> 
> >>> As Honza noted, these ioctls are used by enigma2 and, in general, by
> >>> software running on Dream Multimedia set top boxes.
> >> Right, so reverting the patch is not an option.
> >>
> >> It also makes implementing multiple dvr0.n nodes for a demux0 device
> >> node probably a waste of time at this point.
> > 
> > I think so, too. But I guess it's always worth discussing alternatives.
> 
> If this discussion happened before 2.6.32 release, and provided that a different
> implementation were agreed, things would be easier, as a different solution like
> your proposal could be decided and used.
> 
> Now, we have already a regression on a stable kernel, and solving it by
> creating another regression is not something smart to do.
> 
> >From what I understood, the regression appeared on an old, orphan
> application with a non-official patch applied on it. Other applications with
> similar features weren't affected. On the other hand, if the patch got reverted, 
> we'll break a maintained application that is used on a great number of devices,
> and whose features depend on the new ioctls.
> 
> We are too late in -rc cycle, so probably there's not enough time for
> writing, test, validate any new API in time for 2.6.33 and write some compat
> layer to emulate those two ioctls with a different implementation.
> 
> So, removing those two ioctls is not an option anymore.
> 
> 
> Cheers,
> Mauro

during the still ongoing v4l to v4l2 conversion, all major apps did ship
with their own headers.

Since we keep backward compat, that previously unknown to me
alevt-dvb-t, agreed it is a nice to have, should compile against the
older headers instead latest kernel headers, until someone maintains it
again and takes advantage of later improvements.

Untested, but usually we see just such.

Cheers,
Hermann




