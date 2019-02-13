Return-Path: <SRS0=D6oO=QU=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C093C282C2
	for <linux-media@archiver.kernel.org>; Wed, 13 Feb 2019 12:51:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C9EDB222BA
	for <linux-media@archiver.kernel.org>; Wed, 13 Feb 2019 12:51:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731642AbfBMMvf (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Wed, 13 Feb 2019 07:51:35 -0500
Received: from relay10.mail.gandi.net ([217.70.178.230]:52749 "EHLO
        relay10.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731246AbfBMMve (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 13 Feb 2019 07:51:34 -0500
Received: from aptenodytes (aaubervilliers-681-1-89-68.w90-88.abo.wanadoo.fr [90.88.30.68])
        (Authenticated sender: paul.kocialkowski@bootlin.com)
        by relay10.mail.gandi.net (Postfix) with ESMTPSA id 6F2D8240002;
        Wed, 13 Feb 2019 12:51:32 +0000 (UTC)
Message-ID: <8bf8ed542af47e2ad30b4bdcc7bd5d2a343ead96.camel@bootlin.com>
Subject: Re: [PATCHv2 3/3] vb2: add 'match' arg to vb2_find_buffer()
From:   Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To:     Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Alexandre Courbot <acourbot@chromium.org>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Nicolas Dufresne <nicolas@ndufresne.ca>,
        Tomasz Figa <tfiga@chromium.org>
Date:   Wed, 13 Feb 2019 13:51:31 +0100
In-Reply-To: <d8a46701-5333-ee41-a53b-0cad2a079330@xs4all.nl>
References: <20190204101134.56283-1-hverkuil-cisco@xs4all.nl>
         <20190204101134.56283-4-hverkuil-cisco@xs4all.nl>
         <CAPBb6MUn87+Pu2HNv7MF7vHaqQw-3mQQfDaeu1GtbD=hnDfo1A@mail.gmail.com>
         <33c85a26-0133-8c0a-46f7-458c1cbe61fb@xs4all.nl>
         <c2ec7876bd59d6b81fbb1435f8f7a6e4c2d83fb7.camel@bootlin.com>
         <d8a46701-5333-ee41-a53b-0cad2a079330@xs4all.nl>
Organization: Bootlin
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

On Wed, 2019-02-13 at 10:39 +0100, Hans Verkuil wrote:
> On 2/13/19 10:08 AM, Paul Kocialkowski wrote:
> > Hi,
> > 
> > On Wed, 2019-02-13 at 09:20 +0100, Hans Verkuil wrote:
> > As far as I understand from [0], the capture and output formats can't
> > be changed once we have allocated buffers so I don't really see how we
> > could end up with mixed resolutions.
> 
> Actually, looking at the cedrus code it is missing the check for this:
> both cedrus_s_fmt_vid_cap and cedrus_s_fmt_vid_out should call vb2_is_busy()
> and return EBUSY if that returns true.
> 
> Right now it is perfectly fine for userspace to call S_FMT while buffers
> are allocated.
> 
> This is a cedrus bug that should be fixed.

Definitely yes, we totally missed that. I'll send a fix soon.

> Note that v4l2-compliance doesn't check for this, but it probably should.
> Or at least warn about it. It is not necessarily wrong to call S_FMT while
> buffers are allocated, but the driver has to be able to handle this and
> do the necessary checks. But I don't think there are any drivers today that
> can handle this.

Yes I agree that it would make sense to check this.

Cheers,

Paul

> Regards,
> 
> 	Hans
> 
> > [0]: https://linuxtv.org/downloads/v4l-dvb-apis/uapi/v4l/open.html#multiple-opens
> > 
> > Cheers,
> > 
> > Paul
> > 
> > > The refcount increase is unrelated to this. That would protect against
> > > a potential race condition, not against a size mismatch.
> > > 
> > > In the meantime, can you review/test patches 1 and 2? I'd like to get
> > > those in first.
> > > 
> > > Thanks!
> > > 
> > > 	Hans
> > > 
> > > > 
> > > > > Update the cedrus driver accordingly.
> > > > > 
> > > > > Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
> > > > > ---
> > > > >  drivers/media/common/videobuf2/videobuf2-v4l2.c   | 15 ++++++++++++---
> > > > >  drivers/staging/media/sunxi/cedrus/cedrus_mpeg2.c |  8 ++++----
> > > > >  include/media/videobuf2-v4l2.h                    |  3 ++-
> > > > >  3 files changed, 18 insertions(+), 8 deletions(-)
> > > > > 
> > > > > diff --git a/drivers/media/common/videobuf2/videobuf2-v4l2.c b/drivers/media/common/videobuf2/videobuf2-v4l2.c
> > > > > index 55277370c313..0207493c8877 100644
> > > > > --- a/drivers/media/common/videobuf2/videobuf2-v4l2.c
> > > > > +++ b/drivers/media/common/videobuf2/videobuf2-v4l2.c
> > > > > @@ -599,14 +599,23 @@ static const struct vb2_buf_ops v4l2_buf_ops = {
> > > > >  };
> > > > > 
> > > > >  int vb2_find_timestamp(const struct vb2_queue *q, u64 timestamp,
> > > > > -                      unsigned int start_idx)
> > > > > +                      const struct vb2_buffer *match, unsigned int start_idx)
> > > > >  {
> > > > >         unsigned int i;
> > > > > 
> > > > >         for (i = start_idx; i < q->num_buffers; i++)
> > > > >                 if (q->bufs[i]->copied_timestamp &&
> > > > > -                   q->bufs[i]->timestamp == timestamp)
> > > > > -                       return i;
> > > > > +                   q->bufs[i]->timestamp == timestamp &&
> > > > > +                   q->bufs[i]->num_planes == match->num_planes) {
> > > > > +                       unsigned int p;
> > > > > +
> > > > > +                       for (p = 0; p < match->num_planes; p++)
> > > > > +                               if (q->bufs[i]->planes[p].length <
> > > > > +                                   match->planes[p].length)
> > > > > +                                       break;
> > > > > +                       if (p == match->num_planes)
> > > > > +                               return i;
> > > > > +               }
> > > > >         return -1;
> > > > >  }
> > > > >  EXPORT_SYMBOL_GPL(vb2_find_timestamp);
> > > > > diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_mpeg2.c b/drivers/staging/media/sunxi/cedrus/cedrus_mpeg2.c
> > > > > index cb45fda9aaeb..16bc82f1cb2c 100644
> > > > > --- a/drivers/staging/media/sunxi/cedrus/cedrus_mpeg2.c
> > > > > +++ b/drivers/staging/media/sunxi/cedrus/cedrus_mpeg2.c
> > > > > @@ -159,8 +159,8 @@ static void cedrus_mpeg2_setup(struct cedrus_ctx *ctx, struct cedrus_run *run)
> > > > >         cedrus_write(dev, VE_DEC_MPEG_PICBOUNDSIZE, reg);
> > > > > 
> > > > >         /* Forward and backward prediction reference buffers. */
> > > > > -       forward_idx = vb2_find_timestamp(cap_q,
> > > > > -                                        slice_params->forward_ref_ts, 0);
> > > > > +       forward_idx = vb2_find_timestamp(cap_q, slice_params->forward_ref_ts,
> > > > > +                                        &run->dst->vb2_buf, 0);
> > > > > 
> > > > >         fwd_luma_addr = cedrus_dst_buf_addr(ctx, forward_idx, 0);
> > > > >         fwd_chroma_addr = cedrus_dst_buf_addr(ctx, forward_idx, 1);
> > > > > @@ -168,8 +168,8 @@ static void cedrus_mpeg2_setup(struct cedrus_ctx *ctx, struct cedrus_run *run)
> > > > >         cedrus_write(dev, VE_DEC_MPEG_FWD_REF_LUMA_ADDR, fwd_luma_addr);
> > > > >         cedrus_write(dev, VE_DEC_MPEG_FWD_REF_CHROMA_ADDR, fwd_chroma_addr);
> > > > > 
> > > > > -       backward_idx = vb2_find_timestamp(cap_q,
> > > > > -                                         slice_params->backward_ref_ts, 0);
> > > > > +       backward_idx = vb2_find_timestamp(cap_q, slice_params->backward_ref_ts,
> > > > > +                                         &run->dst->vb2_buf, 0);
> > > > >         bwd_luma_addr = cedrus_dst_buf_addr(ctx, backward_idx, 0);
> > > > >         bwd_chroma_addr = cedrus_dst_buf_addr(ctx, backward_idx, 1);
> > > > > 
> > > > > diff --git a/include/media/videobuf2-v4l2.h b/include/media/videobuf2-v4l2.h
> > > > > index 8a10889dc2fd..b123d12424ba 100644
> > > > > --- a/include/media/videobuf2-v4l2.h
> > > > > +++ b/include/media/videobuf2-v4l2.h
> > > > > @@ -60,6 +60,7 @@ struct vb2_v4l2_buffer {
> > > > >   *
> > > > >   * @q:         pointer to &struct vb2_queue with videobuf2 queue.
> > > > >   * @timestamp: the timestamp to find.
> > > > > + * @match:     the properties of the buffer to find must match this buffer.
> > > > >   * @start_idx: the start index (usually 0) in the buffer array to start
> > > > >   *             searching from. Note that there may be multiple buffers
> > > > >   *             with the same timestamp value, so you can restart the search
> > > > > @@ -69,7 +70,7 @@ struct vb2_v4l2_buffer {
> > > > >   * -1 if no buffer with @timestamp was found.
> > > > >   */
> > > > >  int vb2_find_timestamp(const struct vb2_queue *q, u64 timestamp,
> > > > > -                      unsigned int start_idx);
> > > > > +                      const struct vb2_buffer *match, unsigned int start_idx);
> > > > > 
> > > > >  int vb2_querybuf(struct vb2_queue *q, struct v4l2_buffer *b);
> > > > > 
> > > > > --
> > > > > 2.20.1
> > > > > 
-- 
Paul Kocialkowski, Bootlin
Embedded Linux and kernel engineering
https://bootlin.com

