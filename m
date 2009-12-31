Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:60722 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752851AbZLaEut convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Dec 2009 23:50:49 -0500
From: "Hiremath, Vaibhav" <hvaibhav@ti.com>
To: Pawel Osciak <p.osciak@samsung.com>,
	"'Hans Verkuil'" <hverkuil@xs4all.nl>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-samsung-soc@vger.kernel.org"
	<linux-samsung-soc@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
	"Karicheri, Muralidharan" <m-karicheri2@ti.com>,
	"'Guru Raj'" <gururaj.nagendra@intel.com>,
	"'Xiaolin Zhang'" <xiaolin.zhang@intel.com>,
	"'Magnus Damm'" <magnus.damm@gmail.com>,
	"'Sakari Ailus'" <sakari.ailus@maxwell.research.nokia.com>
Date: Thu, 31 Dec 2009 10:20:28 +0530
Subject: RE: [PATCH/RFC v2.1 0/2] Mem-to-mem device framework
Message-ID: <19F8576C6E063C45BE387C64729E7394044A277BB2@dbde02.ent.ti.com>
References: <1261574255-23386-1-git-send-email-p.osciak@samsung.com>
 <200912231605.44181.hverkuil@xs4all.nl>
 <000001ca87cc$f599dca0$e0cd95e0$%osciak@samsung.com>
In-Reply-To: <000001ca87cc$f599dca0$e0cd95e0$%osciak@samsung.com>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> -----Original Message-----
> From: Pawel Osciak [mailto:p.osciak@samsung.com]
> Sent: Monday, December 28, 2009 8:19 PM
> To: 'Hans Verkuil'
> Cc: linux-media@vger.kernel.org; linux-samsung-soc@vger.kernel.org;
> linux-arm-kernel@lists.infradead.org; Marek Szyprowski;
> kyungmin.park@samsung.com; Hiremath, Vaibhav; Karicheri,
> Muralidharan; 'Guru Raj'; 'Xiaolin Zhang'; 'Magnus Damm'; 'Sakari
> Ailus'
> Subject: RE: [PATCH/RFC v2.1 0/2] Mem-to-mem device framework
> 
> Hello Hans,
> 
> 
> On Wednesday 23 December 2009 16:06:18 Hans Verkuil wrote:
> > Thank you for working on this! It's much appreciated. Now I've
> noticed that
> > patches regarding memory-to-memory and memory pool tend to get
> very few comments.
> > I suspect that the main reason is that these are SoC-specific
> features that do
> > not occur in consumer-type products. So most v4l developers do not
> have the
> > interest and motivation (and time!) to look into this.
> 
> Thank you very much for your response. We were a bit surprised with
> the lack of
> responses as there seemed to be a good number of people interested
> in this area.
> 
> I'm hoping that everybody interested would take a look at the test
> device posted
> along with the patches. It's virtual, no specific hardware required,
> but it
> demonstrates the concepts behind the framework, including
> transactions.
> 
[Hiremath, Vaibhav] I was on vacation and resumed today itself, I will go through these patch series this weekend and will get back to you.

I just had cursory look and I would say it should be really good starting point for us to support mem-to-mem devices.

Thanks,
Vaibhav

