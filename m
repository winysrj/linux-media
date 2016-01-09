Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:64438 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752395AbcAIKrM (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 9 Jan 2016 05:47:12 -0500
Date: Sat, 9 Jan 2016 11:46:57 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
cc: Yoshihiro Kaneko <ykaneko0929@gmail.com>,
	linux-media@vger.kernel.org, Simon Horman <horms@verge.net.au>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
Subject: Re: [PATCH] media: soc_camera: rcar_vin: Add R-Car Gen3 support
In-Reply-To: <566DAE57.6030000@cogentembedded.com>
Message-ID: <Pine.LNX.4.64.1601091140200.15612@axis700.grange>
References: <1450020436-809-1-git-send-email-ykaneko0929@gmail.com>
 <566DAE57.6030000@cogentembedded.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sergei,

On Sun, 13 Dec 2015, Sergei Shtylyov wrote:

> On 12/13/2015 06:27 PM, Yoshihiro Kaneko wrote:
> 
> > From: Yoshihiko Mori <yoshihiko.mori.nx@renesas.com>
> > 
> > Add chip identification for R-Car Gen3.
> > 
> > Signed-off-by: Yoshihiko Mori <yoshihiko.mori.nx@renesas.com>
> > Signed-off-by: Yoshihiro Kaneko <ykaneko0929@gmail.com>
> [...]
> > diff --git a/drivers/media/platform/soc_camera/rcar_vin.c
> > b/drivers/media/platform/soc_camera/rcar_vin.c
> > index 5d90f39..29e7ca4 100644
> > --- a/drivers/media/platform/soc_camera/rcar_vin.c
> > +++ b/drivers/media/platform/soc_camera/rcar_vin.c
> > @@ -143,6 +143,7 @@
> >   #define RCAR_VIN_BT656			(1 << 3)
> > 
> >   enum chip_id {
> > +	RCAR_GEN3,
> >   	RCAR_GEN2,
> >   	RCAR_H1,
> >   	RCAR_M1,
> > @@ -1846,6 +1847,7 @@ static struct soc_camera_host_ops rcar_vin_host_ops =
> > {
> > 
> >   #ifdef CONFIG_OF
> >   static const struct of_device_id rcar_vin_of_table[] = {
> > +	{ .compatible = "renesas,vin-r8a7795", .data = (void *)RCAR_GEN3 },
> 
>    I don't see where this is checked in the driver. Shouldn't we just use
> gen2?

That would be different. What this patch does is not the same, as using 
GEN2. GEN2 is used in the driver when setting up the hardware for RGB32, 
so, if you would use GEN2 for r8a7795 as well, that code path would be 
used for it too. This patch adds GEN3 without modifying that check, so, if 
you now attempt to use RGB32 with GEN3 / r8a7795 it would issue an 
"invalid" warning and fail. Of course, I have no idea, whether this is the 
intended behaviour, especially since many other chips do seem to support 
RGB32 via that code...

Thanks
Guennadi

> 
> MBR, Sergei
> 
