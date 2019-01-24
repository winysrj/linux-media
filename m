Return-Path: <SRS0=42/h=QA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D8D5C41518
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 08:07:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 34353218A2
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 08:07:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="IrfGOP86"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726080AbfAXIHr (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 24 Jan 2019 03:07:47 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:42116 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbfAXIHr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Jan 2019 03:07:47 -0500
Received: by mail-ot1-f66.google.com with SMTP id v23so4464450otk.9
        for <linux-media@vger.kernel.org>; Thu, 24 Jan 2019 00:07:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=upjwkUlLSlOg1yEbM64EKv2x0NREMtcXypyfUS73NsE=;
        b=IrfGOP86HeJ1eDk9qKM3mqgTTEjKl/bcVktZ3Ij5cTafSnxGyWyfHMqa9u+TbQiWTI
         a46fGKrLCUhFx93F2P0nhjM9/Vv8fDO+ZjQydfBCA0dgaUuaX8vF4aEPCkC2/o46bOM0
         nKyy7bEJ6x32azUf6d22BeB1iYQWDduokaJ/o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=upjwkUlLSlOg1yEbM64EKv2x0NREMtcXypyfUS73NsE=;
        b=KYAV+ketQ8lenuuzQs+/sFlQ0sxPZrmCJzIwmRn0na2PW3ADz+aw0agnw6D4lovCEH
         w+GbtO2jRiPFZl1CMuhd+H/KVfAtulxg4zgXsoExS/F6sv93YC4M9uZGMar9fx47+YTX
         D/rnkN4eGYhDhM9fnB60Ft2PHkelaxgDbyu6V/4Nmvcc6SDJ8NfOXcP35M7UvY7umhTc
         CCsq/5a/4E9TW6aoZzi5ui4lfOMXx45x3NVOvWdvz5lltqiDLggPflUo1lgFqNyLNV7R
         WD9WCWB2fEzznxrj8Y/uQUkvv0dLVKXfGgGlTrIcOCLdMQbP2w2LvTZRpWPwatdUADvN
         noJw==
X-Gm-Message-State: AJcUukeL6gj/f1QDejMwfXx8pVir4FVFmutKr0ootZjCw9RQWbPnr4gF
        YixXaYD7jQntYcP5izr7S+0VeOSmYXs=
X-Google-Smtp-Source: ALg8bN7C8Ooec7Cku0jkW9siGXeEo9VU9oQcdqIIMyH2rhXURqKQA9PgAGdQjRlCRRf5l9YVyR24Lg==
X-Received: by 2002:a9d:1b4b:: with SMTP id l69mr3694995otl.183.1548317265069;
        Thu, 24 Jan 2019 00:07:45 -0800 (PST)
Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com. [209.85.167.182])
        by smtp.gmail.com with ESMTPSA id z15sm9396103oib.23.2019.01.24.00.07.43
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Jan 2019 00:07:43 -0800 (PST)
Received: by mail-oi1-f182.google.com with SMTP id a77so4138849oii.5
        for <linux-media@vger.kernel.org>; Thu, 24 Jan 2019 00:07:43 -0800 (PST)
X-Received: by 2002:aca:ea57:: with SMTP id i84mr496281oih.346.1548317263191;
 Thu, 24 Jan 2019 00:07:43 -0800 (PST)
MIME-Version: 1.0
References: <20181205100121.181765-1-acourbot@chromium.org>
 <e2b464c83892b79c77fd7388733758b2e02813d2.camel@bootlin.com>
 <CAAFQd5Aw=A2+pdtJijQ78-nV5qU5ypYjjEFV8rpPk=Je1LajqA@mail.gmail.com>
 <dd07f7ddf2c3790871861855143d3f49359e4f74.camel@bootlin.com>
 <CAPBb6MVnfCRjVBDyKEw=CQnxjq1xFR03Uka+Jxw=kAia5BfFVQ@mail.gmail.com> <42a24867b3b4506cdb7e738eec5b2b8316f8ca19.camel@bootlin.com>
In-Reply-To: <42a24867b3b4506cdb7e738eec5b2b8316f8ca19.camel@bootlin.com>
From:   Tomasz Figa <tfiga@chromium.org>
Date:   Thu, 24 Jan 2019 17:07:32 +0900
X-Gmail-Original-Message-ID: <CAAFQd5CFHJaEELbihq6aNxSOzWghunG-qiqxM9xL1n4q1yBp9g@mail.gmail.com>
Message-ID: <CAAFQd5CFHJaEELbihq6aNxSOzWghunG-qiqxM9xL1n4q1yBp9g@mail.gmail.com>
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

