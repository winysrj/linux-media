Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49633 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753525AbcKPQnN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Nov 2016 11:43:13 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Andrey Utkin <andrey.utkin@corp.bluecherry.net>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Stephen Backway <stev391@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Devin Heitmueller <dheitmueller@kernellabs.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Geunyoung Kim <nenggun.kim@samsung.com>,
        Junghak Sung <jh1009.sung@samsung.com>,
        Olli Salonen <olli.salonen@iki.fi>,
        Matthias Schwarzott <zzam@gentoo.org>,
        Sean Young <sean@mess.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH 06/35] [media] cx23885: convert it to use pr_foo() macros
Date: Wed, 16 Nov 2016 14:42:38 -0200
Message-Id: <f152aad0106bcf5faa13f8cf17449bb7e15fb947.1479314177.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1479314177.git.mchehab@s-opensource.com>
References: <cover.1479314177.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1479314177.git.mchehab@s-opensource.com>
References: <cover.1479314177.git.mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

Instead of calling printk() directly, use pr_foo()
macros, as suggested at the Kernel's coding style.

Please notice that a conversion to dev_foo() is not trivial,
as several parts on this driver uses pr_cont().

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/pci/cx23885/altera-ci.c     |  13 ++-
 drivers/media/pci/cx23885/altera-ci.h     |  14 +--
 drivers/media/pci/cx23885/cimax2.c        |   8 +-
 drivers/media/pci/cx23885/cx23885-417.c   |  57 ++++++-------
 drivers/media/pci/cx23885/cx23885-alsa.c  |  21 ++---
 drivers/media/pci/cx23885/cx23885-cards.c |  49 ++++++-----
 drivers/media/pci/cx23885/cx23885-core.c  | 137 ++++++++++++++----------------
 drivers/media/pci/cx23885/cx23885-dvb.c   |  40 ++++-----
 drivers/media/pci/cx23885/cx23885-f300.c  |   2 +-
 drivers/media/pci/cx23885/cx23885-i2c.c   |  25 +++---
 drivers/media/pci/cx23885/cx23885-input.c |   6 +-
 drivers/media/pci/cx23885/cx23885-ir.c    |   4 +-
 drivers/media/pci/cx23885/cx23885-vbi.c   |   7 +-
 drivers/media/pci/cx23885/cx23885-video.c |  23 ++---
 drivers/media/pci/cx23885/cx23885.h       |   2 +
 drivers/media/pci/cx23885/cx23888-ir.c    |   6 +-
 drivers/media/pci/cx23885/netup-eeprom.c  |   4 +-
 drivers/media/pci/cx23885/netup-init.c    |   8 +-
 18 files changed, 208 insertions(+), 218 deletions(-)

diff --git a/drivers/media/pci/cx23885/altera-ci.c b/drivers/media/pci/cx23885/altera-ci.c
index aaf4e46ff3e9..88a9b8788a17 100644
--- a/drivers/media/pci/cx23885/altera-ci.c
+++ b/drivers/media/pci/cx23885/altera-ci.c
@@ -48,6 +48,9 @@
  * |  DATA7|  DATA6|  DATA5|  DATA4|  DATA3|  DATA2|  DATA1|  DATA0|
  * +-------+-------+-------+-------+-------+-------+-------+-------+
  */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <dvb_demux.h>
 #include <dvb_frontend.h>
 #include "altera-ci.h"
@@ -84,16 +87,18 @@ MODULE_DESCRIPTION("altera FPGA CI module");
 MODULE_AUTHOR("Igor M. Liplianin  <liplianin@netup.ru>");
 MODULE_LICENSE("GPL");
 
-#define ci_dbg_print(args...) \
+#define ci_dbg_print(fmt, args...) \
 	do { \
 		if (ci_dbg) \
-			printk(KERN_DEBUG args); \
+			printk(KERN_DEBUG pr_fmt("%s: " fmt), \
+			       __func__, ##args); \
 	} while (0)
 
-#define pid_dbg_print(args...) \
+#define pid_dbg_print(fmt, args...) \
 	do { \
 		if (pid_dbg) \
-			printk(KERN_DEBUG args); \
+			printk(KERN_DEBUG pr_fmt("%s: " fmt), \
+			       __func__, ##args); \
 	} while (0)
 
 struct altera_ci_state;
diff --git a/drivers/media/pci/cx23885/altera-ci.h b/drivers/media/pci/cx23885/altera-ci.h
index 57a40c84b46e..ababd80fee93 100644
--- a/drivers/media/pci/cx23885/altera-ci.h
+++ b/drivers/media/pci/cx23885/altera-ci.h
@@ -48,24 +48,24 @@ extern int altera_ci_tuner_reset(void *dev, int ci_nr);
 
 static inline int altera_ci_init(struct altera_ci_config *config, int ci_nr)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
+	pr_warn("%s: driver disabled by Kconfig\n", __func__);
 	return 0;
 }
 
 static inline void altera_ci_release(void *dev, int ci_nr)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
+	pr_warn("%s: driver disabled by Kconfig\n", __func__);
 }
 
 static inline int altera_ci_irq(void *dev)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
+	pr_warn("%s: driver disabled by Kconfig\n", __func__);
 	return 0;
 }
 
 static inline int altera_ci_tuner_reset(void *dev, int ci_nr)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
+	pr_warn("%s: driver disabled by Kconfig\n", __func__);
 	return 0;
 }
 
@@ -74,19 +74,19 @@ static inline int altera_ci_tuner_reset(void *dev, int ci_nr)
 static inline int altera_hw_filt_init(struct altera_ci_config *config,
 							int hw_filt_nr)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
+	pr_warn("%s: driver disabled by Kconfig\n", __func__);
 	return 0;
 }
 
 static inline void altera_hw_filt_release(void *dev, int filt_nr)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
+	pr_warn("%s: driver disabled by Kconfig\n", __func__);
 }
 
 static inline int altera_pid_feed_control(void *dev, int filt_nr,
 		struct dvb_demux_feed *dvbdmxfeed, int onoff)
 {
-	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
+	pr_warn("%s: driver disabled by Kconfig\n", __func__);
 	return 0;
 }
 
diff --git a/drivers/media/pci/cx23885/cimax2.c b/drivers/media/pci/cx23885/cimax2.c
index d644c65622e2..5e8e134d81c2 100644
--- a/drivers/media/pci/cx23885/cimax2.c
+++ b/drivers/media/pci/cx23885/cimax2.c
@@ -65,10 +65,11 @@ static unsigned int ci_irq_enable;
 module_param(ci_irq_enable, int, 0644);
 MODULE_PARM_DESC(ci_irq_enable, "Enable IRQ from CAM");
 
