Return-path: <linux-media-owner@vger.kernel.org>
Received: from viridian.itc.Virginia.EDU ([128.143.12.139]:41504 "EHLO
	viridian.itc.virginia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754289Ab2KSSfM (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Nov 2012 13:35:12 -0500
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
	=?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>,
	linux-media@vger.kernel.org, mjpeg-users@lists.sourceforge.net,
	linux-arm-kernel@lists.infradead.org
Subject: =?UTF-8?q?=5BPATCH=20444/493=5D=20media=3A=20remove=20use=20of=20=5F=5Fdevexit?=
Date: Mon, 19 Nov 2012 13:26:33 -0500
Message-Id: <1353349642-3677-444-git-send-email-wfp5p@virginia.edu>
In-Reply-To: <1353349642-3677-1-git-send-email-wfp5p@virginia.edu>
References: <1353349642-3677-1-git-send-email-wfp5p@virginia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

CONFIG_HOTPLUG is going away as an option so __devexit is no
longer needed.

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
Cc: "David Härdeman" <david@hardeman.nu> 
Cc: linux-media@vger.kernel.org 
Cc: mjpeg-users@lists.sourceforge.net 
Cc: linux-arm-kernel@lists.infradead.org 
---
 drivers/media/i2c/adv7180.c                              | 2 +-
 drivers/media/i2c/as3645a.c                              | 2 +-
 drivers/media/i2c/m5mols/m5mols_core.c                   | 2 +-
 drivers/media/i2c/vs6624.c                               | 2 +-
 drivers/media/pci/bt8xx/bt878.c                          | 2 +-
 drivers/media/pci/bt8xx/bttv-driver.c                    | 2 +-
 drivers/media/pci/bt8xx/bttv-input.c                     | 2 +-
 drivers/media/pci/cx23885/cx23885-core.c                 | 2 +-
 drivers/media/pci/cx25821/cx25821-core.c                 | 2 +-
 drivers/media/pci/cx88/cx88-alsa.c                       | 2 +-
 drivers/media/pci/cx88/cx88-mpeg.c                       | 2 +-
 drivers/media/pci/cx88/cx88-video.c                      | 2 +-
 drivers/media/pci/ddbridge/ddbridge-core.c               | 2 +-
 drivers/media/pci/dm1105/dm1105.c                        | 4 ++--
 drivers/media/pci/mantis/hopper_cards.c                  | 4 ++--
 drivers/media/pci/mantis/mantis_cards.c                  | 4 ++--
 drivers/media/pci/mantis/mantis_dvb.c                    | 2 +-
 drivers/media/pci/meye/meye.c                            | 2 +-
 drivers/media/pci/ngene/ngene-core.c                     | 2 +-
 drivers/media/pci/ngene/ngene.h                          | 2 +-
 drivers/media/pci/pluto2/pluto2.c                        | 2 +-
 drivers/media/pci/pt1/pt1.c                              | 2 +-
 drivers/media/pci/saa7134/saa7134-core.c                 | 2 +-
 drivers/media/pci/saa7164/saa7164-core.c                 | 2 +-
 drivers/media/pci/sta2x11/sta2x11_vip.c                  | 2 +-
 drivers/media/pci/ttpci/av7110.c                         | 2 +-
 drivers/media/pci/ttpci/av7110_ir.c                      | 2 +-
 drivers/media/pci/zoran/zoran_card.c                     | 2 +-
 drivers/media/platform/blackfin/bfin_capture.c           | 2 +-
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
 drivers/media/platform/via-camera.c                      | 2 +-
 drivers/media/radio/radio-maxiradio.c                    | 2 +-
 drivers/media/radio/radio-sf16fmr2.c                     | 6 +++---
 drivers/media/radio/radio-tea5764.c                      | 2 +-
 drivers/media/radio/radio-timb.c                         | 2 +-
 drivers/media/radio/saa7706h.c                           | 2 +-
 drivers/media/radio/si470x/radio-si470x-i2c.c            | 2 +-
 drivers/media/radio/tef6862.c                            | 2 +-
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
 73 files changed, 78 insertions(+), 78 deletions(-)

diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
index 3ceee8d..8103a03 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -587,7 +587,7 @@ err:
 	return ret;
 }
 
-static __devexit int adv7180_remove(struct i2c_client *client)
+static int adv7180_remove(struct i2c_client *client)
 {
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
 	struct adv7180_state *state = to_state(sd);
diff --git a/drivers/media/i2c/as3645a.c b/drivers/media/i2c/as3645a.c
index 810d681..9a3483e 100644
--- a/drivers/media/i2c/as3645a.c
+++ b/drivers/media/i2c/as3645a.c
@@ -846,7 +846,7 @@ done:
 	return ret;
 }
 
-static int __devexit as3645a_remove(struct i2c_client *client)
+static int as3645a_remove(struct i2c_client *client)
 {
 	struct v4l2_subdev *subdev = i2c_get_clientdata(client);
 	struct as3645a *flash = to_as3645a(subdev);
diff --git a/drivers/media/i2c/m5mols/m5mols_core.c b/drivers/media/i2c/m5mols/m5mols_core.c
index 3f10efa..50870f5 100644
--- a/drivers/media/i2c/m5mols/m5mols_core.c
+++ b/drivers/media/i2c/m5mols/m5mols_core.c
@@ -1018,7 +1018,7 @@ out_free:
 	return ret;
 }
 
-static int __devexit m5mols_remove(struct i2c_client *client)
+static int m5mols_remove(struct i2c_client *client)
 {
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
 	struct m5mols_info *info = to_m5mols(sd);
diff --git a/drivers/media/i2c/vs6624.c b/drivers/media/i2c/vs6624.c
index fe54f53..1231271 100644
--- a/drivers/media/i2c/vs6624.c
+++ b/drivers/media/i2c/vs6624.c
@@ -881,7 +881,7 @@ static int vs6624_probe(struct i2c_client *client,
 	return ret;
 }
 
-static int __devexit vs6624_remove(struct i2c_client *client)
+static int vs6624_remove(struct i2c_client *client)
 {
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
 	struct vs6624 *sensor = to_vs6624(sd);
diff --git a/drivers/media/pci/bt8xx/bt878.c b/drivers/media/pci/bt8xx/bt878.c
index 4ce3734..459328c 100644
--- a/drivers/media/pci/bt8xx/bt878.c
+++ b/drivers/media/pci/bt8xx/bt878.c
@@ -529,7 +529,7 @@ static int bt878_probe(struct pci_dev *dev,
 	return result;
 }
 
-static void __devexit bt878_remove(struct pci_dev *pci_dev)
+static void bt878_remove(struct pci_dev *pci_dev)
 {
 	u8 command;
 	struct bt878 *bt = pci_get_drvdata(pci_dev);
diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
index 61a2105..b2f9e69 100644
--- a/drivers/media/pci/bt8xx/bttv-driver.c
+++ b/drivers/media/pci/bt8xx/bttv-driver.c
@@ -4455,7 +4455,7 @@ fail0:
 	return result;
 }
 
-static void __devexit bttv_remove(struct pci_dev *pci_dev)
+static void bttv_remove(struct pci_dev *pci_dev)
 {
 	struct v4l2_device *v4l2_dev = pci_get_drvdata(pci_dev);
 	struct bttv *btv = to_bttv(v4l2_dev);
diff --git a/drivers/media/pci/bt8xx/bttv-input.c b/drivers/media/pci/bt8xx/bttv-input.c
index ad9a62d..04207a7 100644
--- a/drivers/media/pci/bt8xx/bttv-input.c
+++ b/drivers/media/pci/bt8xx/bttv-input.c
@@ -411,7 +411,7 @@ void init_bttv_i2c_ir(struct bttv *btv)
 	return;
 }
 
-int __devexit fini_bttv_i2c(struct bttv *btv)
+int fini_bttv_i2c(struct bttv *btv)
 {
 	if (0 != btv->i2c_rc)
 		return 0;
diff --git a/drivers/media/pci/cx23885/cx23885-core.c b/drivers/media/pci/cx23885/cx23885-core.c
index 09b251e..2a787f7 100644
--- a/drivers/media/pci/cx23885/cx23885-core.c
+++ b/drivers/media/pci/cx23885/cx23885-core.c
@@ -2169,7 +2169,7 @@ fail_free:
 	return err;
 }
 
-static void __devexit cx23885_finidev(struct pci_dev *pci_dev)
+static void cx23885_finidev(struct pci_dev *pci_dev)
 {
 	struct v4l2_device *v4l2_dev = pci_get_drvdata(pci_dev);
 	struct cx23885_dev *dev = to_cx23885(v4l2_dev);
diff --git a/drivers/media/pci/cx25821/cx25821-core.c b/drivers/media/pci/cx25821/cx25821-core.c
index 6236f80..90df2ab 100644
--- a/drivers/media/pci/cx25821/cx25821-core.c
+++ b/drivers/media/pci/cx25821/cx25821-core.c
@@ -1433,7 +1433,7 @@ fail_free:
 	return err;
 }
 
-static void __devexit cx25821_finidev(struct pci_dev *pci_dev)
+static void cx25821_finidev(struct pci_dev *pci_dev)
 {
 	struct v4l2_device *v4l2_dev = pci_get_drvdata(pci_dev);
 	struct cx25821_dev *dev = get_cx25821(v4l2_dev);
diff --git a/drivers/media/pci/cx88/cx88-alsa.c b/drivers/media/pci/cx88/cx88-alsa.c
index 5463233..10c534b 100644
--- a/drivers/media/pci/cx88/cx88-alsa.c
+++ b/drivers/media/pci/cx88/cx88-alsa.c
@@ -927,7 +927,7 @@ error:
 /*
  * ALSA destructor
  */
-static void __devexit cx88_audio_finidev(struct pci_dev *pci)
+static void cx88_audio_finidev(struct pci_dev *pci)
 {
 	struct cx88_audio_dev *card = pci_get_drvdata(pci);
 
diff --git a/drivers/media/pci/cx88/cx88-mpeg.c b/drivers/media/pci/cx88/cx88-mpeg.c
index a2be7df..db7def0 100644
--- a/drivers/media/pci/cx88/cx88-mpeg.c
+++ b/drivers/media/pci/cx88/cx88-mpeg.c
@@ -838,7 +838,7 @@ static int cx8802_probe(struct pci_dev *pci_dev,
 	return err;
 }
 
-static void __devexit cx8802_remove(struct pci_dev *pci_dev)
+static void cx8802_remove(struct pci_dev *pci_dev)
 {
 	struct cx8802_dev *dev;
 
diff --git a/drivers/media/pci/cx88/cx88-video.c b/drivers/media/pci/cx88/cx88-video.c
index 62a3ae1..d31387f 100644
--- a/drivers/media/pci/cx88/cx88-video.c
+++ b/drivers/media/pci/cx88/cx88-video.c
@@ -1923,7 +1923,7 @@ fail_free:
 	return err;
 }
 
-static void __devexit cx8800_finidev(struct pci_dev *pci_dev)
+static void cx8800_finidev(struct pci_dev *pci_dev)
 {
 	struct cx8800_dev *dev = pci_get_drvdata(pci_dev);
 	struct cx88_core *core = dev->core;
diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index 0cb8653..83d99b5 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -1542,7 +1542,7 @@ static void ddb_unmap(struct ddb *dev)
 }
 
 
-static void __devexit ddb_remove(struct pci_dev *pdev)
+static void ddb_remove(struct pci_dev *pdev)
 {
 	struct ddb *dev = (struct ddb *) pci_get_drvdata(pdev);
 
diff --git a/drivers/media/pci/dm1105/dm1105.c b/drivers/media/pci/dm1105/dm1105.c
index b8ef0c3..8129805 100644
--- a/drivers/media/pci/dm1105/dm1105.c
+++ b/drivers/media/pci/dm1105/dm1105.c
@@ -776,7 +776,7 @@ int dm1105_ir_init(struct dm1105_dev *dm1105)
 	return 0;
 }
 
-void __devexit dm1105_ir_exit(struct dm1105_dev *dm1105)
+void dm1105_ir_exit(struct dm1105_dev *dm1105)
 {
 	rc_unregister_device(dm1105->ir.dev);
 }
@@ -1172,7 +1172,7 @@ err_kfree:
 	return ret;
 }
 
-static void __devexit dm1105_remove(struct pci_dev *pdev)
+static void dm1105_remove(struct pci_dev *pdev)
 {
 	struct dm1105_dev *dev = pci_get_drvdata(pdev);
 	struct dvb_adapter *dvb_adapter = &dev->dvb_adapter;
diff --git a/drivers/media/pci/mantis/hopper_cards.c b/drivers/media/pci/mantis/hopper_cards.c
index 5b9778a..e17fd34 100644
--- a/drivers/media/pci/mantis/hopper_cards.c
+++ b/drivers/media/pci/mantis/hopper_cards.c
@@ -230,7 +230,7 @@ fail0:
 	return err;
 }
 
-static void __devexit hopper_pci_remove(struct pci_dev *pdev)
+static void hopper_pci_remove(struct pci_dev *pdev)
 {
 	struct mantis_pci *mantis = pci_get_drvdata(pdev);
 
@@ -264,7 +264,7 @@ static int hopper_init(void)
 	return pci_register_driver(&hopper_pci_driver);
 }
 
-static void __devexit hopper_exit(void)
+static void hopper_exit(void)
 {
 	return pci_unregister_driver(&hopper_pci_driver);
 }
diff --git a/drivers/media/pci/mantis/mantis_cards.c b/drivers/media/pci/mantis/mantis_cards.c
index 45fe3db..616741e 100644
--- a/drivers/media/pci/mantis/mantis_cards.c
+++ b/drivers/media/pci/mantis/mantis_cards.c
@@ -249,7 +249,7 @@ fail0:
 	return err;
 }
 
-static void __devexit mantis_pci_remove(struct pci_dev *pdev)
+static void mantis_pci_remove(struct pci_dev *pdev)
 {
 	struct mantis_pci *mantis = pci_get_drvdata(pdev);
 
@@ -294,7 +294,7 @@ static int mantis_init(void)
 	return pci_register_driver(&mantis_pci_driver);
 }
 
-static void __devexit mantis_exit(void)
+static void mantis_exit(void)
 {
 	return pci_unregister_driver(&mantis_pci_driver);
 }
diff --git a/drivers/media/pci/mantis/mantis_dvb.c b/drivers/media/pci/mantis/mantis_dvb.c
index 54e76a8..5a71e17 100644
--- a/drivers/media/pci/mantis/mantis_dvb.c
+++ b/drivers/media/pci/mantis/mantis_dvb.c
@@ -271,7 +271,7 @@ err0:
 }
 EXPORT_SYMBOL_GPL(mantis_dvb_init);
 
-int __devexit mantis_dvb_exit(struct mantis_pci *mantis)
+int mantis_dvb_exit(struct mantis_pci *mantis)
 {
 	int err;
 
diff --git a/drivers/media/pci/meye/meye.c b/drivers/media/pci/meye/meye.c
index bc9ef90..01dd080 100644
--- a/drivers/media/pci/meye/meye.c
+++ b/drivers/media/pci/meye/meye.c
@@ -1889,7 +1889,7 @@ outnotdev:
 	return ret;
 }
 
-static void __devexit meye_remove(struct pci_dev *pcidev)
+static void meye_remove(struct pci_dev *pcidev)
 {
 	video_unregister_device(meye.vdev);
 
diff --git a/drivers/media/pci/ngene/ngene-core.c b/drivers/media/pci/ngene/ngene-core.c
index f604d57..e393449 100644
--- a/drivers/media/pci/ngene/ngene-core.c
+++ b/drivers/media/pci/ngene/ngene-core.c
@@ -1636,7 +1636,7 @@ void ngene_shutdown(struct pci_dev *pdev)
 /* device probe/remove calls ************************************************/
 /****************************************************************************/
 
-void __devexit ngene_remove(struct pci_dev *pdev)
+void ngene_remove(struct pci_dev *pdev)
 {
 	struct ngene *dev = pci_get_drvdata(pdev);
 	int i;
diff --git a/drivers/media/pci/ngene/ngene.h b/drivers/media/pci/ngene/ngene.h
index e23d1f6..5eb7314 100644
--- a/drivers/media/pci/ngene/ngene.h
+++ b/drivers/media/pci/ngene/ngene.h
@@ -889,7 +889,7 @@ struct ngene_buffer {
 /* Provided by ngene-core.c */
 int ngene_probe(struct pci_dev *pci_dev,
 			  const struct pci_device_id *id);
-void __devexit ngene_remove(struct pci_dev *pdev);
+void ngene_remove(struct pci_dev *pdev);
 void ngene_shutdown(struct pci_dev *pdev);
 int ngene_command(struct ngene *dev, struct ngene_command *com);
 int ngene_command_gpio_set(struct ngene *dev, u8 select, u8 level);
diff --git a/drivers/media/pci/pluto2/pluto2.c b/drivers/media/pci/pluto2/pluto2.c
index b083c07..43fdba7 100644
--- a/drivers/media/pci/pluto2/pluto2.c
+++ b/drivers/media/pci/pluto2/pluto2.c
@@ -742,7 +742,7 @@ err_kfree:
 	goto out;
 }
 
-static void __devexit pluto2_remove(struct pci_dev *pdev)
+static void pluto2_remove(struct pci_dev *pdev)
 {
 	struct pluto *pluto = pci_get_drvdata(pdev);
 	struct dvb_adapter *dvb_adapter = &pluto->dvb_adapter;
diff --git a/drivers/media/pci/pt1/pt1.c b/drivers/media/pci/pt1/pt1.c
index 4eec33a..1058b52 100644
--- a/drivers/media/pci/pt1/pt1.c
+++ b/drivers/media/pci/pt1/pt1.c
@@ -1058,7 +1058,7 @@ static void pt1_i2c_init(struct pt1 *pt1)
 		pt1_i2c_emit(pt1, i, 0, 0, 1, 1, 0);
 }
 
-static void __devexit pt1_remove(struct pci_dev *pdev)
+static void pt1_remove(struct pci_dev *pdev)
 {
 	struct pt1 *pt1;
 	void __iomem *regs;
diff --git a/drivers/media/pci/saa7134/saa7134-core.c b/drivers/media/pci/saa7134/saa7134-core.c
index 7719e11..2f1e4f7 100644
--- a/drivers/media/pci/saa7134/saa7134-core.c
+++ b/drivers/media/pci/saa7134/saa7134-core.c
@@ -1103,7 +1103,7 @@ static int saa7134_initdev(struct pci_dev *pci_dev,
 	return err;
 }
 
-static void __devexit saa7134_finidev(struct pci_dev *pci_dev)
+static void saa7134_finidev(struct pci_dev *pci_dev)
 {
 	struct v4l2_device *v4l2_dev = pci_get_drvdata(pci_dev);
 	struct saa7134_dev *dev = container_of(v4l2_dev, struct saa7134_dev, v4l2_dev);
diff --git a/drivers/media/pci/saa7164/saa7164-core.c b/drivers/media/pci/saa7164/saa7164-core.c
index 8614b01..5e2745a 100644
--- a/drivers/media/pci/saa7164/saa7164-core.c
+++ b/drivers/media/pci/saa7164/saa7164-core.c
@@ -1376,7 +1376,7 @@ static void saa7164_shutdown(struct saa7164_dev *dev)
 	dprintk(1, "%s()\n", __func__);
 }
 
-static void __devexit saa7164_finidev(struct pci_dev *pci_dev)
+static void saa7164_finidev(struct pci_dev *pci_dev)
 {
 	struct saa7164_dev *dev = pci_get_drvdata(pci_dev);
 
diff --git a/drivers/media/pci/sta2x11/sta2x11_vip.c b/drivers/media/pci/sta2x11/sta2x11_vip.c
index 7cc5636..2b1c826 100644
--- a/drivers/media/pci/sta2x11/sta2x11_vip.c
+++ b/drivers/media/pci/sta2x11/sta2x11_vip.c
@@ -1376,7 +1376,7 @@ disable:
  * free memory
  * free GPIO pins
  */
-static void __devexit sta2x11_vip_remove_one(struct pci_dev *pdev)
+static void sta2x11_vip_remove_one(struct pci_dev *pdev)
 {
 	struct v4l2_device *v4l2_dev = pci_get_drvdata(pdev);
 	struct sta2x11_vip *vip =
diff --git a/drivers/media/pci/ttpci/av7110.c b/drivers/media/pci/ttpci/av7110.c
index 40c3172..53ac3a90 100644
--- a/drivers/media/pci/ttpci/av7110.c
+++ b/drivers/media/pci/ttpci/av7110.c
@@ -2761,7 +2761,7 @@ err_kfree_0:
 	goto out;
 }
 
-static int __devexit av7110_detach(struct saa7146_dev* saa)
+static int av7110_detach(struct saa7146_dev* saa)
 {
 	struct av7110 *av7110 = saa->ext_priv;
 	dprintk(4, "%p\n", av7110);
diff --git a/drivers/media/pci/ttpci/av7110_ir.c b/drivers/media/pci/ttpci/av7110_ir.c
index af00d30..eb82286 100644
--- a/drivers/media/pci/ttpci/av7110_ir.c
+++ b/drivers/media/pci/ttpci/av7110_ir.c
@@ -385,7 +385,7 @@ int av7110_ir_init(struct av7110 *av7110)
 }
 
 
-void __devexit av7110_ir_exit(struct av7110 *av7110)
+void av7110_ir_exit(struct av7110 *av7110)
 {
 	int i;
 
diff --git a/drivers/media/pci/zoran/zoran_card.c b/drivers/media/pci/zoran/zoran_card.c
index 776644d..3b1f45f 100644
--- a/drivers/media/pci/zoran/zoran_card.c
+++ b/drivers/media/pci/zoran/zoran_card.c
@@ -1083,7 +1083,7 @@ exit_free:
 	return err;
 }
 
-static void __devexit zoran_remove(struct pci_dev *pdev)
+static void zoran_remove(struct pci_dev *pdev)
 {
 	struct v4l2_device *v4l2_dev = dev_get_drvdata(&pdev->dev);
 	struct zoran *zr = to_zoran(v4l2_dev);
diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
index d87c7fc..54f8afb 100644
--- a/drivers/media/platform/blackfin/bfin_capture.c
+++ b/drivers/media/platform/blackfin/bfin_capture.c
@@ -1026,7 +1026,7 @@ err_free_dev:
 	return ret;
 }
 
-static int __devexit bcap_remove(struct platform_device *pdev)
+static int bcap_remove(struct platform_device *pdev)
 {
 	struct v4l2_device *v4l2_dev = platform_get_drvdata(pdev);
 	struct bcap_device *bcap_dev = container_of(v4l2_dev,
diff --git a/drivers/media/platform/davinci/vpfe_capture.c b/drivers/media/platform/davinci/vpfe_capture.c
index f2690bd..be9d3e1 100644
--- a/drivers/media/platform/davinci/vpfe_capture.c
+++ b/drivers/media/platform/davinci/vpfe_capture.c
@@ -2038,7 +2038,7 @@ probe_free_dev_mem:
 /*
  * vpfe_remove : It un-register device from V4L2 driver
  */
-static int __devexit vpfe_remove(struct platform_device *pdev)
+static int vpfe_remove(struct platform_device *pdev)
 {
 	struct vpfe_device *vpfe_dev = platform_get_drvdata(pdev);
 
diff --git a/drivers/media/platform/davinci/vpif.c b/drivers/media/platform/davinci/vpif.c
index cf96cc9..3beedc5 100644
--- a/drivers/media/platform/davinci/vpif.c
+++ b/drivers/media/platform/davinci/vpif.c
@@ -457,7 +457,7 @@ fail:
 	return status;
 }
 
-static int __devexit vpif_remove(struct platform_device *pdev)
+static int vpif_remove(struct platform_device *pdev)
 {
 	if (vpif_clk) {
 		clk_disable(vpif_clk);
diff --git a/drivers/media/platform/davinci/vpss.c b/drivers/media/platform/davinci/vpss.c
index 28cc79b..cdbff88e 100644
--- a/drivers/media/platform/davinci/vpss.c
+++ b/drivers/media/platform/davinci/vpss.c
@@ -445,7 +445,7 @@ fail1:
 	return status;
 }
 
-static int __devexit vpss_remove(struct platform_device *pdev)
+static int vpss_remove(struct platform_device *pdev)
 {
 	struct resource		*res;
 
diff --git a/drivers/media/platform/exynos-gsc/gsc-core.c b/drivers/media/platform/exynos-gsc/gsc-core.c
index 8d0263c..f907645 100644
--- a/drivers/media/platform/exynos-gsc/gsc-core.c
+++ b/drivers/media/platform/exynos-gsc/gsc-core.c
@@ -1149,7 +1149,7 @@ err_clk:
 	return ret;
 }
 
-static int __devexit gsc_remove(struct platform_device *pdev)
+static int gsc_remove(struct platform_device *pdev)
 {
 	struct gsc_dev *gsc = platform_get_drvdata(pdev);
 
diff --git a/drivers/media/platform/fsl-viu.c b/drivers/media/platform/fsl-viu.c
index 6444014..9d923a9 100644
--- a/drivers/media/platform/fsl-viu.c
+++ b/drivers/media/platform/fsl-viu.c
@@ -1617,7 +1617,7 @@ err:
 	return ret;
 }
 
-static int __devexit viu_of_remove(struct platform_device *op)
+static int viu_of_remove(struct platform_device *op)
 {
 	struct v4l2_device *v4l2_dev = dev_get_drvdata(&op->dev);
 	struct viu_dev *dev = container_of(v4l2_dev, struct viu_dev, v4l2_dev);
diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 7f3ec2d..62cd428 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -1978,7 +1978,7 @@ error_csiphy:
  *
  * Always returns 0.
  */
-static int __devexit isp_remove(struct platform_device *pdev)
+static int isp_remove(struct platform_device *pdev)
 {
 	struct isp_device *isp = platform_get_drvdata(pdev);
 	int i;
diff --git a/drivers/media/platform/s5p-fimc/fimc-core.c b/drivers/media/platform/s5p-fimc/fimc-core.c
index fe7f061..545b46a 100644
--- a/drivers/media/platform/s5p-fimc/fimc-core.c
+++ b/drivers/media/platform/s5p-fimc/fimc-core.c
@@ -1035,7 +1035,7 @@ static int fimc_suspend(struct device *dev)
 }
 #endif /* CONFIG_PM_SLEEP */
 
-static int __devexit fimc_remove(struct platform_device *pdev)
+static int fimc_remove(struct platform_device *pdev)
 {
 	struct fimc_dev *fimc = platform_get_drvdata(pdev);
 
diff --git a/drivers/media/platform/s5p-fimc/fimc-lite.c b/drivers/media/platform/s5p-fimc/fimc-lite.c
index c2d577f..ce6d70c 100644
--- a/drivers/media/platform/s5p-fimc/fimc-lite.c
+++ b/drivers/media/platform/s5p-fimc/fimc-lite.c
@@ -1543,7 +1543,7 @@ static int fimc_lite_suspend(struct device *dev)
 }
 #endif /* CONFIG_PM_SLEEP */
 
-static int __devexit fimc_lite_remove(struct platform_device *pdev)
+static int fimc_lite_remove(struct platform_device *pdev)
 {
 	struct fimc_lite *fimc = platform_get_drvdata(pdev);
 	struct device *dev = &pdev->dev;
diff --git a/drivers/media/platform/s5p-fimc/fimc-mdevice.c b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
index 75c8688..2f46a5f 100644
--- a/drivers/media/platform/s5p-fimc/fimc-mdevice.c
+++ b/drivers/media/platform/s5p-fimc/fimc-mdevice.c
@@ -1001,7 +1001,7 @@ err_md:
 	return ret;
 }
 
-static int __devexit fimc_md_remove(struct platform_device *pdev)
+static int fimc_md_remove(struct platform_device *pdev)
 {
 	struct fimc_md *fmd = platform_get_drvdata(pdev);
 
diff --git a/drivers/media/platform/s5p-fimc/mipi-csis.c b/drivers/media/platform/s5p-fimc/mipi-csis.c
index d0ab24b..ec3fa7d 100644
--- a/drivers/media/platform/s5p-fimc/mipi-csis.c
+++ b/drivers/media/platform/s5p-fimc/mipi-csis.c
@@ -851,7 +851,7 @@ static int s5pcsis_runtime_resume(struct device *dev)
 }
 #endif
 
-static int __devexit s5pcsis_remove(struct platform_device *pdev)
+static int s5pcsis_remove(struct platform_device *pdev)
 {
 	struct v4l2_subdev *sd = platform_get_drvdata(pdev);
 	struct csis_state *state = sd_to_csis_state(sd);
diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc.c b/drivers/media/platform/s5p-mfc/s5p_mfc.c
index c4cc37f..4d065ea 100644
--- a/drivers/media/platform/s5p-mfc/s5p_mfc.c
+++ b/drivers/media/platform/s5p-mfc/s5p_mfc.c
@@ -1206,7 +1206,7 @@ err_res:
 }
 
 /* Remove the driver */
-static int __devexit s5p_mfc_remove(struct platform_device *pdev)
+static int s5p_mfc_remove(struct platform_device *pdev)
 {
 	struct s5p_mfc_dev *dev = platform_get_drvdata(pdev);
 
diff --git a/drivers/media/platform/s5p-tv/hdmi_drv.c b/drivers/media/platform/s5p-tv/hdmi_drv.c
index 4b5680b..7c1116c 100644
--- a/drivers/media/platform/s5p-tv/hdmi_drv.c
+++ b/drivers/media/platform/s5p-tv/hdmi_drv.c
@@ -979,7 +979,7 @@ fail:
 	return ret;
 }
 
-static int __devexit hdmi_remove(struct platform_device *pdev)
+static int hdmi_remove(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct v4l2_subdev *sd = dev_get_drvdata(dev);
diff --git a/drivers/media/platform/s5p-tv/hdmiphy_drv.c b/drivers/media/platform/s5p-tv/hdmiphy_drv.c
index 2d3d154..2139edc 100644
--- a/drivers/media/platform/s5p-tv/hdmiphy_drv.c
+++ b/drivers/media/platform/s5p-tv/hdmiphy_drv.c
@@ -295,7 +295,7 @@ static int hdmiphy_probe(struct i2c_client *client,
 	return 0;
 }
 
-static int __devexit hdmiphy_remove(struct i2c_client *client)
+static int hdmiphy_remove(struct i2c_client *client)
 {
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
 	struct hdmiphy_ctx *ctx = sd_to_ctx(sd);
diff --git a/drivers/media/platform/s5p-tv/mixer_drv.c b/drivers/media/platform/s5p-tv/mixer_drv.c
index 46d53cd..7d622e2 100644
--- a/drivers/media/platform/s5p-tv/mixer_drv.c
+++ b/drivers/media/platform/s5p-tv/mixer_drv.c
@@ -431,7 +431,7 @@ fail:
 	return ret;
 }
 
-static int __devexit mxr_remove(struct platform_device *pdev)
+static int mxr_remove(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct mxr_device *mdev = to_mdev(dev);
diff --git a/drivers/media/platform/s5p-tv/sdo_drv.c b/drivers/media/platform/s5p-tv/sdo_drv.c
index 1815b2e..91a6939 100644
--- a/drivers/media/platform/s5p-tv/sdo_drv.c
+++ b/drivers/media/platform/s5p-tv/sdo_drv.c
@@ -419,7 +419,7 @@ fail:
 	return ret;
 }
 
-static int __devexit sdo_remove(struct platform_device *pdev)
+static int sdo_remove(struct platform_device *pdev)
 {
 	struct v4l2_subdev *sd = dev_get_drvdata(&pdev->dev);
 	struct sdo_device *sdev = sd_to_sdev(sd);
diff --git a/drivers/media/platform/s5p-tv/sii9234_drv.c b/drivers/media/platform/s5p-tv/sii9234_drv.c
index 2c5f181..3a3142f 100644
--- a/drivers/media/platform/s5p-tv/sii9234_drv.c
+++ b/drivers/media/platform/s5p-tv/sii9234_drv.c
@@ -378,7 +378,7 @@ fail:
 	return ret;
 }
 
-static int __devexit sii9234_remove(struct i2c_client *client)
+static int sii9234_remove(struct i2c_client *client)
 {
 	struct device *dev = &client->dev;
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
diff --git a/drivers/media/platform/sh_vou.c b/drivers/media/platform/sh_vou.c
index 08bde38..dc0b23e 100644
--- a/drivers/media/platform/sh_vou.c
+++ b/drivers/media/platform/sh_vou.c
@@ -1460,7 +1460,7 @@ ereqmemreg:
 	return ret;
 }
 
-static int __devexit sh_vou_remove(struct platform_device *pdev)
+static int sh_vou_remove(struct platform_device *pdev)
 {
 	int irq = platform_get_irq(pdev, 0);
 	struct v4l2_device *v4l2_dev = platform_get_drvdata(pdev);
diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
index b7f02a49..d96c8c7 100644
--- a/drivers/media/platform/soc_camera/atmel-isi.c
+++ b/drivers/media/platform/soc_camera/atmel-isi.c
@@ -897,7 +897,7 @@ static struct soc_camera_host_ops isi_soc_camera_host_ops = {
 };
 
 /* -----------------------------------------------------------------------*/
-static int __devexit atmel_isi_remove(struct platform_device *pdev)
+static int atmel_isi_remove(struct platform_device *pdev)
 {
 	struct soc_camera_host *soc_host = to_soc_camera_host(&pdev->dev);
 	struct atmel_isi *isi = container_of(soc_host,
diff --git a/drivers/media/platform/soc_camera/mx2_camera.c b/drivers/media/platform/soc_camera/mx2_camera.c
index 6f3738e..8f5eefb 100644
--- a/drivers/media/platform/soc_camera/mx2_camera.c
+++ b/drivers/media/platform/soc_camera/mx2_camera.c
@@ -1863,7 +1863,7 @@ exit:
 	return err;
 }
 
-static int __devexit mx2_camera_remove(struct platform_device *pdev)
+static int mx2_camera_remove(struct platform_device *pdev)
 {
 	struct soc_camera_host *soc_host = to_soc_camera_host(&pdev->dev);
 	struct mx2_camera_dev *pcdev = container_of(soc_host,
diff --git a/drivers/media/platform/soc_camera/mx3_camera.c b/drivers/media/platform/soc_camera/mx3_camera.c
index e518c1f..d635c24 100644
--- a/drivers/media/platform/soc_camera/mx3_camera.c
+++ b/drivers/media/platform/soc_camera/mx3_camera.c
@@ -1245,7 +1245,7 @@ egetres:
 	return err;
 }
 
-static int __devexit mx3_camera_remove(struct platform_device *pdev)
+static int mx3_camera_remove(struct platform_device *pdev)
 {
 	struct soc_camera_host *soc_host = to_soc_camera_host(&pdev->dev);
 	struct mx3_camera_dev *mx3_cam = container_of(soc_host,
diff --git a/drivers/media/platform/soc_camera/pxa_camera.c b/drivers/media/platform/soc_camera/pxa_camera.c
index ac87daf..fc7f7d3 100644
--- a/drivers/media/platform/soc_camera/pxa_camera.c
+++ b/drivers/media/platform/soc_camera/pxa_camera.c
@@ -1801,7 +1801,7 @@ exit:
 	return err;
 }
 
-static int __devexit pxa_camera_remove(struct platform_device *pdev)
+static int pxa_camera_remove(struct platform_device *pdev)
 {
 	struct soc_camera_host *soc_host = to_soc_camera_host(&pdev->dev);
 	struct pxa_camera_dev *pcdev = container_of(soc_host,
diff --git a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
index d6fdf59..6b680ca 100644
--- a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
+++ b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
@@ -2257,7 +2257,7 @@ exit:
 	return err;
 }
 
-static int __devexit sh_mobile_ceu_remove(struct platform_device *pdev)
+static int sh_mobile_ceu_remove(struct platform_device *pdev)
 {
 	struct soc_camera_host *soc_host = to_soc_camera_host(&pdev->dev);
 	struct sh_mobile_ceu_dev *pcdev = container_of(soc_host,
diff --git a/drivers/media/platform/soc_camera/sh_mobile_csi2.c b/drivers/media/platform/soc_camera/sh_mobile_csi2.c
index d965133..a17aba9 100644
--- a/drivers/media/platform/soc_camera/sh_mobile_csi2.c
+++ b/drivers/media/platform/soc_camera/sh_mobile_csi2.c
@@ -366,7 +366,7 @@ ereqreg:
 	return ret;
 }
 
-static __devexit int sh_csi2_remove(struct platform_device *pdev)
+static int sh_csi2_remove(struct platform_device *pdev)
 {
 	struct sh_csi2 *priv = platform_get_drvdata(pdev);
 	struct resource *res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index 8c16b8a..215c5b5 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -1554,7 +1554,7 @@ static int soc_camera_pdrv_probe(struct platform_device *pdev)
  * hot-pluggable. Now we know, that all our users - hosts and devices have
  * been unloaded already
  */
-static int __devexit soc_camera_pdrv_remove(struct platform_device *pdev)
+static int soc_camera_pdrv_remove(struct platform_device *pdev)
 {
 	struct soc_camera_device *icd = platform_get_drvdata(pdev);
 
diff --git a/drivers/media/platform/timblogiw.c b/drivers/media/platform/timblogiw.c
index 384d2cc..d854d08 100644
--- a/drivers/media/platform/timblogiw.c
+++ b/drivers/media/platform/timblogiw.c
@@ -848,7 +848,7 @@ err:
 	return err;
 }
 
-static int __devexit timblogiw_remove(struct platform_device *pdev)
+static int timblogiw_remove(struct platform_device *pdev)
 {
 	struct timblogiw *lw = platform_get_drvdata(pdev);
 
diff --git a/drivers/media/platform/via-camera.c b/drivers/media/platform/via-camera.c
index 932c564..63e8c34 100644
--- a/drivers/media/platform/via-camera.c
+++ b/drivers/media/platform/via-camera.c
@@ -1490,7 +1490,7 @@ out_unregister:
 	return ret;
 }
 
-static __devexit int viacam_remove(struct platform_device *pdev)
+static int viacam_remove(struct platform_device *pdev)
 {
 	struct via_camera *cam = via_cam_info;
 	struct viafb_dev *viadev = pdev->dev.platform_data;
diff --git a/drivers/media/radio/radio-maxiradio.c b/drivers/media/radio/radio-maxiradio.c
index 43a892c..f14497d 100644
--- a/drivers/media/radio/radio-maxiradio.c
+++ b/drivers/media/radio/radio-maxiradio.c
@@ -172,7 +172,7 @@ errfr:
 	return retval;
 }
 
-static void __devexit maxiradio_remove(struct pci_dev *pdev)
+static void maxiradio_remove(struct pci_dev *pdev)
 {
 	struct v4l2_device *v4l2_dev = dev_get_drvdata(&pdev->dev);
 	struct maxiradio *dev = to_maxiradio(v4l2_dev);
diff --git a/drivers/media/radio/radio-sf16fmr2.c b/drivers/media/radio/radio-sf16fmr2.c
index faf84ef..04e62fb 100644
--- a/drivers/media/radio/radio-sf16fmr2.c
+++ b/drivers/media/radio/radio-sf16fmr2.c
@@ -285,7 +285,7 @@ static int fmr2_pnp_probe(struct pnp_dev *pdev,
 	return 0;
 }
 
-static void __devexit fmr2_remove(struct fmr2 *fmr2)
+static void fmr2_remove(struct fmr2 *fmr2)
 {
 	snd_tea575x_exit(&fmr2->tea);
 	release_region(fmr2->io, 2);
@@ -293,7 +293,7 @@ static void __devexit fmr2_remove(struct fmr2 *fmr2)
 	kfree(fmr2);
 }
 
-static int __devexit fmr2_isa_remove(struct device *pdev, unsigned int ndev)
+static int fmr2_isa_remove(struct device *pdev, unsigned int ndev)
 {
 	fmr2_remove(dev_get_drvdata(pdev));
 	dev_set_drvdata(pdev, NULL);
@@ -301,7 +301,7 @@ static int __devexit fmr2_isa_remove(struct device *pdev, unsigned int ndev)
 	return 0;
 }
 
-static void __devexit fmr2_pnp_remove(struct pnp_dev *pdev)
+static void fmr2_pnp_remove(struct pnp_dev *pdev)
 {
 	fmr2_remove(pnp_get_drvdata(pdev));
 	pnp_set_drvdata(pdev, NULL);
diff --git a/drivers/media/radio/radio-tea5764.c b/drivers/media/radio/radio-tea5764.c
index e38a384..a65dd76 100644
--- a/drivers/media/radio/radio-tea5764.c
+++ b/drivers/media/radio/radio-tea5764.c
@@ -552,7 +552,7 @@ errfr:
 	return ret;
 }
 
-static int __devexit tea5764_i2c_remove(struct i2c_client *client)
+static int tea5764_i2c_remove(struct i2c_client *client)
 {
 	struct tea5764_device *radio = i2c_get_clientdata(client);
 
diff --git a/drivers/media/radio/radio-timb.c b/drivers/media/radio/radio-timb.c
index 285cac3..b87effe 100644
--- a/drivers/media/radio/radio-timb.c
+++ b/drivers/media/radio/radio-timb.c
@@ -201,7 +201,7 @@ err:
 	return err;
 }
 
-static int __devexit timbradio_remove(struct platform_device *pdev)
+static int timbradio_remove(struct platform_device *pdev)
 {
 	struct timbradio *tr = platform_get_drvdata(pdev);
 
diff --git a/drivers/media/radio/saa7706h.c b/drivers/media/radio/saa7706h.c
index b7eceb8..7a3c023 100644
--- a/drivers/media/radio/saa7706h.c
+++ b/drivers/media/radio/saa7706h.c
@@ -418,7 +418,7 @@ err:
 	return err;
 }
 
-static int __devexit saa7706h_remove(struct i2c_client *client)
+static int saa7706h_remove(struct i2c_client *client)
 {
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
 
diff --git a/drivers/media/radio/si470x/radio-si470x-i2c.c b/drivers/media/radio/si470x/radio-si470x-i2c.c
index c554e92..f61747a 100644
--- a/drivers/media/radio/si470x/radio-si470x-i2c.c
+++ b/drivers/media/radio/si470x/radio-si470x-i2c.c
@@ -451,7 +451,7 @@ err_initial:
 /*
  * si470x_i2c_remove - remove the device
  */
-static __devexit int si470x_i2c_remove(struct i2c_client *client)
+static int si470x_i2c_remove(struct i2c_client *client)
 {
 	struct si470x_device *radio = i2c_get_clientdata(client);
 
diff --git a/drivers/media/radio/tef6862.c b/drivers/media/radio/tef6862.c
index 1a5a8bc..3b96293 100644
--- a/drivers/media/radio/tef6862.c
+++ b/drivers/media/radio/tef6862.c
@@ -189,7 +189,7 @@ static int tef6862_probe(struct i2c_client *client,
 	return 0;
 }
 
-static int __devexit tef6862_remove(struct i2c_client *client)
+static int tef6862_remove(struct i2c_client *client)
 {
 	struct v4l2_subdev *sd = i2c_get_clientdata(client);
 
diff --git a/drivers/media/rc/fintek-cir.c b/drivers/media/rc/fintek-cir.c
index cddeb1b..a0ff7b2 100644
--- a/drivers/media/rc/fintek-cir.c
+++ b/drivers/media/rc/fintek-cir.c
@@ -590,7 +590,7 @@ failure:
 	return ret;
 }
 
-static void __devexit fintek_remove(struct pnp_dev *pdev)
+static void fintek_remove(struct pnp_dev *pdev)
 {
 	struct fintek_dev *fintek = pnp_get_drvdata(pdev);
 	unsigned long flags;
diff --git a/drivers/media/rc/gpio-ir-recv.c b/drivers/media/rc/gpio-ir-recv.c
index 5b74f9f..d0dfa94 100644
--- a/drivers/media/rc/gpio-ir-recv.c
+++ b/drivers/media/rc/gpio-ir-recv.c
@@ -140,7 +140,7 @@ err_allocate_device:
 	return rc;
 }
 
-static int __devexit gpio_ir_recv_remove(struct platform_device *pdev)
+static int gpio_ir_recv_remove(struct platform_device *pdev)
 {
 	struct gpio_rc_dev *gpio_dev = platform_get_drvdata(pdev);
 
diff --git a/drivers/media/rc/iguanair.c b/drivers/media/rc/iguanair.c
index 9bb3cc0..6f833ef 100644
--- a/drivers/media/rc/iguanair.c
+++ b/drivers/media/rc/iguanair.c
@@ -538,7 +538,7 @@ out:
 	return ret;
 }
 
-static void __devexit iguanair_disconnect(struct usb_interface *intf)
+static void iguanair_disconnect(struct usb_interface *intf)
 {
 	struct iguanair *ir = usb_get_intfdata(intf);
 
diff --git a/drivers/media/rc/imon.c b/drivers/media/rc/imon.c
index da0e759..23f2fb3 100644
--- a/drivers/media/rc/imon.c
+++ b/drivers/media/rc/imon.c
@@ -2376,7 +2376,7 @@ fail:
 /**
  * Callback function for USB core API: disconnect
  */
-static void __devexit imon_disconnect(struct usb_interface *interface)
+static void imon_disconnect(struct usb_interface *interface)
 {
 	struct imon_context *ictx;
 	struct device *dev;
diff --git a/drivers/media/rc/ite-cir.c b/drivers/media/rc/ite-cir.c
index 40ea30d..53de82c 100644
--- a/drivers/media/rc/ite-cir.c
+++ b/drivers/media/rc/ite-cir.c
@@ -1620,7 +1620,7 @@ failure:
 	return ret;
 }
 
-static void __devexit ite_remove(struct pnp_dev *pdev)
+static void ite_remove(struct pnp_dev *pdev)
 {
 	struct ite_dev *dev = pnp_get_drvdata(pdev);
 	unsigned long flags;
diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index 1e1d381d8..8ac7287 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -1393,7 +1393,7 @@ mem_alloc_fail:
 }
 
 
-static void __devexit mceusb_dev_disconnect(struct usb_interface *intf)
+static void mceusb_dev_disconnect(struct usb_interface *intf)
 {
 	struct usb_device *dev = interface_to_usbdev(intf);
 	struct mceusb_dev *ir = usb_get_intfdata(intf);
diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index 2e8d333..45c4998 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -1116,7 +1116,7 @@ failure:
 	return ret;
 }
 
-static void __devexit nvt_remove(struct pnp_dev *pdev)
+static void nvt_remove(struct pnp_dev *pdev)
 {
 	struct nvt_dev *nvt = pnp_get_drvdata(pdev);
 	unsigned long flags;
diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
index 6f1c6ce..c82b604 100644
--- a/drivers/media/rc/redrat3.c
+++ b/drivers/media/rc/redrat3.c
@@ -1241,7 +1241,7 @@ no_endpoints:
 	return retval;
 }
 
-static void __devexit redrat3_dev_disconnect(struct usb_interface *intf)
+static void redrat3_dev_disconnect(struct usb_interface *intf)
 {
 	struct usb_device *udev = interface_to_usbdev(intf);
 	struct redrat3_dev *rr3 = usb_get_intfdata(intf);
diff --git a/drivers/media/rc/ttusbir.c b/drivers/media/rc/ttusbir.c
index 20fe3fc..2023826 100644
--- a/drivers/media/rc/ttusbir.c
+++ b/drivers/media/rc/ttusbir.c
@@ -367,7 +367,7 @@ out:
 	return ret;
 }
 
-static void __devexit ttusbir_disconnect(struct usb_interface *intf)
+static void ttusbir_disconnect(struct usb_interface *intf)
 {
 	struct ttusbir *tt = usb_get_intfdata(intf);
 	struct usb_device *udev = tt->udev;
diff --git a/drivers/media/rc/winbond-cir.c b/drivers/media/rc/winbond-cir.c
index 46466cf..664c54a 100644
--- a/drivers/media/rc/winbond-cir.c
+++ b/drivers/media/rc/winbond-cir.c
@@ -1086,7 +1086,7 @@ exit:
 	return err;
 }
 
-static void __devexit
+static void
 wbcir_remove(struct pnp_dev *device)
 {
 	struct wbcir_data *data = pnp_get_drvdata(device);
diff --git a/drivers/media/usb/usbvision/usbvision-video.c b/drivers/media/usb/usbvision/usbvision-video.c
index ee91432..0da3b9b 100644
--- a/drivers/media/usb/usbvision/usbvision-video.c
+++ b/drivers/media/usb/usbvision/usbvision-video.c
@@ -1619,7 +1619,7 @@ static int usbvision_probe(struct usb_interface *intf,
  * with no ill consequences.
  *
  */
-static void __devexit usbvision_disconnect(struct usb_interface *intf)
+static void usbvision_disconnect(struct usb_interface *intf)
 {
 	struct usb_usbvision *usbvision = to_usbvision(usb_get_intfdata(intf));
 
-- 
1.8.0

