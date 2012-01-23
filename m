Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:34537 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845Ab2AWJpx (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jan 2012 04:45:53 -0500
Received: by wics10 with SMTP id s10so1937182wic.19
        for <linux-media@vger.kernel.org>; Mon, 23 Jan 2012 01:45:52 -0800 (PST)
Date: Mon, 23 Jan 2012 10:45:52 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: 'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	'Sumit Semwal' <sumit.semwal@linaro.org>,
	'Pawel Osciak' <pawel@osciak.com>,
	'Sumit Semwal' <sumit.semwal@ti.com>,
	linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
	arnd@arndb.de, jesse.barker@linaro.org, rob@ti.com,
	daniel@ffwll.ch, patches@linaro.org
Subject: Re: [RFCv1 2/4] v4l:vb2: add support for shared buffer (dma_buf)
Message-ID: <20120123094552.GB5998@phenom.ffwll.local>
References: <1325760118-27997-1-git-send-email-sumit.semwal@ti.com>
 <201201201711.50965.laurent.pinchart@ideasonboard.com>
 <4F199446.6040403@samsung.com>
 <201201201729.00230.laurent.pinchart@ideasonboard.com>
 <000601ccd9ae$5bd5fff0$1381ffd0$%szyprowski@samsung.com>
 <20120123094007.GA5998@phenom.ffwll.local>
MIME-Version: 1.0
In-Reply-To: <20120123094007.GA5998@phenom.ffwll.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jan 23, 2012 at 10:40:07AM +0100, Daniel Vetter wrote:
> On Mon, Jan 23, 2012 at 10:06:57AM +0100, Marek Szyprowski wrote:
> > Hello,
> > 
> > On Friday, January 20, 2012 5:29 PM Laurent Pinchart wrote:
> > 
> > > On Friday 20 January 2012 17:20:22 Tomasz Stanislawski wrote:
> > > > >> IMO, One way to do this is adding field 'struct device *dev' to struct
> > > > >> vb2_queue. This field should be filled by a driver prior to calling
> > > > >> vb2_queue_init.
> > > > >
> > > > > I haven't looked into the details, but that sounds good to me. Do we have
> > > > > use cases where a queue is allocated before knowing which physical
> > > > > device it will be used for ?
> > > >
> > > > I don't think so. In case of S5P drivers, vb2_queue_init is called while
> > > > opening /dev/videoX.
> > > >
> > > > BTW. This struct device may help vb2 to produce logs with more
> > > > descriptive client annotation.
> > > >
> > > > What happens if such a device is NULL. It would happen for vmalloc
> > > > allocator used by VIVI?
> > > 
> > > Good question. Should dma-buf accept NULL devices ? Or should vivi pass its
> > > V4L2 device to vb2 ?
> > 
> > I assume you suggested using struct video_device->dev entry in such case. 
> > It will not work. DMA-mapping API requires some parameters to be set for the 
> > client device, like for example dma mask. struct video_device contains only an
> > artificial struct device entry, which has no relation to any physical device 
> > and cannot be used for calling DMA-mapping functions.
> > 
> > Performing dma_map_* operations with such artificial struct device doesn't make
> > any sense. It also slows down things significantly due to cache flushing 
> > (forced by dma-mapping) which should be avoided if the buffer is accessed only 
> > with CPU (like it is done by vb2-vmalloc style drivers).
> > 
> > IMHO this case perfectly shows the design mistake that have been made. The
> > current version simply tries to do too much. 
> 
> Nope, the current dma_buf does too little. Atm it's simple not useable for
> drivers that need cpu access, at least not if you're willing to resort to
> ugly an non-portable tricks like prime.

Argh, there's a 'not' missing in the above sentence: CPU access is not
possible, at elast not if you're *not* willing to resert to ugly ...

> We've discussed this quite a bit and decided that solving cpu access and
> coherency with n other devices involved is too much v1. It looks like we
> need to add that extension rather sooner than later.
-Daneil
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
