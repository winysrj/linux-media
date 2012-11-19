Return-path: <linux-media-owner@vger.kernel.org>
Received: from viridian.itc.Virginia.EDU ([128.143.12.139]:41412 "EHLO
	viridian.itc.virginia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753462Ab2KSSde (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Nov 2012 13:33:34 -0500
From: Bill Pemberton <wfp5p@virginia.edu>
To: gregkh@linuxfoundation.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Heungjun Kim <riverful.kim@samsung.com>,
	Andy Walls <awalls@md.metrocast.net>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Tomasz Stanislawski <t.stanislaws@samsung.com>,
	Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	=?UTF-8?q?David=20H=C3=A4rdeman?= <david@hardeman.nu>,
	Hans de Goede <hdegoede@redhat.com>,
	linux-media@vger.kernel.org, ivtv-devel@ivtvdriver.org,
	mjpeg-users@lists.sourceforge.net,
	linux-arm-kernel@lists.infradead.org
Subject: =?UTF-8?q?=5BPATCH=20234/493=5D=20media=3A=20remove=20use=20of=20=5F=5Fdevinit?=
Date: Mon, 19 Nov 2012 13:23:03 -0500
Message-Id: <1353349642-3677-234-git-send-email-wfp5p@virginia.edu>
In-Reply-To: <1353349642-3677-1-git-send-email-wfp5p@virginia.edu>
References: <1353349642-3677-1-git-send-email-wfp5p@virginia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

CONFIG_HOTPLUG is going away as an option so __devinit is no longer
needed.

Signed-off-by: Bill Pemberton <wfp5p@virginia.edu>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org> 
Cc: Kyungmin Park <kyungmin.park@samsung.com> 
Cc: Heungjun Kim <riverful.kim@samsung.com> 
Cc: Andy Walls <awalls@md.metrocast.net> 
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com> 
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com> 
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com> 
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de> 
Cc: "David Härdeman" <david@hardeman.nu> 
Cc: Hans de Goede <hdegoede@redhat.com> 
Cc: linux-media@vger.kernel.org 
Cc: ivtv-devel@ivtvdriver.org 
Cc: mjpeg-users@lists.sourceforge.net 
Cc: linux-arm-kernel@lists.infradead.org 
---
 drivers/media/i2c/adv7180.c                        |  2 +-
 drivers/media/i2c/as3645a.c                        |  4 ++--
 drivers/media/i2c/m5mols/m5mols_core.c             |  2 +-
 drivers/media/i2c/vs6624.c                         |  2 +-
 drivers/media/mmc/siano/smssdio.c                  |  2 +-
 drivers/media/pci/bt8xx/bt878.c                    |  4 ++--
 drivers/media/pci/bt8xx/bttv-cards.c               | 26 +++++++++++-----------
 drivers/media/pci/bt8xx/bttv-driver.c              |  4 ++--
 drivers/media/pci/bt8xx/bttv-i2c.c                 |  4 ++--
 drivers/media/pci/bt8xx/bttv-input.c               |  2 +-
 drivers/media/pci/bt8xx/dvb-bt8xx.c                |  6 ++---
 drivers/media/pci/cx18/cx18-driver.c               | 10 ++++-----
 drivers/media/pci/cx23885/cx23885-core.c           |  2 +-
 drivers/media/pci/cx25821/cx25821-core.c           |  2 +-
 drivers/media/pci/cx88/cx88-alsa.c                 |  6 ++---
 drivers/media/pci/cx88/cx88-mpeg.c                 |  2 +-
 drivers/media/pci/cx88/cx88-video.c                |  2 +-
 drivers/media/pci/ddbridge/ddbridge-core.c         |  2 +-
 drivers/media/pci/dm1105/dm1105.c                  | 12 +++++-----
 drivers/media/pci/ivtv/ivtv-driver.c               |  6 ++---
 drivers/media/pci/mantis/hopper_cards.c            |  4 ++--
 drivers/media/pci/mantis/mantis_cards.c            |  4 ++--
 drivers/media/pci/mantis/mantis_dvb.c              |  2 +-
 drivers/media/pci/mantis/mantis_i2c.c              |  2 +-
 drivers/media/pci/mantis/mantis_pci.c              |  2 +-
 drivers/media/pci/meye/meye.c                      |  2 +-
 drivers/media/pci/ngene/ngene-core.c               |  2 +-
 drivers/media/pci/ngene/ngene.h                    |  2 +-
 drivers/media/pci/pluto2/pluto2.c                  | 16 ++++++-------
 drivers/media/pci/pt1/pt1.c                        |  2 +-
 drivers/media/pci/saa7134/saa7134-core.c           |  4 ++--
 drivers/media/pci/saa7164/saa7164-core.c           |  2 +-
 drivers/media/pci/sta2x11/sta2x11_vip.c            |  2 +-
 drivers/media/pci/ttpci/av7110.c                   |  2 +-
 drivers/media/pci/ttpci/av7110_ir.c                |  2 +-
 drivers/media/pci/zoran/zoran_card.c               |  9 ++++----
 drivers/media/platform/blackfin/bfin_capture.c     |  2 +-
 drivers/media/platform/coda.c                      |  2 +-
 drivers/media/platform/davinci/dm355_ccdc.c        |  2 +-
 drivers/media/platform/davinci/dm644x_ccdc.c       |  2 +-
 drivers/media/platform/davinci/isif.c              |  2 +-
 drivers/media/platform/davinci/vpbe.c              |  2 +-
 drivers/media/platform/davinci/vpbe_display.c      |  6 ++---
 drivers/media/platform/davinci/vpfe_capture.c      |  2 +-
 drivers/media/platform/davinci/vpif.c              |  2 +-
 drivers/media/platform/davinci/vpss.c              |  2 +-
 drivers/media/platform/fsl-viu.c                   |  2 +-
 drivers/media/platform/omap24xxcam.c               |  2 +-
 drivers/media/platform/omap3isp/isp.c              |  2 +-
 drivers/media/platform/s5p-fimc/fimc-lite.c        |  2 +-
 drivers/media/platform/s5p-fimc/mipi-csis.c        |  2 +-
 drivers/media/platform/s5p-tv/hdmi_drv.c           |  2 +-
 drivers/media/platform/s5p-tv/hdmiphy_drv.c        |  2 +-
 drivers/media/platform/s5p-tv/mixer.h              |  2 +-
 drivers/media/platform/s5p-tv/mixer_drv.c          |  8 +++----
 drivers/media/platform/s5p-tv/mixer_video.c        |  2 +-
 drivers/media/platform/s5p-tv/sdo_drv.c            |  2 +-
 drivers/media/platform/s5p-tv/sii9234_drv.c        |  2 +-
 drivers/media/platform/sh_vou.c                    |  2 +-
 drivers/media/platform/soc_camera/atmel-isi.c      |  2 +-
 drivers/media/platform/soc_camera/mx2_camera.c     |  4 ++--
 drivers/media/platform/soc_camera/mx3_camera.c     |  2 +-
 drivers/media/platform/soc_camera/pxa_camera.c     |  2 +-
 .../platform/soc_camera/sh_mobile_ceu_camera.c     |  2 +-
 drivers/media/platform/soc_camera/sh_mobile_csi2.c |  2 +-
 drivers/media/platform/soc_camera/soc_camera.c     |  2 +-
 drivers/media/platform/timblogiw.c                 |  2 +-
 drivers/media/platform/via-camera.c                |  4 ++--
 drivers/media/radio/radio-maxiradio.c              |  2 +-
 drivers/media/radio/radio-sf16fmr2.c               |  6 ++---
 drivers/media/radio/radio-tea5764.c                |  2 +-
 drivers/media/radio/radio-timb.c                   |  2 +-
 drivers/media/radio/radio-wl1273.c                 |  2 +-
 drivers/media/radio/saa7706h.c                     |  2 +-
 drivers/media/radio/si470x/radio-si470x-i2c.c      |  2 +-
 drivers/media/radio/tef6862.c                      |  2 +-
 drivers/media/rc/gpio-ir-recv.c                    |  2 +-
 drivers/media/rc/iguanair.c                        |  2 +-
 drivers/media/rc/imon.c                            |  2 +-
 drivers/media/rc/ir-rx51.c                         |  2 +-
 drivers/media/rc/mceusb.c                          |  2 +-
 drivers/media/rc/redrat3.c                         |  2 +-
 drivers/media/rc/streamzap.c                       |  2 +-
 drivers/media/rc/ttusbir.c                         |  2 +-
 drivers/media/rc/winbond-cir.c                     |  2 +-
 drivers/media/usb/gspca/spca506.c                  |  2 +-
 drivers/media/usb/siano/smsusb.c                   |  2 +-
 drivers/media/usb/usbvision/usbvision-video.c      |  4 ++--
 88 files changed, 142 insertions(+), 143 deletions(-)

diff --git a/drivers/media/i2c/adv7180.c b/drivers/media/i2c/adv7180.c
index 801e9be..3ceee8d 100644
--- a/drivers/media/i2c/adv7180.c
+++ b/drivers/media/i2c/adv7180.c
@@ -540,7 +540,7 @@ static int init_device(struct i2c_client *client, struct adv7180_state *state)
 	return 0;
 }
 
-static __devinit int adv7180_probe(struct i2c_client *client,
+static int adv7180_probe(struct i2c_client *client,
 				   const struct i2c_device_id *id)
 {
 	struct adv7180_state *state;
diff --git a/drivers/media/i2c/as3645a.c b/drivers/media/i2c/as3645a.c
index fc8ad56..810d681 100644
--- a/drivers/media/i2c/as3645a.c
+++ b/drivers/media/i2c/as3645a.c
@@ -713,7 +713,7 @@ static int as3645a_resume(struct device *dev)
  * The number of LEDs reported in platform data is used to compute default
  * limits. Parameters passed through platform data can override those limits.
  */
-static int __devinit as3645a_init_controls(struct as3645a *flash)
+static int as3645a_init_controls(struct as3645a *flash)
 {
 	const struct as3645a_platform_data *pdata = flash->pdata;
 	struct v4l2_ctrl *ctrl;
@@ -804,7 +804,7 @@ static int __devinit as3645a_init_controls(struct as3645a *flash)
 	return flash->ctrls.error;
 }
 
-static int __devinit as3645a_probe(struct i2c_client *client,
+static int as3645a_probe(struct i2c_client *client,
 				   const struct i2c_device_id *devid)
 {
 	struct as3645a *flash;
diff --git a/drivers/media/i2c/m5mols/m5mols_core.c b/drivers/media/i2c/m5mols/m5mols_core.c
index 7877a2a..3f10efa 100644
--- a/drivers/media/i2c/m5mols/m5mols_core.c
+++ b/drivers/media/i2c/m5mols/m5mols_core.c
@@ -926,7 +926,7 @@ static irqreturn_t m5mols_irq_handler(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
-static int __devinit m5mols_probe(struct i2c_client *client,
+static int m5mols_probe(struct i2c_client *client,
 				  const struct i2c_device_id *id)
 {
 	const struct m5mols_platform_data *pdata = client->dev.platform_data;
diff --git a/drivers/media/i2c/vs6624.c b/drivers/media/i2c/vs6624.c
index 165c44a..fe54f53 100644
--- a/drivers/media/i2c/vs6624.c
+++ b/drivers/media/i2c/vs6624.c
@@ -788,7 +788,7 @@ static const struct v4l2_subdev_ops vs6624_ops = {
 	.video = &vs6624_video_ops,
 };
 
-static int __devinit vs6624_probe(struct i2c_client *client,
+static int vs6624_probe(struct i2c_client *client,
 			const struct i2c_device_id *id)
 {
 	struct vs6624 *sensor;
diff --git a/drivers/media/mmc/siano/smssdio.c b/drivers/media/mmc/siano/smssdio.c
index d6f3f10..0a61bc6 100644
--- a/drivers/media/mmc/siano/smssdio.c
+++ b/drivers/media/mmc/siano/smssdio.c
@@ -224,7 +224,7 @@ static void smssdio_interrupt(struct sdio_func *func)
 	smscore_onresponse(smsdev->coredev, cb);
 }
 
-static int __devinit smssdio_probe(struct sdio_func *func,
+static int smssdio_probe(struct sdio_func *func,
 			 const struct sdio_device_id *id)
 {
 	int ret;
diff --git a/drivers/media/pci/bt8xx/bt878.c b/drivers/media/pci/bt8xx/bt878.c
index 4225a79..da00f34 100644
--- a/drivers/media/pci/bt8xx/bt878.c
+++ b/drivers/media/pci/bt8xx/bt878.c
@@ -410,7 +410,7 @@ static struct pci_device_id bt878_pci_tbl[] __devinitdata = {
 
 MODULE_DEVICE_TABLE(pci, bt878_pci_tbl);
 
-static const char * __devinit card_name(const struct pci_device_id *id)
+static const char *card_name(const struct pci_device_id *id)
 {
 	return id->driver_data ? (const char *)id->driver_data : "Unknown";
 }
@@ -419,7 +419,7 @@ static const char * __devinit card_name(const struct pci_device_id *id)
 /* PCI device handling */
 /***********************/
 
-static int __devinit bt878_probe(struct pci_dev *dev,
+static int bt878_probe(struct pci_dev *dev,
 				 const struct pci_device_id *pci_id)
 {
 	int result = 0;
diff --git a/drivers/media/pci/bt8xx/bttv-cards.c b/drivers/media/pci/bt8xx/bttv-cards.c
index 38952fa..f8a5f42 100644
--- a/drivers/media/pci/bt8xx/bttv-cards.c
+++ b/drivers/media/pci/bt8xx/bttv-cards.c
@@ -87,7 +87,7 @@ static int tea5757_read(struct bttv *btv);
 static int tea5757_write(struct bttv *btv, int value);
 static void identify_by_eeprom(struct bttv *btv,
 			       unsigned char eeprom_data[256]);
-static int __devinit pvr_boot(struct bttv *btv);
+static int pvr_boot(struct bttv *btv);
 
 /* config variables */
 static unsigned int triton1;
@@ -2837,7 +2837,7 @@ static unsigned char eeprom_data[256];
 /*
  * identify card
  */
-void __devinit bttv_idcard(struct bttv *btv)
+void bttv_idcard(struct bttv *btv)
 {
 	unsigned int gpiobits;
 	int i,type;
@@ -3235,7 +3235,7 @@ static void bttv_reset_audio(struct bttv *btv)
 }
 
 /* initialization part one -- before registering i2c bus */
-void __devinit bttv_init_card1(struct bttv *btv)
+void bttv_init_card1(struct bttv *btv)
 {
 	switch (btv->c.type) {
 	case BTTV_BOARD_HAUPPAUGE:
@@ -3267,7 +3267,7 @@ void __devinit bttv_init_card1(struct bttv *btv)
 }
 
 /* initialization part two -- after registering i2c bus */
-void __devinit bttv_init_card2(struct bttv *btv)
+void bttv_init_card2(struct bttv *btv)
 {
 	btv->tuner_type = UNSET;
 
@@ -3571,7 +3571,7 @@ no_audio:
 
 
 /* initialize the tuner */
-void __devinit bttv_init_tuner(struct bttv *btv)
+void bttv_init_tuner(struct bttv *btv)
 {
 	int addr = ADDR_UNSET;
 
@@ -3635,7 +3635,7 @@ static void modtec_eeprom(struct bttv *btv)
 	}
 }
 
-static void __devinit hauppauge_eeprom(struct bttv *btv)
+static void hauppauge_eeprom(struct bttv *btv)
 {
 	struct tveeprom tv;
 
@@ -3709,7 +3709,7 @@ static int terratec_active_radio_upgrade(struct bttv *btv)
 #define BTTV_ALT_DCLK		0x100000
 #define BTTV_ALT_NCONFIG	0x800000
 
-static int __devinit pvr_altera_load(struct bttv *btv, const u8 *micro,
+static int pvr_altera_load(struct bttv *btv, const u8 *micro,
 				     u32 microlen)
 {
 	u32 n;
@@ -3747,7 +3747,7 @@ static int __devinit pvr_altera_load(struct bttv *btv, const u8 *micro,
 	return 0;
 }
 
-static int __devinit pvr_boot(struct bttv *btv)
+static int pvr_boot(struct bttv *btv)
 {
 	const struct firmware *fw_entry;
 	int rc;
@@ -3767,7 +3767,7 @@ static int __devinit pvr_boot(struct bttv *btv)
 /* ----------------------------------------------------------------------- */
 /* some osprey specific stuff                                              */
 
-static void __devinit osprey_eeprom(struct bttv *btv, const u8 ee[256])
+static void osprey_eeprom(struct bttv *btv, const u8 ee[256])
 {
 	int i;
 	u32 serial = 0;
@@ -3898,7 +3898,7 @@ static int tuner_1_table[] = {
 	TUNER_TEMIC_4012FY5, TUNER_TEMIC_4012FY5, /* TUNER_TEMIC_SECAM */
 	TUNER_TEMIC_4012FY5, TUNER_TEMIC_PAL};
 
-static void __devinit avermedia_eeprom(struct bttv *btv)
+static void avermedia_eeprom(struct bttv *btv)
 {
 	int tuner_make, tuner_tv_fm, tuner_format, tuner_type = 0;
 
@@ -3960,7 +3960,7 @@ u32 bttv_tda9880_setnorm(struct bttv *btv, u32 gpiobits)
  * Hauppauge:  pin  5
  * Voodoo:     pin 20
  */
-static void __devinit boot_msp34xx(struct bttv *btv, int pin)
+static void boot_msp34xx(struct bttv *btv, int pin)
 {
 	int mask = (1 << pin);
 
@@ -3983,7 +3983,7 @@ static void __devinit boot_msp34xx(struct bttv *btv, int pin)
  *  used by Alessandro Rubini in his pxc200
  *  driver, but using BTTV functions */
 
-static void __devinit init_PXC200(struct bttv *btv)
+static void init_PXC200(struct bttv *btv)
 {
 	static int vals[] __devinitdata = { 0x08, 0x09, 0x0a, 0x0b, 0x0d, 0x0d,
 					    0x01, 0x02, 0x03, 0x04, 0x05, 0x06,
@@ -4851,7 +4851,7 @@ void __init bttv_check_chipset(void)
 	}
 }
 
-int __devinit bttv_handle_chipset(struct bttv *btv)
+int bttv_handle_chipset(struct bttv *btv)
 {
 	unsigned char command;
 
diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
index 47a413b..61a2105 100644
--- a/drivers/media/pci/bt8xx/bttv-driver.c
+++ b/drivers/media/pci/bt8xx/bttv-driver.c
@@ -4200,7 +4200,7 @@ static void bttv_unregister_video(struct bttv *btv)
 }
 
 /* register video4linux devices */
-static int __devinit bttv_register_video(struct bttv *btv)
+static int bttv_register_video(struct bttv *btv)
 {
 	if (no_overlay > 0)
 		pr_notice("Overlay support disabled\n");
@@ -4266,7 +4266,7 @@ static void pci_set_command(struct pci_dev *dev)
 #endif
 }
 
-static int __devinit bttv_probe(struct pci_dev *dev,
+static int bttv_probe(struct pci_dev *dev,
 				const struct pci_device_id *pci_id)
 {
 	int result;
diff --git a/drivers/media/pci/bt8xx/bttv-i2c.c b/drivers/media/pci/bt8xx/bttv-i2c.c
index 580c8e6..95f5f64 100644
--- a/drivers/media/pci/bt8xx/bttv-i2c.c
+++ b/drivers/media/pci/bt8xx/bttv-i2c.c
@@ -312,7 +312,7 @@ int bttv_I2CWrite(struct bttv *btv, unsigned char addr, unsigned char b1,
 }
 
 /* read EEPROM content */
-void __devinit bttv_readee(struct bttv *btv, unsigned char *eedata, int addr)
+void bttv_readee(struct bttv *btv, unsigned char *eedata, int addr)
 {
 	memset(eedata, 0, 256);
 	if (0 != btv->i2c_rc)
@@ -347,7 +347,7 @@ static void do_i2c_scan(char *name, struct i2c_client *c)
 }
 
 /* init + register i2c adapter */
-int __devinit init_bttv_i2c(struct bttv *btv)
+int init_bttv_i2c(struct bttv *btv)
 {
 	strlcpy(btv->i2c_client.name, "bttv internal", I2C_NAME_SIZE);
 
diff --git a/drivers/media/pci/bt8xx/bttv-input.c b/drivers/media/pci/bt8xx/bttv-input.c
index ef4c7cd..ad9a62d 100644
--- a/drivers/media/pci/bt8xx/bttv-input.c
+++ b/drivers/media/pci/bt8xx/bttv-input.c
@@ -368,7 +368,7 @@ static int get_key_pv951(struct IR_i2c *ir, u32 *ir_key, u32 *ir_raw)
 }
 
 /* Instantiate the I2C IR receiver device, if present */
-void __devinit init_bttv_i2c_ir(struct bttv *btv)
+void init_bttv_i2c_ir(struct bttv *btv)
 {
 	const unsigned short addr_list[] = {
 		0x1a, 0x18, 0x64, 0x30, 0x71,
diff --git a/drivers/media/pci/bt8xx/dvb-bt8xx.c b/drivers/media/pci/bt8xx/dvb-bt8xx.c
index 81fab9a..c0adb94 100644
--- a/drivers/media/pci/bt8xx/dvb-bt8xx.c
+++ b/drivers/media/pci/bt8xx/dvb-bt8xx.c
@@ -118,7 +118,7 @@ static int is_pci_slot_eq(struct pci_dev* adev, struct pci_dev* bdev)
 	return 0;
 }
 
-static struct bt878 __devinit *dvb_bt8xx_878_match(unsigned int bttv_nr, struct pci_dev* bttv_pci_dev)
+static struct bt878 *dvb_bt8xx_878_match(unsigned int bttv_nr, struct pci_dev* bttv_pci_dev)
 {
 	unsigned int card_nr;
 
@@ -720,7 +720,7 @@ static void frontend_init(struct dvb_bt8xx_card *card, u32 type)
 		}
 }
 
-static int __devinit dvb_bt8xx_load_card(struct dvb_bt8xx_card *card, u32 type)
+static int dvb_bt8xx_load_card(struct dvb_bt8xx_card *card, u32 type)
 {
 	int result;
 
@@ -811,7 +811,7 @@ err_unregister_adaptor:
 	return result;
 }
 
-static int __devinit dvb_bt8xx_probe(struct bttv_sub_device *sub)
+static int dvb_bt8xx_probe(struct bttv_sub_device *sub)
 {
 	struct dvb_bt8xx_card *card;
 	struct pci_dev* bttv_pci_dev;
diff --git a/drivers/media/pci/cx18/cx18-driver.c b/drivers/media/pci/cx18/cx18-driver.c
index 039133d..1d0f65b 100644
--- a/drivers/media/pci/cx18/cx18-driver.c
+++ b/drivers/media/pci/cx18/cx18-driver.c
@@ -691,7 +691,7 @@ done:
 	cx->card_i2c = cx->card->i2c;
 }
 
-static int __devinit cx18_create_in_workq(struct cx18 *cx)
+static int cx18_create_in_workq(struct cx18 *cx)
 {
 	snprintf(cx->in_workq_name, sizeof(cx->in_workq_name), "%s-in",
 		 cx->v4l2_dev.name);
@@ -703,7 +703,7 @@ static int __devinit cx18_create_in_workq(struct cx18 *cx)
 	return 0;
 }
 
-static void __devinit cx18_init_in_work_orders(struct cx18 *cx)
+static void cx18_init_in_work_orders(struct cx18 *cx)
 {
 	int i;
 	for (i = 0; i < CX18_MAX_IN_WORK_ORDERS; i++) {
@@ -718,7 +718,7 @@ static void __devinit cx18_init_in_work_orders(struct cx18 *cx)
    No assumptions on the card type may be made here (see cx18_init_struct2
    for that).
  */
-static int __devinit cx18_init_struct1(struct cx18 *cx)
+static int cx18_init_struct1(struct cx18 *cx)
 {
 	int ret;
 
@@ -775,7 +775,7 @@ static int __devinit cx18_init_struct1(struct cx18 *cx)
 
 /* Second initialization part. Here the card type has been
    autodetected. */
-static void __devinit cx18_init_struct2(struct cx18 *cx)
+static void cx18_init_struct2(struct cx18 *cx)
 {
 	int i;
 
@@ -892,7 +892,7 @@ static void cx18_init_subdevs(struct cx18 *cx)
 		cx->sd_extmux = cx18_find_hw(cx, cx->card->hw_muxer);
 }
 
-static int __devinit cx18_probe(struct pci_dev *pci_dev,
+static int cx18_probe(struct pci_dev *pci_dev,
 				const struct pci_device_id *pci_id)
 {
 	int retval = 0;
diff --git a/drivers/media/pci/cx23885/cx23885-core.c b/drivers/media/pci/cx23885/cx23885-core.c
index 96166ae..09b251e 100644
--- a/drivers/media/pci/cx23885/cx23885-core.c
+++ b/drivers/media/pci/cx23885/cx23885-core.c
@@ -2088,7 +2088,7 @@ void cx23885_gpio_enable(struct cx23885_dev *dev, u32 mask, int asoutput)
 	/* TODO: 23-19 */
 }
 
-static int __devinit cx23885_initdev(struct pci_dev *pci_dev,
+static int cx23885_initdev(struct pci_dev *pci_dev,
 				     const struct pci_device_id *pci_id)
 {
 	struct cx23885_dev *dev;
diff --git a/drivers/media/pci/cx25821/cx25821-core.c b/drivers/media/pci/cx25821/cx25821-core.c
index 6b8c416..6236f80 100644
--- a/drivers/media/pci/cx25821/cx25821-core.c
+++ b/drivers/media/pci/cx25821/cx25821-core.c
@@ -1361,7 +1361,7 @@ struct cx25821_dev *cx25821_dev_get(struct pci_dev *pci)
 }
 EXPORT_SYMBOL(cx25821_dev_get);
 
-static int __devinit cx25821_initdev(struct pci_dev *pci_dev,
+static int cx25821_initdev(struct pci_dev *pci_dev,
 				     const struct pci_device_id *pci_id)
 {
 	struct cx25821_dev *dev;
diff --git a/drivers/media/pci/cx88/cx88-alsa.c b/drivers/media/pci/cx88/cx88-alsa.c
index 0934390..13d4481 100644
--- a/drivers/media/pci/cx88/cx88-alsa.c
+++ b/drivers/media/pci/cx88/cx88-alsa.c
@@ -536,7 +536,7 @@ static struct snd_pcm_ops snd_cx88_pcm_ops = {
 /*
  * create a PCM device
  */
-static int __devinit snd_cx88_pcm(snd_cx88_card_t *chip, int device, const char *name)
+static int snd_cx88_pcm(snd_cx88_card_t *chip, int device, const char *name)
 {
 	int err;
 	struct snd_pcm *pcm;
@@ -788,7 +788,7 @@ static void snd_cx88_dev_free(struct snd_card * card)
  */
 
 static int devno;
-static int __devinit snd_cx88_create(struct snd_card *card,
+static int snd_cx88_create(struct snd_card *card,
 				     struct pci_dev *pci,
 				     snd_cx88_card_t **rchip,
 				     struct cx88_core **core_ptr)
@@ -858,7 +858,7 @@ static int __devinit snd_cx88_create(struct snd_card *card,
 	return 0;
 }
 
-static int __devinit cx88_audio_initdev(struct pci_dev *pci,
+static int cx88_audio_initdev(struct pci_dev *pci,
 				    const struct pci_device_id *pci_id)
 {
 	struct snd_card  *card;
diff --git a/drivers/media/pci/cx88/cx88-mpeg.c b/drivers/media/pci/cx88/cx88-mpeg.c
index ef5656f..a2be7df 100644
--- a/drivers/media/pci/cx88/cx88-mpeg.c
+++ b/drivers/media/pci/cx88/cx88-mpeg.c
@@ -789,7 +789,7 @@ int cx8802_unregister_driver(struct cx8802_driver *drv)
 }
 
 /* ----------------------------------------------------------- */
-static int __devinit cx8802_probe(struct pci_dev *pci_dev,
+static int cx8802_probe(struct pci_dev *pci_dev,
 			       const struct pci_device_id *pci_id)
 {
 	struct cx8802_dev *dev;
diff --git a/drivers/media/pci/cx88/cx88-video.c b/drivers/media/pci/cx88/cx88-video.c
index 657714b..62a3ae1 100644
--- a/drivers/media/pci/cx88/cx88-video.c
+++ b/drivers/media/pci/cx88/cx88-video.c
@@ -1696,7 +1696,7 @@ static void cx8800_unregister_video(struct cx8800_dev *dev)
 	}
 }
 
-static int __devinit cx8800_initdev(struct pci_dev *pci_dev,
+static int cx8800_initdev(struct pci_dev *pci_dev,
 				    const struct pci_device_id *pci_id)
 {
 	struct cx8800_dev *dev;
diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index 47ed48f..8ccbf04 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -1565,7 +1565,7 @@ static void __devexit ddb_remove(struct pci_dev *pdev)
 }
 
 
-static int __devinit ddb_probe(struct pci_dev *pdev,
+static int ddb_probe(struct pci_dev *pdev,
 			       const struct pci_device_id *id)
 {
 	struct ddb *dev;
diff --git a/drivers/media/pci/dm1105/dm1105.c b/drivers/media/pci/dm1105/dm1105.c
index 04e24bb..88df9fb 100644
--- a/drivers/media/pci/dm1105/dm1105.c
+++ b/drivers/media/pci/dm1105/dm1105.c
@@ -616,7 +616,7 @@ static void dm1105_set_dma_addr(struct dm1105_dev *dev)
 	dm_writel(DM1105_STADR, cpu_to_le32(dev->dma_addr));
 }
 
-static int __devinit dm1105_dma_map(struct dm1105_dev *dev)
+static int dm1105_dma_map(struct dm1105_dev *dev)
 {
 	dev->ts_buf = pci_alloc_consistent(dev->pdev,
 					6 * DM1105_DMA_BYTES,
@@ -736,7 +736,7 @@ static irqreturn_t dm1105_irq(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-int __devinit dm1105_ir_init(struct dm1105_dev *dm1105)
+int dm1105_ir_init(struct dm1105_dev *dm1105)
 {
 	struct rc_dev *dev;
 	int err = -ENOMEM;
@@ -781,7 +781,7 @@ void __devexit dm1105_ir_exit(struct dm1105_dev *dm1105)
 	rc_unregister_device(dm1105->ir.dev);
 }
 
-static int __devinit dm1105_hw_init(struct dm1105_dev *dev)
+static int dm1105_hw_init(struct dm1105_dev *dev)
 {
 	dm1105_disable_irqs(dev);
 
@@ -849,7 +849,7 @@ static struct ds3000_config dvbworld_ds3000_config = {
 	.demod_address = 0x68,
 };
 
-static int __devinit frontend_init(struct dm1105_dev *dev)
+static int frontend_init(struct dm1105_dev *dev)
 {
 	int ret;
 
@@ -949,7 +949,7 @@ static int __devinit frontend_init(struct dm1105_dev *dev)
 	return 0;
 }
 
-static void __devinit dm1105_read_mac(struct dm1105_dev *dev, u8 *mac)
+static void dm1105_read_mac(struct dm1105_dev *dev, u8 *mac)
 {
 	static u8 command[1] = { 0x28 };
 
@@ -971,7 +971,7 @@ static void __devinit dm1105_read_mac(struct dm1105_dev *dev, u8 *mac)
 	dev_info(&dev->pdev->dev, "MAC %pM\n", mac);
 }
 
-static int __devinit dm1105_probe(struct pci_dev *pdev,
+static int dm1105_probe(struct pci_dev *pdev,
 				  const struct pci_device_id *ent)
 {
 	struct dm1105_dev *dev;
diff --git a/drivers/media/pci/ivtv/ivtv-driver.c b/drivers/media/pci/ivtv/ivtv-driver.c
index 74e9a50..61160f7 100644
--- a/drivers/media/pci/ivtv/ivtv-driver.c
+++ b/drivers/media/pci/ivtv/ivtv-driver.c
@@ -736,7 +736,7 @@ done:
    No assumptions on the card type may be made here (see ivtv_init_struct2
    for that).
  */
-static int __devinit ivtv_init_struct1(struct ivtv *itv)
+static int ivtv_init_struct1(struct ivtv *itv)
 {
 	struct sched_param param = { .sched_priority = 99 };
 
@@ -802,7 +802,7 @@ static int __devinit ivtv_init_struct1(struct ivtv *itv)
 
 /* Second initialization part. Here the card type has been
    autodetected. */
-static void __devinit ivtv_init_struct2(struct ivtv *itv)
+static void ivtv_init_struct2(struct ivtv *itv)
 {
 	int i;
 
@@ -1001,7 +1001,7 @@ static void ivtv_load_and_init_modules(struct ivtv *itv)
 	}
 }
 
-static int __devinit ivtv_probe(struct pci_dev *pdev,
+static int ivtv_probe(struct pci_dev *pdev,
 				const struct pci_device_id *pci_id)
 {
 	int retval = 0;
diff --git a/drivers/media/pci/mantis/hopper_cards.c b/drivers/media/pci/mantis/hopper_cards.c
index cc0251e..5b9778a 100644
--- a/drivers/media/pci/mantis/hopper_cards.c
+++ b/drivers/media/pci/mantis/hopper_cards.c
@@ -151,7 +151,7 @@ static irqreturn_t hopper_irq_handler(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static int __devinit hopper_pci_probe(struct pci_dev *pdev, const struct pci_device_id *pci_id)
+static int hopper_pci_probe(struct pci_dev *pdev, const struct pci_device_id *pci_id)
 {
 	struct mantis_pci *mantis;
 	struct mantis_hwconfig *config;
@@ -259,7 +259,7 @@ static struct pci_driver hopper_pci_driver = {
 	.remove		= hopper_pci_remove,
 };
 
-static int __devinit hopper_init(void)
+static int hopper_init(void)
 {
 	return pci_register_driver(&hopper_pci_driver);
 }
diff --git a/drivers/media/pci/mantis/mantis_cards.c b/drivers/media/pci/mantis/mantis_cards.c
index 0207d1f..45fe3db 100644
--- a/drivers/media/pci/mantis/mantis_cards.c
+++ b/drivers/media/pci/mantis/mantis_cards.c
@@ -159,7 +159,7 @@ static irqreturn_t mantis_irq_handler(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static int __devinit mantis_pci_probe(struct pci_dev *pdev, const struct pci_device_id *pci_id)
+static int mantis_pci_probe(struct pci_dev *pdev, const struct pci_device_id *pci_id)
 {
 	struct mantis_pci *mantis;
 	struct mantis_hwconfig *config;
@@ -289,7 +289,7 @@ static struct pci_driver mantis_pci_driver = {
 	.remove		= mantis_pci_remove,
 };
 
-static int __devinit mantis_init(void)
+static int mantis_init(void)
 {
 	return pci_register_driver(&mantis_pci_driver);
 }
diff --git a/drivers/media/pci/mantis/mantis_dvb.c b/drivers/media/pci/mantis/mantis_dvb.c
index 5d15c6b..54e76a8 100644
--- a/drivers/media/pci/mantis/mantis_dvb.c
+++ b/drivers/media/pci/mantis/mantis_dvb.c
@@ -144,7 +144,7 @@ static int mantis_dvb_stop_feed(struct dvb_demux_feed *dvbdmxfeed)
 	return 0;
 }
 
-int __devinit mantis_dvb_init(struct mantis_pci *mantis)
+int mantis_dvb_init(struct mantis_pci *mantis)
 {
 	struct mantis_hwconfig *config = mantis->hwconfig;
 	int result = -1;
diff --git a/drivers/media/pci/mantis/mantis_i2c.c b/drivers/media/pci/mantis/mantis_i2c.c
index e779451..937fb9d 100644
--- a/drivers/media/pci/mantis/mantis_i2c.c
+++ b/drivers/media/pci/mantis/mantis_i2c.c
@@ -217,7 +217,7 @@ static struct i2c_algorithm mantis_algo = {
 	.functionality		= mantis_i2c_func,
 };
 
-int __devinit mantis_i2c_init(struct mantis_pci *mantis)
+int mantis_i2c_init(struct mantis_pci *mantis)
 {
 	u32 intstat, intmask;
 	struct i2c_adapter *i2c_adapter = &mantis->adapter;
diff --git a/drivers/media/pci/mantis/mantis_pci.c b/drivers/media/pci/mantis/mantis_pci.c
index 371558a..a846036 100644
--- a/drivers/media/pci/mantis/mantis_pci.c
+++ b/drivers/media/pci/mantis/mantis_pci.c
@@ -46,7 +46,7 @@
 
 #define DRIVER_NAME		"Mantis Core"
 
-int __devinit mantis_pci_init(struct mantis_pci *mantis)
+int mantis_pci_init(struct mantis_pci *mantis)
 {
 	u8 latency;
 	struct mantis_hwconfig *config	= mantis->hwconfig;
diff --git a/drivers/media/pci/meye/meye.c b/drivers/media/pci/meye/meye.c
index 215e0a9..bc9ef90 100644
--- a/drivers/media/pci/meye/meye.c
+++ b/drivers/media/pci/meye/meye.c
@@ -1728,7 +1728,7 @@ static int meye_resume(struct pci_dev *pdev)
 }
 #endif
 
-static int __devinit meye_probe(struct pci_dev *pcidev,
+static int meye_probe(struct pci_dev *pcidev,
 				const struct pci_device_id *ent)
 {
 	struct v4l2_device *v4l2_dev = &meye.v4l2_dev;
diff --git a/drivers/media/pci/ngene/ngene-core.c b/drivers/media/pci/ngene/ngene-core.c
index c8e0d5b..f604d57 100644
--- a/drivers/media/pci/ngene/ngene-core.c
+++ b/drivers/media/pci/ngene/ngene-core.c
@@ -1652,7 +1652,7 @@ void __devexit ngene_remove(struct pci_dev *pdev)
 	pci_disable_device(pdev);
 }
 
-int __devinit ngene_probe(struct pci_dev *pci_dev,
+int ngene_probe(struct pci_dev *pci_dev,
 			  const struct pci_device_id *id)
 {
 	struct ngene *dev;
diff --git a/drivers/media/pci/ngene/ngene.h b/drivers/media/pci/ngene/ngene.h
index 5443dc0..e23d1f6 100644
--- a/drivers/media/pci/ngene/ngene.h
+++ b/drivers/media/pci/ngene/ngene.h
@@ -887,7 +887,7 @@ struct ngene_buffer {
 
 
 /* Provided by ngene-core.c */
-int __devinit ngene_probe(struct pci_dev *pci_dev,
+int ngene_probe(struct pci_dev *pci_dev,
 			  const struct pci_device_id *id);
 void __devexit ngene_remove(struct pci_dev *pdev);
 void ngene_shutdown(struct pci_dev *pdev);
diff --git a/drivers/media/pci/pluto2/pluto2.c b/drivers/media/pci/pluto2/pluto2.c
index e4edb5f..de26be3 100644
--- a/drivers/media/pci/pluto2/pluto2.c
+++ b/drivers/media/pci/pluto2/pluto2.c
@@ -240,7 +240,7 @@ static void pluto_set_dma_addr(struct pluto *pluto)
 	pluto_writereg(pluto, REG_PCAR, pluto->dma_addr);
 }
 
-static int __devinit pluto_dma_map(struct pluto *pluto)
+static int pluto_dma_map(struct pluto *pluto)
 {
 	pluto->dma_addr = pci_map_single(pluto->pdev, pluto->dma_buf,
 			TS_DMA_BYTES, PCI_DMA_FROMDEVICE);
@@ -368,7 +368,7 @@ static irqreturn_t pluto_irq(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static void __devinit pluto_enable_irqs(struct pluto *pluto)
+static void pluto_enable_irqs(struct pluto *pluto)
 {
 	u32 val = pluto_readreg(pluto, REG_TSCR);
 
@@ -394,7 +394,7 @@ static void pluto_disable_irqs(struct pluto *pluto)
 	pluto_write_tscr(pluto, val);
 }
 
-static int __devinit pluto_hw_init(struct pluto *pluto)
+static int pluto_hw_init(struct pluto *pluto)
 {
 	pluto_reset_frontend(pluto, 1);
 
@@ -515,7 +515,7 @@ static struct tda1004x_config pluto2_fe_config __devinitdata = {
 	.request_firmware = pluto2_request_firmware,
 };
 
-static int __devinit frontend_init(struct pluto *pluto)
+static int frontend_init(struct pluto *pluto)
 {
 	int ret;
 
@@ -536,14 +536,14 @@ static int __devinit frontend_init(struct pluto *pluto)
 	return 0;
 }
 
-static void __devinit pluto_read_rev(struct pluto *pluto)
+static void pluto_read_rev(struct pluto *pluto)
 {
 	u32 val = pluto_readreg(pluto, REG_MISC) & MISC_DVR;
 	dev_info(&pluto->pdev->dev, "board revision %d.%d\n",
 			(val >> 12) & 0x0f, (val >> 4) & 0xff);
 }
 
-static void __devinit pluto_read_mac(struct pluto *pluto, u8 *mac)
+static void pluto_read_mac(struct pluto *pluto, u8 *mac)
 {
 	u32 val = pluto_readreg(pluto, REG_MMAC);
 	mac[0] = (val >> 8) & 0xff;
@@ -560,7 +560,7 @@ static void __devinit pluto_read_mac(struct pluto *pluto, u8 *mac)
 	dev_info(&pluto->pdev->dev, "MAC %pM\n", mac);
 }
 
-static int __devinit pluto_read_serial(struct pluto *pluto)
+static int pluto_read_serial(struct pluto *pluto)
 {
 	struct pci_dev *pdev = pluto->pdev;
 	unsigned int i, j;
@@ -588,7 +588,7 @@ out:
 	return 0;
 }
 
-static int __devinit pluto2_probe(struct pci_dev *pdev,
+static int pluto2_probe(struct pci_dev *pdev,
 				  const struct pci_device_id *ent)
 {
 	struct pluto *pluto;
diff --git a/drivers/media/pci/pt1/pt1.c b/drivers/media/pci/pt1/pt1.c
index 875e6dc..4eec33a 100644
--- a/drivers/media/pci/pt1/pt1.c
+++ b/drivers/media/pci/pt1/pt1.c
@@ -1083,7 +1083,7 @@ static void __devexit pt1_remove(struct pci_dev *pdev)
 	pci_disable_device(pdev);
 }
 
-static int __devinit
+static int
 pt1_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	int ret;
diff --git a/drivers/media/pci/saa7134/saa7134-core.c b/drivers/media/pci/saa7134/saa7134-core.c
index 7d1cf2c..7719e11 100644
--- a/drivers/media/pci/saa7134/saa7134-core.c
+++ b/drivers/media/pci/saa7134/saa7134-core.c
@@ -754,7 +754,7 @@ static int saa7134_hwfini(struct saa7134_dev *dev)
 	return 0;
 }
 
-static void __devinit must_configure_manually(int has_eeprom)
+static void must_configure_manually(int has_eeprom)
 {
 	unsigned int i,p;
 
@@ -860,7 +860,7 @@ static void mpeg_ops_detach(struct saa7134_mpeg_ops *ops,
 	dev->mops = NULL;
 }
 
-static int __devinit saa7134_initdev(struct pci_dev *pci_dev,
+static int saa7134_initdev(struct pci_dev *pci_dev,
 				     const struct pci_device_id *pci_id)
 {
 	struct saa7134_dev *dev;
diff --git a/drivers/media/pci/saa7164/saa7164-core.c b/drivers/media/pci/saa7164/saa7164-core.c
index a6e6e60..8614b01 100644
--- a/drivers/media/pci/saa7164/saa7164-core.c
+++ b/drivers/media/pci/saa7164/saa7164-core.c
@@ -1185,7 +1185,7 @@ static int saa7164_thread_function(void *data)
 	return 0;
 }
 
-static int __devinit saa7164_initdev(struct pci_dev *pci_dev,
+static int saa7164_initdev(struct pci_dev *pci_dev,
 				     const struct pci_device_id *pci_id)
 {
 	struct saa7164_dev *dev;
diff --git a/drivers/media/pci/sta2x11/sta2x11_vip.c b/drivers/media/pci/sta2x11/sta2x11_vip.c
index 38ccdf2..7cc5636 100644
--- a/drivers/media/pci/sta2x11/sta2x11_vip.c
+++ b/drivers/media/pci/sta2x11/sta2x11_vip.c
@@ -1205,7 +1205,7 @@ static void vip_gpio_release(struct device *dev, int pin, const char *name)
  *
  * -ENODEV, device could not be detected or registered
  */
-static int __devinit sta2x11_vip_init_one(struct pci_dev *pdev,
+static int sta2x11_vip_init_one(struct pci_dev *pdev,
 					  const struct pci_device_id *ent)
 {
 	int ret;
diff --git a/drivers/media/pci/ttpci/av7110.c b/drivers/media/pci/ttpci/av7110.c
index 66fbd05..40c3172 100644
--- a/drivers/media/pci/ttpci/av7110.c
+++ b/drivers/media/pci/ttpci/av7110.c
@@ -2367,7 +2367,7 @@ static int frontend_init(struct av7110 *av7110)
  * The same behaviour of missing VSYNC can be duplicated on budget
  * cards, by seting DD1_INIT trigger mode 7 in 3rd nibble.
  */
-static int __devinit av7110_attach(struct saa7146_dev* dev,
+static int av7110_attach(struct saa7146_dev* dev,
 				   struct saa7146_pci_extension_data *pci_ext)
 {
 	const int length = TS_WIDTH * TS_HEIGHT;
diff --git a/drivers/media/pci/ttpci/av7110_ir.c b/drivers/media/pci/ttpci/av7110_ir.c
index 908f272..af00d30 100644
--- a/drivers/media/pci/ttpci/av7110_ir.c
+++ b/drivers/media/pci/ttpci/av7110_ir.c
@@ -324,7 +324,7 @@ static void ir_handler(struct av7110 *av7110, u32 ircom)
 }
 
 
-int __devinit av7110_ir_init(struct av7110 *av7110)
+int av7110_ir_init(struct av7110 *av7110)
 {
 	struct input_dev *input_dev;
 	static struct proc_dir_entry *e;
diff --git a/drivers/media/pci/zoran/zoran_card.c b/drivers/media/pci/zoran/zoran_card.c
index bca101c..7a68bbe 100644
--- a/drivers/media/pci/zoran/zoran_card.c
+++ b/drivers/media/pci/zoran/zoran_card.c
@@ -948,7 +948,7 @@ zoran_open_init_params (struct zoran *zr)
 	zr->testing = 0;
 }
 
-static void __devinit
+static void
 test_interrupts (struct zoran *zr)
 {
 	DEFINE_WAIT(wait);
@@ -974,7 +974,7 @@ test_interrupts (struct zoran *zr)
 	btwrite(icr, ZR36057_ICR);
 }
 
-static int __devinit
+static int
 zr36057_init (struct zoran *zr)
 {
 	int j, err;
@@ -1129,8 +1129,7 @@ zoran_vdev_release (struct video_device *vdev)
 	kfree(vdev);
 }
 
-static struct videocodec_master * __devinit
-zoran_setup_videocodec (struct zoran *zr,
+static struct videocodec_master *zoran_setup_videocodec (struct zoran *zr,
 			int           type)
 {
 	struct videocodec_master *m = NULL;
@@ -1192,7 +1191,7 @@ static void zoran_subdev_notify(struct v4l2_subdev *sd, unsigned int cmd, void *
  *   Scan for a Buz card (actually for the PCI controller ZR36057),
  *   request the irq and map the io memory
  */
-static int __devinit zoran_probe(struct pci_dev *pdev,
+static int zoran_probe(struct pci_dev *pdev,
 				 const struct pci_device_id *ent)
 {
 	unsigned char latency, need_latency;
diff --git a/drivers/media/platform/blackfin/bfin_capture.c b/drivers/media/platform/blackfin/bfin_capture.c
index b7c8f96..d87c7fc 100644
--- a/drivers/media/platform/blackfin/bfin_capture.c
+++ b/drivers/media/platform/blackfin/bfin_capture.c
@@ -862,7 +862,7 @@ static struct v4l2_file_operations bcap_fops = {
 	.poll = bcap_poll
 };
 
-static int __devinit bcap_probe(struct platform_device *pdev)
+static int bcap_probe(struct platform_device *pdev)
 {
 	struct bcap_device *bcap_dev;
 	struct video_device *vfd;
diff --git a/drivers/media/platform/coda.c b/drivers/media/platform/coda.c
index ec5bc4a..b618a87 100644
--- a/drivers/media/platform/coda.c
+++ b/drivers/media/platform/coda.c
@@ -1891,7 +1891,7 @@ static const struct of_device_id coda_dt_ids[] = {
 MODULE_DEVICE_TABLE(of, coda_dt_ids);
 #endif
 
-static int __devinit coda_probe(struct platform_device *pdev)
+static int coda_probe(struct platform_device *pdev)
 {
 	const struct of_device_id *of_id =
 			of_match_device(of_match_ptr(coda_dt_ids), &pdev->dev);
diff --git a/drivers/media/platform/davinci/dm355_ccdc.c b/drivers/media/platform/davinci/dm355_ccdc.c
index 5c02672..e0632cb 100644
--- a/drivers/media/platform/davinci/dm355_ccdc.c
+++ b/drivers/media/platform/davinci/dm355_ccdc.c
@@ -965,7 +965,7 @@ static struct ccdc_hw_device ccdc_hw_dev = {
 	},
 };
 
-static int __devinit dm355_ccdc_probe(struct platform_device *pdev)
+static int dm355_ccdc_probe(struct platform_device *pdev)
 {
 	void (*setup_pinmux)(void);
 	struct resource	*res;
diff --git a/drivers/media/platform/davinci/dm644x_ccdc.c b/drivers/media/platform/davinci/dm644x_ccdc.c
index 07639f4..d4b8d9e 100644
--- a/drivers/media/platform/davinci/dm644x_ccdc.c
+++ b/drivers/media/platform/davinci/dm644x_ccdc.c
@@ -957,7 +957,7 @@ static struct ccdc_hw_device ccdc_hw_dev = {
 	},
 };
 
-static int __devinit dm644x_ccdc_probe(struct platform_device *pdev)
+static int dm644x_ccdc_probe(struct platform_device *pdev)
 {
 	struct resource	*res;
 	int status = 0;
diff --git a/drivers/media/platform/davinci/isif.c b/drivers/media/platform/davinci/isif.c
index b20e2a7..1ee8a57 100644
--- a/drivers/media/platform/davinci/isif.c
+++ b/drivers/media/platform/davinci/isif.c
@@ -1032,7 +1032,7 @@ static struct ccdc_hw_device isif_hw_dev = {
 	},
 };
 
-static int __devinit isif_probe(struct platform_device *pdev)
+static int isif_probe(struct platform_device *pdev)
 {
 	void (*setup_pinmux)(void);
 	struct resource	*res;
diff --git a/drivers/media/platform/davinci/vpbe.c b/drivers/media/platform/davinci/vpbe.c
index 69d7a58..0eb7b94 100644
--- a/drivers/media/platform/davinci/vpbe.c
+++ b/drivers/media/platform/davinci/vpbe.c
@@ -803,7 +803,7 @@ static struct vpbe_device_ops vpbe_dev_ops = {
 	.set_mode = vpbe_set_mode,
 };
 
-static __devinit int vpbe_probe(struct platform_device *pdev)
+static int vpbe_probe(struct platform_device *pdev)
 {
 	struct vpbe_device *vpbe_dev;
 	struct vpbe_config *cfg;
diff --git a/drivers/media/platform/davinci/vpbe_display.c b/drivers/media/platform/davinci/vpbe_display.c
index e51302e..8ce9c9e 100644
--- a/drivers/media/platform/davinci/vpbe_display.c
+++ b/drivers/media/platform/davinci/vpbe_display.c
@@ -1603,7 +1603,7 @@ static int vpbe_device_get(struct device *dev, void *data)
 	return 0;
 }
 
-static __devinit int init_vpbe_layer(int i, struct vpbe_display *disp_dev,
+static int init_vpbe_layer(int i, struct vpbe_display *disp_dev,
 				     struct platform_device *pdev)
 {
 	struct vpbe_layer *vpbe_display_layer = NULL;
@@ -1659,7 +1659,7 @@ static __devinit int init_vpbe_layer(int i, struct vpbe_display *disp_dev,
 	return 0;
 }
 
-static __devinit int register_device(struct vpbe_layer *vpbe_display_layer,
+static int register_device(struct vpbe_layer *vpbe_display_layer,
 					struct vpbe_display *disp_dev,
 					struct platform_device *pdev) {
 	int err;
@@ -1693,7 +1693,7 @@ static __devinit int register_device(struct vpbe_layer *vpbe_display_layer,
  * This function creates device entries by register itself to the V4L2 driver
  * and initializes fields of each layer objects
  */
-static __devinit int vpbe_display_probe(struct platform_device *pdev)
+static int vpbe_display_probe(struct platform_device *pdev)
 {
 	struct vpbe_layer *vpbe_display_layer;
 	struct vpbe_display *disp_dev;
diff --git a/drivers/media/platform/davinci/vpfe_capture.c b/drivers/media/platform/davinci/vpfe_capture.c
index 79abcca..f2690bd 100644
--- a/drivers/media/platform/davinci/vpfe_capture.c
+++ b/drivers/media/platform/davinci/vpfe_capture.c
@@ -1831,7 +1831,7 @@ static struct vpfe_device *vpfe_initialize(void)
  * itself to the V4L2 driver and initializes fields of each
  * device objects
  */
-static __devinit int vpfe_probe(struct platform_device *pdev)
+static int vpfe_probe(struct platform_device *pdev)
 {
 	struct vpfe_subdev_info *sdinfo;
 	struct vpfe_config *vpfe_cfg;
diff --git a/drivers/media/platform/davinci/vpif.c b/drivers/media/platform/davinci/vpif.c
index ed00bfd..cf96cc9 100644
--- a/drivers/media/platform/davinci/vpif.c
+++ b/drivers/media/platform/davinci/vpif.c
@@ -419,7 +419,7 @@ int vpif_channel_getfid(u8 channel_id)
 }
 EXPORT_SYMBOL(vpif_channel_getfid);
 
-static int __devinit vpif_probe(struct platform_device *pdev)
+static int vpif_probe(struct platform_device *pdev)
 {
 	int status = 0;
 
diff --git a/drivers/media/platform/davinci/vpss.c b/drivers/media/platform/davinci/vpss.c
index 94ed1a3..28cc79b 100644
--- a/drivers/media/platform/davinci/vpss.c
+++ b/drivers/media/platform/davinci/vpss.c
@@ -357,7 +357,7 @@ void dm365_vpss_set_pg_frame_size(struct vpss_pg_frame_size frame_size)
 }
 EXPORT_SYMBOL(dm365_vpss_set_pg_frame_size);
 
-static int __devinit vpss_probe(struct platform_device *pdev)
+static int vpss_probe(struct platform_device *pdev)
 {
 	struct resource		*r1, *r2;
 	char *platform_name;
diff --git a/drivers/media/platform/fsl-viu.c b/drivers/media/platform/fsl-viu.c
index e577809..6444014 100644
--- a/drivers/media/platform/fsl-viu.c
+++ b/drivers/media/platform/fsl-viu.c
@@ -1480,7 +1480,7 @@ static struct video_device viu_template = {
 	.current_norm   = V4L2_STD_NTSC_M,
 };
 
-static int __devinit viu_of_probe(struct platform_device *op)
+static int viu_of_probe(struct platform_device *op)
 {
 	struct viu_dev *viu_dev;
 	struct video_device *vdev;
diff --git a/drivers/media/platform/omap24xxcam.c b/drivers/media/platform/omap24xxcam.c
index 70f45c3..8b7ccea 100644
--- a/drivers/media/platform/omap24xxcam.c
+++ b/drivers/media/platform/omap24xxcam.c
@@ -1736,7 +1736,7 @@ static struct v4l2_int_device omap24xxcam = {
  *
  */
 
-static int __devinit omap24xxcam_probe(struct platform_device *pdev)
+static int omap24xxcam_probe(struct platform_device *pdev)
 {
 	struct omap24xxcam_device *cam;
 	struct resource *mem;
diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 38db712..7f3ec2d 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -2059,7 +2059,7 @@ static int isp_map_mem_resource(struct platform_device *pdev,
  *   -EINVAL if couldn't install ISR,
  *   or clk_get return error value.
  */
-static int __devinit isp_probe(struct platform_device *pdev)
+static int isp_probe(struct platform_device *pdev)
 {
 	struct isp_platform_data *pdata = pdev->dev.platform_data;
 	struct isp_device *isp;
diff --git a/drivers/media/platform/s5p-fimc/fimc-lite.c b/drivers/media/platform/s5p-fimc/fimc-lite.c
index d460765..c2d577f 100644
--- a/drivers/media/platform/s5p-fimc/fimc-lite.c
+++ b/drivers/media/platform/s5p-fimc/fimc-lite.c
@@ -1402,7 +1402,7 @@ static int fimc_lite_clk_get(struct fimc_lite *fimc)
 	return ret;
 }
 
-static int __devinit fimc_lite_probe(struct platform_device *pdev)
+static int fimc_lite_probe(struct platform_device *pdev)
 {
 	struct flite_drvdata *drv_data = fimc_lite_get_drvdata(pdev);
 	struct fimc_lite *fimc;
diff --git a/drivers/media/platform/s5p-fimc/mipi-csis.c b/drivers/media/platform/s5p-fimc/mipi-csis.c
index 46e987e..d0ab24b 100644
--- a/drivers/media/platform/s5p-fimc/mipi-csis.c
+++ b/drivers/media/platform/s5p-fimc/mipi-csis.c
@@ -654,7 +654,7 @@ static irqreturn_t s5pcsis_irq_handler(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static int __devinit s5pcsis_probe(struct platform_device *pdev)
+static int s5pcsis_probe(struct platform_device *pdev)
 {
 	struct s5p_platform_mipi_csis *pdata;
 	struct resource *mem_res;
diff --git a/drivers/media/platform/s5p-tv/hdmi_drv.c b/drivers/media/platform/s5p-tv/hdmi_drv.c
index b8d1d86..4b5680b 100644
--- a/drivers/media/platform/s5p-tv/hdmi_drv.c
+++ b/drivers/media/platform/s5p-tv/hdmi_drv.c
@@ -830,7 +830,7 @@ fail:
 	return -ENODEV;
 }
 
-static int __devinit hdmi_probe(struct platform_device *pdev)
+static int hdmi_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct resource *res;
diff --git a/drivers/media/platform/s5p-tv/hdmiphy_drv.c b/drivers/media/platform/s5p-tv/hdmiphy_drv.c
index 3f0142b..2d3d154 100644
--- a/drivers/media/platform/s5p-tv/hdmiphy_drv.c
+++ b/drivers/media/platform/s5p-tv/hdmiphy_drv.c
@@ -279,7 +279,7 @@ static const struct v4l2_subdev_ops hdmiphy_ops = {
 	.video = &hdmiphy_video_ops,
 };
 
-static int __devinit hdmiphy_probe(struct i2c_client *client,
+static int hdmiphy_probe(struct i2c_client *client,
 	const struct i2c_device_id *id)
 {
 	struct hdmiphy_ctx *ctx;
diff --git a/drivers/media/platform/s5p-tv/mixer.h b/drivers/media/platform/s5p-tv/mixer.h
index ddb422e..b671e20 100644
--- a/drivers/media/platform/s5p-tv/mixer.h
+++ b/drivers/media/platform/s5p-tv/mixer.h
@@ -290,7 +290,7 @@ static inline struct v4l2_subdev *to_outsd(struct mxr_device *mdev)
 struct mxr_platform_data;
 
 /** acquiring common video resources */
-int __devinit mxr_acquire_video(struct mxr_device *mdev,
+int mxr_acquire_video(struct mxr_device *mdev,
 	struct mxr_output_conf *output_cont, int output_count);
 
 /** releasing common video resources */
diff --git a/drivers/media/platform/s5p-tv/mixer_drv.c b/drivers/media/platform/s5p-tv/mixer_drv.c
index 7c4b945..46d53cd 100644
--- a/drivers/media/platform/s5p-tv/mixer_drv.c
+++ b/drivers/media/platform/s5p-tv/mixer_drv.c
@@ -151,7 +151,7 @@ void mxr_power_put(struct mxr_device *mdev)
 
 /* --------- RESOURCE MANAGEMENT -------------*/
 
-static int __devinit mxr_acquire_plat_resources(struct mxr_device *mdev,
+static int mxr_acquire_plat_resources(struct mxr_device *mdev,
 	struct platform_device *pdev)
 {
 	struct resource *res;
@@ -271,7 +271,7 @@ fail:
 	return -ENODEV;
 }
 
-static int __devinit mxr_acquire_resources(struct mxr_device *mdev,
+static int mxr_acquire_resources(struct mxr_device *mdev,
 	struct platform_device *pdev)
 {
 	int ret;
@@ -310,7 +310,7 @@ static void mxr_release_layers(struct mxr_device *mdev)
 			mxr_layer_release(mdev->layer[i]);
 }
 
-static int __devinit mxr_acquire_layers(struct mxr_device *mdev,
+static int mxr_acquire_layers(struct mxr_device *mdev,
 	struct mxr_platform_data *pdata)
 {
 	mdev->layer[0] = mxr_graph_layer_create(mdev, 0);
@@ -372,7 +372,7 @@ static const struct dev_pm_ops mxr_pm_ops = {
 
 /* --------- DRIVER INITIALIZATION ---------- */
 
-static int __devinit mxr_probe(struct platform_device *pdev)
+static int mxr_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct mxr_platform_data *pdata = dev->platform_data;
diff --git a/drivers/media/platform/s5p-tv/mixer_video.c b/drivers/media/platform/s5p-tv/mixer_video.c
index 0c1cd89..780448df 100644
--- a/drivers/media/platform/s5p-tv/mixer_video.c
+++ b/drivers/media/platform/s5p-tv/mixer_video.c
@@ -63,7 +63,7 @@ done:
 	return sd;
 }
 
-int __devinit mxr_acquire_video(struct mxr_device *mdev,
+int mxr_acquire_video(struct mxr_device *mdev,
 	struct mxr_output_conf *output_conf, int output_count)
 {
 	struct device *dev = mdev->dev;
diff --git a/drivers/media/platform/s5p-tv/sdo_drv.c b/drivers/media/platform/s5p-tv/sdo_drv.c
index ebe24b7..1815b2e 100644
--- a/drivers/media/platform/s5p-tv/sdo_drv.c
+++ b/drivers/media/platform/s5p-tv/sdo_drv.c
@@ -292,7 +292,7 @@ static const struct dev_pm_ops sdo_pm_ops = {
 	.runtime_resume	 = sdo_runtime_resume,
 };
 
-static int __devinit sdo_probe(struct platform_device *pdev)
+static int sdo_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
 	struct sdo_device *sdev;
diff --git a/drivers/media/platform/s5p-tv/sii9234_drv.c b/drivers/media/platform/s5p-tv/sii9234_drv.c
index ec33e66..2c5f181 100644
--- a/drivers/media/platform/s5p-tv/sii9234_drv.c
+++ b/drivers/media/platform/s5p-tv/sii9234_drv.c
@@ -315,7 +315,7 @@ static const struct v4l2_subdev_ops sii9234_ops = {
 	.video = &sii9234_video_ops,
 };
 
-static int __devinit sii9234_probe(struct i2c_client *client,
+static int sii9234_probe(struct i2c_client *client,
 	const struct i2c_device_id *id)
 {
 	struct device *dev = &client->dev;
diff --git a/drivers/media/platform/sh_vou.c b/drivers/media/platform/sh_vou.c
index 5d609c1..08bde38 100644
--- a/drivers/media/platform/sh_vou.c
+++ b/drivers/media/platform/sh_vou.c
@@ -1325,7 +1325,7 @@ static const struct video_device sh_vou_video_template = {
 	.vfl_dir	= VFL_DIR_TX,
 };
 
-static int __devinit sh_vou_probe(struct platform_device *pdev)
+static int sh_vou_probe(struct platform_device *pdev)
 {
 	struct sh_vou_pdata *vou_pdata = pdev->dev.platform_data;
 	struct v4l2_rect *rect;
diff --git a/drivers/media/platform/soc_camera/atmel-isi.c b/drivers/media/platform/soc_camera/atmel-isi.c
index e067da1..b7f02a49 100644
--- a/drivers/media/platform/soc_camera/atmel-isi.c
+++ b/drivers/media/platform/soc_camera/atmel-isi.c
@@ -921,7 +921,7 @@ static int __devexit atmel_isi_remove(struct platform_device *pdev)
 	return 0;
 }
 
-static int __devinit atmel_isi_probe(struct platform_device *pdev)
+static int atmel_isi_probe(struct platform_device *pdev)
 {
 	unsigned int irq;
 	struct atmel_isi *isi;
diff --git a/drivers/media/platform/soc_camera/mx2_camera.c b/drivers/media/platform/soc_camera/mx2_camera.c
index ef65dda..6f3738e 100644
--- a/drivers/media/platform/soc_camera/mx2_camera.c
+++ b/drivers/media/platform/soc_camera/mx2_camera.c
@@ -1676,7 +1676,7 @@ static irqreturn_t mx27_camera_emma_irq(int irq_emma, void *data)
 	return IRQ_HANDLED;
 }
 
-static int __devinit mx27_camera_emma_init(struct platform_device *pdev)
+static int mx27_camera_emma_init(struct platform_device *pdev)
 {
 	struct mx2_camera_dev *pcdev = platform_get_drvdata(pdev);
 	struct resource *res_emma;
@@ -1734,7 +1734,7 @@ out:
 	return err;
 }
 
-static int __devinit mx2_camera_probe(struct platform_device *pdev)
+static int mx2_camera_probe(struct platform_device *pdev)
 {
 	struct mx2_camera_dev *pcdev;
 	struct resource *res_csi;
diff --git a/drivers/media/platform/soc_camera/mx3_camera.c b/drivers/media/platform/soc_camera/mx3_camera.c
index fb12f6d..e518c1f 100644
--- a/drivers/media/platform/soc_camera/mx3_camera.c
+++ b/drivers/media/platform/soc_camera/mx3_camera.c
@@ -1142,7 +1142,7 @@ static struct soc_camera_host_ops mx3_soc_camera_host_ops = {
 	.set_bus_param	= mx3_camera_set_bus_param,
 };
 
-static int __devinit mx3_camera_probe(struct platform_device *pdev)
+static int mx3_camera_probe(struct platform_device *pdev)
 {
 	struct mx3_camera_dev *mx3_cam;
 	struct resource *res;
diff --git a/drivers/media/platform/soc_camera/pxa_camera.c b/drivers/media/platform/soc_camera/pxa_camera.c
index af23c7e..ac87daf 100644
--- a/drivers/media/platform/soc_camera/pxa_camera.c
+++ b/drivers/media/platform/soc_camera/pxa_camera.c
@@ -1651,7 +1651,7 @@ static struct soc_camera_host_ops pxa_soc_camera_host_ops = {
 	.set_bus_param	= pxa_camera_set_bus_param,
 };
 
-static int __devinit pxa_camera_probe(struct platform_device *pdev)
+static int pxa_camera_probe(struct platform_device *pdev)
 {
 	struct pxa_camera_dev *pcdev;
 	struct resource *res;
diff --git a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
index 6a402a7..d6fdf59 100644
--- a/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
+++ b/drivers/media/platform/soc_camera/sh_mobile_ceu_camera.c
@@ -2070,7 +2070,7 @@ static int bus_notify(struct notifier_block *nb,
 	return NOTIFY_DONE;
 }
 
-static int __devinit sh_mobile_ceu_probe(struct platform_device *pdev)
+static int sh_mobile_ceu_probe(struct platform_device *pdev)
 {
 	struct sh_mobile_ceu_dev *pcdev;
 	struct resource *res;
diff --git a/drivers/media/platform/soc_camera/sh_mobile_csi2.c b/drivers/media/platform/soc_camera/sh_mobile_csi2.c
index 0d0344a..d965133 100644
--- a/drivers/media/platform/soc_camera/sh_mobile_csi2.c
+++ b/drivers/media/platform/soc_camera/sh_mobile_csi2.c
@@ -294,7 +294,7 @@ static struct v4l2_subdev_ops sh_csi2_subdev_ops = {
 	.video	= &sh_csi2_subdev_video_ops,
 };
 
-static __devinit int sh_csi2_probe(struct platform_device *pdev)
+static int sh_csi2_probe(struct platform_device *pdev)
 {
 	struct resource *res;
 	unsigned int irq;
diff --git a/drivers/media/platform/soc_camera/soc_camera.c b/drivers/media/platform/soc_camera/soc_camera.c
index 27038af..8c16b8a 100644
--- a/drivers/media/platform/soc_camera/soc_camera.c
+++ b/drivers/media/platform/soc_camera/soc_camera.c
@@ -1526,7 +1526,7 @@ static int soc_camera_video_start(struct soc_camera_device *icd)
 	return 0;
 }
 
-static int __devinit soc_camera_pdrv_probe(struct platform_device *pdev)
+static int soc_camera_pdrv_probe(struct platform_device *pdev)
 {
 	struct soc_camera_link *icl = pdev->dev.platform_data;
 	struct soc_camera_device *icd;
diff --git a/drivers/media/platform/timblogiw.c b/drivers/media/platform/timblogiw.c
index 4a08bd2..574b2dd 100644
--- a/drivers/media/platform/timblogiw.c
+++ b/drivers/media/platform/timblogiw.c
@@ -786,7 +786,7 @@ static __devinitconst struct video_device timblogiw_template = {
 	.tvnorms	= V4L2_STD_PAL | V4L2_STD_NTSC
 };
 
-static int __devinit timblogiw_probe(struct platform_device *pdev)
+static int timblogiw_probe(struct platform_device *pdev)
 {
 	int err;
 	struct timblogiw *lw = NULL;
diff --git a/drivers/media/platform/via-camera.c b/drivers/media/platform/via-camera.c
index eb404c2..932c564 100644
--- a/drivers/media/platform/via-camera.c
+++ b/drivers/media/platform/via-camera.c
@@ -1324,7 +1324,7 @@ static struct video_device viacam_v4l_template = {
 #define VIACAM_SERIAL_CREG 0x46
 #define VIACAM_SERIAL_BIT 0x40
 
-static __devinit bool viacam_serial_is_enabled(void)
+static bool viacam_serial_is_enabled(void)
 {
 	struct pci_bus *pbus = pci_find_bus(0, 0);
 	u8 cbyte;
@@ -1353,7 +1353,7 @@ static struct ov7670_config sensor_cfg = {
 	.clock_speed = 90,
 };
 
-static __devinit int viacam_probe(struct platform_device *pdev)
+static int viacam_probe(struct platform_device *pdev)
 {
 	int ret;
 	struct i2c_adapter *sensor_adapter;
diff --git a/drivers/media/radio/radio-maxiradio.c b/drivers/media/radio/radio-maxiradio.c
index 5bfc1a2..43a892c 100644
--- a/drivers/media/radio/radio-maxiradio.c
+++ b/drivers/media/radio/radio-maxiradio.c
@@ -114,7 +114,7 @@ static struct snd_tea575x_ops maxiradio_tea_ops = {
 	.set_direction = maxiradio_tea575x_set_direction,
 };
 
-static int __devinit maxiradio_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
+static int maxiradio_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	struct maxiradio *dev;
 	struct v4l2_device *v4l2_dev;
diff --git a/drivers/media/radio/radio-sf16fmr2.c b/drivers/media/radio/radio-sf16fmr2.c
index 354cb55..486e8cf 100644
--- a/drivers/media/radio/radio-sf16fmr2.c
+++ b/drivers/media/radio/radio-sf16fmr2.c
@@ -203,7 +203,7 @@ static struct pnp_device_id fmr2_pnp_ids[] __devinitdata = {
 };
 MODULE_DEVICE_TABLE(pnp, fmr2_pnp_ids);
 
-static int __devinit fmr2_probe(struct fmr2 *fmr2, struct device *pdev, int io)
+static int fmr2_probe(struct fmr2 *fmr2, struct device *pdev, int io)
 {
 	int err, i;
 	char *card_name = fmr2->is_fmd2 ? "SF16-FMD2" : "SF16-FMR2";
@@ -249,7 +249,7 @@ static int __devinit fmr2_probe(struct fmr2 *fmr2, struct device *pdev, int io)
 	return 0;
 }
 
-static int __devinit fmr2_isa_match(struct device *pdev, unsigned int ndev)
+static int fmr2_isa_match(struct device *pdev, unsigned int ndev)
 {
 	struct fmr2 *fmr2 = kzalloc(sizeof(*fmr2), GFP_KERNEL);
 	if (!fmr2)
@@ -265,7 +265,7 @@ static int __devinit fmr2_isa_match(struct device *pdev, unsigned int ndev)
 	return 1;
 }
 
-static int __devinit fmr2_pnp_probe(struct pnp_dev *pdev,
+static int fmr2_pnp_probe(struct pnp_dev *pdev,
 				const struct pnp_device_id *id)
 {
 	int ret;
diff --git a/drivers/media/radio/radio-tea5764.c b/drivers/media/radio/radio-tea5764.c
index 95812cb..e38a384 100644
--- a/drivers/media/radio/radio-tea5764.c
+++ b/drivers/media/radio/radio-tea5764.c
@@ -493,7 +493,7 @@ static struct video_device tea5764_radio_template = {
 };
 
 /* I2C probe: check if the device exists and register with v4l if it is */
-static int __devinit tea5764_i2c_probe(struct i2c_client *client,
+static int tea5764_i2c_probe(struct i2c_client *client,
 					const struct i2c_device_id *id)
 {
 	struct tea5764_device *radio;
diff --git a/drivers/media/radio/radio-timb.c b/drivers/media/radio/radio-timb.c
index c6ac683..285cac3 100644
--- a/drivers/media/radio/radio-timb.c
+++ b/drivers/media/radio/radio-timb.c
@@ -145,7 +145,7 @@ static const struct v4l2_file_operations timbradio_fops = {
 	.unlocked_ioctl	= video_ioctl2,
 };
 
-static int __devinit timbradio_probe(struct platform_device *pdev)
+static int timbradio_probe(struct platform_device *pdev)
 {
 	struct timb_radio_platform_data *pdata = pdev->dev.platform_data;
 	struct timbradio *tr;
diff --git a/drivers/media/radio/radio-wl1273.c b/drivers/media/radio/radio-wl1273.c
index 57f617aa..c48be19 100644
--- a/drivers/media/radio/radio-wl1273.c
+++ b/drivers/media/radio/radio-wl1273.c
@@ -1990,7 +1990,7 @@ static int wl1273_fm_radio_remove(struct platform_device *pdev)
 	return 0;
 }
 
-static int __devinit wl1273_fm_radio_probe(struct platform_device *pdev)
+static int wl1273_fm_radio_probe(struct platform_device *pdev)
 {
 	struct wl1273_core **core = pdev->dev.platform_data;
 	struct wl1273_device *radio;
diff --git a/drivers/media/radio/saa7706h.c b/drivers/media/radio/saa7706h.c
index 4ef33ac..b7eceb8 100644
--- a/drivers/media/radio/saa7706h.c
+++ b/drivers/media/radio/saa7706h.c
@@ -373,7 +373,7 @@ static const struct v4l2_subdev_ops saa7706h_ops = {
  * concerning the addresses: i2c wants 7 bit (without the r/w bit), so '>>1'
  */
 
-static int __devinit saa7706h_probe(struct i2c_client *client,
+static int saa7706h_probe(struct i2c_client *client,
 			const struct i2c_device_id *id)
 {
 	struct saa7706h_state *state;
diff --git a/drivers/media/radio/si470x/radio-si470x-i2c.c b/drivers/media/radio/si470x/radio-si470x-i2c.c
index b6de822..c554e92 100644
--- a/drivers/media/radio/si470x/radio-si470x-i2c.c
+++ b/drivers/media/radio/si470x/radio-si470x-i2c.c
@@ -347,7 +347,7 @@ end:
 /*
  * si470x_i2c_probe - probe for the device
  */
-static int __devinit si470x_i2c_probe(struct i2c_client *client,
+static int si470x_i2c_probe(struct i2c_client *client,
 		const struct i2c_device_id *id)
 {
 	struct si470x_device *radio;
diff --git a/drivers/media/radio/tef6862.c b/drivers/media/radio/tef6862.c
index 6418c4c..1a5a8bc 100644
--- a/drivers/media/radio/tef6862.c
+++ b/drivers/media/radio/tef6862.c
@@ -165,7 +165,7 @@ static const struct v4l2_subdev_ops tef6862_ops = {
  * concerning the addresses: i2c wants 7 bit (without the r/w bit), so '>>1'
  */
 
-static int __devinit tef6862_probe(struct i2c_client *client,
+static int tef6862_probe(struct i2c_client *client,
 			const struct i2c_device_id *id)
 {
 	struct tef6862_state *state;
diff --git a/drivers/media/rc/gpio-ir-recv.c b/drivers/media/rc/gpio-ir-recv.c
index cc346a8..5b74f9f 100644
--- a/drivers/media/rc/gpio-ir-recv.c
+++ b/drivers/media/rc/gpio-ir-recv.c
@@ -58,7 +58,7 @@ err_get_value:
 	return IRQ_HANDLED;
 }
 
-static int __devinit gpio_ir_recv_probe(struct platform_device *pdev)
+static int gpio_ir_recv_probe(struct platform_device *pdev)
 {
 	struct gpio_rc_dev *gpio_dev;
 	struct rc_dev *rcdev;
diff --git a/drivers/media/rc/iguanair.c b/drivers/media/rc/iguanair.c
index 1f11e39..9bb3cc0 100644
--- a/drivers/media/rc/iguanair.c
+++ b/drivers/media/rc/iguanair.c
@@ -425,7 +425,7 @@ static void iguanair_close(struct rc_dev *rdev)
 	mutex_unlock(&ir->lock);
 }
 
-static int __devinit iguanair_probe(struct usb_interface *intf,
+static int iguanair_probe(struct usb_interface *intf,
 						const struct usb_device_id *id)
 {
 	struct usb_device *udev = interface_to_usbdev(intf);
diff --git a/drivers/media/rc/imon.c b/drivers/media/rc/imon.c
index 7f26fdf..da0e759 100644
--- a/drivers/media/rc/imon.c
+++ b/drivers/media/rc/imon.c
@@ -2292,7 +2292,7 @@ static void imon_init_display(struct imon_context *ictx,
 /**
  * Callback function for USB core API: Probe
  */
-static int __devinit imon_probe(struct usb_interface *interface,
+static int imon_probe(struct usb_interface *interface,
 				const struct usb_device_id *id)
 {
 	struct usb_device *usbdev = NULL;
diff --git a/drivers/media/rc/ir-rx51.c b/drivers/media/rc/ir-rx51.c
index 82e6c1e..d84fa15 100644
--- a/drivers/media/rc/ir-rx51.c
+++ b/drivers/media/rc/ir-rx51.c
@@ -443,7 +443,7 @@ static int lirc_rx51_resume(struct platform_device *dev)
 
 #endif /* CONFIG_PM */
 
-static int __devinit lirc_rx51_probe(struct platform_device *dev)
+static int lirc_rx51_probe(struct platform_device *dev)
 {
 	lirc_rx51_driver.features = LIRC_RX51_DRIVER_FEATURES;
 	lirc_rx51.pdata = dev->dev.platform_data;
diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index 1c0d87e..1e1d381d8 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -1229,7 +1229,7 @@ out:
 	return NULL;
 }
 
-static int __devinit mceusb_dev_probe(struct usb_interface *intf,
+static int mceusb_dev_probe(struct usb_interface *intf,
 				      const struct usb_device_id *id)
 {
 	struct usb_device *dev = interface_to_usbdev(intf);
diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
index c6aa3e0..6f1c6ce 100644
--- a/drivers/media/rc/redrat3.c
+++ b/drivers/media/rc/redrat3.c
@@ -1102,7 +1102,7 @@ out:
 	return NULL;
 }
 
-static int __devinit redrat3_dev_probe(struct usb_interface *intf,
+static int redrat3_dev_probe(struct usb_interface *intf,
 				       const struct usb_device_id *id)
 {
 	struct usb_device *udev = interface_to_usbdev(intf);
diff --git a/drivers/media/rc/streamzap.c b/drivers/media/rc/streamzap.c
index d6f4bfe..8e65972 100644
--- a/drivers/media/rc/streamzap.c
+++ b/drivers/media/rc/streamzap.c
@@ -346,7 +346,7 @@ out:
  *	On any failure the return value is the ERROR
  *	On success return 0
  */
-static int __devinit streamzap_probe(struct usb_interface *intf,
+static int streamzap_probe(struct usb_interface *intf,
 				     const struct usb_device_id *id)
 {
 	struct usb_device *usbdev = interface_to_usbdev(intf);
diff --git a/drivers/media/rc/ttusbir.c b/drivers/media/rc/ttusbir.c
index 93abca7..20fe3fc 100644
--- a/drivers/media/rc/ttusbir.c
+++ b/drivers/media/rc/ttusbir.c
@@ -194,7 +194,7 @@ static void ttusbir_urb_complete(struct urb *urb)
 		dev_warn(tt->dev, "failed to resubmit urb: %d\n", rc);
 }
 
-static int __devinit ttusbir_probe(struct usb_interface *intf,
+static int ttusbir_probe(struct usb_interface *intf,
 						const struct usb_device_id *id)
 {
 	struct ttusbir *tt;
diff --git a/drivers/media/rc/winbond-cir.c b/drivers/media/rc/winbond-cir.c
index 6fafe60..46466cf 100644
--- a/drivers/media/rc/winbond-cir.c
+++ b/drivers/media/rc/winbond-cir.c
@@ -941,7 +941,7 @@ wbcir_resume(struct pnp_dev *device)
 	return 0;
 }
 
-static int __devinit
+static int
 wbcir_probe(struct pnp_dev *device, const struct pnp_device_id *dev_id)
 {
 	struct device *dev = &device->dev;
diff --git a/drivers/media/usb/gspca/spca506.c b/drivers/media/usb/gspca/spca506.c
index bab01c8..63306bc 100644
--- a/drivers/media/usb/gspca/spca506.c
+++ b/drivers/media/usb/gspca/spca506.c
@@ -590,7 +590,7 @@ static const struct usb_device_id device_table[] = {
 MODULE_DEVICE_TABLE(usb, device_table);
 
 /* -- device connect -- */
-static int __devinit sd_probe(struct usb_interface *intf,
+static int sd_probe(struct usb_interface *intf,
 			const struct usb_device_id *id)
 {
 	return gspca_dev_probe(intf, id, &sd_desc, sizeof(struct sd),
diff --git a/drivers/media/usb/siano/smsusb.c b/drivers/media/usb/siano/smsusb.c
index aac6222..de2c102 100644
--- a/drivers/media/usb/siano/smsusb.c
+++ b/drivers/media/usb/siano/smsusb.c
@@ -389,7 +389,7 @@ static int smsusb_init_device(struct usb_interface *intf, int board_id)
 	return rc;
 }
 
-static int __devinit smsusb_probe(struct usb_interface *intf,
+static int smsusb_probe(struct usb_interface *intf,
 			const struct usb_device_id *id)
 {
 	struct usb_device *udev = interface_to_usbdev(intf);
diff --git a/drivers/media/usb/usbvision/usbvision-video.c b/drivers/media/usb/usbvision/usbvision-video.c
index 77eb1ab..ee91432 100644
--- a/drivers/media/usb/usbvision/usbvision-video.c
+++ b/drivers/media/usb/usbvision/usbvision-video.c
@@ -1363,7 +1363,7 @@ static void usbvision_unregister_video(struct usb_usbvision *usbvision)
 }
 
 /* register video4linux devices */
-static int __devinit usbvision_register_video(struct usb_usbvision *usbvision)
+static int usbvision_register_video(struct usb_usbvision *usbvision)
 {
 	/* Video Device: */
 	usbvision->vdev = usbvision_vdev_init(usbvision,
@@ -1510,7 +1510,7 @@ static void usbvision_configure_video(struct usb_usbvision *usbvision)
  * if it looks like USBVISION video device
  *
  */
-static int __devinit usbvision_probe(struct usb_interface *intf,
+static int usbvision_probe(struct usb_interface *intf,
 				     const struct usb_device_id *devid)
 {
 	struct usb_device *dev = usb_get_dev(interface_to_usbdev(intf));
-- 
1.8.0

