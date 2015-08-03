Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46371 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755758AbbHCXTl (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Aug 2015 19:19:41 -0400
Date: Mon, 3 Aug 2015 16:19:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Jens Axboe <axboe@kernel.dk>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [RFC PATCH v2] lib: scatterlist: add sg splitting function
Message-Id: <20150803161939.2edd494eb64bc81ea8e91c16@linux-foundation.org>
In-Reply-To: <1438435033-7636-1-git-send-email-robert.jarzmik@free.fr>
References: <1438435033-7636-1-git-send-email-robert.jarzmik@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat,  1 Aug 2015 15:17:13 +0200 Robert Jarzmik <robert.jarzmik@free.fr> wrote:

> Sometimes a scatter-gather has to be split into several chunks, or sub scatter
> lists. This happens for example if a scatter list will be handled by multiple
> DMA channels, each one filling a part of it.
> 
> A concrete example comes with the media V4L2 API, where the scatter list is
> allocated from userspace to hold an image, regardless of the knowledge of how
> many DMAs will fill it :
>  - in a simple RGB565 case, one DMA will pump data from the camera ISP to memory
>  - in the trickier YUV422 case, 3 DMAs will pump data from the camera ISP pipes,
>    one for pipe Y, one for pipe U and one for pipe V
> 
> For these cases, it is necessary to split the original scatter list into
> multiple scatter lists, which is the purpose of this patch.
> 
> ...
>
>  include/linux/scatterlist.h |   5 ++
>  lib/scatterlist.c           | 189 ++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 194 insertions(+)

It's quite a bit of code for a fairly specialised thing.  How ugly
would it be to put this in a new .c file and have subsystems select it
in Kconfig?

