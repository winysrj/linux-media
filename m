Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9229 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750796Ab0EGMls (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 7 May 2010 08:41:48 -0400
Date: Fri, 7 May 2010 09:39:16 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: LMML <linux-media@vger.kernel.org>
Cc: awalls@md.metrocast.net, moinejf@free.fr, g.liakhovetski@gmx.de,
	pboettcher@dibcom.fr, awalls@radix.net, crope@iki.fi,
	davidtlwong@gmail.com, liplianin@tut.by, isely@isely.net,
	tobias.lorenz@gmx.net, hdegoede@redhat.com, abraham.manu@gmail.com,
	u.kleine-koenig@pengutronix.de, herton@mandriva.com.br,
	stoth@kernellabs.com, henrik@kurelid.se
Subject: Status of the patches under review (85 patches) and some misc notes
 about the devel procedures
Message-ID: <20100507093916.2e2ef8e3@pedra>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

My original idea were to send one of such emails per week, in order to allow
people to review my pending list and point me for missing things. Fortunately, 
the number of patches for the next merge window is so high that, even passing 
-hg maintainership to Douglas, I was still very busy. Good to see so much work
at the subsystem. Congrats to the media developers that worked really hard!

With respect to -hg/-git pull requests, my queue is currently empty.

While I was working at the patchwork queue, we've received a lot of contributions
on the last few days. So, I gave up of just applying everything before sending this 
email. I'll just list those patches that weren't yet read. I'll likely handle 
those during the weekend.

Also, as usual, there are probably some patches listed that were already applied,
or that I missed the current status. In this case, just ping me.

It is expected that the current development kernel (2.6.33-rc6) to be the last one
before the next merge window. Let's see. If this is the case, this means that we'll
stop patch receiving for 2.6.35 very soon.

With respect to -git tree, I'll likely change the procedure a little bit for 2.6.35:
instead of merging everything at master, I intend to create some topics branches,
merging patches there, and reserving "master" to be in sync with the latest
stable + accepted fixes (or, some -rc + fixes). This will mean that it will have a 
cleaner history. I expect that the merge procedure from developers tree to be simpler, 
as each topic maintainer could decide either to keep using the latest stable, 
or to go to the very latest upstream tree.

With respect to the backport tree, Douglas is the maintainer for it. He's likely
having a very bad time merging those high volume of patches, while trying to keep
the tree compiling with the legacy kernel. Douglas, thanks for your work!
As usual, if you find something broken there, instead of complain, just send him
a patch fixing it ;)

Thanks,
Mauro.

---

This is the summary of the patches that are currently under review.
Each patch is represented by its submission date, the subject (up to 70
chars) and the patchwork link (if submitted via email).

P.S.: This email is c/c to the developers that some review action is expected.



		== New or updated patches starting from May, 5 or newer - not handled yet == 

