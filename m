Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([85.220.165.71]:45825 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932428AbeFFKpD (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 6 Jun 2018 06:45:03 -0400
Message-ID: <1528281896.3438.6.camel@pengutronix.de>
Subject: Re: [RFC PATCH 1/2] media: docs-rst: Add decoder UAPI specification
 to Codec Interfaces
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Tomasz Figa <tfiga@chromium.org>,
        Pawel Osciak <posciak@chromium.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Alexandre Courbot <acourbot@chromium.org>, kamil@wypas.org,
        a.hajda@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>,
        jtp.park@samsung.com,
        Tiffany Lin =?UTF-8?Q?=28=E6=9E=97=E6=85=A7=E7=8F=8A=29?=
        <tiffany.lin@mediatek.com>,
        Andrew-CT Chen =?UTF-8?Q?=28=E9=99=B3=E6=99=BA=E8=BF=AA=29?=
        <andrew-ct.chen@mediatek.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        todor.tomov@linaro.org, nicolas@ndufresne.ca,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Date: Wed, 06 Jun 2018 12:44:56 +0200
In-Reply-To: <CAAFQd5BKdqPWVREeuprWS43kPz7XZR5buiPUZY5UKhaaQCMOBg@mail.gmail.com>
References: <20180605103328.176255-1-tfiga@chromium.org>
         <20180605103328.176255-2-tfiga@chromium.org>
         <1528198888.4074.13.camel@pengutronix.de>
         <CAAFQd5BKdqPWVREeuprWS43kPz7XZR5buiPUZY5UKhaaQCMOBg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2018-06-05 at 22:42 +0900, Tomasz Figa wrote:
[...]
> > > +   a. Values returned from :c:func:`VIDIOC_ENUM_FRAMESIZES` for coded formats
> > > +      must be maximums for given coded format for all supported raw
> > > +      formats.
> > 
> > I don't understand what maximums means in this context.
> > 
> > If I have a decoder that can decode from 16x16 up to 1920x1088, should
> > this return a continuous range from minimum frame size to maximum frame
> > size?
> 
> Looks like the wording here is a bit off. It should be as you say +/-
> alignment requirements, which can be specified by using
> v4l2_frmsize_stepwise. Hardware that supports only a fixed set of
> resolutions (if such exists), should use v4l2_frmsize_discrete.
> Basically this should follow the standard description of
> VIDIOC_ENUM_FRAMESIZES.

Should this contain coded sizes or visible sizes?

> > 
> > > +   b. Values returned from :c:func:`VIDIOC_ENUM_FRAMESIZES` for raw formats must
> > > +      be maximums for given raw format for all supported coded
> > > +      formats.
> > 
> > Same here, this is unclear to me.
> 
> Should be as above, i.e. according to standard operation of
> VIDIOC_ENUM_FRAMESIZES.

How about just:

   a. Values returned from :c:func:`VIDIOC_ENUM_FRAMESIZES` for coded formats
      must contain all possible (coded?) frame sizes for the given coded format
      for all supported raw formats.

   b. Values returned from :c:func:`VIDIOC_ENUM_FRAMESIZES` for raw formats
      must contain all possible coded frame sizes for the given raw format
      for all supported encoded formats.

And then a note somewhere that explains that coded frame sizes are
usually visible frame size rounded up to macro block size, possibly a
link to the coded resolution glossary.

[...]
> Actually, when I think of it now, I wonder if we really should be
> setting resolution here for bitstream formats that don't include
> resolution, rather than on CAPTURE queue. Pawel, could you clarify
> what was the intention here?

Setting the resolution here makes it possible to start streaming,
allocate buffers on both queues etc. without relying on the hardware to
actually parse the headers. If we are given the right information, the
first source change event will just confirm the currently set
resolution.

[...]
> > What about devices that have a frame buffer registration step before
> > stream start? For coda I need to know all CAPTURE buffers before I can
> > start streaming, because there is no way to register them after
> > STREAMON. Do I have to split the driver internally to do streamoff and
> > restart when the capture queue is brought up?
> 
> Do you mean that the hardware requires registering framebuffers before
> the headers are parsed and resolution is detected? That sounds quite
> unusual.

I meant that, but I was mistaken. For coda that is just how the driver
currently works, but it is not required by the hardware.

> Other drivers would:
> 1) parse the header on STREAMON(OUTPUT),

coda has a SEQ_INIT command, which parses the headers, and a
SET_FRAME_BUF command that registers allocated (internal) buffers.
Both are currently done during streamon, but it should be possible to
split this up. SET_FRAME_BUF can be only issued once between SEQ_INIT
and SEQ_END, but it is a separate command.

> 2) report resolution to userspace,
> 3) have framebuffers allocated in REQBUFS(CAPTURE),
> 4) register framebuffers in STREAMON(CAPTURE).

