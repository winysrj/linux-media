Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55101 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802AbbFYPND (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Jun 2015 11:13:03 -0400
Message-ID: <1435245167.3761.53.camel@pengutronix.de>
Subject: Re: [PATCH 1/2] [media] v4l2-mem2mem: set the queue owner field
 just as vb2_ioctl_reqbufs does
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Hans Verkuil <hans.verkuil@cisco.com>, kamil@wypas.org,
	linux-media@vger.kernel.org, kernel@pengutronix.de
Date: Thu, 25 Jun 2015 17:12:47 +0200
In-Reply-To: <558BFDED.1090006@samsung.com>
References: <1435226487-24863-1-git-send-email-p.zabel@pengutronix.de>
	 <558BFDED.1090006@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester,

Am Donnerstag, den 25.06.2015, 15:11 +0200 schrieb Sylwester Nawrocki:
> Hello Philipp,
> 
> On 25/06/15 12:01, Philipp Zabel wrote:
> > Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
> > ---
> >  drivers/media/v4l2-core/v4l2-mem2mem.c | 9 ++++++++-
> >  1 file changed, 8 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/media/v4l2-core/v4l2-mem2mem.c b/drivers/media/v4l2-core/v4l2-mem2mem.c
> > index dc853e5..511caaa 100644
> > --- a/drivers/media/v4l2-core/v4l2-mem2mem.c
> > +++ b/drivers/media/v4l2-core/v4l2-mem2mem.c
> > @@ -357,9 +357,16 @@ int v4l2_m2m_reqbufs(struct file *file, struct v4l2_m2m_ctx *m2m_ctx,
> >  		     struct v4l2_requestbuffers *reqbufs)
> >  {
> >  	struct vb2_queue *vq;
> > +	int ret;
> >  
> >  	vq = v4l2_m2m_get_vq(m2m_ctx, reqbufs->type);
> > -	return vb2_reqbufs(vq, reqbufs);
> > +	ret = vb2_reqbufs(vq, reqbufs);
> > +	/* If count == 0, then the owner has released all buffers and he
> > +	   is no longer owner of the queue. Otherwise we have a new owner. */
> > +	if (ret == 0)
> > +		vq->owner = reqbufs->count ? file->private_data : NULL;
> > +
> > +	return ret;
> >  }
> 
> How about modifying v4l2_m2m_ioctl_reqbufs() instead ?

The coda, gsc-m2m, m2m-deinterlace, mx2_emmaprp, and sh_veu drivers all
have their own implementation of vidioc_reqbufs that call
v4l2_m2m_reqbufs directly.
Maybe this should be moved into v4l2_m2m_ioctl_reqbufs after all drivers
are updated to use it instead of v4l2_m2m_reqbufs.

> Moreover, does it really makes sense when a new m2m device context
> is being created during each video device open()?

Having the queue owner's device minor in the trace output is very useful
when tracing a single stream across multiple devices. To discern events
from multiple simultaneous contexts I have added the context id to the
coda driver specific trace events.

regards
Philipp


