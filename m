Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:63951 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753369Ab2KVTm1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Nov 2012 14:42:27 -0500
Received: from eusync4.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MDV0009RUIB0N80@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 22 Nov 2012 09:32:35 +0000 (GMT)
Received: from AMDN910 ([106.116.147.102])
 by eusync4.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTPA id <0MDV00791UHMK890@eusync4.samsung.com> for
 linux-media@vger.kernel.org; Thu, 22 Nov 2012 09:32:16 +0000 (GMT)
From: Kamil Debski <k.debski@samsung.com>
To: 'Sakari Ailus' <sakari.ailus@iki.fi>,
	'Sylwester Nawrocki' <sylvester.nawrocki@gmail.com>
Cc: 'Shaik Ameer Basha' <shaik.ameer@samsung.com>,
	linux-media@vger.kernel.org,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	kgene.kim@samsung.com, shaik.samsung@gmail.com,
	'Hans Verkuil' <hverkuil@xs4all.nl>
References: <1352270424-14683-1-git-send-email-shaik.ameer@samsung.com>
 <50AAAD6A.80709@gmail.com> <20121121193948.GB30360@valkosipuli.retiisi.org.uk>
In-reply-to: <20121121193948.GB30360@valkosipuli.retiisi.org.uk>
Subject: RE: [PATCH] [media] exynos-gsc: propagate timestamps from src to dst
 buffers
Date: Thu, 22 Nov 2012 10:32:09 +0100
Message-id: <01c501cdc894$3f9be9f0$bed3bdd0$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sakari,

> From: Sakari Ailus [mailto:sakari.ailus@iki.fi]
> Sent: Wednesday, November 21, 2012 8:40 PM
> 
> Hi Sylwester and Shaik,
> 
> On Mon, Nov 19, 2012 at 11:06:34PM +0100, Sylwester Nawrocki wrote:
> > On 11/07/2012 07:40 AM, Shaik Ameer Basha wrote:
> > >Make gsc-m2m propagate the timestamp field from source to
> destination
> > >buffers
> >
> > We probably need some means for letting know the mem-to-mem drivers
> > and applications whether timestamps are copied from OUTPUT to CAPTURE
> or not.
> > Timestamps at only OUTPUT interface are normally used to control
> > buffer processing time [1].
> >
> >
> > "struct timeval	timestamp
> >
> > For input streams this is the system time (as returned by the
> > gettimeofday()
> > function) when the first data byte was captured. For output streams
> 
> Thanks for notifying me; this is going to be dependent on the timestamp
> type.
> 
> Also most drivers use the time the buffer is finished rather than when
> the "first data byte was captured", but that's separate I think.
> 
> > the data
> > will not be displayed before this time, secondary to the nominal
> frame
> > rate determined by the current video standard in enqueued order.
> > Applications can
> > for example zero this field to display frames as soon as possible.
> > The driver
> > stores the time at which the first data byte was actually sent out in
> > the timestamp field. This permits applications to monitor the drift
> > between the video and system clock."
> >
> > In some use cases it might be useful to know exact frame processing
> > time, where driver would be filling OUTPUT and CAPTURE value with
> > exact monotonic clock values corresponding to a frame processing
> start and end time.
> 
> Shouldn't this always be done in memory-to-memory processing? I could
> imagine only performance measurements can benefit from other kind of
> timestamps.
> 
> We could use different timestamp type to tell the timestamp source
> isn't any system clock but an input buffer.

I hope that by input buffer you mean the OUTPUT buffer.
So the timestamp is copied from the OUTPUT buffer to the corresponding
CAPTURE buffer.

> 
> What do you think?

Definite yes, if my assumption above is true. I did reply to your RFC
suggesting to include this, but got no reply whatsoever. Maybe it got
lost somewhere.

Best wishes,
-- 
Kamil Debski
Linux Platform Group
Samsung Poland R&D Center


