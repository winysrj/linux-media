Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:40578 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750909AbZAZJrr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Jan 2009 04:47:47 -0500
Date: Mon, 26 Jan 2009 10:47:39 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: morimoto.kuninori@renesas.com
cc: Linux Media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] ov772x: add support S_CROP operation.
In-Reply-To: <upriaiesk.wl%morimoto.kuninori@renesas.com>
Message-ID: <Pine.LNX.4.64.0901261047190.4236@axis700.grange>
References: <uskna4qh8.wl%morimoto.kuninori@renesas.com>
 <Pine.LNX.4.64.0901250245440.4969@axis700.grange> <uzlheep1l.wl%morimoto.kuninori@renesas.com>
 <Pine.LNX.4.64.0901260854010.4236@axis700.grange> <ur62qifpj.wl%morimoto.kuninori@renesas.com>
 <upriaiesk.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 26 Jan 2009, morimoto.kuninori@renesas.com wrote:

> 
> Dear Guennadi
> 
> > > This is probably because you don't setup a default mode in 
> > > sh_mobile_ceu_camera.c or ov772x.c if S_FMT is never called. This should 
> > > be fixed. I'm not sure if other drivers would deliver anything meaningful 
> > > without a call to S_FMT - has to be tested / fixed...
> > (snip)
> > > > In this case, shoud ov772x use defaul color format
> > > > when S_CROP order ?
> > > 
> > > The thing is that older versions of capture.c always called S_FMT, newer 
> > > ones don't unless forced per "-f" switch.
> > 
> > Yes. Now, sh_mobile_ceu :: set_bus_param must be called to use camera.
> > We need -f option. Thank you.
> 
> sorry. wrong understanding.
> ov772x and tw9910 should works even if -f is not used.
> is this correct ?

Yes.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
