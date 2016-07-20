Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:40604 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753805AbcGTNUm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 20 Jul 2016 09:20:42 -0400
Date: Wed, 20 Jul 2016 16:20:05 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Javier Martinez Canillas <javier@osg.samsung.com>
Cc: linux-kernel@vger.kernel.org,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Pawel Osciak <pawel@osciak.com>, linux-media@vger.kernel.org,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Shuah Khan <shuahkh@osg.samsung.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Luis de Bethencourt <luisbg@osg.samsung.com>
Subject: Re: [PATCH] [media] vb2: map dmabuf for planes on driver queue
 instead of vidioc_qbuf
Message-ID: <20160720132005.GC7976@valkosipuli.retiisi.org.uk>
References: <1468599966-31988-1-git-send-email-javier@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1468599966-31988-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Javier,

On Fri, Jul 15, 2016 at 12:26:06PM -0400, Javier Martinez Canillas wrote:
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

I have the same question has Hans --- why?

I rather think we should keep the buffers mapped all the time. That'd
require a bit of extra from the DMA-BUF framework I suppose, to support
streaming mappings.

The reason for that is performance. If you're passing the buffer between a
couple of hardware devices, there's no need to map and unmap it every time
the buffer is accessed by the said devices. That'd avoid an unnecessary
cache flush as well, something that tends to be quite expensive. On a PC
with resolutions typically used on webcams that might not really matter. But
if you have an embedded system with a relatively modest 10 MP camera sensor,
it's one of the first things you'll notice if you check where the CPU time
is being spent.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
