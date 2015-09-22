Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:49618 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751500AbbIVUhz (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 22 Sep 2015 16:37:55 -0400
Date: Tue, 22 Sep 2015 23:37:51 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Robin Murphy <robin.murphy@arm.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
	Tiffany Lin <tiffany.lin@mediatek.com>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mediatek@lists.infradead.org"
	<linux-mediatek@lists.infradead.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [RESEND PATCH] media: vb2: Fix vb2_dc_prepare do not correct
 sync data to device
Message-ID: <20150922203751.GS3175@valkosipuli.retiisi.org.uk>
References: <1442838371-21484-1-git-send-email-tiffany.lin@mediatek.com>
 <56000293.9000802@xs4all.nl>
 <560175AD.2010401@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <560175AD.2010401@arm.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Robin,

On Tue, Sep 22, 2015 at 04:37:17PM +0100, Robin Murphy wrote:
> Hi Hans,
> 
> On 21/09/15 14:13, Hans Verkuil wrote:
> >Hi Tiffany!
> >
> >On 21-09-15 14:26, Tiffany Lin wrote:
> >>vb2_dc_prepare use the number of SG entries dma_map_sg_attrs return.
> >>But in dma_sync_sg_for_device, it use lengths of each SG entries
> >>before dma_map_sg_attrs. dma_map_sg_attrs will concatenate
> >>SGs until dma length > dma seg bundary. sgt->nents will less than
> >>sgt->orig_nents. Using SG entries after dma_map_sg_attrs
> >>in vb2_dc_prepare will make some SGs are not sync to device.
> >>After add DMA_ATTR_SKIP_CPU_SYNC in vb2_dc_get_userptr to remove
> >>sync data to device twice. Device randomly get incorrect data because
> >>some SGs are not sync to device. Change to use number of SG entries
> >>before dma_map_sg_attrs in vb2_dc_prepare to prevent this issue.
> >>
> >>Signed-off-by: Tiffany Lin <tiffany.lin@mediatek.com>
> >>---
> >>  drivers/media/v4l2-core/videobuf2-dma-contig.c | 4 ++--
> >>  1 file changed, 2 insertions(+), 2 deletions(-)
> >>
> >>diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c b/drivers/media/v4l2-core/videobuf2-dma-contig.c
> >>index 2397ceb..c5d00bd 100644
> >>--- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
> >>+++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
> >>@@ -100,7 +100,7 @@ static void vb2_dc_prepare(void *buf_priv)
> >>  	if (!sgt || buf->db_attach)
> >>  		return;
> >>
> >>-	dma_sync_sg_for_device(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
> >>+	dma_sync_sg_for_device(buf->dev, sgt->sgl, sgt->orig_nents, buf->dma_dir);
> >>  }
> >>
> >>  static void vb2_dc_finish(void *buf_priv)
> >>@@ -112,7 +112,7 @@ static void vb2_dc_finish(void *buf_priv)
> >>  	if (!sgt || buf->db_attach)
> >>  		return;
> >>
> >>-	dma_sync_sg_for_cpu(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
> >>+	dma_sync_sg_for_cpu(buf->dev, sgt->sgl, sgt->orig_nents, buf->dma_dir);
> >>  }
> >
> >I don't really understand it. I am assuming that this happens on an arm and that
> >the dma_map_sg_attrs and dma_sync_sg_* functions used are arm_iommu_map_sg() and
> >arm_iommu_sync_sg_* as implemented in arch/arm/mm/dma-mapping.c.
> >
> >Now, as I understand it (and my understanding may very well be flawed!) the map_sg
> >function concatenates SG entries if possible, so it may return fewer entries. But
> >the dma_sync_sg functions use those updated SG entries, so the full buffer should
> >be covered by this. Using orig_nents will actually sync parts of the buffer twice!
> >The first nents entries already cover the full buffer so any remaining entries up
> >to orig_nents will just duplicate parts of the buffer.
> 
> As Documentation/DMA-API.txt says, the parameters to dma_sync_sg_* must be
> the same as those originally passed into dma_map_sg. The segments are only
> merged *from the point of view of the device*: if I have a scatterlist of
> two discontiguous 4K segments, I can remap them with an IOMMU so the device
> sees them as a single 8K buffer, and tell it as such. If on the other hand I
> want to do maintenance from the CPU side (i.e. any DMA API call), then those
> DMA addresses mean nothing and I can only operate on the CPU addresses of
> the underlying pages, which are still very much discontiguous in the linear
> map; ergo I still need to iterate over the original entries.
> 
> Whilst I can't claim much familiarity with v4l itself, from a brief look
> over the existing code this patch does look to be doing the right thing.

Thanks for the explanation. I wonder if this is the only place where we have
this issue. :-I

I think this might have been partly caused by the unfortunately named field
(nents) in struct sg_table. I wrote a small patch for this (plus a fix for a
few other things as well):


>From 8928d76db4d45c2b4a16ff90de6695bc88e19779 Mon Sep 17 00:00:00 2001
From: Sakari Ailus <sakari.ailus@iki.fi>
Date: Tue, 22 Sep 2015 23:30:30 +0300
Subject: [PATCH 1/1] Documentation: DMA API: Be more explicit that nelems is
 always the same

The nelems argument to the DMA API functions operating on scatterlists is
always the same. The documentation used different argument names and the
matter was not mentioned in Documentation/DMA-API-HOWTO.txt at all. Fix
these.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
---
 Documentation/DMA-API-HOWTO.txt | 5 +++++
 Documentation/DMA-API.txt       | 9 +++++----
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/Documentation/DMA-API-HOWTO.txt b/Documentation/DMA-API-HOWTO.txt
index 55b70b9..d69b3fc 100644
--- a/Documentation/DMA-API-HOWTO.txt
+++ b/Documentation/DMA-API-HOWTO.txt
@@ -681,6 +681,11 @@ or:
 
 as appropriate.
 
+PLEASE NOTE:  The 'nents' argument to dma_sync_sg_for_cpu() and
+	      dma_sync_sg_for_device() must be the same passed to
+	      dma_map_sg(). It is _NOT_ the count returned by
+	      dma_map_sg().
+
 After the last DMA transfer call one of the DMA unmap routines
 dma_unmap_{single,sg}(). If you don't touch the data from the first
 dma_map_*() call till dma_unmap_*(), then you don't have to call the
diff --git a/Documentation/DMA-API.txt b/Documentation/DMA-API.txt
index edccacd..8c832f0 100644
--- a/Documentation/DMA-API.txt
+++ b/Documentation/DMA-API.txt
@@ -340,14 +340,15 @@ accessed sg->address and sg->length as shown above.
 
 	void
 	dma_unmap_sg(struct device *dev, struct scatterlist *sg,
-		int nhwentries, enum dma_data_direction direction)
+		int nents, enum dma_data_direction direction)
 
 Unmap the previously mapped scatter/gather list.  All the parameters
 must be the same as those and passed in to the scatter/gather mapping
 API.
 
 Note: <nents> must be the number you passed in, *not* the number of
-DMA address entries returned.
+DMA address entries returned. In struct sg_table this is the field
+called orig_nents.
 
 void
 dma_sync_single_for_cpu(struct device *dev, dma_addr_t dma_handle, size_t size,
@@ -356,10 +357,10 @@ void
 dma_sync_single_for_device(struct device *dev, dma_addr_t dma_handle, size_t size,
 			   enum dma_data_direction direction)
 void
-dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg, int nelems,
+dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg, int nents,
 		    enum dma_data_direction direction)
 void
-dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg, int nelems,
+dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg, int nents,
 		       enum dma_data_direction direction)
 
 Synchronise a single contiguous or scatter/gather mapping for the CPU

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
