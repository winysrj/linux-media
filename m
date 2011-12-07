Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:24012 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755357Ab1LGLt5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 7 Dec 2011 06:49:57 -0500
Received: from epcpsbgm1.samsung.com (mailout4.samsung.com [203.254.224.34])
 by mailout4.samsung.com
 (Oracle Communications Messaging Exchange Server 7u4-19.01 64bit (built Sep  7
 2010)) with ESMTP id <0LVU0046R0V73O40@mailout4.samsung.com> for
 linux-media@vger.kernel.org; Wed, 07 Dec 2011 20:49:55 +0900 (KST)
Received: from AMDN157 ([106.116.48.215])
 by mmp1.samsung.com (Oracle Communications Messaging Exchange Server 7u4-19.01
 64bit (built Sep  7 2010)) with ESMTPA id <0LVU00IJ80V1GZ80@mmp1.samsung.com>
 for linux-media@vger.kernel.org; Wed, 07 Dec 2011 20:49:55 +0900 (KST)
From: Kamil Debski <k.debski@samsung.com>
To: 'Mauro Carvalho Chehab' <mchehab@redhat.com>
Cc: 'Sakari Ailus' <sakari.ailus@iki.fi>,
	'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org,
	=?utf-8?Q?'Sebastian_Dr=C3=B6ge'?=
	<sebastian.droege@collabora.co.uk>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	'Hans Verkuil' <hans.verkuil@cisco.com>
References: <ADF13DA15EB3FE4FBA487CCC7BEFDF36225500763A@bssrvexch01>
 <4ED905E0.5020706@redhat.com>
 <007201ccb118$633ff890$29bfe9b0$%debski@samsung.com>
 <201112061301.01010.laurent.pinchart@ideasonboard.com>
 <20111206142821.GC938@valkosipuli.localdomain> <4EDE29AA.8090203@redhat.com>
 <00de01ccb42a$7cddab70$76990250$%debski@samsung.com>
 <4EDE375B.6010900@redhat.com>
 <00df01ccb431$bd28d9f0$377a8dd0$%debski@samsung.com>
 <4EDE454D.5060605@redhat.com>
