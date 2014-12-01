Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:38755 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753807AbaLARDp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 1 Dec 2014 12:03:45 -0500
Date: Mon, 1 Dec 2014 15:03:40 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL] soc-camera: 1st set for 3.19
Message-ID: <20141201150340.23e6013e@recife.lan>
In-Reply-To: <Pine.LNX.4.64.1411282307180.15467@axis700.grange>
References: <Pine.LNX.4.64.1411282307180.15467@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 28 Nov 2014 23:15:32 +0100 (CET)
Guennadi Liakhovetski <g.liakhovetski@gmx.de> escreveu:

> Hi Mauro,
> 
> IIUC, this coming Sunday might be the last -rc, so, postponing pull 
> requests to subsystem maintainers even further isn't a good idea, so, here 
> goes an soc-camera request. I know it isn't complete, there are a few more 
> patches waiting to be pushed upstream, but I won't have time this coming 
> weekend and next two weeks I'm traveling, which won't simplify things 
> either. Some more patches are being reworked, if they arrive soon and we 
> do get another -rc, I might try to push them too, but I don't want to 
> postpone these ones, while waiting. One of these patches has also been 
> modified by me and hasn't been tested yet. But changes weren't too 
> complex. If however I did break something, we'll have to fix it in an 
> incremental patch.
> 
> The following changes since commit d298a59791fad3a707c1dadbef0935ee2664a10e:
> 
>   Merge branch 'patchwork' into to_next (2014-11-21 17:01:46 -0200)
> 
> are available in the git repository at:
> 
> 
>   git://linuxtv.org/gliakhovetski/v4l-dvb.git for-3.19-1
> 
> for you to fetch changes up to d8f5c144e57d99d2a7325bf8877812bf560e22dd:
> 
>   rcar_vin: Fix interrupt enable in progressive (2014-11-23 12:08:19 +0100)
> 
> ----------------------------------------------------------------
> Koji Matsuoka (4):
>       rcar_vin: Add YUYV capture format support
>       rcar_vin: Add scaling support

Hmm...

WARNING: DT compatible string "renesas,vin-r8a7794" appears un-documented -- check ./Documentation/devicetree/bindings/
#38: FILE: drivers/media/platform/soc_camera/rcar_vin.c:1406:
+	{ .compatible = "renesas,vin-r8a7794", .data = (void *)RCAR_GEN2 },

WARNING: DT compatible string "renesas,vin-r8a7793" appears un-documented -- check ./Documentation/devicetree/bindings/
#39: FILE: drivers/media/platform/soc_camera/rcar_vin.c:1407:
+	{ .compatible = "renesas,vin-r8a7793", .data = (void *)RCAR_GEN2 },

Where are the DT binding documentation for this?

You should be adding a patch to:
	Documentation/devicetree/bindings/media/rcar_vin.txt
before this one.



>       rcar_vin: Enable VSYNC field toggle mode
>       rcar_vin: Fix interrupt enable in progressive
> 
> Yoshihiro Kaneko (1):
>       rcar_vin: Add DT support for r8a7793 and r8a7794 SoCs
> 
>  .../devicetree/bindings/media/rcar_vin.txt         |   2 +
>  drivers/media/platform/soc_camera/rcar_vin.c       | 466 ++++++++++++++++++++-
>  2 files changed, 457 insertions(+), 11 deletions(-)
> 
> Thanks
> Guennadi
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
