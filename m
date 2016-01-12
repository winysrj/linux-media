Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:41294 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752211AbcALOKt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 12 Jan 2016 09:10:49 -0500
Date: Tue, 12 Jan 2016 16:10:43 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>, hverkuil@xs4all.nl,
	pawel@osciak.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com
Subject: Re: [PATCH] [media] media: Kconfig: add dependency of HAS_DMA
Message-ID: <20160112141042.GI576@valkosipuli.retiisi.org.uk>
References: <1451481963-18853-1-git-send-email-sudipm.mukherjee@gmail.com>
 <20160111125310.GA19742@sudip-pc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160111125310.GA19742@sudip-pc>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jan 11, 2016 at 06:23:11PM +0530, Sudip Mukherjee wrote:
> On Wed, Dec 30, 2015 at 06:56:03PM +0530, Sudip Mukherjee wrote:
> > The build of m32r allmodconfig fails with the error:
> > drivers/media/v4l2-core/videobuf2-dma-contig.c:484:2:
> > 	error: implicit declaration of function 'dma_get_cache_alignment'
> > 
> > The build of videobuf2-dma-contig.c depends on HAS_DMA and it is
> > correctly mentioned in the Kconfig but the symbol VIDEO_STI_BDISP also
> > selects VIDEOBUF2_DMA_CONTIG, so it is trying to compile
> > videobuf2-dma-contig.c even though HAS_DMA is not defined.
> > 
> > Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
> > ---
> 
> A gentle ping. m32r allmodconfig still fails with next-20160111. Build
> log is at:
> https://travis-ci.org/sudipm-mukherjee/parport/jobs/101536379

Hi Sudip,

Even though the issue now manifests itself on m32r, the problem is wider
than that: dma_get_cache_alignment() is only defined if CONFIG_HAS_DMA is
set.

I wonder if using videobuf2-dma-contig makes any sense if HAS_DMA is
disabled, so perhaps it'd be possible to make it depend on HAS_DMA.

Cc others.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
