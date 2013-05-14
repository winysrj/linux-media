Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-1.atlantis.sk ([80.94.52.57]:45577 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757791Ab3ENUzU (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 14 May 2013 16:55:20 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 3/3] bttv: Convert to generic TEA575x interface
Date: Tue, 14 May 2013 22:54:45 +0200
Message-Id: <1368564885-20940-4-git-send-email-linux@rainbow-software.org>
In-Reply-To: <1368564885-20940-1-git-send-email-linux@rainbow-software.org>
References: <1368564885-20940-1-git-send-email-linux@rainbow-software.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Remove tea575x-specific code from bttv and use the common driver instead.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/media/pci/bt8xx/bttv-cards.c  |  317 ++++++++++++---------------------
 drivers/media/pci/bt8xx/bttv-driver.c |    6 +-
 drivers/media/pci/bt8xx/bttvp.h       |   14 +-
 sound/pci/Kconfig                     |    4 +-
 4 files changed, 124 insertions(+), 217 deletions(-)

diff --git a/drivers/media/pci/bt8xx/bttv-cards.c b/drivers/media/pci/bt8xx/bttv-cards.c
index 24c7511..8044df9 100644
--- a/drivers/media/pci/bt8xx/bttv-cards.c
+++ b/drivers/media/pci/bt8xx/bttv-cards.c
@@ -83,8 +83,7 @@ static void gv800s_init(struct bttv *btv);
 static void td3116_muxsel(struct bttv *btv, unsigned int input);
 
 static int terratec_active_radio_upgrade(struct bttv *btv);
-static int tea5757_read(struct bttv *btv);
-static int tea5757_write(struct bttv *btv, int value);
+static int tea575x_init(struct bttv *btv);
 static void identify_by_eeprom(struct bttv *btv,
 			       unsigned char eeprom_data[256]);
 static int pvr_boot(struct bttv *btv);
@@ -3023,12 +3022,12 @@ static void miro_pinnacle_gpio(struct bttv *btv)
 		if (0 == (gpio & 0x20)) {
 			btv->has_radio = 1;
 			if (!miro_fmtuner[id]) {
-				btv->has_matchbox = 1;
-				btv->mbox_we    = (1<<6);
-				btv->mbox_most  = (1<<7);
-				btv->mbox_clk   = (1<<8);
-				btv->mbox_data  = (1<<9);
-				btv->mbox_mask  = (1<<6)|(1<<7)|(1<<8)|(1<<9);
+				btv->has_tea575x = 1;
+				btv->tea_gpio.wren = 6;
+				btv->tea_gpio.most = 7;
+				btv->tea_gpio.clk  = 8;
+				btv->tea_gpio.data = 9;
+				tea575x_init(btv);
 			}
 		} else {
 			btv->has_radio = 0;
@@ -3042,7 +3041,7 @@ static void miro_pinnacle_gpio(struct bttv *btv)
 		pr_info("%d: miro: id=%d tuner=%d radio=%s stereo=%s\n",
 			btv->c.nr, id+1, btv->tuner_type,
 			!btv->has_radio ? "no" :
-			(btv->has_matchbox ? "matchbox" : "fmtuner"),
+			(btv->has_tea575x ? "tea575x" : "fmtuner"),
 			(-1 == msp) ? "no" : "yes");
 	} else {
 		/* new cards with microtune tuner */
@@ -3317,12 +3316,12 @@ void bttv_init_card2(struct bttv *btv)
 		break;
 	case BTTV_BOARD_VHX:
 		btv->has_radio    = 1;
-		btv->has_matchbox = 1;
-		btv->mbox_we      = 0x20;
-		btv->mbox_most    = 0;
-		btv->mbox_clk     = 0x08;
-		btv->mbox_data    = 0x10;
-		btv->mbox_mask    = 0x38;
+		btv->has_tea575x  = 1;
+		btv->tea_gpio.wren = 5;
+		btv->tea_gpio.most = 6;
+		btv->tea_gpio.clk  = 3;
+		btv->tea_gpio.data = 4;
+		tea575x_init(btv);
 		break;
 	case BTTV_BOARD_VOBIS_BOOSTAR:
 	case BTTV_BOARD_TERRATV:
@@ -3670,33 +3669,112 @@ static void hauppauge_eeprom(struct bttv *btv)
 		btv->radio_uses_msp_demodulator = 1;
 }
 
-static int terratec_active_radio_upgrade(struct bttv *btv)
+/* ----------------------------------------------------------------------- */
+
+static void bttv_tea575x_set_pins(struct snd_tea575x *tea, u8 pins)
+{
+	struct bttv *btv = tea->private_data;
+	struct bttv_tea575x_gpio gpio = btv->tea_gpio;
+	u16 val = 0;
+
+	val |= (pins & TEA575X_DATA) ? (1 << gpio.data) : 0;
+	val |= (pins & TEA575X_CLK)  ? (1 << gpio.clk)  : 0;
+	val |= (pins & TEA575X_WREN) ? (1 << gpio.wren) : 0;
+
+	gpio_bits((1 << gpio.data) | (1 << gpio.clk) | (1 << gpio.wren), val);
+	if (btv->mbox_ior) {
+		/* IOW and CSEL active */
+		gpio_bits(btv->mbox_iow | btv->mbox_csel, 0);
+		udelay(5);
+		/* all inactive */
+		gpio_bits(btv->mbox_ior | btv->mbox_iow | btv->mbox_csel,
+			  btv->mbox_ior | btv->mbox_iow | btv->mbox_csel);
+	}
+}
+
+static u8 bttv_tea575x_get_pins(struct snd_tea575x *tea)
 {
-	int freq;
+	struct bttv *btv = tea->private_data;
+	struct bttv_tea575x_gpio gpio = btv->tea_gpio;
+	u8 ret = 0;
+	u16 val;
+
+	if (btv->mbox_ior) {
+		/* IOR and CSEL active */
+		gpio_bits(btv->mbox_ior | btv->mbox_csel, 0);
+		udelay(5);
+	}
+	val = gpio_read();
+	if (btv->mbox_ior) {
+		/* all inactive */
+		gpio_bits(btv->mbox_ior | btv->mbox_iow | btv->mbox_csel,
+			  btv->mbox_ior | btv->mbox_iow | btv->mbox_csel);
+	}
+
+	if (val & (1 << gpio.data))
+		ret |= TEA575X_DATA;
+	if (val & (1 << gpio.most))
+		ret |= TEA575X_MOST;
+
+	return ret;
+}
+
+static void bttv_tea575x_set_direction(struct snd_tea575x *tea, bool output)
+{
+	struct bttv *btv = tea->private_data;
+	struct bttv_tea575x_gpio gpio = btv->tea_gpio;
+	u32 mask = (1 << gpio.clk) | (1 << gpio.wren) | (1 << gpio.data) |
+		   (1 << gpio.most);
+
+	if (output)
+		gpio_inout(mask, (1 << gpio.data) | (1 << gpio.clk) |
+				 (1 << gpio.wren));
+	else
+		gpio_inout(mask, (1 << gpio.clk) | (1 << gpio.wren));
+}
+
+static struct snd_tea575x_ops bttv_tea_ops = {
+	.set_pins = bttv_tea575x_set_pins,
+	.get_pins = bttv_tea575x_get_pins,
+	.set_direction = bttv_tea575x_set_direction,
+};
+
+static int tea575x_init(struct bttv *btv)
+{
+	btv->tea.private_data = btv;
+	btv->tea.ops = &bttv_tea_ops;
+	if (!snd_tea575x_hw_init(&btv->tea)) {
+		pr_info("%d: detected TEA575x radio\n", btv->c.nr);
+		btv->tea.mute = false;
+		return 0;
+	}
 
+	btv->has_tea575x = 0;
+	btv->has_radio = 0;
+
+	return -ENODEV;
+}
+
+/* ----------------------------------------------------------------------- */
+
+static int terratec_active_radio_upgrade(struct bttv *btv)
+{
 	btv->has_radio    = 1;
-	btv->has_matchbox = 1;
-	btv->mbox_we      = 0x10;
-	btv->mbox_most    = 0x20;
-	btv->mbox_clk     = 0x08;
-	btv->mbox_data    = 0x04;
-	btv->mbox_mask    = 0x3c;
+	btv->has_tea575x  = 1;
+	btv->tea_gpio.wren = 4;
+	btv->tea_gpio.most = 5;
+	btv->tea_gpio.clk  = 3;
+	btv->tea_gpio.data = 2;
 
 	btv->mbox_iow     = 1 <<  8;
 	btv->mbox_ior     = 1 <<  9;
 	btv->mbox_csel    = 1 << 10;
 
-	freq=88000/62.5;
-	tea5757_write(btv, 5 * freq + 0x358); /* write 0x1ed8 */
-	if (0x1ed8 == tea5757_read(btv)) {
+	if (!tea575x_init(btv)) {
 		pr_info("%d: Terratec Active Radio Upgrade found\n", btv->c.nr);
-		btv->has_radio    = 1;
-		btv->has_saa6588  = 1;
-		btv->has_matchbox = 1;
-	} else {
-		btv->has_radio    = 0;
-		btv->has_matchbox = 0;
+		btv->has_saa6588 = 1;
 	}
+
 	return 0;
 }
 
@@ -4127,181 +4205,6 @@ init_RTV24 (struct bttv *btv)
 	pr_info("%d: Adlink RTV-24 initialisation complete\n", btv->c.nr);
 }
 
-
-
-/* ----------------------------------------------------------------------- */
-/* Miro Pro radio stuff -- the tea5757 is connected to some GPIO ports     */
-/*
- * Copyright (c) 1999 Csaba Halasz <qgehali@uni-miskolc.hu>
- * This code is placed under the terms of the GNU General Public License
- *
- * Brutally hacked by Dan Sheridan <dan.sheridan@contact.org.uk> djs52 8/3/00
- */
-
-static void bus_low(struct bttv *btv, int bit)
-{
-	if (btv->mbox_ior) {
-		gpio_bits(btv->mbox_ior | btv->mbox_iow | btv->mbox_csel,
-			  btv->mbox_ior | btv->mbox_iow | btv->mbox_csel);
-		udelay(5);
-	}
-
-	gpio_bits(bit,0);
-	udelay(5);
-
-	if (btv->mbox_ior) {
-		gpio_bits(btv->mbox_iow | btv->mbox_csel, 0);
-		udelay(5);
-	}
-}
-
-static void bus_high(struct bttv *btv, int bit)
-{
-	if (btv->mbox_ior) {
-		gpio_bits(btv->mbox_ior | btv->mbox_iow | btv->mbox_csel,
-			  btv->mbox_ior | btv->mbox_iow | btv->mbox_csel);
-		udelay(5);
-	}
-
-	gpio_bits(bit,bit);
-	udelay(5);
-
-	if (btv->mbox_ior) {
-		gpio_bits(btv->mbox_iow | btv->mbox_csel, 0);
-		udelay(5);
-	}
-}
-
-static int bus_in(struct bttv *btv, int bit)
-{
-	if (btv->mbox_ior) {
-		gpio_bits(btv->mbox_ior | btv->mbox_iow | btv->mbox_csel,
-			  btv->mbox_ior | btv->mbox_iow | btv->mbox_csel);
-		udelay(5);
-
-		gpio_bits(btv->mbox_iow | btv->mbox_csel, 0);
-		udelay(5);
-	}
-	return gpio_read() & (bit);
-}
-
-/* TEA5757 register bits */
-#define TEA_FREQ		0:14
-#define TEA_BUFFER		15:15
-
-#define TEA_SIGNAL_STRENGTH	16:17
-
-#define TEA_PORT1		18:18
-#define TEA_PORT0		19:19
-
-#define TEA_BAND		20:21
-#define TEA_BAND_FM		0
-#define TEA_BAND_MW		1
-#define TEA_BAND_LW		2
-#define TEA_BAND_SW		3
-
-#define TEA_MONO		22:22
-#define TEA_ALLOW_STEREO	0
-#define TEA_FORCE_MONO		1
-
-#define TEA_SEARCH_DIRECTION	23:23
-#define TEA_SEARCH_DOWN		0
-#define TEA_SEARCH_UP		1
-
-#define TEA_STATUS		24:24
-#define TEA_STATUS_TUNED	0
-#define TEA_STATUS_SEARCHING	1
-
-/* Low-level stuff */
-static int tea5757_read(struct bttv *btv)
-{
-	unsigned long timeout;
-	int value = 0;
-	int i;
-
-	/* better safe than sorry */
-	gpio_inout(btv->mbox_mask, btv->mbox_clk | btv->mbox_we);
-
-	if (btv->mbox_ior) {
-		gpio_bits(btv->mbox_ior | btv->mbox_iow | btv->mbox_csel,
-			  btv->mbox_ior | btv->mbox_iow | btv->mbox_csel);
-		udelay(5);
-	}
-
-	if (bttv_gpio)
-		bttv_gpio_tracking(btv,"tea5757 read");
-
-	bus_low(btv,btv->mbox_we);
-	bus_low(btv,btv->mbox_clk);
-
-	udelay(10);
-	timeout= jiffies + msecs_to_jiffies(1000);
-
-	/* wait for DATA line to go low; error if it doesn't */
-	while (bus_in(btv,btv->mbox_data) && time_before(jiffies, timeout))
-		schedule();
-	if (bus_in(btv,btv->mbox_data)) {
-		pr_warn("%d: tea5757: read timeout\n", btv->c.nr);
-		return -1;
-	}
-
-	dprintk("%d: tea5757:", btv->c.nr);
-	for (i = 0; i < 24; i++) {
-		udelay(5);
-		bus_high(btv,btv->mbox_clk);
-		udelay(5);
-		dprintk_cont("%c",
-			     bus_in(btv, btv->mbox_most) == 0 ? 'T' : '-');
-		bus_low(btv,btv->mbox_clk);
-		value <<= 1;
-		value |= (bus_in(btv,btv->mbox_data) == 0)?0:1;  /* MSB first */
-		dprintk_cont("%c",
-			     bus_in(btv, btv->mbox_most) == 0 ? 'S' : 'M');
-	}
-	dprintk_cont("\n");
-	dprintk("%d: tea5757: read 0x%X\n", btv->c.nr, value);
-	return value;
-}
-
-static int tea5757_write(struct bttv *btv, int value)
-{
-	int i;
-	int reg = value;
-
-	gpio_inout(btv->mbox_mask, btv->mbox_clk | btv->mbox_we | btv->mbox_data);
-
-	if (btv->mbox_ior) {
-		gpio_bits(btv->mbox_ior | btv->mbox_iow | btv->mbox_csel,
-			  btv->mbox_ior | btv->mbox_iow | btv->mbox_csel);
-		udelay(5);
-	}
-	if (bttv_gpio)
-		bttv_gpio_tracking(btv,"tea5757 write");
-
-	dprintk("%d: tea5757: write 0x%X\n", btv->c.nr, value);
-	bus_low(btv,btv->mbox_clk);
-	bus_high(btv,btv->mbox_we);
-	for (i = 0; i < 25; i++) {
-		if (reg & 0x1000000)
-			bus_high(btv,btv->mbox_data);
-		else
-			bus_low(btv,btv->mbox_data);
-		reg <<= 1;
-		bus_high(btv,btv->mbox_clk);
-		udelay(10);
-		bus_low(btv,btv->mbox_clk);
-		udelay(10);
-	}
-	bus_low(btv,btv->mbox_we);  /* unmute !!! */
-	return 0;
-}
-
-void tea5757_set_freq(struct bttv *btv, unsigned short freq)
-{
-	dprintk("tea5757_set_freq %d\n",freq);
-	tea5757_write(btv, 5 * freq + 0x358); /* add 10.7MHz (see docs) */
-}
-
 /* RemoteVision MX (rv605) muxsel helper [Miguel Freitas]
  *
  * This is needed because rv605 don't use a normal multiplex, but a crosspoint
diff --git a/drivers/media/pci/bt8xx/bttv-driver.c b/drivers/media/pci/bt8xx/bttv-driver.c
index e7d0884..c9d1bb1 100644
--- a/drivers/media/pci/bt8xx/bttv-driver.c
+++ b/drivers/media/pci/bt8xx/bttv-driver.c
@@ -1876,8 +1876,10 @@ static void bttv_set_frequency(struct bttv *btv, const struct v4l2_frequency *f)
 	if (new_freq.type == V4L2_TUNER_RADIO) {
 		radio_enable(btv);
 		btv->radio_freq = new_freq.frequency;
-		if (btv->has_matchbox)
-			tea5757_set_freq(btv, btv->radio_freq);
+		if (btv->has_tea575x) {
+			btv->tea.freq = btv->radio_freq;
+			snd_tea575x_set_freq(&btv->tea);
+		}
 	} else {
 		btv->tv_freq = new_freq.frequency;
 	}
diff --git a/drivers/media/pci/bt8xx/bttvp.h b/drivers/media/pci/bt8xx/bttvp.h
index 6eefb59..5163528 100644
--- a/drivers/media/pci/bt8xx/bttvp.h
+++ b/drivers/media/pci/bt8xx/bttvp.h
@@ -42,6 +42,7 @@
 #include <media/tveeprom.h>
 #include <media/rc-core.h>
 #include <media/ir-kbd-i2c.h>
+#include <sound/tea575x-tuner.h>
 
 #include "bt848.h"
 #include "bttv.h"
@@ -361,6 +362,10 @@ struct bttv_suspend_state {
 	struct bttv_buffer     *vbi;
 };
 
+struct bttv_tea575x_gpio {
+	u8 data, clk, wren, most;
+};
+
 struct bttv {
 	struct bttv_core c;
 
@@ -447,12 +452,9 @@ struct bttv {
 
 	/* miro/pinnacle + Aimslab VHX
 	   philips matchbox (tea5757 radio tuner) support */
-	int has_matchbox;
-	int mbox_we;
-	int mbox_data;
-	int mbox_clk;
-	int mbox_most;
-	int mbox_mask;
+	int has_tea575x;
+	struct bttv_tea575x_gpio tea_gpio;
+	struct snd_tea575x tea;
 
 	/* ISA stuff (Terratec Active Radio Upgrade) */
 	int mbox_ior;
diff --git a/sound/pci/Kconfig b/sound/pci/Kconfig
index fe6fa93..83e0df5 100644
--- a/sound/pci/Kconfig
+++ b/sound/pci/Kconfig
@@ -2,8 +2,8 @@
 
 config SND_TEA575X
 	tristate
-	depends on SND_FM801_TEA575X_BOOL || SND_ES1968_RADIO || RADIO_SF16FMR2 || RADIO_MAXIRADIO || RADIO_SHARK
-	default SND_FM801 || SND_ES1968 || RADIO_SF16FMR2 || RADIO_MAXIRADIO || RADIO_SHARK
+	depends on SND_FM801_TEA575X_BOOL || SND_ES1968_RADIO || RADIO_SF16FMR2 || RADIO_MAXIRADIO || RADIO_SHARK || VIDEO_BT848
+	default SND_FM801 || SND_ES1968 || RADIO_SF16FMR2 || RADIO_MAXIRADIO || RADIO_SHARK || VIDEO_BT848
 
 menuconfig SND_PCI
 	bool "PCI sound devices"
-- 
Ondrej Zary

