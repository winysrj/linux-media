Return-path: <linux-media-owner@vger.kernel.org>
Received: from viridian.itc.Virginia.EDU ([128.143.12.139]:41474 "EHLO
	viridian.itc.virginia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754192Ab2KSSeb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Nov 2012 13:34:31 -0500
From: Bill Pemberton <wfp5p@virginia.edu>
To: gregkh@linuxfoundation.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Andy Walls <awalls@md.metrocast.net>,
	linux-media@vger.kernel.org, ivtv-devel@ivtvdriver.org,
	mjpeg-users@lists.sourceforge.net
Subject: [PATCH 332/493] media: remove use of __devinitdata
Date: Mon, 19 Nov 2012 13:24:41 -0500
Message-Id: <1353349642-3677-332-git-send-email-wfp5p@virginia.edu>
In-Reply-To: <1353349642-3677-1-git-send-email-wfp5p@virginia.edu>
References: <1353349642-3677-1-git-send-email-wfp5p@virginia.edu>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

CONFIG_HOTPLUG is going away as an option so __devinitdata is no
longer needed.

Signed-off-by: Bill Pemberton <wfp5p@virginia.edu>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org> 
Cc: Andy Walls <awalls@md.metrocast.net> 
Cc: linux-media@vger.kernel.org 
Cc: ivtv-devel@ivtvdriver.org 
Cc: mjpeg-users@lists.sourceforge.net 
---
 drivers/media/pci/bt8xx/bt878.c            | 2 +-
 drivers/media/pci/bt8xx/bttv-cards.c       | 4 ++--
 drivers/media/pci/bt8xx/bttv-i2c.c         | 2 +-
 drivers/media/pci/cx18/cx18-driver.c       | 2 +-
 drivers/media/pci/cx88/cx88-alsa.c         | 2 +-
 drivers/media/pci/ddbridge/ddbridge-core.c | 2 +-
 drivers/media/pci/dm1105/dm1105.c          | 2 +-
 drivers/media/pci/ivtv/ivtv-driver.c       | 2 +-
 drivers/media/pci/ngene/ngene-cards.c      | 2 +-
 drivers/media/pci/pluto2/pluto2.c          | 4 ++--
 drivers/media/pci/saa7134/saa7134.h        | 2 +-
 drivers/media/pci/zoran/zoran_card.c       | 2 +-
 drivers/media/pci/zoran/zoran_driver.c     | 2 +-
 drivers/media/radio/radio-sf16fmi.c        | 2 +-
 drivers/media/radio/radio-sf16fmr2.c       | 2 +-
 15 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/media/pci/bt8xx/bt878.c b/drivers/media/pci/bt8xx/bt878.c
index da00f34..4ce3734 100644
--- a/drivers/media/pci/bt8xx/bt878.c
+++ b/drivers/media/pci/bt8xx/bt878.c
@@ -391,7 +391,7 @@ EXPORT_SYMBOL(bt878_device_control);
 		.driver_data = (unsigned long) name \
 	}
 
