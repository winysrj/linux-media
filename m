Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:58391 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752156AbZA0HxT (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Jan 2009 02:53:19 -0500
Date: Tue, 27 Jan 2009 08:53:23 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: morimoto.kuninori@renesas.com
cc: Linux Media <linux-media@vger.kernel.org>
Subject: Re: [PATCH] ov772x: add support S_CROP operation.
In-Reply-To: <uk58hcp3k.wl%morimoto.kuninori@renesas.com>
Message-ID: <alpine.DEB.2.00.0901270851280.4618@axis700.grange>
References: <uskna4qh8.wl%morimoto.kuninori@renesas.com> <Pine.LNX.4.64.0901250245440.4969@axis700.grange> <uzlheep1l.wl%morimoto.kuninori@renesas.com> <Pine.LNX.4.64.0901260854010.4236@axis700.grange> <uk58hcp3k.wl%morimoto.kuninori@renesas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, 27 Jan 2009, morimoto.kuninori@renesas.com wrote:

> Dear Guennadi
> 
> > > what is the best way to us ???
> > > or do I miss understanding ???
> > 
> > Fix behaviour if no S_FMT is done.
> 
> I attached stupid 4 patches.
> I would like to hear your opinion.
> please check it.
> 
> I wonder is there any soc_camera that works without 
> calling S_FMT though set_bus_param is not called ?

Don't know, never tested that way. Might well be they don't, in which case 
they need to be fixed.

> If soc_camera works without calling S_FMT, 
> s_crop should call try_fmt_vid_cap
> and set_bus_param like s_fmt_vid_cap I think.
> 
> And I think "current_fmt" is better than 0 to set_fmt
> if user wants only geometry changes on s_crop.
> it mean keep format.
> 
> These patches works well on my local environment.
> ov772x and tw9910 work even if without -f option on capture_example.
> 
> If you can agree with this idea,
> I will send these as formal patch.

Thanks for the patches, please, give me a couple of days for review.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
