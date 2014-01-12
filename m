Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:48029 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbaALRbM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 12 Jan 2014 12:31:12 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
To: Chris Lee <updatelee@gmail.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH] em28xx: fix xc3028 demod and firmware setup on DVB
Date: Sun, 12 Jan 2014 12:10:44 -0200
Message-Id: <1389535844-31072-1-git-send-email-m.chehab@samsung.com>
In-Reply-To: <CAA9z4LYNHuORA+QnO_3NBj4mwBxSMFY8pXoF2y-iYjJD+Xqteg@mail.gmail.com>
References: <CAA9z4LYNHuORA+QnO_3NBj4mwBxSMFY8pXoF2y-iYjJD+Xqteg@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Now that em28xx can be compiled without V4L support, we should
call em28xx_setup_xc3028() on both em28xx-v4l and em28xx-dvb
modules.

Reported-by: Chris Lee <updatelee@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/usb/em28xx/em28xx-cards.c | 49 +++++++++++++++++++++++++++++++++
 drivers/media/usb/em28xx/em28xx-dvb.c   |  5 ++++
 drivers/media/usb/em28xx/em28xx-video.c | 48 --------------------------------
 drivers/media/usb/em28xx/em28xx.h       |  1 +
 4 files changed, 55 insertions(+), 48 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 39cf49c44e10..6efb9029381b 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -2768,6 +2768,55 @@ static void em28xx_card_setup(struct em28xx *dev)
 		dev->tuner_type = tuner;
 }
 
