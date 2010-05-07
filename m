Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:49319 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752596Ab0EGM6Y (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 7 May 2010 08:58:24 -0400
Date: Fri, 7 May 2010 14:58:22 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
cc: LMML <linux-media@vger.kernel.org>, awalls@md.metrocast.net,
	moinejf@free.fr, pboettcher@dibcom.fr, awalls@radix.net,
	crope@iki.fi, davidtlwong@gmail.com, liplianin@tut.by,
	isely@isely.net, tobias.lorenz@gmx.net, hdegoede@redhat.com,
	abraham.manu@gmail.com, u.kleine-koenig@pengutronix.de,
	herton@mandriva.com.br, stoth@kernellabs.com, henrik@kurelid.se
Subject: Re: Status of the patches under review (85 patches) and some misc
 notes about the devel procedures
In-Reply-To: <20100507093916.2e2ef8e3@pedra>
Message-ID: <Pine.LNX.4.64.1005071453090.4777@axis700.grange>
References: <20100507093916.2e2ef8e3@pedra>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro

On Fri, 7 May 2010, Mauro Carvalho Chehab wrote:

> May, 6 2010: [1/3] mx2_camera: Add soc_camera support for i.MX25/i.MX27             http://patchwork.kernel.org/patch/97345
> May, 6 2010: [2/3] mx27: add support for the CSI device                             http://patchwork.kernel.org/patch/97352
> May, 6 2010: [3/3] mx25: add support for the CSI device                             http://patchwork.kernel.org/patch/97353

I'll be reviewing these

> 		== soc_camera patches - Waiting Guennadi <g.liakhovetski@gmx.de> submission/review == 
> 
> Feb, 2 2010: [2/3] soc-camera: mt9t112: modify delay time after initialize          http://patchwork.kernel.org/patch/76213
> Feb, 2 2010: [3/3] soc-camera: mt9t112: The flag which control camera-init is remov http://patchwork.kernel.org/patch/76214

These two are still on hold, I think, I'll have to ask the author if we 
can drop them.

> Mar, 5 2010: [v2] V4L/DVB: mx1-camera: compile fix                                  http://patchwork.kernel.org/patch/83742

An updated version of this one is already in your fixes tree:

http://git.linuxtv.org/fixes.git?a=commit;h=f6c22d4cff27a4bbb76d899b58b79dd311b7603f

> Apr,20 2010: pxa_camera: move fifo reset direct before dma start                    http://patchwork.kernel.org/patch/93619

Ditto for this one:

http://git.linuxtv.org/fixes.git?a=commit;h=80cef8eb49c9689664a31b8a21f83517042d9763

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
