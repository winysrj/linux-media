Return-path: <mchehab@pedra>
Received: from moutng.kundenserver.de ([212.227.17.10]:64547 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753017Ab1DBW7z (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 2 Apr 2011 18:59:55 -0400
Date: Sun, 3 Apr 2011 00:59:48 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PULL] soc-camera: one more patch
In-Reply-To: <4D97A8F6.1060001@infradead.org>
Message-ID: <Pine.LNX.4.64.1104030058320.22822@axis700.grange>
References: <Pine.LNX.4.64.1103232149360.6836@axis700.grange>
 <4D97A8F6.1060001@infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro

On Sat, 2 Apr 2011, Mauro Carvalho Chehab wrote:

> Em 23-03-2011 17:51, Guennadi Liakhovetski escreveu:
> > Hi Mauro
> > 
> > Sorry, would be nice if we could manage to push one more patch for 2.6.39:
> > 
> > The following changes since commit f772f016e15a0b93b5aa9680203107ab8cb9bdc6:
> > 
> >   [media] media-devnode: don't depend on BKL stuff (2011-03-22 19:43:01 -0300)
> > 
> > are available in the git repository at:
> >   git://linuxtv.org/gliakhovetski/v4l-dvb.git for-2.6.39
> > 
> > Guennadi Liakhovetski (1):
> >       V4L: soc_camera_platform: add helper functions to manage device instances
> > 
> >  include/media/soc_camera_platform.h |   50 +++++++++++++++++++++++++++++++++++
> >  1 files changed, 50 insertions(+), 0 deletions(-)
> 
> Guennadi,
> 
> While it would be probably ok to send this patch after the end of the merge window,
> there's no sense on doing it, as no other driver is using the new stuff. So, I just
> added it at stating/for_2.6.40.

These helper functions are for use not by drivers, but by platforms, and I 
was planning to push 2 users after this patch gets merged. But yes, I 
think, it's not that critical...

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
