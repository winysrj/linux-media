Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:50431 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755680Ab2JEOlZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Oct 2012 10:41:25 -0400
Date: Fri, 5 Oct 2012 16:41:14 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
cc: linux-media@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 00/14] V4L2 DT support
In-Reply-To: <506ED344.2020407@gmail.com>
Message-ID: <Pine.LNX.4.64.1210051639160.13761@axis700.grange>
References: <1348754853-28619-1-git-send-email-g.liakhovetski@gmx.de>
 <506ED344.2020407@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sylwester

On Fri, 5 Oct 2012, Sylwester Nawrocki wrote:

> Hi Guennadi,
> 
> Any chance for a GIT tree including this patch series ? I'd like
> to see all these pieces put together and I don't seem to find any
> base tree that this series would have applied cleanly to.

Ok, I pushed the patches to

git://linuxtv.org/gliakhovetski/v4l-dvb.git dt-soc_camera

Please, give it a go.

Thanks
Guennadi

> 
> ...(20121005_media_for_v3.7-dt)$ git am -3 \[PATCH\ *
> Applying: i2c: add dummy inline functions for when CONFIG_OF_I2C(_MODULE) isn't defined
> Applying: of: add a dummy inline function for when CONFIG_OF is not defined
> Applying: OF: make a function pointer argument const
> Applying: media: add V4L2 DT binding documentation
> Applying: media: add a V4L2 OF parser
> Applying: media: soc-camera: prepare for asynchronous client probing
> Applying: media: soc-camera: support deferred probing of clients
> fatal: sha1 information is lacking or useless (drivers/media/platform/soc_camera/soc_camera.c).
> Repository lacks necessary blobs to fall back on 3-way merge.
> Cannot fall back to three-way merge.
> Patch failed at 0007 media: soc-camera: support deferred probing of clients
> When you have resolved this problem run "git am --resolved".
> If you would prefer to skip this patch, instead run "git am --skip".
> To restore the original branch and stop patching run "git am --abort".
> 
> --
> 
> Thanks,
> Sylwester
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
