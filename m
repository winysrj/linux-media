Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:50869 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675Ab2AWOo2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Jan 2012 09:44:28 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Received: from euspt1 ([210.118.77.13]) by mailout3.w1.samsung.com
 (Sun Java(tm) System Messaging Server 6.3-8.04 (built Jul 29 2009; 32bit))
 with ESMTP id <0LY900GH0AA2WY70@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 23 Jan 2012 14:44:26 +0000 (GMT)
Received: from [106.116.48.223] by spt1.w1.samsung.com
 (iPlanet Messaging Server 5.2 Patch 2 (built Jul 14 2004))
 with ESMTPA id <0LY900F2CAA2V0@spt1.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 23 Jan 2012 14:44:26 +0000 (GMT)
Date: Mon, 23 Jan 2012 15:44:25 +0100
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
Subject: Re: [PATCH] media: vb2-memops: Export vb2_get_vma symbol
In-reply-to: <1327329338-18374-1-git-send-email-laurent.pinchart@ideasonboard.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linaro-mm-sig@lists.linaro.org, linux-media@vger.kernel.org
Message-id: <4F1D7249.4030509@samsung.com>
References: <1327326675-8431-9-git-send-email-t.stanislaws@samsung.com>
 <1327329338-18374-1-git-send-email-laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Thank you for finding a bug in vb2-core.

Regards,
Tomasz Stanislawski

On 01/23/2012 03:35 PM, Laurent Pinchart wrote:
> The vb2_get_vma() function is called by videobuf2-dma-contig. Export it.
>
> Signed-off-by: Laurent Pinchart<laurent.pinchart@ideasonboard.com>
> ---
>   drivers/media/video/videobuf2-memops.c |    1 +
>   1 files changed, 1 insertions(+), 0 deletions(-)
>
> Hi Thomas,
>
> The following patch is needed to compile videobuf2-dma-contig as a module.
>
> diff --git a/drivers/media/video/videobuf2-memops.c b/drivers/media/video/videobuf2-memops.c
> index 71a7a78..718f70e 100644
> --- a/drivers/media/video/videobuf2-memops.c
> +++ b/drivers/media/video/videobuf2-memops.c
> @@ -55,6 +55,7 @@ struct vm_area_struct *vb2_get_vma(struct vm_area_struct *vma)
>
>   	return vma_copy;
>   }
> +EXPORT_SYMBOL_GPL(vb2_get_vma);
>
>   /**
>    * vb2_put_userptr() - release a userspace virtual memory area

