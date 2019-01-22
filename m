Return-Path: <SRS0=JQ9q=P6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C239BC282C5
	for <linux-media@archiver.kernel.org>; Tue, 22 Jan 2019 10:02:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 44DEB2085A
	for <linux-media@archiver.kernel.org>; Tue, 22 Jan 2019 10:02:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="Shsqz6o5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728018AbfAVKCu (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 22 Jan 2019 05:02:50 -0500
Received: from mail-ot1-f43.google.com ([209.85.210.43]:46579 "EHLO
        mail-ot1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727682AbfAVKCu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Jan 2019 05:02:50 -0500
Received: by mail-ot1-f43.google.com with SMTP id w25so23068816otm.13
        for <linux-media@vger.kernel.org>; Tue, 22 Jan 2019 02:02:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=E/uJZKysJ/9LB+QmR9CExnRC9eygIGbPhkxdQxhlk+k=;
        b=Shsqz6o548Rw4W1k+v+hTTs4PEUeeuxW7gBZ6hGNG1/4NKgSP405EvAZuV9X5xk4sf
         uw0JVYI4n0NkVrLS0n/7nLdXKQAFHF1sZw0LT5JsCkH/BNP3jLPDhBVAQxHuvD3Q/4jx
         OkQH8zhQWThV0uKUjsBvC4ydFEyc+kykvEP/o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=E/uJZKysJ/9LB+QmR9CExnRC9eygIGbPhkxdQxhlk+k=;
        b=qx81L+c4jbbYcSBpnuSbcT/CGTMtD3XFu65hWeMX5XGJZlm1PbgYD/OX+qyh5p9Z6O
         /acq71nYVMTtY0FyNcOS01UCqkmUb4ARsBQl0USRtfG8MFuodAoMkXDN+vy/q4MqFbia
         eqOAWIOfLZfj+Lxd+1vFqohW98iG/RfBiJk+PGVxCvcm0jPueRFwpRXH9HrvWExt+TXF
         XyRKh2uRlCSkWFqOKWFDDmRC93V/aHokojbRr2/nT/sX5u44cy/fxe2uIXR6ZGlPH9Nb
         LfvUsY8UXmHdBod2JyQfi0gYCuZA4zWCxqjykLVggLuNqBVD6tTAJX9azunxeiV+Y8mh
         E2Ig==
X-Gm-Message-State: AJcUukeJNpY4n7zbsl9T1WrDezDFmJskm41dMGX3KLlUWjXCbtGvSJSK
        6R2VPppbyxbRiQRKmHMZHqgX1cM4mwkgLA==
X-Google-Smtp-Source: ALg8bN5WpwII7TRbIiBNtfr/mtoHz2L1Osl3q+tFh+TxbL8lYKdzs/EqM7628HAe2J5ZS0/7AS0SJw==
X-Received: by 2002:a9d:6b03:: with SMTP id g3mr22109371otp.266.1548151368071;
        Tue, 22 Jan 2019 02:02:48 -0800 (PST)
Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com. [209.85.167.171])
        by smtp.gmail.com with ESMTPSA id o16sm6816603otl.22.2019.01.22.02.02.46
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 22 Jan 2019 02:02:47 -0800 (PST)
Received: by mail-oi1-f171.google.com with SMTP id c206so16957187oib.0
        for <linux-media@vger.kernel.org>; Tue, 22 Jan 2019 02:02:46 -0800 (PST)
X-Received: by 2002:aca:4586:: with SMTP id s128mr8212149oia.182.1548151366196;
 Tue, 22 Jan 2019 02:02:46 -0800 (PST)
MIME-Version: 1.0
References: <20181022144901.113852-1-tfiga@chromium.org> <20181022144901.113852-2-tfiga@chromium.org>
 <cf0fc2fc-72c6-dbca-68f7-a349879a3a14@xs4all.nl>
In-Reply-To: <cf0fc2fc-72c6-dbca-68f7-a349879a3a14@xs4all.nl>
From:   Tomasz Figa <tfiga@chromium.org>
Date:   Tue, 22 Jan 2019 19:02:34 +0900
X-Gmail-Original-Message-ID: <CAAFQd5AORjMjHdavdr3zM13BnyFnKnEb-0aKNjvwbB_xJEnxgQ@mail.gmail.com>
Message-ID: <CAAFQd5AORjMjHdavdr3zM13BnyFnKnEb-0aKNjvwbB_xJEnxgQ@mail.gmail.com>
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

On Mon, Nov 12, 2018 at 8:37 PM Hans Verkuil <hverkuil@xs4all.nl> wrote:
>
> Hi Tomasz,
>
> A general note for the stateful and stateless patches: they describe spec=
ific
> use-cases of the more generic Codec Interface, and as such should be one
> level deeper in the section hierarchy.

I wonder what exactly this Codec Interface is. Is it a historical name
for mem2mem? If so, perhaps it would make sense to rename it?

>
> I.e. instead of being section 4.6/7/8:
>
> https://hverkuil.home.xs4all.nl/request-api/uapi/v4l/devices.html
>
> they should be 4.5.1/2/3.
>

FYI, the first RFC started like that, but it only made the spec
difficult to navigate and the section numbers too long.

Still, no strong opinion. I'm okay moving it there, if you think it's bette=
r.

> On 10/22/2018 04:48 PM, Tomasz Figa wrote:
> > Due to complexity of the video decoding process, the V4L2 drivers of
> > stateful decoder hardware require specific sequences of V4L2 API calls
> > to be followed. These include capability enumeration, initialization,
> > decoding, seek, pause, dynamic resolution change, drain and end of
> > stream.
[snipping any comments that I agree with]
> > +
> > +source height
> > +   height in pixels for given source resolution; relevant to encoders =
only
> > +
> > +source resolution
> > +   resolution in pixels of source frames being source to the encoder a=
nd
> > +   subject to further cropping to the bounds of visible resolution; re=
levant to
> > +   encoders only
> > +
> > +source width
> > +   width in pixels for given source resolution; relevant to encoders o=
nly
>
> I would drop these three terms: they are not used in this document since =
this
> describes a decoder and not an encoder.
>

The glossary is shared between encoder and decoder, as suggested in
previous round of review.

[snip]
> > +
> > +   * If width and height are set to non-zero values, the ``CAPTURE`` f=
ormat
> > +     will be updated with an appropriate frame buffer resolution insta=
ntly.
> > +     However, for coded formats that include stream resolution informa=
tion,
> > +     after the decoder is done parsing the information from the stream=
, it will
> > +     update the ``CAPTURE`` format with new values and signal a source=
 change
> > +     event.
>
> What if the initial width and height specified by userspace matches the p=
arsed
> width and height? Do you still get a source change event? I think you sho=
uld
> always get this event since there are other parameters that depend on the=
 parsing
> of the meta data.
>
> But that should be made explicit here.
>

Yes, the change event should happen always after the driver determines
the format of the stream. Will specify it explicitly.

> > +
> > +   .. warning::
>
> I'd call this a note rather than a warning.
>

I think it deserves at least the "important" level, since it informs
about the side effects of the call, affecting any actions that the
client might have done before.


> > +
> > +      Changing the ``OUTPUT`` format may change the currently set ``CA=
PTURE``
> > +      format. The decoder will derive a new ``CAPTURE`` format from th=
e
> > +      ``OUTPUT`` format being set, including resolution, colorimetry
> > +      parameters, etc. If the client needs a specific ``CAPTURE`` form=
at, it
> > +      must adjust it afterwards.
> > +
> > +3.  **Optional.** Query the minimum number of buffers required for ``O=
UTPUT``
> > +    queue via :c:func:`VIDIOC_G_CTRL`. This is useful if the client in=
tends to
> > +    use more buffers than the minimum required by hardware/format.
>
> Why is this useful? As far as I can tell only the s5p-mfc *encoder* suppo=
rts
> this control, so this seems pointless. And since the output queue gets a =
bitstream
> I don't see any reason for reading this control in a decoder.
>

