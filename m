Return-path: <linux-media-owner@vger.kernel.org>
Received: from viridian.itc.Virginia.EDU ([128.143.12.139]:41698 "EHLO
	viridian.itc.virginia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754516Ab2KSSiH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Nov 2012 13:38:07 -0500
From: Bill Pemberton <wfp5p@virginia.edu>
To: gregkh@linuxfoundation.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Heungjun Kim <riverful.kim@samsung.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kamil Debski <k.debski@samsung.com>,
	Jeongtae Park <jtp.park@samsung.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	=?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>,
	linux-media@vger.kernel.org, mjpeg-users@lists.sourceforge.net,
	linux-arm-kernel@lists.infradead.org
Subject: =?UTF-8?q?=5BPATCH=20133/493=5D=20remove=20use=20of=20=5F=5Fdevexit=5Fp?=
Date: Mon, 19 Nov 2012 13:21:22 -0500
Message-Id: <1353349642-3677-133-git-send-email-wfp5p@virginia.edu>
In-Reply-To: <1353349642-3677-1-git-send-email-wfp5p@virginia.edu>
References: <1353349642-3677-1-git-send-email-wfp5p@virginia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

CONFIG_HOTPLUG is going away as an option so __devexit_p is no longer
needed.

Signed-off-by: Bill Pemberton <wfp5p@virginia.edu>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org> 
Cc: Kyungmin Park <kyungmin.park@samsung.com> 
Cc: Heungjun Kim <riverful.kim@samsung.com> 
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com> 
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com> 
Cc: Kamil Debski <k.debski@samsung.com> 
Cc: Jeongtae Park <jtp.park@samsung.com> 
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com> 
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de> 
Cc: Maxim Levitsky <maximlevitsky@gmail.com> 
Cc: "David Härdeman" <david@hardeman.nu> 
Cc: linux-media@vger.kernel.org 
Cc: mjpeg-users@lists.sourceforge.net 
Cc: linux-arm-kernel@lists.infradead.org 
---
 drivers/media/i2c/adv7180.c                              | 2 +-
 drivers/media/i2c/adv7183.c                              | 2 +-
 drivers/media/i2c/as3645a.c                              | 2 +-
 drivers/media/i2c/m5mols/m5mols_core.c                   | 2 +-
 drivers/media/i2c/vs6624.c                               | 2 +-
 drivers/media/pci/bt8xx/bttv-driver.c                    | 2 +-
 drivers/media/pci/cx23885/cx23885-core.c                 | 2 +-
 drivers/media/pci/cx25821/cx25821-core.c                 | 2 +-
 drivers/media/pci/cx88/cx88-alsa.c                       | 2 +-
 drivers/media/pci/cx88/cx88-mpeg.c                       | 2 +-
 drivers/media/pci/cx88/cx88-video.c                      | 2 +-
 drivers/media/pci/ddbridge/ddbridge-core.c               | 2 +-
 drivers/media/pci/dm1105/dm1105.c                        | 2 +-
 drivers/media/pci/meye/meye.c                            | 2 +-
 drivers/media/pci/ngene/ngene-cards.c                    | 2 +-
 drivers/media/pci/pluto2/pluto2.c                        | 2 +-
 drivers/media/pci/pt1/pt1.c                              | 2 +-
 drivers/media/pci/saa7134/saa7134-core.c                 | 2 +-
 drivers/media/pci/saa7164/saa7164-core.c                 | 2 +-
 drivers/media/pci/sta2x11/sta2x11_vip.c                  | 2 +-
 drivers/media/pci/ttpci/av7110.c                         | 2 +-
 drivers/media/pci/zoran/zoran_card.c                     | 2 +-
 drivers/media/platform/blackfin/bfin_capture.c           | 2 +-
 drivers/media/platform/coda.c                            | 2 +-
 drivers/media/platform/davinci/dm355_ccdc.c              | 2 +-
 drivers/media/platform/davinci/dm644x_ccdc.c             | 2 +-
 drivers/media/platform/davinci/isif.c                    | 2 +-
 drivers/media/platform/davinci/vpbe_display.c            | 2 +-
 drivers/media/platform/davinci/vpfe_capture.c            | 2 +-
 drivers/media/platform/davinci/vpif.c                    | 2 +-
 drivers/media/platform/davinci/vpss.c                    | 2 +-
 drivers/media/platform/exynos-gsc/gsc-core.c             | 2 +-
 drivers/media/platform/fsl-viu.c                         | 2 +-
 drivers/media/platform/omap3isp/isp.c                    | 2 +-
 drivers/media/platform/s5p-fimc/fimc-core.c              | 2 +-
 drivers/media/platform/s5p-fimc/fimc-lite.c              | 2 +-
 drivers/media/platform/s5p-fimc/fimc-mdevice.c           | 2 +-
 drivers/media/platform/s5p-fimc/mipi-csis.c              | 2 +-
 drivers/media/platform/s5p-mfc/s5p_mfc.c                 | 2 +-
 drivers/media/platform/s5p-tv/hdmi_drv.c                 | 2 +-
 drivers/media/platform/s5p-tv/hdmiphy_drv.c              | 2 +-
 drivers/media/platform/s5p-tv/mixer_drv.c                | 2 +-
 drivers/media/platform/s5p-tv/sdo_drv.c                  | 2 +-
 drivers/media/platform/s5p-tv/sii9234_drv.c              | 2 +-
 drivers/media/platform/sh_vou.c                          | 2 +-
 drivers/media/platform/soc_camera/atmel-isi.c            | 2 +-
 drivers/media/platform/soc_camera/mx2_camera.c           | 2 +-
 drivers/media/platform/soc_camera/mx3_camera.c           | 2 +-
 drivers/media/platform/soc_camera/pxa_camera.c           | 2 +-
 drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c | 2 +-
 drivers/media/platform/soc_camera/sh_mobile_csi2.c       | 2 +-
 drivers/media/platform/soc_camera/soc_camera.c           | 2 +-
 drivers/media/platform/timblogiw.c                       | 2 +-
 drivers/media/radio/radio-maxiradio.c                    | 2 +-
 drivers/media/radio/radio-sf16fmr2.c                     | 4 ++--
 drivers/media/radio/radio-tea5764.c                      | 2 +-
 drivers/media/radio/radio-timb.c                         | 2 +-
 drivers/media/radio/radio-wl1273.c                       | 2 +-
 drivers/media/radio/saa7706h.c                           | 2 +-
 drivers/media/radio/si470x/radio-si470x-i2c.c            | 2 +-
 drivers/media/radio/tef6862.c                            | 2 +-
 drivers/media/rc/ene_ir.c                                | 2 +-
 drivers/media/rc/fintek-cir.c                            | 2 +-
 drivers/media/rc/gpio-ir-recv.c                          | 2 +-
 drivers/media/rc/iguanair.c                              | 2 +-
 drivers/media/rc/imon.c                                  | 2 +-
 drivers/media/rc/ite-cir.c                               | 2 +-
 drivers/media/rc/mceusb.c                                | 2 +-
 drivers/media/rc/nuvoton-cir.c                           | 2 +-
 drivers/media/rc/redrat3.c                               | 2 +-
 drivers/media/rc/ttusbir.c                               | 2 +-
 drivers/media/rc/winbond-cir.c                           | 2 +-
 drivers/media/usb/usbvision/usbvision-video.c            | 2 +-
 73 files changed, 74 insertions(+), 74 deletions(-)

diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
index 45ecf8d..801e9be 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -652,7 +652,7 @@ static struct i2c_driver adv7180_driver = {
 		   .name = KBUILD_MODNAME,
 		   },
 	.probe = adv7180_probe,
-	.remove = __devexit_p(adv7180_remove),
+	.remove = adv7180_remove,
 #ifdef CONFIG_PM
 	.suspend = adv7180_suspend,
 	.resume = adv7180_resume,
diff --git a/drivers/media/i2c/adv7183.c b/drivers/media/i2c/adv7183.c
index e1d4c89..bd2c8f2 100644
--- a/drivers/media/i2c/adv7183.c
+++ b/drivers/media/i2c/adv7183.c
@@ -677,7 +677,7 @@ static struct i2c_driver adv7183_driver = {
 		.name   = "adv7183",
 	},
 	.probe          = adv7183_probe,
-	.remove         = __devexit_p(adv7183_remove),
+	.remove         = adv7183_remove,
 	.id_table       = adv7183_id,
 };
 
