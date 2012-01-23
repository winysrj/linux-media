Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:14970 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852Ab2AWJHI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jan 2012 04:07:08 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
Received: from euspt2 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LY800GZJUNUWH20@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 23 Jan 2012 09:07:06 +0000 (GMT)
Received: from linux.samsung.com ([106.116.38.10])
 by spt2.w1.samsung.com (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14
 2004)) with ESMTPA id <0LY800B12UNUGL@spt2.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 23 Jan 2012 09:07:06 +0000 (GMT)
Date: Mon, 23 Jan 2012 10:06:57 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [RFCv1 2/4] v4l:vb2: add support for shared buffer (dma_buf)
In-reply-to: <201201201729.00230.laurent.pinchart@ideasonboard.com>
To: 'Laurent Pinchart' <laurent.pinchart@ideasonboard.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: 'Sumit Semwal' <sumit.semwal@linaro.org>,
	'Pawel Osciak' <pawel@osciak.com>,
	'Sumit Semwal' <sumit.semwal@ti.com>,
	linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org,
	arnd@arndb.de, jesse.barker@linaro.org, rob@ti.com,
	daniel@ffwll.ch, patches@linaro.org
Message-id: <000601ccd9ae$5bd5fff0$1381ffd0$%szyprowski@samsung.com>
Content-language: pl
References: <1325760118-27997-1-git-send-email-sumit.semwal@ti.com>
 <201201201711.50965.laurent.pinchart@ideasonboard.com>
 <4F199446.6040403@samsung.com>
 <201201201729.00230.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On Friday, January 20, 2012 5:29 PM Laurent Pinchart wrote:

> On Friday 20 January 2012 17:20:22 Tomasz Stanislawski wrote:
> > >> IMO, One way to do this is adding field 'struct device *dev' to struct
> > >> vb2_queue. This field should be filled by a driver prior to calling
> > >> vb2_queue_init.
> > >
> > > I haven't looked into the details, but that sounds good to me. Do we have
> > > use cases where a queue is allocated before knowing which physical
> > > device it will be used for ?
> >
> > I don't think so. In case of S5P drivers, vb2_queue_init is called while
> > opening /dev/videoX.
> >
> > BTW. This struct device may help vb2 to produce logs with more
> > descriptive client annotation.
> >
> > What happens if such a device is NULL. It would happen for vmalloc
> > allocator used by VIVI?
> 
> Good question. Should dma-buf accept NULL devices ? Or should vivi pass its
> V4L2 device to vb2 ?

I assume you suggested using struct video_device->dev entry in such case. 
It will not work. DMA-mapping API requires some parameters to be set for the 
client device, like for example dma mask. struct video_device contains only an
artificial struct device entry, which has no relation to any physical device 
and cannot be used for calling DMA-mapping functions.

Performing dma_map_* operations with such artificial struct device doesn't make
any sense. It also slows down things significantly due to cache flushing 
(forced by dma-mapping) which should be avoided if the buffer is accessed only 
with CPU (like it is done by vb2-vmalloc style drivers).

IMHO this case perfectly shows the design mistake that have been made. The
current version simply tries to do too much. 

Each client of dma_buf should 'map' the provided sgtable/scatterlist on its own.
Only the client device driver has all knowledge to make a proper 'mapping'.
Real physical devices usually will use dma_map_sg() for such operation, while
some virtual ones will only create a kernel mapping for the provided scatterlist
(like vivi with vmalloc memory module).

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center



