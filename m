Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:47570 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933389Ab1LFOfo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Dec 2011 09:35:44 -0500
Date: Tue, 6 Dec 2011 16:35:38 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Kamil Debski <k.debski@samsung.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	'Sebastian =?iso-8859-1?Q?Dr=F6ge'?=
	<sebastian.droege@collabora.co.uk>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [RFC] Resolution change support in video codecs in v4l2
Message-ID: <20111206143538.GD938@valkosipuli.localdomain>
References: <ADF13DA15EB3FE4FBA487CCC7BEFDF36225500763A@bssrvexch01>
 <4ED8C61C.3060404@redhat.com>
 <20111202135748.GO29805@valkosipuli.localdomain>
 <4ED901C9.2050109@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ED901C9.2050109@redhat.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Fri, Dec 02, 2011 at 02:50:17PM -0200, Mauro Carvalho Chehab wrote:
> On 02-12-2011 11:57, Sakari Ailus wrote:
> >Hi Mauro,
> >
> >On Fri, Dec 02, 2011 at 10:35:40AM -0200, Mauro Carvalho Chehab wrote:
> >>On 02-12-2011 08:31, Kamil Debski wrote:
> >>>Hi,
> >>>
> >>>Yesterday we had a chat about video codecs in V4L2 and how to change the
> >>>interface to accommodate the needs of GStreamer (and possibly other media
> >>>players and applications using video codecs).
> >>>
> >>>The problem that many hardware codecs need a fixed number of pre-allocated
> >>>buffers should be resolved when gstreamer 0.11 will be released.
> >>>
> >>>The main issue that we are facing is the resolution change and how it should be
> >>>handled by the driver and the application. The resolution change is
> >>>particularly common in digital TV. It occurs when content on a single channel
> >>>is changed. For example there is the transition from a TV series to a
> >>>commercials block. Other stream parameters may also change. The minimum number
> >>>of buffers required for decoding is of particular interest of us. It is
> >>>connected with how many old buffers are used for picture prediction.
> >>>
> >>>When this occurs there are two possibilities: resolution can be increased or
> >>>decreased. In the first case it is very likely that the current buffers are too
> >>>small to fit the decoded frames. In the latter there is the choice to use the
> >>>existing buffers or allocate new set of buffer with reduced size. Same applies
> >>>to the number of buffers - it can be decreased or increased.
> >>>
> >>>On the OUTPUT queue there is not much to be done. A buffer that contains a
> >>>frame with the new resolution will not be dequeued until it is fully processed.
> >>>
> >>>On the CAPTURE queue the application has to be notified about the resolution
> >>>change.  The idea proposed during the chat is to introduce a new flag
> >>>V4L2_BUF_FLAG_WRONGFORMAT.
> >>
> >>IMO, a bad name. I would call it as V4L2_BUF_FLAG_FORMATCHANGED.
> >
> >The alternative is to return a specific error code to the user --- the frame
> >would not be decoded in either case. See below.
> 
> As I said, some drivers work with buffers with a bigger size than the format, and
> does allow setting a smaller format without the need of streamoff.
> >
> >>>
> >>>1) After all the frames with the old resolution are dequeued a buffer with the
> >>>following flags V4L2_BUF_FLAG_ERROR | V4L2_BUF_FLAG_WRONGFORMAT is returned.
> >>>2) To acknowledge the resolution change the application should STREAMOFF, check
> >>>what has changed and then STREAMON.
> >>
> >>I don't think this is needed, if the buffer size is enough to support the new
> >>format.
> >
> >Sometimes not, but sometimes there are buffer line alignment requirements
> >which must be communicated to the driver using S_FMT. If the frames are
> >decoded using a driver-decided format, it might be impossible to actually
> >use these decoded frames.
> >
> >That's why there's streamoff and streamon.
> 
> Don't get me wrong. What I'm saying is that there are valid cases where
> there's no need to streamoff/streamon. What I'm saying is that, when
> there's no need to do it, just don't rise the V4L2_BUF_FLAG_ERROR flag.
> The V4L2_BUF_FLAG_FORMATCHANGED still makes sense.

I try not to. :)

The issue is that it's the user space which knows how it is going to use the
buffers it dequeues from a device. It's not possible for the driver know
that --- unless explicitly told by the user. This could be a new flag, if we
need differing behaviour as it seems here.

The user may queue the same memory buffers to another device, which I
consider to be a common use case in embedded systems. The line alignment
requirements of the two (or more) devices often are not the same.

> 
> >>Btw, a few drivers (bttv comes into my mind) properly handles format changes.
> >>This were there in order to support a bad behavior found on a few V4L1 applications,
> >>where the applications were first calling STREAMON and then setting the buffer.
> >
> >The buffers do not have a format, the video device queue has. If the format
> >changes during streaming it is impossible to find that out using the current
> >API.
> 
> Yes, but extending it to proper support it is the scope of this RFC. Yet, several
> drivers allow to resize the "format" (e. g. the resolution of the image) without
> streamon/streamoff, via an explicit call to S_FMT.
> 
> So, whatever change at the API is done, it should keep supporting format changes
> (in practice, resolution changes) without the need of re-initializing the DMA engine,
> of course when such change won't break the capability for userspace to decode
> the new frames.

Stopping and starting the queue does not involve additional penalty: a
memory-to-memory device processes buffers one at a time, and most of the
hardware stops between the buffers in any case before being started by the
software again. The buffers are not affected either; they stay mapped and
pinned to memory.

