Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:1433 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164AbZFKUXA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jun 2009 16:23:00 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: v4l-dvb-maintainer@linuxtv.org
Subject: Re: [v4l-dvb-maintainer] 2.6.30: missing audio device in bttv
Date: Thu, 11 Jun 2009 22:22:50 +0200
Cc: "Udo A. Steinberg" <udo@hypervisor.org>,
	linux-media@vger.kernel.org
References: <20090611221402.66709817@laptop.hypervisor.org> <200906112218.11016.hverkuil@xs4all.nl>
In-Reply-To: <200906112218.11016.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_aeWMK7BgdVkNTfn"
Message-Id: <200906112222.50283.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Boundary-00=_aeWMK7BgdVkNTfn
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Thursday 11 June 2009 22:18:10 Hans Verkuil wrote:
> On Thursday 11 June 2009 22:14:02 Udo A. Steinberg wrote:
> > Hi all,
> > 
> > With Linux 2.6.30 the BTTV driver for my WinTV card claims
> > 
> > 	bttv0: audio absent, no audio device found!
> > 
> > and audio does not work. This worked up to and including 2.6.29. Is this a
> > known issue? Does anyone have a fix or a patch for me to try?
> 
> You've no doubt compiled the bttv driver into the kernel and not as a module.
> 
> I've just pushed a fix for this to my tree: http://www.linuxtv.org/hg/~hverkuil/v4l-dvb

I've also attached a diff against 2.6.30 since the patch in my tree is against
the newer v4l-dvb repository and doesn't apply cleanly against 2.6.30.

	Hans


-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom

--Boundary-00=_aeWMK7BgdVkNTfn
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="2.6.30.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="2.6.30.diff"

--- drivers/media/video/Makefile.org	2009-06-11 21:51:05.000000000 +0200
+++ drivers/media/video/Makefile	2009-06-11 21:54:48.000000000 +0200
@@ -12,6 +12,8 @@
 
 videodev-objs	:=	v4l2-dev.o v4l2-ioctl.o v4l2-device.o
 
+# V4L2 core modules
+
 obj-$(CONFIG_VIDEO_DEV) += videodev.o v4l2-int-device.o
 ifeq ($(CONFIG_COMPAT),y)
   obj-$(CONFIG_VIDEO_DEV) += v4l2-compat-ioctl32.o
@@ -23,21 +25,16 @@
   obj-$(CONFIG_VIDEO_DEV) += v4l1-compat.o
 endif
 
-obj-$(CONFIG_VIDEO_TUNER) += tuner.o
+# All i2c modules must come first:
 
-obj-$(CONFIG_VIDEO_BT848) += bt8xx/
+obj-$(CONFIG_VIDEO_TUNER) += tuner.o
 obj-$(CONFIG_VIDEO_IR_I2C)  += ir-kbd-i2c.o
 obj-$(CONFIG_VIDEO_TVAUDIO) += tvaudio.o
 obj-$(CONFIG_VIDEO_TDA7432) += tda7432.o
 obj-$(CONFIG_VIDEO_TDA9875) += tda9875.o
-
 obj-$(CONFIG_VIDEO_SAA6588) += saa6588.o
 obj-$(CONFIG_VIDEO_SAA5246A) += saa5246a.o
 obj-$(CONFIG_VIDEO_SAA5249) += saa5249.o
-obj-$(CONFIG_VIDEO_CQCAM) += c-qcam.o
-obj-$(CONFIG_VIDEO_BWQCAM) += bw-qcam.o
-obj-$(CONFIG_VIDEO_W9966) += w9966.o
-
 obj-$(CONFIG_VIDEO_TDA9840) += tda9840.o
 obj-$(CONFIG_VIDEO_TEA6415C) += tea6415c.o
 obj-$(CONFIG_VIDEO_TEA6420) += tea6420.o
