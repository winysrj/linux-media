Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.w1.samsung.com ([210.118.77.12]:18603 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756826Ab2IYRRR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Sep 2012 13:17:17 -0400
Received: from eusync1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
 by mailout2.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MAX005WN1DDER00@mailout2.w1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 25 Sep 2012 18:17:37 +0100 (BST)
Received: from AMDN157 ([106.116.147.102])
 by eusync1.samsung.com (Oracle Communications Messaging Server 7u4-23.01
 (7.0.4.23.0) 64bit (built Aug 10 2011))
 with ESMTPA id <0MAX00GI31CRBH20@eusync1.samsung.com> for
 linux-media@vger.kernel.org; Tue, 25 Sep 2012 18:17:15 +0100 (BST)
From: Kamil Debski <k.debski@samsung.com>
To: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>, sakari.ailus@iki.fi,
	hverkuil@xs4all.nl, remi@remlab.net
References: <32114057.tIVjSTYujk@avalon> <5061DAE3.2080808@samsung.com>
In-reply-to: <5061DAE3.2080808@samsung.com>
Subject: RE: Re: [RFC] Timestamps and V4L2
Date: Tue, 25 Sep 2012 19:17:14 +0200
Message-id: <023f01cd9b41$9bf49790$d3ddc6b0$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 8BIT
Content-language: en-gb
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Sorry for such a long absence on the mailing list after the Mini summit,
I was out of office. I see that the discussion about timestamps has
already started, so I would like to add some comments. Especially
about mem-to-mem devices.

> Subject: Re: [RFC] Timestamps and V4L2
> Date: Tue, 25 Sep 2012 02:35:47 +0200
> From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> Hi Sylwester,
> 
> On Sunday 23 September 2012 20:40:36 Sylwester Nawrocki wrote:
> > On 09/22/2012 10:28 PM, Daniel Glöckner wrote:
> > > On Sat, Sep 22, 2012 at 07:12:52PM +0200, Sylwester Nawrocki wrote:
> > >> If we ever need the clock selection API I would vote for an IOCTL.
> > >> The controls API is a bad choice for something such fundamental as
> > >> type of clock for buffer timestamping IMHO. Let's stop making the
> > >> controls API a dumping ground for almost everything in V4L2! ;)
> > >>
> > >> Perhaps VIDIOC_QUERYBUF and VIDIOC_DQBUF should be reporting
> > >> timestamps type only for the time they are being called. Not per
buffer,
> > >> per device. And applications would be checking the flags any time they
> > >> want to find out what is the buffer timestamp type. Or every time if it
> > >> don't have full control over the device (S/G_PRIORITY).
> > >
> > > I'm all for adding an IOCTL, but if we think about adding a
> > > VIDIOC_S_TIMESTAMP_TYPE in the future, we might as well add a
> > > VIDIOC_G_TIMESTAMP_TYPE right now. Old drivers will return ENOSYS,
> > > so the application knows it will have to guess the type (or take own
> > > timestamps).
> >
> > Hmm, would it make sense to design a single ioctl that would allow
> > getting and setting the clock type, e.g. VIDIOC_CLOCK/TIMESTAMP_TYPE ?
> >
> > > I can't imagine anything useful coming from an app that has to process
> > > timestamps that change their source every now and then and I seriously
> > > doubt anyone will go to such an extent that they check the timestamp
> > > type on every buffer. If they don't set their priority high enough to
> > > prevent others from changing the timestamp type, they also run the
> > > risk of someone else changing the image format. It should be enough to
> > > forbid changing the timestamp type while I/O is in progress, as it is
> > > done for VIDIOC_S_FMT.
> >
> > I agree, but mem-to-mem devices can have multiple logically independent,
> > "concurrent" streams active. If the clock type is per device it might
> > not be that straightforward...
> 
> Does the clock type need to be selectable for mem-to-mem devices ? Do
device-
> specific timestamps make sense there ?

I think that device-specific (and device assigned) timestamp does not make
much
sense for m2m devices. The solution of my preference is copying the timestamp
and timecode structures from the OUTPUT buffer to the CAPTURE buffer resulting
from processing of the said OUTPUT buffer.

Let's analyze an m2m video codec (decoder):
1) The processed CAPTURE buffers can be dequeued in a different order then the
OUTPUT buffers that were used to generate them. The OUTPUT buffers are
supplied
in decoding order and are returned in display order.
2) One OUTPUT buffer can generate multiple CAPTURE buffers (two frames in one
compressed buffer)
3) A single CAPTURE buffer can be generated from multiple OUTPUT buffers (for
example in the slice mode, where each OUTPUT buffer contains only part of the
frame)

So when the contents of the timestamp/timecode are copied we get:
- a way to identify related OUTPUT and CAPTURE buffers (important)
- in case 2 we get multiple CAPTURE buffers with the same timestamp/timecode
  and incrementing sequence number
- in case 3 we get an CAPTURE buffer with the value of timestamp/timecode of
the
  last buffer OUTPUT used to generate that buffer
- an increasing sequence number as it is simply incremented for every dequeued
  CAPTURE buffer (not affect by copying the timestamp, but I think it's worth
  to mention this)

For simpler m2m devices - such as FIMC and G2D it still makes sense, but is
not
that necessary, as they return buffers CAPTURE in the same order as OTUPUT
buffers, which they were generated from.

Best wishes,
--
Kamil Debski
Linux Platform Group
Samsung Poland R&D Center

