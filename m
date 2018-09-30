Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:52406 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728074AbeI3QCz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 30 Sep 2018 12:02:55 -0400
Date: Sun, 30 Sep 2018 06:30:34 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org, Joe Perches <joe@perches.com>,
        Eugen Hristev <eugen.hristev@microchip.com>,
        Josh Wu <josh.wu@atmel.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>
Subject: Re: [PATCH] MAINTAINERS: Remove stale file entry for the Atmel ISI
 driver
Message-ID: <20180930063034.1dab99d9@coco.lan>
In-Reply-To: <20180930065448.5019-1-laurent.pinchart@ideasonboard.com>
References: <20180930065448.5019-1-laurent.pinchart@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 30 Sep 2018 09:54:48 +0300
Laurent Pinchart <laurent.pinchart@ideasonboard.com> escreveu:

> include/media/atmel-isi got removed three years ago without the
> MAINTAINERS file being updated. Remove the stale entry.
> 
> Fixes: 40a78f36fc92 ("[media] v4l: atmel-isi: Remove support for platform data")
> Reported-by: Joe Perches <joe@perches.com>
> Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> ---
>  MAINTAINERS | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 9989925f658d..1f5da095aff7 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -2497,7 +2497,6 @@ M:	Ludovic Desroches <ludovic.desroches@microchip.com>
>  L:	linux-media@vger.kernel.org
>  S:	Supported
>  F:	drivers/media/platform/atmel/atmel-isi.c
> -F:	include/media/atmel-isi.h

I guess the right fix would be to replace it by:

F: drivers/media/platform/atmel/atmel-isi.h

>  
>  ATMEL LCDFB DRIVER
>  M:	Nicolas Ferre <nicolas.ferre@microchip.com>



Thanks,
Mauro
