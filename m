Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:54194 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751692AbbIWKHt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Sep 2015 06:07:49 -0400
Date: Wed, 23 Sep 2015 13:07:13 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Tiffany Lin <tiffany.lin@mediatek.com>,
	Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org, robin.murphy@arm.com
Subject: Re: [RESEND PATCH] media: vb2: Fix vb2_dc_prepare do not correct
 sync data to device
Message-ID: <20150923100712.GU3175@valkosipuli.retiisi.org.uk>
References: <1442838371-21484-1-git-send-email-tiffany.lin@mediatek.com>
 <20150922211015.GT3175@valkosipuli.retiisi.org.uk>
 <6A2D1ECE-40A4-441C-910B-6EEB3D99D8FA@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6A2D1ECE-40A4-441C-910B-6EEB3D99D8FA@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On Wed, Sep 23, 2015 at 10:40:56AM +0200, Hans Verkuil wrote:
> Resent, hopefully without html this time.
> 
> On September 22, 2015 11:10:15 PM GMT+02:00, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> >Hi Tiffany,
> >
> >(Robin and Hans cc'd.)
> >
> >On Mon, Sep 21, 2015 at 08:26:11PM +0800, Tiffany Lin wrote:
> >> vb2_dc_prepare use the number of SG entries dma_map_sg_attrs return.
> >> But in dma_sync_sg_for_device, it use lengths of each SG entries
> >> before dma_map_sg_attrs. dma_map_sg_attrs will concatenate
> >> SGs until dma length > dma seg bundary. sgt->nents will less than
> >> sgt->orig_nents. Using SG entries after dma_map_sg_attrs
> >> in vb2_dc_prepare will make some SGs are not sync to device.
> >> After add DMA_ATTR_SKIP_CPU_SYNC in vb2_dc_get_userptr to remove
> >> sync data to device twice. Device randomly get incorrect data because
> >> some SGs are not sync to device. Change to use number of SG entries
> >> before dma_map_sg_attrs in vb2_dc_prepare to prevent this issue.
> >> 
> >> Signed-off-by: Tiffany Lin <tiffany.lin@mediatek.com>
> >> ---
> >>  drivers/media/v4l2-core/videobuf2-dma-contig.c | 4 ++--
> >>  1 file changed, 2 insertions(+), 2 deletions(-)
> >> 
> >> diff --git a/drivers/media/v4l2-core/videobuf2-dma-contig.c
> >b/drivers/media/v4l2-core/videobuf2-dma-contig.c
> >> index 2397ceb..c5d00bd 100644
> >> --- a/drivers/media/v4l2-core/videobuf2-dma-contig.c
> >> +++ b/drivers/media/v4l2-core/videobuf2-dma-contig.c
> >> @@ -100,7 +100,7 @@ static void vb2_dc_prepare(void *buf_priv)
> >>  	if (!sgt || buf->db_attach)
> >>  		return;
> >>  
> >> -	dma_sync_sg_for_device(buf->dev, sgt->sgl, sgt->nents,
> >buf->dma_dir);
> >> +	dma_sync_sg_for_device(buf->dev, sgt->sgl, sgt->orig_nents,
> >buf->dma_dir);
> >>  }
> >>  
> >>  static void vb2_dc_finish(void *buf_priv)
> >> @@ -112,7 +112,7 @@ static void vb2_dc_finish(void *buf_priv)
> >>  	if (!sgt || buf->db_attach)
> >>  		return;
> >>  
> >> -	dma_sync_sg_for_cpu(buf->dev, sgt->sgl, sgt->nents, buf->dma_dir);
> >> +	dma_sync_sg_for_cpu(buf->dev, sgt->sgl, sgt->orig_nents,
> >buf->dma_dir);
> >>  }
> >>  
> >>  /*********************************************/
> >
> >Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> >
> >Could you post a similar patch for videobuf2-dma-sg as well, please?
> >This
> >should probably go to stable (since when?).
> >
> >videobuf-dma-sg appears to be broken, too, but the fix is more changes
> >than one or two lines.
> >
> >-- 
> >Kind regards,
> >
> >Sakari Ailus
> >e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
> 
> Sakari, can you take a careful look at the vb2 code? If I remember
> correctly, the nents field receives the result of the map_sg function. I
> have no idea if that's correct.

As far as I can tell, it is. According to a comment in the definition of
struct sg_table in include/linux/scatterlist.h, this is the number of
*mapped* entries in the table. Although a number of drivers construct the
table by themselves use nents only, __sg_alloc_table() assigns the same
number to both. The videobuf2 bug appears to be one of its kind --- I
checked the other users of struct sg_table for the purpose.
drivers/spi/spi.c has the same pattern except that it does not involve
syncing the cache.

There could be other users of dma_map_sg() that get this wrong though.

Perhaps the comment on the sg_table shouldn't be added to the documentation
as most of the users appear to be using it differently, even if it appears
to be in a conflict with the intended usage.

As far as I understand, what we need a similar fix for dma-sg allocator.

> 
> BTW, don't spend too much time on vb1, nobody cares about that old
> framework, and vb1 drivers are rarely used on arm platforms.

In that case the wrong number of sglist entries is also passed to
dma_unmap_sg(). Although in most cases it still works. I think the BTTV
driver is using it, for instance.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
