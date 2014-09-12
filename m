Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:36005 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715AbaILVZh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Sep 2014 17:25:37 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: linux-media@vger.kernel.org, pawel@osciak.com,
	m.szyprowski@samsung.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFCv2 PATCH 01/14] vb2: introduce buf_prepare/finish_for_cpu
Date: Sat, 13 Sep 2014 00:25:36 +0300
Message-ID: <4342247.xaaAE16GTC@avalon>
In-Reply-To: <1410526803-25887-2-git-send-email-hverkuil@xs4all.nl>
References: <1410526803-25887-1-git-send-email-hverkuil@xs4all.nl> <1410526803-25887-2-git-send-email-hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

Thank you for the patch.

On Friday 12 September 2014 14:59:50 Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> This splits the buf_prepare and buf_finish actions into two: one
> called while the cpu can still access the buffer contents, and one where
> the memory has been prepared for DMA and the cpu no longer can access it.

I don't think this applies to all drivers, or rather to all memory models. vb2 
vmalloc allows drivers to touch buffers that have been prepared, and USB 
drivers certainly expect that behaviour in order to copy the content of URBs 
to the buffer as they are received.

> Update a few drivers that use buf_finish where they really meant
> buf_finish_for_cpu.

I don't think this applies to the UVC driver. The buf_finish implementation 
doesn't touch the contents of the buffer.

> The reason for this split is that some drivers need to modify the buffer,
> either before or after the DMA has taken place, in order to e.g. add JPEG
> headers or do other touch ups.
> 
> You cannot do that in buf_prepare since at that time the buffer is already
> synced for DMA and the CPU shouldn't touch it. So add these extra ops to
> make this explicit.
> 
> Note that the dma-sg memory model doesn't sync the buffers yet in the memop
> prepare. This will change in future patches.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> ---
>  drivers/media/parport/bw-qcam.c              |  4 +--
>  drivers/media/pci/sta2x11/sta2x11_vip.c      |  4 +--
>  drivers/media/platform/vivid/vivid-vid-cap.c |  4 +--
>  drivers/media/usb/go7007/go7007-v4l2.c       |  4 +--
>  drivers/media/usb/pwc/pwc-if.c               |  4 +--
>  drivers/media/usb/uvc/uvc_queue.c            |  4 +--
>  drivers/media/v4l2-core/videobuf2-core.c     | 29 ++++++++++++-----
>  include/media/videobuf2-core.h               | 48 +++++++++++++++++++------
>  8 files changed, 72 insertions(+), 29 deletions(-)

-- 
Regards,

Laurent Pinchart

