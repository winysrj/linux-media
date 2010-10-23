Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:1026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750727Ab0JWEHI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 23 Oct 2010 00:07:08 -0400
Message-ID: <4CC25F60.7050106@redhat.com>
Date: Sat, 23 Oct 2010 02:06:56 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Patrick Boettcher <pboettcher@kernellabs.com>,
	Manu Abraham <abraham.manu@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	=?UTF-8?B?SGVybsOhbiBPcmRpYWxlcw==?= <h.ordiales@gmail.com>,
	"Igor M. Liplianin" <liplianin@me.by>
CC: LMML <linux-media@vger.kernel.org>
Subject: V4L/DVB/IR patches pending merge
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This is the list of patches that weren't applied yet. I've made a big effort starting
last weekend to handle everything I could. All pull requests were addressed. There are still
43 patches on my queue.

Please help me to clean the list.

This is what we have currently:

		== Waiting for Jonathan Corbet ack/nack <corbet@lwn.net> == 

Oct,19 2010: [1/2] ov7670: allow configuration of image size, clock speed, and I/O  http://patchwork.kernel.org/patch/266491  Daniel Drake <dsd@laptop.org>
Oct,19 2010: [2/2] cafe_ccic: Configure ov7670 correctly                            http://patchwork.kernel.org/patch/266501  Daniel Drake <dsd@laptop.org>

Jon, 

in the case of the first patch, I'm not sure if you acked or nacked it. I suspect that you ack ;)
You didn't comment the second one (or maybe I just missed your email). Are both ok for you?

		== Videobuf2 series == 

Oct,20 2010: [7/7] v4l: videobuf2: add CMA allocator                                http://patchwork.kernel.org/patch/267521  Pawel Osciak <p.osciak@samsung.com>
Oct,20 2010: [2/7] v4l: videobuf2: add generic memory handling routines             http://patchwork.kernel.org/patch/267531  Pawel Osciak <p.osciak@samsung.com>
Oct,20 2010: [4/7] v4l: videobuf2: add DMA coherent allocator                       http://patchwork.kernel.org/patch/267541  Pawel Osciak <p.osciak@samsung.com>
Oct,20 2010: [6/7] v4l: vivi: port to videobuf2                                     http://patchwork.kernel.org/patch/267551  Pawel Osciak <p.osciak@samsung.com>
Oct,20 2010: [1/7] v4l: add videobuf2 Video for Linux 2 driver framework            http://patchwork.kernel.org/patch/267561  Pawel Osciak <p.osciak@samsung.com>
Oct,20 2010: [3/7] v4l: videobuf2: add vmalloc allocator                            http://patchwork.kernel.org/patch/267571  Pawel Osciak <p.osciak@samsung.com>
Oct,20 2010: [5/7] v4l: videobuf2: add read() emulator                              http://patchwork.kernel.org/patch/267581  Marek Szyprowski <m.szyprowski@samsung.com>
Oct,13 2010: [1/4] MFC: Changes in include/linux/videodev2.h for MFC 5.1 codec      http://patchwork.kernel.org/patch/250371  Kamil Debski <k.debski@samsung.com>
Oct,13 2010: [2/4] MFC: Add MFC 5.1 driver to plat-s5p                              http://patchwork.kernel.org/patch/250361  Kamil Debski <k.debski@samsung.com>
Oct,13 2010: [3/4] MFC: Add MFC 5.1 V4L2 driver                                     http://patchwork.kernel.org/patch/250411  Kamil Debski <k.debski@samsung.com>
Oct,13 2010: [4/4] s5pc110: Enable MFC 5.1 on Goni                                  http://patchwork.kernel.org/patch/250401  Kamil Debski <k.debski@samsung.com>

Laurent wants more time to review videobuf2. I agree. reviewing API changes like this require some
time and some tests. Also, i would like to see DMA Scatter/Gather version, as it allows testing with
more complex devices.

		== Need more tests/acks from DVB users == 

