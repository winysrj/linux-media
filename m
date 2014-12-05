Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:59573 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750891AbaLEHHR (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 5 Dec 2014 02:07:17 -0500
Date: Fri, 5 Dec 2014 08:07:07 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [GIT PULL] soc-camera: 1st set for 3.19
In-Reply-To: <20141201150340.23e6013e@recife.lan>
Message-ID: <Pine.LNX.4.64.1412050805460.12083@axis700.grange>
References: <Pine.LNX.4.64.1411282307180.15467@axis700.grange>
 <20141201150340.23e6013e@recife.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Mon, 1 Dec 2014, Mauro Carvalho Chehab wrote:

> Em Fri, 28 Nov 2014 23:15:32 +0100 (CET)
> Guennadi Liakhovetski <g.liakhovetski@gmx.de> escreveu:
> 
> > Hi Mauro,
> > 
> > IIUC, this coming Sunday might be the last -rc, so, postponing pull 
> > requests to subsystem maintainers even further isn't a good idea, so, here 
> > goes an soc-camera request. I know it isn't complete, there are a few more 
> > patches waiting to be pushed upstream, but I won't have time this coming 
> > weekend and next two weeks I'm traveling, which won't simplify things 
> > either. Some more patches are being reworked, if they arrive soon and we 
> > do get another -rc, I might try to push them too, but I don't want to 
> > postpone these ones, while waiting. One of these patches has also been 
> > modified by me and hasn't been tested yet. But changes weren't too 
> > complex. If however I did break something, we'll have to fix it in an 
> > incremental patch.
> > 
> > The following changes since commit d298a59791fad3a707c1dadbef0935ee2664a10e:
> > 
> >   Merge branch 'patchwork' into to_next (2014-11-21 17:01:46 -0200)
> > 
> > are available in the git repository at:
> > 
> > 
> >   git://linuxtv.org/gliakhovetski/v4l-dvb.git for-3.19-1
> > 
> > for you to fetch changes up to d8f5c144e57d99d2a7325bf8877812bf560e22dd:
> > 
> >   rcar_vin: Fix interrupt enable in progressive (2014-11-23 12:08:19 +0100)
> > 
> > ----------------------------------------------------------------
> > Koji Matsuoka (4):
> >       rcar_vin: Add YUYV capture format support
> >       rcar_vin: Add scaling support
> 
> Hmm...
> 
> WARNING: DT compatible string "renesas,vin-r8a7794" appears un-documented -- check ./Documentation/devicetree/bindings/
> #38: FILE: drivers/media/platform/soc_camera/rcar_vin.c:1406:
> +	{ .compatible = "renesas,vin-r8a7794", .data = (void *)RCAR_GEN2 },
> 
> WARNING: DT compatible string "renesas,vin-r8a7793" appears un-documented -- check ./Documentation/devicetree/bindings/
> #39: FILE: drivers/media/platform/soc_camera/rcar_vin.c:1407:
> +	{ .compatible = "renesas,vin-r8a7793", .data = (void *)RCAR_GEN2 },
> 
> Where are the DT binding documentation for this?
> 
> You should be adding a patch to:
> 	Documentation/devicetree/bindings/media/rcar_vin.txt
> before this one.

Sure, documentation is in the same patch

http://git.linuxtv.org/cgit.cgi/gliakhovetski/v4l-dvb.git/commit/?h=for-3.19-1&id=aa1f7651acbe222948f43e239eda15362c9e274c

Is it because you cannot push it via your tree or what's happened, why 
this warning?

Thanks
Guennadi

> 
> 
> 
> >       rcar_vin: Enable VSYNC field toggle mode
> >       rcar_vin: Fix interrupt enable in progressive
> > 
> > Yoshihiro Kaneko (1):
> >       rcar_vin: Add DT support for r8a7793 and r8a7794 SoCs
> > 
> >  .../devicetree/bindings/media/rcar_vin.txt         |   2 +
> >  drivers/media/platform/soc_camera/rcar_vin.c       | 466 ++++++++++++++++++++-
> >  2 files changed, 457 insertions(+), 11 deletions(-)
> > 
> > Thanks
> > Guennadi
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
