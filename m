Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51728 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752391Ab2HNNEd (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Aug 2012 09:04:33 -0400
Message-ID: <502A4CD1.1020108@redhat.com>
Date: Tue, 14 Aug 2012 10:04:17 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: LMML <linux-media@vger.kernel.org>
CC: Manu Abraham <abraham.manu@gmail.com>,
	=?UTF-8?B?RGF2aWQgSMOkcmRlbWFu?= <david@hardeman.nu>,
	Silvester Nawrocki <sylvester.nawrocki@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Prabhakar Lad <prabhakar.lad@ti.com>
Subject: Patches submitted via linux-media ML that are at patchwork.linuxtv.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In order to help people to know about the status of the pending patches,
I'm summing-up the patches pending for merge on this email.

If is there any patch missing, please check if it is at patchwork
before asking what happened:
	http://patchwork.linuxtv.org/project/linux-media/list/?state=*

If patchwork didn't pick, then the emailer likely line-wrapped or
corrupted the patch.

As announced, patchwork is now generating status change emails. So,
those that didn't decide to opt-out emails there will receive
notifications every time a patch is reviewed. Unfortunately, 
patchwork doesn't send emails is when a patch is stored there.

For the ones explicitly copied on this email, I kindly ask you to update
me about the review status of the patches below.

In special, on my track list, there are three patches from 2011 still
not reviewed. Driver maintainers: I kindly ask you to be more active on
patch reviewing, not holding any patch for long periods like that,
and sending pull request more often. You should only be holding patches
if you have very strong reasons why this is required.

A final note: patches from driver maintainers with git trees are generally
just marked as RFC. Well, I still applied several of them, when they're
trivial enough and they're seem to be addressing a real bug - helping
myself to not need to re-review them later.

I really expect people to add more "RFC" on patches. We're having a net
commit rate of about 500-600 patches per merge window, and perhaps 3 or 4
times more patches at the ML that are just part of some discussions and
aren't yet on their final version. It doesn't scale if I need to review
~3000 patches per merge window, as that would mean reviewing 75 patches per
working day. Unfortunately, linux-media patch reviewing is not my full-time
job. So, please help me marking those under-discussion patches as RFC, in
order to allow me to focus on the 600 ones that will actually be merged.

Thank you!
Mauro


Number of pending patches per reviewer (excluding the newer ones):
  Guennadi Liakhovetski <g.liakhovetski@gmx.de>                         : 17
  Manu Abraham <abraham.manu@gmail.com>                                 : 11
  Silvester Nawrocki <sylvester.nawrocki@gmail.com>                     : 11
  Laurent Pinchart <laurent.pinchart@ideasonboard.com>                  : 3
  Jonathan Corbet <corbet@lwn.net>                                      : 2
  David Härdeman <david@hardeman.nu>                                    : 1
  Prabhakar Lad <prabhakar.lad@ti.com>                                  : 1


		== Patches waiting for some action == 

Those two patches require the m88rs2000 driver to be broken into tuner and demod:

May, 8 2012: [1/2] TeVii DVB-S s421 and s632 cards support                          http://patchwork.linuxtv.org/patch/11103  Igor M. Liplianin <liplianin@me.by>
May, 8 2012: [2/2] TeVii DVB-S s421 and s632 cards support, rs2000 part             http://patchwork.linuxtv.org/patch/11104  Igor M. Liplianin <liplianin@me.by>

This one requires more testing:

May,15 2012: [GIT,PULL,FOR,3.5] DMABUF importer feature in V4L2 API                 http://patchwork.linuxtv.org/patch/11268  Sylwester Nawrocki <s.nawrocki@samsung.com>

Those patches require more test/review from the community (please help!):

Jun,21 2012: dvb: push down ioctl lock in dvb_usercopy                              http://patchwork.linuxtv.org/patch/12989  Nikolaus Schulz <schulz@macnetix.de>
Jul,26 2012: media: rc: Add support to decode Remotes using NECx IR protocol        http://patchwork.linuxtv.org/patch/13480  Ravi Kumar V <kumarrav@codeaurora.org>
Jul,31 2012: [RFC] Fix DVB ioctls failing if frontend open/closed too fast          http://patchwork.linuxtv.org/patch/13563  Juergen Lock <nox@jelal.kn-bremen.de>
Jun,21 2012: [media] dvb frontend core: tuning in ISDB-T using DVB API v3           http://patchwork.linuxtv.org/patch/12988  Olivier Grenie <olivier.grenie@parrot.com>

Those are some RFC patches made by me:

I should be submitting a new version soon for this one:

Jan,20 2012: [RFC] dvb: Add DVBv5 properties for quality parameters                 http://patchwork.linuxtv.org/patch/9578   Mauro Carvalho Chehab <mchehab@redhat.com>

This one is likely ok, as none complained. I'll likely merge it soon,
together with some changes for a few ISDB-T drivers:

Aug,13 2012: [media] dvb: frontend API: Add a flag to indicate that get_frontend()  http://patchwork.linuxtv.org/patch/13783  Mauro Carvalho Chehab <mchehab@redhat.com>

Those are the second part of the tree reorganization. Expect more like
that today:

Aug,14 2012: [2/3,media] rename most media/video usb drivers to media/usb           http://patchwork.linuxtv.org/patch/13786  Mauro Carvalho Chehab <mchehab@redhat.com>
Aug,14 2012: [3/3,media] move the remaining USB drivers to drivers/media/usb        http://patchwork.linuxtv.org/patch/13787  Mauro Carvalho Chehab <mchehab@redhat.com>
Aug,14 2012: media/usb: fix compilation for pure dvb usb drivers                    http://patchwork.linuxtv.org/patch/13799  Mauro Carvalho Chehab <mchehab@redhat.com>

Manu is against this one, as the boards are different. However, both are 
just a copy of the same code, and they're like that since when they got
merged. So, I can't see any technical reason why not merging them.
Anyway, I'll wait a little more before taking any decision about it:

Aug, 6 2012: [media] mantis: merge both vp2033 and vp2040 drivers                   http://patchwork.linuxtv.org/patch/13631  Mauro Carvalho Chehab <mchehab@redhat.com>

		== New patches == 

Those patches simply arrived today. They weren't analyzed yet (see: 10
new patches on just a few hours - that's because I've already cleaned
a few other ones also sent today):

