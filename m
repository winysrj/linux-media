Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40721 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751187Ab1IXMfX (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 24 Sep 2011 08:35:23 -0400
Message-ID: <4E7DCE71.4030200@redhat.com>
Date: Sat, 24 Sep 2011 09:34:57 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
CC: Pawel Osiak <pawel@osciak.com>,
	Morimoto Kuninori <morimoto.kuninori@renesas.com>,
	Manu Abraham <abraham.manu@gmail.com>,
	Jarod Wilson <jarod@redhat.com>,
	Eddi De Pieri <eddi@depieri.net>,
	Hans de Goede <hdegoede@redhat.com>,
	Andy Walls <awalls@md.metrocast.net>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Dmitri Belimov <d.belimov@gmail.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Michael Krufky <mkrufky@linuxtv.org>
Subject: Status of the patches under review at LMML (28 patches)
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Everything at patchwork were reviewed by me, and I've applied all patches
that I didn't notice any review by the drivers maintainers.

Driver maintainers:
Please review the remaining patches.

		== Patches for Manu Abraham <abraham.manu@gmail.com> review == 

Jun,11 2010: stb0899: Removed an extra byte sent at init on DiSEqC bus              http://patchwork.linuxtv.org/patch/3639   Florent AUDEBERT <florent.audebert@anevia.com>
Aug, 7 2010: Refactor Mantis DMA transfer to deliver 16Kb TS data per interrupt     http://patchwork.linuxtv.org/patch/4104   Marko Ristola <marko.ristola@kolumbus.fi>
May,21 2011: Disable dynamic current limit for ttpci budget cards                   http://patchwork.linuxtv.org/patch/6669   Guy Martin <gmsoft@tuxicoman.be>
May,23 2011: Increase a timeout, so that bad scheduling does not accidentially caus http://patchwork.linuxtv.org/patch/7178   Hans Petter Selasky <hselasky@c2i.net>
Jun, 8 2011: Add remote control support for mantis                                  http://patchwork.linuxtv.org/patch/7217   Christoph Pinkl <christoph.pinkl@gmail.com>
May,24 2011: Fix the derot zig-zag to work with TT-USB2.0 TechnoTrend.              http://patchwork.linuxtv.org/patch/6777   Hans Petter Selasky <hselasky@c2i.net>
Jun, 1 2011: stv090x: set status bits when there is no lock                         http://patchwork.linuxtv.org/patch/6804   Guy Martin <gmsoft@tuxicoman.be>

		== Patches for Dmitri Belimov <d.belimov@gmail.com> review == 

Apr,23 2009: FM1216ME_MK3 AUX byte for FM mode                                      http://patchwork.linuxtv.org/patch/764    Dmitri Belimov <d.belimov@gmail.com>

		== Patches waiting for Morimoto Kuninori<morimoto.kuninori@renesas.com> check == 

Feb, 2 2010: [2/3] soc-camera: mt9t112: modify delay time after initialize          http://patchwork.linuxtv.org/patch/2553   Kuninori Morimoto <morimoto.kuninori@renesas.com>

		== Patches waiting Mauro Carvalho Chehab <mchehab@redhat.com> tests with mb86a20s/ISDB-T == 

May,19 2011: saa7134-dvb.c kworld_sbtvd                                             http://patchwork.linuxtv.org/patch/6649   Manoel PN <pinusdtv@hotmail.com>

		== Patches waiting for Hans de Goede <hdegoede@redhat.com> review == 

Jun, 4 2011: Increase max exposure value to 255 from 26.                            http://patchwork.linuxtv.org/patch/6850   Marco Diego Aurélio Mesquita <marcodiegomesquita@gmail.com>

		== Patches waiting for Laurent Pinchart <laurent.pinchart@ideasonboard.com> review == 

Jun,22 2011: Improve UVC buffering with regard to USB. Add checks to avoid division http://patchwork.linuxtv.org/patch/7290   Hans Petter Selasky <hselasky@c2i.net>
Jul,11 2011: Error routes through omap3isp ccdc.                                    http://patchwork.linuxtv.org/patch/7428   Jonathan Cameron <jic23@cam.ac.uk>
Jul,14 2011: uvcvideo: add fix suspend/resume quirk for Microdia camera             http://patchwork.linuxtv.org/patch/186    Ming Lei <tom.leiming@gmail.com>
Jul,13 2011: [RFC, v1] mt9v113: VGA camera sensor driver and support for BeagleBoar http://patchwork.linuxtv.org/patch/184    Joel A Fernandes <agnel.joel@gmail.com>
Sep, 6 2011: mt9p031: Do not use PLL if external frequency is the same as target fr http://patchwork.linuxtv.org/patch/7783   Javier Martin <javier.martin@vista-silicon.com>

		== Patches for Andy Walls <Andy Walls <awalls@md.metrocast.net>> review == 

May,25 2011: ivtv: use display information in info not in var for panning           http://patchwork.linuxtv.org/patch/6706   Laurent Pinchart <laurent.pinchart@ideasonboard.com>

		== Waiting for Andy Walls <awalls@md.metrocast.net> double-check == 

Dec,19 2010: [RESEND, for, 2.6.37] cx23885, cx25840: Provide IR Rx timeout event re http://patchwork.linuxtv.org/patch/5133   Andy Walls <awalls@md.metrocast.net>

		== Waiting for Jarod Wilson <jarod@redhat.com> review == 

Apr,28 2011: [10/10] rc-core: move timeout and checks to lirc                       http://patchwork.linuxtv.org/patch/6468   David Härdeman <david@hardeman.nu>

		== Waiting for Pawel Osiak <pawel@osciak.com> review == 

Jul,12 2011: v4l: mem2mem: add wait_{prepare,finish} ops to m2m_testdev             http://patchwork.linuxtv.org/patch/7431   Michael Olbrich <m.olbrich@pengutronix.de>

		== waiting for Michael Krufky <mkrufky@linuxtv.org> review == 

Sep, 4 2011: Medion 95700 analog video support                                      http://patchwork.linuxtv.org/patch/7767   Maciej Szmigiero <mhej@o2.pl>

		== Patches waiting for Guennadi Liakhovetski <g.liakhovetski@gmx.de> review == 

Sep,19 2011: [1/4,v2,FOR,3.1] v4l2: add vb2_get_unmapped_area in vb2 core           http://patchwork.linuxtv.org/patch/7870   Scott Jiang <scott.jiang.linux@gmail.com>
Sep,19 2011: [2/4,v2,FOR,3.1] v4l2: add adv7183 decoder driver                      http://patchwork.linuxtv.org/patch/7872   Scott Jiang <scott.jiang.linux@gmail.com>
Sep,19 2011: [3/4,v2,FOR,3.1] v4l2: add vs6624 sensor driver                        http://patchwork.linuxtv.org/patch/7871   Scott Jiang <scott.jiang.linux@gmail.com>
Sep,19 2011: [4/4,v2,FOR,3.1] v4l2: add blackfin capture bridge driver              http://patchwork.linuxtv.org/patch/7869   Scott Jiang <scott.jiang.linux@gmail.com>
Sep,22 2011: [v3,1/2,media] Add code to enable/disable ISI_MCK clock.               http://patchwork.linuxtv.org/patch/7917   Josh Wu <josh.wu@atmel.com>
Sep,22 2011: [v3, 2/2] at91: add Atmel ISI and ov2640 support on sam9m10/sam9g45 bo http://patchwork.linuxtv.org/patch/7918   Josh Wu <josh.wu@atmel.com>

		== waiting for Eddi De Pieri <eddi@depieri.net> feedback == 

Sep,23 2011: [v2] xc5000: Add support for get_if_frequency                          http://patchwork.linuxtv.org/patch/7932   Mauro Carvalho Chehab <mchehab@redhat.com>


Number of pending patches per reviewer:
  Manu Abraham <abraham.manu@gmail.com>                                 : 7
  Guennadi Liakhovetski <g.liakhovetski@gmx.de>                         : 6
  Laurent Pinchart <laurent.pinchart@ideasonboard.com>                  : 5
  Andy Walls <awalls@md.metrocast.net>                                  : 2
  Pawel Osiak <pawel@osciak.com>                                        : 1
  Morimoto Kuninori<morimoto.kuninori@renesas.com>                      : 1
  Jarod Wilson <jarod@redhat.com>                                       : 1
  Eddi De Pieri <eddi@depieri.net>                                      : 1
  Hans de Goede <hdegoede@redhat.com>                                   : 1
  Dmitri Belimov <d.belimov@gmail.com>                                  : 1
  Mauro Carvalho Chehab <mchehab@redhat.com>                            : 1
  Michael Krufky <mkrufky@linuxtv.org>                                  : 1
