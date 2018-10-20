Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb1-f196.google.com ([209.85.219.196]:34012 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727270AbeJTRCz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 20 Oct 2018 13:02:55 -0400
Received: by mail-yb1-f196.google.com with SMTP id 184-v6so14219329ybg.1
        for <linux-media@vger.kernel.org>; Sat, 20 Oct 2018 01:53:13 -0700 (PDT)
Received: from mail-yw1-f43.google.com (mail-yw1-f43.google.com. [209.85.161.43])
        by smtp.gmail.com with ESMTPSA id q189-v6sm6276421ywd.78.2018.10.20.01.53.10
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 20 Oct 2018 01:53:11 -0700 (PDT)
Received: by mail-yw1-f43.google.com with SMTP id j75-v6so14115383ywj.10
        for <linux-media@vger.kernel.org>; Sat, 20 Oct 2018 01:53:10 -0700 (PDT)
MIME-Version: 1.0
References: <20180724140621.59624-1-tfiga@chromium.org> <9696282.0ldyWdpzWo@avalon>
 <CAAFQd5Bb2v0iU6GAwOKtc-4kv1V+P_4Co7=OUYg77wfmKQQ=kA@mail.gmail.com> <4766921.vZCsLckqXW@avalon>
In-Reply-To: <4766921.vZCsLckqXW@avalon>
From: Tomasz Figa <tfiga@chromium.org>
Date: Sat, 20 Oct 2018 17:52:57 +0900
Message-ID: <CAAFQd5BnfZdbBpDq5qGwLQrWOzae-kd57JTv1ieokCs8H5K1MQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] media: docs-rst: Document memory-to-memory video
 decoder interface
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Pawel Osciak <posciak@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>, kamil@wypas.org,
        a.hajda@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>,
        jtp.park@samsung.com, Philipp Zabel <p.zabel@pengutronix.de>,
        =?UTF-8?B?VGlmZmFueSBMaW4gKOael+aFp+ePiik=?=
        <tiffany.lin@mediatek.com>,
        =?UTF-8?B?QW5kcmV3LUNUIENoZW4gKOmZs+aZuui/qik=?=
        <andrew-ct.chen@mediatek.com>, todor.tomov@linaro.org,
        nicolas@ndufresne.ca,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        dave.stevenson@raspberrypi.org,
        Ezequiel Garcia <ezequiel@collabora.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Oct 18, 2018 at 8:22 PM Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
>
> Hi Tomasz,
>
> I've stripped out all the parts on which I have no specific comment or ju=
st
> agree with your proposal. Please see below for a few additional remarks.
>
> On Thursday, 18 October 2018 13:03:33 EEST Tomasz Figa wrote:
> > On Wed, Oct 17, 2018 at 10:34 PM Laurent Pinchart wrote:
> > > On Tuesday, 24 July 2018 17:06:20 EEST Tomasz Figa wrote:
> > >> Due to complexity of the video decoding process, the V4L2 drivers of
> > >> stateful decoder hardware require specific sequences of V4L2 API cal=
ls
> > >> to be followed. These include capability enumeration, initialization=
,
> > >> decoding, seek, pause, dynamic resolution change, drain and end of
> > >> stream.
> > >>
> > >> Specifics of the above have been discussed during Media Workshops at
> > >> LinuxCon Europe 2012 in Barcelona and then later Embedded Linux
> > >> Conference Europe 2014 in D=C3=BCsseldorf. The de facto Codec API th=
at
> > >> originated at those events was later implemented by the drivers we
> > >> already have merged in mainline, such as s5p-mfc or coda.
> > >>
> > >> The only thing missing was the real specification included as a part=
 of