Indeed, querying this for bitstream buffers probably doesn't make much
sense. I'll remove it.

> > +
> > +    * **Required fields:**
> > +
> > +      ``id``
> > +          set to ``V4L2_CID_MIN_BUFFERS_FOR_OUTPUT``
> > +
> > +    * **Return fields:**
> > +
> > +      ``value``
> > +          the minimum number of ``OUTPUT`` buffers required for the cu=
rrently
> > +          set format
> > +
> > +4.  Allocate source (bitstream) buffers via :c:func:`VIDIOC_REQBUFS` o=
n
> > +    ``OUTPUT``.
> > +
> > +    * **Required fields:**
> > +
> > +      ``count``
> > +          requested number of buffers to allocate; greater than zero
> > +
> > +      ``type``
> > +          a ``V4L2_BUF_TYPE_*`` enum appropriate for ``OUTPUT``
> > +
> > +      ``memory``
> > +          follows standard semantics
> > +
> > +    * **Return fields:**
> > +
> > +      ``count``
> > +          the actual number of buffers allocated
> > +
> > +    .. warning::
> > +
> > +       The actual number of allocated buffers may differ from the ``co=
unt``
> > +       given. The client must check the updated value of ``count`` aft=
er the
> > +       call returns.
> > +
> > +    .. note::
> > +
> > +       To allocate more than the minimum number of buffers (for pipeli=
ne
> > +       depth), the client may query the ``V4L2_CID_MIN_BUFFERS_FOR_OUT=
PUT``
> > +       control to get the minimum number of buffers required by the
> > +       decoder/format, and pass the obtained value plus the number of
> > +       additional buffers needed in the ``count`` field to
> > +       :c:func:`VIDIOC_REQBUFS`.
>
> As mentioned above, this makes no sense for stateful decoders IMHO.
>

Ack.

> > +
> > +    Alternatively, :c:func:`VIDIOC_CREATE_BUFS` on the ``OUTPUT`` queu=
e can be
> > +    used to have more control over buffer allocation.
> > +
> > +    * **Required fields:**
> > +
> > +      ``count``
> > +          requested number of buffers to allocate; greater than zero
> > +
> > +      ``type``
> > +          a ``V4L2_BUF_TYPE_*`` enum appropriate for ``OUTPUT``
> > +
> > +      ``memory``
> > +          follows standard semantics
> > +
> > +      ``format``
> > +          follows standard semantics
> > +
> > +    * **Return fields:**
> > +
> > +      ``count``
> > +          adjusted to the number of allocated buffers
> > +
> > +    .. warning::
> > +
> > +       The actual number of allocated buffers may differ from the ``co=
unt``
> > +       given. The client must check the updated value of ``count`` aft=
er the
> > +       call returns.
> > +
> > +5.  Start streaming on the ``OUTPUT`` queue via :c:func:`VIDIOC_STREAM=
ON`.
> > +
> > +6.  **This step only applies to coded formats that contain resolution =
information
> > +    in the stream.** Continue queuing/dequeuing bitstream buffers to/f=
rom the
> > +    ``OUTPUT`` queue via :c:func:`VIDIOC_QBUF` and :c:func:`VIDIOC_DQB=
UF`. The
> > +    buffers will be processed and returned to the client in order, unt=
il
> > +    required metadata to configure the ``CAPTURE`` queue are found. Th=
is is
> > +    indicated by the decoder sending a ``V4L2_EVENT_SOURCE_CHANGE`` ev=
ent with
> > +    ``V4L2_EVENT_SRC_CH_RESOLUTION`` source change type.
> > +
> > +    * It is not an error if the first buffer does not contain enough d=
ata for
> > +      this to occur. Processing of the buffers will continue as long a=
s more
> > +      data is needed.
> > +
> > +    * If data in a buffer that triggers the event is required to decod=
e the
> > +      first frame, it will not be returned to the client, until the
> > +      initialization sequence completes and the frame is decoded.
> > +
> > +    * If the client sets width and height of the ``OUTPUT`` format to =
0,
> > +      calling :c:func:`VIDIOC_G_FMT`, :c:func:`VIDIOC_S_FMT` or
> > +      :c:func:`VIDIOC_TRY_FMT` on the ``CAPTURE`` queue will return th=
e
> > +      ``-EACCES`` error code, until the decoder configures ``CAPTURE``=
 format
> > +      according to stream metadata.
> > +
> > +    .. important::
> > +
> > +       Any client query issued after the decoder queues the event will=
 return
> > +       values applying to the just parsed stream, including queue form=
ats,
> > +       selection rectangles and controls.
> > +
> > +    .. note::
> > +
> > +       A client capable of acquiring stream parameters from the bitstr=
eam on
> > +       its own may attempt to set the width and height of the ``OUTPUT=
`` format
> > +       to non-zero values matching the coded size of the stream, skip =
this step
> > +       and continue with the `Capture setup` sequence. However, it mus=
t not
> > +       rely on any driver queries regarding stream parameters, such as
> > +       selection rectangles and controls, since the decoder has not pa=
rsed them
> > +       from the stream yet. If the values configured by the client do =
not match
> > +       those parsed by the decoder, a `Dynamic resolution change` will=
 be
> > +       triggered to reconfigure them.
> > +
> > +    .. note::
> > +
> > +       No decoded frames are produced during this phase.
> > +
> > +7.  Continue with the `Capture setup` sequence.
> > +
> > +Capture setup
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > +
> > +1.  Call :c:func:`VIDIOC_G_FMT` on the ``CAPTURE`` queue to get format=
 for the
> > +    destination buffers parsed/decoded from the bitstream.
> > +
> > +    * **Required fields:**
> > +
> > +      ``type``
> > +          a ``V4L2_BUF_TYPE_*`` enum appropriate for ``CAPTURE``
> > +
> > +    * **Return fields:**
> > +
> > +      ``width``, ``height``
> > +          frame buffer resolution for the decoded frames
> > +
> > +      ``pixelformat``
> > +          pixel format for decoded frames
> > +
> > +      ``num_planes`` (for _MPLANE ``type`` only)
> > +          number of planes for pixelformat
> > +
> > +      ``sizeimage``, ``bytesperline``
> > +          as per standard semantics; matching frame buffer format
> > +
> > +    .. note::
> > +
> > +       The value of ``pixelformat`` may be any pixel format supported =
by the
> > +       decoder for the current stream. The decoder should choose a
> > +       preferred/optimal format for the default configuration. For exa=
mple, a
> > +       YUV format may be preferred over an RGB format if an additional
> > +       conversion step would be required for the latter.
> > +
> > +2.  **Optional.** Acquire the visible resolution via
> > +    :c:func:`VIDIOC_G_SELECTION`.
> > +
> > +    * **Required fields:**
> > +
> > +      ``type``
> > +          a ``V4L2_BUF_TYPE_*`` enum appropriate for ``CAPTURE``
> > +
> > +      ``target``
> > +          set to ``V4L2_SEL_TGT_COMPOSE``
> > +
> > +    * **Return fields:**
> > +
> > +      ``r.left``, ``r.top``, ``r.width``, ``r.height``
> > +          the visible rectangle; it must fit within the frame buffer r=
esolution
> > +          returned by :c:func:`VIDIOC_G_FMT` on ``CAPTURE``.
> > +
> > +    * The following selection targets are supported on ``CAPTURE``:
> > +
> > +      ``V4L2_SEL_TGT_CROP_BOUNDS``
> > +          corresponds to the coded resolution of the stream
> > +
> > +      ``V4L2_SEL_TGT_CROP_DEFAULT``
> > +          the rectangle covering the part of the ``CAPTURE`` buffer th=
at
> > +          contains meaningful picture data (visible area); width and h=
eight
> > +          will be equal to the visible resolution of the stream
> > +
> > +      ``V4L2_SEL_TGT_CROP``
> > +          the rectangle within the coded resolution to be output to
> > +          ``CAPTURE``; defaults to ``V4L2_SEL_TGT_CROP_DEFAULT``; read=
-only on
> > +          hardware without additional compose/scaling capabilities
> > +
> > +      ``V4L2_SEL_TGT_COMPOSE_BOUNDS``
> > +          the maximum rectangle within a ``CAPTURE`` buffer, which the=
 cropped
