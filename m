Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:49044 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932738Ab0JQVVH (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Oct 2010 17:21:07 -0400
Message-ID: <4CBB689F.1070100@redhat.com>
Date: Sun, 17 Oct 2010 19:20:31 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
CC: "Igor M. Liplianin" <liplianin@me.by>,
	Manu Abraham <abraham.manu@gmail.com>,
	Jean-Francois Moine <moinejf@free.fr>,
	Jarod Wilson <jarod@redhat.com>,
	Richard Zidlicky <rz@linux-m68k.org>,
	Antti Palosaari <crope@iki.fi>,
	Sven Barth <pascaldragon@googlemail.com>,
	Patrick Boettcher <pboettcher@kernellabs.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Henrik Kurelid <henke@kurelid.se>,
	Hans de Goede <hdegoede@redhat.com>
Subject: Old patches sent via the Mailing list
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

I did a large effort during this weekend to handle the maximum amount of patches, in order to have them
ready for 2.6.37. While there are still some patches marked as NEW at patchwork, and a few pending pull
requests (mostly related to more kABI changes), there are still a list of patches that are marked as
Under review. Except for 4 patches from me, related to Doc (that I'm keeping in this list just to remind
me that I'll need to fix them when I have some time - just some automation stuff at DocBook), all other
patches marked as Under review are stuff that I basically depend on others.

The last time I sent this list, I was about to travel, and I may have missed some comments, or maybe I
may just forgot to update. But I suspect that, for the list bellow, most of them are stuff where the
driver maintainer just forgot at limbo.

>From the list of patches under review, we have:

Waiting for new patch, signed, from Sven Barth <pascaldragon@googlemail.com>
  Apr,25 2010: Problem with cx25840 and Terratec Grabster AV400                       http://patchwork.kernel.org/patch/94960   Sven Barth <pascaldragon@googlemail.com>

There are some patches where i want to have more tests/acks before applying:
  Aug, 7 2010: Avoid unnecessary data copying inside dvb_dmx_swfilter_204() function  http://patchwork.kernel.org/patch/118147  Marko Ristola <marko.ristola@kolumbus.fi>
  Mar, 1 2010: firedtv: add parameter to fake ca_system_ids in CA_INFO                http://patchwork.kernel.org/patch/82912   Henrik Kurelid <henrik@kurelid.se>
(I'm not sure about this one, Henrik's agument didn't convince me that we should add a workaround for MythTV)

I think that the better is to wait for videobuf2, instead of applying those patches:
  Mar,17 2010: [2/2] V4L/DVB: buf-dma-sg.c: support non-pageable user-allocated memor http://patchwork.kernel.org/patch/97263   Arnout Vandecappelle <arnout@mind.be>
  Jul,27 2010: videobuf_dma_sg: a new implementation for mmap                         http://patchwork.kernel.org/patch/114520  Figo.zhang <figo1802@gmail.com>
  Jul,28 2010: [v2] videobuf_dma_sg: a new implementation for mmap                    http://patchwork.kernel.org/patch/114760  Figo.zhang <figo1802@gmail.com>
  Jul,30 2010: [v2] Resend:videobuf_dma_sg: a new implementation for mmap             http://patchwork.kernel.org/patch/115348  Figo.zhang <figo1802@gmail.com>


Other than that, we have a pending list of older patches, submitted by someone, that I'm still
waiting for the maintainer to take care. If I don't have any return from the maintainer for
a patch older than, let's say, a month, is probably because it is safe for me to apply.

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

		== Soc_camera waiting for Guennadi Liakhovetski <g.liakhovetski@gmx.de> review == 

(Guennadi gave me an update about those patches last time. I'm not sure about the updated status)

Jul, 5 2010: soc-camera: module_put() fix                                           http://patchwork.kernel.org/patch/110202  Magnus Damm <damm@opensource.se>
Jul,27 2010: [1/4] mx2_camera: fix a race causing NULL dereference                  http://patchwork.kernel.org/patch/114515  Baruch Siach <baruch@tkos.co.il>
Jul,27 2010: [2/4] mx2_camera: return IRQ_NONE when doing nothing                   http://patchwork.kernel.org/patch/114517  Baruch Siach <baruch@tkos.co.il>
Jul,27 2010: [4/4] mx2_camera: implement forced termination of active buffer for mx http://patchwork.kernel.org/patch/114518  Baruch Siach <baruch@tkos.co.il>
Aug, 3 2010: [2/5] mx2_camera: remove emma limitation for RGB565                    http://patchwork.kernel.org/patch/116703  Michael Grzeschik <m.grzeschik@pengutronix.de>
Aug, 3 2010: [3/5] mx2_camera: fix for list bufnum in frame_done_emma               http://patchwork.kernel.org/patch/116705  Michael Grzeschik <m.grzeschik@pengutronix.de>
Aug, 3 2010: [4/5] mx2_camera: add rising edge for pixclock                         http://patchwork.kernel.org/patch/116704  Michael Grzeschik <m.grzeschik@pengutronix.de>
Aug, 3 2010: [5/5] mx2_camera: add informative camera clock frequency printout      http://patchwork.kernel.org/patch/116707  Michael Grzeschik <m.grzeschik@pengutronix.de>
Aug, 3 2010: [04/11] mt9m111: added new bit offset defines                          http://patchwork.kernel.org/patch/116721  Michael Grzeschik <m.grzeschik@pengutronix.de>
Aug, 3 2010: [06/11] mt9m111: cropcap and s_crop check if type is VIDEO_CAPTURE     http://patchwork.kernel.org/patch/116726  Michael Grzeschik <m.grzeschik@pengutronix.de>
Aug, 3 2010: [07/11] mt9m111: added current colorspace at g_fmt                     http://patchwork.kernel.org/patch/116724  Michael Grzeschik <m.grzeschik@pengutronix.de>
Aug, 3 2010: [08/11] mt9m111: added reg_mask function                               http://patchwork.kernel.org/patch/116722  Michael Grzeschik <m.grzeschik@pengutronix.de>
Aug, 3 2010: [v2,10/11] mt9m111: rewrite set_pixfmt                                 http://patchwork.kernel.org/patch/116728  Michael Grzeschik <m.grzeschik@pengutronix.de>
Aug, 3 2010: [v2,11/11] mt9m111: make use of testpattern                            http://patchwork.kernel.org/patch/116730  Michael Grzeschik <m.grzeschik@pengutronix.de>

		== Waiting for Antti Palosaari <crope@iki.fi> review == 

Mar,21 2010: af9015 : more robust eeprom parsing                                    http://patchwork.kernel.org/patch/87243   matthieu castet <castet.matthieu@free.fr>

		== Waiting for Igor M. Liplianin <liplianin@tut.by> review == 

Mar,10 2010: DM1105: could not attach frontend 195d:1105                            http://patchwork.kernel.org/patch/84549   Hendrik Skarpeid <skarp@online.no>

		== Waiting for Jarod Wilson <jarod@redhat.com> review/ack == 

Jun,20 2010: drivers/media/IR/imon.c: Use pr_err instead of err                     http://patchwork.kernel.org/patch/107025  Joe Perches <joe@perches.com>

		== Gspca patches - Waiting Jean-Francois Moine <moinejf@free.fr> review == 

Jul, 8 2010: video:gspca.c Fix warning: case value '7' not in enumerated type 'enum http://patchwork.kernel.org/patch/110779  Jean-Francois Moine <moinejf@free.fr>

		== Gspca patches - Waiting Hans de Goede <hdegoede@redhat.com> review == 

Jan,29 2010: [gspca_jf,tree] gspca zc3xx: signal when unknown packet received       http://patchwork.kernel.org/patch/75837   NÃ©meth MÃ¡rton <nm127@freemail.hu>

		== Waiting for Patrick Boettcher <pboettcher@dibcom.fr> review == 

May,25 2010: Adding support to the Geniatech/MyGica SBTVD Stick S870 remote control http://patchwork.kernel.org/patch/102314  Hernán Ordiales <h.ordiales@gmail.com>
Jul,14 2010: [1/4] drivers/media/dvb: Remove dead Configs                           http://patchwork.kernel.org/patch/111972  Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
Jul,14 2010: [2/4] drivers/media/dvb: Remove undead configs                         http://patchwork.kernel.org/patch/111973  Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>

Cheers,
Mauro
