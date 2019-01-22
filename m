Return-Path: <SRS0=JQ9q=P6=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CA2FC282C3
	for <linux-media@archiver.kernel.org>; Tue, 22 Jan 2019 08:19:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D57E220861
	for <linux-media@archiver.kernel.org>; Tue, 22 Jan 2019 08:19:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="FxQFXQ6L"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727117AbfAVITf (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Tue, 22 Jan 2019 03:19:35 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:34371 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727087AbfAVITf (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 22 Jan 2019 03:19:35 -0500
Received: by mail-ot1-f68.google.com with SMTP id t5so17861039otk.1
        for <linux-media@vger.kernel.org>; Tue, 22 Jan 2019 00:19:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=J2bWyXanFvbFi0cxNVeBE1Aj5uPjUQ9mCRmSgPI8Chc=;
        b=FxQFXQ6LzHigHmajcLgYXh7VaqlhBXd4WWFO5/PCmVrxaQISbbPtOqtxFjVH7R20el
         GA0Dz6VLgw7yiRX6j71jdO2mlN693RJOe4tUSKJ04kAYI6iQAEzD0c3xNU5oT7Y4vEMX
         vDBIhpMxq8rIKkKwWZSNGsOFBOPHt/KXEwFug=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=J2bWyXanFvbFi0cxNVeBE1Aj5uPjUQ9mCRmSgPI8Chc=;
        b=WP6gHlS5qQ4kehttsurTqwJpOuUUtoArFGaifjO+hztpu7GQZr9yf0tdRuEaKP3Kep
         IqzPPugrNWcocWofDdONV4xMAioaEq81QM3N20JUUJMRzIDoXzZgHX3N6/gJWVld5JXz
         yy57jmubcEwUEOlhOZaeGgqXLtF835KyNROe3kVjkPezw0b6iKOV1TNYUfaRhoGiTNw6
         zItYCLbAXRbxoeHxSqopMtkd7EibI9XuksSNINggzpGzK7yF9BJ0YT4IxAl84jrBQCv2
         IreV0hUXtAuxAZLnPGpYRnI7DQOaSCv+kZPJKoHPoYJh0kfmI/q2eqLsX9yCc/lOA5Yu
         FSzw==
X-Gm-Message-State: AJcUukeOu4AS736m537YbXBc4Ev0CbOpU+sdoC1uExYwiNA0iFhhOj+m
        QEqPhzEuNGzUTGz0eaKQHm7IWCzwdAM=
X-Google-Smtp-Source: ALg8bN6h6GuYzF/LBPQ6lEc2iSMWgSXP2NbmMjc2cTBG0utvhZdB1C1x0EXHpsjD6kiR/IGADWiVsA==
X-Received: by 2002:a9d:3ecb:: with SMTP id b69mr20403517otc.329.1548145173271;
        Tue, 22 Jan 2019 00:19:33 -0800 (PST)
Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com. [209.85.167.180])
        by smtp.gmail.com with ESMTPSA id r11sm7661332oib.45.2019.01.22.00.19.31
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 22 Jan 2019 00:19:32 -0800 (PST)
Received: by mail-oi1-f180.google.com with SMTP id x23so16717687oix.3
        for <linux-media@vger.kernel.org>; Tue, 22 Jan 2019 00:19:31 -0800 (PST)
X-Received: by 2002:aca:c312:: with SMTP id t18mr8088005oif.92.1548145171391;
 Tue, 22 Jan 2019 00:19:31 -0800 (PST)
MIME-Version: 1.0
References: <20181205100121.181765-1-acourbot@chromium.org> <e2b464c83892b79c77fd7388733758b2e02813d2.camel@bootlin.com>
In-Reply-To: <e2b464c83892b79c77fd7388733758b2e02813d2.camel@bootlin.com>
From:   Tomasz Figa <tfiga@chromium.org>
Date:   Tue, 22 Jan 2019 17:19:20 +0900
X-Gmail-Original-Message-ID: <CAAFQd5Aw=A2+pdtJijQ78-nV5qU5ypYjjEFV8rpPk=Je1LajqA@mail.gmail.com>
Message-ID: <CAAFQd5Aw=A2+pdtJijQ78-nV5qU5ypYjjEFV8rpPk=Je1LajqA@mail.gmail.com>
Subject: Re: [PATCH] media: docs-rst: Document m2m stateless video decoder interface
To:     Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Cc:     Alexandre Courbot <acourbot@chromium.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Pawel Osciak <posciak@chromium.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi Paul,

On Fri, Dec 7, 2018 at 5:30 PM Paul Kocialkowski
<paul.kocialkowski@bootlin.com> wrote:
>
> Hi,
>
> Thanks for this new version! I only have one comment left, see below.
>
> On Wed, 2018-12-05 at 19:01 +0900, Alexandre Courbot wrote:
> > Documents the protocol that user-space should follow when
> > communicating with stateless video decoders.
> >
> > The stateless video decoding API makes use of the new request and tags
> > APIs. While it has been implemented with the Cedrus driver so far, it
> > should probably still be considered staging for a short while.
> >
> > Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
> > ---
> > Removing the RFC flag this time. Changes since RFCv3:
> >
> > * Included Tomasz and Hans feedback,
> > * Expanded the decoding section to better describe the use of requests,
> > * Use the tags API.
> >
> >  Documentation/media/uapi/v4l/dev-codec.rst    |   5 +
> >  .../media/uapi/v4l/dev-stateless-decoder.rst  | 399 ++++++++++++++++++
> >  2 files changed, 404 insertions(+)
> >  create mode 100644 Documentation/media/uapi/v4l/dev-stateless-decoder.rst
> >
> > diff --git a/Documentation/media/uapi/v4l/dev-codec.rst b/Documentation/media/uapi/v4l/dev-codec.rst
> > index c61e938bd8dc..3e6a3e883f11 100644
> > --- a/Documentation/media/uapi/v4l/dev-codec.rst
> > +++ b/Documentation/media/uapi/v4l/dev-codec.rst
> > @@ -6,6 +6,11 @@
> >  Codec Interface
> >  ***************
> >
> > +.. toctree::
> > +    :maxdepth: 1
> > +
> > +    dev-stateless-decoder
> > +
> >  A V4L2 codec can compress, decompress, transform, or otherwise convert
> >  video data from one format into another format, in memory. Typically
> >  such devices are memory-to-memory devices (i.e. devices with the
> > diff --git a/Documentation/media/uapi/v4l/dev-stateless-decoder.rst b/Documentation/media/uapi/v4l/dev-stateless-decoder.rst
> > new file mode 100644
> > index 000000000000..7a781c89bd59
> > --- /dev/null
> > +++ b/Documentation/media/uapi/v4l/dev-stateless-decoder.rst
> > @@ -0,0 +1,399 @@
> > +.. -*- coding: utf-8; mode: rst -*-
> > +
> > +.. _stateless_decoder:
> > +
> > +**************************************************
> > +Memory-to-memory Stateless Video Decoder Interface
> > +**************************************************
> > +
> > +A stateless decoder is a decoder that works without retaining any kind of state
> > +between processing frames. This means that each frame is decoded independently
> > +of any previous and future frames, and that the client is responsible for
> > +maintaining the decoding state and providing it to the decoder with each
> > +decoding request. This is in contrast to the stateful video decoder interface,
> > +where the hardware and driver maintain the decoding state and all the client
> > +has to do is to provide the raw encoded stream.
> > +
> > +This section describes how user-space ("the client") is expected to communicate
> > +with such decoders in order to successfully decode an encoded stream. Compared
> > +to stateful codecs, the decoder/client sequence is simpler, but the cost of
> > +this simplicity is extra complexity in the client which must maintain a
> > +consistent decoding state.
> > +
> > +Stateless decoders make use of the request API and buffer tags. A stateless
> > +decoder must thus expose the following capabilities on its queues when
> > +:c:func:`VIDIOC_REQBUFS` or :c:func:`VIDIOC_CREATE_BUFS` are invoked:
> > +
> > +* The ``V4L2_BUF_CAP_SUPPORTS_REQUESTS`` capability must be set on the
> > +  ``OUTPUT`` queue,
> > +
> > +* The ``V4L2_BUF_CAP_SUPPORTS_TAGS`` capability must be set on the ``OUTPUT``
> > +  and ``CAPTURE`` queues,
> > +
>
> [...]
>
> > +Decoding
> > +========
> > +
> > +For each frame, the client is responsible for submitting a request to which the
> > +following is attached:
> > +
> > +* Exactly one frame worth of encoded data in a buffer submitted to the
> > +  ``OUTPUT`` queue,
>
> Although this is still the case in the cedrus driver (but will be fixed
> eventually), this requirement should be dropped because metadata is
> per-slice and not per-picture in the formats we're currently aiming to
> support.
>
> I think it would be safer to mention something like filling the output
> buffer with the minimum unit size for the selected output format, to
> which the associated metadata applies.

I'm not sure it's a good idea. Some of the reasons why I think so:
 1) There are streams that can have even 32 slices. With that, you
instantly run out of V4L2 buffers even just for 1 frame.
 2) The Rockchip hardware which seems to just pick all the slices one
