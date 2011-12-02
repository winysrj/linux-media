Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:18728 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756878Ab1LBPlx (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Dec 2011 10:41:53 -0500
Received: from epcpsbgm2.samsung.com (mailout3.samsung.com [203.254.224.33])
 by mailout3.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LVL0020A29RWD70@mailout3.samsung.com> for
 linux-media@vger.kernel.org; Sat, 03 Dec 2011 00:41:52 +0900 (KST)
Received: from AMDN157 ([106.116.48.215])
 by mmp1.samsung.com (Oracle Communications Messaging Exchange Server 7u4-19.01
 64bit (built Sep  7 2010)) with ESMTPA id <0LVL002AB29MJT80@mmp1.samsung.com>
 for linux-media@vger.kernel.org; Sat, 03 Dec 2011 00:41:51 +0900 (KST)
From: Kamil Debski <k.debski@samsung.com>
To: 'Sakari Ailus' <sakari.ailus@iki.fi>,
	'Mauro Carvalho Chehab' <mchehab@redhat.com>
Cc: linux-media@vger.kernel.org,
	'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>,
	=?iso-8859-1?Q?'Sebastian_Dr=F6ge'?=
	<sebastian.droege@collabora.co.uk>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
References: <ADF13DA15EB3FE4FBA487CCC7BEFDF36225500763A@bssrvexch01>
 <4ED8C61C.3060404@redhat.com> <20111202135748.GO29805@valkosipuli.localdomain>
In-reply-to: <20111202135748.GO29805@valkosipuli.localdomain>
Subject: RE: [RFC] Resolution change support in video codecs in v4l2
Date: Fri, 02 Dec 2011 16:41:10 +0100
Message-id: <006b01ccb108$d3eafff0$7bc0ffd0$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-language: en-gb
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

> From: Sakari Ailus [mailto:sakari.ailus@iki.fi]
> Sent: 02 December 2011 14:58
> 
> Hi Mauro,
> 
> On Fri, Dec 02, 2011 at 10:35:40AM -0200, Mauro Carvalho Chehab wrote:
> > On 02-12-2011 08:31, Kamil Debski wrote:
> > >Hi,
> > >
> > >Yesterday we had a chat about video codecs in V4L2 and how to change the
> > >interface to accommodate the needs of GStreamer (and possibly other media
> > >players and applications using video codecs).
> > >
> > >The problem that many hardware codecs need a fixed number of pre-
> allocated
> > >buffers should be resolved when gstreamer 0.11 will be released.
> > >
> > >The main issue that we are facing is the resolution change and how it
> should be
> > >handled by the driver and the application. The resolution change is
> > >particularly common in digital TV. It occurs when content on a single
> channel
> > >is changed. For example there is the transition from a TV series to a
> > >commercials block. Other stream parameters may also change. The minimum
> number
> > >of buffers required for decoding is of particular interest of us. It is
> > >connected with how many old buffers are used for picture prediction.
> > >
> > >When this occurs there are two possibilities: resolution can be increased
> or
> > >decreased. In the first case it is very likely that the current buffers
> are too
> > >small to fit the decoded frames. In the latter there is the choice to use
> the
> > >existing buffers or allocate new set of buffer with reduced size. Same
> applies
> > >to the number of buffers - it can be decreased or increased.
> > >
> > >On the OUTPUT queue there is not much to be done. A buffer that contains
> a
> > >frame with the new resolution will not be dequeued until it is fully
> processed.
> > >
> > >On the CAPTURE queue the application has to be notified about the
> resolution
> > >change.  The idea proposed during the chat is to introduce a new flag
> > >V4L2_BUF_FLAG_WRONGFORMAT.
> >
> > IMO, a bad name. I would call it as V4L2_BUF_FLAG_FORMATCHANGED.
> 
> The alternative is to return a specific error code to the user --- the frame
> would not be decoded in either case. See below.
> 
> > >
> > >1) After all the frames with the old resolution are dequeued a buffer
> with the
> > >following flags V4L2_BUF_FLAG_ERROR | V4L2_BUF_FLAG_WRONGFORMAT is
> returned.
> > >2) To acknowledge the resolution change the application should STREAMOFF,
> check
> > >what has changed and then STREAMON.
> >
> > I don't think this is needed, if the buffer size is enough to support the
> new
> > format.
> 
> Sometimes not, but sometimes there are buffer line alignment requirements
> which must be communicated to the driver using S_FMT. If the frames are
> decoded using a driver-decided format, it might be impossible to actually
> use these decoded frames.
> That's why there's streamoff and streamon.

