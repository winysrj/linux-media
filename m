Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pz0-f196.google.com ([209.85.222.196]:39329 "EHLO
	mail-pz0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216AbZHJVXK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Aug 2009 17:23:10 -0400
Received: by pzk34 with SMTP id 34so3086050pzk.4
        for <linux-media@vger.kernel.org>; Mon, 10 Aug 2009 14:23:11 -0700 (PDT)
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: hverkuil@xs4all.nl, linux-media@vger.kernel.org,
	davinci-linux-open-source@linux.davincidsp.com
Subject: Re: [PATCH] V4L/DVB: dm646x: fix DMA_nnBIT_MASK
References: <1248389413-19366-1-git-send-email-khilman@deeprootsystems.com>
From: Kevin Hilman <khilman@deeprootsystems.com>
Date: Mon, 10 Aug 2009 14:23:08 -0700
In-Reply-To: <1248389413-19366-1-git-send-email-khilman@deeprootsystems.com> (Kevin Hilman's message of "Thu\, 23 Jul 2009 15\:50\:13 -0700")
Message-ID: <87r5vjfjnn.fsf@deeprootsystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Kevin Hilman <khilman@deeprootsystems.com> writes:

> Fix deprecated use of DMA_nnBIT_MASK which now gives a compiler
> warning.
>
> Signed-off-by: Kevin Hilman <khilman@deeprootsystems.com>
> ---
> This compiler warning patch is on top of the master branch of Mauro's 
> linux-next tree.

Ping. 

This is needed on top of the DaVinci changes queued in the master branch
of Mauro's linux-next.git.

Kevin

>  arch/arm/mach-davinci/dm646x.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/arch/arm/mach-davinci/dm646x.c b/arch/arm/mach-davinci/dm646x.c
> index 73a7e8b..8f38371 100644
> --- a/arch/arm/mach-davinci/dm646x.c
> +++ b/arch/arm/mach-davinci/dm646x.c
> @@ -720,7 +720,7 @@ static struct platform_device vpif_display_dev = {
>  	.id		= -1,
>  	.dev		= {
>  			.dma_mask 		= &vpif_dma_mask,
> -			.coherent_dma_mask	= DMA_32BIT_MASK,
> +			.coherent_dma_mask	= DMA_BIT_MASK(32),
>  	},
>  	.resource	= vpif_resource,
>  	.num_resources	= ARRAY_SIZE(vpif_resource),
> -- 
> 1.6.3.3