> 
> >>If I'm not mistaken, the old vlc V4L1 driver used to do that.
> >>
> >>What bttv used to do is to allocate a buffer big enough to support the max resolution.
> >>So, any format changes (size increase or decrease) would fit into the allocated
> >>buffers.
> >>
> >>Depending on how applications want to handle format changes, and how big is the
> >>amount of memory on the system, a similar approach may be done with CREATE_BUFFERS:
> >>just allocate enough space for the maximum supported resolution for that stream,
> >>and let the resolution changes, as required.
> >
> >I'm not fully certain it is always possible to find out the largest stream
> >resolution. I'd like an answer from someone knowing more about video codecs
> >than I do.
> 
> When the input or output is some hardware device, there is a maximum resolution
> (sensor resolution, monitor resolution, pixel sampling rate, etc). A pure DSP block
> doesn't have it, but, anyway, it should be up to the userspace application to decide
> if it wants to over-allocate a buffer, in order to cover a scenario where the
> resolution may change or not.

In this case, allocating bigger buffers than necessary is a big
disadvantage, and forcing the application to requeue the compressed data
to the OUTPUT queue doesn't sound very appealing either. This could involve
the application having to queue several buffers which already have been
decoded earlier on. Also figuring out how many is a task for the decoder,
not the application.

> >>I see two possible scenarios here:
> >>
> >>1) new format size is smaller than the buffers. Just V4L2_BUF_FLAG_FORMATCHANGED
> >>should be rised. No need to stop DMA transfers with STREAMOFF.
> >>
> >>2) new requirement is for a bigger buffer. DMA transfers need to be stopped before
> >>actually writing inside the buffer (otherwise, memory will be corrupted). In this
> >>case, all queued buffers should be marked with an error flag. So, both
> >>V4L2_BUF_FLAG_FORMATCHANGED and V4L2_BUF_FLAG_ERROR should raise. The new format
> >>should be available via G_FMT.
> >
> >In memory-to-memory devices, I assume that the processing stops immediately
> >when it's not possible to further process the frames. The capture queue
> >would be stopped.
> 
> In all cases, when it is not possible to further process the frames, the
> stream needs to be stopped (whatever it means ;) ).
> 
> The decision of stopping the streaming should be taken by the driver. API needs
> to properly support it and provide some way for userspace to re-start streaming
> with the correct format, when this occurs.

Do you mean straeming as in V4L2 API or on hardware devices? In
memory-to-memory processing they are actually different concepts. The
decoding has to stop since there are no destination buffers where to write
the data to.

> >>>3) The application should check with G_FMT how did the format change and the
> >>>V4L2_CID_MIN_BUFFERS_FOR_CAPTURE control to check how many buffers are
> >>>required.
> >>>4) Now it is necessary to resume processing:
> >>>   A. If there is no need to change the size of buffers or their number the
> >>>application needs only to STREAMON.
> >>>   B. If it is necessary to allocate bigger buffers the application should use
> >>>CREATE_BUFS to allocate new buffers, the old should be left until the
> >>>application is finished and frees them with the DESTROY_BUFS call. S_FMT
> >>>should be used to adjust the new format (if necessary and possible in HW).
> >>
> >>If the application already cleaned the DMA transfers with STREAMOFF, it can
> >>also just re-queue the buffers with REQBUFS, e. g. vb2 should be smart enough to
> >>accept both ways to allocate buffers.
> >
> >No need to REQBUFS after streaming has been stopped. STREAMOFF won't harm
> >the buffers in any way anymore --- as it did in videobuf1.
> 
> OK, but userspace applications may use REQBUFS instead of CREATE_BUFFERS, as REQBUFS
> is part of the API.

True. But new REQBUFS, as far as I remember, re-allocates the buffers,
causing a glitch to the stream. That's why CREATE_BUFS was proposed.

...

> >That's a good point. It's more related to changes in stream properties ---
> >the frame rate of the stream could change, too. That might be when you could
> >like to have more buffers in the queue. I don't think this is critical
> >either.
> >
> >This could also depend on the properties of the codec. Again, I'd wish a
> >comment from someone who knows codecs well. Some codecs need to be able to
> >access buffers which have already been decoded to decode more buffers. Key
> >frames, simply.
> 
> Ok, but let's not add unneeded things at the API if you're not sure. If we have
> such need for a given hardware, then add it. Otherwise, keep it simple.

This is not so much dependent on hardware but on the standards which the
cdoecs implement.

> >The user space still wants to be able to show these buffers, so a new flag
> >would likely be required --- V4L2_BUF_FLAG_READ_ONLY, for example.
> 
> Huh? Assuming a capture device, when kernel makes a buffer available to userspace,
> kernel should not touch on it anymore (not even for read - although reading from
> it probably won't cause any issues, as video applications in general don't write
> into those buffers). The opposite is true for output devices: once userspace fills it,
> and queues, it should not touch that buffer again.
> 
> This is part of the queue/dequeue logic. I can't see any need for an extra
> flag to explicitly say that.

There is a reason to do so. An example of this is below. The
memory-to-memory device has two queues, output can capture. A video decoder
memory-to-memory device's output queue handles compressed video and the
capture queue provides the application decoded frames.

Certain frames in the stream are key frames, meaning that the decoding of
the following non-key frames requires access to the key frame. The number of
non-key frame can be relatively large, say 16, depending on the codec.

If the user should wait for all the frames to be decoded before the key
frame can be shown, then either the key frame is to be skipped or delayed.
Both of the options are highly undesirable.

Alternatively one could allocate the double number of buffers required. At
1080p and 16 buffers this could be roughly 66 MB. Additionally, starting the
playback is delayed for the duration for the decoding of those frames. I
think we should not force users to do so.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
