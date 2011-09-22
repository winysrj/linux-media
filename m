Return-path: <linux-media-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:49720 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334Ab1IVIVT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 22 Sep 2011 04:21:19 -0400
Date: Thu, 22 Sep 2011 10:21:15 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
cc: LMML <linux-media@vger.kernel.org>,
	Morimoto Kuninori <morimoto.kuninori@renesas.com>,
	Manu Abraham <abraham.manu@gmail.com>,
	Jarod Wilson <jarod@redhat.com>,
	Jean-Francois Moine <moinejf@free.fr>,
	Andy Walls <awalls@md.metrocast.net>,
	Hans de Goede <hdegoede@redhat.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Dmitri Belimov <d.belimov@gmail.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Pawel Osiak <pawel@osciak.co>
Subject: Re: Patches at patchwork.linuxtv.org (127 patches)
In-Reply-To: <4E7A4CA4.8040205@redhat.com>
Message-ID: <Pine.LNX.4.64.1109220022240.24024@axis700.grange>
References: <4E7A4BA7.5050505@redhat.com> <4E7A4CA4.8040205@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 21 Sep 2011, Mauro Carvalho Chehab wrote:

> Em 21-09-2011 17:40, Mauro Carvalho Chehab escreveu:
> > As announced on Sept, 18, we moved our patch queue to patchwork.linuxtv.org.
> > 
> > As we were without access to the old patchwork instance, I simply sent all
> > emails I had locally stored on my local mahine to the new instance and reviewed
> > all patches again. Basically, for old patches, I basically did some scripting
> > that were marking old patches as "superseded", if they didn't apply anymore.
> > I also preserved the patches that were marked as "under review" from patchwork
> > time, using some scripting and a local control file.
> > 
> > So, we're basically close to what we had before kernel.org troubles (except for
> > a series of patches that I've already applied today).
> > 
> > My intention is to finish review all patches marked as "new" until the end of this
> > week, and set a new tree for linux-next with our stuff (as the old one were at
> > git.kernel.org).
> > 
> > Please let me know if something is missed or if some patch from the list bellow
> > is obsolete and can be marked with a different status.
> > 
> > Thanks!
> > Mauro
> > 
> > 
> > 		== New patches == 
> 
> Gah! forgot to update the URL on my script. the patch list with the right URL is:
> 
> 		== New patches == 



> Sep, 6 2011: [v2] at91: add code to initialize and manage the ISI_MCK for Atmel ISI http://patchwork.linuxtv.org/patch/7780   Josh Wu <josh.wu@atmel.com>

More work is needed on this one

> Sep, 6 2011: [1/2,v5] media: Add support for arbitrary resolution                   http://patchwork.linuxtv.org/patch/7782   Bastian Hecht <hechtb@googlemail.com>

I'll push the newest version of this one

> Sep,21 2011: [1/2] V4L: soc-camera: add a function to lookup xlate by mediabus code http://patchwork.linuxtv.org/patch/7909   Guennadi Liakhovetski <Guennadi Liakhovetski <g.liakhovetski@gmx.de>>
> Sep,21 2011: [2/2] V4L: sh_mobile_ceu_camera: simplify scaling and cropping algorit http://patchwork.linuxtv.org/patch/7910   Guennadi Liakhovetski <Guennadi Liakhovetski <g.liakhovetski@gmx.de>>

I think, these are for 3.3, unless 3.2 is sufficiently delayed

> 		== Patches waiting for Guennadi Liakhovetski <g.liakhovetski@gmx.de> review == 
> 
> Jul,10 2011: [1/3] Add 8-bit and 16-bit YCrCb media bus pixel codes                 http://patchwork.linuxtv.org/patch/7423   Christian Gmeiner <christian.gmeiner@gmail.com>

I didn't recognise this one as needing my review, but I agree with Laurent 
in his reply to patch 2/3, that these new formats are not needed.

> Jul,12 2011: [1/5] mt9m111: set inital return values to zero                        http://patchwork.linuxtv.org/patch/7433   Michael Grzeschik <m.grzeschik@pengutronix.de>

Is dropped as per my comment

> Jul,12 2011: [3/5] mt9m111: move lastpage to struct mt9m111 for multi instances     http://patchwork.linuxtv.org/patch/7435   Michael Grzeschik <m.grzeschik@pengutronix.de>

Will be in my pull request

> Jul,12 2011: [5/5] mt9m111: make use of testpattern                                 http://patchwork.linuxtv.org/patch/7434   Michael Grzeschik <m.grzeschik@pengutronix.de>

is rejested in its present form

> Jun,24 2011: media: initial driver for ov5642 CMOS sensor                           http://patchwork.linuxtv.org/patch/7327   Bastian Hecht <hechtb@googlemail.com>

is in the mainline as of 3.1-rc1

> Jul, 6 2011: [REVIEW] adv7175 mbus support                                          http://patchwork.linuxtv.org/patch/7410   Christian Gmeiner <christian.gmeiner@gmail.com>

that wasn't even marked as "[PATCH]," was more of an RFC

> Jul,10 2011: [1/9] stringify: add HEX_STRING()                                      http://patchwork.linuxtv.org/patch/160    Randy Dunlap <rdunlap@xenotime.net>

wow, that's a weird one;-) no idea how it ended up on your list at all

> Jul,12 2011: [2/5] mt9m111: fix missing return value check mt9m111_reg_clear        http://patchwork.linuxtv.org/patch/7432   Michael Grzeschik <m.grzeschik@pengutronix.de>

in 3.1-rc1

> Jul,12 2011: [v4,4/5] mt9m111: rewrite set_pixfmt                                   http://patchwork.linuxtv.org/patch/7436   Michael Grzeschik <m.grzeschik@pengutronix.de>

ditto

> Aug,24 2011: media i.MX27 camera: remove legacy dma support                         http://patchwork.linuxtv.org/patch/298    Sascha Hauer <s.hauer@pengutronix.de>

Expecting v2.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