May, 5 2010: [-next] input: unlock on error paths                                   http://patchwork.kernel.org/patch/96982
May, 5 2010: [-next] dvb/stv6110x: cleanup error handling                           http://patchwork.kernel.org/patch/96983
May, 5 2010: [-next] media/mem2mem: dereferencing free memory                       http://patchwork.kernel.org/patch/96984
May, 5 2010: media/ov511: cleanup: remove unneeded null check                       http://patchwork.kernel.org/patch/96985
May, 5 2010: [-next,1/2] media/s2255drv: return if vdev not found                   http://patchwork.kernel.org/patch/96987
May, 5 2010: [-next,2/2] media/s2255drv: remove dead code                           http://patchwork.kernel.org/patch/96986
May, 5 2010: tda10048: fix the uncomplete function tda10048_read_ber                http://patchwork.kernel.org/patch/97058
May, 5 2010: media/IR: Add missing include file to rc-map.c                         http://patchwork.kernel.org/patch/97133
May, 5 2010: -next: staging/cx25821: please revert 7a02f549fcc                      http://patchwork.kernel.org/patch/97134
May, 5 2010: fix dvb frontend lockup                                                http://patchwork.kernel.org/patch/97171
May, 5 2010: videobuf: remove external function videobuf_dma_sync()                 http://patchwork.kernel.org/patch/97175
May, 5 2010: -next: staging/cx25821: please revert 7a02f549fcc                      http://patchwork.kernel.org/patch/97177
May, 5 2010: videobuf-vmalloc: remove __videobuf_sync()                             http://patchwork.kernel.org/patch/97197
May, 5 2010: [1/5] viafb: fold via_io.h into via-core.h                             http://patchwork.kernel.org/patch/97224
May, 5 2010: [2/5] viafb: get rid of i2c debug cruft                                http://patchwork.kernel.org/patch/97230
May, 5 2010: [3/5] viafb: Eliminate some global.h references                        http://patchwork.kernel.org/patch/97233
May, 5 2010: [4/5] viafb: move some include files to include/linux                  http://patchwork.kernel.org/patch/97232
May, 5 2010: [5/5] Add the viafb video capture driver                               http://patchwork.kernel.org/patch/97231
Mar,17 2010: [2/2] V4L/DVB: buf-dma-sg.c: support non-pageable user-allocated memor http://patchwork.kernel.org/patch/97263
May, 6 2010: [1/1] staging: cx25821: cx25821-alsa.c: cleanup                        http://patchwork.kernel.org/patch/97295
May, 6 2010: tda10048: fix bitmask for the transmission mode                        http://patchwork.kernel.org/patch/97340
May, 6 2010: tda10048: clear the uncorrected packet registers when saturated        http://patchwork.kernel.org/patch/97341
May, 6 2010: dvb_frontend: fix typos in comments and one function                   http://patchwork.kernel.org/patch/97343
May, 6 2010: [1/3] mx2_camera: Add soc_camera support for i.MX25/i.MX27             http://patchwork.kernel.org/patch/97345
May, 6 2010: [2/3] mx27: add support for the CSI device                             http://patchwork.kernel.org/patch/97352
May, 6 2010: [3/3] mx25: add support for the CSI device                             http://patchwork.kernel.org/patch/97353
May, 6 2010: tm6000: README - add vbi                                               http://patchwork.kernel.org/patch/97354
May, 6 2010: dvb-core: Fix ULE decapsulation bug when less than 4 bytes of ULE SNDU http://patchwork.kernel.org/patch/97358
May, 6 2010: TechnoTrend TT-budget T-3000                                           http://patchwork.kernel.org/patch/97436
May, 4 2010: [v2] IR/imon: remove dead IMON_KEY_RELEASE_OFFSET                      http://patchwork.kernel.org/patch/96854
May, 6 2010: [-next] IR: add header file to fix build                               http://patchwork.kernel.org/patch/97502
May, 7 2010: stv6110x Fix kernel null pointer deref when plugging two TT s2-1600    http://patchwork.kernel.org/patch/97603
May, 7 2010: TT CT-3650 DVB-C support                                               http://patchwork.kernel.org/patch/97606
May, 7 2010: [v2] stv6110x Fix kernel null pointer deref when plugging two TT s2-16 http://patchwork.kernel.org/patch/97612

		== Port mantis IR to the new API - waiting for Manu Abraham <abraham.manu@gmail.com> ack or alternative patch == 

Apr,15 2010: [5/8] ir-core: convert mantis from ir-functions.c                      http://patchwork.kernel.org/patch/92961

		== dsbr100 patchess waiting for more review at the ML == 

May, 5 2010: dsbr100: implement proper locking                                      http://patchwork.kernel.org/patch/97155
May, 5 2010: dsbr100: fix potential use after free                                  http://patchwork.kernel.org/patch/97154
May, 5 2010: dsbr100: only change frequency upon success                            http://patchwork.kernel.org/patch/97156
May, 5 2010: dsbr100: remove disconnected indicator                                 http://patchwork.kernel.org/patch/97158
May, 5 2010: dsbr100: properly initialize the radio                                 http://patchwork.kernel.org/patch/97153
May, 5 2010: dsbr100: cleanup usb probe routine                                     http://patchwork.kernel.org/patch/97157
May, 5 2010: dsbr100: simplify access to radio device                               http://patchwork.kernel.org/patch/97159

		== Moorestown patches waiting for more review at the ML == 

