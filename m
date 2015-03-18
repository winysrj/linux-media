Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:38029 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123AbbCRKoE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Mar 2015 06:44:04 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NLE00EFOM067R00@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Wed, 18 Mar 2015 10:48:06 +0000 (GMT)
From: Kamil Debski <k.debski@samsung.com>
To: 'Jean-Michel Hautbois' <jhautbois@gmail.com>,
	'Philipp Zabel' <p.zabel@pengutronix.de>
Cc: 'Peter Seiderer' <ps.report@gmx.net>,
	'Linux Media Mailing List' <linux-media@vger.kernel.org>,
	'Sascha Hauer' <kernel@pengutronix.de>
References: <1424704813-20792-1-git-send-email-p.zabel@pengutronix.de>
 <1424704813-20792-11-git-send-email-p.zabel@pengutronix.de>
 <CAL8zT=iEZC4beWdMQD-vagRh9E7nwqprqrtRB7FVR9wpre45OQ@mail.gmail.com>
In-reply-to: <CAL8zT=iEZC4beWdMQD-vagRh9E7nwqprqrtRB7FVR9wpre45OQ@mail.gmail.com>
Subject: RE: [PATCH 10/12] [media] coda: fail to start streaming if userspace
 set invalid formats
Date: Wed, 18 Mar 2015 11:44:01 +0100
Message-id: <013c01d06168$72da5a30$588f0e90$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Philipp,

> From: Jean-Michel Hautbois [mailto:jhautbois@gmail.com]
> Sent: Friday, February 27, 2015 10:00 AM
> To: Philipp Zabel
> Cc: Kamil Debski; Peter Seiderer; Linux Media Mailing List; Sascha
> Hauer
> Subject: Re: [PATCH 10/12] [media] coda: fail to start streaming if
> userspace set invalid formats
> 
> Hi Philipp,
> 
> 2015-02-23 16:20 GMT+01:00 Philipp Zabel <p.zabel@pengutronix.de>:

Could you add a description to this patch?
Also, please remember about this patch https://patchwork.linuxtv.org/patch/28016.
It also needs a description.

Best wishes,
-- 
Kamil Debski
Samsung R&D Institute Poland

> > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> > ---
> >  drivers/media/platform/coda/coda-common.c | 13 ++++++++++++-
> >  1 file changed, 12 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/media/platform/coda/coda-common.c
> > b/drivers/media/platform/coda/coda-common.c
> > index b42ccfc..4441179 100644
> > --- a/drivers/media/platform/coda/coda-common.c
> > +++ b/drivers/media/platform/coda/coda-common.c
> > @@ -1282,12 +1282,23 @@ static int coda_start_streaming(struct
> vb2_queue *q, unsigned int count)
> >         if (!(ctx->streamon_out & ctx->streamon_cap))
> >                 return 0;
> >
> > +       q_data_dst = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
> > +       if ((q_data_src->width != q_data_dst->width &&
> > +            round_up(q_data_src->width, 16) != q_data_dst->width) ||
> > +           (q_data_src->height != q_data_dst->height &&
> > +            round_up(q_data_src->height, 16) != q_data_dst->height))
> {
> > +               v4l2_err(v4l2_dev, "can't convert %dx%d to %dx%d\n",
> > +                        q_data_src->width, q_data_src->height,
> > +                        q_data_dst->width, q_data_dst->height);
> > +               ret = -EINVAL;
> > +               goto err;
> > +       }
> > +
> 
> Shouldn't the driver check on queues related to encoding or decoding
> only ?
> We don't need to set correct width/height from userspace if we are
> encoding, or it should be done by s_fmt itself.
> 
> Thanks,
> JM

