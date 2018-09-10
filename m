Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:53488 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728603AbeIJRNU (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 10 Sep 2018 13:13:20 -0400
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 1/3] media: use strscpy() instead of strlcpy()
Date: Mon, 10 Sep 2018 08:19:14 -0400
Message-Id: <8984cbc7c4af93f8449c5af1cd9b26b620d4fb9f.1536581757.git.mchehab+samsung@kernel.org>
In-Reply-To: <cover.1536581757.git.mchehab+samsung@kernel.org>
References: <cover.1536581757.git.mchehab+samsung@kernel.org>
In-Reply-To: <cover.1536581757.git.mchehab+samsung@kernel.org>
References: <cover.1536581757.git.mchehab+samsung@kernel.org>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The implementation of strscpy() is more robust and safer.

That's now the recommended way to copy NUL terminated strings.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/cec/cec-api.c                   |  4 +-
 drivers/media/cec/cec-core.c                  |  2 +-
 drivers/media/common/b2c2/flexcop-i2c.c       | 12 ++---
 drivers/media/common/cx2341x.c                |  2 +-
 drivers/media/common/saa7146/saa7146_fops.c   |  2 +-
 drivers/media/common/saa7146/saa7146_video.c  |  6 +--
 drivers/media/common/siano/smscoreapi.c       |  4 +-
 drivers/media/common/siano/smsir.c            |  2 +-
 drivers/media/dvb-core/dvb_vb2.c              |  2 +-
 drivers/media/dvb-core/dvbdev.c               |  4 +-
 drivers/media/dvb-frontends/cx24123.c         |  2 +-
 drivers/media/dvb-frontends/cxd2820r_core.c   |  2 +-
 drivers/media/dvb-frontends/dibx000_common.c  |  2 +-
 drivers/media/dvb-frontends/lgdt330x.c        |  2 +-
 drivers/media/dvb-frontends/m88ds3103.c       |  2 +-
 drivers/media/dvb-frontends/rtl2832_sdr.c     | 10 ++--
 drivers/media/dvb-frontends/s5h1420.c         |  2 +-
 drivers/media/dvb-frontends/tc90522.c         |  2 +-
 drivers/media/dvb-frontends/ts2020.c          |  2 +-
 drivers/media/dvb-frontends/zd1301_demod.c    |  3 +-
 drivers/media/i2c/cs53l32a.c                  |  2 +-
 drivers/media/i2c/imx274.c                    |  2 +-
 drivers/media/i2c/m5mols/m5mols_core.c        |  2 +-
 drivers/media/i2c/max2175.c                   |  2 +-
 drivers/media/i2c/msp3400-driver.c            |  2 +-
 drivers/media/i2c/noon010pc30.c               |  2 +-
 drivers/media/i2c/ov9650.c                    |  2 +-
 drivers/media/i2c/s5c73m3/s5c73m3-core.c      |  2 +-
 drivers/media/i2c/s5k4ecgx.c                  |  2 +-
 drivers/media/i2c/s5k6aa.c                    |  2 +-
 drivers/media/i2c/saa7115.c                   |  6 +--
 drivers/media/i2c/saa7127.c                   |  4 +-
 drivers/media/i2c/tvaudio.c                   |  2 +-
 drivers/media/i2c/video-i2c.c                 |  8 +--
 drivers/media/media-device.c                  | 28 +++++-----
 drivers/media/pci/bt8xx/bttv-driver.c         |  6 +--
 drivers/media/pci/bt8xx/bttv-i2c.c            |  6 +--
 drivers/media/pci/bt8xx/bttv-input.c          |  2 +-
 drivers/media/pci/bt8xx/dvb-bt8xx.c           |  3 +-
 drivers/media/pci/cobalt/cobalt-alsa-main.c   |  2 +-
 drivers/media/pci/cobalt/cobalt-alsa-pcm.c    |  4 +-
 drivers/media/pci/cobalt/cobalt-v4l2.c        | 14 ++---
 drivers/media/pci/cx18/cx18-alsa-main.c       |  2 +-
 drivers/media/pci/cx18/cx18-alsa-pcm.c        |  2 +-
 drivers/media/pci/cx18/cx18-cards.c           |  8 +--
 drivers/media/pci/cx18/cx18-driver.c          |  2 +-
 drivers/media/pci/cx18/cx18-i2c.c             |  2 +-
 drivers/media/pci/cx18/cx18-ioctl.c           |  8 +--
 drivers/media/pci/cx23885/cx23885-417.c       |  6 +--
 drivers/media/pci/cx23885/cx23885-dvb.c       | 54 +++++++++----------
 drivers/media/pci/cx23885/cx23885-i2c.c       |  4 +-
 drivers/media/pci/cx23885/cx23885-ioctl.c     |  4 +-
 drivers/media/pci/cx23885/cx23885-video.c     |  4 +-
 drivers/media/pci/cx25821/cx25821-i2c.c       |  2 +-
 drivers/media/pci/cx25821/cx25821-video.c     |  4 +-
 drivers/media/pci/cx88/cx88-blackbird.c       |  2 +-
 drivers/media/pci/cx88/cx88-i2c.c             |  4 +-
 drivers/media/pci/cx88/cx88-input.c           |  4 +-
 drivers/media/pci/cx88/cx88-video.c           |  4 +-
 drivers/media/pci/cx88/cx88-vp3054-i2c.c      |  2 +-
 drivers/media/pci/dt3155/dt3155.c             |  2 +-
 drivers/media/pci/intel/ipu3/ipu3-cio2.c      |  8 +--
 drivers/media/pci/ivtv/ivtv-alsa-main.c       |  2 +-
 drivers/media/pci/ivtv/ivtv-alsa-pcm.c        |  2 +-
 drivers/media/pci/ivtv/ivtv-cards.c           | 12 ++---
 drivers/media/pci/ivtv/ivtv-i2c.c             |  4 +-
 drivers/media/pci/ivtv/ivtv-ioctl.c           |  8 +--
 drivers/media/pci/ivtv/ivtvfb.c               |  2 +-
 drivers/media/pci/pt3/pt3.c                   |  2 +-
 drivers/media/pci/saa7134/saa7134-empress.c   |  2 +-
 drivers/media/pci/saa7134/saa7134-go7007.c    |  2 +-
 drivers/media/pci/saa7134/saa7134-input.c     |  2 +-
 drivers/media/pci/saa7134/saa7134-video.c     |  6 +--
 drivers/media/pci/saa7146/mxb.c               |  2 +-
 drivers/media/pci/saa7164/saa7164-dvb.c       | 10 ++--
 drivers/media/pci/saa7164/saa7164-encoder.c   |  4 +-
 drivers/media/pci/saa7164/saa7164-i2c.c       |  2 +-
 drivers/media/pci/saa7164/saa7164-vbi.c       |  2 +-
 drivers/media/pci/smipcie/smipcie-main.c      |  8 +--
 drivers/media/pci/solo6x10/solo6x10-v4l2.c    |  2 +-
 drivers/media/pci/ttpci/av7110.c              |  3 +-
 drivers/media/pci/ttpci/budget-core.c         |  3 +-
 drivers/media/pci/tw68/tw68-video.c           |  4 +-
 drivers/media/pci/tw686x/tw686x-audio.c       |  8 +--
 drivers/media/pci/tw686x/tw686x-video.c       |  4 +-
 drivers/media/platform/am437x/am437x-vpfe.c   |  6 +--
 drivers/media/platform/atmel/atmel-isc.c      |  2 +-
 drivers/media/platform/atmel/atmel-isi.c      | 10 ++--
 drivers/media/platform/coda/coda-common.c     |  8 +--
 drivers/media/platform/davinci/vpbe_display.c |  2 +-
 drivers/media/platform/davinci/vpfe_capture.c |  6 +--
 drivers/media/platform/davinci/vpif_capture.c |  6 +--
 drivers/media/platform/davinci/vpif_display.c |  6 +--
 drivers/media/platform/exynos-gsc/gsc-core.c  |  2 +-
 drivers/media/platform/exynos-gsc/gsc-m2m.c   |  4 +-
 drivers/media/platform/exynos4-is/common.c    |  4 +-
 .../media/platform/exynos4-is/fimc-capture.c  |  2 +-
 .../media/platform/exynos4-is/fimc-is-i2c.c   |  2 +-
 .../platform/exynos4-is/fimc-isp-video.c      |  2 +-
 drivers/media/platform/exynos4-is/fimc-lite.c |  6 +--
 drivers/media/platform/exynos4-is/media-dev.c |  8 +--
 drivers/media/platform/m2m-deinterlace.c      |  8 +--
 .../media/platform/marvell-ccic/mcam-core.c   |  6 +--
 .../media/platform/marvell-ccic/mmp-driver.c  |  2 +-
 .../media/platform/mtk-jpeg/mtk_jpeg_core.c   |  4 +-
 drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c  |  6 +--
 .../platform/mtk-vcodec/mtk_vcodec_dec.c      |  6 +--
 .../platform/mtk-vcodec/mtk_vcodec_enc.c      |  6 +--
 drivers/media/platform/mx2_emmaprp.c          |  2 +-
 drivers/media/platform/omap/omap_vout.c       | 10 ++--
 drivers/media/platform/omap3isp/isp.c         |  2 +-
 drivers/media/platform/omap3isp/ispccdc.c     |  2 +-
 drivers/media/platform/omap3isp/ispccp2.c     |  2 +-
 drivers/media/platform/omap3isp/ispcsi2.c     |  2 +-
 drivers/media/platform/omap3isp/isppreview.c  |  2 +-
 drivers/media/platform/omap3isp/ispresizer.c  |  2 +-
 drivers/media/platform/omap3isp/ispvideo.c    |  8 +--
 drivers/media/platform/pxa_camera.c           |  8 +--
 .../media/platform/qcom/camss/camss-video.c   |  8 +--
 drivers/media/platform/qcom/camss/camss.c     |  2 +-
 drivers/media/platform/qcom/venus/vdec.c      |  8 +--
 drivers/media/platform/qcom/venus/venc.c      |  8 +--
 drivers/media/platform/rcar-vin/rcar-core.c   |  4 +-
 drivers/media/platform/rcar-vin/rcar-v4l2.c   |  8 +--
 drivers/media/platform/rcar_drif.c            |  4 +-
 drivers/media/platform/rcar_fdp1.c            |  6 +--
 drivers/media/platform/rcar_jpu.c             | 10 ++--
 drivers/media/platform/renesas-ceu.c          |  6 +--
 drivers/media/platform/rockchip/rga/rga.c     |  6 +--
 .../media/platform/s3c-camif/camif-capture.c  | 10 ++--
 drivers/media/platform/s3c-camif/camif-core.c |  4 +-
 drivers/media/platform/s5p-jpeg/jpeg-core.c   | 10 ++--
 drivers/media/platform/s5p-mfc/s5p_mfc_dec.c  |  6 +--
 drivers/media/platform/s5p-mfc/s5p_mfc_enc.c  |  6 +--
 drivers/media/platform/sh_veu.c               |  9 ++--
 drivers/media/platform/sh_vou.c               | 10 ++--
 .../soc_camera/sh_mobile_ceu_camera.c         |  6 +--
 .../media/platform/soc_camera/soc_camera.c    |  6 +--
 .../platform/soc_camera/soc_camera_platform.c |  2 +-
 drivers/media/platform/sti/bdisp/bdisp-v4l2.c |  4 +-
 drivers/media/platform/sti/delta/delta-v4l2.c |  4 +-
 drivers/media/platform/sti/hva/hva-v4l2.c     |  4 +-
 drivers/media/platform/stm32/stm32-dcmi.c     | 10 ++--
 drivers/media/platform/ti-vpe/cal.c           |  6 +--
 drivers/media/platform/via-camera.c           |  4 +-
 drivers/media/platform/vicodec/vicodec-core.c |  6 +--
 drivers/media/platform/vim2m.c                |  2 +-
 drivers/media/platform/vimc/vimc-capture.c    |  6 +--
 drivers/media/platform/vimc/vimc-common.c     |  2 +-
 drivers/media/platform/vimc/vimc-core.c       |  4 +-
 drivers/media/platform/vivid/vivid-osd.c      |  2 +-
 .../media/platform/vivid/vivid-radio-common.c |  4 +-
 drivers/media/platform/vivid/vivid-radio-rx.c |  2 +-
 drivers/media/platform/vivid/vivid-radio-tx.c |  2 +-
 drivers/media/platform/vivid/vivid-rds-gen.c  |  4 +-
 drivers/media/platform/vivid/vivid-sdr-cap.c  |  4 +-
 drivers/media/platform/vivid/vivid-vid-cap.c  |  2 +-
 drivers/media/platform/vsp1/vsp1_drv.c        |  2 +-
 drivers/media/platform/vsp1/vsp1_histo.c      |  4 +-
 drivers/media/platform/vsp1/vsp1_video.c      |  4 +-
 drivers/media/platform/xilinx/xilinx-dma.c    |  6 +--
 drivers/media/platform/xilinx/xilinx-tpg.c    |  2 +-
 drivers/media/platform/xilinx/xilinx-vipp.c   |  2 +-
 drivers/media/radio/dsbr100.c                 |  7 +--
 drivers/media/radio/radio-cadet.c             | 12 ++---
 drivers/media/radio/radio-isa.c               | 10 ++--
 drivers/media/radio/radio-keene.c             |  8 +--
 drivers/media/radio/radio-ma901.c             |  6 +--
 drivers/media/radio/radio-maxiradio.c         |  2 +-
 drivers/media/radio/radio-miropcm20.c         | 10 ++--
 drivers/media/radio/radio-mr800.c             |  6 +--
 drivers/media/radio/radio-raremono.c          |  8 +--
 drivers/media/radio/radio-sf16fmi.c           | 12 ++---
 drivers/media/radio/radio-sf16fmr2.c          |  6 +--
 drivers/media/radio/radio-shark.c             |  2 +-
 drivers/media/radio/radio-shark2.c            |  2 +-
 drivers/media/radio/radio-si476x.c            | 12 ++---
 drivers/media/radio/radio-tea5764.c           |  6 +--
 drivers/media/radio/radio-tea5777.c           | 12 ++---
 drivers/media/radio/radio-timb.c              |  8 +--
 drivers/media/radio/radio-wl1273.c            | 12 ++---
 drivers/media/radio/si470x/radio-si470x-i2c.c |  4 +-
 drivers/media/radio/si470x/radio-si470x-usb.c |  4 +-
 .../radio/si4713/radio-platform-si4713.c      |  6 +--
 drivers/media/radio/si4713/radio-usb-si4713.c |  6 +--
 drivers/media/radio/tea575x.c                 | 10 ++--
 drivers/media/radio/tef6862.c                 |  2 +-
 drivers/media/radio/wl128x/fmdrv_v4l2.c       |  9 ++--
 drivers/media/rc/ati_remote.c                 |  2 +-
 drivers/media/rc/mceusb.c                     |  2 +-
 drivers/media/rc/streamzap.c                  |  2 +-
 drivers/media/tuners/e4000.c                  |  2 +-
 drivers/media/tuners/fc2580.c                 |  2 +-
 drivers/media/tuners/msi001.c                 |  2 +-
 drivers/media/tuners/mt20xx.c                 |  2 +-
 drivers/media/tuners/tuner-simple.c           |  2 +-
 drivers/media/usb/airspy/airspy.c             | 10 ++--
 drivers/media/usb/au0828/au0828-i2c.c         |  2 +-
 drivers/media/usb/au0828/au0828-video.c       |  4 +-
 drivers/media/usb/cx231xx/cx231xx-417.c       |  2 +-
 drivers/media/usb/cx231xx/cx231xx-input.c     |  2 +-
 drivers/media/usb/cx231xx/cx231xx-video.c     | 18 +++----
 drivers/media/usb/dvb-usb-v2/af9035.c         |  2 +-
 drivers/media/usb/dvb-usb-v2/anysee.c         |  2 +-
 drivers/media/usb/dvb-usb-v2/dvb_usb_core.c   |  2 +-
 drivers/media/usb/dvb-usb-v2/gl861.c          |  2 +-
 drivers/media/usb/dvb-usb-v2/lmedm04.c        |  2 +-
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c       | 18 +++----
 drivers/media/usb/dvb-usb-v2/zd1301.c         |  2 +-
 drivers/media/usb/dvb-usb/cxusb.c             |  4 +-
 drivers/media/usb/dvb-usb/dib0700_devices.c   |  4 +-
 drivers/media/usb/dvb-usb/dvb-usb-i2c.c       |  2 +-
 drivers/media/usb/dvb-usb/dw2102.c            |  4 +-
 drivers/media/usb/dvb-usb/technisat-usb2.c    |  5 +-
 drivers/media/usb/em28xx/em28xx-video.c       | 10 ++--
 drivers/media/usb/go7007/go7007-driver.c      |  2 +-
 drivers/media/usb/go7007/go7007-v4l2.c        | 16 +++---
 drivers/media/usb/go7007/snd-go7007.c         |  8 +--
 drivers/media/usb/gspca/gspca.c               | 10 ++--
 drivers/media/usb/gspca/sn9c20x.c             |  2 +-
 drivers/media/usb/hackrf/hackrf.c             | 12 ++---
 drivers/media/usb/hdpvr/hdpvr-video.c         |  2 +-
 drivers/media/usb/msi2500/msi2500.c           |  8 +--
 drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c  |  6 +--
 drivers/media/usb/pvrusb2/pvrusb2-v4l2.c      | 10 ++--
 drivers/media/usb/pwc/pwc-v4l.c               | 10 ++--
 drivers/media/usb/s2255/s2255drv.c            | 10 ++--
 drivers/media/usb/stk1160/stk1160-v4l.c       |  2 +-
 drivers/media/usb/tm6000/tm6000-i2c.c         |  4 +-
 drivers/media/usb/tm6000/tm6000-video.c       |  7 +--
 drivers/media/usb/usbtv/usbtv-audio.c         |  6 +--
 drivers/media/usb/usbtv/usbtv-video.c         | 14 ++---
 drivers/media/usb/usbvision/usbvision-video.c |  4 +-
 drivers/media/usb/uvc/uvc_ctrl.c              |  4 +-
 drivers/media/usb/uvc/uvc_driver.c            | 20 +++----
 drivers/media/usb/uvc/uvc_entity.c            |  2 +-
 drivers/media/usb/uvc/uvc_metadata.c          |  4 +-
 drivers/media/usb/uvc/uvc_v4l2.c              | 10 ++--
 drivers/media/usb/zr364xx/zr364xx.c           |  6 +--
 drivers/media/v4l2-core/v4l2-common.c         |  6 +--
 drivers/media/v4l2-core/v4l2-ctrls.c          |  8 +--
 drivers/media/v4l2-core/v4l2-device.c         |  2 +-
 .../media/v4l2-core/v4l2-flash-led-class.c    |  2 +-
 drivers/media/v4l2-core/v4l2-ioctl.c          |  8 +--
 drivers/media/v4l2-core/v4l2-subdev.c         |  2 +-
 drivers/staging/media/bcm2048/radio-bcm2048.c |  4 +-
 .../staging/media/davinci_vpfe/dm365_ipipe.c  |  2 +-
 .../media/davinci_vpfe/dm365_ipipeif.c        |  2 +-
 .../staging/media/davinci_vpfe/dm365_isif.c   |  2 +-
 .../media/davinci_vpfe/dm365_resizer.c        |  6 +--
 .../staging/media/davinci_vpfe/vpfe_video.c   |  6 +--
 drivers/staging/media/imx/imx-media-capture.c |  4 +-
 drivers/staging/media/imx/imx-media-dev.c     |  4 +-
 drivers/staging/media/omap4iss/iss.c          |  2 +-
 drivers/staging/media/omap4iss/iss_ipipe.c    |  2 +-
 drivers/staging/media/omap4iss/iss_ipipeif.c  |  2 +-
 drivers/staging/media/omap4iss/iss_resizer.c  |  2 +-
 drivers/staging/media/omap4iss/iss_video.c    | 10 ++--
 drivers/staging/media/zoran/zoran_card.c      |  4 +-
 drivers/staging/media/zoran/zoran_driver.c    |  4 +-
 260 files changed, 676 insertions(+), 665 deletions(-)

diff --git a/drivers/media/cec/cec-api.c b/drivers/media/cec/cec-api.c
index b6536bbad530..27ae9e138b8e 100644
--- a/drivers/media/cec/cec-api.c
+++ b/drivers/media/cec/cec-api.c
@@ -77,9 +77,9 @@ static long cec_adap_g_caps(struct cec_adapter *adap,
 {
 	struct cec_caps caps = {};
 
-	strlcpy(caps.driver, adap->devnode.dev.parent->driver->name,
+	strscpy(caps.driver, adap->devnode.dev.parent->driver->name,
 		sizeof(caps.driver));
-	strlcpy(caps.name, adap->name, sizeof(caps.name));
+	strscpy(caps.name, adap->name, sizeof(caps.name));
 	caps.available_log_addrs = adap->available_log_addrs;
 	caps.capabilities = adap->capabilities;
 	caps.version = LINUX_VERSION_CODE;
diff --git a/drivers/media/cec/cec-core.c b/drivers/media/cec/cec-core.c
index b278ab90b387..74596f089ec9 100644
--- a/drivers/media/cec/cec-core.c
+++ b/drivers/media/cec/cec-core.c
@@ -264,7 +264,7 @@ struct cec_adapter *cec_allocate_adapter(const struct cec_adap_ops *ops,
 	adap = kzalloc(sizeof(*adap), GFP_KERNEL);
 	if (!adap)
 		return ERR_PTR(-ENOMEM);
-	strlcpy(adap->name, name, sizeof(adap->name));
+	strscpy(adap->name, name, sizeof(adap->name));
 	adap->phys_addr = CEC_PHYS_ADDR_INVALID;
 	adap->cec_pin_is_high = true;
 	adap->log_addrs.cec_version = CEC_OP_CEC_VERSION_2_0;
diff --git a/drivers/media/common/b2c2/flexcop-i2c.c b/drivers/media/common/b2c2/flexcop-i2c.c
index 6675b605eb6f..1f1eaa807811 100644
--- a/drivers/media/common/b2c2/flexcop-i2c.c
+++ b/drivers/media/common/b2c2/flexcop-i2c.c
@@ -226,12 +226,12 @@ int flexcop_i2c_init(struct flexcop_device *fc)
 	fc->fc_i2c_adap[1].port = FC_I2C_PORT_EEPROM;
 	fc->fc_i2c_adap[2].port = FC_I2C_PORT_TUNER;
 
-	strlcpy(fc->fc_i2c_adap[0].i2c_adap.name, "B2C2 FlexCop I2C to demod",
-			sizeof(fc->fc_i2c_adap[0].i2c_adap.name));
-	strlcpy(fc->fc_i2c_adap[1].i2c_adap.name, "B2C2 FlexCop I2C to eeprom",
-			sizeof(fc->fc_i2c_adap[1].i2c_adap.name));
-	strlcpy(fc->fc_i2c_adap[2].i2c_adap.name, "B2C2 FlexCop I2C to tuner",
-			sizeof(fc->fc_i2c_adap[2].i2c_adap.name));
+	strscpy(fc->fc_i2c_adap[0].i2c_adap.name, "B2C2 FlexCop I2C to demod",
+		sizeof(fc->fc_i2c_adap[0].i2c_adap.name));
+	strscpy(fc->fc_i2c_adap[1].i2c_adap.name, "B2C2 FlexCop I2C to eeprom",
+		sizeof(fc->fc_i2c_adap[1].i2c_adap.name));
+	strscpy(fc->fc_i2c_adap[2].i2c_adap.name, "B2C2 FlexCop I2C to tuner",
+		sizeof(fc->fc_i2c_adap[2].i2c_adap.name));
 
 	i2c_set_adapdata(&fc->fc_i2c_adap[0].i2c_adap, &fc->fc_i2c_adap[0]);
 	i2c_set_adapdata(&fc->fc_i2c_adap[1].i2c_adap, &fc->fc_i2c_adap[1]);
diff --git a/drivers/media/common/cx2341x.c b/drivers/media/common/cx2341x.c
index 81dce9a81bd3..1dcc39b87bb7 100644
--- a/drivers/media/common/cx2341x.c
+++ b/drivers/media/common/cx2341x.c
@@ -569,7 +569,7 @@ static int cx2341x_ctrl_query_fill(struct v4l2_queryctrl *qctrl,
 		qctrl->step = step;
 		qctrl->default_value = def;
 		qctrl->reserved[0] = qctrl->reserved[1] = 0;
-		strlcpy(qctrl->name, name, sizeof(qctrl->name));
+		strscpy(qctrl->name, name, sizeof(qctrl->name));
 		return 0;
 
 	default:
diff --git a/drivers/media/common/saa7146/saa7146_fops.c b/drivers/media/common/saa7146/saa7146_fops.c
index d4987fd05d05..c790ae264464 100644
--- a/drivers/media/common/saa7146/saa7146_fops.c
+++ b/drivers/media/common/saa7146/saa7146_fops.c
@@ -606,7 +606,7 @@ int saa7146_register_device(struct video_device *vfd, struct saa7146_dev *dev,
 	vfd->tvnorms = 0;
 	for (i = 0; i < dev->ext_vv_data->num_stds; i++)
 		vfd->tvnorms |= dev->ext_vv_data->stds[i].id;
-	strlcpy(vfd->name, name, sizeof(vfd->name));
+	strscpy(vfd->name, name, sizeof(vfd->name));
 	video_set_drvdata(vfd, dev);
 
 	err = video_register_device(vfd, type, -1);
diff --git a/drivers/media/common/saa7146/saa7146_video.c b/drivers/media/common/saa7146/saa7146_video.c
index 0dfa0c09d646..2a5c4b113f89 100644
--- a/drivers/media/common/saa7146/saa7146_video.c
+++ b/drivers/media/common/saa7146/saa7146_video.c
@@ -452,7 +452,7 @@ static int vidioc_querycap(struct file *file, void *fh, struct v4l2_capability *
 	struct saa7146_dev *dev = ((struct saa7146_fh *)fh)->dev;
 
 	strcpy((char *)cap->driver, "saa7146 v4l2");
-	strlcpy((char *)cap->card, dev->ext->name, sizeof(cap->card));
+	strscpy((char *)cap->card, dev->ext->name, sizeof(cap->card));
 	sprintf((char *)cap->bus_info, "PCI:%s", pci_name(dev->pci));
 	cap->device_caps =
 		V4L2_CAP_VIDEO_CAPTURE |
@@ -525,8 +525,8 @@ static int vidioc_enum_fmt_vid_cap(struct file *file, void *fh, struct v4l2_fmtd
 {
 	if (f->index >= ARRAY_SIZE(formats))
 		return -EINVAL;
-	strlcpy((char *)f->description, formats[f->index].name,
-			sizeof(f->description));
+	strscpy((char *)f->description, formats[f->index].name,
+		sizeof(f->description));
 	f->pixelformat = formats[f->index].pixelformat;
 	return 0;
 }
diff --git a/drivers/media/common/siano/smscoreapi.c b/drivers/media/common/siano/smscoreapi.c
index 3b02cb570a6e..add9d6361914 100644
--- a/drivers/media/common/siano/smscoreapi.c
+++ b/drivers/media/common/siano/smscoreapi.c
@@ -450,7 +450,7 @@ static struct smscore_registry_entry_t *smscore_find_registry(char *devpath)
 	entry = kmalloc(sizeof(*entry), GFP_KERNEL);
 	if (entry) {
 		entry->mode = default_mode;
-		strlcpy(entry->devpath, devpath, sizeof(entry->devpath));
+		strscpy(entry->devpath, devpath, sizeof(entry->devpath));
 		list_add(&entry->entry, &g_smscore_registry);
 	} else
 		pr_err("failed to create smscore_registry.\n");
@@ -735,7 +735,7 @@ int smscore_register_device(struct smsdevice_params_t *params,
 	dev->postload_handler = params->postload_handler;
 
 	dev->device_flags = params->flags;
-	strlcpy(dev->devpath, params->devpath, sizeof(dev->devpath));
+	strscpy(dev->devpath, params->devpath, sizeof(dev->devpath));
 
 	smscore_registry_settype(dev->devpath, params->device_type);
 
diff --git a/drivers/media/common/siano/smsir.c b/drivers/media/common/siano/smsir.c
index 56db0a944421..a1cfafba9b4c 100644
--- a/drivers/media/common/siano/smsir.c
+++ b/drivers/media/common/siano/smsir.c
@@ -55,7 +55,7 @@ int sms_ir_init(struct smscore_device_t *coredev)
 	snprintf(coredev->ir.name, sizeof(coredev->ir.name),
 		 "SMS IR (%s)", sms_get_board(board_id)->name);
 
-	strlcpy(coredev->ir.phys, coredev->devpath, sizeof(coredev->ir.phys));
+	strscpy(coredev->ir.phys, coredev->devpath, sizeof(coredev->ir.phys));
 	strlcat(coredev->ir.phys, "/ir0", sizeof(coredev->ir.phys));
 
 	dev->device_name = coredev->ir.name;
diff --git a/drivers/media/dvb-core/dvb_vb2.c b/drivers/media/dvb-core/dvb_vb2.c
index b811adf88afa..c90b1fd94735 100644
--- a/drivers/media/dvb-core/dvb_vb2.c
+++ b/drivers/media/dvb-core/dvb_vb2.c
@@ -194,7 +194,7 @@ int dvb_vb2_init(struct dvb_vb2_ctx *ctx, const char *name, int nonblocking)
 	spin_lock_init(&ctx->slock);
 	INIT_LIST_HEAD(&ctx->dvb_q);
 
-	strlcpy(ctx->name, name, DVB_VB2_NAME_MAX);
+	strscpy(ctx->name, name, DVB_VB2_NAME_MAX);
 	ctx->nonblocking = nonblocking;
 	ctx->state = DVB_VB2_STATE_INIT;
 
diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
index 3c8778570331..9a5eed3f6cf6 100644
--- a/drivers/media/dvb-core/dvbdev.c
+++ b/drivers/media/dvb-core/dvbdev.c
@@ -967,9 +967,9 @@ struct i2c_client *dvb_module_probe(const char *module_name,
 		return NULL;
 
 	if (name)
-		strlcpy(board_info->type, name, I2C_NAME_SIZE);
+		strscpy(board_info->type, name, I2C_NAME_SIZE);
 	else
-		strlcpy(board_info->type, module_name, I2C_NAME_SIZE);
+		strscpy(board_info->type, module_name, I2C_NAME_SIZE);
 
 	board_info->addr = addr;
 	board_info->platform_data = platform_data;
diff --git a/drivers/media/dvb-frontends/cx24123.c b/drivers/media/dvb-frontends/cx24123.c
index e49215020a93..83dfae78579d 100644
--- a/drivers/media/dvb-frontends/cx24123.c
+++ b/drivers/media/dvb-frontends/cx24123.c
@@ -1087,7 +1087,7 @@ struct dvb_frontend *cx24123_attach(const struct cx24123_config *config,
 	if (config->dont_use_pll)
 		cx24123_repeater_mode(state, 1, 0);
 
-	strlcpy(state->tuner_i2c_adapter.name, "CX24123 tuner I2C bus",
+	strscpy(state->tuner_i2c_adapter.name, "CX24123 tuner I2C bus",
 		sizeof(state->tuner_i2c_adapter.name));
 	state->tuner_i2c_adapter.algo      = &cx24123_tuner_i2c_algo;
 	state->tuner_i2c_adapter.algo_data = NULL;
diff --git a/drivers/media/dvb-frontends/cxd2820r_core.c b/drivers/media/dvb-frontends/cxd2820r_core.c
index 3e0d8cbd76da..0f0acf98d226 100644
--- a/drivers/media/dvb-frontends/cxd2820r_core.c
+++ b/drivers/media/dvb-frontends/cxd2820r_core.c
@@ -540,7 +540,7 @@ struct dvb_frontend *cxd2820r_attach(const struct cxd2820r_config *config,
 	pdata.attach_in_use = true;
 
 	memset(&board_info, 0, sizeof(board_info));
-	strlcpy(board_info.type, "cxd2820r", I2C_NAME_SIZE);
+	strscpy(board_info.type, "cxd2820r", I2C_NAME_SIZE);
 	board_info.addr = config->i2c_address;
 	board_info.platform_data = &pdata;
 	client = i2c_new_device(adapter, &board_info);
diff --git a/drivers/media/dvb-frontends/dibx000_common.c b/drivers/media/dvb-frontends/dibx000_common.c
index 70119c79ac2b..dc80a8442e7a 100644
--- a/drivers/media/dvb-frontends/dibx000_common.c
+++ b/drivers/media/dvb-frontends/dibx000_common.c
@@ -424,7 +424,7 @@ static int i2c_adapter_init(struct i2c_adapter *i2c_adap,
 				struct i2c_algorithm *algo, const char *name,
 				struct dibx000_i2c_master *mst)
 {
-	strlcpy(i2c_adap->name, name, sizeof(i2c_adap->name));
+	strscpy(i2c_adap->name, name, sizeof(i2c_adap->name));
 	i2c_adap->algo = algo;
 	i2c_adap->algo_data = NULL;
 	i2c_set_adapdata(i2c_adap, mst);
diff --git a/drivers/media/dvb-frontends/lgdt330x.c b/drivers/media/dvb-frontends/lgdt330x.c
index 10d584ce538d..96807e134886 100644
--- a/drivers/media/dvb-frontends/lgdt330x.c
+++ b/drivers/media/dvb-frontends/lgdt330x.c
@@ -929,7 +929,7 @@ struct dvb_frontend *lgdt330x_attach(const struct lgdt330x_config *_config,
 	struct i2c_board_info board_info = {};
 	struct lgdt330x_config config = *_config;
 
-	strlcpy(board_info.type, "lgdt330x", sizeof(board_info.type));
+	strscpy(board_info.type, "lgdt330x", sizeof(board_info.type));
 	board_info.addr = demod_address;
 	board_info.platform_data = &config;
 	client = i2c_new_device(i2c, &board_info);
diff --git a/drivers/media/dvb-frontends/m88ds3103.c b/drivers/media/dvb-frontends/m88ds3103.c
index dffd2d4bf1c8..123f2a33738b 100644
--- a/drivers/media/dvb-frontends/m88ds3103.c
+++ b/drivers/media/dvb-frontends/m88ds3103.c
@@ -1284,7 +1284,7 @@ struct dvb_frontend *m88ds3103_attach(const struct m88ds3103_config *cfg,
 	pdata.attach_in_use = true;
 
 	memset(&board_info, 0, sizeof(board_info));
-	strlcpy(board_info.type, "m88ds3103", I2C_NAME_SIZE);
+	strscpy(board_info.type, "m88ds3103", I2C_NAME_SIZE);
 	board_info.addr = cfg->i2c_addr;
 	board_info.platform_data = &pdata;
 	client = i2c_new_device(i2c, &board_info);
diff --git a/drivers/media/dvb-frontends/rtl2832_sdr.c b/drivers/media/dvb-frontends/rtl2832_sdr.c
index d448d9d4879c..8ef91b1598e3 100644
--- a/drivers/media/dvb-frontends/rtl2832_sdr.c
+++ b/drivers/media/dvb-frontends/rtl2832_sdr.c
@@ -439,8 +439,8 @@ static int rtl2832_sdr_querycap(struct file *file, void *fh,
 
 	dev_dbg(&pdev->dev, "\n");
 
-	strlcpy(cap->driver, KBUILD_MODNAME, sizeof(cap->driver));
-	strlcpy(cap->card, dev->vdev.name, sizeof(cap->card));
+	strscpy(cap->driver, KBUILD_MODNAME, sizeof(cap->driver));
+	strscpy(cap->card, dev->vdev.name, sizeof(cap->card));
 	usb_make_path(dev->udev, cap->bus_info, sizeof(cap->bus_info));
 	cap->device_caps = V4L2_CAP_SDR_CAPTURE | V4L2_CAP_STREAMING |
 			V4L2_CAP_READWRITE | V4L2_CAP_TUNER;
@@ -976,7 +976,7 @@ static int rtl2832_sdr_g_tuner(struct file *file, void *priv,
 	dev_dbg(&pdev->dev, "index=%d type=%d\n", v->index, v->type);
 
 	if (v->index == 0) {
-		strlcpy(v->name, "ADC: Realtek RTL2832", sizeof(v->name));
+		strscpy(v->name, "ADC: Realtek RTL2832", sizeof(v->name));
 		v->type = V4L2_TUNER_ADC;
 		v->capability = V4L2_TUNER_CAP_1HZ | V4L2_TUNER_CAP_FREQ_BANDS;
 		v->rangelow =   300000;
@@ -986,7 +986,7 @@ static int rtl2832_sdr_g_tuner(struct file *file, void *priv,
 		   V4L2_SUBDEV_HAS_OP(dev->v4l2_subdev, tuner, g_tuner)) {
 		ret = v4l2_subdev_call(dev->v4l2_subdev, tuner, g_tuner, v);
 	} else if (v->index == 1) {
-		strlcpy(v->name, "RF: <unknown>", sizeof(v->name));
+		strscpy(v->name, "RF: <unknown>", sizeof(v->name));
 		v->type = V4L2_TUNER_RF;
 		v->capability = V4L2_TUNER_CAP_1HZ | V4L2_TUNER_CAP_FREQ_BANDS;
 		v->rangelow =    50000000;
@@ -1133,7 +1133,7 @@ static int rtl2832_sdr_enum_fmt_sdr_cap(struct file *file, void *priv,
 	if (f->index >= dev->num_formats)
 		return -EINVAL;
 
-	strlcpy(f->description, formats[f->index].name, sizeof(f->description));
+	strscpy(f->description, formats[f->index].name, sizeof(f->description));
 	f->pixelformat = formats[f->index].pixelformat;
 
 	return 0;
diff --git a/drivers/media/dvb-frontends/s5h1420.c b/drivers/media/dvb-frontends/s5h1420.c
index a65cdf8e8cd9..c63b56f7fc14 100644
--- a/drivers/media/dvb-frontends/s5h1420.c
+++ b/drivers/media/dvb-frontends/s5h1420.c
@@ -912,7 +912,7 @@ struct dvb_frontend *s5h1420_attach(const struct s5h1420_config *config,
 	state->frontend.demodulator_priv = state;
 
 	/* create tuner i2c adapter */
-	strlcpy(state->tuner_i2c_adapter.name, "S5H1420-PN1010 tuner I2C bus",
+	strscpy(state->tuner_i2c_adapter.name, "S5H1420-PN1010 tuner I2C bus",
 		sizeof(state->tuner_i2c_adapter.name));
 	state->tuner_i2c_adapter.algo      = &s5h1420_tuner_i2c_algo;
 	state->tuner_i2c_adapter.algo_data = NULL;
diff --git a/drivers/media/dvb-frontends/tc90522.c b/drivers/media/dvb-frontends/tc90522.c
index 2ad81a438d6a..849d63dbc279 100644
--- a/drivers/media/dvb-frontends/tc90522.c
+++ b/drivers/media/dvb-frontends/tc90522.c
@@ -781,7 +781,7 @@ static int tc90522_probe(struct i2c_client *client,
 	adap->owner = THIS_MODULE;
 	adap->algo = &tc90522_tuner_i2c_algo;
 	adap->dev.parent = &client->dev;
-	strlcpy(adap->name, "tc90522_sub", sizeof(adap->name));
+	strscpy(adap->name, "tc90522_sub", sizeof(adap->name));
 	i2c_set_adapdata(adap, state);
 	ret = i2c_add_adapter(adap);
 	if (ret < 0)
diff --git a/drivers/media/dvb-frontends/ts2020.c b/drivers/media/dvb-frontends/ts2020.c
index 3e3e40878633..e5cd2cd414f4 100644
--- a/drivers/media/dvb-frontends/ts2020.c
+++ b/drivers/media/dvb-frontends/ts2020.c
@@ -525,7 +525,7 @@ struct dvb_frontend *ts2020_attach(struct dvb_frontend *fe,
 	pdata.attach_in_use = true;
 
 	memset(&board_info, 0, sizeof(board_info));
-	strlcpy(board_info.type, "ts2020", I2C_NAME_SIZE);
+	strscpy(board_info.type, "ts2020", I2C_NAME_SIZE);
 	board_info.addr = config->tuner_address;
 	board_info.platform_data = &pdata;
 	client = i2c_new_device(i2c, &board_info);
diff --git a/drivers/media/dvb-frontends/zd1301_demod.c b/drivers/media/dvb-frontends/zd1301_demod.c
index 84a2b25a574a..212f9328cea8 100644
--- a/drivers/media/dvb-frontends/zd1301_demod.c
+++ b/drivers/media/dvb-frontends/zd1301_demod.c
@@ -499,7 +499,8 @@ static int zd1301_demod_probe(struct platform_device *pdev)
 		goto err_kfree;
 
 	/* Create I2C adapter */
-	strlcpy(dev->adapter.name, "ZyDAS ZD1301 demod", sizeof(dev->adapter.name));
+	strscpy(dev->adapter.name, "ZyDAS ZD1301 demod",
+		sizeof(dev->adapter.name));
 	dev->adapter.algo = &zd1301_demod_i2c_algorithm;
 	dev->adapter.algo_data = NULL;
 	dev->adapter.dev.parent = pdev->dev.parent;
diff --git a/drivers/media/i2c/cs53l32a.c b/drivers/media/i2c/cs53l32a.c
index fd70fe2130a1..ef4bdbae4531 100644
--- a/drivers/media/i2c/cs53l32a.c
+++ b/drivers/media/i2c/cs53l32a.c
@@ -149,7 +149,7 @@ static int cs53l32a_probe(struct i2c_client *client,
 		return -EIO;
 
 	if (!id)
-		strlcpy(client->name, "cs53l32a", sizeof(client->name));
+		strscpy(client->name, "cs53l32a", sizeof(client->name));
 
 	v4l_info(client, "chip found @ 0x%x (%s)\n",
 			client->addr << 1, client->adapter->name);
diff --git a/drivers/media/i2c/imx274.c b/drivers/media/i2c/imx274.c
index f8c70f1a34fe..b82625ff1558 100644
--- a/drivers/media/i2c/imx274.c
+++ b/drivers/media/i2c/imx274.c
@@ -1895,7 +1895,7 @@ static int imx274_probe(struct i2c_client *client,
 	imx274->client = client;
 	sd = &imx274->sd;
 	v4l2_i2c_subdev_init(sd, client, &imx274_subdev_ops);
-	strlcpy(sd->name, DRIVER_NAME, sizeof(sd->name));
+	strscpy(sd->name, DRIVER_NAME, sizeof(sd->name));
 	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE | V4L2_SUBDEV_FL_HAS_EVENTS;
 
 	/* initialize subdev media pad */
diff --git a/drivers/media/i2c/m5mols/m5mols_core.c b/drivers/media/i2c/m5mols/m5mols_core.c
index 12e79f9e32d5..155424a43d4c 100644
--- a/drivers/media/i2c/m5mols/m5mols_core.c
+++ b/drivers/media/i2c/m5mols/m5mols_core.c
@@ -987,7 +987,7 @@ static int m5mols_probe(struct i2c_client *client,
 
 	sd = &info->sd;
 	v4l2_i2c_subdev_init(sd, client, &m5mols_ops);
-	strlcpy(sd->name, MODULE_NAME, sizeof(sd->name));
+	strscpy(sd->name, MODULE_NAME, sizeof(sd->name));
 	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
 
 	sd->internal_ops = &m5mols_subdev_internal_ops;
diff --git a/drivers/media/i2c/max2175.c b/drivers/media/i2c/max2175.c
index 008a082cb8ad..8569a2058b02 100644
--- a/drivers/media/i2c/max2175.c
+++ b/drivers/media/i2c/max2175.c
@@ -1165,7 +1165,7 @@ static int max2175_g_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *vt)
 	if (vt->index > 0)
 		return -EINVAL;
 
-	strlcpy(vt->name, "RF", sizeof(vt->name));
+	strscpy(vt->name, "RF", sizeof(vt->name));
 	vt->type = V4L2_TUNER_RF;
 	vt->capability = V4L2_TUNER_CAP_1HZ | V4L2_TUNER_CAP_FREQ_BANDS;
 	vt->rangelow = ctx->bands_rf->rangelow;
diff --git a/drivers/media/i2c/msp3400-driver.c b/drivers/media/i2c/msp3400-driver.c
index 3db966db83eb..98d20479b651 100644
--- a/drivers/media/i2c/msp3400-driver.c
+++ b/drivers/media/i2c/msp3400-driver.c
@@ -688,7 +688,7 @@ static int msp_probe(struct i2c_client *client, const struct i2c_device_id *id)
 #endif
 
 	if (!id)
-		strlcpy(client->name, "msp3400", sizeof(client->name));
+		strscpy(client->name, "msp3400", sizeof(client->name));
 
 	if (msp_reset(client) == -1) {
 		dev_dbg_lvl(&client->dev, 1, msp_debug, "msp3400 not found\n");
diff --git a/drivers/media/i2c/noon010pc30.c b/drivers/media/i2c/noon010pc30.c
index 88c498ad45df..4698e40fedd2 100644
--- a/drivers/media/i2c/noon010pc30.c
+++ b/drivers/media/i2c/noon010pc30.c
@@ -720,7 +720,7 @@ static int noon010_probe(struct i2c_client *client,
 	mutex_init(&info->lock);
 	sd = &info->sd;
 	v4l2_i2c_subdev_init(sd, client, &noon010_ops);
-	strlcpy(sd->name, MODULE_NAME, sizeof(sd->name));
+	strscpy(sd->name, MODULE_NAME, sizeof(sd->name));
 
 	sd->internal_ops = &noon010_subdev_internal_ops;
 	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
diff --git a/drivers/media/i2c/ov9650.c b/drivers/media/i2c/ov9650.c
index 16f625ffbde0..3c9e6798d14b 100644
--- a/drivers/media/i2c/ov9650.c
+++ b/drivers/media/i2c/ov9650.c
@@ -1539,7 +1539,7 @@ static int ov965x_probe(struct i2c_client *client,
 
 	sd = &ov965x->sd;
 	v4l2_i2c_subdev_init(sd, client, &ov965x_subdev_ops);
-	strlcpy(sd->name, DRIVER_NAME, sizeof(sd->name));
+	strscpy(sd->name, DRIVER_NAME, sizeof(sd->name));
 
 	sd->internal_ops = &ov965x_sd_internal_ops;
 	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE |
diff --git a/drivers/media/i2c/s5c73m3/s5c73m3-core.c b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
index ce196b60f917..9ca9b3997073 100644
--- a/drivers/media/i2c/s5c73m3/s5c73m3-core.c
+++ b/drivers/media/i2c/s5c73m3/s5c73m3-core.c
@@ -1683,7 +1683,7 @@ static int s5c73m3_probe(struct i2c_client *client,
 	v4l2_subdev_init(sd, &s5c73m3_subdev_ops);
 	sd->owner = client->dev.driver->owner;
 	v4l2_set_subdevdata(sd, state);
-	strlcpy(sd->name, "S5C73M3", sizeof(sd->name));
+	strscpy(sd->name, "S5C73M3", sizeof(sd->name));
 
 	sd->internal_ops = &s5c73m3_internal_ops;
 	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
diff --git a/drivers/media/i2c/s5k4ecgx.c b/drivers/media/i2c/s5k4ecgx.c
index 6ebcf254989a..8c0dca6cb20c 100644
--- a/drivers/media/i2c/s5k4ecgx.c
+++ b/drivers/media/i2c/s5k4ecgx.c
@@ -954,7 +954,7 @@ static int s5k4ecgx_probe(struct i2c_client *client,
 	sd = &priv->sd;
 	/* Registering subdev */
 	v4l2_i2c_subdev_init(sd, client, &s5k4ecgx_ops);
-	strlcpy(sd->name, S5K4ECGX_DRIVER_NAME, sizeof(sd->name));
+	strscpy(sd->name, S5K4ECGX_DRIVER_NAME, sizeof(sd->name));
 
 	sd->internal_ops = &s5k4ecgx_subdev_internal_ops;
 	/* Support v4l2 sub-device user space API */
diff --git a/drivers/media/i2c/s5k6aa.c b/drivers/media/i2c/s5k6aa.c
index 13c10b5e2b45..52ca033f7069 100644
--- a/drivers/media/i2c/s5k6aa.c
+++ b/drivers/media/i2c/s5k6aa.c
@@ -1576,7 +1576,7 @@ static int s5k6aa_probe(struct i2c_client *client,
 
 	sd = &s5k6aa->sd;
 	v4l2_i2c_subdev_init(sd, client, &s5k6aa_subdev_ops);
-	strlcpy(sd->name, DRIVER_NAME, sizeof(sd->name));
+	strscpy(sd->name, DRIVER_NAME, sizeof(sd->name));
 
 	sd->internal_ops = &s5k6aa_subdev_internal_ops;
 	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
diff --git a/drivers/media/i2c/saa7115.c b/drivers/media/i2c/saa7115.c
index b07114b5efb2..7bc3b721831e 100644
--- a/drivers/media/i2c/saa7115.c
+++ b/drivers/media/i2c/saa7115.c
@@ -1765,7 +1765,7 @@ static int saa711x_detect_chip(struct i2c_client *client,
 		 * the lower nibble is a gm7113c.
 		 */
 
-		strlcpy(name, "gm7113c", CHIP_VER_SIZE);
+		strscpy(name, "gm7113c", CHIP_VER_SIZE);
 
 		if (!autodetect && strcmp(name, id->name))
 			return -EINVAL;
@@ -1779,7 +1779,7 @@ static int saa711x_detect_chip(struct i2c_client *client,
 
 	/* Check if it is a CJC7113 */
 	if (!memcmp(name, "1111111111111111", CHIP_VER_SIZE)) {
-		strlcpy(name, "cjc7113", CHIP_VER_SIZE);
+		strscpy(name, "cjc7113", CHIP_VER_SIZE);
 
 		if (!autodetect && strcmp(name, id->name))
 			return -EINVAL;
@@ -1825,7 +1825,7 @@ static int saa711x_probe(struct i2c_client *client,
 	if (ident < 0)
 		return ident;
 
-	strlcpy(client->name, name, sizeof(client->name));
+	strscpy(client->name, name, sizeof(client->name));
 
 	state = devm_kzalloc(&client->dev, sizeof(*state), GFP_KERNEL);
 	if (state == NULL)
diff --git a/drivers/media/i2c/saa7127.c b/drivers/media/i2c/saa7127.c
index e58a150cec5c..a67865b810c0 100644
--- a/drivers/media/i2c/saa7127.c
+++ b/drivers/media/i2c/saa7127.c
@@ -761,10 +761,10 @@ static int saa7127_probe(struct i2c_client *client,
 			saa7127_write(sd, SAA7129_REG_FADE_KEY_COL2,
 					read_result);
 			state->ident = SAA7129;
-			strlcpy(client->name, "saa7129", I2C_NAME_SIZE);
+			strscpy(client->name, "saa7129", I2C_NAME_SIZE);
 		} else {
 			state->ident = SAA7127;
-			strlcpy(client->name, "saa7127", I2C_NAME_SIZE);
+			strscpy(client->name, "saa7127", I2C_NAME_SIZE);
 		}
 	}
 
diff --git a/drivers/media/i2c/tvaudio.c b/drivers/media/i2c/tvaudio.c
index 5919214a56bf..af2da977a685 100644
--- a/drivers/media/i2c/tvaudio.c
+++ b/drivers/media/i2c/tvaudio.c
@@ -1981,7 +1981,7 @@ static int tvaudio_probe(struct i2c_client *client, const struct i2c_device_id *
 
 	/* fill required data structures */
 	if (!id)
-		strlcpy(client->name, desc->name, I2C_NAME_SIZE);
+		strscpy(client->name, desc->name, I2C_NAME_SIZE);
 	chip->desc = desc;
 	chip->shadow.count = desc->registers+1;
 	chip->prevmode = -1;
diff --git a/drivers/media/i2c/video-i2c.c b/drivers/media/i2c/video-i2c.c
index 06d29d8f6be8..4d49af86c15e 100644
--- a/drivers/media/i2c/video-i2c.c
+++ b/drivers/media/i2c/video-i2c.c
@@ -352,8 +352,8 @@ static int video_i2c_querycap(struct file *file, void  *priv,
 	struct video_i2c_data *data = video_drvdata(file);
 	struct i2c_client *client = data->client;
 
-	strlcpy(vcap->driver, data->v4l2_dev.name, sizeof(vcap->driver));
-	strlcpy(vcap->card, data->vdev.name, sizeof(vcap->card));
+	strscpy(vcap->driver, data->v4l2_dev.name, sizeof(vcap->driver));
+	strscpy(vcap->card, data->vdev.name, sizeof(vcap->card));
 
 	sprintf(vcap->bus_info, "I2C:%d-%d", client->adapter->nr, client->addr);
 
@@ -378,7 +378,7 @@ static int video_i2c_enum_input(struct file *file, void *fh,
 	if (vin->index > 0)
 		return -EINVAL;
 
-	strlcpy(vin->name, "Camera", sizeof(vin->name));
+	strscpy(vin->name, "Camera", sizeof(vin->name));
 
 	vin->type = V4L2_INPUT_TYPE_CAMERA;
 
@@ -534,7 +534,7 @@ static int video_i2c_probe(struct i2c_client *client,
 
 	data->client = client;
 	v4l2_dev = &data->v4l2_dev;
-	strlcpy(v4l2_dev->name, VIDEO_I2C_DRIVER, sizeof(v4l2_dev->name));
+	strscpy(v4l2_dev->name, VIDEO_I2C_DRIVER, sizeof(v4l2_dev->name));
 
 	ret = v4l2_device_register(&client->dev, v4l2_dev);
 	if (ret < 0)
diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
index 3bae24b15eaa..4c7190db420e 100644
--- a/drivers/media/media-device.c
+++ b/drivers/media/media-device.c
@@ -69,14 +69,14 @@ static long media_device_get_info(struct media_device *dev, void *arg)
 	memset(info, 0, sizeof(*info));
 
 	if (dev->driver_name[0])
-		strlcpy(info->driver, dev->driver_name, sizeof(info->driver));
+		strscpy(info->driver, dev->driver_name, sizeof(info->driver));
 	else
-		strlcpy(info->driver, dev->dev->driver->name,
+		strscpy(info->driver, dev->dev->driver->name,
 			sizeof(info->driver));
 
-	strlcpy(info->model, dev->model, sizeof(info->model));
-	strlcpy(info->serial, dev->serial, sizeof(info->serial));
-	strlcpy(info->bus_info, dev->bus_info, sizeof(info->bus_info));
+	strscpy(info->model, dev->model, sizeof(info->model));
+	strscpy(info->serial, dev->serial, sizeof(info->serial));
+	strscpy(info->bus_info, dev->bus_info, sizeof(info->bus_info));
 
 	info->media_version = LINUX_VERSION_CODE;
 	info->driver_version = info->media_version;
@@ -115,7 +115,7 @@ static long media_device_enum_entities(struct media_device *mdev, void *arg)
 
 	entd->id = media_entity_id(ent);
 	if (ent->name)
-		strlcpy(entd->name, ent->name, sizeof(entd->name));
+		strscpy(entd->name, ent->name, sizeof(entd->name));
 	entd->type = ent->function;
 	entd->revision = 0;		/* Unused */
 	entd->flags = ent->flags;
@@ -268,7 +268,7 @@ static long media_device_get_topology(struct media_device *mdev, void *arg)
 		kentity.id = entity->graph_obj.id;
 		kentity.function = entity->function;
 		kentity.flags = entity->flags;
-		strlcpy(kentity.name, entity->name,
+		strscpy(kentity.name, entity->name,
 			sizeof(kentity.name));
 
 		if (copy_to_user(uentity, &kentity, sizeof(kentity)))
@@ -836,9 +836,9 @@ void media_device_pci_init(struct media_device *mdev,
 	mdev->dev = &pci_dev->dev;
 
 	if (name)
-		strlcpy(mdev->model, name, sizeof(mdev->model));
+		strscpy(mdev->model, name, sizeof(mdev->model));
 	else
-		strlcpy(mdev->model, pci_name(pci_dev), sizeof(mdev->model));
+		strscpy(mdev->model, pci_name(pci_dev), sizeof(mdev->model));
 
 	sprintf(mdev->bus_info, "PCI:%s", pci_name(pci_dev));
 
@@ -859,17 +859,17 @@ void __media_device_usb_init(struct media_device *mdev,
 	mdev->dev = &udev->dev;
 
 	if (driver_name)
-		strlcpy(mdev->driver_name, driver_name,
+		strscpy(mdev->driver_name, driver_name,
 			sizeof(mdev->driver_name));
 
 	if (board_name)
-		strlcpy(mdev->model, board_name, sizeof(mdev->model));
+		strscpy(mdev->model, board_name, sizeof(mdev->model));
 	else if (udev->product)
-		strlcpy(mdev->model, udev->product, sizeof(mdev->model));
+		strscpy(mdev->model, udev->product, sizeof(mdev->model));
 	else
-		strlcpy(mdev->model, "unknown model", sizeof(mdev->model));
+		strscpy(mdev->model, "unknown model", sizeof(mdev->model));
 	if (udev->serial)
-		strlcpy(mdev->serial, udev->serial, sizeof(mdev->serial));
+		strscpy(mdev->serial, udev->serial, sizeof(mdev->serial));
 	usb_make_path(udev, mdev->bus_info, sizeof(mdev->bus_info));
 	mdev->hw_revision = le16_to_cpu(udev->descriptor.bcdDevice);
 
diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
index cf05e11da01b..95045448a112 100644
--- a/drivers/media/pci/bt8xx/bttv-driver.c
+++ b/drivers/media/pci/bt8xx/bttv-driver.c
@@ -2473,8 +2473,8 @@ static int bttv_querycap(struct file *file, void  *priv,
 	if (0 == v4l2)
 		return -EINVAL;
 
-	strlcpy(cap->driver, "bttv", sizeof(cap->driver));
-	strlcpy(cap->card, btv->video_dev.name, sizeof(cap->card));
+	strscpy(cap->driver, "bttv", sizeof(cap->driver));
+	strscpy(cap->card, btv->video_dev.name, sizeof(cap->card));
 	snprintf(cap->bus_info, sizeof(cap->bus_info),
 		 "PCI:%s", pci_name(btv->c.pci));
 	cap->capabilities =
@@ -2535,7 +2535,7 @@ static int bttv_enum_fmt_cap_ovr(struct v4l2_fmtdesc *f)
 		return -EINVAL;
 
 	f->pixelformat = formats[i].fourcc;
-	strlcpy(f->description, formats[i].name, sizeof(f->description));
+	strscpy(f->description, formats[i].name, sizeof(f->description));
 
 	return i;
 }
diff --git a/drivers/media/pci/bt8xx/bttv-i2c.c b/drivers/media/pci/bt8xx/bttv-i2c.c
index c76823eb399d..15ff7f9d8373 100644
--- a/drivers/media/pci/bt8xx/bttv-i2c.c
+++ b/drivers/media/pci/bt8xx/bttv-i2c.c
@@ -347,13 +347,13 @@ static void do_i2c_scan(char *name, struct i2c_client *c)
 /* init + register i2c adapter */
 int init_bttv_i2c(struct bttv *btv)
 {
-	strlcpy(btv->i2c_client.name, "bttv internal", I2C_NAME_SIZE);
+	strscpy(btv->i2c_client.name, "bttv internal", I2C_NAME_SIZE);
 
 	if (i2c_hw)
 		btv->use_i2c_hw = 1;
 	if (btv->use_i2c_hw) {
 		/* bt878 */
-		strlcpy(btv->c.i2c_adap.name, "bt878",
+		strscpy(btv->c.i2c_adap.name, "bt878",
 			sizeof(btv->c.i2c_adap.name));
 		btv->c.i2c_adap.algo = &bttv_algo;
 	} else {
@@ -362,7 +362,7 @@ int init_bttv_i2c(struct bttv *btv)
 		if (i2c_udelay<5)
 			i2c_udelay=5;
 
-		strlcpy(btv->c.i2c_adap.name, "bttv",
+		strscpy(btv->c.i2c_adap.name, "bttv",
 			sizeof(btv->c.i2c_adap.name));
 		btv->i2c_algo = bttv_i2c_algo_bit_template;
 		btv->i2c_algo.udelay = i2c_udelay;
diff --git a/drivers/media/pci/bt8xx/bttv-input.c b/drivers/media/pci/bt8xx/bttv-input.c
index 08266b23826e..5cf929370398 100644
--- a/drivers/media/pci/bt8xx/bttv-input.c
+++ b/drivers/media/pci/bt8xx/bttv-input.c
@@ -382,7 +382,7 @@ void init_bttv_i2c_ir(struct bttv *btv)
 
 	memset(&info, 0, sizeof(struct i2c_board_info));
 	memset(&btv->init_data, 0, sizeof(btv->init_data));
-	strlcpy(info.type, "ir_video", I2C_NAME_SIZE);
+	strscpy(info.type, "ir_video", I2C_NAME_SIZE);
 
 	switch (btv->c.type) {
 	case BTTV_BOARD_PV951:
diff --git a/drivers/media/pci/bt8xx/dvb-bt8xx.c b/drivers/media/pci/bt8xx/dvb-bt8xx.c
index 2f810b7130e6..b46fbe557dd9 100644
--- a/drivers/media/pci/bt8xx/dvb-bt8xx.c
+++ b/drivers/media/pci/bt8xx/dvb-bt8xx.c
@@ -819,7 +819,8 @@ static int dvb_bt8xx_probe(struct bttv_sub_device *sub)
 
 	mutex_init(&card->lock);
 	card->bttv_nr = sub->core->nr;
-	strlcpy(card->card_name, sub->core->v4l2_dev.name, sizeof(card->card_name));
+	strscpy(card->card_name, sub->core->v4l2_dev.name,
+		sizeof(card->card_name));
 	card->i2c_adapter = &sub->core->i2c_adap;
 
 	switch(sub->core->type) {
diff --git a/drivers/media/pci/cobalt/cobalt-alsa-main.c b/drivers/media/pci/cobalt/cobalt-alsa-main.c
index e5022b620856..c57f87a68269 100644
--- a/drivers/media/pci/cobalt/cobalt-alsa-main.c
+++ b/drivers/media/pci/cobalt/cobalt-alsa-main.c
@@ -65,7 +65,7 @@ static int snd_cobalt_card_set_names(struct snd_cobalt_card *cobsc)
 	struct snd_card *sc = cobsc->sc;
 
 	/* sc->driver is used by alsa-lib's configurator: simple, unique */
-	strlcpy(sc->driver, "cobalt", sizeof(sc->driver));
+	strscpy(sc->driver, "cobalt", sizeof(sc->driver));
 
 	/* sc->shortname is a symlink in /proc/asound: COBALT-M -> cardN */
 	snprintf(sc->shortname,  sizeof(sc->shortname), "cobalt-%d-%d",
diff --git a/drivers/media/pci/cobalt/cobalt-alsa-pcm.c b/drivers/media/pci/cobalt/cobalt-alsa-pcm.c
index f6a7df13cd04..38d00935a292 100644
--- a/drivers/media/pci/cobalt/cobalt-alsa-pcm.c
+++ b/drivers/media/pci/cobalt/cobalt-alsa-pcm.c
@@ -557,7 +557,7 @@ int snd_cobalt_pcm_create(struct snd_cobalt_card *cobsc)
 				&snd_cobalt_pcm_capture_ops);
 		sp->info_flags = 0;
 		sp->private_data = cobsc;
-		strlcpy(sp->name, "cobalt", sizeof(sp->name));
+		strscpy(sp->name, "cobalt", sizeof(sp->name));
 	} else {
 		cobalt_s_bit_sysctrl(cobalt,
 			COBALT_SYS_CTRL_AUDIO_OPP_RESETN_BIT, 0);
@@ -581,7 +581,7 @@ int snd_cobalt_pcm_create(struct snd_cobalt_card *cobsc)
 				&snd_cobalt_pcm_playback_ops);
 		sp->info_flags = 0;
 		sp->private_data = cobsc;
-		strlcpy(sp->name, "cobalt", sizeof(sp->name));
+		strscpy(sp->name, "cobalt", sizeof(sp->name));
 	}
 
 	return 0;
diff --git a/drivers/media/pci/cobalt/cobalt-v4l2.c b/drivers/media/pci/cobalt/cobalt-v4l2.c
index c8fd2d075f43..0525f5e1565b 100644
--- a/drivers/media/pci/cobalt/cobalt-v4l2.c
+++ b/drivers/media/pci/cobalt/cobalt-v4l2.c
@@ -479,8 +479,8 @@ static int cobalt_querycap(struct file *file, void *priv_fh,
 	struct cobalt_stream *s = video_drvdata(file);
 	struct cobalt *cobalt = s->cobalt;
 
-	strlcpy(vcap->driver, "cobalt", sizeof(vcap->driver));
-	strlcpy(vcap->card, "cobalt", sizeof(vcap->card));
+	strscpy(vcap->driver, "cobalt", sizeof(vcap->driver));
+	strscpy(vcap->card, "cobalt", sizeof(vcap->card));
 	snprintf(vcap->bus_info, sizeof(vcap->bus_info),
 		 "PCIe:%s", pci_name(cobalt->pci_dev));
 	vcap->device_caps = V4L2_CAP_STREAMING | V4L2_CAP_READWRITE;
@@ -693,15 +693,15 @@ static int cobalt_enum_fmt_vid_cap(struct file *file, void *priv_fh,
 {
 	switch (f->index) {
 	case 0:
-		strlcpy(f->description, "YUV 4:2:2", sizeof(f->description));
+		strscpy(f->description, "YUV 4:2:2", sizeof(f->description));
 		f->pixelformat = V4L2_PIX_FMT_YUYV;
 		break;
 	case 1:
-		strlcpy(f->description, "RGB24", sizeof(f->description));
+		strscpy(f->description, "RGB24", sizeof(f->description));
 		f->pixelformat = V4L2_PIX_FMT_RGB24;
 		break;
 	case 2:
-		strlcpy(f->description, "RGB32", sizeof(f->description));
+		strscpy(f->description, "RGB32", sizeof(f->description));
 		f->pixelformat = V4L2_PIX_FMT_BGR32;
 		break;
 	default:
@@ -898,11 +898,11 @@ static int cobalt_enum_fmt_vid_out(struct file *file, void *priv_fh,
 {
 	switch (f->index) {
 	case 0:
-		strlcpy(f->description, "YUV 4:2:2", sizeof(f->description));
+		strscpy(f->description, "YUV 4:2:2", sizeof(f->description));
 		f->pixelformat = V4L2_PIX_FMT_YUYV;
 		break;
 	case 1:
-		strlcpy(f->description, "RGB32", sizeof(f->description));
+		strscpy(f->description, "RGB32", sizeof(f->description));
 		f->pixelformat = V4L2_PIX_FMT_BGR32;
 		break;
 	default:
diff --git a/drivers/media/pci/cx18/cx18-alsa-main.c b/drivers/media/pci/cx18/cx18-alsa-main.c
index 93443d1457c5..687477748fdd 100644
--- a/drivers/media/pci/cx18/cx18-alsa-main.c
+++ b/drivers/media/pci/cx18/cx18-alsa-main.c
@@ -112,7 +112,7 @@ static int snd_cx18_card_set_names(struct snd_cx18_card *cxsc)
 	struct snd_card *sc = cxsc->sc;
 
 	/* sc->driver is used by alsa-lib's configurator: simple, unique */
-	strlcpy(sc->driver, "CX23418", sizeof(sc->driver));
+	strscpy(sc->driver, "CX23418", sizeof(sc->driver));
 
 	/* sc->shortname is a symlink in /proc/asound: CX18-M -> cardN */
 	snprintf(sc->shortname,  sizeof(sc->shortname), "CX18-%d",
diff --git a/drivers/media/pci/cx18/cx18-alsa-pcm.c b/drivers/media/pci/cx18/cx18-alsa-pcm.c
index 4f31042a442a..3eafc27956c2 100644
--- a/drivers/media/pci/cx18/cx18-alsa-pcm.c
+++ b/drivers/media/pci/cx18/cx18-alsa-pcm.c
@@ -345,7 +345,7 @@ int snd_cx18_pcm_create(struct snd_cx18_card *cxsc)
 			&snd_cx18_pcm_capture_ops);
 	sp->info_flags = 0;
 	sp->private_data = cxsc;
-	strlcpy(sp->name, cx->card_name, sizeof(sp->name));
+	strscpy(sp->name, cx->card_name, sizeof(sp->name));
 
 	return 0;
 
diff --git a/drivers/media/pci/cx18/cx18-cards.c b/drivers/media/pci/cx18/cx18-cards.c
index c2cf965d639e..2dcbccfbd60d 100644
--- a/drivers/media/pci/cx18/cx18-cards.c
+++ b/drivers/media/pci/cx18/cx18-cards.c
@@ -602,8 +602,8 @@ int cx18_get_input(struct cx18 *cx, u16 index, struct v4l2_input *input)
 	if (index >= cx->nof_inputs)
 		return -EINVAL;
 	input->index = index;
-	strlcpy(input->name, input_strs[card_input->video_type - 1],
-			sizeof(input->name));
+	strscpy(input->name, input_strs[card_input->video_type - 1],
+		sizeof(input->name));
 	input->type = (card_input->video_type == CX18_CARD_INPUT_VID_TUNER ?
 			V4L2_INPUT_TYPE_TUNER : V4L2_INPUT_TYPE_CAMERA);
 	input->audioset = (1 << cx->nof_audio_inputs) - 1;
@@ -625,8 +625,8 @@ int cx18_get_audio_input(struct cx18 *cx, u16 index, struct v4l2_audio *audio)
 	memset(audio, 0, sizeof(*audio));
 	if (index >= cx->nof_audio_inputs)
 		return -EINVAL;
-	strlcpy(audio->name, input_strs[aud_input->audio_type - 1],
-			sizeof(audio->name));
+	strscpy(audio->name, input_strs[aud_input->audio_type - 1],
+		sizeof(audio->name));
 	audio->index = index;
 	audio->capability = V4L2_AUDCAP_STEREO;
 	return 0;
diff --git a/drivers/media/pci/cx18/cx18-driver.c b/drivers/media/pci/cx18/cx18-driver.c
index 0c389a3fb4e5..56763c4ea1a7 100644
--- a/drivers/media/pci/cx18/cx18-driver.c
+++ b/drivers/media/pci/cx18/cx18-driver.c
@@ -328,7 +328,7 @@ void cx18_read_eeprom(struct cx18 *cx, struct tveeprom *tv)
 	if (!c)
 		return;
 
-	strlcpy(c->name, "cx18 tveeprom tmp", sizeof(c->name));
+	strscpy(c->name, "cx18 tveeprom tmp", sizeof(c->name));
 	c->adapter = &cx->i2c_adap[0];
 	c->addr = 0xa0 >> 1;
 
diff --git a/drivers/media/pci/cx18/cx18-i2c.c b/drivers/media/pci/cx18/cx18-i2c.c
index f0eb181f2b94..a89c666953f5 100644
--- a/drivers/media/pci/cx18/cx18-i2c.c
+++ b/drivers/media/pci/cx18/cx18-i2c.c
@@ -83,7 +83,7 @@ static int cx18_i2c_new_ir(struct cx18 *cx, struct i2c_adapter *adap, u32 hw,
 	unsigned short addr_list[2] = { addr, I2C_CLIENT_END };
 
 	memset(&info, 0, sizeof(struct i2c_board_info));
-	strlcpy(info.type, type, I2C_NAME_SIZE);
+	strscpy(info.type, type, I2C_NAME_SIZE);
 
 	/* Our default information for ir-kbd-i2c.c to use */
 	switch (hw) {
diff --git a/drivers/media/pci/cx18/cx18-ioctl.c b/drivers/media/pci/cx18/cx18-ioctl.c
index 80b902b12a78..854116375a7c 100644
--- a/drivers/media/pci/cx18/cx18-ioctl.c
+++ b/drivers/media/pci/cx18/cx18-ioctl.c
@@ -397,8 +397,8 @@ static int cx18_querycap(struct file *file, void *fh,
 	struct cx18_stream *s = video_drvdata(file);
 	struct cx18 *cx = id->cx;
 
-	strlcpy(vcap->driver, CX18_DRIVER_NAME, sizeof(vcap->driver));
-	strlcpy(vcap->card, cx->card_name, sizeof(vcap->card));
+	strscpy(vcap->driver, CX18_DRIVER_NAME, sizeof(vcap->driver));
+	strscpy(vcap->card, cx->card_name, sizeof(vcap->card));
 	snprintf(vcap->bus_info, sizeof(vcap->bus_info),
 		 "PCI:%s", pci_name(cx->pci_dev));
 	vcap->capabilities = cx->v4l2_cap;	/* capabilities */
@@ -632,9 +632,9 @@ static int cx18_g_tuner(struct file *file, void *fh, struct v4l2_tuner *vt)
 	cx18_call_all(cx, tuner, g_tuner, vt);
 
 	if (vt->type == V4L2_TUNER_RADIO)
-		strlcpy(vt->name, "cx18 Radio Tuner", sizeof(vt->name));
+		strscpy(vt->name, "cx18 Radio Tuner", sizeof(vt->name));
 	else
-		strlcpy(vt->name, "cx18 TV Tuner", sizeof(vt->name));
+		strscpy(vt->name, "cx18 TV Tuner", sizeof(vt->name));
 	return 0;
 }
 
diff --git a/drivers/media/pci/cx23885/cx23885-417.c b/drivers/media/pci/cx23885/cx23885-417.c
index a71f3c7569ce..8579de5bb61b 100644
--- a/drivers/media/pci/cx23885/cx23885-417.c
+++ b/drivers/media/pci/cx23885/cx23885-417.c
@@ -1329,8 +1329,8 @@ static int vidioc_querycap(struct file *file, void  *priv,
 	struct cx23885_dev *dev = video_drvdata(file);
 	struct cx23885_tsport  *tsport = &dev->ts1;
 
-	strlcpy(cap->driver, dev->name, sizeof(cap->driver));
-	strlcpy(cap->card, cx23885_boards[tsport->dev->board].name,
+	strscpy(cap->driver, dev->name, sizeof(cap->driver));
+	strscpy(cap->card, cx23885_boards[tsport->dev->board].name,
 		sizeof(cap->card));
 	sprintf(cap->bus_info, "PCIe:%s", pci_name(dev->pci));
 	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_READWRITE |
@@ -1349,7 +1349,7 @@ static int vidioc_enum_fmt_vid_cap(struct file *file, void  *priv,
 	if (f->index != 0)
 		return -EINVAL;
 
-	strlcpy(f->description, "MPEG", sizeof(f->description));
+	strscpy(f->description, "MPEG", sizeof(f->description));
 	f->pixelformat = V4L2_PIX_FMT_MPEG;
 
 	return 0;
diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c b/drivers/media/pci/cx23885/cx23885-dvb.c
index 7d52173073d6..0d0929c54f93 100644
--- a/drivers/media/pci/cx23885/cx23885-dvb.c
+++ b/drivers/media/pci/cx23885/cx23885-dvb.c
@@ -1165,7 +1165,7 @@ static int dvb_register_ci_mac(struct cx23885_tsport *port)
 		sp2_config.priv = port;
 		sp2_config.ci_control = cx23885_sp2_ci_ctrl;
 		memset(&info, 0, sizeof(struct i2c_board_info));
-		strlcpy(info.type, "sp2", I2C_NAME_SIZE);
+		strscpy(info.type, "sp2", I2C_NAME_SIZE);
 		info.addr = 0x40;
 		info.platform_data = &sp2_config;
 		request_module(info.type);
@@ -1831,7 +1831,7 @@ static int dvb_register(struct cx23885_tsport *port)
 		case 1:
 			/* attach demod + tuner combo */
 			memset(&info, 0, sizeof(info));
-			strlcpy(info.type, "tda10071_cx24118", I2C_NAME_SIZE);
+			strscpy(info.type, "tda10071_cx24118", I2C_NAME_SIZE);
 			info.addr = 0x05;
 			info.platform_data = &tda10071_pdata;
 			request_module("tda10071");
@@ -1848,7 +1848,7 @@ static int dvb_register(struct cx23885_tsport *port)
 			/* attach SEC */
 			a8293_pdata.dvb_frontend = fe0->dvb.frontend;
 			memset(&info, 0, sizeof(info));
-			strlcpy(info.type, "a8293", I2C_NAME_SIZE);
+			strscpy(info.type, "a8293", I2C_NAME_SIZE);
 			info.addr = 0x0b;
 			info.platform_data = &a8293_pdata;
 			request_module("a8293");
@@ -1869,7 +1869,7 @@ static int dvb_register(struct cx23885_tsport *port)
 			si2165_pdata.chip_mode = SI2165_MODE_PLL_XTAL;
 			si2165_pdata.ref_freq_hz = 16000000;
 			memset(&info, 0, sizeof(struct i2c_board_info));
-			strlcpy(info.type, "si2165", I2C_NAME_SIZE);
+			strscpy(info.type, "si2165", I2C_NAME_SIZE);
 			info.addr = 0x64;
 			info.platform_data = &si2165_pdata;
 			request_module(info.type);
@@ -1903,7 +1903,7 @@ static int dvb_register(struct cx23885_tsport *port)
 
 		/* attach demod + tuner combo */
 		memset(&info, 0, sizeof(info));
-		strlcpy(info.type, "tda10071_cx24118", I2C_NAME_SIZE);
+		strscpy(info.type, "tda10071_cx24118", I2C_NAME_SIZE);
 		info.addr = 0x05;
 		info.platform_data = &tda10071_pdata;
 		request_module("tda10071");
@@ -1920,7 +1920,7 @@ static int dvb_register(struct cx23885_tsport *port)
 		/* attach SEC */
 		a8293_pdata.dvb_frontend = fe0->dvb.frontend;
 		memset(&info, 0, sizeof(info));
-		strlcpy(info.type, "a8293", I2C_NAME_SIZE);
+		strscpy(info.type, "a8293", I2C_NAME_SIZE);
 		info.addr = 0x0b;
 		info.platform_data = &a8293_pdata;
 		request_module("a8293");
@@ -1953,7 +1953,7 @@ static int dvb_register(struct cx23885_tsport *port)
 			ts2020_config.fe = fe0->dvb.frontend;
 			ts2020_config.get_agc_pwm = m88ds3103_get_agc_pwm;
 			memset(&info, 0, sizeof(struct i2c_board_info));
-			strlcpy(info.type, "ts2020", I2C_NAME_SIZE);
+			strscpy(info.type, "ts2020", I2C_NAME_SIZE);
 			info.addr = 0x60;
 			info.platform_data = &ts2020_config;
 			request_module(info.type);
@@ -1990,7 +1990,7 @@ static int dvb_register(struct cx23885_tsport *port)
 			si2168_config.fe = &fe0->dvb.frontend;
 			si2168_config.ts_mode = SI2168_TS_SERIAL;
 			memset(&info, 0, sizeof(struct i2c_board_info));
-			strlcpy(info.type, "si2168", I2C_NAME_SIZE);
+			strscpy(info.type, "si2168", I2C_NAME_SIZE);
 			info.addr = 0x64;
 			info.platform_data = &si2168_config;
 			request_module(info.type);
@@ -2009,7 +2009,7 @@ static int dvb_register(struct cx23885_tsport *port)
 			si2157_config.fe = fe0->dvb.frontend;
 			si2157_config.if_port = 1;
 			memset(&info, 0, sizeof(struct i2c_board_info));
-			strlcpy(info.type, "si2157", I2C_NAME_SIZE);
+			strscpy(info.type, "si2157", I2C_NAME_SIZE);
 			info.addr = 0x60;
 			info.platform_data = &si2157_config;
 			request_module(info.type);
@@ -2037,7 +2037,7 @@ static int dvb_register(struct cx23885_tsport *port)
 		si2168_config.fe = &fe0->dvb.frontend;
 		si2168_config.ts_mode = SI2168_TS_PARALLEL;
 		memset(&info, 0, sizeof(struct i2c_board_info));
-		strlcpy(info.type, "si2168", I2C_NAME_SIZE);
+		strscpy(info.type, "si2168", I2C_NAME_SIZE);
 		info.addr = 0x64;
 		info.platform_data = &si2168_config;
 		request_module(info.type);
@@ -2055,7 +2055,7 @@ static int dvb_register(struct cx23885_tsport *port)
 		si2157_config.fe = fe0->dvb.frontend;
 		si2157_config.if_port = 1;
 		memset(&info, 0, sizeof(struct i2c_board_info));
-		strlcpy(info.type, "si2157", I2C_NAME_SIZE);
+		strscpy(info.type, "si2157", I2C_NAME_SIZE);
 		info.addr = 0x60;
 		info.platform_data = &si2157_config;
 		request_module(info.type);
@@ -2085,7 +2085,7 @@ static int dvb_register(struct cx23885_tsport *port)
 		ts2020_config.fe = fe0->dvb.frontend;
 		ts2020_config.get_agc_pwm = m88ds3103_get_agc_pwm;
 		memset(&info, 0, sizeof(struct i2c_board_info));
-		strlcpy(info.type, "ts2020", I2C_NAME_SIZE);
+		strscpy(info.type, "ts2020", I2C_NAME_SIZE);
 		info.addr = 0x60;
 		info.platform_data = &ts2020_config;
 		request_module(info.type);
@@ -2134,7 +2134,7 @@ static int dvb_register(struct cx23885_tsport *port)
 		}
 
 		memset(&info, 0, sizeof(info));
-		strlcpy(info.type, "m88ds3103", I2C_NAME_SIZE);
+		strscpy(info.type, "m88ds3103", I2C_NAME_SIZE);
 		info.addr = 0x68;
 		info.platform_data = &m88ds3103_pdata;
 		request_module(info.type);
@@ -2154,7 +2154,7 @@ static int dvb_register(struct cx23885_tsport *port)
 		ts2020_config.fe = fe0->dvb.frontend;
 		ts2020_config.get_agc_pwm = m88ds3103_get_agc_pwm;
 		memset(&info, 0, sizeof(struct i2c_board_info));
-		strlcpy(info.type, "ts2020", I2C_NAME_SIZE);
+		strscpy(info.type, "ts2020", I2C_NAME_SIZE);
 		info.addr = 0x60;
 		info.platform_data = &ts2020_config;
 		request_module(info.type);
@@ -2199,7 +2199,7 @@ static int dvb_register(struct cx23885_tsport *port)
 		si2168_config.i2c_adapter = &adapter;
 		si2168_config.fe = &fe0->dvb.frontend;
 		memset(&info, 0, sizeof(struct i2c_board_info));
-		strlcpy(info.type, "si2168", I2C_NAME_SIZE);
+		strscpy(info.type, "si2168", I2C_NAME_SIZE);
 		info.addr = 0x64;
 		info.platform_data = &si2168_config;
 		request_module(info.type);
@@ -2217,7 +2217,7 @@ static int dvb_register(struct cx23885_tsport *port)
 		si2157_config.fe = fe0->dvb.frontend;
 		si2157_config.if_port = 1;
 		memset(&info, 0, sizeof(struct i2c_board_info));
-		strlcpy(info.type, "si2157", I2C_NAME_SIZE);
+		strscpy(info.type, "si2157", I2C_NAME_SIZE);
 		info.addr = 0x60;
 		info.platform_data = &si2157_config;
 		request_module(info.type);
@@ -2250,7 +2250,7 @@ static int dvb_register(struct cx23885_tsport *port)
 			/* attach SEC */
 			a8293_pdata.dvb_frontend = fe0->dvb.frontend;
 			memset(&info, 0, sizeof(info));
-			strlcpy(info.type, "a8293", I2C_NAME_SIZE);
+			strscpy(info.type, "a8293", I2C_NAME_SIZE);
 			info.addr = 0x0b;
 			info.platform_data = &a8293_pdata;
 			request_module("a8293");
@@ -2267,7 +2267,7 @@ static int dvb_register(struct cx23885_tsport *port)
 			memset(&m88rs6000t_config, 0, sizeof(m88rs6000t_config));
 			m88rs6000t_config.fe = fe0->dvb.frontend;
 			memset(&info, 0, sizeof(struct i2c_board_info));
-			strlcpy(info.type, "m88rs6000t", I2C_NAME_SIZE);
+			strscpy(info.type, "m88rs6000t", I2C_NAME_SIZE);
 			info.addr = 0x21;
 			info.platform_data = &m88rs6000t_config;
 			request_module("%s", info.type);
@@ -2292,7 +2292,7 @@ static int dvb_register(struct cx23885_tsport *port)
 			si2168_config.fe = &fe0->dvb.frontend;
 			si2168_config.ts_mode = SI2168_TS_SERIAL;
 			memset(&info, 0, sizeof(struct i2c_board_info));
-			strlcpy(info.type, "si2168", I2C_NAME_SIZE);
+			strscpy(info.type, "si2168", I2C_NAME_SIZE);
 			info.addr = 0x64;
 			info.platform_data = &si2168_config;
 			request_module("%s", info.type);
@@ -2310,7 +2310,7 @@ static int dvb_register(struct cx23885_tsport *port)
 			si2157_config.fe = fe0->dvb.frontend;
 			si2157_config.if_port = 1;
 			memset(&info, 0, sizeof(struct i2c_board_info));
-			strlcpy(info.type, "si2157", I2C_NAME_SIZE);
+			strscpy(info.type, "si2157", I2C_NAME_SIZE);
 			info.addr = 0x60;
 			info.platform_data = &si2157_config;
 			request_module("%s", info.type);
@@ -2345,7 +2345,7 @@ static int dvb_register(struct cx23885_tsport *port)
 			si2168_config.fe = &fe0->dvb.frontend;
 			si2168_config.ts_mode = SI2168_TS_SERIAL;
 			memset(&info, 0, sizeof(struct i2c_board_info));
-			strlcpy(info.type, "si2168", I2C_NAME_SIZE);
+			strscpy(info.type, "si2168", I2C_NAME_SIZE);
 			info.addr = 0x64;
 			info.platform_data = &si2168_config;
 			request_module("%s", info.type);
@@ -2363,7 +2363,7 @@ static int dvb_register(struct cx23885_tsport *port)
 			si2157_config.fe = fe0->dvb.frontend;
 			si2157_config.if_port = 1;
 			memset(&info, 0, sizeof(struct i2c_board_info));
-			strlcpy(info.type, "si2157", I2C_NAME_SIZE);
+			strscpy(info.type, "si2157", I2C_NAME_SIZE);
 			info.addr = 0x60;
 			info.platform_data = &si2157_config;
 			request_module("%s", info.type);
@@ -2392,7 +2392,7 @@ static int dvb_register(struct cx23885_tsport *port)
 			si2168_config.fe = &fe0->dvb.frontend;
 			si2168_config.ts_mode = SI2168_TS_SERIAL;
 			memset(&info, 0, sizeof(struct i2c_board_info));
-			strlcpy(info.type, "si2168", I2C_NAME_SIZE);
+			strscpy(info.type, "si2168", I2C_NAME_SIZE);
 			info.addr = 0x66;
 			info.platform_data = &si2168_config;
 			request_module("%s", info.type);
@@ -2410,7 +2410,7 @@ static int dvb_register(struct cx23885_tsport *port)
 			si2157_config.fe = fe0->dvb.frontend;
 			si2157_config.if_port = 1;
 			memset(&info, 0, sizeof(struct i2c_board_info));
-			strlcpy(info.type, "si2157", I2C_NAME_SIZE);
+			strscpy(info.type, "si2157", I2C_NAME_SIZE);
 			info.addr = 0x62;
 			info.platform_data = &si2157_config;
 			request_module("%s", info.type);
@@ -2452,7 +2452,7 @@ static int dvb_register(struct cx23885_tsport *port)
 			si2157_config.if_port = 1;
 			si2157_config.inversion = 1;
 			memset(&info, 0, sizeof(struct i2c_board_info));
-			strlcpy(info.type, "si2157", I2C_NAME_SIZE);
+			strscpy(info.type, "si2157", I2C_NAME_SIZE);
 			info.addr = 0x60;
 			info.platform_data = &si2157_config;
 			request_module("%s", info.type);
@@ -2488,7 +2488,7 @@ static int dvb_register(struct cx23885_tsport *port)
 			si2157_config.if_port = 1;
 			si2157_config.inversion = 1;
 			memset(&info, 0, sizeof(struct i2c_board_info));
-			strlcpy(info.type, "si2157", I2C_NAME_SIZE);
+			strscpy(info.type, "si2157", I2C_NAME_SIZE);
 			info.addr = 0x62;
 			info.platform_data = &si2157_config;
 			request_module("%s", info.type);
@@ -2528,7 +2528,7 @@ static int dvb_register(struct cx23885_tsport *port)
 			si2157_config.if_port = 1;
 			si2157_config.inversion = 1;
 			memset(&info, 0, sizeof(struct i2c_board_info));
-			strlcpy(info.type, "si2157", I2C_NAME_SIZE);
+			strscpy(info.type, "si2157", I2C_NAME_SIZE);
 			info.addr = 0x60;
 			info.platform_data = &si2157_config;
 			request_module("%s", info.type);
diff --git a/drivers/media/pci/cx23885/cx23885-i2c.c b/drivers/media/pci/cx23885/cx23885-i2c.c
index ef863492c0ac..dd67135d2bb6 100644
--- a/drivers/media/pci/cx23885/cx23885-i2c.c
+++ b/drivers/media/pci/cx23885/cx23885-i2c.c
@@ -317,7 +317,7 @@ int cx23885_i2c_register(struct cx23885_i2c *bus)
 	bus->i2c_client = cx23885_i2c_client_template;
 	bus->i2c_adap.dev.parent = &dev->pci->dev;
 
-	strlcpy(bus->i2c_adap.name, bus->dev->name,
+	strscpy(bus->i2c_adap.name, bus->dev->name,
 		sizeof(bus->i2c_adap.name));
 
 	bus->i2c_adap.algo_data = bus;
@@ -345,7 +345,7 @@ int cx23885_i2c_register(struct cx23885_i2c *bus)
 		};
 
 		memset(&info, 0, sizeof(struct i2c_board_info));
-		strlcpy(info.type, "ir_video", I2C_NAME_SIZE);
+		strscpy(info.type, "ir_video", I2C_NAME_SIZE);
 		/* Use quick read command for probe, some IR chips don't
 		 * support writes */
 		i2c_new_probed_device(&bus->i2c_adap, &info, addr_list,
diff --git a/drivers/media/pci/cx23885/cx23885-ioctl.c b/drivers/media/pci/cx23885/cx23885-ioctl.c
index d2cdd40f79f5..d162bf4b4800 100644
--- a/drivers/media/pci/cx23885/cx23885-ioctl.c
+++ b/drivers/media/pci/cx23885/cx23885-ioctl.c
@@ -31,9 +31,9 @@ int cx23885_g_chip_info(struct file *file, void *fh,
 	if (chip->match.addr == 1) {
 		if (dev->v4l_device == NULL)
 			return -EINVAL;
-		strlcpy(chip->name, "cx23417", sizeof(chip->name));
+		strscpy(chip->name, "cx23417", sizeof(chip->name));
 	} else {
-		strlcpy(chip->name, dev->v4l2_dev.name, sizeof(chip->name));
+		strscpy(chip->name, dev->v4l2_dev.name, sizeof(chip->name));
 	}
 	return 0;
 }
diff --git a/drivers/media/pci/cx23885/cx23885-video.c b/drivers/media/pci/cx23885/cx23885-video.c
index f8a3deadc77a..b5ac7a6a9a62 100644
--- a/drivers/media/pci/cx23885/cx23885-video.c
+++ b/drivers/media/pci/cx23885/cx23885-video.c
@@ -640,7 +640,7 @@ static int vidioc_querycap(struct file *file, void  *priv,
 	struct video_device *vdev = video_devdata(file);
 
 	strcpy(cap->driver, "cx23885");
-	strlcpy(cap->card, cx23885_boards[dev->board].name,
+	strscpy(cap->card, cx23885_boards[dev->board].name,
 		sizeof(cap->card));
 	sprintf(cap->bus_info, "PCIe:%s", pci_name(dev->pci));
 	cap->device_caps = V4L2_CAP_READWRITE | V4L2_CAP_STREAMING | V4L2_CAP_AUDIO;
@@ -661,7 +661,7 @@ static int vidioc_enum_fmt_vid_cap(struct file *file, void  *priv,
 	if (unlikely(f->index >= ARRAY_SIZE(formats)))
 		return -EINVAL;
 
-	strlcpy(f->description, formats[f->index].name,
+	strscpy(f->description, formats[f->index].name,
 		sizeof(f->description));
 	f->pixelformat = formats[f->index].fourcc;
 
diff --git a/drivers/media/pci/cx25821/cx25821-i2c.c b/drivers/media/pci/cx25821/cx25821-i2c.c
index 31479a41f359..67d2f7610011 100644
--- a/drivers/media/pci/cx25821/cx25821-i2c.c
+++ b/drivers/media/pci/cx25821/cx25821-i2c.c
@@ -306,7 +306,7 @@ int cx25821_i2c_register(struct cx25821_i2c *bus)
 	bus->i2c_client = cx25821_i2c_client_template;
 	bus->i2c_adap.dev.parent = &dev->pci->dev;
 
-	strlcpy(bus->i2c_adap.name, bus->dev->name, sizeof(bus->i2c_adap.name));
+	strscpy(bus->i2c_adap.name, bus->dev->name, sizeof(bus->i2c_adap.name));
 
 	bus->i2c_adap.algo_data = bus;
 	i2c_set_adapdata(&bus->i2c_adap, &dev->v4l2_dev);
diff --git a/drivers/media/pci/cx25821/cx25821-video.c b/drivers/media/pci/cx25821/cx25821-video.c
index dbaf42ec26cd..21607fbb6758 100644
--- a/drivers/media/pci/cx25821/cx25821-video.c
+++ b/drivers/media/pci/cx25821/cx25821-video.c
@@ -322,7 +322,7 @@ static int cx25821_vidioc_enum_fmt_vid_cap(struct file *file, void *priv,
 	if (unlikely(f->index >= ARRAY_SIZE(formats)))
 		return -EINVAL;
 
-	strlcpy(f->description, formats[f->index].name, sizeof(f->description));
+	strscpy(f->description, formats[f->index].name, sizeof(f->description));
 	f->pixelformat = formats[f->index].fourcc;
 
 	return 0;
@@ -442,7 +442,7 @@ static int cx25821_vidioc_querycap(struct file *file, void *priv,
 	const u32 cap_output = V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_READWRITE;
 
 	strcpy(cap->driver, "cx25821");
-	strlcpy(cap->card, cx25821_boards[dev->board].name, sizeof(cap->card));
+	strscpy(cap->card, cx25821_boards[dev->board].name, sizeof(cap->card));
 	sprintf(cap->bus_info, "PCIe:%s", pci_name(dev->pci));
 	if (chan->id >= VID_CHANNEL_NUM)
 		cap->device_caps = cap_output;
diff --git a/drivers/media/pci/cx88/cx88-blackbird.c b/drivers/media/pci/cx88/cx88-blackbird.c
index 7a4876cf9f08..cf4e926cc388 100644
--- a/drivers/media/pci/cx88/cx88-blackbird.c
+++ b/drivers/media/pci/cx88/cx88-blackbird.c
@@ -814,7 +814,7 @@ static int vidioc_enum_fmt_vid_cap(struct file *file, void  *priv,
 	if (f->index != 0)
 		return -EINVAL;
 
-	strlcpy(f->description, "MPEG", sizeof(f->description));
+	strscpy(f->description, "MPEG", sizeof(f->description));
 	f->pixelformat = V4L2_PIX_FMT_MPEG;
 	f->flags = V4L2_FMT_FLAG_COMPRESSED;
 	return 0;
diff --git a/drivers/media/pci/cx88/cx88-i2c.c b/drivers/media/pci/cx88/cx88-i2c.c
index 99f88a05a7c9..48be0b0ad680 100644
--- a/drivers/media/pci/cx88/cx88-i2c.c
+++ b/drivers/media/pci/cx88/cx88-i2c.c
@@ -140,14 +140,14 @@ int cx88_i2c_init(struct cx88_core *core, struct pci_dev *pci)
 	core->i2c_algo = cx8800_i2c_algo_template;
 
 	core->i2c_adap.dev.parent = &pci->dev;
-	strlcpy(core->i2c_adap.name, core->name, sizeof(core->i2c_adap.name));
+	strscpy(core->i2c_adap.name, core->name, sizeof(core->i2c_adap.name));
 	core->i2c_adap.owner = THIS_MODULE;
 	core->i2c_algo.udelay = i2c_udelay;
 	core->i2c_algo.data = core;
 	i2c_set_adapdata(&core->i2c_adap, &core->v4l2_dev);
 	core->i2c_adap.algo_data = &core->i2c_algo;
 	core->i2c_client.adapter = &core->i2c_adap;
-	strlcpy(core->i2c_client.name, "cx88xx internal", I2C_NAME_SIZE);
+	strscpy(core->i2c_client.name, "cx88xx internal", I2C_NAME_SIZE);
 
 	cx8800_bit_setscl(core, 1);
 	cx8800_bit_setsda(core, 1);
diff --git a/drivers/media/pci/cx88/cx88-input.c b/drivers/media/pci/cx88/cx88-input.c
index 2f5debce4905..c5cee71d744d 100644
--- a/drivers/media/pci/cx88/cx88-input.c
+++ b/drivers/media/pci/cx88/cx88-input.c
@@ -610,7 +610,7 @@ void cx88_i2c_init_ir(struct cx88_core *core)
 		return;
 
 	memset(&info, 0, sizeof(struct i2c_board_info));
-	strlcpy(info.type, "ir_video", I2C_NAME_SIZE);
+	strscpy(info.type, "ir_video", I2C_NAME_SIZE);
 
 	switch (core->boardnr) {
 	case CX88_BOARD_LEADTEK_PVR2000:
@@ -635,7 +635,7 @@ void cx88_i2c_init_ir(struct cx88_core *core)
 
 		if (*addrp == 0x71) {
 			/* Hauppauge Z8F0811 */
-			strlcpy(info.type, "ir_z8f0811_haup", I2C_NAME_SIZE);
+			strscpy(info.type, "ir_z8f0811_haup", I2C_NAME_SIZE);
 			core->init_data.name = core->board.name;
 			core->init_data.ir_codes = RC_MAP_HAUPPAUGE;
 			core->init_data.type = RC_PROTO_BIT_RC5 |
diff --git a/drivers/media/pci/cx88/cx88-video.c b/drivers/media/pci/cx88/cx88-video.c
index 7b113bad70d2..f5d0624023da 100644
--- a/drivers/media/pci/cx88/cx88-video.c
+++ b/drivers/media/pci/cx88/cx88-video.c
@@ -811,7 +811,7 @@ int cx88_querycap(struct file *file, struct cx88_core *core,
 {
 	struct video_device *vdev = video_devdata(file);
 
-	strlcpy(cap->card, core->board.name, sizeof(cap->card));
+	strscpy(cap->card, core->board.name, sizeof(cap->card));
 	cap->device_caps = V4L2_CAP_READWRITE | V4L2_CAP_STREAMING;
 	if (core->board.tuner_type != UNSET)
 		cap->device_caps |= V4L2_CAP_TUNER;
@@ -853,7 +853,7 @@ static int vidioc_enum_fmt_vid_cap(struct file *file, void  *priv,
 	if (unlikely(f->index >= ARRAY_SIZE(formats)))
 		return -EINVAL;
 
-	strlcpy(f->description, formats[f->index].name, sizeof(f->description));
+	strscpy(f->description, formats[f->index].name, sizeof(f->description));
 	f->pixelformat = formats[f->index].fourcc;
 
 	return 0;
diff --git a/drivers/media/pci/cx88/cx88-vp3054-i2c.c b/drivers/media/pci/cx88/cx88-vp3054-i2c.c
index 92876de3841c..e4db636e9fad 100644
--- a/drivers/media/pci/cx88/cx88-vp3054-i2c.c
+++ b/drivers/media/pci/cx88/cx88-vp3054-i2c.c
@@ -114,7 +114,7 @@ int vp3054_i2c_probe(struct cx8802_dev *dev)
 	vp3054_i2c->algo = vp3054_i2c_algo_template;
 
 	vp3054_i2c->adap.dev.parent = &dev->pci->dev;
-	strlcpy(vp3054_i2c->adap.name, core->name,
+	strscpy(vp3054_i2c->adap.name, core->name,
 		sizeof(vp3054_i2c->adap.name));
 	vp3054_i2c->adap.owner = THIS_MODULE;
 	vp3054_i2c->algo.data = dev;
diff --git a/drivers/media/pci/dt3155/dt3155.c b/drivers/media/pci/dt3155/dt3155.c
index 1775c36891ae..bf6e1621ad6b 100644
--- a/drivers/media/pci/dt3155/dt3155.c
+++ b/drivers/media/pci/dt3155/dt3155.c
@@ -378,7 +378,7 @@ static int dt3155_enum_input(struct file *filp, void *p,
 		snprintf(input->name, sizeof(input->name), "VID%d",
 			 input->index);
 	else
-		strlcpy(input->name, "J2/VID0", sizeof(input->name));
+		strscpy(input->name, "J2/VID0", sizeof(input->name));
 	input->type = V4L2_INPUT_TYPE_CAMERA;
 	input->std = V4L2_STD_ALL;
 	input->status = 0;
diff --git a/drivers/media/pci/intel/ipu3/ipu3-cio2.c b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
index f0c6374ee58e..08cf4bf00941 100644
--- a/drivers/media/pci/intel/ipu3/ipu3-cio2.c
+++ b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
@@ -1064,8 +1064,8 @@ static int cio2_v4l2_querycap(struct file *file, void *fh,
 {
 	struct cio2_device *cio2 = video_drvdata(file);
 
-	strlcpy(cap->driver, CIO2_NAME, sizeof(cap->driver));
-	strlcpy(cap->card, CIO2_DEVICE_NAME, sizeof(cap->card));
+	strscpy(cap->driver, CIO2_NAME, sizeof(cap->driver));
+	strscpy(cap->card, CIO2_DEVICE_NAME, sizeof(cap->card));
 	snprintf(cap->bus_info, sizeof(cap->bus_info),
 		 "PCI:%s", pci_name(cio2->pci_dev));
 
@@ -1143,7 +1143,7 @@ cio2_video_enum_input(struct file *file, void *fh, struct v4l2_input *input)
 	if (input->index > 0)
 		return -EINVAL;
 
-	strlcpy(input->name, "camera", sizeof(input->name));
+	strscpy(input->name, "camera", sizeof(input->name));
 	input->type = V4L2_INPUT_TYPE_CAMERA;
 
 	return 0;
@@ -1783,7 +1783,7 @@ static int cio2_pci_probe(struct pci_dev *pci_dev,
 	mutex_init(&cio2->lock);
 
 	cio2->media_dev.dev = &cio2->pci_dev->dev;
-	strlcpy(cio2->media_dev.model, CIO2_DEVICE_NAME,
+	strscpy(cio2->media_dev.model, CIO2_DEVICE_NAME,
 		sizeof(cio2->media_dev.model));
 	snprintf(cio2->media_dev.bus_info, sizeof(cio2->media_dev.bus_info),
 		 "PCI:%s", pci_name(cio2->pci_dev));
diff --git a/drivers/media/pci/ivtv/ivtv-alsa-main.c b/drivers/media/pci/ivtv/ivtv-alsa-main.c
index c1856f609d2c..0de8a9f5011a 100644
--- a/drivers/media/pci/ivtv/ivtv-alsa-main.c
+++ b/drivers/media/pci/ivtv/ivtv-alsa-main.c
@@ -109,7 +109,7 @@ static int snd_ivtv_card_set_names(struct snd_ivtv_card *itvsc)
 	struct snd_card *sc = itvsc->sc;
 
 	/* sc->driver is used by alsa-lib's configurator: simple, unique */
-	strlcpy(sc->driver, "CX2341[56]", sizeof(sc->driver));
+	strscpy(sc->driver, "CX2341[56]", sizeof(sc->driver));
 
 	/* sc->shortname is a symlink in /proc/asound: IVTV-M -> cardN */
 	snprintf(sc->shortname,  sizeof(sc->shortname), "IVTV-%d",
diff --git a/drivers/media/pci/ivtv/ivtv-alsa-pcm.c b/drivers/media/pci/ivtv/ivtv-alsa-pcm.c
index 5326d86fa375..737c52de7558 100644
--- a/drivers/media/pci/ivtv/ivtv-alsa-pcm.c
+++ b/drivers/media/pci/ivtv/ivtv-alsa-pcm.c
@@ -350,7 +350,7 @@ int snd_ivtv_pcm_create(struct snd_ivtv_card *itvsc)
 			&snd_ivtv_pcm_capture_ops);
 	sp->info_flags = 0;
 	sp->private_data = itvsc;
-	strlcpy(sp->name, itv->card_name, sizeof(sp->name));
+	strscpy(sp->name, itv->card_name, sizeof(sp->name));
 
 	return 0;
 
diff --git a/drivers/media/pci/ivtv/ivtv-cards.c b/drivers/media/pci/ivtv/ivtv-cards.c
index c63792964a03..4ff46a6d0503 100644
--- a/drivers/media/pci/ivtv/ivtv-cards.c
+++ b/drivers/media/pci/ivtv/ivtv-cards.c
@@ -1317,8 +1317,8 @@ int ivtv_get_input(struct ivtv *itv, u16 index, struct v4l2_input *input)
 	if (index >= itv->nof_inputs)
 		return -EINVAL;
 	input->index = index;
-	strlcpy(input->name, input_strs[card_input->video_type - 1],
-			sizeof(input->name));
+	strscpy(input->name, input_strs[card_input->video_type - 1],
+		sizeof(input->name));
 	input->type = (card_input->video_type == IVTV_CARD_INPUT_VID_TUNER ?
 			V4L2_INPUT_TYPE_TUNER : V4L2_INPUT_TYPE_CAMERA);
 	input->audioset = (1 << itv->nof_audio_inputs) - 1;
@@ -1334,7 +1334,7 @@ int ivtv_get_output(struct ivtv *itv, u16 index, struct v4l2_output *output)
 	if (index >= itv->card->nof_outputs)
 		return -EINVAL;
 	output->index = index;
-	strlcpy(output->name, card_output->name, sizeof(output->name));
+	strscpy(output->name, card_output->name, sizeof(output->name));
 	output->type = V4L2_OUTPUT_TYPE_ANALOG;
 	output->audioset = 1;
 	output->std = V4L2_STD_ALL;
@@ -1353,8 +1353,8 @@ int ivtv_get_audio_input(struct ivtv *itv, u16 index, struct v4l2_audio *audio)
 	memset(audio, 0, sizeof(*audio));
 	if (index >= itv->nof_audio_inputs)
 		return -EINVAL;
-	strlcpy(audio->name, input_strs[aud_input->audio_type - 1],
-			sizeof(audio->name));
+	strscpy(audio->name, input_strs[aud_input->audio_type - 1],
+		sizeof(audio->name));
 	audio->index = index;
 	audio->capability = V4L2_AUDCAP_STEREO;
 	return 0;
@@ -1365,6 +1365,6 @@ int ivtv_get_audio_output(struct ivtv *itv, u16 index, struct v4l2_audioout *aud
 	memset(aud_output, 0, sizeof(*aud_output));
 	if (itv->card->video_outputs == NULL || index != 0)
 		return -EINVAL;
-	strlcpy(aud_output->name, "A/V Audio Out", sizeof(aud_output->name));
+	strscpy(aud_output->name, "A/V Audio Out", sizeof(aud_output->name));
 	return 0;
 }
diff --git a/drivers/media/pci/ivtv/ivtv-i2c.c b/drivers/media/pci/ivtv/ivtv-i2c.c
index e9ce54dd5e01..5e4e52147fb7 100644
--- a/drivers/media/pci/ivtv/ivtv-i2c.c
+++ b/drivers/media/pci/ivtv/ivtv-i2c.c
@@ -218,7 +218,7 @@ static int ivtv_i2c_new_ir(struct ivtv *itv, u32 hw, const char *type, u8 addr)
 
 	memset(&info, 0, sizeof(struct i2c_board_info));
 	info.platform_data = init_data;
-	strlcpy(info.type, type, I2C_NAME_SIZE);
+	strscpy(info.type, type, I2C_NAME_SIZE);
 
 	return i2c_new_probed_device(adap, &info, addr_list, NULL) == NULL ?
 	       -1 : 0;
@@ -246,7 +246,7 @@ struct i2c_client *ivtv_i2c_new_ir_legacy(struct ivtv *itv)
 	};
 
 	memset(&info, 0, sizeof(struct i2c_board_info));
-	strlcpy(info.type, "ir_video", I2C_NAME_SIZE);
+	strscpy(info.type, "ir_video", I2C_NAME_SIZE);
 	return i2c_new_probed_device(&itv->i2c_adap, &info, addr_list, NULL);
 }
 
diff --git a/drivers/media/pci/ivtv/ivtv-ioctl.c b/drivers/media/pci/ivtv/ivtv-ioctl.c
index 4cdc6d2be85d..edb85ca9c0c2 100644
--- a/drivers/media/pci/ivtv/ivtv-ioctl.c
+++ b/drivers/media/pci/ivtv/ivtv-ioctl.c
@@ -747,8 +747,8 @@ static int ivtv_querycap(struct file *file, void *fh, struct v4l2_capability *vc
 	struct ivtv *itv = id->itv;
 	struct ivtv_stream *s = &itv->streams[id->type];
 
-	strlcpy(vcap->driver, IVTV_DRIVER_NAME, sizeof(vcap->driver));
-	strlcpy(vcap->card, itv->card_name, sizeof(vcap->card));
+	strscpy(vcap->driver, IVTV_DRIVER_NAME, sizeof(vcap->driver));
+	strscpy(vcap->card, itv->card_name, sizeof(vcap->card));
 	snprintf(vcap->bus_info, sizeof(vcap->bus_info), "PCI:%s", pci_name(itv->pdev));
 	vcap->capabilities = itv->v4l2_cap | V4L2_CAP_DEVICE_CAPS;
 	vcap->device_caps = s->caps;
@@ -1227,9 +1227,9 @@ static int ivtv_g_tuner(struct file *file, void *fh, struct v4l2_tuner *vt)
 	ivtv_call_all(itv, tuner, g_tuner, vt);
 
 	if (vt->type == V4L2_TUNER_RADIO)
-		strlcpy(vt->name, "ivtv Radio Tuner", sizeof(vt->name));
+		strscpy(vt->name, "ivtv Radio Tuner", sizeof(vt->name));
 	else
-		strlcpy(vt->name, "ivtv TV Tuner", sizeof(vt->name));
+		strscpy(vt->name, "ivtv TV Tuner", sizeof(vt->name));
 	return 0;
 }
 
diff --git a/drivers/media/pci/ivtv/ivtvfb.c b/drivers/media/pci/ivtv/ivtvfb.c
index 5ddaa8ed11a5..3e02de02ffdd 100644
--- a/drivers/media/pci/ivtv/ivtvfb.c
+++ b/drivers/media/pci/ivtv/ivtvfb.c
@@ -624,7 +624,7 @@ static int ivtvfb_get_fix(struct ivtv *itv, struct fb_fix_screeninfo *fix)
 
 	IVTVFB_DEBUG_INFO("ivtvfb_get_fix\n");
 	memset(fix, 0, sizeof(struct fb_fix_screeninfo));
-	strlcpy(fix->id, "cx23415 TV out", sizeof(fix->id));
+	strscpy(fix->id, "cx23415 TV out", sizeof(fix->id));
 	fix->smem_start = oi->video_pbase;
 	fix->smem_len = oi->video_buffer_size;
 	fix->type = FB_TYPE_PACKED_PIXELS;
diff --git a/drivers/media/pci/pt3/pt3.c b/drivers/media/pci/pt3/pt3.c
index 90273b4d772f..7a7afae4c84c 100644
--- a/drivers/media/pci/pt3/pt3.c
+++ b/drivers/media/pci/pt3/pt3.c
@@ -765,7 +765,7 @@ static int pt3_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	i2c->algo = &pt3_i2c_algo;
 	i2c->algo_data = NULL;
 	i2c->dev.parent = &pdev->dev;
-	strlcpy(i2c->name, DRV_NAME, sizeof(i2c->name));
+	strscpy(i2c->name, DRV_NAME, sizeof(i2c->name));
 	i2c_set_adapdata(i2c, pt3);
 	ret = i2c_add_adapter(i2c);
 	if (ret < 0)
diff --git a/drivers/media/pci/saa7134/saa7134-empress.c b/drivers/media/pci/saa7134/saa7134-empress.c
index 66acfd35ffc6..747a082229dc 100644
--- a/drivers/media/pci/saa7134/saa7134-empress.c
+++ b/drivers/media/pci/saa7134/saa7134-empress.c
@@ -100,7 +100,7 @@ static int empress_enum_fmt_vid_cap(struct file *file, void  *priv,
 	if (f->index != 0)
 		return -EINVAL;
 
-	strlcpy(f->description, "MPEG TS", sizeof(f->description));
+	strscpy(f->description, "MPEG TS", sizeof(f->description));
 	f->pixelformat = V4L2_PIX_FMT_MPEG;
 	f->flags = V4L2_FMT_FLAG_COMPRESSED;
 	return 0;
diff --git a/drivers/media/pci/saa7134/saa7134-go7007.c b/drivers/media/pci/saa7134/saa7134-go7007.c
index 2799538e2d7e..275c5e151818 100644
--- a/drivers/media/pci/saa7134/saa7134-go7007.c
+++ b/drivers/media/pci/saa7134/saa7134-go7007.c
@@ -435,7 +435,7 @@ static int saa7134_go7007_init(struct saa7134_dev *dev)
 
 	go->board_id = GO7007_BOARDID_PCI_VOYAGER;
 	snprintf(go->bus_info, sizeof(go->bus_info), "PCI:%s", pci_name(dev->pci));
-	strlcpy(go->name, saa7134_boards[dev->board].name, sizeof(go->name));
+	strscpy(go->name, saa7134_boards[dev->board].name, sizeof(go->name));
 	go->hpi_ops = &saa7134_go7007_hpi_ops;
 	go->hpi_context = saa;
 	saa->dev = dev;
diff --git a/drivers/media/pci/saa7134/saa7134-input.c b/drivers/media/pci/saa7134/saa7134-input.c
index 0e28c5021ac4..999b2774b220 100644
--- a/drivers/media/pci/saa7134/saa7134-input.c
+++ b/drivers/media/pci/saa7134/saa7134-input.c
@@ -953,7 +953,7 @@ void saa7134_probe_i2c_ir(struct saa7134_dev *dev)
 
 	memset(&info, 0, sizeof(struct i2c_board_info));
 	memset(&dev->init_data, 0, sizeof(dev->init_data));
-	strlcpy(info.type, "ir_video", I2C_NAME_SIZE);
+	strscpy(info.type, "ir_video", I2C_NAME_SIZE);
 
 	switch (dev->board) {
 	case SAA7134_BOARD_PINNACLE_PCTV_110i:
diff --git a/drivers/media/pci/saa7134/saa7134-video.c b/drivers/media/pci/saa7134/saa7134-video.c
index 1a50ec9d084f..b41de940a1ee 100644
--- a/drivers/media/pci/saa7134/saa7134-video.c
+++ b/drivers/media/pci/saa7134/saa7134-video.c
@@ -1503,7 +1503,7 @@ int saa7134_querycap(struct file *file, void *priv,
 	unsigned int tuner_type = dev->tuner_type;
 
 	strcpy(cap->driver, "saa7134");
-	strlcpy(cap->card, saa7134_boards[dev->board].name,
+	strscpy(cap->card, saa7134_boards[dev->board].name,
 		sizeof(cap->card));
 	sprintf(cap->bus_info, "PCI:%s", pci_name(dev->pci));
 
@@ -1819,7 +1819,7 @@ static int saa7134_enum_fmt_vid_cap(struct file *file, void  *priv,
 	if (f->index >= FORMATS)
 		return -EINVAL;
 
-	strlcpy(f->description, formats[f->index].name,
+	strscpy(f->description, formats[f->index].name,
 		sizeof(f->description));
 
 	f->pixelformat = formats[f->index].fourcc;
@@ -1838,7 +1838,7 @@ static int saa7134_enum_fmt_vid_overlay(struct file *file, void  *priv,
 	if ((f->index >= FORMATS) || formats[f->index].planar)
 		return -EINVAL;
 
-	strlcpy(f->description, formats[f->index].name,
+	strscpy(f->description, formats[f->index].name,
 		sizeof(f->description));
 
 	f->pixelformat = formats[f->index].fourcc;
diff --git a/drivers/media/pci/saa7146/mxb.c b/drivers/media/pci/saa7146/mxb.c
index 6b5582b7c595..44440c6208df 100644
--- a/drivers/media/pci/saa7146/mxb.c
+++ b/drivers/media/pci/saa7146/mxb.c
@@ -553,7 +553,7 @@ static int vidioc_g_tuner(struct file *file, void *fh, struct v4l2_tuner *t)
 	DEB_EE("VIDIOC_G_TUNER: %d\n", t->index);
 
 	memset(t, 0, sizeof(*t));
-	strlcpy(t->name, "TV Tuner", sizeof(t->name));
+	strscpy(t->name, "TV Tuner", sizeof(t->name));
 	t->type = V4L2_TUNER_ANALOG_TV;
 	t->capability = V4L2_TUNER_CAP_NORM | V4L2_TUNER_CAP_STEREO |
 			V4L2_TUNER_CAP_LANG1 | V4L2_TUNER_CAP_LANG2 | V4L2_TUNER_CAP_SAP;
diff --git a/drivers/media/pci/saa7164/saa7164-dvb.c b/drivers/media/pci/saa7164/saa7164-dvb.c
index 4f9f03c3b252..dfb118d7d1ec 100644
--- a/drivers/media/pci/saa7164/saa7164-dvb.c
+++ b/drivers/media/pci/saa7164/saa7164-dvb.c
@@ -120,7 +120,7 @@ static int si2157_attach(struct saa7164_port *port, struct i2c_adapter *adapter,
 
 	memset(&bi, 0, sizeof(bi));
 
-	strlcpy(bi.type, "si2157", I2C_NAME_SIZE);
+	strscpy(bi.type, "si2157", I2C_NAME_SIZE);
 	bi.platform_data = cfg;
 	bi.addr = addr8bit >> 1;
 
@@ -643,7 +643,7 @@ int saa7164_dvb_register(struct saa7164_port *port)
 			si2168_config.fe = &port->dvb.frontend;
 			si2168_config.ts_mode = SI2168_TS_SERIAL;
 			memset(&info, 0, sizeof(struct i2c_board_info));
-			strlcpy(info.type, "si2168", I2C_NAME_SIZE);
+			strscpy(info.type, "si2168", I2C_NAME_SIZE);
 			info.addr = 0xc8 >> 1;
 			info.platform_data = &si2168_config;
 			request_module(info.type);
@@ -663,7 +663,7 @@ int saa7164_dvb_register(struct saa7164_port *port)
 			si2157_config.if_port = 1;
 			si2157_config.fe = port->dvb.frontend;
 			memset(&info, 0, sizeof(struct i2c_board_info));
-			strlcpy(info.type, "si2157", I2C_NAME_SIZE);
+			strscpy(info.type, "si2157", I2C_NAME_SIZE);
 			info.addr = 0xc0 >> 1;
 			info.platform_data = &si2157_config;
 			request_module(info.type);
@@ -688,7 +688,7 @@ int saa7164_dvb_register(struct saa7164_port *port)
 			si2168_config.fe = &port->dvb.frontend;
 			si2168_config.ts_mode = SI2168_TS_SERIAL;
 			memset(&info, 0, sizeof(struct i2c_board_info));
-			strlcpy(info.type, "si2168", I2C_NAME_SIZE);
+			strscpy(info.type, "si2168", I2C_NAME_SIZE);
 			info.addr = 0xcc >> 1;
 			info.platform_data = &si2168_config;
 			request_module(info.type);
@@ -708,7 +708,7 @@ int saa7164_dvb_register(struct saa7164_port *port)
 			si2157_config.fe = port->dvb.frontend;
 			si2157_config.if_port = 1;
 			memset(&info, 0, sizeof(struct i2c_board_info));
-			strlcpy(info.type, "si2157", I2C_NAME_SIZE);
+			strscpy(info.type, "si2157", I2C_NAME_SIZE);
 			info.addr = 0xc0 >> 1;
 			info.platform_data = &si2157_config;
 			request_module(info.type);
diff --git a/drivers/media/pci/saa7164/saa7164-encoder.c b/drivers/media/pci/saa7164/saa7164-encoder.c
index 32136ebe4f61..50161921e4e7 100644
--- a/drivers/media/pci/saa7164/saa7164-encoder.c
+++ b/drivers/media/pci/saa7164/saa7164-encoder.c
@@ -498,7 +498,7 @@ static int vidioc_querycap(struct file *file, void  *priv,
 	struct saa7164_dev *dev = port->dev;
 
 	strcpy(cap->driver, dev->name);
-	strlcpy(cap->card, saa7164_boards[dev->board].name,
+	strscpy(cap->card, saa7164_boards[dev->board].name,
 		sizeof(cap->card));
 	sprintf(cap->bus_info, "PCI:%s", pci_name(dev->pci));
 
@@ -520,7 +520,7 @@ static int vidioc_enum_fmt_vid_cap(struct file *file, void  *priv,
 	if (f->index != 0)
 		return -EINVAL;
 
-	strlcpy(f->description, "MPEG", sizeof(f->description));
+	strscpy(f->description, "MPEG", sizeof(f->description));
 	f->pixelformat = V4L2_PIX_FMT_MPEG;
 
 	return 0;
diff --git a/drivers/media/pci/saa7164/saa7164-i2c.c b/drivers/media/pci/saa7164/saa7164-i2c.c
index 6d13cbb9d010..317f48bc6506 100644
--- a/drivers/media/pci/saa7164/saa7164-i2c.c
+++ b/drivers/media/pci/saa7164/saa7164-i2c.c
@@ -99,7 +99,7 @@ int saa7164_i2c_register(struct saa7164_i2c *bus)
 
 	bus->i2c_adap.dev.parent = &dev->pci->dev;
 
-	strlcpy(bus->i2c_adap.name, bus->dev->name,
+	strscpy(bus->i2c_adap.name, bus->dev->name,
 		sizeof(bus->i2c_adap.name));
 
 	bus->i2c_adap.algo_data = bus;
diff --git a/drivers/media/pci/saa7164/saa7164-vbi.c b/drivers/media/pci/saa7164/saa7164-vbi.c
index 221de91a8bae..17b7cabf9a1f 100644
--- a/drivers/media/pci/saa7164/saa7164-vbi.c
+++ b/drivers/media/pci/saa7164/saa7164-vbi.c
@@ -209,7 +209,7 @@ static int vidioc_querycap(struct file *file, void  *priv,
 	struct saa7164_dev *dev = port->dev;
 
 	strcpy(cap->driver, dev->name);
-	strlcpy(cap->card, saa7164_boards[dev->board].name,
+	strscpy(cap->card, saa7164_boards[dev->board].name,
 		sizeof(cap->card));
 	sprintf(cap->bus_info, "PCI:%s", pci_name(dev->pci));
 
diff --git a/drivers/media/pci/smipcie/smipcie-main.c b/drivers/media/pci/smipcie/smipcie-main.c
index 6dbe3b4d09ce..4c2da27fee4b 100644
--- a/drivers/media/pci/smipcie/smipcie-main.c
+++ b/drivers/media/pci/smipcie/smipcie-main.c
@@ -549,7 +549,7 @@ static int smi_dvbsky_m88ds3103_fe_attach(struct smi_port *port)
 	}
 	/* attach tuner */
 	ts2020_config.fe = port->fe;
-	strlcpy(tuner_info.type, "ts2020", I2C_NAME_SIZE);
+	strscpy(tuner_info.type, "ts2020", I2C_NAME_SIZE);
 	tuner_info.addr = 0x60;
 	tuner_info.platform_data = &ts2020_config;
 	tuner_client = smi_add_i2c_client(tuner_i2c_adapter, &tuner_info);
@@ -605,7 +605,7 @@ static int smi_dvbsky_m88rs6000_fe_attach(struct smi_port *port)
 	}
 	/* attach tuner */
 	m88rs6000t_config.fe = port->fe;
-	strlcpy(tuner_info.type, "m88rs6000t", I2C_NAME_SIZE);
+	strscpy(tuner_info.type, "m88rs6000t", I2C_NAME_SIZE);
 	tuner_info.addr = 0x21;
 	tuner_info.platform_data = &m88rs6000t_config;
 	tuner_client = smi_add_i2c_client(tuner_i2c_adapter, &tuner_info);
@@ -647,7 +647,7 @@ static int smi_dvbsky_sit2_fe_attach(struct smi_port *port)
 	si2168_config.ts_mode = SI2168_TS_PARALLEL;
 
 	memset(&client_info, 0, sizeof(struct i2c_board_info));
-	strlcpy(client_info.type, "si2168", I2C_NAME_SIZE);
+	strscpy(client_info.type, "si2168", I2C_NAME_SIZE);
 	client_info.addr = 0x64;
 	client_info.platform_data = &si2168_config;
 
@@ -664,7 +664,7 @@ static int smi_dvbsky_sit2_fe_attach(struct smi_port *port)
 	si2157_config.if_port = 1;
 
 	memset(&client_info, 0, sizeof(struct i2c_board_info));
-	strlcpy(client_info.type, "si2157", I2C_NAME_SIZE);
+	strscpy(client_info.type, "si2157", I2C_NAME_SIZE);
 	client_info.addr = 0x60;
 	client_info.platform_data = &si2157_config;
 
diff --git a/drivers/media/pci/solo6x10/solo6x10-v4l2.c b/drivers/media/pci/solo6x10/solo6x10-v4l2.c
index 99ffd1ed4a73..351bc434d3a2 100644
--- a/drivers/media/pci/solo6x10/solo6x10-v4l2.c
+++ b/drivers/media/pci/solo6x10/solo6x10-v4l2.c
@@ -470,7 +470,7 @@ static int solo_enum_fmt_cap(struct file *file, void *priv,
 		return -EINVAL;
 
 	f->pixelformat = V4L2_PIX_FMT_UYVY;
-	strlcpy(f->description, "UYUV 4:2:2 Packed", sizeof(f->description));
+	strscpy(f->description, "UYUV 4:2:2 Packed", sizeof(f->description));
 
 	return 0;
 }
diff --git a/drivers/media/pci/ttpci/av7110.c b/drivers/media/pci/ttpci/av7110.c
index d6816effb878..409defc75c05 100644
--- a/drivers/media/pci/ttpci/av7110.c
+++ b/drivers/media/pci/ttpci/av7110.c
@@ -2482,7 +2482,8 @@ static int av7110_attach(struct saa7146_dev* dev,
 	   get recognized before the main driver is fully loaded */
 	saa7146_write(dev, GPIO_CTRL, 0x500000);
 
-	strlcpy(av7110->i2c_adap.name, pci_ext->ext_priv, sizeof(av7110->i2c_adap.name));
+	strscpy(av7110->i2c_adap.name, pci_ext->ext_priv,
+		sizeof(av7110->i2c_adap.name));
 
 	saa7146_i2c_adapter_prepare(dev, &av7110->i2c_adap, SAA7146_I2C_BUS_BIT_RATE_120); /* 275 kHz */
 
diff --git a/drivers/media/pci/ttpci/budget-core.c b/drivers/media/pci/ttpci/budget-core.c
index b3dc45b91101..505356bde14b 100644
--- a/drivers/media/pci/ttpci/budget-core.c
+++ b/drivers/media/pci/ttpci/budget-core.c
@@ -504,7 +504,8 @@ int ttpci_budget_init(struct budget *budget, struct saa7146_dev *dev,
 	if (bi->type != BUDGET_FS_ACTIVY)
 		saa7146_write(dev, GPIO_CTRL, 0x500000);	/* GPIO 3 = 1 */
 
-	strlcpy(budget->i2c_adap.name, budget->card->name, sizeof(budget->i2c_adap.name));
+	strscpy(budget->i2c_adap.name, budget->card->name,
+		sizeof(budget->i2c_adap.name));
 
 	saa7146_i2c_adapter_prepare(dev, &budget->i2c_adap, SAA7146_I2C_BUS_BIT_RATE_120);
 	strcpy(budget->i2c_adap.name, budget->card->name);
diff --git a/drivers/media/pci/tw68/tw68-video.c b/drivers/media/pci/tw68/tw68-video.c
index 8c1f4a049764..08e7dd6ecb07 100644
--- a/drivers/media/pci/tw68/tw68-video.c
+++ b/drivers/media/pci/tw68/tw68-video.c
@@ -735,7 +735,7 @@ static int tw68_querycap(struct file *file, void  *priv,
 	struct tw68_dev *dev = video_drvdata(file);
 
 	strcpy(cap->driver, "tw68");
-	strlcpy(cap->card, "Techwell Capture Card",
+	strscpy(cap->card, "Techwell Capture Card",
 		sizeof(cap->card));
 	sprintf(cap->bus_info, "PCI:%s", pci_name(dev->pci));
 	cap->device_caps =
@@ -789,7 +789,7 @@ static int tw68_enum_fmt_vid_cap(struct file *file, void  *priv,
 	if (f->index >= FORMATS)
 		return -EINVAL;
 
-	strlcpy(f->description, formats[f->index].name,
+	strscpy(f->description, formats[f->index].name,
 		sizeof(f->description));
 
 	f->pixelformat = formats[f->index].fourcc;
diff --git a/drivers/media/pci/tw686x/tw686x-audio.c b/drivers/media/pci/tw686x/tw686x-audio.c
index 77190768622a..a28329698e20 100644
--- a/drivers/media/pci/tw686x/tw686x-audio.c
+++ b/drivers/media/pci/tw686x/tw686x-audio.c
@@ -295,7 +295,7 @@ static int tw686x_snd_pcm_init(struct tw686x_dev *dev)
 	snd_pcm_set_ops(pcm, SNDRV_PCM_STREAM_CAPTURE, &tw686x_pcm_ops);
 	snd_pcm_chip(pcm) = dev;
 	pcm->info_flags = 0;
-	strlcpy(pcm->name, "tw686x PCM", sizeof(pcm->name));
+	strscpy(pcm->name, "tw686x PCM", sizeof(pcm->name));
 
 	for (i = 0, ss = pcm->streams[SNDRV_PCM_STREAM_CAPTURE].substream;
 	     ss; ss = ss->next, i++)
@@ -390,9 +390,9 @@ int tw686x_audio_init(struct tw686x_dev *dev)
 		return err;
 
 	dev->snd_card = card;
-	strlcpy(card->driver, "tw686x", sizeof(card->driver));
-	strlcpy(card->shortname, "tw686x", sizeof(card->shortname));
-	strlcpy(card->longname, pci_name(pci_dev), sizeof(card->longname));
+	strscpy(card->driver, "tw686x", sizeof(card->driver));
+	strscpy(card->shortname, "tw686x", sizeof(card->shortname));
+	strscpy(card->longname, pci_name(pci_dev), sizeof(card->longname));
 	snd_card_set_dev(card, &pci_dev->dev);
 
 	for (ch = 0; ch < max_channels(dev); ch++) {
diff --git a/drivers/media/pci/tw686x/tw686x-video.c b/drivers/media/pci/tw686x/tw686x-video.c
index 3a06c000f97b..4890b7f1248b 100644
--- a/drivers/media/pci/tw686x/tw686x-video.c
+++ b/drivers/media/pci/tw686x/tw686x-video.c
@@ -765,8 +765,8 @@ static int tw686x_querycap(struct file *file, void *priv,
 	struct tw686x_video_channel *vc = video_drvdata(file);
 	struct tw686x_dev *dev = vc->dev;
 
-	strlcpy(cap->driver, "tw686x", sizeof(cap->driver));
-	strlcpy(cap->card, dev->name, sizeof(cap->card));
+	strscpy(cap->driver, "tw686x", sizeof(cap->driver));
+	strscpy(cap->card, dev->name, sizeof(cap->card));
 	snprintf(cap->bus_info, sizeof(cap->bus_info),
 		 "PCI:%s", pci_name(dev->pci_dev));
 	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING |
diff --git a/drivers/media/platform/am437x/am437x-vpfe.c b/drivers/media/platform/am437x/am437x-vpfe.c
index b05738a95e55..28590cf3770b 100644
--- a/drivers/media/platform/am437x/am437x-vpfe.c
+++ b/drivers/media/platform/am437x/am437x-vpfe.c
@@ -1408,8 +1408,8 @@ static int vpfe_querycap(struct file *file, void  *priv,
 
 	vpfe_dbg(2, vpfe, "vpfe_querycap\n");
 
-	strlcpy(cap->driver, VPFE_MODULE_NAME, sizeof(cap->driver));
-	strlcpy(cap->card, "TI AM437x VPFE", sizeof(cap->card));
+	strscpy(cap->driver, VPFE_MODULE_NAME, sizeof(cap->driver));
+	strscpy(cap->card, "TI AM437x VPFE", sizeof(cap->card));
 	snprintf(cap->bus_info, sizeof(cap->bus_info),
 			"platform:%s", vpfe->v4l2_dev.name);
 	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING |
@@ -2386,7 +2386,7 @@ static int vpfe_probe_complete(struct vpfe_device *vpfe)
 	INIT_LIST_HEAD(&vpfe->dma_queue);
 
 	vdev = &vpfe->video_dev;
-	strlcpy(vdev->name, VPFE_MODULE_NAME, sizeof(vdev->name));
+	strscpy(vdev->name, VPFE_MODULE_NAME, sizeof(vdev->name));
 	vdev->release = video_device_release_empty;
 	vdev->fops = &vpfe_fops;
 	vdev->ioctl_ops = &vpfe_ioctl_ops;
diff --git a/drivers/media/platform/atmel/atmel-isc.c b/drivers/media/platform/atmel/atmel-isc.c
index d89e14524d42..776a92d7387f 100644
--- a/drivers/media/platform/atmel/atmel-isc.c
+++ b/drivers/media/platform/atmel/atmel-isc.c
@@ -1951,7 +1951,7 @@ static int isc_async_complete(struct v4l2_async_notifier *notifier)
 	INIT_WORK(&isc->awb_work, isc_awb_work);
 
 	/* Register video device */
-	strlcpy(vdev->name, ATMEL_ISC_NAME, sizeof(vdev->name));
+	strscpy(vdev->name, ATMEL_ISC_NAME, sizeof(vdev->name));
 	vdev->release		= video_device_release_empty;
 	vdev->fops		= &isc_fops;
 	vdev->ioctl_ops		= &isc_ioctl_ops;
diff --git a/drivers/media/platform/atmel/atmel-isi.c b/drivers/media/platform/atmel/atmel-isi.c
index e8db4df1e7c4..26874575d381 100644
--- a/drivers/media/platform/atmel/atmel-isi.c
+++ b/drivers/media/platform/atmel/atmel-isi.c
@@ -655,9 +655,9 @@ static int isi_enum_fmt_vid_cap(struct file *file, void  *priv,
 static int isi_querycap(struct file *file, void *priv,
 			struct v4l2_capability *cap)
 {
-	strlcpy(cap->driver, "atmel-isi", sizeof(cap->driver));
-	strlcpy(cap->card, "Atmel Image Sensor Interface", sizeof(cap->card));
-	strlcpy(cap->bus_info, "platform:isi", sizeof(cap->bus_info));
+	strscpy(cap->driver, "atmel-isi", sizeof(cap->driver));
+	strscpy(cap->card, "Atmel Image Sensor Interface", sizeof(cap->card));
+	strscpy(cap->bus_info, "platform:isi", sizeof(cap->bus_info));
 	return 0;
 }
 
@@ -668,7 +668,7 @@ static int isi_enum_input(struct file *file, void *priv,
 		return -EINVAL;
 
 	i->type = V4L2_INPUT_TYPE_CAMERA;
-	strlcpy(i->name, "Camera", sizeof(i->name));
+	strscpy(i->name, "Camera", sizeof(i->name));
 	return 0;
 }
 
@@ -1202,7 +1202,7 @@ static int atmel_isi_probe(struct platform_device *pdev)
 	isi->vdev->fops = &isi_fops;
 	isi->vdev->v4l2_dev = &isi->v4l2_dev;
 	isi->vdev->queue = &isi->queue;
-	strlcpy(isi->vdev->name, KBUILD_MODNAME, sizeof(isi->vdev->name));
+	strscpy(isi->vdev->name, KBUILD_MODNAME, sizeof(isi->vdev->name));
 	isi->vdev->release = video_device_release;
 	isi->vdev->ioctl_ops = &isi_ioctl_ops;
 	isi->vdev->lock = &isi->lock;
diff --git a/drivers/media/platform/coda/coda-common.c b/drivers/media/platform/coda/coda-common.c
index 726b3b93a486..0bffa1e02e58 100644
--- a/drivers/media/platform/coda/coda-common.c
+++ b/drivers/media/platform/coda/coda-common.c
@@ -390,10 +390,10 @@ static int coda_querycap(struct file *file, void *priv,
 {
 	struct coda_ctx *ctx = fh_to_ctx(priv);
 
-	strlcpy(cap->driver, CODA_NAME, sizeof(cap->driver));
-	strlcpy(cap->card, coda_product_name(ctx->dev->devtype->product),
+	strscpy(cap->driver, CODA_NAME, sizeof(cap->driver));
+	strscpy(cap->card, coda_product_name(ctx->dev->devtype->product),
 		sizeof(cap->card));
-	strlcpy(cap->bus_info, "platform:" CODA_NAME, sizeof(cap->bus_info));
+	strscpy(cap->bus_info, "platform:" CODA_NAME, sizeof(cap->bus_info));
 	cap->device_caps = V4L2_CAP_VIDEO_M2M | V4L2_CAP_STREAMING;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 
@@ -2408,7 +2408,7 @@ static int coda_register_device(struct coda_dev *dev, int i)
 	if (i >= dev->devtype->num_vdevs)
 		return -EINVAL;
 
-	strlcpy(vfd->name, dev->devtype->vdevs[i]->name, sizeof(vfd->name));
+	strscpy(vfd->name, dev->devtype->vdevs[i]->name, sizeof(vfd->name));
 	vfd->fops	= &coda_fops;
 	vfd->ioctl_ops	= &coda_ioctl_ops;
 	vfd->release	= video_device_release_empty,
diff --git a/drivers/media/platform/davinci/vpbe_display.c b/drivers/media/platform/davinci/vpbe_display.c
index b0eb3d899eb4..a96c9337ae58 100644
--- a/drivers/media/platform/davinci/vpbe_display.c
+++ b/drivers/media/platform/davinci/vpbe_display.c
@@ -647,7 +647,7 @@ static int vpbe_display_querycap(struct file *file, void  *priv,
 		dev_name(vpbe_dev->pdev));
 	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s",
 		 dev_name(vpbe_dev->pdev));
-	strlcpy(cap->card, vpbe_dev->cfg->module_name, sizeof(cap->card));
+	strscpy(cap->card, vpbe_dev->cfg->module_name, sizeof(cap->card));
 
 	return 0;
 }
diff --git a/drivers/media/platform/davinci/vpfe_capture.c b/drivers/media/platform/davinci/vpfe_capture.c
index 8613358ed245..ea3ddd5a42bd 100644
--- a/drivers/media/platform/davinci/vpfe_capture.c
+++ b/drivers/media/platform/davinci/vpfe_capture.c
@@ -889,9 +889,9 @@ static int vpfe_querycap(struct file *file, void  *priv,
 
 	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
-	strlcpy(cap->driver, CAPTURE_DRV_NAME, sizeof(cap->driver));
-	strlcpy(cap->bus_info, "VPFE", sizeof(cap->bus_info));
-	strlcpy(cap->card, vpfe_dev->cfg->card_name, sizeof(cap->card));
+	strscpy(cap->driver, CAPTURE_DRV_NAME, sizeof(cap->driver));
+	strscpy(cap->bus_info, "VPFE", sizeof(cap->bus_info));
+	strscpy(cap->card, vpfe_dev->cfg->card_name, sizeof(cap->card));
 	return 0;
 }
 
diff --git a/drivers/media/platform/davinci/vpif_capture.c b/drivers/media/platform/davinci/vpif_capture.c
index a96f53ce8088..f0c2508a6e2e 100644
--- a/drivers/media/platform/davinci/vpif_capture.c
+++ b/drivers/media/platform/davinci/vpif_capture.c
@@ -1094,10 +1094,10 @@ static int vpif_querycap(struct file *file, void  *priv,
 
 	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
-	strlcpy(cap->driver, VPIF_DRIVER_NAME, sizeof(cap->driver));
+	strscpy(cap->driver, VPIF_DRIVER_NAME, sizeof(cap->driver));
 	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s",
 		 dev_name(vpif_dev));
-	strlcpy(cap->card, config->card_name, sizeof(cap->card));
+	strscpy(cap->card, config->card_name, sizeof(cap->card));
 
 	return 0;
 }
@@ -1463,7 +1463,7 @@ static int vpif_probe_complete(void)
 
 		/* Initialize the video_device structure */
 		vdev = &ch->video_dev;
-		strlcpy(vdev->name, VPIF_DRIVER_NAME, sizeof(vdev->name));
+		strscpy(vdev->name, VPIF_DRIVER_NAME, sizeof(vdev->name));
 		vdev->release = video_device_release_empty;
 		vdev->fops = &vpif_fops;
 		vdev->ioctl_ops = &vpif_ioctl_ops;
diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index 0f324055cc9f..fec4341eb93e 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -586,10 +586,10 @@ static int vpif_querycap(struct file *file, void  *priv,
 
 	cap->device_caps = V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_STREAMING;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
-	strlcpy(cap->driver, VPIF_DRIVER_NAME, sizeof(cap->driver));
+	strscpy(cap->driver, VPIF_DRIVER_NAME, sizeof(cap->driver));
 	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s",
 		 dev_name(vpif_dev));
-	strlcpy(cap->card, config->card_name, sizeof(cap->card));
+	strscpy(cap->card, config->card_name, sizeof(cap->card));
 
 	return 0;
 }
@@ -1209,7 +1209,7 @@ static int vpif_probe_complete(void)
 
 		/* Initialize the video_device structure */
 		vdev = &ch->video_dev;
-		strlcpy(vdev->name, VPIF_DRIVER_NAME, sizeof(vdev->name));
+		strscpy(vdev->name, VPIF_DRIVER_NAME, sizeof(vdev->name));
 		vdev->release = video_device_release_empty;
 		vdev->fops = &vpif_fops;
 		vdev->ioctl_ops = &vpif_ioctl_ops;
diff --git a/drivers/media/platform/exynos-gsc/gsc-core.c b/drivers/media/platform/exynos-gsc/gsc-core.c
index 17854a379243..838c5c53de37 100644
--- a/drivers/media/platform/exynos-gsc/gsc-core.c
+++ b/drivers/media/platform/exynos-gsc/gsc-core.c
@@ -339,7 +339,7 @@ int gsc_enum_fmt_mplane(struct v4l2_fmtdesc *f)
 	if (!fmt)
 		return -EINVAL;
 
-	strlcpy(f->description, fmt->name, sizeof(f->description));
+	strscpy(f->description, fmt->name, sizeof(f->description));
 	f->pixelformat = fmt->pixelformat;
 
 	return 0;
diff --git a/drivers/media/platform/exynos-gsc/gsc-m2m.c b/drivers/media/platform/exynos-gsc/gsc-m2m.c
index c9d2f6c5311a..cc5d690818e1 100644
--- a/drivers/media/platform/exynos-gsc/gsc-m2m.c
+++ b/drivers/media/platform/exynos-gsc/gsc-m2m.c
@@ -294,8 +294,8 @@ static int gsc_m2m_querycap(struct file *file, void *fh,
 	struct gsc_ctx *ctx = fh_to_ctx(fh);
 	struct gsc_dev *gsc = ctx->gsc_dev;
 
-	strlcpy(cap->driver, GSC_MODULE_NAME, sizeof(cap->driver));
-	strlcpy(cap->card, GSC_MODULE_NAME " gscaler", sizeof(cap->card));
+	strscpy(cap->driver, GSC_MODULE_NAME, sizeof(cap->driver));
+	strscpy(cap->card, GSC_MODULE_NAME " gscaler", sizeof(cap->card));
 	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s",
 		 dev_name(&gsc->pdev->dev));
 	cap->device_caps = V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_M2M_MPLANE;
diff --git a/drivers/media/platform/exynos4-is/common.c b/drivers/media/platform/exynos4-is/common.c
index b90f5bb15517..76f557548dfc 100644
--- a/drivers/media/platform/exynos4-is/common.c
+++ b/drivers/media/platform/exynos4-is/common.c
@@ -40,8 +40,8 @@ EXPORT_SYMBOL(fimc_find_remote_sensor);
 void __fimc_vidioc_querycap(struct device *dev, struct v4l2_capability *cap,
 						unsigned int caps)
 {
-	strlcpy(cap->driver, dev->driver->name, sizeof(cap->driver));
-	strlcpy(cap->card, dev->driver->name, sizeof(cap->card));
+	strscpy(cap->driver, dev->driver->name, sizeof(cap->driver));
+	strscpy(cap->card, dev->driver->name, sizeof(cap->card));
 	snprintf(cap->bus_info, sizeof(cap->bus_info),
 				"platform:%s", dev_name(dev));
 	cap->device_caps = caps;
diff --git a/drivers/media/platform/exynos4-is/fimc-capture.c b/drivers/media/platform/exynos4-is/fimc-capture.c
index a3cdac188190..f56220e549bb 100644
--- a/drivers/media/platform/exynos4-is/fimc-capture.c
+++ b/drivers/media/platform/exynos4-is/fimc-capture.c
@@ -1087,7 +1087,7 @@ static int fimc_cap_enum_input(struct file *file, void *priv,
 	fimc_md_graph_unlock(ve);
 
 	if (sd)
-		strlcpy(i->name, sd->name, sizeof(i->name));
+		strscpy(i->name, sd->name, sizeof(i->name));
 
 	return 0;
 }
diff --git a/drivers/media/platform/exynos4-is/fimc-is-i2c.c b/drivers/media/platform/exynos4-is/fimc-is-i2c.c
index 70dd4852b2b9..be937caf7645 100644
--- a/drivers/media/platform/exynos4-is/fimc-is-i2c.c
+++ b/drivers/media/platform/exynos4-is/fimc-is-i2c.c
@@ -57,7 +57,7 @@ static int fimc_is_i2c_probe(struct platform_device *pdev)
 	i2c_adap = &isp_i2c->adapter;
 	i2c_adap->dev.of_node = node;
 	i2c_adap->dev.parent = &pdev->dev;
-	strlcpy(i2c_adap->name, "exynos4x12-isp-i2c", sizeof(i2c_adap->name));
+	strscpy(i2c_adap->name, "exynos4x12-isp-i2c", sizeof(i2c_adap->name));
 	i2c_adap->owner = THIS_MODULE;
 	i2c_adap->algo = &fimc_is_i2c_algorithm;
 	i2c_adap->class = I2C_CLASS_SPD;
diff --git a/drivers/media/platform/exynos4-is/fimc-isp-video.c b/drivers/media/platform/exynos4-is/fimc-isp-video.c
index a920164f53f1..de6bd28f7e31 100644
--- a/drivers/media/platform/exynos4-is/fimc-isp-video.c
+++ b/drivers/media/platform/exynos4-is/fimc-isp-video.c
@@ -365,7 +365,7 @@ static int isp_video_enum_fmt_mplane(struct file *file, void *priv,
 	if (WARN_ON(fmt == NULL))
 		return -EINVAL;
 
-	strlcpy(f->description, fmt->name, sizeof(f->description));
+	strscpy(f->description, fmt->name, sizeof(f->description));
 	f->pixelformat = fmt->fourcc;
 
 	return 0;
diff --git a/drivers/media/platform/exynos4-is/fimc-lite.c b/drivers/media/platform/exynos4-is/fimc-lite.c
index 70d5f5586a5d..96f0a8a0dcae 100644
--- a/drivers/media/platform/exynos4-is/fimc-lite.c
+++ b/drivers/media/platform/exynos4-is/fimc-lite.c
@@ -654,8 +654,8 @@ static int fimc_lite_querycap(struct file *file, void *priv,
 {
 	struct fimc_lite *fimc = video_drvdata(file);
 
-	strlcpy(cap->driver, FIMC_LITE_DRV_NAME, sizeof(cap->driver));
-	strlcpy(cap->card, FIMC_LITE_DRV_NAME, sizeof(cap->card));
+	strscpy(cap->driver, FIMC_LITE_DRV_NAME, sizeof(cap->driver));
+	strscpy(cap->card, FIMC_LITE_DRV_NAME, sizeof(cap->card));
 	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s",
 					dev_name(&fimc->pdev->dev));
 
@@ -673,7 +673,7 @@ static int fimc_lite_enum_fmt_mplane(struct file *file, void *priv,
 		return -EINVAL;
 
 	fmt = &fimc_lite_formats[f->index];
-	strlcpy(f->description, fmt->name, sizeof(f->description));
+	strscpy(f->description, fmt->name, sizeof(f->description));
 	f->pixelformat = fmt->fourcc;
 
 	return 0;
diff --git a/drivers/media/platform/exynos4-is/media-dev.c b/drivers/media/platform/exynos4-is/media-dev.c
index deb499f76412..18a393f51a26 100644
--- a/drivers/media/platform/exynos4-is/media-dev.c
+++ b/drivers/media/platform/exynos4-is/media-dev.c
@@ -1204,9 +1204,9 @@ static ssize_t fimc_md_sysfs_show(struct device *dev,
 	struct fimc_md *fmd = dev_get_drvdata(dev);
 
 	if (fmd->user_subdev_api)
-		return strlcpy(buf, "Sub-device API (sub-dev)\n", PAGE_SIZE);
+		return strscpy(buf, "Sub-device API (sub-dev)\n", PAGE_SIZE);
 
-	return strlcpy(buf, "V4L2 video node only API (vid-dev)\n", PAGE_SIZE);
+	return strscpy(buf, "V4L2 video node only API (vid-dev)\n", PAGE_SIZE);
 }
 
 static ssize_t fimc_md_sysfs_store(struct device *dev,
@@ -1426,7 +1426,7 @@ static int fimc_md_probe(struct platform_device *pdev)
 	INIT_LIST_HEAD(&fmd->pipelines);
 	fmd->pdev = pdev;
 
-	strlcpy(fmd->media_dev.model, "SAMSUNG S5P FIMC",
+	strscpy(fmd->media_dev.model, "SAMSUNG S5P FIMC",
 		sizeof(fmd->media_dev.model));
 	fmd->media_dev.ops = &fimc_md_ops;
 	fmd->media_dev.dev = dev;
@@ -1434,7 +1434,7 @@ static int fimc_md_probe(struct platform_device *pdev)
 	v4l2_dev = &fmd->v4l2_dev;
 	v4l2_dev->mdev = &fmd->media_dev;
 	v4l2_dev->notify = fimc_sensor_notify;
-	strlcpy(v4l2_dev->name, "s5p-fimc-md", sizeof(v4l2_dev->name));
+	strscpy(v4l2_dev->name, "s5p-fimc-md", sizeof(v4l2_dev->name));
 
 	fmd->use_isp = fimc_md_is_isp_available(dev->of_node);
 	fmd->user_subdev_api = true;
diff --git a/drivers/media/platform/m2m-deinterlace.c b/drivers/media/platform/m2m-deinterlace.c
index 5f84d2aa47ab..c62e598ee7d0 100644
--- a/drivers/media/platform/m2m-deinterlace.c
+++ b/drivers/media/platform/m2m-deinterlace.c
@@ -438,9 +438,9 @@ static void deinterlace_device_run(void *priv)
 static int vidioc_querycap(struct file *file, void *priv,
 			   struct v4l2_capability *cap)
 {
-	strlcpy(cap->driver, MEM2MEM_NAME, sizeof(cap->driver));
-	strlcpy(cap->card, MEM2MEM_NAME, sizeof(cap->card));
-	strlcpy(cap->bus_info, MEM2MEM_NAME, sizeof(cap->card));
+	strscpy(cap->driver, MEM2MEM_NAME, sizeof(cap->driver));
+	strscpy(cap->card, MEM2MEM_NAME, sizeof(cap->card));
+	strscpy(cap->bus_info, MEM2MEM_NAME, sizeof(cap->card));
 	/*
 	 * This is only a mem-to-mem video device. The capture and output
 	 * device capability flags are left only for backward compatibility
@@ -474,7 +474,7 @@ static int enum_fmt(struct v4l2_fmtdesc *f, u32 type)
 	if (i < NUM_FORMATS) {
 		/* Format found */
 		fmt = &formats[i];
-		strlcpy(f->description, fmt->name, sizeof(f->description));
+		strscpy(f->description, fmt->name, sizeof(f->description));
 		f->pixelformat = fmt->fourcc;
 		return 0;
 	}
diff --git a/drivers/media/platform/marvell-ccic/mcam-core.c b/drivers/media/platform/marvell-ccic/mcam-core.c
index dfdbd4354b74..c47011194710 100644
--- a/drivers/media/platform/marvell-ccic/mcam-core.c
+++ b/drivers/media/platform/marvell-ccic/mcam-core.c
@@ -1305,7 +1305,7 @@ static int mcam_vidioc_querycap(struct file *file, void *priv,
 
 	strcpy(cap->driver, "marvell_ccic");
 	strcpy(cap->card, "marvell_ccic");
-	strlcpy(cap->bus_info, cam->bus_info, sizeof(cap->bus_info));
+	strscpy(cap->bus_info, cam->bus_info, sizeof(cap->bus_info));
 	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE |
 		V4L2_CAP_READWRITE | V4L2_CAP_STREAMING;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
@@ -1318,8 +1318,8 @@ static int mcam_vidioc_enum_fmt_vid_cap(struct file *filp,
 {
 	if (fmt->index >= N_MCAM_FMTS)
 		return -EINVAL;
-	strlcpy(fmt->description, mcam_formats[fmt->index].desc,
-			sizeof(fmt->description));
+	strscpy(fmt->description, mcam_formats[fmt->index].desc,
+		sizeof(fmt->description));
 	fmt->pixelformat = mcam_formats[fmt->index].pixelformat;
 	return 0;
 }
diff --git a/drivers/media/platform/marvell-ccic/mmp-driver.c b/drivers/media/platform/marvell-ccic/mmp-driver.c
index 6d9f0abb2660..41968cd388ac 100644
--- a/drivers/media/platform/marvell-ccic/mmp-driver.c
+++ b/drivers/media/platform/marvell-ccic/mmp-driver.c
@@ -371,7 +371,7 @@ static int mmpcam_probe(struct platform_device *pdev)
 	mcam->lane = pdata->lane;
 	mcam->chip_id = MCAM_ARMADA610;
 	mcam->buffer_mode = B_DMA_sg;
-	strlcpy(mcam->bus_info, "platform:mmp-camera", sizeof(mcam->bus_info));
+	strscpy(mcam->bus_info, "platform:mmp-camera", sizeof(mcam->bus_info));
 	spin_lock_init(&mcam->dev_lock);
 	/*
 	 * Get our I/O memory.
diff --git a/drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c b/drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c
index 4f24da8afecc..2a5d5002c27e 100644
--- a/drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c
+++ b/drivers/media/platform/mtk-jpeg/mtk_jpeg_core.c
@@ -94,8 +94,8 @@ static int mtk_jpeg_querycap(struct file *file, void *priv,
 {
 	struct mtk_jpeg_dev *jpeg = video_drvdata(file);
 
-	strlcpy(cap->driver, MTK_JPEG_NAME " decoder", sizeof(cap->driver));
-	strlcpy(cap->card, MTK_JPEG_NAME " decoder", sizeof(cap->card));
+	strscpy(cap->driver, MTK_JPEG_NAME " decoder", sizeof(cap->driver));
+	strscpy(cap->card, MTK_JPEG_NAME " decoder", sizeof(cap->card));
 	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s",
 		 dev_name(jpeg->dev));
 
diff --git a/drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c b/drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c
index ceffc31cc6eb..51a13466261e 100644
--- a/drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c
+++ b/drivers/media/platform/mtk-mdp/mtk_mdp_m2m.c
@@ -619,9 +619,9 @@ static int mtk_mdp_m2m_querycap(struct file *file, void *fh,
 	struct mtk_mdp_ctx *ctx = fh_to_ctx(fh);
 	struct mtk_mdp_dev *mdp = ctx->mdp_dev;
 
-	strlcpy(cap->driver, MTK_MDP_MODULE_NAME, sizeof(cap->driver));
-	strlcpy(cap->card, mdp->pdev->name, sizeof(cap->card));
-	strlcpy(cap->bus_info, "platform:mt8173", sizeof(cap->bus_info));
+	strscpy(cap->driver, MTK_MDP_MODULE_NAME, sizeof(cap->driver));
+	strscpy(cap->card, mdp->pdev->name, sizeof(cap->card));
+	strscpy(cap->bus_info, "platform:mt8173", sizeof(cap->bus_info));
 
 	return 0;
 }
diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c
index 0c8a8b4c4e1c..ba619647bc10 100644
--- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_dec.c
@@ -613,9 +613,9 @@ static int vidioc_vdec_dqbuf(struct file *file, void *priv,
 static int vidioc_vdec_querycap(struct file *file, void *priv,
 				struct v4l2_capability *cap)
 {
-	strlcpy(cap->driver, MTK_VCODEC_DEC_NAME, sizeof(cap->driver));
-	strlcpy(cap->bus_info, MTK_PLATFORM_STR, sizeof(cap->bus_info));
-	strlcpy(cap->card, MTK_PLATFORM_STR, sizeof(cap->card));
+	strscpy(cap->driver, MTK_VCODEC_DEC_NAME, sizeof(cap->driver));
+	strscpy(cap->bus_info, MTK_PLATFORM_STR, sizeof(cap->bus_info));
+	strscpy(cap->card, MTK_PLATFORM_STR, sizeof(cap->card));
 
 	return 0;
 }
diff --git a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
index 6ad408514a99..54631ad1c71e 100644
--- a/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
+++ b/drivers/media/platform/mtk-vcodec/mtk_vcodec_enc.c
@@ -222,9 +222,9 @@ static int vidioc_enum_fmt_vid_out_mplane(struct file *file, void *prov,
 static int vidioc_venc_querycap(struct file *file, void *priv,
 				struct v4l2_capability *cap)
 {
-	strlcpy(cap->driver, MTK_VCODEC_ENC_NAME, sizeof(cap->driver));
-	strlcpy(cap->bus_info, MTK_PLATFORM_STR, sizeof(cap->bus_info));
-	strlcpy(cap->card, MTK_PLATFORM_STR, sizeof(cap->card));
+	strscpy(cap->driver, MTK_VCODEC_ENC_NAME, sizeof(cap->driver));
+	strscpy(cap->bus_info, MTK_PLATFORM_STR, sizeof(cap->bus_info));
+	strscpy(cap->card, MTK_PLATFORM_STR, sizeof(cap->card));
 
 	return 0;
 }
diff --git a/drivers/media/platform/mx2_emmaprp.c b/drivers/media/platform/mx2_emmaprp.c
index 64195c4ddeaf..27b078cf98e3 100644
--- a/drivers/media/platform/mx2_emmaprp.c
+++ b/drivers/media/platform/mx2_emmaprp.c
@@ -413,7 +413,7 @@ static int enum_fmt(struct v4l2_fmtdesc *f, u32 type)
 	if (i < NUM_FORMATS) {
 		/* Format found */
 		fmt = &formats[i];
-		strlcpy(f->description, fmt->name, sizeof(f->description) - 1);
+		strscpy(f->description, fmt->name, sizeof(f->description) - 1);
 		f->pixelformat = fmt->fourcc;
 		return 0;
 	}
diff --git a/drivers/media/platform/omap/omap_vout.c b/drivers/media/platform/omap/omap_vout.c
index 5700b7818621..f447ae3bb465 100644
--- a/drivers/media/platform/omap/omap_vout.c
+++ b/drivers/media/platform/omap/omap_vout.c
@@ -1041,8 +1041,8 @@ static int vidioc_querycap(struct file *file, void *fh,
 {
 	struct omap_vout_device *vout = fh;
 
-	strlcpy(cap->driver, VOUT_NAME, sizeof(cap->driver));
-	strlcpy(cap->card, vout->vfd->name, sizeof(cap->card));
+	strscpy(cap->driver, VOUT_NAME, sizeof(cap->driver));
+	strscpy(cap->card, vout->vfd->name, sizeof(cap->card));
 	cap->bus_info[0] = '\0';
 	cap->device_caps = V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_OUTPUT |
 		V4L2_CAP_VIDEO_OUTPUT_OVERLAY;
@@ -1060,8 +1060,8 @@ static int vidioc_enum_fmt_vid_out(struct file *file, void *fh,
 		return -EINVAL;
 
 	fmt->flags = omap_formats[index].flags;
-	strlcpy(fmt->description, omap_formats[index].description,
-			sizeof(fmt->description));
+	strscpy(fmt->description, omap_formats[index].description,
+		sizeof(fmt->description));
 	fmt->pixelformat = omap_formats[index].pixelformat;
 
 	return 0;
@@ -1868,7 +1868,7 @@ static int __init omap_vout_setup_video_data(struct omap_vout_device *vout)
 	vfd->release = video_device_release;
 	vfd->ioctl_ops = &vout_ioctl_ops;
 
-	strlcpy(vfd->name, VOUT_NAME, sizeof(vfd->name));
+	strscpy(vfd->name, VOUT_NAME, sizeof(vfd->name));
 
 	vfd->fops = &omap_vout_fops;
 	vfd->v4l2_dev = &vout->vid_dev->v4l2_dev;
diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 842e2235047d..93f032a39470 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -1677,7 +1677,7 @@ static int isp_register_entities(struct isp_device *isp)
 	int ret;
 
 	isp->media_dev.dev = isp->dev;
-	strlcpy(isp->media_dev.model, "TI OMAP3 ISP",
+	strscpy(isp->media_dev.model, "TI OMAP3 ISP",
 		sizeof(isp->media_dev.model));
 	isp->media_dev.hw_revision = isp->revision;
 	isp->media_dev.ops = &isp_media_ops;
diff --git a/drivers/media/platform/omap3isp/ispccdc.c b/drivers/media/platform/omap3isp/ispccdc.c
index 77b73e27a274..14a1c24037c4 100644
--- a/drivers/media/platform/omap3isp/ispccdc.c
+++ b/drivers/media/platform/omap3isp/ispccdc.c
@@ -2641,7 +2641,7 @@ static int ccdc_init_entities(struct isp_ccdc_device *ccdc)
 
 	v4l2_subdev_init(sd, &ccdc_v4l2_ops);
 	sd->internal_ops = &ccdc_v4l2_internal_ops;
-	strlcpy(sd->name, "OMAP3 ISP CCDC", sizeof(sd->name));
+	strscpy(sd->name, "OMAP3 ISP CCDC", sizeof(sd->name));
 	sd->grp_id = 1 << 16;	/* group ID for isp subdevs */
 	v4l2_set_subdevdata(sd, ccdc);
 	sd->flags |= V4L2_SUBDEV_FL_HAS_EVENTS | V4L2_SUBDEV_FL_HAS_DEVNODE;
diff --git a/drivers/media/platform/omap3isp/ispccp2.c b/drivers/media/platform/omap3isp/ispccp2.c
index e062939d0d05..2dea423ffc0e 100644
--- a/drivers/media/platform/omap3isp/ispccp2.c
+++ b/drivers/media/platform/omap3isp/ispccp2.c
@@ -1070,7 +1070,7 @@ static int ccp2_init_entities(struct isp_ccp2_device *ccp2)
 
 	v4l2_subdev_init(sd, &ccp2_sd_ops);
 	sd->internal_ops = &ccp2_sd_internal_ops;
-	strlcpy(sd->name, "OMAP3 ISP CCP2", sizeof(sd->name));
+	strscpy(sd->name, "OMAP3 ISP CCP2", sizeof(sd->name));
 	sd->grp_id = 1 << 16;   /* group ID for isp subdevs */
 	v4l2_set_subdevdata(sd, ccp2);
 	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
diff --git a/drivers/media/platform/omap3isp/ispcsi2.c b/drivers/media/platform/omap3isp/ispcsi2.c
index a4d3d030e81e..9c180f607bcb 100644
--- a/drivers/media/platform/omap3isp/ispcsi2.c
+++ b/drivers/media/platform/omap3isp/ispcsi2.c
@@ -1234,7 +1234,7 @@ static int csi2_init_entities(struct isp_csi2_device *csi2)
 
 	v4l2_subdev_init(sd, &csi2_ops);
 	sd->internal_ops = &csi2_internal_ops;
-	strlcpy(sd->name, "OMAP3 ISP CSI2a", sizeof(sd->name));
+	strscpy(sd->name, "OMAP3 ISP CSI2a", sizeof(sd->name));
 
 	sd->grp_id = 1 << 16;	/* group ID for isp subdevs */
 	v4l2_set_subdevdata(sd, csi2);
diff --git a/drivers/media/platform/omap3isp/isppreview.c b/drivers/media/platform/omap3isp/isppreview.c
index 3195f7c8b8b7..6ea6aeafd751 100644
--- a/drivers/media/platform/omap3isp/isppreview.c
+++ b/drivers/media/platform/omap3isp/isppreview.c
@@ -2267,7 +2267,7 @@ static int preview_init_entities(struct isp_prev_device *prev)
 
 	v4l2_subdev_init(sd, &preview_v4l2_ops);
 	sd->internal_ops = &preview_v4l2_internal_ops;
-	strlcpy(sd->name, "OMAP3 ISP preview", sizeof(sd->name));
+	strscpy(sd->name, "OMAP3 ISP preview", sizeof(sd->name));
 	sd->grp_id = 1 << 16;	/* group ID for isp subdevs */
 	v4l2_set_subdevdata(sd, prev);
 	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
diff --git a/drivers/media/platform/omap3isp/ispresizer.c b/drivers/media/platform/omap3isp/ispresizer.c
index 0b6a87508584..b281cae036b3 100644
--- a/drivers/media/platform/omap3isp/ispresizer.c
+++ b/drivers/media/platform/omap3isp/ispresizer.c
@@ -1723,7 +1723,7 @@ static int resizer_init_entities(struct isp_res_device *res)
 
 	v4l2_subdev_init(sd, &resizer_v4l2_ops);
 	sd->internal_ops = &resizer_v4l2_internal_ops;
-	strlcpy(sd->name, "OMAP3 ISP resizer", sizeof(sd->name));
+	strscpy(sd->name, "OMAP3 ISP resizer", sizeof(sd->name));
 	sd->grp_id = 1 << 16;	/* group ID for isp subdevs */
 	v4l2_set_subdevdata(sd, res);
 	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
diff --git a/drivers/media/platform/omap3isp/ispvideo.c b/drivers/media/platform/omap3isp/ispvideo.c
index 9d228eac24ea..5658f6a326f7 100644
--- a/drivers/media/platform/omap3isp/ispvideo.c
+++ b/drivers/media/platform/omap3isp/ispvideo.c
@@ -654,9 +654,9 @@ isp_video_querycap(struct file *file, void *fh, struct v4l2_capability *cap)
 {
 	struct isp_video *video = video_drvdata(file);
 
-	strlcpy(cap->driver, ISP_VIDEO_DRIVER_NAME, sizeof(cap->driver));
-	strlcpy(cap->card, video->video.name, sizeof(cap->card));
-	strlcpy(cap->bus_info, "media", sizeof(cap->bus_info));
+	strscpy(cap->driver, ISP_VIDEO_DRIVER_NAME, sizeof(cap->driver));
+	strscpy(cap->card, video->video.name, sizeof(cap->card));
+	strscpy(cap->bus_info, "media", sizeof(cap->bus_info));
 
 	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_VIDEO_OUTPUT
 		| V4L2_CAP_STREAMING | V4L2_CAP_DEVICE_CAPS;
@@ -1251,7 +1251,7 @@ isp_video_enum_input(struct file *file, void *fh, struct v4l2_input *input)
 	if (input->index > 0)
 		return -EINVAL;
 
-	strlcpy(input->name, "camera", sizeof(input->name));
+	strscpy(input->name, "camera", sizeof(input->name));
 	input->type = V4L2_INPUT_TYPE_CAMERA;
 
 	return 0;
diff --git a/drivers/media/platform/pxa_camera.c b/drivers/media/platform/pxa_camera.c
index b6e9e93bde7a..3288d22de2a0 100644
--- a/drivers/media/platform/pxa_camera.c
+++ b/drivers/media/platform/pxa_camera.c
@@ -1994,9 +1994,9 @@ static int pxac_vidioc_s_fmt_vid_cap(struct file *filp, void *priv,
 static int pxac_vidioc_querycap(struct file *file, void *priv,
 				struct v4l2_capability *cap)
 {
-	strlcpy(cap->bus_info, "platform:pxa-camera", sizeof(cap->bus_info));
-	strlcpy(cap->driver, PXA_CAM_DRV_NAME, sizeof(cap->driver));
-	strlcpy(cap->card, pxa_cam_driver_description, sizeof(cap->card));
+	strscpy(cap->bus_info, "platform:pxa-camera", sizeof(cap->bus_info));
+	strscpy(cap->driver, PXA_CAM_DRV_NAME, sizeof(cap->driver));
+	strscpy(cap->card, pxa_cam_driver_description, sizeof(cap->card));
 	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 
@@ -2010,7 +2010,7 @@ static int pxac_vidioc_enum_input(struct file *file, void *priv,
 		return -EINVAL;
 
 	i->type = V4L2_INPUT_TYPE_CAMERA;
-	strlcpy(i->name, "Camera", sizeof(i->name));
+	strscpy(i->name, "Camera", sizeof(i->name));
 
 	return 0;
 }
diff --git a/drivers/media/platform/qcom/camss/camss-video.c b/drivers/media/platform/qcom/camss/camss-video.c
index c9bb0d023db4..58aebe7114cd 100644
--- a/drivers/media/platform/qcom/camss/camss-video.c
+++ b/drivers/media/platform/qcom/camss/camss-video.c
@@ -521,8 +521,8 @@ static int video_querycap(struct file *file, void *fh,
 {
 	struct camss_video *video = video_drvdata(file);
 
-	strlcpy(cap->driver, "qcom-camss", sizeof(cap->driver));
-	strlcpy(cap->card, "Qualcomm Camera Subsystem", sizeof(cap->card));
+	strscpy(cap->driver, "qcom-camss", sizeof(cap->driver));
+	strscpy(cap->card, "Qualcomm Camera Subsystem", sizeof(cap->card));
 	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s",
 		 dev_name(video->camss->dev));
 
@@ -683,7 +683,7 @@ static int video_enum_input(struct file *file, void *fh,
 	if (input->index > 0)
 		return -EINVAL;
 
-	strlcpy(input->name, "camera", sizeof(input->name));
+	strscpy(input->name, "camera", sizeof(input->name));
 	input->type = V4L2_INPUT_TYPE_CAMERA;
 
 	return 0;
@@ -919,7 +919,7 @@ int msm_video_register(struct camss_video *video, struct v4l2_device *v4l2_dev,
 	vdev->vfl_dir = VFL_DIR_RX;
 	vdev->queue = &video->vb2_q;
 	vdev->lock = &video->lock;
-	strlcpy(vdev->name, name, sizeof(vdev->name));
+	strscpy(vdev->name, name, sizeof(vdev->name));
 
 	ret = video_register_device(vdev, VFL_TYPE_GRABBER, -1);
 	if (ret < 0) {
diff --git a/drivers/media/platform/qcom/camss/camss.c b/drivers/media/platform/qcom/camss/camss.c
index 669615fff6a0..a838a7e560e3 100644
--- a/drivers/media/platform/qcom/camss/camss.c
+++ b/drivers/media/platform/qcom/camss/camss.c
@@ -876,7 +876,7 @@ static int camss_probe(struct platform_device *pdev)
 		return ret;
 
 	camss->media_dev.dev = camss->dev;
-	strlcpy(camss->media_dev.model, "Qualcomm Camera Subsystem",
+	strscpy(camss->media_dev.model, "Qualcomm Camera Subsystem",
 		sizeof(camss->media_dev.model));
 	camss->media_dev.ops = &camss_media_ops;
 	media_device_init(&camss->media_dev);
diff --git a/drivers/media/platform/qcom/venus/vdec.c b/drivers/media/platform/qcom/venus/vdec.c
index dfbbbf0f746f..991e1583b92a 100644
--- a/drivers/media/platform/qcom/venus/vdec.c
+++ b/drivers/media/platform/qcom/venus/vdec.c
@@ -341,9 +341,9 @@ vdec_g_selection(struct file *file, void *fh, struct v4l2_selection *s)
 static int
 vdec_querycap(struct file *file, void *fh, struct v4l2_capability *cap)
 {
-	strlcpy(cap->driver, "qcom-venus", sizeof(cap->driver));
-	strlcpy(cap->card, "Qualcomm Venus video decoder", sizeof(cap->card));
-	strlcpy(cap->bus_info, "platform:qcom-venus", sizeof(cap->bus_info));
+	strscpy(cap->driver, "qcom-venus", sizeof(cap->driver));
+	strscpy(cap->card, "Qualcomm Venus video decoder", sizeof(cap->card));
+	strscpy(cap->bus_info, "platform:qcom-venus", sizeof(cap->bus_info));
 
 	return 0;
 }
@@ -1153,7 +1153,7 @@ static int vdec_probe(struct platform_device *pdev)
 	if (!vdev)
 		return -ENOMEM;
 
-	strlcpy(vdev->name, "qcom-venus-decoder", sizeof(vdev->name));
+	strscpy(vdev->name, "qcom-venus-decoder", sizeof(vdev->name));
 	vdev->release = video_device_release;
 	vdev->fops = &vdec_fops;
 	vdev->ioctl_ops = &vdec_ioctl_ops;
diff --git a/drivers/media/platform/qcom/venus/venc.c b/drivers/media/platform/qcom/venus/venc.c
index 41249d1443fa..ce85962b6adc 100644
--- a/drivers/media/platform/qcom/venus/venc.c
+++ b/drivers/media/platform/qcom/venus/venc.c
@@ -273,9 +273,9 @@ static int venc_v4l2_to_hfi(int id, int value)
 static int
 venc_querycap(struct file *file, void *fh, struct v4l2_capability *cap)
 {
-	strlcpy(cap->driver, "qcom-venus", sizeof(cap->driver));
-	strlcpy(cap->card, "Qualcomm Venus video encoder", sizeof(cap->card));
-	strlcpy(cap->bus_info, "platform:qcom-venus", sizeof(cap->bus_info));
+	strscpy(cap->driver, "qcom-venus", sizeof(cap->driver));
+	strscpy(cap->card, "Qualcomm Venus video encoder", sizeof(cap->card));
+	strscpy(cap->bus_info, "platform:qcom-venus", sizeof(cap->bus_info));
 
 	return 0;
 }
@@ -1257,7 +1257,7 @@ static int venc_probe(struct platform_device *pdev)
 	if (!vdev)
 		return -ENOMEM;
 
-	strlcpy(vdev->name, "qcom-venus-encoder", sizeof(vdev->name));
+	strscpy(vdev->name, "qcom-venus-encoder", sizeof(vdev->name));
 	vdev->release = video_device_release;
 	vdev->fops = &venc_fops;
 	vdev->ioctl_ops = &venc_ioctl_ops;
diff --git a/drivers/media/platform/rcar-vin/rcar-core.c b/drivers/media/platform/rcar-vin/rcar-core.c
index ce09799976ef..5dd16af3625c 100644
--- a/drivers/media/platform/rcar-vin/rcar-core.c
+++ b/drivers/media/platform/rcar-vin/rcar-core.c
@@ -268,8 +268,8 @@ static int rvin_group_init(struct rvin_group *group, struct rvin_dev *vin)
 	match = of_match_node(vin->dev->driver->of_match_table,
 			      vin->dev->of_node);
 
-	strlcpy(mdev->driver_name, KBUILD_MODNAME, sizeof(mdev->driver_name));
-	strlcpy(mdev->model, match->compatible, sizeof(mdev->model));
+	strscpy(mdev->driver_name, KBUILD_MODNAME, sizeof(mdev->driver_name));
+	strscpy(mdev->model, match->compatible, sizeof(mdev->model));
 	snprintf(mdev->bus_info, sizeof(mdev->bus_info), "platform:%s",
 		 dev_name(mdev->dev));
 
diff --git a/drivers/media/platform/rcar-vin/rcar-v4l2.c b/drivers/media/platform/rcar-vin/rcar-v4l2.c
index 5a54779cfc27..dc77682b4785 100644
--- a/drivers/media/platform/rcar-vin/rcar-v4l2.c
+++ b/drivers/media/platform/rcar-vin/rcar-v4l2.c
@@ -238,8 +238,8 @@ static int rvin_querycap(struct file *file, void *priv,
 {
 	struct rvin_dev *vin = video_drvdata(file);
 
-	strlcpy(cap->driver, KBUILD_MODNAME, sizeof(cap->driver));
-	strlcpy(cap->card, "R_Car_VIN", sizeof(cap->card));
+	strscpy(cap->driver, KBUILD_MODNAME, sizeof(cap->driver));
+	strscpy(cap->card, "R_Car_VIN", sizeof(cap->card));
 	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s",
 		 dev_name(vin->dev));
 	return 0;
@@ -440,7 +440,7 @@ static int rvin_enum_input(struct file *file, void *priv,
 		i->std = vin->vdev.tvnorms;
 	}
 
-	strlcpy(i->name, "Camera", sizeof(i->name));
+	strscpy(i->name, "Camera", sizeof(i->name));
 
 	return 0;
 }
@@ -714,7 +714,7 @@ static int rvin_mc_enum_input(struct file *file, void *priv,
 		return -EINVAL;
 
 	i->type = V4L2_INPUT_TYPE_CAMERA;
-	strlcpy(i->name, "Camera", sizeof(i->name));
+	strscpy(i->name, "Camera", sizeof(i->name));
 
 	return 0;
 }
diff --git a/drivers/media/platform/rcar_drif.c b/drivers/media/platform/rcar_drif.c
index 81413ab52475..9fa108b23cb3 100644
--- a/drivers/media/platform/rcar_drif.c
+++ b/drivers/media/platform/rcar_drif.c
@@ -870,8 +870,8 @@ static int rcar_drif_querycap(struct file *file, void *fh,
 {
 	struct rcar_drif_sdr *sdr = video_drvdata(file);
 
-	strlcpy(cap->driver, KBUILD_MODNAME, sizeof(cap->driver));
-	strlcpy(cap->card, sdr->vdev->name, sizeof(cap->card));
+	strscpy(cap->driver, KBUILD_MODNAME, sizeof(cap->driver));
+	strscpy(cap->card, sdr->vdev->name, sizeof(cap->card));
 	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s",
 		 sdr->vdev->name);
 
diff --git a/drivers/media/platform/rcar_fdp1.c b/drivers/media/platform/rcar_fdp1.c
index 2a15b7cca338..6bda1eee9170 100644
--- a/drivers/media/platform/rcar_fdp1.c
+++ b/drivers/media/platform/rcar_fdp1.c
@@ -1359,8 +1359,8 @@ static void device_frame_end(struct fdp1_dev *fdp1,
 static int fdp1_vidioc_querycap(struct file *file, void *priv,
 			   struct v4l2_capability *cap)
 {
-	strlcpy(cap->driver, DRIVER_NAME, sizeof(cap->driver));
-	strlcpy(cap->card, DRIVER_NAME, sizeof(cap->card));
+	strscpy(cap->driver, DRIVER_NAME, sizeof(cap->driver));
+	strscpy(cap->card, DRIVER_NAME, sizeof(cap->card));
 	snprintf(cap->bus_info, sizeof(cap->bus_info),
 			"platform:%s", DRIVER_NAME);
 	return 0;
@@ -2339,7 +2339,7 @@ static int fdp1_probe(struct platform_device *pdev)
 	vfd->lock = &fdp1->dev_mutex;
 	vfd->v4l2_dev = &fdp1->v4l2_dev;
 	video_set_drvdata(vfd, fdp1);
-	strlcpy(vfd->name, fdp1_videodev.name, sizeof(vfd->name));
+	strscpy(vfd->name, fdp1_videodev.name, sizeof(vfd->name));
 
 	ret = video_register_device(vfd, VFL_TYPE_GRABBER, 0);
 	if (ret) {
diff --git a/drivers/media/platform/rcar_jpu.c b/drivers/media/platform/rcar_jpu.c
index e5c882423f57..1dfd2eb65920 100644
--- a/drivers/media/platform/rcar_jpu.c
+++ b/drivers/media/platform/rcar_jpu.c
@@ -664,11 +664,11 @@ static int jpu_querycap(struct file *file, void *priv,
 	struct jpu_ctx *ctx = fh_to_ctx(priv);
 
 	if (ctx->encoder)
-		strlcpy(cap->card, DRV_NAME " encoder", sizeof(cap->card));
+		strscpy(cap->card, DRV_NAME " encoder", sizeof(cap->card));
 	else
-		strlcpy(cap->card, DRV_NAME " decoder", sizeof(cap->card));
+		strscpy(cap->card, DRV_NAME " decoder", sizeof(cap->card));
 
-	strlcpy(cap->driver, DRV_NAME, sizeof(cap->driver));
+	strscpy(cap->driver, DRV_NAME, sizeof(cap->driver));
 	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s",
 		 dev_name(ctx->jpu->dev));
 	cap->device_caps |= V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_M2M_MPLANE;
@@ -1654,7 +1654,7 @@ static int jpu_probe(struct platform_device *pdev)
 	for (i = 0; i < JPU_MAX_QUALITY; i++)
 		jpu_generate_hdr(i, (unsigned char *)jpeg_hdrs[i]);
 
-	strlcpy(jpu->vfd_encoder.name, DRV_NAME, sizeof(jpu->vfd_encoder.name));
+	strscpy(jpu->vfd_encoder.name, DRV_NAME, sizeof(jpu->vfd_encoder.name));
 	jpu->vfd_encoder.fops		= &jpu_fops;
 	jpu->vfd_encoder.ioctl_ops	= &jpu_ioctl_ops;
 	jpu->vfd_encoder.minor		= -1;
@@ -1671,7 +1671,7 @@ static int jpu_probe(struct platform_device *pdev)
 
 	video_set_drvdata(&jpu->vfd_encoder, jpu);
 
-	strlcpy(jpu->vfd_decoder.name, DRV_NAME, sizeof(jpu->vfd_decoder.name));
+	strscpy(jpu->vfd_decoder.name, DRV_NAME, sizeof(jpu->vfd_decoder.name));
 	jpu->vfd_decoder.fops		= &jpu_fops;
 	jpu->vfd_decoder.ioctl_ops	= &jpu_ioctl_ops;
 	jpu->vfd_decoder.minor		= -1;
diff --git a/drivers/media/platform/renesas-ceu.c b/drivers/media/platform/renesas-ceu.c
index ad782901cd7a..b7ae820a2ef6 100644
--- a/drivers/media/platform/renesas-ceu.c
+++ b/drivers/media/platform/renesas-ceu.c
@@ -1137,8 +1137,8 @@ static int ceu_querycap(struct file *file, void *priv,
 {
 	struct ceu_device *ceudev = video_drvdata(file);
 
-	strlcpy(cap->card, "Renesas CEU", sizeof(cap->card));
-	strlcpy(cap->driver, DRIVER_NAME, sizeof(cap->driver));
+	strscpy(cap->card, "Renesas CEU", sizeof(cap->card));
+	strscpy(cap->driver, DRIVER_NAME, sizeof(cap->driver));
 	snprintf(cap->bus_info, sizeof(cap->bus_info),
 		 "platform:renesas-ceu-%s", dev_name(ceudev->dev));
 
@@ -1440,7 +1440,7 @@ static int ceu_notify_complete(struct v4l2_async_notifier *notifier)
 		return ret;
 
 	/* Register the video device. */
-	strlcpy(vdev->name, DRIVER_NAME, sizeof(vdev->name));
+	strscpy(vdev->name, DRIVER_NAME, sizeof(vdev->name));
 	vdev->v4l2_dev		= v4l2_dev;
 	vdev->lock		= &ceudev->mlock;
 	vdev->queue		= &ceudev->vb2_vq;
diff --git a/drivers/media/platform/rockchip/rga/rga.c b/drivers/media/platform/rockchip/rga/rga.c
index ab5a6f95044a..9cc9db083870 100644
--- a/drivers/media/platform/rockchip/rga/rga.c
+++ b/drivers/media/platform/rockchip/rga/rga.c
@@ -447,9 +447,9 @@ static const struct v4l2_file_operations rga_fops = {
 static int
 vidioc_querycap(struct file *file, void *priv, struct v4l2_capability *cap)
 {
-	strlcpy(cap->driver, RGA_NAME, sizeof(cap->driver));
-	strlcpy(cap->card, "rockchip-rga", sizeof(cap->card));
-	strlcpy(cap->bus_info, "platform:rga", sizeof(cap->bus_info));
+	strscpy(cap->driver, RGA_NAME, sizeof(cap->driver));
+	strscpy(cap->card, "rockchip-rga", sizeof(cap->card));
+	strscpy(cap->bus_info, "platform:rga", sizeof(cap->bus_info));
 
 	return 0;
 }
diff --git a/drivers/media/platform/s3c-camif/camif-capture.c b/drivers/media/platform/s3c-camif/camif-capture.c
index c02dce8b4c6c..23b008d1a47b 100644
--- a/drivers/media/platform/s3c-camif/camif-capture.c
+++ b/drivers/media/platform/s3c-camif/camif-capture.c
@@ -640,8 +640,8 @@ static int s3c_camif_vidioc_querycap(struct file *file, void *priv,
 {
 	struct camif_vp *vp = video_drvdata(file);
 
-	strlcpy(cap->driver, S3C_CAMIF_DRIVER_NAME, sizeof(cap->driver));
-	strlcpy(cap->card, S3C_CAMIF_DRIVER_NAME, sizeof(cap->card));
+	strscpy(cap->driver, S3C_CAMIF_DRIVER_NAME, sizeof(cap->driver));
+	strscpy(cap->card, S3C_CAMIF_DRIVER_NAME, sizeof(cap->card));
 	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s.%d",
 		 dev_name(vp->camif->dev), vp->id);
 
@@ -661,7 +661,7 @@ static int s3c_camif_vidioc_enum_input(struct file *file, void *priv,
 		return -EINVAL;
 
 	input->type = V4L2_INPUT_TYPE_CAMERA;
-	strlcpy(input->name, sensor->name, sizeof(input->name));
+	strscpy(input->name, sensor->name, sizeof(input->name));
 	return 0;
 }
 
@@ -688,7 +688,7 @@ static int s3c_camif_vidioc_enum_fmt(struct file *file, void *priv,
 	if (!fmt)
 		return -EINVAL;
 
-	strlcpy(f->description, fmt->name, sizeof(f->description));
+	strscpy(f->description, fmt->name, sizeof(f->description));
 	f->pixelformat = fmt->fourcc;
 
 	pr_debug("fmt(%d): %s\n", f->index, f->description);
@@ -1555,7 +1555,7 @@ int s3c_camif_create_subdev(struct camif_dev *camif)
 
 	v4l2_subdev_init(sd, &s3c_camif_subdev_ops);
 	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
-	strlcpy(sd->name, "S3C-CAMIF", sizeof(sd->name));
+	strscpy(sd->name, "S3C-CAMIF", sizeof(sd->name));
 
 	camif->pads[CAMIF_SD_PAD_SINK].flags = MEDIA_PAD_FL_SINK;
 	camif->pads[CAMIF_SD_PAD_SOURCE_C].flags = MEDIA_PAD_FL_SOURCE;
diff --git a/drivers/media/platform/s3c-camif/camif-core.c b/drivers/media/platform/s3c-camif/camif-core.c
index 79bc0ef6bb41..31759f16458e 100644
--- a/drivers/media/platform/s3c-camif/camif-core.c
+++ b/drivers/media/platform/s3c-camif/camif-core.c
@@ -316,12 +316,12 @@ static int camif_media_dev_init(struct camif_dev *camif)
 	memset(md, 0, sizeof(*md));
 	snprintf(md->model, sizeof(md->model), "SAMSUNG S3C%s CAMIF",
 		 ip_rev == S3C6410_CAMIF_IP_REV ? "6410" : "244X");
-	strlcpy(md->bus_info, "platform", sizeof(md->bus_info));
+	strscpy(md->bus_info, "platform", sizeof(md->bus_info));
 	md->hw_revision = ip_rev;
 
 	md->dev = camif->dev;
 
-	strlcpy(v4l2_dev->name, "s3c-camif", sizeof(v4l2_dev->name));
+	strscpy(v4l2_dev->name, "s3c-camif", sizeof(v4l2_dev->name));
 	v4l2_dev->mdev = md;
 
 	media_device_init(md);
diff --git a/drivers/media/platform/s5p-jpeg/jpeg-core.c b/drivers/media/platform/s5p-jpeg/jpeg-core.c
index 04fd2e0493c0..3f9000b70385 100644
--- a/drivers/media/platform/s5p-jpeg/jpeg-core.c
+++ b/drivers/media/platform/s5p-jpeg/jpeg-core.c
@@ -1276,14 +1276,14 @@ static int s5p_jpeg_querycap(struct file *file, void *priv,
 	struct s5p_jpeg_ctx *ctx = fh_to_ctx(priv);
 
 	if (ctx->mode == S5P_JPEG_ENCODE) {
-		strlcpy(cap->driver, S5P_JPEG_M2M_NAME,
+		strscpy(cap->driver, S5P_JPEG_M2M_NAME,
 			sizeof(cap->driver));
-		strlcpy(cap->card, S5P_JPEG_M2M_NAME " encoder",
+		strscpy(cap->card, S5P_JPEG_M2M_NAME " encoder",
 			sizeof(cap->card));
 	} else {
-		strlcpy(cap->driver, S5P_JPEG_M2M_NAME,
+		strscpy(cap->driver, S5P_JPEG_M2M_NAME,
 			sizeof(cap->driver));
-		strlcpy(cap->card, S5P_JPEG_M2M_NAME " decoder",
+		strscpy(cap->card, S5P_JPEG_M2M_NAME " decoder",
 			sizeof(cap->card));
 	}
 	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s",
@@ -1314,7 +1314,7 @@ static int enum_fmt(struct s5p_jpeg_fmt *sjpeg_formats, int n,
 	if (i >= n)
 		return -EINVAL;
 
-	strlcpy(f->description, sjpeg_formats[i].name, sizeof(f->description));
+	strscpy(f->description, sjpeg_formats[i].name, sizeof(f->description));
 	f->pixelformat = sjpeg_formats[i].fourcc;
 
 	return 0;
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
index 6a3cc4f86c5d..670ca869babb 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_dec.c
@@ -271,8 +271,8 @@ static int vidioc_querycap(struct file *file, void *priv,
 {
 	struct s5p_mfc_dev *dev = video_drvdata(file);
 
-	strlcpy(cap->driver, S5P_MFC_NAME, sizeof(cap->driver));
-	strlcpy(cap->card, dev->vfd_dec->name, sizeof(cap->card));
+	strscpy(cap->driver, S5P_MFC_NAME, sizeof(cap->driver));
+	strscpy(cap->card, dev->vfd_dec->name, sizeof(cap->card));
 	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s",
 		 dev_name(&dev->plat_dev->dev));
 	/*
@@ -308,7 +308,7 @@ static int vidioc_enum_fmt(struct file *file, struct v4l2_fmtdesc *f,
 	if (i == ARRAY_SIZE(formats))
 		return -EINVAL;
 	fmt = &formats[i];
-	strlcpy(f->description, fmt->name, sizeof(f->description));
+	strscpy(f->description, fmt->name, sizeof(f->description));
 	f->pixelformat = fmt->fourcc;
 	return 0;
 }
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
index 3ad4f5073002..7037d48bdc2c 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
@@ -1313,8 +1313,8 @@ static int vidioc_querycap(struct file *file, void *priv,
 {
 	struct s5p_mfc_dev *dev = video_drvdata(file);
 
-	strlcpy(cap->driver, S5P_MFC_NAME, sizeof(cap->driver));
-	strlcpy(cap->card, dev->vfd_enc->name, sizeof(cap->card));
+	strscpy(cap->driver, S5P_MFC_NAME, sizeof(cap->driver));
+	strscpy(cap->card, dev->vfd_enc->name, sizeof(cap->card));
 	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s",
 		 dev_name(&dev->plat_dev->dev));
 	/*
@@ -1344,7 +1344,7 @@ static int vidioc_enum_fmt(struct file *file, struct v4l2_fmtdesc *f,
 
 		if (j == f->index) {
 			fmt = &formats[i];
-			strlcpy(f->description, fmt->name,
+			strscpy(f->description, fmt->name,
 				sizeof(f->description));
 			f->pixelformat = fmt->fourcc;
 			return 0;
diff --git a/drivers/media/platform/sh_veu.c b/drivers/media/platform/sh_veu.c
index 1d274c64de09..09ae64a0004c 100644
--- a/drivers/media/platform/sh_veu.c
+++ b/drivers/media/platform/sh_veu.c
@@ -345,9 +345,9 @@ static int sh_veu_context_init(struct sh_veu_dev *veu)
 static int sh_veu_querycap(struct file *file, void *priv,
 			   struct v4l2_capability *cap)
 {
-	strlcpy(cap->driver, "sh-veu", sizeof(cap->driver));
-	strlcpy(cap->card, "sh-mobile VEU", sizeof(cap->card));
-	strlcpy(cap->bus_info, "platform:sh-veu", sizeof(cap->bus_info));
+	strscpy(cap->driver, "sh-veu", sizeof(cap->driver));
+	strscpy(cap->card, "sh-mobile VEU", sizeof(cap->card));
+	strscpy(cap->bus_info, "platform:sh-veu", sizeof(cap->bus_info));
 	cap->device_caps = V4L2_CAP_VIDEO_M2M | V4L2_CAP_STREAMING;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 
@@ -359,7 +359,8 @@ static int sh_veu_enum_fmt(struct v4l2_fmtdesc *f, const int *fmt, int fmt_num)
 	if (f->index >= fmt_num)
 		return -EINVAL;
 
-	strlcpy(f->description, sh_veu_fmt[fmt[f->index]].name, sizeof(f->description));
+	strscpy(f->description, sh_veu_fmt[fmt[f->index]].name,
+		sizeof(f->description));
 	f->pixelformat = sh_veu_fmt[fmt[f->index]].fourcc;
 	return 0;
 }
diff --git a/drivers/media/platform/sh_vou.c b/drivers/media/platform/sh_vou.c
index 6135e13e24d4..cee58b125548 100644
--- a/drivers/media/platform/sh_vou.c
+++ b/drivers/media/platform/sh_vou.c
@@ -378,9 +378,9 @@ static int sh_vou_querycap(struct file *file, void  *priv,
 
 	dev_dbg(vou_dev->v4l2_dev.dev, "%s()\n", __func__);
 
-	strlcpy(cap->card, "SuperH VOU", sizeof(cap->card));
-	strlcpy(cap->driver, "sh-vou", sizeof(cap->driver));
-	strlcpy(cap->bus_info, "platform:sh-vou", sizeof(cap->bus_info));
+	strscpy(cap->card, "SuperH VOU", sizeof(cap->card));
+	strscpy(cap->driver, "sh-vou", sizeof(cap->driver));
+	strscpy(cap->bus_info, "platform:sh-vou", sizeof(cap->bus_info));
 	cap->device_caps = V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_READWRITE |
 			   V4L2_CAP_STREAMING;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
@@ -399,7 +399,7 @@ static int sh_vou_enum_fmt_vid_out(struct file *file, void  *priv,
 	dev_dbg(vou_dev->v4l2_dev.dev, "%s()\n", __func__);
 
 	fmt->type = V4L2_BUF_TYPE_VIDEO_OUTPUT;
-	strlcpy(fmt->description, vou_fmt[fmt->index].desc,
+	strscpy(fmt->description, vou_fmt[fmt->index].desc,
 		sizeof(fmt->description));
 	fmt->pixelformat = vou_fmt[fmt->index].pfmt;
 
@@ -790,7 +790,7 @@ static int sh_vou_enum_output(struct file *file, void *fh,
 
 	if (a->index)
 		return -EINVAL;
-	strlcpy(a->name, "Video Out", sizeof(a->name));
+	strscpy(a->name, "Video Out", sizeof(a->name));
 	a->type = V4L2_OUTPUT_TYPE_ANALOG;
 	a->std = vou_dev->vdev.tvnorms;
 	return 0;
diff --git a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
index 0a2c0daaffef..6803f744e307 100644
--- a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
+++ b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
@@ -1564,9 +1564,9 @@ static __poll_t sh_mobile_ceu_poll(struct file *file, poll_table *pt)
 static int sh_mobile_ceu_querycap(struct soc_camera_host *ici,
 				  struct v4l2_capability *cap)
 {
-	strlcpy(cap->card, "SuperH_Mobile_CEU", sizeof(cap->card));
-	strlcpy(cap->driver, "sh_mobile_ceu", sizeof(cap->driver));
-	strlcpy(cap->bus_info, "platform:sh_mobile_ceu", sizeof(cap->bus_info));
+	strscpy(cap->card, "SuperH_Mobile_CEU", sizeof(cap->card));
+	strscpy(cap->driver, "sh_mobile_ceu", sizeof(cap->driver));
+	strscpy(cap->bus_info, "platform:sh_mobile_ceu", sizeof(cap->bus_info));
 	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS;
 
diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index 66d613629167..1a00b1fa7990 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -874,7 +874,7 @@ static int soc_camera_enum_fmt_vid_cap(struct file *file, void  *priv,
 	format = icd->user_formats[f->index].host_fmt;
 
 	if (format->name)
-		strlcpy(f->description, format->name, sizeof(f->description));
+		strscpy(f->description, format->name, sizeof(f->description));
 	f->pixelformat = format->fourcc;
 	return 0;
 }
@@ -910,7 +910,7 @@ static int soc_camera_querycap(struct file *file, void  *priv,
 
 	WARN_ON(priv != file->private_data);
 
-	strlcpy(cap->driver, ici->drv_name, sizeof(cap->driver));
+	strscpy(cap->driver, ici->drv_name, sizeof(cap->driver));
 	return ici->ops->querycap(ici, cap);
 }
 
@@ -2026,7 +2026,7 @@ static int video_dev_create(struct soc_camera_device *icd)
 	if (!vdev)
 		return -ENOMEM;
 
-	strlcpy(vdev->name, ici->drv_name, sizeof(vdev->name));
+	strscpy(vdev->name, ici->drv_name, sizeof(vdev->name));
 
 	vdev->v4l2_dev		= &ici->v4l2_dev;
 	vdev->fops		= &soc_camera_fops;
diff --git a/drivers/media/platform/soc_camera/soc_camera_platform.c b/drivers/media/platform/soc_camera/soc_camera_platform.c
index 6745a6e3f464..79fbe1fea95f 100644
--- a/drivers/media/platform/soc_camera/soc_camera_platform.c
+++ b/drivers/media/platform/soc_camera/soc_camera_platform.c
@@ -156,7 +156,7 @@ static int soc_camera_platform_probe(struct platform_device *pdev)
 
 	v4l2_subdev_init(&priv->subdev, &platform_subdev_ops);
 	v4l2_set_subdevdata(&priv->subdev, p);
-	strlcpy(priv->subdev.name, dev_name(&pdev->dev),
+	strscpy(priv->subdev.name, dev_name(&pdev->dev),
 		sizeof(priv->subdev.name));
 
 	return v4l2_device_register_subdev(&ici->v4l2_dev, &priv->subdev);
diff --git a/drivers/media/platform/sti/bdisp/bdisp-v4l2.c b/drivers/media/platform/sti/bdisp/bdisp-v4l2.c
index 66b64096f5de..79f7db1a9d18 100644
--- a/drivers/media/platform/sti/bdisp/bdisp-v4l2.c
+++ b/drivers/media/platform/sti/bdisp/bdisp-v4l2.c
@@ -688,8 +688,8 @@ static int bdisp_querycap(struct file *file, void *fh,
 	struct bdisp_ctx *ctx = fh_to_ctx(fh);
 	struct bdisp_dev *bdisp = ctx->bdisp_dev;
 
-	strlcpy(cap->driver, bdisp->pdev->name, sizeof(cap->driver));
-	strlcpy(cap->card, bdisp->pdev->name, sizeof(cap->card));
+	strscpy(cap->driver, bdisp->pdev->name, sizeof(cap->driver));
+	strscpy(cap->card, bdisp->pdev->name, sizeof(cap->card));
 	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s%d",
 		 BDISP_NAME, bdisp->id);
 
diff --git a/drivers/media/platform/sti/delta/delta-v4l2.c b/drivers/media/platform/sti/delta/delta-v4l2.c
index 0b42acd4e3a6..91369fb3ffaa 100644
--- a/drivers/media/platform/sti/delta/delta-v4l2.c
+++ b/drivers/media/platform/sti/delta/delta-v4l2.c
@@ -385,8 +385,8 @@ static int delta_querycap(struct file *file, void *priv,
 	struct delta_ctx *ctx = to_ctx(file->private_data);
 	struct delta_dev *delta = ctx->dev;
 
-	strlcpy(cap->driver, DELTA_NAME, sizeof(cap->driver));
-	strlcpy(cap->card, delta->vdev->name, sizeof(cap->card));
+	strscpy(cap->driver, DELTA_NAME, sizeof(cap->driver));
+	strscpy(cap->card, delta->vdev->name, sizeof(cap->card));
 	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s",
 		 delta->pdev->name);
 
diff --git a/drivers/media/platform/sti/hva/hva-v4l2.c b/drivers/media/platform/sti/hva/hva-v4l2.c
index 5a807c7c5e79..c42623dccfd6 100644
--- a/drivers/media/platform/sti/hva/hva-v4l2.c
+++ b/drivers/media/platform/sti/hva/hva-v4l2.c
@@ -257,8 +257,8 @@ static int hva_querycap(struct file *file, void *priv,
 	struct hva_ctx *ctx = fh_to_ctx(file->private_data);
 	struct hva_dev *hva = ctx_to_hdev(ctx);
 
-	strlcpy(cap->driver, HVA_NAME, sizeof(cap->driver));
-	strlcpy(cap->card, hva->vdev->name, sizeof(cap->card));
+	strscpy(cap->driver, HVA_NAME, sizeof(cap->driver));
+	strscpy(cap->card, hva->vdev->name, sizeof(cap->card));
 	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s",
 		 hva->pdev->name);
 
diff --git a/drivers/media/platform/stm32/stm32-dcmi.c b/drivers/media/platform/stm32/stm32-dcmi.c
index 721564176d8c..ba3e2eee1d92 100644
--- a/drivers/media/platform/stm32/stm32-dcmi.c
+++ b/drivers/media/platform/stm32/stm32-dcmi.c
@@ -1147,10 +1147,10 @@ static int dcmi_s_selection(struct file *file, void *priv,
 static int dcmi_querycap(struct file *file, void *priv,
 			 struct v4l2_capability *cap)
 {
-	strlcpy(cap->driver, DRV_NAME, sizeof(cap->driver));
-	strlcpy(cap->card, "STM32 Camera Memory Interface",
+	strscpy(cap->driver, DRV_NAME, sizeof(cap->driver));
+	strscpy(cap->card, "STM32 Camera Memory Interface",
 		sizeof(cap->card));
-	strlcpy(cap->bus_info, "platform:dcmi", sizeof(cap->bus_info));
+	strscpy(cap->bus_info, "platform:dcmi", sizeof(cap->bus_info));
 	return 0;
 }
 
@@ -1161,7 +1161,7 @@ static int dcmi_enum_input(struct file *file, void *priv,
 		return -EINVAL;
 
 	i->type = V4L2_INPUT_TYPE_CAMERA;
-	strlcpy(i->name, "Camera", sizeof(i->name));
+	strscpy(i->name, "Camera", sizeof(i->name));
 	return 0;
 }
 
@@ -1736,7 +1736,7 @@ static int dcmi_probe(struct platform_device *pdev)
 	dcmi->vdev->fops = &dcmi_fops;
 	dcmi->vdev->v4l2_dev = &dcmi->v4l2_dev;
 	dcmi->vdev->queue = &dcmi->queue;
-	strlcpy(dcmi->vdev->name, KBUILD_MODNAME, sizeof(dcmi->vdev->name));
+	strscpy(dcmi->vdev->name, KBUILD_MODNAME, sizeof(dcmi->vdev->name));
 	dcmi->vdev->release = video_device_release;
 	dcmi->vdev->ioctl_ops = &dcmi_ioctl_ops;
 	dcmi->vdev->lock = &dcmi->lock;
diff --git a/drivers/media/platform/ti-vpe/cal.c b/drivers/media/platform/ti-vpe/cal.c
index d1febe5baa6d..c9f54fbcdfe4 100644
--- a/drivers/media/platform/ti-vpe/cal.c
+++ b/drivers/media/platform/ti-vpe/cal.c
@@ -912,8 +912,8 @@ static int cal_querycap(struct file *file, void *priv,
 {
 	struct cal_ctx *ctx = video_drvdata(file);
 
-	strlcpy(cap->driver, CAL_MODULE_NAME, sizeof(cap->driver));
-	strlcpy(cap->card, CAL_MODULE_NAME, sizeof(cap->card));
+	strscpy(cap->driver, CAL_MODULE_NAME, sizeof(cap->driver));
+	strscpy(cap->card, CAL_MODULE_NAME, sizeof(cap->card));
 
 	snprintf(cap->bus_info, sizeof(cap->bus_info),
 		 "platform:%s", ctx->v4l2_dev.name);
@@ -1818,7 +1818,7 @@ static int cal_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	/* set pseudo v4l2 device name so we can use v4l2_printk */
-	strlcpy(dev->v4l2_dev.name, CAL_MODULE_NAME,
+	strscpy(dev->v4l2_dev.name, CAL_MODULE_NAME,
 		sizeof(dev->v4l2_dev.name));
 
 	/* save pdev pointer */
diff --git a/drivers/media/platform/via-camera.c b/drivers/media/platform/via-camera.c
index c8bb82fe0b9d..554870e48750 100644
--- a/drivers/media/platform/via-camera.c
+++ b/drivers/media/platform/via-camera.c
@@ -860,8 +860,8 @@ static int viacam_enum_fmt_vid_cap(struct file *filp, void *priv,
 {
 	if (fmt->index >= N_VIA_FMTS)
 		return -EINVAL;
-	strlcpy(fmt->description, via_formats[fmt->index].desc,
-			sizeof(fmt->description));
+	strscpy(fmt->description, via_formats[fmt->index].desc,
+		sizeof(fmt->description));
 	fmt->pixelformat = via_formats[fmt->index].pixelformat;
 	return 0;
 }
diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
index fdd77441a47b..3c96b7567c8d 100644
--- a/drivers/media/platform/vicodec/vicodec-core.c
+++ b/drivers/media/platform/vicodec/vicodec-core.c
@@ -1283,7 +1283,7 @@ static int vicodec_probe(struct platform_device *pdev)
 
 #ifdef CONFIG_MEDIA_CONTROLLER
 	dev->mdev.dev = &pdev->dev;
-	strlcpy(dev->mdev.model, "vicodec", sizeof(dev->mdev.model));
+	strscpy(dev->mdev.model, "vicodec", sizeof(dev->mdev.model));
 	media_device_init(&dev->mdev);
 	dev->v4l2_dev.mdev = &dev->mdev;
 #endif
@@ -1311,7 +1311,7 @@ static int vicodec_probe(struct platform_device *pdev)
 	vfd = &dev->enc_vfd;
 	vfd->lock = &dev->enc_mutex;
 	vfd->v4l2_dev = &dev->v4l2_dev;
-	strlcpy(vfd->name, "vicodec-enc", sizeof(vfd->name));
+	strscpy(vfd->name, "vicodec-enc", sizeof(vfd->name));
 	v4l2_disable_ioctl(vfd, VIDIOC_DECODER_CMD);
 	v4l2_disable_ioctl(vfd, VIDIOC_TRY_DECODER_CMD);
 	video_set_drvdata(vfd, dev);
@@ -1328,7 +1328,7 @@ static int vicodec_probe(struct platform_device *pdev)
 	vfd = &dev->dec_vfd;
 	vfd->lock = &dev->dec_mutex;
 	vfd->v4l2_dev = &dev->v4l2_dev;
-	strlcpy(vfd->name, "vicodec-dec", sizeof(vfd->name));
+	strscpy(vfd->name, "vicodec-dec", sizeof(vfd->name));
 	v4l2_disable_ioctl(vfd, VIDIOC_ENCODER_CMD);
 	v4l2_disable_ioctl(vfd, VIDIOC_TRY_ENCODER_CMD);
 	video_set_drvdata(vfd, dev);
diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
index 462099a141e4..60c522ee2e03 100644
--- a/drivers/media/platform/vim2m.c
+++ b/drivers/media/platform/vim2m.c
@@ -1038,7 +1038,7 @@ static int vim2m_probe(struct platform_device *pdev)
 
 #ifdef CONFIG_MEDIA_CONTROLLER
 	dev->mdev.dev = &pdev->dev;
-	strlcpy(dev->mdev.model, "vim2m", sizeof(dev->mdev.model));
+	strscpy(dev->mdev.model, "vim2m", sizeof(dev->mdev.model));
 	media_device_init(&dev->mdev);
 	dev->v4l2_dev.mdev = &dev->mdev;
 
diff --git a/drivers/media/platform/vimc/vimc-capture.c b/drivers/media/platform/vimc/vimc-capture.c
index ec68feaac378..3f7e9ed56633 100644
--- a/drivers/media/platform/vimc/vimc-capture.c
+++ b/drivers/media/platform/vimc/vimc-capture.c
@@ -71,8 +71,8 @@ static int vimc_cap_querycap(struct file *file, void *priv,
 {
 	struct vimc_cap_device *vcap = video_drvdata(file);
 
-	strlcpy(cap->driver, KBUILD_MODNAME, sizeof(cap->driver));
-	strlcpy(cap->card, KBUILD_MODNAME, sizeof(cap->card));
+	strscpy(cap->driver, KBUILD_MODNAME, sizeof(cap->driver));
+	strscpy(cap->card, KBUILD_MODNAME, sizeof(cap->card));
 	snprintf(cap->bus_info, sizeof(cap->bus_info),
 		 "platform:%s", vcap->vdev.v4l2_dev->name);
 
@@ -476,7 +476,7 @@ static int vimc_cap_comp_bind(struct device *comp, struct device *master,
 	vdev->queue = q;
 	vdev->v4l2_dev = v4l2_dev;
 	vdev->vfl_dir = VFL_DIR_RX;
-	strlcpy(vdev->name, pdata->entity_name, sizeof(vdev->name));
+	strscpy(vdev->name, pdata->entity_name, sizeof(vdev->name));
 	video_set_drvdata(vdev, &vcap->ved);
 
 	/* Register the video_device with the v4l2 and the media framework */
diff --git a/drivers/media/platform/vimc/vimc-common.c b/drivers/media/platform/vimc/vimc-common.c
index 617415c224fe..dee1b9dfc4f6 100644
--- a/drivers/media/platform/vimc/vimc-common.c
+++ b/drivers/media/platform/vimc/vimc-common.c
@@ -430,7 +430,7 @@ int vimc_ent_sd_register(struct vimc_ent_device *ved,
 	sd->entity.function = function;
 	sd->entity.ops = &vimc_ent_sd_mops;
 	sd->owner = THIS_MODULE;
-	strlcpy(sd->name, name, sizeof(sd->name));
+	strscpy(sd->name, name, sizeof(sd->name));
 	v4l2_set_subdevdata(sd, ved);
 
 	/* Expose this subdev to user space */
diff --git a/drivers/media/platform/vimc/vimc-core.c b/drivers/media/platform/vimc/vimc-core.c
index 9246f265de31..ce809d2e3d53 100644
--- a/drivers/media/platform/vimc/vimc-core.c
+++ b/drivers/media/platform/vimc/vimc-core.c
@@ -259,7 +259,7 @@ static struct component_match *vimc_add_subdevs(struct vimc_device *vimc)
 		dev_dbg(&vimc->pdev.dev, "new pdev for %s\n",
 			vimc->pipe_cfg->ents[i].drv);
 
-		strlcpy(pdata.entity_name, vimc->pipe_cfg->ents[i].name,
+		strscpy(pdata.entity_name, vimc->pipe_cfg->ents[i].name,
 			sizeof(pdata.entity_name));
 
 		vimc->subdevs[i] = platform_device_register_data(&vimc->pdev.dev,
@@ -317,7 +317,7 @@ static int vimc_probe(struct platform_device *pdev)
 	vimc->v4l2_dev.mdev = &vimc->mdev;
 
 	/* Initialize media device */
-	strlcpy(vimc->mdev.model, VIMC_MDEV_MODEL_NAME,
+	strscpy(vimc->mdev.model, VIMC_MDEV_MODEL_NAME,
 		sizeof(vimc->mdev.model));
 	vimc->mdev.dev = &pdev->dev;
 	media_device_init(&vimc->mdev);
diff --git a/drivers/media/platform/vivid/vivid-osd.c b/drivers/media/platform/vivid/vivid-osd.c
index bbbc1b6938a5..1a89593b0c86 100644
--- a/drivers/media/platform/vivid/vivid-osd.c
+++ b/drivers/media/platform/vivid/vivid-osd.c
@@ -110,7 +110,7 @@ static int vivid_fb_get_fix(struct vivid_dev *dev, struct fb_fix_screeninfo *fix
 {
 	dprintk(dev, 1, "vivid_fb_get_fix\n");
 	memset(fix, 0, sizeof(struct fb_fix_screeninfo));
-	strlcpy(fix->id, "vioverlay fb", sizeof(fix->id));
+	strscpy(fix->id, "vioverlay fb", sizeof(fix->id));
 	fix->smem_start = dev->video_pbase;
 	fix->smem_len = dev->video_buffer_size;
 	fix->type = FB_TYPE_PACKED_PIXELS;
diff --git a/drivers/media/platform/vivid/vivid-radio-common.c b/drivers/media/platform/vivid/vivid-radio-common.c
index 7c8efe38ff5b..138c7bce68b1 100644
--- a/drivers/media/platform/vivid/vivid-radio-common.c
+++ b/drivers/media/platform/vivid/vivid-radio-common.c
@@ -76,10 +76,10 @@ void vivid_radio_rds_init(struct vivid_dev *dev)
 		rds->ta = dev->radio_tx_rds_ta->cur.val;
 		rds->tp = dev->radio_tx_rds_tp->cur.val;
 		rds->ms = dev->radio_tx_rds_ms->cur.val;
-		strlcpy(rds->psname,
+		strscpy(rds->psname,
 			dev->radio_tx_rds_psname->p_cur.p_char,
 			sizeof(rds->psname));
-		strlcpy(rds->radiotext,
+		strscpy(rds->radiotext,
 			dev->radio_tx_rds_radiotext->p_cur.p_char + alt * 64,
 			sizeof(rds->radiotext));
 		v4l2_ctrl_unlock(dev->radio_tx_rds_pi);
diff --git a/drivers/media/platform/vivid/vivid-radio-rx.c b/drivers/media/platform/vivid/vivid-radio-rx.c
index 1f86d7d4f72f..232cab508f48 100644
--- a/drivers/media/platform/vivid/vivid-radio-rx.c
+++ b/drivers/media/platform/vivid/vivid-radio-rx.c
@@ -223,7 +223,7 @@ int vivid_radio_rx_g_tuner(struct file *file, void *fh, struct v4l2_tuner *vt)
 	if (vt->index > 0)
 		return -EINVAL;
 
-	strlcpy(vt->name, "AM/FM/SW Receiver", sizeof(vt->name));
+	strscpy(vt->name, "AM/FM/SW Receiver", sizeof(vt->name));
 	vt->capability = V4L2_TUNER_CAP_LOW | V4L2_TUNER_CAP_STEREO |
 			 V4L2_TUNER_CAP_FREQ_BANDS | V4L2_TUNER_CAP_RDS |
 			 (dev->radio_rx_rds_controls ?
diff --git a/drivers/media/platform/vivid/vivid-radio-tx.c b/drivers/media/platform/vivid/vivid-radio-tx.c
index 1a3749ba5e7e..049d40b948bb 100644
--- a/drivers/media/platform/vivid/vivid-radio-tx.c
+++ b/drivers/media/platform/vivid/vivid-radio-tx.c
@@ -103,7 +103,7 @@ int vidioc_g_modulator(struct file *file, void *fh, struct v4l2_modulator *a)
 	if (a->index > 0)
 		return -EINVAL;
 
-	strlcpy(a->name, "AM/FM/SW Transmitter", sizeof(a->name));
+	strscpy(a->name, "AM/FM/SW Transmitter", sizeof(a->name));
 	a->capability = V4L2_TUNER_CAP_LOW | V4L2_TUNER_CAP_STEREO |
 			V4L2_TUNER_CAP_FREQ_BANDS | V4L2_TUNER_CAP_RDS |
 			(dev->radio_tx_rds_controls ?
diff --git a/drivers/media/platform/vivid/vivid-rds-gen.c b/drivers/media/platform/vivid/vivid-rds-gen.c
index 39ca9a56448c..b5b104ee64c9 100644
--- a/drivers/media/platform/vivid/vivid-rds-gen.c
+++ b/drivers/media/platform/vivid/vivid-rds-gen.c
@@ -147,11 +147,11 @@ void vivid_rds_gen_fill(struct vivid_rds_gen *rds, unsigned freq,
 	snprintf(rds->psname, sizeof(rds->psname), "%6d.%1d",
 		 freq / 16, ((freq & 0xf) * 10) / 16);
 	if (alt)
-		strlcpy(rds->radiotext,
+		strscpy(rds->radiotext,
 			" The Radio Data System can switch between different Radio Texts ",
 			sizeof(rds->radiotext));
 	else
-		strlcpy(rds->radiotext,
+		strscpy(rds->radiotext,
 			"An example of Radio Text as transmitted by the Radio Data System",
 			sizeof(rds->radiotext));
 }
diff --git a/drivers/media/platform/vivid/vivid-sdr-cap.c b/drivers/media/platform/vivid/vivid-sdr-cap.c
index cfb7cb4d37a8..200b789a3f21 100644
--- a/drivers/media/platform/vivid/vivid-sdr-cap.c
+++ b/drivers/media/platform/vivid/vivid-sdr-cap.c
@@ -396,7 +396,7 @@ int vivid_sdr_g_tuner(struct file *file, void *fh, struct v4l2_tuner *vt)
 {
 	switch (vt->index) {
 	case 0:
-		strlcpy(vt->name, "ADC", sizeof(vt->name));
+		strscpy(vt->name, "ADC", sizeof(vt->name));
 		vt->type = V4L2_TUNER_ADC;
 		vt->capability =
 			V4L2_TUNER_CAP_1HZ | V4L2_TUNER_CAP_FREQ_BANDS;
@@ -404,7 +404,7 @@ int vivid_sdr_g_tuner(struct file *file, void *fh, struct v4l2_tuner *vt)
 		vt->rangehigh = bands_adc[2].rangehigh;
 		return 0;
 	case 1:
-		strlcpy(vt->name, "RF", sizeof(vt->name));
+		strscpy(vt->name, "RF", sizeof(vt->name));
 		vt->type = V4L2_TUNER_RF;
 		vt->capability =
 			V4L2_TUNER_CAP_1HZ | V4L2_TUNER_CAP_FREQ_BANDS;
diff --git a/drivers/media/platform/vivid/vivid-vid-cap.c b/drivers/media/platform/vivid/vivid-vid-cap.c
index 1599159f2574..f2c37e959bea 100644
--- a/drivers/media/platform/vivid/vivid-vid-cap.c
+++ b/drivers/media/platform/vivid/vivid-vid-cap.c
@@ -1505,7 +1505,7 @@ int vivid_video_g_tuner(struct file *file, void *fh, struct v4l2_tuner *vt)
 			break;
 		}
 	}
-	strlcpy(vt->name, "TV Tuner", sizeof(vt->name));
+	strscpy(vt->name, "TV Tuner", sizeof(vt->name));
 	return 0;
 }
 
diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
index b6619c9c18bb..8c9d9d6e5632 100644
--- a/drivers/media/platform/vsp1/vsp1_drv.c
+++ b/drivers/media/platform/vsp1/vsp1_drv.c
@@ -242,7 +242,7 @@ static int vsp1_create_entities(struct vsp1_device *vsp1)
 
 	mdev->dev = vsp1->dev;
 	mdev->hw_revision = vsp1->version;
-	strlcpy(mdev->model, vsp1->info->model, sizeof(mdev->model));
+	strscpy(mdev->model, vsp1->info->model, sizeof(mdev->model));
 	snprintf(mdev->bus_info, sizeof(mdev->bus_info), "platform:%s",
 		 dev_name(mdev->dev));
 	media_device_init(mdev);
diff --git a/drivers/media/platform/vsp1/vsp1_histo.c b/drivers/media/platform/vsp1/vsp1_histo.c
index 5e15c8ff88d9..8b01e99acd20 100644
--- a/drivers/media/platform/vsp1/vsp1_histo.c
+++ b/drivers/media/platform/vsp1/vsp1_histo.c
@@ -429,8 +429,8 @@ static int histo_v4l2_querycap(struct file *file, void *fh,
 	cap->device_caps = V4L2_CAP_META_CAPTURE
 			 | V4L2_CAP_STREAMING;
 
-	strlcpy(cap->driver, "vsp1", sizeof(cap->driver));
-	strlcpy(cap->card, histo->video.name, sizeof(cap->card));
+	strscpy(cap->driver, "vsp1", sizeof(cap->driver));
+	strscpy(cap->card, histo->video.name, sizeof(cap->card));
 	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s",
 		 dev_name(histo->entity.vsp1->dev));
 
diff --git a/drivers/media/platform/vsp1/vsp1_video.c b/drivers/media/platform/vsp1/vsp1_video.c
index 81d47a09d7bc..aa54322dad71 100644
--- a/drivers/media/platform/vsp1/vsp1_video.c
+++ b/drivers/media/platform/vsp1/vsp1_video.c
@@ -976,8 +976,8 @@ vsp1_video_querycap(struct file *file, void *fh, struct v4l2_capability *cap)
 		cap->device_caps = V4L2_CAP_VIDEO_OUTPUT_MPLANE
 				 | V4L2_CAP_STREAMING;
 
-	strlcpy(cap->driver, "vsp1", sizeof(cap->driver));
-	strlcpy(cap->card, video->video.name, sizeof(cap->card));
+	strscpy(cap->driver, "vsp1", sizeof(cap->driver));
+	strscpy(cap->card, video->video.name, sizeof(cap->card));
 	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s",
 		 dev_name(video->vsp1->dev));
 
diff --git a/drivers/media/platform/xilinx/xilinx-dma.c b/drivers/media/platform/xilinx/xilinx-dma.c
index d041f94be832..5d3f627516b2 100644
--- a/drivers/media/platform/xilinx/xilinx-dma.c
+++ b/drivers/media/platform/xilinx/xilinx-dma.c
@@ -504,8 +504,8 @@ xvip_dma_querycap(struct file *file, void *fh, struct v4l2_capability *cap)
 	cap->capabilities = cap->device_caps | V4L2_CAP_DEVICE_CAPS
 			  | dma->xdev->v4l2_caps;
 
-	strlcpy(cap->driver, "xilinx-vipp", sizeof(cap->driver));
-	strlcpy(cap->card, dma->video.name, sizeof(cap->card));
+	strscpy(cap->driver, "xilinx-vipp", sizeof(cap->driver));
+	strscpy(cap->card, dma->video.name, sizeof(cap->card));
 	snprintf(cap->bus_info, sizeof(cap->bus_info), "platform:%s:%u",
 		 dma->xdev->dev->of_node->name, dma->port);
 
@@ -527,7 +527,7 @@ xvip_dma_enum_format(struct file *file, void *fh, struct v4l2_fmtdesc *f)
 		return -EINVAL;
 
 	f->pixelformat = dma->format.pixelformat;
-	strlcpy(f->description, dma->fmtinfo->description,
+	strscpy(f->description, dma->fmtinfo->description,
 		sizeof(f->description));
 
 	return 0;
diff --git a/drivers/media/platform/xilinx/xilinx-tpg.c b/drivers/media/platform/xilinx/xilinx-tpg.c
index 9c49d1d10bee..851d20dcd550 100644
--- a/drivers/media/platform/xilinx/xilinx-tpg.c
+++ b/drivers/media/platform/xilinx/xilinx-tpg.c
@@ -833,7 +833,7 @@ static int xtpg_probe(struct platform_device *pdev)
 	v4l2_subdev_init(subdev, &xtpg_ops);
 	subdev->dev = &pdev->dev;
 	subdev->internal_ops = &xtpg_internal_ops;
-	strlcpy(subdev->name, dev_name(&pdev->dev), sizeof(subdev->name));
+	strscpy(subdev->name, dev_name(&pdev->dev), sizeof(subdev->name));
 	v4l2_set_subdevdata(subdev, xtpg);
 	subdev->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
 	subdev->entity.ops = &xtpg_media_ops;
diff --git a/drivers/media/platform/xilinx/xilinx-vipp.c b/drivers/media/platform/xilinx/xilinx-vipp.c
index 6d95ec1e9a6b..5148df007c6e 100644
--- a/drivers/media/platform/xilinx/xilinx-vipp.c
+++ b/drivers/media/platform/xilinx/xilinx-vipp.c
@@ -578,7 +578,7 @@ static int xvip_composite_v4l2_init(struct xvip_composite_device *xdev)
 	int ret;
 
 	xdev->media_dev.dev = xdev->dev;
-	strlcpy(xdev->media_dev.model, "Xilinx Video Composite Device",
+	strscpy(xdev->media_dev.model, "Xilinx Video Composite Device",
 		sizeof(xdev->media_dev.model));
 	xdev->media_dev.hw_revision = 0;
 
diff --git a/drivers/media/radio/dsbr100.c b/drivers/media/radio/dsbr100.c
index 8521bb2825e8..a6f207b448be 100644
--- a/drivers/media/radio/dsbr100.c
+++ b/drivers/media/radio/dsbr100.c
@@ -174,8 +174,8 @@ static int vidioc_querycap(struct file *file, void *priv,
 {
 	struct dsbr100_device *radio = video_drvdata(file);
 
-	strlcpy(v->driver, "dsbr100", sizeof(v->driver));
-	strlcpy(v->card, "D-Link R-100 USB FM Radio", sizeof(v->card));
+	strscpy(v->driver, "dsbr100", sizeof(v->driver));
+	strscpy(v->card, "D-Link R-100 USB FM Radio", sizeof(v->card));
 	usb_make_path(radio->usbdev, v->bus_info, sizeof(v->bus_info));
 	v->device_caps = V4L2_CAP_RADIO | V4L2_CAP_TUNER;
 	v->capabilities = v->device_caps | V4L2_CAP_DEVICE_CAPS;
@@ -379,7 +379,8 @@ static int usb_dsbr100_probe(struct usb_interface *intf,
 		goto err_reg_ctrl;
 	}
 	mutex_init(&radio->v4l2_lock);
-	strlcpy(radio->videodev.name, v4l2_dev->name, sizeof(radio->videodev.name));
+	strscpy(radio->videodev.name, v4l2_dev->name,
+		sizeof(radio->videodev.name));
 	radio->videodev.v4l2_dev = v4l2_dev;
 	radio->videodev.fops = &usb_dsbr100_fops;
 	radio->videodev.ioctl_ops = &usb_dsbr100_ioctl_ops;
diff --git a/drivers/media/radio/radio-cadet.c b/drivers/media/radio/radio-cadet.c
index 5b82e63885cd..d12e07e32546 100644
--- a/drivers/media/radio/radio-cadet.c
+++ b/drivers/media/radio/radio-cadet.c
@@ -353,9 +353,9 @@ static ssize_t cadet_read(struct file *file, char __user *data, size_t count, lo
 static int vidioc_querycap(struct file *file, void *priv,
 				struct v4l2_capability *v)
 {
-	strlcpy(v->driver, "ADS Cadet", sizeof(v->driver));
-	strlcpy(v->card, "ADS Cadet", sizeof(v->card));
-	strlcpy(v->bus_info, "ISA:radio-cadet", sizeof(v->bus_info));
+	strscpy(v->driver, "ADS Cadet", sizeof(v->driver));
+	strscpy(v->card, "ADS Cadet", sizeof(v->card));
+	strscpy(v->bus_info, "ISA:radio-cadet", sizeof(v->bus_info));
 	v->device_caps = V4L2_CAP_TUNER | V4L2_CAP_RADIO |
 			  V4L2_CAP_READWRITE | V4L2_CAP_RDS_CAPTURE;
 	v->capabilities = v->device_caps | V4L2_CAP_DEVICE_CAPS;
@@ -370,7 +370,7 @@ static int vidioc_g_tuner(struct file *file, void *priv,
 	if (v->index)
 		return -EINVAL;
 	v->type = V4L2_TUNER_RADIO;
-	strlcpy(v->name, "Radio", sizeof(v->name));
+	strscpy(v->name, "Radio", sizeof(v->name));
 	v->capability = bands[0].capability | bands[1].capability;
 	v->rangelow = bands[0].rangelow;	   /* 520 kHz (start of AM band) */
 	v->rangehigh = bands[1].rangehigh;    /* 108.0 MHz (end of FM band) */
@@ -595,7 +595,7 @@ static int __init cadet_init(void)
 	struct v4l2_ctrl_handler *hdl;
 	int res = -ENODEV;
 
-	strlcpy(v4l2_dev->name, "cadet", sizeof(v4l2_dev->name));
+	strscpy(v4l2_dev->name, "cadet", sizeof(v4l2_dev->name));
 	mutex_init(&dev->lock);
 
 	/* If a probe was requested then probe ISAPnP first (safest) */
@@ -639,7 +639,7 @@ static int __init cadet_init(void)
 	dev->is_fm_band = true;
 	dev->curfreq = bands[dev->is_fm_band].rangelow;
 	cadet_setfreq(dev, dev->curfreq);
-	strlcpy(dev->vdev.name, v4l2_dev->name, sizeof(dev->vdev.name));
+	strscpy(dev->vdev.name, v4l2_dev->name, sizeof(dev->vdev.name));
 	dev->vdev.v4l2_dev = v4l2_dev;
 	dev->vdev.fops = &cadet_fops;
 	dev->vdev.ioctl_ops = &cadet_ioctl_ops;
diff --git a/drivers/media/radio/radio-isa.c b/drivers/media/radio/radio-isa.c
index 7312e469e850..551de8a45b95 100644
--- a/drivers/media/radio/radio-isa.c
+++ b/drivers/media/radio/radio-isa.c
@@ -42,8 +42,8 @@ static int radio_isa_querycap(struct file *file, void  *priv,
 {
 	struct radio_isa_card *isa = video_drvdata(file);
 
-	strlcpy(v->driver, isa->drv->driver.driver.name, sizeof(v->driver));
-	strlcpy(v->card, isa->drv->card, sizeof(v->card));
+	strscpy(v->driver, isa->drv->driver.driver.name, sizeof(v->driver));
+	strscpy(v->card, isa->drv->card, sizeof(v->card));
 	snprintf(v->bus_info, sizeof(v->bus_info), "ISA:%s", isa->v4l2_dev.name);
 
 	v->device_caps = V4L2_CAP_TUNER | V4L2_CAP_RADIO;
@@ -60,7 +60,7 @@ static int radio_isa_g_tuner(struct file *file, void *priv,
 	if (v->index > 0)
 		return -EINVAL;
 
-	strlcpy(v->name, "FM", sizeof(v->name));
+	strscpy(v->name, "FM", sizeof(v->name));
 	v->type = V4L2_TUNER_RADIO;
 	v->rangelow = FREQ_LOW;
 	v->rangehigh = FREQ_HIGH;
@@ -198,7 +198,7 @@ static struct radio_isa_card *radio_isa_alloc(struct radio_isa_driver *drv,
 	dev_set_drvdata(pdev, isa);
 	isa->drv = drv;
 	v4l2_dev = &isa->v4l2_dev;
-	strlcpy(v4l2_dev->name, dev_name(pdev), sizeof(v4l2_dev->name));
+	strscpy(v4l2_dev->name, dev_name(pdev), sizeof(v4l2_dev->name));
 
 	return isa;
 }
@@ -243,7 +243,7 @@ static int radio_isa_common_probe(struct radio_isa_card *isa,
 
 	mutex_init(&isa->lock);
 	isa->vdev.lock = &isa->lock;
-	strlcpy(isa->vdev.name, v4l2_dev->name, sizeof(isa->vdev.name));
+	strscpy(isa->vdev.name, v4l2_dev->name, sizeof(isa->vdev.name));
 	isa->vdev.v4l2_dev = v4l2_dev;
 	isa->vdev.fops = &radio_isa_fops;
 	isa->vdev.ioctl_ops = &radio_isa_ioctl_ops;
diff --git a/drivers/media/radio/radio-keene.c b/drivers/media/radio/radio-keene.c
index f2ea8bc5f5ee..e9484b013073 100644
--- a/drivers/media/radio/radio-keene.c
+++ b/drivers/media/radio/radio-keene.c
@@ -174,8 +174,8 @@ static int vidioc_querycap(struct file *file, void *priv,
 {
 	struct keene_device *radio = video_drvdata(file);
 
-	strlcpy(v->driver, "radio-keene", sizeof(v->driver));
-	strlcpy(v->card, "Keene FM Transmitter", sizeof(v->card));
+	strscpy(v->driver, "radio-keene", sizeof(v->driver));
+	strscpy(v->card, "Keene FM Transmitter", sizeof(v->card));
 	usb_make_path(radio->usbdev, v->bus_info, sizeof(v->bus_info));
 	v->device_caps = V4L2_CAP_RADIO | V4L2_CAP_MODULATOR;
 	v->capabilities = v->device_caps | V4L2_CAP_DEVICE_CAPS;
@@ -190,7 +190,7 @@ static int vidioc_g_modulator(struct file *file, void *priv,
 	if (v->index > 0)
 		return -EINVAL;
 
-	strlcpy(v->name, "FM", sizeof(v->name));
+	strscpy(v->name, "FM", sizeof(v->name));
 	v->rangelow = FREQ_MIN * FREQ_MUL;
 	v->rangehigh = FREQ_MAX * FREQ_MUL;
 	v->txsubchans = radio->stereo ? V4L2_TUNER_SUB_STEREO : V4L2_TUNER_SUB_MONO;
@@ -362,7 +362,7 @@ static int usb_keene_probe(struct usb_interface *intf,
 
 	radio->v4l2_dev.ctrl_handler = hdl;
 	radio->v4l2_dev.release = usb_keene_video_device_release;
-	strlcpy(radio->vdev.name, radio->v4l2_dev.name,
+	strscpy(radio->vdev.name, radio->v4l2_dev.name,
 		sizeof(radio->vdev.name));
 	radio->vdev.v4l2_dev = &radio->v4l2_dev;
 	radio->vdev.fops = &usb_keene_fops;
diff --git a/drivers/media/radio/radio-ma901.c b/drivers/media/radio/radio-ma901.c
index fdc481257efd..0a59d97d4627 100644
--- a/drivers/media/radio/radio-ma901.c
+++ b/drivers/media/radio/radio-ma901.c
@@ -197,8 +197,8 @@ static int vidioc_querycap(struct file *file, void *priv,
 {
 	struct ma901radio_device *radio = video_drvdata(file);
 
-	strlcpy(v->driver, "radio-ma901", sizeof(v->driver));
-	strlcpy(v->card, "Masterkit MA901 USB FM Radio", sizeof(v->card));
+	strscpy(v->driver, "radio-ma901", sizeof(v->driver));
+	strscpy(v->card, "Masterkit MA901 USB FM Radio", sizeof(v->card));
 	usb_make_path(radio->usbdev, v->bus_info, sizeof(v->bus_info));
 	v->device_caps = V4L2_CAP_RADIO | V4L2_CAP_TUNER;
 	v->capabilities = v->device_caps | V4L2_CAP_DEVICE_CAPS;
@@ -400,7 +400,7 @@ static int usb_ma901radio_probe(struct usb_interface *intf,
 
 	radio->v4l2_dev.ctrl_handler = &radio->hdl;
 	radio->v4l2_dev.release = usb_ma901radio_release;
-	strlcpy(radio->vdev.name, radio->v4l2_dev.name,
+	strscpy(radio->vdev.name, radio->v4l2_dev.name,
 		sizeof(radio->vdev.name));
 	radio->vdev.v4l2_dev = &radio->v4l2_dev;
 	radio->vdev.fops = &usb_ma901radio_fops;
diff --git a/drivers/media/radio/radio-maxiradio.c b/drivers/media/radio/radio-maxiradio.c
index e4e758739246..1b97ad2ce7d0 100644
--- a/drivers/media/radio/radio-maxiradio.c
+++ b/drivers/media/radio/radio-maxiradio.c
@@ -142,7 +142,7 @@ static int maxiradio_probe(struct pci_dev *pdev,
 	dev->tea.cannot_read_data = true;
 	dev->tea.v4l2_dev = v4l2_dev;
 	dev->tea.radio_nr = radio_nr;
-	strlcpy(dev->tea.card, "Maxi Radio FM2000", sizeof(dev->tea.card));
+	strscpy(dev->tea.card, "Maxi Radio FM2000", sizeof(dev->tea.card));
 	snprintf(dev->tea.bus_info, sizeof(dev->tea.bus_info),
 			"PCI:%s", pci_name(pdev));
 
diff --git a/drivers/media/radio/radio-miropcm20.c b/drivers/media/radio/radio-miropcm20.c
index 7b35e633118d..b626567b75c5 100644
--- a/drivers/media/radio/radio-miropcm20.c
+++ b/drivers/media/radio/radio-miropcm20.c
@@ -200,8 +200,8 @@ static int vidioc_querycap(struct file *file, void *priv,
 {
 	struct pcm20 *dev = video_drvdata(file);
 
-	strlcpy(v->driver, "Miro PCM20", sizeof(v->driver));
-	strlcpy(v->card, "Miro PCM20", sizeof(v->card));
+	strscpy(v->driver, "Miro PCM20", sizeof(v->driver));
+	strscpy(v->card, "Miro PCM20", sizeof(v->card));
 	snprintf(v->bus_info, sizeof(v->bus_info), "ISA:%s", dev->v4l2_dev.name);
 	v->device_caps = V4L2_CAP_TUNER | V4L2_CAP_RADIO | V4L2_CAP_RDS_CAPTURE;
 	v->capabilities = v->device_caps | V4L2_CAP_DEVICE_CAPS;
@@ -231,7 +231,7 @@ static int vidioc_g_tuner(struct file *file, void *priv,
 
 	if (v->index)
 		return -EINVAL;
-	strlcpy(v->name, "FM", sizeof(v->name));
+	strscpy(v->name, "FM", sizeof(v->name));
 	v->type = V4L2_TUNER_RADIO;
 	v->rangelow = 87*16000;
 	v->rangehigh = 108*16000;
@@ -443,7 +443,7 @@ static int __init pcm20_init(void)
 			 "you must load the snd-miro driver first!\n");
 		return -ENODEV;
 	}
-	strlcpy(v4l2_dev->name, "radio-miropcm20", sizeof(v4l2_dev->name));
+	strscpy(v4l2_dev->name, "radio-miropcm20", sizeof(v4l2_dev->name));
 	mutex_init(&dev->lock);
 
 	res = v4l2_device_register(NULL, v4l2_dev);
@@ -474,7 +474,7 @@ static int __init pcm20_init(void)
 		v4l2_err(v4l2_dev, "Could not register control\n");
 		goto err_hdl;
 	}
-	strlcpy(dev->vdev.name, v4l2_dev->name, sizeof(dev->vdev.name));
+	strscpy(dev->vdev.name, v4l2_dev->name, sizeof(dev->vdev.name));
 	dev->vdev.v4l2_dev = v4l2_dev;
 	dev->vdev.fops = &pcm20_fops;
 	dev->vdev.ioctl_ops = &pcm20_ioctl_ops;
diff --git a/drivers/media/radio/radio-mr800.c b/drivers/media/radio/radio-mr800.c
index 0f292c6ba338..e7c35b184e21 100644
--- a/drivers/media/radio/radio-mr800.c
+++ b/drivers/media/radio/radio-mr800.c
@@ -266,8 +266,8 @@ static int vidioc_querycap(struct file *file, void *priv,
 {
 	struct amradio_device *radio = video_drvdata(file);
 
-	strlcpy(v->driver, "radio-mr800", sizeof(v->driver));
-	strlcpy(v->card, "AverMedia MR 800 USB FM Radio", sizeof(v->card));
+	strscpy(v->driver, "radio-mr800", sizeof(v->driver));
+	strscpy(v->card, "AverMedia MR 800 USB FM Radio", sizeof(v->card));
 	usb_make_path(radio->usbdev, v->bus_info, sizeof(v->bus_info));
 	v->device_caps = V4L2_CAP_RADIO | V4L2_CAP_TUNER |
 					V4L2_CAP_HW_FREQ_SEEK;
@@ -547,7 +547,7 @@ static int usb_amradio_probe(struct usb_interface *intf,
 
 	radio->v4l2_dev.ctrl_handler = &radio->hdl;
 	radio->v4l2_dev.release = usb_amradio_release;
-	strlcpy(radio->vdev.name, radio->v4l2_dev.name,
+	strscpy(radio->vdev.name, radio->v4l2_dev.name,
 		sizeof(radio->vdev.name));
 	radio->vdev.v4l2_dev = &radio->v4l2_dev;
 	radio->vdev.fops = &usb_amradio_fops;
diff --git a/drivers/media/radio/radio-raremono.c b/drivers/media/radio/radio-raremono.c
index 9a5079d64c4a..5e782b3c2fa9 100644
--- a/drivers/media/radio/radio-raremono.c
+++ b/drivers/media/radio/radio-raremono.c
@@ -181,8 +181,8 @@ static int vidioc_querycap(struct file *file, void *priv,
 {
 	struct raremono_device *radio = video_drvdata(file);
 
-	strlcpy(v->driver, "radio-raremono", sizeof(v->driver));
-	strlcpy(v->card, "Thanko's Raremono", sizeof(v->card));
+	strscpy(v->driver, "radio-raremono", sizeof(v->driver));
+	strscpy(v->card, "Thanko's Raremono", sizeof(v->card));
 	usb_make_path(radio->usbdev, v->bus_info, sizeof(v->bus_info));
 	v->device_caps = V4L2_CAP_TUNER | V4L2_CAP_RADIO;
 	v->capabilities = v->device_caps | V4L2_CAP_DEVICE_CAPS;
@@ -212,7 +212,7 @@ static int vidioc_g_tuner(struct file *file, void *priv,
 	if (v->index > 0)
 		return -EINVAL;
 
-	strlcpy(v->name, "AM/FM/SW", sizeof(v->name));
+	strscpy(v->name, "AM/FM/SW", sizeof(v->name));
 	v->capability = V4L2_TUNER_CAP_LOW | V4L2_TUNER_CAP_STEREO |
 		V4L2_TUNER_CAP_FREQ_BANDS;
 	v->rangelow = AM_FREQ_RANGE_LOW * 16;
@@ -338,7 +338,7 @@ static int usb_raremono_probe(struct usb_interface *intf,
 
 	mutex_init(&radio->lock);
 
-	strlcpy(radio->vdev.name, radio->v4l2_dev.name,
+	strscpy(radio->vdev.name, radio->v4l2_dev.name,
 		sizeof(radio->vdev.name));
 	radio->vdev.v4l2_dev = &radio->v4l2_dev;
 	radio->vdev.fops = &usb_raremono_fops;
diff --git a/drivers/media/radio/radio-sf16fmi.c b/drivers/media/radio/radio-sf16fmi.c
index 4f9b97edd9eb..a8fedc963614 100644
--- a/drivers/media/radio/radio-sf16fmi.c
+++ b/drivers/media/radio/radio-sf16fmi.c
@@ -129,9 +129,9 @@ static void fmi_set_freq(struct fmi *fmi)
 static int vidioc_querycap(struct file *file, void  *priv,
 					struct v4l2_capability *v)
 {
-	strlcpy(v->driver, "radio-sf16fmi", sizeof(v->driver));
-	strlcpy(v->card, "SF16-FMI/FMP/FMD radio", sizeof(v->card));
-	strlcpy(v->bus_info, "ISA:radio-sf16fmi", sizeof(v->bus_info));
+	strscpy(v->driver, "radio-sf16fmi", sizeof(v->driver));
+	strscpy(v->card, "SF16-FMI/FMP/FMD radio", sizeof(v->card));
+	strscpy(v->bus_info, "ISA:radio-sf16fmi", sizeof(v->bus_info));
 	v->device_caps = V4L2_CAP_TUNER | V4L2_CAP_RADIO;
 	v->capabilities = v->device_caps | V4L2_CAP_DEVICE_CAPS;
 	return 0;
@@ -145,7 +145,7 @@ static int vidioc_g_tuner(struct file *file, void *priv,
 	if (v->index > 0)
 		return -EINVAL;
 
-	strlcpy(v->name, "FM", sizeof(v->name));
+	strscpy(v->name, "FM", sizeof(v->name));
 	v->type = V4L2_TUNER_RADIO;
 	v->rangelow = RSF16_MINFREQ;
 	v->rangehigh = RSF16_MAXFREQ;
@@ -315,7 +315,7 @@ static int __init fmi_init(void)
 		return -ENODEV;
 	}
 
-	strlcpy(v4l2_dev->name, "sf16fmi", sizeof(v4l2_dev->name));
+	strscpy(v4l2_dev->name, "sf16fmi", sizeof(v4l2_dev->name));
 	fmi->io = io;
 
 	res = v4l2_device_register(NULL, v4l2_dev);
@@ -339,7 +339,7 @@ static int __init fmi_init(void)
 		return res;
 	}
 
-	strlcpy(fmi->vdev.name, v4l2_dev->name, sizeof(fmi->vdev.name));
+	strscpy(fmi->vdev.name, v4l2_dev->name, sizeof(fmi->vdev.name));
 	fmi->vdev.v4l2_dev = v4l2_dev;
 	fmi->vdev.fops = &fmi_fops;
 	fmi->vdev.ioctl_ops = &fmi_ioctl_ops;
diff --git a/drivers/media/radio/radio-sf16fmr2.c b/drivers/media/radio/radio-sf16fmr2.c
index 7b07d42a9909..ca8a1c263eac 100644
--- a/drivers/media/radio/radio-sf16fmr2.c
+++ b/drivers/media/radio/radio-sf16fmr2.c
@@ -213,8 +213,8 @@ static int fmr2_probe(struct fmr2 *fmr2, struct device *pdev, int io)
 		if (io == fmr2_cards[i]->io)
 			return -EBUSY;
 
-	strlcpy(fmr2->v4l2_dev.name, "radio-sf16fmr2",
-			sizeof(fmr2->v4l2_dev.name)),
+	strscpy(fmr2->v4l2_dev.name, "radio-sf16fmr2",
+		sizeof(fmr2->v4l2_dev.name)),
 	fmr2->io = io;
 
 	if (!request_region(fmr2->io, 2, fmr2->v4l2_dev.name)) {
@@ -234,7 +234,7 @@ static int fmr2_probe(struct fmr2 *fmr2, struct device *pdev, int io)
 	fmr2->tea.radio_nr = radio_nr[num_fmr2_cards];
 	fmr2->tea.ops = &fmr2_tea_ops;
 	fmr2->tea.ext_init = fmr2_tea_ext_init;
-	strlcpy(fmr2->tea.card, card_name, sizeof(fmr2->tea.card));
+	strscpy(fmr2->tea.card, card_name, sizeof(fmr2->tea.card));
 	snprintf(fmr2->tea.bus_info, sizeof(fmr2->tea.bus_info), "%s:%s",
 			fmr2->is_fmd2 ? "PnP" : "ISA", dev_name(pdev));
 
diff --git a/drivers/media/radio/radio-shark.c b/drivers/media/radio/radio-shark.c
index 22f3466af2b1..8230da828d0e 100644
--- a/drivers/media/radio/radio-shark.c
+++ b/drivers/media/radio/radio-shark.c
@@ -345,7 +345,7 @@ static int usb_shark_probe(struct usb_interface *intf,
 	shark->tea.ops = &shark_tea_ops;
 	shark->tea.cannot_mute = true;
 	shark->tea.has_am = true;
-	strlcpy(shark->tea.card, "Griffin radioSHARK",
+	strscpy(shark->tea.card, "Griffin radioSHARK",
 		sizeof(shark->tea.card));
 	usb_make_path(shark->usbdev, shark->tea.bus_info,
 		sizeof(shark->tea.bus_info));
diff --git a/drivers/media/radio/radio-shark2.c b/drivers/media/radio/radio-shark2.c
index 4d1a4b3d669c..d150f12382c6 100644
--- a/drivers/media/radio/radio-shark2.c
+++ b/drivers/media/radio/radio-shark2.c
@@ -310,7 +310,7 @@ static int usb_shark_probe(struct usb_interface *intf,
 	shark->tea.ops = &shark_tea_ops;
 	shark->tea.has_am = true;
 	shark->tea.write_before_read = true;
-	strlcpy(shark->tea.card, "Griffin radioSHARK2",
+	strscpy(shark->tea.card, "Griffin radioSHARK2",
 		sizeof(shark->tea.card));
 	usb_make_path(shark->usbdev, shark->tea.bus_info,
 		sizeof(shark->tea.bus_info));
diff --git a/drivers/media/radio/radio-si476x.c b/drivers/media/radio/radio-si476x.c
index b52e678c6901..269971145f88 100644
--- a/drivers/media/radio/radio-si476x.c
+++ b/drivers/media/radio/radio-si476x.c
@@ -340,9 +340,9 @@ static int si476x_radio_querycap(struct file *file, void *priv,
 {
 	struct si476x_radio *radio = video_drvdata(file);
 
-	strlcpy(capability->driver, radio->v4l2dev.name,
+	strscpy(capability->driver, radio->v4l2dev.name,
 		sizeof(capability->driver));
-	strlcpy(capability->card,   DRIVER_CARD, sizeof(capability->card));
+	strscpy(capability->card,   DRIVER_CARD, sizeof(capability->card));
 	snprintf(capability->bus_info, sizeof(capability->bus_info),
 		 "platform:%s", radio->v4l2dev.name);
 
@@ -428,15 +428,15 @@ static int si476x_radio_g_tuner(struct file *file, void *priv,
 	si476x_core_lock(radio->core);
 
 	if (si476x_core_is_a_secondary_tuner(radio->core)) {
-		strlcpy(tuner->name, "FM (secondary)", sizeof(tuner->name));
+		strscpy(tuner->name, "FM (secondary)", sizeof(tuner->name));
 		tuner->rxsubchans = 0;
 		tuner->rangelow = si476x_bands[SI476X_BAND_FM].rangelow;
 	} else if (si476x_core_has_am(radio->core)) {
 		if (si476x_core_is_a_primary_tuner(radio->core))
-			strlcpy(tuner->name, "AM/FM (primary)",
+			strscpy(tuner->name, "AM/FM (primary)",
 				sizeof(tuner->name));
 		else
-			strlcpy(tuner->name, "AM/FM", sizeof(tuner->name));
+			strscpy(tuner->name, "AM/FM", sizeof(tuner->name));
 
 		tuner->rxsubchans = V4L2_TUNER_SUB_MONO | V4L2_TUNER_SUB_STEREO
 			| V4L2_TUNER_SUB_RDS;
@@ -446,7 +446,7 @@ static int si476x_radio_g_tuner(struct file *file, void *priv,
 
 		tuner->rangelow = si476x_bands[SI476X_BAND_AM].rangelow;
 	} else {
-		strlcpy(tuner->name, "FM", sizeof(tuner->name));
+		strscpy(tuner->name, "FM", sizeof(tuner->name));
 		tuner->rxsubchans = V4L2_TUNER_SUB_RDS;
 		tuner->capability |= V4L2_TUNER_CAP_RDS
 			| V4L2_TUNER_CAP_RDS_BLOCK_IO
diff --git a/drivers/media/radio/radio-tea5764.c b/drivers/media/radio/radio-tea5764.c
index afb763256fd6..6632be648cea 100644
--- a/drivers/media/radio/radio-tea5764.c
+++ b/drivers/media/radio/radio-tea5764.c
@@ -287,8 +287,8 @@ static int vidioc_querycap(struct file *file, void  *priv,
 	struct tea5764_device *radio = video_drvdata(file);
 	struct video_device *dev = &radio->vdev;
 
-	strlcpy(v->driver, dev->dev.driver->name, sizeof(v->driver));
-	strlcpy(v->card, dev->name, sizeof(v->card));
+	strscpy(v->driver, dev->dev.driver->name, sizeof(v->driver));
+	strscpy(v->card, dev->name, sizeof(v->card));
 	snprintf(v->bus_info, sizeof(v->bus_info),
 		 "I2C:%s", dev_name(&dev->dev));
 	v->device_caps = V4L2_CAP_TUNER | V4L2_CAP_RADIO;
@@ -305,7 +305,7 @@ static int vidioc_g_tuner(struct file *file, void *priv,
 	if (v->index > 0)
 		return -EINVAL;
 
-	strlcpy(v->name, "FM", sizeof(v->name));
+	strscpy(v->name, "FM", sizeof(v->name));
 	v->type = V4L2_TUNER_RADIO;
 	tea5764_i2c_read(radio);
 	v->rangelow   = FREQ_MIN * FREQ_MUL;
diff --git a/drivers/media/radio/radio-tea5777.c b/drivers/media/radio/radio-tea5777.c
index 04ed1a5d1177..61f751cf1aa4 100644
--- a/drivers/media/radio/radio-tea5777.c
+++ b/drivers/media/radio/radio-tea5777.c
@@ -266,10 +266,10 @@ static int vidioc_querycap(struct file *file, void  *priv,
 {
 	struct radio_tea5777 *tea = video_drvdata(file);
 
-	strlcpy(v->driver, tea->v4l2_dev->name, sizeof(v->driver));
-	strlcpy(v->card, tea->card, sizeof(v->card));
+	strscpy(v->driver, tea->v4l2_dev->name, sizeof(v->driver));
+	strscpy(v->card, tea->card, sizeof(v->card));
 	strlcat(v->card, " TEA5777", sizeof(v->card));
-	strlcpy(v->bus_info, tea->bus_info, sizeof(v->bus_info));
+	strscpy(v->bus_info, tea->bus_info, sizeof(v->bus_info));
 	v->device_caps = V4L2_CAP_TUNER | V4L2_CAP_RADIO;
 	v->device_caps |= V4L2_CAP_HW_FREQ_SEEK;
 	v->capabilities = v->device_caps | V4L2_CAP_DEVICE_CAPS;
@@ -304,9 +304,9 @@ static int vidioc_g_tuner(struct file *file, void *priv,
 
 	memset(v, 0, sizeof(*v));
 	if (tea->has_am)
-		strlcpy(v->name, "AM/FM", sizeof(v->name));
+		strscpy(v->name, "AM/FM", sizeof(v->name));
 	else
-		strlcpy(v->name, "FM", sizeof(v->name));
+		strscpy(v->name, "FM", sizeof(v->name));
 	v->type = V4L2_TUNER_RADIO;
 	v->capability = V4L2_TUNER_CAP_LOW | V4L2_TUNER_CAP_STEREO |
 			V4L2_TUNER_CAP_FREQ_BANDS |
@@ -560,7 +560,7 @@ int radio_tea5777_init(struct radio_tea5777 *tea, struct module *owner)
 	tea->vd = tea575x_radio;
 	video_set_drvdata(&tea->vd, tea);
 	mutex_init(&tea->mutex);
-	strlcpy(tea->vd.name, tea->v4l2_dev->name, sizeof(tea->vd.name));
+	strscpy(tea->vd.name, tea->v4l2_dev->name, sizeof(tea->vd.name));
 	tea->vd.lock = &tea->mutex;
 	tea->vd.v4l2_dev = tea->v4l2_dev;
 	tea->fops = tea575x_fops;
diff --git a/drivers/media/radio/radio-timb.c b/drivers/media/radio/radio-timb.c
index fc4d9a73ab17..0eda863124e9 100644
--- a/drivers/media/radio/radio-timb.c
+++ b/drivers/media/radio/radio-timb.c
@@ -39,8 +39,8 @@ struct timbradio {
 static int timbradio_vidioc_querycap(struct file *file, void  *priv,
 	struct v4l2_capability *v)
 {
-	strlcpy(v->driver, DRIVER_NAME, sizeof(v->driver));
-	strlcpy(v->card, "Timberdale Radio", sizeof(v->card));
+	strscpy(v->driver, DRIVER_NAME, sizeof(v->driver));
+	strscpy(v->card, "Timberdale Radio", sizeof(v->card));
 	snprintf(v->bus_info, sizeof(v->bus_info), "platform:"DRIVER_NAME);
 	v->device_caps = V4L2_CAP_TUNER | V4L2_CAP_RADIO;
 	v->capabilities = v->device_caps | V4L2_CAP_DEVICE_CAPS;
@@ -115,7 +115,7 @@ static int timbradio_probe(struct platform_device *pdev)
 	tr->pdata = *pdata;
 	mutex_init(&tr->lock);
 
-	strlcpy(tr->video_dev.name, "Timberdale Radio",
+	strscpy(tr->video_dev.name, "Timberdale Radio",
 		sizeof(tr->video_dev.name));
 	tr->video_dev.fops = &timbradio_fops;
 	tr->video_dev.ioctl_ops = &timbradio_ioctl_ops;
@@ -123,7 +123,7 @@ static int timbradio_probe(struct platform_device *pdev)
 	tr->video_dev.minor = -1;
 	tr->video_dev.lock = &tr->lock;
 
-	strlcpy(tr->v4l2_dev.name, DRIVER_NAME, sizeof(tr->v4l2_dev.name));
+	strscpy(tr->v4l2_dev.name, DRIVER_NAME, sizeof(tr->v4l2_dev.name));
 	err = v4l2_device_register(NULL, &tr->v4l2_dev);
 	if (err)
 		goto err;
diff --git a/drivers/media/radio/radio-wl1273.c b/drivers/media/radio/radio-wl1273.c
index 11aa94f189cb..b95704f3cb8b 100644
--- a/drivers/media/radio/radio-wl1273.c
+++ b/drivers/media/radio/radio-wl1273.c
@@ -1286,11 +1286,11 @@ static int wl1273_fm_vidioc_querycap(struct file *file, void *priv,
 
 	dev_dbg(radio->dev, "%s\n", __func__);
 
-	strlcpy(capability->driver, WL1273_FM_DRIVER_NAME,
+	strscpy(capability->driver, WL1273_FM_DRIVER_NAME,
 		sizeof(capability->driver));
-	strlcpy(capability->card, "Texas Instruments Wl1273 FM Radio",
+	strscpy(capability->card, "Texas Instruments Wl1273 FM Radio",
 		sizeof(capability->card));
-	strlcpy(capability->bus_info, radio->bus_type,
+	strscpy(capability->bus_info, radio->bus_type,
 		sizeof(capability->bus_info));
 
 	capability->device_caps = V4L2_CAP_HW_FREQ_SEEK |
@@ -1488,7 +1488,7 @@ static int wl1273_fm_vidioc_g_audio(struct file *file, void *priv,
 	if (audio->index > 1)
 		return -EINVAL;
 
-	strlcpy(audio->name, "Radio", sizeof(audio->name));
+	strscpy(audio->name, "Radio", sizeof(audio->name));
 	audio->capability = V4L2_AUDCAP_STEREO;
 
 	return 0;
@@ -1523,7 +1523,7 @@ static int wl1273_fm_vidioc_g_tuner(struct file *file, void *priv,
 	if (tuner->index > 0)
 		return -EINVAL;
 
-	strlcpy(tuner->name, WL1273_FM_DRIVER_NAME, sizeof(tuner->name));
+	strscpy(tuner->name, WL1273_FM_DRIVER_NAME, sizeof(tuner->name));
 	tuner->type = V4L2_TUNER_RADIO;
 
 	tuner->rangelow	= WL1273_FREQ(WL1273_BAND_JAPAN_LOW);
@@ -1781,7 +1781,7 @@ static int wl1273_fm_vidioc_g_modulator(struct file *file, void *priv,
 
 	dev_dbg(radio->dev, "%s\n", __func__);
 
-	strlcpy(modulator->name, WL1273_FM_DRIVER_NAME,
+	strscpy(modulator->name, WL1273_FM_DRIVER_NAME,
 		sizeof(modulator->name));
 
 	modulator->rangelow = WL1273_FREQ(WL1273_BAND_JAPAN_LOW);
diff --git a/drivers/media/radio/si470x/radio-si470x-i2c.c b/drivers/media/radio/si470x/radio-si470x-i2c.c
index e3b3ecd14a4d..9751ea1d80be 100644
--- a/drivers/media/radio/si470x/radio-si470x-i2c.c
+++ b/drivers/media/radio/si470x/radio-si470x-i2c.c
@@ -229,8 +229,8 @@ static int si470x_fops_release(struct file *file)
 static int si470x_vidioc_querycap(struct file *file, void *priv,
 				  struct v4l2_capability *capability)
 {
-	strlcpy(capability->driver, DRIVER_NAME, sizeof(capability->driver));
-	strlcpy(capability->card, DRIVER_CARD, sizeof(capability->card));
+	strscpy(capability->driver, DRIVER_NAME, sizeof(capability->driver));
+	strscpy(capability->card, DRIVER_CARD, sizeof(capability->card));
 	capability->device_caps = V4L2_CAP_HW_FREQ_SEEK | V4L2_CAP_READWRITE |
 		V4L2_CAP_TUNER | V4L2_CAP_RADIO | V4L2_CAP_RDS_CAPTURE;
 	capability->capabilities = capability->device_caps | V4L2_CAP_DEVICE_CAPS;
diff --git a/drivers/media/radio/si470x/radio-si470x-usb.c b/drivers/media/radio/si470x/radio-si470x-usb.c
index 313a95f195a2..91d6ef5579f7 100644
--- a/drivers/media/radio/si470x/radio-si470x-usb.c
+++ b/drivers/media/radio/si470x/radio-si470x-usb.c
@@ -519,8 +519,8 @@ static int si470x_vidioc_querycap(struct file *file, void *priv,
 {
 	struct si470x_device *radio = video_drvdata(file);
 
-	strlcpy(capability->driver, DRIVER_NAME, sizeof(capability->driver));
-	strlcpy(capability->card, DRIVER_CARD, sizeof(capability->card));
+	strscpy(capability->driver, DRIVER_NAME, sizeof(capability->driver));
+	strscpy(capability->card, DRIVER_CARD, sizeof(capability->card));
 	usb_make_path(radio->usbdev, capability->bus_info,
 			sizeof(capability->bus_info));
 	capability->device_caps = V4L2_CAP_HW_FREQ_SEEK | V4L2_CAP_READWRITE |
diff --git a/drivers/media/radio/si4713/radio-platform-si4713.c b/drivers/media/radio/si4713/radio-platform-si4713.c
index 27339ec495f6..733fcf3933e4 100644
--- a/drivers/media/radio/si4713/radio-platform-si4713.c
+++ b/drivers/media/radio/si4713/radio-platform-si4713.c
@@ -67,10 +67,10 @@ static const struct v4l2_file_operations radio_si4713_fops = {
 static int radio_si4713_querycap(struct file *file, void *priv,
 					struct v4l2_capability *capability)
 {
-	strlcpy(capability->driver, "radio-si4713", sizeof(capability->driver));
-	strlcpy(capability->card, "Silicon Labs Si4713 Modulator",
+	strscpy(capability->driver, "radio-si4713", sizeof(capability->driver));
+	strscpy(capability->card, "Silicon Labs Si4713 Modulator",
 		sizeof(capability->card));
-	strlcpy(capability->bus_info, "platform:radio-si4713",
+	strscpy(capability->bus_info, "platform:radio-si4713",
 		sizeof(capability->bus_info));
 	capability->device_caps = V4L2_CAP_MODULATOR | V4L2_CAP_RDS_OUTPUT;
 	capability->capabilities = capability->device_caps | V4L2_CAP_DEVICE_CAPS;
diff --git a/drivers/media/radio/si4713/radio-usb-si4713.c b/drivers/media/radio/si4713/radio-usb-si4713.c
index 1ebbf0217142..23065ecce979 100644
--- a/drivers/media/radio/si4713/radio-usb-si4713.c
+++ b/drivers/media/radio/si4713/radio-usb-si4713.c
@@ -67,8 +67,8 @@ static int vidioc_querycap(struct file *file, void *priv,
 {
 	struct si4713_usb_device *radio = video_drvdata(file);
 
-	strlcpy(v->driver, "radio-usb-si4713", sizeof(v->driver));
-	strlcpy(v->card, "Si4713 FM Transmitter", sizeof(v->card));
+	strscpy(v->driver, "radio-usb-si4713", sizeof(v->driver));
+	strscpy(v->card, "Si4713 FM Transmitter", sizeof(v->card));
 	usb_make_path(radio->usbdev, v->bus_info, sizeof(v->bus_info));
 	v->device_caps = V4L2_CAP_MODULATOR | V4L2_CAP_RDS_OUTPUT;
 	v->capabilities = v->device_caps | V4L2_CAP_DEVICE_CAPS;
@@ -467,7 +467,7 @@ static int usb_si4713_probe(struct usb_interface *intf,
 
 	radio->vdev.ctrl_handler = sd->ctrl_handler;
 	radio->v4l2_dev.release = usb_si4713_video_device_release;
-	strlcpy(radio->vdev.name, radio->v4l2_dev.name,
+	strscpy(radio->vdev.name, radio->v4l2_dev.name,
 		sizeof(radio->vdev.name));
 	radio->vdev.v4l2_dev = &radio->v4l2_dev;
 	radio->vdev.fops = &usb_si4713_fops;
diff --git a/drivers/media/radio/tea575x.c b/drivers/media/radio/tea575x.c
index 7412fe1b10c6..f89f83e04741 100644
--- a/drivers/media/radio/tea575x.c
+++ b/drivers/media/radio/tea575x.c
@@ -233,10 +233,10 @@ static int vidioc_querycap(struct file *file, void  *priv,
 {
 	struct snd_tea575x *tea = video_drvdata(file);
 
-	strlcpy(v->driver, tea->v4l2_dev->name, sizeof(v->driver));
-	strlcpy(v->card, tea->card, sizeof(v->card));
+	strscpy(v->driver, tea->v4l2_dev->name, sizeof(v->driver));
+	strscpy(v->card, tea->card, sizeof(v->card));
 	strlcat(v->card, tea->tea5759 ? " TEA5759" : " TEA5757", sizeof(v->card));
-	strlcpy(v->bus_info, tea->bus_info, sizeof(v->bus_info));
+	strscpy(v->bus_info, tea->bus_info, sizeof(v->bus_info));
 	v->device_caps = V4L2_CAP_TUNER | V4L2_CAP_RADIO;
 	if (!tea->cannot_read_data)
 		v->device_caps |= V4L2_CAP_HW_FREQ_SEEK;
@@ -296,7 +296,7 @@ int snd_tea575x_g_tuner(struct snd_tea575x *tea, struct v4l2_tuner *v)
 	snd_tea575x_enum_freq_bands(tea, &band_fm);
 
 	memset(v, 0, sizeof(*v));
-	strlcpy(v->name, tea->has_am ? "FM/AM" : "FM", sizeof(v->name));
+	strscpy(v->name, tea->has_am ? "FM/AM" : "FM", sizeof(v->name));
 	v->type = V4L2_TUNER_RADIO;
 	v->capability = band_fm.capability;
 	v->rangelow = tea->has_am ? bands[BAND_AM].rangelow : band_fm.rangelow;
@@ -537,7 +537,7 @@ int snd_tea575x_init(struct snd_tea575x *tea, struct module *owner)
 	tea->vd = tea575x_radio;
 	video_set_drvdata(&tea->vd, tea);
 	mutex_init(&tea->mutex);
-	strlcpy(tea->vd.name, tea->v4l2_dev->name, sizeof(tea->vd.name));
+	strscpy(tea->vd.name, tea->v4l2_dev->name, sizeof(tea->vd.name));
 	tea->vd.lock = &tea->mutex;
 	tea->vd.v4l2_dev = tea->v4l2_dev;
 	tea->fops = tea575x_fops;
diff --git a/drivers/media/radio/tef6862.c b/drivers/media/radio/tef6862.c
index ed210f4c476a..a76ff2978dfb 100644
--- a/drivers/media/radio/tef6862.c
+++ b/drivers/media/radio/tef6862.c
@@ -79,7 +79,7 @@ static int tef6862_g_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *v)
 		return -EINVAL;
 
 	/* only support FM for now */
-	strlcpy(v->name, "FM", sizeof(v->name));
+	strscpy(v->name, "FM", sizeof(v->name));
 	v->type = V4L2_TUNER_RADIO;
 	v->rangelow = TEF6862_LO_FREQ;
 	v->rangehigh = TEF6862_HI_FREQ;
diff --git a/drivers/media/radio/wl128x/fmdrv_v4l2.c b/drivers/media/radio/wl128x/fmdrv_v4l2.c
index dccdf6558e6a..c5f433b24713 100644
--- a/drivers/media/radio/wl128x/fmdrv_v4l2.c
+++ b/drivers/media/radio/wl128x/fmdrv_v4l2.c
@@ -190,9 +190,9 @@ static int fm_v4l2_fops_release(struct file *file)
 static int fm_v4l2_vidioc_querycap(struct file *file, void *priv,
 		struct v4l2_capability *capability)
 {
-	strlcpy(capability->driver, FM_DRV_NAME, sizeof(capability->driver));
-	strlcpy(capability->card, FM_DRV_CARD_SHORT_NAME,
-			sizeof(capability->card));
+	strscpy(capability->driver, FM_DRV_NAME, sizeof(capability->driver));
+	strscpy(capability->card, FM_DRV_CARD_SHORT_NAME,
+		sizeof(capability->card));
 	sprintf(capability->bus_info, "UART");
 	capability->device_caps = V4L2_CAP_HW_FREQ_SEEK | V4L2_CAP_TUNER |
 		V4L2_CAP_RADIO | V4L2_CAP_MODULATOR |
@@ -531,7 +531,8 @@ int fm_v4l2_init_video_device(struct fmdev *fmdev, int radio_nr)
 	struct v4l2_ctrl *ctrl;
 	int ret;
 
-	strlcpy(fmdev->v4l2_dev.name, FM_DRV_NAME, sizeof(fmdev->v4l2_dev.name));
+	strscpy(fmdev->v4l2_dev.name, FM_DRV_NAME,
+		sizeof(fmdev->v4l2_dev.name));
 	ret = v4l2_device_register(NULL, &fmdev->v4l2_dev);
 	if (ret < 0)
 		return ret;
diff --git a/drivers/media/rc/ati_remote.c b/drivers/media/rc/ati_remote.c
index 8e82610ffaad..265e91a2a70d 100644
--- a/drivers/media/rc/ati_remote.c
+++ b/drivers/media/rc/ati_remote.c
@@ -862,7 +862,7 @@ static int ati_remote_probe(struct usb_interface *interface,
 	ati_remote->interface = interface;
 
 	usb_make_path(udev, ati_remote->rc_phys, sizeof(ati_remote->rc_phys));
-	strlcpy(ati_remote->mouse_phys, ati_remote->rc_phys,
+	strscpy(ati_remote->mouse_phys, ati_remote->rc_phys,
 		sizeof(ati_remote->mouse_phys));
 
 	strlcat(ati_remote->rc_phys, "/input0", sizeof(ati_remote->rc_phys));
diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index 4c0c8008872a..7f0fc3e12190 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -1603,7 +1603,7 @@ static int mceusb_dev_probe(struct usb_interface *intf,
 	if (dev->descriptor.iManufacturer
 	    && usb_string(dev, dev->descriptor.iManufacturer,
 			  buf, sizeof(buf)) > 0)
-		strlcpy(name, buf, sizeof(name));
+		strscpy(name, buf, sizeof(name));
 	if (dev->descriptor.iProduct
 	    && usb_string(dev, dev->descriptor.iProduct,
 			  buf, sizeof(buf)) > 0)
diff --git a/drivers/media/rc/streamzap.c b/drivers/media/rc/streamzap.c
index c9a70fda88a8..c3e183aabfbe 100644
--- a/drivers/media/rc/streamzap.c
+++ b/drivers/media/rc/streamzap.c
@@ -396,7 +396,7 @@ static int streamzap_probe(struct usb_interface *intf,
 	if (usbdev->descriptor.iManufacturer
 	    && usb_string(usbdev, usbdev->descriptor.iManufacturer,
 			  buf, sizeof(buf)) > 0)
-		strlcpy(name, buf, sizeof(name));
+		strscpy(name, buf, sizeof(name));
 
 	if (usbdev->descriptor.iProduct
 	    && usb_string(usbdev, usbdev->descriptor.iProduct,
diff --git a/drivers/media/tuners/e4000.c b/drivers/media/tuners/e4000.c
index fbec1a13dc6a..91956fb55b75 100644
--- a/drivers/media/tuners/e4000.c
+++ b/drivers/media/tuners/e4000.c
@@ -312,7 +312,7 @@ static int e4000_g_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *v)
 
 	dev_dbg(&client->dev, "index=%d\n", v->index);
 
-	strlcpy(v->name, "Elonics E4000", sizeof(v->name));
+	strscpy(v->name, "Elonics E4000", sizeof(v->name));
 	v->type = V4L2_TUNER_RF;
 	v->capability = V4L2_TUNER_CAP_1HZ | V4L2_TUNER_CAP_FREQ_BANDS;
 	v->rangelow  = bands[0].rangelow;
diff --git a/drivers/media/tuners/fc2580.c b/drivers/media/tuners/fc2580.c
index db26892aac84..dd88cf7148d0 100644
--- a/drivers/media/tuners/fc2580.c
+++ b/drivers/media/tuners/fc2580.c
@@ -405,7 +405,7 @@ static int fc2580_g_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *v)
 
 	dev_dbg(&client->dev, "index=%d\n", v->index);
 
-	strlcpy(v->name, "FCI FC2580", sizeof(v->name));
+	strscpy(v->name, "FCI FC2580", sizeof(v->name));
 	v->type = V4L2_TUNER_RF;
 	v->capability = V4L2_TUNER_CAP_1HZ | V4L2_TUNER_CAP_FREQ_BANDS;
 	v->rangelow  = bands[0].rangelow;
diff --git a/drivers/media/tuners/msi001.c b/drivers/media/tuners/msi001.c
index 5de6ed728708..331c198c00bb 100644
--- a/drivers/media/tuners/msi001.c
+++ b/drivers/media/tuners/msi001.c
@@ -305,7 +305,7 @@ static int msi001_g_tuner(struct v4l2_subdev *sd, struct v4l2_tuner *v)
 
 	dev_dbg(&spi->dev, "index=%d\n", v->index);
 
-	strlcpy(v->name, "Mirics MSi001", sizeof(v->name));
+	strscpy(v->name, "Mirics MSi001", sizeof(v->name));
 	v->type = V4L2_TUNER_RF;
 	v->capability = V4L2_TUNER_CAP_1HZ | V4L2_TUNER_CAP_FREQ_BANDS;
 	v->rangelow =    49000000;
diff --git a/drivers/media/tuners/mt20xx.c b/drivers/media/tuners/mt20xx.c
index 129bf8e1aff8..8b4ce84b6914 100644
--- a/drivers/media/tuners/mt20xx.c
+++ b/drivers/media/tuners/mt20xx.c
@@ -636,7 +636,7 @@ struct dvb_frontend *microtune_attach(struct dvb_frontend *fe,
 		return NULL;
 	}
 
-	strlcpy(fe->ops.tuner_ops.info.name, name,
+	strscpy(fe->ops.tuner_ops.info.name, name,
 		sizeof(fe->ops.tuner_ops.info.name));
 	tuner_info("microtune %s found, OK\n",name);
 	return fe;
diff --git a/drivers/media/tuners/tuner-simple.c b/drivers/media/tuners/tuner-simple.c
index 29c1473f2e9f..d2169bb3111a 100644
--- a/drivers/media/tuners/tuner-simple.c
+++ b/drivers/media/tuners/tuner-simple.c
@@ -1130,7 +1130,7 @@ struct dvb_frontend *simple_tuner_attach(struct dvb_frontend *fe,
 				   priv->nr, dtv_input[priv->nr]);
 	}
 
-	strlcpy(fe->ops.tuner_ops.info.name, priv->tun->name,
+	strscpy(fe->ops.tuner_ops.info.name, priv->tun->name,
 		sizeof(fe->ops.tuner_ops.info.name));
 
 	return fe;
diff --git a/drivers/media/usb/airspy/airspy.c b/drivers/media/usb/airspy/airspy.c
index e70c9e2f3798..41fa0f93143d 100644
--- a/drivers/media/usb/airspy/airspy.c
+++ b/drivers/media/usb/airspy/airspy.c
@@ -619,8 +619,8 @@ static int airspy_querycap(struct file *file, void *fh,
 {
 	struct airspy *s = video_drvdata(file);
 
-	strlcpy(cap->driver, KBUILD_MODNAME, sizeof(cap->driver));
-	strlcpy(cap->card, s->vdev.name, sizeof(cap->card));
+	strscpy(cap->driver, KBUILD_MODNAME, sizeof(cap->driver));
+	strscpy(cap->card, s->vdev.name, sizeof(cap->card));
 	usb_make_path(s->udev, cap->bus_info, sizeof(cap->bus_info));
 	cap->device_caps = V4L2_CAP_SDR_CAPTURE | V4L2_CAP_STREAMING |
 			V4L2_CAP_READWRITE | V4L2_CAP_TUNER;
@@ -635,7 +635,7 @@ static int airspy_enum_fmt_sdr_cap(struct file *file, void *priv,
 	if (f->index >= NUM_FORMATS)
 		return -EINVAL;
 
-	strlcpy(f->description, formats[f->index].name, sizeof(f->description));
+	strscpy(f->description, formats[f->index].name, sizeof(f->description));
 	f->pixelformat = formats[f->index].pixelformat;
 
 	return 0;
@@ -720,14 +720,14 @@ static int airspy_g_tuner(struct file *file, void *priv, struct v4l2_tuner *v)
 	int ret;
 
 	if (v->index == 0) {
-		strlcpy(v->name, "AirSpy ADC", sizeof(v->name));
+		strscpy(v->name, "AirSpy ADC", sizeof(v->name));
 		v->type = V4L2_TUNER_ADC;
 		v->capability = V4L2_TUNER_CAP_1HZ | V4L2_TUNER_CAP_FREQ_BANDS;
 		v->rangelow  = bands[0].rangelow;
 		v->rangehigh = bands[0].rangehigh;
 		ret = 0;
 	} else if (v->index == 1) {
-		strlcpy(v->name, "AirSpy RF", sizeof(v->name));
+		strscpy(v->name, "AirSpy RF", sizeof(v->name));
 		v->type = V4L2_TUNER_RF;
 		v->capability = V4L2_TUNER_CAP_1HZ | V4L2_TUNER_CAP_FREQ_BANDS;
 		v->rangelow  = bands_rf[0].rangelow;
diff --git a/drivers/media/usb/au0828/au0828-i2c.c b/drivers/media/usb/au0828/au0828-i2c.c
index 1b8ec5d9e7ab..92df5b5463af 100644
--- a/drivers/media/usb/au0828/au0828-i2c.c
+++ b/drivers/media/usb/au0828/au0828-i2c.c
@@ -378,7 +378,7 @@ int au0828_i2c_register(struct au0828_dev *dev)
 
 	dev->i2c_adap.dev.parent = &dev->usbdev->dev;
 
-	strlcpy(dev->i2c_adap.name, KBUILD_MODNAME,
+	strscpy(dev->i2c_adap.name, KBUILD_MODNAME,
 		sizeof(dev->i2c_adap.name));
 
 	dev->i2c_adap.algo = &dev->i2c_algo;
diff --git a/drivers/media/usb/au0828/au0828-video.c b/drivers/media/usb/au0828/au0828-video.c
index 62b45062b1e6..aa25c19437ad 100644
--- a/drivers/media/usb/au0828/au0828-video.c
+++ b/drivers/media/usb/au0828/au0828-video.c
@@ -1191,8 +1191,8 @@ static int vidioc_querycap(struct file *file, void  *priv,
 	dprintk(1, "%s called std_set %d dev_state %ld\n", __func__,
 		dev->std_set_in_tuner_core, dev->dev_state);
 
-	strlcpy(cap->driver, "au0828", sizeof(cap->driver));
-	strlcpy(cap->card, dev->board.name, sizeof(cap->card));
+	strscpy(cap->driver, "au0828", sizeof(cap->driver));
+	strscpy(cap->card, dev->board.name, sizeof(cap->card));
 	usb_make_path(dev->usbdev, cap->bus_info, sizeof(cap->bus_info));
 
 	/* set the device capabilities */
diff --git a/drivers/media/usb/cx231xx/cx231xx-417.c b/drivers/media/usb/cx231xx/cx231xx-417.c
index 2f3b0564d676..f700ec35b7f3 100644
--- a/drivers/media/usb/cx231xx/cx231xx-417.c
+++ b/drivers/media/usb/cx231xx/cx231xx-417.c
@@ -1583,7 +1583,7 @@ static int vidioc_enum_fmt_vid_cap(struct file *file, void  *priv,
 	if (f->index != 0)
 		return -EINVAL;
 
-	strlcpy(f->description, "MPEG", sizeof(f->description));
+	strscpy(f->description, "MPEG", sizeof(f->description));
 	f->pixelformat = V4L2_PIX_FMT_MPEG;
 
 	return 0;
diff --git a/drivers/media/usb/cx231xx/cx231xx-input.c b/drivers/media/usb/cx231xx/cx231xx-input.c
index 3e9b73a6b7c9..9f88c640ec2b 100644
--- a/drivers/media/usb/cx231xx/cx231xx-input.c
+++ b/drivers/media/usb/cx231xx/cx231xx-input.c
@@ -67,7 +67,7 @@ int cx231xx_ir_init(struct cx231xx *dev)
 
 	dev->init_data.name = cx231xx_boards[dev->model].name;
 
-	strlcpy(info.type, "ir_video", I2C_NAME_SIZE);
+	strscpy(info.type, "ir_video", I2C_NAME_SIZE);
 	info.platform_data = &dev->init_data;
 
 	/*
diff --git a/drivers/media/usb/cx231xx/cx231xx-video.c b/drivers/media/usb/cx231xx/cx231xx-video.c
index f7fcd733a2ca..7759bc66f18c 100644
--- a/drivers/media/usb/cx231xx/cx231xx-video.c
+++ b/drivers/media/usb/cx231xx/cx231xx-video.c
@@ -1354,22 +1354,22 @@ int cx231xx_g_chip_info(struct file *file, void *fh,
 	case 0:	/* Cx231xx - internal registers */
 		return 0;
 	case 1:	/* AFE - read byte */
-		strlcpy(chip->name, "AFE (byte)", sizeof(chip->name));
+		strscpy(chip->name, "AFE (byte)", sizeof(chip->name));
 		return 0;
 	case 2:	/* Video Block - read byte */
-		strlcpy(chip->name, "Video (byte)", sizeof(chip->name));
+		strscpy(chip->name, "Video (byte)", sizeof(chip->name));
 		return 0;
 	case 3:	/* I2S block - read byte */
-		strlcpy(chip->name, "I2S (byte)", sizeof(chip->name));
+		strscpy(chip->name, "I2S (byte)", sizeof(chip->name));
 		return 0;
 	case 4: /* AFE - read dword */
-		strlcpy(chip->name, "AFE (dword)", sizeof(chip->name));
+		strscpy(chip->name, "AFE (dword)", sizeof(chip->name));
 		return 0;
 	case 5: /* Video Block - read dword */
-		strlcpy(chip->name, "Video (dword)", sizeof(chip->name));
+		strscpy(chip->name, "Video (dword)", sizeof(chip->name));
 		return 0;
 	case 6: /* I2S Block - read dword */
-		strlcpy(chip->name, "I2S (dword)", sizeof(chip->name));
+		strscpy(chip->name, "I2S (dword)", sizeof(chip->name));
 		return 0;
 	}
 	return -EINVAL;
@@ -1553,8 +1553,8 @@ int cx231xx_querycap(struct file *file, void *priv,
 	struct cx231xx_fh *fh = priv;
 	struct cx231xx *dev = fh->dev;
 
-	strlcpy(cap->driver, "cx231xx", sizeof(cap->driver));
-	strlcpy(cap->card, cx231xx_boards[dev->model].name, sizeof(cap->card));
+	strscpy(cap->driver, "cx231xx", sizeof(cap->driver));
+	strscpy(cap->card, cx231xx_boards[dev->model].name, sizeof(cap->card));
 	usb_make_path(dev->udev, cap->bus_info, sizeof(cap->bus_info));
 
 	if (vdev->vfl_type == VFL_TYPE_RADIO)
@@ -1583,7 +1583,7 @@ static int vidioc_enum_fmt_vid_cap(struct file *file, void *priv,
 	if (unlikely(f->index >= ARRAY_SIZE(format)))
 		return -EINVAL;
 
-	strlcpy(f->description, format[f->index].name, sizeof(f->description));
+	strscpy(f->description, format[f->index].name, sizeof(f->description));
 	f->pixelformat = format[f->index].fourcc;
 
 	return 0;
diff --git a/drivers/media/usb/dvb-usb-v2/af9035.c b/drivers/media/usb/dvb-usb-v2/af9035.c
index 1f6c1eefe389..80d3bd3a0f24 100644
--- a/drivers/media/usb/dvb-usb-v2/af9035.c
+++ b/drivers/media/usb/dvb-usb-v2/af9035.c
@@ -204,7 +204,7 @@ static int af9035_add_i2c_dev(struct dvb_usb_device *d, const char *type,
 		.platform_data = platform_data,
 	};
 
-	strlcpy(board_info.type, type, I2C_NAME_SIZE);
+	strscpy(board_info.type, type, I2C_NAME_SIZE);
 
 	/* find first free client */
 	for (num = 0; num < AF9035_I2C_CLIENT_MAX; num++) {
diff --git a/drivers/media/usb/dvb-usb-v2/anysee.c b/drivers/media/usb/dvb-usb-v2/anysee.c
index 20ee7eea2a91..0df7ad69e6c7 100644
--- a/drivers/media/usb/dvb-usb-v2/anysee.c
+++ b/drivers/media/usb/dvb-usb-v2/anysee.c
@@ -638,7 +638,7 @@ static int anysee_add_i2c_dev(struct dvb_usb_device *d, const char *type,
 		.platform_data = platform_data,
 	};
 
-	strlcpy(board_info.type, type, I2C_NAME_SIZE);
+	strscpy(board_info.type, type, I2C_NAME_SIZE);
 
 	/* find first free client */
 	for (num = 0; num < ANYSEE_I2C_CLIENT_MAX; num++) {
diff --git a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
index 955318ab7f5e..3b8f7931b730 100644
--- a/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
+++ b/drivers/media/usb/dvb-usb-v2/dvb_usb_core.c
@@ -74,7 +74,7 @@ static int dvb_usbv2_i2c_init(struct dvb_usb_device *d)
 	if (!d->props->i2c_algo)
 		return 0;
 
-	strlcpy(d->i2c_adap.name, d->name, sizeof(d->i2c_adap.name));
+	strscpy(d->i2c_adap.name, d->name, sizeof(d->i2c_adap.name));
 	d->i2c_adap.algo = d->props->i2c_algo;
 	d->i2c_adap.dev.parent = &d->udev->dev;
 	i2c_set_adapdata(&d->i2c_adap, d);
diff --git a/drivers/media/usb/dvb-usb-v2/gl861.c b/drivers/media/usb/dvb-usb-v2/gl861.c
index 3338b21d8b25..0559417c8af4 100644
--- a/drivers/media/usb/dvb-usb-v2/gl861.c
+++ b/drivers/media/usb/dvb-usb-v2/gl861.c
@@ -507,7 +507,7 @@ static int friio_frontend_attach(struct dvb_usb_adapter *adap)
 	priv->i2c_client_demod = cl;
 	priv->tuner_adap.algo = &friio_tuner_i2c_algo;
 	priv->tuner_adap.dev.parent = &d->udev->dev;
-	strlcpy(priv->tuner_adap.name, d->name, sizeof(priv->tuner_adap.name));
+	strscpy(priv->tuner_adap.name, d->name, sizeof(priv->tuner_adap.name));
 	strlcat(priv->tuner_adap.name, "-tuner", sizeof(priv->tuner_adap.name));
 	priv->demod_sub_i2c = &priv->tuner_adap;
 	i2c_set_adapdata(&priv->tuner_adap, d);
diff --git a/drivers/media/usb/dvb-usb-v2/lmedm04.c b/drivers/media/usb/dvb-usb-v2/lmedm04.c
index 0750a975bcb8..f109c04f05ae 100644
--- a/drivers/media/usb/dvb-usb-v2/lmedm04.c
+++ b/drivers/media/usb/dvb-usb-v2/lmedm04.c
@@ -1004,7 +1004,7 @@ static int lme_name(struct dvb_usb_adapter *adap)
 		" SHARP:BS2F7HZ0194", " RS2000"};
 	char *name = adap->fe[0]->ops.info.name;
 
-	strlcpy(name, desc, 128);
+	strscpy(name, desc, 128);
 	strlcat(name, fe_name[st->tuner_config], 128);
 
 	return 0;
diff --git a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
index a970224a94bd..33f76a347baa 100644
--- a/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
+++ b/drivers/media/usb/dvb-usb-v2/rtl28xxu.c
@@ -687,7 +687,7 @@ static int rtl2831u_frontend_attach(struct dvb_usb_adapter *adap)
 
 	/* attach demodulator */
 	memset(&board_info, 0, sizeof(board_info));
-	strlcpy(board_info.type, "rtl2830", I2C_NAME_SIZE);
+	strscpy(board_info.type, "rtl2830", I2C_NAME_SIZE);
 	board_info.addr = 0x10;
 	board_info.platform_data = pdata;
 	request_module("%s", board_info.type);
@@ -908,7 +908,7 @@ static int rtl2832u_frontend_attach(struct dvb_usb_adapter *adap)
 
 	/* attach demodulator */
 	memset(&board_info, 0, sizeof(board_info));
-	strlcpy(board_info.type, "rtl2832", I2C_NAME_SIZE);
+	strscpy(board_info.type, "rtl2832", I2C_NAME_SIZE);
 	board_info.addr = 0x10;
 	board_info.platform_data = pdata;
 	request_module("%s", board_info.type);
@@ -947,7 +947,7 @@ static int rtl2832u_frontend_attach(struct dvb_usb_adapter *adap)
 
 			mn88472_config.fe = &adap->fe[1];
 			mn88472_config.i2c_wr_max = 22,
-			strlcpy(info.type, "mn88472", I2C_NAME_SIZE);
+			strscpy(info.type, "mn88472", I2C_NAME_SIZE);
 			mn88472_config.xtal = 20500000;
 			mn88472_config.ts_mode = SERIAL_TS_MODE;
 			mn88472_config.ts_clock = VARIABLE_TS_CLOCK;
@@ -972,7 +972,7 @@ static int rtl2832u_frontend_attach(struct dvb_usb_adapter *adap)
 
 			mn88473_config.fe = &adap->fe[1];
 			mn88473_config.i2c_wr_max = 22,
-			strlcpy(info.type, "mn88473", I2C_NAME_SIZE);
+			strscpy(info.type, "mn88473", I2C_NAME_SIZE);
 			info.addr = 0x18;
 			info.platform_data = &mn88473_config;
 			request_module(info.type);
@@ -998,7 +998,7 @@ static int rtl2832u_frontend_attach(struct dvb_usb_adapter *adap)
 			si2168_config.ts_mode = SI2168_TS_SERIAL;
 			si2168_config.ts_clock_inv = false;
 			si2168_config.ts_clock_gapped = true;
-			strlcpy(info.type, "si2168", I2C_NAME_SIZE);
+			strscpy(info.type, "si2168", I2C_NAME_SIZE);
 			info.addr = 0x64;
 			info.platform_data = &si2168_config;
 			request_module(info.type);
@@ -1189,7 +1189,7 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
 				.clock = 28800000,
 			};
 
-			strlcpy(info.type, "e4000", I2C_NAME_SIZE);
+			strscpy(info.type, "e4000", I2C_NAME_SIZE);
 			info.addr = 0x64;
 			info.platform_data = &e4000_config;
 
@@ -1213,7 +1213,7 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
 			};
 			struct i2c_board_info board_info = {};
 
-			strlcpy(board_info.type, "fc2580", I2C_NAME_SIZE);
+			strscpy(board_info.type, "fc2580", I2C_NAME_SIZE);
 			board_info.addr = 0x56;
 			board_info.platform_data = &fc2580_pdata;
 			request_module("fc2580");
@@ -1244,7 +1244,7 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
 		if (ret)
 			goto err;
 
-		strlcpy(board_info.type, "tua9001", I2C_NAME_SIZE);
+		strscpy(board_info.type, "tua9001", I2C_NAME_SIZE);
 		board_info.addr = 0x60;
 		board_info.platform_data = &tua9001_pdata;
 		request_module("tua9001");
@@ -1289,7 +1289,7 @@ static int rtl2832u_tuner_attach(struct dvb_usb_adapter *adap)
 				.inversion = false,
 			};
 
-			strlcpy(info.type, "si2157", I2C_NAME_SIZE);
+			strscpy(info.type, "si2157", I2C_NAME_SIZE);
 			info.addr = 0x60;
 			info.platform_data = &si2157_config;
 			request_module(info.type);
diff --git a/drivers/media/usb/dvb-usb-v2/zd1301.c b/drivers/media/usb/dvb-usb-v2/zd1301.c
index d1eb4b7bc051..7a41d744ff58 100644
--- a/drivers/media/usb/dvb-usb-v2/zd1301.c
+++ b/drivers/media/usb/dvb-usb-v2/zd1301.c
@@ -177,7 +177,7 @@ static int zd1301_frontend_attach(struct dvb_usb_adapter *adap)
 	dev->mt2060_pdata.i2c_write_max = 9;
 	dev->mt2060_pdata.dvb_frontend = frontend;
 	memset(&board_info, 0, sizeof(board_info));
-	strlcpy(board_info.type, "mt2060", I2C_NAME_SIZE);
+	strscpy(board_info.type, "mt2060", I2C_NAME_SIZE);
 	board_info.addr = 0x60;
 	board_info.platform_data = &dev->mt2060_pdata;
 	request_module("%s", "mt2060");
diff --git a/drivers/media/usb/dvb-usb/cxusb.c b/drivers/media/usb/dvb-usb/cxusb.c
index 5b51ed7d6243..a51a45c60233 100644
--- a/drivers/media/usb/dvb-usb/cxusb.c
+++ b/drivers/media/usb/dvb-usb/cxusb.c
@@ -1196,7 +1196,7 @@ static int cxusb_mygica_t230_frontend_attach(struct dvb_usb_adapter *adap)
 	si2168_config.ts_mode = SI2168_TS_PARALLEL;
 	si2168_config.ts_clock_inv = 1;
 	memset(&info, 0, sizeof(struct i2c_board_info));
-	strlcpy(info.type, "si2168", I2C_NAME_SIZE);
+	strscpy(info.type, "si2168", I2C_NAME_SIZE);
 	info.addr = 0x64;
 	info.platform_data = &si2168_config;
 	request_module(info.type);
@@ -1216,7 +1216,7 @@ static int cxusb_mygica_t230_frontend_attach(struct dvb_usb_adapter *adap)
 	si2157_config.fe = adap->fe_adap[0].fe;
 	si2157_config.if_port = 1;
 	memset(&info, 0, sizeof(struct i2c_board_info));
-	strlcpy(info.type, "si2157", I2C_NAME_SIZE);
+	strscpy(info.type, "si2157", I2C_NAME_SIZE);
 	info.addr = 0x60;
 	info.platform_data = &si2157_config;
 	request_module(info.type);
diff --git a/drivers/media/usb/dvb-usb/dib0700_devices.c b/drivers/media/usb/dvb-usb/dib0700_devices.c
index 091389fdf89e..7551dce96f64 100644
--- a/drivers/media/usb/dvb-usb/dib0700_devices.c
+++ b/drivers/media/usb/dvb-usb/dib0700_devices.c
@@ -3763,7 +3763,7 @@ static int xbox_one_attach(struct dvb_usb_adapter *adap)
 	mn88472_config.ts_mode = PARALLEL_TS_MODE;
 	mn88472_config.ts_clock = FIXED_TS_CLOCK;
 	memset(&info, 0, sizeof(struct i2c_board_info));
-	strlcpy(info.type, "mn88472", I2C_NAME_SIZE);
+	strscpy(info.type, "mn88472", I2C_NAME_SIZE);
 	info.addr = 0x18;
 	info.platform_data = &mn88472_config;
 	request_module(info.type);
@@ -3790,7 +3790,7 @@ static int xbox_one_attach(struct dvb_usb_adapter *adap)
 	tda18250_config.fe = adap->fe_adap[0].fe;
 
 	memset(&info, 0, sizeof(struct i2c_board_info));
-	strlcpy(info.type, "tda18250", I2C_NAME_SIZE);
+	strscpy(info.type, "tda18250", I2C_NAME_SIZE);
 	info.addr = 0x60;
 	info.platform_data = &tda18250_config;
 
diff --git a/drivers/media/usb/dvb-usb/dvb-usb-i2c.c b/drivers/media/usb/dvb-usb/dvb-usb-i2c.c
index ca0b734e009b..2e07106f4680 100644
--- a/drivers/media/usb/dvb-usb/dvb-usb-i2c.c
+++ b/drivers/media/usb/dvb-usb/dvb-usb-i2c.c
@@ -20,7 +20,7 @@ int dvb_usb_i2c_init(struct dvb_usb_device *d)
 		return -EINVAL;
 	}
 
-	strlcpy(d->i2c_adap.name, d->desc->name, sizeof(d->i2c_adap.name));
+	strscpy(d->i2c_adap.name, d->desc->name, sizeof(d->i2c_adap.name));
 	d->i2c_adap.algo      = d->props.i2c_algo;
 	d->i2c_adap.algo_data = NULL;
 	d->i2c_adap.dev.parent = &d->udev->dev;
diff --git a/drivers/media/usb/dvb-usb/dw2102.c b/drivers/media/usb/dvb-usb/dw2102.c
index 9ce8b4d79d1f..eefe2867815c 100644
--- a/drivers/media/usb/dvb-usb/dw2102.c
+++ b/drivers/media/usb/dvb-usb/dw2102.c
@@ -1589,7 +1589,7 @@ static int tt_s2_4600_frontend_attach(struct dvb_usb_adapter *adap)
 	m88ds3103_pdata.lnb_hv_pol = 1;
 	m88ds3103_pdata.lnb_en_pol = 0;
 	memset(&board_info, 0, sizeof(board_info));
-	strlcpy(board_info.type, "m88ds3103", I2C_NAME_SIZE);
+	strscpy(board_info.type, "m88ds3103", I2C_NAME_SIZE);
 	board_info.addr = 0x68;
 	board_info.platform_data = &m88ds3103_pdata;
 	request_module("m88ds3103");
@@ -1608,7 +1608,7 @@ static int tt_s2_4600_frontend_attach(struct dvb_usb_adapter *adap)
 	/* attach tuner */
 	ts2020_config.fe = adap->fe_adap[0].fe;
 	memset(&board_info, 0, sizeof(board_info));
-	strlcpy(board_info.type, "ts2022", I2C_NAME_SIZE);
+	strscpy(board_info.type, "ts2022", I2C_NAME_SIZE);
 	board_info.addr = 0x60;
 	board_info.platform_data = &ts2020_config;
 	request_module("ts2020");
diff --git a/drivers/media/usb/dvb-usb/technisat-usb2.c b/drivers/media/usb/dvb-usb/technisat-usb2.c
index 18d0f8f5283f..c659e18b358b 100644
--- a/drivers/media/usb/dvb-usb/technisat-usb2.c
+++ b/drivers/media/usb/dvb-usb/technisat-usb2.c
@@ -566,8 +566,9 @@ static int technisat_usb2_frontend_attach(struct dvb_usb_adapter *a)
 			a->fe_adap[0].fe->ops.set_voltage = technisat_usb2_set_voltage;
 
 			/* if everything was successful assign a nice name to the frontend */
-			strlcpy(a->fe_adap[0].fe->ops.info.name, a->dev->desc->name,
-					sizeof(a->fe_adap[0].fe->ops.info.name));
+			strscpy(a->fe_adap[0].fe->ops.info.name,
+				a->dev->desc->name,
+				sizeof(a->fe_adap[0].fe->ops.info.name));
 		} else {
 			dvb_frontend_detach(a->fe_adap[0].fe);
 			a->fe_adap[0].fe = NULL;
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 68571bf36d28..5e8a26fa719a 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -1833,9 +1833,9 @@ static int vidioc_g_chip_info(struct file *file, void *priv,
 	if (chip->match.addr > 1)
 		return -EINVAL;
 	if (chip->match.addr == 1)
-		strlcpy(chip->name, "ac97", sizeof(chip->name));
+		strscpy(chip->name, "ac97", sizeof(chip->name));
 	else
-		strlcpy(chip->name,
+		strscpy(chip->name,
 			dev->v4l2->v4l2_dev.name, sizeof(chip->name));
 	return 0;
 }
@@ -1920,8 +1920,8 @@ static int vidioc_querycap(struct file *file, void  *priv,
 	struct em28xx_v4l2    *v4l2 = dev->v4l2;
 	struct usb_device *udev = interface_to_usbdev(dev->intf);
 
-	strlcpy(cap->driver, "em28xx", sizeof(cap->driver));
-	strlcpy(cap->card, em28xx_boards[dev->model].name, sizeof(cap->card));
+	strscpy(cap->driver, "em28xx", sizeof(cap->driver));
+	strscpy(cap->card, em28xx_boards[dev->model].name, sizeof(cap->card));
 	usb_make_path(udev, cap->bus_info, sizeof(cap->bus_info));
 
 	if (vdev->vfl_type == VFL_TYPE_GRABBER)
@@ -1954,7 +1954,7 @@ static int vidioc_enum_fmt_vid_cap(struct file *file, void  *priv,
 	if (unlikely(f->index >= ARRAY_SIZE(format)))
 		return -EINVAL;
 
-	strlcpy(f->description, format[f->index].name, sizeof(f->description));
+	strscpy(f->description, format[f->index].name, sizeof(f->description));
 	f->pixelformat = format[f->index].fourcc;
 
 	return 0;
diff --git a/drivers/media/usb/go7007/go7007-driver.c b/drivers/media/usb/go7007/go7007-driver.c
index 62aeebcdd7f7..59cf50355b4e 100644
--- a/drivers/media/usb/go7007/go7007-driver.c
+++ b/drivers/media/usb/go7007/go7007-driver.c
@@ -208,7 +208,7 @@ static int init_i2c_module(struct i2c_adapter *adapter, const struct go_i2c *con
 	struct i2c_board_info info;
 
 	memset(&info, 0, sizeof(info));
-	strlcpy(info.type, i2c->type, sizeof(info.type));
+	strscpy(info.type, i2c->type, sizeof(info.type));
 	info.addr = i2c->addr;
 	info.flags = i2c->flags;
 
diff --git a/drivers/media/usb/go7007/go7007-v4l2.c b/drivers/media/usb/go7007/go7007-v4l2.c
index c55c82f70e54..7a2781fa83e7 100644
--- a/drivers/media/usb/go7007/go7007-v4l2.c
+++ b/drivers/media/usb/go7007/go7007-v4l2.c
@@ -284,9 +284,9 @@ static int vidioc_querycap(struct file *file, void  *priv,
 {
 	struct go7007 *go = video_drvdata(file);
 
-	strlcpy(cap->driver, "go7007", sizeof(cap->driver));
-	strlcpy(cap->card, go->name, sizeof(cap->card));
-	strlcpy(cap->bus_info, go->bus_info, sizeof(cap->bus_info));
+	strscpy(cap->driver, "go7007", sizeof(cap->driver));
+	strscpy(cap->card, go->name, sizeof(cap->card));
+	strscpy(cap->bus_info, go->bus_info, sizeof(cap->bus_info));
 
 	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_READWRITE |
 				V4L2_CAP_STREAMING;
@@ -634,8 +634,8 @@ static int vidioc_enum_input(struct file *file, void *priv,
 	if (inp->index >= go->board_info->num_inputs)
 		return -EINVAL;
 
-	strlcpy(inp->name, go->board_info->inputs[inp->index].name,
-			sizeof(inp->name));
+	strscpy(inp->name, go->board_info->inputs[inp->index].name,
+		sizeof(inp->name));
 
 	/* If this board has a tuner, it will be the first input */
 	if ((go->board_info->flags & GO7007_BOARD_HAS_TUNER) &&
@@ -673,7 +673,7 @@ static int vidioc_enumaudio(struct file *file, void *fh, struct v4l2_audio *a)
 
 	if (a->index >= go->board_info->num_aud_inputs)
 		return -EINVAL;
-	strlcpy(a->name, go->board_info->aud_inputs[a->index].name,
+	strscpy(a->name, go->board_info->aud_inputs[a->index].name,
 		sizeof(a->name));
 	a->capability = V4L2_AUDCAP_STEREO;
 	return 0;
@@ -684,7 +684,7 @@ static int vidioc_g_audio(struct file *file, void *fh, struct v4l2_audio *a)
 	struct go7007 *go = video_drvdata(file);
 
 	a->index = go->aud_input;
-	strlcpy(a->name, go->board_info->aud_inputs[go->aud_input].name,
+	strscpy(a->name, go->board_info->aud_inputs[go->aud_input].name,
 		sizeof(a->name));
 	a->capability = V4L2_AUDCAP_STEREO;
 	return 0;
@@ -742,7 +742,7 @@ static int vidioc_g_tuner(struct file *file, void *priv,
 	if (t->index != 0)
 		return -EINVAL;
 
-	strlcpy(t->name, "Tuner", sizeof(t->name));
+	strscpy(t->name, "Tuner", sizeof(t->name));
 	return call_all(&go->v4l2_dev, tuner, g_tuner, t);
 }
 
diff --git a/drivers/media/usb/go7007/snd-go7007.c b/drivers/media/usb/go7007/snd-go7007.c
index 137fc253b122..fc84b37d5587 100644
--- a/drivers/media/usb/go7007/snd-go7007.c
+++ b/drivers/media/usb/go7007/snd-go7007.c
@@ -260,10 +260,10 @@ int go7007_snd_init(struct go7007 *go)
 		kfree(gosnd);
 		return ret;
 	}
-	strlcpy(gosnd->card->driver, "go7007", sizeof(gosnd->card->driver));
-	strlcpy(gosnd->card->shortname, go->name, sizeof(gosnd->card->driver));
-	strlcpy(gosnd->card->longname, gosnd->card->shortname,
-			sizeof(gosnd->card->longname));
+	strscpy(gosnd->card->driver, "go7007", sizeof(gosnd->card->driver));
+	strscpy(gosnd->card->shortname, go->name, sizeof(gosnd->card->driver));
+	strscpy(gosnd->card->longname, gosnd->card->shortname,
+		sizeof(gosnd->card->longname));
 
 	gosnd->pcm->private_data = go;
 	snd_pcm_set_ops(gosnd->pcm, SNDRV_PCM_STREAM_CAPTURE,
diff --git a/drivers/media/usb/gspca/gspca.c b/drivers/media/usb/gspca/gspca.c
index 57aa521e16b1..fce9d6f4b7c9 100644
--- a/drivers/media/usb/gspca/gspca.c
+++ b/drivers/media/usb/gspca/gspca.c
@@ -1193,11 +1193,11 @@ static int vidioc_querycap(struct file *file, void  *priv,
 {
 	struct gspca_dev *gspca_dev = video_drvdata(file);
 
-	strlcpy((char *) cap->driver, gspca_dev->sd_desc->name,
-			sizeof cap->driver);
+	strscpy((char *)cap->driver, gspca_dev->sd_desc->name,
+		sizeof(cap->driver));
 	if (gspca_dev->dev->product != NULL) {
-		strlcpy((char *) cap->card, gspca_dev->dev->product,
-			sizeof cap->card);
+		strscpy((char *)cap->card, gspca_dev->dev->product,
+			sizeof(cap->card));
 	} else {
 		snprintf((char *) cap->card, sizeof cap->card,
 			"USB Camera (%04x:%04x)",
@@ -1222,7 +1222,7 @@ static int vidioc_enum_input(struct file *file, void *priv,
 		return -EINVAL;
 	input->type = V4L2_INPUT_TYPE_CAMERA;
 	input->status = gspca_dev->cam.input_flags;
-	strlcpy(input->name, gspca_dev->sd_desc->name,
+	strscpy(input->name, gspca_dev->sd_desc->name,
 		sizeof input->name);
 	return 0;
 }
diff --git a/drivers/media/usb/gspca/sn9c20x.c b/drivers/media/usb/gspca/sn9c20x.c
index cfa2a04d9f3f..5984bb12bcff 100644
--- a/drivers/media/usb/gspca/sn9c20x.c
+++ b/drivers/media/usb/gspca/sn9c20x.c
@@ -1601,7 +1601,7 @@ static int sd_chip_info(struct gspca_dev *gspca_dev,
 	if (chip->match.addr > 1)
 		return -EINVAL;
 	if (chip->match.addr == 1)
-		strlcpy(chip->name, "sensor", sizeof(chip->name));
+		strscpy(chip->name, "sensor", sizeof(chip->name));
 	return 0;
 }
 #endif
diff --git a/drivers/media/usb/hackrf/hackrf.c b/drivers/media/usb/hackrf/hackrf.c
index 34085a0b15a1..d43785206622 100644
--- a/drivers/media/usb/hackrf/hackrf.c
+++ b/drivers/media/usb/hackrf/hackrf.c
@@ -918,8 +918,8 @@ static int hackrf_querycap(struct file *file, void *fh,
 	cap->capabilities = V4L2_CAP_SDR_CAPTURE | V4L2_CAP_TUNER |
 			    V4L2_CAP_SDR_OUTPUT | V4L2_CAP_MODULATOR |
 			    V4L2_CAP_DEVICE_CAPS | cap->device_caps;
-	strlcpy(cap->driver, KBUILD_MODNAME, sizeof(cap->driver));
-	strlcpy(cap->card, dev->rx_vdev.name, sizeof(cap->card));
+	strscpy(cap->driver, KBUILD_MODNAME, sizeof(cap->driver));
+	strscpy(cap->card, dev->rx_vdev.name, sizeof(cap->card));
 	usb_make_path(dev->udev, cap->bus_info, sizeof(cap->bus_info));
 
 	return 0;
@@ -1041,14 +1041,14 @@ static int hackrf_g_tuner(struct file *file, void *priv, struct v4l2_tuner *v)
 	dev_dbg(dev->dev, "index=%d\n", v->index);
 
 	if (v->index == 0) {
-		strlcpy(v->name, "HackRF ADC", sizeof(v->name));
+		strscpy(v->name, "HackRF ADC", sizeof(v->name));
 		v->type = V4L2_TUNER_SDR;
 		v->capability = V4L2_TUNER_CAP_1HZ | V4L2_TUNER_CAP_FREQ_BANDS;
 		v->rangelow  = bands_adc_dac[0].rangelow;
 		v->rangehigh = bands_adc_dac[0].rangehigh;
 		ret = 0;
 	} else if (v->index == 1) {
-		strlcpy(v->name, "HackRF RF", sizeof(v->name));
+		strscpy(v->name, "HackRF RF", sizeof(v->name));
 		v->type = V4L2_TUNER_RF;
 		v->capability = V4L2_TUNER_CAP_1HZ | V4L2_TUNER_CAP_FREQ_BANDS;
 		v->rangelow  = bands_rx_tx[0].rangelow;
@@ -1080,14 +1080,14 @@ static int hackrf_g_modulator(struct file *file, void *fh,
 	dev_dbg(dev->dev, "index=%d\n", a->index);
 
 	if (a->index == 0) {
-		strlcpy(a->name, "HackRF DAC", sizeof(a->name));
+		strscpy(a->name, "HackRF DAC", sizeof(a->name));
 		a->type = V4L2_TUNER_SDR;
 		a->capability = V4L2_TUNER_CAP_1HZ | V4L2_TUNER_CAP_FREQ_BANDS;
 		a->rangelow  = bands_adc_dac[0].rangelow;
 		a->rangehigh = bands_adc_dac[0].rangehigh;
 		ret = 0;
 	} else if (a->index == 1) {
-		strlcpy(a->name, "HackRF RF", sizeof(a->name));
+		strscpy(a->name, "HackRF RF", sizeof(a->name));
 		a->type = V4L2_TUNER_RF;
 		a->capability = V4L2_TUNER_CAP_1HZ | V4L2_TUNER_CAP_FREQ_BANDS;
 		a->rangelow  = bands_rx_tx[0].rangelow;
diff --git a/drivers/media/usb/hdpvr/hdpvr-video.c b/drivers/media/usb/hdpvr/hdpvr-video.c
index 1b89c77bad66..9ab071f8993d 100644
--- a/drivers/media/usb/hdpvr/hdpvr-video.c
+++ b/drivers/media/usb/hdpvr/hdpvr-video.c
@@ -873,7 +873,7 @@ static int vidioc_g_audio(struct file *file, void *private_data,
 
 	audio->index = dev->options.audio_input;
 	audio->capability = V4L2_AUDCAP_STEREO;
-	strlcpy(audio->name, audio_iname[audio->index], sizeof(audio->name));
+	strscpy(audio->name, audio_iname[audio->index], sizeof(audio->name));
 	audio->name[sizeof(audio->name) - 1] = '\0';
 	return 0;
 }
diff --git a/drivers/media/usb/msi2500/msi2500.c b/drivers/media/usb/msi2500/msi2500.c
index 65ef755adfdc..0fc4076c6d16 100644
--- a/drivers/media/usb/msi2500/msi2500.c
+++ b/drivers/media/usb/msi2500/msi2500.c
@@ -604,8 +604,8 @@ static int msi2500_querycap(struct file *file, void *fh,
 
 	dev_dbg(dev->dev, "\n");
 
-	strlcpy(cap->driver, KBUILD_MODNAME, sizeof(cap->driver));
-	strlcpy(cap->card, dev->vdev.name, sizeof(cap->card));
+	strscpy(cap->driver, KBUILD_MODNAME, sizeof(cap->driver));
+	strscpy(cap->card, dev->vdev.name, sizeof(cap->card));
 	usb_make_path(dev->udev, cap->bus_info, sizeof(cap->bus_info));
 	cap->device_caps = V4L2_CAP_SDR_CAPTURE | V4L2_CAP_STREAMING |
 			V4L2_CAP_READWRITE | V4L2_CAP_TUNER;
@@ -916,7 +916,7 @@ static int msi2500_enum_fmt_sdr_cap(struct file *file, void *priv,
 	if (f->index >= dev->num_formats)
 		return -EINVAL;
 
-	strlcpy(f->description, formats[f->index].name, sizeof(f->description));
+	strscpy(f->description, formats[f->index].name, sizeof(f->description));
 	f->pixelformat = formats[f->index].pixelformat;
 
 	return 0;
@@ -1017,7 +1017,7 @@ static int msi2500_g_tuner(struct file *file, void *priv, struct v4l2_tuner *v)
 	dev_dbg(dev->dev, "index=%d\n", v->index);
 
 	if (v->index == 0) {
-		strlcpy(v->name, "Mirics MSi2500", sizeof(v->name));
+		strscpy(v->name, "Mirics MSi2500", sizeof(v->name));
 		v->type = V4L2_TUNER_ADC;
 		v->capability = V4L2_TUNER_CAP_1HZ | V4L2_TUNER_CAP_FREQ_BANDS;
 		v->rangelow =   1200000;
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c b/drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c
index f3003ca05f4b..ec7d32759e39 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-i2c-core.c
@@ -573,7 +573,7 @@ static void pvr2_i2c_register_ir(struct pvr2_hdw *hdw)
 		/* IR Receiver */
 		info.addr          = 0x18;
 		info.platform_data = init_data;
-		strlcpy(info.type, "ir_video", I2C_NAME_SIZE);
+		strscpy(info.type, "ir_video", I2C_NAME_SIZE);
 		pvr2_trace(PVR2_TRACE_INFO, "Binding %s to i2c address 0x%02x.",
 			   info.type, info.addr);
 		i2c_new_device(&hdw->i2c_adap, &info);
@@ -588,7 +588,7 @@ static void pvr2_i2c_register_ir(struct pvr2_hdw *hdw)
 		/* IR Transceiver */
 		info.addr = 0x71;
 		info.platform_data = init_data;
-		strlcpy(info.type, "ir_z8f0811_haup", I2C_NAME_SIZE);
+		strscpy(info.type, "ir_z8f0811_haup", I2C_NAME_SIZE);
 		pvr2_trace(PVR2_TRACE_INFO, "Binding %s to i2c address 0x%02x.",
 			   info.type, info.addr);
 		i2c_new_device(&hdw->i2c_adap, &info);
@@ -631,7 +631,7 @@ void pvr2_i2c_core_init(struct pvr2_hdw *hdw)
 	// Configure the adapter and set up everything else related to it.
 	hdw->i2c_adap = pvr2_i2c_adap_template;
 	hdw->i2c_algo = pvr2_i2c_algo_template;
-	strlcpy(hdw->i2c_adap.name,hdw->name,sizeof(hdw->i2c_adap.name));
+	strscpy(hdw->i2c_adap.name, hdw->name, sizeof(hdw->i2c_adap.name));
 	hdw->i2c_adap.dev.parent = &hdw->usb_dev->dev;
 	hdw->i2c_adap.algo = &hdw->i2c_algo;
 	hdw->i2c_adap.algo_data = hdw;
diff --git a/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c b/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
index e53a80b589a1..cea232a3302d 100644
--- a/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
+++ b/drivers/media/usb/pvrusb2/pvrusb2-v4l2.c
@@ -121,10 +121,10 @@ static int pvr2_querycap(struct file *file, void *priv, struct v4l2_capability *
 	struct pvr2_v4l2_fh *fh = file->private_data;
 	struct pvr2_hdw *hdw = fh->channel.mc_head->hdw;
 
-	strlcpy(cap->driver, "pvrusb2", sizeof(cap->driver));
-	strlcpy(cap->bus_info, pvr2_hdw_get_bus_info(hdw),
-			sizeof(cap->bus_info));
-	strlcpy(cap->card, pvr2_hdw_get_desc(hdw), sizeof(cap->card));
+	strscpy(cap->driver, "pvrusb2", sizeof(cap->driver));
+	strscpy(cap->bus_info, pvr2_hdw_get_bus_info(hdw),
+		sizeof(cap->bus_info));
+	strscpy(cap->card, pvr2_hdw_get_desc(hdw), sizeof(cap->card));
 	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_TUNER |
 			    V4L2_CAP_AUDIO | V4L2_CAP_RADIO |
 			    V4L2_CAP_READWRITE | V4L2_CAP_DEVICE_CAPS;
@@ -545,7 +545,7 @@ static int pvr2_queryctrl(struct file *file, void *priv,
 			"QUERYCTRL id=0x%x mapping name=%s (%s)",
 			vc->id, pvr2_ctrl_get_name(cptr),
 			pvr2_ctrl_get_desc(cptr));
-	strlcpy(vc->name, pvr2_ctrl_get_desc(cptr), sizeof(vc->name));
+	strscpy(vc->name, pvr2_ctrl_get_desc(cptr), sizeof(vc->name));
 	vc->flags = pvr2_ctrl_get_v4lflags(cptr);
 	pvr2_ctrl_get_def(cptr, &val);
 	vc->default_value = val;
diff --git a/drivers/media/usb/pwc/pwc-v4l.c b/drivers/media/usb/pwc/pwc-v4l.c
index 043b2b97cee6..0673238c2c63 100644
--- a/drivers/media/usb/pwc/pwc-v4l.c
+++ b/drivers/media/usb/pwc/pwc-v4l.c
@@ -493,7 +493,7 @@ static int pwc_querycap(struct file *file, void *fh, struct v4l2_capability *cap
 	struct pwc_device *pdev = video_drvdata(file);
 
 	strcpy(cap->driver, PWC_NAME);
-	strlcpy(cap->card, pdev->vdev.name, sizeof(cap->card));
+	strscpy(cap->card, pdev->vdev.name, sizeof(cap->card));
 	usb_make_path(pdev->udev, cap->bus_info, sizeof(cap->bus_info));
 	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING |
 					V4L2_CAP_READWRITE;
@@ -506,7 +506,7 @@ static int pwc_enum_input(struct file *file, void *fh, struct v4l2_input *i)
 	if (i->index)	/* Only one INPUT is supported */
 		return -EINVAL;
 
-	strlcpy(i->name, "Camera", sizeof(i->name));
+	strscpy(i->name, "Camera", sizeof(i->name));
 	i->type = V4L2_INPUT_TYPE_CAMERA;
 	return 0;
 }
@@ -889,11 +889,13 @@ static int pwc_enum_fmt_vid_cap(struct file *file, void *fh, struct v4l2_fmtdesc
 		/* RAW format */
 		f->pixelformat = pdev->type <= 646 ? V4L2_PIX_FMT_PWC1 : V4L2_PIX_FMT_PWC2;
 		f->flags = V4L2_FMT_FLAG_COMPRESSED;
-		strlcpy(f->description, "Raw Philips Webcam", sizeof(f->description));
+		strscpy(f->description, "Raw Philips Webcam",
+			sizeof(f->description));
 		break;
 	case 1:
 		f->pixelformat = V4L2_PIX_FMT_YUV420;
-		strlcpy(f->description, "4:2:0, planar, Y-Cb-Cr", sizeof(f->description));
+		strscpy(f->description, "4:2:0, planar, Y-Cb-Cr",
+			sizeof(f->description));
 		break;
 	default:
 		return -EINVAL;
diff --git a/drivers/media/usb/s2255/s2255drv.c b/drivers/media/usb/s2255/s2255drv.c
index 82927eb334c4..5b3e54b76e9a 100644
--- a/drivers/media/usb/s2255/s2255drv.c
+++ b/drivers/media/usb/s2255/s2255drv.c
@@ -730,8 +730,8 @@ static int vidioc_querycap(struct file *file, void *priv,
 	struct s2255_vc *vc = video_drvdata(file);
 	struct s2255_dev *dev = vc->dev;
 
-	strlcpy(cap->driver, "s2255", sizeof(cap->driver));
-	strlcpy(cap->card, "s2255", sizeof(cap->card));
+	strscpy(cap->driver, "s2255", sizeof(cap->driver));
+	strscpy(cap->card, "s2255", sizeof(cap->card));
 	usb_make_path(dev->udev, cap->bus_info, sizeof(cap->bus_info));
 	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING |
 		V4L2_CAP_READWRITE;
@@ -749,7 +749,7 @@ static int vidioc_enum_fmt_vid_cap(struct file *file, void *priv,
 	if (!jpeg_enable && ((formats[index].fourcc == V4L2_PIX_FMT_JPEG) ||
 			(formats[index].fourcc == V4L2_PIX_FMT_MJPEG)))
 		return -EINVAL;
-	strlcpy(f->description, formats[index].name, sizeof(f->description));
+	strscpy(f->description, formats[index].name, sizeof(f->description));
 	f->pixelformat = formats[index].fourcc;
 	return 0;
 }
@@ -1195,10 +1195,10 @@ static int vidioc_enum_input(struct file *file, void *priv,
 	switch (dev->pid) {
 	case 0x2255:
 	default:
-		strlcpy(inp->name, "Composite", sizeof(inp->name));
+		strscpy(inp->name, "Composite", sizeof(inp->name));
 		break;
 	case 0x2257:
-		strlcpy(inp->name, (vc->idx < 2) ? "Composite" : "S-Video",
+		strscpy(inp->name, (vc->idx < 2) ? "Composite" : "S-Video",
 			sizeof(inp->name));
 		break;
 	}
diff --git a/drivers/media/usb/stk1160/stk1160-v4l.c b/drivers/media/usb/stk1160/stk1160-v4l.c
index 504e413edcd2..bbf191b71f38 100644
--- a/drivers/media/usb/stk1160/stk1160-v4l.c
+++ b/drivers/media/usb/stk1160/stk1160-v4l.c
@@ -361,7 +361,7 @@ static int vidioc_enum_fmt_vid_cap(struct file *file, void  *priv,
 	if (f->index != 0)
 		return -EINVAL;
 
-	strlcpy(f->description, format[f->index].name, sizeof(f->description));
+	strscpy(f->description, format[f->index].name, sizeof(f->description));
 	f->pixelformat = format[f->index].fourcc;
 	return 0;
 }
diff --git a/drivers/media/usb/tm6000/tm6000-i2c.c b/drivers/media/usb/tm6000/tm6000-i2c.c
index ccd1adf862b1..8c0476dfe54f 100644
--- a/drivers/media/usb/tm6000/tm6000-i2c.c
+++ b/drivers/media/usb/tm6000/tm6000-i2c.c
@@ -292,7 +292,7 @@ int tm6000_i2c_register(struct tm6000_core *dev)
 	dev->i2c_adap.owner = THIS_MODULE;
 	dev->i2c_adap.algo = &tm6000_algo;
 	dev->i2c_adap.dev.parent = &dev->udev->dev;
-	strlcpy(dev->i2c_adap.name, dev->name, sizeof(dev->i2c_adap.name));
+	strscpy(dev->i2c_adap.name, dev->name, sizeof(dev->i2c_adap.name));
 	dev->i2c_adap.algo_data = dev;
 	i2c_set_adapdata(&dev->i2c_adap, &dev->v4l2_dev);
 	rc = i2c_add_adapter(&dev->i2c_adap);
@@ -300,7 +300,7 @@ int tm6000_i2c_register(struct tm6000_core *dev)
 		return rc;
 
 	dev->i2c_client.adapter = &dev->i2c_adap;
-	strlcpy(dev->i2c_client.name, "tm6000 internal", I2C_NAME_SIZE);
+	strscpy(dev->i2c_client.name, "tm6000 internal", I2C_NAME_SIZE);
 	tm6000_i2c_eeprom(dev);
 
 	return 0;
diff --git a/drivers/media/usb/tm6000/tm6000-video.c b/drivers/media/usb/tm6000/tm6000-video.c
index 96055de6e8ce..f3082bd44ce6 100644
--- a/drivers/media/usb/tm6000/tm6000-video.c
+++ b/drivers/media/usb/tm6000/tm6000-video.c
@@ -855,8 +855,9 @@ static int vidioc_querycap(struct file *file, void  *priv,
 	struct tm6000_core *dev = ((struct tm6000_fh *)priv)->dev;
 	struct video_device *vdev = video_devdata(file);
 
-	strlcpy(cap->driver, "tm6000", sizeof(cap->driver));
-	strlcpy(cap->card, "Trident TVMaster TM5600/6000/6010", sizeof(cap->card));
+	strscpy(cap->driver, "tm6000", sizeof(cap->driver));
+	strscpy(cap->card, "Trident TVMaster TM5600/6000/6010",
+		sizeof(cap->card));
 	usb_make_path(dev->udev, cap->bus_info, sizeof(cap->bus_info));
 	if (dev->tuner_type != TUNER_ABSENT)
 		cap->device_caps |= V4L2_CAP_TUNER;
@@ -878,7 +879,7 @@ static int vidioc_enum_fmt_vid_cap(struct file *file, void  *priv,
 	if (f->index >= ARRAY_SIZE(format))
 		return -EINVAL;
 
-	strlcpy(f->description, format[f->index].name, sizeof(f->description));
+	strscpy(f->description, format[f->index].name, sizeof(f->description));
 	f->pixelformat = format[f->index].fourcc;
 	return 0;
 }
diff --git a/drivers/media/usb/usbtv/usbtv-audio.c b/drivers/media/usb/usbtv/usbtv-audio.c
index 4ce38246ed64..6f108996142d 100644
--- a/drivers/media/usb/usbtv/usbtv-audio.c
+++ b/drivers/media/usb/usbtv/usbtv-audio.c
@@ -358,8 +358,8 @@ int usbtv_audio_init(struct usbtv *usbtv)
 	if (rv < 0)
 		return rv;
 
-	strlcpy(card->driver, usbtv->dev->driver->name, sizeof(card->driver));
-	strlcpy(card->shortname, "usbtv", sizeof(card->shortname));
+	strscpy(card->driver, usbtv->dev->driver->name, sizeof(card->driver));
+	strscpy(card->shortname, "usbtv", sizeof(card->shortname));
 	snprintf(card->longname, sizeof(card->longname),
 		"USBTV Audio at bus %d device %d", usbtv->udev->bus->busnum,
 		usbtv->udev->devnum);
@@ -372,7 +372,7 @@ int usbtv_audio_init(struct usbtv *usbtv)
 	if (rv < 0)
 		goto err;
 
-	strlcpy(pcm->name, "USBTV Audio Input", sizeof(pcm->name));
+	strscpy(pcm->name, "USBTV Audio Input", sizeof(pcm->name));
 	pcm->info_flags = 0;
 	pcm->private_data = usbtv;
 
diff --git a/drivers/media/usb/usbtv/usbtv-video.c b/drivers/media/usb/usbtv/usbtv-video.c
index 36a9a4017185..4a1eab711bdc 100644
--- a/drivers/media/usb/usbtv/usbtv-video.c
+++ b/drivers/media/usb/usbtv/usbtv-video.c
@@ -600,8 +600,8 @@ static int usbtv_querycap(struct file *file, void *priv,
 {
 	struct usbtv *dev = video_drvdata(file);
 
-	strlcpy(cap->driver, "usbtv", sizeof(cap->driver));
-	strlcpy(cap->card, "usbtv", sizeof(cap->card));
+	strscpy(cap->driver, "usbtv", sizeof(cap->driver));
+	strscpy(cap->card, "usbtv", sizeof(cap->card));
 	usb_make_path(dev->udev, cap->bus_info, sizeof(cap->bus_info));
 	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE;
 	cap->device_caps |= V4L2_CAP_READWRITE | V4L2_CAP_STREAMING;
@@ -616,10 +616,10 @@ static int usbtv_enum_input(struct file *file, void *priv,
 
 	switch (i->index) {
 	case USBTV_COMPOSITE_INPUT:
-		strlcpy(i->name, "Composite", sizeof(i->name));
+		strscpy(i->name, "Composite", sizeof(i->name));
 		break;
 	case USBTV_SVIDEO_INPUT:
-		strlcpy(i->name, "S-Video", sizeof(i->name));
+		strscpy(i->name, "S-Video", sizeof(i->name));
 		break;
 	default:
 		return -EINVAL;
@@ -636,8 +636,8 @@ static int usbtv_enum_fmt_vid_cap(struct file *file, void  *priv,
 	if (f->index > 0)
 		return -EINVAL;
 
-	strlcpy(f->description, "16 bpp YUY2, 4:2:2, packed",
-					sizeof(f->description));
+	strscpy(f->description, "16 bpp YUY2, 4:2:2, packed",
+		sizeof(f->description));
 	f->pixelformat = V4L2_PIX_FMT_YUYV;
 	return 0;
 }
@@ -934,7 +934,7 @@ int usbtv_video_init(struct usbtv *usbtv)
 	}
 
 	/* Video structure */
-	strlcpy(usbtv->vdev.name, "usbtv", sizeof(usbtv->vdev.name));
+	strscpy(usbtv->vdev.name, "usbtv", sizeof(usbtv->vdev.name));
 	usbtv->vdev.v4l2_dev = &usbtv->v4l2_dev;
 	usbtv->vdev.release = video_device_release_empty;
 	usbtv->vdev.fops = &usbtv_fops;
diff --git a/drivers/media/usb/usbvision/usbvision-video.c b/drivers/media/usb/usbvision/usbvision-video.c
index f29d1bef0293..f4e758e5f3ec 100644
--- a/drivers/media/usb/usbvision/usbvision-video.c
+++ b/drivers/media/usb/usbvision/usbvision-video.c
@@ -467,8 +467,8 @@ static int vidioc_querycap(struct file *file, void  *priv,
 	struct usb_usbvision *usbvision = video_drvdata(file);
 	struct video_device *vdev = video_devdata(file);
 
-	strlcpy(vc->driver, "USBVision", sizeof(vc->driver));
-	strlcpy(vc->card,
+	strscpy(vc->driver, "USBVision", sizeof(vc->driver));
+	strscpy(vc->card,
 		usbvision_device_data[usbvision->dev_model].model_string,
 		sizeof(vc->card));
 	usb_make_path(usbvision->dev, vc->bus_info, sizeof(vc->bus_info));
diff --git a/drivers/media/usb/uvc/uvc_ctrl.c b/drivers/media/usb/uvc/uvc_ctrl.c
index c2ad102bd693..d8281f9f0b3a 100644
--- a/drivers/media/usb/uvc/uvc_ctrl.c
+++ b/drivers/media/usb/uvc/uvc_ctrl.c
@@ -1031,7 +1031,7 @@ static int __uvc_query_v4l2_ctrl(struct uvc_video_chain *chain,
 	memset(v4l2_ctrl, 0, sizeof(*v4l2_ctrl));
 	v4l2_ctrl->id = mapping->id;
 	v4l2_ctrl->type = mapping->v4l2_type;
-	strlcpy(v4l2_ctrl->name, mapping->name, sizeof(v4l2_ctrl->name));
+	strscpy(v4l2_ctrl->name, mapping->name, sizeof(v4l2_ctrl->name));
 	v4l2_ctrl->flags = 0;
 
 	if (!(ctrl->info.flags & UVC_CTRL_FLAG_GET_CUR))
@@ -1191,7 +1191,7 @@ int uvc_query_v4l2_menu(struct uvc_video_chain *chain,
 		}
 	}
 
-	strlcpy(query_menu->name, menu_info->name, sizeof(query_menu->name));
+	strscpy(query_menu->name, menu_info->name, sizeof(query_menu->name));
 
 done:
 	mutex_unlock(&chain->ctrl_mutex);
diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index d46dc432456c..4dd83bae0fd7 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -427,7 +427,7 @@ static int uvc_parse_format(struct uvc_device *dev,
 		fmtdesc = uvc_format_by_guid(&buffer[5]);
 
 		if (fmtdesc != NULL) {
-			strlcpy(format->name, fmtdesc->name,
+			strscpy(format->name, fmtdesc->name,
 				sizeof(format->name));
 			format->fcc = fmtdesc->fcc;
 		} else {
@@ -445,7 +445,7 @@ static int uvc_parse_format(struct uvc_device *dev,
 		 */
 		if (dev->quirks & UVC_QUIRK_FORCE_Y8) {
 			if (format->fcc == V4L2_PIX_FMT_YUYV) {
-				strlcpy(format->name, "Greyscale 8-bit (Y8  )",
+				strscpy(format->name, "Greyscale 8-bit (Y8  )",
 					sizeof(format->name));
 				format->fcc = V4L2_PIX_FMT_GREY;
 				format->bpp = 8;
@@ -471,7 +471,7 @@ static int uvc_parse_format(struct uvc_device *dev,
 			return -EINVAL;
 		}
 
-		strlcpy(format->name, "MJPEG", sizeof(format->name));
+		strscpy(format->name, "MJPEG", sizeof(format->name));
 		format->fcc = V4L2_PIX_FMT_MJPEG;
 		format->flags = UVC_FMT_FLAG_COMPRESSED;
 		format->bpp = 0;
@@ -489,13 +489,13 @@ static int uvc_parse_format(struct uvc_device *dev,
 
 		switch (buffer[8] & 0x7f) {
 		case 0:
-			strlcpy(format->name, "SD-DV", sizeof(format->name));
+			strscpy(format->name, "SD-DV", sizeof(format->name));
 			break;
 		case 1:
-			strlcpy(format->name, "SDL-DV", sizeof(format->name));
+			strscpy(format->name, "SDL-DV", sizeof(format->name));
 			break;
 		case 2:
-			strlcpy(format->name, "HD-DV", sizeof(format->name));
+			strscpy(format->name, "HD-DV", sizeof(format->name));
 			break;
 		default:
 			uvc_trace(UVC_TRACE_DESCR, "device %d videostreaming "
@@ -1932,7 +1932,7 @@ int uvc_register_video_device(struct uvc_device *dev,
 		break;
 	}
 
-	strlcpy(vdev->name, dev->name, sizeof(vdev->name));
+	strscpy(vdev->name, dev->name, sizeof(vdev->name));
 
 	/*
 	 * Set the driver data before calling video_register_device, otherwise
@@ -2086,7 +2086,7 @@ static int uvc_probe(struct usb_interface *intf,
 		dev->meta_format = info->meta_format;
 
 	if (udev->product != NULL)
-		strlcpy(dev->name, udev->product, sizeof(dev->name));
+		strscpy(dev->name, udev->product, sizeof(dev->name));
 	else
 		snprintf(dev->name, sizeof(dev->name),
 			 "UVC Camera (%04x:%04x)",
@@ -2134,9 +2134,9 @@ static int uvc_probe(struct usb_interface *intf,
 	/* Initialize the media device and register the V4L2 device. */
 #ifdef CONFIG_MEDIA_CONTROLLER
 	dev->mdev.dev = &intf->dev;
-	strlcpy(dev->mdev.model, dev->name, sizeof(dev->mdev.model));
+	strscpy(dev->mdev.model, dev->name, sizeof(dev->mdev.model));
 	if (udev->serial)
-		strlcpy(dev->mdev.serial, udev->serial,
+		strscpy(dev->mdev.serial, udev->serial,
 			sizeof(dev->mdev.serial));
 	strcpy(dev->mdev.bus_info, udev->devpath);
 	dev->mdev.hw_revision = le16_to_cpu(udev->descriptor.bcdDevice);
diff --git a/drivers/media/usb/uvc/uvc_entity.c b/drivers/media/usb/uvc/uvc_entity.c
index 554063c07d7a..06bffdf8828b 100644
--- a/drivers/media/usb/uvc/uvc_entity.c
+++ b/drivers/media/usb/uvc/uvc_entity.c
@@ -79,7 +79,7 @@ static int uvc_mc_init_entity(struct uvc_video_chain *chain,
 
 	if (UVC_ENTITY_TYPE(entity) != UVC_TT_STREAMING) {
 		v4l2_subdev_init(&entity->subdev, &uvc_subdev_ops);
-		strlcpy(entity->subdev.name, entity->name,
+		strscpy(entity->subdev.name, entity->name,
 			sizeof(entity->subdev.name));
 
 		ret = media_entity_pads_init(&entity->subdev.entity,
diff --git a/drivers/media/usb/uvc/uvc_metadata.c b/drivers/media/usb/uvc/uvc_metadata.c
index cd1aec19cc5b..da2b063e88a2 100644
--- a/drivers/media/usb/uvc/uvc_metadata.c
+++ b/drivers/media/usb/uvc/uvc_metadata.c
@@ -33,8 +33,8 @@ static int uvc_meta_v4l2_querycap(struct file *file, void *fh,
 	struct uvc_streaming *stream = video_get_drvdata(vfh->vdev);
 	struct uvc_video_chain *chain = stream->chain;
 
-	strlcpy(cap->driver, "uvcvideo", sizeof(cap->driver));
-	strlcpy(cap->card, vfh->vdev->name, sizeof(cap->card));
+	strscpy(cap->driver, "uvcvideo", sizeof(cap->driver));
+	strscpy(cap->card, vfh->vdev->name, sizeof(cap->card));
 	usb_make_path(stream->dev->udev, cap->bus_info, sizeof(cap->bus_info));
 	cap->capabilities = V4L2_CAP_DEVICE_CAPS | V4L2_CAP_STREAMING
 			  | chain->caps;
diff --git a/drivers/media/usb/uvc/uvc_v4l2.c b/drivers/media/usb/uvc/uvc_v4l2.c
index 18a7384b50ee..b26182ce7462 100644
--- a/drivers/media/usb/uvc/uvc_v4l2.c
+++ b/drivers/media/usb/uvc/uvc_v4l2.c
@@ -591,8 +591,8 @@ static int uvc_ioctl_querycap(struct file *file, void *fh,
 	struct uvc_video_chain *chain = handle->chain;
 	struct uvc_streaming *stream = handle->stream;
 
-	strlcpy(cap->driver, "uvcvideo", sizeof(cap->driver));
-	strlcpy(cap->card, vdev->name, sizeof(cap->card));
+	strscpy(cap->driver, "uvcvideo", sizeof(cap->driver));
+	strscpy(cap->card, vdev->name, sizeof(cap->card));
 	usb_make_path(stream->dev->udev, cap->bus_info, sizeof(cap->bus_info));
 	cap->capabilities = V4L2_CAP_DEVICE_CAPS | V4L2_CAP_STREAMING
 			  | chain->caps;
@@ -618,7 +618,7 @@ static int uvc_ioctl_enum_fmt(struct uvc_streaming *stream,
 	fmt->flags = 0;
 	if (format->flags & UVC_FMT_FLAG_COMPRESSED)
 		fmt->flags |= V4L2_FMT_FLAG_COMPRESSED;
-	strlcpy(fmt->description, format->name, sizeof(fmt->description));
+	strscpy(fmt->description, format->name, sizeof(fmt->description));
 	fmt->description[sizeof(fmt->description) - 1] = 0;
 	fmt->pixelformat = format->fcc;
 	return 0;
@@ -859,7 +859,7 @@ static int uvc_ioctl_enum_input(struct file *file, void *fh,
 
 	memset(input, 0, sizeof(*input));
 	input->index = index;
-	strlcpy(input->name, iterm->name, sizeof(input->name));
+	strscpy(input->name, iterm->name, sizeof(input->name));
 	if (UVC_ENTITY_TYPE(iterm) == UVC_ITT_CAMERA)
 		input->type = V4L2_INPUT_TYPE_CAMERA;
 
@@ -939,7 +939,7 @@ static int uvc_ioctl_query_ext_ctrl(struct file *file, void *fh,
 
 	qec->id = qc.id;
 	qec->type = qc.type;
-	strlcpy(qec->name, qc.name, sizeof(qec->name));
+	strscpy(qec->name, qc.name, sizeof(qec->name));
 	qec->minimum = qc.minimum;
 	qec->maximum = qc.maximum;
 	qec->step = qc.step;
diff --git a/drivers/media/usb/zr364xx/zr364xx.c b/drivers/media/usb/zr364xx/zr364xx.c
index b8886102c5ed..0ba98583c736 100644
--- a/drivers/media/usb/zr364xx/zr364xx.c
+++ b/drivers/media/usb/zr364xx/zr364xx.c
@@ -702,9 +702,9 @@ static int zr364xx_vidioc_querycap(struct file *file, void *priv,
 {
 	struct zr364xx_camera *cam = video_drvdata(file);
 
-	strlcpy(cap->driver, DRIVER_DESC, sizeof(cap->driver));
-	strlcpy(cap->card, cam->udev->product, sizeof(cap->card));
-	strlcpy(cap->bus_info, dev_name(&cam->udev->dev),
+	strscpy(cap->driver, DRIVER_DESC, sizeof(cap->driver));
+	strscpy(cap->card, cam->udev->product, sizeof(cap->card));
+	strscpy(cap->bus_info, dev_name(&cam->udev->dev),
 		sizeof(cap->bus_info));
 	cap->device_caps = V4L2_CAP_VIDEO_CAPTURE |
 			    V4L2_CAP_READWRITE |
diff --git a/drivers/media/v4l2-core/v4l2-common.c b/drivers/media/v4l2-core/v4l2-common.c
index b518b92d6d96..a443cfa050b6 100644
--- a/drivers/media/v4l2-core/v4l2-common.c
+++ b/drivers/media/v4l2-core/v4l2-common.c
@@ -100,7 +100,7 @@ int v4l2_ctrl_query_fill(struct v4l2_queryctrl *qctrl, s32 _min, s32 _max, s32 _
 	qctrl->step = step;
 	qctrl->default_value = def;
 	qctrl->reserved[0] = qctrl->reserved[1] = 0;
-	strlcpy(qctrl->name, name, sizeof(qctrl->name));
+	strscpy(qctrl->name, name, sizeof(qctrl->name));
 	return 0;
 }
 EXPORT_SYMBOL(v4l2_ctrl_query_fill);
@@ -186,7 +186,7 @@ struct v4l2_subdev *v4l2_i2c_new_subdev(struct v4l2_device *v4l2_dev,
 	/* Setup the i2c board info with the device type and
 	   the device address. */
 	memset(&info, 0, sizeof(info));
-	strlcpy(info.type, client_type, sizeof(info.type));
+	strscpy(info.type, client_type, sizeof(info.type));
 	info.addr = addr;
 
 	return v4l2_i2c_new_subdev_board(v4l2_dev, adapter, &info, probe_addrs);
@@ -255,7 +255,7 @@ void v4l2_spi_subdev_init(struct v4l2_subdev *sd, struct spi_device *spi,
 	v4l2_set_subdevdata(sd, spi);
 	spi_set_drvdata(spi, sd);
 	/* initialize name */
-	strlcpy(sd->name, spi->dev.driver->name, sizeof(sd->name));
+	strscpy(sd->name, spi->dev.driver->name, sizeof(sd->name));
 }
 EXPORT_SYMBOL_GPL(v4l2_spi_subdev_init);
 
diff --git a/drivers/media/v4l2-core/v4l2-ctrls.c b/drivers/media/v4l2-core/v4l2-ctrls.c
index 599c1cbff3b9..ee006d34c19f 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls.c
@@ -2722,7 +2722,7 @@ int v4l2_query_ext_ctrl(struct v4l2_ctrl_handler *hdl, struct v4l2_query_ext_ctr
 		qc->id = id;
 	else
 		qc->id = ctrl->id;
-	strlcpy(qc->name, ctrl->name, sizeof(qc->name));
+	strscpy(qc->name, ctrl->name, sizeof(qc->name));
 	qc->flags = user_flags(ctrl);
 	qc->type = ctrl->type;
 	qc->elem_size = ctrl->elem_size;
@@ -2754,7 +2754,7 @@ int v4l2_queryctrl(struct v4l2_ctrl_handler *hdl, struct v4l2_queryctrl *qc)
 	qc->id = qec.id;
 	qc->type = qec.type;
 	qc->flags = qec.flags;
-	strlcpy(qc->name, qec.name, sizeof(qc->name));
+	strscpy(qc->name, qec.name, sizeof(qc->name));
 	switch (qc->type) {
 	case V4L2_CTRL_TYPE_INTEGER:
 	case V4L2_CTRL_TYPE_BOOLEAN:
@@ -2813,7 +2813,7 @@ int v4l2_querymenu(struct v4l2_ctrl_handler *hdl, struct v4l2_querymenu *qm)
 	if (ctrl->type == V4L2_CTRL_TYPE_MENU) {
 		if (ctrl->qmenu[i] == NULL || ctrl->qmenu[i][0] == '\0')
 			return -EINVAL;
-		strlcpy(qm->name, ctrl->qmenu[i], sizeof(qm->name));
+		strscpy(qm->name, ctrl->qmenu[i], sizeof(qm->name));
 	} else {
 		qm->value = ctrl->qmenu_int[i];
 	}
@@ -3442,7 +3442,7 @@ int __v4l2_ctrl_s_ctrl_string(struct v4l2_ctrl *ctrl, const char *s)
 
 	/* It's a driver bug if this happens. */
 	WARN_ON(ctrl->type != V4L2_CTRL_TYPE_STRING);
-	strlcpy(ctrl->p_new.p_char, s, ctrl->maximum + 1);
+	strscpy(ctrl->p_new.p_char, s, ctrl->maximum + 1);
 	return set_ctrl(NULL, ctrl, 0);
 }
 EXPORT_SYMBOL(__v4l2_ctrl_s_ctrl_string);
diff --git a/drivers/media/v4l2-core/v4l2-device.c b/drivers/media/v4l2-core/v4l2-device.c
index 3940e55c72f1..098562901f25 100644
--- a/drivers/media/v4l2-core/v4l2-device.c
+++ b/drivers/media/v4l2-core/v4l2-device.c
@@ -245,7 +245,7 @@ int v4l2_device_register_subdev_nodes(struct v4l2_device *v4l2_dev)
 		}
 
 		video_set_drvdata(vdev, sd);
-		strlcpy(vdev->name, sd->name, sizeof(vdev->name));
+		strscpy(vdev->name, sd->name, sizeof(vdev->name));
 		vdev->v4l2_dev = v4l2_dev;
 		vdev->fops = &v4l2_subdev_fops;
 		vdev->release = v4l2_device_release_subdev_node;
diff --git a/drivers/media/v4l2-core/v4l2-flash-led-class.c b/drivers/media/v4l2-core/v4l2-flash-led-class.c
index 215b4804ada2..1697932af5ea 100644
--- a/drivers/media/v4l2-core/v4l2-flash-led-class.c
+++ b/drivers/media/v4l2-core/v4l2-flash-led-class.c
@@ -640,7 +640,7 @@ static struct v4l2_flash *__v4l2_flash_init(
 	v4l2_subdev_init(sd, &v4l2_flash_subdev_ops);
 	sd->internal_ops = &v4l2_flash_subdev_internal_ops;
 	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
-	strlcpy(sd->name, config->dev_name, sizeof(sd->name));
+	strscpy(sd->name, config->dev_name, sizeof(sd->name));
 
 	ret = media_entity_pads_init(&sd->entity, 0, NULL);
 	if (ret < 0)
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index 54afc9c7ee6e..7de041bae84f 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -121,7 +121,7 @@ int v4l2_video_std_construct(struct v4l2_standard *vs,
 	vs->id = id;
 	v4l2_video_std_frame_period(id, &vs->frameperiod);
 	vs->framelines = (id & V4L2_STD_525_60) ? 525 : 625;
-	strlcpy(vs->name, name, sizeof(vs->name));
+	strscpy(vs->name, name, sizeof(vs->name));
 	return 0;
 }
 EXPORT_SYMBOL(v4l2_video_std_construct);
@@ -1352,7 +1352,7 @@ static void v4l_fill_fmtdesc(struct v4l2_fmtdesc *fmt)
 	}
 
 	if (descr)
-		WARN_ON(strlcpy(fmt->description, descr, sz) >= sz);
+		WARN_ON(strscpy(fmt->description, descr, sz) >= sz);
 	fmt->flags = flags;
 }
 
@@ -2391,7 +2391,7 @@ static int v4l_dbg_g_chip_info(const struct v4l2_ioctl_ops *ops,
 			p->flags |= V4L2_CHIP_FL_WRITABLE;
 		if (ops->vidioc_g_register)
 			p->flags |= V4L2_CHIP_FL_READABLE;
-		strlcpy(p->name, vfd->v4l2_dev->name, sizeof(p->name));
+		strscpy(p->name, vfd->v4l2_dev->name, sizeof(p->name));
 		if (ops->vidioc_g_chip_info)
 			return ops->vidioc_g_chip_info(file, fh, arg);
 		if (p->match.addr)
@@ -2408,7 +2408,7 @@ static int v4l_dbg_g_chip_info(const struct v4l2_ioctl_ops *ops,
 				p->flags |= V4L2_CHIP_FL_WRITABLE;
 			if (sd->ops->core && sd->ops->core->g_register)
 				p->flags |= V4L2_CHIP_FL_READABLE;
-			strlcpy(p->name, sd->name, sizeof(p->name));
+			strscpy(p->name, sd->name, sizeof(p->name));
 			return 0;
 		}
 		break;
diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
index 2b63fa6b6fc9..792f41dffe23 100644
--- a/drivers/media/v4l2-core/v4l2-subdev.c
+++ b/drivers/media/v4l2-core/v4l2-subdev.c
@@ -273,7 +273,7 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg)
 			p->flags |= V4L2_CHIP_FL_WRITABLE;
 		if (sd->ops->core && sd->ops->core->g_register)
 			p->flags |= V4L2_CHIP_FL_READABLE;
-		strlcpy(p->name, sd->name, sizeof(p->name));
+		strscpy(p->name, sd->name, sizeof(p->name));
 		return 0;
 	}
 #endif
diff --git a/drivers/staging/media/bcm2048/radio-bcm2048.c b/drivers/staging/media/bcm2048/radio-bcm2048.c
index a90b2eb112f9..874d290f9622 100644
--- a/drivers/staging/media/bcm2048/radio-bcm2048.c
+++ b/drivers/staging/media/bcm2048/radio-bcm2048.c
@@ -2304,9 +2304,9 @@ static int bcm2048_vidioc_querycap(struct file *file, void *priv,
 {
 	struct bcm2048_device *bdev = video_get_drvdata(video_devdata(file));
 
-	strlcpy(capability->driver, BCM2048_DRIVER_NAME,
+	strscpy(capability->driver, BCM2048_DRIVER_NAME,
 		sizeof(capability->driver));
-	strlcpy(capability->card, BCM2048_DRIVER_CARD,
+	strscpy(capability->card, BCM2048_DRIVER_CARD,
 		sizeof(capability->card));
 	snprintf(capability->bus_info, 32, "I2C: 0x%X", bdev->client->addr);
 	capability->device_caps = V4L2_CAP_TUNER | V4L2_CAP_RADIO |
diff --git a/drivers/staging/media/davinci_vpfe/dm365_ipipe.c b/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
index 95942768639c..7c09efc6c299 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_ipipe.c
@@ -1801,7 +1801,7 @@ vpfe_ipipe_init(struct vpfe_ipipe_device *ipipe, struct platform_device *pdev)
 
 	v4l2_subdev_init(sd, &ipipe_v4l2_ops);
 	sd->internal_ops = &ipipe_v4l2_internal_ops;
-	strlcpy(sd->name, "DAVINCI IPIPE", sizeof(sd->name));
+	strscpy(sd->name, "DAVINCI IPIPE", sizeof(sd->name));
 	sd->grp_id = 1 << 16;	/* group ID for davinci subdevs */
 	v4l2_set_subdevdata(sd, ipipe);
 	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
diff --git a/drivers/staging/media/davinci_vpfe/dm365_ipipeif.c b/drivers/staging/media/davinci_vpfe/dm365_ipipeif.c
index 11c9edfbdbe3..a53231b08d30 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_ipipeif.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_ipipeif.c
@@ -1020,7 +1020,7 @@ int vpfe_ipipeif_init(struct vpfe_ipipeif_device *ipipeif,
 	v4l2_subdev_init(sd, &ipipeif_v4l2_ops);
 
 	sd->internal_ops = &ipipeif_v4l2_internal_ops;
-	strlcpy(sd->name, "DAVINCI IPIPEIF", sizeof(sd->name));
+	strscpy(sd->name, "DAVINCI IPIPEIF", sizeof(sd->name));
 	sd->grp_id = 1 << 16;	/* group ID for davinci subdevs */
 
 	v4l2_set_subdevdata(sd, ipipeif);
diff --git a/drivers/staging/media/davinci_vpfe/dm365_isif.c b/drivers/staging/media/davinci_vpfe/dm365_isif.c
index 745e33fa6bea..39eb0819ab4e 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_isif.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_isif.c
@@ -2038,7 +2038,7 @@ int vpfe_isif_init(struct vpfe_isif_device *isif, struct platform_device *pdev)
 	isif->video_out.ops = &isif_video_ops;
 	v4l2_subdev_init(sd, &isif_v4l2_ops);
 	sd->internal_ops = &isif_v4l2_internal_ops;
-	strlcpy(sd->name, "DAVINCI ISIF", sizeof(sd->name));
+	strscpy(sd->name, "DAVINCI ISIF", sizeof(sd->name));
 	sd->grp_id = 1 << 16;	/* group ID for davinci subdevs */
 	v4l2_set_subdevdata(sd, isif);
 	sd->flags |= V4L2_SUBDEV_FL_HAS_EVENTS | V4L2_SUBDEV_FL_HAS_DEVNODE;
diff --git a/drivers/staging/media/davinci_vpfe/dm365_resizer.c b/drivers/staging/media/davinci_vpfe/dm365_resizer.c
index 2b797474a344..aac6dbfc646f 100644
--- a/drivers/staging/media/davinci_vpfe/dm365_resizer.c
+++ b/drivers/staging/media/davinci_vpfe/dm365_resizer.c
@@ -1903,7 +1903,7 @@ int vpfe_resizer_init(struct vpfe_resizer_device *vpfe_rsz,
 
 	v4l2_subdev_init(sd, &resizer_v4l2_ops);
 	sd->internal_ops = &resizer_v4l2_internal_ops;
-	strlcpy(sd->name, "DAVINCI RESIZER CROP", sizeof(sd->name));
+	strscpy(sd->name, "DAVINCI RESIZER CROP", sizeof(sd->name));
 	sd->grp_id = 1 << 16;	/* group ID for davinci subdevs */
 	v4l2_set_subdevdata(sd, vpfe_rsz);
 	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
@@ -1927,7 +1927,7 @@ int vpfe_resizer_init(struct vpfe_resizer_device *vpfe_rsz,
 
 	v4l2_subdev_init(sd, &resizer_v4l2_ops);
 	sd->internal_ops = &resizer_v4l2_internal_ops;
-	strlcpy(sd->name, "DAVINCI RESIZER A", sizeof(sd->name));
+	strscpy(sd->name, "DAVINCI RESIZER A", sizeof(sd->name));
 	sd->grp_id = 1 << 16;	/* group ID for davinci subdevs */
 	v4l2_set_subdevdata(sd, vpfe_rsz);
 	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
@@ -1949,7 +1949,7 @@ int vpfe_resizer_init(struct vpfe_resizer_device *vpfe_rsz,
 
 	v4l2_subdev_init(sd, &resizer_v4l2_ops);
 	sd->internal_ops = &resizer_v4l2_internal_ops;
-	strlcpy(sd->name, "DAVINCI RESIZER B", sizeof(sd->name));
+	strscpy(sd->name, "DAVINCI RESIZER B", sizeof(sd->name));
 	sd->grp_id = 1 << 16;	/* group ID for davinci subdevs */
 	v4l2_set_subdevdata(sd, vpfe_rsz);
 	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
diff --git a/drivers/staging/media/davinci_vpfe/vpfe_video.c b/drivers/staging/media/davinci_vpfe/vpfe_video.c
index 1269a983455e..5e42490331b7 100644
--- a/drivers/staging/media/davinci_vpfe/vpfe_video.c
+++ b/drivers/staging/media/davinci_vpfe/vpfe_video.c
@@ -618,9 +618,9 @@ static int vpfe_querycap(struct file *file, void  *priv,
 		cap->device_caps = V4L2_CAP_VIDEO_OUTPUT | V4L2_CAP_STREAMING;
 	cap->capabilities = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_VIDEO_OUTPUT |
 			    V4L2_CAP_STREAMING | V4L2_CAP_DEVICE_CAPS;
-	strlcpy(cap->driver, CAPTURE_DRV_NAME, sizeof(cap->driver));
-	strlcpy(cap->bus_info, "VPFE", sizeof(cap->bus_info));
-	strlcpy(cap->card, vpfe_dev->cfg->card_name, sizeof(cap->card));
+	strscpy(cap->driver, CAPTURE_DRV_NAME, sizeof(cap->driver));
+	strscpy(cap->bus_info, "VPFE", sizeof(cap->bus_info));
+	strscpy(cap->card, vpfe_dev->cfg->card_name, sizeof(cap->card));
 
 	return 0;
 }
diff --git a/drivers/staging/media/imx/imx-media-capture.c b/drivers/staging/media/imx/imx-media-capture.c
index 256039ce561e..b37e1186eb2f 100644
--- a/drivers/staging/media/imx/imx-media-capture.c
+++ b/drivers/staging/media/imx/imx-media-capture.c
@@ -73,8 +73,8 @@ static int vidioc_querycap(struct file *file, void *fh,
 {
 	struct capture_priv *priv = video_drvdata(file);
 
-	strlcpy(cap->driver, "imx-media-capture", sizeof(cap->driver));
-	strlcpy(cap->card, "imx-media-capture", sizeof(cap->card));
+	strscpy(cap->driver, "imx-media-capture", sizeof(cap->driver));
+	strscpy(cap->card, "imx-media-capture", sizeof(cap->card));
 	snprintf(cap->bus_info, sizeof(cap->bus_info),
 		 "platform:%s", priv->src_sd->name);
 
diff --git a/drivers/staging/media/imx/imx-media-dev.c b/drivers/staging/media/imx/imx-media-dev.c
index b0be80f05767..1931d1b038dc 100644
--- a/drivers/staging/media/imx/imx-media-dev.c
+++ b/drivers/staging/media/imx/imx-media-dev.c
@@ -498,14 +498,14 @@ static int imx_media_probe(struct platform_device *pdev)
 
 	dev_set_drvdata(dev, imxmd);
 
-	strlcpy(imxmd->md.model, "imx-media", sizeof(imxmd->md.model));
+	strscpy(imxmd->md.model, "imx-media", sizeof(imxmd->md.model));
 	imxmd->md.ops = &imx_media_md_ops;
 	imxmd->md.dev = dev;
 
 	mutex_init(&imxmd->mutex);
 
 	imxmd->v4l2_dev.mdev = &imxmd->md;
-	strlcpy(imxmd->v4l2_dev.name, "imx-media",
+	strscpy(imxmd->v4l2_dev.name, "imx-media",
 		sizeof(imxmd->v4l2_dev.name));
 
 	media_device_init(&imxmd->md);
diff --git a/drivers/staging/media/omap4iss/iss.c b/drivers/staging/media/omap4iss/iss.c
index b1036baebb03..960f43fddfc1 100644
--- a/drivers/staging/media/omap4iss/iss.c
+++ b/drivers/staging/media/omap4iss/iss.c
@@ -989,7 +989,7 @@ static int iss_register_entities(struct iss_device *iss)
 	int ret;
 
 	iss->media_dev.dev = iss->dev;
-	strlcpy(iss->media_dev.model, "TI OMAP4 ISS",
+	strscpy(iss->media_dev.model, "TI OMAP4 ISS",
 		sizeof(iss->media_dev.model));
 	iss->media_dev.hw_revision = iss->revision;
 	iss->media_dev.ops = &iss_media_ops;
diff --git a/drivers/staging/media/omap4iss/iss_ipipe.c b/drivers/staging/media/omap4iss/iss_ipipe.c
index d86ef8a031f2..caf4fab5a229 100644
--- a/drivers/staging/media/omap4iss/iss_ipipe.c
+++ b/drivers/staging/media/omap4iss/iss_ipipe.c
@@ -507,7 +507,7 @@ static int ipipe_init_entities(struct iss_ipipe_device *ipipe)
 
 	v4l2_subdev_init(sd, &ipipe_v4l2_ops);
 	sd->internal_ops = &ipipe_v4l2_internal_ops;
-	strlcpy(sd->name, "OMAP4 ISS ISP IPIPE", sizeof(sd->name));
+	strscpy(sd->name, "OMAP4 ISS ISP IPIPE", sizeof(sd->name));
 	sd->grp_id = BIT(16);	/* group ID for iss subdevs */
 	v4l2_set_subdevdata(sd, ipipe);
 	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
diff --git a/drivers/staging/media/omap4iss/iss_ipipeif.c b/drivers/staging/media/omap4iss/iss_ipipeif.c
index cb88b2bd0d82..5f33506fb1b9 100644
--- a/drivers/staging/media/omap4iss/iss_ipipeif.c
+++ b/drivers/staging/media/omap4iss/iss_ipipeif.c
@@ -738,7 +738,7 @@ static int ipipeif_init_entities(struct iss_ipipeif_device *ipipeif)
 
 	v4l2_subdev_init(sd, &ipipeif_v4l2_ops);
 	sd->internal_ops = &ipipeif_v4l2_internal_ops;
-	strlcpy(sd->name, "OMAP4 ISS ISP IPIPEIF", sizeof(sd->name));
+	strscpy(sd->name, "OMAP4 ISS ISP IPIPEIF", sizeof(sd->name));
 	sd->grp_id = BIT(16);	/* group ID for iss subdevs */
 	v4l2_set_subdevdata(sd, ipipeif);
 	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
diff --git a/drivers/staging/media/omap4iss/iss_resizer.c b/drivers/staging/media/omap4iss/iss_resizer.c
index 4bbfa20b3c38..27f0d7168e50 100644
--- a/drivers/staging/media/omap4iss/iss_resizer.c
+++ b/drivers/staging/media/omap4iss/iss_resizer.c
@@ -781,7 +781,7 @@ static int resizer_init_entities(struct iss_resizer_device *resizer)
 
 	v4l2_subdev_init(sd, &resizer_v4l2_ops);
 	sd->internal_ops = &resizer_v4l2_internal_ops;
-	strlcpy(sd->name, "OMAP4 ISS ISP resizer", sizeof(sd->name));
+	strscpy(sd->name, "OMAP4 ISS ISP resizer", sizeof(sd->name));
 	sd->grp_id = BIT(16);	/* group ID for iss subdevs */
 	v4l2_set_subdevdata(sd, resizer);
 	sd->flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
diff --git a/drivers/staging/media/omap4iss/iss_video.c b/drivers/staging/media/omap4iss/iss_video.c
index 16478fe9e3f8..124f304907b6 100644
--- a/drivers/staging/media/omap4iss/iss_video.c
+++ b/drivers/staging/media/omap4iss/iss_video.c
@@ -534,9 +534,9 @@ iss_video_querycap(struct file *file, void *fh, struct v4l2_capability *cap)
 {
 	struct iss_video *video = video_drvdata(file);
 
-	strlcpy(cap->driver, ISS_VIDEO_DRIVER_NAME, sizeof(cap->driver));
-	strlcpy(cap->card, video->video.name, sizeof(cap->card));
-	strlcpy(cap->bus_info, "media", sizeof(cap->bus_info));
+	strscpy(cap->driver, ISS_VIDEO_DRIVER_NAME, sizeof(cap->driver));
+	strscpy(cap->card, video->video.name, sizeof(cap->card));
+	strscpy(cap->bus_info, "media", sizeof(cap->bus_info));
 
 	if (video->type == V4L2_BUF_TYPE_VIDEO_CAPTURE)
 		cap->device_caps = V4L2_CAP_VIDEO_CAPTURE | V4L2_CAP_STREAMING;
@@ -573,7 +573,7 @@ iss_video_enum_format(struct file *file, void *fh, struct v4l2_fmtdesc *f)
 
 		if (index == 0) {
 			f->pixelformat = info->pixelformat;
-			strlcpy(f->description, info->description,
+			strscpy(f->description, info->description,
 				sizeof(f->description));
 			return 0;
 		}
@@ -1053,7 +1053,7 @@ iss_video_enum_input(struct file *file, void *fh, struct v4l2_input *input)
 	if (input->index > 0)
 		return -EINVAL;
 
-	strlcpy(input->name, "camera", sizeof(input->name));
+	strscpy(input->name, "camera", sizeof(input->name));
 	input->type = V4L2_INPUT_TYPE_CAMERA;
 
 	return 0;
diff --git a/drivers/staging/media/zoran/zoran_card.c b/drivers/staging/media/zoran/zoran_card.c
index a6b9ebd20263..e69a43ae74c2 100644
--- a/drivers/staging/media/zoran/zoran_card.c
+++ b/drivers/staging/media/zoran/zoran_card.c
@@ -706,7 +706,7 @@ zoran_register_i2c (struct zoran *zr)
 {
 	zr->i2c_algo = zoran_i2c_bit_data_template;
 	zr->i2c_algo.data = zr;
-	strlcpy(zr->i2c_adapter.name, ZR_DEVNAME(zr),
+	strscpy(zr->i2c_adapter.name, ZR_DEVNAME(zr),
 		sizeof(zr->i2c_adapter.name));
 	i2c_set_adapdata(&zr->i2c_adapter, &zr->v4l2_dev);
 	zr->i2c_adapter.algo_data = &zr->i2c_algo;
@@ -1145,7 +1145,7 @@ static struct videocodec_master *zoran_setup_videocodec(struct zoran *zr,
 	m->type = 0;
 
 	m->flags = CODEC_FLAG_ENCODER | CODEC_FLAG_DECODER;
-	strlcpy(m->name, ZR_DEVNAME(zr), sizeof(m->name));
+	strscpy(m->name, ZR_DEVNAME(zr), sizeof(m->name));
 	m->data = zr;
 
 	switch (type)
diff --git a/drivers/staging/media/zoran/zoran_driver.c b/drivers/staging/media/zoran/zoran_driver.c
index d7842224fff6..e30c3ef31a9b 100644
--- a/drivers/staging/media/zoran/zoran_driver.c
+++ b/drivers/staging/media/zoran/zoran_driver.c
@@ -1510,8 +1510,8 @@ static int zoran_querycap(struct file *file, void *__fh, struct v4l2_capability
 	struct zoran_fh *fh = __fh;
 	struct zoran *zr = fh->zr;
 
-	strlcpy(cap->card, ZR_DEVNAME(zr), sizeof(cap->card));
-	strlcpy(cap->driver, "zoran", sizeof(cap->driver));
+	strscpy(cap->card, ZR_DEVNAME(zr), sizeof(cap->card));
+	strscpy(cap->driver, "zoran", sizeof(cap->driver));
 	snprintf(cap->bus_info, sizeof(cap->bus_info), "PCI:%s",
 		 pci_name(zr->pci_dev));
 	cap->device_caps = V4L2_CAP_STREAMING | V4L2_CAP_VIDEO_CAPTURE |
-- 
2.17.1
