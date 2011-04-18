Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.10]:60166 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753347Ab1DRIPM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 18 Apr 2011 04:15:12 -0400
Date: Mon, 18 Apr 2011 10:14:56 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?=
	<u.kleine-koenig@pengutronix.de>
cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	kernel@pengutronix.de
Subject: Re: [PATCH] V4L: mx3_camera: select VIDEOBUF2_DMA_CONTIG instead of
 VIDEOBUF_DMA_CONTIG
In-Reply-To: <20110418080637.GA31131@pengutronix.de>
Message-ID: <Pine.LNX.4.64.1104181013250.27247@axis700.grange>
References: <1302166243-650-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <20110418080637.GA31131@pengutronix.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, 18 Apr 2011, Uwe Kleine-König wrote:

> Hi Guennadi,
> 
> On Thu, Apr 07, 2011 at 10:50:43AM +0200, Uwe Kleine-König wrote:
> > Since commit
> > 
> > 	379fa5d ([media] V4L: mx3_camera: convert to videobuf2)
> > 
> > mx3_camera uses videobuf2, but that commit didn't upgrade the select
> > resulting in the following build failure:
> > 
> > 	drivers/built-in.o: In function `mx3_camera_init_videobuf':
> > 	clkdev.c:(.text+0x86580): undefined reference to `vb2_dma_contig_memops'
> > 	drivers/built-in.o: In function `mx3_camera_probe':
> > 	clkdev.c:(.devinit.text+0x3548): undefined reference to `vb2_dma_contig_init_ctx'
> > 	clkdev.c:(.devinit.text+0x3578): undefined reference to `vb2_dma_contig_cleanup_ctx'
> > 	drivers/built-in.o: In function `mx3_camera_remove':
> > 	clkdev.c:(.devexit.text+0x674): undefined reference to `vb2_dma_contig_cleanup_ctx'
> > 	make[2]: *** [.tmp_vmlinux1] Error 1
> > 	make[1]: *** [sub-make] Error 2
> > 	make: *** [all] Error 2
> > 
> > Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > ---
> I guess the only problem with this is -ENOTIME on your side?

It's been pushed upstream almost 2 weeks ago:

http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/31352

Thanks
Guennadi

> 
> > does someone has a hint how to fix gcc not to believe the undefined
> > references to be in clkdev.c?
> I got a hint that might be related to ccache. Didn't look into it yet,
> though.
> 
> Best regards
> Uwe
> 
> -- 
> Pengutronix e.K.                           | Uwe Kleine-König            |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