diff --git a/drivers/media/i2c/as3645a.c b/drivers/media/i2c/as3645a.c
index 3bfdbf9..fc8ad56 100644
--- a/drivers/media/i2c/as3645a.c
+++ b/drivers/media/i2c/as3645a.c
@@ -877,7 +877,7 @@ static struct i2c_driver as3645a_i2c_driver = {
 		.pm   = &as3645a_pm_ops,
 	},
 	.probe	= as3645a_probe,
-	.remove	= __devexit_p(as3645a_remove),
+	.remove	= as3645a_remove,
 	.id_table = as3645a_id_table,
 };
 
diff --git a/drivers/media/i2c/m5mols/m5mols_core.c b/drivers/media/i2c/m5mols/m5mols_core.c
index 8131d65..7877a2a 100644
--- a/drivers/media/i2c/m5mols/m5mols_core.c
+++ b/drivers/media/i2c/m5mols/m5mols_core.c
@@ -1045,7 +1045,7 @@ static struct i2c_driver m5mols_i2c_driver = {
 		.name	= MODULE_NAME,
 	},
 	.probe		= m5mols_probe,
-	.remove		= __devexit_p(m5mols_remove),
+	.remove		= m5mols_remove,
 	.id_table	= m5mols_id,
 };
 
diff --git a/drivers/media/i2c/vs6624.c b/drivers/media/i2c/vs6624.c
index 42ae9dc..165c44a 100644
--- a/drivers/media/i2c/vs6624.c
+++ b/drivers/media/i2c/vs6624.c
@@ -906,7 +906,7 @@ static struct i2c_driver vs6624_driver = {
 		.name   = "vs6624",
 	},
 	.probe          = vs6624_probe,
-	.remove         = __devexit_p(vs6624_remove),
+	.remove         = vs6624_remove,
 	.id_table       = vs6624_id,
 };
 
diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
index 56c6c77..47a413b 100644
--- a/drivers/media/pci/bt8xx/bttv-driver.c
+++ b/drivers/media/pci/bt8xx/bttv-driver.c
@@ -4599,7 +4599,7 @@ static struct pci_driver bttv_pci_driver = {
 	.name     = "bttv",
 	.id_table = bttv_pci_tbl,
 	.probe    = bttv_probe,
-	.remove   = __devexit_p(bttv_remove),
+	.remove   = bttv_remove,
 #ifdef CONFIG_PM
 	.suspend  = bttv_suspend,
 	.resume   = bttv_resume,
diff --git a/drivers/media/pci/cx23885/cx23885-core.c b/drivers/media/pci/cx23885/cx23885-core.c
index 697728f..96166ae 100644
--- a/drivers/media/pci/cx23885/cx23885-core.c
+++ b/drivers/media/pci/cx23885/cx23885-core.c
@@ -2212,7 +2212,7 @@ static struct pci_driver cx23885_pci_driver = {
 	.name     = "cx23885",
 	.id_table = cx23885_pci_tbl,
 	.probe    = cx23885_initdev,
-	.remove   = __devexit_p(cx23885_finidev),
+	.remove   = cx23885_finidev,
 	/* TODO */
 	.suspend  = NULL,
 	.resume   = NULL,
diff --git a/drivers/media/pci/cx25821/cx25821-core.c b/drivers/media/pci/cx25821/cx25821-core.c
index f11f6f0..6b8c416 100644
--- a/drivers/media/pci/cx25821/cx25821-core.c
+++ b/drivers/media/pci/cx25821/cx25821-core.c
@@ -1478,7 +1478,7 @@ static struct pci_driver cx25821_pci_driver = {
 	.name = "cx25821",
 	.id_table = cx25821_pci_tbl,
 	.probe = cx25821_initdev,
-	.remove = __devexit_p(cx25821_finidev),
+	.remove = cx25821_finidev,
 	/* TODO */
 	.suspend = NULL,
 	.resume = NULL,
diff --git a/drivers/media/pci/cx88/cx88-alsa.c b/drivers/media/pci/cx88/cx88-alsa.c
index 3aa6856..0934390 100644
--- a/drivers/media/pci/cx88/cx88-alsa.c
+++ b/drivers/media/pci/cx88/cx88-alsa.c
@@ -946,7 +946,7 @@ static struct pci_driver cx88_audio_pci_driver = {
 	.name     = "cx88_audio",
 	.id_table = cx88_audio_pci_tbl,
 	.probe    = cx88_audio_initdev,
-	.remove   = __devexit_p(cx88_audio_finidev),
+	.remove   = cx88_audio_finidev,
 };
 
 /****************************************************************************
diff --git a/drivers/media/pci/cx88/cx88-mpeg.c b/drivers/media/pci/cx88/cx88-mpeg.c
index d154bc1..ef5656f 100644
--- a/drivers/media/pci/cx88/cx88-mpeg.c
+++ b/drivers/media/pci/cx88/cx88-mpeg.c
@@ -896,7 +896,7 @@ static struct pci_driver cx8802_pci_driver = {
 	.name     = "cx88-mpeg driver manager",
 	.id_table = cx8802_pci_tbl,
 	.probe    = cx8802_probe,
-	.remove   = __devexit_p(cx8802_remove),
+	.remove   = cx8802_remove,
 };
 
 static int __init cx8802_init(void)
diff --git a/drivers/media/pci/cx88/cx88-video.c b/drivers/media/pci/cx88/cx88-video.c
index 0517145..657714b 100644
--- a/drivers/media/pci/cx88/cx88-video.c
+++ b/drivers/media/pci/cx88/cx88-video.c
@@ -2052,7 +2052,7 @@ static struct pci_driver cx8800_pci_driver = {
 	.name     = "cx8800",
 	.id_table = cx8800_pci_tbl,
 	.probe    = cx8800_initdev,
-	.remove   = __devexit_p(cx8800_finidev),
+	.remove   = cx8800_finidev,
 #ifdef CONFIG_PM
 	.suspend  = cx8800_suspend,
 	.resume   = cx8800_resume,
diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index feff57e..47ed48f 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -1696,7 +1696,7 @@ static struct pci_driver ddb_pci_driver = {
 	.name        = "DDBridge",
 	.id_table    = ddb_id_tbl,
 	.probe       = ddb_probe,
-	.remove      = __devexit_p(ddb_remove),
+	.remove      = ddb_remove,
 };
 
 static __init int module_init_ddbridge(void)
diff --git a/drivers/media/pci/dm1105/dm1105.c b/drivers/media/pci/dm1105/dm1105.c
index a609b3a..04e24bb 100644
--- a/drivers/media/pci/dm1105/dm1105.c
+++ b/drivers/media/pci/dm1105/dm1105.c
@@ -1227,7 +1227,7 @@ static struct pci_driver dm1105_driver = {
 	.name = DRIVER_NAME,
 	.id_table = dm1105_id_table,
 	.probe = dm1105_probe,
-	.remove = __devexit_p(dm1105_remove),
+	.remove = dm1105_remove,
 };
 
 static int __init dm1105_init(void)
diff --git a/drivers/media/pci/meye/meye.c b/drivers/media/pci/meye/meye.c
index e5a76da..215e0a9 100644
--- a/drivers/media/pci/meye/meye.c
+++ b/drivers/media/pci/meye/meye.c
@@ -1935,7 +1935,7 @@ static struct pci_driver meye_driver = {
 	.name		= "meye",
 	.id_table	= meye_pci_tbl,
 	.probe		= meye_probe,
-	.remove		= __devexit_p(meye_remove),
+	.remove		= meye_remove,
 #ifdef CONFIG_PM
 	.suspend	= meye_suspend,
 	.resume		= meye_resume,
diff --git a/drivers/media/pci/ngene/ngene-cards.c b/drivers/media/pci/ngene/ngene-cards.c
index 96a13ed..09c02b5 100644
--- a/drivers/media/pci/ngene/ngene-cards.c
+++ b/drivers/media/pci/ngene/ngene-cards.c
@@ -798,7 +798,7 @@ static struct pci_driver ngene_pci_driver = {
 	.name        = "ngene",
 	.id_table    = ngene_id_tbl,
 	.probe       = ngene_probe,
-	.remove      = __devexit_p(ngene_remove),
+	.remove      = ngene_remove,
 	.err_handler = &ngene_errors,
 	.shutdown    = ngene_shutdown,
 };
diff --git a/drivers/media/pci/pluto2/pluto2.c b/drivers/media/pci/pluto2/pluto2.c
index f148b19..e4edb5f 100644
--- a/drivers/media/pci/pluto2/pluto2.c
+++ b/drivers/media/pci/pluto2/pluto2.c
@@ -794,7 +794,7 @@ static struct pci_driver pluto2_driver = {
 	.name = DRIVER_NAME,
 	.id_table = pluto2_id_table,
 	.probe = pluto2_probe,
-	.remove = __devexit_p(pluto2_remove),
+	.remove = pluto2_remove,
 };
 
 static int __init pluto2_init(void)
diff --git a/drivers/media/pci/pt1/pt1.c b/drivers/media/pci/pt1/pt1.c
index 15b35c4..875e6dc 100644
--- a/drivers/media/pci/pt1/pt1.c
+++ b/drivers/media/pci/pt1/pt1.c
@@ -1222,7 +1222,7 @@ MODULE_DEVICE_TABLE(pci, pt1_id_table);
 static struct pci_driver pt1_driver = {
 	.name		= DRIVER_NAME,
 	.probe		= pt1_probe,
-	.remove		= __devexit_p(pt1_remove),
+	.remove		= pt1_remove,
 	.id_table	= pt1_id_table,
 };
 
diff --git a/drivers/media/pci/saa7134/saa7134-core.c b/drivers/media/pci/saa7134/saa7134-core.c
index f2b37e0..7d1cf2c 100644
--- a/drivers/media/pci/saa7134/saa7134-core.c
+++ b/drivers/media/pci/saa7134/saa7134-core.c
@@ -1323,7 +1323,7 @@ static struct pci_driver saa7134_pci_driver = {
 	.name     = "saa7134",
 	.id_table = saa7134_pci_tbl,
 	.probe    = saa7134_initdev,
-	.remove   = __devexit_p(saa7134_finidev),
+	.remove   = saa7134_finidev,
 #ifdef CONFIG_PM
 	.suspend  = saa7134_suspend,
 	.resume   = saa7134_resume
diff --git a/drivers/media/pci/saa7164/saa7164-core.c b/drivers/media/pci/saa7164/saa7164-core.c
index 2c9ad87..a6e6e60 100644
--- a/drivers/media/pci/saa7164/saa7164-core.c
+++ b/drivers/media/pci/saa7164/saa7164-core.c
@@ -1459,7 +1459,7 @@ static struct pci_driver saa7164_pci_driver = {
 	.name     = "saa7164",
 	.id_table = saa7164_pci_tbl,
 	.probe    = saa7164_initdev,
-	.remove   = __devexit_p(saa7164_finidev),
+	.remove   = saa7164_finidev,
 	/* TODO */
 	.suspend  = NULL,
 	.resume   = NULL,
diff --git a/drivers/media/pci/sta2x11/sta2x11_vip.c b/drivers/media/pci/sta2x11/sta2x11_vip.c
index 4c10205..38ccdf2 100644
--- a/drivers/media/pci/sta2x11/sta2x11_vip.c
+++ b/drivers/media/pci/sta2x11/sta2x11_vip.c
@@ -1517,7 +1517,7 @@ static DEFINE_PCI_DEVICE_TABLE(sta2x11_vip_pci_tbl) = {
 static struct pci_driver sta2x11_vip_driver = {
 	.name = DRV_NAME,
 	.probe = sta2x11_vip_init_one,
-	.remove = __devexit_p(sta2x11_vip_remove_one),
+	.remove = sta2x11_vip_remove_one,
 	.id_table = sta2x11_vip_pci_tbl,
 #ifdef CONFIG_PM
 	.suspend = sta2x11_vip_suspend,
diff --git a/drivers/media/pci/ttpci/av7110.c b/drivers/media/pci/ttpci/av7110.c
index 4bd8bd5..66fbd05 100644
--- a/drivers/media/pci/ttpci/av7110.c
+++ b/drivers/media/pci/ttpci/av7110.c
@@ -2910,7 +2910,7 @@ static struct saa7146_extension av7110_extension_driver = {
 	.module		= THIS_MODULE,
 	.pci_tbl	= &pci_tbl[0],
 	.attach		= av7110_attach,
-	.detach		= __devexit_p(av7110_detach),
+	.detach		= av7110_detach,
 
 	.irq_mask	= MASK_19 | MASK_03 | MASK_10,
 	.irq_func	= av7110_irq,
diff --git a/drivers/media/pci/zoran/zoran_card.c b/drivers/media/pci/zoran/zoran_card.c
index fffc54b..bca101c 100644
--- a/drivers/media/pci/zoran/zoran_card.c
+++ b/drivers/media/pci/zoran/zoran_card.c
@@ -1459,7 +1459,7 @@ static struct pci_driver zoran_driver = {
 	.name = "zr36067",
 	.id_table = zr36067_pci_tbl,
 	.probe = zoran_probe,
-	.remove = __devexit_p(zoran_remove),
+	.remove = zoran_remove,
 };
 
 static int __init zoran_init(void)
diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
index cb2eb26..b7c8f96 100644
--- a/drivers/media/platform/blackfin/bfin_capture.c
+++ b/drivers/media/platform/blackfin/bfin_capture.c
@@ -1048,7 +1048,7 @@ static struct platform_driver bcap_driver = {
 		.owner = THIS_MODULE,
 	},
 	.probe = bcap_probe,
-	.remove = __devexit_p(bcap_remove),
+	.remove = bcap_remove,
 };
 
 static __init int bcap_init(void)
diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index cd04ae2..ec5bc4a 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -2033,7 +2033,7 @@ static int coda_remove(struct platform_device *pdev)
 
 static struct platform_driver coda_driver = {
 	.probe	= coda_probe,
-	.remove	= __devexit_p(coda_remove),
+	.remove	= coda_remove,
 	.driver	= {
 		.name	= CODA_NAME,
 		.owner	= THIS_MODULE,
diff --git a/drivers/media/platform/davinci/dm355_ccdc.c b/drivers/media/platform/davinci/dm355_ccdc.c
index ce0e413..5c02672 100644
--- a/drivers/media/platform/davinci/dm355_ccdc.c
+++ b/drivers/media/platform/davinci/dm355_ccdc.c
@@ -1065,7 +1065,7 @@ static struct platform_driver dm355_ccdc_driver = {
 		.name	= "dm355_ccdc",
 		.owner = THIS_MODULE,
 	},
-	.remove = __devexit_p(dm355_ccdc_remove),
+	.remove = dm355_ccdc_remove,
 	.probe = dm355_ccdc_probe,
 };
 
diff --git a/drivers/media/platform/davinci/dm644x_ccdc.c b/drivers/media/platform/davinci/dm644x_ccdc.c
index ee7942b..07639f4 100644
--- a/drivers/media/platform/davinci/dm644x_ccdc.c
+++ b/drivers/media/platform/davinci/dm644x_ccdc.c
@@ -1074,7 +1074,7 @@ static struct platform_driver dm644x_ccdc_driver = {
 		.owner = THIS_MODULE,
 		.pm = &dm644x_ccdc_pm_ops,
 	},
-	.remove = __devexit_p(dm644x_ccdc_remove),
+	.remove = dm644x_ccdc_remove,
 	.probe = dm644x_ccdc_probe,
 };
 
diff --git a/drivers/media/platform/davinci/isif.c b/drivers/media/platform/davinci/isif.c
index b99d542..b20e2a7 100644
--- a/drivers/media/platform/davinci/isif.c
+++ b/drivers/media/platform/davinci/isif.c
@@ -1153,7 +1153,7 @@ static struct platform_driver isif_driver = {
 		.name	= "isif",
 		.owner = THIS_MODULE,
 	},
-	.remove = __devexit_p(isif_remove),
+	.remove = isif_remove,
 	.probe = isif_probe,
 };
 
diff --git a/drivers/media/platform/davinci/vpbe_display.c b/drivers/media/platform/davinci/vpbe_display.c
index 161c776..e51302e 100644
--- a/drivers/media/platform/davinci/vpbe_display.c
+++ b/drivers/media/platform/davinci/vpbe_display.c
@@ -1827,7 +1827,7 @@ static struct platform_driver vpbe_display_driver = {
 		.bus = &platform_bus_type,
 	},
 	.probe = vpbe_display_probe,
-	.remove = __devexit_p(vpbe_display_remove),
+	.remove = vpbe_display_remove,
 };
 
 module_platform_driver(vpbe_display_driver);
diff --git a/drivers/media/platform/davinci/vpfe_capture.c b/drivers/media/platform/davinci/vpfe_capture.c
index 8be492c..79abcca 100644
--- a/drivers/media/platform/davinci/vpfe_capture.c
+++ b/drivers/media/platform/davinci/vpfe_capture.c
@@ -2075,7 +2075,7 @@ static struct platform_driver vpfe_driver = {
 		.pm = &vpfe_dev_pm_ops,
 	},
 	.probe = vpfe_probe,
-	.remove = __devexit_p(vpfe_remove),
+	.remove = vpfe_remove,
 };
 
 module_platform_driver(vpfe_driver);
diff --git a/drivers/media/platform/davinci/vpif.c b/drivers/media/platform/davinci/vpif.c
index cff3c0a..ed00bfd 100644
--- a/drivers/media/platform/davinci/vpif.c
+++ b/drivers/media/platform/davinci/vpif.c
@@ -498,7 +498,7 @@ static struct platform_driver vpif_driver = {
 		.owner = THIS_MODULE,
 		.pm	= vpif_pm_ops,
 	},
-	.remove = __devexit_p(vpif_remove),
+	.remove = vpif_remove,
 	.probe = vpif_probe,
 };
 
diff --git a/drivers/media/platform/davinci/vpss.c b/drivers/media/platform/davinci/vpss.c
index 146e4b0..94ed1a3 100644
--- a/drivers/media/platform/davinci/vpss.c
+++ b/drivers/media/platform/davinci/vpss.c
@@ -465,7 +465,7 @@ static struct platform_driver vpss_driver = {
 		.name	= "vpss",
 		.owner = THIS_MODULE,
 	},
-	.remove = __devexit_p(vpss_remove),
+	.remove = vpss_remove,
 	.probe = vpss_probe,
 };
 
