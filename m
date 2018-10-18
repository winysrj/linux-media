Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:33162 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727470AbeJRTWg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 Oct 2018 15:22:36 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Tomasz Figa <tfiga@chromium.org>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Pawel Osciak <posciak@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>, kamil@wypas.org,
        a.hajda@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>,
        jtp.park@samsung.com, Philipp Zabel <p.zabel@pengutronix.de>,
        Tiffany Lin =?utf-8?B?KOael+aFp+ePiik=?=
        <tiffany.lin@mediatek.com>,
        Andrew-CT Chen =?utf-8?B?KOmZs+aZuui/qik=?=
        <andrew-ct.chen@mediatek.com>, todor.tomov@linaro.org,
        nicolas@ndufresne.ca,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        dave.stevenson@raspberrypi.org,
        Ezequiel Garcia <ezequiel@collabora.com>
Subject: Re: [PATCH 1/2] media: docs-rst: Document memory-to-memory video decoder interface
Date: Thu, 18 Oct 2018 14:22:08 +0300
Message-ID: <4766921.vZCsLckqXW@avalon>
In-Reply-To: <CAAFQd5Bb2v0iU6GAwOKtc-4kv1V+P_4Co7=OUYg77wfmKQQ=kA@mail.gmail.com>
References: <20180724140621.59624-1-tfiga@chromium.org> <9696282.0ldyWdpzWo@avalon> <CAAFQd5Bb2v0iU6GAwOKtc-4kv1V+P_4Co7=OUYg77wfmKQQ=kA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

I've stripped out all the parts on which I have no specific comment or just=
=20
agree with your proposal. Please see below for a few additional remarks.

On Thursday, 18 October 2018 13:03:33 EEST Tomasz Figa wrote:
> On Wed, Oct 17, 2018 at 10:34 PM Laurent Pinchart wrote:
> > On Tuesday, 24 July 2018 17:06:20 EEST Tomasz Figa wrote:
> >> Due to complexity of the video decoding process, the V4L2 drivers of
> >> stateful decoder hardware require specific sequences of V4L2 API calls
> >> to be followed. These include capability enumeration, initialization,
> >> decoding, seek, pause, dynamic resolution change, drain and end of
> >> stream.
> >>=20
> >> Specifics of the above have been discussed during Media Workshops at
> >> LinuxCon Europe 2012 in Barcelona and then later Embedded Linux
> >> Conference Europe 2014 in D=FCsseldorf. The de facto Codec API that
> >> originated at those events was later implemented by the drivers we
> >> already have merged in mainline, such as s5p-mfc or coda.
> >>=20
> >> The only thing missing was the real specification included as a part of
> >> Linux Media documentation. Fix it now and document the decoder part of
> >> the Codec API.
> >>=20
> >> Signed-off-by: Tomasz Figa <tfiga@chromium.org>
> >> ---
> >>=20
> >>  Documentation/media/uapi/v4l/dev-decoder.rst | 872 +++++++++++++++++++
> >>  Documentation/media/uapi/v4l/devices.rst     |   1 +
> >>  Documentation/media/uapi/v4l/v4l2.rst        |  10 +-
> >>  3 files changed, 882 insertions(+), 1 deletion(-)
> >>  create mode 100644 Documentation/media/uapi/v4l/dev-decoder.rst
> >>=20
> >> diff --git a/Documentation/media/uapi/v4l/dev-decoder.rst
> >> b/Documentation/media/uapi/v4l/dev-decoder.rst new file mode 100644
> >> index 000000000000..f55d34d2f860
> >> --- /dev/null
> >> +++ b/Documentation/media/uapi/v4l/dev-decoder.rst
> >> @@ -0,0 +1,872 @@

[snip]

