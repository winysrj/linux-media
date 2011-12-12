Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:37938 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423Ab1LLK6s (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 12 Dec 2011 05:58:48 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Kamil Debski <k.debski@samsung.com>
Subject: Re: [RFC] Resolution change support in video codecs in v4l2
Date: Mon, 12 Dec 2011 11:59:02 +0100
Cc: "'Sakari Ailus'" <sakari.ailus@iki.fi>,
	"'Mauro Carvalho Chehab'" <mchehab@redhat.com>,
	linux-media@vger.kernel.org,
	"'Sebastian =?iso-8859-1?q?Dr=F6ge=27?="
	<sebastian.droege@collabora.co.uk>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
References: <ADF13DA15EB3FE4FBA487CCC7BEFDF36225500763A@bssrvexch01> <20111206143538.GD938@valkosipuli.localdomain> <00da01ccb428$3c9522c0$b5bf6840$%debski@samsung.com>
In-Reply-To: <00da01ccb428$3c9522c0$b5bf6840$%debski@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201112121159.03471.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kamil,

On Tuesday 06 December 2011 16:03:33 Kamil Debski wrote:
> On 06 December 2011 15:36 Sakari Ailus wrote:
> > On Fri, Dec 02, 2011 at 02:50:17PM -0200, Mauro Carvalho Chehab wrote:
> > > On 02-12-2011 11:57, Sakari Ailus wrote:
> > > > Some codecs need to be able to access buffers which have already been
> > > > decoded to decode more buffers. Key frames, simply.
> > > 
> > > Ok, but let's not add unneeded things at the API if you're not sure. If
> > > we have such need for a given hardware, then add it. Otherwise, keep it
> > > simple.
> >
> > This is not so much dependent on hardware but on the standards which the
> > cdoecs implement.
> > 
> > > > The user space still wants to be able to show these buffers, so a new
> > > > flag would likely be required --- V4L2_BUF_FLAG_READ_ONLY, for
> > > > example.
> > > 
> > > Huh? Assuming a capture device, when kernel makes a buffer available to
> > > userspace, kernel should not touch on it anymore (not even for read -
> > > although reading from it probably won't cause any issues, as video
> > > applications in general don't write into those buffers). The opposite is
> > > true for output devices: once userspace fills it, and queues, it should
> > > not touch that buffer again.
> > > 
> > > This is part of the queue/dequeue logic. I can't see any need for an
> > > extra flag to explicitly say that.
> > 
> > There is a reason to do so. An example of this is below. The
> > memory-to-memory device has two queues, output can capture. A video
> > decoder memory-to-memory device's output queue handles compressed video
> > and the capture queue provides the application decoded frames.
> > 
> > Certain frames in the stream are key frames, meaning that the decoding of
> > the following non-key frames requires access to the key frame. The number
> > of non-key frame can be relatively large, say 16, depending on the
> > codec.
> > 
> > If the user should wait for all the frames to be decoded before the key
> > frame can be shown, then either the key frame is to be skipped or
> > delayed. Both of the options are highly undesirable.
> 
> I don't think that such a delay is worrisome. This is only initial delay.
> The hw will process these N buffers and after that it works exactly the
> same as it would without the delay in terms of processing time.

For offline video decoding (such as playing a movie for instance) that's 
probably not a big issue. For online video decoding (video conferencing) where 
you want to minimize latency it can be.

> > Alternatively one could allocate the double number of buffers required.
> > At 1080p and 16 buffers this could be roughly 66 MB. Additionally,
> > starting the playback is delayed for the duration for the decoding of
> > those frames. I think we should not force users to do so.
> 
> I really don't think it is necessary to allocate twice as many buffers.
> Assuming that hw needs K buffers you may alloc N (= K + L) and the
> application may use all these L buffers at a time.

-- 
Regards,

Laurent Pinchart
