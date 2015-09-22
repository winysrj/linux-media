Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:42195 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756350AbbIVMH2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Sep 2015 08:07:28 -0400
Date: Tue, 22 Sep 2015 15:07:24 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: tiffany lin <tiffany.lin@mediatek.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: Re: [RESEND PATCH] media: vb2: Fix vb2_dc_prepare do not correct
 sync data to device
Message-ID: <20150922120724.GQ3175@valkosipuli.retiisi.org.uk>
References: <1442838371-21484-1-git-send-email-tiffany.lin@mediatek.com>
 <56000293.9000802@xs4all.nl>
 <1442917165.20006.30.camel@mtksdaap41>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1442917165.20006.30.camel@mtksdaap41>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Tiffany,

On Tue, Sep 22, 2015 at 06:19:25PM +0800, tiffany lin wrote:
> Hi Hans,
> 
> On Mon, 2015-09-21 at 15:13 +0200, Hans Verkuil wrote:
> > Hi Tiffany!
> > 
> > On 21-09-15 14:26, Tiffany Lin wrote:
> > > vb2_dc_prepare use the number of SG entries dma_map_sg_attrs return.
> > > But in dma_sync_sg_for_device, it use lengths of each SG entries
> > > before dma_map_sg_attrs. dma_map_sg_attrs will concatenate
> > > SGs until dma length > dma seg bundary. sgt->nents will less than
> > > sgt->orig_nents. Using SG entries after dma_map_sg_attrs
> > > in vb2_dc_prepare will make some SGs are not sync to device.
> > > After add DMA_ATTR_SKIP_CPU_SYNC in vb2_dc_get_userptr to remove
> > > sync data to device twice. Device randomly get incorrect data because
> > > some SGs are not sync to device. Change to use number of SG entries
> > > before dma_map_sg_attrs in vb2_dc_prepare to prevent this issue.
> > > 
> > > Signed-off-by: Tiffany Lin <tiffany.lin@mediatek.com>
> > > ---
> > >  drivers/media/v4l2-core/videobuf2-dma-contig.c | 4 ++--
> > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
> > > index 2397ceb..c5d00bd 100644
> > > --- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
> > > +++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
> > > @@ -100,7 +100,7 @@ static void vb2_dc_prepare(void *buf_priv)
> > >  	if (!sgt || buf->db_attach)
> > >  		return;
> > >  
> > > -	dma_sync_sg_for_device(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
> > > +	dma_sync_sg_for_device(buf->dev, sgt->sgl, sgt->orig_nents, buf->dma_dir);
> > >  }
> > >  
> > >  static void vb2_dc_finish(void *buf_priv)
> > > @@ -112,7 +112,7 @@ static void vb2_dc_finish(void *buf_priv)
> > >  	if (!sgt || buf->db_attach)
> > >  		return;
> > >  
> > > -	dma_sync_sg_for_cpu(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
> > > +	dma_sync_sg_for_cpu(buf->dev, sgt->sgl, sgt->orig_nents, buf->dma_dir);
> > >  }
> > 
> > I don't really understand it. I am assuming that this happens on an arm and that
> > the dma_map_sg_attrs and dma_sync_sg_* functions used are arm_iommu_map_sg() and
> > arm_iommu_sync_sg_* as implemented in arch/arm/mm/dma-mapping.c.
> > 
> 
> We are using __iommu_* implemented in "arch/arm64/mm/dma-mapping.c" in
> review patch
> http://lists.linuxfoundation.org/pipermail/iommu/2015-July/013898.html
> Without patch "[media] vb2: use dma_map_sg_attrs to prevent unnecessary
> sync", vb2 will sync data to device twice.
> One is from "dma_map_sg" in "vb2_dc_get_userptr", the other is from
> "dma_sync_sg_for_device" in "vb2_dc_prepare". dma_map_sg use orig_nents,
> and dma_sync_sg_for_device use nents."
> 
> We do not run in 32bits mode, but check "arm_dma_sync_sg_for_device" in
> "arch/arm/mm/dma-mapping.c", 
> ops->sync_single_for_device(dev, sg_dma_address(s), s->length, dir);
> It looks like has same issue.
> 
> > Now, as I understand it (and my understanding may very well be flawed!) the map_sg
> > function concatenates SG entries if possible, so it may return fewer entries. But
> > the dma_sync_sg functions use those updated SG entries, so the full buffer should
> > be covered by this. Using orig_nents will actually sync parts of the buffer twice!
> > The first nents entries already cover the full buffer so any remaining entries up
> > to orig_nents will just duplicate parts of the buffer.
> > 
> I found that in __iommu_sync_sg_for_device, it use sg->length , do not
> cover full buffer.
> By adding log in " __iommu_sync_sg_for_device" without patch "[media]
> vb2: use dma_map_sg_attrs to prevent unnecessary sync", we could see
> total synced size are different between called from dma_map_sg and
> dma_sync_sg_for_device.

I had the same question Hans did, but I still fail to understand where in
the code things are going wrong the way you described at the moment ---
after dma_map_sg() there are nents entries in the scatterlist. But.
sg_dma_len() should be used instead of the length field to get the size of
the entry. If something is wrong, then it's this AFAICT.

Could you try whether changing this fixes it?

> __iommu_sync_sg_for_device called from dma_sync_sg_for_device got
> updated SG entries number but it use un-updated sg length.
> After using "DMA_ATTR_SKIP_CPU_SYNC" to skip sync in vb2_dc_get_userptr,
> we got some part of the buffer not sync.
> 
> > So this patch makes no sense in the current code.
> > 
> > If I understand your log text correctly this patch goes on top of Sakari Ailus' vb2
> > sync patch series. So if it wasn't needed before, but it is needed after his patch
> > series, then the problem is in that patch series.
> > 
> This patch goes on top of these two patchs
> https://www.mail-archive.com/linux-media%40vger.kernel.org/msg82143.html

This patch has been merged long time ago.

> http://lists.linuxfoundation.org/pipermail/iommu/2015-July/013898.html
> 
> 
> > In any case, I need some help understanding this patch.
> > 
> > And *if* this patch is correct, then the same thing should likely be done for
> > videobuf2-dma-sg.c.
> > 
> Yes, if this patch correct, same thing should be done for
> videobuf2-dma-sg.c
> > Regards,
> > 
> > 	Hans
> > 
> > >  
> > >  /*********************************************/
> > > 
> 
> 

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
