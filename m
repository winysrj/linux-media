Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr9.xs4all.nl ([194.109.24.29]:3281 "EHLO
	smtp-vbr9.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050AbaC1J3C (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Mar 2014 05:29:02 -0400
Message-ID: <533540CE.8070703@xs4all.nl>
Date: Fri, 28 Mar 2014 10:28:46 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Ma Haijun <mahaijuns@gmail.com>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [media] videobuf-dma-contig: fix vm_iomap_memory() call
References: <1395918426-27787-1-git-send-email-mahaijuns@gmail.com>
In-Reply-To: <1395918426-27787-1-git-send-email-mahaijuns@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 03/27/2014 12:07 PM, Ma Haijun wrote:
> Hi all,
> 
> This is a trivial fix, but I think the patch itself has problem too. 
> The function requires a phys_addr_t, but we feed it with a dma_handle_t.
> AFAIK, this implicit conversion does not always work.
> Can I use virt_to_phys(mem->vaddr) to get the physical address instead?
> (mem->vaddr and mem->dma_handle are from dma_alloc_coherent)

Does this actually fail? With what driver and on what hardware?

I ask because I am very reluctant to make any changes to videobuf. It is
slowly being replaced by the vastly superior videobuf2 framework. Existing
drivers in the kernel still using the old videobuf seem to work just fine
(or at least as fine as videobuf allows you to be).

Regards,

	Hans

> 
> Regards
> 
> Ma Haijun
> 
> Ma Haijun (1):
>   [media] videobuf-dma-contig: fix incorrect argument to
>     vm_iomap_memory() call
> 
>  drivers/media/v4l2-core/videobuf-dma-contig.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

