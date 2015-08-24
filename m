Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-io0-f171.google.com ([209.85.223.171]:33623 "EHLO
	mail-io0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754550AbbHXUPK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 24 Aug 2015 16:15:10 -0400
Received: by iods203 with SMTP id s203so162628680iod.0
        for <linux-media@vger.kernel.org>; Mon, 24 Aug 2015 13:15:10 -0700 (PDT)
Message-ID: <55DB7B4C.4010804@kernel.dk>
Date: Mon, 24 Aug 2015 14:15:08 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Robert Jarzmik <robert.jarzmik@free.fr>,
	Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] lib: scatterlist: add sg splitting function
References: <1439023450-2689-1-git-send-email-robert.jarzmik@free.fr>
In-Reply-To: <1439023450-2689-1-git-send-email-robert.jarzmik@free.fr>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/08/2015 02:44 AM, Robert Jarzmik wrote:
> Sometimes a scatter-gather has to be split into several chunks, or sub
> scatter lists. This happens for example if a scatter list will be
> handled by multiple DMA channels, each one filling a part of it.
>
> A concrete example comes with the media V4L2 API, where the scatter list
> is allocated from userspace to hold an image, regardless of the
> knowledge of how many DMAs will fill it :
>   - in a simple RGB565 case, one DMA will pump data from the camera ISP
>     to memory
>   - in the trickier YUV422 case, 3 DMAs will pump data from the camera
>     ISP pipes, one for pipe Y, one for pipe U and one for pipe V
>
> For these cases, it is necessary to split the original scatter list into
> multiple scatter lists, which is the purpose of this patch.
>
> The guarantees that are required for this patch are :
>   - the intersection of spans of any couple of resulting scatter lists is
>     empty.
>   - the union of spans of all resulting scatter lists is a subrange of
>     the span of the original scatter list.
>   - streaming DMA API operations (mapping, unmapping) should not happen
>     both on both the resulting and the original scatter list. It's either
>     the first or the later ones.
>   - the caller is reponsible to call kfree() on the resulting
>     scatterlists.
>
> Signed-off-by: Robert Jarzmik <robert.jarzmik@free.fr>

I think this looks fine. But do we really need the Kconfig option? It's 
not a lot of code, and it seems silly to put the onus on the driver for 
having to enable something that is a subset of the SG api.

-- 
Jens Axboe

