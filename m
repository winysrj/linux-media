Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:47230 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752790Ab0EZIRb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 26 May 2010 04:17:31 -0400
Date: Wed, 26 May 2010 10:17:40 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Baruch Siach <baruch@tkos.co.il>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sascha Hauer <kernel@pengutronix.de>,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/3] mx2_camera: Add soc_camera support for i.MX25/i.MX27
In-Reply-To: <20100526081331.GB10306@jasper.tkos.co.il>
Message-ID: <Pine.LNX.4.64.1005261016170.22516@axis700.grange>
References: <cover.1274706733.git.baruch@tkos.co.il>
 <4c15903511a5c4e6997b190d321b6fdf15bb6579.1274706733.git.baruch@tkos.co.il>
 <Pine.LNX.4.64.1005241754220.2611@axis700.grange> <20100526081331.GB10306@jasper.tkos.co.il>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 26 May 2010, Baruch Siach wrote:

> Hi Guennadi,
> 
> Thanks for your comments. A question below.
> 
> On Tue, May 25, 2010 at 05:34:52PM +0200, Guennadi Liakhovetski wrote:
> > On Mon, 24 May 2010, Baruch Siach wrote:
> 
> [snip]
> 
> > > +static void mx2_camera_deactivate(struct mx2_camera_dev *pcdev)
> > > +{
> > > +	unsigned long flags;
> > > +
> > > +	clk_disable(pcdev->clk_csi);
> > > +	writel(0, pcdev->base_csi + CSICR1);
> > > +	if (mx27_camera_emma(pcdev))
> > > +		writel(0, pcdev->base_emma + PRP_CNTL);
> > > +	else if (cpu_is_mx25()) {
> > 
> > Missing braces in the "if" case.
> 
> Which braces are missing?

Should be

+	if (mx27_camera_emma(pcdev)) {
+		writel(0, pcdev->base_emma + PRP_CNTL);
+	} else if (cpu_is_mx25()) {

... See CodingStyle for details.

> > > +		spin_lock_irqsave(&pcdev->lock, flags);
> > > +		pcdev->fb1_active = NULL;
> > > +		pcdev->fb2_active = NULL;
> > > +		writel(0, pcdev->base_csi + CSIDMASA_FB1);
> > > +		writel(0, pcdev->base_csi + CSIDMASA_FB2);
> > > +		spin_unlock_irqrestore(&pcdev->lock, flags);
> > > +	}
> > > +}
> 
> [snip]
> 
> > > +static void mx2_videobuf_queue(struct videobuf_queue *vq,
> > > +			       struct videobuf_buffer *vb)
> > > +{
> > > +	struct soc_camera_device *icd = vq->priv_data;
> > > +	struct soc_camera_host *ici =
> > > +		to_soc_camera_host(icd->dev.parent);
> > > +	struct mx2_camera_dev *pcdev = ici->priv;
> > > +	struct mx2_buffer *buf = container_of(vb, struct mx2_buffer, vb);
> > > +	unsigned long flags;
> > > +	int ret;
> > > +
> > > +	dev_dbg(&icd->dev, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
> > > +		vb, vb->baddr, vb->bsize);
> > > +
> > > +	spin_lock_irqsave(&pcdev->lock, flags);
> > > +
> > > +	vb->state = VIDEOBUF_QUEUED;
> > > +	list_add_tail(&vb->queue, &pcdev->capture);
> > > +
> > > +	if (mx27_camera_emma(pcdev))
> > > +		goto out;
> > > +	else if (cpu_is_mx27()) {
> > > +		if (pcdev->active != NULL) {
> > 
> > In v1 you had
> > 
> > > +		if (!pcdev->active) {
> > 
> > i.e., opposite logic. v2 seems to be wrong.
> 
> Right. I'll fix this.
> 
> > > +			ret = imx_dma_setup_single(pcdev->dma,
> > > +					videobuf_to_dma_contig(vb), vb->size,
> > > +					(u32)pcdev->base_dma + 0x10,
> > > +					DMA_MODE_READ);
> > > +			if (ret) {
> > > +				vb->state = VIDEOBUF_ERROR;
> > > +				wake_up(&vb->done);
> > > +				goto out;
> > > +			}
> > > +
> > > +			vb->state = VIDEOBUF_ACTIVE;
> > 
> > This is different from v1 of your patch. I meant not below this if, but 3 
> > lines down:
> > 
> > > +			pcdev->active = buf;
> > > +		}
> > 
> > ...here. Otherwise, if you don't enter the "active == NULL" if, your state 
> > remains at "QUEUED." OTOH, maybe this is deliberate and you want to only 
> > set the buffer to "ACTIVE" if it's really becomming active?
> 
> Yes, this is intentional.
> 
> > > +	} else { /* cpu_is_mx25() */

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
