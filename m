Return-path: <mchehab@gaivota>
Received: from moutng.kundenserver.de ([212.227.126.171]:52732 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753459Ab0LaNh4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Dec 2010 08:37:56 -0500
Date: Fri, 31 Dec 2010 14:37:47 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
cc: LMML <linux-media@vger.kernel.org>, adams.xu@azwave.com.cn,
	Manu Abraham <abraham.manu@gmail.com>,
	Patrick Boettcher <pboettcher@kernellabs.com>,
	Hendrik Skarpeid <skarp@online.no>, stoth@kernellabs.com
Subject: Re: Summary of the pending patches up to Dec, 31 (26 patches)
In-Reply-To: <4D1DCF6A.2090505@redhat.com>
Message-ID: <Pine.LNX.4.64.1012311416210.6275@axis700.grange>
References: <4D1DCF6A.2090505@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On Fri, 31 Dec 2010, Mauro Carvalho Chehab wrote:

> 		== Soc_camera waiting for Guennadi Liakhovetski <g.liakhovetski@gmx.de> review == 
> 
> Aug, 3 2010: [04/11] mt9m111: added new bit offset defines                          http://patchwork.kernel.org/patch/116721  Michael Grzeschik <m.grzeschik@pengutronix.de>

Merged into "Oct,25 2010: [v3] mt9m111: rewrite set_pixfmt" below

> Aug, 3 2010: [08/11] mt9m111: added reg_mask function                               http://patchwork.kernel.org/patch/116722  Michael Grzeschik <m.grzeschik@pengutronix.de>

ditto

> Aug, 3 2010: [v2,11/11] mt9m111: make use of testpattern                            http://patchwork.kernel.org/patch/116730  Michael Grzeschik <m.grzeschik@pengutronix.de>

A .vidioc_s_input() implementation has been proposed, no reply followed

> Oct,25 2010: [v3] mt9m111: rewrite set_pixfmt                                       http://patchwork.kernel.org/patch/266822  Michael Grzeschik <m.grzeschik@pengutronix.de>

See my reply to this patch. It has been rejected in that form and there 
has been no update.

> Nov,17 2010: v4l: list entries no need to check                                     http://patchwork.kernel.org/patch/332611  Figo.zhang <figo1802@gmail.com>

It's the first time I see this one.

> Dec, 2 2010: [v3] soc_camera: Add the ability to bind regulators to soc_camedra dev http://patchwork.kernel.org/patch/373691  Alberto Panizzo <maramaopercheseimorto@gmail.com>

In yesterday's pull request

> Dec, 2 2010: [v2] V4L2: Add a v4l2-subdev (soc-camera) driver for OmniVision OV2640 http://patchwork.kernel.org/patch/374771  Alberto Panizzo <maramaopercheseimorto@gmail.com>

ditto

> Dec, 5 2010: [1/2] OMAP1: allow reserving memory for camera                         http://patchwork.kernel.org/patch/381601  Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
> Dec, 5 2010: [2/2] OMAP1: Amstrad Delta: reserve memory for camera                  http://patchwork.kernel.org/patch/381621  Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>

These two could only go via the ARM tree, if at all.

> Guennadi,
> 	Probably, several of those patches are obsolete and you already pointed it to me.
> 	but I probably missed your comments, due to my email issues.

Wishing you reliable communication in the new year;)

Thanks
Guennadi

> 
> 		== waiting for Hendrik Skarpeid <skarp@online.no> tests == 
> 
> Oct,23 2010: DM1105: could not attach frontend 195d:1105                            http://patchwork.kernel.org/patch/279091  Igor M. Liplianin <liplianin@me.by>
> 
> 		== Waiting for Patrick Boettcher <pboettcher@dibcom.fr> review == 
> 
> May,25 2010: Adding support to the Geniatech/MyGica SBTVD Stick S870 remote control http://patchwork.kernel.org/patch/102314  Hernán Ordiales <h.ordiales@gmail.com>
> Jul,14 2010: [1/4] drivers/media/dvb: Remove dead Configs                           http://patchwork.kernel.org/patch/111972  Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
> Jul,14 2010: [2/4] drivers/media/dvb: Remove undead configs                         http://patchwork.kernel.org/patch/111973  Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
> 
> 		== waiting for videobuf2 == 
> 
> Mar,17 2010: [2/2] V4L/DVB: buf-dma-sg.c: support non-pageable user-allocated memor http://patchwork.kernel.org/patch/97263   Arnout Vandecappelle <arnout@mind.be>
> Jul,27 2010: videobuf_dma_sg: a new implementation for mmap                         http://patchwork.kernel.org/patch/114520  Figo.zhang <figo1802@gmail.com>
> Jul,28 2010: [v2] videobuf_dma_sg: a new implementation for mmap                    http://patchwork.kernel.org/patch/114760  Figo.zhang <figo1802@gmail.com>
> Jul,30 2010: [v2] Resend:videobuf_dma_sg: a new implementation for mmap             http://patchwork.kernel.org/patch/115348  Figo.zhang <figo1802@gmail.com>
> 
> The above patches will likely be obsolete after videobuf2 merge. We need to double-check
> if the needed functionality is provided on videobuf2.
> 
> 		== Waiting for Mauro Carvalho Chehab <mchehab@redhat.com> fixes on Docbook == 
> 
> Oct,23 2010: [RFC, PATCHv3] DocBook: Add rules to auto-generate some media docbooks http://patchwork.kernel.org/patch/279201  Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> 		== Waiting for a Kworld UB430-AF to test and report back to Mauro Carvalho Chehab <mchehab@redhat.com> == 
> 
> Nov, 8 2010: [RFC] cx231xx: Add support for Kworld UB430 AF                         http://patchwork.kernel.org/patch/308712  Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> 
> Number of pending patches per reviewer:
>   Guennadi Liakhovetski <g.liakhovetski@gmx.de>                         : 9
>   LinuxTV community                                                     : 5
>   Manu Abraham <abraham.manu@gmail.com>                                 : 4
>   Patrick Boettcher <pboettcher@kernellabs.com>                         : 3
>   Mauro Carvalho Chehab <mchehab@redhat.com>                            : 2
>   Adams Xu <adams.xu@azwave.com.cn>                                     : 1
>   Hendrik Skarpeid <skarp@online.no>                                    : 1
>   Steven Toth <stoth@kernellabs.com>                                    : 1
> 
> Cheers,
> Mauro
> 
> ---
> 
> If you discover any patch submitted via email that weren't caught by
> kernel.patchwork.org, this means that the patch got mangled by your emailer.
> The more likely cause is that the emailer converted tabs into spaces or broke
> long lines.
> 
> If you're using Thunderbird, the solution is to install Asalted Patches
> extension, available at:
> 	https://hg.mozilla.org/users/clarkbw_gnome.org/asalted-patches/
> Other emailers will need you to disable the wrapping long lines feature.
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
