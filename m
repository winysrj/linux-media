Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.22]:38926 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751144Ab0JQWDe (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Oct 2010 18:03:34 -0400
Date: Mon, 18 Oct 2010 00:03:30 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
cc: LMML <linux-media@vger.kernel.org>,
	"Igor M. Liplianin" <liplianin@me.by>,
	Manu Abraham <abraham.manu@gmail.com>,
	Jean-Francois Moine <moinejf@free.fr>,
	Jarod Wilson <jarod@redhat.com>,
	Richard Zidlicky <rz@linux-m68k.org>,
	Antti Palosaari <crope@iki.fi>,
	Sven Barth <pascaldragon@googlemail.com>,
	Patrick Boettcher <pboettcher@kernellabs.com>,
	Henrik Kurelid <henke@kurelid.se>,
	Hans de Goede <hdegoede@redhat.com>
Subject: Re: Old patches sent via the Mailing list
In-Reply-To: <4CBB689F.1070100@redhat.com>
Message-ID: <Pine.LNX.4.64.1010172348520.2757@axis700.grange>
References: <4CBB689F.1070100@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi Mauro

On Sun, 17 Oct 2010, Mauro Carvalho Chehab wrote:

> 		== Soc_camera waiting for Guennadi Liakhovetski <g.liakhovetski@gmx.de> review == 
> 
> (Guennadi gave me an update about those patches last time. I'm not sure about the updated status)
> 
> Jul, 5 2010: soc-camera: module_put() fix                                           http://patchwork.kernel.org/patch/110202  Magnus Damm <damm@opensource.se>

Please, mark as dropped

> Jul,27 2010: [1/4] mx2_camera: fix a race causing NULL dereference                  http://patchwork.kernel.org/patch/114515  Baruch Siach <baruch@tkos.co.il>

is upstream 
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=5384a12b23160e11ff949a94172051476d308b66

> Jul,27 2010: [2/4] mx2_camera: return IRQ_NONE when doing nothing                   http://patchwork.kernel.org/patch/114517  Baruch Siach <baruch@tkos.co.il>

mark as dropped

> Jul,27 2010: [4/4] mx2_camera: implement forced termination of active buffer for mx http://patchwork.kernel.org/patch/114518  Baruch Siach <baruch@tkos.co.il>

is in next 
http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=commit;h=9cf6ddf5eeedaffd989f9b93df1b7ea8d459786b

> Aug, 3 2010: [2/5] mx2_camera: remove emma limitation for RGB565                    http://patchwork.kernel.org/patch/116703  Michael Grzeschik <m.grzeschik@pengutronix.de>

is in next 
http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=commit;h=2b262a18b79768a2b7a62ba187f8830802790b9a

> Aug, 3 2010: [3/5] mx2_camera: fix for list bufnum in frame_done_emma               http://patchwork.kernel.org/patch/116705  Michael Grzeschik <m.grzeschik@pengutronix.de>

is upstream 
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=cd9ebdbc0541b4e8ee145c81642d68332f79b932

> Aug, 3 2010: [4/5] mx2_camera: add rising edge for pixclock                         http://patchwork.kernel.org/patch/116704  Michael Grzeschik <m.grzeschik@pengutronix.de>

upstream 
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=d86097e19cef2f13a29fc37db0dad17b99b6d5f8

> Aug, 3 2010: [5/5] mx2_camera: add informative camera clock frequency printout      http://patchwork.kernel.org/patch/116707  Michael Grzeschik <m.grzeschik@pengutronix.de>

in next 
http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=commit;h=e7d317b5b210a2f9486faa335e4eff81e5f6210d

> Aug, 3 2010: [04/11] mt9m111: added new bit offset defines                          http://patchwork.kernel.org/patch/116721  Michael Grzeschik <m.grzeschik@pengutronix.de>

waiting an update (possible merge with 08/11 and 10/11 below)

> Aug, 3 2010: [06/11] mt9m111: cropcap and s_crop check if type is VIDEO_CAPTURE     http://patchwork.kernel.org/patch/116726  Michael Grzeschik <m.grzeschik@pengutronix.de>

upstream 
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=6b6d33c746ace7bd0dbbdde674d3fb1100ab081d

> Aug, 3 2010: [07/11] mt9m111: added current colorspace at g_fmt                     http://patchwork.kernel.org/patch/116724  Michael Grzeschik <m.grzeschik@pengutronix.de>

upstream 
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=01f5a394eac48b74c84434e95e74cd172b0682c3

> Aug, 3 2010: [08/11] mt9m111: added reg_mask function                               http://patchwork.kernel.org/patch/116722  Michael Grzeschik <m.grzeschik@pengutronix.de>

waiting for update (see 04/11 above)

> Aug, 3 2010: [v2,10/11] mt9m111: rewrite set_pixfmt                                 http://patchwork.kernel.org/patch/116728  Michael Grzeschik <m.grzeschik@pengutronix.de>

waiting for update (see 04/11 above)

> Aug, 3 2010: [v2,11/11] mt9m111: make use of testpattern                            http://patchwork.kernel.org/patch/116730  Michael Grzeschik <m.grzeschik@pengutronix.de>

waiting for a new version, using additional inputs to provide test 
patterns.

Somehow, looks like patches, that I push to you, don't (automatically) get 
updated in patchwork, is there anything, that I'm doing wrongly, why this 
is happening?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
