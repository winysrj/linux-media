Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.9]:54210 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966415Ab3HHUw6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 8 Aug 2013 16:52:58 -0400
Date: Thu, 8 Aug 2013 22:52:47 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Bryan Wu <cooloney@gmail.com>
cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Thierry Reding <thierry.reding@gmail.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	linux-tegra <linux-tegra@vger.kernel.org>,
	=?ISO-8859-1?Q?Terje_Bergstr=F6m?= <tbergstrom@nvidia.com>
Subject: Re: Can I put a V4L2 soc camera driver under other subsystem directory?
In-Reply-To: <CAK5ve-J7Sn5wuJ_z6Lqr=_qMQRqF12Aa6GfTv4xBhh=n_28Yjg@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1308082225150.29611@axis700.grange>
References: <CAK5ve-J7Sn5wuJ_z6Lqr=_qMQRqF12Aa6GfTv4xBhh=n_28Yjg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Bryan,

On Wed, 7 Aug 2013, Bryan Wu wrote:

> Hi Guennadi and LMML,
> 
> I'm working on a camera controller driver for Tegra, which is using
> soc_camera. But we also need to use Tegra specific host1x interface
> like syncpt APIs.
> 
> Since host1x is quite Tegra specific framework which is in
> drivers/gpu/host1x and has several host1x's client driver like graphic
> 2D driver, my v4l2 soc_camera driver is also a host1x client driver.
> Right now host1x does not expose any global include header files like
> API in the kernel, because no other users. So we plan to put all
> host1x related driver together, is that OK for us to put our Tegra
> soc_camera driver into drivers/gpu/host1x/camera or similar?
> 
> I guess besides it will introduce some extra maintenance it should be OK, right?

Exactly, there's already been a precedent:

http://www.mail-archive.com/linux-media@vger.kernel.org/msg56213.html

It hasn't been finalised yet though.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
