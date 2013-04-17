Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:57180 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966437Ab3DQOIE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Apr 2013 10:08:04 -0400
Date: Wed, 17 Apr 2013 16:07:49 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Arnd Bergmann <arnd@arndb.de>
cc: devicetree-discuss@lists.ozlabs.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Rob Herring <rob.herring@calxeda.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] DT: export of_get_next_parent() for use by modules: fix
 modular V4L2
In-Reply-To: <Pine.LNX.4.64.1304021840590.31999@axis700.grange>
Message-ID: <Pine.LNX.4.64.1304171555140.16330@axis700.grange>
References: <Pine.LNX.4.64.1304021825130.31999@axis700.grange>
 <201304021630.13371.arnd@arndb.de> <Pine.LNX.4.64.1304021840590.31999@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all

On Tue, 2 Apr 2013, Guennadi Liakhovetski wrote:

> On Tue, 2 Apr 2013, Arnd Bergmann wrote:
> 
> > On Tuesday 02 April 2013, Guennadi Liakhovetski wrote:
> > > Currently modular V4L2 build with enabled OF is broken dur to the
> > > of_get_next_parent() function being unavailable to modules. Export it to
> > > fix the build.
> > > 
> > > Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
> > > Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > 
> > Looks good to me, but shouldn't this be EXPORT_SYMBOL_GPL?
> 
> "grep EXPORT_SYMBOL drivers/of/base.c" doesn't give a certain answer, but 
> it seems to fit other of_get_* functions pretty well:

Ping, could this patch be pushed to -next asap, please? Without it the 
current V4L2 -next doesn't compile. Also, I think, ro avoid breaking the 
mainline, we should try to have this patch pulled in before the media 
tree, could that be done?

Thanks
Guennadi

>  EXPORT_SYMBOL(of_get_parent);
> +EXPORT_SYMBOL(of_get_next_parent);
>  EXPORT_SYMBOL(of_get_next_child);
>  EXPORT_SYMBOL(of_get_next_available_child);
>  EXPORT_SYMBOL(of_get_child_by_name);

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
