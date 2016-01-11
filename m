Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f182.google.com ([209.85.192.182]:33154 "EHLO
	mail-pf0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822AbcAKMxX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 11 Jan 2016 07:53:23 -0500
Date: Mon, 11 Jan 2016 18:23:11 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] [media] media: Kconfig: add dependency of HAS_DMA
Message-ID: <20160111125310.GA19742@sudip-pc>
References: <1451481963-18853-1-git-send-email-sudipm.mukherjee@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1451481963-18853-1-git-send-email-sudipm.mukherjee@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Dec 30, 2015 at 06:56:03PM +0530, Sudip Mukherjee wrote:
> The build of m32r allmodconfig fails with the error:
> drivers/media/v4l2-core/videobuf2-dma-contig.c:484:2:
> 	error: implicit declaration of function 'dma_get_cache_alignment'
> 
> The build of videobuf2-dma-contig.c depends on HAS_DMA and it is
> correctly mentioned in the Kconfig but the symbol VIDEO_STI_BDISP also
> selects VIDEOBUF2_DMA_CONTIG, so it is trying to compile
> videobuf2-dma-contig.c even though HAS_DMA is not defined.
> 
> Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
> ---

A gentle ping. m32r allmodconfig still fails with next-20160111. Build
log is at:
https://travis-ci.org/sudipm-mukherjee/parport/jobs/101536379

regards
sudip
