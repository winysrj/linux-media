Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13221 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751491Ab0GFRdp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 6 Jul 2010 13:33:45 -0400
Message-ID: <4C336863.80508@redhat.com>
Date: Tue, 06 Jul 2010 14:31:15 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: LMML <linux-media@vger.kernel.org>, awalls@md.metrocast.net,
	moinejf@free.fr, g.liakhovetski@gmx.de, jarod@redhat.com,
	corbet@lwn.net, rz@linux-m68k.org, pboettcher@dibcom.fr,
	awalls@radix.net, crope@iki.fi, davidtlwong@gmail.com,
	laurent.pinchart@ideasonboard.com, eduardo.valentin@nokia.com,
	p.osciak@samsung.com, liplianin@tut.by, isely@isely.net,
	tobias.lorenz@gmx.net, hdegoede@redhat.com,
	u.kleine-koenig@pengutronix.de, abraham.manu@gmail.com,
	stoth@kernellabs.com, henrik@kurelid.se
Subject: Re: Status of the patches under review at LMML (60 patches)
References: <4C332A5F.4000706@redhat.com> <20100706082146.598976e9.randy.dunlap@oracle.com>
In-Reply-To: <20100706082146.598976e9.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 06-07-2010 12:21, Randy Dunlap escreveu:
> On Tue, 06 Jul 2010 10:06:39 -0300 Mauro Carvalho Chehab wrote:
> 
>> This is the summary of the patches that are currently under review at 
>> Linux Media Mailing List <linux-media@vger.kernel.org>.
>> Each patch is represented by its submission date, the subject (up to 70
>> chars) and the patchwork link (if submitted via email).
>>
>> P.S.: This email is c/c to the developers where some action is expected.
>>       If you were copied, please review the patches, acking/nacking or
>>       submitting an update.
>>
>> 		== New patches - waiting for some days for more review == 
>>
>> Jul, 1 2010: v4l2-dev: fix memory leak                                              http://patchwork.kernel.org/patch/109191
>> Jul, 5 2010: soc-camera: module_put() fix                                           http://patchwork.kernel.org/patch/110202
>> Jul, 4 2010: IR/mceusb: unify and simplify different gen device init                http://patchwork.kernel.org/patch/110078
>> Jul, 6 2010: [1/2] Added Technisat Skystar USB HD CI                                http://patchwork.kernel.org/patch/110395
>> Jul, 6 2010: [2/2] Retrieve firmware for az6027                                     http://patchwork.kernel.org/patch/110394
> 
> 
> Hi Mauro,
> Is it possible to add Author (or From:) to each of these?

It is easier to just modify the script that generates the email ;)

Ok, that's the updated list of patches (52 patches). I've updated the stuff at
patchwork to reflect the recent comments I received so far. 

Also, one of the new patches got merged. 

Cheers,
Mauro.

---

		== New patches == 

Jul, 1 2010: v4l2-dev: fix memory leak                                              http://patchwork.kernel.org/patch/109191  Anatolij Gustschin <agust@denx.de>
Jul, 5 2010: soc-camera: module_put() fix                                           http://patchwork.kernel.org/patch/110202  Magnus Damm <damm@opensource.se>
Jul, 6 2010: [2/2] Retrieve firmware for az6027                                     http://patchwork.kernel.org/patch/110394  Renzo Dani <arons7@gmail.com>
Jul, 6 2010: [1/2] Added Technisat Skystar USB HD CI                                http://patchwork.kernel.org/patch/110395  Renzo Dani <arons7@gmail.com>

		== Need more tests/acks from DVB users == 

Jun,27 2010: Avoid unnecessary data copying inside dvb_dmx_swfilter_204() function  http://patchwork.kernel.org/patch/108274  Marko Ristola <marko.ristola@kolumbus.fi>

		== Better to wait for videobuf changes == 

Mar,17 2010: [2/2] V4L/DVB: buf-dma-sg.c: support non-pageable user-allocated memor http://patchwork.kernel.org/patch/97263   Arnout Vandecappelle <arnout@mind.be>
May,26 2010: [1/2] media: Add timberdale video-in driver                            http://patchwork.kernel.org/patch/102414  Richard Röjfors <richard.rojfors@pelagicore.com>

		== Waiting for a new version from Jonathan Corbet <corbet@lwn.net> == 

Jun, 7 2010: Add the viafb video capture driver                                     http://patchwork.kernel.org/patch/104840  Jonathan Corbet <corbet@lwn.net>

		== Depends on input get_bigkeycode stuff that got postponed == 

May,20 2010: input: fix error at the default input_get_keycode call                 http://patchwork.kernel.org/patch/101122  Mauro Carvalho Chehab <mchehab@redhat.com>

		== Waiting for Pawel Osciak <p.osciak@samsung.com> comments == 

