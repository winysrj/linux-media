Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f190.google.com ([209.85.222.190]:46687 "EHLO
	mail-pz0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbZIOUZQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 15 Sep 2009 16:25:16 -0400
Received: by pzk28 with SMTP id 28so3670807pzk.20
        for <linux-media@vger.kernel.org>; Tue, 15 Sep 2009 13:25:20 -0700 (PDT)
Date: Tue, 15 Sep 2009 13:24:41 -0700
From: Brandon Philips <brandon@ifup.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, Andy Walls <awalls@radix.net>,
	Steven Toth <stoth@hauppauge.com>,
	Mike Krufky <mkrufky@linuxtv.org>,
	Devin Heitmueller <devin.heitmueller@gmail.com>,
	Vaibhav Hiremath <hvaibhav@ti.com>,
	Muralidharan Karicheri <m-karicheri2@ti.com>,
	"Iovescu, Magdalena" <m-iovescu1@ti.com>,
	"Aguirre Rodriguez, Sergio Alberto" <saaguirre@ti.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Laurent Pinchart <laurent.pinchart@skynet.be>,
	Hans de Goede <j.w.r.degoede@hhs.nl>
Subject: Re: LPC v4l-dvb mini-summit agenda
Message-ID: <20090915202441.GA29973@jenkins.home.ifup.org>
References: <200909151919.53930.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200909151919.53930.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 19:19 Tue 15 Sep 2009, Hans Verkuil wrote:
> We have a room available all three days, so that makes life easier for us.
>
> I assume that most people will want to attend at least the keynote speeches,
> so I'm scheduling around that.

Thanks for organizing this. But, I have other priorities and things I
want to discuss during the conference. I don't think I can attend a
full three days.

> So Wednesday we start at 10:00 after the keynote (except for those
> attending the audio track) and go on until 15:00 (yes, you are
> allowed to have lunch :-) ).
> 
> Thursday we can start at 9:00 until 16:00.

I wish I had seen this sooner so we could have done something like the
Networking folks and met while LinuxCon was going on instead. I
thought the V4L meetup was going to be a regular BoF.

> Friday starts with a V4L2 BoF followed by two v4l presentations, so
> we will only have a session from 13:30 - 16:00. I suggest we use
> that to wrap up.

After dicussing this a bit Hans and I cut it down to a single 45
minute slot with each of us doing a 20 or so minutes.

> The main discussion points are these RFCs:
> 
> - V2.1 Media Controller RFC:
> - Bus and data format negotiation (addresses open issue #3 of the MC RFC):
> - Support for video timings at the input/output interface (aka support for HDTV):
> - Allow bridge drivers to have better control over DVB frontend operations:

> We have some other topics as well (in no particular order):
> - mercurial vs git, how important is backwards compatibility to us?
> - how to do events in V4L?
> - is it possible to create a pool of buffers that we can pass around to
>   various video nodes?
> - others?
> 
> My plan is to use the Wednesday to start with the media controller, make sure
> that everyone understands what it is and what it is not and perhaps look at
> one embedded device to see how well it would work. The afternoon we can look
> at some of the other topics.

Can you plan on a quick overview of the RFCs and in particular how far
along the hardware is and how it is implemented early in the morning?

An hour by hour schedule with when you plan on discussing what would
be very helpful. I find meetings that have too open ended of a
schedule have a tendency to rat-hole ;)

> I hope that on Thursday we can go over the media controller in more detail,
> esp. with regards to other embedded devices, current and (if possible)
> upcoming. 

An overview of the current hardware implementation would be nice on
Wed. It seems to be missing from the RFCs.

Thanks,

	Brandon
