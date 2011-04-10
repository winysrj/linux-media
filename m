Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.126.187]:50183 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753931Ab1DJWq5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Apr 2011 18:46:57 -0400
Date: Mon, 11 Apr 2011 00:46:02 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sergio Aguirre <saaguirre@ti.com>
Subject: Re: [PATCH 2.6.39] soc_camera: OMAP1: fix missing bytesperline and
 sizeimage initialization
In-Reply-To: <201104110000.56040.jkrzyszt@tis.icnet.pl>
Message-ID: <Pine.LNX.4.64.1104110035160.18671@axis700.grange>
References: <201104090158.04827.jkrzyszt@tis.icnet.pl>
 <Pine.LNX.4.64.1104101751380.12697@axis700.grange> <201104110000.56040.jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Mon, 11 Apr 2011, Janusz Krzysztofik wrote:

> Dnia niedziela 10 kwiecień 2011 o 18:00:14 Guennadi Liakhovetski 
> napisał(a):
> > Hi Janusz
> > 
> > On Sat, 9 Apr 2011, Janusz Krzysztofik wrote:
> > > Since commit 0e4c180d3e2cc11e248f29d4c604b6194739d05a, bytesperline
> > > and sizeimage memebers of v4l2_pix_format structure have no longer
> > > been calculated inside soc_camera_g_fmt_vid_cap(), but rather
> > > passed via soc_camera_device structure from a host driver callback
> > > invoked by soc_camera_set_fmt().
> > > 
> > > OMAP1 camera host driver has never been providing these parameters,
> > > so it no longer works correctly. Fix it by adding suitable
> > > assignments to omap1_cam_set_fmt().
> > 
> > Thanks for the patch, but now it looks like many soc-camera host
> > drivers are re-implementing this very same calculation in different
> > parts of their code - in try_fmt, set_fmt, get_fmt. Why don't we
> > unify them all, implement this centrally in soc_camera.c and remove
> > all those calculations? 
> 
> Wasn't it already unified before commit in question?

It was, but it was inconsistent. It was done centrally, and it was done in 
several other drivers additionally, creating a mess.

> > Could you cook up a patch or maybe several
> > patches - for soc_camera.c and all drivers?
> 
> Perhaps I could, as soon as I found some spare time, but first I'd have 
> to really understand why we need bytesperline or sizeimage handling 
> being changed from how they worked before commit 
> 0e4c180d3e2cc11e248f29d4c604b6194739d05a was introduced. I never had a 
> need to customize bytesperline or sizeimage calculations in my driver. 
> 
> But even then, I think these new patches would rather qualify for next 
> merge window, while the OMAP1 driver case is just a regression, caused 
> by an alredy applied, unrelated change to the underlying framework, and 
> requires a fix if that change is not going to be reverted.

Sure, we want this fixed for the current merge window. But I think it is 
possible with a relatively easy patch to soc_camera.c. I asked you, 
whether you'd be able to make a patch of that kind, if you don't have 
enough time ATM, I can try to make one and just ask you to test it on 
omap1. I'll have a look at it tomorrow.

> Maybe the author of the change, Sergio Aguirre form TI (CCing him), 
> could rework his patch in a way which wouldn't impose, as a side effect, 
> the new requirement of those structure members being passed from host 
> drivers?

I think we can just make an incremental patch to fill in those fields 
centrally, if the driver didn't do it for us.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
