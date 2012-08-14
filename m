Return-path: <linux-media-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:56259 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751119Ab2HNNgq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Aug 2012 09:36:46 -0400
Message-ID: <502A5464.2060005@ti.com>
Date: Tue, 14 Aug 2012 19:06:36 +0530
From: Prabhakar Lad <prabhakar.lad@ti.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: LMML <linux-media@vger.kernel.org>
Subject: Re: Patches submitted via linux-media ML that are at patchwork.linuxtv.org
References: <502A4CD1.1020108@redhat.com>
In-Reply-To: <502A4CD1.1020108@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Tuesday 14 August 2012 06:34 PM, Mauro Carvalho Chehab wrote:
> In order to help people to know about the status of the pending patches,
> I'm summing-up the patches pending for merge on this email.
> 
> If is there any patch missing, please check if it is at patchwork
> before asking what happened:
> 	http://patchwork.linuxtv.org/project/linux-media/list/?state=*
> 
> If patchwork didn't pick, then the emailer likely line-wrapped or
> corrupted the patch.
> 

[Snip]

> 		== Laurent Pinchart <laurent.pinchart@ideasonboard.com> == 
> 
> Sep,27 2011: [v2,1/5] omap3evm: Enable regulators for camera interface              http://patchwork.linuxtv.org/patch/7969   Vaibhav Hiremath <hvaibhav@ti.com>
> Jul,26 2012: [1/2,media] omap3isp: implement ENUM_FMT                               http://patchwork.linuxtv.org/patch/13492  Michael Jones <michael.jones@matrix-vision.de>
> Jul,26 2012: [2/2,media] omap3isp: support G_FMT                                    http://patchwork.linuxtv.org/patch/13493  Michael Jones <michael.jones@matrix-vision.de>
> 
> 		== Prabhakar Lad <prabhakar.lad@ti.com> == 
> 
> Aug, 2 2012: [1/1] media/video: vpif: fixing function name start to vpif_config_par http://patchwork.linuxtv.org/patch/13576  Dror Cohen <dror@liveu.tv>
> 
 This patch can be marked as 'Rejected'. Dror has sent a v2 version
