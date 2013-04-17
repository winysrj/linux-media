Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37957 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966592Ab3DQOyW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Apr 2013 10:54:22 -0400
Date: Wed, 17 Apr 2013 11:53:57 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Rob Herring <rob.herring@calxeda.com>,
	Grant Likely <grant.likely@secretlab.ca>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Arnd Bergmann <arnd@arndb.de>,
	devicetree-discuss@lists.ozlabs.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Compilation breakage on drivers/media due to OF patches - was: Re:
 [PATCH] DT: export of_get_next_parent() for use by modules: fix modular
 V4L2
Message-ID: <20130417115357.0b0f31ae@redhat.com>
In-Reply-To: <Pine.LNX.4.64.1304171555140.16330@axis700.grange>
References: <Pine.LNX.4.64.1304021825130.31999@axis700.grange>
	<201304021630.13371.arnd@arndb.de>
	<Pine.LNX.4.64.1304021840590.31999@axis700.grange>
	<Pine.LNX.4.64.1304171555140.16330@axis700.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Grant/Rob,

Our tree is currently _broken_ with OT, because of the lack of 
exporting of_get_next_parent. The developer that submitted the patches 
that added V4L2 OF support forgot to test to compilation with MODULES
support enabled.

So, we're now having:
	ERROR: "of_get_next_parent" [drivers/media/v4l2-core/videodev.ko] undefined!

if compiled with OF enabled and media as module.

As those patches were applied at my master branch and there are lots of
other patches on the top of the patches that added V4L2 OF support, 
I prefer to avoid reverting those patches. 

On the other hand, I can't send the patches upstream next week (assuming 
that -rc7 is the final one), without having this patch applying before 
the media tree.

So, please help me solving this issue as soon as possible.

Thank you!
Mauro

Em Wed, 17 Apr 2013 16:07:49 +0200 (CEST)
Guennadi Liakhovetski <g.liakhovetski@gmx.de> escreveu:

> Hi all
> 
> On Tue, 2 Apr 2013, Guennadi Liakhovetski wrote:
> 
> > On Tue, 2 Apr 2013, Arnd Bergmann wrote:
> > 
> > > On Tuesday 02 April 2013, Guennadi Liakhovetski wrote:
> > > > Currently modular V4L2 build with enabled OF is broken dur to the
> > > > of_get_next_parent() function being unavailable to modules. Export it to
> > > > fix the build.
> > > > 
> > > > Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
> > > > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > > 
> > > Looks good to me, but shouldn't this be EXPORT_SYMBOL_GPL?
> > 
> > "grep EXPORT_SYMBOL drivers/of/base.c" doesn't give a certain answer, but 
> > it seems to fit other of_get_* functions pretty well:
> 
> Ping, could this patch be pushed to -next asap, please? Without it the 
> current V4L2 -next doesn't compile. Also, I think, ro avoid breaking the 
> mainline, we should try to have this patch pulled in before the media 
> tree, could that be done?
> 
> Thanks
> Guennadi
> 
> >  EXPORT_SYMBOL(of_get_parent);
> > +EXPORT_SYMBOL(of_get_next_parent);
> >  EXPORT_SYMBOL(of_get_next_child);
> >  EXPORT_SYMBOL(of_get_next_available_child);
> >  EXPORT_SYMBOL(of_get_child_by_name);
> 
> ---
> Guennadi Liakhovetski, Ph.D.
> Freelance Open-Source Software Developer
> http://www.open-technology.de/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 

Cheers,
Mauro