Mar,28 2010: This patch is first part of the intel moorestown isp driver and header http://patchwork.kernel.org/patch/88734
Mar,28 2010: This patch is second part of intel moorestown isp driver and c files c http://patchwork.kernel.org/patch/88775
Mar,28 2010: This patch is second part of intel moorestown isp driver and c files c http://patchwork.kernel.org/patch/88776
Mar,28 2010: This patch is the flash subdev driver for intel moorestown camera imag http://patchwork.kernel.org/patch/88735
Mar,28 2010: this patch is 2mp camera (ov2650) sensor subdev driver for intel moore http://patchwork.kernel.org/patch/88738
Mar,28 2010: this patch is the 1.3mp camera (ov9665) sensor subdev driver fro inter http://patchwork.kernel.org/patch/88736
Mar,28 2010: this patch is the 5mp camera (ov5630) sensor subdev driver for intel m http://patchwork.kernel.org/patch/88737
Mar,28 2010: this patch is the 5mp camera (ov5630) sensor lens subdev driver for in http://patchwork.kernel.org/patch/88739
Mar,28 2010: this patch is the 5mp camera (s5k4e1) sensor subdev driver for intel m http://patchwork.kernel.org/patch/88740
Mar,28 2010: this patch is the make/kconfig files changes to enable the camera driv http://patchwork.kernel.org/patch/88741

		== Arm s5p patches waiting for more review at the ML == 

Apr,19 2010: [v1,1/3] ARM: S5P: Add FIMC driver platform helpers                    http://patchwork.kernel.org/patch/93460
Apr,19 2010: [v1,2/3] ARM: S5PC100: Add FIMC driver platform helpers                http://patchwork.kernel.org/patch/93466
Apr,19 2010: [v1,3/3] ARM: S5P: Add Camera interface (video postprocessor) driver   http://patchwork.kernel.org/patch/95064

		== Waiting for more DVB acks == 