diff --git a/drivers/media/platform/exynos-gsc/gsc-core.c b/drivers/media/platform/exynos-gsc/gsc-core.c
index bfec9e6..8d0263c 100644
--- a/drivers/media/platform/exynos-gsc/gsc-core.c
+++ b/drivers/media/platform/exynos-gsc/gsc-core.c
@@ -1235,7 +1235,7 @@ static const struct dev_pm_ops gsc_pm_ops = {
 
 static struct platform_driver gsc_driver = {
 	.probe		= gsc_probe,
-	.remove	= __devexit_p(gsc_remove),
+	.remove	= gsc_remove,
 	.id_table	= gsc_driver_ids,
 	.driver = {
 		.name	= GSC_MODULE_NAME,
diff --git a/drivers/media/platform/fsl-viu.c b/drivers/media/platform/fsl-viu.c
index 31ac4dc..e577809 100644
--- a/drivers/media/platform/fsl-viu.c
+++ b/drivers/media/platform/fsl-viu.c
@@ -1670,7 +1670,7 @@ MODULE_DEVICE_TABLE(of, mpc512x_viu_of_match);
 
 static struct platform_driver viu_of_platform_driver = {
 	.probe = viu_of_probe,
-	.remove = __devexit_p(viu_of_remove),
+	.remove = viu_of_remove,
 #ifdef CONFIG_PM
 	.suspend = viu_suspend,
 	.resume = viu_resume,
diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 99640d8..38db712 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -2228,7 +2228,7 @@ MODULE_DEVICE_TABLE(platform, omap3isp_id_table);
 
 static struct platform_driver omap3isp_driver = {
 	.probe = isp_probe,
-	.remove = __devexit_p(isp_remove),
+	.remove = isp_remove,
 	.id_table = omap3isp_id_table,
 	.driver = {
 		.owner = THIS_MODULE,
diff --git a/drivers/media/platform/s5p-fimc/fimc-core.c b/drivers/media/platform/s5p-fimc/fimc-core.c
index 8d0d2b9..fe7f061 100644
--- a/drivers/media/platform/s5p-fimc/fimc-core.c
+++ b/drivers/media/platform/s5p-fimc/fimc-core.c
@@ -1234,7 +1234,7 @@ static const struct dev_pm_ops fimc_pm_ops = {
 
 static struct platform_driver fimc_driver = {
 	.probe		= fimc_probe,
-	.remove		= __devexit_p(fimc_remove),
+	.remove		= fimc_remove,
 	.id_table	= fimc_driver_ids,
 	.driver = {
 		.name	= FIMC_MODULE_NAME,
diff --git a/drivers/media/platform/s5p-fimc/fimc-lite.c b/drivers/media/platform/s5p-fimc/fimc-lite.c
index 70bcf39..d460765 100644
--- a/drivers/media/platform/s5p-fimc/fimc-lite.c
+++ b/drivers/media/platform/s5p-fimc/fimc-lite.c
@@ -1591,7 +1591,7 @@ static const struct dev_pm_ops fimc_lite_pm_ops = {
 
 static struct platform_driver fimc_lite_driver = {
 	.probe		= fimc_lite_probe,
-	.remove		= __devexit_p(fimc_lite_remove),
+	.remove		= fimc_lite_remove,
 	.id_table	= fimc_lite_driver_ids,
 	.driver = {
 		.name		= FIMC_LITE_DRV_NAME,
diff --git a/drivers/media/platform/s5p-fimc/fimc-mdevice.c b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
index 80ada58..75c8688 100644
--- a/drivers/media/platform/s5p-fimc/fimc-mdevice.c
+++ b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
@@ -1016,7 +1016,7 @@ static int __devexit fimc_md_remove(struct platform_device *pdev)
 
 static struct platform_driver fimc_md_driver = {
 	.probe		= fimc_md_probe,
-	.remove		= __devexit_p(fimc_md_remove),
+	.remove		= fimc_md_remove,
 	.driver = {
 		.name	= "s5p-fimc-md",
 		.owner	= THIS_MODULE,
diff --git a/drivers/media/platform/s5p-fimc/mipi-csis.c b/drivers/media/platform/s5p-fimc/mipi-csis.c
index 4c961b1..46e987e 100644
--- a/drivers/media/platform/s5p-fimc/mipi-csis.c
+++ b/drivers/media/platform/s5p-fimc/mipi-csis.c
@@ -876,7 +876,7 @@ static const struct dev_pm_ops s5pcsis_pm_ops = {
 
 static struct platform_driver s5pcsis_driver = {
 	.probe		= s5pcsis_probe,
-	.remove		= __devexit_p(s5pcsis_remove),
+	.remove		= s5pcsis_remove,
 	.driver		= {
 		.name	= CSIS_DRIVER_NAME,
 		.owner	= THIS_MODULE,
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index 130f4ac..c4cc37f 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -1371,7 +1371,7 @@ MODULE_DEVICE_TABLE(platform, mfc_driver_ids);
 
 static struct platform_driver s5p_mfc_driver = {
 	.probe		= s5p_mfc_probe,
-	.remove		= __devexit_p(s5p_mfc_remove),
+	.remove		= s5p_mfc_remove,
 	.id_table	= mfc_driver_ids,
 	.driver	= {
 		.name	= S5P_MFC_NAME,
diff --git a/drivers/media/platform/s5p-tv/hdmi_drv.c b/drivers/media/platform/s5p-tv/hdmi_drv.c
index 8a9cf43..b8d1d86 100644
--- a/drivers/media/platform/s5p-tv/hdmi_drv.c
+++ b/drivers/media/platform/s5p-tv/hdmi_drv.c
@@ -997,7 +997,7 @@ static int __devexit hdmi_remove(struct platform_device *pdev)
 
 static struct platform_driver hdmi_driver __refdata = {
 	.probe = hdmi_probe,
-	.remove = __devexit_p(hdmi_remove),
+	.remove = hdmi_remove,
 	.id_table = hdmi_driver_types,
 	.driver = {
 		.name = "s5p-hdmi",
diff --git a/drivers/media/platform/s5p-tv/hdmiphy_drv.c b/drivers/media/platform/s5p-tv/hdmiphy_drv.c
index f67b386..3f0142b 100644
--- a/drivers/media/platform/s5p-tv/hdmiphy_drv.c
+++ b/drivers/media/platform/s5p-tv/hdmiphy_drv.c
@@ -322,7 +322,7 @@ static struct i2c_driver hdmiphy_driver = {
 		.owner	= THIS_MODULE,
 	},
 	.probe		= hdmiphy_probe,
-	.remove		= __devexit_p(hdmiphy_remove),
+	.remove		= hdmiphy_remove,
 	.id_table = hdmiphy_id,
 };
 
diff --git a/drivers/media/platform/s5p-tv/mixer_drv.c b/drivers/media/platform/s5p-tv/mixer_drv.c
index ca0f297..7c4b945 100644
--- a/drivers/media/platform/s5p-tv/mixer_drv.c
+++ b/drivers/media/platform/s5p-tv/mixer_drv.c
@@ -450,7 +450,7 @@ static int __devexit mxr_remove(struct platform_device *pdev)
 
 static struct platform_driver mxr_driver __refdata = {
 	.probe = mxr_probe,
-	.remove = __devexit_p(mxr_remove),
+	.remove = mxr_remove,
 	.driver = {
 		.name = MXR_DRIVER_NAME,
 		.owner = THIS_MODULE,
diff --git a/drivers/media/platform/s5p-tv/sdo_drv.c b/drivers/media/platform/s5p-tv/sdo_drv.c
index ad68bbe..ebe24b7 100644
--- a/drivers/media/platform/s5p-tv/sdo_drv.c
+++ b/drivers/media/platform/s5p-tv/sdo_drv.c
@@ -437,7 +437,7 @@ static int __devexit sdo_remove(struct platform_device *pdev)
 
 static struct platform_driver sdo_driver __refdata = {
 	.probe = sdo_probe,
-	.remove = __devexit_p(sdo_remove),
+	.remove = sdo_remove,
 	.driver = {
 		.name = "s5p-sdo",
 		.owner = THIS_MODULE,
diff --git a/drivers/media/platform/s5p-tv/sii9234_drv.c b/drivers/media/platform/s5p-tv/sii9234_drv.c
index 716d484..ec33e66 100644
--- a/drivers/media/platform/s5p-tv/sii9234_drv.c
+++ b/drivers/media/platform/s5p-tv/sii9234_drv.c
@@ -406,7 +406,7 @@ static struct i2c_driver sii9234_driver = {
 		.pm = &sii9234_pm_ops,
 	},
 	.probe		= sii9234_probe,
-	.remove		= __devexit_p(sii9234_remove),
+	.remove		= sii9234_remove,
 	.id_table = sii9234_id,
 };
 
diff --git a/drivers/media/platform/sh_vou.c b/drivers/media/platform/sh_vou.c
index 85fd312..5d609c1 100644
--- a/drivers/media/platform/sh_vou.c
+++ b/drivers/media/platform/sh_vou.c
@@ -1486,7 +1486,7 @@ static int __devexit sh_vou_remove(struct platform_device *pdev)
 }
 
 static struct platform_driver __refdata sh_vou = {
-	.remove  = __devexit_p(sh_vou_remove),
+	.remove  = sh_vou_remove,
 	.driver  = {
 		.name	= "sh-vou",
 		.owner	= THIS_MODULE,
diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
index 6274a91..e067da1 100644
--- a/drivers/media/platform/soc_camera/atmel-isi.c
+++ b/drivers/media/platform/soc_camera/atmel-isi.c
@@ -1074,7 +1074,7 @@ err_clk_prepare_pclk:
 
 static struct platform_driver atmel_isi_driver = {
 	.probe		= atmel_isi_probe,
-	.remove		= __devexit_p(atmel_isi_remove),
+	.remove		= atmel_isi_remove,
 	.driver		= {
 		.name = "atmel_isi",
 		.owner = THIS_MODULE,
diff --git a/drivers/media/platform/soc_camera/mx2_camera.c b/drivers/media/platform/soc_camera/mx2_camera.c
index e575ae8..ef65dda 100644
--- a/drivers/media/platform/soc_camera/mx2_camera.c
+++ b/drivers/media/platform/soc_camera/mx2_camera.c
@@ -1888,7 +1888,7 @@ static struct platform_driver mx2_camera_driver = {
 		.name	= MX2_CAM_DRV_NAME,
 	},
 	.id_table	= mx2_camera_devtype,
-	.remove		= __devexit_p(mx2_camera_remove),
+	.remove		= mx2_camera_remove,
 };
 
 
diff --git a/drivers/media/platform/soc_camera/mx3_camera.c b/drivers/media/platform/soc_camera/mx3_camera.c
index 64d39b1..fb12f6d 100644
--- a/drivers/media/platform/soc_camera/mx3_camera.c
+++ b/drivers/media/platform/soc_camera/mx3_camera.c
@@ -1278,7 +1278,7 @@ static struct platform_driver mx3_camera_driver = {
 		.name	= MX3_CAM_DRV_NAME,
 	},
 	.probe		= mx3_camera_probe,
-	.remove		= __devexit_p(mx3_camera_remove),
+	.remove		= mx3_camera_remove,
 };
 
 module_platform_driver(mx3_camera_driver);
diff --git a/drivers/media/platform/soc_camera/pxa_camera.c b/drivers/media/platform/soc_camera/pxa_camera.c
index 1e3776d..af23c7e 100644
--- a/drivers/media/platform/soc_camera/pxa_camera.c
+++ b/drivers/media/platform/soc_camera/pxa_camera.c
@@ -1840,7 +1840,7 @@ static struct platform_driver pxa_camera_driver = {
 		.pm	= &pxa_camera_pm,
 	},
 	.probe		= pxa_camera_probe,
-	.remove		= __devexit_p(pxa_camera_remove),
+	.remove		= pxa_camera_remove,
 };
 
 module_platform_driver(pxa_camera_driver);
diff --git a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
index 0a24253..6a402a7 100644
--- a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
+++ b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
@@ -2306,7 +2306,7 @@ static struct platform_driver sh_mobile_ceu_driver = {
 		.pm	= &sh_mobile_ceu_dev_pm_ops,
 	},
 	.probe		= sh_mobile_ceu_probe,
-	.remove		= __devexit_p(sh_mobile_ceu_remove),
+	.remove		= sh_mobile_ceu_remove,
 };
 
 static int __init sh_mobile_ceu_init(void)
diff --git a/drivers/media/platform/soc_camera/sh_mobile_csi2.c b/drivers/media/platform/soc_camera/sh_mobile_csi2.c
index 0528650..0d0344a 100644
--- a/drivers/media/platform/soc_camera/sh_mobile_csi2.c
+++ b/drivers/media/platform/soc_camera/sh_mobile_csi2.c
@@ -382,7 +382,7 @@ static __devexit int sh_csi2_remove(struct platform_device *pdev)
 }
 
 static struct platform_driver __refdata sh_csi2_pdrv = {
-	.remove	= __devexit_p(sh_csi2_remove),
+	.remove	= sh_csi2_remove,
 	.probe	= sh_csi2_probe,
 	.driver	= {
 		.name	= "sh-mobile-csi2",
diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index d3f0b84..27038af 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -1568,7 +1568,7 @@ static int __devexit soc_camera_pdrv_remove(struct platform_device *pdev)
 
 static struct platform_driver __refdata soc_camera_pdrv = {
 	.probe = soc_camera_pdrv_probe,
-	.remove  = __devexit_p(soc_camera_pdrv_remove),
+	.remove  = soc_camera_pdrv_remove,
 	.driver  = {
 		.name	= "soc-camera-pdrv",
 		.owner	= THIS_MODULE,
diff --git a/drivers/media/platform/timblogiw.c b/drivers/media/platform/timblogiw.c
index 02194c0..4a08bd2 100644
--- a/drivers/media/platform/timblogiw.c
+++ b/drivers/media/platform/timblogiw.c
@@ -869,7 +869,7 @@ static struct platform_driver timblogiw_platform_driver = {
 		.owner	= THIS_MODULE,
 	},
 	.probe		= timblogiw_probe,
-	.remove		= __devexit_p(timblogiw_remove),
+	.remove		= timblogiw_remove,
 };
 
 module_platform_driver(timblogiw_platform_driver);
diff --git a/drivers/media/radio/radio-maxiradio.c b/drivers/media/radio/radio-maxiradio.c
index b415211..5bfc1a2 100644
--- a/drivers/media/radio/radio-maxiradio.c
+++ b/drivers/media/radio/radio-maxiradio.c
@@ -196,7 +196,7 @@ static struct pci_driver maxiradio_driver = {
 	.name		= "radio-maxiradio",
 	.id_table	= maxiradio_pci_tbl,
 	.probe		= maxiradio_probe,
-	.remove		= __devexit_p(maxiradio_remove),
+	.remove		= maxiradio_remove,
 };
 
 static int __init maxiradio_init(void)
diff --git a/drivers/media/radio/radio-sf16fmr2.c b/drivers/media/radio/radio-sf16fmr2.c
index 4efcbec..354cb55 100644
--- a/drivers/media/radio/radio-sf16fmr2.c
+++ b/drivers/media/radio/radio-sf16fmr2.c
@@ -309,7 +309,7 @@ static void __devexit fmr2_pnp_remove(struct pnp_dev *pdev)
 
 struct isa_driver fmr2_isa_driver = {
 	.match		= fmr2_isa_match,
-	.remove		= __devexit_p(fmr2_isa_remove),
+	.remove		= fmr2_isa_remove,
 	.driver		= {
 		.name	= "radio-sf16fmr2",
 	},
@@ -319,7 +319,7 @@ struct pnp_driver fmr2_pnp_driver = {
 	.name		= "radio-sf16fmr2",
 	.id_table	= fmr2_pnp_ids,
 	.probe		= fmr2_pnp_probe,
-	.remove		= __devexit_p(fmr2_pnp_remove),
+	.remove		= fmr2_pnp_remove,
 };
 
 static int __init fmr2_init(void)
diff --git a/drivers/media/radio/radio-tea5764.c b/drivers/media/radio/radio-tea5764.c
index d0c9053..95812cb 100644
--- a/drivers/media/radio/radio-tea5764.c
+++ b/drivers/media/radio/radio-tea5764.c
@@ -578,7 +578,7 @@ static struct i2c_driver tea5764_i2c_driver = {
 		.owner = THIS_MODULE,
 	},
 	.probe = tea5764_i2c_probe,
-	.remove = __devexit_p(tea5764_i2c_remove),
+	.remove = tea5764_i2c_remove,
 	.id_table = tea5764_id,
 };
 
diff --git a/drivers/media/radio/radio-timb.c b/drivers/media/radio/radio-timb.c
index 5cf0777..c6ac683 100644
--- a/drivers/media/radio/radio-timb.c
+++ b/drivers/media/radio/radio-timb.c
@@ -219,7 +219,7 @@ static struct platform_driver timbradio_platform_driver = {
 		.owner	= THIS_MODULE,
 	},
 	.probe		= timbradio_probe,
-	.remove		= __devexit_p(timbradio_remove),
+	.remove		= timbradio_remove,
 };
 
 module_platform_driver(timbradio_platform_driver);
diff --git a/drivers/media/radio/radio-wl1273.c b/drivers/media/radio/radio-wl1273.c
index 9b0c9fa..57f617aa 100644
--- a/drivers/media/radio/radio-wl1273.c
+++ b/drivers/media/radio/radio-wl1273.c
@@ -2145,7 +2145,7 @@ pdata_err:
 
 static struct platform_driver wl1273_fm_radio_driver = {
 	.probe		= wl1273_fm_radio_probe,
-	.remove		= __devexit_p(wl1273_fm_radio_remove),
+	.remove		= wl1273_fm_radio_remove,
 	.driver		= {
 		.name	= "wl1273_fm_radio",
 		.owner	= THIS_MODULE,
diff --git a/drivers/media/radio/saa7706h.c b/drivers/media/radio/saa7706h.c
index 54db36c..4ef33ac 100644
--- a/drivers/media/radio/saa7706h.c
+++ b/drivers/media/radio/saa7706h.c
@@ -441,7 +441,7 @@ static struct i2c_driver saa7706h_driver = {
 		.name	= DRIVER_NAME,
 	},
 	.probe		= saa7706h_probe,
-	.remove		= __devexit_p(saa7706h_remove),
+	.remove		= saa7706h_remove,
 	.id_table	= saa7706h_id,
 };
 
diff --git a/drivers/media/radio/si470x/radio-si470x-i2c.c b/drivers/media/radio/si470x/radio-si470x-i2c.c
index 4ef55ec..b6de822 100644
--- a/drivers/media/radio/si470x/radio-si470x-i2c.c
+++ b/drivers/media/radio/si470x/radio-si470x-i2c.c
@@ -514,7 +514,7 @@ static struct i2c_driver si470x_i2c_driver = {
 #endif
 	},
 	.probe			= si470x_i2c_probe,
-	.remove			= __devexit_p(si470x_i2c_remove),
+	.remove			= si470x_i2c_remove,
 	.id_table		= si470x_i2c_id,
 };
 
diff --git a/drivers/media/radio/tef6862.c b/drivers/media/radio/tef6862.c
index 06d47e5..6418c4c 100644
--- a/drivers/media/radio/tef6862.c
+++ b/drivers/media/radio/tef6862.c
@@ -211,7 +211,7 @@ static struct i2c_driver tef6862_driver = {
 		.name	= DRIVER_NAME,
 	},
 	.probe		= tef6862_probe,
-	.remove		= __devexit_p(tef6862_remove),
+	.remove		= tef6862_remove,
 	.id_table	= tef6862_id,
 };
 
diff --git a/drivers/media/rc/ene_ir.c b/drivers/media/rc/ene_ir.c
index d05ac15..94f299f 100644
--- a/drivers/media/rc/ene_ir.c
+++ b/drivers/media/rc/ene_ir.c
@@ -1175,7 +1175,7 @@ static struct pnp_driver ene_driver = {
 	.flags = PNP_DRIVER_RES_DO_NOT_CHANGE,
 
 	.probe = ene_probe,
-	.remove = __devexit_p(ene_remove),
+	.remove = ene_remove,
 #ifdef CONFIG_PM
 	.suspend = ene_suspend,
 	.resume = ene_resume,
diff --git a/drivers/media/rc/fintek-cir.c b/drivers/media/rc/fintek-cir.c
index 52fd769..cddeb1b 100644
--- a/drivers/media/rc/fintek-cir.c
+++ b/drivers/media/rc/fintek-cir.c
@@ -678,7 +678,7 @@ static struct pnp_driver fintek_driver = {
 	.id_table	= fintek_ids,
 	.flags		= PNP_DRIVER_RES_DO_NOT_CHANGE,
 	.probe		= fintek_probe,
-	.remove		= __devexit_p(fintek_remove),
+	.remove		= fintek_remove,
 	.suspend	= fintek_suspend,
 	.resume		= fintek_resume,
 	.shutdown	= fintek_shutdown,
diff --git a/drivers/media/rc/gpio-ir-recv.c b/drivers/media/rc/gpio-ir-recv.c
index 04cb272..cc346a8 100644
--- a/drivers/media/rc/gpio-ir-recv.c
+++ b/drivers/media/rc/gpio-ir-recv.c
@@ -188,7 +188,7 @@ static const struct dev_pm_ops gpio_ir_recv_pm_ops = {
 
 static struct platform_driver gpio_ir_recv_driver = {
 	.probe  = gpio_ir_recv_probe,
-	.remove = __devexit_p(gpio_ir_recv_remove),
+	.remove = gpio_ir_recv_remove,
 	.driver = {
 		.name   = GPIO_IR_DRIVER_NAME,
 		.owner  = THIS_MODULE,
diff --git a/drivers/media/rc/iguanair.c b/drivers/media/rc/iguanair.c
index 51d7057..1f11e39 100644
--- a/drivers/media/rc/iguanair.c
+++ b/drivers/media/rc/iguanair.c
@@ -604,7 +604,7 @@ static const struct usb_device_id iguanair_table[] = {
 static struct usb_driver iguanair_driver = {
 	.name =	DRIVER_NAME,
 	.probe = iguanair_probe,
-	.disconnect = __devexit_p(iguanair_disconnect),
+	.disconnect = iguanair_disconnect,
 	.suspend = iguanair_suspend,
 	.resume = iguanair_resume,
 	.reset_resume = iguanair_resume,
diff --git a/drivers/media/rc/imon.c b/drivers/media/rc/imon.c
index 5dd0386..7f26fdf 100644
--- a/drivers/media/rc/imon.c
+++ b/drivers/media/rc/imon.c
@@ -255,7 +255,7 @@ static struct usb_device_id imon_usb_id_table[] = {
 static struct usb_driver imon_driver = {
 	.name		= MOD_NAME,
 	.probe		= imon_probe,
-	.disconnect	= __devexit_p(imon_disconnect),
+	.disconnect	= imon_disconnect,
 	.suspend	= imon_suspend,
 	.resume		= imon_resume,
 	.id_table	= imon_usb_id_table,
diff --git a/drivers/media/rc/ite-cir.c b/drivers/media/rc/ite-cir.c
index 24c77a4..40ea30d 100644
--- a/drivers/media/rc/ite-cir.c
+++ b/drivers/media/rc/ite-cir.c
@@ -1702,7 +1702,7 @@ static struct pnp_driver ite_driver = {
 	.name		= ITE_DRIVER_NAME,
 	.id_table	= ite_ids,
 	.probe		= ite_probe,
-	.remove		= __devexit_p(ite_remove),
+	.remove		= ite_remove,
 	.suspend	= ite_suspend,
 	.resume		= ite_resume,
 	.shutdown	= ite_shutdown,
diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index 850547f..1c0d87e 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -1432,7 +1432,7 @@ static int mceusb_dev_resume(struct usb_interface *intf)
 static struct usb_driver mceusb_dev_driver = {
 	.name =		DRIVER_NAME,
 	.probe =	mceusb_dev_probe,
-	.disconnect =	__devexit_p(mceusb_dev_disconnect),
+	.disconnect =	mceusb_dev_disconnect,
 	.suspend =	mceusb_dev_suspend,
 	.resume =	mceusb_dev_resume,
 	.reset_resume =	mceusb_dev_resume,
diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index 2ea913a..2e8d333 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -1214,7 +1214,7 @@ static struct pnp_driver nvt_driver = {
 	.id_table	= nvt_ids,
 	.flags		= PNP_DRIVER_RES_DO_NOT_CHANGE,
 	.probe		= nvt_probe,
-	.remove		= __devexit_p(nvt_remove),
+	.remove		= nvt_remove,
 	.suspend	= nvt_suspend,
 	.resume		= nvt_resume,
 	.shutdown	= nvt_shutdown,
diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
index 9f5a17b..c6aa3e0 100644
--- a/drivers/media/rc/redrat3.c
+++ b/drivers/media/rc/redrat3.c
@@ -1281,7 +1281,7 @@ static int redrat3_dev_resume(struct usb_interface *intf)
 static struct usb_driver redrat3_dev_driver = {
 	.name		= DRIVER_NAME,
 	.probe		= redrat3_dev_probe,
-	.disconnect	= __devexit_p(redrat3_dev_disconnect),
+	.disconnect	= redrat3_dev_disconnect,
 	.suspend	= redrat3_dev_suspend,
 	.resume		= redrat3_dev_resume,
 	.reset_resume	= redrat3_dev_resume,
diff --git a/drivers/media/rc/ttusbir.c b/drivers/media/rc/ttusbir.c
index fef0523..93abca7 100644
--- a/drivers/media/rc/ttusbir.c
+++ b/drivers/media/rc/ttusbir.c
@@ -435,7 +435,7 @@ static struct usb_driver ttusbir_driver = {
 	.suspend = ttusbir_suspend,
 	.resume = ttusbir_resume,
 	.reset_resume = ttusbir_resume,
-	.disconnect = __devexit_p(ttusbir_disconnect)
+	.disconnect = ttusbir_disconnect
 };
 
 module_usb_driver(ttusbir_driver);
diff --git a/drivers/media/rc/winbond-cir.c b/drivers/media/rc/winbond-cir.c
index 7c9b5f3..6fafe60 100644
--- a/drivers/media/rc/winbond-cir.c
+++ b/drivers/media/rc/winbond-cir.c
@@ -1132,7 +1132,7 @@ static struct pnp_driver wbcir_driver = {
 	.name     = WBCIR_NAME,
 	.id_table = wbcir_ids,
 	.probe    = wbcir_probe,
-	.remove   = __devexit_p(wbcir_remove),
+	.remove   = wbcir_remove,
 	.suspend  = wbcir_suspend,
 	.resume   = wbcir_resume,
 	.shutdown = wbcir_shutdown
diff --git a/drivers/media/usb/usbvision/usbvision-video.c b/drivers/media/usb/usbvision/usbvision-video.c
index 5c36a57..77eb1ab 100644
--- a/drivers/media/usb/usbvision/usbvision-video.c
+++ b/drivers/media/usb/usbvision/usbvision-video.c
@@ -1664,7 +1664,7 @@ static struct usb_driver usbvision_driver = {
 	.name		= "usbvision",
 	.id_table	= usbvision_table,
 	.probe		= usbvision_probe,
-	.disconnect	= __devexit_p(usbvision_disconnect),
+	.disconnect	= usbvision_disconnect,
 };
 
 /*
-- 
1.8.0

