Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:33289 "EHLO
	mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762872AbcALQGN (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jan 2016 11:06:13 -0500
Date: Tue, 12 Jan 2016 21:35:56 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>, hverkuil@xs4all.nl,
	pawel@osciak.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com
Subject: Re: [PATCH] [media] media: Kconfig: add dependency of HAS_DMA
Message-ID: <20160112160555.GA6866@sudip-laptop>
References: <1451481963-18853-1-git-send-email-sudipm.mukherjee@gmail.com>
 <20160111125310.GA19742@sudip-pc>
 <20160112141042.GI576@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160112141042.GI576@valkosipuli.retiisi.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jan 12, 2016 at 04:10:43PM +0200, Sakari Ailus wrote:
> On Mon, Jan 11, 2016 at 06:23:11PM +0530, Sudip Mukherjee wrote:
> > On Wed, Dec 30, 2015 at 06:56:03PM +0530, Sudip Mukherjee wrote:
> > > The build of m32r allmodconfig fails with the error:
> > > drivers/media/v4l2-core/videobuf2-dma-contig.c:484:2:
> > > 	error: implicit declaration of function 'dma_get_cache_alignment'
> > > 
> > > The build of videobuf2-dma-contig.c depends on HAS_DMA and it is
> > > correctly mentioned in the Kconfig but the symbol VIDEO_STI_BDISP also
> > > selects VIDEOBUF2_DMA_CONTIG, so it is trying to compile
> > > videobuf2-dma-contig.c even though HAS_DMA is not defined.
> > > 
> > > Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
> > > ---
> > 
> > A gentle ping. m32r allmodconfig still fails with next-20160111. Build
> > log is at:
> > https://travis-ci.org/sudipm-mukherjee/parport/jobs/101536379
> 
> Hi Sudip,
> 
> Even though the issue now manifests itself on m32r, the problem is wider
> than that: dma_get_cache_alignment() is only defined if CONFIG_HAS_DMA is
> set.
> 
> I wonder if using videobuf2-dma-contig makes any sense if HAS_DMA is
> disabled, so perhaps it'd be possible to make it depend on HAS_DMA.

I have checked with all the Kconfig which selects VIDEOBUF2_DMA_CONTIG
and all of them does depend on HAS_DMA. This is the only place where it
was missing.

regards
sudip