> > +          frame can be output into; equal to ``V4L2_SEL_TGT_CROP`` if =
the
> > +          hardware does not support compose/scaling
> > +
> > +      ``V4L2_SEL_TGT_COMPOSE_DEFAULT``
> > +          equal to ``V4L2_SEL_TGT_CROP``
> > +
> > +      ``V4L2_SEL_TGT_COMPOSE``
> > +          the rectangle inside a ``CAPTURE`` buffer into which the cro=
pped
> > +          frame is written; defaults to ``V4L2_SEL_TGT_COMPOSE_DEFAULT=
``;
> > +          read-only on hardware without additional compose/scaling cap=
abilities
> > +
> > +      ``V4L2_SEL_TGT_COMPOSE_PADDED``
> > +          the rectangle inside a ``CAPTURE`` buffer which is overwritt=
en by the
> > +          hardware; equal to ``V4L2_SEL_TGT_COMPOSE`` if the hardware =
does not
> > +          write padding pixels
> > +
> > +    .. warning::
> > +
> > +       The values are guaranteed to be meaningful only after the decod=
er
> > +       successfully parses the stream metadata. The client must not re=
ly on the
> > +       query before that happens.
> > +
> > +3.  Query the minimum number of buffers required for the ``CAPTURE`` q=
ueue via
> > +    :c:func:`VIDIOC_G_CTRL`. This is useful if the client intends to u=
se more
> > +    buffers than the minimum required by hardware/format.
>
> Is this step optional or required? Can it change when a resolution change=
 occurs?

Probably not with a simple resolution change, but a case when a stream
is changed on the fly would trigger what we call "resolution change"
here, but what would effectively be a "source change" and that could
include a change in the number of required CAPTURE buffers.

> How does this relate to the checks for the minimum number of buffers that=
 REQBUFS
> does?

The control returns the minimum that REQBUFS would allow, so the
application can add few more buffers on top of that and improve the
pipelining.

>
> The 'This is useful if' sentence suggests that it is optional, but I thin=
k that
> sentence just confuses the issue.
>

It used to be optional and I didn't rephrase it after turning it into
mandatory. How about:

    This enables the client to request more buffers
    than the minimum required by hardware/format and achieve better pipelin=
ing.

> > +
> > +    * **Required fields:**
> > +
> > +      ``id``
> > +          set to ``V4L2_CID_MIN_BUFFERS_FOR_CAPTURE``
> > +
> > +    * **Return fields:**
> > +
> > +      ``value``
> > +          minimum number of buffers required to decode the stream pars=
ed in
> > +          this initialization sequence.
> > +
> > +    .. note::
> > +
> > +       The minimum number of buffers must be at least the number requi=
red to
> > +       successfully decode the current stream. This may for example be=
 the
> > +       required DPB size for an H.264 stream given the parsed stream
> > +       configuration (resolution, level).
> > +
> > +    .. warning::
> > +
> > +       The value is guaranteed to be meaningful only after the decoder
> > +       successfully parses the stream metadata. The client must not re=
ly on the
> > +       query before that happens.
> > +
> > +4.  **Optional.** Enumerate ``CAPTURE`` formats via :c:func:`VIDIOC_EN=
UM_FMT` on
> > +    the ``CAPTURE`` queue. Once the stream information is parsed and k=
nown, the
> > +    client may use this ioctl to discover which raw formats are suppor=
ted for
> > +    given stream and select one of them via :c:func:`VIDIOC_S_FMT`.
>
> Can the list returned here differ from the list returned in the 'Querying=
 capabilities'
> step? If so, then I assume it will always be a subset of what was returne=
d in
> the 'Querying' step?

Depends on whether you're considering just VIDIOC_ENUM_FMT or also
VIDIOC_G_FMT and VIDIOC_ENUM_FRAMESIZES.

The initial VIDIOC_ENUM_FMT has no way to account for any resolution
constraints of the formats, so the list would include all raw pixel
formats that the decoder can handle with selected coded pixel format.
However, the list can be further narrowed down by using
VIDIOC_ENUM_FRAMESIZES, to restrict each raw format only to the
resolutions it can handle.

The VIDIOC_ENUM_FMT call in this sequence (after getting the stream
information) would have the knowledge about the resolution, so the
list returned here would only include the formats that can be actually
handled. It should match the result of the initial query using both
VIDIOC_ENUM_FMT and VIDIOC_ENUM_FRAMESIZES.

>
> > +
> > +    .. important::
> > +
> > +       The decoder will return only formats supported for the currentl=
y
> > +       established coded format, as per the ``OUTPUT`` format and/or s=
tream
> > +       metadata parsed in this initialization sequence, even if more f=
ormats
> > +       may be supported by the decoder in general.
> > +
> > +       For example, a decoder may support YUV and RGB formats for reso=
lutions
> > +       1920x1088 and lower, but only YUV for higher resolutions (due t=
o
> > +       hardware limitations). After parsing a resolution of 1920x1088 =
or lower,
> > +       :c:func:`VIDIOC_ENUM_FMT` may return a set of YUV and RGB pixel=
 formats,
> > +       but after parsing resolution higher than 1920x1088, the decoder=
 will not
> > +       return RGB, unsupported for this resolution.
> > +
> > +       However, subsequent resolution change event triggered after
> > +       discovering a resolution change within the same stream may swit=
ch
> > +       the stream into a lower resolution and :c:func:`VIDIOC_ENUM_FMT=
`
> > +       would return RGB formats again in that case.
> > +
> > +5.  **Optional.** Set the ``CAPTURE`` format via :c:func:`VIDIOC_S_FMT=
` on the
> > +    ``CAPTURE`` queue. The client may choose a different format than
> > +    selected/suggested by the decoder in :c:func:`VIDIOC_G_FMT`.
> > +
> > +    * **Required fields:**
> > +
> > +      ``type``
> > +          a ``V4L2_BUF_TYPE_*`` enum appropriate for ``CAPTURE``
> > +
> > +      ``pixelformat``
> > +          a raw pixel format
> > +
> > +    .. note::
> > +
> > +       The client may use :c:func:`VIDIOC_ENUM_FMT` after receiving th=
e
> > +       ``V4L2_EVENT_SOURCE_CHANGE`` event to find out the set of raw f=
ormats
> > +       supported for the stream.
>
> Isn't this a duplicate of step 4? I think this note can be dropped.
>

Ack.

> > +
> > +6.  If all the following conditions are met, the client may resume the=
 decoding
> > +    instantly:
> > +
> > +    * ``sizeimage`` of the new format (determined in previous steps) i=
s less
> > +      than or equal to the size of currently allocated buffers,
> > +
> > +    * the number of buffers currently allocated is greater than or equ=
al to the
> > +      minimum number of buffers acquired in previous steps. To fulfill=
 this
