Return-Path: <SRS0=42/h=QA=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1CDFC282C5
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 08:59:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C184D21872
	for <linux-media@archiver.kernel.org>; Thu, 24 Jan 2019 08:59:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727652AbfAXI7w (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 24 Jan 2019 03:59:52 -0500
Received: from mail.bootlin.com ([62.4.15.54]:57280 "EHLO mail.bootlin.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727208AbfAXI7u (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 24 Jan 2019 03:59:50 -0500
Received: by mail.bootlin.com (Postfix, from userid 110)
        id 00E2B207B0; Thu, 24 Jan 2019 09:59:47 +0100 (CET)
Received: from aptenodytes (aaubervilliers-681-1-87-206.w90-88.abo.wanadoo.fr [90.88.29.206])
        by mail.bootlin.com (Postfix) with ESMTPSA id 9F2042084E;
        Thu, 24 Jan 2019 09:59:37 +0100 (CET)
Message-ID: <c93952fb3ddac34c03f4fdc2dedd0bc8b88a00a9.camel@bootlin.com>
Subject: Re: [PATCH] media: docs-rst: Document m2m stateless video decoder
 interface
From:   Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To:     Tomasz Figa <tfiga@chromium.org>
Cc:     Alexandre Courbot <acourbot@chromium.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Pawel Osciak <posciak@chromium.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>
Date:   Thu, 24 Jan 2019 09:59:38 +0100
In-Reply-To: <CAAFQd5CFHJaEELbihq6aNxSOzWghunG-qiqxM9xL1n4q1yBp9g@mail.gmail.com>
References: <20181205100121.181765-1-acourbot@chromium.org>
         <e2b464c83892b79c77fd7388733758b2e02813d2.camel@bootlin.com>
         <CAAFQd5Aw=A2+pdtJijQ78-nV5qU5ypYjjEFV8rpPk=Je1LajqA@mail.gmail.com>
         <dd07f7ddf2c3790871861855143d3f49359e4f74.camel@bootlin.com>
         <CAPBb6MVnfCRjVBDyKEw=CQnxjq1xFR03Uka+Jxw=kAia5BfFVQ@mail.gmail.com>
         <42a24867b3b4506cdb7e738eec5b2b8316f8ca19.camel@bootlin.com>
         <CAAFQd5CFHJaEELbihq6aNxSOzWghunG-qiqxM9xL1n4q1yBp9g@mail.gmail.com>
Organization: Bootlin
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi,

On Thu, 2019-01-24 at 17:07 +0900, Tomasz Figa wrote:
> On Wed, Jan 23, 2019 at 7:42 PM Paul Kocialkowski
> <paul.kocialkowski@bootlin.com> wrote:
> > Hi Alex,
> > 
> > On Wed, 2019-01-23 at 18:43 +0900, Alexandre Courbot wrote:
> > > On Tue, Jan 22, 2019 at 7:10 PM Paul Kocialkowski
> > > <paul.kocialkowski@bootlin.com> wrote:
> > > > Hi,
> > > > 
> > > > On Tue, 2019-01-22 at 17:19 +0900, Tomasz Figa wrote:
> > > > > Hi Paul,
> > > > > 
> > > > > On Fri, Dec 7, 2018 at 5:30 PM Paul Kocialkowski
> > > > > <paul.kocialkowski@bootlin.com> wrote:
> > > > > > Hi,
> > > > > > 
> > > > > > Thanks for this new version! I only have one comment left, see below.
> > > > > > 
> > > > > > On Wed, 2018-12-05 at 19:01 +0900, Alexandre Courbot wrote:
> > > > > > > Documents the protocol that user-space should follow when
> > > > > > > communicating with stateless video decoders.
> > > > > > > 
> > > > > > > The stateless video decoding API makes use of the new request and tags
> > > > > > > APIs. While it has been implemented with the Cedrus driver so far, it
> > > > > > > should probably still be considered staging for a short while.
> > > > > > > 
> > > > > > > Signed-off-by: Alexandre Courbot <acourbot@chromium.org>
> > > > > > > ---
> > > > > > > Removing the RFC flag this time. Changes since RFCv3:
> > > > > > > 
> > > > > > > * Included Tomasz and Hans feedback,
> > > > > > > * Expanded the decoding section to better describe the use of requests,
> > > > > > > * Use the tags API.
> > > > > > > 
> > > > > > >  Documentation/media/uapi/v4l/dev-codec.rst    |   5 +
> > > > > > >  .../media/uapi/v4l/dev-stateless-decoder.rst  | 399 ++++++++++++++++++
> > > > > > >  2 files changed, 404 insertions(+)
> > > > > > >  create mode 100644 Documentation/media/uapi/v4l/dev-stateless-decoder.rst
> > > > > > > 
> > > > > > > diff --git a/Documentation/media/uapi/v4l/dev-codec.rst b/Documentation/media/uapi/v4l/dev-codec.rst
> > > > > > > index c61e938bd8dc..3e6a3e883f11 100644
> > > > > > > --- a/Documentation/media/uapi/v4l/dev-codec.rst
> > > > > > > +++ b/Documentation/media/uapi/v4l/dev-codec.rst
> > > > > > > @@ -6,6 +6,11 @@
> > > > > > >  Codec Interface
> > > > > > >  ***************
> > > > > > > 
> > > > > > > +.. toctree::
> > > > > > > +    :maxdepth: 1
> > > > > > > +
> > > > > > > +    dev-stateless-decoder
> > > > > > > +
> > > > > > >  A V4L2 codec can compress, decompress, transform, or otherwise convert
> > > > > > >  video data from one format into another format, in memory. Typically
> > > > > > >  such devices are memory-to-memory devices (i.e. devices with the
> > > > > > > diff --git a/Documentation/media/uapi/v4l/dev-stateless-decoder.rst b/Documentation/media/uapi/v4l/dev-stateless-decoder.rst
> > > > > > > new file mode 100644
> > > > > > > index 000000000000..7a781c89bd59
> > > > > > > --- /dev/null
> > > > > > > +++ b/Documentation/media/uapi/v4l/dev-stateless-decoder.rst
> > > > > > > @@ -0,0 +1,399 @@
> > > > > > > +.. -*- coding: utf-8; mode: rst -*-
> > > > > > > +
> > > > > > > +.. _stateless_decoder:
> > > > > > > +
> > > > > > > +**************************************************
> > > > > > > +Memory-to-memory Stateless Video Decoder Interface
> > > > > > > +**************************************************
> > > > > > > +
> > > > > > > +A stateless decoder is a decoder that works without retaining any kind of state
> > > > > > > +between processing frames. This means that each frame is decoded independently
> > > > > > > +of any previous and future frames, and that the client is responsible for
> > > > > > > +maintaining the decoding state and providing it to the decoder with each
> > > > > > > +decoding request. This is in contrast to the stateful video decoder interface,
> > > > > > > +where the hardware and driver maintain the decoding state and all the client
> > > > > > > +has to do is to provide the raw encoded stream.
> > > > > > > +
> > > > > > > +This section describes how user-space ("the client") is expected to communicate
> > > > > > > +with such decoders in order to successfully decode an encoded stream. Compared
> > > > > > > +to stateful codecs, the decoder/client sequence is simpler, but the cost of
> > > > > > > +this simplicity is extra complexity in the client which must maintain a
> > > > > > > +consistent decoding state.
> > > > > > > +
> > > > > > > +Stateless decoders make use of the request API and buffer tags. A stateless
> > > > > > > +decoder must thus expose the following capabilities on its queues when
> > > > > > > +:c:func:`VIDIOC_REQBUFS` or :c:func:`VIDIOC_CREATE_BUFS` are invoked:
> > > > > > > +
> > > > > > > +* The ``V4L2_BUF_CAP_SUPPORTS_REQUESTS`` capability must be set on the
> > > > > > > +  ``OUTPUT`` queue,
> > > > > > > +
> > > > > > > +* The ``V4L2_BUF_CAP_SUPPORTS_TAGS`` capability must be set on the ``OUTPUT``
> > > > > > > +  and ``CAPTURE`` queues,
> > > > > > > +
> > > > > > 
> > > > > > [...]
> > > > > > 
> > > > > > > +Decoding
> > > > > > > +========
> > > > > > > +
> > > > > > > +For each frame, the client is responsible for submitting a request to which the
> > > > > > > +following is attached:
> > > > > > > +
> > > > > > > +* Exactly one frame worth of encoded data in a buffer submitted to the
> > > > > > > +  ``OUTPUT`` queue,
> > > > > > 
> > > > > > Although this is still the case in the cedrus driver (but will be fixed
> > > > > > eventually), this requirement should be dropped because metadata is
> > > > > > per-slice and not per-picture in the formats we're currently aiming to
> > > > > > support.
> > > > > > 
> > > > > > I think it would be safer to mention something like filling the output
> > > > > > buffer with the minimum unit size for the selected output format, to
> > > > > > which the associated metadata applies.
> > > > > 
> > > > > I'm not sure it's a good idea. Some of the reasons why I think so:
> > > > >  1) There are streams that can have even 32 slices. With that, you
> > > > > instantly run out of V4L2 buffers even just for 1 frame.
> > > > >  2) The Rockchip hardware which seems to just pick all the slices one
> > > > > after another and which was the reason to actually put the slice data
> > > > > in the buffer like that.
> > > > >  3) Not all the metadata is per-slice. Actually most of the metadata
> > > > > is per frame and only what is located inside v4l2_h264_slice_param is
> > > > > per-slice. The corresponding control is an array, which has an entry
> > > > > for each slice in the buffer. Each entry includes an offset field,
> > > > > which points to the place in the buffer where the slice is located.
> > > > 
> > > > Sorry, I realize that my email wasn't very clear. What I meant to say
> > > > is that the spec should specify that "at least the minimum unit size
> > > > for decoding should be passed in a buffer" (that's maybe not the
> > > > clearest wording), instead of "one frame worth of".
> > > > 
> > > > I certainly don't mean to say that each slice should be held in a
> > > > separate buffer and totally agree with all the points you're making :)
> > > 
> > > Thanks for clarifying. I will update the document and post v3 accordingly.
> > > 
> > > > I just think we should still allow userspace to pass slices with a
> > > > finer granularity than "all the slices required for one frame".
> > > 
> > > I'm afraid that doing so could open the door to some ambiguities. If
> > > you allow that, then are you also allowed to send more than one frame
> > > if the decode parameters do not change? How do drivers that only
> > > support full frames react when handled only parts of a frame?
> > 
> > IIRC the ability to pass individual slices was brought up regarding a
> > potential latency benefit, but I doubt it would really be that
> > significant.
> > 
> > Thinking about it with the points you mentionned in mind, I guess the
> > downsides are much more significant than the potential gain.
> > 
> > So let's stick with requiring all the slices for a frame then!
> 
> Ack.
> 
> My view is that we can still loosen this requirement in the future,
> possibly behind some driver capability flag, but starting with a
> simpler API, with less freedom to the applications and less
> constraints on hardware support sounds like a better practice in
> general.

