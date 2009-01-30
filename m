Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:54604 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752056AbZA3Hos (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Jan 2009 02:44:48 -0500
Date: Fri, 30 Jan 2009 08:44:50 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: morimoto.kuninori@renesas.com
cc: Linux Media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] ov772x: add support S_CROP operation.
In-Reply-To: <u3af1o8zz.wl%morimoto.kuninori@renesas.com>
Message-ID: <Pine.LNX.4.64.0901300829070.4617@axis700.grange>
References: <uskna4qh8.wl%morimoto.kuninori@renesas.com>
 <Pine.LNX.4.64.0901250245440.4969@axis700.grange> <uzlheep1l.wl%morimoto.kuninori@renesas.com>
 <Pine.LNX.4.64.0901260854010.4236@axis700.grange> <uk58hcp3k.wl%morimoto.kuninori@renesas.com>
 <alpine.DEB.2.00.0901270851280.4618@axis700.grange> <u3af1o8zz.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Morimoto-san,

On Fri, 30 Jan 2009, morimoto.kuninori@renesas.com wrote:

> > > I attached stupid 4 patches.
> (snip)
> > Thanks for the patches, please, give me a couple of days for review.
> (snip)
> >> Yes, I'm (going to be) reviewing them, as soon as I find some time.
> 
> If you have not reviewed now, please use attached one.
> It use more clever way I think.

I'll have to think about it more, but the first impression is - this 
wouldn't work.

At the moment we use the same soc-camera API call set_fmt for both S_FMT 
and S_CROP calls. But it you look in various instance drivers - host and 
camera - you will see, that almost all of them have a test "if (pixfmt)," 
i.e., they have to differentiate between the two cases. And not only 
because with pixfmt == 0 they cannot configure the stack completely, but 
because the meaning of these two calls even just with respect to geometry 
is different: S_FMT specifies scaling, whereas S_CROP preserves the 
current scaling and only specifies a window using the current scaled 
coordinates. So, you have to be able to differentiate. The original 
mt9m001 and mt9v022 drivers didn't support scaling, so, for they just used 
cropping for both, but the recently added mt9t031 does support scaling, 
so, it is indeed important. Not sure about mt9m111, and yours ov772x and 
tw9910.

Further, calling set_bus_param() from (or soc_camera_s_fmt_vid_cap()) from 
S_CROP is not enough too. This lets the capture.c example run, but, I 
think, we should be able to run with no configuration at all - even 
without a S_CROP. So, some default configuration has to be set up on 
open() or on STREAMON if none is set yet (current_fmt == NULL).

So, you can either wit until I find time to address this, or try to do 
something along these lines yourself. But I'm not sure if I manage to 
propose anything meaningful before FOSDEM (next weekend), so, this might 
take up to two weeks. But, I think, we have a bit of time before the 
2.6.30 merge window:-)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
