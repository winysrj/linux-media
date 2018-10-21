Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([213.167.242.64]:38436 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726975AbeJURhZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 21 Oct 2018 13:37:25 -0400
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
Date: Sun, 21 Oct 2018 12:23:43 +0300
Message-ID: <2340231.s4xOQAu5Wh@avalon>
In-Reply-To: <CAAFQd5BnfZdbBpDq5qGwLQrWOzae-kd57JTv1ieokCs8H5K1MQ@mail.gmail.com>
References: <20180724140621.59624-1-tfiga@chromium.org> <4766921.vZCsLckqXW@avalon> <CAAFQd5BnfZdbBpDq5qGwLQrWOzae-kd57JTv1ieokCs8H5K1MQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tomasz,

On Saturday, 20 October 2018 11:52:57 EEST Tomasz Figa wrote:
> On Thu, Oct 18, 2018 at 8:22 PM Laurent Pinchart wrote:
> > On Thursday, 18 October 2018 13:03:33 EEST Tomasz Figa wrote:
> >> On Wed, Oct 17, 2018 at 10:34 PM Laurent Pinchart wrote:
> >>> On Tuesday, 24 July 2018 17:06:20 EEST Tomasz Figa wrote:
> >>>> Due to complexity of the video decoding process, the V4L2 drivers of
> >>>> stateful decoder hardware require specific sequences of V4L2 API
> >>>> calls to be followed. These include capability enumeration,
> >>>> initialization, decoding, seek, pause, dynamic resolution change, dr=
ain
> >>>> and end of stream.
> >>>>=20
> >>>> Specifics of the above have been discussed during Media Workshops at
> >>>> LinuxCon Europe 2012 in Barcelona and then later Embedded Linux
> >>>> Conference Europe 2014 in D=FCsseldorf. The de facto Codec API that
> >>>> originated at those events was later implemented by the drivers we
> >>>> already have merged in mainline, such as s5p-mfc or coda.
> >>>>=20
> >>>> The only thing missing was the real specification included as a part
> >>>> of Linux Media documentation. Fix it now and document the decoder pa=
rt
> >>>> of the Codec API.
> >>>>=20
> >>>> Signed-off-by: Tomasz Figa <tfiga@chromium.org>
> >>>> ---
> >>>>=20
> >>>>  Documentation/media/uapi/v4l/dev-decoder.rst | 872 ++++++++++++++++=
+++
> >>>>  Documentation/media/uapi/v4l/devices.rst     |   1 +
> >>>>  Documentation/media/uapi/v4l/v4l2.rst        |  10 +-
> >>>>  3 files changed, 882 insertions(+), 1 deletion(-)
> >>>>  create mode 100644 Documentation/media/uapi/v4l/dev-decoder.rst
> >>>>=20
> >>>> diff --git a/Documentation/media/uapi/v4l/dev-decoder.rst
> >>>> b/Documentation/media/uapi/v4l/dev-decoder.rst new file mode 100644
> >>>> index 000000000000..f55d34d2f860
> >>>> --- /dev/null
> >>>> +++ b/Documentation/media/uapi/v4l/dev-decoder.rst
> >>>> @@ -0,0 +1,872 @@
> >=20
> > [snip]
> >=20
> >>>> +4.  Allocate source (bitstream) buffers via :c:func:`VIDIOC_REQBUFS`
> >>>> on
> >>>> +    ``OUTPUT``.
> >>>> +
> >>>> +    * **Required fields:**
> >>>> +
> >>>> +      ``count``
> >>>> +          requested number of buffers to allocate; greater than zero
> >>>> +
> >>>> +      ``type``
> >>>> +          a ``V4L2_BUF_TYPE_*`` enum appropriate for ``OUTPUT``
> >>>> +
> >>>> +      ``memory``
> >>>> +          follows standard semantics
> >>>> +
> >>>> +      ``sizeimage``
> >>>> +          follows standard semantics; the client is free to choose
> >>>> any
> >>>> +          suitable size, however, it may be subject to change by the
> >>>> +          driver
> >>>> +
> >>>> +    * **Return fields:**
> >>>> +
> >>>> +      ``count``
> >>>> +          actual number of buffers allocated
> >>>> +
> >>>> +    * The driver must adjust count to minimum of required number of
> >>>> +      ``OUTPUT`` buffers for given format and count passed.
> >>>=20
> >>> Isn't it the maximum, not the minimum ?
> >>=20
> >> It's actually neither. All we can generally say here is that the
> >> number will be adjusted and the client must note it.
> >=20
> > I expect it to be clamp(requested count, driver minimum, driver maximum=
).
> > I'm not sure it's worth capturing this in the document though, but we
> > could say
> >=20
> > "The driver must clam count to the minimum and maximum number of requir=
ed
> > ``OUTPUT`` buffers for the given format ."
>=20
> I'd leave the details to the documentation of VIDIOC_REQBUFS, if
> needed. This document focuses on the decoder UAPI and with this note I
> want to ensure that the applications don't assume that exactly the
> requested number of buffers is always allocated.
>=20
> How about making it even simpler:
>=20
> The actual number of allocated buffers may differ from the ``count``
> given. The client must check the updated value of ``count`` after the
> call returns.

That works for me. You may want to see "... given, as specified in the=20
VIDIOC_REQBUFS documentation.".

> >>>> The client must
> >>>> +      check this value after the ioctl returns to get the number of
> >>>> +      buffers allocated.
> >>>> +
> >>>> +    .. note::
> >>>> +
> >>>> +       To allocate more than minimum number of buffers (for pipeline
> >>>> +       depth), use G_CTRL(``V4L2_CID_MIN_BUFFERS_FOR_OUTPUT``) to
> >>>> +       get minimum number of buffers required by the driver/format,
> >>>> +       and pass the obtained value plus the number of additional
> >>>> +       buffers needed in count to :c:func:`VIDIOC_REQBUFS`.
> >>>> +
> >>>> +5.  Start streaming on ``OUTPUT`` queue via
> >>>> :c:func:`VIDIOC_STREAMON`.
> >>>> +
> >>>> +6.  This step only applies to coded formats that contain resolution
> >>>> +    information in the stream. Continue queuing/dequeuing bitstream
> >>>> +    buffers to/from the ``OUTPUT`` queue via :c:func:`VIDIOC_QBUF`
> >>>> and
> >>>> +    :c:func:`VIDIOC_DQBUF`. The driver must keep processing and
> >>>> returning
> >>>> +    each buffer to the client until required metadata to configure
> >>>> the
> >>>> +    ``CAPTURE`` queue are found. This is indicated by the driver
> >>>> sending
> >>>> +    a ``V4L2_EVENT_SOURCE_CHANGE`` event with
> >>>> +    ``V4L2_EVENT_SRC_CH_RESOLUTION`` source change type. There is no
> >>>> +    requirement to pass enough data for this to occur in the first
> >>>> buffer
> >>>> +    and the driver must be able to process any number.
> >>>> +
> >>>> +    * If data in a buffer that triggers the event is required to
> >>>> decode
> >>>> +      the first frame, the driver must not return it to the client,
> >>>> +      but must retain it for further decoding.
> >>>> +
> >>>> +    * If the client set width and height of ``OUTPUT`` format to 0,
> >>>> calling
> >>>> +      :c:func:`VIDIOC_G_FMT` on the ``CAPTURE`` queue will return
> >>>> -EPERM,
> >>>> +      until the driver configures ``CAPTURE`` format according to
> >>>> stream
> >>>> +      metadata.
> >>>=20
> >>> That's a pretty harsh handling for this condition. What's the
> >>> rationale for returning -EPERM instead of for instance succeeding with
> >>> width and height set to 0 ?
> >>=20
> >> I don't like it, but the error condition must stay for compatibility
> >> reasons as that's what current drivers implement and applications
> >> expect. (Technically current drivers would return -EINVAL, but we
> >> concluded that existing applications don't care about the exact value,
> >> so we can change it to make more sense.)
> >=20
> > Fair enough :-/ A bit of a shame though. Should we try to use an error
> > code that would have less chance of being confused with an actual
> > permission problem ? -EILSEQ could be an option for "illegal sequence" =
of
> > operations, but better options could exist.
>=20
> In Request API we concluded that -EACCES is the right code to return
> for G_EXT_CTRLS on a request that has not finished yet. The case here
> is similar - the capture queue is not yet set up. What do you think?

Good question. -EPERM is documented as "Operation not permitted", while -
EACCES is documented as "Permission denied". The former appears to be=20
understood as "This isn't a good idea, I can't let you do that", and the=20
latter as "You don't have sufficient privileges, if you retry with the corr=
ect=20
privileges this will succeed". Neither are a perfect match, but -EACCES mig=
ht=20
be better if you replace getting privileges by performing the required setu=
p.

> >>>> +    * If the client subscribes to ``V4L2_EVENT_SOURCE_CHANGE``
> >>>> events and
> >>>> +      the event is signaled, the decoding process will not continue
> >>>> until
> >>>> +      it is acknowledged by either (re-)starting streaming on
> >>>> ``CAPTURE``,
> >>>> +      or via :c:func:`VIDIOC_DECODER_CMD` with
> >>>> ``V4L2_DEC_CMD_START``
> >>>> +      command.
> >>>> +
> >>>> +    .. note::
> >>>> +
> >>>> +       No decoded frames are produced during this phase.
> >>>> +

[snip]

> >> Also added a note:
> >>        To fulfill those requirements, the client may attempt to use
> >>        :c:func:`VIDIOC_CREATE_BUFS` to add more buffers. However, due =
to
> >>        hardware limitations, the decoder may not support adding buffers
> >>        at this point and the client must be able to handle a failure
> >>        using the steps below.
> >=20
> > I wonder if there could be a way to work around those limitations on the
> > driver side. At the beginning of step 7, the decoder is effectively
> > stopped. If the hardware doesn't support adding new buffers on the fly,
> > can't the driver support the VIDIOC_CREATE_BUFS + V4L2_DEC_CMD_START
> > sequence the same way it would support the VIDIOC_STREAMOFF +
> > VIDIOC_REQBUFS(0) +
> > VIDIOC_REQBUFS(n) + VIDIOC_STREAMON ?
>=20
> I guess that would work. I would only allow it for the case where
> existing buffers are already big enough and just more buffers are
> needed. Otherwise it would lead to some weird cases, such as some old
> buffers already in the CAPTURE queue, blocking the decode of further
> frames. (While it could be handled by the driver returning them with
> an error state, it would only complicate the interface.)

Good point. I wonder if this could be handled in the framework. If it can't=
,=20
or with non trivial support code on the driver side, then I would agree wit=
h=20
you. Otherwise, handling the workaround in the framework would ensure=20
consistent behaviour across drivers with minimal cost, and simplify the=20
userspace API, so I think it would be a good thing.

=2D-=20
Regards,

Laurent Pinchart