> > >> Linux Media documentation. Fix it now and document the decoder part =
of
> > >> the Codec API.
> > >>
> > >> Signed-off-by: Tomasz Figa <tfiga@chromium.org>
> > >> ---
> > >>
> > >>  Documentation/media/uapi/v4l/dev-decoder.rst | 872 ++++++++++++++++=
+++
> > >>  Documentation/media/uapi/v4l/devices.rst     |   1 +
> > >>  Documentation/media/uapi/v4l/v4l2.rst        |  10 +-
> > >>  3 files changed, 882 insertions(+), 1 deletion(-)
> > >>  create mode 100644 Documentation/media/uapi/v4l/dev-decoder.rst
> > >>
> > >> diff --git a/Documentation/media/uapi/v4l/dev-decoder.rst
> > >> b/Documentation/media/uapi/v4l/dev-decoder.rst new file mode 100644
> > >> index 000000000000..f55d34d2f860
> > >> --- /dev/null
> > >> +++ b/Documentation/media/uapi/v4l/dev-decoder.rst
> > >> @@ -0,0 +1,872 @@
>
> [snip]
>
> > >> +4.  Allocate source (bitstream) buffers via :c:func:`VIDIOC_REQBUFS=
` on
> > >> +    ``OUTPUT``.
> > >> +
> > >> +    * **Required fields:**
> > >> +
> > >> +      ``count``
> > >> +          requested number of buffers to allocate; greater than zer=
o
> > >> +
> > >> +      ``type``
> > >> +          a ``V4L2_BUF_TYPE_*`` enum appropriate for ``OUTPUT``
> > >> +
> > >> +      ``memory``
> > >> +          follows standard semantics
> > >> +
> > >> +      ``sizeimage``
> > >> +          follows standard semantics; the client is free to choose =
any
> > >> +          suitable size, however, it may be subject to change by th=
e
> > >> +          driver
> > >> +
> > >> +    * **Return fields:**
> > >> +
> > >> +      ``count``
> > >> +          actual number of buffers allocated
> > >> +
> > >> +    * The driver must adjust count to minimum of required number of
> > >> +      ``OUTPUT`` buffers for given format and count passed.
> > >
> > > Isn't it the maximum, not the minimum ?
> >
> > It's actually neither. All we can generally say here is that the
> > number will be adjusted and the client must note it.
>
> I expect it to be clamp(requested count, driver minimum, driver maximum).=
 I'm
> not sure it's worth capturing this in the document though, but we could s=
ay
>
> "The driver must clam count to the minimum and maximum number of required
> ``OUTPUT`` buffers for the given format ."
>

I'd leave the details to the documentation of VIDIOC_REQBUFS, if
needed. This document focuses on the decoder UAPI and with this note I
want to ensure that the applications don't assume that exactly the
requested number of buffers is always allocated.

How about making it even simpler:

The actual number of allocated buffers may differ from the ``count``
given. The client must check the updated value of ``count`` after the
call returns.

> > >> The client must
> > >> +      check this value after the ioctl returns to get the number of
> > >> +      buffers allocated.
> > >> +
> > >> +    .. note::
> > >> +
> > >> +       To allocate more than minimum number of buffers (for pipelin=
e
> > >> +       depth), use G_CTRL(``V4L2_CID_MIN_BUFFERS_FOR_OUTPUT``) to
> > >> +       get minimum number of buffers required by the driver/format,
> > >> +       and pass the obtained value plus the number of additional
> > >> +       buffers needed in count to :c:func:`VIDIOC_REQBUFS`.
> > >> +
> > >> +5.  Start streaming on ``OUTPUT`` queue via :c:func:`VIDIOC_STREAMO=
N`.
> > >> +
> > >> +6.  This step only applies to coded formats that contain resolution
> > >> +    information in the stream. Continue queuing/dequeuing bitstream
> > >> +    buffers to/from the ``OUTPUT`` queue via :c:func:`VIDIOC_QBUF` =
and
> > >> +    :c:func:`VIDIOC_DQBUF`. The driver must keep processing and
> > >> returning
> > >> +    each buffer to the client until required metadata to configure =
the
> > >> +    ``CAPTURE`` queue are found. This is indicated by the driver
> > >> sending
> > >> +    a ``V4L2_EVENT_SOURCE_CHANGE`` event with
> > >> +    ``V4L2_EVENT_SRC_CH_RESOLUTION`` source change type. There is n=
o
> > >> +    requirement to pass enough data for this to occur in the first
> > >> buffer
> > >> +    and the driver must be able to process any number.
> > >> +
> > >> +    * If data in a buffer that triggers the event is required to de=
code
> > >> +      the first frame, the driver must not return it to the client,
> > >> +      but must retain it for further decoding.
> > >> +
> > >> +    * If the client set width and height of ``OUTPUT`` format to 0,
> > >> calling
> > >> +      :c:func:`VIDIOC_G_FMT` on the ``CAPTURE`` queue will return
> > >> -EPERM,
> > >> +      until the driver configures ``CAPTURE`` format according to s=
tream
> > >> +      metadata.
> > >
> > > That's a pretty harsh handling for this condition. What's the rationa=
le
> > > for returning -EPERM instead of for instance succeeding with width an=
d
> > > height set to 0 ?
> >
> > I don't like it, but the error condition must stay for compatibility
> > reasons as that's what current drivers implement and applications
> > expect. (Technically current drivers would return -EINVAL, but we
> > concluded that existing applications don't care about the exact value,
> > so we can change it to make more sense.)
>
> Fair enough :-/ A bit of a shame though. Should we try to use an error co=
de
> that would have less chance of being confused with an actual permission
> problem ? -EILSEQ could be an option for "illegal sequence" of operations=
, but
> better options could exist.
>

