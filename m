Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39670 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753727AbaGVI4z (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Jul 2014 04:56:55 -0400
Message-ID: <1406019410.4496.3.camel@paszta.hi.pengutronix.de>
Subject: Re: [PATCH v3 18/32] [media] v4l2-mem2mem: export
 v4l2_m2m_try_schedule
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org, Kamil Debski <k.debski@samsung.com>,
	Fabio Estevam <fabio.estevam@freescale.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	kernel@pengutronix.de, Michael Olbrich <m.olbrich@pengutronix.de>,
	Pawel Osciak <p.osciak@samsung.com>
Date: Tue, 22 Jul 2014 10:56:50 +0200
In-Reply-To: <20140721160432.12e34653.m.chehab@samsung.com>
References: <1405071403-1859-1-git-send-email-p.zabel@pengutronix.de>
	 <1405071403-1859-19-git-send-email-p.zabel@pengutronix.de>
	 <20140721160432.12e34653.m.chehab@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am Montag, den 21.07.2014, 16:04 -0300 schrieb Mauro Carvalho Chehab:
> Em Fri, 11 Jul 2014 11:36:29 +0200
> Philipp Zabel <p.zabel@pengutronix.de> escreveu:
> 
> > From: Michael Olbrich <m.olbrich@pengutronix.de>
> > 
> > Some drivers might allow to decode remaining frames from an internal ringbuffer
> > after a decoder stop command. Allow those to call v4l2_m2m_try_schedule
> > directly.
> > 
> > Signed-off-by: Michael Olbrich <m.olbrich@pengutronix.de>
> > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> > ---
> >  drivers/media/v4l2-core/v4l2-mem2mem.c | 3 ++-
> >  include/media/v4l2-mem2mem.h           | 2 ++
> >  2 files changed, 4 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c b/drivers/media/v4l2-core/v4l2-mem2mem.c
> > index 178ce96..5f5c175 100644
> > --- a/drivers/media/v4l2-core/v4l2-mem2mem.c
> > +++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
> > @@ -208,7 +208,7 @@ static void v4l2_m2m_try_run(struct v4l2_m2m_dev *m2m_dev)
> >   * An example of the above could be an instance that requires more than one
> >   * src/dst buffer per transaction.
> >   */
> > -static void v4l2_m2m_try_schedule(struct v4l2_m2m_ctx *m2m_ctx)
> > +void v4l2_m2m_try_schedule(struct v4l2_m2m_ctx *m2m_ctx)
> >  {
> >  	struct v4l2_m2m_dev *m2m_dev;
> >  	unsigned long flags_job, flags_out, flags_cap;
> > @@ -274,6 +274,7 @@ static void v4l2_m2m_try_schedule(struct v4l2_m2m_ctx *m2m_ctx)
> >  
> >  	v4l2_m2m_try_run(m2m_dev);
> >  }
> > +EXPORT_SYMBOL(v4l2_m2m_try_schedule);
> 
> Please use EXPORT_SYMBOL_GPL() instead.

Are you sure about this? I see that Pawel (added to Cc:) exported
v4l2_m2m_get_vq, v4l2_m2m_get_curr_priv, v4l2_m2m_mmap, and
v4l2_m2m_job_finish (which calls v4l2_m2m_try_schedule) also using
EXPORT_SYMBOL() while all other functions are EXPORT_SYMBOL_GPL()
Is there some reasoning behind this, or is it accidental?

regards
Philipp

