Return-path: <mchehab@pedra>
Received: from [120.204.251.227] ([120.204.251.227]:31289 "EHLO
	LC-SHMAIL-01.SHANGHAI.LEADCORETECH.COM" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754186Ab0KQBLw (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Nov 2010 20:11:52 -0500
Message-ID: <4CE32B9D.1020705@leadcoretech.com>
Date: Wed, 17 Nov 2010 09:10:53 +0800
From: "Figo.zhang" <zhangtianfei@leadcoretech.com>
MIME-Version: 1.0
To: achew@nvidia.com
CC: hverkuil@xs4all.nl, pawel@osciak.com, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] videobuf: Initialize lists in videobuf_buffer.
References: <1289939083-27209-1-git-send-email-achew@nvidia.com>
In-Reply-To: <1289939083-27209-1-git-send-email-achew@nvidia.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>


> 
> diff --git a/drivers/media/video/videobuf-dma-contig.c b/drivers/media/video/videobuf-dma-contig.c
> index c969111..f7e0f86 100644
> --- a/drivers/media/video/videobuf-dma-contig.c
> +++ b/drivers/media/video/videobuf-dma-contig.c
> @@ -193,6 +193,8 @@ static struct videobuf_buffer *__videobuf_alloc_vb(size_t size)
>   	if (vb) {
>   		mem = vb->priv = ((char *)vb) + size;
>   		mem->magic = MAGIC_DC_MEM;
> +		INIT_LIST_HEAD(&vb->stream);
> +		INIT_LIST_HEAD(&vb->queue);

i think it no need to be init, it just a list-entry.