> > +      requirement, the client may use :c:func:`VIDIOC_CREATE_BUFS` to =
add new
> > +      buffers.
> > +
> > +    In such case, the remaining steps do not apply and the client may =
resume
> > +    the decoding by one of the following actions:
> > +
> > +    * if the ``CAPTURE`` queue is streaming, call :c:func:`VIDIOC_DECO=
DER_CMD`
> > +      with the ``V4L2_DEC_CMD_START`` command,
> > +
> > +    * if the ``CAPTURE`` queue is not streaming, call :c:func:`VIDIOC_=
STREAMON`
> > +      on the ``CAPTURE`` queue.
> > +
> > +    However, if the client intends to change the buffer set, to lower
> > +    memory usage or for any other reasons, it may be achieved by follo=
wing
> > +    the steps below.
> > +
> > +7.  **If the** ``CAPTURE`` **queue is streaming,** keep queuing and de=
queuing
> > +    buffers on the ``CAPTURE`` queue until a buffer marked with the
> > +    ``V4L2_BUF_FLAG_LAST`` flag is dequeued.
> > +
> > +8.  **If the** ``CAPTURE`` **queue is streaming,** call :c:func:`VIDIO=
C_STREAMOFF`
> > +    on the ``CAPTURE`` queue to stop streaming.
> > +
> > +    .. warning::
> > +
> > +       The ``OUTPUT`` queue must remain streaming. Calling
> > +       :c:func:`VIDIOC_STREAMOFF` on it would abort the sequence and t=
rigger a
> > +       seek.
> > +
> > +9.  **If the** ``CAPTURE`` **queue has buffers allocated,** free the `=
`CAPTURE``
> > +    buffers using :c:func:`VIDIOC_REQBUFS`.
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
> > +10. Allocate ``CAPTURE`` buffers via :c:func:`VIDIOC_REQBUFS` on the
> > +    ``CAPTURE`` queue.
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
> > +          actual number of buffers allocated
> > +
> > +    .. warning::
> > +
> > +       The actual number of allocated buffers may differ from the ``co=
unt``
> > +       given. The client must check the updated value of ``count`` aft=
er the
> > +       call returns.
> > +
> > +    .. note::
> > +
> > +       To allocate more than the minimum number of buffers (for pipeli=
ne
> > +       depth), the client may query the ``V4L2_CID_MIN_BUFFERS_FOR_CAP=
TURE``
> > +       control to get the minimum number of buffers required, and pass=
 the
> > +       obtained value plus the number of additional buffers needed in =
the
> > +       ``count`` field to :c:func:`VIDIOC_REQBUFS`.
>
> Same question as before: is it optional or required to obtain the value o=
f this
> control? And can't the driver just set the min_buffers_needed field in th=
e capture
> vb2_queue to the minimum number of buffers that are required?

min_buffers_needed is the number of buffers that must be queued before
start_streaming() can be called, so not relevant here. The control is
about the number of buffers to be allocated. Although the drivers must
ensure that REQBUFS allocates the absolute minimum number of buffers
for the decoding to be able to progress, the pipeline depth is
something that the applications should control (e.g. depending on the
consumers of the decoded buffers) and this is allowed by this control.

>
> Should you be allowed to allocate buffers at all if the capture format is=
n't
> known? I.e. width/height is still 0. It makes no sense to call REQBUFS si=
nce
> there is no format size known that REQBUFS can use.
>

Indeed, REQBUFS(CAPTURE) must not be allowed before the stream
information is known (regardless of whether it comes from the OUTPUT
format or is parsed from the stream). Let me add this to the related
note in the Initialization sequence, which already includes
VIDIOC_*_FMT.

For the Capture setup sequence, though, it's expected to happen when
the stream information is already known, so I wouldn't change the
description here.

> > +
> > +    Alternatively, :c:func:`VIDIOC_CREATE_BUFS` on the ``CAPTURE`` que=
ue can be
> > +    used to have more control over buffer allocation. For example, by
> > +    allocating buffers larger than the current ``CAPTURE`` format, fut=
ure
> > +    resolution changes can be accommodated.
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
> > +      ``format``
> > +          a format representing the maximum framebuffer resolution to =
be
> > +          accommodated by newly allocated buffers
> > +
> > +    * **Return fields:**
> > +
> > +      ``count``
> > +          adjusted to the number of allocated buffers
> > +
> > +    .. warning::
> > +
> > +       The actual number of allocated buffers may differ from the ``co=
unt``
> > +       given. The client must check the updated value of ``count`` aft=
er the
> > +       call returns.
> > +
> > +    .. note::
> > +
> > +       To allocate buffers for a format different than parsed from the=
 stream
> > +       metadata, the client must proceed as follows, before the metada=
ta
> > +       parsing is initiated:
> > +
> > +       * set width and height of the ``OUTPUT`` format to desired code=
d resolution to
> > +         let the decoder configure the ``CAPTURE`` format appropriatel=
y,
> > +
> > +       * query the ``CAPTURE`` format using :c:func:`VIDIOC_G_FMT` and=
 save it
> > +         until this step.
> > +
> > +       The format obtained in the query may be then used with
> > +       :c:func:`VIDIOC_CREATE_BUFS` in this step to allocate the buffe=
rs.
> > +
> > +11. Call :c:func:`VIDIOC_STREAMON` on the ``CAPTURE`` queue to start d=
ecoding
> > +    frames.
> > +
> > +Decoding
> > +=3D=3D=3D=3D=3D=3D=3D=3D
> > +
> > +This state is reached after the `Capture setup` sequence finishes succ=
esfully.
> > +In this state, the client queues and dequeues buffers to both queues v=
ia
> > +:c:func:`VIDIOC_QBUF` and :c:func:`VIDIOC_DQBUF`, following the standa=
rd
> > +semantics.
> > +
> > +The contents of the source ``OUTPUT`` buffers depend on the active cod=
ed pixel
> > +format and may be affected by codec-specific extended controls, as sta=
ted in
> > +the documentation of each format.
> > +
> > +Both queues operate independently, following the standard behavior of =
V4L2
> > +buffer queues and memory-to-memory devices. In addition, the order of =
decoded
> > +frames dequeued from the ``CAPTURE`` queue may differ from the order o=
f queuing
> > +coded frames to the ``OUTPUT`` queue, due to properties of the selecte=
d coded
> > +format, e.g. frame reordering.
> > +
> > +The client must not assume any direct relationship between ``CAPTURE``
> > +and ``OUTPUT`` buffers and any specific timing of buffers becoming
> > +available to dequeue. Specifically,
> > +
> > +* a buffer queued to ``OUTPUT`` may result in no buffers being produce=
d
> > +  on ``CAPTURE`` (e.g. if it does not contain encoded data, or if only
> > +  metadata syntax structures are present in it),
> > +
> > +* a buffer queued to ``OUTPUT`` may result in more than 1 buffer produ=
ced
> > +  on ``CAPTURE`` (if the encoded data contained more than one frame, o=
r if
> > +  returning a decoded frame allowed the decoder to return a frame that
> > +  preceded it in decode, but succeeded it in the display order),
> > +
> > +* a buffer queued to ``OUTPUT`` may result in a buffer being produced =
on
> > +  ``CAPTURE`` later into decode process, and/or after processing furth=
er
> > +  ``OUTPUT`` buffers, or be returned out of order, e.g. if display
> > +  reordering is used,
> > +
> > +* buffers may become available on the ``CAPTURE`` queue without additi=
onal
> > +  buffers queued to ``OUTPUT`` (e.g. during drain or ``EOS``), because=
 of the
> > +  ``OUTPUT`` buffers queued in the past whose decoding results are onl=
y
> > +  available at later time, due to specifics of the decoding process.
> > +
> > +.. note::
> > +
> > +   To allow matching decoded ``CAPTURE`` buffers with ``OUTPUT`` buffe=
rs they
> > +   originated from, the client can set the ``timestamp`` field of the
> > +   :c:type:`v4l2_buffer` struct when queuing an ``OUTPUT`` buffer. The
> > +   ``CAPTURE`` buffer(s), which resulted from decoding that ``OUTPUT``=
 buffer
