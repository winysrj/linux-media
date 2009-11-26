Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f171.google.com ([209.85.222.171]:64925 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081AbZKZFtg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Nov 2009 00:49:36 -0500
Date: Wed, 25 Nov 2009 21:49:38 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Andy Walls <awalls@radix.net>
Cc: Christoph Bartelmus <lirc@bartelmus.de>, khc@pm.waw.pl,
	j@jannau.net, jarod@redhat.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	mchehab@redhat.com, superm1@ubuntu.com
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was:
	Re: [PATCH 1/3 v2] lirc core device driver infrastructure
Message-ID: <20091126054938.GH23244@core.coreip.homeip.net>
References: <BDRae8rZjFB@christoph> <1259024037.3871.36.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1259024037.3871.36.camel@palomino.walls.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Nov 23, 2009 at 07:53:57PM -0500, Andy Walls wrote:
> On Mon, 2009-11-23 at 22:11 +0100, Christoph Bartelmus wrote:
> > Czesc Krzysztof,
> > 
> > on 23 Nov 09 at 15:14, Krzysztof Halasa wrote:
> > [...]
> > > I think we shouldn't at this time worry about IR transmitters.
> > 
> > Sorry, but I have to disagree strongly.
> > Any interface without transmitter support would be absolutely unacceptable  
> > for many LIRC users, including myself.
> 
> I agree with Christoph.  
> 
> Is it that the input subsystem is better developed and seen as a
> leverage point for development and thus an "easier" place to get results
> earlier?  If so, then one should definitely deal with transmitters early
> in the design, as that is where the most unknowns lie.
> 
> With the end of analog TV, people will have STBs feeding analog only
> video cards.  Being able to change the channel on the STB with an IR
> transmitter controlled by applications like MythTV is essential.
> 
> 
> And on some different notes:
> 
> I generally don't understand the LIRC aversion I perceive in this thread
> (maybe I just have a skewed perception).  Aside for a video card's
> default remote setup, the suggestions so far don't strike me as any
> simpler for the end user than LIRC -- maybe I'm just used to LIRC.  LIRC
> already works for both transmit and receive and has existing support in
> applications such as MythTV and mplayer.

Is it that LIRC supports MythTV and mplayer or MythTV and mplayer are
forced to support lirc because the remores are not available through
other means? I believe it is the latter and applications writers would
be happy to reduce number of ways they get button data.

I don't think there is LIRC aversion per se. We are just trying to
decide whether multiple interfaces for the same data is needed. And
I don't think that we will completely reject userspace components. Just
as input subsystem allows for userspace drivers I do not think why we
can't have the same for the LIRC. But I do think that the primary
interface for regular userspace consumers (read mplayer and MythTV and
the likes) should be input event interface (EV_KEY/KEY_*).

-- 
Dmitry