> >> +4.  Allocate source (bitstream) buffers via :c:func:`VIDIOC_REQBUFS` =
on
> >> +    ``OUTPUT``.
> >> +
> >> +    * **Required fields:**
> >> +
> >> +      ``count``
> >> +          requested number of buffers to allocate; greater than zero
> >> +
> >> +      ``type``
> >> +          a ``V4L2_BUF_TYPE_*`` enum appropriate for ``OUTPUT``
> >> +
> >> +      ``memory``
> >> +          follows standard semantics
> >> +
> >> +      ``sizeimage``
> >> +          follows standard semantics; the client is free to choose any
> >> +          suitable size, however, it may be subject to change by the
> >> +          driver
> >> +
> >> +    * **Return fields:**
> >> +
> >> +      ``count``
> >> +          actual number of buffers allocated
> >> +
> >> +    * The driver must adjust count to minimum of required number of
> >> +      ``OUTPUT`` buffers for given format and count passed.
> >=20
> > Isn't it the maximum, not the minimum ?
>=20
> It's actually neither. All we can generally say here is that the
> number will be adjusted and the client must note it.

I expect it to be clamp(requested count, driver minimum, driver maximum). I=
'm=20
not sure it's worth capturing this in the document though, but we could say

"The driver must clam count to the minimum and maximum number of required=20
``OUTPUT`` buffers for the given format ."

> >> The client must
> >> +      check this value after the ioctl returns to get the number of
> >> +      buffers allocated.
> >> +
> >> +    .. note::
> >> +
> >> +       To allocate more than minimum number of buffers (for pipeline
> >> +       depth), use G_CTRL(``V4L2_CID_MIN_BUFFERS_FOR_OUTPUT``) to
> >> +       get minimum number of buffers required by the driver/format,
> >> +       and pass the obtained value plus the number of additional
> >> +       buffers needed in count to :c:func:`VIDIOC_REQBUFS`.
> >> +
> >> +5.  Start streaming on ``OUTPUT`` queue via :c:func:`VIDIOC_STREAMON`.
> >> +
> >> +6.  This step only applies to coded formats that contain resolution
> >> +    information in the stream. Continue queuing/dequeuing bitstream
> >> +    buffers to/from the ``OUTPUT`` queue via :c:func:`VIDIOC_QBUF` and
> >> +    :c:func:`VIDIOC_DQBUF`. The driver must keep processing and
> >> returning
> >> +    each buffer to the client until required metadata to configure the
> >> +    ``CAPTURE`` queue are found. This is indicated by the driver
> >> sending
> >> +    a ``V4L2_EVENT_SOURCE_CHANGE`` event with
> >> +    ``V4L2_EVENT_SRC_CH_RESOLUTION`` source change type. There is no
> >> +    requirement to pass enough data for this to occur in the first
> >> buffer
> >> +    and the driver must be able to process any number.
> >> +
> >> +    * If data in a buffer that triggers the event is required to deco=
de
> >> +      the first frame, the driver must not return it to the client,
> >> +      but must retain it for further decoding.
> >> +
> >> +    * If the client set width and height of ``OUTPUT`` format to 0,
> >> calling
> >> +      :c:func:`VIDIOC_G_FMT` on the ``CAPTURE`` queue will return
> >> -EPERM,
> >> +      until the driver configures ``CAPTURE`` format according to str=
eam
> >> +      metadata.
> >=20
> > That's a pretty harsh handling for this condition. What's the rationale
> > for returning -EPERM instead of for instance succeeding with width and
> > height set to 0 ?
>=20
> I don't like it, but the error condition must stay for compatibility
> reasons as that's what current drivers implement and applications
> expect. (Technically current drivers would return -EINVAL, but we
> concluded that existing applications don't care about the exact value,
> so we can change it to make more sense.)

=46air enough :-/ A bit of a shame though. Should we try to use an error co=
de=20
that would have less chance of being confused with an actual permission=20
problem ? -EILSEQ could be an option for "illegal sequence" of operations, =
but=20
better options could exist.

