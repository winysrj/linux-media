Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:34581 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753981Ab2BBKEJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 2 Feb 2012 05:04:09 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Daniel Vetter <daniel@ffwll.ch>
Subject: Re: [PATCH] dma-buf: add dma_data_direction to unmap dma_buf_op
Date: Thu, 2 Feb 2012 11:04:29 +0100
Cc: "Semwal, Sumit" <sumit.semwal@ti.com>, t.stanislaws@samsung.com,
	linaro-mm-sig@lists.linaro.org, dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org
References: <1327657408-15234-1-git-send-email-sumit.semwal@ti.com> <201201311042.59917.laurent.pinchart@ideasonboard.com> <20120131103602.GD3911@phenom.ffwll.local>
In-Reply-To: <20120131103602.GD3911@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201202021104.30326.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Daniel,

On Tuesday 31 January 2012 11:36:02 Daniel Vetter wrote:
> On Tue, Jan 31, 2012 at 10:42:59AM +0100, Laurent Pinchart wrote:
> > Hi Sumit,
> > 
> > > On Friday 27 January 2012 10:43:28 Sumit Semwal wrote:
> > [snip]
> > 
> > >  static inline void dma_buf_unmap_attachment(struct dma_buf_attachment
> > > 
> > > *attach,
> > > -                                            struct sg_table *sg)
> > > +                     struct sg_table *sg, enum dma_data_direction
> > > write)
> > 
> > On a second thought, would it make sense to store the direction in struct
> > dma_buf_attachment in dma_buf_map_attachment(), and pass the value
> > directly to the .unmap_dma_buf() instead of requiring the
> > dma_buf_unmap_attachment() caller to remember it ? Or is an attachment
> > allowed to map the buffer several times with different directions ?
> 
> Current dma api functions already require you to supply the direction
> argument on unmap

If I understand it correctly, that's mostly because the DMA API doesn't keep 
track of DMA mappings in a way that it can store the direction on map(), and 
use it on unmap(). In this case we have an attachment object that we can use 
to cache the information.

> and I think for cpu access I'm also leaning towards an interface where the
> importer has to supply the direction argument for both begin_access and
> end_access. So for consistency reasons I'm leaning towards adding it to
> unmap.

I'm OK with keeping the direction as an argument to unmap() if you think 
that's better.

-- 
Regards,

Laurent Pinchart