In-reply-to: <4EDE454D.5060605@redhat.com>
Subject: RE: [RFC] Resolution change support in video codecs in v4l2
Date: Wed, 07 Dec 2011 12:49:07 +0100
Message-id: <00f501ccb4d6$3d8e03a0$b8aa0ae0$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT
Content-language: en-gb
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> From: Mauro Carvalho Chehab [mailto:mchehab@redhat.com]
> Sent: 06 December 2011 17:40
> 
> On 06-12-2011 14:11, Kamil Debski wrote:
> >> From: Mauro Carvalho Chehab [mailto:mchehab@redhat.com]
> >> Sent: 06 December 2011 16:40
> >>
> >> On 06-12-2011 13:19, Kamil Debski wrote:
> >>>> From: Mauro Carvalho Chehab [mailto:mchehab@redhat.com]
> >>>> Sent: 06 December 2011 15:42
> >>>>
> >>>> On 06-12-2011 12:28, 'Sakari Ailus' wrote:
> >>>>> Hi all,
> >>>>>
> >>>>> On Tue, Dec 06, 2011 at 01:00:59PM +0100, Laurent Pinchart wrote:
> >>>>> ...
> >>>>>>>>>>> 2) new requirement is for a bigger buffer. DMA transfers need to
> >> be
> >>>>>>>>>>> stopped before actually writing inside the buffer (otherwise,
> >> memory
> >>>>>>>>>>> will be corrupted).
> >>>>>>>>>>>
> >>>>>>>>>>> In this case, all queued buffers should be marked with an error
> >> flag.
> >>>>>>>>>>> So, both V4L2_BUF_FLAG_FORMATCHANGED and V4L2_BUF_FLAG_ERROR
> >> should
> >>>>>>>>>>> raise. The new format should be available via G_FMT.
> >>>>>>
> >>>>>> I'd like to reword this as follows:
> >>>>>>
> >>>>>> 1. In all cases, the application needs to be informed that the format
> >> has
> >>>>>> changed.
> >>>>>>
> >>>>>> V4L2_BUF_FLAG_FORMATCHANGED (or a similar flag) is all we need. G_FMT
> >>>> will
> >>>>>> report the new format.
> >>>>>>
> >>>>>> 2. In all cases, the application must have the option of reallocating
> >>>> buffers
> >>>>>> if it wishes.
> >>>>>>
> >>>>>> In order to support this, the driver needs to wait until the
> >> application
> >>>>>> acknowledged the format change before it starts decoding the stream.
> >>>>>> Otherwise, if the codec started decoding the new stream to the
> existing
> >>>>>> buffers by itself, applications wouldn't have the option of freeing
> the
> >>>>>> existing buffers and allocating smaller ones.
> >>>>>>
> >>>>>> STREAMOFF/STREAMON is one way of acknowledging the format change. I'm
> >> not
> >>>>>> opposed to other ways of doing that, but I think we need an
> >>>> acknowledgment API
> >>>>>> to tell the driver to proceed.
> >>>>>
> >>>>> Forcing STRAEMOFF/STRAEMON has two major advantages:
> >>>>>
> >>>>> 1) The application will have an ability to free and reallocate buffers
> >> if
> >>>> it
> >>>>> wishes so, and
> >>>>>
> >>>>> 2) It will get explicit information on the changed format. Alternative
> >>>> would
> >>>>> require an additional API to query the format of buffers in cases the
> >>>>> information isn't implicitly available.
> >>>>
> >>>> As already said, a simple flag may give this meaning. Alternatively (or
> >>>> complementary,
> >>>> an event may be generated, containing the new format).
> >>>>>
> >>>>> If we do not require STRAEMOFF/STREAMON, the stream would have to be
> >>>> paused
> >>>>> until the application chooses to continue it after dealing with its
> >>>> buffers
> >>>>> and formats.
> >>>>
> >>>> No. STREAMOFF is always used to stop the stream. We can't make it mean
> >>>> otherwise.
> >>>>
> >>>> So, after calling it, application should assume that frames will be
> lost,
> >>>> while
> >>>> the DMA engine doesn't start again.
> >>>
> >>> Do you mean all buffers or just those that are queued in hardware?
> >>
> >> Of course the ones queued.
> >>
> >>> What has been processed stays processed, it should not matter to the
> >> buffers
> >>> that have been processed.
> >>
> >> Sure.
> >>
> >>> The compressed buffer that is queued in the driver and that caused the
> >> resolution
> >>> change is on the OUTPUT queue.
> >>
> >> Not necessarily. If the buffer is smaller than the size needed for the
> >> resolution
> >> change, what is there is trash, as it could be a partially filled buffer
> or
> >> an
> >> empty buffer, depending if the driver detected about the format change
> after
> >> or
> >> before start filling it.
> >
> > I see the problem. If a bigger buffer is needed it's clear. A buffer with
> > no sane data is returned and *_FORMAT_CHANGED | *_ERROR flags are set.
> > If the resolution is changed but it fits the current conditions (size +
> number
> > of buffers) then what should be the contents of the returned buffer?
> 
> The one returned on G_FMT or at an specific event. Userspace application can
> change it later with S_FMT, if needed.
> 
> > I think that still it should contain no useful data, just *_FORMAT_CHANGED
> | *_ERROR
> > flags set. Then the application could decide whether it keeps the current
> > size/alignment/... or should it allocate new buffers. Then ACK the driver.
> 
> This will cause frame losses on Capture devices. It probably doesn't make
> sense to
> define resolution change support like this for output devices.
> 
> Eventually, we may have an extra flag: *_PAUSE. If *_PAUSE is detected, a
> VIDEO_DECODER_CMD
> is needed to continue.
> 
> So, on M2M devices, the 3 flags are raised and the buffer is not filled.
> This would cover
> Sakari's case.
> 
> > For our (Samsung) hw this is not a problem, we could always use the
> existing buffers
> > if it is possible (size). But Sakari had reported that he might need to
> adjust some
> > alignment property. Also, having memory constraints, the application might
> choose
> > to allocate smaller buffers.
> >
> >
> >>
> >>> STREMOFF is only done on the CAPTURE queue, so it
> >>> stays queued and information is retained.
> >>>
> >>>   From CAPTURE all processed buffers have already been dequeued, so yes
> the
> >> content of
> >>> the buffers queued in hw is lost. But this is ok, because after the
> >> resolution change
> >>> the previous frames are not used in prediction.
> >>
> >> No. According with the spec:
> >>
> >> 	The VIDIOC_STREAMON and VIDIOC_STREAMOFF ioctl start and stop the
> >> capture or
> >> 	output process during streaming (memory mapping or user pointer) I/O.
> >>
> >> 	Specifically the capture hardware is disabled and no input buffers are
> >> filled
> >> 	(if there are any empty buffers in the incoming queue) until
> >> VIDIOC_STREAMON
> >> 	has been called. Accordingly the output hardware is disabled, no video
> >> signal
> >> 	is produced until VIDIOC_STREAMON has been called. The ioctl will
> >> succeed
> >> 	only when at least one output buffer is in the incoming queue.
> >>
> >> 	The VIDIOC_STREAMOFF ioctl, apart of aborting or finishing any DMA in
> >> progress,
> >> 	unlocks any user pointer buffers locked in physical memory, and it
> >> removes all
> >> 	buffers from the incoming and outgoing queues. That means all images
> >> captured
> >> 	but not dequeued yet will be lost, likewise all images enqueued for
> >> output
> >> 	but not transmitted yet. I/O returns to the same state as after
> >> calling
> >> 	VIDIOC_REQBUFS and can be restarted accordingly.
> >
> > The thing is that we have two queues in memory-to-memory devices.
> > I think the above does apply to the CAPTURE queue:
> > - no processing is done after STREAMOFF
> > - buffers that have been queue are dequeued and their content is lost
> > Am I wrong?
> 
> This is what is there at the spec. I think we need to properly specify what
> happens for M2M devices.
> 
> > The buffer that had to be kept is on the OUTPUT queue.
> > (the compressed data that caused the resolution change).
> 
> >
> >>
> >>> My initial idea was to acknowledge the resolution change by G_FMT.
> >>> Later in our chat it had evolved into S_FMT. Then it mutated into
> >>> STREAMOFF/STREAMON on the CAPTURE queue.
> >>
> >> Why application should ack with it? If the application doesn't ack, it
> can
> >> just send
> >> a VIDIOC_STREAMOFF. If application doesn't do it, and the buffer size is
> >> enough to
> >> proceed, the hardware should just keep doing the DMA transfers and assume
> >> that the
> >> applications are OK.
> >>
> >>>> For things like MPEG decoders, Hans proposed an ioctl, that could use
> to
> >>>> pause
> >>>> and continue the decoding.
> >>>
> >>> This still could be useful... But processing will also pause when hw
> runs
> >> out
> >>> of buffers. It will be resumed after the application consumes/produces
> new
> >>> buffers and enqueue them.
> >>
> >> No. Capture devices will start loosing frames. For other types, it makes
> >> sense to
> >> implicitly pause/continue.
> >
> > I have meant memory-to-memory devices.
> 
> Ah, ok. The RFC should not be restricted to M2M devices, as a V4L2 decoder
> device
> may also detect format changes.