Jun,16 2010: [1/7] ARM: Samsung: Add FIMC driver register definition and platform h http://patchwork.kernel.org/patch/106457  Sylwester Nawrocki <s.nawrocki@samsung.com>
Jun,16 2010: [2/7] ARM: Samsung: Add platform definitions for local FIMC/FIMD fifo  http://patchwork.kernel.org/patch/106459  Marek Szyprowski <m.szyprowski@samsung.com>
Jun,16 2010: [3/7] s3c-fb: Add v4l2 subdevice to support framebuffer local fifo inp http://patchwork.kernel.org/patch/106445  Sylwester Nawrocki <s.nawrocki@samsung.com>
Jun,16 2010: [4/7] v4l: Add Samsung FIMC (video postprocessor) driver               http://patchwork.kernel.org/patch/106448  Sylwester Nawrocki <s.nawrocki@samsung.com>
Jun,16 2010: [5/7] ARM: S5PV210: Add fifo link definitions for fimc and framebuffer http://patchwork.kernel.org/patch/106447  Marek Szyprowski <m.szyprowski@samsung.com>
Jun,16 2010: [6/7] ARM: S5PV210: enable FIMC on Aquila                              http://patchwork.kernel.org/patch/106449  Sylwester Nawrocki <s.nawrocki@samsung.com>
Jun,16 2010: [7/7] ARM: S5PC100: enable FIMC on SMDKC100                            http://patchwork.kernel.org/patch/106454  Sylwester Nawrocki <s.nawrocki@samsung.com>
Jun,28 2010: v4l: mem2mem_testdev: fix g_fmt NULL pointer dereference               http://patchwork.kernel.org/patch/108321  Pawel Osciak <p.osciak@samsung.com>

		== Soc_camera waiting for Guennadi Liakhovetski <g.liakhovetski@gmx.de> review == 

May,11 2010: [v3] soc_camera_platform: Add necessary v4l2_subdev_video_ops method   http://patchwork.kernel.org/patch/98660   Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

		== lmml_107126_patchv4_1_3_mx2_camera_add_soc_camera_support_for_i_mx25_i_mx27.patch == 

Jun,21 2010: mx27: add support for the CSI device                                   http://patchwork.kernel.org/patch/107124  Baruch Siach <baruch@tkos.co.il>
Jun,21 2010: mx25: add support for the CSI device                                   http://patchwork.kernel.org/patch/107125  Baruch Siach <baruch@tkos.co.il>
Jul, 4 2010: mx2_camera: Add soc_camera support for i.MX25/i.MX27                   http://patchwork.kernel.org/patch/110090  Baruch Siach <baruch@tkos.co.il>

		== mantis patches - waiting for Manu Abraham <abraham.manu@gmail.com> == 

Apr,15 2010: [5/8] ir-core: convert mantis from ir-functions.c                      http://patchwork.kernel.org/patch/92961   David Härdeman <david@hardeman.nu>
Jun,11 2010: stb0899: Removed an extra byte sent at init on DiSEqC bus              http://patchwork.kernel.org/patch/105621  Florent AUDEBERT <florent.audebert@anevia.com>
Jun,20 2010: Mantis DMA transfer cleanup, fixes data corruption and a race, improve http://patchwork.kernel.org/patch/107036  Marko Ristola <marko.ristola@kolumbus.fi>
Jun,20 2010: Mantis: append tasklet maintenance for DVB stream delivery             http://patchwork.kernel.org/patch/107055  Marko Ristola <marko.ristola@kolumbus.fi>
Jun,20 2010: [2/2] DVB/V4L: mantis: remove unused files                             http://patchwork.kernel.org/patch/107062  Bjørn Mork <bjorn@mork.no>
Jun,20 2010: mantis: use dvb_attach to avoid double dereferencing on module removal http://patchwork.kernel.org/patch/107063  Bjørn Mork <bjorn@mork.no>
Jun,21 2010: Mantis, hopper: use MODULE_DEVICE_TABLE use the macro to make modules  http://patchwork.kernel.org/patch/107147  Manu Abraham <abraham.manu@gmail.com>
Jul, 3 2010: mantis: Rename gpio_set_bits to mantis_gpio_set_bits                   http://patchwork.kernel.org/patch/109972  Ben Hutchings <ben@decadent.org.uk>

		== Waiting for my fixes on Docbook == 

Feb,25 2010: DocBook/Makefile: Make it less verbose                                 http://patchwork.kernel.org/patch/82076   Mauro Carvalho Chehab <mchehab@redhat.com>
Feb,25 2010: DocBook: Add rules to auto-generate some media docbooks                http://patchwork.kernel.org/patch/82075   Mauro Carvalho Chehab <mchehab@redhat.com>
Feb,25 2010: DocBook/v4l/pixfmt.xml: Add missing formats for gspca cpia1 and sn9c20 http://patchwork.kernel.org/patch/82074   Mauro Carvalho Chehab <mchehab@redhat.com>
Feb,25 2010: v4l: document new Bayer and monochrome pixel formats                   http://patchwork.kernel.org/patch/82073   Mauro Carvalho Chehab <mchehab@redhat.com>

		== Waiting for Antti Palosaari <crope@iki.fi> review == 

