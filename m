Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:55405 "EHLO
        metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751640AbdC0KLC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Mar 2017 06:11:02 -0400
Message-ID: <1490609415.2409.5.camel@pengutronix.de>
Subject: Re: [PATCH] [media] coda: remove redundant call to v4l2_m2m_get_vq
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Colin King <colin.king@canonical.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 27 Mar 2017 12:10:15 +0200
In-Reply-To: <45a3ba2e-634c-156b-71b4-75aa8d89827b@xs4all.nl>
References: <20170323115746.18474-1-colin.king@canonical.com>
         <45a3ba2e-634c-156b-71b4-75aa8d89827b@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2017-03-27 at 11:46 +0200, Hans Verkuil wrote:
> On 23/03/17 12:57, Colin King wrote:
> > From: Colin Ian King <colin.king@canonical.com>
> > 
> > The call to v4ls_m2m_get_vq is only used to get the return value
> > which is not being used, so it appears to be redundant and can
> > be removed.
> > 
> > Detected with CoverityScan, CID#1420674 ("Useless call")
> > 
> > Signed-off-by: Colin Ian King <colin.king@canonical.com>
> > ---
> >  drivers/media/platform/coda/coda-common.c | 2 --
> >  1 file changed, 2 deletions(-)
> > 
> > diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
> > index 800d2477f1a0..95e4648f18e6 100644
> > --- a/drivers/media/platform/coda/coda-common.c
> > +++ b/drivers/media/platform/coda/coda-common.c
> > @@ -817,8 +817,6 @@ static int coda_qbuf(struct file *file, void *priv,
> >  static bool coda_buf_is_end_of_stream(struct coda_ctx *ctx,
> >  				      struct vb2_v4l2_buffer *buf)
> >  {
> > -	v4l2_m2m_get_vq(ctx->fh.m2m_ctx, V4L2_BUF_TYPE_VIDEO_OUTPUT);
> > -
> >  	return ((ctx->bit_stream_param & CODA_BIT_STREAM_END_FLAG) &&
> >  		(buf->sequence == (ctx->qsequence - 1)));
> >  }
> > 
> 
> Philipp, is this correct, or should this actually check whether the queue is an
> output queue?

Yes, this was previously assigned to an unused local variable src_vq,
since initial commit 918c66fd4126 ("[media] coda: add CODA7541 decoding
support").

coda_buf_is_end_of_stream is called from coda_m2m_buf_done, which is
exclusively used on destination buffers on the capture queue.

Acked-by: Philipp Zabel <p.zabel@pengutronix.de>

regards
Philipp
