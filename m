Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:53504 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115Ab1KBKv2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Nov 2011 06:51:28 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [RFC] Monotonic clock usage in buffer timestamps
Date: Wed, 2 Nov 2011 11:51:25 +0100
Cc: "=?iso-8859-1?q?R=E9mi?= Denis-Courmont" <remi@remlab.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
References: <201111011324.36742.laurent.pinchart@ideasonboard.com> <20111102091046.GA14955@minime.bse> <20111102101449.GC22159@valkosipuli.localdomain>
In-Reply-To: <20111102101449.GC22159@valkosipuli.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201111021151.26259.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

On Wednesday 02 November 2011 11:14:49 Sakari Ailus wrote:
> On Wed, Nov 02, 2011 at 10:10:46AM +0100, Daniel Glöckner wrote:
> > On Tue, Nov 01, 2011 at 01:49:46PM +0100, Laurent Pinchart wrote:
> > > > Nevertheless, I agree that the monotonic clock is better than the
> > > > real time clock.
> > > > In user space, VLC, Gstreamer already switched to monotonic a while
> > > > ago as far as I know.
> > > > 
> > > > And I guess there is no way to detect this, other than detect
> > > > ridiculously large gap between the timestamp and the current clock
> > > > value?
> > > 
> > > That's right. We could add a device capability flag if needed, but that
> > > wouldn't help older applications that expect system time in the
> > > timestamps.
> > 
> > I just so happen to have tried to use V4L2 and ALSA timestamps in a
> > single application. In ALSA the core supports switching between
> > monotonic and realtime timestamps, with the library always using
> > monotonic available.
> > 
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
> 
> I'd probably rather just make a new timestamp in wall clock time in
> v4l2-ioctl.c if needed using do_gettimeofday(). It also needs to be agreed
> how does the user space request that to be done.
> 
> Or just do the wall clock timestamps user space as they are typically
> critical in timing.
> 
> How would this work for you?

I agree that converting between the timestamps is error prone. Compatibility 
code, if required, should probably just call do_gettimeofday() in v4l2_ioctl.c 
(or possibly in videobuf2 ?).

The real problem would be to decide how to select compatibility mode. Adding a 
flag so that applications can request monotonic timestamps is doable, but 
would open the door to a long transition period, and I'd like to avoid that.

I expect most applications to not even notice the switch from the system clock 
to a monotonic clock. Using system timestamps for video buffers is unreliable 
and broken by design, so we could argue that applications that would break (if 
any) are already broken :-)

-- 
Regards,

Laurent Pinchart
