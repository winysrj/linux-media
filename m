Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:55530 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755399Ab0BXHWN (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Feb 2010 02:22:13 -0500
Date: Wed, 24 Feb 2010 08:22:12 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
cc: LMML <linux-media@vger.kernel.org>, helmut@helmutauer.de,
	moinejf@free.fr, m-karicheri2@ti.com, pboettcher@dibcom.fr,
	tobias.lorenz@gmx.net, awalls@radix.net, khali@linux-fr.org,
	hdegoede@redhat.com, abraham.manu@gmail.com, davidtlwong@gmail.com,
	stoth@kernellabs.com
Subject: Re: Status of the patches under review (29 patches)
In-Reply-To: <4B84BBB0.1020408@redhat.com>
Message-ID: <Pine.LNX.4.64.1002240807100.4741@axis700.grange>
References: <4B84BBB0.1020408@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro

On Wed, 24 Feb 2010, Mauro Carvalho Chehab wrote:

> Hi,
> 
> I suspect that Linus should be releasing the 2.6.33 kernel any time soon,
> so the next merge window is about to open. I've handled already everything
> on my pending queues. However, I missed some emails due to a crash on my 
> exim filter. Also, patchwork.kernel.org missed some emails due to some
> trouble there. So, maybe there are still some unnoticed pending stuff.

Looks like you missed about two of my pull requests.

> If you still have any pending work for 2.6.34 that aren't merged nor
> are under review, please submit it ASAP, as patches received after the 
> release of 2.6.33 will likely be postponed to 2.6.35.

Namely:

> 		== soc_camera patches - Waiting Guennadi <g.liakhovetski@gmx.de> submission/review == 
> 
> Feb, 9 2010: mt9t031: use runtime pm support to restore ADDRESS_MODE registers      http://patchwork.kernel.org/patch/77997

This one depends on my runtime-pm patch (which is not listed here btw), 
which we didn't come to a consensus about, so, I think, I'll just push 
both of them and let you decide whether or not to pull.

> Feb,19 2010: v4l: soc_camera: fix bound checking of mbus_fmt[] index                http://patchwork.kernel.org/patch/80757

This one 
(http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/16068/match=pull+soc+camera) 
and

> Feb, 2 2010: [1/3] soc-camera: mt9t112: modify exiting conditions from standby mode http://patchwork.kernel.org/patch/76212

this one are in fixes branch of 
http://git.linuxtv.org/gliakhovetski/soc-camera.git?a=shortlog;h=refs/heads/fixes 
which I asked you to pull in 
http://www.spinics.net/lists/linux-media/msg16281.html

> Feb, 2 2010: [2/3] soc-camera: mt9t112: modify delay time after initialize          http://patchwork.kernel.org/patch/76213
> Feb, 2 2010: [3/3] soc-camera: mt9t112: The flag which control camera-init is       http://patchwork.kernel.org/patch/76214

These two have been put on hold by Morimoto-san.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
