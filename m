Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-68.nebula.fi ([83.145.220.68]:38127 "EHLO
	smtp-68.nebula.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891Ab2AYX2V (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Jan 2012 18:28:21 -0500
Date: Thu, 26 Jan 2012 01:28:16 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Pawel Osciak <pawel@osciak.com>,
	Sumit Semwal <sumit.semwal@ti.com>,
	linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
	arnd@arndb.de, jesse.barker@linaro.org, rob@ti.com,
	patches@linaro.org
Subject: Re: [RFCv1 2/4] v4l:vb2: add support for shared buffer (dma_buf)
Message-ID: <20120125232816.GA15297@valkosipuli.localdomain>
References: <1325760118-27997-1-git-send-email-sumit.semwal@ti.com>
 <201201201729.00230.laurent.pinchart@ideasonboard.com>
 <000601ccd9ae$5bd5fff0$1381ffd0$%szyprowski@samsung.com>
 <201201231048.47433.laurent.pinchart@ideasonboard.com>
 <CAKMK7uGSWQSq=tdoSp54ksXuwUD6z=FusSJf7=uzSp5Jm6t6sA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKMK7uGSWQSq=tdoSp54ksXuwUD6z=FusSJf7=uzSp5Jm6t6sA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Daniel and Laurent,

On Mon, Jan 23, 2012 at 11:35:01AM +0100, Daniel Vetter wrote:
> On Mon, Jan 23, 2012 at 10:48, Laurent Pinchart
> <laurent.pinchart@ideasonboard.com> wrote:
> > Hi Marek,
> >
> > On Monday 23 January 2012 10:06:57 Marek Szyprowski wrote:
> >> On Friday, January 20, 2012 5:29 PM Laurent Pinchart wrote:
> >> > On Friday 20 January 2012 17:20:22 Tomasz Stanislawski wrote:
> >> > > >> IMO, One way to do this is adding field 'struct device *dev' to
> >> > > >> struct vb2_queue. This field should be filled by a driver prior to
> >> > > >> calling vb2_queue_init.
> >> > > >
> >> > > > I haven't looked into the details, but that sounds good to me. Do we
> >> > > > have use cases where a queue is allocated before knowing which
> >> > > > physical device it will be used for ?
> >> > >
> >> > > I don't think so. In case of S5P drivers, vb2_queue_init is called
> >> > > while opening /dev/videoX.
> >> > >
> >> > > BTW. This struct device may help vb2 to produce logs with more
> >> > > descriptive client annotation.
> >> > >
> >> > > What happens if such a device is NULL. It would happen for vmalloc
> >> > > allocator used by VIVI?
> >> >
> >> > Good question. Should dma-buf accept NULL devices ? Or should vivi pass
> >> > its V4L2 device to vb2 ?
> >>
> >> I assume you suggested using struct video_device->dev entry in such case.
> >> It will not work. DMA-mapping API requires some parameters to be set for
> >> the client device, like for example dma mask. struct video_device contains
> >> only an artificial struct device entry, which has no relation to any
> >> physical device and cannot be used for calling DMA-mapping functions.
> >>
> >> Performing dma_map_* operations with such artificial struct device doesn't
> >> make any sense. It also slows down things significantly due to cache
> >> flushing (forced by dma-mapping) which should be avoided if the buffer is
> >> accessed only with CPU (like it is done by vb2-vmalloc style drivers).
> >
> > I agree that mapping the buffer to the physical device doesn't make any sense,
> > as there's simple no physical device to map the buffer to. In that case we
> > could simply skip the dma_map/dma_unmap calls.
> 
> See my other mail, dma_buf v1 does not support cpu access. So if you
> don't have a device around, you can't use it in it's current form.
> 
> > Note, however, that dma-buf v1 explicitly does not support CPU access by the
> > importer.
> >
> >> IMHO this case perfectly shows the design mistake that have been made. The
> >> current version simply tries to do too much.
> >>
> >> Each client of dma_buf should 'map' the provided sgtable/scatterlist on its
> >> own. Only the client device driver has all knowledge to make a proper
> >> 'mapping'. Real physical devices usually will use dma_map_sg() for such
> >> operation, while some virtual ones will only create a kernel mapping for
> >> the provided scatterlist (like vivi with vmalloc memory module).
> >
> > I tend to agree with that. Depending on the importer device, drivers could
> > then map/unmap the buffer around each DMA access, or keep a mapping and sync
> > the buffer.
> 
> Again we've discussed adding a syncing op to the interface that would
> allow keeping around mappings. The thing is that this also requires an
> unmap callback or something similar, so that the exporter can inform
> the importer that the memory just moved around. And the exporter
> _needs_ to be able to do that, hence also the language in the doc that
> importers need to braked all uses with a map/unmap and can't sit
> forever on a dma_buf mapping.

I'd also like to stress that being able to prepare video buffers and keep
them around is a very important feature. The buffers should not be unmapped
while the user space doesn't want that. Mapping buffer in V4L2 for every
frame is prohibitively expensive and should only happen the first time the
buffer is introduced to the buffer queue. Similarly unmapping should take
place either explicitly (REQBUFS) IOCTL or implicitly (closing associated
file handle).

Could this be a single bit that tells whether the buffer can be moved around
or not? Where exactly, I don't know.

> > What about splitting the map_dma_buf operation into an operation that backs
> > the buffer with pages and returns an sg_list, and an operation that performs
> > DMA synchronization with the exporter ? unmap_dma_buf would similarly be split
> > in two operations.
> 
> Again for v1 that doesn't make sense because you can't do cpu access
> anyway and you should not hang onto mappings forever. Furthermore we
> have cases where an unmapped sg_list for cpu access simple makes no
> sense.

Why you "should not hang onto mappings forever"? This is currently done by
virtually all V4L2 drivers where such mappings are relevant. Not doing so
would really kill the performance i.e. it's infeasible. Same goes to (m)any
other multimedia devices dealing with buffers containing streaming video
data.

Kind regards,

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	jabber/XMPP/Gmail: sailus@retiisi.org.uk
