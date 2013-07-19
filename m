Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:49991 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755520Ab3GSIvh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 19 Jul 2013 04:51:37 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MQ6006ORDW03FC0@mailout1.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 19 Jul 2013 09:51:35 +0100 (BST)
Message-id: <51E8FE15.4090604@samsung.com>
Date: Fri, 19 Jul 2013 10:51:33 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>,
	=?ISO-8859-1?Q?=A0Mauro_Carvalho_?= =?ISO-8859-1?Q?Chehab?=
	<mchehab@redhat.com>, Pawel Osciak <pawel@osciak.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	=?ISO-8859-1?Q?=A0Ismael_Luceno?=
	<ismael.luceno@corp.bluecherry.net>,
	=?ISO-8859-1?Q?=A0Greg_Kroah-Hartman?= <gregkh@linuxfoundation.org>,
	linux-media@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH 2/4] videobuf2-dma-sg: Replace vb2_dma_sg_desc with sg_table
References: <1374220729-8304-1-git-send-email-ricardo.ribalda@gmail.com>
 <1374220729-8304-3-git-send-email-ricardo.ribalda@gmail.com>
In-reply-to: <1374220729-8304-3-git-send-email-ricardo.ribalda@gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Ricardo,

On 07/19/2013 09:58 AM, Ricardo Ribalda Delgado wrote:
> Replace the private struct vb2_dma_sg_desc with the struct sg_table so
> we can benefit from all the helping functions in lib/scatterlist.c for
> things like allocating the sg or compacting the descriptor
> 
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> ---
[...]
> diff --git a/include/media/videobuf2-dma-sg.h b/include/media/videobuf2-dma-sg.h
> index 0038526..7b89852 100644
> --- a/include/media/videobuf2-dma-sg.h
> +++ b/include/media/videobuf2-dma-sg.h
> @@ -15,16 +15,10 @@
>  
>  #include <media/videobuf2-core.h>
>  
> -struct vb2_dma_sg_desc {
> -	unsigned long		size;
> -	unsigned int		num_pages;
> -	struct scatterlist	*sglist;
> -};

You need to squash patches 3/4, 4/4 into this one to avoid breaking
build and git bisection.

Thanks,
Sylwester

