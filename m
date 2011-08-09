Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:29972 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752900Ab1HIJPJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 9 Aug 2011 05:15:09 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
Received: from spt2.w1.samsung.com ([210.118.77.14]) by mailout4.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LPN00BHDLP7ZJ20@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 09 Aug 2011 10:15:07 +0100 (BST)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LPN000CLLP6SY@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 09 Aug 2011 10:15:06 +0100 (BST)
Date: Tue, 09 Aug 2011 11:14:43 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: Possible issue in videobuf2 with buffer length check at QBUF time
In-reply-to: <201108081211.24012.laurent.pinchart@ideasonboard.com>
To: 'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>,
	'Pawel Osciak' <pawel@osciak.com>,
	'Marek Szyprowski' <m.szyprowski@samsung.com>
Cc: linux-media@vger.kernel.org
Message-id: <021301cc5674$c6e1bea0$54a53be0$%szyprowski@samsung.com>
Content-language: pl
References: <201108051055.08641.laurent.pinchart@ideasonboard.com>
 <CAMm-=zBQePQpaFZ2t7sfu8_u2V0BxLXgCZrQZt8dK8jHePSoow@mail.gmail.com>
 <201108081211.24012.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Monday, August 08, 2011 12:11 PM Laurent Pinchart wrote:

> On Friday 05 August 2011 17:01:09 Pawel Osciak wrote:
> > On Fri, Aug 5, 2011 at 01:55, Laurent Pinchart wrote:
> > > Hi Marek and Pawel,
> > >
> > > While reviewing an OMAP3 ISP patch, I noticed that videobuf2 doesn't
> > > verify the buffer length field value when a new USERPTR buffer is
> > > queued.
> >
> > That's a good catch. We should definitely do something about it.
> >
> > > The length given by userspace is copied to the internal buffer length
> > > field. It seems to be up to drivers to verify that the value is equal to
> > > or higher than the minimum required to store the image, but that's not
> > > clearly documented. Should the buf_init operation be made mandatory for
> > > drivers that support USERPTR, and documented as required to implement a
> > > length check ?
> >
> > Technically, drivers can do the length checks on buf_prepare if they
> > don't allow format changes after REQBUFS. On the other hand though, if
> > a driver supports USERPTR, the buffers queued from userspace have to
> > be verified on qbuf and the only place to do that would be buf_init.
> > So every driver that supports USERPTR would have to implement
> > buf_init, as you said.
> >
> > > Alternatively the check could be performed in videobuf2-core, which would
> > > probably make sense as the check is required. videobuf2 doesn't store the
> > > minimum size for USERPTR buffers though (but that can of course be
> > > changed).
> >
> > Let's say we make vb2 save minimum buffer size. This would have to be
> > done on queue_setup I imagine. We could add a new field to vb2_buffer
> > for that. One problem is that if the driver actually supports changing
> > format after REQBUFS, we would need a new function in vb2 to change
> > minimum buffer size. Actually, this has to be minimum plane sizes. So
> > the alternatives are:
> >
> > 1. Make buf_init required for drivers that support USERPTR; or
> > 2. Add minimum plane sizes to vb2_buffer,add a new return array
> > argument to queue_setup to return minimum plane sizes that would be
> > stored in vb2. Make vb2 verify sizes on qbuf of USERPTR. Add a new vb2
> > function for drivers to call when minimum sizes have to be changed.
> >
> > The first solution is way simpler for drivers that require this. The
> > second solution is maybe a bit simpler for drivers that do not, as
> > they would only have to return the sizes in queue_setup, but
> > implementing buf_init instead wouldn't be a big of a difference I
> > think. So I'm leaning towards the second solution.
> > Any comments, did I miss something?
> 
> Thanks for the analysis. I would go for the second solution as well.
> 
> Do we have any driver that supports changing the format after REQBUFS ? If not
> we can delay adding the new vb2 function until we get such a driver.

I really wonder if we should support changing the format which results in 
buffer/plane size change after REQBUFS. Please notice that it causes additional
problems with mmap-style buffers, which are allocated once during the REQBUFS
call. Also none driver support it right now and I doubt that changing buffer
size after REQBUFS can be implemented without breaking anything other (there
are a lot of things that depends on buffer size, both in vb2 and the drivers).

I would just simplify solution number 2 - imho vb2 should just store the
minimal buffer/plane size acquired in queue_setup and check if any buffers
that have been queued are large enough.

If one wants to change format to the one that requires other buffer size,
then he should just call STREAM_OFF, REQBUFS(0), S_FMT, REQBUFS(n) and
STREAM_ON. The other solution will be to use separately created buffers,
which already have format/size information attached (Guennadi's proposal).

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center

