Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:54473 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753261AbbH3LPG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Aug 2015 07:15:06 -0400
Date: Sun, 30 Aug 2015 13:14:43 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Robert Jarzmik <robert.jarzmik@free.fr>
cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Jiri Kosina <trivial@kernel.org>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Robert Jarzmik <robert.jarzmik@intel.com>
Subject: Re: [PATCH v3 3/4] media: pxa_camera: trivial move of dma irq
 functions
In-Reply-To: <1438198744-6150-4-git-send-email-robert.jarzmik@free.fr>
Message-ID: <Pine.LNX.4.64.1508301312250.29683@axis700.grange>
References: <1438198744-6150-1-git-send-email-robert.jarzmik@free.fr>
 <1438198744-6150-4-git-send-email-robert.jarzmik@free.fr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 29 Jul 2015, Robert Jarzmik wrote:

> From: Robert Jarzmik <robert.jarzmik@intel.com>
> 
> This moves the dma irq handling functions up in the source file, so that
> they are available before DMA preparation functions. It prepares the
> conversion to DMA engine, where the descriptors are populated with these
> functions as callbacks.
> 
> Signed-off-by: Robert Jarzmik <robert.jarzmik@intel.com>
> ---
> Since v1: fixed prototypes change
> ---
>  drivers/media/platform/soc_camera/pxa_camera.c | 42 +++++++++++++++-----------
>  1 file changed, 24 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/media/platform/soc_camera/pxa_camera.c b/drivers/media/platform/soc_camera/pxa_camera.c
> index 39c7e7519b3c..cdfb93aaee43 100644
> --- a/drivers/media/platform/soc_camera/pxa_camera.c
> +++ b/drivers/media/platform/soc_camera/pxa_camera.c
> @@ -313,6 +313,30 @@ static int calculate_dma_sglen(struct scatterlist *sglist, int sglen,

[snip]

> +	pxa_camera_dma_irq(pcdev, DMA_Y);

[snip]

> -	pxa_camera_dma_irq(channel, pcdev, DMA_Y);

This still seems to break compilation to me. Could you compile-test after 
each your patch, please?

Thanks
Guennadi
