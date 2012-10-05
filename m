Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:55291 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932431Ab2JEMcJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 5 Oct 2012 08:32:09 -0400
Message-ID: <506ED344.2020407@gmail.com>
Date: Fri, 05 Oct 2012 14:32:04 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: linux-media@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 00/14] V4L2 DT support
References: <1348754853-28619-1-git-send-email-g.liakhovetski@gmx.de>
In-Reply-To: <1348754853-28619-1-git-send-email-g.liakhovetski@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guennadi,

Any chance for a GIT tree including this patch series ? I'd like
to see all these pieces put together and I don't seem to find any
base tree that this series would have applied cleanly to.

...(20121005_media_for_v3.7-dt)$ git am -3 \[PATCH\ *
Applying: i2c: add dummy inline functions for when CONFIG_OF_I2C(_MODULE) isn't defined
Applying: of: add a dummy inline function for when CONFIG_OF is not defined
Applying: OF: make a function pointer argument const
Applying: media: add V4L2 DT binding documentation
Applying: media: add a V4L2 OF parser
Applying: media: soc-camera: prepare for asynchronous client probing
Applying: media: soc-camera: support deferred probing of clients
fatal: sha1 information is lacking or useless (drivers/media/platform/soc_camera/soc_camera.c).
Repository lacks necessary blobs to fall back on 3-way merge.
Cannot fall back to three-way merge.
Patch failed at 0007 media: soc-camera: support deferred probing of clients
When you have resolved this problem run "git am --resolved".
If you would prefer to skip this patch, instead run "git am --skip".
To restore the original branch and stop patching run "git am --abort".

--

Thanks,
Sylwester