> >> +    * If the client subscribes to ``V4L2_EVENT_SOURCE_CHANGE`` events
> >> and
> >> +      the event is signaled, the decoding process will not continue
> >> until
> >> +      it is acknowledged by either (re-)starting streaming on
> >> ``CAPTURE``,
> >> +      or via :c:func:`VIDIOC_DECODER_CMD` with ``V4L2_DEC_CMD_START``
> >> +      command.
> >> +
> >> +    .. note::
> >> +
> >> +       No decoded frames are produced during this phase.
> >> +

[snip]

> >> +8.  Call :c:func:`VIDIOC_G_FMT` for ``CAPTURE`` queue to get format f=
or
> >> the +    destination buffers parsed/decoded from the bitstream.
> >> +
> >> +    * **Required fields:**
> >> +
> >> +      ``type``
> >> +          a ``V4L2_BUF_TYPE_*`` enum appropriate for ``CAPTURE``
> >> +
> >> +    * **Return fields:**
> >> +
> >> +      ``width``, ``height``
> >> +          frame buffer resolution for the decoded frames
> >> +
> >> +      ``pixelformat``
> >> +          pixel format for decoded frames
> >> +
> >> +      ``num_planes`` (for _MPLANE ``type`` only)
> >> +          number of planes for pixelformat
> >> +
> >> +      ``sizeimage``, ``bytesperline``
> >> +          as per standard semantics; matching frame buffer format
> >> +
> >> +    .. note::
> >> +
> >> +       The value of ``pixelformat`` may be any pixel format supported
> >> and
> >> +       must be supported for current stream, based on the information
> >> +       parsed from the stream and hardware capabilities. It is
> >> suggested
> >> +       that driver chooses the preferred/optimal format for given
> >=20
> > In compliance with RFC 2119, how about using "Drivers should choose"
> > instead of "It is suggested that driver chooses" ?
>=20
> The whole paragraph became:
>=20
>        The value of ``pixelformat`` may be any pixel format supported by =
the
> decoder for the current stream. It is expected that the decoder chooses a
> preferred/optimal format for the default configuration. For example, a YUV
> format may be preferred over an RGB format, if additional conversion step
> would be required.

How about using "should" instead of "it is expected that" ?

[snip]

> >> +10.  *[optional]* Choose a different ``CAPTURE`` format than suggested
> >> via
> >> +     :c:func:`VIDIOC_S_FMT` on ``CAPTURE`` queue. It is possible for
> >> the
> >> +     client to choose a different format than selected/suggested by t=
he
> >=20
> > And here, "A client may choose" ?
> >=20
> >> +     driver in :c:func:`VIDIOC_G_FMT`.
> >> +
> >> +     * **Required fields:**
> >> +
> >> +       ``type``
> >> +           a ``V4L2_BUF_TYPE_*`` enum appropriate for ``CAPTURE``
> >> +
> >> +       ``pixelformat``
> >> +           a raw pixel format
> >> +
> >> +     .. note::
> >> +
> >> +        Calling :c:func:`VIDIOC_ENUM_FMT` to discover currently
> >> available
> >> +        formats after receiving ``V4L2_EVENT_SOURCE_CHANGE`` is useful
> >> to
> >> +        find out a set of allowed formats for given configuration, but
> >> not
> >> +        required, if the client can accept the defaults.
> >=20
> > s/required/required,/
>=20
> That would become "[...]but not required,, if the client[...]". Is
> that your suggestion? ;)

Oops, the other way around of course :-)

[snip]

> >> +3. Start queuing buffers to ``OUTPUT`` queue containing stream data
> >> after
> >> +   the seek until a suitable resume point is found.
> >> +
> >> +   .. note::
> >> +
> >> +      There is no requirement to begin queuing stream starting exactly
> >> from
> >=20
> > s/stream/buffers/ ?
>=20
> Perhaps "stream data"? The buffers don't have a resume point, the stream
> does.

Maybe "coded data" ?

