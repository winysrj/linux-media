Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:28976 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbaIVGSs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 22 Sep 2014 02:18:48 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NCA00BHGHNYGL30@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Mon, 22 Sep 2014 07:21:34 +0100 (BST)
Message-id: <541FBF45.6030601@samsung.com>
Date: Mon, 22 Sep 2014 08:18:45 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
MIME-version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>, Pawel Osciak <pawel@osciak.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: RFC: vb2: replace alloc_ctx by struct device * in vb2_queue
References: <541ECD1D.5020605@xs4all.nl>
In-reply-to: <541ECD1D.5020605@xs4all.nl>
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On 2014-09-21 15:05, Hans Verkuil wrote:
> Hi Marek, Pawel,
>
> Currently for dma_config (and the dma_sg code that I posted before) drivers have
> to allocate a alloc_ctx context, but in practice that just contains a device pointer.
>
> Is there any reason why we can't just change in struct vb2_queue:
>
> 	void                            *alloc_ctx[VIDEO_MAX_PLANES];
>
> to:
>
> 	struct device                   *alloc_ctx[VIDEO_MAX_PLANES];
>
> or possibly even just:
>
> 	struct device                   *alloc_ctx;
>
> That simplifies the code quite a bit and I don't see and need for anything
> else. The last option would make it impossible to have different allocation
> contexts for different planes, but that might be something that Samsumg needs.

The last option won't work for for s5p-mfc driver, so better please keep
separate context per each plane.

If we are going to change the structures and their names, then maybe we 
should
get rid of 'context' name are simply replace it by the following entry in
vb2_queue:

struct device  *alloc_dev[VIDEO_MAX_PLANES];


and change respective parameter names in memory allocators.

The true context was useful when we were using custom, non-mainline memory
allocators.

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

