Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:9483 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755365Ab3HAP2A (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 1 Aug 2013 11:28:00 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MQU001PCYYLLRB0@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 01 Aug 2013 16:27:58 +0100 (BST)
From: Kamil Debski <k.debski@samsung.com>
To: 'Philipp Zabel' <p.zabel@pengutronix.de>,
	'Fabio Estevam' <fabio.estevam@freescale.com>
Cc: m.chehab@samsung.com, kernel@pengutronix.de,
	linux-media@vger.kernel.org
References: <1374602690-12842-1-git-send-email-fabio.estevam@freescale.com>
 <1374659222.3929.4.camel@pizza.hi.pengutronix.de>
In-reply-to: <1374659222.3929.4.camel@pizza.hi.pengutronix.de>
Subject: RE: [PATCH v4 1/3] [media] coda: Fix error paths
Date: Thu, 01 Aug 2013 17:27:57 +0200
Message-id: <00a901ce8ecb$b36c0830$1a441890$%debski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
Content-language: pl
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Fabio,

> From: Philipp Zabel [mailto:p.zabel@pengutronix.de]
> Sent: Wednesday, July 24, 2013 11:47 AM
> To: Fabio Estevam
> Cc: k.debski@samsung.com; m.chehab@samsung.com; kernel@pengutronix.de;
> linux-media@vger.kernel.org
> Subject: Re: [PATCH v4 1/3] [media] coda: Fix error paths
> 
> Hi Fabio,
> 
> Am Dienstag, den 23.07.2013, 15:04 -0300 schrieb Fabio Estevam:
> > Some resources were not being released in the error path and some
> were
> > released in the incorrect order.
> >
> > Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
> > ---
> > Changes since v3:
> > - Only disable the clocks after v4l2_m2m_ctx_release() Changes since
> > v2:
> > - Newly introduced in this series
> >
> >  drivers/media/platform/coda.c | 38
> > ++++++++++++++++++++++++--------------
> >  1 file changed, 24 insertions(+), 14 deletions(-)
> >
> > diff --git a/drivers/media/platform/coda.c
> > b/drivers/media/platform/coda.c index df4ada88..9384f02 100644
> > --- a/drivers/media/platform/coda.c
> > +++ b/drivers/media/platform/coda.c
> > @@ -1514,21 +1514,26 @@ static int coda_open(struct file *file)
> >  	int ret = 0;
> >  	int idx;
> >
> > -	idx = coda_next_free_instance(dev);
> > -	if (idx >= CODA_MAX_INSTANCES)
> > -		return -EBUSY;
> > -	set_bit(idx, &dev->instance_mask);
> > -
> >  	ctx = kzalloc(sizeof *ctx, GFP_KERNEL);
> >  	if (!ctx)
> >  		return -ENOMEM;
> >
> > +	idx = coda_next_free_instance(dev);
> > +	if (idx >= CODA_MAX_INSTANCES) {
> > +		ret =  -EBUSY;
> > +		goto err_coda_max;
> > +	}
> > +	set_bit(idx, &dev->instance_mask);
> > +
> >  	v4l2_fh_init(&ctx->fh, video_devdata(file));
> >  	file->private_data = &ctx->fh;
> >  	v4l2_fh_add(&ctx->fh);
> >  	ctx->dev = dev;
> >  	ctx->idx = idx;
> >
> > +	clk_prepare_enable(dev->clk_per);
> > +	clk_prepare_enable(dev->clk_ahb);
> > +
> >  	set_default_params(ctx);
> >  	ctx->m2m_ctx = v4l2_m2m_ctx_init(dev->m2m_dev, ctx,
> >  					 &coda_queue_init);
> > @@ -1537,12 +1542,12 @@ static int coda_open(struct file *file)
> >
> >  		v4l2_err(&dev->v4l2_dev, "%s return error (%d)\n",
> >  			 __func__, ret);
> > -		goto err;
> > +		goto err_ctx_init;
> >  	}
> >  	ret = coda_ctrls_setup(ctx);
> >  	if (ret) {
> >  		v4l2_err(&dev->v4l2_dev, "failed to setup coda controls\n");
> > -		goto err;
> > +		goto err_ctrls_setup;
> >  	}
> >
> >  	ctx->fh.ctrl_handler = &ctx->ctrls;
> > @@ -1552,24 +1557,29 @@ static int coda_open(struct file *file)
> >  	if (!ctx->parabuf.vaddr) {
> >  		v4l2_err(&dev->v4l2_dev, "failed to allocate parabuf");
> >  		ret = -ENOMEM;
> > -		goto err;
> > +		goto err_dma_alloc;
> >  	}
> >
> >  	coda_lock(ctx);
> >  	list_add(&ctx->list, &dev->instances);
> >  	coda_unlock(ctx);
> >
> > -	clk_prepare_enable(dev->clk_per);
> > -	clk_prepare_enable(dev->clk_ahb);
> > -
> >  	v4l2_dbg(1, coda_debug, &dev->v4l2_dev, "Created instance %d
> (%p)\n",
> >  		 ctx->idx, ctx);
> >
> >  	return 0;
> >
> > -err:
> > +err_dma_alloc:
> > +	v4l2_ctrl_handler_free(&ctx->ctrls);
> > +err_ctrls_setup:
> > +	v4l2_m2m_ctx_release(ctx->m2m_ctx);
> > +err_ctx_init:
> > +	clk_disable_unprepare(dev->clk_ahb);
> > +	clk_disable_unprepare(dev->clk_per);
> >  	v4l2_fh_del(&ctx->fh);
> >  	v4l2_fh_exit(&ctx->fh);
> > +	clear_bit(ctx->idx, &dev->instance_mask);
> > +err_coda_max:
> >  	kfree(ctx);
> >  	return ret;
> >  }
> > @@ -1588,10 +1598,10 @@ static int coda_release(struct file *file)
> >
> >  	dma_free_coherent(&dev->plat_dev->dev, CODA_PARA_BUF_SIZE,
> >  		ctx->parabuf.vaddr, ctx->parabuf.paddr);
> > -	v4l2_m2m_ctx_release(ctx->m2m_ctx);
> >  	v4l2_ctrl_handler_free(&ctx->ctrls);
> > -	clk_disable_unprepare(dev->clk_per);
> > +	v4l2_m2m_ctx_release(ctx->m2m_ctx);
> >  	clk_disable_unprepare(dev->clk_ahb);
> > +	clk_disable_unprepare(dev->clk_per);
> >  	v4l2_fh_del(&ctx->fh);
> >  	v4l2_fh_exit(&ctx->fh);
> >  	clear_bit(ctx->idx, &dev->instance_mask);
> 
> this looks better, thanks. Could you rebase the patches onto Kamil's
> http://git.linuxtv.org/kdebski/media.git/shortlog/refs/heads/new-for-
> 3.12
> branch?

Could you rebase these patches onto 
http://git.linuxtv.org/kdebski/media.git/shortlog/refs/heads/new-for-3.12-2nd
?

I get some conflicts and I am not sure how to resolve them.

Best wishes,
-- 
Kamil Debski
Linux Kernel Developer
Samsung R&D Institute Poland