In Request API we concluded that -EACCES is the right code to return
for G_EXT_CTRLS on a request that has not finished yet. The case here
is similar - the capture queue is not yet set up. What do you think?

> > >> +    * If the client subscribes to ``V4L2_EVENT_SOURCE_CHANGE`` even=
ts
> > >> and
> > >> +      the event is signaled, the decoding process will not continue
> > >> until
> > >> +      it is acknowledged by either (re-)starting streaming on
> > >> ``CAPTURE``,
> > >> +      or via :c:func:`VIDIOC_DECODER_CMD` with ``V4L2_DEC_CMD_START=
``
> > >> +      command.
> > >> +
> > >> +    .. note::
> > >> +
> > >> +       No decoded frames are produced during this phase.
> > >> +
>
> [snip]
>
> > >> +8.  Call :c:func:`VIDIOC_G_FMT` for ``CAPTURE`` queue to get format=
 for
> > >> the +    destination buffers parsed/decoded from the bitstream.
> > >> +
> > >> +    * **Required fields:**
> > >> +
> > >> +      ``type``
> > >> +          a ``V4L2_BUF_TYPE_*`` enum appropriate for ``CAPTURE``
> > >> +
> > >> +    * **Return fields:**
> > >> +
> > >> +      ``width``, ``height``
> > >> +          frame buffer resolution for the decoded frames
> > >> +
> > >> +      ``pixelformat``
> > >> +          pixel format for decoded frames
> > >> +
> > >> +      ``num_planes`` (for _MPLANE ``type`` only)
> > >> +          number of planes for pixelformat
> > >> +
> > >> +      ``sizeimage``, ``bytesperline``
> > >> +          as per standard semantics; matching frame buffer format
> > >> +
> > >> +    .. note::
> > >> +
> > >> +       The value of ``pixelformat`` may be any pixel format support=
ed
> > >> and
> > >> +       must be supported for current stream, based on the informati=
on
> > >> +       parsed from the stream and hardware capabilities. It is
> > >> suggested
> > >> +       that driver chooses the preferred/optimal format for given
> > >
> > > In compliance with RFC 2119, how about using "Drivers should choose"
> > > instead of "It is suggested that driver chooses" ?
> >
> > The whole paragraph became:
> >
> >        The value of ``pixelformat`` may be any pixel format supported b=
y the
> > decoder for the current stream. It is expected that the decoder chooses=
 a
> > preferred/optimal format for the default configuration. For example, a =
YUV
> > format may be preferred over an RGB format, if additional conversion st=
ep
> > would be required.
>
> How about using "should" instead of "it is expected that" ?
>

Done.

> [snip]
>
> > >> +10.  *[optional]* Choose a different ``CAPTURE`` format than sugges=
ted
> > >> via
> > >> +     :c:func:`VIDIOC_S_FMT` on ``CAPTURE`` queue. It is possible fo=
r
> > >> the
> > >> +     client to choose a different format than selected/suggested by=
 the
> > >
> > > And here, "A client may choose" ?
> > >
> > >> +     driver in :c:func:`VIDIOC_G_FMT`.
> > >> +
> > >> +     * **Required fields:**
> > >> +
> > >> +       ``type``
> > >> +           a ``V4L2_BUF_TYPE_*`` enum appropriate for ``CAPTURE``
> > >> +
> > >> +       ``pixelformat``
> > >> +           a raw pixel format
> > >> +
> > >> +     .. note::
> > >> +
> > >> +        Calling :c:func:`VIDIOC_ENUM_FMT` to discover currently
> > >> available
> > >> +        formats after receiving ``V4L2_EVENT_SOURCE_CHANGE`` is use=
ful
> > >> to
> > >> +        find out a set of allowed formats for given configuration, =
but
> > >> not
> > >> +        required, if the client can accept the defaults.
> > >
> > > s/required/required,/
> >
> > That would become "[...]but not required,, if the client[...]". Is
> > that your suggestion? ;)
>
> Oops, the other way around of course :-)

Done.

>
> [snip]
>
> > >> +3. Start queuing buffers to ``OUTPUT`` queue containing stream data
> > >> after
> > >> +   the seek until a suitable resume point is found.
> > >> +
> > >> +   .. note::
> > >> +
> > >> +      There is no requirement to begin queuing stream starting exac=
tly
> > >> from
> > >
> > > s/stream/buffers/ ?
> >
> > Perhaps "stream data"? The buffers don't have a resume point, the strea=
m
> > does.
>
> Maybe "coded data" ?
>

