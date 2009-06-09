Return-path: <linux-media-owner@vger.kernel.org>
Received: from 81-7-68-229.static.zebra.lt ([81.7.68.229]:59167 "EHLO
	teltonika.lt" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750880AbZFIORh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 9 Jun 2009 10:17:37 -0400
Message-ID: <4A2E6F02.6040003@teltonika.lt>
Date: Tue, 09 Jun 2009 17:17:38 +0300
From: Paulius Zaleckas <paulius.zaleckas@teltonika.lt>
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-media@vger.kernel.org, mchehab@infradead.org
Subject: Re: [PATCH 2/2] se401: Fix coding style
References: <20090609125408.10098.45945.stgit@t61.ukuu.org.uk> <20090609125720.10098.88218.stgit@t61.ukuu.org.uk>
In-Reply-To: <20090609125720.10098.88218.stgit@t61.ukuu.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Alan Cox wrote:
> From: Alan Cox <alan@linux.intel.com>
> 
> Having fixed the sprintfs I decided a quick clean wouldn't do any harm so
> it was actually easy to read in future.
> 
> Signed-off-by: Alan Cox <alan@linux.intel.com>
> ---
> 
>  drivers/media/video/se401.c |  876 ++++++++++++++++++++++---------------------
>  drivers/media/video/se401.h |    7 
>  2 files changed, 452 insertions(+), 431 deletions(-)
> 
> 
> diff --git a/drivers/media/video/se401.c b/drivers/media/video/se401.c
> index 08129a8..c8f0529 100644
> --- a/drivers/media/video/se401.c
> +++ b/drivers/media/video/se401.c

[...]

> @@ -78,8 +79,8 @@ static void *rvmalloc(unsigned long size)
>  	adr = (unsigned long) mem;
>  	while (size > 0) {
>  		SetPageReserved(vmalloc_to_page((void *)adr));
> -		adr += PAGE_SIZE;
> -		size -= PAGE_SIZE;
> +		adr +=  PAGE_SIZE;
> +		size -=  PAGE_SIZE;

Why 2 spaces are better here?

>  	}
>  
>  	return mem;
