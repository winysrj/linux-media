Return-path: <mchehab@gaivota>
Received: from mx1.redhat.com ([209.132.183.28]:56378 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753014Ab0LaMlg (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 31 Dec 2010 07:41:36 -0500
Message-ID: <4D1DCF6A.2090505@redhat.com>
Date: Fri, 31 Dec 2010 10:41:14 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
CC: adams.xu@azwave.com.cn, Manu Abraham <abraham.manu@gmail.com>,
	Patrick Boettcher <pboettcher@kernellabs.com>,
	Hendrik Skarpeid <skarp@online.no>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	stoth@kernellabs.com, Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Summary of the pending patches up to Dec, 31 (26 patches)
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

Dear Developers,

I'm enclosing the current list of patches that I have on my queue. I did 
an effort to apply a large amount of patches during the past two weeks, in
order to be ready for the 2.6.38 merge window, expected to be after
the end year's holiday.

I lost about one month of emails from the period between Nov-Dec, so
I may have lost a pull request, or some patch comments. I had to fully
rely on patchwork for the patches sent during that period.

Kernel 2.6.38 will be a nice Kernel for us, as it will contain some
very interesting things:
	- The removal of BKL (in fact, .37 will have that also, but
we have some BKL cleanups already for .38, and I suspect that we'll
have some bug fixes for the changes during the .38 rc period);
	- The removal of V4L1 API. We're trying to remove it for a
very long time. V4L2 API is here since 2002. That means that we took
8 years to remove the legacy API.
	- The merge between lirc_i2c and ir-kbd-i2c. The LIRC i2c driver
is also very old, and there were several IR key parsers implemented
on both. The missing things were migrated into ir-kbd-i2c and some
board-specific get key parsers into their respective boards.

Due to that, we have enough reasons to celebrate the end of this year
and the arrival of the next year.

Cheers!

I wish you all the best for the coming year!

P.S.:

1) I explicitly c/c the developers or the ones waiting for an analysis.
   If you're a developer and were c/c, please comment on the listed
   patches.
2) I removed the Videobuf2 patches from the list. I expect to be
   analyzing and testing them during the next week.

		== Need more tests/acks from DVB users == 

Aug, 7 2010: Avoid unnecessary data copying inside dvb_dmx_swfilter_204() function  http://patchwork.kernel.org/patch/118147  Marko Ristola <marko.ristola@kolumbus.fi>

************************************************************************
* I want to see people testing the above patch, as it seems to improve *
* DVB performance by avoiding data copy.                               *
************************************************************************

		== mantis patches - Waiting for Manu Abraham <abraham.manu@gmail.com> == 

Jun,20 2010: [2/2] DVB/V4L: mantis: remove unused files                             http://patchwork.kernel.org/patch/107062  BjÃ¸rn Mork <bjorn@mork.no>
Jul,19 2010: Twinhan DTV Ter-CI (3030 mantis)                                       http://patchwork.kernel.org/patch/112708  Niklas Claesson <nicke.claesson@gmail.com>
Aug, 7 2010: Refactor Mantis DMA transfer to deliver 16Kb TS data per interrupt     http://patchwork.kernel.org/patch/118173  Marko Ristola <marko.ristola@kolumbus.fi>
Oct,10 2010: [v2] V4L/DVB: faster DVB-S lock for mantis cards using stb0899 demod   http://patchwork.kernel.org/patch/244201  Tuxoholic <tuxoholic@hotmail.de>

		== for Adams.Xu <adams.xu@azwave.com.cn> and Manu Abraham <abraham.manu@gmail.com> review == 

Jun,11 2010: stb0899: Removed an extra byte sent at init on DiSEqC bus              http://patchwork.kernel.org/patch/105621  Florent AUDEBERT <florent.audebert@anevia.com>

		== Waiting for Steven Toth <stoth@kernellabs.com> review == 

Nov,24 2010: [media] saa7164: poll mask set incorrectly                             http://patchwork.kernel.org/patch/351711  Dan Carpenter <error27@gmail.com>

		== Soc_camera waiting for Guennadi Liakhovetski <g.liakhovetski@gmx.de> review == 

