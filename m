Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35919 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755804Ab3AFNgC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 6 Jan 2013 08:36:02 -0500
Date: Sun, 6 Jan 2013 11:34:55 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: LMML <linux-media@vger.kernel.org>
Cc: Manu Abraham <abraham.manu@gmail.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Prabhakar Lad <prabhakar.lad@ti.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Status of the patches under review at LMML (35 patches)
Message-ID: <20130106113455.329ad868@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is the summary of the patches that are currently under review at
Linux Media Mailing List <linux-media@vger.kernel.org>.
Each patch is represented by its submission date, the subject (up to 70
chars) and the patchwork link (if submitted via email).

P.S.: This email is c/c to the developers where some action is expected.
      If you were copied, please review the patches, acking/nacking or
      submitting an update.


		== New patches == 

Those patches require some review from the community:

This one could break again DVB-S->DVB-S2 support, so, it needs to be
carefully reviewed and tested:

Jun,21 2012: [media] dvb frontend core: tuning in ISDB-T using DVB API v3           http://patchwork.linuxtv.org/patch/12988  Olivier Grenie <olivier.grenie@parrot.com>

This one fix a code that, IMHO, should, instead be replaced by
something better:
Sep,17 2012: [3/3] cx25821: Cleanup filename assignment code                        http://patchwork.linuxtv.org/patch/14445  Peter Senna Tschudin <peter.senna@gmail.com>

This one doesn't seem right for me. Anybody can test/work with it?
Sep, 2 2012: fix: iMon Knob event interpretation issues                             http://patchwork.linuxtv.org/patch/16030  Alexandre Lissy <alexandrelissy@free.fr>

I'm not sure if we should apply this one or not, as it will increase
the probability of miss-interpreting a nec IR protocol. Comments?
Jul,26 2012: media: rc: Add support to decode Remotes using NECx IR protocol        http://patchwork.linuxtv.org/patch/13480  Ravi Kumar V <kumarrav@codeaurora.org>


		== Manu Abraham <abraham.manu@gmail.com> == 

Those patches are there for a long time. I think I'll simply apply all of
them, if they're not reviewed on the next couple weeks:

Mar,11 2012: [2/3] stv090x: use error counter 1 for BER estimation                  http://patchwork.linuxtv.org/patch/10301  Andreas Regel <andreas.regel@gmx.de>
Mar,11 2012: [3/3] stv090x: On STV0903 do not set registers of the second path.     http://patchwork.linuxtv.org/patch/10302  Andreas Regel <andreas.regel@gmx.de>
Nov,29 2011: stv090x: implement function for reading uncorrected blocks count       http://patchwork.linuxtv.org/patch/8656   Mariusz Bia?o?czyk <manio@skyboo.net>
Jun, 8 2011: Add remote control support for mantis                                  http://patchwork.linuxtv.org/patch/7217   Christoph Pinkl <christoph.pinkl@gmail.com>
Apr, 1 2012: [05/11] Slightly more friendly debugging output.                       http://patchwork.linuxtv.org/patch/10520  "Steinar H. Gunderson" <sesse@samfundet.no>
Apr, 1 2012: [06/11] Replace ca_lock by a slightly more general int_stat_lock.      http://patchwork.linuxtv.org/patch/10521  "Steinar H. Gunderson" <sesse@samfundet.no>
Apr, 1 2012: [07/11] Fix a ton of SMP-unsafe accesses.                              http://patchwork.linuxtv.org/patch/10523  "Steinar H. Gunderson" <sesse@samfundet.no>
Apr, 1 2012: [08/11] Remove some unused structure members.                          http://patchwork.linuxtv.org/patch/10525  "Steinar H. Gunderson" <sesse@samfundet.no>
Apr, 1 2012: [09/11] Correct wait_event_timeout error return check.                 http://patchwork.linuxtv.org/patch/10526  "Steinar H. Gunderson" <sesse@samfundet.no>
Apr, 1 2012: [10/11] Ignore timeouts waiting for the IRQ0 flag.                     http://patchwork.linuxtv.org/patch/10527  "Steinar H. Gunderson" <sesse@samfundet.no>
Apr, 1 2012: [11/11] Enable Mantis CA support.                                      http://patchwork.linuxtv.org/patch/10524  "Steinar H. Gunderson" <sesse@samfundet.no>

		== Prabhakar Lad <prabhakar.lad@ti.com> == 

