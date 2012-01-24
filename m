Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:60419 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755868Ab2AXKw4 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Jan 2012 05:52:56 -0500
Received: by werb13 with SMTP id b13so2838420wer.19
        for <linux-media@vger.kernel.org>; Tue, 24 Jan 2012 02:52:55 -0800 (PST)
Date: Tue, 24 Jan 2012 11:52:55 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: "Clark, Rob" <rob@ti.com>, Daniel Vetter <daniel@ffwll.ch>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Pawel Osciak <pawel@osciak.com>,
	Sumit Semwal <sumit.semwal@ti.com>,
	linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
	arnd@arndb.de, jesse.barker@linaro.org, patches@linaro.org
Subject: Re: [RFCv1 2/4] v4l:vb2: add support for shared buffer (dma_buf)
Message-ID: <20120124105255.GB3980@phenom.ffwll.local>
References: <1325760118-27997-1-git-send-email-sumit.semwal@ti.com>
 <201201231154.21006.laurent.pinchart@ideasonboard.com>
 <CAO8GWqmv0mqk_=VvSmOCQkREFTRZ7L_xgRa9i=Wx8ap08m3zpw@mail.gmail.com>
 <201201241034.39393.laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
In-Reply-To: <201201241034.39393.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jan 24, 2012 at 10:34:38AM +0100, Laurent Pinchart wrote:
> > > I'm not sure I would like a callback approach. If we add a sync
> > > operation, the exporter could signal to the importer that it must unmap
> > > the buffer by returning an appropriate value from the sync operation.
> > > Would that be usable for DRM ?
> > 
> > It does seem a bit over-complicated..  and deadlock prone.  Is there a
> > reason the importer couldn't just unmap when DMA is completed, and the
> > exporter give some hint on next map() that the buffer hasn't actually
> > moved?
> 
> If the importer unmaps the buffer completely when DMA is completed, it will 
> have to map it again for the next DMA transfer, even if the 
> dma_buf_map_attachement() calls returns an hint that the buffer hasn't moved.
> 
> What I want to avoid here is having to map/unmap buffers to the device IOMMU 
> around each DMA if the buffer doesn't move. To avoid that, the importer needs 
> to keep the IOMMU mapping after DMA completes if the buffer won't move until 
> the next DMA transfer, but that information isn't available when the first DMA 
> completes.

The exporter should cache the iommu mapping for all attachments. The
driver would the only need to adjust the dma address - I was kinda hoping
this would be little enough overhead that we could just ignore it, at
least for the moment (especially for hw that can only deal with contigious
buffers).

The issue with adding explicit support for evicting buffers is that it's
hilariously deadlock-prone, especially when both sides are exporters (dev1
waits for dev2 to finish processing buffer A while dev2 waits for dev1 to
finish with buffer B ...). Before we don't have a solid buffer sharing
between gpus (i.e. prime) I don't think it makes sense to add these
extension to dma_buf.
-Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
