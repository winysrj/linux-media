Return-path: <linux-media-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:42140 "EHLO
	metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751587AbcGRIBm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Jul 2016 04:01:42 -0400
Date: Mon, 18 Jul 2016 10:01:39 +0200
From: Michael Olbrich <m.olbrich@pengutronix.de>
To: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] [media] vb2: map dmabuf for planes on driver queue
 instead of vidioc_qbuf
Message-ID: <20160718080139.GA22269@pengutronix.de>
References: <1468599966-31988-1-git-send-email-javier@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1468599966-31988-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

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

And for mem2mem devices? Does this mean that the second VIDIOC_STREAMON
will fail? That would make it impossible detect if the buffers on the
capture or the output side are incorrect.

It's already quite difficult to handle these issues gracefully and without
loosing any data. This would make it even worse.

Regards,
Michael

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
