Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:42880 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751406Ab2KYMJz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 25 Nov 2012 07:09:55 -0500
Date: Sun, 25 Nov 2012 14:09:50 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: Shaik Ameer Basha <shaik.ameer@samsung.com>,
	linux-media@vger.kernel.org, s.nawrocki@samsung.com,
	kgene.kim@samsung.com, shaik.samsung@gmail.com,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Kamil Debski <k.debski@samsung.com>,
	laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH] [media] exynos-gsc: propagate timestamps from src to
 dst buffers
Message-ID: <20121125120950.GD31879@valkosipuli.retiisi.org.uk>
References: <1352270424-14683-1-git-send-email-shaik.ameer@samsung.com>
 <50AAAD6A.80709@gmail.com>
 <20121121193948.GB30360@valkosipuli.retiisi.org.uk>
 <50AE9CB6.8020100@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50AE9CB6.8020100@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

On Thu, Nov 22, 2012 at 10:44:22PM +0100, Sylwester Nawrocki wrote:
> >>the data
> >>will not be displayed before this time, secondary to the nominal frame rate
> >>determined by the current video standard in enqueued order.
> >>Applications can
> >>for example zero this field to display frames as soon as possible.
> >>The driver
> >>stores the time at which the first data byte was actually sent out in the
> >>timestamp field. This permits applications to monitor the drift between the
> >>video and system clock."
> >>
> >>In some use cases it might be useful to know exact frame processing time,
> >>where driver would be filling OUTPUT and CAPTURE value with exact monotonic
> >>clock values corresponding to a frame processing start and end time.
> >
> >Shouldn't this always be done in memory-to-memory processing? I could
> >imagine only performance measurements can benefit from other kind of
> >timestamps.
> >
> >We could use different timestamp type to tell the timestamp source isn't any
> >system clock but an input buffer.
> >
> >What do you think?
> 
> Yes, it makes sense to me to report with the buffer flag that the source of
> timestamp is just an OUTPUT buffer. At least this would solve the reporting
> part of the issue. Oh wait, could applications tell by setting buffer flag
> what timestamping behaviour they expect from a driver ?

I'd prefer not to. Timestamps not involving use of video nodes or buffers
would have no way to choose this. Timestamps only make sense if they're all
the same kind of, so you can cmopare them, with possibly some exceptions
this could be one of.

In memory-to-memory processing we could possibly also force such timestamps,
but that'd require making vb2 timestamp source-aware. I certainly have
nothing against that: it's been already planned.

Handling queryctrl requirest that, and I prefer to avoid involving drivers
in it.

(Cc Laurent.)

> I can't see an important use of timestamping m2m buffers at device drivers.

How not important is it then?

> Performance measurement can probably be done in user space with sufficient
> accuracy as well. However, it wouldn't be difficult for drivers to

I agree.

> implement
> multiple time stamping techniques, e.g. OUTPUT -> CAPTURE timestamp copying
> or getting timestamps from monotonic clock at frame processing beginning and
> end for OUTPUT and CAPTURE respectively.
> 
> I believe the buffer flags might be a good solution.

Have you looked at the monotonic timestamp patches ("[PATCH 0/4] Monotonic
timestamps")?

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