-#define ci_dbg_print(args...) \
+#define ci_dbg_print(fmt, args...) \
 	do { \
 		if (ci_dbg) \
-			printk(KERN_DEBUG args); \
+			printk(KERN_DEBUG pr_fmt("%s: " fmt), \
+			       __func__, ##args); \
 	} while (0)
 
 #define ci_irq_flags() (ci_irq_enable ? NETUP_IRQ_IRQAM : 0)
@@ -135,8 +136,7 @@ static int netup_write_i2c(struct i2c_adapter *i2c_adap, u8 addr, u8 reg,
 	};
 
 	if (1 + len > sizeof(buffer)) {
-		printk(KERN_WARNING
-		       "%s: i2c wr reg=%04x: len=%d is too big!\n",
+		pr_warn("%s: i2c wr reg=%04x: len=%d is too big!\n",
 		       KBUILD_MODNAME, reg, len);
 		return -EINVAL;
 	}
diff --git a/drivers/media/pci/cx23885/cx23885-417.c b/drivers/media/pci/cx23885/cx23885-417.c
index 0c122585a1f0..2ff1d1e274be 100644
--- a/drivers/media/pci/cx23885/cx23885-417.c
+++ b/drivers/media/pci/cx23885/cx23885-417.c
@@ -20,6 +20,9 @@
  *  GNU General Public License for more details.
  */
 
+#include "cx23885.h"
+#include "cx23885-ioctl.h"
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/init.h>
@@ -32,9 +35,6 @@
 #include <media/v4l2-ioctl.h>
 #include <media/drv-intf/cx2341x.h>
 
-#include "cx23885.h"
-#include "cx23885-ioctl.h"
-
 #define CX23885_FIRM_IMAGE_SIZE 376836
 #define CX23885_FIRM_IMAGE_NAME "v4l-cx23885-enc.fw"
 
@@ -55,8 +55,8 @@ MODULE_PARM_DESC(v4l_debug, "enable V4L debug messages");
 
 #define dprintk(level, fmt, arg...)\
 	do { if (v4l_debug >= level) \
-		printk(KERN_DEBUG "%s: " fmt, \
-		(dev) ? dev->name : "cx23885[?]", ## arg); \
+		printk(KERN_DEBUG pr_fmt("%s: 417:" fmt), \
+			__func__, ##arg); \
 	} while (0)
 
 static struct cx23885_tvnorm cx23885_tvnorms[] = {
@@ -769,8 +769,7 @@ static int cx23885_mbox_func(void *priv,
 	   without side effects */
 	mc417_memory_read(dev, dev->cx23417_mailbox - 4, &value);
 	if (value != 0x12345678) {
-		printk(KERN_ERR
-			"Firmware and/or mailbox pointer not initialized or corrupted, signature = 0x%x, cmd = %s\n",
+		pr_err("Firmware and/or mailbox pointer not initialized or corrupted, signature = 0x%x, cmd = %s\n",
 			value, cmd_to_str(command));
 		return -1;
 	}
@@ -780,7 +779,7 @@ static int cx23885_mbox_func(void *priv,
 	 */
 	mc417_memory_read(dev, dev->cx23417_mailbox, &flag);
 	if (flag) {
-		printk(KERN_ERR "ERROR: Mailbox appears to be in use (%x), cmd = %s\n",
+		pr_err("ERROR: Mailbox appears to be in use (%x), cmd = %s\n",
 		       flag, cmd_to_str(command));
 		return -1;
 	}
@@ -810,7 +809,7 @@ static int cx23885_mbox_func(void *priv,
 		if (0 != (flag & 4))
 			break;
 		if (time_after(jiffies, timeout)) {
-			printk(KERN_ERR "ERROR: API Mailbox timeout\n");
+			pr_err("ERROR: API Mailbox timeout\n");
 			return -1;
 		}
 		udelay(10);
@@ -887,7 +886,7 @@ static int cx23885_find_mailbox(struct cx23885_dev *dev)
 			return i+1;
 		}
 	}
-	printk(KERN_ERR "Mailbox signature values not found!\n");
+	pr_err("Mailbox signature values not found!\n");
 	return -1;
 }
 
@@ -922,7 +921,7 @@ static int cx23885_load_firmware(struct cx23885_dev *dev)
 		IVTV_REG_APU, 0);
 
 	if (retval != 0) {
-		printk(KERN_ERR "%s: Error with mc417_register_write\n",
+		pr_err("%s: Error with mc417_register_write\n",
 			__func__);
 		return -1;
 	}
@@ -931,23 +930,21 @@ static int cx23885_load_firmware(struct cx23885_dev *dev)
 				  &dev->pci->dev);
 
 	if (retval != 0) {
-		printk(KERN_ERR
-			"ERROR: Hotplug firmware request failed (%s).\n",
-			CX23885_FIRM_IMAGE_NAME);
-		printk(KERN_ERR "Please fix your hotplug setup, the board will not work without firmware loaded!\n");
+		pr_err("ERROR: Hotplug firmware request failed (%s).\n",
+		       CX23885_FIRM_IMAGE_NAME);
+		pr_err("Please fix your hotplug setup, the board will not work without firmware loaded!\n");
 		return -1;
 	}
 
 	if (firmware->size != CX23885_FIRM_IMAGE_SIZE) {
-		printk(KERN_ERR "ERROR: Firmware size mismatch (have %zu, expected %d)\n",
-			firmware->size, CX23885_FIRM_IMAGE_SIZE);
+		pr_err("ERROR: Firmware size mismatch (have %zu, expected %d)\n",
+		       firmware->size, CX23885_FIRM_IMAGE_SIZE);
 		release_firmware(firmware);
 		return -1;
 	}
 
 	if (0 != memcmp(firmware->data, magic, 8)) {
-		printk(KERN_ERR
-			"ERROR: Firmware magic mismatch, wrong file?\n");
+		pr_err("ERROR: Firmware magic mismatch, wrong file?\n");
 		release_firmware(firmware);
 		return -1;
 	}
@@ -959,7 +956,7 @@ static int cx23885_load_firmware(struct cx23885_dev *dev)
 		value = *dataptr;
 		checksum += ~value;
 		if (mc417_memory_write(dev, i, value) != 0) {
-			printk(KERN_ERR "ERROR: Loading firmware failed!\n");
+			pr_err("ERROR: Loading firmware failed!\n");
 			release_firmware(firmware);
 			return -1;
 		}
@@ -970,15 +967,14 @@ static int cx23885_load_firmware(struct cx23885_dev *dev)
 	dprintk(1, "Verifying firmware ...\n");
 	for (i--; i >= 0; i--) {
 		if (mc417_memory_read(dev, i, &value) != 0) {
-			printk(KERN_ERR "ERROR: Reading firmware failed!\n");
+			pr_err("ERROR: Reading firmware failed!\n");
 			release_firmware(firmware);
 			return -1;
 		}
 		checksum -= ~value;
 	}
 	if (checksum) {
-		printk(KERN_ERR
-			"ERROR: Firmware load failed (checksum mismatch).\n");
+		pr_err("ERROR: Firmware load failed (checksum mismatch).\n");
 		release_firmware(firmware);
 		return -1;
 	}
@@ -1003,7 +999,7 @@ static int cx23885_load_firmware(struct cx23885_dev *dev)
 	mc417_register_read(dev, 0x900C, &gpio_value);
 
 	if (retval < 0)
-		printk(KERN_ERR "%s: Error with mc417_register_write\n",
+		pr_err("%s: Error with mc417_register_write\n",
 			__func__);
 	return 0;
 }
@@ -1055,26 +1051,25 @@ static int cx23885_initialize_codec(struct cx23885_dev *dev, int startencoder)
 		dprintk(2, "%s() PING OK\n", __func__);
 		retval = cx23885_load_firmware(dev);
 		if (retval < 0) {
-			printk(KERN_ERR "%s() f/w load failed\n", __func__);
+			pr_err("%s() f/w load failed\n", __func__);
 			return retval;
 		}
 		retval = cx23885_find_mailbox(dev);
 		if (retval < 0) {
-			printk(KERN_ERR "%s() mailbox < 0, error\n",
+			pr_err("%s() mailbox < 0, error\n",
 				__func__);
 			return -1;
 		}
 		dev->cx23417_mailbox = retval;
 		retval = cx23885_api_cmd(dev, CX2341X_ENC_PING_FW, 0, 0);
 		if (retval < 0) {
-			printk(KERN_ERR
-				"ERROR: cx23417 firmware ping failed!\n");
+			pr_err("ERROR: cx23417 firmware ping failed!\n");
 			return -1;
 		}
 		retval = cx23885_api_cmd(dev, CX2341X_ENC_GET_VERSION, 0, 1,
 			&version);
 		if (retval < 0) {
-			printk(KERN_ERR "ERROR: cx23417 firmware get encoder :version failed!\n");
+			pr_err("ERROR: cx23417 firmware get encoder :version failed!\n");
 			return -1;
 		}
 		dprintk(1, "cx23417 firmware version is 0x%08x\n", version);
@@ -1559,11 +1554,11 @@ int cx23885_417_register(struct cx23885_dev *dev)
 	err = video_register_device(dev->v4l_device,
 		VFL_TYPE_GRABBER, -1);
 	if (err < 0) {
-		printk(KERN_INFO "%s: can't register mpeg device\n", dev->name);
+		pr_info("%s: can't register mpeg device\n", dev->name);
 		return err;
 	}
 
-	printk(KERN_INFO "%s: registered device %s [mpeg]\n",
+	pr_info("%s: registered device %s [mpeg]\n",
 	       dev->name, video_device_node_name(dev->v4l_device));
 
 	/* ST: Configure the encoder paramaters, but don't begin
diff --git a/drivers/media/pci/cx23885/cx23885-alsa.c b/drivers/media/pci/cx23885/cx23885-alsa.c
index 9d2a4e2dc54f..c148f9a4a9ac 100644
--- a/drivers/media/pci/cx23885/cx23885-alsa.c
+++ b/drivers/media/pci/cx23885/cx23885-alsa.c
@@ -17,6 +17,9 @@
  *  GNU General Public License for more details.
  */
 
+#include "cx23885.h"
+#include "cx23885-reg.h"
+
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/device.h>
@@ -35,20 +38,14 @@
 
 #include <sound/tlv.h>
 
-
-#include "cx23885.h"
-#include "cx23885-reg.h"
-
 #define AUDIO_SRAM_CHANNEL	SRAM_CH07
 
 #define dprintk(level, fmt, arg...) do {				\
 	if (audio_debug + 1 > level)					\
-		printk(KERN_INFO "%s: " fmt, chip->dev->name , ## arg);	\
+		printk(KERN_DEBUG pr_fmt("%s: alsa: " fmt), \
+			chip->dev->name, ##arg); \
 } while(0)
 
-#define dprintk_core(level, fmt, arg...)	if (audio_debug >= level) \
-	printk(KERN_DEBUG "%s: " fmt, chip->dev->name , ## arg)
-
 /****************************************************************************
 			Module global static vars
  ****************************************************************************/
@@ -247,7 +244,7 @@ int cx23885_audio_irq(struct cx23885_dev *dev, u32 status, u32 mask)
 
 	/* risc op code error */
 	if (status & AUD_INT_OPC_ERR) {
-		printk(KERN_WARNING "%s/1: Audio risc op code error\n",
+		pr_warn("%s/1: Audio risc op code error\n",
 			dev->name);
 		cx_clear(AUD_INT_DMA_CTL, 0x11);
 		cx23885_sram_channel_dump(dev,
@@ -327,7 +324,7 @@ static int snd_cx23885_pcm_open(struct snd_pcm_substream *substream)
 	int err;
 
 	if (!chip) {
-		printk(KERN_ERR "BUG: cx23885 can't find device struct. Can't proceed with open\n");
+		pr_err("BUG: cx23885 can't find device struct. Can't proceed with open\n");
 		return -ENODEV;
 	}
 
@@ -554,7 +551,7 @@ struct cx23885_audio_dev *cx23885_audio_register(struct cx23885_dev *dev)
 		return NULL;
 
 	if (dev->sram_channels[AUDIO_SRAM_CHANNEL].cmds_start == 0) {
-		printk(KERN_WARNING "%s(): Missing SRAM channel configuration for analog TV Audio\n",
+		pr_warn("%s(): Missing SRAM channel configuration for analog TV Audio\n",
 		       __func__);
 		return NULL;
 	}
@@ -589,7 +586,7 @@ struct cx23885_audio_dev *cx23885_audio_register(struct cx23885_dev *dev)
 
 error:
 	snd_card_free(card);
-	printk(KERN_ERR "%s(): Failed to register analog audio adapter\n",
+	pr_err("%s(): Failed to register analog audio adapter\n",
 	       __func__);
 
 	return NULL;
diff --git a/drivers/media/pci/cx23885/cx23885-cards.c b/drivers/media/pci/cx23885/cx23885-cards.c
index e2c4edbfbdb7..6011e6b7dcbd 100644
--- a/drivers/media/pci/cx23885/cx23885-cards.c
+++ b/drivers/media/pci/cx23885/cx23885-cards.c
@@ -15,6 +15,8 @@
  *  GNU General Public License for more details.
  */
 
+#include "cx23885.h"
+
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/pci.h>
@@ -23,7 +25,6 @@
 #include <linux/firmware.h>
 #include <misc/altera.h>
 
-#include "cx23885.h"
 #include "tuner-xc2028.h"
 #include "netup-eeprom.h"
 #include "netup-init.h"
@@ -1096,26 +1097,24 @@ void cx23885_card_list(struct cx23885_dev *dev)
 
 	if (0 == dev->pci->subsystem_vendor &&
 	    0 == dev->pci->subsystem_device) {
-		printk(KERN_INFO
-			"%s: Board has no valid PCIe Subsystem ID and can't\n"
-		       "%s: be autodetected. Pass card=<n> insmod option\n"
-		       "%s: to workaround that. Redirect complaints to the\n"
-		       "%s: vendor of the TV card.  Best regards,\n"
-		       "%s:         -- tux\n",
-		       dev->name, dev->name, dev->name, dev->name, dev->name);
+		pr_info("%s: Board has no valid PCIe Subsystem ID and can't\n"
+		        "%s: be autodetected. Pass card=<n> insmod option\n"
+		        "%s: to workaround that. Redirect complaints to the\n"
+		        "%s: vendor of the TV card.  Best regards,\n"
+		        "%s:         -- tux\n",
+		        dev->name, dev->name, dev->name, dev->name, dev->name);
 	} else {
-		printk(KERN_INFO
-			"%s: Your board isn't known (yet) to the driver.\n"
-		       "%s: Try to pick one of the existing card configs via\n"
-		       "%s: card=<n> insmod option.  Updating to the latest\n"
-		       "%s: version might help as well.\n",
-		       dev->name, dev->name, dev->name, dev->name);
+		pr_info("%s: Your board isn't known (yet) to the driver.\n"
+		        "%s: Try to pick one of the existing card configs via\n"
+		        "%s: card=<n> insmod option.  Updating to the latest\n"
+		        "%s: version might help as well.\n",
+		        dev->name, dev->name, dev->name, dev->name);
 	}
-	printk(KERN_INFO "%s: Here is a list of valid choices for the card=<n> insmod option:\n",
+	pr_info("%s: Here is a list of valid choices for the card=<n> insmod option:\n",
 	       dev->name);
 	for (i = 0; i < cx23885_bcount; i++)
-		printk(KERN_INFO "%s:    card=%d -> %s\n",
-		       dev->name, i, cx23885_boards[i].name);
+		pr_info("%s:    card=%d -> %s\n",
+			dev->name, i, cx23885_boards[i].name);
 }
 
 static void viewcast_eeprom(struct cx23885_dev *dev, u8 *eeprom_data)
@@ -1304,13 +1303,13 @@ static void hauppauge_eeprom(struct cx23885_dev *dev, u8 *eeprom_data)
 		 */
 		break;
 	default:
-		printk(KERN_WARNING "%s: warning: unknown hauppauge model #%d\n",
+		pr_warn("%s: warning: unknown hauppauge model #%d\n",
 			dev->name, tv.model);
 		break;
 	}
 
-	printk(KERN_INFO "%s: hauppauge eeprom: model=%d\n",
-			dev->name, tv.model);
+	pr_info("%s: hauppauge eeprom: model=%d\n",
+		dev->name, tv.model);
 }
 
 /* Some TBS cards require initing a chip using a bitbanged SPI attached
@@ -1352,8 +1351,8 @@ int cx23885_tuner_callback(void *priv, int component, int command, int arg)
 		return 0;
 
 	if (command != 0) {
-		printk(KERN_ERR "%s(): Unknown command 0x%x.\n",
-			__func__, command);
+		pr_err("%s(): Unknown command 0x%x.\n",
+		       __func__, command);
 		return -EINVAL;
 	}
 
@@ -2336,12 +2335,12 @@ void cx23885_card_setup(struct cx23885_dev *dev)
 			filename = "dvb-netup-altera-01.fw";
 			break;
 		}
-		printk(KERN_INFO "NetUP card rev=0x%x fw_filename=%s\n",
-				cinfo.rev, filename);
+		pr_info("NetUP card rev=0x%x fw_filename=%s\n",
+			cinfo.rev, filename);
 
 		ret = request_firmware(&fw, filename, &dev->pci->dev);
 		if (ret != 0)
-			printk(KERN_ERR "did not find the firmware file. (%s) Please see linux/Documentation/dvb/ for more details on firmware-problems.",
+			pr_err("did not find the firmware file. (%s) Please see linux/Documentation/dvb/ for more details on firmware-problems.",
 			       filename);
 		else
 			altera_init(&netup_config, fw);
diff --git a/drivers/media/pci/cx23885/cx23885-core.c b/drivers/media/pci/cx23885/cx23885-core.c
index 0d97da3be90b..02b5ec549369 100644
--- a/drivers/media/pci/cx23885/cx23885-core.c
+++ b/drivers/media/pci/cx23885/cx23885-core.c
@@ -15,6 +15,8 @@
  *  GNU General Public License for more details.
  */
 
+#include "cx23885.h"
+
 #include <linux/init.h>
 #include <linux/list.h>
 #include <linux/module.h>
@@ -27,7 +29,6 @@
 #include <asm/div64.h>
 #include <linux/firmware.h>
 
-#include "cx23885.h"
 #include "cimax2.h"
 #include "altera-ci.h"
 #include "cx23888-ir.h"
@@ -50,7 +51,8 @@ MODULE_PARM_DESC(card, "card type");
 
 #define dprintk(level, fmt, arg...)\
 	do { if (debug >= level)\
-		printk(KERN_DEBUG "%s: " fmt, dev->name, ## arg);\
+		printk(KERN_DEBUG pr_fmt("%s: " fmt), \
+		       __func__, ##arg); \
 	} while (0)
 
 static unsigned int cx23885_devcount;
@@ -411,15 +413,14 @@ static int cx23885_risc_decode(u32 risc)
 	       instr[risc >> 28] ? instr[risc >> 28] : "INVALID");
 	for (i = ARRAY_SIZE(bits) - 1; i >= 0; i--)
 		if (risc & (1 << (i + 12)))
-			printk(KERN_CONT " %s", bits[i]);
-	printk(KERN_CONT " count=%d ]\n", risc & 0xfff);
+			pr_cont(" %s", bits[i]);
+	pr_cont(" count=%d ]\n", risc & 0xfff);
 	return incr[risc >> 28] ? incr[risc >> 28] : 1;
 }
 
 static void cx23885_wakeup(struct cx23885_tsport *port,
 			   struct cx23885_dmaqueue *q, u32 count)
 {
-	struct cx23885_dev *dev = port->dev;
 	struct cx23885_buffer *buf;
 
 	if (list_empty(&q->active))
@@ -530,44 +531,44 @@ void cx23885_sram_channel_dump(struct cx23885_dev *dev,
 	u32 risc;
 	unsigned int i, j, n;
 
-	printk(KERN_WARNING "%s: %s - dma channel status dump\n",
-	       dev->name, ch->name);
+	pr_warn("%s: %s - dma channel status dump\n",
+		dev->name, ch->name);
 	for (i = 0; i < ARRAY_SIZE(name); i++)
-		printk(KERN_WARNING "%s:   cmds: %-15s: 0x%08x\n",
-		       dev->name, name[i],
-		       cx_read(ch->cmds_start + 4*i));
+		pr_warn("%s:   cmds: %-15s: 0x%08x\n",
+			dev->name, name[i],
+			cx_read(ch->cmds_start + 4*i));
 
 	for (i = 0; i < 4; i++) {
 		risc = cx_read(ch->cmds_start + 4 * (i + 14));
-		printk(KERN_WARNING "%s:   risc%d: ", dev->name, i);
+		pr_warn("%s:   risc%d: ", dev->name, i);
 		cx23885_risc_decode(risc);
 	}
 	for (i = 0; i < (64 >> 2); i += n) {
 		risc = cx_read(ch->ctrl_start + 4 * i);
 		/* No consideration for bits 63-32 */
 
-		printk(KERN_WARNING "%s:   (0x%08x) iq %x: ", dev->name,
-		       ch->ctrl_start + 4 * i, i);
+		pr_warn("%s:   (0x%08x) iq %x: ", dev->name,
+			ch->ctrl_start + 4 * i, i);
 		n = cx23885_risc_decode(risc);
 		for (j = 1; j < n; j++) {
 			risc = cx_read(ch->ctrl_start + 4 * (i + j));
-			printk(KERN_WARNING "%s:   iq %x: 0x%08x [ arg #%d ]\n",
-			       dev->name, i+j, risc, j);
+			pr_warn("%s:   iq %x: 0x%08x [ arg #%d ]\n",
+				dev->name, i+j, risc, j);
 		}
 	}
 
-	printk(KERN_WARNING "%s: fifo: 0x%08x -> 0x%x\n",
-	       dev->name, ch->fifo_start, ch->fifo_start+ch->fifo_size);
-	printk(KERN_WARNING "%s: ctrl: 0x%08x -> 0x%x\n",
-	       dev->name, ch->ctrl_start, ch->ctrl_start + 6*16);
-	printk(KERN_WARNING "%s:   ptr1_reg: 0x%08x\n",
-	       dev->name, cx_read(ch->ptr1_reg));
-	printk(KERN_WARNING "%s:   ptr2_reg: 0x%08x\n",
-	       dev->name, cx_read(ch->ptr2_reg));
-	printk(KERN_WARNING "%s:   cnt1_reg: 0x%08x\n",
-	       dev->name, cx_read(ch->cnt1_reg));
-	printk(KERN_WARNING "%s:   cnt2_reg: 0x%08x\n",
-	       dev->name, cx_read(ch->cnt2_reg));
+	pr_warn("%s: fifo: 0x%08x -> 0x%x\n",
+		dev->name, ch->fifo_start, ch->fifo_start+ch->fifo_size);
+	pr_warn("%s: ctrl: 0x%08x -> 0x%x\n",
+		dev->name, ch->ctrl_start, ch->ctrl_start + 6*16);
+	pr_warn("%s:   ptr1_reg: 0x%08x\n",
+		dev->name, cx_read(ch->ptr1_reg));
+	pr_warn("%s:   ptr2_reg: 0x%08x\n",
+		dev->name, cx_read(ch->ptr2_reg));
+	pr_warn("%s:   cnt1_reg: 0x%08x\n",
+		dev->name, cx_read(ch->cnt1_reg));
+	pr_warn("%s:   cnt2_reg: 0x%08x\n",
+		dev->name, cx_read(ch->cnt2_reg));
 }
 
 static void cx23885_risc_disasm(struct cx23885_tsport *port,
@@ -576,14 +577,14 @@ static void cx23885_risc_disasm(struct cx23885_tsport *port,
 	struct cx23885_dev *dev = port->dev;
 	unsigned int i, j, n;
 
-	printk(KERN_INFO "%s: risc disasm: %p [dma=0x%08lx]\n",
+	pr_info("%s: risc disasm: %p [dma=0x%08lx]\n",
 	       dev->name, risc->cpu, (unsigned long)risc->dma);
 	for (i = 0; i < (risc->size >> 2); i += n) {
-		printk(KERN_INFO "%s:   %04d: ", dev->name, i);
+		pr_info("%s:   %04d: ", dev->name, i);
 		n = cx23885_risc_decode(le32_to_cpu(risc->cpu[i]));
 		for (j = 1; j < n; j++)
-			printk(KERN_INFO "%s:   %04d: 0x%08x [ arg #%d ]\n",
-			       dev->name, i + j, risc->cpu[i + j], j);
+			pr_info("%s:   %04d: 0x%08x [ arg #%d ]\n",
+				dev->name, i + j, risc->cpu[i + j], j);
 		if (risc->cpu[i] == cpu_to_le32(RISC_JUMP))
 			break;
 	}
@@ -674,8 +675,8 @@ static int get_resources(struct cx23885_dev *dev)
 			       dev->name))
 		return 0;
 
-	printk(KERN_ERR "%s: can't get MMIO memory @ 0x%llx\n",
-		dev->name, (unsigned long long)pci_resource_start(dev->pci, 0));
+	pr_err("%s: can't get MMIO memory @ 0x%llx\n",
+	       dev->name, (unsigned long long)pci_resource_start(dev->pci, 0));
 
 	return -EBUSY;
 }
@@ -793,15 +794,15 @@ static void cx23885_dev_checkrevision(struct cx23885_dev *dev)
 		dev->hwrevision = 0xb1;
 		break;
 	default:
-		printk(KERN_ERR "%s() New hardware revision found 0x%x\n",
-			__func__, dev->hwrevision);
+		pr_err("%s() New hardware revision found 0x%x\n",
+		       __func__, dev->hwrevision);
 	}
 	if (dev->hwrevision)
-		printk(KERN_INFO "%s() Hardware revision = 0x%02x\n",
+		pr_info("%s() Hardware revision = 0x%02x\n",
 			__func__, dev->hwrevision);
 	else
-		printk(KERN_ERR "%s() Hardware revision unknown 0x%x\n",
-			__func__, dev->hwrevision);
+		pr_err("%s() Hardware revision unknown 0x%x\n",
+		       __func__, dev->hwrevision);
 }
 
 /* Find the first v4l2_subdev member of the group id in hw */
@@ -915,7 +916,7 @@ static int cx23885_dev_setup(struct cx23885_dev *dev)
 		cx23885_init_tsport(dev, &dev->ts2, 2);
 
 	if (get_resources(dev) < 0) {
-		printk(KERN_ERR "CORE %s No more PCIe resources for subsystem: %04x:%04x\n",
+		pr_err("CORE %s No more PCIe resources for subsystem: %04x:%04x\n",
 		       dev->name, dev->pci->subsystem_vendor,
 		       dev->pci->subsystem_device);
 
@@ -929,11 +930,11 @@ static int cx23885_dev_setup(struct cx23885_dev *dev)
 
 	dev->bmmio = (u8 __iomem *)dev->lmmio;
 
-	printk(KERN_INFO "CORE %s: subsystem: %04x:%04x, board: %s [card=%d,%s]\n",
-	       dev->name, dev->pci->subsystem_vendor,
-	       dev->pci->subsystem_device, cx23885_boards[dev->board].name,
-	       dev->board, card[dev->nr] == dev->board ?
-	       "insmod option" : "autodetected");
+	pr_info("CORE %s: subsystem: %04x:%04x, board: %s [card=%d,%s]\n",
+		dev->name, dev->pci->subsystem_vendor,
+		dev->pci->subsystem_device, cx23885_boards[dev->board].name,
+		dev->board, card[dev->nr] == dev->board ?
+		"insmod option" : "autodetected");
 
 	cx23885_pci_quirks(dev);
 
@@ -979,7 +980,7 @@ static int cx23885_dev_setup(struct cx23885_dev *dev)
 
 	if (cx23885_boards[dev->board].porta == CX23885_ANALOG_VIDEO) {
 		if (cx23885_video_register(dev) < 0) {
-			printk(KERN_ERR "%s() Failed to register analog video adapters on VID_A\n",
+			pr_err("%s() Failed to register analog video adapters on VID_A\n",
 			       __func__);
 		}
 	}
@@ -989,14 +990,13 @@ static int cx23885_dev_setup(struct cx23885_dev *dev)
 			dev->ts1.num_frontends =
 				cx23885_boards[dev->board].num_fds_portb;
 		if (cx23885_dvb_register(&dev->ts1) < 0) {
-			printk(KERN_ERR "%s() Failed to register dvb adapters on VID_B\n",
+			pr_err("%s() Failed to register dvb adapters on VID_B\n",
 			       __func__);
 		}
 	} else
 	if (cx23885_boards[dev->board].portb == CX23885_MPEG_ENCODER) {
 		if (cx23885_417_register(dev) < 0) {
-			printk(KERN_ERR
-				"%s() Failed to register 417 on VID_B\n",
+			pr_err("%s() Failed to register 417 on VID_B\n",
 			       __func__);
 		}
 	}
@@ -1006,15 +1006,13 @@ static int cx23885_dev_setup(struct cx23885_dev *dev)
 			dev->ts2.num_frontends =
 				cx23885_boards[dev->board].num_fds_portc;
 		if (cx23885_dvb_register(&dev->ts2) < 0) {
-			printk(KERN_ERR
-				"%s() Failed to register dvb on VID_C\n",
+			pr_err("%s() Failed to register dvb on VID_C\n",
 			       __func__);
 		}
 	} else
 	if (cx23885_boards[dev->board].portc == CX23885_MPEG_ENCODER) {
 		if (cx23885_417_register(dev) < 0) {
-			printk(KERN_ERR
-				"%s() Failed to register 417 on VID_C\n",
+			pr_err("%s() Failed to register 417 on VID_C\n",
 			       __func__);
 		}
 	}
@@ -1343,7 +1341,7 @@ int cx23885_start_dma(struct cx23885_tsport *port,
 
 	if ((!(cx23885_boards[dev->board].portb & CX23885_MPEG_DVB)) &&
 		(!(cx23885_boards[dev->board].portc & CX23885_MPEG_DVB))) {
-		printk("%s() Unsupported .portb/c (0x%08x)/(0x%08x)\n",
+		pr_err("%s() Unsupported .portb/c (0x%08x)/(0x%08x)\n",
 			__func__,
 			cx23885_boards[dev->board].portb,
 			cx23885_boards[dev->board].portc);
@@ -1530,7 +1528,6 @@ void cx23885_buf_queue(struct cx23885_tsport *port, struct cx23885_buffer *buf)
 
 static void do_cancel_buffers(struct cx23885_tsport *port, char *reason)
 {
-	struct cx23885_dev *dev = port->dev;
 	struct cx23885_dmaqueue *q = &port->mpegq;
 	struct cx23885_buffer *buf;
 	unsigned long flags;
@@ -1550,8 +1547,6 @@ static void do_cancel_buffers(struct cx23885_tsport *port, char *reason)
 
 void cx23885_cancel_buffers(struct cx23885_tsport *port)
 {
-	struct cx23885_dev *dev = port->dev;
-
 	dprintk(1, "%s()\n", __func__);
 	cx23885_stop_dma(port);
 	do_cancel_buffers(port, "cancel");
@@ -1578,7 +1573,7 @@ int cx23885_irq_417(struct cx23885_dev *dev, u32 status)
 		(status & VID_B_MSK_VBI_SYNC)    ||
 		(status & VID_B_MSK_OF)          ||
 		(status & VID_B_MSK_VBI_OF)) {
-		printk(KERN_ERR "%s: V4L mpeg risc op code error, status = 0x%x\n",
+		pr_err("%s: V4L mpeg risc op code error, status = 0x%x\n",
 		       dev->name, status);
 		if (status & VID_B_MSK_BAD_PKT)
 			dprintk(1, "        VID_B_MSK_BAD_PKT\n");
@@ -1640,7 +1635,7 @@ static int cx23885_irq_ts(struct cx23885_tsport *port, u32 status)
 			dprintk(7, " (VID_BC_MSK_OF      0x%08x)\n",
 				VID_BC_MSK_OF);
 
-		printk(KERN_ERR "%s: mpeg risc op code error\n", dev->name);
+		pr_err("%s: mpeg risc op code error\n", dev->name);
 
 		cx_clear(port->reg_dma_ctl, port->dma_ctl_val);
 		cx23885_sram_channel_dump(dev,
@@ -1880,15 +1875,14 @@ void cx23885_gpio_set(struct cx23885_dev *dev, u32 mask)
 
 	if (mask & 0x0007fff8) {
 		if (encoder_on_portb(dev) || encoder_on_portc(dev))
-			printk(KERN_ERR
-				"%s: Setting GPIO on encoder ports\n",
+			pr_err("%s: Setting GPIO on encoder ports\n",
 				dev->name);
 		cx_set(MC417_RWD, (mask & 0x0007fff8) >> 3);
 	}
 
 	/* TODO: 23-19 */
 	if (mask & 0x00f80000)
-		printk(KERN_INFO "%s: Unsupported\n", dev->name);
+		pr_info("%s: Unsupported\n", dev->name);
 }
 
 void cx23885_gpio_clear(struct cx23885_dev *dev, u32 mask)
@@ -1898,15 +1892,14 @@ void cx23885_gpio_clear(struct cx23885_dev *dev, u32 mask)
 
 	if (mask & 0x0007fff8) {
 		if (encoder_on_portb(dev) || encoder_on_portc(dev))
-			printk(KERN_ERR
-				"%s: Clearing GPIO moving on encoder ports\n",
+			pr_err("%s: Clearing GPIO moving on encoder ports\n",
 				dev->name);
 		cx_clear(MC417_RWD, (mask & 0x7fff8) >> 3);
 	}
 
 	/* TODO: 23-19 */
 	if (mask & 0x00f80000)
-		printk(KERN_INFO "%s: Unsupported\n", dev->name);
+		pr_info("%s: Unsupported\n", dev->name);
 }
 
 u32 cx23885_gpio_get(struct cx23885_dev *dev, u32 mask)
@@ -1916,15 +1909,14 @@ u32 cx23885_gpio_get(struct cx23885_dev *dev, u32 mask)
 
 	if (mask & 0x0007fff8) {
 		if (encoder_on_portb(dev) || encoder_on_portc(dev))
-			printk(KERN_ERR
-				"%s: Reading GPIO moving on encoder ports\n",
+			pr_err("%s: Reading GPIO moving on encoder ports\n",
 				dev->name);
 		return (cx_read(MC417_RWD) & ((mask & 0x7fff8) >> 3)) << 3;
 	}
 
 	/* TODO: 23-19 */
 	if (mask & 0x00f80000)
-		printk(KERN_INFO "%s: Unsupported\n", dev->name);
+		pr_info("%s: Unsupported\n", dev->name);
 
 	return 0;
 }
@@ -1938,8 +1930,7 @@ void cx23885_gpio_enable(struct cx23885_dev *dev, u32 mask, int asoutput)
 
 	if (mask & 0x0007fff8) {
 		if (encoder_on_portb(dev) || encoder_on_portc(dev))
-			printk(KERN_ERR
-				"%s: Enabling GPIO on encoder ports\n",
+			pr_err("%s: Enabling GPIO on encoder ports\n",
 				dev->name);
 	}
 
@@ -1994,7 +1985,7 @@ static int cx23885_initdev(struct pci_dev *pci_dev,
 	/* print pci info */
 	dev->pci_rev = pci_dev->revision;
 	pci_read_config_byte(pci_dev, PCI_LATENCY_TIMER,  &dev->pci_lat);
-	printk(KERN_INFO "%s/0: found at %s, rev: %d, irq: %d, latency: %d, mmio: 0x%llx\n",
+	pr_info("%s/0: found at %s, rev: %d, irq: %d, latency: %d, mmio: 0x%llx\n",
 	       dev->name,
 	       pci_name(pci_dev), dev->pci_rev, pci_dev->irq,
 	       dev->pci_lat,
@@ -2003,14 +1994,14 @@ static int cx23885_initdev(struct pci_dev *pci_dev,
 	pci_set_master(pci_dev);
 	err = pci_set_dma_mask(pci_dev, 0xffffffff);
 	if (err) {
-		printk(KERN_ERR "%s/0: Oops: no 32bit PCI DMA ???\n", dev->name);
+		pr_err("%s/0: Oops: no 32bit PCI DMA ???\n", dev->name);
 		goto fail_ctrl;
 	}
 
 	err = request_irq(pci_dev->irq, cx23885_irq,
 			  IRQF_SHARED, dev->name, dev);
 	if (err < 0) {
-		printk(KERN_ERR "%s: can't get IRQ %d\n",
+		pr_err("%s: can't get IRQ %d\n",
 		       dev->name, pci_dev->irq);
 		goto fail_irq;
 	}
@@ -2096,7 +2087,7 @@ static struct pci_driver cx23885_pci_driver = {
 
 static int __init cx23885_init(void)
 {
-	printk(KERN_INFO "cx23885 driver version %s loaded\n",
+	pr_info("cx23885 driver version %s loaded\n",
 		CX23885_VERSION);
 	return pci_register_driver(&cx23885_pci_driver);
 }
diff --git a/drivers/media/pci/cx23885/cx23885-dvb.c b/drivers/media/pci/cx23885/cx23885-dvb.c
index 42413fa423b4..589a168d1df4 100644
--- a/drivers/media/pci/cx23885/cx23885-dvb.c
+++ b/drivers/media/pci/cx23885/cx23885-dvb.c
@@ -15,6 +15,8 @@
  *  GNU General Public License for more details.
  */
 
+#include "cx23885.h"
+
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/device.h>
@@ -23,7 +25,6 @@
 #include <linux/file.h>
 #include <linux/suspend.h>
 
-#include "cx23885.h"
 #include <media/v4l2-common.h>
 
 #include "dvb_ca_en50221.h"
@@ -80,7 +81,8 @@ static unsigned int debug;
 
 #define dprintk(level, fmt, arg...)\
 	do { if (debug >= level)\
-		printk(KERN_DEBUG "%s/0: " fmt, dev->name, ## arg);\
+		printk(KERN_DEBUG pr_fmt("%s dvb: " fmt), \
+			__func__, ##arg); \
 	} while (0)
 
 /* ------------------------------------------------------------------ */
@@ -1101,7 +1103,7 @@ static int dvb_register_ci_mac(struct cx23885_tsport *port)
 		netup_get_card_info(&dev->i2c_bus[0].i2c_adap, &cinfo);
 		memcpy(port->frontends.adapter.proposed_mac,
 				cinfo.port[port->nr - 1].mac, 6);
-		printk(KERN_INFO "NetUP Dual DVB-S2 CI card port%d MAC=%pM\n",
+		pr_info("NetUP Dual DVB-S2 CI card port%d MAC=%pM\n",
 			port->nr, port->frontends.adapter.proposed_mac);
 
 		netup_ci_init(port);
@@ -1127,7 +1129,7 @@ static int dvb_register_ci_mac(struct cx23885_tsport *port)
 		/* Read entire EEPROM */
 		dev->i2c_bus[0].i2c_client.addr = 0xa0 >> 1;
 		tveeprom_read(&dev->i2c_bus[0].i2c_client, eeprom, sizeof(eeprom));
-		printk(KERN_INFO "TeVii S470 MAC= %pM\n", eeprom + 0xa0);
+		pr_info("TeVii S470 MAC= %pM\n", eeprom + 0xa0);
 		memcpy(port->frontends.adapter.proposed_mac, eeprom + 0xa0, 6);
 		return 0;
 		}
@@ -1144,7 +1146,7 @@ static int dvb_register_ci_mac(struct cx23885_tsport *port)
 		dev->i2c_bus[0].i2c_client.addr = 0xa0 >> 1;
 		tveeprom_read(&dev->i2c_bus[0].i2c_client, eeprom,
 				sizeof(eeprom));
-		printk(KERN_INFO "%s port %d MAC address: %pM\n",
+		pr_info("%s port %d MAC address: %pM\n",
 			cx23885_boards[dev->board].name, port->nr,
 			eeprom + 0xc0 + (port->nr-1) * 8);
 		memcpy(port->frontends.adapter.proposed_mac, eeprom + 0xc0 +
@@ -1185,7 +1187,7 @@ static int dvb_register_ci_mac(struct cx23885_tsport *port)
 		dev->i2c_bus[0].i2c_client.addr = 0xa0 >> 1;
 		tveeprom_read(&dev->i2c_bus[0].i2c_client, eeprom,
 				sizeof(eeprom));
-		printk(KERN_INFO "%s MAC address: %pM\n",
+		pr_info("%s MAC address: %pM\n",
 			cx23885_boards[dev->board].name, eeprom + 0xc0);
 		memcpy(port->frontends.adapter.proposed_mac, eeprom + 0xc0, 6);
 		return 0;
@@ -1464,7 +1466,7 @@ static int dvb_register(struct cx23885_tsport *port)
 			return -ENODEV;
 
 		if (dib7000p_ops.i2c_enumeration(&i2c_bus->i2c_adap, 1, 0x12, &dib7070p_dib7000p_config) < 0) {
-			printk(KERN_WARNING "Unable to enumerate dib7000p\n");
+			pr_warn("Unable to enumerate dib7000p\n");
 			return -ENODEV;
 		}
 		fe0->dvb.frontend = dib7000p_ops.init(&i2c_bus->i2c_adap, 0x80, &dib7070p_dib7000p_config);
@@ -1524,7 +1526,7 @@ static int dvb_register(struct cx23885_tsport *port)
 			fe = dvb_attach(xc4000_attach, fe0->dvb.frontend,
 					&dev->i2c_bus[1].i2c_adap, &cfg);
 			if (!fe) {
-				printk(KERN_ERR "%s/2: xc4000 attach failed\n",
+				pr_err("%s/2: xc4000 attach failed\n",
 				       dev->name);
 				goto frontend_detach;
 			}
@@ -1597,8 +1599,7 @@ static int dvb_register(struct cx23885_tsport *port)
 							&i2c_bus->i2c_adap,
 							LNBH24_PCL | LNBH24_TTX,
 							LNBH24_TEN, 0x09))
-						printk(KERN_ERR
-							"No LNBH24 found!\n");
+						pr_err("No LNBH24 found!\n");
 
 				}
 			}
@@ -1618,8 +1619,7 @@ static int dvb_register(struct cx23885_tsport *port)
 							&i2c_bus->i2c_adap,
 							LNBH24_PCL | LNBH24_TTX,
 							LNBH24_TEN, 0x0a))
-						printk(KERN_ERR
-							"No LNBH24 found!\n");
+						pr_err("No LNBH24 found!\n");
 
 				}
 			}
@@ -2482,13 +2482,13 @@ static int dvb_register(struct cx23885_tsport *port)
 		break;
 
 	default:
-		printk(KERN_INFO "%s: The frontend of your DVB/ATSC card  isn't supported yet\n",
-		       dev->name);
+		pr_info("%s: The frontend of your DVB/ATSC card  isn't supported yet\n",
+			dev->name);
 		break;
 	}
 
 	if ((NULL == fe0->dvb.frontend) || (fe1 && NULL == fe1->dvb.frontend)) {
-		printk(KERN_ERR "%s: frontend initialization failed\n",
+		pr_err("%s: frontend initialization failed\n",
 		       dev->name);
 		goto frontend_detach;
 	}
@@ -2569,7 +2569,7 @@ int cx23885_dvb_register(struct cx23885_tsport *port)
 	 * are for safety, and should provide a good foundation for the
 	 * future addition of any multi-frontend cx23885 based boards.
 	 */
-	printk(KERN_INFO "%s() allocating %d frontend(s)\n", __func__,
+	pr_info("%s() allocating %d frontend(s)\n", __func__,
 		port->num_frontends);
 
 	for (i = 1; i <= port->num_frontends; i++) {
@@ -2577,7 +2577,7 @@ int cx23885_dvb_register(struct cx23885_tsport *port)
 
 		if (vb2_dvb_alloc_frontend(
 			&port->frontends, i) == NULL) {
-			printk(KERN_ERR "%s() failed to alloc\n", __func__);
+			pr_err("%s() failed to alloc\n", __func__);
 			return -ENOMEM;
 		}
 
@@ -2596,7 +2596,7 @@ int cx23885_dvb_register(struct cx23885_tsport *port)
 
 		/* dvb stuff */
 		/* We have to init the queue for each frontend on a port. */
-		printk(KERN_INFO "%s: cx23885 based dvb card\n", dev->name);
+		pr_info("%s: cx23885 based dvb card\n", dev->name);
 		q = &fe0->dvb.dvbq;
 		q->type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
 		q->io_modes = VB2_MMAP | VB2_USERPTR | VB2_DMABUF | VB2_READ;
@@ -2616,8 +2616,8 @@ int cx23885_dvb_register(struct cx23885_tsport *port)
 	}
 	err = dvb_register(port);
 	if (err != 0)
-		printk(KERN_ERR "%s() dvb_register failed err = %d\n",
-			__func__, err);
+		pr_err("%s() dvb_register failed err = %d\n",
+		       __func__, err);
 
 	return err;
 }
diff --git a/drivers/media/pci/cx23885/cx23885-f300.c b/drivers/media/pci/cx23885/cx23885-f300.c
index a6c45eb0a105..460cb8f314b2 100644
--- a/drivers/media/pci/cx23885/cx23885-f300.c
+++ b/drivers/media/pci/cx23885/cx23885-f300.c
@@ -122,7 +122,7 @@ static u8 f300_xfer(struct dvb_frontend *fe, u8 *buf)
 	}
 
 	if (i > 7) {
-		printk(KERN_ERR "%s: timeout, the slave no response\n",
+		pr_err("%s: timeout, the slave no response\n",
 								__func__);
 		ret = 1; /* timeout, the slave no response */
 	} else { /* the slave not busy, prepare for getting data */
diff --git a/drivers/media/pci/cx23885/cx23885-i2c.c b/drivers/media/pci/cx23885/cx23885-i2c.c
index 19faf9a611ed..8528032090f2 100644
--- a/drivers/media/pci/cx23885/cx23885-i2c.c
+++ b/drivers/media/pci/cx23885/cx23885-i2c.c
@@ -15,14 +15,14 @@
  *  GNU General Public License for more details.
  */
 
+#include "cx23885.h"
+
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/init.h>
 #include <linux/delay.h>
 #include <asm/io.h>
 
-#include "cx23885.h"
-
 #include <media/v4l2-common.h>
 
 static unsigned int i2c_debug;
@@ -35,7 +35,8 @@ MODULE_PARM_DESC(i2c_scan, "scan i2c bus at insmod time");
 
 #define dprintk(level, fmt, arg...)\
 	do { if (i2c_debug >= level)\
-		printk(KERN_DEBUG "%s/0: " fmt, dev->name, ## arg);\
+		printk(KERN_DEBUG pr_fmt("%s: i2c:" fmt), \
+			__func__, ##arg); \
 	} while (0)
 
 #define I2C_WAIT_DELAY 32
@@ -121,7 +122,7 @@ static int i2c_sendbytes(struct i2c_adapter *i2c_adap,
 	if (i2c_debug) {
 		printk(KERN_DEBUG " <W %02x %02x", msg->addr << 1, msg->buf[0]);
 		if (!(ctrl & I2C_NOSTOP))
-			printk(KERN_CONT " >\n");
+			pr_cont(" >\n");
 	}
 
 	for (cnt = 1; cnt < msg->len; cnt++) {
@@ -141,9 +142,9 @@ static int i2c_sendbytes(struct i2c_adapter *i2c_adap,
 		if (!i2c_wait_done(i2c_adap))
 			goto eio;
 		if (i2c_debug) {
-			printk(KERN_CONT " %02x", msg->buf[cnt]);
+			pr_cont(" %02x", msg->buf[cnt]);
 			if (!(ctrl & I2C_NOSTOP))
-				printk(KERN_CONT " >\n");
+				pr_cont(" >\n");
 		}
 	}
 	return msg->len;
@@ -151,7 +152,7 @@ static int i2c_sendbytes(struct i2c_adapter *i2c_adap,
  eio:
 	retval = -EIO;
 	if (i2c_debug)
-		printk(KERN_ERR " ERR: %d\n", retval);
+		pr_err(" ERR: %d\n", retval);
 	return retval;
 }
 
@@ -212,15 +213,13 @@ static int i2c_readbytes(struct i2c_adapter *i2c_adap,
  eio:
 	retval = -EIO;
 	if (i2c_debug)
-		printk(KERN_ERR " ERR: %d\n", retval);
+		pr_err(" ERR: %d\n", retval);
 	return retval;
 }
 
 static int i2c_xfer(struct i2c_adapter *i2c_adap,
 		    struct i2c_msg *msgs, int num)
 {
-	struct cx23885_i2c *bus = i2c_adap->algo_data;
-	struct cx23885_dev *dev = bus->dev;
 	int i, retval = 0;
 
 	dprintk(1, "%s(num = %d)\n", __func__, num);
@@ -302,7 +301,7 @@ static void do_i2c_scan(char *name, struct i2c_client *c)
 		rc = i2c_master_recv(c, &buf, 0);
 		if (rc < 0)
 			continue;
-		printk(KERN_INFO "%s: i2c scan: found device @ 0x%04x  [%s]\n",
+		pr_info("%s: i2c scan: found device @ 0x%04x  [%s]\n",
 		       name, i, i2c_devs[i] ? i2c_devs[i] : "???");
 	}
 }
@@ -330,12 +329,12 @@ int cx23885_i2c_register(struct cx23885_i2c *bus)
 	if (0 == bus->i2c_rc) {
 		dprintk(1, "%s: i2c bus %d registered\n", dev->name, bus->nr);
 		if (i2c_scan) {
-			printk(KERN_INFO "%s: scan bus %d:\n",
+			pr_info("%s: scan bus %d:\n",
 					dev->name, bus->nr);
 			do_i2c_scan(dev->name, &bus->i2c_client);
 		}
 	} else
-		printk(KERN_WARNING "%s: i2c bus %d register FAILED\n",
+		pr_warn("%s: i2c bus %d register FAILED\n",
 			dev->name, bus->nr);
 
 	/* Instantiate the IR receiver device, if present */
diff --git a/drivers/media/pci/cx23885/cx23885-input.c b/drivers/media/pci/cx23885/cx23885-input.c
index 410c3141c163..1f092febdbd1 100644
--- a/drivers/media/pci/cx23885/cx23885-input.c
+++ b/drivers/media/pci/cx23885/cx23885-input.c
@@ -30,13 +30,13 @@
  *  GNU General Public License for more details.
  */
 
+#include "cx23885.h"
+#include "cx23885-input.h"
+
 #include <linux/slab.h>
 #include <media/rc-core.h>
 #include <media/v4l2-subdev.h>
 
-#include "cx23885.h"
-#include "cx23885-input.h"
-
 #define MODULE_NAME "cx23885"
 
 static void cx23885_input_process_measurements(struct cx23885_dev *dev,
diff --git a/drivers/media/pci/cx23885/cx23885-ir.c b/drivers/media/pci/cx23885/cx23885-ir.c
index 89dc4cc3e1ce..2cd5ac41ab75 100644
--- a/drivers/media/pci/cx23885/cx23885-ir.c
+++ b/drivers/media/pci/cx23885/cx23885-ir.c
@@ -16,12 +16,12 @@
  *  GNU General Public License for more details.
  */
 
-#include <media/v4l2-device.h>
-
 #include "cx23885.h"
 #include "cx23885-ir.h"
 #include "cx23885-input.h"
 
+#include <media/v4l2-device.h>
+
 #define CX23885_IR_RX_FIFO_SERVICE_REQ		0
 #define CX23885_IR_RX_END_OF_RX_DETECTED	1
 #define CX23885_IR_RX_HW_FIFO_OVERRUN		2
diff --git a/drivers/media/pci/cx23885/cx23885-vbi.c b/drivers/media/pci/cx23885/cx23885-vbi.c
index 75e7fa7b1121..369e545cac04 100644
--- a/drivers/media/pci/cx23885/cx23885-vbi.c
+++ b/drivers/media/pci/cx23885/cx23885-vbi.c
@@ -15,13 +15,13 @@
  *  GNU General Public License for more details.
  */
 
+#include "cx23885.h"
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/init.h>
 
-#include "cx23885.h"
-
 static unsigned int vbibufs = 4;
 module_param(vbibufs, int, 0644);
 MODULE_PARM_DESC(vbibufs, "number of vbi buffers, range 2-32");
@@ -32,7 +32,8 @@ MODULE_PARM_DESC(vbi_debug, "enable debug messages [vbi]");
 
 #define dprintk(level, fmt, arg...)\
 	do { if (vbi_debug >= level)\
-		printk(KERN_DEBUG "%s/0: " fmt, dev->name, ## arg);\
+		printk(KERN_DEBUG pr_fmt("%s: vbi:" fmt), \
+			__func__, ##arg); \
 	} while (0)
 
 /* ------------------------------------------------------------------ */
diff --git a/drivers/media/pci/cx23885/cx23885-video.c b/drivers/media/pci/cx23885/cx23885-video.c
index 92ff452e5886..ecc580af0148 100644
--- a/drivers/media/pci/cx23885/cx23885-video.c
+++ b/drivers/media/pci/cx23885/cx23885-video.c
@@ -15,6 +15,9 @@
  *  GNU General Public License for more details.
  */
 
+#include "cx23885.h"
+#include "cx23885-video.h"
+
 #include <linux/init.h>
 #include <linux/list.h>
 #include <linux/module.h>
@@ -27,8 +30,6 @@
 #include <linux/kthread.h>
 #include <asm/div64.h>
 
-#include "cx23885.h"
-#include "cx23885-video.h"
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-event.h>
@@ -66,7 +67,8 @@ MODULE_PARM_DESC(vid_limit, "capture memory limit in megabytes");
 
 #define dprintk(level, fmt, arg...)\
 	do { if (video_debug >= level)\
-		printk(KERN_DEBUG "%s: " fmt, dev->name, ## arg);\
+		printk(KERN_DEBUG pr_fmt("%s: video:" fmt), \
+			__func__, ##arg); \
 	} while (0)
 
 /* ------------------------------------------------------------------- */
@@ -194,7 +196,7 @@ u8 cx23885_flatiron_read(struct cx23885_dev *dev, u8 reg)
 
 	ret = i2c_transfer(&dev->i2c_bus[2].i2c_adap, &msg[0], 2);
 	if (ret != 2)
-		printk(KERN_ERR "%s() error\n", __func__);
+		pr_err("%s() error\n", __func__);
 
 	return b1[0];
 }
@@ -811,7 +813,6 @@ static int vidioc_log_status(struct file *file, void *priv)
 static int cx23885_query_audinput(struct file *file, void *priv,
 	struct v4l2_audio *i)
 {
-	struct cx23885_dev *dev = video_drvdata(file);
 	static const char *iname[] = {
 		[0] = "Baseband L/R 1",
 		[1] = "Baseband L/R 2",
@@ -1000,7 +1001,7 @@ static int cx23885_set_freq_via_ops(struct cx23885_dev *dev,
 		fe->ops.tuner_ops.set_analog_params(fe, &params);
 	}
 	else
-		printk(KERN_ERR "%s() No analog tuner, aborting\n", __func__);
+		pr_err("%s() No analog tuner, aborting\n", __func__);
 
 	/* When changing channels it is required to reset TVAUDIO */
 	msleep(100);
@@ -1058,7 +1059,7 @@ int cx23885_video_irq(struct cx23885_dev *dev, u32 status)
 		if (status & VID_BC_MSK_OPC_ERR) {
 			dprintk(7, " (VID_BC_MSK_OPC_ERR 0x%08x)\n",
 				VID_BC_MSK_OPC_ERR);
-			printk(KERN_WARNING "%s: video risc op code error\n",
+			pr_warn("%s: video risc op code error\n",
 				dev->name);
 			cx23885_sram_channel_dump(dev,
 				&dev->sram_channels[SRAM_CH01]);
@@ -1296,11 +1297,11 @@ int cx23885_video_register(struct cx23885_dev *dev)
 	err = video_register_device(dev->video_dev, VFL_TYPE_GRABBER,
 				    video_nr[dev->nr]);
 	if (err < 0) {
-		printk(KERN_INFO "%s: can't register video device\n",
+		pr_info("%s: can't register video device\n",
 			dev->name);
 		goto fail_unreg;
 	}
-	printk(KERN_INFO "%s: registered device %s [v4l2]\n",
+	pr_info("%s: registered device %s [v4l2]\n",
 	       dev->name, video_device_node_name(dev->video_dev));
 
 	/* register VBI device */
@@ -1310,11 +1311,11 @@ int cx23885_video_register(struct cx23885_dev *dev)
 	err = video_register_device(dev->vbi_dev, VFL_TYPE_VBI,
 				    vbi_nr[dev->nr]);
 	if (err < 0) {
-		printk(KERN_INFO "%s: can't register vbi device\n",
+		pr_info("%s: can't register vbi device\n",
 			dev->name);
 		goto fail_unreg;
 	}
-	printk(KERN_INFO "%s: registered device %s\n",
+	pr_info("%s: registered device %s\n",
 	       dev->name, video_device_node_name(dev->vbi_dev));
 
 	/* Register ALSA audio device */
diff --git a/drivers/media/pci/cx23885/cx23885.h b/drivers/media/pci/cx23885/cx23885.h
index a6735afe2269..cb714ab60d69 100644
--- a/drivers/media/pci/cx23885/cx23885.h
+++ b/drivers/media/pci/cx23885/cx23885.h
@@ -15,6 +15,8 @@
  *  GNU General Public License for more details.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/pci.h>
 #include <linux/i2c.h>
 #include <linux/kdev_t.h>
diff --git a/drivers/media/pci/cx23885/cx23888-ir.c b/drivers/media/pci/cx23885/cx23888-ir.c
index 3115cfddab95..040323b0f945 100644
--- a/drivers/media/pci/cx23885/cx23888-ir.c
+++ b/drivers/media/pci/cx23885/cx23888-ir.c
@@ -16,15 +16,15 @@
  *  GNU General Public License for more details.
  */
 
+#include "cx23885.h"
+#include "cx23888-ir.h"
+
 #include <linux/kfifo.h>
 #include <linux/slab.h>
 
 #include <media/v4l2-device.h>
 #include <media/rc-core.h>
 
-#include "cx23885.h"
-#include "cx23888-ir.h"
-
 static unsigned int ir_888_debug;
 module_param(ir_888_debug, int, 0644);
 MODULE_PARM_DESC(ir_888_debug, "enable debug messages [CX23888 IR controller]");
diff --git a/drivers/media/pci/cx23885/netup-eeprom.c b/drivers/media/pci/cx23885/netup-eeprom.c
index b6542ee4385b..6384c12aa38e 100644
--- a/drivers/media/pci/cx23885/netup-eeprom.c
+++ b/drivers/media/pci/cx23885/netup-eeprom.c
@@ -52,7 +52,7 @@ int netup_eeprom_read(struct i2c_adapter *i2c_adap, u8 addr)
 	ret = i2c_transfer(i2c_adap, msg, 2);
 
 	if (ret != 2) {
-		printk(KERN_ERR "eeprom i2c read error, status=%d\n", ret);
+		pr_err("eeprom i2c read error, status=%d\n", ret);
 		return -1;
 	}
 
@@ -80,7 +80,7 @@ int netup_eeprom_write(struct i2c_adapter *i2c_adap, u8 addr, u8 data)
 	ret = i2c_transfer(i2c_adap, msg, 1);
 
 	if (ret != 1) {
-		printk(KERN_ERR "eeprom i2c write error, status=%d\n", ret);
+		pr_err("eeprom i2c write error, status=%d\n", ret);
 		return -1;
 	}
 
diff --git a/drivers/media/pci/cx23885/netup-init.c b/drivers/media/pci/cx23885/netup-init.c
index 76d9487aafc8..6a27ef5d9ec2 100644
--- a/drivers/media/pci/cx23885/netup-init.c
+++ b/drivers/media/pci/cx23885/netup-init.c
@@ -40,7 +40,7 @@ static void i2c_av_write(struct i2c_adapter *i2c, u16 reg, u8 val)
 	ret = i2c_transfer(i2c, &msg, 1);
 
 	if (ret != 1)
-		printk(KERN_ERR "%s: i2c write error!\n", __func__);
+		pr_err("%s: i2c write error!\n", __func__);
 }
 
 static void i2c_av_write4(struct i2c_adapter *i2c, u16 reg, u32 val)
@@ -64,7 +64,7 @@ static void i2c_av_write4(struct i2c_adapter *i2c, u16 reg, u32 val)
 	ret = i2c_transfer(i2c, &msg, 1);
 
 	if (ret != 1)
-		printk(KERN_ERR "%s: i2c write error!\n", __func__);
+		pr_err("%s: i2c write error!\n", __func__);
 }
 
 static u8 i2c_av_read(struct i2c_adapter *i2c, u16 reg)
@@ -84,7 +84,7 @@ static u8 i2c_av_read(struct i2c_adapter *i2c, u16 reg)
 	ret = i2c_transfer(i2c, &msg, 1);
 
 	if (ret != 1)
-		printk(KERN_ERR "%s: i2c write error!\n", __func__);
+		pr_err("%s: i2c write error!\n", __func__);
 
 	msg.flags = I2C_M_RD;
 	msg.len = 1;
@@ -92,7 +92,7 @@ static u8 i2c_av_read(struct i2c_adapter *i2c, u16 reg)
 	ret = i2c_transfer(i2c, &msg, 1);
 
 	if (ret != 1)
-		printk(KERN_ERR "%s: i2c read error!\n", __func__);
+		pr_err("%s: i2c read error!\n", __func__);
 
 	return buf[0];
 }
-- 
2.7.4