> > One thing that I am missing is a high-level overview of what we
> want. Currently
> > there are patches/RFCs floating around for memory-to-memory
> support, multiplanar
> > support and memory-pool support.
> >
> > What I would like to see is a RFC that ties this all together from
> the point of
> > view of the public API. I.e. what are the requirements? Possibly
> solutions? Open
> > questions? Forget about how to implement it for the moment, that
> will follow
> > from the chosen solutions.
> 
> Yes, that's true, sorry about that. We've been so into it after the
> memory pool
> discussion and the V4L2 mini-summit that I neglected describing the
> big picture
> behind this.
> 
> So to give a more high-level description, from the point of view of
> applications
> and the V4L2 API:
> 
> ---------------
> Requirements:
> ---------------
> (Some of the following were first posted by Laurent in:
> http://thread.gmane.org/gmane.linux.drivers.video-input-
> infrastructure/10204).
> 
> 1. Support for devices that take input data in a source buffer, take
> a separate
> destination buffer, process the source data and put it in the
> destination buffer.
> 
> 2. Allow sharing buffers between devices, effectively chaining them
> to form
> video pipelines. An example of this could be a video decoder, fed
> with video
> stream which returns raw frames, which then have to be postprocessed
> by another
> device and displayed. This is the main scenario we need to have for
> our S3C/S5P
> series SoCs. Of course, we'd like zero-copy.
> 
> 3. Allow using more than one buffer by the device at the same time.
> This is not
> supported by videobuffer (e.g. we have to choose on which buffer
> we'd like
> to sleep, and we do not always know that). This is not really a
> requirement
> from the V4L2 API point of view, but has direct influence on how
> poll() and
> blocking I/O works.
> 
> 4. Multiplanar buffers. Our devices require them (see the RFC for
> more details:
> http://article.gmane.org/gmane.linux.drivers.video-input-
> infrastructure/11212).
> 
> 5. Solve problems with cache coherency on non-x86 architectures,
> especially in
> videobuf for OUTPUT buffers. We need to flush the cache before
> starting the
> transaction.
> 
> 6. Reduce buffer queuing latency, e.g.: move operations such as
> locking, out
> of qbuf.
> Applications would like to queue a buffer and be able to fire up the
> device
> as fast as possible.
> 
> 7. Large buffer allocations, buffer preallocation, etc.
> 
> 
> ---------------
> Solutions:
> ---------------
> 1. After a detailed discussion, we agreed in:
> http://thread.gmane.org/gmane.linux.drivers.video-input-
> infrastructure/10668,
> that we'd like the application to be able to queue/dequeue both
> OUTPUT (as source)
> and CAPTURE (as destination) buffers on one video node. Activating
> the device
> (after streamon) would take effect only if there are both types of
> buffers
> available. The application would put source data into OUTPUT buffers
> and expect
> to find it processed in dequeued CAPTURE buffers. Addressed by
> mem2mem framework.
> 
> 2. I don't see anything to do here from the API's point of view. The
> application
> would open two video nodes, e.g. video decoder and video
> postprocessor and queue
> buffers dequeued from decoder on the postprocessor. To get the best
> performance,
> this requires the buffers to be marked as non cached somehow to
> avoid unneeded
> cache syncs.
> 
> 3. Mem2mem addresses this partially by adding a "transaction"
> concept. It's
> not bullet-proof though, as it assumes the buffers will be returned
> in the same
> order as passed. Some videobuffer limitations will have to be
> addressed here.
> 
> 4. See my RFC. Patches in progress.
> 
> 5. We have narrowed it down to an additional sync() before the
> operation
> (i.e. in qbuf), but more issues may exist here. I have already added
> sync()
> support for qbuf with minimal changes to videobuf and will be
> posting the
> proposal soon. This also requires identifying the direction of the
> sync, but
> we have found a way to do this without adding anything new (videobuf
> flags
> are enough).
> 
> 6. Later. We haven't done anything in this field.
> 
> 7. We use our own allocator (see
> http://thread.gmane.org/gmane.linux.ports.arm.kernel/56879), but we
> have a new
> concept for that which we'd like to discuss separately later.
> 
> 
> > Note that I would suggest though that the memory-pool part is
> split into two
> > parts: how to actually allocate the memory is pretty much separate
> from how v4l
> > will use it. The actual allocation part is probably quite complex
> and might
> > even be hardware dependent and should be discussed separately. But
> how to use
> > it is something that can be discussed without needing to know how
> it was
> > allocated.
> 
> Exactly, this is the approach we have assumed right now. We'd like
> to introduce
> each part of the infrastructure incrementally. The plan was to do
> exactly as
> you said: leave the allocator-specific parts for later and for a
> separate
> discussion.
> We intend to follow with multi-planar buffers and then to focus on
> dma-contig,
> as this is what our hardware requires.
> 
> > BTW, what is the status of the multiplanar RFC? I later realized
> that that RFC
> > might be very useful for adding meta-data to buffers. There are
> several cases
> > where that is useful: sensors that provide meta-data when
> capturing a frame and
> > imagepipelines (particularly in memory-to-memory cases) that want
> to have all
> > parameters as part of the meta-data associated with the image.
> There may well
> > be more of those.
> 
> This got pushed back but now after m2m, it's become next task on my
> list. I
> expect to be posting patches in a week or two, hopefully.
> I understand that you'd like to make the pointer in the union and
> the helper
> struct more generic to use it to pass different types of
> information?
> 
> 
> Best regards
> --
> Pawel Osciak
> Linux Platform Group
> Samsung Poland R&D Center
> 
> 
> 

