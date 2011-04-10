Return-path: <mchehab@pedra>
Received: from d1.icnet.pl ([212.160.220.21]:46701 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752754Ab1DJWBt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 10 Apr 2011 18:01:49 -0400
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 2.6.39] soc_camera: OMAP1: fix missing bytesperline and sizeimage initialization
Date: Mon, 11 Apr 2011 00:00:49 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sergio Aguirre <saaguirre@ti.com>
References: <201104090158.04827.jkrzyszt@tis.icnet.pl> <Pine.LNX.4.64.1104101751380.12697@axis700.grange>
In-Reply-To: <Pine.LNX.4.64.1104101751380.12697@axis700.grange>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201104110000.56040.jkrzyszt@tis.icnet.pl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Dnia niedziela 10 kwiecień 2011 o 18:00:14 Guennadi Liakhovetski 
napisał(a):
> Hi Janusz
> 
> On Sat, 9 Apr 2011, Janusz Krzysztofik wrote:
> > Since commit 0e4c180d3e2cc11e248f29d4c604b6194739d05a, bytesperline
> > and sizeimage memebers of v4l2_pix_format structure have no longer
> > been calculated inside soc_camera_g_fmt_vid_cap(), but rather
> > passed via soc_camera_device structure from a host driver callback
> > invoked by soc_camera_set_fmt().
> > 
> > OMAP1 camera host driver has never been providing these parameters,
> > so it no longer works correctly. Fix it by adding suitable
> > assignments to omap1_cam_set_fmt().
> 
> Thanks for the patch, but now it looks like many soc-camera host
> drivers are re-implementing this very same calculation in different
> parts of their code - in try_fmt, set_fmt, get_fmt. Why don't we
> unify them all, implement this centrally in soc_camera.c and remove
> all those calculations? 

Wasn't it already unified before commit in question?

> Could you cook up a patch or maybe several
> patches - for soc_camera.c and all drivers?

Perhaps I could, as soon as I found some spare time, but first I'd have 
to really understand why we need bytesperline or sizeimage handling 
being changed from how they worked before commit 
0e4c180d3e2cc11e248f29d4c604b6194739d05a was introduced. I never had a 
need to customize bytesperline or sizeimage calculations in my driver. 

But even then, I think these new patches would rather qualify for next 
merge window, while the OMAP1 driver case is just a regression, caused 
by an alredy applied, unrelated change to the underlying framework, and 
requires a fix if that change is not going to be reverted.

Maybe the author of the change, Sergio Aguirre form TI (CCing him), 
could rework his patch in a way which wouldn't impose, as a side effect, 
the new requirement of those structure members being passed from host 
drivers?

Thanks,
Janusz