+void em28xx_setup_xc3028(struct em28xx *dev, struct xc2028_ctrl *ctl)
+{
+	memset(ctl, 0, sizeof(*ctl));
+
+	ctl->fname   = XC2028_DEFAULT_FIRMWARE;
+	ctl->max_len = 64;
+	ctl->mts = em28xx_boards[dev->model].mts_firmware;
+
+	switch (dev->model) {
+	case EM2880_BOARD_EMPIRE_DUAL_TV:
+	case EM2880_BOARD_HAUPPAUGE_WINTV_HVR_900:
+	case EM2882_BOARD_TERRATEC_HYBRID_XS:
+		ctl->demod = XC3028_FE_ZARLINK456;
+		break;
+	case EM2880_BOARD_TERRATEC_HYBRID_XS:
+	case EM2880_BOARD_TERRATEC_HYBRID_XS_FR:
+	case EM2881_BOARD_PINNACLE_HYBRID_PRO:
+		ctl->demod = XC3028_FE_ZARLINK456;
+		break;
+	case EM2880_BOARD_HAUPPAUGE_WINTV_HVR_900_R2:
+	case EM2882_BOARD_PINNACLE_HYBRID_PRO_330E:
+		ctl->demod = XC3028_FE_DEFAULT;
+		break;
+	case EM2880_BOARD_AMD_ATI_TV_WONDER_HD_600:
+		ctl->demod = XC3028_FE_DEFAULT;
+		ctl->fname = XC3028L_DEFAULT_FIRMWARE;
+		break;
+	case EM2883_BOARD_HAUPPAUGE_WINTV_HVR_850:
+	case EM2883_BOARD_HAUPPAUGE_WINTV_HVR_950:
+	case EM2880_BOARD_PINNACLE_PCTV_HD_PRO:
+		/* FIXME: Better to specify the needed IF */
+		ctl->demod = XC3028_FE_DEFAULT;
+		break;
+	case EM2883_BOARD_KWORLD_HYBRID_330U:
+	case EM2882_BOARD_DIKOM_DK300:
+	case EM2882_BOARD_KWORLD_VS_DVBT:
+		ctl->demod = XC3028_FE_CHINA;
+		ctl->fname = XC2028_DEFAULT_FIRMWARE;
+		break;
+	case EM2882_BOARD_EVGA_INDTUBE:
+		ctl->demod = XC3028_FE_CHINA;
+		ctl->fname = XC3028L_DEFAULT_FIRMWARE;
+		break;
+	default:
+		ctl->demod = XC3028_FE_OREN538;
+	}
+}
+EXPORT_SYMBOL_GPL(em28xx_setup_xc3028);
+
 static void request_module_async(struct work_struct *work)
 {
 	struct em28xx *dev = container_of(work,
diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index 5c6be66ac858..7dba17576edf 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -828,11 +828,16 @@ static int em28xx_attach_xc3028(u8 addr, struct em28xx *dev)
 {
 	struct dvb_frontend *fe;
 	struct xc2028_config cfg;
+	struct xc2028_ctrl ctl;
 
 	memset(&cfg, 0, sizeof(cfg));
 	cfg.i2c_adap  = &dev->i2c_adap[dev->def_i2c_bus];
 	cfg.i2c_addr  = addr;
 
+	memset(&ctl, 0, sizeof(ctl));
+	em28xx_setup_xc3028(dev, &ctl);
+	cfg.ctrl  = &ctl;
+
 	if (!dev->dvb->fe[0]) {
 		em28xx_errdev("/2: dvb frontend not attached. "
 				"Can't attach xc3028\n");
diff --git a/drivers/media/usb/em28xx/em28xx-video.c b/drivers/media/usb/em28xx/em28xx-video.c
index 9c4462868330..a1dcceb7b2c0 100644
--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -2100,54 +2100,6 @@ static struct video_device *em28xx_vdev_init(struct em28xx *dev,
 	return vfd;
 }
 
-static void em28xx_setup_xc3028(struct em28xx *dev, struct xc2028_ctrl *ctl)
-{
-	memset(ctl, 0, sizeof(*ctl));
-
-	ctl->fname   = XC2028_DEFAULT_FIRMWARE;
-	ctl->max_len = 64;
-	ctl->mts = em28xx_boards[dev->model].mts_firmware;
-
-	switch (dev->model) {
-	case EM2880_BOARD_EMPIRE_DUAL_TV:
-	case EM2880_BOARD_HAUPPAUGE_WINTV_HVR_900:
-	case EM2882_BOARD_TERRATEC_HYBRID_XS:
-		ctl->demod = XC3028_FE_ZARLINK456;
-		break;
-	case EM2880_BOARD_TERRATEC_HYBRID_XS:
-	case EM2880_BOARD_TERRATEC_HYBRID_XS_FR:
-	case EM2881_BOARD_PINNACLE_HYBRID_PRO:
-		ctl->demod = XC3028_FE_ZARLINK456;
-		break;
-	case EM2880_BOARD_HAUPPAUGE_WINTV_HVR_900_R2:
-	case EM2882_BOARD_PINNACLE_HYBRID_PRO_330E:
-		ctl->demod = XC3028_FE_DEFAULT;
-		break;
-	case EM2880_BOARD_AMD_ATI_TV_WONDER_HD_600:
-		ctl->demod = XC3028_FE_DEFAULT;
-		ctl->fname = XC3028L_DEFAULT_FIRMWARE;
-		break;
-	case EM2883_BOARD_HAUPPAUGE_WINTV_HVR_850:
-	case EM2883_BOARD_HAUPPAUGE_WINTV_HVR_950:
-	case EM2880_BOARD_PINNACLE_PCTV_HD_PRO:
-		/* FIXME: Better to specify the needed IF */
-		ctl->demod = XC3028_FE_DEFAULT;
-		break;
-	case EM2883_BOARD_KWORLD_HYBRID_330U:
-	case EM2882_BOARD_DIKOM_DK300:
-	case EM2882_BOARD_KWORLD_VS_DVBT:
-		ctl->demod = XC3028_FE_CHINA;
-		ctl->fname = XC2028_DEFAULT_FIRMWARE;
-		break;
-	case EM2882_BOARD_EVGA_INDTUBE:
-		ctl->demod = XC3028_FE_CHINA;
-		ctl->fname = XC3028L_DEFAULT_FIRMWARE;
-		break;
-	default:
-		ctl->demod = XC3028_FE_OREN538;
-	}
-}
-
 static void em28xx_tuner_setup(struct em28xx *dev)
 {
 	struct tuner_setup           tun_setup;
diff --git a/drivers/media/usb/em28xx/em28xx.h b/drivers/media/usb/em28xx/em28xx.h
index e76f993e3195..5d5d1b6f0294 100644
--- a/drivers/media/usb/em28xx/em28xx.h
+++ b/drivers/media/usb/em28xx/em28xx.h
@@ -762,6 +762,7 @@ void em28xx_close_extension(struct em28xx *dev);
 extern struct em28xx_board em28xx_boards[];
 extern struct usb_device_id em28xx_id_table[];
 int em28xx_tuner_callback(void *ptr, int component, int command, int arg);
+void em28xx_setup_xc3028(struct em28xx *dev, struct xc2028_ctrl *ctl);
 void em28xx_release_resources(struct em28xx *dev);
 
 /* Provided by em28xx-camera.c */
-- 
1.8.3.1

