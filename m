Return-Path: <SRS0=FDnu=P7=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA77AC282C0
	for <linux-media@archiver.kernel.org>; Wed, 23 Jan 2019 05:27:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8A978217F5
	for <linux-media@archiver.kernel.org>; Wed, 23 Jan 2019 05:27:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="W8hmby5P"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726015AbfAWF1z (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 23 Jan 2019 00:27:55 -0500
Received: from mail-oi1-f195.google.com ([209.85.167.195]:37142 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725899AbfAWF1z (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 23 Jan 2019 00:27:55 -0500
Received: by mail-oi1-f195.google.com with SMTP id y23so841378oia.4
        for <linux-media@vger.kernel.org>; Tue, 22 Jan 2019 21:27:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=BSNVAiWGA2hPWdyaz1uBMb2kwQXAZkyf/WPkK306YZM=;
        b=W8hmby5PF9NaAHULa5qS/7V8nn5HUeQJoCUL1dwkr+bBmWZArQcJbaxdFh3dAqT+o5
         6uvZH3paCyd3jPsiUdoEcIsE72L2UBYZINrhjOysvpwLatRTE/lhRHLUSfP9PPEEBhde
         nkrSrBqvMjnmhYMIv1uOeAXSzQzOkKHML/o0w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=BSNVAiWGA2hPWdyaz1uBMb2kwQXAZkyf/WPkK306YZM=;
        b=CiClnsNmq4QqxCPFfy/1H8nClqMpQpVk/x6u+73OsAkzcbSYTKC1osSk/dsb7K/s0L
         OrdtNLT1twtHoO1xuTzyFcG8T2qaVegwPOLiL9zxb42/s/zpnHjfODmcQjjkcKguepkY
         I/jPjMxPXVI+uSXjB10O44wEabimYBGfIvzjkT/MqDwSt20J3TIHXs2fJGWUfwhpC6Mx
         sGlBuslzN1ahiMZiarGLvSLZy7XvNCs9p0AVwDGmlqcJjbT4rPY7g1RnBqkc8Jp6x/ej
         Wha/SC3jyFMQuSpAtTbGLrXnWC7DIJNPvfU4vrYhc0LurmZ0KiuuRcK94GJMxoXVByLy
         LxmQ==
X-Gm-Message-State: AJcUukdRLQqmZ4yKY7a6rBwkjBYNSrJiL1DZ/mZEWuxKQrGqBofBPEp4
        an+6RKHPLhpYpk5rG3TdzUcAGHh+oOKHjQ==
X-Google-Smtp-Source: ALg8bN7+kTNJMRp4efyTHpNy21uuIkpMsfhGs1oxWKxD/xHI7nGnq/vL9S1zTiR55pqCKEop076wOA==
X-Received: by 2002:a54:460a:: with SMTP id p10mr497247oip.27.1548221274174;
        Tue, 22 Jan 2019 21:27:54 -0800 (PST)
Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com. [209.85.210.46])
        by smtp.gmail.com with ESMTPSA id l20sm7743881otp.47.2019.01.22.21.27.53
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 22 Jan 2019 21:27:54 -0800 (PST)
Received: by mail-ot1-f46.google.com with SMTP id e12so884114otl.5
        for <linux-media@vger.kernel.org>; Tue, 22 Jan 2019 21:27:53 -0800 (PST)
X-Received: by 2002:a9d:6546:: with SMTP id q6mr582128otl.288.1548221273016;
 Tue, 22 Jan 2019 21:27:53 -0800 (PST)
MIME-Version: 1.0
References: <20181022144901.113852-1-tfiga@chromium.org> <20181022144901.113852-2-tfiga@chromium.org>
 <cf0fc2fc-72c6-dbca-68f7-a349879a3a14@xs4all.nl> <CAAFQd5AORjMjHdavdr3zM13BnyFnKnEb-0aKNjvwbB_xJEnxgQ@mail.gmail.com>
 <9b7c1385-d482-6e92-2222-2daa835dbc91@xs4all.nl>
In-Reply-To: <9b7c1385-d482-6e92-2222-2daa835dbc91@xs4all.nl>
From:   Tomasz Figa <tfiga@chromium.org>
Date:   Wed, 23 Jan 2019 14:27:41 +0900
X-Gmail-Original-Message-ID: <CAAFQd5DwjLt8UeDohzrMausaLGnOStvrmp5p7frYbG1hbGjx3Q@mail.gmail.com>
Message-ID: <CAAFQd5DwjLt8UeDohzrMausaLGnOStvrmp5p7frYbG1hbGjx3Q@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] media: docs-rst: Document memory-to-memory video
 decoder interface
To:     Hans Verkuil <hverkuil@xs4all.nl>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Pawel Osciak <posciak@chromium.org>,
        Alexandre Courbot <acourbot@chromium.org>, kamil@wypas.org,
        a.hajda@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>,
        jtp.park@samsung.com, Philipp Zabel <p.zabel@pengutronix.de>,
        =?UTF-8?B?VGlmZmFueSBMaW4gKOael+aFp+ePiik=?= 
        <tiffany.lin@mediatek.com>,
        =?UTF-8?B?QW5kcmV3LUNUIENoZW4gKOmZs+aZuui/qik=?= 
        <andrew-ct.chen@mediatek.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        todor.tomov@linaro.org, nicolas@ndufresne.ca,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        dave.stevenson@raspberrypi.org,
        Ezequiel Garcia <ezequiel@collabora.com>,
        Maxime Jourdan <maxi.jourdan@wanadoo.fr>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Tue, Jan 22, 2019 at 11:47 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> On 01/22/19 11:02, Tomasz Figa wrote:
> > On Mon, Nov 12, 2018 at 8:37 PM Hans Verkuil <hverkuil@xs4all.nl> wrote=
:
> >>
> >> Hi Tomasz,
> >>
> >> A general note for the stateful and stateless patches: they describe s=
pecific
> >> use-cases of the more generic Codec Interface, and as such should be o=
ne
> >> level deeper in the section hierarchy.
> >
> > I wonder what exactly this Codec Interface is. Is it a historical name
> > for mem2mem? If so, perhaps it would make sense to rename it?
>
> Yeah, it should be renamed to "Video Memory-to-Memory Interface", and the
> codecs are just specific instances of such an interface.
>

Ack.

> >
> >>
> >> I.e. instead of being section 4.6/7/8:
> >>
> >> https://hverkuil.home.xs4all.nl/request-api/uapi/v4l/devices.html
> >>
> >> they should be 4.5.1/2/3.
> >>
> >
> > FYI, the first RFC started like that, but it only made the spec
> > difficult to navigate and the section numbers too long.
> >
> > Still, no strong opinion. I'm okay moving it there, if you think it's b=
etter.
>
> It should be moved and the interface name should be renamed. It makes a l=
ot
> more sense with those changes.
>
> I've posted a patch for this.
>

Thanks. I've rebased on top of it.

[snip]
> >>> +3.  Query the minimum number of buffers required for the ``CAPTURE``=
 queue via
> >>> +    :c:func:`VIDIOC_G_CTRL`. This is useful if the client intends to=
 use more
> >>> +    buffers than the minimum required by hardware/format.
> >>
> >> Is this step optional or required? Can it change when a resolution cha=
nge occurs?
> >
> > Probably not with a simple resolution change, but a case when a stream
> > is changed on the fly would trigger what we call "resolution change"
> > here, but what would effectively be a "source change" and that could
> > include a change in the number of required CAPTURE buffers.
> >
> >> How does this relate to the checks for the minimum number of buffers t=
hat REQBUFS
> >> does?
> >
> > The control returns the minimum that REQBUFS would allow, so the
> > application can add few more buffers on top of that and improve the
> > pipelining.
> >
> >>
> >> The 'This is useful if' sentence suggests that it is optional, but I t=
hink that
> >> sentence just confuses the issue.
> >>
> >
> > It used to be optional and I didn't rephrase it after turning it into
> > mandatory. How about:
> >
> >     This enables the client to request more buffers
> >     than the minimum required by hardware/format and achieve better pip=
elining.
>
> Hmm, OK. It'll do, I guess. I never liked these MIN_BUFFERS controls, I w=
ish they
> would return something like the recommended number of buffers that will g=
ive you
> decent performance.
>

The problem here is that the kernel doesn't know what is decent for
the application, since it doesn't know how the results of the decoding
are used. Over-allocating would result to a waste of memory, which
could then make it less than decent for memory-constrained
applications.

> >
> >>> +
> >>> +    * **Required fields:**
> >>> +
> >>> +      ``id``
> >>> +          set to ``V4L2_CID_MIN_BUFFERS_FOR_CAPTURE``
> >>> +
> >>> +    * **Return fields:**
> >>> +
> >>> +      ``value``
> >>> +          minimum number of buffers required to decode the stream pa=
rsed in
> >>> +          this initialization sequence.
> >>> +
> >>> +    .. note::
> >>> +
> >>> +       The minimum number of buffers must be at least the number req=
uired to
> >>> +       successfully decode the current stream. This may for example =
be the
> >>> +       required DPB size for an H.264 stream given the parsed stream
> >>> +       configuration (resolution, level).
> >>> +
> >>> +    .. warning::
> >>> +
> >>> +       The value is guaranteed to be meaningful only after the decod=
er
> >>> +       successfully parses the stream metadata. The client must not =
rely on the
> >>> +       query before that happens.
> >>> +
> >>> +4.  **Optional.** Enumerate ``CAPTURE`` formats via :c:func:`VIDIOC_=
ENUM_FMT` on
> >>> +    the ``CAPTURE`` queue. Once the stream information is parsed and=
 known, the
> >>> +    client may use this ioctl to discover which raw formats are supp=
orted for
> >>> +    given stream and select one of them via :c:func:`VIDIOC_S_FMT`.
> >>
> >> Can the list returned here differ from the list returned in the 'Query=
ing capabilities'
> >> step? If so, then I assume it will always be a subset of what was retu=
rned in
> >> the 'Querying' step?
> >
> > Depends on whether you're considering just VIDIOC_ENUM_FMT or also
> > VIDIOC_G_FMT and VIDIOC_ENUM_FRAMESIZES.
> >
> > The initial VIDIOC_ENUM_FMT has no way to account for any resolution
> > constraints of the formats, so the list would include all raw pixel
> > formats that the decoder can handle with selected coded pixel format.
> > However, the list can be further narrowed down by using
> > VIDIOC_ENUM_FRAMESIZES, to restrict each raw format only to the
> > resolutions it can handle.
> >
> > The VIDIOC_ENUM_FMT call in this sequence (after getting the stream
> > information) would have the knowledge about the resolution, so the
> > list returned here would only include the formats that can be actually
> > handled. It should match the result of the initial query using both
> > VIDIOC_ENUM_FMT and VIDIOC_ENUM_FRAMESIZES.
>
> Right, so this will be a subset of the initial query taking the resolutio=
n
> into account.
>

Do you think it could be worth adding a note about this?

[snip]
> >>> +Decoding
> >>> +=3D=3D=3D=3D=3D=3D=3D=3D
> >>> +
> >>> +This state is reached after the `Capture setup` sequence finishes su=
ccesfully.
> >>> +In this state, the client queues and dequeues buffers to both queues=
 via
> >>> +:c:func:`VIDIOC_QBUF` and :c:func:`VIDIOC_DQBUF`, following the stan=
dard
> >>> +semantics.
> >>> +
> >>> +The contents of the source ``OUTPUT`` buffers depend on the active c=
oded pixel
> >>> +format and may be affected by codec-specific extended controls, as s=
tated in
> >>> +the documentation of each format.
> >>> +
> >>> +Both queues operate independently, following the standard behavior o=
f V4L2
> >>> +buffer queues and memory-to-memory devices. In addition, the order o=
f decoded
> >>> +frames dequeued from the ``CAPTURE`` queue may differ from the order=
 of queuing
> >>> +coded frames to the ``OUTPUT`` queue, due to properties of the selec=
ted coded
> >>> +format, e.g. frame reordering.
> >>> +
> >>> +The client must not assume any direct relationship between ``CAPTURE=
``
> >>> +and ``OUTPUT`` buffers and any specific timing of buffers becoming
> >>> +available to dequeue. Specifically,
> >>> +
> >>> +* a buffer queued to ``OUTPUT`` may result in no buffers being produ=
ced
> >>> +  on ``CAPTURE`` (e.g. if it does not contain encoded data, or if on=
ly
> >>> +  metadata syntax structures are present in it),
> >>> +
> >>> +* a buffer queued to ``OUTPUT`` may result in more than 1 buffer pro=
duced
> >>> +  on ``CAPTURE`` (if the encoded data contained more than one frame,=
 or if
> >>> +  returning a decoded frame allowed the decoder to return a frame th=
at
> >>> +  preceded it in decode, but succeeded it in the display order),
> >>> +
> >>> +* a buffer queued to ``OUTPUT`` may result in a buffer being produce=
d on
> >>> +  ``CAPTURE`` later into decode process, and/or after processing fur=
ther
> >>> +  ``OUTPUT`` buffers, or be returned out of order, e.g. if display
> >>> +  reordering is used,
> >>> +
> >>> +* buffers may become available on the ``CAPTURE`` queue without addi=
tional
> >>> +  buffers queued to ``OUTPUT`` (e.g. during drain or ``EOS``), becau=
se of the
> >>> +  ``OUTPUT`` buffers queued in the past whose decoding results are o=
nly
> >>> +  available at later time, due to specifics of the decoding process.
> >>> +
> >>> +.. note::
> >>> +
> >>> +   To allow matching decoded ``CAPTURE`` buffers with ``OUTPUT`` buf=
fers they
> >>> +   originated from, the client can set the ``timestamp`` field of th=
e
> >>> +   :c:type:`v4l2_buffer` struct when queuing an ``OUTPUT`` buffer. T=
he
> >>> +   ``CAPTURE`` buffer(s), which resulted from decoding that ``OUTPUT=
`` buffer
> >>> +   will have their ``timestamp`` field set to the same value when de=
queued.
> >>> +
> >>> +   In addition to the straighforward case of one ``OUTPUT`` buffer p=
roducing
>
> straighforward -> straightforward
>

Ack.

> >>> +   one ``CAPTURE`` buffer, the following cases are defined:
> >>> +
> >>> +   * one ``OUTPUT`` buffer generates multiple ``CAPTURE`` buffers: t=
he same
> >>> +     ``OUTPUT`` timestamp will be copied to multiple ``CAPTURE`` buf=
fers,
> >>> +
> >>> +   * multiple ``OUTPUT`` buffers generate one ``CAPTURE`` buffer: ti=
mestamp of
> >>> +     the ``OUTPUT`` buffer queued last will be copied,
> >>> +
> >>> +   * the decoding order differs from the display order (i.e. the
> >>> +     ``CAPTURE`` buffers are out-of-order compared to the ``OUTPUT``=
 buffers):
> >>> +     ``CAPTURE`` timestamps will not retain the order of ``OUTPUT`` =
timestamps
> >>> +     and thus monotonicity of the timestamps cannot be guaranteed.
>
> I think this last point should be rewritten. The timestamp is just a valu=
e that
> is copied, there are no monotonicity requirements for m2m devices in gene=
ral.
>

Actually I just realized the last point might not even be achievable
for some of the decoders (s5p-mfc, mtk-vcodec), as they don't report
which frame originates from which bitstream buffer and the driver just
picks the most recently consumed OUTPUT buffer to copy the timestamp
from. (s5p-mfc actually "forgets" to set the timestamp in some cases
too...)

I need to think a bit more about this.

[snip]
> >>> +Seek
> >>> +=3D=3D=3D=3D
> >>> +
> >>> +Seek is controlled by the ``OUTPUT`` queue, as it is the source of c=
oded data.
> >>> +The seek does not require any specific operation on the ``CAPTURE`` =
queue, but
> >>> +it may be affected as per normal decoder operation.
> >>> +
> >>> +1. Stop the ``OUTPUT`` queue to begin the seek sequence via
> >>> +   :c:func:`VIDIOC_STREAMOFF`.
> >>> +
> >>> +   * **Required fields:**
> >>> +
> >>> +     ``type``
> >>> +         a ``V4L2_BUF_TYPE_*`` enum appropriate for ``OUTPUT``
> >>> +
> >>> +   * The decoder will drop all the pending ``OUTPUT`` buffers and th=
ey must be
> >>> +     treated as returned to the client (following standard semantics=
).
> >>> +
> >>> +2. Restart the ``OUTPUT`` queue via :c:func:`VIDIOC_STREAMON`
> >>> +
> >>> +   * **Required fields:**
> >>> +
> >>> +     ``type``
> >>> +         a ``V4L2_BUF_TYPE_*`` enum appropriate for ``OUTPUT``
> >>> +
> >>> +   * The decoder will start accepting new source bitstream buffers a=
fter the
> >>> +     call returns.
> >>> +
> >>> +3. Start queuing buffers containing coded data after the seek to the=
 ``OUTPUT``
> >>> +   queue until a suitable resume point is found.
> >>> +
> >>> +   .. note::
> >>> +
> >>> +      There is no requirement to begin queuing coded data starting e=
xactly
> >>> +      from a resume point (e.g. SPS or a keyframe). Any queued ``OUT=
PUT``
> >>> +      buffers will be processed and returned to the client until a s=
uitable
> >>> +      resume point is found.  While looking for a resume point, the =
decoder
> >>> +      should not produce any decoded frames into ``CAPTURE`` buffers=
.
> >>> +
> >>> +      Some hardware is known to mishandle seeks to a non-resume poin=
t. Such an
> >>> +      operation may result in an unspecified number of corrupted dec=
oded frames
> >>> +      being made available on the ``CAPTURE`` queue. Drivers must en=
sure that
> >>> +      no fatal decoding errors or crashes occur, and implement any n=
ecessary
> >>> +      handling and workarounds for hardware issues related to seek o=
perations.
> >>
> >> Is there a requirement that those corrupted frames have V4L2_BUF_FLAG_=
ERROR set?
> >> I.e., can userspace detect those currupted frames?
> >>
> >
> > I think the question is whether the kernel driver can actually detect
> > those corrupted frames. We can't guarantee reporting errors to the
> > userspace, if the hardware doesn't actually report them.
> >
> > Could we perhaps keep this an open question and possibly address with
> > some extension that could be an opt in for the decoders that can
> > report errors?
>
> Hmm, how about: If the hardware can detect such corrupted decoded frames,=
 then
> it shall set V4L2_BUF_FLAG_ERROR.
>

Sounds good to me.

Actually, let me add a paragraph about error handling in the decoding
section, since it's a general problem, not limited to seeking. I can
then refer to it from the Seek sequence.

> >
> >>> +
> >>> +   .. warning::
> >>> +
> >>> +      In case of the H.264 codec, the client must take care not to s=
eek over a
> >>> +      change of SPS/PPS. Even though the target frame could be a key=
frame, the
> >>> +      stale SPS/PPS inside decoder state would lead to undefined res=
ults when
> >>> +      decoding. Although the decoder must handle such case without a=
 crash or a
> >>> +      fatal decode error, the client must not expect a sensible deco=
de output.
> >>> +
> >>> +4. After a resume point is found, the decoder will start returning `=
`CAPTURE``
> >>> +   buffers containing decoded frames.
> >>> +
> >>> +.. important::
> >>> +
> >>> +   A seek may result in the `Dynamic resolution change` sequence bei=
ng
> >>> +   iniitated, due to the seek target having decoding parameters diff=
erent from
> >>> +   the part of the stream decoded before the seek. The sequence must=
 be handled
> >>> +   as per normal decoder operation.
> >>> +
> >>> +.. warning::
> >>> +
> >>> +   It is not specified when the ``CAPTURE`` queue starts producing b=
uffers
> >>> +   containing decoded data from the ``OUTPUT`` buffers queued after =
the seek,
> >>> +   as it operates independently from the ``OUTPUT`` queue.
> >>> +
> >>> +   The decoder may return a number of remaining ``CAPTURE`` buffers =
containing
> >>> +   decoded frames originating from the ``OUTPUT`` buffers queued bef=
ore the
> >>> +   seek sequence is performed.
> >>> +
> >>> +   The ``VIDIOC_STREAMOFF`` operation discards any remaining queued
> >>> +   ``OUTPUT`` buffers, which means that not all of the ``OUTPUT`` bu=
ffers
> >>> +   queued before the seek sequence may have matching ``CAPTURE`` buf=
fers
> >>> +   produced.  For example, given the sequence of operations on the
> >>> +   ``OUTPUT`` queue:
> >>> +
> >>> +     QBUF(A), QBUF(B), STREAMOFF(), STREAMON(), QBUF(G), QBUF(H),
> >>> +
> >>> +   any of the following results on the ``CAPTURE`` queue is allowed:
> >>> +
> >>> +     {A=E2=80=99, B=E2=80=99, G=E2=80=99, H=E2=80=99}, {A=E2=80=99, =
G=E2=80=99, H=E2=80=99}, {G=E2=80=99, H=E2=80=99}.
> >>
> >> Isn't it the case that if you would want to avoid that, then you shoul=
d call
> >> DECODER_STOP, wait for the last buffer on the CAPTURE queue, then seek=
 and
> >> call DECODER_START. If you do that, then you should always get {A=E2=
=80=99, B=E2=80=99, G=E2=80=99, H=E2=80=99}.
> >> (basically following the Drain sequence).
> >
> > Yes, it is, but I think it depends on the application needs. Here we
> > just give a primitive to change the place in the stream that's being
> > decoded (or change the stream on the fly).
> >
> > Actually, with the timestamp copy, I guess we wouldn't even need to do
> > the DECODER_STOP, as we could just discard the CAPTURE buffers until
> > we get one that matches the timestamp of the first OUTPUT buffer after
> > the seek.
> >
> >>
> >> Admittedly, you typically want to do an instantaneous seek, so this is=
 probably
> >> not what you want to do normally.
> >>
> >> It might help to have this documented in a separate note.
> >>
> >
> > The instantaneous seek is documented below. I'm not sure if there is
> > any practical need to document the other case, but I could add a
> > sentence like below to the warning above. What do you think?
> >
> >    The ``VIDIOC_STREAMOFF`` operation discards any remaining queued
> >    ``OUTPUT`` buffers, which means that not all of the ``OUTPUT`` buffe=
rs
> >    queued before the seek sequence may have matching ``CAPTURE`` buffer=
s
> >    produced.  For example, given the sequence of operations on the
> >    ``OUTPUT`` queue:
> >
> >      QBUF(A), QBUF(B), STREAMOFF(), STREAMON(), QBUF(G), QBUF(H),
> >
> >    any of the following results on the ``CAPTURE`` queue is allowed:
>
> is allowed -> are allowed
>

Only one can happen at given time, so I think singular is correct
here? (i.e. Any [...] is allowed)

[snip]
> >>> diff --git a/Documentation/media/uapi/v4l/vidioc-g-fmt.rst b/Document=
ation/media/uapi/v4l/vidioc-g-fmt.rst
> >>> index 3ead350e099f..0fc0b78a943e 100644
> >>> --- a/Documentation/media/uapi/v4l/vidioc-g-fmt.rst
> >>> +++ b/Documentation/media/uapi/v4l/vidioc-g-fmt.rst
> >>> @@ -53,6 +53,13 @@ devices that is either the struct
> >>>  member. When the requested buffer type is not supported drivers retu=
rn
> >>>  an ``EINVAL`` error code.
> >>>
> >>> +A stateful mem2mem decoder will not allow operations on the
> >>> +``V4L2_BUF_TYPE_VIDEO_CAPTURE`` or ``V4L2_BUF_TYPE_VIDEO_CAPTURE_MPL=
ANE``
> >>> +buffer type until the corresponding ``V4L2_BUF_TYPE_VIDEO_OUTPUT`` o=
r
> >>> +``V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE`` buffer type is configured. If =
such an
> >>> +operation is attempted, drivers return an ``EACCES`` error code. Ref=
er to
> >>> +:ref:`decoder` for more details.
> >>
> >> This isn't right. EACCES is returned as long as the output format reso=
lution is
> >> unknown. If it is set explicitly, then this will work without an error=
.
>
> Ah, sorry, I phrased that poorly. Let me try again:
>
> This isn't right. EACCES is returned for CAPTURE operations as long as th=
e
> output format resolution is unknown or the CAPTURE format is explicitly s=
et.
> If the CAPTURE format is set explicitly, then this will work without an e=
rror.

We don't allow directly setting CAPTURE format explicitly either,
because the driver wouldn't have anything to validate the format
against. We allow the client to do it indirectly, by setting the width
and height of the OUTPUT format, which unblocks the CAPTURE format
operations, because the driver can then validate against the OUTPUT
(coded) format.

Best regards,
Tomasz