-static struct pci_device_id bt878_pci_tbl[] __devinitdata = {
+static struct pci_device_id bt878_pci_tbl[] = {
 	BROOKTREE_878_DEVICE(0x0071, 0x0101, "Nebula Electronics DigiTV"),
 	BROOKTREE_878_DEVICE(0x1461, 0x0761, "AverMedia AverTV DVB-T 761"),
 	BROOKTREE_878_DEVICE(0x11bd, 0x001c, "Pinnacle PCTV Sat"),
diff --git a/drivers/media/pci/bt8xx/bttv-cards.c b/drivers/media/pci/bt8xx/bttv-cards.c
index f8a5f42..62ca1a9 100644
--- a/drivers/media/pci/bt8xx/bttv-cards.c
+++ b/drivers/media/pci/bt8xx/bttv-cards.c
@@ -151,7 +151,7 @@ static struct CARD {
 	unsigned id;
 	int cardnr;
 	char *name;
-} cards[] __devinitdata = {
+} cards[] = {
 	{ 0x13eb0070, BTTV_BOARD_HAUPPAUGE878,  "Hauppauge WinTV" },
 	{ 0x39000070, BTTV_BOARD_HAUPPAUGE878,  "Hauppauge WinTV-D" },
 	{ 0x45000070, BTTV_BOARD_HAUPPAUGEPVR,  "Hauppauge WinTV/PVR" },
@@ -3985,7 +3985,7 @@ static void boot_msp34xx(struct bttv *btv, int pin)
 
 static void init_PXC200(struct bttv *btv)
 {
-	static int vals[] __devinitdata = { 0x08, 0x09, 0x0a, 0x0b, 0x0d, 0x0d,
+	static int vals[] = { 0x08, 0x09, 0x0a, 0x0b, 0x0d, 0x0d,
 					    0x01, 0x02, 0x03, 0x04, 0x05, 0x06,
 					    0x00 };
 	unsigned int i;
diff --git a/drivers/media/pci/bt8xx/bttv-i2c.c b/drivers/media/pci/bt8xx/bttv-i2c.c
index 95f5f64..5039b88 100644
--- a/drivers/media/pci/bt8xx/bttv-i2c.c
+++ b/drivers/media/pci/bt8xx/bttv-i2c.c
@@ -99,7 +99,7 @@ static int bttv_bit_getsda(void *data)
 	return state;
 }
 
-static struct i2c_algo_bit_data __devinitdata bttv_i2c_algo_bit_template = {
+static struct i2c_algo_bit_data bttv_i2c_algo_bit_template = {
 	.setsda  = bttv_bit_setsda,
 	.setscl  = bttv_bit_setscl,
 	.getsda  = bttv_bit_getsda,
diff --git a/drivers/media/pci/cx18/cx18-driver.c b/drivers/media/pci/cx18/cx18-driver.c
index 1d0f65b..661ed6d 100644
--- a/drivers/media/pci/cx18/cx18-driver.c
+++ b/drivers/media/pci/cx18/cx18-driver.c
@@ -53,7 +53,7 @@ int (*cx18_ext_init)(struct cx18 *);
 EXPORT_SYMBOL(cx18_ext_init);
 
 /* add your revision and whatnot here */
-static struct pci_device_id cx18_pci_tbl[] __devinitdata = {
+static struct pci_device_id cx18_pci_tbl[] = {
 	{PCI_VENDOR_ID_CX, PCI_DEVICE_ID_CX23418,
 	 PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
 	{0,}
diff --git a/drivers/media/pci/cx88/cx88-alsa.c b/drivers/media/pci/cx88/cx88-alsa.c
index 13d4481..5463233 100644
--- a/drivers/media/pci/cx88/cx88-alsa.c
+++ b/drivers/media/pci/cx88/cx88-alsa.c
@@ -749,7 +749,7 @@ static struct snd_kcontrol_new snd_cx88_alc_switch = {
  * Only boards with eeprom and byte 1 at eeprom=1 have it
  */
 
-static const struct pci_device_id cx88_audio_pci_tbl[] __devinitdata = {
+static const struct pci_device_id cx88_audio_pci_tbl[] = {
 	{0x14f1,0x8801,PCI_ANY_ID,PCI_ANY_ID,0,0,0},
 	{0x14f1,0x8811,PCI_ANY_ID,PCI_ANY_ID,0,0,0},
 	{0, }
diff --git a/drivers/media/pci/ddbridge/ddbridge-core.c b/drivers/media/pci/ddbridge/ddbridge-core.c
index 8ccbf04..0cb8653 100644
--- a/drivers/media/pci/ddbridge/ddbridge-core.c
+++ b/drivers/media/pci/ddbridge/ddbridge-core.c
@@ -1679,7 +1679,7 @@ static struct ddb_info ddb_v6 = {
 	.subvendor   = _subvend, .subdevice = _subdev, \
 	.driver_data = (unsigned long)&_driverdata }
 
-static const struct pci_device_id ddb_id_tbl[] __devinitdata = {
+static const struct pci_device_id ddb_id_tbl[] = {
 	DDB_ID(DDVID, 0x0002, DDVID, 0x0001, ddb_octopus),
 	DDB_ID(DDVID, 0x0003, DDVID, 0x0001, ddb_octopus),
 	DDB_ID(DDVID, 0x0003, DDVID, 0x0002, ddb_octopus_le),
diff --git a/drivers/media/pci/dm1105/dm1105.c b/drivers/media/pci/dm1105/dm1105.c
index 88df9fb..b8ef0c3 100644
--- a/drivers/media/pci/dm1105/dm1105.c
+++ b/drivers/media/pci/dm1105/dm1105.c
@@ -1205,7 +1205,7 @@ static void __devexit dm1105_remove(struct pci_dev *pdev)
 	kfree(dev);
 }
 
-static struct pci_device_id dm1105_id_table[] __devinitdata = {
+static struct pci_device_id dm1105_id_table[] = {
 	{
 		.vendor = PCI_VENDOR_ID_TRIGEM,
 		.device = PCI_DEVICE_ID_DM1105,
diff --git a/drivers/media/pci/ivtv/ivtv-driver.c b/drivers/media/pci/ivtv/ivtv-driver.c
index 61160f7..040b430 100644
--- a/drivers/media/pci/ivtv/ivtv-driver.c
+++ b/drivers/media/pci/ivtv/ivtv-driver.c
@@ -73,7 +73,7 @@ int (*ivtv_ext_init)(struct ivtv *);
 EXPORT_SYMBOL(ivtv_ext_init);
 
 /* add your revision and whatnot here */
-static struct pci_device_id ivtv_pci_tbl[] __devinitdata = {
+static struct pci_device_id ivtv_pci_tbl[] = {
 	{PCI_VENDOR_ID_ICOMP, PCI_DEVICE_ID_IVTV15,
 	 PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
 	{PCI_VENDOR_ID_ICOMP, PCI_DEVICE_ID_IVTV16,
diff --git a/drivers/media/pci/ngene/ngene-cards.c b/drivers/media/pci/ngene/ngene-cards.c
index 09c02b5..cb445dd 100644
--- a/drivers/media/pci/ngene/ngene-cards.c
+++ b/drivers/media/pci/ngene/ngene-cards.c
@@ -741,7 +741,7 @@ static struct ngene_info ngene_info_terratec = {
 
 /****************************************************************************/
 
-static const struct pci_device_id ngene_id_tbl[] __devinitdata = {
+static const struct pci_device_id ngene_id_tbl[] = {
 	NGENE_ID(0x18c3, 0xabc3, ngene_info_cineS2),
 	NGENE_ID(0x18c3, 0xabc4, ngene_info_cineS2),
 	NGENE_ID(0x18c3, 0xdb01, ngene_info_satixS2),
diff --git a/drivers/media/pci/pluto2/pluto2.c b/drivers/media/pci/pluto2/pluto2.c
index de26be3..b083c07 100644
--- a/drivers/media/pci/pluto2/pluto2.c
+++ b/drivers/media/pci/pluto2/pluto2.c
@@ -505,7 +505,7 @@ static int pluto2_request_firmware(struct dvb_frontend *fe,
 	return request_firmware(fw, name, &pluto->pdev->dev);
 }
 
-static struct tda1004x_config pluto2_fe_config __devinitdata = {
+static struct tda1004x_config pluto2_fe_config = {
 	.demod_address = I2C_ADDR_TDA10046 >> 1,
 	.invert = 1,
 	.invert_oclk = 0,
@@ -777,7 +777,7 @@ static void __devexit pluto2_remove(struct pci_dev *pdev)
 #define PCI_DEVICE_ID_PLUTO2	0x0001
 #endif
 
-static struct pci_device_id pluto2_id_table[] __devinitdata = {
+static struct pci_device_id pluto2_id_table[] = {
 	{
 		.vendor = PCI_VENDOR_ID_SCM,
 		.device = PCI_DEVICE_ID_PLUTO2,
diff --git a/drivers/media/pci/saa7134/saa7134.h b/drivers/media/pci/saa7134/saa7134.h
index c24b651..075908f 100644
--- a/drivers/media/pci/saa7134/saa7134.h
+++ b/drivers/media/pci/saa7134/saa7134.h
@@ -739,7 +739,7 @@ extern int (*saa7134_dmasound_exit)(struct saa7134_dev *dev);
 
 extern struct saa7134_board saa7134_boards[];
 extern const unsigned int saa7134_bcount;
-extern struct pci_device_id __devinitdata saa7134_pci_tbl[];
+extern struct pci_device_id saa7134_pci_tbl[];
 
 extern int saa7134_board_init1(struct saa7134_dev *dev);
 extern int saa7134_board_init2(struct saa7134_dev *dev);
diff --git a/drivers/media/pci/zoran/zoran_card.c b/drivers/media/pci/zoran/zoran_card.c
index 7a68bbe..776644d 100644
--- a/drivers/media/pci/zoran/zoran_card.c
+++ b/drivers/media/pci/zoran/zoran_card.c
@@ -369,7 +369,7 @@ static const unsigned short bt819_addrs[] = { 0x45, I2C_CLIENT_END };
 static const unsigned short bt856_addrs[] = { 0x44, I2C_CLIENT_END };
 static const unsigned short bt866_addrs[] = { 0x44, I2C_CLIENT_END };
 
-static struct card_info zoran_cards[NUM_CARDS] __devinitdata = {
+static struct card_info zoran_cards[NUM_CARDS] = {
 	{
 		.type = DC10_old,
 		.name = "DC10(old)",
diff --git a/drivers/media/pci/zoran/zoran_driver.c b/drivers/media/pci/zoran/zoran_driver.c
index 53f12c7..e60ae41 100644
--- a/drivers/media/pci/zoran/zoran_driver.c
+++ b/drivers/media/pci/zoran/zoran_driver.c
@@ -3080,7 +3080,7 @@ static const struct v4l2_file_operations zoran_fops = {
 	.poll = zoran_poll,
 };
 
-struct video_device zoran_template __devinitdata = {
+struct video_device zoran_template = {
 	.name = ZORAN_NAME,
 	.fops = &zoran_fops,
 	.ioctl_ops = &zoran_ioctl_ops,
diff --git a/drivers/media/radio/radio-sf16fmi.c b/drivers/media/radio/radio-sf16fmi.c
index 227dcdb..0a3b907 100644
--- a/drivers/media/radio/radio-sf16fmi.c
+++ b/drivers/media/radio/radio-sf16fmi.c
@@ -265,7 +265,7 @@ static const struct v4l2_ioctl_ops fmi_ioctl_ops = {
 };
 
 /* ladis: this is my card. does any other types exist? */
-static struct isapnp_device_id id_table[] __devinitdata = {
+static struct isapnp_device_id id_table[] = {
 		/* SF16-FMI */
 	{	ISAPNP_ANY_ID, ISAPNP_ANY_ID,
 		ISAPNP_VENDOR('M','F','R'), ISAPNP_FUNCTION(0xad10), 0},
diff --git a/drivers/media/radio/radio-sf16fmr2.c b/drivers/media/radio/radio-sf16fmr2.c
index 486e8cf..faf84ef 100644
--- a/drivers/media/radio/radio-sf16fmr2.c
+++ b/drivers/media/radio/radio-sf16fmr2.c
@@ -197,7 +197,7 @@ static int fmr2_tea_ext_init(struct snd_tea575x *tea)
 	return 0;
 }
 
-static struct pnp_device_id fmr2_pnp_ids[] __devinitdata = {
+static struct pnp_device_id fmr2_pnp_ids[] = {
 	{ .id = "MFRad13" }, /* tuner subdevice of SF16-FMD2 */
 	{ .id = "" }
 };
-- 
1.8.0