May, 2 2010: Add FE_CAN_TURBO_FEC (was: Add FE_CAN_PSK_8 to allow apps to identify  http://patchwork.kernel.org/patch/96341

		== Waiting for my fixes on Docbook == 

Feb,25 2010: DocBook/Makefile: Make it less verbose                                 http://patchwork.kernel.org/patch/82076
Feb,25 2010: DocBook: Add rules to auto-generate some media docbooks                http://patchwork.kernel.org/patch/82075
Feb,25 2010: DocBook/v4l/pixfmt.xml: Add missing formats for gspca cpia1 and sn9c20 http://patchwork.kernel.org/patch/82074
Feb,25 2010: v4l: document new Bayer and monochrome pixel formats                   http://patchwork.kernel.org/patch/82073

		== Waiting for Antti Palosaari <crope@iki.fi> review == 

Mar,21 2010: af9015 : more robust eeprom parsing                                    http://patchwork.kernel.org/patch/87243

		== Waiting for Tobias Lorenz <tobias.lorenz@gmx.net> review == 

Feb, 3 2010: radio-si470x-common: -EINVAL overwritten in si470x_vidioc_s_tuner()    http://patchwork.kernel.org/patch/76786

		== Waiting for its addition at linux-firmware and driver test by David Wong <davidtlwong@gmail.com>  == 

Nov, 1 2009: lgs8gxx: remove firmware for lgs8g75                                   http://patchwork.kernel.org/patch/56822

		== Andy Walls <awalls@radix.net> and Aleksandr Piskunov <aleksandr.v.piskunov@gmail.com> are discussing around the solution == 

Oct,11 2009: AVerTV MCE 116 Plus radio                                              http://patchwork.kernel.org/patch/52981

		== Waiting for Andy Walls <awalls@md.metrocast.net> == 

Apr,10 2010: cx18: "missing audio" for analog recordings                            http://patchwork.kernel.org/patch/91879

		== Patches waiting for Patrick Boettcher <pboettcher@dibcom.fr> review == 

Jan,15 2010: remove obsolete conditionalizing on DVB_DIBCOM_DEBUG                   http://patchwork.kernel.org/patch/73147

		== Gspca patches - Waiting Hans de Goede <hdegoede@redhat.com> submission/review == 

Jan,29 2010: [gspca_jf,tree] gspca zc3xx: signal when unknown packet received       http://patchwork.kernel.org/patch/75837

		== Gspca patches - Waiting Jean-Francois Moine <moinejf@free.fr> submission/review == 

Feb,24 2010: gspca pac7302: add USB PID range based on heuristics                   http://patchwork.kernel.org/patch/81612
May, 3 2010: gspca: Try a less bandwidth-intensive alt setting.                     http://patchwork.kernel.org/patch/96514

		== soc_camera patches - Waiting Guennadi <g.liakhovetski@gmx.de> submission/review == 

Feb, 2 2010: [2/3] soc-camera: mt9t112: modify delay time after initialize          http://patchwork.kernel.org/patch/76213
Feb, 2 2010: [3/3] soc-camera: mt9t112: The flag which control camera-init is remov http://patchwork.kernel.org/patch/76214
Mar, 5 2010: [v2] V4L/DVB: mx1-camera: compile fix                                  http://patchwork.kernel.org/patch/83742
Apr,20 2010: pxa_camera: move fifo reset direct before dma start                    http://patchwork.kernel.org/patch/93619

		== Waiting for Steven Toth <stoth@kernellabs.com> comments on it == 

Feb, 6 2010: cx23885: Enable Message Signaled Interrupts(MSI).                      http://patchwork.kernel.org/patch/77492

		== Waiting for Henrik Kurelid <henrik@kurelid.se> comments about an userspace patch for MythTV == 

Mar, 1 2010: firedtv: add parameter to fake ca_system_ids in CA_INFO                http://patchwork.kernel.org/patch/82912

		== Videobuf patches - Need more tests before committing it - Volunteers? == 

Apr,21 2010: [v1, 1/2] v4l: videobuf: Add support for out-of-order buffer dequeuing http://patchwork.kernel.org/patch/93901
Apr,21 2010: [v1, 2/2] v4l: vivi: adapt to out-of-order buffer dequeuing in videobu http://patchwork.kernel.org/patch/93903

		== Waiting for Mike Isely <isely@isely.net> review == 

Apr,25 2010: Problem with cx25840 and Terratec Grabster AV400                       http://patchwork.kernel.org/patch/94960
Apr,27 2010: V4L: Events: Include slab.h explicitly                                 http://patchwork.kernel.org/patch/95449

		== Waiting for Igor M. Liplianin <liplianin@tut.by> comments/review == 

Mar,10 2010: DM1105: could not attach frontend 195d:1105                            http://patchwork.kernel.org/patch/84549

		== Need some fixes from Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de> == 

Mar,16 2010: mx1-camera: compile fix                                                http://patchwork.kernel.org/patch/86106

		== Patch(broken) Lock fixes. Patch is wrong but Siano has lock problems - Waiting for developers with time to fix it == 

Nov,12 2009: Locking in Siano driver (untested)                                     http://patchwork.kernel.org/patch/59590

		== Patch(broken) - waiting for Manu Abraham <abraham.manu@gmail.com> submission == 

Feb,16 2010: Twinhan 1027 + IR Port support                                         http://patchwork.kernel.org/patch/79753

		== Patch(broken) - waiting for Herton Ronaldo Krzesinski <herton@mandriva.com.br> new submission == 

Apr, 5 2010: saa7134: add support for Avermedia M733A                               http://patchwork.kernel.org/patch/90692
Mar,19 2010: saa7134: add support for one more remote control for Avermedia M135A   http://patchwork.kernel.org/patch/86989

Cheers,
Mauro

---

All patches sent to linux-media@vger.kernel.org are automatically stored at
Patchwork. The driver maintainer then analyzes it it and apply or reply
with comments. Others also may comment about it.

When the patch is is too trivial, or touches on a driver without a specific
maintainer, I analyze and apply it directly. Otherwise, it will be taged
as under review and the proper maintainer will be warned.

If you submitted or are waiting for the review of some patchset that weren't
applied at the git://git.kernel.org/v4l-dvb.git nor it is at the list bellow,
please check the status of the patch at the patchwork:
	http://patchwork.kernel.org/project/linux-media/list/

To check for a patch that is not New or Under Review, you'll need to click at
the "Filters" and pass some parameters to find the patch. Don't forget to
change the "State" to "any".

Eventually, your patch were rejected for some reason, or someone asked for
changes on it. If the patch is there, with a status different than
New/Under Review, double check for the received comments at the mailing list.
If it got Rejected, marked as RFC or as Changes Requested, please review it
according with the requests and send it again. In the very unlikely case
that the patch were wrongly tagged, please ping me.

If you discover any patch submitted via email that weren't caught by Patchwork,
this means that the patch got mangled by your emailer. The more likely
cause is that the emailer converted tabs into spaces or broke long lines.

If you're using Thunderbird, the solution is to install Asalted Patches
extension, available at:
	https://hg.mozilla.org/users/clarkbw_gnome.org/asalted-patches/
Other emailers will need you to disable the wrapping long lines feature.
