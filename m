Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:42843 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751462Ab2IQHNp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 17 Sep 2012 03:13:45 -0400
Date: Mon, 17 Sep 2012 09:13:42 +0200
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <daniel-gl@gmx.net>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@iki.fi>,
	=?iso-8859-1?Q?R=E9mi?= Denis-Courmont <remi@remlab.net>,
	linux-media@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv3 API PATCH 15/31] v4l2-core: Add new
 V4L2_CAP_MONOTONIC_TS capability.
Message-ID: <20120917071342.GA15574@minime.bse>
References: <1347620266-13767-1-git-send-email-hans.verkuil@cisco.com>
 <5054E218.4010807@gmail.com>
 <201209161557.15049.hverkuil@xs4all.nl>
 <2870315.6PlfZS62FS@avalon>
 <50564BCE.8010901@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50564BCE.8010901@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Sep 16, 2012 at 11:59:42PM +0200, Sylwester Nawrocki wrote:
> On 09/16/2012 05:33 PM, Laurent Pinchart wrote:
> > On Sunday 16 September 2012 15:57:14 Hans Verkuil wrote:
> >> On Sat September 15 2012 22:16:24 Sylwester Nawrocki wrote:
> >>> There is already lots of overhead related to the buffers management, could
> >>> we perhaps have the most common option defined in a way that drivers don't
> >>> need to update each buffer's flags before dequeuing, only to indicate the
> >>> timestamp type (other than flags being modified in videobuf) ?
> >>
> >> Well, if all vb2 drivers use the monotonic clock, then you could do it in
> >> __fill_v4l2_buffer: instead of clearing just the state flags you'd clear
> >> state + clock flags, and you OR in the monotonic flag in the case statement
> >> below (adding just a single b->flags |= line in the DEQUEUED case).
> >>
> >> So that wouldn't add any overhead. Not that I think setting a flag will add
> >> any measurable overhead in any case.
> 
> Yes, that might be indeed negligible overhead, especially if it's done well.
> User space logic usually adds much more to complexity.
> 
> Might be good idea to add some helpers to videobuf2, so handling timestamps
> is as simple as possible in drivers.

The kernel keeps the time of the last timer interrupt in
timekeeper.xtime_sec and timekeeper.xtime_nsec in CLOCK_REALTIME,
so it just has to add the nanoseconds since then. Getting CLOCK_MONOTONIC
always involves adding timekeeper.wall_to_monotonic, so it is
a few cycles less overhead to get CLOCK_REALTIME.

How about storing both values and deferring the addition to
__fill_v4l2_buffer just for applications that want monotonic time?
I wouldn't justify this with the reduced overhead but with backward
compatibility.

  Daniel