Aug,14 2012: cx23885-cards: fix netup card revision                                 http://patchwork.linuxtv.org/patch/13791  Anton Nurkin <ptqa@netup.ru>
Aug,14 2012: [media] it913x-fe: use ARRAY_SIZE() as a cleanup                       http://patchwork.linuxtv.org/patch/13792  Dan Carpenter <dan.carpenter@oracle.com>
Aug,14 2012: [media] em28xx: use after free in em28xx_v4l2_close()                  http://patchwork.linuxtv.org/patch/13793  Dan Carpenter <dan.carpenter@oracle.com>
Aug,14 2012: [media] mem2mem_testdev: unlock and return error code properly         http://patchwork.linuxtv.org/patch/13794  Dan Carpenter <dan.carpenter@oracle.com>
Aug,14 2012: [media] stk1160: unlock on error path stk1160_set_alternate()          http://patchwork.linuxtv.org/patch/13795  Dan Carpenter <dan.carpenter@oracle.com>
Aug,14 2012: [media] stk1160: remove unneeded check                                 http://patchwork.linuxtv.org/patch/13796  Dan Carpenter <dan.carpenter@oracle.com>
Aug,14 2012: v4l/s5p-mfc: optimized code related to working contextes               http://patchwork.linuxtv.org/patch/13797  Andrzej Hajda <a.hajda@samsung.com>
Aug,14 2012: v4l/s5p-mfc: added DMABUF support for encoder                          http://patchwork.linuxtv.org/patch/13798  Andrzej Hajda <a.hajda@samsung.com>
Aug,14 2012: DocBook: update RDS references to the latest RDS standards.            http://patchwork.linuxtv.org/patch/13800  Hans Verkuil <hans.verkuil@cisco.com>
Aug,14 2012: DocBook validation fixes.                                              http://patchwork.linuxtv.org/patch/13801  Hans Verkuil <hans.verkuil@cisco.com>

		== Guennadi Liakhovetski <g.liakhovetski@gmx.de> == 

