Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:34971 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754642Ab2AXJed (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Jan 2012 04:34:33 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Clark, Rob" <rob@ti.com>
Subject: Re: [RFCv1 2/4] v4l:vb2: add support for shared buffer (dma_buf)
Date: Tue, 24 Jan 2012 10:34:38 +0100
Cc: Daniel Vetter <daniel@ffwll.ch>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Pawel Osciak <pawel@osciak.com>,
	Sumit Semwal <sumit.semwal@ti.com>,
	linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
	arnd@arndb.de, jesse.barker@linaro.org, patches@linaro.org
References: <1325760118-27997-1-git-send-email-sumit.semwal@ti.com> <201201231154.21006.laurent.pinchart@ideasonboard.com> <CAO8GWqmv0mqk_=VvSmOCQkREFTRZ7L_xgRa9i=Wx8ap08m3zpw@mail.gmail.com>
In-Reply-To: <CAO8GWqmv0mqk_=VvSmOCQkREFTRZ7L_xgRa9i=Wx8ap08m3zpw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201201241034.39393.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Rob,

On Tuesday 24 January 2012 01:26:15 Clark, Rob wrote:
> On Mon, Jan 23, 2012 at 4:54 AM, Laurent Pinchart wrote:
> > On Monday 23 January 2012 11:35:01 Daniel Vetter wrote:
> >> On Mon, Jan 23, 2012 at 10:48, Laurent Pinchart wrote:
> >> > On Monday 23 January 2012 10:06:57 Marek Szyprowski wrote:
> >> >> On Friday, January 20, 2012 5:29 PM Laurent Pinchart wrote:
> >> >> > On Friday 20 January 2012 17:20:22 Tomasz Stanislawski wrote:
> >> >> > > >> IMO, One way to do this is adding field 'struct device *dev'
> >> >> > > >> to struct vb2_queue. This field should be filled by a driver
> >> >> > > >> prior to calling vb2_queue_init.
> >> >> > > > 
> >> >> > > > I haven't looked into the details, but that sounds good to me.
> >> >> > > > Do we have use cases where a queue is allocated before knowing
> >> >> > > > which physical device it will be used for ?
> >> >> > > 
> >> >> > > I don't think so. In case of S5P drivers, vb2_queue_init is
> >> >> > > called while opening /dev/videoX.
> >> >> > > 
> >> >> > > BTW. This struct device may help vb2 to produce logs with more
> >> >> > > descriptive client annotation.
> >> >> > > 
> >> >> > > What happens if such a device is NULL. It would happen for
> >> >> > > vmalloc allocator used by VIVI?
> >> >> > 
> >> >> > Good question. Should dma-buf accept NULL devices ? Or should vivi
> >> >> > pass its V4L2 device to vb2 ?
> >> >> 
> >> >> I assume you suggested using struct video_device->dev entry in such
> >> >> case. It will not work. DMA-mapping API requires some parameters to
> >> >> be set for the client device, like for example dma mask. struct
> >> >> video_device contains only an artificial struct device entry, which
> >> >> has no relation to any physical device and cannot be used for
> >> >> calling DMA-mapping functions.
> >> >> 
> >> >> Performing dma_map_* operations with such artificial struct device
> >> >> doesn't make any sense. It also slows down things significantly due
> >> >> to cache flushing (forced by dma-mapping) which should be avoided if
> >> >> the buffer is accessed only with CPU (like it is done by vb2-vmalloc
> >> >> style drivers).
> >> > 
> >> > I agree that mapping the buffer to the physical device doesn't make
> >> > any sense, as there's simple no physical device to map the buffer to.
> >> > In that case we could simply skip the dma_map/dma_unmap calls.
> >> 
> >> See my other mail, dma_buf v1 does not support cpu access.
> > 
> > v1 is in the kernel now, let's start discussing v2 ;-)
> > 
> >> So if you don't have a device around, you can't use it in it's current
> >> form.
> >> 
> >> > Note, however, that dma-buf v1 explicitly does not support CPU access
> >> > by the importer.
> >> > 
> >> >> IMHO this case perfectly shows the design mistake that have been
> >> >> made. The current version simply tries to do too much.
> >> >> 
> >> >> Each client of dma_buf should 'map' the provided sgtable/scatterlist
> >> >> on its own. Only the client device driver has all knowledge to make
> >> >> a proper 'mapping'. Real physical devices usually will use
> >> >> dma_map_sg() for such operation, while some virtual ones will only
> >> >> create a kernel mapping for the provided scatterlist (like vivi with
> >> >> vmalloc memory module).
> >> > 
> >> > I tend to agree with that. Depending on the importer device, drivers
> >> > could then map/unmap the buffer around each DMA access, or keep a
> >> > mapping and sync the buffer.
> >> 
> >> Again we've discussed adding a syncing op to the interface that would
> >> allow keeping around mappings. The thing is that this also requires an
> >> unmap callback or something similar, so that the exporter can inform
> >> the importer that the memory just moved around. And the exporter
> >> _needs_ to be able to do that, hence also the language in the doc that
> >> importers need to braked all uses with a map/unmap and can't sit
> >> forever on a dma_buf mapping.
> > 
> > Not all exporters need to be able to move buffers around. If I'm not
> > mistaken, only DRM exporters need such a feature (which obviously makes
> > it an important feature). Does the exporter need to be able to do so at
> > any time ? Buffers can't obviously be moved around when they're used by
> > an activa DMA, so I expect the exporter to be able to wait. How long can
> > it wait ?
> 
> Offhand I think it would usually be a request from userspace (in some
> cases page faults (although I think only if there is hw de-tiling?),
> or command submission to gpu involving some buffer(s) that are not
> currently mapped) that would trigger the exporter to want to be able
> to evict something.  So could be blocked or something else
> evicted/moved instead.  Although perhaps not ideal for performance.
> (app/toolkit writers seem to have a love of temporary pixmaps, so
> x11/ddx driver can chew thru a huge number of new buffer allocations
> in very short amount of time)
> 
> > I'm not sure I would like a callback approach. If we add a sync
> > operation, the exporter could signal to the importer that it must unmap
> > the buffer by returning an appropriate value from the sync operation.
> > Would that be usable for DRM ?
> 
> It does seem a bit over-complicated..  and deadlock prone.  Is there a
> reason the importer couldn't just unmap when DMA is completed, and the
> exporter give some hint on next map() that the buffer hasn't actually
> moved?

If the importer unmaps the buffer completely when DMA is completed, it will 
have to map it again for the next DMA transfer, even if the 
dma_buf_map_attachement() calls returns an hint that the buffer hasn't moved.

What I want to avoid here is having to map/unmap buffers to the device IOMMU 
around each DMA if the buffer doesn't move. To avoid that, the importer needs 
to keep the IOMMU mapping after DMA completes if the buffer won't move until 
the next DMA transfer, but that information isn't available when the first DMA 
completes.

-- 
Regards,

Laurent Pinchart
