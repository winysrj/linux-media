Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:53435 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753597Ab2ATPEH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 20 Jan 2012 10:04:07 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Semwal, Sumit" <sumit.semwal@ti.com>
Subject: Re: [Linaro-mm-sig] [RFCv1 2/4] v4l:vb2: add support for shared buffer (dma_buf)
Date: Fri, 20 Jan 2012 16:04:04 +0100
Cc: Sakari Ailus <sakari.ailus@iki.fi>, linaro-mm-sig@lists.linaro.org,
	linux-media@vger.kernel.org, arnd@arndb.de, patches@linaro.org,
	jesse.barker@linaro.org, daniel@ffwll.ch,
	Hiroshi Doyu <hiroshi.doyu@gmail.com>
References: <1325760118-27997-1-git-send-email-sumit.semwal@ti.com> <4F11E7D4.4050906@iki.fi> <CAB2ybb83ub=A45-m6o+RXqFOTUmXCgeFqs03WZDHeWeLe2+29w@mail.gmail.com>
In-Reply-To: <CAB2ybb83ub=A45-m6o+RXqFOTUmXCgeFqs03WZDHeWeLe2+29w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201201201604.05966.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sumit,

On Monday 16 January 2012 06:33:31 Semwal, Sumit wrote:
> On Sun, Jan 15, 2012 at 2:08 AM, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> > Hi Sumit,
> > 
> > Thanks for the patch!
> 
> Hi Sakari,
> 
> Thanks for reviewing this :)
> 
> > <snip>
> > Shouldn't the buffer mapping only be done at the first call to
> > __qbuf_dmabuf()? On latter calls, the cache would need to be handled
> > according to presence of V4L2_BUF_FLAG_NO_CACHE_CLEAN /
> > V4L2_BUF_FLAG_NO_CACHE_INVALIDATE in v4l2_buffer.
> 
> Well, the 'map / unmap' implementation is by design exporter-specific; so
> the exporter of the buffer may choose to, depending on the use case,
> 'map-and-keep' on first call to map_dmabuf, and do actual unmap only at
> 'release' time. This will mean that the {map,unmap}_dmabuf calls will be
> used mostly for 'access-bracketing' between multiple users, and not for
> actual map/unmap each time.
> Again, the framework is flexible enough to allow exporters to actually
> map/unmap as required (think cases where backing-storage migration might be
> needed while buffers are in use - in that case, when all current users have
> called unmap_XXX() on a buffer, it can be migrated, and the next map_XXX()
> calls could give different mappings back to the users).
> The kernel 'users' of dma-buf [in case of this RFC, v4l2] should not
> ideally need to worry about the actual mapping/unmapping that is done; the
> buffer exporter in a particular use-case should be able to handle it.

I'm afraid it's more complex than that. Your patch calls q->mem_ops-
>map_dmabuf() at every VIDIOC_QBUF call. The function will call 
dma_buf_map_attachment(), which could cache the mapping somehow (even though 
that triggers an alarm somewhere in my brain, deciding in the exporter how to 
do so will likely cause issues - I'll try to sort my thoughts out on this), 
but it will also be responsible for mapping the sg list to the V4L2 device 
IOMMU (not for dma-contig obviously, but this code is in videobuf2-core.c). 
This is an expensive operation that we don't want to perform at every 
QBUF/DQBUF.

V4L2 uses streaming DMA mappings, partly for performance reasons. That's 
something dma-buf will likely need to support. Or you could argue that 
streaming DMA mappings are broken by design on some platform anyway, but then 
I'll expect a proposal for an efficient replacement :-)

> <snip>
> 
> > Same here, except reverse: this only should be done when the buffer is
> > destroyed --- either when the user explicitly calls reqbufs(0) or when
> > the file handle owning this buffer is being closed.
> > 
> > Mapping buffers at every prepare_buf and unmapping them in dqbuf is
> > prohibitively expensive. Same goes for many other APIs than V4L2, I
> > think.
> > 
> > I wonder if the means to do this exists already.
> > 
> > I have to admit I haven't followed the dma_buf discussion closely so I
> > might be missing something relevant here.
> 
> Hope the above explanation helps. Please do not hesitate to contact if you
> need more details.

-- 
Regards,

Laurent Pinchart
