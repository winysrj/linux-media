Return-path: <linux-media-owner@vger.kernel.org>
Received: from tango.tkos.co.il ([62.219.50.35]:34984 "EHLO tango.tkos.co.il"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751818Ab0FUFPq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 21 Jun 2010 01:15:46 -0400
Date: Mon, 21 Jun 2010 08:15:19 +0300
From: Baruch Siach <baruch@tkos.co.il>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sascha Hauer <kernel@pengutronix.de>,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 1/3] mx2_camera: Add soc_camera support for
 i.MX25/i.MX27
Message-ID: <20100621051519.GB18217@jasper.tkos.co.il>
References: <cover.1274865040.git.baruch@tkos.co.il>
 <190248f3b311ccfcb73f1fc71d185e3927f0bf05.1274865040.git.baruch@tkos.co.il>
 <Pine.LNX.4.64.1006191458420.11313@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1006191458420.11313@axis700.grange>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

On Sat, Jun 19, 2010 at 04:13:31PM +0200, Guennadi Liakhovetski wrote:
> On Wed, 26 May 2010, Baruch Siach wrote:
> 
> > This is the soc_camera support developed by Sascha Hauer for the i.MX27.  Alan
> > Carvalho de Assis modified the original driver to get it working on more recent
> > kernels. I modified it further to add support for i.MX25. This driver has been
> > tested on i.MX25 and i.MX27 based platforms.

Tanks for your review. I'll send v4 shortly.

baruch

> I hoped, this would be the final version, but if I'm not mistaken, you've 
> introduced an error, which we better fix before committing. And as we anyway 
> will likely need a v4, I'll also ask you to improve a couple of stylistic 
> issues, which otherwise I'd just fix myself with your permission.
> 
> > Signed-off-by: Baruch Siach <baruch@tkos.co.il>
> > ---
> >  arch/arm/plat-mxc/include/mach/memory.h  |    4 +-
> >  arch/arm/plat-mxc/include/mach/mx2_cam.h |   46 +
> >  drivers/media/video/Kconfig              |   13 +
> >  drivers/media/video/Makefile             |    1 +
> >  drivers/media/video/mx2_camera.c         | 1488 ++++++++++++++++++++++++++++++
> >  5 files changed, 1550 insertions(+), 2 deletions(-)
> >  create mode 100644 arch/arm/plat-mxc/include/mach/mx2_cam.h
> >  create mode 100644 drivers/media/video/mx2_camera.c
> > 
> > diff --git a/arch/arm/plat-mxc/include/mach/memory.h b/arch/arm/plat-mxc/include/mach/memory.h
> > index c4b40c3..5803836 100644
> > --- a/arch/arm/plat-mxc/include/mach/memory.h
> > +++ b/arch/arm/plat-mxc/include/mach/memory.h
> 
> [snip]
> 
> > +static void mx2_videobuf_queue(struct videobuf_queue *vq,
> > +			       struct videobuf_buffer *vb)
> > +{
> > +	struct soc_camera_device *icd = vq->priv_data;
> > +	struct soc_camera_host *ici =
> > +		to_soc_camera_host(icd->dev.parent);
> > +	struct mx2_camera_dev *pcdev = ici->priv;
> > +	struct mx2_buffer *buf = container_of(vb, struct mx2_buffer, vb);
> > +	unsigned long flags;
> > +	int ret;
> > +
> > +	dev_dbg(&icd->dev, "%s (vb=0x%p) 0x%08lx %d\n", __func__,
> > +		vb, vb->baddr, vb->bsize);
> > +
> > +	spin_lock_irqsave(&pcdev->lock, flags);
> > +
> > +	vb->state = VIDEOBUF_QUEUED;
> > +	list_add_tail(&vb->queue, &pcdev->capture);
> > +
> > +	if (mx27_camera_emma(pcdev))
> > +		goto out;
> > +	else if (cpu_is_mx27()) {
> 
> One of the minor ones - please, add braces in the "if" case.
> 
> [snip]
> 
> > +static irqreturn_t mx27_camera_emma_irq(int irq_emma, void *data)
> > +{
> > +	struct mx2_camera_dev *pcdev = data;
> > +	unsigned int status = readl(pcdev->base_emma + PRP_INTRSTATUS);
> > +	struct mx2_buffer *buf;
> > +
> > +	if ((status & (3 << 5)) == (3 << 5)
> > +			&& !list_empty(&pcdev->active_bufs)) {
> > +		/*
> > +		 * Both buffers have triggered, process the one we're expecting
> > +		 * to first
> > +		 */
> > +		buf = list_entry(pcdev->active_bufs.next,
> > +			struct mx2_buffer, vb.queue);
> > +		mx27_camera_frame_done_emma(pcdev, buf->bufnum, VIDEOBUF_DONE);
> > +	}
> > +	if (status & (1 << 6))
> > +		mx27_camera_frame_done_emma(pcdev, 0, VIDEOBUF_DONE);
> > +	if (status & (1 << 5))
> > +		mx27_camera_frame_done_emma(pcdev, 1, VIDEOBUF_DONE);
> 
> Now, this is the important one. In my review of v2 I proposed the above 
> fix for the both-bits-set case. But, I think, your implementation is not 
> correct. Don't you have to clear the expected buffer number, so that you 
> don't process it twice? Something like
> 
> 		status &= ~(1 << 6 - buf->bufnum);
> 
> anywhere inside the first of the three ifs?
> 
> > +	if (status & (1 << 7)) {
> 
> Bit 7 is overflow. A correct handling could be resetting the buffer, 
> returning an error frame and continuing with the next one. However, I 
> understand, that you do not have a chance to implement this properly 
> now. So, please, at least add a "FIXME" comment, explaining, what should 
> be done here. Besides, error states are normally checked before normal 
> data processing. So, either mention this in the comment too, or move this 
> above the buffer completion processing.
> 
> Thanks
> Guennadi
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/

-- 
                                                     ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.2.679.5364, http://www.tkos.co.il -