Aug, 7 2010: Avoid unnecessary data copying inside dvb_dmx_swfilter_204() function  http://patchwork.kernel.org/patch/118147  Marko Ristola <marko.ristola@kolumbus.fi>

Comments? Reviews? I'd like to see more tests about it, as it can potentially break DVB filtering.

		== mantis patches - Waiting for Manu Abraham <abraham.manu@gmail.com> == 

Apr,15 2010: [5/8] ir-core: convert mantis from ir-functions.c                      http://patchwork.kernel.org/patch/92961   David HÃ¤rdeman <david@hardeman.nu>
Jun,20 2010: Mantis DMA transfer cleanup, fixes data corruption and a race, improve http://patchwork.kernel.org/patch/107036  Marko Ristola <marko.ristola@kolumbus.fi>
Jun,20 2010: [2/2] DVB/V4L: mantis: remove unused files                             http://patchwork.kernel.org/patch/107062  BjÃ¸rn Mork <bjorn@mork.no>
Jun,20 2010: mantis: use dvb_attach to avoid double dereferencing on module removal http://patchwork.kernel.org/patch/107063  BjÃ¸rn Mork <bjorn@mork.no>
Jun,21 2010: Mantis, hopper: use MODULE_DEVICE_TABLE use the macro to make modules  http://patchwork.kernel.org/patch/107147  Manu Abraham <abraham.manu@gmail.com>
Jul, 3 2010: mantis: Rename gpio_set_bits to mantis_gpio_set_bits                   http://patchwork.kernel.org/patch/109972  Ben Hutchings <ben@decadent.org.uk>
Jul, 8 2010: Mantis DMA transfer cleanup, fixes data corruption and a race, improve http://patchwork.kernel.org/patch/110909  Marko Ristola <marko.ristola@kolumbus.fi>
Jul, 9 2010: Mantis: append tasklet maintenance for DVB stream delivery             http://patchwork.kernel.org/patch/111090  Marko Ristola <marko.ristola@kolumbus.fi>
Jul,10 2010: Mantis driver patch: use interrupt for I2C traffic instead of busy reg http://patchwork.kernel.org/patch/111245  Marko Ristola <marko.ristola@kolumbus.fi>
Jul,19 2010: Twinhan DTV Ter-CI (3030 mantis)                                       http://patchwork.kernel.org/patch/112708  Niklas Claesson <nicke.claesson@gmail.com>
Aug, 7 2010: Refactor Mantis DMA transfer to deliver 16Kb TS data per interrupt     http://patchwork.kernel.org/patch/118173  Marko Ristola <marko.ristola@kolumbus.fi>
Oct,10 2010: [v2] V4L/DVB: faster DVB-S lock for mantis cards using stb0899 demod   http://patchwork.kernel.org/patch/244201  Tuxoholic <tuxoholic@hotmail.de>
Jun,11 2010: stb0899: Removed an extra byte sent at init on DiSEqC bus              http://patchwork.kernel.org/patch/105621  Florent AUDEBERT <florent.audebert@anevia.com>

What to say? Well, still waiting for Manu to handle those patches. He said he had a problem with
his dish and should be working on it next week. Let's hope we can finally have some movement
on those patches in time for .37.

		== Soc_camera waiting for Guennadi Liakhovetski <g.liakhovetski@gmx.de> review == 

Aug, 3 2010: [04/11] mt9m111: added new bit offset defines                          http://patchwork.kernel.org/patch/116721  Michael Grzeschik <m.grzeschik@pengutronix.de>
Aug, 3 2010: [08/11] mt9m111: added reg_mask function                               http://patchwork.kernel.org/patch/116722  Michael Grzeschik <m.grzeschik@pengutronix.de>
Aug, 3 2010: [v2,10/11] mt9m111: rewrite set_pixfmt                                 http://patchwork.kernel.org/patch/116728  Michael Grzeschik <m.grzeschik@pengutronix.de>
Aug, 3 2010: [v2,11/11] mt9m111: make use of testpattern                            http://patchwork.kernel.org/patch/116730  Michael Grzeschik <m.grzeschik@pengutronix.de>