coda has a peculiarity in that the registered frame buffers are internal
only, and another part of the codec (copy/rotator) or another part of
the SoC (VDOA) copies those frames into the CAPTURE buffers that don't
have to be registered at all in advance in a separate step. But it
should still be possible to do the internal buffer allocation and
registration in the right places.

[...]
> Should be the same. There was "+5. Single-plane API (see spec) and
> applicable structures may be used interchangeably with Multi-plane
> API, unless specified otherwise." mentioned at the beginning of the
> documentation, but I guess we could just make the description generic
> instead.

Yes, please. Especially when using this as a reference during driver
development, it would be very helpful to have all relevant information
in place or at least referenced, instead of having to read and memorize
the whole document linearly.

[...]
> > Isn't CROP supposed to be set on the OUTPUT queue only and COMPOSE on
> > the CAPTURE queue?
> 
> Why? Both CROP and COMPOSE can be used on any queue, if supported by
> given interface.
> 
> However, on codecs, since OUTPUT queue is a bitstream, I don't think
> selection makes sense there.
>
> > I would expect COMPOSE/COMPOSE_DEFAULT to be set to the visible
> > rectangle and COMPOSE_PADDED to be set to the rectangle that the
> > hardware actually overwrites.
> 
> Yes, that's a good point. I'd also say that CROP/CROP_DEFAULT should
> be set to the visible rectangle as well, to allow adding handling for
> cases when the hardware can actually do further cropping.

Should CROP_BOUNDS be set to visible rectangle or to the coded
rectangle? This is related the question to whether coded G/S_FMT should
handle coded sizes or visible sizes.

For video capture devices, the cropping bounds should represent those
pixels that can be sampled. If we can 'sample' the coded pixels beyond
the visible rectangle, should decoders behave the same?

I think Documentation/media/uapi/v4l/selection-api-004.rst is missing a
section about mem2mem devices and/or codecs to clarify this.