> > +   will have their ``timestamp`` field set to the same value when dequ=
eued.
> > +
> > +   In addition to the straighforward case of one ``OUTPUT`` buffer pro=
ducing
> > +   one ``CAPTURE`` buffer, the following cases are defined:
> > +
> > +   * one ``OUTPUT`` buffer generates multiple ``CAPTURE`` buffers: the=
 same
> > +     ``OUTPUT`` timestamp will be copied to multiple ``CAPTURE`` buffe=
rs,
> > +
> > +   * multiple ``OUTPUT`` buffers generate one ``CAPTURE`` buffer: time=
stamp of
> > +     the ``OUTPUT`` buffer queued last will be copied,
> > +
> > +   * the decoding order differs from the display order (i.e. the
> > +     ``CAPTURE`` buffers are out-of-order compared to the ``OUTPUT`` b=
uffers):
> > +     ``CAPTURE`` timestamps will not retain the order of ``OUTPUT`` ti=
mestamps
> > +     and thus monotonicity of the timestamps cannot be guaranteed.
>
> Should stateful codecs be required to support 'tags'? See:
>
> https://www.mail-archive.com/linux-media@vger.kernel.org/msg136314.html
>
> To be honest, I'm inclined to require this for all m2m devices eventually=
.
>

I guess this goes outside of the scope now, since we deferred tags.

Other than that, I would indeed make all m2m devices support tags,
since it shouldn't differ from the timestamp copy feature as we have
now.

> > +
> > +During the decoding, the decoder may initiate one of the special seque=
nces, as
> > +listed below. The sequences will result in the decoder returning all t=
he
> > +``CAPTURE`` buffers that originated from all the ``OUTPUT`` buffers pr=
ocessed
> > +before the sequence started. Last of the buffers will have the
> > +``V4L2_BUF_FLAG_LAST`` flag set. To determine the sequence to follow, =
the client
> > +must check if there is any pending event and,
> > +
> > +* if a ``V4L2_EVENT_SOURCE_CHANGE`` event is pending, the `Dynamic res=
olution
> > +  change` sequence needs to be followed,
> > +
> > +* if a ``V4L2_EVENT_EOS`` event is pending, the `End of stream` sequen=
ce needs
> > +  to be followed.
> > +
> > +Some of the sequences can be intermixed with each other and need to be=
 handled
> > +as they happen. The exact operation is documented for each sequence.
> > +
> > +Seek
> > +=3D=3D=3D=3D
> > +
> > +Seek is controlled by the ``OUTPUT`` queue, as it is the source of cod=
ed data.
> > +The seek does not require any specific operation on the ``CAPTURE`` qu=
eue, but
> > +it may be affected as per normal decoder operation.
> > +
> > +1. Stop the ``OUTPUT`` queue to begin the seek sequence via
> > +   :c:func:`VIDIOC_STREAMOFF`.
> > +
> > +   * **Required fields:**
> > +
> > +     ``type``
> > +         a ``V4L2_BUF_TYPE_*`` enum appropriate for ``OUTPUT``
> > +
> > +   * The decoder will drop all the pending ``OUTPUT`` buffers and they=
 must be
> > +     treated as returned to the client (following standard semantics).
> > +
> > +2. Restart the ``OUTPUT`` queue via :c:func:`VIDIOC_STREAMON`
> > +
> > +   * **Required fields:**
> > +
> > +     ``type``
> > +         a ``V4L2_BUF_TYPE_*`` enum appropriate for ``OUTPUT``
> > +
> > +   * The decoder will start accepting new source bitstream buffers aft=
er the
> > +     call returns.
> > +
> > +3. Start queuing buffers containing coded data after the seek to the `=
`OUTPUT``
> > +   queue until a suitable resume point is found.
> > +
> > +   .. note::
> > +
> > +      There is no requirement to begin queuing coded data starting exa=
ctly
> > +      from a resume point (e.g. SPS or a keyframe). Any queued ``OUTPU=
T``
> > +      buffers will be processed and returned to the client until a sui=
table
> > +      resume point is found.  While looking for a resume point, the de=
coder
> > +      should not produce any decoded frames into ``CAPTURE`` buffers.
> > +
> > +      Some hardware is known to mishandle seeks to a non-resume point.=
 Such an
> > +      operation may result in an unspecified number of corrupted decod=
ed frames
> > +      being made available on the ``CAPTURE`` queue. Drivers must ensu=
re that
> > +      no fatal decoding errors or crashes occur, and implement any nec=
essary
> > +      handling and workarounds for hardware issues related to seek ope=
rations.
>
> Is there a requirement that those corrupted frames have V4L2_BUF_FLAG_ERR=
OR set?
> I.e., can userspace detect those currupted frames?
>

I think the question is whether the kernel driver can actually detect
those corrupted frames. We can't guarantee reporting errors to the
userspace, if the hardware doesn't actually report them.

Could we perhaps keep this an open question and possibly address with
some extension that could be an opt in for the decoders that can
report errors?

> > +
> > +   .. warning::
> > +
> > +      In case of the H.264 codec, the client must take care not to see=
k over a
> > +      change of SPS/PPS. Even though the target frame could be a keyfr=
ame, the
> > +      stale SPS/PPS inside decoder state would lead to undefined resul=
ts when
> > +      decoding. Although the decoder must handle such case without a c=
rash or a
> > +      fatal decode error, the client must not expect a sensible decode=
 output.
> > +
> > +4. After a resume point is found, the decoder will start returning ``C=
APTURE``
> > +   buffers containing decoded frames.
> > +
> > +.. important::
> > +
> > +   A seek may result in the `Dynamic resolution change` sequence being
> > +   iniitated, due to the seek target having decoding parameters differ=
ent from
> > +   the part of the stream decoded before the seek. The sequence must b=
e handled
> > +   as per normal decoder operation.
> > +
> > +.. warning::
> > +
> > +   It is not specified when the ``CAPTURE`` queue starts producing buf=
fers
> > +   containing decoded data from the ``OUTPUT`` buffers queued after th=
e seek,
> > +   as it operates independently from the ``OUTPUT`` queue.
> > +
> > +   The decoder may return a number of remaining ``CAPTURE`` buffers co=
ntaining
> > +   decoded frames originating from the ``OUTPUT`` buffers queued befor=
e the
> > +   seek sequence is performed.
> > +
> > +   The ``VIDIOC_STREAMOFF`` operation discards any remaining queued
> > +   ``OUTPUT`` buffers, which means that not all of the ``OUTPUT`` buff=
ers
> > +   queued before the seek sequence may have matching ``CAPTURE`` buffe=
rs
> > +   produced.  For example, given the sequence of operations on the
> > +   ``OUTPUT`` queue:
> > +
> > +     QBUF(A), QBUF(B), STREAMOFF(), STREAMON(), QBUF(G), QBUF(H),
> > +
> > +   any of the following results on the ``CAPTURE`` queue is allowed:
> > +
> > +     {A=E2=80=99, B=E2=80=99, G=E2=80=99, H=E2=80=99}, {A=E2=80=99, G=
=E2=80=99, H=E2=80=99}, {G=E2=80=99, H=E2=80=99}.
>
> Isn't it the case that if you would want to avoid that, then you should c=
all
> DECODER_STOP, wait for the last buffer on the CAPTURE queue, then seek an=
d
> call DECODER_START. If you do that, then you should always get {A=E2=80=
=99, B=E2=80=99, G=E2=80=99, H=E2=80=99}.
> (basically following the Drain sequence).

Yes, it is, but I think it depends on the application needs. Here we
just give a primitive to change the place in the stream that's being
decoded (or change the stream on the fly).

Actually, with the timestamp copy, I guess we wouldn't even need to do
the DECODER_STOP, as we could just discard the CAPTURE buffers until
we get one that matches the timestamp of the first OUTPUT buffer after
the seek.