Aug, 2 2012: [v3] mt9v022: Add support for mt9v024                                  http://patchwork.linuxtv.org/patch/13582  Alex Gershgorin <alexg@meprolight.com>
Aug, 6 2012: [1/1] media: mx3_camera: Improve data bus width check code for probe   http://patchwork.linuxtv.org/patch/13618  Liu Ying <Ying.liu@freescale.com>
Aug, 9 2012: [1/1, v2] media/video: vpif: fixing function name start to vpif_config http://patchwork.linuxtv.org/patch/13689  Dror Cohen <dror@liveu.tv>
Aug, 1 2012: media: soc_camera: don't clear pix->sizeimage in JPEG mode when try_fm http://patchwork.linuxtv.org/patch/13565  Albert Wang <twang13@marvell.com>
Jul,30 2012: media: mx3_camera: buf_init() add buffer state check                   http://patchwork.linuxtv.org/patch/13528  Alex Gershgorin <alexg@meprolight.com>
Jul,11 2012: [v2] media: mx2_camera: Don't modify non volatile parameters in try_fm http://patchwork.linuxtv.org/patch/13310  Javier Martin <javier.martin@vista-silicon.com>
Jul,11 2012: [v6] media: mx2_camera: Fix mbus format handling                       http://patchwork.linuxtv.org/patch/13314  Javier Martin <javier.martin@vista-silicon.com>
Jul,12 2012: media: mx2_camera: Add YUYV output format.                             http://patchwork.linuxtv.org/patch/13330  Javier Martin <javier.martin@vista-silicon.com>
Jul,12 2012: media: mx2_camera: Remove MX2_CAMERA_SWAP16 and MX2_CAMERA_PACK_DIR_MS http://patchwork.linuxtv.org/patch/13331  Javier Martin <javier.martin@vista-silicon.com>
Jul,12 2012: [1/2,v2] media: Add mem2mem deinterlacing driver.                      http://patchwork.linuxtv.org/patch/13332  Javier Martin <javier.martin@vista-silicon.com>
Jul,30 2012: mt9v022: Add support for mt9v024                                       http://patchwork.linuxtv.org/patch/13525  Alex Gershgorin <alexg@meprolight.com>
Aug, 1 2012: [v2] media: mx2_camera: Fix clock handling for i.MX27.                 http://patchwork.linuxtv.org/patch/13569  Javier Martin <javier.martin@vista-silicon.com>
Aug, 2 2012: [v2] mt9v022: Add support for mt9v024                                  http://patchwork.linuxtv.org/patch/13579  Alex Gershgorin <alexg@meprolight.com>
May,25 2012: [06/15] video: mx1_camera: Use clk_prepare_enable/clk_disable_unprepar http://patchwork.linuxtv.org/patch/11505  Fabio Estevam <fabio.estevam@freescale.com>
May,25 2012: [07/15] video: mx2_camera: Use clk_prepare_enable/clk_disable_unprepar http://patchwork.linuxtv.org/patch/11506  Fabio Estevam <fabio.estevam@freescale.com>
May,25 2012: [08/15] video: mx2_emmaprp: Use clk_prepare_enable/clk_disable_unprepa http://patchwork.linuxtv.org/patch/11507  Fabio Estevam <fabio.estevam@freescale.com>
Jun, 5 2012: media: mx2_camera: Add YUYV output format.                             http://patchwork.linuxtv.org/patch/11580  Javier Martin <javier.martin@vista-silicon.com>

		== Laurent Pinchart <laurent.pinchart@ideasonboard.com> == 

Sep,27 2011: [v2,1/5] omap3evm: Enable regulators for camera interface              http://patchwork.linuxtv.org/patch/7969   Vaibhav Hiremath <hvaibhav@ti.com>
Jul,26 2012: [1/2,media] omap3isp: implement ENUM_FMT                               http://patchwork.linuxtv.org/patch/13492  Michael Jones <michael.jones@matrix-vision.de>
Jul,26 2012: [2/2,media] omap3isp: support G_FMT                                    http://patchwork.linuxtv.org/patch/13493  Michael Jones <michael.jones@matrix-vision.de>

		== Prabhakar Lad <prabhakar.lad@ti.com> == 

Aug, 2 2012: [1/1] media/video: vpif: fixing function name start to vpif_config_par http://patchwork.linuxtv.org/patch/13576  Dror Cohen <dror@liveu.tv>

		== Silvester Nawrocki <sylvester.nawrocki@gmail.com> == 

