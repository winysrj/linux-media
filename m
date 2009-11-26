Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:43410 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759054AbZKZMaa (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Nov 2009 07:30:30 -0500
Subject: Re: [RFC] Should we create a raw input interface for IR's ? - Was:
 Re: [PATCH 1/3 v2] lirc core device driver infrastructure
From: Andy Walls <awalls@radix.net>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jarod Wilson <jarod@wilsonet.com>,
	Christoph Bartelmus <lirc@bartelmus.de>, khc@pm.waw.pl,
	j@jannau.net, jarod@redhat.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	mchehab@redhat.com, superm1@ubuntu.com
In-Reply-To: <6619F77F-446F-47ED-B9F5-6CFC00E3EA49@wilsonet.com>
References: <BDRae8rZjFB@christoph>
	 <1259024037.3871.36.camel@palomino.walls.org>
	 <20091126054938.GH23244@core.coreip.homeip.net>
	 <6619F77F-446F-47ED-B9F5-6CFC00E3EA49@wilsonet.com>
Content-Type: text/plain
Date: Thu, 26 Nov 2009 07:28:20 -0500
Message-Id: <1259238500.3062.10.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 2009-11-26 at 01:23 -0500, Jarod Wilson wrote:
> On Nov 26, 2009, at 12:49 AM, Dmitry Torokhov wrote:
> 
> > On Mon, Nov 23, 2009 at 07:53:57PM -0500, Andy Walls wrote:
> >> On Mon, 2009-11-23 at 22:11 +0100, Christoph Bartelmus wrote:
> >>> Czesc Krzysztof,
> >>> 
> >>> on 23 Nov 09 at 15:14, Krzysztof Halasa wrote:
> >>> [...]
> >>>> I think we shouldn't at this time worry about IR transmitters.
> >>> 
> >>> Sorry, but I have to disagree strongly.
> >>> Any interface without transmitter support would be absolutely unacceptable  
> >>> for many LIRC users, including myself.
> >> 
> >> I agree with Christoph.  
> >> 
> >> Is it that the input subsystem is better developed and seen as a
> >> leverage point for development and thus an "easier" place to get results
> >> earlier?  If so, then one should definitely deal with transmitters early
> >> in the design, as that is where the most unknowns lie.
> >> 
> >> With the end of analog TV, people will have STBs feeding analog only
> >> video cards.  Being able to change the channel on the STB with an IR
> >> transmitter controlled by applications like MythTV is essential.
> >> 
> >> 
> >> And on some different notes:
> >> 
> >> I generally don't understand the LIRC aversion I perceive in this thread
> >> (maybe I just have a skewed perception).  Aside for a video card's
> >> default remote setup, the suggestions so far don't strike me as any
> >> simpler for the end user than LIRC -- maybe I'm just used to LIRC.  LIRC
> >> already works for both transmit and receive and has existing support in
> >> applications such as MythTV and mplayer.
> > 
> > Is it that LIRC supports MythTV and mplayer or MythTV and mplayer are
> > forced to support lirc because the remores are not available through
> > other means? I believe it is the latter and applications writers would
> > be happy to reduce number of ways they get button data.
> 
> Well, when mythtv was started, I don't know that there were many input layer remotes around... lirc was definitely around though. serial receivers and transmitters, both supported by lirc_serial, were the most frequently used devices outside of plain old keyboards. The lirc support in mythtv actually relies on mapping remote button names as defined in lircd.conf to keyboard key strokes. As mentioned elsewhere in this beast of a thread, mythtv doesn't currently support things like KEY_PLAY, KEY_VOLUMEUP, KEY_CHANNELUP, etc. just yet, but I intend on fixing that...
> 
> > I don't think there is LIRC aversion per se. We are just trying to
> > decide whether multiple interfaces for the same data is needed. And
> > I don't think that we will completely reject userspace components. Just
> > as input subsystem allows for userspace drivers I do not think why we
> > can't have the same for the LIRC. But I do think that the primary
> > interface for regular userspace consumers (read mplayer and MythTV and
> > the likes) should be input event interface (EV_KEY/KEY_*).
> 
> Works for me.

Even though two interfaces is a bit of "extra" work, I'm not averse to
Gerd's suggestions of a dual implementation: input layer for the simple,
common use case, and lirc type interface for more sophisticated usage.

One thing I would like to be provided by the input layer is automatic
key-up after a specified time.  Remote protocols send an initial button
press and then after a certain amount of time (~115 ms for RC-5) send a
repeated code or repeat sequence, if the button is still pressed.
Currently, most of the V4L-DVB drivers have some code to perform a
timeout just to send the key-up event.  That's a good bit of redundant
code for key-up timeouts that I suspect makes sense for the input layer
to handle.

Regards,
Andy

