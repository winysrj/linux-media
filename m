Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:25527 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478AbcGUNNi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 21 Jul 2016 09:13:38 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0OAO0090922N2WB0@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 21 Jul 2016 14:13:35 +0100 (BST)
Subject: Re: [PATCHv2 0/2] vb2: check for valid device pointer
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
References: <1469103243-5296-1-git-send-email-hverkuil@xs4all.nl>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
	laurent.pinchart@ideasonboard.com
From: Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <2f4812ba-6bc4-4159-93b2-294cf12d1a80@samsung.com>
Date: Thu, 21 Jul 2016 15:13:33 +0200
MIME-version: 1.0
In-reply-to: <1469103243-5296-1-git-send-email-hverkuil@xs4all.nl>
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi


On 2016-07-21 14:14, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
>
> Make error handling of alloc, get_userptr and attach_dmabuf systematic.
>
> Add tests to check for a valid non-NULL device pointer.

Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>

>
> Regards,
>
> 	Hans
>
> Changes since v1:
>
> - Split into two patches
> - Drop pr_debug
>
> Hans Verkuil (2):
>    vb2: don't return NULL for alloc and get_userptr ops
>    vb2: add WARN_ONs checking if a valid struct device was passed
>
>   drivers/media/v4l2-core/videobuf2-core.c       | 12 ++++++++----
>   drivers/media/v4l2-core/videobuf2-dma-contig.c |  9 +++++++++
>   drivers/media/v4l2-core/videobuf2-dma-sg.c     | 19 +++++++++++++------
>   drivers/media/v4l2-core/videobuf2-vmalloc.c    | 13 ++++++++-----
>   include/media/videobuf2-core.h                 |  6 +++---
>   5 files changed, 41 insertions(+), 18 deletions(-)
>

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