>
> Admittedly, you typically want to do an instantaneous seek, so this is pr=
obably
> not what you want to do normally.
>
> It might help to have this documented in a separate note.
>

The instantaneous seek is documented below. I'm not sure if there is
any practical need to document the other case, but I could add a
sentence like below to the warning above. What do you think?

   The ``VIDIOC_STREAMOFF`` operation discards any remaining queued
   ``OUTPUT`` buffers, which means that not all of the ``OUTPUT`` buffers
   queued before the seek sequence may have matching ``CAPTURE`` buffers
   produced.  For example, given the sequence of operations on the
   ``OUTPUT`` queue:

     QBUF(A), QBUF(B), STREAMOFF(), STREAMON(), QBUF(G), QBUF(H),

   any of the following results on the ``CAPTURE`` queue is allowed:

     {A=E2=80=99, B=E2=80=99, G=E2=80=99, H=E2=80=99}, {A=E2=80=99, G=E2=80=
=99, H=E2=80=99}, {G=E2=80=99, H=E2=80=99}.

   To determine the CAPTURE buffer containing the first decoded frame
after the seek,
   the client may observe the timestamps to match the CAPTURE and OUTPUT bu=
ffers
   or use V4L2_DEC_CMD_STOP and V4L2_DEC_CMD_START to drain the decoder.

> > +
> > +.. note::
> > +
> > +   To achieve instantaneous seek, the client may restart streaming on =
the
> > +   ``CAPTURE`` queue too to discard decoded, but not yet dequeued buff=
ers.
> > +
> > +Dynamic resolution change
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
> > +
> > +Streams that include resolution metadata in the bitstream may require =
switching
> > +to a different resolution during the decoding.
> > +
> > +The sequence starts when the decoder detects a coded frame with one or=
 more of
> > +the following parameters different from previously established (and re=
flected
> > +by corresponding queries):
> > +
> > +* coded resolution (``OUTPUT`` width and height),
> > +
> > +* visible resolution (selection rectangles),
> > +
> > +* the minimum number of buffers needed for decoding.
> > +
> > +Whenever that happens, the decoder must proceed as follows:
> > +
> > +1.  After encountering a resolution change in the stream, the decoder =
sends a
> > +    ``V4L2_EVENT_SOURCE_CHANGE`` event with source change type set to
> > +    ``V4L2_EVENT_SRC_CH_RESOLUTION``.
> > +
> > +    .. important::
> > +
> > +       Any client query issued after the decoder queues the event will=
 return
> > +       values applying to the stream after the resolution change, incl=
uding
> > +       queue formats, selection rectangles and controls.
> > +
> > +2.  The decoder will then process and decode all remaining buffers fro=
m before
> > +    the resolution change point.
> > +
> > +    * The last buffer from before the change must be marked with the
> > +      ``V4L2_BUF_FLAG_LAST`` flag, similarly to the `Drain` sequence a=
bove.
> > +
> > +    .. warning::
> > +
> > +       The last buffer may be empty (with :c:type:`v4l2_buffer` ``byte=
sused``
> > +       =3D 0) and in such case it must be ignored by the client, as it=
 does not
> > +       contain a decoded frame.
> > +
> > +    .. note::
> > +
> > +       Any attempt to dequeue more buffers beyond the buffer marked wi=
th
> > +       ``V4L2_BUF_FLAG_LAST`` will result in a -EPIPE error from
> > +       :c:func:`VIDIOC_DQBUF`.
> > +
> > +The client must continue the sequence as described below to continue t=
he
> > +decoding process.
> > +
> > +1.  Dequeue the source change event.
> > +
> > +    .. important::
> > +
> > +       A source change triggers an implicit decoder drain, similar to =
the
> > +       explicit `Drain` sequence. The decoder is stopped after it comp=
letes.
> > +       The decoding process must be resumed with either a pair of call=
s to
> > +       :c:func:`VIDIOC_STREAMOFF` and :c:func:`VIDIOC_STREAMON` on the
> > +       ``CAPTURE`` queue, or a call to :c:func:`VIDIOC_DECODER_CMD` wi=
th the
> > +       ``V4L2_DEC_CMD_START`` command.
> > +
> > +2.  Continue with the `Capture setup` sequence.
> > +
> > +.. note::
> > +
> > +   During the resolution change sequence, the ``OUTPUT`` queue must re=
main
> > +   streaming. Calling :c:func:`VIDIOC_STREAMOFF` on the ``OUTPUT`` que=
ue would
> > +   abort the sequence and initiate a seek.
> > +
> > +   In principle, the ``OUTPUT`` queue operates separately from the ``C=
APTURE``
> > +   queue and this remains true for the duration of the entire resoluti=
on change
> > +   sequence as well.
> > +
> > +   The client should, for best performance and simplicity, keep queuin=
g/dequeuing
> > +   buffers to/from the ``OUTPUT`` queue even while processing this seq=
uence.
> > +
> > +Drain
> > +=3D=3D=3D=3D=3D
> > +
> > +To ensure that all queued ``OUTPUT`` buffers have been processed and r=
elated
> > +``CAPTURE`` buffers output to the client, the client must follow the d=
rain
> > +sequence described below. After the drain sequence ends, the client ha=
s
> > +received all decoded frames for all ``OUTPUT`` buffers queued before t=
he
> > +sequence was started.
> > +
> > +1. Begin drain by issuing :c:func:`VIDIOC_DECODER_CMD`.
> > +
> > +   * **Required fields:**
> > +
> > +     ``cmd``
> > +         set to ``V4L2_DEC_CMD_STOP``
> > +
> > +     ``flags``
> > +         set to 0
> > +
> > +     ``pts``
> > +         set to 0
> > +
> > +   .. warning::
> > +
> > +   The sentence can be only initiated if both ``OUTPUT`` and ``CAPTURE=
`` queues
>
> 'sentence'? You mean 'decoder command'?

Sequence. :)

>
> > +   are streaming. For compatibility reasons, the call to
> > +   :c:func:`VIDIOC_DECODER_CMD` will not fail even if any of the queue=
s is not
> > +   streaming, but at the same time it will not initiate the `Drain` se=
quence
> > +   and so the steps described below would not be applicable.
> > +
> > +2. Any ``OUTPUT`` buffers queued by the client before the
> > +   :c:func:`VIDIOC_DECODER_CMD` was issued will be processed and decod=
ed as
> > +   normal. The client must continue to handle both queues independentl=
y,
> > +   similarly to normal decode operation. This includes,
> > +
> > +   * handling any operations triggered as a result of processing those=
 buffers,
> > +     such as the `Dynamic resolution change` sequence, before continui=
ng with
> > +     the drain sequence,
> > +
> > +   * queuing and dequeuing ``CAPTURE`` buffers, until a buffer marked =
with the
> > +     ``V4L2_BUF_FLAG_LAST`` flag is dequeued,
> > +
> > +     .. warning::
> > +
> > +        The last buffer may be empty (with :c:type:`v4l2_buffer`
> > +        ``bytesused`` =3D 0) and in such case it must be ignored by th=
e client,
> > +        as it does not contain a decoded frame.
> > +
> > +     .. note::
> > +
> > +        Any attempt to dequeue more buffers beyond the buffer marked w=
ith
> > +        ``V4L2_BUF_FLAG_LAST`` will result in a -EPIPE error from
> > +        :c:func:`VIDIOC_DQBUF`.
> > +
> > +   * dequeuing processed ``OUTPUT`` buffers, until all the buffers que=
ued
> > +     before the ``V4L2_DEC_CMD_STOP`` command are dequeued.
> > +
> > +   * dequeuing the ``V4L2_EVENT_EOS`` event, if the client subscribed =
to it.
> > +
> > +   .. note::
> > +
> > +      For backwards compatibility, the decoder will signal a ``V4L2_EV=
ENT_EOS``
> > +      event when the last the last frame has been decoded and all fram=
es are
>
> 'the last the last' -> the last

