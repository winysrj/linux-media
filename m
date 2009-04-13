Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:43226 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750750AbZDMTjr (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 13 Apr 2009 15:39:47 -0400
Date: Mon, 13 Apr 2009 21:39:42 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Agustin <gatoguan-os@yahoo.com>
cc: linux-arm-kernel@lists.arm.linux.org.uk,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: Testing latest mx3_camera.c
In-Reply-To: <486508.99603.qm@web32101.mail.mud.yahoo.com>
Message-ID: <Pine.LNX.4.64.0904132136030.1587@axis700.grange>
References: <486508.99603.qm@web32101.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 13 Apr 2009, Agustin wrote:

> Which patchset should one use today to have latest and most stable 
> "mx3_camera" driver in 2.6.29?
> 
> Until now, I have been using mx3_camera (/soc_camera) to interface a 
> custom 7.5MPix 12bpp camera on a PCM037 based system running linux 
> 2.6.28-next plus your November 2009 soc_camera patchset. I have also 
> added support for 16 bit data in IDMAC driver though I have tested just 
> 12.
> 
> I currently use OSELAS i.MX31 BSP Release 10, that is 2.6.29 plus a 
> patch stack prepared by Sascha Hauer / Pengutronix. On top of that I am 
> applying the "v4l-20090408" series from 
> http://gross-embedded.homelinux.org/~lyakh/v4l-20090408/, with little 
> merging effort.

Please, use http://marc.info/?l=linux-arm-kernel&m=123866462620240&w=2 
also notice, which patches it needs. As a basis you can take linux-next or 
a suitable branch from git://git.pengutronix.de/git/imx/linux-2.6.git

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