@@ -54,11 +51,40 @@
 obj-$(CONFIG_VIDEO_BT856) += bt856.o
 obj-$(CONFIG_VIDEO_BT866) += bt866.o
 obj-$(CONFIG_VIDEO_KS0127) += ks0127.o
+obj-$(CONFIG_VIDEO_VINO) += indycam.o
+obj-$(CONFIG_VIDEO_TVP5150) += tvp5150.o
+obj-$(CONFIG_VIDEO_TVP514X) += tvp514x.o
+obj-$(CONFIG_VIDEO_MSP3400) += msp3400.o
+obj-$(CONFIG_VIDEO_CS5345) += cs5345.o
+obj-$(CONFIG_VIDEO_CS53L32A) += cs53l32a.o
+obj-$(CONFIG_VIDEO_M52790) += m52790.o
+obj-$(CONFIG_VIDEO_TLV320AIC23B) += tlv320aic23b.o
+obj-$(CONFIG_VIDEO_WM8775) += wm8775.o
+obj-$(CONFIG_VIDEO_WM8739) += wm8739.o
+obj-$(CONFIG_VIDEO_VP27SMPX) += vp27smpx.o
+obj-$(CONFIG_VIDEO_CX25840) += cx25840/
+obj-$(CONFIG_VIDEO_UPD64031A) += upd64031a.o
+obj-$(CONFIG_VIDEO_UPD64083) += upd64083.o
+obj-$(CONFIG_VIDEO_OV7670) 	+= ov7670.o
+obj-$(CONFIG_VIDEO_TCM825X) += tcm825x.o
+obj-$(CONFIG_VIDEO_TVEEPROM) += tveeprom.o
 
-obj-$(CONFIG_VIDEO_ZORAN) += zoran/
+obj-$(CONFIG_SOC_CAMERA_MT9M001)	+= mt9m001.o
+obj-$(CONFIG_SOC_CAMERA_MT9M111)	+= mt9m111.o
+obj-$(CONFIG_SOC_CAMERA_MT9T031)	+= mt9t031.o
+obj-$(CONFIG_SOC_CAMERA_MT9V022)	+= mt9v022.o
+obj-$(CONFIG_SOC_CAMERA_OV772X)		+= ov772x.o
+obj-$(CONFIG_SOC_CAMERA_TW9910)		+= tw9910.o
 
+# And now the v4l2 drivers:
+
+obj-$(CONFIG_VIDEO_BT848) += bt8xx/
+obj-$(CONFIG_VIDEO_ZORAN) += zoran/
+obj-$(CONFIG_VIDEO_CQCAM) += c-qcam.o
+obj-$(CONFIG_VIDEO_BWQCAM) += bw-qcam.o
+obj-$(CONFIG_VIDEO_W9966) += w9966.o
 obj-$(CONFIG_VIDEO_PMS) += pms.o
-obj-$(CONFIG_VIDEO_VINO) += vino.o indycam.o
+obj-$(CONFIG_VIDEO_VINO) += vino.o
 obj-$(CONFIG_VIDEO_STRADIS) += stradis.o
 obj-$(CONFIG_VIDEO_CPIA) += cpia.o
 obj-$(CONFIG_VIDEO_CPIA_PP) += cpia_pp.o
@@ -69,17 +95,7 @@
 obj-$(CONFIG_VIDEO_EM28XX) += em28xx/
 obj-$(CONFIG_VIDEO_CX231XX) += cx231xx/
 obj-$(CONFIG_VIDEO_USBVISION) += usbvision/
-obj-$(CONFIG_VIDEO_TVP5150) += tvp5150.o
-obj-$(CONFIG_VIDEO_TVP514X) += tvp514x.o
 obj-$(CONFIG_VIDEO_PVRUSB2) += pvrusb2/