Ack.

>
> > +      ready to be dequeued. It is a deprecated behavior and the client=
 must not
> > +      rely on it. The ``V4L2_BUF_FLAG_LAST`` buffer flag should be use=
d
> > +      instead.
> > +
> > +3. Once all the ``OUTPUT`` buffers queued before the ``V4L2_DEC_CMD_ST=
OP`` call
> > +   and the last ``CAPTURE`` buffer are dequeued, the decoder is stoppe=
d and it
>
> This sentence is a bit confusing. This is better IMHO:
>
> 3. Once all the ``OUTPUT`` buffers queued before the ``V4L2_DEC_CMD_STOP`=
` call
>    are dequeued and the last ``CAPTURE`` buffer is dequeued, the decoder =
is stopped and it
>

Ack.

> > +   will accept, but not process any newly queued ``OUTPUT`` buffers un=
til the
>
> process any -> process, any
>

Ack.

> > +   client issues any of the following operations:
> > +
> > +   * ``V4L2_DEC_CMD_START`` - the decoder will resume the operation no=
rmally,
> > +
> > +   * a pair of :c:func:`VIDIOC_STREAMOFF` and :c:func:`VIDIOC_STREAMON=
` on the
> > +     ``CAPTURE`` queue - the decoder will resume the operation normall=
y,
> > +     however any ``CAPTURE`` buffers still in the queue will be return=
ed to the
> > +     client,
> > +
> > +   * a pair of :c:func:`VIDIOC_STREAMOFF` and :c:func:`VIDIOC_STREAMON=
` on the
> > +     ``OUTPUT`` queue - any pending source buffers will be returned to=
 the
> > +     client and the `Seek` sequence will be triggered.
> > +
> > +.. note::
> > +
> > +   Once the drain sequence is initiated, the client needs to drive it =
to
> > +   completion, as described by the steps above, unless it aborts the p=
rocess by
> > +   issuing :c:func:`VIDIOC_STREAMOFF` on any of the ``OUTPUT`` or ``CA=
PTURE``
> > +   queues.  The client is not allowed to issue ``V4L2_DEC_CMD_START`` =
or
> > +   ``V4L2_DEC_CMD_STOP`` again while the drain sequence is in progress=
 and they
> > +   will fail with -EBUSY error code if attempted.
> > +
> > +   Although mandatory, the availability of decoder commands may be que=
ried
> > +   using :c:func:`VIDIOC_TRY_DECODER_CMD`.
> > +
> > +End of stream
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > +
> > +If the decoder encounters an end of stream marking in the stream, the =
decoder
> > +will initiate the `Drain` sequence, which the client must handle as de=
scribed
> > +above, skipping the initial :c:func:`VIDIOC_DECODER_CMD`.
> > +
> > +Commit points
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > +
> > +Setting formats and allocating buffers trigger changes in the behavior=
 of the
> > +decoder.
> > +
> > +1. Setting the format on the ``OUTPUT`` queue may change the set of fo=
rmats
> > +   supported/advertised on the ``CAPTURE`` queue. In particular, it al=
so means
> > +   that the ``CAPTURE`` format may be reset and the client must not re=
ly on the
> > +   previously set format being preserved.
> > +
> > +2. Enumerating formats on the ``CAPTURE`` queue always returns only fo=
rmats
> > +   supported for the current ``OUTPUT`` format.
> > +
> > +3. Setting the format on the ``CAPTURE`` queue does not change the lis=
t of
> > +   formats available on the ``OUTPUT`` queue. An attempt to set the ``=
CAPTURE``
> > +   format that is not supported for the currently selected ``OUTPUT`` =
format
> > +   will result in the decoder adjusting the requested ``CAPTURE`` form=
at to a
> > +   supported one.
> > +
> > +4. Enumerating formats on the ``OUTPUT`` queue always returns the full=
 set of
> > +   supported coded formats, irrespectively of the current ``CAPTURE`` =
format.
> > +
> > +5. While buffers are allocated on the ``OUTPUT`` queue, the client mus=
t not
> > +   change the format on the queue. Drivers will return the -EBUSY erro=
r code
> > +   for any such format change attempt.
> > +
> > +To summarize, setting formats and allocation must always start with th=
e
> > +``OUTPUT`` queue and the ``OUTPUT`` queue is the master that governs t=
he
> > +set of supported formats for the ``CAPTURE`` queue.
> > diff --git a/Documentation/media/uapi/v4l/devices.rst b/Documentation/m=
edia/uapi/v4l/devices.rst
> > index fb7f8c26cf09..12d43fe711cf 100644
> > --- a/Documentation/media/uapi/v4l/devices.rst
> > +++ b/Documentation/media/uapi/v4l/devices.rst
> > @@ -15,6 +15,7 @@ Interfaces
> >      dev-output
> >      dev-osd
> >      dev-codec
> > +    dev-decoder
> >      dev-effect
> >      dev-raw-vbi
> >      dev-sliced-vbi
> > diff --git a/Documentation/media/uapi/v4l/pixfmt-v4l2.rst b/Documentati=
on/media/uapi/v4l/pixfmt-v4l2.rst
> > index 826f2305da01..ca5f2270a829 100644
> > --- a/Documentation/media/uapi/v4l/pixfmt-v4l2.rst
> > +++ b/Documentation/media/uapi/v4l/pixfmt-v4l2.rst
> > @@ -32,6 +32,11 @@ Single-planar format structure
> >       to a multiple of the scale factor of any smaller planes. For
> >       example when the image format is YUV 4:2:0, ``width`` and
> >       ``height`` must be multiples of two.
> > +
> > +     For compressed formats that contain the resolution information en=
coded
> > +     inside the stream, when fed to a stateful mem2mem decoder, the fi=
elds
> > +     may be zero to rely on the decoder to detect the right values. Fo=
r more
> > +     details see :ref:`decoder` and format descriptions.
> >      * - __u32
> >        - ``pixelformat``
> >        - The pixel format or type of compression, set by the applicatio=
n.
> > diff --git a/Documentation/media/uapi/v4l/v4l2.rst b/Documentation/medi=
a/uapi/v4l/v4l2.rst
> > index b89e5621ae69..65dc096199ad 100644
> > --- a/Documentation/media/uapi/v4l/v4l2.rst
> > +++ b/Documentation/media/uapi/v4l/v4l2.rst
> > @@ -53,6 +53,10 @@ Authors, in alphabetical order:
> >
> >    - Original author of the V4L2 API and documentation.
> >
> > +- Figa, Tomasz <tfiga@chromium.org>
> > +
> > +  - Documented the memory-to-memory decoder interface.
> > +
> >  - H Schimek, Michael <mschimek@gmx.at>
> >
> >    - Original author of the V4L2 API and documentation.
> > @@ -61,6 +65,10 @@ Authors, in alphabetical order:
> >
> >    - Documented the Digital Video timings API.
> >
> > +- Osciak, Pawel <posciak@chromium.org>
> > +
> > +  - Documented the memory-to-memory decoder interface.
> > +
> >  - Osciak, Pawel <pawel@osciak.com>
> >
> >    - Designed and documented the multi-planar API.
> > @@ -85,7 +93,7 @@ Authors, in alphabetical order:
> >
> >    - Designed and documented the VIDIOC_LOG_STATUS ioctl, the extended =
control ioctls, major parts of the sliced VBI API, the MPEG encoder and dec=
oder APIs and the DV Timings API.
> >
> > -**Copyright** |copy| 1999-2016: Bill Dirks, Michael H. Schimek, Hans V=
erkuil, Martin Rubli, Andy Walls, Muralidharan Karicheri, Mauro Carvalho Ch=
ehab, Pawel Osciak, Sakari Ailus & Antti Palosaari.
> > +**Copyright** |copy| 1999-2018: Bill Dirks, Michael H. Schimek, Hans V=
erkuil, Martin Rubli, Andy Walls, Muralidharan Karicheri, Mauro Carvalho Ch=
ehab, Pawel Osciak, Sakari Ailus & Antti Palosaari, Tomasz Figa
> >
> >  Except when explicitly stated as GPL, programming examples within this
> >  part can be used and distributed without restrictions.
> > diff --git a/Documentation/media/uapi/v4l/vidioc-decoder-cmd.rst b/Docu=
mentation/media/uapi/v4l/vidioc-decoder-cmd.rst
> > index 85c916b0ce07..2f73fe22a9cd 100644
> > --- a/Documentation/media/uapi/v4l/vidioc-decoder-cmd.rst
> > +++ b/Documentation/media/uapi/v4l/vidioc-decoder-cmd.rst
> > @@ -49,14 +49,16 @@ The ``cmd`` field must contain the command code. So=
me commands use the
> >
> >  A :ref:`write() <func-write>` or :ref:`VIDIOC_STREAMON`
> >  call sends an implicit START command to the decoder if it has not been
> > -started yet.
> > +started yet. Applies to both queues of mem2mem decoders.
> >
> >  A :ref:`close() <func-close>` or :ref:`VIDIOC_STREAMOFF <VIDIOC_STREAM=
ON>`
> >  call of a streaming file descriptor sends an implicit immediate STOP
> > -command to the decoder, and all buffered data is discarded.
> > +command to the decoder, and all buffered data is discarded. Applies to=
 both
