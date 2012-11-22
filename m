Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:42130 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757752Ab2KVVZH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Nov 2012 16:25:07 -0500
Date: Thu, 22 Nov 2012 23:25:02 +0200
From: 'Sakari Ailus' <sakari.ailus@iki.fi>
To: Kamil Debski <k.debski@samsung.com>
Cc: 'Sylwester Nawrocki' <sylvester.nawrocki@gmail.com>,
	'Shaik Ameer Basha' <shaik.ameer@samsung.com>,
	linux-media@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	kgene.kim@samsung.com, shaik.samsung@gmail.com,
	'Hans Verkuil' <hverkuil@xs4all.nl>
Subject: Re: [PATCH] [media] exynos-gsc: propagate timestamps from src to
 dst buffers
Message-ID: <20121122212502.GC31442@valkosipuli.retiisi.org.uk>
References: <1352270424-14683-1-git-send-email-shaik.ameer@samsung.com>
 <50AAAD6A.80709@gmail.com>
 <20121121193948.GB30360@valkosipuli.retiisi.org.uk>
 <01c501cdc894$3f9be9f0$bed3bdd0$%debski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <01c501cdc894$3f9be9f0$bed3bdd0$%debski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kamil,

On Thu, Nov 22, 2012 at 10:32:09AM +0100, Kamil Debski wrote:
> Hi Sakari,
> 
> > From: Sakari Ailus [mailto:sakari.ailus@iki.fi]
> > Sent: Wednesday, November 21, 2012 8:40 PM
> > 
> > Hi Sylwester and Shaik,
> > 
> > On Mon, Nov 19, 2012 at 11:06:34PM +0100, Sylwester Nawrocki wrote:
> > > On 11/07/2012 07:40 AM, Shaik Ameer Basha wrote:
> > > >Make gsc-m2m propagate the timestamp field from source to
> > destination
> > > >buffers
> > >
> > > We probably need some means for letting know the mem-to-mem drivers
> > > and applications whether timestamps are copied from OUTPUT to CAPTURE
> > or not.
> > > Timestamps at only OUTPUT interface are normally used to control
> > > buffer processing time [1].
> > >
> > >
> > > "struct timeval	timestamp
> > >
> > > For input streams this is the system time (as returned by the
> > > gettimeofday()
> > > function) when the first data byte was captured. For output streams
> > 
> > Thanks for notifying me; this is going to be dependent on the timestamp
> > type.
> > 
> > Also most drivers use the time the buffer is finished rather than when
> > the "first data byte was captured", but that's separate I think.
> > 
> > > the data
> > > will not be displayed before this time, secondary to the nominal
> > frame
> > > rate determined by the current video standard in enqueued order.
> > > Applications can
> > > for example zero this field to display frames as soon as possible.
> > > The driver
> > > stores the time at which the first data byte was actually sent out in
> > > the timestamp field. This permits applications to monitor the drift
> > > between the video and system clock."
> > >
> > > In some use cases it might be useful to know exact frame processing
> > > time, where driver would be filling OUTPUT and CAPTURE value with
> > > exact monotonic clock values corresponding to a frame processing
> > start and end time.
> > 
> > Shouldn't this always be done in memory-to-memory processing? I could
> > imagine only performance measurements can benefit from other kind of
> > timestamps.
> > 
> > We could use different timestamp type to tell the timestamp source
> > isn't any system clock but an input buffer.
> 
> I hope that by input buffer you mean the OUTPUT buffer.
> So the timestamp is copied from the OUTPUT buffer to the corresponding
> CAPTURE buffer.

Correct. Input for the device. I think the OMAP 3 ISP also uses these names;
should it, that's another question. OUTPUT and CAPTURE are good.

> > 
> > What do you think?
> 
> Definite yes, if my assumption above is true. I did reply to your RFC
> suggesting to include this, but got no reply whatsoever. Maybe it got
> lost somewhere.

Could be. Anyway, I think we can then say that we agree. :-)

Who will write the patch? :-)

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
