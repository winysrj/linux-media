Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:50204 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932128Ab0CJVsP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Mar 2010 16:48:15 -0500
Message-ID: <4B981379.1050704@nokia.com>
Date: Wed, 10 Mar 2010 23:47:37 +0200
From: Sakari Ailus <sakari.ailus@nokia.com>
MIME-Version: 1.0
To: Dan Carpenter <error27@gmail.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Trent Piepho <xyzzy@speakeasy.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	"kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: Re: [patch] omap24xxcam: potential buffer overflow
References: <20100310105703.GD6321@bicker>
In-Reply-To: <20100310105703.GD6321@bicker>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Dan Carpenter wrote:
> The previous loop goes until last == VIDEO_MAX_FRAME, so this could 
> potentially go one past the end of the loop.

Hi Dan,

Thanks for the patch!

> Signed-off-by: Dan Carpenter <error27@gmail.com>
> 
> diff --git a/drivers/media/video/omap24xxcam.c b/drivers/media/video/omap24xxcam.c
> index 142c327..bedbee9 100644
> --- a/drivers/media/video/omap24xxcam.c
> +++ b/drivers/media/video/omap24xxcam.c
> @@ -1404,7 +1404,7 @@ static int omap24xxcam_mmap_buffers(struct file *file,
>  	}
>  
>  	size = 0;
> -	for (i = first; i <= last; i++) {
> +	for (i = first; i <= last && i < VIDEO_MAX_FRAME; i++) {
>  		struct videobuf_dmabuf *dma = videobuf_to_dma(vbq->bufs[i]);
>  
>  		for (j = 0; j < dma->sglen; j++) {

That function is quite an ugly piece of code... This patch fixes an
obvious bug in it.

Acked-by: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>

-- 
Sakari Ailus
sakari.ailus@maxwell.research.nokia.com