On Wed, Jan 23, 2019 at 7:42 PM Paul Kocialkowski
<paul.kocialkowski@bootlin.com> wrote:
>
> Hi Alex,
>
> On Wed, 2019-01-23 at 18:43 +0900, Alexandre Courbot wrote:
> > On Tue, Jan 22, 2019 at 7:10 PM Paul Kocialkowski
> > <paul.kocialkowski@bootlin.com> wrote:
> > > Hi,
> > >
> > > On Tue, 2019-01-22 at 17:19 +0900, Tomasz Figa wrote:
> > > > Hi Paul,
> > > >
> > > > On Fri, Dec 7, 2018 at 5:30 PM Paul Kocialkowski
> > > > <paul.kocialkowski@bootlin.com> wrote:
> > > > > Hi,
> > > > >
> > > > > Thanks for this new version! I only have one comment left, see below.
> > > > >
> > > > > On Wed, 2018-12-05 at 19:01 +0900, Alexandre Courbot wrote:
> > > > > > Documents the protocol that user-space should follow when
> > > > > > communicating with stateless video decoders.
> > > > > >
> > > > > > The stateless video decoding API makes use of the new request and tags
> > > > > > APIs. While it has been implemented with the Cedrus driver so far, it
> > > > > > should probably still be considered staging for a short while.
> > > > > >
> > > > > > Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
> > > > > > ---
> > > > > > Removing the RFC flag this time. Changes since RFCv3:
> > > > > >
> > > > > > * Included Tomasz and Hans feedback,
> > > > > > * Expanded the decoding section to better describe the use of requests,
> > > > > > * Use the tags API.
> > > > > >
> > > > > >  Documentation/media/uapi/v4l/dev-codec.rst    |   5 +
> > > > > >  .../media/uapi/v4l/dev-stateless-decoder.rst  | 399 ++++++++++++++++++
> > > > > >  2 files changed, 404 insertions(+)
> > > > > >  create mode 100644 Documentation/media/uapi/v4l/dev-stateless-decoder.rst
> > > > > >
> > > > > > diff --git a/Documentation/media/uapi/v4l/dev-codec.rst b/Documentation/media/uapi/v4l/dev-codec.rst
> > > > > > index c61e938bd8dc..3e6a3e883f11 100644
> > > > > > --- a/Documentation/media/uapi/v4l/dev-codec.rst
> > > > > > +++ b/Documentation/media/uapi/v4l/dev-codec.rst
> > > > > > @@ -6,6 +6,11 @@
> > > > > >  Codec Interface
> > > > > >  ***************
> > > > > >
> > > > > > +.. toctree::
> > > > > > +    :maxdepth: 1
> > > > > > +
> > > > > > +    dev-stateless-decoder
> > > > > > +
> > > > > >  A V4L2 codec can compress, decompress, transform, or otherwise convert
> > > > > >  video data from one format into another format, in memory. Typically
> > > > > >  such devices are memory-to-memory devices (i.e. devices with the
> > > > > > diff --git a/Documentation/media/uapi/v4l/dev-stateless-decoder.rst b/Documentation/media/uapi/v4l/dev-stateless-decoder.rst
> > > > > > new file mode 100644
> > > > > > index 000000000000..7a781c89bd59
> > > > > > --- /dev/null
> > > > > > +++ b/Documentation/media/uapi/v4l/dev-stateless-decoder.rst
> > > > > > @@ -0,0 +1,399 @@
> > > > > > +.. -*- coding: utf-8; mode: rst -*-
> > > > > > +
> > > > > > +.. _stateless_decoder:
> > > > > > +
> > > > > > +**************************************************
> > > > > > +Memory-to-memory Stateless Video Decoder Interface
> > > > > > +**************************************************
> > > > > > +
> > > > > > +A stateless decoder is a decoder that works without retaining any kind of state
> > > > > > +between processing frames. This means that each frame is decoded independently
> > > > > > +of any previous and future frames, and that the client is responsible for
> > > > > > +maintaining the decoding state and providing it to the decoder with each
> > > > > > +decoding request. This is in contrast to the stateful video decoder interface,
> > > > > > +where the hardware and driver maintain the decoding state and all the client
> > > > > > +has to do is to provide the raw encoded stream.
> > > > > > +
> > > > > > +This section describes how user-space ("the client") is expected to communicate
> > > > > > +with such decoders in order to successfully decode an encoded stream. Compared
> > > > > > +to stateful codecs, the decoder/client sequence is simpler, but the cost of
> > > > > > +this simplicity is extra complexity in the client which must maintain a
> > > > > > +consistent decoding state.
> > > > > > +
> > > > > > +Stateless decoders make use of the request API and buffer tags. A stateless
> > > > > > +decoder must thus expose the following capabilities on its queues when
> > > > > > +:c:func:`VIDIOC_REQBUFS` or :c:func:`VIDIOC_CREATE_BUFS` are invoked:
> > > > > > +
> > > > > > +* The ``V4L2_BUF_CAP_SUPPORTS_REQUESTS`` capability must be set on the
> > > > > > +  ``OUTPUT`` queue,
> > > > > > +
> > > > > > +* The ``V4L2_BUF_CAP_SUPPORTS_TAGS`` capability must be set on the ``OUTPUT``
> > > > > > +  and ``CAPTURE`` queues,
> > > > > > +
> > > > >
> > > > > [...]
> > > > >
> > > > > > +Decoding
> > > > > > +========
> > > > > > +
> > > > > > +For each frame, the client is responsible for submitting a request to which the
> > > > > > +following is attached:
> > > > > > +
> > > > > > +* Exactly one frame worth of encoded data in a buffer submitted to the
> > > > > > +  ``OUTPUT`` queue,
> > > > >
> > > > > Although this is still the case in the cedrus driver (but will be fixed
> > > > > eventually), this requirement should be dropped because metadata is
> > > > > per-slice and not per-picture in the formats we're currently aiming to
> > > > > support.
> > > > >
> > > > > I think it would be safer to mention something like filling the output
> > > > > buffer with the minimum unit size for the selected output format, to
> > > > > which the associated metadata applies.
> > > >
> > > > I'm not sure it's a good idea. Some of the reasons why I think so:
> > > >  1) There are streams that can have even 32 slices. With that, you
> > > > instantly run out of V4L2 buffers even just for 1 frame.
> > > >  2) The Rockchip hardware which seems to just pick all the slices one
> > > > after another and which was the reason to actually put the slice data
> > > > in the buffer like that.
> > > >  3) Not all the metadata is per-slice. Actually most of the metadata
> > > > is per frame and only what is located inside v4l2_h264_slice_param is
> > > > per-slice. The corresponding control is an array, which has an entry
> > > > for each slice in the buffer. Each entry includes an offset field,
> > > > which points to the place in the buffer where the slice is located.
> > >
> > > Sorry, I realize that my email wasn't very clear. What I meant to say
> > > is that the spec should specify that "at least the minimum unit size
> > > for decoding should be passed in a buffer" (that's maybe not the
> > > clearest wording), instead of "one frame worth of".
> > >
> > > I certainly don't mean to say that each slice should be held in a
> > > separate buffer and totally agree with all the points you're making :)
> >
> > Thanks for clarifying. I will update the document and post v3 accordingly.
> >
> > > I just think we should still allow userspace to pass slices with a
> > > finer granularity than "all the slices required for one frame".
> >
> > I'm afraid that doing so could open the door to some ambiguities. If
> > you allow that, then are you also allowed to send more than one frame
> > if the decode parameters do not change? How do drivers that only
> > support full frames react when handled only parts of a frame?
>
> IIRC the ability to pass individual slices was brought up regarding a
> potential latency benefit, but I doubt it would really be that
> significant.
>
> Thinking about it with the points you mentionned in mind, I guess the
> downsides are much more significant than the potential gain.
>
> So let's stick with requiring all the slices for a frame then!

Ack.

My view is that we can still loosen this requirement in the future,
possibly behind some driver capability flag, but starting with a
simpler API, with less freedom to the applications and less
constraints on hardware support sounds like a better practice in
general.

>
> Cheers,
>
> Paul
>
> > > However, it looks like supporting this might be a problem for the
> > > rockchip decoder though. Note that our Allwinner VPU can also process
> > > all slices one after the other, but can be configured for slice-level
> > > granularity while decoding (at least it looks that way).
> > >
> > > Side point: After some discussions with Thierry Reading, who's looking
> > > into the the Tegra VPU (also stateless), it seems that using the annex-
> > > b format for h.264 would be best for everyone. So that means including
> > > the start code, NAL header and "raw" slice data. I guess the same
> > > should apply to other codecs too. But that should be in the associated
> > > pixfmt spec, not in this general document.
> > >
> > > What do yout think?

Hmm, wouldn't that effectively make it the same as V4L2_PIX_FMT_H264?

By the way, I proposed it once, some time ago, but it was rejected
because VAAPI didn't get the full annex B stream and a V4L2 stateless
VAAPI backend would have to reconstruct the stream.

Best regards,
Tomasz
