Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:48110 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213Ab1KBMrs (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Nov 2011 08:47:48 -0400
Date: Wed, 2 Nov 2011 14:47:43 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	=?iso-8859-1?Q?R=E9mi?= Denis-Courmont <remi@remlab.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [RFC] Monotonic clock usage in buffer timestamps
Message-ID: <20111102124743.GE22159@valkosipuli.localdomain>
References: <201111011324.36742.laurent.pinchart@ideasonboard.com>
 <b3e1d11fbdb6c1fe02954f7b2dd29b01@chewa.net>
 <201111011349.47132.laurent.pinchart@ideasonboard.com>
 <20111102091046.GA14955@minime.bse>
 <20111102101449.GC22159@valkosipuli.localdomain>
 <20111102105804.GA15491@minime.bse>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20111102105804.GA15491@minime.bse>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Nov 02, 2011 at 11:58:04AM +0100, Daniel Glöckner wrote:
> On Wed, Nov 02, 2011 at 12:14:49PM +0200, Sakari Ailus wrote:
> > > How about making all drivers record monotonic timestamps and doing
> > > the conversion to/from realtime timestamps in v4l2-ioctl.c's
> > > __video_do_ioctl if requested? We then just need an extension of the
> > > spec to switch to monotonic, which can be implemented without touching
> > > a single driver.
> > 
> > Converting between the two can be done when making the timestamp but it's
> > non-trivial at other times and likely isn't supported. I could be wrong,
> > though. This might lead to e.g. timestamps that are taken before switching
> > to summer time and for which the conversion is done after the switch. This
> > might be a theoretical possibility, but there might be also unfavourable
> > interaction with the NTP.
> 
> Summertime/wintertime is purely a userspace thing. UTC as returned by
> gettimeofday is unaffected by that.

Indeed, that's correct.

> NTP AFAIK adjusts the speed of the monotonic clock, so there is a constant
> delta between wall clock time and clock monotonic unless there is a leap
> second or someone calls settimeofday. Applications currently using the
> wall clock timestamps should have trouble dealing with that as well.

I wonder if applications do use it for something these days. Some might, but
I don't know of any that would be affected.

> > I'd probably rather just make a new timestamp in wall clock time in
> > v4l2-ioctl.c if needed using do_gettimeofday().
> 
> I think that would be worse than subtracting ktime_get_monotonic_offset().
> You don't know the delay between capturing a frame and calling dqbuf.

Right. As Laurent suggested, doing that in videobuf2 is better option since
it gets called when the buffer gets dequeueable.

If videobuf2 already has knowledge on what kind of timestamp the user
expects it would be possible to do it here.

> If there is a settimeofday between capturing a frame and calling dqbuf,
> the wall time clock was probably wrong when the frame was captured
> and subtracting the new ktime_get_monotonic_offset() yields a better
> timestamp.
> 
> > Or just do the wall clock timestamps user space as they are typically
> > critical in timing.
> >
> > How would this work for you?
> 
> As I keep the cpu busy with video encoding in the same thread, I'd expect
> a high jitter from taking timestamps in userspace.

True.

Kind regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
