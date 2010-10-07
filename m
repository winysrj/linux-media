Return-path: <mchehab@pedra>
Received: from perceval.irobotique.be ([92.243.18.41]:53059 "EHLO
	perceval.irobotique.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760598Ab0JGNqO (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 7 Oct 2010 09:46:14 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/3] V4L/DVB: videobuf-dma-sg: Use min_t(size_t, PAGE_SIZE ..)
Date: Thu, 7 Oct 2010 15:46:29 +0200
References: <20101007094543.47b77328@pedra>
In-Reply-To: <20101007094543.47b77328@pedra>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010071546.30191.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro,

On Thursday 07 October 2010 14:45:43 Mauro Carvalho Chehab wrote:
> As pointed by Laurent:
> 
> I think min_t(size_t, PAGE_SIZE, size) is the preferred way.
> 
> Thanks-to: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> diff --git a/drivers/media/video/videobuf-dma-sg.c
> b/drivers/media/video/videobuf-dma-sg.c index 7153e44..20f227e 100644
> --- a/drivers/media/video/videobuf-dma-sg.c
> +++ b/drivers/media/video/videobuf-dma-sg.c
> @@ -116,8 +116,8 @@ static struct scatterlist *videobuf_pages_to_sg(struct
> page **pages, goto nopage;
>  		if (PageHighMem(pages[i]))
>  			goto highmem;
> -		sg_set_page(&sglist[i], pages[i], min((unsigned)PAGE_SIZE, size), 0);
> -		size -= min((unsigned)PAGE_SIZE, size);
> +		sg_set_page(&sglist[i], pages[i], min_t(size_t, PAGE_SIZE, size), 0);

This won't pass checkpatch.pl (line > 80 characters long).

Beside, this patch applies on top of the previous one whereas I suppose you'd 
want to replace the previous one.

> +		size -= min_t(size_t, PAGE_SIZE, size);
>  	}
>  	return sglist;

-- 
Regards,

Laurent Pinchart
