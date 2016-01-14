Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:59483 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751071AbcANIrD (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 14 Jan 2016 03:47:03 -0500
Date: Thu, 14 Jan 2016 10:46:59 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>, hverkuil@xs4all.nl,
	pawel@osciak.com, kyungmin.park@samsung.com
Subject: Re: [PATCH] [media] media: Kconfig: add dependency of HAS_DMA
Message-ID: <20160114084658.GK576@valkosipuli.retiisi.org.uk>
References: <1451481963-18853-1-git-send-email-sudipm.mukherjee@gmail.com>
 <20160111125310.GA19742@sudip-pc>
 <20160112141042.GI576@valkosipuli.retiisi.org.uk>
 <569660F7.2000802@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <569660F7.2000802@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Marek and Sudip,

On Wed, Jan 13, 2016 at 03:36:39PM +0100, Marek Szyprowski wrote:
> Hello,
> 
> On 2016-01-12 15:10, Sakari Ailus wrote:
> >On Mon, Jan 11, 2016 at 06:23:11PM +0530, Sudip Mukherjee wrote:
> >>On Wed, Dec 30, 2015 at 06:56:03PM +0530, Sudip Mukherjee wrote:
> >>>The build of m32r allmodconfig fails with the error:
> >>>drivers/media/v4l2-core/videobuf2-dma-contig.c:484:2:
> >>>	error: implicit declaration of function 'dma_get_cache_alignment'
> >>>
> >>>The build of videobuf2-dma-contig.c depends on HAS_DMA and it is
> >>>correctly mentioned in the Kconfig but the symbol VIDEO_STI_BDISP also
> >>>selects VIDEOBUF2_DMA_CONTIG, so it is trying to compile
> >>>videobuf2-dma-contig.c even though HAS_DMA is not defined.
> >>>
> >>>Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
> >>>---
> >>A gentle ping. m32r allmodconfig still fails with next-20160111. Build
> >>log is at:
> >>https://travis-ci.org/sudipm-mukherjee/parport/jobs/101536379
> >Hi Sudip,
> >
> >Even though the issue now manifests itself on m32r, the problem is wider
> >than that: dma_get_cache_alignment() is only defined if CONFIG_HAS_DMA is
> >set.
> >
> >I wonder if using videobuf2-dma-contig makes any sense if HAS_DMA is
> >disabled, so perhaps it'd be possible to make it depend on HAS_DMA.
> 
> VIDEOBUF2_DMA_CONTIG already depends on HAS_DMA, but when driver use select
> directive for enabling support for VIDEOBUF2_DMA_CONTIG, the dependencies
> are not checked further. This is known limitation/feature of kconfig system.

Thanks for the insight. Sounds like this is the right thing to do then.

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