Mar,21 2010: af9015 : more robust eeprom parsing                                    http://patchwork.kernel.org/patch/87243   matthieu castet <castet.matthieu@free.fr>
May,20 2010: New NXP tda18218 tuner                                                 http://patchwork.kernel.org/patch/101170  Nikola Pajkovsky <npajkovs@redhat.com>

		== Waiting for Tobias Lorenz <tobias.lorenz@gmx.net> review == 

Feb, 3 2010: radio-si470x-common: -EINVAL overwritten in si470x_vidioc_s_tuner()    http://patchwork.kernel.org/patch/76786   Roel Kluin <roel.kluin@gmail.com>

		== Waiting for its addition at linux-firmware and driver test by David Wong <davidtlwong@gmail.com>  == 

Nov, 1 2009: lgs8gxx: remove firmware for lgs8g75                                   http://patchwork.kernel.org/patch/56822   Ben Hutchings <ben@decadent.org.uk>

		== Andy Walls <awalls@radix.net> and Aleksandr Piskunov <aleksandr.v.piskunov@gmail.com> are discussing around the solution == 

Oct,11 2009: AVerTV MCE 116 Plus radio                                              http://patchwork.kernel.org/patch/52981   Aleksandr V. Piskunov <aleksandr.v.piskunov@gmail.com>

		== Waiting for Andy Walls <awalls@md.metrocast.net> == 

Apr,10 2010: cx18: "missing audio" for analog recordings                            http://patchwork.kernel.org/patch/91879   Mark Lord <mlord@pobox.com>

		== Patches waiting for Patrick Boettcher <pboettcher@dibcom.fr> review == 

Jan,15 2010: remove obsolete conditionalizing on DVB_DIBCOM_DEBUG                   http://patchwork.kernel.org/patch/73147   Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
May,25 2010: Adding support to the Geniatech/MyGica SBTVD Stick S870 remote control http://patchwork.kernel.org/patch/102314  Hernán Ordiales <h.ordiales@gmail.com>

		== Gspca patches - Waiting Hans de Goede <hdegoede@redhat.com> submission/review == 

Jan,29 2010: [gspca_jf,tree] gspca zc3xx: signal when unknown packet received       http://patchwork.kernel.org/patch/75837   Németh Márton <nm127@freemail.hu>

		== Waiting for Henrik Kurelid <henrik@kurelid.se> comments about an userspace patch for MythTV == 

Mar, 1 2010: firedtv: add parameter to fake ca_system_ids in CA_INFO                http://patchwork.kernel.org/patch/82912   Henrik Kurelid <henrik@kurelid.se>

		== Waiting for Mike Isely <isely@isely.net> review == 

Apr,25 2010: Problem with cx25840 and Terratec Grabster AV400                       http://patchwork.kernel.org/patch/94960   Sven Barth <pascaldragon@googlemail.com>

		== Waiting for Igor M. Liplianin <liplianin@tut.by> comments/review == 

Mar,10 2010: DM1105: could not attach frontend 195d:1105                            http://patchwork.kernel.org/patch/84549   Hendrik Skarpeid <skarp@online.no>

		== Need some fixes from Uwe Kleine-Koenig <u.kleine-koenig@pengutronix.de> == 

Mar,16 2010: mx1-camera: compile fix                                                http://patchwork.kernel.org/patch/86106   Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

		== Waiting for Signed-off-by from Richard Zidlicky <rz@linux-m68k.org> == 

Jun,15 2010: support for Hauppauge WinTV MiniStic IR remote                         http://patchwork.kernel.org/patch/106247  Richard Zidlicky <rz@linux-m68k.org>

		== Waiting for Eduardo Valentin <eduardo.valentin@nokia.com> review == 

Jun,13 2010: [1/2] V4L/DVB: radio-si4713: Release i2c adapter in driver cleanup pat http://patchwork.kernel.org/patch/105846  Jarkko Nikula <jhnikula@gmail.com>
Jun,13 2010: [2/2] V4L/DVB: radio-si4713: Add regulator framework support           http://patchwork.kernel.org/patch/105847  Jarkko Nikula <jhnikula@gmail.com>

		== Waiting for Jarod Wilson <jarod@redhat.com> review/ack == 

Jun,20 2010: drivers/media/IR/imon.c: Use pr_err instead of err                     http://patchwork.kernel.org/patch/107025  Joe Perches <joe@perches.com>

		== Patch(broken) - waiting for Manu Abraham <abraham.manu@gmail.com> submission == 

Feb,16 2010: Twinhan 1027 + IR Port support                                         http://patchwork.kernel.org/patch/79753   Sergey Ivanov <123kash@gmail.com>

		== Patches under review == 

Nov,12 2009: Locking in Siano driver (untested)                                     http://patchwork.kernel.org/patch/59590   Tim Borgeaud <tim@tangobravo.co.uk>
