Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:33516 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754467Ab1KBKOx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Nov 2011 06:14:53 -0400
Date: Wed, 2 Nov 2011 12:14:49 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	=?iso-8859-1?Q?R=E9mi?= Denis-Courmont <remi@remlab.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [RFC] Monotonic clock usage in buffer timestamps
Message-ID: <20111102101449.GC22159@valkosipuli.localdomain>
References: <201111011324.36742.laurent.pinchart@ideasonboard.com>
 <b3e1d11fbdb6c1fe02954f7b2dd29b01@chewa.net>
 <201111011349.47132.laurent.pinchart@ideasonboard.com>
 <20111102091046.GA14955@minime.bse>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20111102091046.GA14955@minime.bse>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Nov 02, 2011 at 10:10:46AM +0100, Daniel Glöckner wrote:
> Hello,

Hi Daniel,

> On Tue, Nov 01, 2011 at 01:49:46PM +0100, Laurent Pinchart wrote:
> > > Nevertheless, I agree that the monotonic clock is better than the real
> > > time clock.
> > > In user space, VLC, Gstreamer already switched to monotonic a while ago as
> > > far as I know.
> > > 
> > > And I guess there is no way to detect this, other than detect ridiculously
> > > large gap between the timestamp and the current clock value?
> > 
> > That's right. We could add a device capability flag if needed, but that 
> > wouldn't help older applications that expect system time in the timestamps.
> 
> I just so happen to have tried to use V4L2 and ALSA timestamps in a
> single application. In ALSA the core supports switching between
> monotonic and realtime timestamps, with the library always using
> monotonic available.
> 
> How about making all drivers record monotonic timestamps and doing
> the conversion to/from realtime timestamps in v4l2-ioctl.c's
> __video_do_ioctl if requested? We then just need an extension of the
> spec to switch to monotonic, which can be implemented without touching
> a single driver.

Converting between the two can be done when making the timestamp but it's
non-trivial at other times and likely isn't supported. I could be wrong,
though. This might lead to e.g. timestamps that are taken before switching
to summer time and for which the conversion is done after the switch. This
might be a theoretical possibility, but there might be also unfavourable
interaction with the NTP.

I'd probably rather just make a new timestamp in wall clock time in
v4l2-ioctl.c if needed using do_gettimeofday(). It also needs to be agreed
how does the user space request that to be done.

Or just do the wall clock timestamps user space as they are typically
critical in timing.

How would this work for you?

Kind regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
