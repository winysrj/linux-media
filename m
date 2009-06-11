Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:1560 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756462AbZFKXCJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 11 Jun 2009 19:02:09 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "Udo A. Steinberg" <udo@hypervisor.org>
Subject: Re: [v4l-dvb-maintainer] 2.6.30: missing audio device in bttv
Date: Fri, 12 Jun 2009 01:01:59 +0200
Cc: v4l-dvb-maintainer@linuxtv.org, linux-media@vger.kernel.org
References: <20090611221402.66709817@laptop.hypervisor.org> <200906112346.48528.hverkuil@xs4all.nl> <20090612003526.24f1213c@laptop.hypervisor.org>
In-Reply-To: <20090612003526.24f1213c@laptop.hypervisor.org>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_nzYMKfVUTDcxQ5v"
Message-Id: <200906120101.59458.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--Boundary-00=_nzYMKfVUTDcxQ5v
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Friday 12 June 2009 00:35:26 Udo A. Steinberg wrote:
> On Thu, 11 Jun 2009 23:46:48 +0200 Hans Verkuil (HV) wrote:
> 
> HV> Hmm, my patch needs a bit more work. But to get your setup working try to
> HV> revert the change you made and do just this:
> HV> 
> HV> Go to drivers/media/video/Makefile and move this line:
> HV> 
> HV> obj-$(CONFIG_VIDEO_MSP3400) += msp3400.o
> HV> 
> HV> in front of this line:
> HV> 
> HV> obj-$(CONFIG_VIDEO_BT848) += bt8xx/
> HV> 
> HV> Recompile and see if that is working.
> HV> 
> HV> I got the tveeprom error as well when I tested with ivtv, but I thought
> HV> that had something to do with the ivtv driver. Apparently not, so I need
> HV> to dig a bit more into these dependencies.
> 
> Switching those two lines seems to improve the dependencies for my setup.
> However, audio still does not work. Furthermore, switching channels in
> tvtime now hangs for up to 5 seconds. strace -r shows that it spends a lot
> of time in the second ioctl.
> 
> 0.000085 ioctl(4, VIDIOC_G_TUNER, 0xbfef1d70) = 0
> 0.000385 select(5, [4], NULL, NULL, {3, 0}) = 1 (in [4], left {2, 988069})
> 0.012006 ioctl(4, VIDIOC_DQBUF, 0xbfef1dc4) = 0
> 
> The current dmesg output is as follows:
> 
> bttv: driver version 0.9.18 loaded
> bttv: using 8 buffers with 2080k (520 pages) each for capture
> bttv: Bt8xx card found (0).
> bttv 0000:06:00.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
> bttv0: Bt878 (rev 2) at 0000:06:00.0, irq: 21, latency: 32, mmio: 0x50001000
> bttv0: detected: Hauppauge WinTV [card=10], PCI subsystem ID is 0070:13eb
> bttv0: using: Hauppauge (bt878) [card=10,autodetected]
> IRQ 21/bttv0: IRQF_DISABLED is not guaranteed on shared IRQs
> bttv0: gpio: en=00000000, out=00000000 in=00ffffdb [init]
> bttv0: Hauppauge/Voodoo msp34xx: reset line init [5]
> tveeprom 1-0050: Hauppauge model 37284, rev B221, serial# 3546046
> tveeprom 1-0050: tuner model is Philips FM1216 (idx 21, type 5)
> tveeprom 1-0050: TV standards PAL(B/G) (eeprom 0x04)
> tveeprom 1-0050: audio processor is MSP3410D (idx 5)
> tveeprom 1-0050: has radio
> bttv0: Hauppauge eeprom indicates model#37284
> bttv0: tuner type=5
> tuner 1-0042: chip found @ 0x84 (bt878 #0 [sw])
> tda9887 1-0042: creating new instance
> tda9887 1-0042: tda988[5/6/7] found
> tuner 1-0061: chip found @ 0xc2 (bt878 #0 [sw])
> tuner-simple 1-0061: creating new instance
> tuner-simple 1-0061: type set to 5 (Philips PAL_BG (FI1216 and compatibles))
> msp3400 1-0040: MSP3410D-B4 found @ 0x80 (bt878 #0 [sw])
> msp3400 1-0040: msp3400 supports nicam, mode is autodetect
> bttv0: registered device video0
> bttv0: registered device vbi0
> bttv0: registered device radio0

Hmm, this looks OK.

I've fixed the problem in my original patch. I've attached the new version.
It works fine with ivtv, the problems with reading the eeprom are now
fixed. Please test and if it still doesn't work then I'll have to install
my bttv card in my PC and test again. But that will be tomorrow evening.

BTW, it would be nice if you can confirm that everything is working fine
if you compile bttv as a module. Just to make sure that this is related
to the in-kernel build. The other person who had this problem (and who
had a very similar card) said that it was working after moving that line
in the Makefile.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom

--Boundary-00=_nzYMKfVUTDcxQ5v
Content-Type: text/x-diff;
  charset="iso-8859-15";
  name="2.6.30.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="2.6.30.diff"

--- drivers/media/video/Makefile.org	2009-06-11 21:51:05.000000000 +0200
+++ drivers/media/video/Makefile	2009-06-12 00:45:46.000000000 +0200
@@ -12,6 +12,8 @@
 
 videodev-objs	:=	v4l2-dev.o v4l2-ioctl.o v4l2-device.o
 
+# V4L2 core modules
+
 obj-$(CONFIG_VIDEO_DEV) += videodev.o v4l2-int-device.o
 ifeq ($(CONFIG_COMPAT),y)
   obj-$(CONFIG_VIDEO_DEV) += v4l2-compat-ioctl32.o
@@ -23,21 +25,15 @@
   obj-$(CONFIG_VIDEO_DEV) += v4l1-compat.o
 endif
 
-obj-$(CONFIG_VIDEO_TUNER) += tuner.o
+# All i2c modules must come first:
 
-obj-$(CONFIG_VIDEO_BT848) += bt8xx/
-obj-$(CONFIG_VIDEO_IR_I2C)  += ir-kbd-i2c.o
+obj-$(CONFIG_VIDEO_TUNER) += tuner.o
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
@@ -54,11 +50,40 @@
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
@@ -69,17 +94,7 @@
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
@@ -92,19 +107,12 @@
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
@@ -134,24 +142,21 @@
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
 
 obj-$(CONFIG_USB_VIDEO_CLASS)	+= uvc/
 
+obj-$(CONFIG_VIDEO_IR_I2C)  += ir-kbd-i2c.o
+
 EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core
 EXTRA_CFLAGS += -Idrivers/media/dvb/frontends
 EXTRA_CFLAGS += -Idrivers/media/common/tuners

--Boundary-00=_nzYMKfVUTDcxQ5v--