> > +queues of mem2mem decoders.
> >
> > -These ioctls are optional, not all drivers may support them. They were
> > -introduced in Linux 3.3.
> > +In principle, these ioctls are optional, not all drivers may support t=
hem. They were
> > +introduced in Linux 3.3. They are, however, mandatory for stateful mem=
2mem decoders
> > +(as further documented in :ref:`decoder`).
> >
> >
> >  .. tabularcolumns:: |p{1.1cm}|p{2.4cm}|p{1.2cm}|p{1.6cm}|p{10.6cm}|
> > @@ -160,26 +162,36 @@ introduced in Linux 3.3.
> >       ``V4L2_DEC_CMD_RESUME`` for that. This command has one flag:
> >       ``V4L2_DEC_CMD_START_MUTE_AUDIO``. If set, then audio will be
> >       muted when playing back at a non-standard speed.
> > +
> > +     For stateful mem2mem decoders, the command may be also used to re=
start
> > +     the decoder in case of an implicit stop initiated by the decoder
> > +     itself, without the ``V4L2_DEC_CMD_STOP`` being called explicitly=
.
> > +     No flags or other arguments are accepted in case of mem2mem decod=
ers.
> > +     See :ref:`decoder` for more details.
> >      * - ``V4L2_DEC_CMD_STOP``
> >        - 1
> >        - Stop the decoder. When the decoder is already stopped, this
> >       command does nothing. This command has two flags: if
> >       ``V4L2_DEC_CMD_STOP_TO_BLACK`` is set, then the decoder will set
> >       the picture to black after it stopped decoding. Otherwise the las=
t
> > -     image will repeat. mem2mem decoders will stop producing new frame=
s
> > -     altogether. They will send a ``V4L2_EVENT_EOS`` event when the
> > -     last frame has been decoded and all frames are ready to be
> > -     dequeued and will set the ``V4L2_BUF_FLAG_LAST`` buffer flag on
> > -     the last buffer of the capture queue to indicate there will be no
> > -     new buffers produced to dequeue. This buffer may be empty,
> > -     indicated by the driver setting the ``bytesused`` field to 0. Onc=
e
> > -     the ``V4L2_BUF_FLAG_LAST`` flag was set, the
> > -     :ref:`VIDIOC_DQBUF <VIDIOC_QBUF>` ioctl will not block anymore,
> > -     but return an ``EPIPE`` error code. If
> > +     image will repeat. If
> >       ``V4L2_DEC_CMD_STOP_IMMEDIATELY`` is set, then the decoder stops
> >       immediately (ignoring the ``pts`` value), otherwise it will keep
> >       decoding until timestamp >=3D pts or until the last of the pendin=
g
> >       data from its internal buffers was decoded.
> > +
> > +     A stateful mem2mem decoder will proceed with decoding the source
> > +     buffers pending before the command is issued and then stop produc=
ing
> > +     new frames. It will send a ``V4L2_EVENT_EOS`` event when the last=
 frame
> > +     has been decoded and all frames are ready to be dequeued and will=
 set
> > +     the ``V4L2_BUF_FLAG_LAST`` buffer flag on the last buffer of the
> > +     capture queue to indicate there will be no new buffers produced t=
o
> > +     dequeue. This buffer may be empty, indicated by the driver settin=
g the
> > +     ``bytesused`` field to 0. Once the buffer with the
> > +     ``V4L2_BUF_FLAG_LAST`` flag set was dequeued, the :ref:`VIDIOC_DQ=
BUF
> > +     <VIDIOC_QBUF>` ioctl will not block anymore, but return an ``EPIP=
E``
> > +     error code. No flags or other arguments are accepted in case of m=
em2mem
> > +     decoders.  See :ref:`decoder` for more details.
> >      * - ``V4L2_DEC_CMD_PAUSE``
> >        - 2
> >        - Pause the decoder. When the decoder has not been started yet, =
the
> > diff --git a/Documentation/media/uapi/v4l/vidioc-g-fmt.rst b/Documentat=
ion/media/uapi/v4l/vidioc-g-fmt.rst
> > index 3ead350e099f..0fc0b78a943e 100644
> > --- a/Documentation/media/uapi/v4l/vidioc-g-fmt.rst
> > +++ b/Documentation/media/uapi/v4l/vidioc-g-fmt.rst
> > @@ -53,6 +53,13 @@ devices that is either the struct
> >  member. When the requested buffer type is not supported drivers return
> >  an ``EINVAL`` error code.
> >
> > +A stateful mem2mem decoder will not allow operations on the
> > +``V4L2_BUF_TYPE_VIDEO_CAPTURE`` or ``V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLAN=
E``
> > +buffer type until the corresponding ``V4L2_BUF_TYPE_VIDEO_OUTPUT`` or
> > +``V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE`` buffer type is configured. If su=
ch an
> > +operation is attempted, drivers return an ``EACCES`` error code. Refer=
 to
> > +:ref:`decoder` for more details.
>
> This isn't right. EACCES is returned as long as the output format resolut=
ion is
> unknown. If it is set explicitly, then this will work without an error.

I think that's what is written above. The stream resolution is known
when the applicable OUTPUT queue is configured, which lets the driver
determine the format constraints on the applicable CAPTURE queue. If
it's not clear, could you help rephrasing?

>
> > +
> >  To change the current format parameters applications initialize the
> >  ``type`` field and all fields of the respective ``fmt`` union member.
> >  For details see the documentation of the various devices types in
> > @@ -145,6 +152,13 @@ On success 0 is returned, on error -1 and the ``er=
rno`` variable is set
> >  appropriately. The generic error codes are described at the
> >  :ref:`Generic Error Codes <gen-errors>` chapter.
> >
> > +EACCES
> > +    The format is not accessible until another buffer type is configur=
ed.
> > +    Relevant for the V4L2_BUF_TYPE_VIDEO_CAPTURE and
> > +    V4L2_BUF_TYPE_VIDEO_CAPTURE_MPLANE buffer types of mem2mem decoder=
s, which
> > +    require the format of V4L2_BUF_TYPE_VIDEO_OUTPUT or
> > +    V4L2_BUF_TYPE_VIDEO_OUTPUT_MPLANE buffer type to be configured fir=
st.
>
> Ditto.

Ditto.

Best regards,
Tomasz
