Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:33723 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752626Ab3AWIrO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Jan 2013 03:47:14 -0500
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MH2001IWLQDL5C0@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 23 Jan 2013 08:47:12 +0000 (GMT)
Received: from AMDN910 ([106.116.147.102])
 by eusync1.samsung.com (Oracle Communications Messaging Server 7u4-23.01
 (7.0.4.23.0) 64bit (built Aug 10 2011))
 with ESMTPA id <0MH200402LQJ2C90@eusync1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 23 Jan 2013 08:47:12 +0000 (GMT)
From: Kamil Debski <k.debski@samsung.com>
To: 'Sakari Ailus' <sakari.ailus@iki.fi>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, arun.kk@samsung.com,
	mchehab@redhat.com, laurent.pinchart@ideasonboard.com,
	hans.verkuil@cisco.com, kyungmin.park@samsung.com
References: <1358156164-11382-1-git-send-email-k.debski@samsung.com>
 <1358156164-11382-4-git-send-email-k.debski@samsung.com>
 <20130119174329.GL13641@valkosipuli.retiisi.org.uk>
 <029c01cdf7e0$b64ce4c0$22e6ae40$%debski@samsung.com>
 <50FE6BFB.3090102@samsung.com>
 <03ad01cdf8ca$0dfcb580$29f62080$%debski@samsung.com>
 <20130122184442.GB18639@valkosipuli.retiisi.org.uk>
In-reply-to: <20130122184442.GB18639@valkosipuli.retiisi.org.uk>
Subject: RE: [PATCH 3/3] v4l: Set proper timestamp type in selected drivers
 which use videobuf2
Date: Wed, 23 Jan 2013 09:47:06 +0100
Message-id: <040701cdf946$3a18c060$ae4a4120$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

> From: 'Sakari Ailus' [mailto:sakari.ailus@iki.fi]
> Sent: Tuesday, January 22, 2013 7:45 PM
> 
> Hi Kamil,
> 
> On Tue, Jan 22, 2013 at 06:58:09PM +0100, Kamil Debski wrote:
> ...
> > > OTOH I'm not certain what's the main purpose of such copied
> > > timestamps, is it to identify which CAPTURE buffer comes from which
> OUTPUT buffer ?
> > >
> >
> > Yes, indeed. This is especially useful when the CAPTURE buffers can
> be
> > returned in an order different than the order of corresponding OUTPUT
> > buffers.
> 
> How about sequence numbers then? Shouldn't that be also copied?
> 
> If you're interested in the order alone, comparing the sequence numbers
> is a better way to figure out the order. That does require strict one-
> to-one mapping between the output and capture buffers, though, and that
> does not help in knowing when it might be a good time to display a
> frame, for instance.
> 

The idea behind copying the timestamp was that it can propagate the
timestamp
from the video stream. If this info is absent application can generate them
and
still be able to connect OUTPUT and CAPTURE frames. 

While decoding MPEG4 it is possible to get a compressed frame saying
"nothing
to do here, move along" (which basically means that the last frame should be
repeated).
This is where increasing sequence number comes in handy. Even if no
timestamp
is set the application can detect such empty frames and display the decoded
video
correctly.

Copying sequence numbers was already discussed in January 2012 IIRC. The
recommendation
was that the device keeps an internal sequence counter and assigns it to
both OUTPUT and
CAPTURE buffers, so they can be associated.

I think that we're diverting from the main topic of this discussion. My
patches fix a
problem and the only thing that, we cannot agree about is what the default
timestamp type
should be.

Best wishes,
-- 
Kamil Debski
Linux Platform Group
Samsung Poland R&D Center


