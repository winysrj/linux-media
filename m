Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr13.xs4all.nl ([194.109.24.33]:3909 "EHLO
	smtp-vbr13.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437AbaIDQWV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 4 Sep 2014 12:22:21 -0400
Message-ID: <5408918A.2090607@xs4all.nl>
Date: Thu, 04 Sep 2014 18:21:30 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 3/3] [media] tw68: don't assume that pagesize is always
 4096
References: <ce9e1ac1b9becb9481f8492d9ccf713398a07ef8.1409841955.git.m.chehab@samsung.com> <5bbc05f52d23b17cc0faa81a2e5d4f2a344aaaa9.1409841955.git.m.chehab@samsung.com>
In-Reply-To: <5bbc05f52d23b17cc0faa81a2e5d4f2a344aaaa9.1409841955.git.m.chehab@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 09/04/2014 04:46 PM, Mauro Carvalho Chehab wrote:
> This code implicitly assumes that pagesize is 4096, but this is
> not true on all archs, as the PAGE_SHIFT can be different than
> 12 on all those architectures: alpha, arc, arm64, cris, frv,
> hexagon,ia64, m68k, metag, microblaze, mips, openrisc, parisc,
> powerpc, sh, sparc and tile.
> 
> The real constrant here seems to be to limit the buffer size to
> 4MB.
> 
> So, fix the code to reflect that, in a way that it will keep
> working with differnt values for PAGE_SIZE.

While your fix is OK, I have a better patch that makes the code a lot more
readable. I'll post that soon.

Regards,

	Hans

> 
> Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
> 
> diff --git a/drivers/media/pci/tw68/tw68-video.c b/drivers/media/pci/tw68/tw68-video.c
> index 4dd38578cf1b..66658accdca9 100644
> --- a/drivers/media/pci/tw68/tw68-video.c
> +++ b/drivers/media/pci/tw68/tw68-video.c
> @@ -366,7 +366,7 @@ static int tw68_buffer_pages(int size)
>  {
>  	size  = PAGE_ALIGN(size);
>  	size += PAGE_SIZE; /* for non-page-aligned buffers */
> -	size /= 4096;
> +	size /= PAGE_SIZE;
>  	return size;
>  }
>  
> @@ -376,7 +376,7 @@ static int tw68_buffer_count(unsigned int size, unsigned int count)
>  {
>  	unsigned int maxcount;
>  
> -	maxcount = 1024 / tw68_buffer_pages(size);
> +	maxcount = (4096 * 1024 / PAGE_SIZE) / tw68_buffer_pages(size);
>  	if (count > maxcount)
>  		count = maxcount;
>  	return count;
> 