Also, if memory use is our key consideration then the application might want
to allocate smaller buffers.

> 
> > Btw, a few drivers (bttv comes into my mind) properly handles format
> changes.
> > This were there in order to support a bad behavior found on a few V4L1
> applications,
> > where the applications were first calling STREAMON and then setting the
> buffer.
> 
> The buffers do not have a format, the video device queue has. If the format
> changes during streaming it is impossible to find that out using the current
> API.
> 
> > If I'm not mistaken, the old vlc V4L1 driver used to do that.
> >
> > What bttv used to do is to allocate a buffer big enough to support the max
> resolution.
> > So, any format changes (size increase or decrease) would fit into the
> allocated
> > buffers.
> >
> > Depending on how applications want to handle format changes, and how big
> is the
> > amount of memory on the system, a similar approach may be done with
> CREATE_BUFFERS:
> > just allocate enough space for the maximum supported resolution for that
> stream,
> > and let the resolution changes, as required.
> 
> I'm not fully certain it is always possible to find out the largest stream
> resolution. I'd like an answer from someone knowing more about video codecs
> than I do.

That is one thing. Also, I don't think that allocating N buffers each of 
1920x1080 size up front is a good idea. In embedded systems the memory can
be scarce (although recently this is changing and we see smart phones with
1 GB of ram). It is better to allow application to use the extra memory when
possible, if the memory is required by the hardware then it can be reclaimed.

> 
> > I see two possible scenarios here:
> >
> > 1) new format size is smaller than the buffers. Just
> V4L2_BUF_FLAG_FORMATCHANGED
> > should be rised. No need to stop DMA transfers with STREAMOFF.
> >
> > 2) new requirement is for a bigger buffer. DMA transfers need to be
> stopped before
> > actually writing inside the buffer (otherwise, memory will be corrupted).
> In this
> > case, all queued buffers should be marked with an error flag. So, both
> > V4L2_BUF_FLAG_FORMATCHANGED and V4L2_BUF_FLAG_ERROR should raise. The new
> format
> > should be available via G_FMT.
> 
> In memory-to-memory devices, I assume that the processing stops immediately
> when it's not possible to further process the frames. The capture queue
> would be stopped.

Yes, in mem2mem processing is only done when there are enough capture and output
buffers. It is also less time critical than capture live video stream.

