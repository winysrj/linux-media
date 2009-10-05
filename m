Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:46682 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754128AbZJESCP (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 5 Oct 2009 14:02:15 -0400
Date: Mon, 5 Oct 2009 20:01:39 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Kuninori Morimoto <morimoto.kuninori@renesas.com>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/2] soc-camera: add a new driver for the RJ54N1CB0C
 camera sensor from Sharp
In-Reply-To: <uljjqvhac.wl%morimoto.kuninori@renesas.com>
Message-ID: <Pine.LNX.4.64.0910052000430.4337@axis700.grange>
References: <Pine.LNX.4.64.0910031319320.5857@axis700.grange>
 <uljjqvhac.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello Morimoto-san

On Mon, 5 Oct 2009, Kuninori Morimoto wrote:

> Dear Guennadi
> 
> > diff --git a/drivers/media/video/Makefile b/drivers/media/video/Makefile
> > index e706cee..2851e5e 100644
> > --- a/drivers/media/video/Makefile
> > +++ b/drivers/media/video/Makefile
> > @@ -79,6 +79,7 @@ obj-$(CONFIG_SOC_CAMERA_MT9V022)	+= mt9v022.o
> >  obj-$(CONFIG_SOC_CAMERA_OV772X)		+= ov772x.o
> >  obj-$(CONFIG_SOC_CAMERA_OV9640)		+= ov9640.o
> >  obj-$(CONFIG_SOC_CAMERA_TW9910)		+= tw9910.o
> > +obj-$(CONFIG_SOC_CAMERA_RJ54N1)		+= rj54n1cb0c.o
> 
> alphabet order wrong ?
> 'R' is earlier than 'T' ?

Thanks, I forgot they were ordered:-) Fixed in the final version.

Regards
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
