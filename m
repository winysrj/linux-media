Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:33336 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752235Ab0JGHsX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Oct 2010 03:48:23 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/3] V4L/DVB: videobuf-dma-sg: Fix a warning due to the usage of min(PAGE_SIZE, arg)
Date: Thu, 7 Oct 2010 09:48:38 +0200
References: <20101006225647.2c0dfa39@pedra>
In-Reply-To: <20101006225647.2c0dfa39@pedra>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201010070948.39123.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

On Thursday 07 October 2010 03:56:47 Mauro Carvalho Chehab wrote:
> drivers/media/video/videobuf-dma-sg.c: In function ‘videobuf_pages_to_sg’:
> drivers/media/video/videobuf-dma-sg.c:119: warning: comparison of distinct
> pointer types lacks a cast drivers/media/video/videobuf-dma-sg.c:120:
> warning: comparison of distinct pointer types lacks a cast
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> diff --git a/drivers/media/video/videobuf-dma-sg.c
> b/drivers/media/video/videobuf-dma-sg.c index 359f2f3..7153e44 100644
> --- a/drivers/media/video/videobuf-dma-sg.c
> +++ b/drivers/media/video/videobuf-dma-sg.c
> @@ -116,8 +116,8 @@ static struct scatterlist *videobuf_pages_to_sg(struct
> page **pages, goto nopage;
>  		if (PageHighMem(pages[i]))
>  			goto highmem;
> -		sg_set_page(&sglist[i], pages[i], min(PAGE_SIZE, size), 0);
> -		size -= min(PAGE_SIZE, size);
> +		sg_set_page(&sglist[i], pages[i], min((unsigned)PAGE_SIZE, size), 0);
> +		size -= min((unsigned)PAGE_SIZE, size);

I think min_t(size_t, PAGE_SIZE, size) is the preferred way.

>  	}
>  	return sglist;

-- 
Regards,

Laurent Pinchart
