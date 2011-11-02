Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:40429 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751655Ab1KBK6H (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Nov 2011 06:58:07 -0400
Date: Wed, 2 Nov 2011 11:58:04 +0100
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	=?iso-8859-1?Q?R=E9mi?= Denis-Courmont <remi@remlab.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [RFC] Monotonic clock usage in buffer timestamps
Message-ID: <20111102105804.GA15491@minime.bse>
References: <201111011324.36742.laurent.pinchart@ideasonboard.com>
 <b3e1d11fbdb6c1fe02954f7b2dd29b01@chewa.net>
 <201111011349.47132.laurent.pinchart@ideasonboard.com>
 <20111102091046.GA14955@minime.bse>
 <20111102101449.GC22159@valkosipuli.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111102101449.GC22159@valkosipuli.localdomain>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Nov 02, 2011 at 12:14:49PM +0200, Sakari Ailus wrote:
> > How about making all drivers record monotonic timestamps and doing
> > the conversion to/from realtime timestamps in v4l2-ioctl.c's
> > __video_do_ioctl if requested? We then just need an extension of the
> > spec to switch to monotonic, which can be implemented without touching
> > a single driver.
> 
> Converting between the two can be done when making the timestamp but it's
> non-trivial at other times and likely isn't supported. I could be wrong,
> though. This might lead to e.g. timestamps that are taken before switching
> to summer time and for which the conversion is done after the switch. This
> might be a theoretical possibility, but there might be also unfavourable
> interaction with the NTP.

Summertime/wintertime is purely a userspace thing. UTC as returned by
gettimeofday is unaffected by that.

NTP AFAIK adjusts the speed of the monotonic clock, so there is a constant
delta between wall clock time and clock monotonic unless there is a leap
second or someone calls settimeofday. Applications currently using the
wall clock timestamps should have trouble dealing with that as well.

> I'd probably rather just make a new timestamp in wall clock time in
> v4l2-ioctl.c if needed using do_gettimeofday().

I think that would be worse than subtracting ktime_get_monotonic_offset().
You don't know the delay between capturing a frame and calling dqbuf.

If there is a settimeofday between capturing a frame and calling dqbuf,
the wall time clock was probably wrong when the frame was captured
and subtracting the new ktime_get_monotonic_offset() yields a better
timestamp.

> Or just do the wall clock timestamps user space as they are typically
> critical in timing.
>
> How would this work for you?

As I keep the cpu busy with video encoding in the same thread, I'd expect
a high jitter from taking timestamps in userspace.

  Daniel
