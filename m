Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:47356
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705AbcGVT40 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jul 2016 15:56:26 -0400
Message-ID: <57927A64.6000307@osg.samsung.com>
Date: Fri, 22 Jul 2016 20:56:20 +0100
From: Luis de Bethencourt <luisbg@osg.samsung.com>
MIME-Version: 1.0
To: Javier Martinez Canillas <javier@osg.samsung.com>,
	linux-kernel@vger.kernel.org
CC: Sakari Ailus <sakari.ailus@iki.fi>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Pawel Osciak <pawel@osciak.com>, linux-media@vger.kernel.org,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Shuah Khan <shuahkh@osg.samsung.com>
Subject: Re: [PATCH] [media] vb2: move dma-buf unmap from __vb2_dqbuf() to
 vb2_buffer_done()
References: <1469038941-5257-1-git-send-email-javier@osg.samsung.com>
In-Reply-To: <1469038941-5257-1-git-send-email-javier@osg.samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 20/07/16 19:22, Javier Martinez Canillas wrote:
> Currently the dma-buf is unmapped when the buffer is dequeued by userspace
> but it's not used anymore after the driver finished processing the buffer.
> 
> So instead of doing the dma-buf unmapping in __vb2_dqbuf(), it can be made
> in vb2_buffer_done() after the driver notified that buf processing is done.
> 
> Decoupling the buffer dequeue from the dma-buf unmapping has also the side
> effect of making possible to add dma-buf fence support in the future since
> the buffer could be dequeued even before the driver has finished using it.
> 
> Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>
> 
> ---
> Hello,
> 
> I've tested this patch doing DMA buffer sharing between a
> vivid input and output device with both v4l2-ctl and gst:
> 
> $ v4l2-ctl -d0 -e1 --stream-dmabuf --stream-out-mmap
> $ v4l2-ctl -d0 -e1 --stream-mmap --stream-out-dmabuf
> $ gst-launch-1.0 v4l2src device=/dev/video0 io-mode=dmabuf ! v4l2sink device=/dev/video1 io-mode=dmabuf-import
> 
> And I didn't find any issues but more testing will be appreciated.
> 
> Best regards,
> Javier
> 

Hello all,

Tested this using the same GStreamer pipeline as Javier mentions above.
It works nicely.

Thanks,
Luis

Tested-by: Luis de Bethencourt <luisbg@osg.samsung.com> 

