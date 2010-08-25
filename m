Return-path: <mchehab@pedra>
Received: from smtp24.services.sfr.fr ([93.17.128.82]:29683 "EHLO
	smtp24.services.sfr.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862Ab0HYMu1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Aug 2010 08:50:27 -0400
Received: from filter.sfr.fr (localhost [127.0.0.1])
	by msfrf2408.sfr.fr (SMTP Server) with ESMTP id 5F6647000089
	for <linux-media@vger.kernel.org>; Wed, 25 Aug 2010 14:50:25 +0200 (CEST)
Received: from smtp-in.softsystem.co.uk (37.213.205-77.rev.gaoland.net [77.205.213.37])
	by msfrf2408.sfr.fr (SMTP Server) with SMTP id 5AB807000088
	for <linux-media@vger.kernel.org>; Wed, 25 Aug 2010 14:50:22 +0200 (CEST)
Received: FROM [192.168.1.62] (gagarin [192.168.1.62])
	BY smtp-in.softsystem.co.uk [77.205.213.37] (SoftMail 1.0.5, www.softsystem.co.uk) WITH ESMTP
	FOR <linux-media@vger.kernel.org>; Wed, 25 Aug 2010 14:50:21 +0200
Subject: [PATCH] cx88: Make static data tables and strings const.
From: lawrence rust <lawrence@softsystem.co.uk>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 Aug 2010 14:50:20 +0200
Message-ID: <1282740620.1406.7.camel@gagarin>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@pedra>

Making static data const avoids allocation of additional r/w memory and
reduces initialisation time.  It also provides some additional opportunities
for compiler optimisations.

Signed-off-by: Lawrence Rust <lvr@softsystem.co.uk>
---
 drivers/media/common/tuners/xc5000.c      |    2 +-
 drivers/media/common/tuners/xc5000.h      |    4 +-
 drivers/media/dvb/dvb-core/dvb_frontend.h |    2 +-
 drivers/media/dvb/dvb-usb/friio-fe.c      |    2 +-
 drivers/media/dvb/frontends/cx24110.c     |    2 +-
 drivers/media/dvb/frontends/lgs8gxx.c     |    2 +-
 drivers/media/dvb/frontends/mt352.c       |    2 +-
 drivers/media/dvb/frontends/mt352.h       |    2 +-
 drivers/media/dvb/frontends/si21xx.c      |    2 +-
 drivers/media/dvb/frontends/stb6100.c     |    2 +-
 drivers/media/dvb/frontends/stb6100.h     |    4 +-
 drivers/media/dvb/frontends/stv0288.c     |    2 +-
 drivers/media/dvb/frontends/stv0299.c     |    2 +-
 drivers/media/dvb/frontends/stv0299.h     |    2 +-
 drivers/media/dvb/frontends/tda1004x.c    |    2 +-
 drivers/media/dvb/frontends/zl10353.c     |    2 +-
 drivers/media/video/cx88/cx88-alsa.c      |   18 ++--
 drivers/media/video/cx88/cx88-cards.c     |    6 +-
 drivers/media/video/cx88/cx88-core.c      |   26 +++---
 drivers/media/video/cx88/cx88-dsp.c       |    2 +-
 drivers/media/video/cx88/cx88-dvb.c       |  118 ++++++++++++++--------------
 drivers/media/video/cx88/cx88-i2c.c       |    4 +-
 drivers/media/video/cx88/cx88-mpeg.c      |    6 +-
 drivers/media/video/cx88/cx88-tvaudio.c   |    6 +-
 drivers/media/video/cx88/cx88-vbi.c       |    2 +-
 drivers/media/video/cx88/cx88-video.c     |   30 ++++----
 drivers/media/video/cx88/cx88.h           |   24 +++---
 27 files changed, 139 insertions(+), 139 deletions(-)

diff --git a/drivers/media/common/tuners/xc5000.c b/drivers/media/common/tuners/xc5000.c
index 432003d..5658db3 100644
--- a/drivers/media/common/tuners/xc5000.c
+++ b/drivers/media/common/tuners/xc5000.c
@@ -1045,7 +1045,7 @@ static const struct dvb_tuner_ops xc5000_tuner_ops = {
 
 struct dvb_frontend *xc5000_attach(struct dvb_frontend *fe,
 				   struct i2c_adapter *i2c,
-				   struct xc5000_config *cfg)
+				   const struct xc5000_config *cfg)
 {
 	struct xc5000_priv *priv = NULL;
 	int instance;
diff --git a/drivers/media/common/tuners/xc5000.h b/drivers/media/common/tuners/xc5000.h
index e6d7236..3756e73 100644
--- a/drivers/media/common/tuners/xc5000.h
+++ b/drivers/media/common/tuners/xc5000.h
@@ -53,11 +53,11 @@ struct xc5000_config {
     (defined(CONFIG_MEDIA_TUNER_XC5000_MODULE) && defined(MODULE))
 extern struct dvb_frontend *xc5000_attach(struct dvb_frontend *fe,
 					  struct i2c_adapter *i2c,
-					  struct xc5000_config *cfg);
+					  const struct xc5000_config *cfg);
 #else
 static inline struct dvb_frontend *xc5000_attach(struct dvb_frontend *fe,
 						 struct i2c_adapter *i2c,
-						 struct xc5000_config *cfg)
+						 const struct xc5000_config *cfg)
 {
 	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
diff --git a/drivers/media/dvb/dvb-core/dvb_frontend.h b/drivers/media/dvb/dvb-core/dvb_frontend.h
index bf0e6be..f9f19be 100644
--- a/drivers/media/dvb/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb/dvb-core/dvb_frontend.h
@@ -260,7 +260,7 @@ struct dvb_frontend_ops {
 	int (*init)(struct dvb_frontend* fe);
 	int (*sleep)(struct dvb_frontend* fe);
 
-	int (*write)(struct dvb_frontend* fe, u8* buf, int len);
+	int (*write)(struct dvb_frontend* fe, const u8 buf[], int len);
 
 	/* if this is set, it overrides the default swzigzag */
 	int (*tune)(struct dvb_frontend* fe,
diff --git a/drivers/media/dvb/dvb-usb/friio-fe.c b/drivers/media/dvb/dvb-usb/friio-fe.c
index 93c21dd..015b4e8 100644
--- a/drivers/media/dvb/dvb-usb/friio-fe.c
+++ b/drivers/media/dvb/dvb-usb/friio-fe.c
@@ -75,7 +75,7 @@ static int jdvbt90502_single_reg_write(struct jdvbt90502_state *state,
 	return 0;
 }
 
-static int _jdvbt90502_write(struct dvb_frontend *fe, u8 *buf, int len)
+static int _jdvbt90502_write(struct dvb_frontend *fe, const u8 buf[], int len)
 {
 	struct jdvbt90502_state *state = fe->demodulator_priv;
 	int err, i;
diff --git a/drivers/media/dvb/frontends/cx24110.c b/drivers/media/dvb/frontends/cx24110.c
index 00a4e8f..7a1a5bc 100644
--- a/drivers/media/dvb/frontends/cx24110.c
+++ b/drivers/media/dvb/frontends/cx24110.c
@@ -310,7 +310,7 @@ static int cx24110_set_symbolrate (struct cx24110_state* state, u32 srate)
 
 }
 
-static int _cx24110_pll_write (struct dvb_frontend* fe, u8 *buf, int len)
+static int _cx24110_pll_write (struct dvb_frontend* fe, const u8 buf[], int len)
 {
 	struct cx24110_state *state = fe->demodulator_priv;
 
diff --git a/drivers/media/dvb/frontends/lgs8gxx.c b/drivers/media/dvb/frontends/lgs8gxx.c
index dee5396..e28e045 100644
--- a/drivers/media/dvb/frontends/lgs8gxx.c
+++ b/drivers/media/dvb/frontends/lgs8gxx.c
@@ -692,7 +692,7 @@ static void lgs8gxx_release(struct dvb_frontend *fe)
 }
 
 
-static int lgs8gxx_write(struct dvb_frontend *fe, u8 *buf, int len)
+static int lgs8gxx_write(struct dvb_frontend *fe, const u8 buf[], int len)
 {
 	struct lgs8gxx_state *priv = fe->demodulator_priv;
 
diff --git a/drivers/media/dvb/frontends/mt352.c b/drivers/media/dvb/frontends/mt352.c
index beba5aa..319672f 100644
--- a/drivers/media/dvb/frontends/mt352.c
+++ b/drivers/media/dvb/frontends/mt352.c
@@ -69,7 +69,7 @@ static int mt352_single_write(struct dvb_frontend *fe, u8 reg, u8 val)
 	return 0;
 }
 
-static int _mt352_write(struct dvb_frontend* fe, u8* ibuf, int ilen)
+static int _mt352_write(struct dvb_frontend* fe, const u8 ibuf[], int ilen)
 {
 	int err,i;
 	for (i=0; i < ilen-1; i++)
diff --git a/drivers/media/dvb/frontends/mt352.h b/drivers/media/dvb/frontends/mt352.h
index 595092f..ca2562d 100644
--- a/drivers/media/dvb/frontends/mt352.h
+++ b/drivers/media/dvb/frontends/mt352.h
@@ -63,7 +63,7 @@ static inline struct dvb_frontend* mt352_attach(const struct mt352_config* confi
 }
 #endif // CONFIG_DVB_MT352
 
-static inline int mt352_write(struct dvb_frontend *fe, u8 *buf, int len) {
+static inline int mt352_write(struct dvb_frontend *fe, const u8 buf[], int len) {
 	int r = 0;
 	if (fe->ops.write)
 		r = fe->ops.write(fe, buf, len);
diff --git a/drivers/media/dvb/frontends/si21xx.c b/drivers/media/dvb/frontends/si21xx.c
index d21a327..4b0c99a 100644
--- a/drivers/media/dvb/frontends/si21xx.c
+++ b/drivers/media/dvb/frontends/si21xx.c
@@ -268,7 +268,7 @@ static int si21_writereg(struct si21xx_state *state, u8 reg, u8 data)
 	return (ret != 1) ? -EREMOTEIO : 0;
 }
 
-static int si21_write(struct dvb_frontend *fe, u8 *buf, int len)
+static int si21_write(struct dvb_frontend *fe, const u8 buf[], int len)
 {
 	struct si21xx_state *state = fe->demodulator_priv;
 
diff --git a/drivers/media/dvb/frontends/stb6100.c b/drivers/media/dvb/frontends/stb6100.c
index f73c133..80a9e4c 100644
--- a/drivers/media/dvb/frontends/stb6100.c
+++ b/drivers/media/dvb/frontends/stb6100.c
@@ -506,7 +506,7 @@ static struct dvb_tuner_ops stb6100_ops = {
 };
 
 struct dvb_frontend *stb6100_attach(struct dvb_frontend *fe,
-				    struct stb6100_config *config,
+				    const struct stb6100_config *config,
 				    struct i2c_adapter *i2c)
 {
 	struct stb6100_state *state = NULL;
diff --git a/drivers/media/dvb/frontends/stb6100.h b/drivers/media/dvb/frontends/stb6100.h
index 395d056..2ab0966 100644
--- a/drivers/media/dvb/frontends/stb6100.h
+++ b/drivers/media/dvb/frontends/stb6100.h
@@ -97,13 +97,13 @@ struct stb6100_state {
 #if defined(CONFIG_DVB_STB6100) || (defined(CONFIG_DVB_STB6100_MODULE) && defined(MODULE))
 
 extern struct dvb_frontend *stb6100_attach(struct dvb_frontend *fe,
-					   struct stb6100_config *config,
+					   const struct stb6100_config *config,
 					   struct i2c_adapter *i2c);
 
 #else
 
 static inline struct dvb_frontend *stb6100_attach(struct dvb_frontend *fe,
-						  struct stb6100_config *config,
+						  const struct stb6100_config *config,
 						  struct i2c_adapter *i2c)
 {
 	printk(KERN_WARNING "%s: Driver disabled by Kconfig\n", __func__);
diff --git a/drivers/media/dvb/frontends/stv0288.c b/drivers/media/dvb/frontends/stv0288.c
index 2930a5d..743989d 100644
--- a/drivers/media/dvb/frontends/stv0288.c
+++ b/drivers/media/dvb/frontends/stv0288.c
@@ -78,7 +78,7 @@ static int stv0288_writeregI(struct stv0288_state *state, u8 reg, u8 data)
 	return (ret != 1) ? -EREMOTEIO : 0;
 }
 
-static int stv0288_write(struct dvb_frontend *fe, u8 *buf, int len)
+static int stv0288_write(struct dvb_frontend *fe, const u8 buf[], int len)
 {
 	struct stv0288_state *state = fe->demodulator_priv;
 
diff --git a/drivers/media/dvb/frontends/stv0299.c b/drivers/media/dvb/frontends/stv0299.c
index 9688744..4e3db3a 100644
--- a/drivers/media/dvb/frontends/stv0299.c
+++ b/drivers/media/dvb/frontends/stv0299.c
@@ -92,7 +92,7 @@ static int stv0299_writeregI (struct stv0299_state* state, u8 reg, u8 data)
 	return (ret != 1) ? -EREMOTEIO : 0;
 }
 
-static int stv0299_write(struct dvb_frontend* fe, u8 *buf, int len)
+static int stv0299_write(struct dvb_frontend* fe, const u8 buf[], int len)
 {
 	struct stv0299_state* state = fe->demodulator_priv;
 
diff --git a/drivers/media/dvb/frontends/stv0299.h b/drivers/media/dvb/frontends/stv0299.h
index 0fd96e2..ba219b7 100644
--- a/drivers/media/dvb/frontends/stv0299.h
+++ b/drivers/media/dvb/frontends/stv0299.h
@@ -65,7 +65,7 @@ struct stv0299_config
 	 * First of each pair is the register, second is the value.
 	 * List should be terminated with an 0xff, 0xff pair.
 	 */
-	u8* inittab;
+	const u8* inittab;
 
 	/* master clock to use */
 	u32 mclk;
diff --git a/drivers/media/dvb/frontends/tda1004x.c b/drivers/media/dvb/frontends/tda1004x.c
index f2a8abe..ea485d9 100644
--- a/drivers/media/dvb/frontends/tda1004x.c
+++ b/drivers/media/dvb/frontends/tda1004x.c
@@ -598,7 +598,7 @@ static int tda1004x_decode_fec(int tdafec)
 	return -1;
 }
 
-static int tda1004x_write(struct dvb_frontend* fe, u8 *buf, int len)
+static int tda1004x_write(struct dvb_frontend* fe, const u8 buf[], int len)
 {
 	struct tda1004x_state* state = fe->demodulator_priv;
 
diff --git a/drivers/media/dvb/frontends/zl10353.c b/drivers/media/dvb/frontends/zl10353.c
index 8c61271..adbbf6d 100644
--- a/drivers/media/dvb/frontends/zl10353.c
+++ b/drivers/media/dvb/frontends/zl10353.c
@@ -64,7 +64,7 @@ static int zl10353_single_write(struct dvb_frontend *fe, u8 reg, u8 val)
 	return 0;
 }
 
-static int zl10353_write(struct dvb_frontend *fe, u8 *ibuf, int ilen)
+static int zl10353_write(struct dvb_frontend *fe, const u8 ibuf[], int ilen)
 {
 	int err, i;
 	for (i = 0; i < ilen - 1; i++)
diff --git a/drivers/media/video/cx88/cx88-alsa.c b/drivers/media/video/cx88/cx88-alsa.c
index 33082c9..c47408b 100644
--- a/drivers/media/video/cx88/cx88-alsa.c
+++ b/drivers/media/video/cx88/cx88-alsa.c
@@ -88,7 +88,7 @@ typedef struct cx88_audio_dev snd_cx88_card_t;
  ****************************************************************************/
 
 static int index[SNDRV_CARDS] = SNDRV_DEFAULT_IDX;	/* Index 0-MAX */
-static char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;	/* ID for this card */
+static const char *id[SNDRV_CARDS] = SNDRV_DEFAULT_STR;	/* ID for this card */
 static int enable[SNDRV_CARDS] = {1, [1 ... (SNDRV_CARDS - 1)] = 1};
 
 module_param_array(enable, bool, NULL, 0444);
@@ -125,7 +125,7 @@ static int _cx88_start_audio_dma(snd_cx88_card_t *chip)
 {
 	struct cx88_buffer   *buf = chip->buf;
 	struct cx88_core *core=chip->core;
-	struct sram_channel *audio_ch = &cx88_sram_channels[SRAM_CH25];
+	const struct sram_channel *audio_ch = &cx88_sram_channels[SRAM_CH25];
 
 	/* Make sure RISC/FIFO are off before changing FIFO/RISC settings */
 	cx_clear(MO_AUD_DMACNTRL, 0x11);
@@ -191,7 +191,7 @@ static int _cx88_stop_audio_dma(snd_cx88_card_t *chip)
 /*
  * BOARD Specific: IRQ dma bits
  */
-static char *cx88_aud_irqs[32] = {
+static const char *cx88_aud_irqs[32] = {
 	"dn_risci1", "up_risci1", "rds_dn_risc1", /* 0-2 */
 	NULL,					  /* reserved */
 	"dn_risci2", "up_risci2", "rds_dn_risc2", /* 4-6 */
@@ -302,7 +302,7 @@ static int dsp_buffer_free(snd_cx88_card_t *chip)
  * Digital hardware definition
  */
 #define DEFAULT_FIFO_SIZE	4096
-static struct snd_pcm_hardware snd_cx88_digital_hw = {
+static const struct snd_pcm_hardware snd_cx88_digital_hw = {
 	.info = SNDRV_PCM_INFO_MMAP |
 		SNDRV_PCM_INFO_INTERLEAVED |
 		SNDRV_PCM_INFO_BLOCK_TRANSFER |
@@ -534,7 +534,7 @@ static struct snd_pcm_ops snd_cx88_pcm_ops = {
 /*
  * create a PCM device
  */
-static int __devinit snd_cx88_pcm(snd_cx88_card_t *chip, int device, char *name)
+static int __devinit snd_cx88_pcm(snd_cx88_card_t *chip, int device, const char *name)
 {
 	int err;
 	struct snd_pcm *pcm;
@@ -615,7 +615,7 @@ static int snd_cx88_volume_put(struct snd_kcontrol *kcontrol,
 
 static const DECLARE_TLV_DB_SCALE(snd_cx88_db_scale, -6300, 100, 0);
 
-static struct snd_kcontrol_new snd_cx88_volume = {
+static const struct snd_kcontrol_new snd_cx88_volume = {
 	.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
 	.access = SNDRV_CTL_ELEM_ACCESS_READWRITE |
 		  SNDRV_CTL_ELEM_ACCESS_TLV_READ,
@@ -657,7 +657,7 @@ static int snd_cx88_switch_put(struct snd_kcontrol *kcontrol,
 	return ret;
 }
 
-static struct snd_kcontrol_new snd_cx88_dac_switch = {
+static const struct snd_kcontrol_new snd_cx88_dac_switch = {
 	.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
 	.name = "Playback Switch",
 	.info = snd_ctl_boolean_mono_info,
@@ -666,7 +666,7 @@ static struct snd_kcontrol_new snd_cx88_dac_switch = {
 	.private_value = (1<<8),
 };
 
-static struct snd_kcontrol_new snd_cx88_source_switch = {
+static const struct snd_kcontrol_new snd_cx88_source_switch = {
 	.iface = SNDRV_CTL_ELEM_IFACE_MIXER,
 	.name = "Capture Switch",
 	.info = snd_ctl_boolean_mono_info,
@@ -684,7 +684,7 @@ static struct snd_kcontrol_new snd_cx88_source_switch = {
  * Only boards with eeprom and byte 1 at eeprom=1 have it
  */
 
-static struct pci_device_id cx88_audio_pci_tbl[] __devinitdata = {
+static const struct pci_device_id const cx88_audio_pci_tbl[] __devinitdata = {
 	{0x14f1,0x8801,PCI_ANY_ID,PCI_ANY_ID,0,0,0},
 	{0x14f1,0x8811,PCI_ANY_ID,PCI_ANY_ID,0,0,0},
 	{0, }
diff --git a/drivers/media/video/cx88/cx88-cards.c b/drivers/media/video/cx88/cx88-cards.c
index 2918a6e..fcc46ae 100644
--- a/drivers/media/video/cx88/cx88-cards.c
+++ b/drivers/media/video/cx88/cx88-cards.c
@@ -2669,10 +2669,10 @@ static void hauppauge_eeprom(struct cx88_core *core, u8 *eeprom_data)
 /* ----------------------------------------------------------------------- */
 /* some GDI (was: Modular Technology) specific stuff                       */
 
-static struct {
+static const struct {
 	int  id;
 	int  fm;
-	char *name;
+	const char *name;
 } gdi_tuner[] = {
 	[ 0x01 ] = { .id   = TUNER_ABSENT,
 		     .name = "NTSC_M" },
@@ -2706,7 +2706,7 @@ static struct {
 
 static void gdi_eeprom(struct cx88_core *core, u8 *eeprom_data)
 {
-	char *name = (eeprom_data[0x0d] < ARRAY_SIZE(gdi_tuner))
+	const char *name = (eeprom_data[0x0d] < ARRAY_SIZE(gdi_tuner))
 		? gdi_tuner[eeprom_data[0x0d]].name : NULL;
 
 	info_printk(core, "GDI: tuner=%s\n", name ? name : "unknown");
diff --git a/drivers/media/video/cx88/cx88-core.c b/drivers/media/video/cx88/cx88-core.c
index 8b21457..469d71d 100644
--- a/drivers/media/video/cx88/cx88-core.c
+++ b/drivers/media/video/cx88/cx88-core.c
@@ -253,7 +253,7 @@ cx88_free_buffer(struct videobuf_queue *q, struct cx88_buffer *buf)
  *    0x0c00 -           FIFOs
  */
 
-struct sram_channel cx88_sram_channels[] = {
+const struct sram_channel const cx88_sram_channels[] = {
 	[SRAM_CH21] = {
 		.name       = "video y / packed",
 		.cmds_start = 0x180040,
@@ -353,7 +353,7 @@ struct sram_channel cx88_sram_channels[] = {
 };
 
 int cx88_sram_channel_setup(struct cx88_core *core,
-			    struct sram_channel *ch,
+			    const struct sram_channel *ch,
 			    unsigned int bpl, u32 risc)
 {
 	unsigned int i,lines;
@@ -394,7 +394,7 @@ int cx88_sram_channel_setup(struct cx88_core *core,
 
 static int cx88_risc_decode(u32 risc)
 {
-	static char *instr[16] = {
+	static const char * const instr[16] = {
 		[ RISC_SYNC    >> 28 ] = "sync",
 		[ RISC_WRITE   >> 28 ] = "write",
 		[ RISC_WRITEC  >> 28 ] = "writec",
@@ -406,14 +406,14 @@ static int cx88_risc_decode(u32 risc)
 		[ RISC_WRITECM >> 28 ] = "writecm",
 		[ RISC_WRITECR >> 28 ] = "writecr",
 	};
-	static int incr[16] = {
+	static int const incr[16] = {
 		[ RISC_WRITE   >> 28 ] = 2,
 		[ RISC_JUMP    >> 28 ] = 2,
 		[ RISC_WRITERM >> 28 ] = 3,
 		[ RISC_WRITECM >> 28 ] = 3,
 		[ RISC_WRITECR >> 28 ] = 4,
 	};
-	static char *bits[] = {
+	static const char * const bits[] = {
 		"12",   "13",   "14",   "resync",
 		"cnt0", "cnt1", "18",   "19",
 		"20",   "21",   "22",   "23",
@@ -432,9 +432,9 @@ static int cx88_risc_decode(u32 risc)
 
 
 void cx88_sram_channel_dump(struct cx88_core *core,
-			    struct sram_channel *ch)
+			    const struct sram_channel *ch)
 {
-	static char *name[] = {
+	static const char * const name[] = {
 		"initial risc",
 		"cdt base",
 		"cdt size",
@@ -489,14 +489,14 @@ void cx88_sram_channel_dump(struct cx88_core *core,
 	       core->name,cx_read(ch->cnt2_reg));
 }
 
-static char *cx88_pci_irqs[32] = {
+static const char *cx88_pci_irqs[32] = {
 	"vid", "aud", "ts", "vip", "hst", "5", "6", "tm1",
 	"src_dma", "dst_dma", "risc_rd_err", "risc_wr_err",
 	"brdg_err", "src_dma_err", "dst_dma_err", "ipb_dma_err",
 	"i2c", "i2c_rack", "ir_smp", "gpio0", "gpio1"
 };
 
-void cx88_print_irqbits(char *name, char *tag, char **strings,
+void cx88_print_irqbits(const char *name, const char *tag, const char *strings[],
 			int len, u32 bits, u32 mask)
 {
 	unsigned int i;
@@ -770,7 +770,7 @@ static const u32 xtal = 28636363;
 
 static int set_pll(struct cx88_core *core, int prescale, u32 ofreq)
 {
-	static u32 pre[] = { 0, 0, 0, 3, 2, 1 };
+	static const u32 pre[] = { 0, 0, 0, 3, 2, 1 };
 	u64 pll;
 	u32 reg;
 	int i;
@@ -1020,15 +1020,15 @@ int cx88_set_tvnorm(struct cx88_core *core, v4l2_std_id norm)
 
 struct video_device *cx88_vdev_init(struct cx88_core *core,
 				    struct pci_dev *pci,
-				    struct video_device *template,
-				    char *type)
+				    const struct video_device *template_,
+				    const char *type)
 {
 	struct video_device *vfd;
 
 	vfd = video_device_alloc();
 	if (NULL == vfd)
 		return NULL;
-	*vfd = *template;
+	*vfd = *template_;
 	vfd->v4l2_dev = &core->v4l2_dev;
 	vfd->parent = &pci->dev;
 	vfd->release = video_device_release;
diff --git a/drivers/media/video/cx88/cx88-dsp.c b/drivers/media/video/cx88/cx88-dsp.c
index a94e00a..2c39c60 100644
--- a/drivers/media/video/cx88/cx88-dsp.c
+++ b/drivers/media/video/cx88/cx88-dsp.c
@@ -230,7 +230,7 @@ static s32 detect_btsc(struct cx88_core *core, s16 x[], u32 N)
 
 static s16 *read_rds_samples(struct cx88_core *core, u32 *N)
 {
-	struct sram_channel *srch = &cx88_sram_channels[SRAM_CH27];
+	const struct sram_channel *srch = &cx88_sram_channels[SRAM_CH27];
 	s16 *samples;
 
 	unsigned int i;
diff --git a/drivers/media/video/cx88/cx88-dvb.c b/drivers/media/video/cx88/cx88-dvb.c
index faa8e81..e24fd8d 100644
--- a/drivers/media/video/cx88/cx88-dvb.c
+++ b/drivers/media/video/cx88/cx88-dvb.c
@@ -105,7 +105,7 @@ static void dvb_buf_release(struct videobuf_queue *q,
 	cx88_free_buffer(q, (struct cx88_buffer*)vb);
 }
 
-static struct videobuf_queue_ops dvb_qops = {
+static const struct videobuf_queue_ops dvb_qops = {
 	.buf_setup    = dvb_buf_setup,
 	.buf_prepare  = dvb_buf_prepare,
 	.buf_queue    = dvb_buf_queue,
@@ -167,12 +167,12 @@ static void cx88_dvb_gate_ctrl(struct cx88_core  *core, int open)
 
 static int dvico_fusionhdtv_demod_init(struct dvb_frontend* fe)
 {
-	static u8 clock_config []  = { CLOCK_CTL,  0x38, 0x39 };
-	static u8 reset []         = { RESET,      0x80 };
-	static u8 adc_ctl_1_cfg [] = { ADC_CTL_1,  0x40 };
-	static u8 agc_cfg []       = { AGC_TARGET, 0x24, 0x20 };
-	static u8 gpp_ctl_cfg []   = { GPP_CTL,    0x33 };
-	static u8 capt_range_cfg[] = { CAPT_RANGE, 0x32 };
+	static const u8 clock_config []  = { CLOCK_CTL,  0x38, 0x39 };
+	static const u8 reset []         = { RESET,      0x80 };
+	static const u8 adc_ctl_1_cfg [] = { ADC_CTL_1,  0x40 };
+	static const u8 agc_cfg []       = { AGC_TARGET, 0x24, 0x20 };
+	static const u8 gpp_ctl_cfg []   = { GPP_CTL,    0x33 };
+	static const u8 capt_range_cfg[] = { CAPT_RANGE, 0x32 };
 
 	mt352_write(fe, clock_config,   sizeof(clock_config));
 	udelay(200);
@@ -187,12 +187,12 @@ static int dvico_fusionhdtv_demod_init(struct dvb_frontend* fe)
 
 static int dvico_dual_demod_init(struct dvb_frontend *fe)
 {
-	static u8 clock_config []  = { CLOCK_CTL,  0x38, 0x38 };
-	static u8 reset []         = { RESET,      0x80 };
-	static u8 adc_ctl_1_cfg [] = { ADC_CTL_1,  0x40 };
-	static u8 agc_cfg []       = { AGC_TARGET, 0x28, 0x20 };
-	static u8 gpp_ctl_cfg []   = { GPP_CTL,    0x33 };
-	static u8 capt_range_cfg[] = { CAPT_RANGE, 0x32 };
+	static const u8 clock_config []  = { CLOCK_CTL,  0x38, 0x38 };
+	static const u8 reset []         = { RESET,      0x80 };
+	static const u8 adc_ctl_1_cfg [] = { ADC_CTL_1,  0x40 };
+	static const u8 agc_cfg []       = { AGC_TARGET, 0x28, 0x20 };
+	static const u8 gpp_ctl_cfg []   = { GPP_CTL,    0x33 };
+	static const u8 capt_range_cfg[] = { CAPT_RANGE, 0x32 };
 
 	mt352_write(fe, clock_config,   sizeof(clock_config));
 	udelay(200);
@@ -208,13 +208,13 @@ static int dvico_dual_demod_init(struct dvb_frontend *fe)
 
 static int dntv_live_dvbt_demod_init(struct dvb_frontend* fe)
 {
-	static u8 clock_config []  = { 0x89, 0x38, 0x39 };
-	static u8 reset []         = { 0x50, 0x80 };
-	static u8 adc_ctl_1_cfg [] = { 0x8E, 0x40 };
-	static u8 agc_cfg []       = { 0x67, 0x10, 0x23, 0x00, 0xFF, 0xFF,
+	static const u8 clock_config []  = { 0x89, 0x38, 0x39 };
+	static const u8 reset []         = { 0x50, 0x80 };
+	static const u8 adc_ctl_1_cfg [] = { 0x8E, 0x40 };
+	static const u8 agc_cfg []       = { 0x67, 0x10, 0x23, 0x00, 0xFF, 0xFF,
 				       0x00, 0xFF, 0x00, 0x40, 0x40 };
-	static u8 dntv_extra[]     = { 0xB5, 0x7A };
-	static u8 capt_range_cfg[] = { 0x75, 0x32 };
+	static const u8 dntv_extra[]     = { 0xB5, 0x7A };
+	static const u8 capt_range_cfg[] = { 0x75, 0x32 };
 
 	mt352_write(fe, clock_config,   sizeof(clock_config));
 	udelay(2000);
@@ -229,22 +229,22 @@ static int dntv_live_dvbt_demod_init(struct dvb_frontend* fe)
 	return 0;
 }
 
-static struct mt352_config dvico_fusionhdtv = {
+static const struct mt352_config dvico_fusionhdtv = {
 	.demod_address = 0x0f,
 	.demod_init    = dvico_fusionhdtv_demod_init,
 };
 
-static struct mt352_config dntv_live_dvbt_config = {
+static const struct mt352_config dntv_live_dvbt_config = {
 	.demod_address = 0x0f,
 	.demod_init    = dntv_live_dvbt_demod_init,
 };
 
-static struct mt352_config dvico_fusionhdtv_dual = {
+static const struct mt352_config dvico_fusionhdtv_dual = {
 	.demod_address = 0x0f,
 	.demod_init    = dvico_dual_demod_init,
 };
 
-static struct zl10353_config cx88_terratec_cinergy_ht_pci_mkii_config = {
+static const struct zl10353_config cx88_terratec_cinergy_ht_pci_mkii_config = {
 	.demod_address = (0x1e >> 1),
 	.no_tuner      = 1,
 	.if2           = 45600,
@@ -253,13 +253,13 @@ static struct zl10353_config cx88_terratec_cinergy_ht_pci_mkii_config = {
 #if defined(CONFIG_VIDEO_CX88_VP3054) || (defined(CONFIG_VIDEO_CX88_VP3054_MODULE) && defined(MODULE))
 static int dntv_live_dvbt_pro_demod_init(struct dvb_frontend* fe)
 {
-	static u8 clock_config []  = { 0x89, 0x38, 0x38 };
-	static u8 reset []         = { 0x50, 0x80 };
-	static u8 adc_ctl_1_cfg [] = { 0x8E, 0x40 };
-	static u8 agc_cfg []       = { 0x67, 0x10, 0x20, 0x00, 0xFF, 0xFF,
+	static const u8 clock_config []  = { 0x89, 0x38, 0x38 };
+	static const u8 reset []         = { 0x50, 0x80 };
+	static const u8 adc_ctl_1_cfg [] = { 0x8E, 0x40 };
+	static const u8 agc_cfg []       = { 0x67, 0x10, 0x20, 0x00, 0xFF, 0xFF,
 				       0x00, 0xFF, 0x00, 0x40, 0x40 };
-	static u8 dntv_extra[]     = { 0xB5, 0x7A };
-	static u8 capt_range_cfg[] = { 0x75, 0x32 };
+	static const u8 dntv_extra[]     = { 0xB5, 0x7A };
+	static const u8 capt_range_cfg[] = { 0x75, 0x32 };
 
 	mt352_write(fe, clock_config,   sizeof(clock_config));
 	udelay(2000);
@@ -274,41 +274,41 @@ static int dntv_live_dvbt_pro_demod_init(struct dvb_frontend* fe)
 	return 0;
 }
 
-static struct mt352_config dntv_live_dvbt_pro_config = {
+static const struct mt352_config dntv_live_dvbt_pro_config = {
 	.demod_address = 0x0f,
 	.no_tuner      = 1,
 	.demod_init    = dntv_live_dvbt_pro_demod_init,
 };
 #endif
 
-static struct zl10353_config dvico_fusionhdtv_hybrid = {
+static const struct zl10353_config dvico_fusionhdtv_hybrid = {
 	.demod_address = 0x0f,
 	.no_tuner      = 1,
 };
 
-static struct zl10353_config dvico_fusionhdtv_xc3028 = {
+static const struct zl10353_config dvico_fusionhdtv_xc3028 = {
 	.demod_address = 0x0f,
 	.if2           = 45600,
 	.no_tuner      = 1,
 };
 
-static struct mt352_config dvico_fusionhdtv_mt352_xc3028 = {
+static const struct mt352_config dvico_fusionhdtv_mt352_xc3028 = {
 	.demod_address = 0x0f,
 	.if2 = 4560,
 	.no_tuner = 1,
 	.demod_init = dvico_fusionhdtv_demod_init,
 };
 
-static struct zl10353_config dvico_fusionhdtv_plus_v1_1 = {
+static const struct zl10353_config dvico_fusionhdtv_plus_v1_1 = {
 	.demod_address = 0x0f,
 };
 
-static struct cx22702_config connexant_refboard_config = {
+static const struct cx22702_config connexant_refboard_config = {
 	.demod_address = 0x43,
 	.output_mode   = CX22702_SERIAL_OUTPUT,
 };
 
-static struct cx22702_config hauppauge_hvr_config = {
+static const struct cx22702_config hauppauge_hvr_config = {
 	.demod_address = 0x63,
 	.output_mode   = CX22702_SERIAL_OUTPUT,
 };
@@ -320,7 +320,7 @@ static int or51132_set_ts_param(struct dvb_frontend* fe, int is_punctured)
 	return 0;
 }
 
-static struct or51132_config pchdtv_hd3000 = {
+static const struct or51132_config pchdtv_hd3000 = {
 	.demod_address = 0x15,
 	.set_ts_params = or51132_set_ts_param,
 };
@@ -355,14 +355,14 @@ static struct lgdt330x_config fusionhdtv_3_gold = {
 	.set_ts_params = lgdt330x_set_ts_param,
 };
 
-static struct lgdt330x_config fusionhdtv_5_gold = {
+static const struct lgdt330x_config fusionhdtv_5_gold = {
 	.demod_address = 0x0e,
 	.demod_chip    = LGDT3303,
 	.serial_mpeg   = 0x40, /* TPSERIAL for 3303 in TOP_CONTROL */
 	.set_ts_params = lgdt330x_set_ts_param,
 };
 
-static struct lgdt330x_config pchdtv_hd5500 = {
+static const struct lgdt330x_config pchdtv_hd5500 = {
 	.demod_address = 0x59,
 	.demod_chip    = LGDT3303,
 	.serial_mpeg   = 0x40, /* TPSERIAL for 3303 in TOP_CONTROL */
@@ -376,7 +376,7 @@ static int nxt200x_set_ts_param(struct dvb_frontend* fe, int is_punctured)
 	return 0;
 }
 
-static struct nxt200x_config ati_hdtvwonder = {
+static const struct nxt200x_config ati_hdtvwonder = {
 	.demod_address = 0x0a,
 	.set_ts_params = nxt200x_set_ts_param,
 };
@@ -445,23 +445,23 @@ static int tevii_dvbs_set_voltage(struct dvb_frontend *fe,
 	return 0;
 }
 
-static struct cx24123_config geniatech_dvbs_config = {
+static const struct cx24123_config geniatech_dvbs_config = {
 	.demod_address = 0x55,
 	.set_ts_params = cx24123_set_ts_param,
 };
 
-static struct cx24123_config hauppauge_novas_config = {
+static const struct cx24123_config hauppauge_novas_config = {
 	.demod_address = 0x55,
 	.set_ts_params = cx24123_set_ts_param,
 };
 
-static struct cx24123_config kworld_dvbs_100_config = {
+static const struct cx24123_config kworld_dvbs_100_config = {
 	.demod_address = 0x15,
 	.set_ts_params = cx24123_set_ts_param,
 	.lnb_polarity  = 1,
 };
 
-static struct s5h1409_config pinnacle_pctv_hd_800i_config = {
+static const struct s5h1409_config pinnacle_pctv_hd_800i_config = {
 	.demod_address = 0x32 >> 1,
 	.output_mode   = S5H1409_PARALLEL_OUTPUT,
 	.gpio	       = S5H1409_GPIO_ON,
@@ -471,7 +471,7 @@ static struct s5h1409_config pinnacle_pctv_hd_800i_config = {
 	.mpeg_timing   = S5H1409_MPEGTIMING_NONCONTINOUS_NONINVERTING_CLOCK,
 };
 
-static struct s5h1409_config dvico_hdtv5_pci_nano_config = {
+static const struct s5h1409_config dvico_hdtv5_pci_nano_config = {
 	.demod_address = 0x32 >> 1,
 	.output_mode   = S5H1409_SERIAL_OUTPUT,
 	.gpio          = S5H1409_GPIO_OFF,
@@ -480,7 +480,7 @@ static struct s5h1409_config dvico_hdtv5_pci_nano_config = {
 	.mpeg_timing   = S5H1409_MPEGTIMING_CONTINOUS_NONINVERTING_CLOCK,
 };
 
-static struct s5h1409_config kworld_atsc_120_config = {
+static const struct s5h1409_config kworld_atsc_120_config = {
 	.demod_address = 0x32 >> 1,
 	.output_mode   = S5H1409_SERIAL_OUTPUT,
 	.gpio	       = S5H1409_GPIO_OFF,
@@ -489,24 +489,24 @@ static struct s5h1409_config kworld_atsc_120_config = {
 	.mpeg_timing   = S5H1409_MPEGTIMING_CONTINOUS_NONINVERTING_CLOCK,
 };
 
-static struct xc5000_config pinnacle_pctv_hd_800i_tuner_config = {
+static const struct xc5000_config pinnacle_pctv_hd_800i_tuner_config = {
 	.i2c_address	= 0x64,
 	.if_khz		= 5380,
 };
 
-static struct zl10353_config cx88_pinnacle_hybrid_pctv = {
+static const struct zl10353_config cx88_pinnacle_hybrid_pctv = {
 	.demod_address = (0x1e >> 1),
 	.no_tuner      = 1,
 	.if2           = 45600,
 };
 
-static struct zl10353_config cx88_geniatech_x8000_mt = {
+static const struct zl10353_config cx88_geniatech_x8000_mt = {
 	.demod_address = (0x1e >> 1),
 	.no_tuner = 1,
 	.disable_i2c_gate_ctrl = 1,
 };
 
-static struct s5h1411_config dvico_fusionhdtv7_config = {
+static const struct s5h1411_config dvico_fusionhdtv7_config = {
 	.output_mode   = S5H1411_SERIAL_OUTPUT,
 	.gpio          = S5H1411_GPIO_ON,
 	.mpeg_timing   = S5H1411_MPEGTIMING_CONTINOUS_NONINVERTING_CLOCK,
@@ -516,7 +516,7 @@ static struct s5h1411_config dvico_fusionhdtv7_config = {
 	.status_mode   = S5H1411_DEMODLOCKING
 };
 
-static struct xc5000_config dvico_fusionhdtv7_tuner_config = {
+static const struct xc5000_config dvico_fusionhdtv7_tuner_config = {
 	.i2c_address    = 0xc2 >> 1,
 	.if_khz         = 5380,
 };
@@ -601,19 +601,19 @@ static int cx24116_reset_device(struct dvb_frontend *fe)
 	return 0;
 }
 
-static struct cx24116_config hauppauge_hvr4000_config = {
+static const struct cx24116_config hauppauge_hvr4000_config = {
 	.demod_address          = 0x05,
 	.set_ts_params          = cx24116_set_ts_param,
 	.reset_device           = cx24116_reset_device,
 };
 
-static struct cx24116_config tevii_s460_config = {
+static const struct cx24116_config tevii_s460_config = {
 	.demod_address = 0x55,
 	.set_ts_params = cx24116_set_ts_param,
 	.reset_device  = cx24116_reset_device,
 };
 
-static struct stv0900_config prof_7301_stv0900_config = {
+static const struct stv0900_config prof_7301_stv0900_config = {
 	.demod_address = 0x6a,
 /*	demod_mode = 0,*/
 	.xtal = 27000000,
@@ -625,12 +625,12 @@ static struct stv0900_config prof_7301_stv0900_config = {
 	.set_ts_params = stv0900_set_ts_param,
 };
 
-static struct stb6100_config prof_7301_stb6100_config = {
+static const struct stb6100_config prof_7301_stb6100_config = {
 	.tuner_address = 0x60,
 	.refclock = 27000000,
 };
 
-static struct stv0299_config tevii_tuner_sharp_config = {
+static const struct stv0299_config tevii_tuner_sharp_config = {
 	.demod_address = 0x68,
 	.inittab = sharp_z0194a_inittab,
 	.mclk = 88000000UL,
@@ -643,7 +643,7 @@ static struct stv0299_config tevii_tuner_sharp_config = {
 	.set_ts_params = cx24116_set_ts_param,
 };
 
-static struct stv0288_config tevii_tuner_earda_config = {
+static const struct stv0288_config tevii_tuner_earda_config = {
 	.demod_address = 0x68,
 	.min_delay_ms = 100,
 	.set_ts_params = cx24116_set_ts_param,
@@ -676,7 +676,7 @@ static int cx8802_alloc_frontends(struct cx8802_dev *dev)
 
 
 
-static u8 samsung_smt_7020_inittab[] = {
+static const u8 samsung_smt_7020_inittab[] = {
 	     0x01, 0x15,
 	     0x02, 0x00,
 	     0x03, 0x00,
@@ -850,7 +850,7 @@ static int samsung_smt_7020_stv0299_set_symbol_rate(struct dvb_frontend *fe,
 }
 
 
-static struct stv0299_config samsung_stv0299_config = {
+static const struct stv0299_config samsung_stv0299_config = {
 	.demod_address = 0x68,
 	.inittab = samsung_smt_7020_inittab,
 	.mclk = 88000000UL,
diff --git a/drivers/media/video/cx88/cx88-i2c.c b/drivers/media/video/cx88/cx88-i2c.c
index fb39f11..51c13e6 100644
--- a/drivers/media/video/cx88/cx88-i2c.c
+++ b/drivers/media/video/cx88/cx88-i2c.c
@@ -108,7 +108,7 @@ static const struct i2c_algo_bit_data cx8800_i2c_algo_template = {
 
 /* ----------------------------------------------------------------------- */
 
-static char *i2c_devs[128] = {
+static const char * const i2c_devs[128] = {
 	[ 0x1c >> 1 ] = "lgdt330x",
 	[ 0x86 >> 1 ] = "tda9887/cx22702",
 	[ 0xa0 >> 1 ] = "eeprom",
@@ -117,7 +117,7 @@ static char *i2c_devs[128] = {
 	[ 0xc8 >> 1 ] = "xc5000",
 };
 
-static void do_i2c_scan(char *name, struct i2c_client *c)
+static void do_i2c_scan(const char *name, struct i2c_client *c)
 {
 	unsigned char buf;
 	int i,rc;
diff --git a/drivers/media/video/cx88/cx88-mpeg.c b/drivers/media/video/cx88/cx88-mpeg.c
index 499f8d5..f7d71ac 100644
--- a/drivers/media/video/cx88/cx88-mpeg.c
+++ b/drivers/media/video/cx88/cx88-mpeg.c
@@ -313,7 +313,7 @@ void cx8802_buf_queue(struct cx8802_dev *dev, struct cx88_buffer *buf)
 
 /* ----------------------------------------------------------- */
 
-static void do_cancel_buffers(struct cx8802_dev *dev, char *reason, int restart)
+static void do_cancel_buffers(struct cx8802_dev *dev, const char *reason, int restart)
 {
 	struct cx88_dmaqueue *q = &dev->mpegq;
 	struct cx88_buffer *buf;
@@ -358,7 +358,7 @@ static void cx8802_timeout(unsigned long data)
 	do_cancel_buffers(dev,"timeout",1);
 }
 
-static char *cx88_mpeg_irqs[32] = {
+static const char * cx88_mpeg_irqs[32] = {
 	"ts_risci1", NULL, NULL, NULL,
 	"ts_risci2", NULL, NULL, NULL,
 	"ts_oflow",  NULL, NULL, NULL,
@@ -849,7 +849,7 @@ static void __devexit cx8802_remove(struct pci_dev *pci_dev)
 	kfree(dev);
 }
 
-static struct pci_device_id cx8802_pci_tbl[] = {
+static const struct pci_device_id cx8802_pci_tbl[] = {
 	{
 		.vendor       = 0x14f1,
 		.device       = 0x8802,
diff --git a/drivers/media/video/cx88/cx88-tvaudio.c b/drivers/media/video/cx88/cx88-tvaudio.c
index 2396315..a33e00e 100644
--- a/drivers/media/video/cx88/cx88-tvaudio.c
+++ b/drivers/media/video/cx88/cx88-tvaudio.c
@@ -70,7 +70,7 @@ MODULE_PARM_DESC(radio_deemphasis, "Radio deemphasis time constant, "
 
 /* ----------------------------------------------------------- */
 
-static char *aud_ctl_names[64] = {
+static const char * const aud_ctl_names[64] = {
 	[EN_BTSC_FORCE_MONO] = "BTSC_FORCE_MONO",
 	[EN_BTSC_FORCE_STEREO] = "BTSC_FORCE_STEREO",
 	[EN_BTSC_FORCE_SAP] = "BTSC_FORCE_SAP",
@@ -795,8 +795,8 @@ void cx88_newstation(struct cx88_core *core)
 
 void cx88_get_stereo(struct cx88_core *core, struct v4l2_tuner *t)
 {
-	static char *m[] = { "stereo", "dual mono", "mono", "sap" };
-	static char *p[] = { "no pilot", "pilot c1", "pilot c2", "?" };
+	static const char * const m[] = { "stereo", "dual mono", "mono", "sap" };
+	static const char * const p[] = { "no pilot", "pilot c1", "pilot c2", "?" };
 	u32 reg, mode, pilot;
 
 	reg = cx_read(AUD_STATUS);
diff --git a/drivers/media/video/cx88/cx88-vbi.c b/drivers/media/video/cx88/cx88-vbi.c
index d9445b0..f8f8389 100644
--- a/drivers/media/video/cx88/cx88-vbi.c
+++ b/drivers/media/video/cx88/cx88-vbi.c
@@ -230,7 +230,7 @@ static void vbi_release(struct videobuf_queue *q, struct videobuf_buffer *vb)
 	cx88_free_buffer(q,buf);
 }
 
-struct videobuf_queue_ops cx8800_vbi_qops = {
+const struct videobuf_queue_ops cx8800_vbi_qops = {
 	.buf_setup    = vbi_setup,
 	.buf_prepare  = vbi_prepare,
 	.buf_queue    = vbi_queue,
diff --git a/drivers/media/video/cx88/cx88-video.c b/drivers/media/video/cx88/cx88-video.c
index 0fab65c..86f8056 100644
--- a/drivers/media/video/cx88/cx88-video.c
+++ b/drivers/media/video/cx88/cx88-video.c
@@ -78,7 +78,7 @@ MODULE_PARM_DESC(vid_limit,"capture memory limit in megabytes");
 /* ------------------------------------------------------------------- */
 /* static data                                                         */
 
-static struct cx8800_fmt formats[] = {
+static const struct cx8800_fmt formats[] = {
 	{
 		.name     = "8 bpp, gray",
 		.fourcc   = V4L2_PIX_FMT_GREY,
@@ -142,7 +142,7 @@ static struct cx8800_fmt formats[] = {
 	},
 };
 
-static struct cx8800_fmt* format_by_fourcc(unsigned int fourcc)
+static const struct cx8800_fmt* format_by_fourcc(unsigned int fourcc)
 {
 	unsigned int i;
 
@@ -159,7 +159,7 @@ static const struct v4l2_queryctrl no_ctl = {
 	.flags = V4L2_CTRL_FLAG_DISABLED,
 };
 
-static struct cx88_ctrl cx8800_ctls[] = {
+static const struct cx88_ctrl cx8800_ctls[] = {
 	/* --- video --- */
 	{
 		.v = {
@@ -288,7 +288,7 @@ static struct cx88_ctrl cx8800_ctls[] = {
 		.shift                 = 0,
 	}
 };
-static const int CX8800_CTLS = ARRAY_SIZE(cx8800_ctls);
+enum { CX8800_CTLS = ARRAY_SIZE(cx8800_ctls) };
 
 /* Must be sorted from low to high control ID! */
 const u32 cx88_user_ctrls[] = {
@@ -306,7 +306,7 @@ const u32 cx88_user_ctrls[] = {
 };
 EXPORT_SYMBOL(cx88_user_ctrls);
 
-static const u32 *ctrl_classes[] = {
+static const u32 * const ctrl_classes[] = {
 	cx88_user_ctrls,
 	NULL
 };
@@ -710,7 +710,7 @@ static void buffer_release(struct videobuf_queue *q, struct videobuf_buffer *vb)
 	cx88_free_buffer(q,buf);
 }
 
-static struct videobuf_queue_ops cx8800_video_qops = {
+static const struct videobuf_queue_ops cx8800_video_qops = {
 	.buf_setup    = buffer_setup,
 	.buf_prepare  = buffer_prepare,
 	.buf_queue    = buffer_queue,
@@ -944,7 +944,7 @@ video_mmap(struct file *file, struct vm_area_struct * vma)
 
 int cx88_get_control (struct cx88_core  *core, struct v4l2_control *ctl)
 {
-	struct cx88_ctrl  *c    = NULL;
+	const struct cx88_ctrl  *c    = NULL;
 	u32 value;
 	int i;
 
@@ -976,7 +976,7 @@ EXPORT_SYMBOL(cx88_get_control);
 
 int cx88_set_control(struct cx88_core *core, struct v4l2_control *ctl)
 {
-	struct cx88_ctrl *c = NULL;
+	const struct cx88_ctrl *c = NULL;
 	u32 value,mask;
 	int i;
 
@@ -1072,7 +1072,7 @@ static int vidioc_try_fmt_vid_cap(struct file *file, void *priv,
 			struct v4l2_format *f)
 {
 	struct cx88_core  *core = ((struct cx8800_fh *)priv)->dev->core;
-	struct cx8800_fmt *fmt;
+	const struct cx8800_fmt *fmt;
 	enum v4l2_field   field;
 	unsigned int      maxw, maxh;
 
@@ -1247,7 +1247,7 @@ static int vidioc_s_std (struct file *file, void *priv, v4l2_std_id *tvnorms)
 /* only one input in this sample driver */
 int cx88_enum_input (struct cx88_core  *core,struct v4l2_input *i)
 {
-	static const char *iname[] = {
+	static const char * const iname[] = {
 		[ CX88_VMUX_COMPOSITE1 ] = "Composite1",
 		[ CX88_VMUX_COMPOSITE2 ] = "Composite2",
 		[ CX88_VMUX_COMPOSITE3 ] = "Composite3",
@@ -1578,7 +1578,7 @@ static void cx8800_vid_timeout(unsigned long data)
 	spin_unlock_irqrestore(&dev->slock,flags);
 }
 
-static char *cx88_vid_irqs[32] = {
+static const char *cx88_vid_irqs[32] = {
 	"y_risci1", "u_risci1", "v_risci1", "vbi_risc1",
 	"y_risci2", "u_risci2", "v_risci2", "vbi_risc2",
 	"y_oflow",  "u_oflow",  "v_oflow",  "vbi_oflow",
@@ -1723,7 +1723,7 @@ static const struct v4l2_ioctl_ops video_ioctl_ops = {
 
 static struct video_device cx8800_vbi_template;
 
-static struct video_device cx8800_video_template = {
+static const struct video_device cx8800_video_template = {
 	.name                 = "cx8800-video",
 	.fops                 = &video_fops,
 	.ioctl_ops 	      = &video_ioctl_ops,
@@ -1758,7 +1758,7 @@ static const struct v4l2_ioctl_ops radio_ioctl_ops = {
 #endif
 };
 
-static struct video_device cx8800_radio_template = {
+static const struct video_device cx8800_radio_template = {
 	.name                 = "cx8800-radio",
 	.fops                 = &radio_fops,
 	.ioctl_ops 	      = &radio_ioctl_ops,
@@ -1885,7 +1885,7 @@ static int __devinit cx8800_initdev(struct pci_dev *pci_dev,
 	switch (core->boardnr) {
 	case CX88_BOARD_DVICO_FUSIONHDTV_5_GOLD:
 	case CX88_BOARD_DVICO_FUSIONHDTV_7_GOLD: {
-		static struct i2c_board_info rtc_info = {
+		static const struct i2c_board_info rtc_info = {
 			I2C_BOARD_INFO("isl1208", 0x6f)
 		};
 
@@ -2082,7 +2082,7 @@ static int cx8800_resume(struct pci_dev *pci_dev)
 
 /* ----------------------------------------------------------- */
 
-static struct pci_device_id cx8800_pci_tbl[] = {
+static const struct pci_device_id cx8800_pci_tbl[] = {
 	{
 		.vendor       = 0x14f1,
 		.device       = 0x8800,
diff --git a/drivers/media/video/cx88/cx88.h b/drivers/media/video/cx88/cx88.h
index bdb03d3..1e0327d 100644
--- a/drivers/media/video/cx88/cx88.h
+++ b/drivers/media/video/cx88/cx88.h
@@ -108,7 +108,7 @@ static unsigned int inline norm_maxh(v4l2_std_id norm)
 /* static data                                                 */
 
 struct cx8800_fmt {
-	char  *name;
+	const char  *name;
 	u32   fourcc;          /* v4l2 format id */
 	int   depth;
 	int   flags;
@@ -138,7 +138,7 @@ struct cx88_ctrl {
 /* more */
 
 struct sram_channel {
-	char *name;
+	const char *name;
 	u32  cmds_start;
 	u32  ctrl_start;
 	u32  cdt;
@@ -149,7 +149,7 @@ struct sram_channel {
 	u32  cnt1_reg;
 	u32  cnt2_reg;
 };
-extern struct sram_channel cx88_sram_channels[];
+extern const struct sram_channel const cx88_sram_channels[];
 
 /* ----------------------------------------------------------- */
 /* card configuration                                          */
@@ -262,7 +262,7 @@ struct cx88_input {
 };
 
 struct cx88_board {
-	char                    *name;
+	const char              *name;
 	unsigned int            tuner_type;
 	unsigned int		radio_type;
 	unsigned char		tuner_addr;
@@ -300,7 +300,7 @@ struct cx88_buffer {
 	/* cx88 specific */
 	unsigned int           bpl;
 	struct btcx_riscmem    risc;
-	struct cx8800_fmt      *fmt;
+	const struct cx8800_fmt *fmt;
 	u32                    count;
 };
 
@@ -410,7 +410,7 @@ struct cx8800_fh {
 	unsigned int               nclips;
 
 	/* video capture */
-	struct cx8800_fmt          *fmt;
+	const struct cx8800_fmt    *fmt;
 	unsigned int               width,height;
 	struct videobuf_queue      vidq;
 
@@ -565,7 +565,7 @@ struct cx8802_dev {
 /* ----------------------------------------------------------- */
 /* cx88-core.c                                                 */
 
-extern void cx88_print_irqbits(char *name, char *tag, char **strings,
+extern void cx88_print_irqbits(const char *name, const char *tag, const char *strings[],
 			       int len, u32 bits, u32 mask);
 
 extern int cx88_core_irq(struct cx88_core *core, u32 status);
@@ -592,10 +592,10 @@ cx88_free_buffer(struct videobuf_queue *q, struct cx88_buffer *buf);
 extern void cx88_risc_disasm(struct cx88_core *core,
 			     struct btcx_riscmem *risc);
 extern int cx88_sram_channel_setup(struct cx88_core *core,
-				   struct sram_channel *ch,
+				   const struct sram_channel *ch,
 				   unsigned int bpl, u32 risc);
 extern void cx88_sram_channel_dump(struct cx88_core *core,
-				   struct sram_channel *ch);
+				   const struct sram_channel *ch);
 
 extern int cx88_set_scale(struct cx88_core *core, unsigned int width,
 			  unsigned int height, enum v4l2_field field);
@@ -603,8 +603,8 @@ extern int cx88_set_tvnorm(struct cx88_core *core, v4l2_std_id norm);
 
 extern struct video_device *cx88_vdev_init(struct cx88_core *core,
 					   struct pci_dev *pci,
-					   struct video_device *template,
-					   char *type);
+					   const struct video_device *template_,
+					   const char *type);
 extern struct cx88_core* cx88_core_get(struct pci_dev *pci);
 extern void cx88_core_put(struct cx88_core *core,
 			  struct pci_dev *pci);
@@ -630,7 +630,7 @@ int cx8800_restart_vbi_queue(struct cx8800_dev    *dev,
 			     struct cx88_dmaqueue *q);
 void cx8800_vbi_timeout(unsigned long data);
 
-extern struct videobuf_queue_ops cx8800_vbi_qops;
+extern const struct videobuf_queue_ops cx8800_vbi_qops;
 
 /* ----------------------------------------------------------- */
 /* cx88-i2c.c                                                  */
-- 
1.7.0.4




