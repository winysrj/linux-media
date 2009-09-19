Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:57980 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754305AbZISMRV (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 19 Sep 2009 08:17:21 -0400
Date: Sat, 19 Sep 2009 09:16:44 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Magnus Damm <damm@igel.co.jp>
Subject: Re: Diffs between our tree and upstream
Message-ID: <20090919091644.0219cfba@pedra.chehab.org>
In-Reply-To: <20090919010602.7e8f2df2@pedra.chehab.org>
References: <20090919010602.7e8f2df2@pedra.chehab.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sat, 19 Sep 2009 01:06:02 -0300
Mauro Carvalho Chehab <mchehab@infradead.org> escreveu:

> Hi Guennadi,
> 
> I'm about to send our pull request.
> 
> While doing my last checks, I noticed a difference between our tree and
> upstream. I'm not sure what happens. Could you please check?
> 
> The enclosed patch is the diff from upstream to -hg.

Ok, I discovered the cause of the conflict: 
	git patch 6d1386c6b8db54ac8d94c01194e0c27cd538532b were applied before the
soc_camera conversion to v4l dev/subdev.

I've applied the patch on our development tree. Still, we have a few diffs,
probably meaning that I solved it at the wrong way at git.

Please let me know what would be the proper way to fix it: by keeping
clk_enable/clk_disable (so reverting part of Magnus changes),
or by using, instead pm_runtime_get_sync/pm_runtime_put_sync.

I guess the latter is the proper fix, but, as both use API's that are sh
specific, the better is if you could point me the right way.

Cheers,
Mauro.

diff -upr oldtree/drivers/media/video/sh_mobile_ceu_camera.c /home/v4l/tokernel/wrk/linux-next/drivers/media/video/sh_mobile_ceu_camera.c
--- oldtree/drivers/media/video/sh_mobile_ceu_camera.c	2009-09-19 09:08:13.000000000 -0300
+++ /home/v4l/tokernel/wrk/linux-next/drivers/media/video/sh_mobile_ceu_camera.c	2009-09-19 01:35:28.000000000 -0300
@@ -404,7 +404,7 @@ static int sh_mobile_ceu_add_device(stru
 		 "SuperH Mobile CEU driver attached to camera %d\n",
 		 icd->devnum);
 
-	pm_runtime_get_sync(ici->dev);
+	clk_enable(pcdev->clk);
 
 	ceu_write(pcdev, CAPSR, 1 << 16); /* reset */
 	while (ceu_read(pcdev, CSTSR) & 1)
@@ -438,7 +438,7 @@ static void sh_mobile_ceu_remove_device(
 	}
 	spin_unlock_irqrestore(&pcdev->lock, flags);
 
-	pm_runtime_put_sync(ici->dev);
+	clk_disable(pcdev->clk);
 
 	dev_info(icd->dev.parent,
 		 "SuperH Mobile CEU driver detached from camera %d\n",






Cheers,
Mauro
