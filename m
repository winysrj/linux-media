Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:63120 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750985AbbBRVRN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 18 Feb 2015 16:17:13 -0500
Date: Wed, 18 Feb 2015 22:16:58 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
cc: Geert Uytterhoeven <geert+renesas@glider.be>,
	Ben Dooks <ben.dooks@codethink.co.uk>,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	linux-media@vger.kernel.org, linux-sh@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] [media] soc-camera: Remove bogus devm_kfree() in
 soc_of_bind()
In-Reply-To: <54E4D2DB.4050909@cogentembedded.com>
Message-ID: <Pine.LNX.4.64.1502182216060.31387@axis700.grange>
References: <1424277163-24869-1-git-send-email-geert+renesas@glider.be>
 <54E4D2DB.4050909@cogentembedded.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 18 Feb 2015, Sergei Shtylyov wrote:

> Hello.
> 
> On 02/18/2015 07:32 PM, Geert Uytterhoeven wrote:
> 
> > Unlike scan_async_group(), soc_of_bind() doesn't allocate its
> > soc_camera_async_client structure using devm_kzalloc(), but has it
> > embedded inside the soc_of_info structure.  Hence on failure, it must
> > not free it using devm_kfree(), as this will cause a warning, and may
> > cause slab corruption:
> 
> [...]
> 
> > Fixes: 1ddc6a6caa94e1e1 ("[media] soc_camera: add support for dt binding
> > soc_camera drivers")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> > ---
> > Triggered with shmobile-defconfig on r8a7791/koelsch.
> > ---
> >   drivers/media/platform/soc_camera/soc_camera.c | 1 -
> >   1 file changed, 1 deletion(-)
> 
> > diff --git a/drivers/media/platform/soc_camera/soc_camera.c
> > b/drivers/media/platform/soc_camera/soc_camera.c
> > index cee7b56f84049944..d8a072fe46035821 100644
> > --- a/drivers/media/platform/soc_camera/soc_camera.c
> > +++ b/drivers/media/platform/soc_camera/soc_camera.c
> > @@ -1665,7 +1665,6 @@ eclkreg:
> >   eaddpdev:
> >   	platform_device_put(sasc->pdev);
> >   eallocpdev:
> > -	devm_kfree(ici->v4l2_dev.dev, sasc);
> 
>    Perhaps Ben meant 'info' ISO 'sasc'? This way it would make more sense.

Agree. Geert, could you double-check and respin?

Thanks
Guennadi

> 
> >   	dev_err(ici->v4l2_dev.dev, "group probe failed: %d\n", ret);
> > 
> >   	return ret;
> 
> WBR, Sergei
> 
