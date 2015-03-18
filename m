Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54367 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755488AbbCRLaw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Mar 2015 07:30:52 -0400
Message-ID: <1426678247.30356.9.camel@pengutronix.de>
Subject: Re: [PATCH 10/12] [media] coda: fail to start streaming if
 userspace set invalid formats
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Jean-Michel Hautbois <jhautbois@gmail.com>
Cc: Kamil Debski <k.debski@samsung.com>,
	Peter Seiderer <ps.report@gmx.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sascha Hauer <kernel@pengutronix.de>
Date: Wed, 18 Mar 2015 12:30:47 +0100
In-Reply-To: <CAL8zT=iEZC4beWdMQD-vagRh9E7nwqprqrtRB7FVR9wpre45OQ@mail.gmail.com>
References: <1424704813-20792-1-git-send-email-p.zabel@pengutronix.de>
	 <1424704813-20792-11-git-send-email-p.zabel@pengutronix.de>
	 <CAL8zT=iEZC4beWdMQD-vagRh9E7nwqprqrtRB7FVR9wpre45OQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Freitag, den 27.02.2015, 09:59 +0100 schrieb Jean-Michel Hautbois:
> Hi Philipp,
> 
> 2015-02-23 16:20 GMT+01:00 Philipp Zabel <p.zabel@pengutronix.de>:
> > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> > ---
> >  drivers/media/platform/coda/coda-common.c | 13 ++++++++++++-
> >  1 file changed, 12 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
> > index b42ccfc..4441179 100644
> > --- a/drivers/media/platform/coda/coda-common.c
> > +++ b/drivers/media/platform/coda/coda-common.c
> > @@ -1282,12 +1282,23 @@ static int coda_start_streaming(struct vb2_queue *q, unsigned int count)
> >         if (!(ctx->streamon_out & ctx->streamon_cap))
> >                 return 0;
> >
> > +       q_data_dst = get_q_data(ctx, V4L2_BUF_TYPE_VIDEO_CAPTURE);
> > +       if ((q_data_src->width != q_data_dst->width &&
> > +            round_up(q_data_src->width, 16) != q_data_dst->width) ||
> > +           (q_data_src->height != q_data_dst->height &&
> > +            round_up(q_data_src->height, 16) != q_data_dst->height)) {
> > +               v4l2_err(v4l2_dev, "can't convert %dx%d to %dx%d\n",
> > +                        q_data_src->width, q_data_src->height,
> > +                        q_data_dst->width, q_data_dst->height);
> > +               ret = -EINVAL;
> > +               goto err;
> > +       }
> > +
> 
> Shouldn't the driver check on queues related to encoding or decoding only ?
> We don't need to set correct width/height from userspace if we are
> encoding, or it should be done by s_fmt itself.

Good point, the notes from the V4L2 codec API session during ELCE2014
say:
   "the coded format is always the master; changing format on it
    changes the set of supported formats on the other queue;"

Since an unsupported format shouldn't be selected, this implies that
S_FMT on an encoder capture queue should possibly change the format on
the output queue at the same time.
If I enforce compatible output and capture formats during S_FMT,
this check is indeed not needed.

regards
Philipp