Initially it supposed to be restricted to M2M devices. I am afraid I have less
knowledge on purely CAPTURE/OUTPUT devices. I agree that these devices could 
also benefit from resolution change.

What would be the use cases when using OUTPUT devices for resolution change?

Because for CAPTURE I can imagine that a camera needs to reduce resolution
if the lighting conditions are poor. But what about OUTPUT devices, any suggestions?

> 
> > The will not do any processing if any of
> > these conditions is false:
> > - there is enough queued buffers on the CAPTURE queue
> > - there is enough queued buffers on the OUTPUT queue
> > - streaming is on the CAPTURE queue
> > - streaming is on the OUTPUT queue
> >
> > In case of purely CAPTURE device then, yes, it will start losing frames
> and
> > the idea of a pause ioctl is useful. On the other hand, a pause is not
> that
> > different from losing frames.
> >
> > I still think that for m2m devices a pause ioctl is not necessary. No
> buffers
> > to process means no processing is done.
> 
> If the input for such device is really coming from userspace, yes, you're
> right.
> But you should remind that the same device block could be connected into
> some
> capture device. In other words, the same IP block could be doing:
> 
> Output device ===> Mpeg decoder ===> Capture device
> 
> Digital TV ===> MPEG decoder ===> Capture device
> 
> At the first scenario, no real time is envolved. So, it can pause when
> something is
> not met, but, the same IP block should behave different, as pausing would
> cause
> data loss.

By the second scenario you mean a DVB card that acts as a Capture device, yes?

If it was "some MPEG compressed stream generating device" connected to the
Memory2memory codec device then I suppose it would be sufficient to pause the
"some MPEG compressed stream generating device" as the codec would not 
do any processing if there were no buffers to process.

Best wishes,
--
Kamil Debski
Linux Platform Group
Samsung Poland R&D Center

