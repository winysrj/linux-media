Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:51705 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753524Ab2HPKj0 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Aug 2012 06:39:26 -0400
Message-ID: <502CCDBB.8070501@ti.com>
Date: Thu, 16 Aug 2012 16:08:51 +0530
From: Prabhakar Lad <prabhakar.lad@ti.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: LMML <linux-media@vger.kernel.org>,
	Manu Abraham <abraham.manu@gmail.com>,
	=?UTF-8?B?RGF2aWQgSMOkcmRlbWFu?= <david@hardeman.nu>,
	Silvester Nawrocki <sylvester.nawrocki@gmail.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: Re: Patches submitted via linux-media ML that are at patchwork.linuxtv.org
References: <502A4CD1.1020108@redhat.com> <502C34CE.1040100@redhat.com>
In-Reply-To: <502C34CE.1040100@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Thursday 16 August 2012 05:16 AM, Mauro Carvalho Chehab wrote:
> Em 14-08-2012 10:04, Mauro Carvalho Chehab escreveu:
>> In order to help people to know about the status of the pending patches,
>> I'm summing-up the patches pending for merge on this email.
> 
> Thank you all maintainers that helped me updating it!
> 
> If I didn't miss anything, the patches below are what's under review.
> 
> I applied today the reorg patches part 2. Please test. There are still some
> mess at drivers/media/platform. I may try to address it next week, if I have
> some time. Of course, people are welcome to do that, instead ;) Basically,
> vivi, platform and mem2mem drivers are there, maybe together with some other
> stuff. I think soc_camera deserves its own directory, just like other
> platform drivers.
> 
> The Kconfig stuff on V4L can likely be simplified: there are too many hidden
> options there that probably can be removed, in order to make it simpler.
> 
> Anyway, at least in my humble opinion, things are now better organized.
> 
> With regards to media-build.git tree, I updated it to properly apply the
> fixup patches against the new tree. I didn't updated the driver removal
> logic there, used during "make install".
> 
> For the driver removal logic to work at media-build, the file "obsolete.txt" 
> needs to have the name and patches for all drivers before the reorganization.
> As the maximum backport is 2.6.31, I suspect that all other stuff at 
> "obsolete.txt" just got outdated and can be removed.
> 
> Thanks,
> Mauro
> 
> 		== Needing more discussions/review by the LinuxTV community == 
> 
> Jun,21 2012: [media] dvb frontend core: tuning in ISDB-T using DVB API v3           http://patchwork.linuxtv.org/patch/12988  Olivier Grenie <olivier.grenie@parrot.com>
> Jun,21 2012: dvb: push down ioctl lock in dvb_usercopy                              http://patchwork.linuxtv.org/patch/12989  Nikolaus Schulz <schulz@macnetix.de>
> Jul,26 2012: media: rc: Add support to decode Remotes using NECx IR protocol        http://patchwork.linuxtv.org/patch/13480  Ravi Kumar V <kumarrav@codeaurora.org>
> Jul,31 2012: [RFC] Fix DVB ioctls failing if frontend open/closed too fast          http://patchwork.linuxtv.org/patch/13563  Juergen Lock <nox@jelal.kn-bremen.de>
> Jan,20 2012: [RFC] dvb: Add DVBv5 properties for quality parameters                 http://patchwork.linuxtv.org/patch/9578   Mauro Carvalho Chehab <mchehab@redhat.com>
> Aug,13 2012: [media] dvb: frontend API: Add a flag to indicate that get_frontend()  http://patchwork.linuxtv.org/patch/13783  Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> 		== Guennadi Liakhovetski <g.liakhovetski@gmx.de> == 
> 
> Jul,12 2012: media: mx2_camera: Remove MX2_CAMERA_SWAP16 and MX2_CAMERA_PACK_DIR_MS http://patchwork.linuxtv.org/patch/13331  Javier Martin <javier.martin@vista-silicon.com>
> May,25 2012: [08/15] video: mx2_emmaprp: Use clk_prepare_enable/clk_disable_unprepa http://patchwork.linuxtv.org/patch/11507  Fabio Estevam <fabio.estevam@freescale.com>
> 
> 		== Prabhakar Lad <prabhakar.lad@ti.com> == 
> 
> Aug, 9 2012: [1/1, v2] media/video: vpif: fixing function name start to vpif_config http://patchwork.linuxtv.org/patch/13689  Dror Cohen <dror@liveu.tv>
> 
 This patch can be marked as 'Accepted'.

Thanks and Regards,
--Prabhakar

> 		== Jonathan Corbet <corbet@lwn.net> == 
> 
> Apr,26 2012: [2/2] marvell-cam: Build fix: missing "select VIDEOBUF2_VMALLOC"       http://patchwork.linuxtv.org/patch/10848  Chris Ball <cjb@laptop.org>
> Aug,13 2012: [2/2] marvell-cam: Build fix: missing "select VIDEOBUF2_VMALLOC"       http://patchwork.linuxtv.org/patch/13784  Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> 		== Manu Abraham <abraham.manu@gmail.com> == 
> 
> May,25 2011: Add remote control support for mantis                                                                            Christoph Pinkl <christoph.pinkl@gmail.com>
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
> 
> 		== Waiting for Malcolm Priestley <tvboxspy@gmail.com> split tuner/demod new patches == 
> 
> May, 8 2012: [1/2] TeVii DVB-S s421 and s632 cards support                          http://patchwork.linuxtv.org/patch/11103  Igor M. Liplianin <liplianin@me.by>
> May, 8 2012: [2/2] TeVii DVB-S s421 and s632 cards support, rs2000 part             http://patchwork.linuxtv.org/patch/11104  Igor M. Liplianin <liplianin@me.by>
> 
> Number of pending patches per reviewer:
>   Manu Abraham <abraham.manu@gmail.com>                                 : 12
>   LinuxTV community                                                     : 6
>   Malcolm Priestley <tvboxspy@gmail.com>                                : 2
>   Jonathan Corbet <corbet@lwn.net>                                      : 2
>   Guennadi Liakhovetski <g.liakhovetski@gmx.de>                         : 2
>   David Härdeman <david@hardeman.nu>                                    : 1
>   Prabhakar Lad <prabhakar.lad@ti.com>                                  : 1
> 
> Cheers,
> Mauro
> 