fixing few comments (http://patchwork.linuxtv.org/patch/13689/) which
I'll issue a pull to this v2 patch through Manju's tree soon for 3.7.

Thx,
--Prabhakar

> 		== Silvester Nawrocki <sylvester.nawrocki@gmail.com> == 
> 
> Aug, 2 2012: [PATH,v3,1/2] v4l: Add factory register values form S5K4ECGX sensor    http://patchwork.linuxtv.org/patch/13580  Sangwook Lee <sangwook.lee@linaro.org>
> Aug, 2 2012: [PATH,v3,2/2] v4l: Add v4l2 subdev driver for S5K4ECGX sensor          http://patchwork.linuxtv.org/patch/13581  Sangwook Lee <sangwook.lee@linaro.org>
> Aug,10 2012: [1/2,media] s5p-tv: Use devm_regulator_get() in sdo_drv.c file         http://patchwork.linuxtv.org/patch/13719  Sachin Kamat <sachin.kamat@linaro.org>
> Aug,10 2012: [2/2,media] s5p-tv: Use devm_* functions in sii9234_drv.c file         http://patchwork.linuxtv.org/patch/13720  Sachin Kamat <sachin.kamat@linaro.org>
> Aug,10 2012: [RESEND] v4l/s5p-mfc: added support for end of stream handling in MFC  http://patchwork.linuxtv.org/patch/13721  Andrzej Hajda <a.hajda@samsung.com>
> Aug,10 2012: [v4,1/2] v4l: Add factory register values form S5K4ECGX sensor         http://patchwork.linuxtv.org/patch/13727  Sangwook Lee <sangwook.lee@linaro.org>
> Aug,10 2012: [v4,2/2] v4l: Add v4l2 subdev driver for S5K4ECGX sensor               http://patchwork.linuxtv.org/patch/13728  Sangwook Lee <sangwook.lee@linaro.org>
> Jun,11 2012: [1/3,media] s5p-tv: Replace printk with pr_* functions                 http://patchwork.linuxtv.org/patch/11666  Sachin Kamat <sachin.kamat@linaro.org>
> Jun,11 2012: [2/3,media] s5p-mfc: Replace printk with pr_* functions                http://patchwork.linuxtv.org/patch/11667  Sachin Kamat <sachin.kamat@linaro.org>
> Jun,11 2012: [3/3,media] s5p-fimc: Replace printk with pr_* functions               http://patchwork.linuxtv.org/patch/11668  Sachin Kamat <sachin.kamat@linaro.org>
> Jun,12 2012: [1/1, media] s5p-fimc: Replace custom err() macro with v4l2_err() macr http://patchwork.linuxtv.org/patch/11675  Sachin Kamat <sachin.kamat@linaro.org>
> 
> 		== Jonathan Corbet <corbet@lwn.net> == 
> 
> Apr,26 2012: [2/2] marvell-cam: Build fix: missing "select VIDEOBUF2_VMALLOC"       http://patchwork.linuxtv.org/patch/10848  Chris Ball <cjb@laptop.org>
> 
> This one is an alternative RFC proposal for the above, if Jon/Chris
> decide to take another approach:
> 
> Aug,13 2012: [2/2] marvell-cam: Build fix: missing "select VIDEOBUF2_VMALLOC"       http://patchwork.linuxtv.org/patch/13784  Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> 		== Manu Abraham <abraham.manu@gmail.com> == 
> 
> Jun, 8 2011: Add remote control support for mantis                                  http://patchwork.linuxtv.org/patch/7217   Christoph Pinkl <christoph.pinkl@gmail.com>
> Nov,29 2011: stv090x: implement function for reading uncorrected blocks count       http://patchwork.linuxtv.org/patch/8656   Mariusz Bia?o?czyk <manio@skyboo.net>
> Mar,11 2012: [2/3] stv090x: use error counter 1 for BER estimation                  http://patchwork.linuxtv.org/patch/10301  Andreas Regel <andreas.regel@gmx.de>
> Mar,11 2012: [3/3] stv090x: On STV0903 do not set registers of the second path.     http://patchwork.linuxtv.org/patch/10302  Andreas Regel <andreas.regel@gmx.de>
> Apr, 1 2012: [05/11] Slightly more friendly debugging output.                       http://patchwork.linuxtv.org/patch/10520  "Steinar H. Gunderson" <sesse@samfundet.no>
> Apr, 1 2012: [06/11] Replace ca_lock by a slightly more general int_stat_lock.      http://patchwork.linuxtv.org/patch/10521  "Steinar H. Gunderson" <sesse@samfundet.no>
> Apr, 1 2012: [07/11] Fix a ton of SMP-unsafe accesses.                              http://patchwork.linuxtv.org/patch/10523  "Steinar H. Gunderson" <sesse@samfundet.no>
> Apr, 1 2012: [11/11] Enable Mantis CA support.                                      http://patchwork.linuxtv.org/patch/10524  "Steinar H. Gunderson" <sesse@samfundet.no>
> Apr, 1 2012: [08/11] Remove some unused structure members.                          http://patchwork.linuxtv.org/patch/10525  "Steinar H. Gunderson" <sesse@samfundet.no>
> Apr, 1 2012: [09/11] Correct wait_event_timeout error return check.                 http://patchwork.linuxtv.org/patch/10526  "Steinar H. Gunderson" <sesse@samfundet.no>
> Apr, 1 2012: [10/11] Ignore timeouts waiting for the IRQ0 flag.                     http://patchwork.linuxtv.org/patch/10527  "Steinar H. Gunderson" <sesse@samfundet.no>
> 
> 		== David Härdeman <david@hardeman.nu> == 
> 
> Jul,31 2012: [media] winbond-cir: Fix initialization                                http://patchwork.linuxtv.org/patch/13539  Sean Young <sean@mess.org>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

