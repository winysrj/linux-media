Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:34997 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756674Ab0A2E7K (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 28 Jan 2010 23:59:10 -0500
Message-ID: <4B626B19.5000609@infradead.org>
Date: Fri, 29 Jan 2010 02:59:05 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
MIME-Version: 1.0
To: H Hartley Sweeten <hartleys@visionengravers.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
	linux-media@vger.kernel.org, michael@mihu.de
Subject: Re: [PATCH] drivers/media/common: remove unnecessary casts of void
 *
References: <201001081551.42264.hartleys@visionengravers.com>
In-Reply-To: <201001081551.42264.hartleys@visionengravers.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

H Hartley Sweeten wrote:
> drivers/media/common: Remove unnecessary casts of void *
> 
> void pointers do not need to be cast to other pointer types.
> 

> diff --git a/drivers/media/common/saa7146_vbi.c b/drivers/media/common/saa7146_vbi.c
> index 74e2b56..301a795 100644
> --- a/drivers/media/common/saa7146_vbi.c
> +++ b/drivers/media/common/saa7146_vbi.c
> @@ -3,7 +3,7 @@
>  static int vbi_pixel_to_capture = 720 * 2;
>  
>  static int vbi_workaround(struct saa7146_dev *dev)
> -{
> +{.remove_casts.hhs~

What's this? It seems that your patch got corrupted somehow.

Cheers,
Mauro

