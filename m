Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:51692 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348AbZBBMJZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Feb 2009 07:09:25 -0500
Date: Mon, 2 Feb 2009 10:08:52 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: video4linux-list@redhat.com, linux-media@vger.kernel.org
Subject: Re: [PATCH] newport: newport_*wait() return 0 on timeout
Message-ID: <20090202100852.733c6c8e@caramujo.chehab.org>
In-Reply-To: <49846E63.8070507@gmail.com>
References: <49846E63.8070507@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Roel,

It seems that you've sent this driver to the wrong ML. Video adapters are not handled on those ML's.

On Sat, 31 Jan 2009 16:29:39 +0100
Roel Kluin <roel.kluin@gmail.com> wrote:

> With a postfix decrement t reaches -1 on timeout which results in a
> return of 0.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> diff --git a/include/video/newport.h b/include/video/newport.h
> index 1f5ebea..001b935 100644
> --- a/include/video/newport.h
> +++ b/include/video/newport.h
> @@ -453,7 +453,7 @@ static __inline__ int newport_wait(struct newport_regs *regs)
>  {
>  	int t = BUSY_TIMEOUT;
>  
> -	while (t--)
> +	while (--t)
>  		if (!(regs->cset.status & NPORT_STAT_GBUSY))
>  			break;
>  	return !t;
> @@ -463,7 +463,7 @@ static __inline__ int newport_bfwait(struct newport_regs *regs)
>  {
>  	int t = BUSY_TIMEOUT;
>  
> -	while (t--)
> +	while (--t)
>  		if(!(regs->cset.status & NPORT_STAT_BBUSY))
>  			break;
>  	return !t;




Cheers,
Mauro