> > > +12. (optional) Get minimum number of buffers required for CAPTURE queue
> > > +    via :c:func:`VIDIOC_G_CTRL`. This is useful if client intends to use
> > > +    more buffers than minimum required by hardware/format (see
> > > +    allocation).
> > > +
> > > +    a. Required fields:
> > > +
> > > +       i. id = ``V4L2_CID_MIN_BUFFERS_FOR_CAPTURE``
> > > +
> > > +    b. Return values: per spec.
> > > +
> > > +    c. Return fields:
> > > +
> > > +       i. value: minimum number of buffers required to decode the stream
> > > +          parsed in this initialization sequence.
> > > +
> > > +    .. note::
> > > +
> > > +       Note that the minimum number of buffers must be at least the
> > > +       number required to successfully decode the current stream.
> > > +       This may for example be the required DPB size for an H.264
> > > +       stream given the parsed stream configuration (resolution,
> > > +       level).
> > > +
> > > +13. Allocate destination (raw format) buffers via :c:func:`VIDIOC_REQBUFS` on the
> > > +    CAPTURE queue.
> > > +
> > > +    a. Required fields:
> > > +
> > > +       i.   count = n, where n > 0.
> > > +
> > > +       ii.  type = CAPTURE
> > > +
> > > +       iii. memory = as per spec
> > > +
> > > +    b. Return values: Per spec.
> > > +
> > > +    c. Return fields:
> > > +
> > > +       i. count: adjusted to allocated number of buffers.
> > > +
> > > +    d. The driver must adjust count to minimum of required number of
> > > +       destination buffers for given format and stream configuration
> > > +       and the count passed. The client must check this value after
> > > +       the ioctl returns to get the number of buffers allocated.
> > > +
> > > +    .. note::
> > > +
> > > +       Passing count = 1 is useful for letting the driver choose
> > > +       the minimum.
> > > +
> > > +    .. note::
> > > +
> > > +       To allocate more than minimum number of buffers (for pipeline
> > > +       depth), use G_CTRL(``V4L2_CID_MIN_BUFFERS_FOR_CAPTURE)`` to
> > > +       get minimum number of buffers required, and pass the obtained
> > > +       value plus the number of additional buffers needed in count
> > > +       to :c:func:`VIDIOC_REQBUFS`.
> > > +
> > > +14. Call :c:func:`VIDIOC_STREAMON` to initiate decoding frames.
> > > +
> > > +    a. Required fields: as per spec.
> > > +
> > > +    b. Return values: as per spec.
> > > +
> > > +Decoding
> > > +--------
> > > +
> > > +This state is reached after a successful initialization sequence. In
> > > +this state, client queues and dequeues buffers to both queues via
> > > +:c:func:`VIDIOC_QBUF` and :c:func:`VIDIOC_DQBUF`, as per spec.
> > > +
> > > +Both queues operate independently. The client may queue and dequeue
> > > +buffers to queues in any order and at any rate, also at a rate different
> > > +for each queue. The client may queue buffers within the same queue in
> > > +any order (V4L2 index-wise). It is recommended for the client to operate
> > > +the queues independently for best performance.
> > > +
> > > +Source OUTPUT buffers must contain:
> > > +
> > > +-  H.264/AVC: one or more complete NALUs of an Annex B elementary
> > > +   stream; one buffer does not have to contain enough data to decode
> > > +   a frame;
> > 
> > What if the hardware only supports handling complete frames?
> 
> Pawel, could you help with this?
> 
> > 
> > > +-  VP8/VP9: one or more complete frames.
> > > +
> > > +No direct relationship between source and destination buffers and the
> > > +timing of buffers becoming available to dequeue should be assumed in the
> > > +Stream API. Specifically:
> > > +
> > > +-  a buffer queued to OUTPUT queue may result in no buffers being
> > > +   produced on the CAPTURE queue (e.g. if it does not contain
> > > +   encoded data, or if only metadata syntax structures are present
> > > +   in it), or one or more buffers produced on the CAPTURE queue (if
> > > +   the encoded data contained more than one frame, or if returning a
> > > +   decoded frame allowed the driver to return a frame that preceded
> > > +   it in decode, but succeeded it in display order)
> > > +
> > > +-  a buffer queued to OUTPUT may result in a buffer being produced on
> > > +   the CAPTURE queue later into decode process, and/or after
> > > +   processing further OUTPUT buffers, or be returned out of order,
> > > +   e.g. if display reordering is used
> > > +
> > > +-  buffers may become available on the CAPTURE queue without additional
> > > +   buffers queued to OUTPUT (e.g. during flush or EOS)
> > > +
> > > +Seek
> > > +----
> > > +
> > > +Seek is controlled by the OUTPUT queue, as it is the source of bitstream
> > > +data. CAPTURE queue remains unchanged/unaffected.
> > 
> > Does this mean that to achieve instantaneous seeks the driver has to
> > flush its CAPTURE queue internally when a seek is issued?
> 
> That's a good point. I'd say that we might actually want the userspace
> to restart the capture queue in such case. Pawel, do you have any
> opinion on this?
> 
> > 
> > > +
> > > +1. Stop the OUTPUT queue to begin the seek sequence via
> > > +   :c:func:`VIDIOC_STREAMOFF`.
> > > +
> > > +   a. Required fields:
> > > +
> > > +      i. type = OUTPUT
> > > +
> > > +   b. The driver must drop all the pending OUTPUT buffers and they are
> > > +      treated as returned to the client (as per spec).
> > 
> > What about pending CAPTURE buffers that the client may not yet have
> > dequeued?
> 
> Just as written here: nothing happens to them, since the "CAPTURE
> queue remains unchanged/unaffected". :)
> 
> > 
> > > +
> > > +2. Restart the OUTPUT queue via :c:func:`VIDIOC_STREAMON`
> > > +
> > > +   a. Required fields:
> > > +
> > > +      i. type = OUTPUT
> > > +
> > > +   b. The driver must be put in a state after seek and be ready to
> > > +      accept new source bitstream buffers.
> > > +
> > > +3. Start queuing buffers to OUTPUT queue containing stream data after
> > > +   the seek until a suitable resume point is found.
> > > +
> > > +   .. note::
> > > +
> > > +      There is no requirement to begin queuing stream
> > > +      starting exactly from a resume point (e.g. SPS or a keyframe).
> > > +      The driver must handle any data queued and must keep processing
> > > +      the queued buffers until it finds a suitable resume point.
> > > +      While looking for a resume point, the driver processes OUTPUT
> > > +      buffers and returns them to the client without producing any
> > > +      decoded frames.
> > > +
> > > +4. After a resume point is found, the driver will start returning
> > > +   CAPTURE buffers with decoded frames.
> > > +
> > > +   .. note::
> > > +
> > > +      There is no precise specification for CAPTURE queue of when it
> > > +      will start producing buffers containing decoded data from
> > > +      buffers queued after the seek, as it operates independently
> > > +      from OUTPUT queue.
> > > +
> > > +      -  The driver is allowed to and may return a number of remaining CAPTURE
> > > +         buffers containing decoded frames from before the seek after the
> > > +         seek sequence (STREAMOFF-STREAMON) is performed.
> > 
> > Oh, ok. That answers my last question above.
> > 
> > > +      -  The driver is also allowed to and may not return all decoded frames
> > > +         queued but not decode before the seek sequence was initiated.
> > > +         E.g. for an OUTPUT queue sequence: QBUF(A), QBUF(B),
> > > +         STREAMOFF(OUT), STREAMON(OUT), QBUF(G), QBUF(H), any of the
> > > +         following results on the CAPTURE queue is allowed: {A’, B’, G’,
> > > +         H’}, {A’, G’, H’}, {G’, H’}.
> > > +
> > > +Pause
> > > +-----
> > > +
> > > +In order to pause, the client should just cease queuing buffers onto the
> > > +OUTPUT queue. This is different from the general V4L2 API definition of
> > > +pause, which involves calling :c:func:`VIDIOC_STREAMOFF` on the queue. Without
> > > +source bitstream data, there is not data to process and the hardware
> > > +remains idle. Conversely, using :c:func:`VIDIOC_STREAMOFF` on OUTPUT queue
> > > +indicates a seek, which 1) drops all buffers in flight and 2) after a
> > 
> > "... 1) drops all OUTPUT buffers in flight ... " ?
> 
> Yeah, although it's kind of inferred from the standard behavior of
> VIDIOC_STREAMOFF on given queue.
> 
> > 
> > > +subsequent :c:func:`VIDIOC_STREAMON` will look for and only continue from a
> > > +resume point. This is usually undesirable for pause. The
> > > +STREAMOFF-STREAMON sequence is intended for seeking.
> > > +
> > > +Similarly, CAPTURE queue should remain streaming as well, as the
> > > +STREAMOFF-STREAMON sequence on it is intended solely for changing buffer
> > > +sets
> > > +
> > > +Dynamic resolution change
> > > +-------------------------
> > > +
> > > +When driver encounters a resolution change in the stream, the dynamic
> > > +resolution change sequence is started.
> > 
> > Must all drivers support dynamic resolution change?
> 
> I'd say no, but I guess that would mean that the driver never
> encounters it, because hardware wouldn't report it.
> 
> I wonder would happen in such case, though. Obviously decoding of such
> stream couldn't continue without support in the driver.