Done.

> > >> +      a resume point (e.g. SPS or a keyframe). The driver must hand=
le
> > >> any
> > >> +      data queued and must keep processing the queued buffers until=
 it
> > >> +      finds a suitable resume point. While looking for a resume poi=
nt,
> > >> the
> > >> +      driver processes ``OUTPUT`` buffers and returns them to the
> > >> client
> > >> +      without producing any decoded frames.
> > >> +
> > >> +      For hardware known to be mishandling seeks to a non-resume po=
int,
> > >> +      e.g. by returning corrupted decoded frames, the driver must b=
e
> > >> able
> > >> +      to handle such seeks without a crash or any fatal decode erro=
r.
> > >
> > > This should be true for any hardware, there should never be any crash=
 or
> > > fatal decode error. I'd write it as
> > >
> > > Some hardware is known to mishandle seeks to a non-resume point. Such=
 an
> > > operation may result in an unspecified number of corrupted decoded fr=
ames
> > > being made available on ``CAPTURE``. Drivers must ensure that no fata=
l
> > > decoding errors or crashes occur, and implement any necessary handlin=
g and
> > > work-arounds for hardware issues related to seek operations.
> >
> > Done.
>
> [snip]
>
> > >> +2.  After all buffers containing decoded frames from before the
> > >> resolution
> > >> +    change point are ready to be dequeued on the ``CAPTURE`` queue,=
 the
> > >> +    driver sends a ``V4L2_EVENT_SOURCE_CHANGE`` event for source ch=
ange
> > >> +    type ``V4L2_EVENT_SRC_CH_RESOLUTION``.
> > >> +
> > >> +    * The last buffer from before the change must be marked with
> > >> +      :c:type:`v4l2_buffer` ``flags`` flag ``V4L2_BUF_FLAG_LAST`` a=
s in
> > >> the +      drain sequence. The last buffer might be empty (with
> > >> +      :c:type:`v4l2_buffer` ``bytesused`` =3D 0) and must be ignore=
d by
> > >> the
> > >> +      client, since it does not contain any decoded frame.
> > >> +
> > >> +    * Any client query issued after the driver queues the event mus=
t
> > >> return
> > >> +      values applying to the stream after the resolution change,
> > >> including
> > >> +      queue formats, selection rectangles and controls.
> > >> +
> > >> +    * If the client subscribes to ``V4L2_EVENT_SOURCE_CHANGE`` even=
ts
> > >> and
> > >> +      the event is signaled, the decoding process will not continue
> > >> until
> > >> +      it is acknowledged by either (re-)starting streaming on
> > >> ``CAPTURE``,
> > >> +      or via :c:func:`VIDIOC_DECODER_CMD` with ``V4L2_DEC_CMD_START=
``
> > >> +      command.
> > >
> > > This usage of V4L2_DEC_CMD_START isn't aligned with the documentation=
 of
> > > the command. I'm not opposed to this, but I think the use cases of
> > > decoder commands for codecs should be explained in the VIDIOC_DECODER=
_CMD
> > > documentation. What bothers me in particular is usage of
> > > V4L2_DEC_CMD_START to restart the decoder, while no V4L2_DEC_CMD_STOP=
 has
> > > been issued. Should we add a section that details the decoder state
> > > machine with the implicit and explicit ways in which it is started an=
d
> > > stopped ?
> >
> > Yes, we should probably extend the VIDIOC_DECODER_CMD documentation.
> >
> > As for diagrams, they would indeed be nice to have, but maybe we could
> > add them in a follow up patch?
>
> That's another way to say it won't happen, right ? ;-)

I'd prefer to focus on the basic description first, since for the last
6 years we haven't had any documentation at all. I hope we can later
have more contributors follow up with patches to make it easier to
read, e.g. add nice diagrams.

Anyway, I'll try to add a simple state machine diagram in dot, but
would appreciate if we could postpone any not critical improvements.

> I'm OK with that, but I
> think we should still clarify that the source change generates an implici=
t
> V4L2_DEC_CMD_STOP.
>

Good idea, thanks.