Aug, 3 2010: [04/11] mt9m111: added new bit offset defines                          http://patchwork.kernel.org/patch/116721  Michael Grzeschik <m.grzeschik@pengutronix.de>
Aug, 3 2010: [08/11] mt9m111: added reg_mask function                               http://patchwork.kernel.org/patch/116722  Michael Grzeschik <m.grzeschik@pengutronix.de>
Aug, 3 2010: [v2,11/11] mt9m111: make use of testpattern                            http://patchwork.kernel.org/patch/116730  Michael Grzeschik <m.grzeschik@pengutronix.de>
Oct,25 2010: [v3] mt9m111: rewrite set_pixfmt                                       http://patchwork.kernel.org/patch/266822  Michael Grzeschik <m.grzeschik@pengutronix.de>
Nov,17 2010: v4l: list entries no need to check                                     http://patchwork.kernel.org/patch/332611  Figo.zhang <figo1802@gmail.com>
Dec, 2 2010: [v3] soc_camera: Add the ability to bind regulators to soc_camedra dev http://patchwork.kernel.org/patch/373691  Alberto Panizzo <maramaopercheseimorto@gmail.com>
Dec, 2 2010: [v2] V4L2: Add a v4l2-subdev (soc-camera) driver for OmniVision OV2640 http://patchwork.kernel.org/patch/374771  Alberto Panizzo <maramaopercheseimorto@gmail.com>
Dec, 5 2010: [1/2] OMAP1: allow reserving memory for camera                         http://patchwork.kernel.org/patch/381601  Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Dec, 5 2010: [2/2] OMAP1: Amstrad Delta: reserve memory for camera                  http://patchwork.kernel.org/patch/381621  Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>

Guennadi,
	Probably, several of those patches are obsolete and you already pointed it to me.
	but I probably missed your comments, due to my email issues.

		== waiting for Hendrik Skarpeid <skarp@online.no> tests == 

Oct,23 2010: DM1105: could not attach frontend 195d:1105                            http://patchwork.kernel.org/patch/279091  Igor M. Liplianin <liplianin@me.by>

		== Waiting for Patrick Boettcher <pboettcher@dibcom.fr> review == 

May,25 2010: Adding support to the Geniatech/MyGica SBTVD Stick S870 remote control http://patchwork.kernel.org/patch/102314  Hernán Ordiales <h.ordiales@gmail.com>
Jul,14 2010: [1/4] drivers/media/dvb: Remove dead Configs                           http://patchwork.kernel.org/patch/111972  Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
Jul,14 2010: [2/4] drivers/media/dvb: Remove undead configs                         http://patchwork.kernel.org/patch/111973  Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>

		== waiting for videobuf2 == 

Mar,17 2010: [2/2] V4L/DVB: buf-dma-sg.c: support non-pageable user-allocated memor http://patchwork.kernel.org/patch/97263   Arnout Vandecappelle <arnout@mind.be>
Jul,27 2010: videobuf_dma_sg: a new implementation for mmap                         http://patchwork.kernel.org/patch/114520  Figo.zhang <figo1802@gmail.com>
Jul,28 2010: [v2] videobuf_dma_sg: a new implementation for mmap                    http://patchwork.kernel.org/patch/114760  Figo.zhang <figo1802@gmail.com>
Jul,30 2010: [v2] Resend:videobuf_dma_sg: a new implementation for mmap             http://patchwork.kernel.org/patch/115348  Figo.zhang <figo1802@gmail.com>

The above patches will likely be obsolete after videobuf2 merge. We need to double-check
if the needed functionality is provided on videobuf2.

		== Waiting for Mauro Carvalho Chehab <mchehab@redhat.com> fixes on Docbook == 

Oct,23 2010: [RFC, PATCHv3] DocBook: Add rules to auto-generate some media docbooks http://patchwork.kernel.org/patch/279201  Mauro Carvalho Chehab <mchehab@redhat.com>

		== Waiting for a Kworld UB430-AF to test and report back to Mauro Carvalho Chehab <mchehab@redhat.com> == 

Nov, 8 2010: [RFC] cx231xx: Add support for Kworld UB430 AF                         http://patchwork.kernel.org/patch/308712  Mauro Carvalho Chehab <mchehab@redhat.com>


Number of pending patches per reviewer:
  Guennadi Liakhovetski <g.liakhovetski@gmx.de>                         : 9
  LinuxTV community                                                     : 5
  Manu Abraham <abraham.manu@gmail.com>                                 : 4
  Patrick Boettcher <pboettcher@kernellabs.com>                         : 3
  Mauro Carvalho Chehab <mchehab@redhat.com>                            : 2
  Adams Xu <adams.xu@azwave.com.cn>                                     : 1
  Hendrik Skarpeid <skarp@online.no>                                    : 1
  Steven Toth <stoth@kernellabs.com>                                    : 1

Cheers,
Mauro

---

If you discover any patch submitted via email that weren't caught by
kernel.patchwork.org, this means that the patch got mangled by your emailer.
The more likely cause is that the emailer converted tabs into spaces or broke
long lines.

If you're using Thunderbird, the solution is to install Asalted Patches
extension, available at:
	https://hg.mozilla.org/users/clarkbw_gnome.org/asalted-patches/
Other emailers will need you to disable the wrapping long lines feature.
