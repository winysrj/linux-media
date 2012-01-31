Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:41647 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216Ab2AaKgB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 31 Jan 2012 05:36:01 -0500
Received: by wics10 with SMTP id s10so4241658wic.19
        for <linux-media@vger.kernel.org>; Tue, 31 Jan 2012 02:36:00 -0800 (PST)
Date: Tue, 31 Jan 2012 11:36:02 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: "Semwal, Sumit" <sumit.semwal@ti.com>, t.stanislaws@samsung.com,
	linaro-mm-sig@lists.linaro.org, dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] dma-buf: add dma_data_direction to unmap dma_buf_op
Message-ID: <20120131103602.GD3911@phenom.ffwll.local>
References: <1327657408-15234-1-git-send-email-sumit.semwal@ti.com>
 <201201301519.07785.laurent.pinchart@ideasonboard.com>
 <CAB2ybb8RX5Sy7-s4-X2cLC9HcoTmsn_miYu0HysjHSU4aZ4BBw@mail.gmail.com>
 <201201311042.59917.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201201311042.59917.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jan 31, 2012 at 10:42:59AM +0100, Laurent Pinchart wrote:
> Hi Sumit,
> 
> > On Friday 27 January 2012 10:43:28 Sumit Semwal wrote:
> 
> [snip]
> 
> >  static inline void dma_buf_unmap_attachment(struct dma_buf_attachment
> > *attach,
> > -                                            struct sg_table *sg)
> > +                     struct sg_table *sg, enum dma_data_direction write)
> 
> On a second thought, would it make sense to store the direction in struct 
> dma_buf_attachment in dma_buf_map_attachment(), and pass the value directly to 
> the .unmap_dma_buf() instead of requiring the dma_buf_unmap_attachment() 
> caller to remember it ? Or is an attachment allowed to map the buffer several 
> times with different directions ?

Current dma api functions already require you to supply the direction
argument on unmap and I think for cpu access I'm also leaning towards an
interface where the importer has to supply the direction argument for both
begin_access and end_access. So for consistency reasons I'm leaning
towards adding it to unmap.
-Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
