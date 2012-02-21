Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:61127 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753795Ab2BUJYp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Feb 2012 04:24:45 -0500
Date: Tue, 21 Feb 2012 10:24:29 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: javier Martin <javier.martin@vista-silicon.com>
cc: linux-media@vger.kernel.org, mchehab@infradead.org,
	s.hauer@pengutronix.de
Subject: Re: [PATCH] media: i.MX27 camera: Add resizing support.
In-Reply-To: <CACKLOr2uOab=yS6iE2A871=dEfWH5jFDcoL7FQ2=nKOyJkHN-A@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1202211020040.18412@axis700.grange>
References: <1329219332-27620-1-git-send-email-javier.martin@vista-silicon.com>
 <Pine.LNX.4.64.1202201413300.2836@axis700.grange>
 <CACKLOr1KT2A1Zd_xsVXPGW8X6e57v6xTZTm46wdfNfwwf9-MYQ@mail.gmail.com>
 <Pine.LNX.4.64.1202210936420.18412@axis700.grange>
 <CACKLOr2uOab=yS6iE2A871=dEfWH5jFDcoL7FQ2=nKOyJkHN-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 21 Feb 2012, javier Martin wrote:

> On 21 February 2012 09:39, Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> > Hi Javier
> >
> > One more thing occurred to me: I don't see anywhere in your patch checking
> > for supported pixel (fourcc) formats. I don't think the PRP can resize
> > arbitrary formats? Most likely these would be limited to some YUV, and,
> > possibly, some RGB formats?
> 
> The PrP can resize every format which is supported as input by the eMMa.
> 
> Currently, the driver supports 2 input formats: RGB565 and YUV422
> (YUYV)  (see mx27_emma_prp_table[]).

That's not how I understand it. The mx27_emma_prp_table[] array has 2 
entries: the first one is indeed configured for RGB565, and the second one 
is converting input YUV422 to output YUV420. But the former one is not 
really that specific format, rather it is a generic configuration used as 
a pass-through mode for generic 16-bit formats.

BTW, does that mean, that on i.MX27 the driver currently doesn't support 
8-bit formats like Bayer?

Thanks
Guennadi

> Since the commit of resizing registers is done in the stream_start
> callback this makes sure that resizing won't be applied to unknown
> formats.
> 
> Regards.
> -- 
> Javier Martin
> Vista Silicon S.L.
> CDTUC - FASE C - Oficina S-345
> Avda de los Castros s/n
> 39005- Santander. Cantabria. Spain
> +34 942 25 32 60
> www.vista-silicon.com

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