Aug,24 2012: Corrected Oops on omap_vout when no manager is connected               http://patchwork.linuxtv.org/patch/14033  Federico Fuga <fuga@studiofuga.com>
Oct,22 2012: [media] davinci: vpbe: fix missing unlock on error in vpbe_initialize( http://patchwork.linuxtv.org/patch/15106  Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Oct,24 2012: [media] vpif_display: fix return value check in vpif_reqbufs()         http://patchwork.linuxtv.org/patch/15167  Wei Yongjun <yongjun_wei@trendmicro.com.cn>

		== Maxim Levitsky <maximlevitsky@gmail.com> == 

Oct,15 2012: [1/4,media] ene-ir: Fix cleanup on probe failure                       http://patchwork.linuxtv.org/patch/15024  Matthijs Kooijman <matthijs@stdin.nl>

		== Guennadi Liakhovetski <g.liakhovetski@gmx.de> == 

Oct,30 2012: [v2,2/4] media: mx2_camera: Add image size HW limits.                  http://patchwork.linuxtv.org/patch/15298  Javier Martin <javier.martin@vista-silicon.com>
Nov,13 2012: sh_vou: Move from videobuf to videobuf2                                http://patchwork.linuxtv.org/patch/15433  Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Nov,16 2012: [05/14,media] atmel-isi: Update error check for unsigned variables     http://patchwork.linuxtv.org/patch/15475  Tushar Behera <tushar.behera@linaro.org>
Jan, 3 2013: [1/3] sh_vou: Don't modify const variable in sh_vou_s_crop()           http://patchwork.linuxtv.org/patch/16095  Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Jan, 3 2013: [2/3] sh_vou: Use video_drvdata()                                      http://patchwork.linuxtv.org/patch/16097  Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Jan, 3 2013: [3/3] sh_vou: Use vou_dev instead of vou_file wherever possible        http://patchwork.linuxtv.org/patch/16096  Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

		== Laurent Pinchart <laurent.pinchart@ideasonboard.com> == 

Dec,12 2012: [v2] ad5820: Voice coil motor controller driver                        http://patchwork.linuxtv.org/patch/15881  Florian Neuhaus <florian.neuhaus@reberinformatik.ch>
Jan, 4 2013: omap3isp: Add support for interlaced input data                        http://patchwork.linuxtv.org/patch/16133  William Swanson <william.swanson@fuel7.com>
Sep, 4 2012: [5/5] drivers/media/platform/omap3isp/isp.c: fix error return code     http://patchwork.linuxtv.org/patch/14169  Peter Senna Tschudin <peter.senna@gmail.com>

		== Sylwester Nawrocki <s.nawrocki@samsung.com> == 

Dec,28 2012: [1/3,media] s5p-mfc: use mfc_err instead of printk                     http://patchwork.linuxtv.org/patch/16012  Sachin Kamat <sachin.kamat@linaro.org>
Jan, 6 2013: s5p-tv: mixer: fix handling of VIDIOC_S_FMT                            http://patchwork.linuxtv.org/patch/16143  Tomasz Stanislawski <t.stanislaws@samsung.com>

		== Marek Szyprowski <m.szyprowski@samsung.com> == 

Nov,12 2012: [media] videobuf2-core: print current state of buffer in vb2_buffer_do http://patchwork.linuxtv.org/patch/15420  Tushar Behera <tushar.behera@linaro.org>

		== Sascha Hauer <s.hauer@pengutronix.de> == 

Sacha is returing next week. He should be addressing this issue
by them:
Nov,14 2012: [media] coda: Fix build due to iram.h rename                           http://patchwork.linuxtv.org/patch/15447  Fabio Estevam <fabio.estevam@freescale.com>

		== Mauro Carvalho Chehab <mchehab@redhat.com> == 

Those are my own RFC patches. I should rework the QoS patches next
week/weekend:

Dec,28 2012: [RFCv3] dvb: Add DVBv5 properties for quality parameters               http://patchwork.linuxtv.org/patch/16026  Mauro Carvalho Chehab <mchehab@redhat.com>
Dec,28 2012: [RFC, media] dvb: frontend API: Add a flag to indicate that get_fronte http://patchwork.linuxtv.org/patch/16024  Mauro Carvalho Chehab <mchehab@redhat.com>
Jan, 1 2013: [RFCv3] dvb: Add DVBv5 properties for quality parameters               http://patchwork.linuxtv.org/patch/16053  Mauro Carvalho Chehab <mchehab@redhat.com>


Number of pending patches per reviewer:
  Manu Abraham <abraham.manu@gmail.com>                                 : 11
  Guennadi Liakhovetski <g.liakhovetski@gmx.de>                         : 6
  LinuxTV community                                                     : 4
  Laurent Pinchart <laurent.pinchart@ideasonboard.com>                  : 3
  Mauro Carvalho Chehab <mchehab@redhat.com>                            : 3
  Prabhakar Lad <prabhakar.lad@ti.com>                                  : 3
  Sylwester Nawrocki <s.nawrocki@samsung.com>                           : 2
  Sascha Hauer <s.hauer@pengutronix.de>                                 : 1
  Maxim Levitsky <maximlevitsky@gmail.com>                              : 1
  Marek Szyprowski <m.szyprowski@samsung.com>                           : 1

Cheers,
Mauro

---

If you discover any patch submitted via email that weren't caught by
kernel.patchwork.org, this means that the patch got mangled by your emailer.
The more likely cause is that the emailer converted tabs into spaces or broke
long lines. Please fix your emailer and re-send.
