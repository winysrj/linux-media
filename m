Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:54773 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbbDUNTw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Apr 2015 09:19:52 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Hyun Kwon <hyun.kwon@xilinx.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Michal Simek <michal.simek@xilinx.com>,
	=?ISO-8859-1?Q?S=F6ren?= Brinkmann <soren.brinkmann@xilinx.com>,
	linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] [media] v4l: xilinx: harmless buffer overflow
Date: Tue, 21 Apr 2015 16:20 +0300
Message-ID: <1496059.xVrMZN3Nsa@avalon>
In-Reply-To: <20150421093110.GD12098@mwanda>
References: <20150421093110.GD12098@mwanda>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Dan,

Thank you for the patch.

On Tuesday 21 April 2015 12:31:10 Dan Carpenter wrote:
> My static checker warns that the name of the port can be 15 characters
> when you consider the NUL terminator and that's one more than the 14
> characters in name[].  Maybe it's an off-by-one?
>
> It's unlikely that we hit the limit and even if we do the overflow will
> only affect one of the two bytes of padding so it's harmless.  Still
> let's fix it and also change the sprintf() to snprintf().
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/media/platform/xilinx/xilinx-dma.c
> b/drivers/media/platform/xilinx/xilinx-dma.c index efde88a..98e50e4 100644
> --- a/drivers/media/platform/xilinx/xilinx-dma.c
> +++ b/drivers/media/platform/xilinx/xilinx-dma.c
> @@ -653,7 +653,7 @@ static const struct v4l2_file_operations xvip_dma_fops =
> { int xvip_dma_init(struct xvip_composite_device *xdev, struct xvip_dma
> *dma, enum v4l2_buf_type type, unsigned int port)
>  {
> -	char name[14];
> +	char name[16];

Being pedantic we could use name[15], but it wouldn't make any difference.

>  	int ret;
> 
>  	dma->xdev = xdev;
> @@ -725,7 +725,7 @@ int xvip_dma_init(struct xvip_composite_device *xdev,
> struct xvip_dma *dma, }
> 
>  	/* ... and the DMA channel. */
> -	sprintf(name, "port%u", port);
> +	snprintf(name, sizeof(name), "port%u", port);

Nitpicking again, I'd say that sprintf is enough as we know it won't overflow. 
However, as the sprintf implementation is a wrapper around vsnprintf with size 
set to INT_MAX, using snprintf won't incur any runtime performance penalty.

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

and applied to my tree.

>  	dma->dma = dma_request_slave_channel(dma->xdev->dev, name);
>  	if (dma->dma == NULL) {
>  		dev_err(dma->xdev->dev, "no VDMA channel found\n");

-- 
Regards,

Laurent Pinchart

