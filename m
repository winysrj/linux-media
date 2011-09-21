Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15721 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750711Ab1IUUom (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 21 Sep 2011 16:44:42 -0400
Message-ID: <4E7A4CA4.8040205@redhat.com>
Date: Wed, 21 Sep 2011 17:44:20 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: LMML <linux-media@vger.kernel.org>,
	Morimoto Kuninori <morimoto.kuninori@renesas.com>,
	Manu Abraham <abraham.manu@gmail.com>,
	Jarod Wilson <jarod@redhat.com>,
	Jean-Francois Moine <moinejf@free.fr>,
	Andy Walls <awalls@md.metrocast.net>,
	Hans de Goede <hdegoede@redhat.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Dmitri Belimov <d.belimov@gmail.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>,
	Pawel Osiak <pawel@osciak.co>
Subject: Re: Patches at patchwork.linuxtv.org (127 patches)
References: <4E7A4BA7.5050505@redhat.com>
In-Reply-To: <4E7A4BA7.5050505@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 21-09-2011 17:40, Mauro Carvalho Chehab escreveu:
> As announced on Sept, 18, we moved our patch queue to patchwork.linuxtv.org.
> 
> As we were without access to the old patchwork instance, I simply sent all
> emails I had locally stored on my local mahine to the new instance and reviewed
> all patches again. Basically, for old patches, I basically did some scripting
> that were marking old patches as "superseded", if they didn't apply anymore.
> I also preserved the patches that were marked as "under review" from patchwork
> time, using some scripting and a local control file.
> 
> So, we're basically close to what we had before kernel.org troubles (except for
> a series of patches that I've already applied today).
> 
> My intention is to finish review all patches marked as "new" until the end of this
> week, and set a new tree for linux-next with our stuff (as the old one were at
> git.kernel.org).
> 
> Please let me know if something is missed or if some patch from the list bellow
> is obsolete and can be marked with a different status.
> 
> Thanks!
> Mauro
> 
> 
> 		== New patches == 

Gah! forgot to update the URL on my script. the patch list with the right URL is:

		== New patches == 

Aug, 6 2011: [1/7] move ati_remote driver from input/misc to media/rc               http://patchwork.linuxtv.org/patch/255    Anssi Hannula <anssi.hannula@iki.fi>
Aug, 6 2011: [3/7] ati_remote: parent input devices to usb interface                http://patchwork.linuxtv.org/patch/251    Anssi Hannula <anssi.hannula@iki.fi>
Aug, 6 2011: [4/7] ati_remote: fix check for a weird byte                           http://patchwork.linuxtv.org/patch/253    Anssi Hannula <anssi.hannula@iki.fi>
Aug, 6 2011: [5/7] ati_remote: add keymap for Medion X10 RF remote                  http://patchwork.linuxtv.org/patch/250    Anssi Hannula <anssi.hannula@iki.fi>
Aug, 6 2011: [6/7] ati_remote: add support for SnapStream Firefly remote            http://patchwork.linuxtv.org/patch/252    Anssi Hannula <anssi.hannula@iki.fi>
Aug, 6 2011: [7/7] ati_remote: update Kconfig description                           http://patchwork.linuxtv.org/patch/254    Anssi Hannula <anssi.hannula@iki.fi>
Aug,20 2011: [2/6] Fix memory leak on disconnect or error.                          http://patchwork.linuxtv.org/patch/270    Chris Rankin <rankincj@yahoo.com>
Aug,20 2011: [1/2] EM28xx - fix race on disconnect                                  http://patchwork.linuxtv.org/patch/275    Chris Rankin <rankincj@yahoo.com>
Aug,20 2011: [2/2] EM28xx - fix deadlock when unplugging and replugging a DVB adapt http://patchwork.linuxtv.org/patch/276    Chris Rankin <rankincj@yahoo.com>
Aug,20 2011: [1/1] EM28xx - fix deadlock when unplugging and replugging a DVB adapt http://patchwork.linuxtv.org/patch/278    Chris Rankin <rankincj@yahoo.com>
Aug,21 2011: [1/1] EM28xx - fix deadlock when unplugging and replugging a DVB adapt http://patchwork.linuxtv.org/patch/279    Chris Rankin <rankincj@yahoo.com>
Aug,27 2011: OMAP_VOUT: Fix check in reqbuf & mmap for buf_size allocation          http://patchwork.linuxtv.org/patch/304    Archit Taneja <archit@ti.com>
Sep,16 2011: [1/5] : OMAP_VOUT: Fix check in reqbuf & mmap for buf_size allocation  http://patchwork.linuxtv.org/patch/353    Archit Taneja <archit@ti.com>
Sep,16 2011: [2/5] : OMAP_VOUT: CLEANUP: Remove redundant code from omap_vout_isr   http://patchwork.linuxtv.org/patch/354    Archit Taneja <archit@ti.com>
Aug, 4 2011: [21/21,staging] tm6000: Remove unnecessary workaround.                 http://patchwork.linuxtv.org/patch/7088   Thierry Reding <thierry.reding@avionic-design.de>
Aug, 5 2011: [1/1] Add driver support for ITE IT9135 device                         http://patchwork.linuxtv.org/patch/7090   jasondong <jason.dong@ite.com.tw>
May,23 2011: Alternate setting 1 must be selected for interface 0 on the model that http://patchwork.linuxtv.org/patch/7179   Hans Petter Selasky <hselasky@c2i.net>
Jul, 7 2011: V4L2: OMAP: VOUT: Changes to support NV12-color format on OMAP4        http://patchwork.linuxtv.org/patch/7414   Amber Jain <amber@ti.com>
Aug,19 2011: v4l: Add V4L2_PIX_FMT_NV24 and V4L2_PIX_FMT_NV42 formats               http://patchwork.linuxtv.org/patch/7630   Laurent Pinchart <Laurent Pinchart <laurent.pinchart@ideasonboard.com>>
Aug,27 2011: vp702x_fe_set_frontend+0x156/0x1a0 [dvb_usb_vp702x]                    http://patchwork.linuxtv.org/patch/7683   Florian Mickler <florian@mickler.org>
Aug,29 2011: [GIT,PULL,for,v3.1-rc] OMAP_VOUT: Fix build failure                    http://patchwork.linuxtv.org/patch/7687   Hiremath, Vaibhav <hvaibhav@ti.com>
Aug,29 2011: tvp5150: add v4l2 subdev pad ops                                       http://patchwork.linuxtv.org/patch/7700   Enrico <ebutera@users.berlios.de>
Aug,29 2011: [V4L2] decrement struct v4l2_device refcount on device unregister      http://patchwork.linuxtv.org/patch/7701   Maciej Szmigiero <mhej@o2.pl>
Aug,31 2011: TT CT-3650 CI support                                                  http://patchwork.linuxtv.org/patch/7732   
Sep, 4 2011: Medion 95700 analog video support                                      http://patchwork.linuxtv.org/patch/7767   Maciej Szmigiero <mhej@o2.pl>
Sep, 5 2011: Add support for PCTV452E.                                              http://patchwork.linuxtv.org/patch/7778   Oliver Freyermuth <o.freyermuth@googlemail.com>
Sep, 5 2011: BUG: unable to handle kernel paging request at 6b6b6bcb (v4l2_device_d http://patchwork.linuxtv.org/patch/7779   Sitsofe Wheeler <sitsofe@yahoo.com>
Sep, 6 2011: [v2] at91: add code to initialize and manage the ISI_MCK for Atmel ISI http://patchwork.linuxtv.org/patch/7780   Josh Wu <josh.wu@atmel.com>
Sep, 6 2011: [1/2,v5] media: Add support for arbitrary resolution                   http://patchwork.linuxtv.org/patch/7782   Bastian Hecht <hechtb@googlemail.com>
Sep, 6 2011: mt9p031: Do not use PLL if external frequency is the same as target fr http://patchwork.linuxtv.org/patch/7783   Javier Martin <javier.martin@vista-silicon.com>
Sep, 7 2011: [v2] omap3: ISP: Fix the failure of CCDC capture during suspend/resume http://patchwork.linuxtv.org/patch/7795   Abhilash K V <abhilash.kv@ti.com>
Sep,12 2011: [GIT,PULL,FOR,v3.1] v4l and uvcvideo fixes                             http://patchwork.linuxtv.org/patch/7835   Laurent Pinchart <Laurent Pinchart <laurent.pinchart@ideasonboard.com>>
Sep,17 2011: [v2] v4l: Add driver for Micron MT9M032 camera sensor                  http://patchwork.linuxtv.org/patch/7853   Martin Hostettler <martin@neutronstar.dyndns.org>
Sep,17 2011: [v2] arm: omap3evm: Add support for an MT9M032 based camera board.     http://patchwork.linuxtv.org/patch/7854   Martin Hostettler <martin@neutronstar.dyndns.org>
Sep,17 2011: [2/5] uvcvideo: Remove deprecated UVCIOC ioctls                        http://patchwork.linuxtv.org/patch/7855   Laurent Pinchart <Laurent Pinchart <laurent.pinchart@ideasonboard.com>>
Sep,17 2011: [3/5] media: Fix a UVC performance problem on systems with non-coheren http://patchwork.linuxtv.org/patch/7856   Al Cooper <alcooperx@gmail.com>
Sep,17 2011: [5/5] USB: export video.h to the includes available for userspace      http://patchwork.linuxtv.org/patch/7857   Marek Szyprowski <m.szyprowski@samsung.com>
Sep,17 2011: [4/5] uvcvideo: Add a mapping for H.264 payloads                       http://patchwork.linuxtv.org/patch/7858   Stephan Lachowsky <stephan.lachowsky@maxim-ic.com>
Sep,17 2011: [1/5] uvcvideo: Detect The Imaging Source CCD cameras by vendor and pr http://patchwork.linuxtv.org/patch/7859   Arne Caspari <arne@unicap-imaging.org>
Sep,18 2011: TT CT-3650 CI support                                                  http://patchwork.linuxtv.org/patch/7861   Jose Alberto Reguero <jareguero@telefonica.net>
Sep,18 2011: saa7134: introduce "std" module parameter to force video               http://patchwork.linuxtv.org/patch/7862   Stas Sergeev <stsp@users.sourceforge.net>
Sep,19 2011: [RESEND,1/4] davinci vpbe: remove unused macro.                        http://patchwork.linuxtv.org/patch/7863   Manjunath Hadli <manjunath.hadli@ti.com>
Sep,19 2011: [RESEND, 4/4] davinci vpbe: add VENC block changes to enable dm365 and http://patchwork.linuxtv.org/patch/7864   Manjunath Hadli <manjunath.hadli@ti.com>
Sep,19 2011: [RESEND,3/4] davinci vpbe: add dm365 and dm355 specific OSD changes    http://patchwork.linuxtv.org/patch/7865   Manjunath Hadli <manjunath.hadli@ti.com>
Sep,19 2011: [RESEND,2/4] davinci vpbe: add dm365 VPBE display driver changes       http://patchwork.linuxtv.org/patch/7866   Manjunath Hadli <manjunath.hadli@ti.com>
Sep,19 2011: [v2] v4l subdev: add dispatching for VIDIOC_DBG_G_REGISTER and VIDIOC_ http://patchwork.linuxtv.org/patch/7867   Martin Hostettler <martin@neutronstar.dyndns.org>
Sep,18 2011: v4l2: Add the parallel bus HREF and FIELD signal polarity              http://patchwork.linuxtv.org/patch/7868   Sylwester Nawrocki <s.nawrocki@samsung.com>
Sep,19 2011: [4/4,v2,FOR,3.1] v4l2: add blackfin capture bridge driver              http://patchwork.linuxtv.org/patch/7869   Scott Jiang <scott.jiang.linux@gmail.com>
Sep,19 2011: [1/4,v2,FOR,3.1] v4l2: add vb2_get_unmapped_area in vb2 core           http://patchwork.linuxtv.org/patch/7870   Scott Jiang <scott.jiang.linux@gmail.com>
Sep,19 2011: [3/4,v2,FOR,3.1] v4l2: add vs6624 sensor driver                        http://patchwork.linuxtv.org/patch/7871   Scott Jiang <scott.jiang.linux@gmail.com>
Sep,19 2011: [2/4,v2,FOR,3.1] v4l2: add adv7183 decoder driver                      http://patchwork.linuxtv.org/patch/7872   Scott Jiang <scott.jiang.linux@gmail.com>
Sep,19 2011: RC6 decoding                                                           http://patchwork.linuxtv.org/patch/7873   lawrence rust <lawrence@softsystem.co.uk>
Sep,19 2011: [v2,2/2] s5p-fimc: Convert to use generic media bus polarity flags     http://patchwork.linuxtv.org/patch/7874   Sylwester Nawrocki <s.nawrocki@samsung.com>
Sep,19 2011: [v2, 1/2] v4l2: Add the polarity flags for parallel camera bus FIELD s http://patchwork.linuxtv.org/patch/7875   Sylwester Nawrocki <s.nawrocki@samsung.com>
Sep,19 2011: [v3, 1/2] v4l2: Add the polarity flags for parallel camera bus FIELD s http://patchwork.linuxtv.org/patch/7876   Sylwester Nawrocki <s.nawrocki@samsung.com>
Sep,19 2011: [GIT,PATCHES,FOR,3.2] noon010pc30 conversion to the pad level ops      http://patchwork.linuxtv.org/patch/7877   Sylwester Nawrocki <s.nawrocki@samsung.com>
Sep,14 2011: Add smsspi driver to support Siano SPI connected                       http://patchwork.linuxtv.org/patch/7878   Doron Cohen <doronc@siano-ms.com>
Sep,15 2011: Add version number to all siano modules                                http://patchwork.linuxtv.org/patch/7879   Doron Cohen <doronc@siano-ms.com>
Sep,15 2011: Change debug prints and struct field names to be                       http://patchwork.linuxtv.org/patch/7880   Doron Cohen <doronc@siano-ms.com>
Sep,15 2011: Add support to new siano DSIO devices.                                 http://patchwork.linuxtv.org/patch/7881   Doron Cohen <doronc@siano-ms.com>
Sep,19 2011: Chnage smscoreapi.h definitions to match Siano FW                      http://patchwork.linuxtv.org/patch/7882   Doron Cohen <doronc@siano-ms.com>
Sep,19 2011: Support flexible endpoint numbering for various                        http://patchwork.linuxtv.org/patch/7883   Doron Cohen <doronc@siano-ms.com>
Sep,19 2011: Hide smscore data by making pointer NULL with                          http://patchwork.linuxtv.org/patch/7884   Doron Cohen <doronc@siano-ms.com>
Sep,19 2011: Improve debug capabilities by separating debug                         http://patchwork.linuxtv.org/patch/7885   Doron Cohen <doronc@siano-ms.com>
Sep,19 2011: Bug fix - DVB statistics were wrong since                              http://patchwork.linuxtv.org/patch/7886   Doron Cohen <doronc@siano-ms.com>
Sep,20 2011: Improve debug capabilities - add and change debug                      http://patchwork.linuxtv.org/patch/7887   Doron Cohen <doronc@siano-ms.com>
Sep,19 2011: Add support in various boards with SMS devices                         http://patchwork.linuxtv.org/patch/7888   Doron Cohen <doronc@siano-ms.com>
Sep,20 2011: Improve firmware load and reload mechanism in                          http://patchwork.linuxtv.org/patch/7889   Doron Cohen <doronc@siano-ms.com>
Sep,20 2011: Support big endian platform which uses SPI/I2C                         http://patchwork.linuxtv.org/patch/7890   Doron Cohen <doronc@siano-ms.com>
Sep,20 2011: Support platform which doesn't have                                    http://patchwork.linuxtv.org/patch/7891   Doron Cohen <doronc@siano-ms.com>
Sep,20 2011: Bug fix - waiting for free buffers might have                          http://patchwork.linuxtv.org/patch/7892   Doron Cohen <doronc@siano-ms.com>
Sep,20 2011: extern function smscore_send_last_fw_chunk to be                       http://patchwork.linuxtv.org/patch/7893   Doron Cohen <doronc@siano-ms.com>
Sep,20 2011: Automatically load client modules to make easier                       http://patchwork.linuxtv.org/patch/7894   Doron Cohen <doronc@siano-ms.com>
Sep,20 2011: [v1, 2/3] v4l: Add AUTO option for the V4L2_CID_POWER_LINE_FREQUENCY c http://patchwork.linuxtv.org/patch/7895   Sylwester Nawrocki <s.nawrocki@samsung.com>
Sep,20 2011: [v1,1/3] v4l: Extend V4L2_CID_COLORFX control with AQUA effect         http://patchwork.linuxtv.org/patch/7896   Sylwester Nawrocki <s.nawrocki@samsung.com>
Sep,20 2011: [v1,3/3] v4l: Add v4l2 subdev driver for S5K6AAFX sensor               http://patchwork.linuxtv.org/patch/7897   Sylwester Nawrocki <s.nawrocki@samsung.com>
Sep,20 2011: v4l: Move SR030PC30, NOON010PC30, M5MOLS drivers to the right location http://patchwork.linuxtv.org/patch/7898   Sylwester Nawrocki <s.nawrocki@samsung.com>
Sep,20 2011: m5mols: Remove superfluous irq field from the platform data struct     http://patchwork.linuxtv.org/patch/7899   Sylwester Nawrocki <s.nawrocki@samsung.com>
Sep,20 2011: [3/5] omap3evm: Add Camera board init/hookup file                      http://patchwork.linuxtv.org/patch/7900   Vaibhav Hiremath <hvaibhav@ti.com>
Sep,20 2011: [4/5] ispccdc: Configure CCDC_SYN_MODE register for UYVY8_2X8 and YUYV http://patchwork.linuxtv.org/patch/7901   Deepthy Ravi <deepthy.ravi@ti.com>
Sep,20 2011: [1/5] omap3evm: Enable regulators for camera interface                 http://patchwork.linuxtv.org/patch/7902   Vaibhav Hiremath <hvaibhav@ti.com>
Sep,20 2011: [5/5] omap2plus_defconfig: Enable omap3isp and MT9T111 sensor drivers  http://patchwork.linuxtv.org/patch/7903   Deepthy Ravi <deepthy.ravi@ti.com>
Sep,21 2011: [v4] noon010pc30: Conversion to the media controller API               http://patchwork.linuxtv.org/patch/7904   Sylwester Nawrocki <s.nawrocki@samsung.com>
Sep,21 2011: drivers/media/video/stk-webcam.c: webcam LED bug fix [IMPROVED]        http://patchwork.linuxtv.org/patch/7905   Arvydas Sidorenko <asido4@gmail.com>
Sep,21 2011: [1/3] fixup! mm: alloc_contig_freed_pages() added                      http://patchwork.linuxtv.org/patch/7906   Michal Nazarewicz <mina86@mina86.com>
Sep,21 2011: [GIT,PATCHES,FOR,3.2] noon010pc30 conversion to the pad (v2)           http://patchwork.linuxtv.org/patch/7907   Sylwester Nawrocki <s.nawrocki@samsung.com>
Sep,21 2011: [1/3] fixup! mm: alloc_contig_freed_pages() added                      http://patchwork.linuxtv.org/patch/7908   Michal Nazarewicz <mina86@mina86.com>
Sep,21 2011: [1/2] V4L: soc-camera: add a function to lookup xlate by mediabus code http://patchwork.linuxtv.org/patch/7909   Guennadi Liakhovetski <Guennadi Liakhovetski <g.liakhovetski@gmx.de>>
Sep,21 2011: [2/2] V4L: sh_mobile_ceu_camera: simplify scaling and cropping algorit http://patchwork.linuxtv.org/patch/7910   Guennadi Liakhovetski <Guennadi Liakhovetski <g.liakhovetski@gmx.de>>
Sep,21 2011: [v2, 1/2] v4l: Add AUTO option for the V4L2_CID_POWER_LINE_FREQUENCY c http://patchwork.linuxtv.org/patch/7912   Sylwester Nawrocki <s.nawrocki@samsung.com>
Sep,21 2011: [v2,2/2] v4l: Add v4l2 subdev driver for S5K6AAFX sensor               http://patchwork.linuxtv.org/patch/7913   Sylwester Nawrocki <s.nawrocki@samsung.com>

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

		== Patches for Hans Verkuil <hans.verkuil@cisco.com> check == 

Aug, 3 2010: [1/2] TVP7002: Return V4L2_DV_INVALID if any of the errors occur.      http://patchwork.linuxtv.org/patch/4064   Mats Randgaard <mats.randgaard@tandberg.com>
Aug, 3 2010: [2/2] TVP7002: Changed register values.                                http://patchwork.linuxtv.org/patch/4063   Mats Randgaard <mats.randgaard@tandberg.com>

		== Patches waiting Mauro Carvalho Chehab <mchehab@redhat.com> tests with mb86a20s/ISDB-T == 

May,19 2011: saa7134-dvb.c kworld_sbtvd                                             http://patchwork.linuxtv.org/patch/6649   Manoel PN <pinusdtv@hotmail.com>

		== Patches waiting for Hans de Goede <hdegoede@redhat.com> review == 

Jun, 4 2011: Increase max exposure value to 255 from 26.                            http://patchwork.linuxtv.org/patch/6850   Marco Diego Aurélio Mesquita <marcodiegomesquita@gmail.com>

		== Patches waiting for Jean-Francois Moine <moinejf@free.fr> review == 

Jul, 2 2011: [V2] gspca/zc3xx: add usb_id for HP Premium Starter Cam                http://patchwork.linuxtv.org/patch/7358   Wolfram Sang <w.sang@pengutronix.de>
Jul, 1 2011: gspca_sn9c20x: device 0c45:62b3: fix status LED                        http://patchwork.linuxtv.org/patch/114    Frank Schaefer <fschaefer.oss@googlemail.com>

		== Patches waiting for Guennadi Liakhovetski <g.liakhovetski@gmx.de> review == 

Jul,10 2011: [1/3] Add 8-bit and 16-bit YCrCb media bus pixel codes                 http://patchwork.linuxtv.org/patch/7423   Christian Gmeiner <christian.gmeiner@gmail.com>
Jul,12 2011: [1/5] mt9m111: set inital return values to zero                        http://patchwork.linuxtv.org/patch/7433   Michael Grzeschik <m.grzeschik@pengutronix.de>
Jul,12 2011: [3/5] mt9m111: move lastpage to struct mt9m111 for multi instances     http://patchwork.linuxtv.org/patch/7435   Michael Grzeschik <m.grzeschik@pengutronix.de>
Jul,12 2011: [5/5] mt9m111: make use of testpattern                                 http://patchwork.linuxtv.org/patch/7434   Michael Grzeschik <m.grzeschik@pengutronix.de>
Jun,24 2011: media: initial driver for ov5642 CMOS sensor                           http://patchwork.linuxtv.org/patch/7327   Bastian Hecht <hechtb@googlemail.com>
Jul, 6 2011: [REVIEW] adv7175 mbus support                                          http://patchwork.linuxtv.org/patch/7410   Christian Gmeiner <christian.gmeiner@gmail.com>
Jul,10 2011: [1/9] stringify: add HEX_STRING()                                      http://patchwork.linuxtv.org/patch/160    Randy Dunlap <rdunlap@xenotime.net>
Jul,12 2011: [2/5] mt9m111: fix missing return value check mt9m111_reg_clear        http://patchwork.linuxtv.org/patch/7432   Michael Grzeschik <m.grzeschik@pengutronix.de>
Jul,12 2011: [v4,4/5] mt9m111: rewrite set_pixfmt                                   http://patchwork.linuxtv.org/patch/7436   Michael Grzeschik <m.grzeschik@pengutronix.de>
Aug,24 2011: media i.MX27 camera: remove legacy dma support                         http://patchwork.linuxtv.org/patch/298    Sascha Hauer <s.hauer@pengutronix.de>

		== Patches waiting for Laurent Pinchart <laurent.pinchart@ideasonboard.com> review == 

Jun,22 2011: Improve UVC buffering with regard to USB. Add checks to avoid division http://patchwork.linuxtv.org/patch/7290   Hans Petter Selasky <hselasky@c2i.net>
Jul,11 2011: Error routes through omap3isp ccdc.                                    http://patchwork.linuxtv.org/patch/7428   Jonathan Cameron <jic23@cam.ac.uk>
Jul,12 2011: v4l: mem2mem: add wait_{prepare,finish} ops to m2m_testdev             http://patchwork.linuxtv.org/patch/7431   Michael Olbrich <m.olbrich@pengutronix.de>
Jul,14 2011: uvcvideo: add fix suspend/resume quirk for Microdia camera             http://patchwork.linuxtv.org/patch/186    Ming Lei <tom.leiming@gmail.com>
Jul,10 2011: [3/3] Make use of 8-bit and 16-bit YCrCb media bus pixel codes in adv7 http://patchwork.linuxtv.org/patch/7425   Christian Gmeiner <christian.gmeiner@gmail.com>
Jul,13 2011: [RFC, v1] mt9v113: VGA camera sensor driver and support for BeagleBoar http://patchwork.linuxtv.org/patch/184    Joel A Fernandes <agnel.joel@gmail.com>

		== Patches waiting for Sakari Ailus <sakari.ailus@maxwell.research.nokia.com> review == 

Aug,11 2011: adp1653: set media entity type                                         http://patchwork.linuxtv.org/patch/7100   Andy Shevchenko <andriy.shevchenko@linux.intel.com>

		== Patches for Andy Walls <Andy Walls <awalls@md.metrocast.net>> review == 

May,25 2011: ivtv: use display information in info not in var for panning           http://patchwork.linuxtv.org/patch/6706   Laurent Pinchart <laurent.pinchart@ideasonboard.com>

		== Waiting for Andy Walls <awalls@md.metrocast.net> double-check == 

Dec,19 2010: [RESEND, for, 2.6.37] cx23885, cx25840: Provide IR Rx timeout event re http://patchwork.linuxtv.org/patch/5133   Andy Walls <awalls@md.metrocast.net>

		== Waiting for Jarod Wilson <jarod@redhat.com> review == 

Apr,28 2011: [10/10] rc-core: move timeout and checks to lirc                       http://patchwork.linuxtv.org/patch/6468   David Härdeman <david@hardeman.nu>

		== Waiting for Pawel Osiak <pawel@osciak.co> review == 

Jul,14 2011: videobuf2: call buf_finish() on unprocessed buffers                    http://patchwork.linuxtv.org/patch/7443   Jonathan Corbet <corbet@lwn.net>