-obj-$(CONFIG_VIDEO_MSP3400) += msp3400.o
-obj-$(CONFIG_VIDEO_CS5345) += cs5345.o
-obj-$(CONFIG_VIDEO_CS53L32A) += cs53l32a.o
-obj-$(CONFIG_VIDEO_M52790) += m52790.o
-obj-$(CONFIG_VIDEO_TLV320AIC23B) += tlv320aic23b.o
-obj-$(CONFIG_VIDEO_WM8775) += wm8775.o
-obj-$(CONFIG_VIDEO_WM8739) += wm8739.o
-obj-$(CONFIG_VIDEO_VP27SMPX) += vp27smpx.o
 obj-$(CONFIG_VIDEO_OVCAMCHIP) += ovcamchip/
 obj-$(CONFIG_VIDEO_CPIA2) += cpia2/
 obj-$(CONFIG_VIDEO_MXB) += mxb.o
@@ -92,19 +108,12 @@
 obj-$(CONFIG_VIDEOBUF_VMALLOC) += videobuf-vmalloc.o
 obj-$(CONFIG_VIDEOBUF_DVB) += videobuf-dvb.o
 obj-$(CONFIG_VIDEO_BTCX)  += btcx-risc.o
-obj-$(CONFIG_VIDEO_TVEEPROM) += tveeprom.o
 
 obj-$(CONFIG_VIDEO_M32R_AR_M64278) += arv.o
 
-obj-$(CONFIG_VIDEO_CX25840) += cx25840/
-obj-$(CONFIG_VIDEO_UPD64031A) += upd64031a.o
-obj-$(CONFIG_VIDEO_UPD64083) += upd64083.o
 obj-$(CONFIG_VIDEO_CX2341X) += cx2341x.o
 
 obj-$(CONFIG_VIDEO_CAFE_CCIC) += cafe_ccic.o
-obj-$(CONFIG_VIDEO_OV7670) 	+= ov7670.o
-
-obj-$(CONFIG_VIDEO_TCM825X) += tcm825x.o
 
 obj-$(CONFIG_USB_DABUSB)        += dabusb.o
 obj-$(CONFIG_USB_OV511)         += ov511.o
@@ -134,19 +143,14 @@
 obj-$(CONFIG_VIDEO_VIVI) += vivi.o
 obj-$(CONFIG_VIDEO_CX23885) += cx23885/
 
+obj-$(CONFIG_VIDEO_OMAP2)		+= omap2cam.o
+obj-$(CONFIG_SOC_CAMERA)		+= soc_camera.o
+obj-$(CONFIG_SOC_CAMERA_PLATFORM)	+= soc_camera_platform.o
+# soc-camera host drivers have to be linked after camera drivers
 obj-$(CONFIG_VIDEO_MX1)			+= mx1_camera.o
 obj-$(CONFIG_VIDEO_MX3)			+= mx3_camera.o
 obj-$(CONFIG_VIDEO_PXA27x)		+= pxa_camera.o
 obj-$(CONFIG_VIDEO_SH_MOBILE_CEU)	+= sh_mobile_ceu_camera.o
-obj-$(CONFIG_VIDEO_OMAP2)		+= omap2cam.o
-obj-$(CONFIG_SOC_CAMERA)		+= soc_camera.o
-obj-$(CONFIG_SOC_CAMERA_MT9M001)	+= mt9m001.o
-obj-$(CONFIG_SOC_CAMERA_MT9M111)	+= mt9m111.o
-obj-$(CONFIG_SOC_CAMERA_MT9T031)	+= mt9t031.o
-obj-$(CONFIG_SOC_CAMERA_MT9V022)	+= mt9v022.o
-obj-$(CONFIG_SOC_CAMERA_OV772X)		+= ov772x.o
-obj-$(CONFIG_SOC_CAMERA_PLATFORM)	+= soc_camera_platform.o
-obj-$(CONFIG_SOC_CAMERA_TW9910)		+= tw9910.o
 
 obj-$(CONFIG_VIDEO_AU0828) += au0828/
 

--Boundary-00=_aeWMK7BgdVkNTfn--