Sounds good, a capability flag would definitely make sense for that.

> > > > Side point: After some discussions with Thierry Reading, who's looking
> > > > into the the Tegra VPU (also stateless), it seems that using the annex-
> > > > b format for h.264 would be best for everyone. So that means including
> > > > the start code, NAL header and "raw" slice data. I guess the same
> > > > should apply to other codecs too. But that should be in the associated
> > > > pixfmt spec, not in this general document.
> > > > 
> > > > What do yout think?
> 
> Hmm, wouldn't that effectively make it the same as V4L2_PIX_FMT_H264?

Well, this would only concern the slice NAL unit. As far as I
understood, V4L2_PIX_FMT_H264 takes all sorts of NAL units.

> By the way, I proposed it once, some time ago, but it was rejected
> because VAAPI didn't get the full annex B stream and a V4L2 stateless
> VAAPI backend would have to reconstruct the stream.

Oh, right I remember. After a close look, this is apparently not the
case, according to the VAAPI docs at: 
http://intel.github.io/libva/structVASliceParameterBufferH264.html

Also looking at ffmpeg, VAAPI and VDPAU seem to pass the same data,
except that VDPAU adds a start code prefix (which IIRC is required by
the rockchip decoder):

- VAAPI: https://github.com/FFmpeg/FFmpeg/blob/master/libavcodec/vaapi_h264.c#L331
- VDPAU: https://github.com/FFmpeg/FFmpeg/blob/master/libavcodec/vdpau_h264.c#L182

So I was initially a bit reluctant to make it part of the spec that the
full slice NAL should be passed since that would imply geting the NAL
header info both in parsed form through the control and in raw form
along with the slice data. But it looks like it might be rather common
for decoders to require this if the tegra decoder also needs it.

Cheers,

Paul

-- 
Paul Kocialkowski, Bootlin
Embedded Linux and kernel engineering
https://bootlin.com