> >> +      a resume point (e.g. SPS or a keyframe). The driver must handle
> >> any
> >> +      data queued and must keep processing the queued buffers until it
> >> +      finds a suitable resume point. While looking for a resume point,
> >> the
> >> +      driver processes ``OUTPUT`` buffers and returns them to the
> >> client
> >> +      without producing any decoded frames.
> >> +
> >> +      For hardware known to be mishandling seeks to a non-resume poin=
t,
> >> +      e.g. by returning corrupted decoded frames, the driver must be
> >> able
> >> +      to handle such seeks without a crash or any fatal decode error.
> >=20
> > This should be true for any hardware, there should never be any crash or
> > fatal decode error. I'd write it as
> >=20
> > Some hardware is known to mishandle seeks to a non-resume point. Such an
> > operation may result in an unspecified number of corrupted decoded fram=
es
> > being made available on ``CAPTURE``. Drivers must ensure that no fatal
> > decoding errors or crashes occur, and implement any necessary handling =
and
> > work-arounds for hardware issues related to seek operations.
>=20
> Done.

[snip]

> >> +2.  After all buffers containing decoded frames from before the
> >> resolution
> >> +    change point are ready to be dequeued on the ``CAPTURE`` queue, t=
he
> >> +    driver sends a ``V4L2_EVENT_SOURCE_CHANGE`` event for source chan=
ge
> >> +    type ``V4L2_EVENT_SRC_CH_RESOLUTION``.
> >> +
> >> +    * The last buffer from before the change must be marked with
> >> +      :c:type:`v4l2_buffer` ``flags`` flag ``V4L2_BUF_FLAG_LAST`` as =
in
> >> the +      drain sequence. The last buffer might be empty (with
> >> +      :c:type:`v4l2_buffer` ``bytesused`` =3D 0) and must be ignored =
by
> >> the
> >> +      client, since it does not contain any decoded frame.
> >> +
> >> +    * Any client query issued after the driver queues the event must
> >> return
> >> +      values applying to the stream after the resolution change,
> >> including
> >> +      queue formats, selection rectangles and controls.
> >> +
> >> +    * If the client subscribes to ``V4L2_EVENT_SOURCE_CHANGE`` events
> >> and
> >> +      the event is signaled, the decoding process will not continue
> >> until
> >> +      it is acknowledged by either (re-)starting streaming on
> >> ``CAPTURE``,
> >> +      or via :c:func:`VIDIOC_DECODER_CMD` with ``V4L2_DEC_CMD_START``
> >> +      command.
> >=20
> > This usage of V4L2_DEC_CMD_START isn't aligned with the documentation of
> > the command. I'm not opposed to this, but I think the use cases of
> > decoder commands for codecs should be explained in the VIDIOC_DECODER_C=
MD
> > documentation. What bothers me in particular is usage of
> > V4L2_DEC_CMD_START to restart the decoder, while no V4L2_DEC_CMD_STOP h=
as
> > been issued. Should we add a section that details the decoder state
> > machine with the implicit and explicit ways in which it is started and
> > stopped ?
>=20
> Yes, we should probably extend the VIDIOC_DECODER_CMD documentation.
>=20
> As for diagrams, they would indeed be nice to have, but maybe we could
> add them in a follow up patch?

That's another way to say it won't happen, right ? ;-) I'm OK with that, bu=
t I=20
think we should still clarify that the source change generates an implicit=
=20
V4L2_DEC_CMD_STOP.

> > I would also reference step 7 here.
> >=20
> >> +    .. note::
> >> +
> >> +       Any attempts to dequeue more buffers beyond the buffer marked
> >> +       with ``V4L2_BUF_FLAG_LAST`` will result in a -EPIPE error from
> >> +       :c:func:`VIDIOC_DQBUF`.
> >> +
> >> +3.  The client calls :c:func:`VIDIOC_G_FMT` for ``CAPTURE`` to get the
> >> new
> >> +    format information. This is identical to calling
> >> :c:func:`VIDIOC_G_FMT` +    after ``V4L2_EVENT_SRC_CH_RESOLUTION`` in
> >> the initialization sequence +    and should be handled similarly.
> >=20
> > As the source resolution change event is mentioned in multiple places, =
how
> > about extracting the related ioctls sequence to a specific section, and
> > referencing it where needed (at least from the initialization sequence =
and
> > here) ?
>=20
> I made the text here refer to the Initialization sequence.

