Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yb0-f194.google.com ([209.85.213.194]:36458 "EHLO
        mail-yb0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728956AbeGZLgj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 26 Jul 2018 07:36:39 -0400
Received: by mail-yb0-f194.google.com with SMTP id s1-v6so426447ybk.3
        for <linux-media@vger.kernel.org>; Thu, 26 Jul 2018 03:20:28 -0700 (PDT)
Received: from mail-yw0-f172.google.com (mail-yw0-f172.google.com. [209.85.161.172])
        by smtp.gmail.com with ESMTPSA id z125-v6sm460662ywg.57.2018.07.26.03.20.25
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 26 Jul 2018 03:20:26 -0700 (PDT)
Received: by mail-yw0-f172.google.com with SMTP id e23-v6so375458ywe.13
        for <linux-media@vger.kernel.org>; Thu, 26 Jul 2018 03:20:25 -0700 (PDT)
MIME-Version: 1.0
References: <20180724140621.59624-1-tfiga@chromium.org> <20180724140621.59624-2-tfiga@chromium.org>
 <37a8faea-a226-2d52-36d4-f9df194623cc@xs4all.nl>
In-Reply-To: <37a8faea-a226-2d52-36d4-f9df194623cc@xs4all.nl>
From: Tomasz Figa <tfiga@chromium.org>
Date: Thu, 26 Jul 2018 19:20:14 +0900
Message-ID: <CAAFQd5BgGEBmd8gNGc-qqtUtLo=Mh8U+TVTWRsKYMv1LmeBQMA@mail.gmail.com>
Subject: Re: [PATCH 1/2] media: docs-rst: Document memory-to-memory video
 decoder interface
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
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
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        dave.stevenson@raspberrypi.org,
        Ezequiel Garcia <ezequiel@collabora.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Wed, Jul 25, 2018 at 8:59 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> Hi Tomasz,
>
> Many, many thanks for working on this! It's a great document and when don=
e
> it will be very useful indeed.
>
> Review comments follow...

Thanks for review!

>
> On 24/07/18 16:06, Tomasz Figa wrote:
[snip]
> > +DPB
> > +   Decoded Picture Buffer; a H.264 term for a buffer that stores a pic=
ture
>
> a H.264 -> an H.264
>

Ack.

> > +   that is encoded or decoded and available for reference in further
> > +   decode/encode steps.
> > +
> > +EOS
> > +   end of stream
> > +
> > +IDR
> > +   a type of a keyframe in H.264-encoded stream, which clears the list=
 of
> > +   earlier reference frames (DPBs)
>
> You do not actually say what IDR stands for. Can you add that?
>

Ack.

[snip]
> > +3. The client may use :c:func:`VIDIOC_ENUM_FRAMESIZES` to detect suppo=
rted
> > +   resolutions for a given format, passing desired pixel format in
> > +   :c:type:`v4l2_frmsizeenum` ``pixel_format``.
> > +
> > +   * Values returned by :c:func:`VIDIOC_ENUM_FRAMESIZES` on ``OUTPUT``
> > +     must include all possible coded resolutions supported by the deco=
der
> > +     for given coded pixel format.
>
> This is confusing. Since VIDIOC_ENUM_FRAMESIZES does not have a buffer ty=
pe
> argument you cannot say 'on OUTPUT'. I would remove 'on OUTPUT' entirely.
>
> > +
> > +   * Values returned by :c:func:`VIDIOC_ENUM_FRAMESIZES` on ``CAPTURE`=
`
>
> Ditto for 'on CAPTURE'
>

You're right. I didn't notice that the "type" field in
v4l2_frmsizeenum was not buffer type, but type of the range. Thanks
for spotting this.

> > +     must include all possible frame buffer resolutions supported by t=
he
> > +     decoder for given raw pixel format and coded format currently set=
 on
> > +     ``OUTPUT``.
> > +
> > +    .. note::
> > +
> > +       The client may derive the supported resolution range for a
> > +       combination of coded and raw format by setting width and height=
 of
> > +       ``OUTPUT`` format to 0 and calculating the intersection of
> > +       resolutions returned from calls to :c:func:`VIDIOC_ENUM_FRAMESI=
ZES`
> > +       for the given coded and raw formats.
>
> So if the output format is set to 1280x720, then ENUM_FRAMESIZES would ju=
st
> return 1280x720 as the resolution. If the output format is set to 0x0, th=
en
> it returns the full range it is capable of.
>
> Correct?
>
> If so, then I think this needs to be a bit more explicit. I had to think =
about
> it a bit.
>
> Note that the v4l2_pix_format/S_FMT documentation needs to be updated as =
well
> since we never allowed 0x0 before.

Is there any text that disallows this? I couldn't spot any. Generally
there are already drivers which return 0x0 for coded formats (s5p-mfc)
and it's not even strange, because in such case, the buffer contains
just a sequence of bytes, not a 2D picture.

> What if you set the format to 0x0 but the stream does not have meta data =
with
> the resolution? How does userspace know if 0x0 is allowed or not? If this=
 is
> specific to the chosen coded pixel format, should be add a new flag for t=
hose
> formats indicating that the coded data contains resolution information?

Yes, this would definitely be on a per-format basis. Not sure what you
mean by a flag, though? E.g. if the format is set to H264, then it's
bound to include resolution information. If the format doesn't include
it, then userspace is already aware of this fact, because it needs to
get this from some other source (e.g. container).

>
> That way userspace knows if 0x0 can be used, and the driver can reject 0x=
0
> for formats that do not support it.

As above, but I might be misunderstanding your suggestion.

>
> > +
> > +4. Supported profiles and levels for given format, if applicable, may =
be
> > +   queried using their respective controls via :c:func:`VIDIOC_QUERYCT=
RL`.
> > +
> > +Initialization
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > +
> > +1. *[optional]* Enumerate supported ``OUTPUT`` formats and resolutions=
. See
> > +   capability enumeration.
>
> capability enumeration. -> 'Querying capabilities' above.
>

Ack.

> > +
> > +2. Set the coded format on ``OUTPUT`` via :c:func:`VIDIOC_S_FMT`
> > +
> > +   * **Required fields:**
> > +
> > +     ``type``
> > +         a ``V4L2_BUF_TYPE_*`` enum appropriate for ``OUTPUT``
> > +
> > +     ``pixelformat``
> > +         a coded pixel format
> > +
> > +     ``width``, ``height``
> > +         required only if cannot be parsed from the stream for the giv=
en
> > +         coded format; optional otherwise - set to zero to ignore
> > +
> > +     other fields
> > +         follow standard semantics
> > +
> > +   * For coded formats including stream resolution information, if wid=
th
> > +     and height are set to non-zero values, the driver will propagate =
the
> > +     resolution to ``CAPTURE`` and signal a source change event
> > +     instantly. However, after the decoder is done parsing the
> > +     information embedded in the stream, it will update ``CAPTURE``
> > +     format with new values and signal a source change event again, if
> > +     the values do not match.
> > +
> > +   .. note::
> > +
> > +      Changing ``OUTPUT`` format may change currently set ``CAPTURE``
>
> change -> change the

Ack.

>
> > +      format. The driver will derive a new ``CAPTURE`` format from
>
> from -> from the

Ack.

>
> > +      ``OUTPUT`` format being set, including resolution, colorimetry
> > +      parameters, etc. If the client needs a specific ``CAPTURE`` form=
at,
> > +      it must adjust it afterwards.
> > +
> > +3.  *[optional]* Get minimum number of buffers required for ``OUTPUT``
> > +    queue via :c:func:`VIDIOC_G_CTRL`. This is useful if client intend=
s to
>
> client -> the client

Ack.

>
> > +    use more buffers than minimum required by hardware/format.
>
> than -> than the

Ack.

[snip]
> > +13. Allocate destination (raw format) buffers via :c:func:`VIDIOC_REQB=
UFS`
> > +    on the ``CAPTURE`` queue.
> > +
> > +    * **Required fields:**
> > +
> > +      ``count``
> > +          requested number of buffers to allocate; greater than zero
> > +
> > +      ``type``
> > +          a ``V4L2_BUF_TYPE_*`` enum appropriate for ``CAPTURE``
> > +
> > +      ``memory``
> > +          follows standard semantics
> > +
> > +    * **Return fields:**
> > +
> > +      ``count``
> > +          adjusted to allocated number of buffers
> > +
> > +    * The driver must adjust count to minimum of required number of
> > +      destination buffers for given format and stream configuration an=
d the
> > +      count passed. The client must check this value after the ioctl
> > +      returns to get the number of buffers allocated.
> > +
> > +    .. note::
> > +
> > +       To allocate more than minimum number of buffers (for pipeline
> > +       depth), use G_CTRL(``V4L2_CID_MIN_BUFFERS_FOR_CAPTURE``) to
> > +       get minimum number of buffers required, and pass the obtained v=
alue
> > +       plus the number of additional buffers needed in count to
> > +       :c:func:`VIDIOC_REQBUFS`.
>
>
> I think we should mention here the option of using VIDIOC_CREATE_BUFS in =
order
> to allocate buffers larger than the current CAPTURE format in order to ac=
commodate
> future resolution changes.

Ack.

>
> > +
> > +14. Call :c:func:`VIDIOC_STREAMON` to initiate decoding frames.
> > +
> > +Decoding
> > +=3D=3D=3D=3D=3D=3D=3D=3D
> > +
> > +This state is reached after a successful initialization sequence. In t=
his
> > +state, client queues and dequeues buffers to both queues via
> > +:c:func:`VIDIOC_QBUF` and :c:func:`VIDIOC_DQBUF`, following standard
> > +semantics.
> > +
> > +Both queues operate independently, following standard behavior of V4L2
> > +buffer queues and memory-to-memory devices. In addition, the order of
> > +decoded frames dequeued from ``CAPTURE`` queue may differ from the ord=
er of
> > +queuing coded frames to ``OUTPUT`` queue, due to properties of selecte=
d
> > +coded format, e.g. frame reordering. The client must not assume any di=
rect
> > +relationship between ``CAPTURE`` and ``OUTPUT`` buffers, other than
> > +reported by :c:type:`v4l2_buffer` ``timestamp`` field.
>
> Is there a relationship between capture and output buffers w.r.t. the tim=
estamp
> field? I am not aware that there is one.

I believe the decoder was expected to copy the timestamp of matching
OUTPUT buffer to respective CAPTURE buffer. Both s5p-mfc and coda seem
to be implementing it this way. I guess it might be a good idea to
specify this more explicitly.

>
> > +
> > +The contents of source ``OUTPUT`` buffers depend on active coded pixel
> > +format and might be affected by codec-specific extended controls, as s=
tated
> > +in documentation of each format individually.
>
> in -> in the
> each format individually -> each format
>

Ack.

[snip]
> > +2. Restart the ``OUTPUT`` queue via :c:func:`VIDIOC_STREAMON`
> > +
> > +   * **Required fields:**
> > +
> > +     ``type``
> > +         a ``V4L2_BUF_TYPE_*`` enum appropriate for ``OUTPUT``
> > +
> > +   * The driver must be put in a state after seek and be ready to
>
> "put in a state"???
>

I'm not sure what this was supposed to be. I guess just "The driver
must start accepting new source bitstream buffers after the call
returns." would be enough.

> > +     accept new source bitstream buffers.
> > +
> > +3. Start queuing buffers to ``OUTPUT`` queue containing stream data af=
ter
> > +   the seek until a suitable resume point is found.
> > +
> > +   .. note::
> > +
> > +      There is no requirement to begin queuing stream starting exactly=
 from
> > +      a resume point (e.g. SPS or a keyframe). The driver must handle =
any
> > +      data queued and must keep processing the queued buffers until it
> > +      finds a suitable resume point. While looking for a resume point,=
 the
> > +      driver processes ``OUTPUT`` buffers and returns them to the clie=
nt
> > +      without producing any decoded frames.
> > +
> > +      For hardware known to be mishandling seeks to a non-resume point=
,
> > +      e.g. by returning corrupted decoded frames, the driver must be a=
ble
> > +      to handle such seeks without a crash or any fatal decode error.
> > +
> > +4. After a resume point is found, the driver will start returning
> > +   ``CAPTURE`` buffers with decoded frames.
> > +
> > +   * There is no precise specification for ``CAPTURE`` queue of when i=
t
> > +     will start producing buffers containing decoded data from buffers
> > +     queued after the seek, as it operates independently
> > +     from ``OUTPUT`` queue.
> > +
> > +     * The driver is allowed to and may return a number of remaining
>
> I'd drop 'is allowed to and'.
>

Ack.

> > +       ``CAPTURE`` buffers containing decoded frames from before the s=
eek
> > +       after the seek sequence (STREAMOFF-STREAMON) is performed.
> > +
> > +     * The driver is also allowed to and may not return all decoded fr=
ames
>
> Ditto.

Ack.

>
> > +       queued but not decode before the seek sequence was initiated. F=
or
>
> Very confusing sentence. I think you mean this:
>
>           The driver may not return all decoded frames that where ready f=
or
>           dequeueing from before the seek sequence was initiated.
>
> Is this really true? Once decoded frames are marked as buffer_done by the
> driver there is no reason for them to be removed. Or you mean something e=
lse
> here, e.g. the frames are decoded, but the buffers not yet given back to =
vb2.
>

Exactly "the frames are decoded, but the buffers not yet given back to
vb2", for example, if reordering takes place. However, if one stops
streaming before dequeuing all buffers, they are implicitly returned
(reset to the state after REQBUFS) and can't be dequeued anymore, so
the frames are lost, even if the driver returned them. I guess the
sentence was really unfortunate indeed.

> > +       example, given an ``OUTPUT`` queue sequence: QBUF(A), QBUF(B),
> > +       STREAMOFF(OUT), STREAMON(OUT), QBUF(G), QBUF(H), any of the
> > +       following results on the ``CAPTURE`` queue is allowed: {A=E2=80=
=99, B=E2=80=99, G=E2=80=99,
> > +       H=E2=80=99}, {A=E2=80=99, G=E2=80=99, H=E2=80=99}, {G=E2=80=99,=
 H=E2=80=99}.
> > +
> > +   .. note::
> > +
> > +      To achieve instantaneous seek, the client may restart streaming =
on
> > +      ``CAPTURE`` queue to discard decoded, but not yet dequeued buffe=
rs.
> > +
> > +Pause
> > +=3D=3D=3D=3D=3D
> > +
> > +In order to pause, the client should just cease queuing buffers onto t=
he
> > +``OUTPUT`` queue. This is different from the general V4L2 API definiti=
on of
> > +pause, which involves calling :c:func:`VIDIOC_STREAMOFF` on the queue.
> > +Without source bitstream data, there is no data to process and the har=
dware
> > +remains idle.
> > +
> > +Conversely, using :c:func:`VIDIOC_STREAMOFF` on ``OUTPUT`` queue indic=
ates
> > +a seek, which
> > +
> > +1. drops all ``OUTPUT`` buffers in flight and
> > +2. after a subsequent :c:func:`VIDIOC_STREAMON`, will look for and onl=
y
> > +   continue from a resume point.
> > +
> > +This is usually undesirable for pause. The STREAMOFF-STREAMON sequence=
 is
> > +intended for seeking.
> > +
> > +Similarly, ``CAPTURE`` queue should remain streaming as well, as the
>
> the ``CAPTURE`` queue
>
> (add 'the')
>

Ack.

> > +STREAMOFF-STREAMON sequence on it is intended solely for changing buff=
er
> > +sets.
>
> 'changing buffer sets': not clear what is meant by this. It's certainly n=
ot
> 'solely' since it can also be used to achieve an instantaneous seek.
>

To be honest, I'm not sure whether there is even a need to include
this whole section. It's obvious that if you stop feeding a mem2mem
device, it will pause. Moreover, other sections imply various
behaviors triggered by STREAMOFF/STREAMON/DECODER_CMD/etc., so it
should be quite clear that they are different from a simple pause.
What do you think?

> > +
> > +Dynamic resolution change
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
> > +
> > +A video decoder implementing this interface must support dynamic resol=
ution
> > +change, for streams, which include resolution metadata in the bitstrea=
m.
>
> I think the commas can be removed from this sentence. I would also replac=
e
> 'which' by 'that'.
>

Ack.

> > +When the decoder encounters a resolution change in the stream, the dyn=
amic
> > +resolution change sequence is started.
> > +
> > +1.  After encountering a resolution change in the stream, the driver m=
ust
> > +    first process and decode all remaining buffers from before the
> > +    resolution change point.
> > +
> > +2.  After all buffers containing decoded frames from before the resolu=
tion
> > +    change point are ready to be dequeued on the ``CAPTURE`` queue, th=
e
> > +    driver sends a ``V4L2_EVENT_SOURCE_CHANGE`` event for source chang=
e
> > +    type ``V4L2_EVENT_SRC_CH_RESOLUTION``.
> > +
> > +    * The last buffer from before the change must be marked with
> > +      :c:type:`v4l2_buffer` ``flags`` flag ``V4L2_BUF_FLAG_LAST`` as i=
n the
>
> spurious 'as'?
>

It should be:

    * The last buffer from before the change must be marked with
      the ``V4L2_BUF_FLAG_LAST`` flag in :c:type:`v4l2_buffer` ``flags`` fi=
eld,
      similarly to the

> > +      drain sequence. The last buffer might be empty (with
> > +      :c:type:`v4l2_buffer` ``bytesused`` =3D 0) and must be ignored b=
y the
> > +      client, since it does not contain any decoded frame.
>
> any -> a
>

Ack.

> > +
> > +    * Any client query issued after the driver queues the event must r=
eturn
> > +      values applying to the stream after the resolution change, inclu=
ding
> > +      queue formats, selection rectangles and controls.
> > +
> > +    * If the client subscribes to ``V4L2_EVENT_SOURCE_CHANGE`` events =
and
> > +      the event is signaled, the decoding process will not continue un=
til
> > +      it is acknowledged by either (re-)starting streaming on ``CAPTUR=
E``,
> > +      or via :c:func:`VIDIOC_DECODER_CMD` with ``V4L2_DEC_CMD_START``
> > +      command.
>
> With (re-)starting streaming you mean a STREAMOFF/ON pair on the CAPTURE =
queue,
> right?
>

Right. I guess it might be better to just state that explicitly.

> > +
> > +    .. note::
> > +
> > +       Any attempts to dequeue more buffers beyond the buffer marked
> > +       with ``V4L2_BUF_FLAG_LAST`` will result in a -EPIPE error from
> > +       :c:func:`VIDIOC_DQBUF`.
> > +
> > +3.  The client calls :c:func:`VIDIOC_G_FMT` for ``CAPTURE`` to get the=
 new
> > +    format information. This is identical to calling :c:func:`VIDIOC_G=
_FMT`
> > +    after ``V4L2_EVENT_SRC_CH_RESOLUTION`` in the initialization seque=
nce
> > +    and should be handled similarly.
> > +
> > +    .. note::
> > +
> > +       It is allowed for the driver not to support the same pixel form=
at as
> > +       previously used (before the resolution change) for the new
> > +       resolution. The driver must select a default supported pixel fo=
rmat,
> > +       return it, if queried using :c:func:`VIDIOC_G_FMT`, and the cli=
ent
> > +       must take note of it.
> > +
> > +4.  The client acquires visible resolution as in initialization sequen=
ce.
> > +
> > +5.  *[optional]* The client is allowed to enumerate available formats =
and
> > +    select a different one than currently chosen (returned via
> > +    :c:func:`VIDIOC_G_FMT)`. This is identical to a corresponding step=
 in
> > +    the initialization sequence.
> > +
> > +6.  *[optional]* The client acquires minimum number of buffers as in
> > +    initialization sequence.
>
> It's an optional step, but what might happen if you ignore it or if the c=
ontrol
> does not exist?

REQBUFS is supposed clamp the requested number of buffers to the [min,
max] range anyway.

>
> You also should mention that this is the min number of CAPTURE buffers.
>
> I wonder if we should make these min buffer controls required. It might b=
e easier
> that way.

Agreed. Although userspace is still free to ignore it, because REQBUFS
would do the right thing anyway.

>
> > +7.  If all the following conditions are met, the client may resume the
> > +    decoding instantly, by using :c:func:`VIDIOC_DECODER_CMD` with
> > +    ``V4L2_DEC_CMD_START`` command, as in case of resuming after the d=
rain
> > +    sequence:
> > +
> > +    * ``sizeimage`` of new format is less than or equal to the size of
> > +      currently allocated buffers,
> > +
> > +    * the number of buffers currently allocated is greater than or equ=
al to
> > +      the minimum number of buffers acquired in step 6.
>
> You might want to mention that if there are insufficient buffers, then
> VIDIOC_CREATE_BUFS can be used to add more buffers.
>

This might be a bit tricky, since at least s5p-mfc and coda can only
work on a fixed buffer set and one would need to fully reinitialize
the decoding to add one more buffer, which would effectively be the
full resolution change sequence, as below, just with REQBUFS(0),
REQBUFS(N) replaced with CREATE_BUFS.

We should mention CREATE_BUFS as an alternative to steps 9 and 10, though.

> > +
> > +    In such case, the remaining steps do not apply.
> > +
> > +    However, if the client intends to change the buffer set, to lower
> > +    memory usage or for any other reasons, it may be achieved by follo=
wing
> > +    the steps below.
> > +
> > +8.  After dequeuing all remaining buffers from the ``CAPTURE`` queue, =
the
> > +    client must call :c:func:`VIDIOC_STREAMOFF` on the ``CAPTURE`` que=
ue.
> > +    The ``OUTPUT`` queue must remain streaming (calling STREAMOFF on i=
t
> > +    would trigger a seek).
> > +
> > +9.  The client frees the buffers on the ``CAPTURE`` queue using
> > +    :c:func:`VIDIOC_REQBUFS`.
> > +
> > +    * **Required fields:**
> > +
> > +      ``count``
> > +          set to 0
> > +
> > +      ``type``
> > +          a ``V4L2_BUF_TYPE_*`` enum appropriate for ``CAPTURE``
> > +
> > +      ``memory``
> > +          follows standard semantics
> > +
> > +10. The client allocates a new set of buffers for the ``CAPTURE`` queu=
e via
> > +    :c:func:`VIDIOC_REQBUFS`. This is identical to a corresponding ste=
p in
> > +    the initialization sequence.
[snip]
> > +
> > +Commit points
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > +
> > +Setting formats and allocating buffers triggers changes in the behavio=
r
> > +of the driver.
> > +
> > +1. Setting format on ``OUTPUT`` queue may change the set of formats
>
> Setting -> Setting the
>

Ack.

> > +   supported/advertised on the ``CAPTURE`` queue. In particular, it al=
so
> > +   means that ``CAPTURE`` format may be reset and the client must not
>
> that -> that the
>

Ack.

> > +   rely on the previously set format being preserved.
> > +
> > +2. Enumerating formats on ``CAPTURE`` queue must only return formats
> > +   supported for the ``OUTPUT`` format currently set.
> > +
> > +3. Setting/changing format on ``CAPTURE`` queue does not change format=
s
>
> format -> the format
>

Ack.

> > +   available on ``OUTPUT`` queue. An attempt to set ``CAPTURE`` format=
 that
>
> set -> set a
>

Ack.

> > +   is not supported for the currently selected ``OUTPUT`` format must
> > +   result in the driver adjusting the requested format to an acceptabl=
e
> > +   one.
> > +
> > +4. Enumerating formats on ``OUTPUT`` queue always returns the full set=
 of
> > +   supported coded formats, irrespective of the current ``CAPTURE``
> > +   format.
> > +
> > +5. After allocating buffers on the ``OUTPUT`` queue, it is not possibl=
e to
> > +   change format on it.
>
> format -> the format
>

Ack.

Best regards,
Tomasz