after another and which was the reason to actually put the slice data
in the buffer like that.
 3) Not all the metadata is per-slice. Actually most of the metadata
is per frame and only what is located inside v4l2_h264_slice_param is
per-slice. The corresponding control is an array, which has an entry
for each slice in the buffer. Each entry includes an offset field,
which points to the place in the buffer where the slice is located.

Best regards,
Tomasz

>
> > +* All the controls relevant to the format being decoded (see below for details).
> > +
> > +The contents of the source ``OUTPUT`` buffer, as well as the controls that must
> > +be set on the request, depend on the active coded pixel format and might be
> > +affected by codec-specific extended controls, as stated in documentation of each
> > +format.
> > +
> > +A typical frame would thus be decoded using the following sequence:
> > +
> > +1. Queue an ``OUTPUT`` buffer containing one frame worth of encoded bitstream
>
> Ditto here.
>
> > +   data for the decoding request, using :c:func:`VIDIOC_QBUF`.
> > +
> > +    * **Required fields:**
> > +
> > +      ``index``
> > +          index of the buffer being queued.
> > +
> > +      ``type``
> > +          type of the buffer.
> > +
> > +      ``bytesused``
> > +          number of bytes taken by the encoded data frame in the buffer.
> > +
> > +      ``flags``
> > +          the ``V4L2_BUF_FLAG_REQUEST_FD`` flag must be set. In addition, if
> > +       the decoded frame is to be used as a reference frame in the future,
> > +       then the ``V4L2_BUF_FLAG_TAG`` flag must be set (it can also be set
> > +       for non-reference frames if it helps the client).
> > +
> > +      ``request_fd``
> > +          must be set to the file descriptor of the decoding request.
> > +
> > +      ``tag``
> > +          if the ``V4L2_BUF_FLAG_TAG`` is set, then this must contain the tag
> > +          for the frame that will be copied into the decoded frame buffer, and
> > +          can be used to specify this frame as a reference frame for another
> > +          one.
> > +
> > +   .. note::
> > +
> > +     The API currently requires one frame of encoded data per ``OUTPUT`` buffer,
> > +     even though some encoded formats may present their data in smaller chunks
> > +     (e.g. H.264's frames can be made of several slices that can be processed
> > +     independently). It is currently the responsibility of the client to gather
> > +     the different parts of a frame into a single ``OUTPUT`` buffer, while
> > +     preserving the same layout as the original bitstream. This
> > +     restriction may be lifted in the future.
>
> And this part should probably be dropped too.
>
> Cheers,
>
> Paul
>
> > +2. Set the codec-specific controls for the decoding request, using
> > +   :c:func:`VIDIOC_S_EXT_CTRLS`.
> > +
> > +    * **Required fields:**
> > +
> > +      ``which``
> > +          must be ``V4L2_CTRL_WHICH_REQUEST_VAL``.
> > +
> > +      ``request_fd``
> > +          must be set to the file descriptor of the decoding request.
> > +
> > +      other fields
> > +          other fields are set as usual when setting controls. The ``controls``
> > +          array must contain all the codec-specific controls required to decode
> > +          a frame.
> > +
> > +   .. note::
> > +
> > +      It is possible to specify the controls in different invocations of
> > +      :c:func:`VIDIOC_S_EXT_CTRLS`, or to overwrite a previously set control, as
> > +      long as ``request_fd`` and ``which`` are properly set. The controls state
> > +      at the moment of request submission is the one that will be considered.
> > +
> > +   .. note::
> > +
> > +      The order in which steps 1 and 2 take place is interchangeable.
> > +
> > +3. Submit the request by invoking :c:func:`MEDIA_IOC_REQUEST_QUEUE` on the
> > +   request FD.
> > +
> > +    If the request is submitted without an ``OUTPUT`` buffer, or if some of the
> > +    required controls are missing from the request, then
> > +    :c:func:`MEDIA_REQUEST_IOC_QUEUE` will return ``-ENOENT``. If more than one
> > +    ``OUTPUT`` buffer is queued, then it will return ``-EINVAL``.
> > +    :c:func:`MEDIA_REQUEST_IOC_QUEUE` returning non-zero means that no
> > +    ``CAPTURE`` buffer will be produced for this request.
> > +
> > +``CAPTURE`` buffers must not be part of the request, and are queued
> > +independently. They are returned in decode order (i.e. the same order as
> > +``OUTPUT`` buffers were submitted).
> > +
> > +Runtime decoding errors are signaled by the dequeued ``CAPTURE`` buffers
> > +carrying the ``V4L2_BUF_FLAG_ERROR`` flag. If a decoded reference frame has an
> > +error, then all following decoded frames that refer to it also have the
> > +``V4L2_BUF_FLAG_ERROR`` flag set, although the decoder will still try to
> > +produce a (likely corrupted) frame.
> > +
> > +Buffer management while decoding
> > +================================
> > +Contrary to stateful decoders, a stateless decoder does not perform any kind of
> > +buffer management: it only guarantees that dequeued ``CAPTURE`` buffer can be
> > +used by the client for as long as they are not queued again. "Used" here
> > +encompasses using the buffer for compositing, display, or as a reference frame
> > +to decode a subsequent frame.
> > +
> > +Reference frames are specified by using the same tag that was set to the
> > +``OUTPUT`` buffer of a frame into the relevant codec-specific structures that
> > +are submitted as controls. This tag will be copied to the corresponding
> > +``CAPTURE`` buffer, but can be used in any subsequent decoding request as soon
> > +as the decoding request for that buffer is queued successfully. This means that
> > +the client does not need to wait until a ``CAPTURE`` buffer with a given tag is
> > +dequeued to start using that tag in reference frames. However, it must wait
> > +until all frames referencing a given tag are dequeued before queuing the
> > +referenced ``CAPTURE`` buffer again, since queueing a buffer effectively removes
> > +its tag.
> > +
> > +When queuing a decoding request, the driver will increase the reference count of
> > +all the resources associated with reference frames. This means that the client
> > +can e.g. close the DMABUF file descriptors of the reference frame buffers if it
> > +won't need it afterwards, as long as the V4L2 ``CAPTURE`` buffer of the
> > +reference frame is not re-queued before all referencing frames are decoded.
> > +
> > +Seeking
> > +=======
> > +In order to seek, the client just needs to submit requests using input buffers
> > +corresponding to the new stream position. It must however be aware that
> > +resolution may have changed and follow the dynamic resolution change sequence in
> > +that case. Also depending on the codec used, picture parameters (e.g. SPS/PPS
> > +for H.264) may have changed and the client is responsible for making sure that a
> > +valid state is sent to the decoder.
> > +
> > +The client is then free to ignore any returned ``CAPTURE`` buffer that comes
> > +from the pre-seek position.
> > +
> > +Pause
> > +=====
> > +
> > +In order to pause, the client can just cease queuing buffers onto the ``OUTPUT``
> > +queue. Without source bitstream data, there is no data to process and the codec
> > +will remain idle.
> > +
> > +Dynamic resolution change
> > +=========================
> > +
> > +If the client detects a resolution change in the stream, it will need to perform
> > +the initialization sequence again with the new resolution:
> > +
> > +1. Wait until all submitted requests have completed and dequeue the
> > +   corresponding output buffers.
> > +
> > +2. Call :c:func:`VIDIOC_STREAMOFF` on both the ``OUTPUT`` and ``CAPTURE``
> > +   queues.
> > +
> > +3. Free all ``CAPTURE`` buffers by calling :c:func:`VIDIOC_REQBUFS` on the
> > +   ``CAPTURE`` queue with a buffer count of zero.
> > +
> > +4. Perform the initialization sequence again (minus the allocation of
> > +   ``OUTPUT`` buffers), with the new resolution set on the ``OUTPUT`` queue.
> > +   Note that due to resolution constraints, a different format may need to be
> > +   picked on the ``CAPTURE`` queue.
> > +
> > +Drain
> > +=====
> > +
> > +In order to drain the stream on a stateless decoder, the client just needs to
> > +wait until all the submitted requests are completed. There is no need to send a
> > +``V4L2_DEC_CMD_STOP`` command since requests are processed sequentially by the
> > +decoder.
> > +
> > +End of stream
> > +=============
> > +
> > +When the client detects that the end of stream is reached, it can simply stop
> > +sending new frames to the decoder, drain the ``CAPTURE`` queue, and dispose of
> > +the decoder as needed.
> --
> Paul Kocialkowski, Bootlin (formerly Free Electrons)
> Embedded Linux and kernel engineering
> https://bootlin.com
>