GStreamer supports decoding of variable resolution streams without
driver support by just stopping and restarting streaming completely.

> > 
> > > +1.  On encountering a resolution change in the stream. The driver must
> > > +    first process and decode all remaining buffers from before the
> > > +    resolution change point.
> > > +
> > > +2.  After all buffers containing decoded frames from before the
> > > +    resolution change point are ready to be dequeued on the
> > > +    CAPTURE queue, the driver sends a ``V4L2_EVENT_SOURCE_CHANGE``
> > > +    event for source change type ``V4L2_EVENT_SRC_CH_RESOLUTION``.
> > > +    The last buffer from before the change must be marked with
> > > +    :c:type:`v4l2_buffer` ``flags`` flag ``V4L2_BUF_FLAG_LAST`` as in the flush
> > > +    sequence.
> > > +
> > > +    .. note::
> > > +
> > > +       Any attempts to dequeue more buffers beyond the buffer marked
> > > +       with ``V4L2_BUF_FLAG_LAST`` will result in a -EPIPE error from
> > > +       :c:func:`VIDIOC_DQBUF`.
> > > +
> > > +3.  After dequeuing all remaining buffers from the CAPTURE queue, the
> > > +    client must call :c:func:`VIDIOC_STREAMOFF` on the CAPTURE queue. The
> > > +    OUTPUT queue remains streaming (calling STREAMOFF on it would
> > > +    trigger a seek).
> > > +    Until STREAMOFF is called on the CAPTURE queue (acknowledging
> > > +    the event), the driver operates as if the resolution hasn’t
> > > +    changed yet, i.e. :c:func:`VIDIOC_G_FMT`, etc. return previous
> > > +    resolution.
> > 
> > What about the OUTPUT queue resolution, does it change as well?
> 
> There shouldn't be resolution associated with OUTPUT queue, because
> pixel format is bitstream, not raw frame.