Those are a few experimental patches. Guennadi is already handling them. I'm keeping here just to avoid being forgotten.

		== Waiting for Igor M. Liplianin <liplianin@tut.by> review == 

Mar,10 2010: DM1105: could not attach frontend 195d:1105                            http://patchwork.kernel.org/patch/84549   Hendrik Skarpeid <skarp@online.no>

Still waiting for Igor about this one. It is not a trivial patch, so we need
some deep analysis on it.

		== Waiting for Patrick Boettcher <pboettcher@dibcom.fr> review == 

May,25 2010: Adding support to the Geniatech/MyGica SBTVD Stick S870 remote control http://patchwork.kernel.org/patch/102314  Hernán Ordiales <h.ordiales@gmail.com>
Jul,14 2010: [1/4] drivers/media/dvb: Remove dead Configs                           http://patchwork.kernel.org/patch/111972  Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
Jul,14 2010: [2/4] drivers/media/dvb: Remove undead configs                         http://patchwork.kernel.org/patch/111973  Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>

The first patch is probably broken.

Hernán,
Could you please re-generate it?

The other two are probably ok.

Patrick, 
any reviews?


		== Waiting for Mauro Carvalho Chehab <mchehab@redhat.com> fixes on Docbook == 

Feb,25 2010: DocBook/Makefile: Make it less verbose                                 http://patchwork.kernel.org/patch/82076   Mauro Carvalho Chehab <mchehab@redhat.com>
Feb,25 2010: DocBook: Add rules to auto-generate some media docbooks                http://patchwork.kernel.org/patch/82075   Mauro Carvalho Chehab <mchehab@redhat.com>
Feb,25 2010: DocBook/v4l/pixfmt.xml: Add missing formats for gspca cpia1 and sn9c20 http://patchwork.kernel.org/patch/82074   Mauro Carvalho Chehab <mchehab@redhat.com>
Feb,25 2010: v4l: document new Bayer and monochrome pixel formats                   http://patchwork.kernel.org/patch/82073   Mauro Carvalho Chehab <mchehab@redhat.com>

Those are my fault^Wlack of time. Not really exciting changes. Just a bunch of automatic checks for
the DocBook building system, and some patch-dependent stuff. I'll see if I can find some time to finish those stuff.

		== waiting for videobuf2 == 

Mar,17 2010: [2/2] V4L/DVB: buf-dma-sg.c: support non-pageable user-allocated memor http://patchwork.kernel.org/patch/97263   Arnout Vandecappelle <arnout@mind.be>
Jul,27 2010: videobuf_dma_sg: a new implementation for mmap                         http://patchwork.kernel.org/patch/114520  Figo.zhang <figo1802@gmail.com>
Jul,28 2010: [v2] videobuf_dma_sg: a new implementation for mmap                    http://patchwork.kernel.org/patch/114760  Figo.zhang <figo1802@gmail.com>
Jul,30 2010: [v2] Resend:videobuf_dma_sg: a new implementation for mmap             http://patchwork.kernel.org/patch/115348  Figo.zhang <figo1802@gmail.com>

Those are some videobuf changes meant to fix some problems on videobuf. However, I think that the
proper way is to address at videobuf2. So, I'm keeping them in order to not forget as requirements
for videobuf2.

Number of pending patches per reviewer:
  LinuxTV community                                                     : 18
  Manu Abraham <abraham.manu@gmail.com>                                 : 13
  Mauro Carvalho Chehab <mchehab@redhat.com>                            : 4
  Guennadi Liakhovetski <g.liakhovetski@gmx.de>                         : 4
  Patrick Boettcher <pboettcher@kernellabs.com                          : 3
  Igor M. Liplianin<liplianin@me.by>                                    : 1

Cheers,
Mauro

---

If you discover any patch submitted via email that weren't caught by
kernel.patchwork.org, this means that the patch got mangled by your emailer.
The more likely cause is that the emailer converted tabs into spaces or broke
long lines, or maybe they were attached with a binary type.
