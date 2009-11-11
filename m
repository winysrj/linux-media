Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:33326 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758591AbZKKTWh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Nov 2009 14:22:37 -0500
Date: Wed, 11 Nov 2009 20:22:55 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Martin Michlmayr <tbm@cyrius.com>
cc: Magnus Damm <damm@igel.co.jp>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH] videobuf-dma-contig.c: add missing #include
In-Reply-To: <20091031102850.GA3850@deprecation.cyrius.com>
Message-ID: <Pine.LNX.4.64.0911112021300.4072@axis700.grange>
References: <20091031102850.GA3850@deprecation.cyrius.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, 31 Oct 2009, Martin Michlmayr wrote:

> media/video/videobuf-dma-contig.c fails to compile on ARM Versatile
> like this:
>  | videobuf-dma-contig.c: In function ‘videobuf_dma_contig_user_get’:
>  | videobuf-dma-contig.c:139: error: dereferencing pointer to incomplete type
>  | videobuf-dma-contig.c:184: error: dereferencing pointer to incomplete type
>  | make[8]: *** [drivers/media/video/videobuf-dma-contig.o] Error 1
> 
> Looking at the preprocessed source, I noticed that there was no definition
> for struct task_struct.
> 
> Signed-off-by: Martin Michlmayr <tbm@cyrius.com>

Mauro, if you decide to apply this one and then only take missing parts 
from 
http://linuxtv.org/hg/~gliakhovetski/v4l-dvb?cmd=changeset;node=d5defdb8768d 
then you can add my

Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

to this one.

> 
> --- a/drivers/media/video/videobuf-dma-contig.c	2009-10-31 10:22:42.000000000 +0000
> +++ b/drivers/media/video/videobuf-dma-contig.c	2009-10-31 10:24:40.000000000 +0000
> @@ -19,6 +19,7 @@
>  #include <linux/mm.h>
>  #include <linux/pagemap.h>
>  #include <linux/dma-mapping.h>
> +#include <linux/sched.h>
>  #include <media/videobuf-dma-contig.h>
>  
>  struct videobuf_dma_contig_memory {
> 
> -- 
> Martin Michlmayr
> http://www.cyrius.com/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
