Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50877 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754531Ab3I3NXZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Sep 2013 09:23:25 -0400
Message-ID: <1380547384.3959.12.camel@pizza.hi.pengutronix.de>
Subject: Re: [PATCH 04/10] [media] coda: fix FMO value setting for CodaDx6
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Javier Martin <javier.martin@vista-silicon.com>,
	Hans Verkuil <hans.verkuil@cisco.com>, kernel@pengutronix.de
Date: Mon, 30 Sep 2013 15:23:04 +0200
In-Reply-To: <524964F9.80804@xs4all.nl>
References: <1379582036-4840-1-git-send-email-p.zabel@pengutronix.de>
	 <1379582036-4840-5-git-send-email-p.zabel@pengutronix.de>
	 <524964F9.80804@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Montag, den 30.09.2013, 13:48 +0200 schrieb Hans Verkuil:
> On 09/19/2013 11:13 AM, Philipp Zabel wrote:
> > The register is only written on CodaDx6, so the temporary variable
> > to be written only needs to be initialized on CodaDx6.
> > 
> > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> > ---
> >  drivers/media/platform/coda.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
> > index 53539c1..e8acff3 100644
> > --- a/drivers/media/platform/coda.c
> > +++ b/drivers/media/platform/coda.c
> > @@ -2074,10 +2074,10 @@ static int coda_start_streaming(struct vb2_queue *q, unsigned int count)
> >  	coda_setup_iram(ctx);
> >  
> >  	if (dst_fourcc == V4L2_PIX_FMT_H264) {
> > -		value  = (FMO_SLICE_SAVE_BUF_SIZE << 7);
> > -		value |= (0 & CODA_FMOPARAM_TYPE_MASK) << CODA_FMOPARAM_TYPE_OFFSET;
> > -		value |=  0 & CODA_FMOPARAM_SLICENUM_MASK;
> >  		if (dev->devtype->product == CODA_DX6) {
> > +			value  = (FMO_SLICE_SAVE_BUF_SIZE << 7);
> > +			value |= (0 & CODA_FMOPARAM_TYPE_MASK) << CODA_FMOPARAM_TYPE_OFFSET;
> > +			value |=  0 & CODA_FMOPARAM_SLICENUM_MASK;
> 
> 0 & CODA_FMOPARAM_SLICENUM_MASK?
> 
> These last two lines evaluate to a nop, so that looks very weird. Is this a bug?

I assume Javier added those for documentation purposes. The newer CODA
cores don't have the FMO configuration anymore. I'll remove the no-op
lines for now if he doesn't mind.

regards
Philipp

