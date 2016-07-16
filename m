Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:46780
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447AbcGPMPu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 16 Jul 2016 08:15:50 -0400
Message-ID: <578A256F.7040706@osg.samsung.com>
Date: Sat, 16 Jul 2016 13:15:43 +0100
From: Luis de Bethencourt <luisbg@osg.samsung.com>
MIME-Version: 1.0
To: Javier Martinez Canillas <javier@osg.samsung.com>,
	linux-kernel@vger.kernel.org
CC: Marek Szyprowski <m.szyprowski@samsung.com>,
	Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Pawel Osciak <pawel@osciak.com>, linux-media@vger.kernel.org,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>
Subject: Re: [PATCH] [media] vb2: map dmabuf for planes on driver queue instead
 of vidioc_qbuf
References: <1468599966-31988-1-git-send-email-javier@osg.samsung.com>
In-Reply-To: <1468599966-31988-1-git-send-email-javier@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 15/07/16 17:26, Javier Martinez Canillas wrote:
> The buffer planes' dma-buf are currently mapped when buffers are queued
> from userspace but it's more appropriate to do the mapping when buffers
> are queued in the driver since that's when the actual DMA operation are
> going to happen.
> 
> Suggested-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
> 
> ---
> 
> Hello,
> 
> A side effect of this change is that if the dmabuf map fails for some
> reasons (i.e: a driver using the DMA contig memory allocator but CMA
> not being enabled), the fail will no longer happen on VIDIOC_QBUF but
> later (i.e: in VIDIOC_STREAMON).
> 
> I don't know if that's an issue though but I think is worth mentioning.
> 
> Best regards,
> Javier
> 

Just run this path on the ODROID using GStreamer and the vivid driver.
It worked nicely.

Tested-by: Luis de Bethencourt <luisbg@osg.samsung.com>

Thanks Javier,
Luis

