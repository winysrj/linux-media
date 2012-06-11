Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:64462 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418Ab2FKJVQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jun 2012 05:21:16 -0400
Date: Mon, 11 Jun 2012 11:21:09 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Albert Wang <twang13@marvell.com>
cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	"pawel@osciak.com" <pawel@osciak.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: RE: [PATCH] media: videobuf2: fix kernel panic due to missing assign
 NULL to alloc_ctx
In-Reply-To: <477F20668A386D41ADCC57781B1F7043083A7F0E11@SC-VEXCH1.marvell.com>
Message-ID: <Pine.LNX.4.64.1206111118210.28244@axis700.grange>
References: <1339156511-16509-1-git-send-email-twang13@marvell.com>
 <15576892.cR1LHefC7i@avalon> <477F20668A386D41ADCC57781B1F7043083A7F0E11@SC-VEXCH1.marvell.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Albert

On Mon, 11 Jun 2012, Albert Wang wrote:

> Hi, Laurent
> 
> Thanks for your reply!
> 
> We allocated the context when init_videobuf2() which will be called in 
> soc_camera_open(), so if we get exit with exception in 
> soc_camera_set_fmt()
> Actually we will double call vb2_dma_contig_cleanup_ctx().
> 
> 	ret = soc_camera_set_fmt(icd, &f);
> 	if (ret < 0)
> 		goto esfmt;
> 
> 	if (ici->ops->init_videobuf) {
> 		ici->ops->init_videobuf(&icd->vb_vidq, icd);
> 	} else {
> 		ret = ici->ops->init_videobuf2(&icd->vb2_vidq, icd);
> 		if (ret < 0)
> 			goto einitvb;
> 	}
> 
> Actually, in current code, we can found some drivers allocated the 
> context in probe(), and some drivers also do that in soc_camera_open().

Sorry, AFAICS all soc-camera host drivers allocate vb2 context in their 
.probe() methods. Can you point me out to the one(s) you mean, that do 
that at open() time?

> Of course, we can update our driver and move it to probe(), it will 
> stand aside the issue, that's also OK for us.
> 
> But we still think it's not safe that leave the point be a non-NULL 
> after we have kfree it. Do you think so?

Your patch doesn't fix anything. It only changes the local variable in the 
vb2_dma_contig_cleanup_ctx() function, which doesn't affect the caller in 
any way.

Thanks
Guennadi

> Thanks
> Albert Wang
> 86-21-61092656
> 
> -----Original Message-----
> From: Laurent Pinchart [mailto:laurent.pinchart@ideasonboard.com] 
> Sent: Monday, 11 June, 2012 16:00
> To: Albert Wang
> Cc: pawel@osciak.com; g.liakhovetski@gmx.de; linux-media@vger.kernel.org
> Subject: Re: [PATCH] media: videobuf2: fix kernel panic due to missing assign NULL to alloc_ctx
> 
> Hi Albert,
> 
> On Friday 08 June 2012 19:55:11 Albert Wang wrote:
> >   In function vb2_dma_contig_cleanup_ctx(), we only kfree the alloc_ctx
> >   If we didn't assign NULL to this point after kfree it,
> >   we may encounter the following kernel panic:
> > 
> >  kernel BUG at kernel/cred.c:98!
> >  Unable to handle kernel NULL pointer dereference at virtual address
> > 00000000 pgd = c0004000
> >  [00000000] *pgd=00000000
> >  Internal error: Oops: 817 [#1] PREEMPT SMP  Modules linked in: 
> > runcase_sysfs galcore mv_wtm_drv mv_wtm_prim
> >  CPU: 0    Not tainted  (3.0.8+ #213)
> >  PC is at __bug+0x18/0x24
> >  LR is at __bug+0x14/0x24
> >  pc : [<c0054670>]    lr : [<c005466c>]    psr: 60000113
> >  sp : c0681ec0  ip : f683e000  fp : 00000000
> >  r10: e8ab4b58  r9 : 00000fff  r8 : 00000002
> >  r7 : e8665698  r6 : c10079ec  r5 : e8b13d80  r4 : e8b13d98
> >  r3 : 00000000  r2 : c0681eb4  r1 : c05c9ccc  r0 : 00000035
> >  Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment kernel
> >  Control: 10c53c7d  Table: 29c3406a  DAC: 00000015
> > 
> >   the root cause is we may encounter some i2c or HW issue with sensor
> >   which result in driver exit with exception during soc_camera_set_fmt()
> >   from soc_camera_open():
> > 
> > 	ret = soc_camera_set_fmt(icd, &f);
> > 	if (ret < 0)
> > 		goto esfmt;
> > 
> >   it will call ici->ops->remove() in following code:
> > 
> >   esfmt:
> > 	pm_runtime_disable(&icd->vdev->dev);
> >   eresume:
> > 	ici->ops->remove(icd);
> > 
> >   ici->ops->remove() will call vb2_dma_contig_cleanup_ctx() for cleanup
> >   but we didn't do ici->ops->init_videobuf2() yet at that time
> >   it will result in kfree a non-NULL point twice
> 
> I'm not sure to follow you. How is init_videobuf2() related ? The context is allocated once only at probe time from what I can see. Your problem is more likely caused by a double call to vb2_dma_contig_cleanup_ctx(), which looks like a driver bug to me, not a videobuf2 bug.
> 
> > Change-Id: I1c66dd08438ae90abe555c52edcdbca0d39d829d
> > Signed-off-by: Albert Wang <twang13@marvell.com>
> > ---
> >  drivers/media/video/videobuf2-dma-contig.c |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/media/video/videobuf2-dma-contig.c
> > b/drivers/media/video/videobuf2-dma-contig.c index 4b71326..9881171 
> > 100755
> > --- a/drivers/media/video/videobuf2-dma-contig.c
> > +++ b/drivers/media/video/videobuf2-dma-contig.c
> > @@ -178,6 +178,7 @@ EXPORT_SYMBOL_GPL(vb2_dma_contig_init_ctx);
> >  void vb2_dma_contig_cleanup_ctx(void *alloc_ctx)  {
> >  	kfree(alloc_ctx);
> > +	alloc_ctx = NULL;
> >  }
> >  EXPORT_SYMBOL_GPL(vb2_dma_contig_cleanup_ctx);
> 
> --
> Regards,
> 
> Laurent Pinchart
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