Wouldn't it be clearer if those steps were extracted to a standalone sequen=
ce=20
referenced from both locations ?

> >> +    .. note::
> >> +
> >> +       It is allowed for the driver not to support the same pixel
> >> format as
> >=20
> > "Drivers may not support ..."
> >=20
> >> +       previously used (before the resolution change) for the new
> >> +       resolution. The driver must select a default supported pixel
> >> format,
> >> +       return it, if queried using :c:func:`VIDIOC_G_FMT`, and the
> >> client
> >> +       must take note of it.
> >> +
> >> +4.  The client acquires visible resolution as in initialization
> >> sequence.
> >> +
> >> +5.  *[optional]* The client is allowed to enumerate available formats
> >> and
> >=20
> > s/is allowed to/may/
> >=20
> >> +    select a different one than currently chosen (returned via
> >> +    :c:func:`VIDIOC_G_FMT)`. This is identical to a corresponding step
> >> in
> >> +    the initialization sequence.
> >> +
> >> +6.  *[optional]* The client acquires minimum number of buffers as in
> >> +    initialization sequence.
> >> +
> >> +7.  If all the following conditions are met, the client may resume the
> >> +    decoding instantly, by using :c:func:`VIDIOC_DECODER_CMD` with
> >> +    ``V4L2_DEC_CMD_START`` command, as in case of resuming after the
> >> drain
> >> +    sequence:
> >> +
> >> +    * ``sizeimage`` of new format is less than or equal to the size of
> >> +      currently allocated buffers,
> >> +
> >> +    * the number of buffers currently allocated is greater than or
> >> equal to
> >> +      the minimum number of buffers acquired in step 6.
> >> +
> >> +    In such case, the remaining steps do not apply.
> >> +
> >> +    However, if the client intends to change the buffer set, to lower
> >> +    memory usage or for any other reasons, it may be achieved by
> >> following
> >> +    the steps below.
> >> +
> >> +8.  After dequeuing all remaining buffers from the ``CAPTURE`` queue,
> >=20
> > This is optional, isn't it ?
>=20
> I wouldn't call it optional, since it depends on what the client does
> and what the decoder supports. That's why the point above just states
> that the remaining steps do not apply.

I meant isn't the "After dequeuing all remaining buffers from the CAPTURE=20
queue" part optional ? As far as I understand, the client may decide not to=
=20
dequeue them.

> Also added a note:
>=20
>        To fulfill those requirements, the client may attempt to use
>        :c:func:`VIDIOC_CREATE_BUFS` to add more buffers. However, due to
>        hardware limitations, the decoder may not support adding buffers at
>        this point and the client must be able to handle a failure using t=
he
>        steps below.

I wonder if there could be a way to work around those limitations on the=20
driver side. At the beginning of step 7, the decoder is effectively stopped=
=2E=20
If the hardware doesn't support adding new buffers on the fly, can't the=20
driver support the VIDIOC_CREATE_BUFS + V4L2_DEC_CMD_START sequence the sam=
e=20
way it would support the VIDIOC_STREAMOFF + VIDIOC_REQBUFS(0) +=20
VIDIOC_REQBUFS(n) + VIDIOC_STREAMON ?

> >> the
> >> +    client must call :c:func:`VIDIOC_STREAMOFF` on the ``CAPTURE``
> >> queue.
> >> +    The ``OUTPUT`` queue must remain streaming (calling STREAMOFF on =
it
> >
> > :c:func:`VIDIOC_STREAMOFF`
> >
> >> +    would trigger a seek).

[snip]

=2D-=20
Regards,

Laurent Pinchart