> > > I would also reference step 7 here.
> > >
> > >> +    .. note::
> > >> +
> > >> +       Any attempts to dequeue more buffers beyond the buffer marke=
d
> > >> +       with ``V4L2_BUF_FLAG_LAST`` will result in a -EPIPE error fr=
om
> > >> +       :c:func:`VIDIOC_DQBUF`.
> > >> +
> > >> +3.  The client calls :c:func:`VIDIOC_G_FMT` for ``CAPTURE`` to get =
the
> > >> new
> > >> +    format information. This is identical to calling
> > >> :c:func:`VIDIOC_G_FMT` +    after ``V4L2_EVENT_SRC_CH_RESOLUTION`` i=
n
> > >> the initialization sequence +    and should be handled similarly.
> > >
> > > As the source resolution change event is mentioned in multiple places=
, how
> > > about extracting the related ioctls sequence to a specific section, a=
nd
> > > referencing it where needed (at least from the initialization sequenc=
e and
> > > here) ?
> >
> > I made the text here refer to the Initialization sequence.
>
> Wouldn't it be clearer if those steps were extracted to a standalone sequ=
ence
> referenced from both locations ?
>

It might be possible to extract the operations on the CAPTURE queue
into a "Capture setup" sequence. Let me check that.

> > >> +    .. note::
> > >> +
> > >> +       It is allowed for the driver not to support the same pixel
> > >> format as
> > >
> > > "Drivers may not support ..."
> > >
> > >> +       previously used (before the resolution change) for the new
> > >> +       resolution. The driver must select a default supported pixel
> > >> format,
> > >> +       return it, if queried using :c:func:`VIDIOC_G_FMT`, and the
> > >> client
> > >> +       must take note of it.
> > >> +
> > >> +4.  The client acquires visible resolution as in initialization
> > >> sequence.
> > >> +
> > >> +5.  *[optional]* The client is allowed to enumerate available forma=
ts
> > >> and
> > >
> > > s/is allowed to/may/
> > >
> > >> +    select a different one than currently chosen (returned via
> > >> +    :c:func:`VIDIOC_G_FMT)`. This is identical to a corresponding s=
tep
> > >> in
> > >> +    the initialization sequence.
> > >> +
> > >> +6.  *[optional]* The client acquires minimum number of buffers as i=
n
> > >> +    initialization sequence.
> > >> +
> > >> +7.  If all the following conditions are met, the client may resume =
the
> > >> +    decoding instantly, by using :c:func:`VIDIOC_DECODER_CMD` with
> > >> +    ``V4L2_DEC_CMD_START`` command, as in case of resuming after th=
e
> > >> drain
> > >> +    sequence:
> > >> +
> > >> +    * ``sizeimage`` of new format is less than or equal to the size=
 of
> > >> +      currently allocated buffers,
> > >> +
> > >> +    * the number of buffers currently allocated is greater than or
> > >> equal to
> > >> +      the minimum number of buffers acquired in step 6.
> > >> +
> > >> +    In such case, the remaining steps do not apply.
> > >> +
> > >> +    However, if the client intends to change the buffer set, to low=
er
> > >> +    memory usage or for any other reasons, it may be achieved by
> > >> following
> > >> +    the steps below.
> > >> +
> > >> +8.  After dequeuing all remaining buffers from the ``CAPTURE`` queu=
e,
> > >
> > > This is optional, isn't it ?
> >
> > I wouldn't call it optional, since it depends on what the client does
> > and what the decoder supports. That's why the point above just states
> > that the remaining steps do not apply.
>
> I meant isn't the "After dequeuing all remaining buffers from the CAPTURE
> queue" part optional ? As far as I understand, the client may decide not =
to
> dequeue them.
>

A STREAMOFF would discard the already decoded but not yet dequeued
frames. While it's technically fine, it doesn't make sense, because it
would lead to a frame drop. Therefore, I'd rather keep it required,
for simplicity.

> > Also added a note:
> >
> >        To fulfill those requirements, the client may attempt to use
> >        :c:func:`VIDIOC_CREATE_BUFS` to add more buffers. However, due t=
o
> >        hardware limitations, the decoder may not support adding buffers=
 at
> >        this point and the client must be able to handle a failure using=
 the
> >        steps below.
>
> I wonder if there could be a way to work around those limitations on the
> driver side. At the beginning of step 7, the decoder is effectively stopp=
ed.
> If the hardware doesn't support adding new buffers on the fly, can't the
> driver support the VIDIOC_CREATE_BUFS + V4L2_DEC_CMD_START sequence the s=
ame
> way it would support the VIDIOC_STREAMOFF + VIDIOC_REQBUFS(0) +
> VIDIOC_REQBUFS(n) + VIDIOC_STREAMON ?
>

I guess that would work. I would only allow it for the case where
existing buffers are already big enough and just more buffers are
needed. Otherwise it would lead to some weird cases, such as some old
buffers already in the CAPTURE queue, blocking the decode of further
frames. (While it could be handled by the driver returning them with
an error state, it would only complicate the interface.)

Best regards,
Tomasz