So the width and height field may just contain bogus values for coded
formats?

[...]
> > Ok. Is the same true about the contained colorimetry? What should happen
> > if the stream contains colorimetry information that differs from
> > S_FMT(OUT) colorimetry?
> 
> As I explained close to the top, IMHO we shouldn't be setting
> colorimetry on OUTPUT queue.

Does that mean that if userspace sets those fields though, we correct to
V4L2_COLORSPACE_DEFAULT and friends? Or just accept anything and ignore
it?

> > > +2. Enumerating formats on CAPTURE queue must only return CAPTURE formats
> > > +   supported for the OUTPUT format currently set.
> > > +
> > > +3. Setting/changing format on CAPTURE queue does not change formats
> > > +   available on OUTPUT queue. An attempt to set CAPTURE format that
> > > +   is not supported for the currently selected OUTPUT format must
> > > +   result in an error (-EINVAL) from :c:func:`VIDIOC_S_FMT`.
> > 
> > Is this limited to the pixel format? Surely setting out of bounds
> > width/height or incorrect colorimetry should not result in EINVAL but
> > still be corrected by the driver?
> 
> That doesn't sound right to me indeed. The driver should fix up
> S_FMT(CAPTURE), including pixel format or anything else. It must only
> not alter OUTPUT settings.

That's what I would have expected as well.

> > 
> > > +4. Enumerating formats on OUTPUT queue always returns a full set of
> > > +   supported formats, irrespective of the current format selected on
> > > +   CAPTURE queue.
> > > +
> > > +5. After allocating buffers on the OUTPUT queue, it is not possible to
> > > +   change format on it.
> > 
> > So even after source change events the OUTPUT queue still keeps the
> > initial OUTPUT format?
> 
> It would basically only have pixelformat (fourcc) assigned to it,
> since bitstream formats are not video frames, but just sequences of
> bytes. I don't think it makes sense to change e.g. from H264 to VP8
> during streaming.

What should the width and height format fields be set to then? Is there
a precedent for this? Capture devices that produce compressed output
usually set width and height to the visible resolution.

regards
Philipp
