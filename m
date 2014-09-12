Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:43186 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226AbaILG6I (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Sep 2014 02:58:08 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0NBS00IBM0TPBG20@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 12 Sep 2014 08:01:01 +0100 (BST)
Message-id: <5412997D.4040806@samsung.com>
Date: Fri, 12 Sep 2014 08:58:05 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
MIME-version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	linux-media@vger.kernel.org
Cc: Pawel Osciak <pawel@osciak.com>, Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [PATCH] v4l: videobuf2: Fix typos in comments
References: <1410475426-30019-1-git-send-email-laurent.pinchart@ideasonboard.com>
In-reply-to: <1410475426-30019-1-git-send-email-laurent.pinchart@ideasonboard.com>
Content-type: text/plain; charset=utf-8; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

On 2014-09-12 00:43, Laurent Pinchart wrote:
> The buffer flags are incorrectly referred to as V4L2_BUF_FLAGS_* instead
> of V4L2_BUF_FLAG_* in comments. Fix it.
>
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>

> ---
>   include/media/videobuf2-core.h | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/include/media/videobuf2-core.h b/include/media/videobuf2-core.h
> index 5a10d8d..5901b24 100644
> --- a/include/media/videobuf2-core.h
> +++ b/include/media/videobuf2-core.h
> @@ -356,8 +356,8 @@ struct v4l2_fh;
>    * @buf_struct_size: size of the driver-specific buffer structure;
>    *		"0" indicates the driver doesn't want to use a custom buffer
>    *		structure type, so sizeof(struct vb2_buffer) will is used
> - * @timestamp_flags: Timestamp flags; V4L2_BUF_FLAGS_TIMESTAMP_* and
> - *		V4L2_BUF_FLAGS_TSTAMP_SRC_*
> + * @timestamp_flags: Timestamp flags; V4L2_BUF_FLAG_TIMESTAMP_* and
> + *		V4L2_BUF_FLAG_TSTAMP_SRC_*
>    * @gfp_flags:	additional gfp flags used when allocating the buffers.
>    *		Typically this is 0, but it may be e.g. GFP_DMA or __GFP_DMA32
>    *		to force the buffer allocation to a specific memory zone.

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