Aug, 2 2012: [PATH,v3,1/2] v4l: Add factory register values form S5K4ECGX sensor    http://patchwork.linuxtv.org/patch/13580  Sangwook Lee <sangwook.lee@linaro.org>
Aug, 2 2012: [PATH,v3,2/2] v4l: Add v4l2 subdev driver for S5K4ECGX sensor          http://patchwork.linuxtv.org/patch/13581  Sangwook Lee <sangwook.lee@linaro.org>
Aug,10 2012: [1/2,media] s5p-tv: Use devm_regulator_get() in sdo_drv.c file         http://patchwork.linuxtv.org/patch/13719  Sachin Kamat <sachin.kamat@linaro.org>
Aug,10 2012: [2/2,media] s5p-tv: Use devm_* functions in sii9234_drv.c file         http://patchwork.linuxtv.org/patch/13720  Sachin Kamat <sachin.kamat@linaro.org>
Aug,10 2012: [RESEND] v4l/s5p-mfc: added support for end of stream handling in MFC  http://patchwork.linuxtv.org/patch/13721  Andrzej Hajda <a.hajda@samsung.com>
Aug,10 2012: [v4,1/2] v4l: Add factory register values form S5K4ECGX sensor         http://patchwork.linuxtv.org/patch/13727  Sangwook Lee <sangwook.lee@linaro.org>
Aug,10 2012: [v4,2/2] v4l: Add v4l2 subdev driver for S5K4ECGX sensor               http://patchwork.linuxtv.org/patch/13728  Sangwook Lee <sangwook.lee@linaro.org>
Jun,11 2012: [1/3,media] s5p-tv: Replace printk with pr_* functions                 http://patchwork.linuxtv.org/patch/11666  Sachin Kamat <sachin.kamat@linaro.org>
Jun,11 2012: [2/3,media] s5p-mfc: Replace printk with pr_* functions                http://patchwork.linuxtv.org/patch/11667  Sachin Kamat <sachin.kamat@linaro.org>
Jun,11 2012: [3/3,media] s5p-fimc: Replace printk with pr_* functions               http://patchwork.linuxtv.org/patch/11668  Sachin Kamat <sachin.kamat@linaro.org>
Jun,12 2012: [1/1, media] s5p-fimc: Replace custom err() macro with v4l2_err() macr http://patchwork.linuxtv.org/patch/11675  Sachin Kamat <sachin.kamat@linaro.org>

		== Jonathan Corbet <corbet@lwn.net> == 

Apr,26 2012: [2/2] marvell-cam: Build fix: missing "select VIDEOBUF2_VMALLOC"       http://patchwork.linuxtv.org/patch/10848  Chris Ball <cjb@laptop.org>

This one is an alternative RFC proposal for the above, if Jon/Chris
decide to take another approach:

Aug,13 2012: [2/2] marvell-cam: Build fix: missing "select VIDEOBUF2_VMALLOC"       http://patchwork.linuxtv.org/patch/13784  Mauro Carvalho Chehab <mchehab@redhat.com>

		== Manu Abraham <abraham.manu@gmail.com> == 

Jun, 8 2011: Add remote control support for mantis                                  http://patchwork.linuxtv.org/patch/7217   Christoph Pinkl <christoph.pinkl@gmail.com>
Nov,29 2011: stv090x: implement function for reading uncorrected blocks count       http://patchwork.linuxtv.org/patch/8656   Mariusz Bia?o?czyk <manio@skyboo.net>
Mar,11 2012: [2/3] stv090x: use error counter 1 for BER estimation                  http://patchwork.linuxtv.org/patch/10301  Andreas Regel <andreas.regel@gmx.de>
Mar,11 2012: [3/3] stv090x: On STV0903 do not set registers of the second path.     http://patchwork.linuxtv.org/patch/10302  Andreas Regel <andreas.regel@gmx.de>
Apr, 1 2012: [05/11] Slightly more friendly debugging output.                       http://patchwork.linuxtv.org/patch/10520  "Steinar H. Gunderson" <sesse@samfundet.no>
Apr, 1 2012: [06/11] Replace ca_lock by a slightly more general int_stat_lock.      http://patchwork.linuxtv.org/patch/10521  "Steinar H. Gunderson" <sesse@samfundet.no>
Apr, 1 2012: [07/11] Fix a ton of SMP-unsafe accesses.                              http://patchwork.linuxtv.org/patch/10523  "Steinar H. Gunderson" <sesse@samfundet.no>
Apr, 1 2012: [11/11] Enable Mantis CA support.                                      http://patchwork.linuxtv.org/patch/10524  "Steinar H. Gunderson" <sesse@samfundet.no>
Apr, 1 2012: [08/11] Remove some unused structure members.                          http://patchwork.linuxtv.org/patch/10525  "Steinar H. Gunderson" <sesse@samfundet.no>
Apr, 1 2012: [09/11] Correct wait_event_timeout error return check.                 http://patchwork.linuxtv.org/patch/10526  "Steinar H. Gunderson" <sesse@samfundet.no>
Apr, 1 2012: [10/11] Ignore timeouts waiting for the IRQ0 flag.                     http://patchwork.linuxtv.org/patch/10527  "Steinar H. Gunderson" <sesse@samfundet.no>

		== David Härdeman <david@hardeman.nu> == 

Jul,31 2012: [media] winbond-cir: Fix initialization                                http://patchwork.linuxtv.org/patch/13539  Sean Young <sean@mess.org>
