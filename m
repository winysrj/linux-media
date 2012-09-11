Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50312 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758762Ab2IKLTV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 11 Sep 2012 07:19:21 -0400
Subject: Re: [PATCH v4 12/16] media: coda: add byte size slice limit control
From: Philipp Zabel <p.zabel@pengutronix.de>
To: javier Martin <javier.martin@vista-silicon.com>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Richard Zhao <richard.zhao@freescale.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>, kernel@pengutronix.de
In-Reply-To: <CACKLOr06ymPN8Upt0Z_Vdq8=qwAnXOaWd1k3nVMUB3GOCqv1+g@mail.gmail.com>
References: <1347291000-340-1-git-send-email-p.zabel@pengutronix.de>
	 <1347291000-340-13-git-send-email-p.zabel@pengutronix.de>
	 <CACKLOr06ymPN8Upt0Z_Vdq8=qwAnXOaWd1k3nVMUB3GOCqv1+g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 Sep 2012 13:19:19 +0200
Message-ID: <1347362359.2615.41.camel@pizza.hi.pengutronix.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier,

Am Dienstag, den 11.09.2012, 12:50 +0200 schrieb javier Martin:
> On 10 September 2012 17:29, Philipp Zabel <p.zabel@pengutronix.de> wrote:
> > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> > ---
> >  drivers/media/platform/coda.c |   29 +++++++++++++++++++++++------
> >  1 file changed, 23 insertions(+), 6 deletions(-)
> >
> > diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
> > index 81e3401..863b96a 100644
> > --- a/drivers/media/platform/coda.c
> > +++ b/drivers/media/platform/coda.c
[...]
> > @@ -1346,10 +1361,12 @@ static int coda_ctrls_setup(struct coda_ctx *ctx)
> >                 V4L2_CID_MPEG_VIDEO_MPEG4_P_FRAME_QP, 1, 31, 1, 2);
> >         v4l2_ctrl_new_std_menu(&ctx->ctrls, &coda_ctrl_ops,
> >                 V4L2_CID_MPEG_VIDEO_MULTI_SLICE_MODE,
> > -               V4L2_MPEG_VIDEO_MULTI_SICE_MODE_MAX_MB, 0,
> > -               V4L2_MPEG_VIDEO_MULTI_SICE_MODE_MAX_MB);
> > +               V4L2_MPEG_VIDEO_MULTI_SICE_MODE_MAX_BYTES, 0x7,
> > +               V4L2_MPEG_VIDEO_MULTI_SLICE_MODE_SINGLE);
> 
> The mask must be 0x0 instead of 0x7. Otherwise you are forbidding all
> the possible values for this ctrl and that won't work.

Thank you, will fix that.

regards
Philipp

