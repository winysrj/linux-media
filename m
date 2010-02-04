Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail1.radix.net ([207.192.128.31]:56902 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758007Ab0BDAsn (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 3 Feb 2010 19:48:43 -0500
Subject: Re: [patch 5/7] drivers/media/video/cx18/cx18-alsa-pcm.c: fix
 printk warning
From: Andy Walls <awalls@radix.net>
To: akpm@linux-foundation.org
Cc: mchehab@infradead.org, linux-media@vger.kernel.org
In-Reply-To: <201002022240.o12MeoSv018915@imap1.linux-foundation.org>
References: <201002022240.o12MeoSv018915@imap1.linux-foundation.org>
Content-Type: text/plain
Date: Wed, 03 Feb 2010 19:47:45 -0500
Message-Id: <1265244465.3122.11.camel@palomino.walls.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 2010-02-02 at 14:40 -0800, akpm@linux-foundation.org wrote:
> From: Andrew Morton <akpm@linux-foundation.org>
> 
> drivers/media/video/cx18/cx18-alsa-pcm.c: In function 'cx18_alsa_announce_pcm_data':
> drivers/media/video/cx18/cx18-alsa-pcm.c:82: warning: format '%d' expects type 'int', but argument 5 has type 'size_t'
> 
> Cc: Andy Walls <awalls@radix.net>

You beat me to it. :)

Acked-by: Andy Walls <awalls@radix.net>

> Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  drivers/media/video/cx18/cx18-alsa-pcm.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff -puN drivers/media/video/cx18/cx18-alsa-pcm.c~drivers-media-video-cx18-cx18-alsa-pcmc-fix-printk-warning drivers/media/video/cx18/cx18-alsa-pcm.c
> --- a/drivers/media/video/cx18/cx18-alsa-pcm.c~drivers-media-video-cx18-cx18-alsa-pcmc-fix-printk-warning
> +++ a/drivers/media/video/cx18/cx18-alsa-pcm.c
> @@ -79,7 +79,7 @@ void cx18_alsa_announce_pcm_data(struct 
>  	int period_elapsed = 0;
>  	int length;
>  
> -	dprintk("cx18 alsa announce ptr=%p data=%p num_bytes=%d\n", cxsc,
> +	dprintk("cx18 alsa announce ptr=%p data=%p num_bytes=%zd\n", cxsc,
>  		pcm_data, num_bytes);
>  
>  	substream = cxsc->capture_pcm_substream;
> _
> 