> 
> > >3) The application should check with G_FMT how did the format change and
> the
> > >V4L2_CID_MIN_BUFFERS_FOR_CAPTURE control to check how many buffers are
> > >required.
> > >4) Now it is necessary to resume processing:
> > >   A. If there is no need to change the size of buffers or their number
> the
> > >application needs only to STREAMON.
> > >   B. If it is necessary to allocate bigger buffers the application
> should use
> > >CREATE_BUFS to allocate new buffers, the old should be left until the
> > >application is finished and frees them with the DESTROY_BUFS call. S_FMT
> > >should be used to adjust the new format (if necessary and possible in HW).
> >
> > If the application already cleaned the DMA transfers with STREAMOFF, it
> can
> > also just re-queue the buffers with REQBUFS, e. g. vb2 should be smart
> enough to
> > accept both ways to allocate buffers.
> 
> No need to REQBUFS after streaming has been stopped. STREAMOFF won't harm
> the buffers in any way anymore --- as it did in videobuf1.
> 
> > Also, if the format changed, applications should use G_FMT  to get the new
> buffer
> > requirements. Using S_FMT here doesn't seem to be the right thing to do,
> as the
> > format may have changed again, while the DMA transfers were stopped by
> STREAMOFF.
> 
> S_FMT is needed to communicate line alignment to the driver. Not every time
> but sometimes, depending on the hardware.
> 
> > >   C. If only the number of buffers has changed then it is possible to
> add
> > >buffers with CREATE_BUF or remove spare buffers with DESTROY_BUFS (not
> yet
> > >implemented to my knowledge).
> >
> > I don't see why a new format would require more buffers.
> 
> That's a good point. It's more related to changes in stream properties ---
> the frame rate of the stream could change, too. That might be when you could
> like to have more buffers in the queue. I don't think this is critical
> either.
> 
> This could also depend on the properties of the codec. Again, I'd wish a
> comment from someone who knows codecs well. Some codecs need to be able to
> access buffers which have already been decoded to decode more buffers. Key
> frames, simply.

Usually there is a minimum number of buffers that has to be kept for future
references. New frames reference previous frames (and sometimes the following
frames as well) to achieve better compression. If we haven't got enough buffers
decoding cannot be done.

> 
> The user space still wants to be able to show these buffers, so a new flag
> would likely be required --- V4L2_BUF_FLAG_READ_ONLY, for example.

Currently it is done in the following way. On the CAPTURE side you have a
total of N buffers. Out of them K are necessary for decoding (K = 1 + L).
L is the number of buffers necessary for reference lookup and the single
buffer is required as the destination for new frame. If less than K buffers
are queued then no processing is done. The buffers that have been dequeued
should be ok with the application changing them. However if you request some
arbitrary display delay you may get buffers that still could be used as
reference. Thus I agree with Sakari that the V4L2_BUF_FLAG_READ_ONLY flag
should be introduced.

However I see one problem with such flag. Let's assume that we dequeue a
buffer. It is still needed as reference, thus it has the READ_ONLY flag
set. Then we dequeue another buffer. Ditto for that buffer. But after we
have dequeued the second buffer the first can be modified. How to handle this?

This flag could be used as a hint for the application saying that it is risky
to modify those buffers.
 
> > The minimal number of buffers is more related to latency issues and
> processing
> > speed at userspace than to any driver or format-dependent hardware
> constraints.
> >
> > On the other hand, the maximum number of buffers might eventually have
> some
> > constraint, e. g. a hardware might support less buffers, if the resolution
> > is too high.
> >
> > I prefer to not add anything to the V4L2 API with regards to changes at
> max/min
> > number of buffers, except if we actually have any limitation at the
> supported
> > hardware. In that case, it will likely need a separate flag, to indicate
> userspace
> > that buffer constraints have changed, and that audio buffers will also
> need to be
> > re-negotiated, in order to preserve A/V synch.
> 
> I think that boils down to the properties of the codec and possibly also the
> stream.

If a timestamp or sequence number is used then I don't see why should we
renegotiate audio buffers. Am I wrong? Number of audio and video of buffers
does not need to be correlated.

> 
> > >5) After the application does STREMON the processing should continue. Old
> > >buffers can still be used by the application (as CREATE_BUFS was used),
> but
> > >they should not be queued (error shall be returned in this case). After
> the
> > >application is finished with the old buffers it should free them with
> > >DESTROY_BUFS.
> >
> > If the buffers are bigger, there's no issue on not allowing queuing them.
> Enforcing
> > it will likely break drivers and eventually applications.
> 
> I think this means buffers that are too small for the new format. They are
> no longer needed after they have been displayed --- remember there must also
> be no interruption in displaying the video.

Yes, I have meant the buffers that are too small.
 
Best wishes,
--
Kamil Debski
Linux Platform Group
Samsung Poland R&D Center

