Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49629 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753471AbcKPQnN (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 16 Nov 2016 11:43:13 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Andrey Utkin <andrey.utkin@corp.bluecherry.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Junghak Sung <jh1009.sung@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Inki Dae <inki.dae@samsung.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [PATCH 08/35] [media] cx88: convert it to use pr_foo() macros
Date: Wed, 16 Nov 2016 14:42:40 -0200
Message-Id: <cf30cb9b17879d4496c627501b35d85c34247084.1479314177.git.mchehab@s-opensource.com>
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
 drivers/media/pci/cx88/cx88-alsa.c       |  26 ++----
 drivers/media/pci/cx88/cx88-blackbird.c  |  31 +++----
 drivers/media/pci/cx88/cx88-cards.c      | 103 +++++++++------------
 drivers/media/pci/cx88/cx88-core.c       | 126 +++++++++++++------------
 drivers/media/pci/cx88/cx88-dsp.c        |  17 ++--
 drivers/media/pci/cx88/cx88-dvb.c        |  61 ++++++------
 drivers/media/pci/cx88/cx88-i2c.c        |  19 ++--
 drivers/media/pci/cx88/cx88-input.c      |   3 +-
 drivers/media/pci/cx88/cx88-mpeg.c       | 153 ++++++++++++++-----------------
 drivers/media/pci/cx88/cx88-tvaudio.c    |  15 +--
 drivers/media/pci/cx88/cx88-vbi.c        |  12 ++-
 drivers/media/pci/cx88/cx88-video.c      |  71 +++++++-------
 drivers/media/pci/cx88/cx88-vp3054-i2c.c |   8 +-
 drivers/media/pci/cx88/cx88.h            |   4 +-
 14 files changed, 306 insertions(+), 343 deletions(-)

diff --git a/drivers/media/pci/cx88/cx88-alsa.c b/drivers/media/pci/cx88/cx88-alsa.c
index 495f9a0569e0..d2f1880a157e 100644
--- a/drivers/media/pci/cx88/cx88-alsa.c
+++ b/drivers/media/pci/cx88/cx88-alsa.c
@@ -24,6 +24,9 @@
  *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#include "cx88.h"
+#include "cx88-reg.h"
+
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/device.h>
@@ -42,18 +45,11 @@
 #include <sound/tlv.h>
 #include <media/i2c/wm8775.h>
 
-#include "cx88.h"
-#include "cx88-reg.h"
-
 #define dprintk(level, fmt, arg...) do {				\
 	if (debug + 1 > level)						\
-		printk(KERN_INFO "%s/1: " fmt, chip->core->name , ## arg);\
-} while(0)
-
-#define dprintk_core(level, fmt, arg...) do {				\
-	if (debug + 1 > level)						\
-		printk(KERN_DEBUG "%s/1: " fmt, chip->core->name , ## arg);\
-} while(0)
+		printk(KERN_DEBUG pr_fmt("%s: alsa: " fmt),		\
+			chip->core->name, ##arg);			\
+} while (0)
 
 /****************************************************************************
 	Data type declarations - Can be moded to a header file later
@@ -230,12 +226,12 @@ static void cx8801_aud_irq(snd_cx88_card_t *chip)
 		return;
 	cx_write(MO_AUD_INTSTAT, status);
 	if (debug > 1  ||  (status & mask & ~0xff))
-		cx88_print_irqbits(core->name, "irq aud",
+		cx88_print_irqbits("irq aud",
 				   cx88_aud_irqs, ARRAY_SIZE(cx88_aud_irqs),
 				   status, mask);
 	/* risc op code error */
 	if (status & AUD_INT_OPC_ERR) {
-		printk(KERN_WARNING "%s/1: Audio risc op code error\n",core->name);
+		pr_warn("Audio risc op code error\n");
 		cx_clear(MO_AUD_DMACNTRL, 0x11);
 		cx88_sram_channel_dump(core, &cx88_sram_channels[SRAM_CH25]);
 	}
@@ -279,9 +275,7 @@ static irqreturn_t cx8801_irq(int irq, void *dev_id)
 	}
 
 	if (MAX_IRQ_LOOP == loop) {
-		printk(KERN_ERR
-		       "%s/1: IRQ loop detected, disabling interrupts\n",
-		       core->name);
+		pr_err("IRQ loop detected, disabling interrupts\n");
 		cx_clear(MO_PCI_INTMSK, PCI_INT_AUDINT);
 	}
 
@@ -423,7 +417,7 @@ static int snd_cx88_pcm_open(struct snd_pcm_substream *substream)
 	int err;
 
 	if (!chip) {
-		printk(KERN_ERR "BUG: cx88 can't find device struct. Can't proceed with open\n");
+		pr_err("BUG: cx88 can't find device struct. Can't proceed with open\n");
 		return -ENODEV;
 	}
 
diff --git a/drivers/media/pci/cx88/cx88-blackbird.c b/drivers/media/pci/cx88/cx88-blackbird.c
index b532e49e8f33..4163e777825d 100644
--- a/drivers/media/pci/cx88/cx88-blackbird.c
+++ b/drivers/media/pci/cx88/cx88-blackbird.c
@@ -26,6 +26,8 @@
  *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#include "cx88.h"
+
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/slab.h>
@@ -38,8 +40,6 @@
 #include <media/v4l2-event.h>
 #include <media/drv-intf/cx2341x.h>
 
-#include "cx88.h"
-
 MODULE_DESCRIPTION("driver for cx2388x/cx23416 based mpeg encoder cards");
 MODULE_AUTHOR("Jelle Foks <jelle@foks.us>, Gerd Knorr <kraxel@bytesex.org> [SuSE Labs]");
 MODULE_LICENSE("GPL");
@@ -49,10 +49,11 @@ static unsigned int debug;
 module_param(debug,int,0644);
 MODULE_PARM_DESC(debug,"enable debug messages [blackbird]");
 
-#define dprintk(level, fmt, arg...) do {				      \
-	if (debug + 1 > level)						      \
-		printk(KERN_DEBUG "%s/2-bb: " fmt, dev->core->name , ## arg); \
-} while(0)
+#define dprintk(level, fmt, arg...) do {				\
+	if (debug + 1 > level)						\
+		printk(KERN_DEBUG pr_fmt("%s: blackbird:" fmt),		\
+			__func__, ##arg);				\
+} while (0)
 
 /* ------------------------------------------------------------------ */
 
@@ -446,14 +447,14 @@ static int blackbird_load_firmware(struct cx8802_dev *dev)
 
 	if (retval != 0) {
 		pr_err("Hotplug firmware request failed (%s).\n",
-			CX2341X_FIRM_ENC_FILENAME);
+		       CX2341X_FIRM_ENC_FILENAME);
 		pr_err("Please fix your hotplug setup, the board will not work without firmware loaded!\n");
 		return -EIO;
 	}
 
 	if (firmware->size != BLACKBIRD_FIRM_IMAGE_SIZE) {
 		pr_err("Firmware size mismatch (have %zd, expected %d)\n",
-			firmware->size, BLACKBIRD_FIRM_IMAGE_SIZE);
+		       firmware->size, BLACKBIRD_FIRM_IMAGE_SIZE);
 		release_firmware(firmware);
 		return -EINVAL;
 	}
@@ -1118,12 +1119,11 @@ static int blackbird_register_video(struct cx8802_dev *dev)
 	dev->mpeg_dev.queue = &dev->vb2_mpegq;
 	err = video_register_device(&dev->mpeg_dev, VFL_TYPE_GRABBER, -1);
 	if (err < 0) {
-		printk(KERN_INFO "%s/2: can't register mpeg device\n",
-		       dev->core->name);
+		pr_info("can't register mpeg device\n");
 		return err;
 	}
-	printk(KERN_INFO "%s/2: registered device %s [mpeg]\n",
-	       dev->core->name, video_device_node_name(&dev->mpeg_dev));
+	pr_info("registered device %s [mpeg]\n",
+		video_device_node_name(&dev->mpeg_dev));
 	return 0;
 }
 
@@ -1158,8 +1158,7 @@ static int cx8802_blackbird_probe(struct cx8802_driver *drv)
 	v4l2_ctrl_add_handler(&dev->cxhdl.hdl, &core->video_hdl, NULL);
 
 	/* blackbird stuff */
-	printk("%s/2: cx23416 based mpeg encoder (blackbird reference design)\n",
-	       core->name);
+	pr_info("cx23416 based mpeg encoder (blackbird reference design)\n");
 	host_setup(dev->core);
 
 	blackbird_initialize_codec(dev);
@@ -1219,8 +1218,8 @@ static struct cx8802_driver cx8802_blackbird_driver = {
 
 static int __init blackbird_init(void)
 {
-	printk(KERN_INFO "cx2388x blackbird driver version %s loaded\n",
-	       CX88_VERSION);
+	pr_info("cx2388x blackbird driver version %s loaded\n",
+		CX88_VERSION);
 	return cx8802_register_driver(&cx8802_blackbird_driver);
 }
 
diff --git a/drivers/media/pci/cx88/cx88-cards.c b/drivers/media/pci/cx88/cx88-cards.c
index 31295b36dafc..1a65db957dcb 100644
--- a/drivers/media/pci/cx88/cx88-cards.c
+++ b/drivers/media/pci/cx88/cx88-cards.c
@@ -20,16 +20,16 @@
  *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#include "cx88.h"
+#include "tea5767.h"
+#include "xc4000.h"
+
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/pci.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
 
-#include "cx88.h"
-#include "tea5767.h"
-#include "xc4000.h"
-
 static unsigned int tuner[] = {[0 ... (CX88_MAXBOARDS - 1)] = UNSET };
 static unsigned int radio[] = {[0 ... (CX88_MAXBOARDS - 1)] = UNSET };
 static unsigned int card[]  = {[0 ... (CX88_MAXBOARDS - 1)] = UNSET };
@@ -50,19 +50,11 @@ static int disable_ir;
 module_param(disable_ir, int, 0444);
 MODULE_PARM_DESC(disable_ir, "Disable IR support");
 
-#define info_printk(core, fmt, arg...) \
-	printk(KERN_INFO "%s: " fmt, core->name , ## arg)
-
-#define warn_printk(core, fmt, arg...) \
-	printk(KERN_WARNING "%s: " fmt, core->name , ## arg)
-
-#define err_printk(core, fmt, arg...) \
-	printk(KERN_ERR "%s: " fmt, core->name , ## arg)
-
 #define dprintk(level,fmt, arg...)	do {				\
 	if (cx88_core_debug >= level)					\
-		printk(KERN_DEBUG "%s: " fmt, core->name , ## arg);	\
-	} while(0)
+		printk(KERN_DEBUG pr_fmt("%s: core:" fmt),		\
+			__func__, ##arg);				\
+} while (0)
 
 
 /* ------------------------------------------------------------------ */
@@ -2829,7 +2821,7 @@ static void leadtek_eeprom(struct cx88_core *core, u8 *eeprom_data)
 	if (eeprom_data[4] != 0x7d ||
 	    eeprom_data[5] != 0x10 ||
 	    eeprom_data[7] != 0x66) {
-		warn_printk(core, "Leadtek eeprom invalid.\n");
+		pr_warn("Leadtek eeprom invalid.\n");
 		return;
 	}
 
@@ -2847,8 +2839,8 @@ static void leadtek_eeprom(struct cx88_core *core, u8 *eeprom_data)
 		break;
 	}
 
-	info_printk(core, "Leadtek Winfast 2000XP Expert config: tuner=%d, eeprom[0]=0x%02x\n",
-		    core->board.tuner_type, eeprom_data[0]);
+	pr_info("Leadtek Winfast 2000XP Expert config: tuner=%d, eeprom[0]=0x%02x\n",
+		core->board.tuner_type, eeprom_data[0]);
 }
 
 static void hauppauge_eeprom(struct cx88_core *core, u8 *eeprom_data)
@@ -2904,12 +2896,11 @@ static void hauppauge_eeprom(struct cx88_core *core, u8 *eeprom_data)
 		cx_set(MO_GP0_IO, 0x008989FF);
 		break;
 	default:
-		warn_printk(core, "warning: unknown hauppauge model #%d\n",
-			    tv.model);
+		pr_warn("warning: unknown hauppauge model #%d\n", tv.model);
 		break;
 	}
 
-	info_printk(core, "hauppauge eeprom: model=%d\n", tv.model);
+	pr_info("hauppauge eeprom: model=%d\n", tv.model);
 }
 
 /* ----------------------------------------------------------------------- */
@@ -2955,7 +2946,7 @@ static void gdi_eeprom(struct cx88_core *core, u8 *eeprom_data)
 	const char *name = (eeprom_data[0x0d] < ARRAY_SIZE(gdi_tuner))
 		? gdi_tuner[eeprom_data[0x0d]].name : NULL;
 
-	info_printk(core, "GDI: tuner=%s\n", name ? name : "unknown");
+	pr_info("GDI: tuner=%s\n", name ? name : "unknown");
 	if (NULL == name)
 		return;
 	core->board.tuner_type = gdi_tuner[eeprom_data[0x0d]].id;
@@ -3106,8 +3097,8 @@ static void dvico_fusionhdtv_hybrid_init(struct cx88_core *core)
 		msg.len = (i != 12 ? 5 : 2);
 		err = i2c_transfer(&core->i2c_adap, &msg, 1);
 		if (err != 1) {
-			warn_printk(core, "dvico_fusionhdtv_hybrid_init buf %d failed (err = %d)!\n",
-				    i, err);
+			pr_warn("dvico_fusionhdtv_hybrid_init buf %d failed (err = %d)!\n",
+				i, err);
 			return;
 		}
 	}
@@ -3229,14 +3220,14 @@ int cx88_tuner_callback(void *priv, int component, int command, int arg)
 	struct cx88_core *core;
 
 	if (!i2c_algo) {
-		printk(KERN_ERR "cx88: Error - i2c private data undefined.\n");
+		pr_err("Error - i2c private data undefined.\n");
 		return -EINVAL;
 	}
 
 	core = i2c_algo->data;
 
 	if (!core) {
-		printk(KERN_ERR "cx88: Error - device struct undefined.\n");
+		pr_err("Error - device struct undefined.\n");
 		return -EINVAL;
 	}
 
@@ -3254,8 +3245,8 @@ int cx88_tuner_callback(void *priv, int component, int command, int arg)
 			dprintk(1, "Calling XC5000 callback\n");
 			return cx88_xc5000_tuner_callback(core, command, arg);
 	}
-	err_printk(core, "Error: Calling callback for tuner %d\n",
-		   core->board.tuner_type);
+	pr_err("Error: Calling callback for tuner %d\n",
+	       core->board.tuner_type);
 	return -EINVAL;
 }
 EXPORT_SYMBOL(cx88_tuner_callback);
@@ -3268,25 +3259,19 @@ static void cx88_card_list(struct cx88_core *core, struct pci_dev *pci)
 
 	if (0 == pci->subsystem_vendor &&
 	    0 == pci->subsystem_device) {
-		printk(KERN_ERR
-		       "%s: Your board has no valid PCI Subsystem ID and thus can't\n"
-		       "%s: be autodetected.  Please pass card=<n> insmod option to\n"
-		       "%s: workaround that.  Redirect complaints to the vendor of\n"
-		       "%s: the TV card.  Best regards,\n"
-		       "%s:         -- tux\n",
-		       core->name,core->name,core->name,core->name,core->name);
+		pr_err("Your board has no valid PCI Subsystem ID and thus can't\n");
+		pr_err("be autodetected.  Please pass card=<n> insmod option to\n");
+		pr_err("workaround that.  Redirect complaints to the vendor of\n");
+		pr_err("the TV card\n");
 	} else {
-		printk(KERN_ERR
-		       "%s: Your board isn't known (yet) to the driver.  You can\n"
-		       "%s: try to pick one of the existing card configs via\n"
-		       "%s: card=<n> insmod option.  Updating to the latest\n"
-		       "%s: version might help as well.\n",
-		       core->name,core->name,core->name,core->name);
+		pr_err("Your board isn't known (yet) to the driver.  You can\n");
+		pr_err("try to pick one of the existing card configs via\n");
+		pr_err("card=<n> insmod option.  Updating to the latest\n");
+		pr_err("version might help as well.\n");
 	}
-	err_printk(core, "Here is a list of valid choices for the card=<n> insmod option:\n");
+	pr_err("Here is a list of valid choices for the card=<n> insmod option:\n");
 	for (i = 0; i < ARRAY_SIZE(cx88_boards); i++)
-		printk(KERN_ERR "%s:    card=%d -> %s\n",
-		       core->name, i, cx88_boards[i].name);
+		pr_err("    card=%d -> %s\n", i, cx88_boards[i].name);
 }
 
 static void cx88_card_setup_pre_i2c(struct cx88_core *core)
@@ -3508,8 +3493,8 @@ static void cx88_card_setup(struct cx88_core *core)
 			for (i = 0; i < ARRAY_SIZE(buffer); i++)
 				if (2 != i2c_master_send(&core->i2c_client,
 							buffer[i],2))
-					warn_printk(core, "Unable to enable tuner(%i).\n",
-						    i);
+					pr_warn("Unable to enable tuner(%i).\n",
+						i);
 		}
 		break;
 	case CX88_BOARD_MSI_TVANYWHERE_MASTER:
@@ -3608,29 +3593,24 @@ static int cx88_pci_quirks(const char *name, struct pci_dev *pci)
 
 	/* check pci quirks */
 	if (pci_pci_problems & PCIPCI_TRITON) {
-		printk(KERN_INFO "%s: quirk: PCIPCI_TRITON -- set TBFX\n",
-		       name);
+		pr_info("quirk: PCIPCI_TRITON -- set TBFX\n");
 		ctrl |= CX88X_EN_TBFX;
 	}
 	if (pci_pci_problems & PCIPCI_NATOMA) {
-		printk(KERN_INFO "%s: quirk: PCIPCI_NATOMA -- set TBFX\n",
-		       name);
+		pr_info("quirk: PCIPCI_NATOMA -- set TBFX\n");
 		ctrl |= CX88X_EN_TBFX;
 	}
 	if (pci_pci_problems & PCIPCI_VIAETBF) {
-		printk(KERN_INFO "%s: quirk: PCIPCI_VIAETBF -- set TBFX\n",
-		       name);
+		pr_info("quirk: PCIPCI_VIAETBF -- set TBFX\n");
 		ctrl |= CX88X_EN_TBFX;
 	}
 	if (pci_pci_problems & PCIPCI_VSFX) {
-		printk(KERN_INFO "%s: quirk: PCIPCI_VSFX -- set VSFX\n",
-		       name);
+		pr_info("quirk: PCIPCI_VSFX -- set VSFX\n");
 		ctrl |= CX88X_EN_VSFX;
 	}
 #ifdef PCIPCI_ALIMAGIK
 	if (pci_pci_problems & PCIPCI_ALIMAGIK) {
-		printk(KERN_INFO "%s: quirk: PCIPCI_ALIMAGIK -- latency fixup\n",
-		       name);
+		pr_info("quirk: PCIPCI_ALIMAGIK -- latency fixup\n");
 		lat = 0x0A;
 	}
 #endif
@@ -3646,8 +3626,8 @@ static int cx88_pci_quirks(const char *name, struct pci_dev *pci)
 		pci_write_config_byte(pci, CX88X_DEVCTRL, value);
 	}
 	if (UNSET != lat) {
-		printk(KERN_INFO "%s: setting pci latency timer to %d\n",
-		       name, latency);
+		pr_info("setting pci latency timer to %d\n",
+			latency);
 		pci_write_config_byte(pci, PCI_LATENCY_TIMER, latency);
 	}
 	return 0;
@@ -3659,9 +3639,8 @@ int cx88_get_resources(const struct cx88_core *core, struct pci_dev *pci)
 			       pci_resource_len(pci,0),
 			       core->name))
 		return 0;
-	printk(KERN_ERR
-	       "%s/%d: Can't get MMIO memory @ 0x%llx, subsystem: %04x:%04x\n",
-	       core->name, PCI_FUNC(pci->devfn),
+	pr_err("func %d: Can't get MMIO memory @ 0x%llx, subsystem: %04x:%04x\n",
+	       PCI_FUNC(pci->devfn),
 	       (unsigned long long)pci_resource_start(pci, 0),
 	       pci->subsystem_vendor, pci->subsystem_device);
 	return -EBUSY;
@@ -3755,7 +3734,7 @@ struct cx88_core *cx88_core_create(struct pci_dev *pci, int nr)
 	if (!core->board.num_frontends && (core->board.mpeg & CX88_MPEG_DVB))
 		core->board.num_frontends = 1;
 
-	info_printk(core, "subsystem: %04x:%04x, board: %s [card=%d,%s], frontend(s): %d\n",
+	pr_info("subsystem: %04x:%04x, board: %s [card=%d,%s], frontend(s): %d\n",
 		pci->subsystem_vendor, pci->subsystem_device, core->board.name,
 		core->boardnr, card[core->nr] == core->boardnr ?
 		"insmod option" : "autodetected",
diff --git a/drivers/media/pci/cx88/cx88-core.c b/drivers/media/pci/cx88/cx88-core.c
index 1ffd341f990d..27203e094655 100644
--- a/drivers/media/pci/cx88/cx88-core.c
+++ b/drivers/media/pci/cx88/cx88-core.c
@@ -25,6 +25,8 @@
  *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#include "cx88.h"
+
 #include <linux/init.h>
 #include <linux/list.h>
 #include <linux/module.h>
@@ -38,7 +40,6 @@
 #include <linux/videodev2.h>
 #include <linux/mutex.h>
 
-#include "cx88.h"
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
 
@@ -60,10 +61,15 @@ static unsigned int nocomb;
 module_param(nocomb,int,0644);
 MODULE_PARM_DESC(nocomb,"disable comb filter");
 
-#define dprintk(level,fmt, arg...)	do {				\
-	if (cx88_core_debug >= level)					\
-		printk(KERN_DEBUG "%s: " fmt, core->name , ## arg);	\
-	} while(0)
+#define dprintk0(fmt, arg...)				\
+	printk(KERN_DEBUG pr_fmt("%s: core:" fmt),	\
+		__func__, ##arg)			\
+
+#define dprintk(level, fmt, arg...)	do {			\
+	if (cx88_core_debug >= level)				\
+		printk(KERN_DEBUG pr_fmt("%s: core:" fmt),	\
+		       __func__, ##arg);			\
+} while (0)
 
 static unsigned int cx88_devcount;
 static LIST_HEAD(cx88_devlist);
@@ -363,7 +369,7 @@ int cx88_sram_channel_setup(struct cx88_core *core,
 	cx_write(ch->cnt1_reg, (bpl >> 3) -1);
 	cx_write(ch->cnt2_reg, (lines*16) >> 3);
 
-	dprintk(2,"sram setup %s: bpl=%d lines=%d\n", ch->name, bpl, lines);
+	dprintk(2, "sram setup %s: bpl=%d lines=%d\n", ch->name, bpl, lines);
 	return 0;
 }
 
@@ -399,12 +405,12 @@ static int cx88_risc_decode(u32 risc)
 	};
 	int i;
 
-	printk(KERN_DEBUG "0x%08x [ %s", risc,
+	dprintk0("0x%08x [ %s", risc,
 	       instr[risc >> 28] ? instr[risc >> 28] : "INVALID");
 	for (i = ARRAY_SIZE(bits)-1; i >= 0; i--)
 		if (risc & (1 << (i + 12)))
-			printk(KERN_CONT " %s", bits[i]);
-	printk(KERN_CONT " count=%d ]\n", risc & 0xfff);
+			pr_cont(" %s", bits[i]);
+	pr_cont(" count=%d ]\n", risc & 0xfff);
 	return incr[risc >> 28] ? incr[risc >> 28] : 1;
 }
 
@@ -428,43 +434,39 @@ void cx88_sram_channel_dump(struct cx88_core *core,
 	u32 risc;
 	unsigned int i,j,n;
 
-	printk(KERN_DEBUG "%s: %s - dma channel status dump\n",
-	       core->name,ch->name);
+	dprintk0("%s - dma channel status dump\n",
+		ch->name);
 	for (i = 0; i < ARRAY_SIZE(name); i++)
-		printk(KERN_DEBUG "%s:   cmds: %-12s: 0x%08x\n",
-		       core->name,name[i],
-		       cx_read(ch->cmds_start + 4*i));
+		dprintk0("   cmds: %-12s: 0x%08x\n",
+			name[i],
+			cx_read(ch->cmds_start + 4*i));
 	for (n = 1, i = 0; i < 4; i++) {
 		risc = cx_read(ch->cmds_start + 4 * (i+11));
-		printk(KERN_CONT "%s:   risc%d: ", core->name, i);
+		pr_cont("  risc%d: ", i);
 		if (--n)
-			printk(KERN_CONT "0x%08x [ arg #%d ]\n", risc, n);
+			pr_cont("0x%08x [ arg #%d ]\n", risc, n);
 		else
 			n = cx88_risc_decode(risc);
 	}
 	for (i = 0; i < 16; i += n) {
 		risc = cx_read(ch->ctrl_start + 4 * i);
-		printk(KERN_DEBUG "%s:   iq %x: ", core->name, i);
+		dprintk0("  iq %x: ", i);
 		n = cx88_risc_decode(risc);
 		for (j = 1; j < n; j++) {
 			risc = cx_read(ch->ctrl_start + 4 * (i+j));
-			printk(KERN_CONT "%s:   iq %x: 0x%08x [ arg #%d ]\n",
-			       core->name, i+j, risc, j);
+			pr_cont("  iq %x: 0x%08x [ arg #%d ]\n",
+				i + j, risc, j);
 		}
 	}
 
-	printk(KERN_DEBUG "%s: fifo: 0x%08x -> 0x%x\n",
-	       core->name, ch->fifo_start, ch->fifo_start+ch->fifo_size);
-	printk(KERN_DEBUG "%s: ctrl: 0x%08x -> 0x%x\n",
-	       core->name, ch->ctrl_start, ch->ctrl_start+6*16);
-	printk(KERN_DEBUG "%s:   ptr1_reg: 0x%08x\n",
-	       core->name,cx_read(ch->ptr1_reg));
-	printk(KERN_DEBUG "%s:   ptr2_reg: 0x%08x\n",
-	       core->name,cx_read(ch->ptr2_reg));
-	printk(KERN_DEBUG "%s:   cnt1_reg: 0x%08x\n",
-	       core->name,cx_read(ch->cnt1_reg));
-	printk(KERN_DEBUG "%s:   cnt2_reg: 0x%08x\n",
-	       core->name,cx_read(ch->cnt2_reg));
+	dprintk0("fifo: 0x%08x -> 0x%x\n",
+	       ch->fifo_start, ch->fifo_start+ch->fifo_size);
+	dprintk0("ctrl: 0x%08x -> 0x%x\n",
+	       ch->ctrl_start, ch->ctrl_start + 6 * 16);
+	dprintk0("  ptr1_reg: 0x%08x\n", cx_read(ch->ptr1_reg));
+	dprintk0("  ptr2_reg: 0x%08x\n", cx_read(ch->ptr2_reg));
+	dprintk0("  cnt1_reg: 0x%08x\n", cx_read(ch->cnt1_reg));
+	dprintk0("  cnt2_reg: 0x%08x\n", cx_read(ch->cnt2_reg));
 }
 
 static const char *cx88_pci_irqs[32] = {
@@ -474,24 +476,24 @@ static const char *cx88_pci_irqs[32] = {
 	"i2c", "i2c_rack", "ir_smp", "gpio0", "gpio1"
 };
 
-void cx88_print_irqbits(const char *name, const char *tag, const char *strings[],
+void cx88_print_irqbits(const char *tag, const char *strings[],
 			int len, u32 bits, u32 mask)
 {
 	unsigned int i;
 
-	printk(KERN_DEBUG "%s: %s [0x%x]", name, tag, bits);
+	dprintk0("%s [0x%x]", tag, bits);
 	for (i = 0; i < len; i++) {
 		if (!(bits & (1 << i)))
 			continue;
 		if (strings[i])
-			printk(KERN_CONT " %s", strings[i]);
+			pr_cont(" %s", strings[i]);
 		else
-			printk(KERN_CONT " %d", i);
+			pr_cont(" %d", i);
 		if (!(mask & (1 << i)))
 			continue;
-		printk(KERN_CONT "*");
+		pr_cont("*");
 	}
-	printk(KERN_CONT "\n");
+	pr_cont("\n");
 }
 
 /* ------------------------------------------------------------------ */
@@ -505,7 +507,7 @@ int cx88_core_irq(struct cx88_core *core, u32 status)
 		handled++;
 	}
 	if (!handled)
-		cx88_print_irqbits(core->name, "irq pci",
+		cx88_print_irqbits("irq pci",
 				   cx88_pci_irqs, ARRAY_SIZE(cx88_pci_irqs),
 				   status, core->pci_irqmask);
 	return handled;
@@ -551,7 +553,7 @@ void cx88_shutdown(struct cx88_core *core)
 
 int cx88_reset(struct cx88_core *core)
 {
-	dprintk(1,"%s\n",__func__);
+	dprintk(1, "");
 	cx88_shutdown(core);
 
 	/* clear irq status */
@@ -663,7 +665,7 @@ int cx88_set_scale(struct cx88_core *core, unsigned int width, unsigned int heig
 	unsigned int sheight = norm_maxh(core->tvnorm);
 	u32 value;
 
-	dprintk(1,"set_scale: %dx%d [%s%s,%s]\n", width, height,
+	dprintk(1, "set_scale: %dx%d [%s%s,%s]\n", width, height,
 		V4L2_FIELD_HAS_TOP(field)    ? "T" : "",
 		V4L2_FIELD_HAS_BOTTOM(field) ? "B" : "",
 		v4l2_norm_to_name(core->tvnorm));
@@ -675,30 +677,30 @@ int cx88_set_scale(struct cx88_core *core, unsigned int width, unsigned int heig
 	value &= 0x3fe;
 	cx_write(MO_HDELAY_EVEN,  value);
 	cx_write(MO_HDELAY_ODD,   value);
-	dprintk(1,"set_scale: hdelay  0x%04x (width %d)\n", value,swidth);
+	dprintk(1, "set_scale: hdelay  0x%04x (width %d)\n", value, swidth);
 
 	value = (swidth * 4096 / width) - 4096;
 	cx_write(MO_HSCALE_EVEN,  value);
 	cx_write(MO_HSCALE_ODD,   value);
-	dprintk(1,"set_scale: hscale  0x%04x\n", value);
+	dprintk(1, "set_scale: hscale  0x%04x\n", value);
 
 	cx_write(MO_HACTIVE_EVEN, width);
 	cx_write(MO_HACTIVE_ODD,  width);
-	dprintk(1,"set_scale: hactive 0x%04x\n", width);
+	dprintk(1, "set_scale: hactive 0x%04x\n", width);
 
 	// recalc V scale Register (delay is constant)
 	cx_write(MO_VDELAY_EVEN, norm_vdelay(core->tvnorm));
 	cx_write(MO_VDELAY_ODD,  norm_vdelay(core->tvnorm));
-	dprintk(1,"set_scale: vdelay  0x%04x\n", norm_vdelay(core->tvnorm));
+	dprintk(1, "set_scale: vdelay  0x%04x\n", norm_vdelay(core->tvnorm));
 
 	value = (0x10000 - (sheight * 512 / height - 512)) & 0x1fff;
 	cx_write(MO_VSCALE_EVEN,  value);
 	cx_write(MO_VSCALE_ODD,   value);
-	dprintk(1,"set_scale: vscale  0x%04x\n", value);
+	dprintk(1, "set_scale: vscale  0x%04x\n", value);
 
 	cx_write(MO_VACTIVE_EVEN, sheight);
 	cx_write(MO_VACTIVE_ODD,  sheight);
-	dprintk(1,"set_scale: vactive 0x%04x\n", sheight);
+	dprintk(1, "set_scale: vactive 0x%04x\n", sheight);
 
 	// setup filters
 	value = 0;
@@ -720,7 +722,7 @@ int cx88_set_scale(struct cx88_core *core, unsigned int width, unsigned int heig
 
 	cx_andor(MO_FILTER_EVEN,  0x7ffc7f, value); /* preserve PEAKEN, PSEL */
 	cx_andor(MO_FILTER_ODD,   0x7ffc7f, value);
-	dprintk(1,"set_scale: filter  0x%04x\n", value);
+	dprintk(1, "set_scale: filter  0x%04x\n", value);
 
 	return 0;
 }
@@ -743,11 +745,11 @@ static int set_pll(struct cx88_core *core, int prescale, u32 ofreq)
 	do_div(pll,xtal);
 	reg = (pll & 0x3ffffff) | (pre[prescale] << 26);
 	if (((reg >> 20) & 0x3f) < 14) {
-		printk("%s/0: pll out of range\n",core->name);
+		pr_err("pll out of range\n");
 		return -1;
 	}
 
-	dprintk(1,"set_pll:    MO_PLL_REG       0x%08x [old=0x%08x,freq=%d]\n",
+	dprintk(1, "set_pll:    MO_PLL_REG       0x%08x [old=0x%08x,freq=%d]\n",
 		reg, cx_read(MO_PLL_REG), ofreq);
 	cx_write(MO_PLL_REG, reg);
 	for (i = 0; i < 100; i++) {
@@ -757,10 +759,10 @@ static int set_pll(struct cx88_core *core, int prescale, u32 ofreq)
 				prescale,ofreq);
 			return 0;
 		}
-		dprintk(1,"pll not locked yet, waiting ...\n");
+		dprintk(1, "pll not locked yet, waiting ...\n");
 		msleep(10);
 	}
-	dprintk(1,"pll NOT locked [pre=%d,ofreq=%d]\n",prescale,ofreq);
+	dprintk(1, "pll NOT locked [pre=%d,ofreq=%d]\n", prescale, ofreq);
 	return -1;
 }
 
@@ -836,8 +838,8 @@ static int set_tvaudio(struct cx88_core *core)
 		core->tvaudio = WW_EIAJ;
 
 	} else {
-		printk("%s/0: tvaudio support needs work for this tv norm [%s], sorry\n",
-		       core->name, v4l2_norm_to_name(core->tvnorm));
+		pr_info("tvaudio support needs work for this tv norm [%s], sorry\n",
+			v4l2_norm_to_name(core->tvnorm));
 		core->tvaudio = WW_NONE;
 		return 0;
 	}
@@ -912,12 +914,12 @@ int cx88_set_tvnorm(struct cx88_core *core, v4l2_std_id norm)
 		cxoformat = 0x181f0008;
 	}
 
-	dprintk(1,"set_tvnorm: \"%s\" fsc8=%d adc=%d vdec=%d db/dr=%d/%d\n",
+	dprintk(1, "set_tvnorm: \"%s\" fsc8=%d adc=%d vdec=%d db/dr=%d/%d\n",
 		v4l2_norm_to_name(core->tvnorm), fsc8, adc_clock, vdec_clock,
 		step_db, step_dr);
 	set_pll(core,2,vdec_clock);
 
-	dprintk(1,"set_tvnorm: MO_INPUT_FORMAT  0x%08x [old=0x%08x]\n",
+	dprintk(1, "set_tvnorm: MO_INPUT_FORMAT  0x%08x [old=0x%08x]\n",
 		cxiformat, cx_read(MO_INPUT_FORMAT) & 0x0f);
 	/* Chroma AGC must be disabled if SECAM is used, we enable it
 	   by default on PAL and NTSC */
@@ -925,35 +927,36 @@ int cx88_set_tvnorm(struct cx88_core *core, v4l2_std_id norm)
 		 norm & V4L2_STD_SECAM ? cxiformat : cxiformat | 0x400);
 
 	// FIXME: as-is from DScaler
-	dprintk(1,"set_tvnorm: MO_OUTPUT_FORMAT 0x%08x [old=0x%08x]\n",
+	dprintk(1, "set_tvnorm: MO_OUTPUT_FORMAT 0x%08x [old=0x%08x]\n",
 		cxoformat, cx_read(MO_OUTPUT_FORMAT));
 	cx_write(MO_OUTPUT_FORMAT, cxoformat);
 
 	// MO_SCONV_REG = adc clock / video dec clock * 2^17
 	tmp64  = adc_clock * (u64)(1 << 17);
 	do_div(tmp64, vdec_clock);
-	dprintk(1,"set_tvnorm: MO_SCONV_REG     0x%08x [old=0x%08x]\n",
+	dprintk(1, "set_tvnorm: MO_SCONV_REG     0x%08x [old=0x%08x]\n",
 		(u32)tmp64, cx_read(MO_SCONV_REG));
 	cx_write(MO_SCONV_REG, (u32)tmp64);
 
 	// MO_SUB_STEP = 8 * fsc / video dec clock * 2^22
 	tmp64  = step_db * (u64)(1 << 22);
 	do_div(tmp64, vdec_clock);
-	dprintk(1,"set_tvnorm: MO_SUB_STEP      0x%08x [old=0x%08x]\n",
+	dprintk(1, "set_tvnorm: MO_SUB_STEP      0x%08x [old=0x%08x]\n",
 		(u32)tmp64, cx_read(MO_SUB_STEP));
 	cx_write(MO_SUB_STEP, (u32)tmp64);
 
 	// MO_SUB_STEP_DR = 8 * 4406250 / video dec clock * 2^22
 	tmp64  = step_dr * (u64)(1 << 22);
 	do_div(tmp64, vdec_clock);
-	dprintk(1,"set_tvnorm: MO_SUB_STEP_DR   0x%08x [old=0x%08x]\n",
+	dprintk(1, "set_tvnorm: MO_SUB_STEP_DR   0x%08x [old=0x%08x]\n",
 		(u32)tmp64, cx_read(MO_SUB_STEP_DR));
 	cx_write(MO_SUB_STEP_DR, (u32)tmp64);
 
 	// bdelay + agcdelay
 	bdelay   = vdec_clock * 65 / 20000000 + 21;
 	agcdelay = vdec_clock * 68 / 20000000 + 15;
-	dprintk(1,"set_tvnorm: MO_AGC_BURST     0x%08x [old=0x%08x,bdelay=%d,agcdelay=%d]\n",
+	dprintk(1,
+		"set_tvnorm: MO_AGC_BURST     0x%08x [old=0x%08x,bdelay=%d,agcdelay=%d]\n",
 		(bdelay << 8) | agcdelay, cx_read(MO_AGC_BURST), bdelay, agcdelay);
 	cx_write(MO_AGC_BURST, (bdelay << 8) | agcdelay);
 
@@ -961,7 +964,8 @@ int cx88_set_tvnorm(struct cx88_core *core, v4l2_std_id norm)
 	tmp64 = norm_htotal(norm) * (u64)vdec_clock;
 	do_div(tmp64, fsc8);
 	htotal = (u32)tmp64;
-	dprintk(1,"set_tvnorm: MO_HTOTAL        0x%08x [old=0x%08x,htotal=%d]\n",
+	dprintk(1,
+		"set_tvnorm: MO_HTOTAL        0x%08x [old=0x%08x,htotal=%d]\n",
 		htotal, cx_read(MO_HTOTAL), (u32)tmp64);
 	cx_andor(MO_HTOTAL, 0x07ff, htotal);
 
diff --git a/drivers/media/pci/cx88/cx88-dsp.c b/drivers/media/pci/cx88/cx88-dsp.c
index d00e20b1e53b..eb502f8a290b 100644
--- a/drivers/media/pci/cx88/cx88-dsp.c
+++ b/drivers/media/pci/cx88/cx88-dsp.c
@@ -19,15 +19,15 @@
  *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#include "cx88.h"
+#include "cx88-reg.h"
+
 #include <linux/slab.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/jiffies.h>
 #include <asm/div64.h>
 
-#include "cx88.h"
-#include "cx88-reg.h"
-
 #define INT_PI			((s32)(3.141592653589 * 32768.0))
 
 #define compat_remainder(a, b) \
@@ -71,8 +71,11 @@ static unsigned int dsp_debug;
 module_param(dsp_debug, int, 0644);
 MODULE_PARM_DESC(dsp_debug, "enable audio dsp debug messages");
 
-#define dprintk(level, fmt, arg...)	if (dsp_debug >= level) \
-	printk(KERN_DEBUG "%s/0: " fmt, core->name , ## arg)
+#define dprintk(level, fmt, arg...) do {				\
+	if (dsp_debug >= level)						\
+		printk(KERN_DEBUG pr_fmt("%s: dsp:" fmt),		\
+			__func__, ##arg);				\
+} while (0)
 
 static s32 int_cos(u32 x)
 {
@@ -176,8 +179,8 @@ static s32 detect_a2_a2m_eiaj(struct cx88_core *core, s16 x[], u32 N)
 		dual_freq = FREQ_EIAJ_DUAL;
 		break;
 	default:
-		printk(KERN_WARNING "%s/0: unsupported audio mode %d for %s\n",
-		       core->name, core->tvaudio, __func__);
+		pr_warn("unsupported audio mode %d for %s\n",
+			core->tvaudio, __func__);
 		return UNSET;
 	}
 
diff --git a/drivers/media/pci/cx88/cx88-dvb.c b/drivers/media/pci/cx88/cx88-dvb.c
index 157bc14874eb..378135ddb6fb 100644
--- a/drivers/media/pci/cx88/cx88-dvb.c
+++ b/drivers/media/pci/cx88/cx88-dvb.c
@@ -21,6 +21,9 @@
  *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#include "cx88.h"
+#include "dvb-pll.h"
+
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/device.h>
@@ -29,8 +32,6 @@
 #include <linux/file.h>
 #include <linux/suspend.h>
 
-#include "cx88.h"
-#include "dvb-pll.h"
 #include <media/v4l2-common.h>
 
 #include "mt352.h"
@@ -77,8 +78,11 @@ MODULE_PARM_DESC(dvb_buf_tscnt, "DVB Buffer TS count [dvb]");
 
 DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 
-#define dprintk(level,fmt, arg...)	if (debug >= level) \
-	printk(KERN_DEBUG "%s/2-dvb: " fmt, core->name, ## arg)
+#define dprintk(level, fmt, arg...) do {				\
+	if (debug >= level)						\
+		printk(KERN_DEBUG pr_fmt("%s: dvb:" fmt),		\
+			__func__, ##arg);				\
+} while (0)
 
 /* ------------------------------------------------------------------ */
 
@@ -178,7 +182,7 @@ static int cx88_dvb_bus_ctrl(struct dvb_frontend* fe, int acquire)
 
 	fe_id = vb2_dvb_find_frontend(&dev->frontends, fe);
 	if (!fe_id) {
-		printk(KERN_ERR "%s() No frontend found\n", __func__);
+		pr_err("%s() No frontend found\n", __func__);
 		return -EINVAL;
 	}
 
@@ -625,8 +629,7 @@ static int attach_xc3028(u8 addr, struct cx8802_dev *dev)
 		return -EINVAL;
 
 	if (!fe0->dvb.frontend) {
-		printk(KERN_ERR "%s/2: dvb frontend not attached. Can't attach xc3028\n",
-		       dev->core->name);
+		pr_err("dvb frontend not attached. Can't attach xc3028\n");
 		return -EINVAL;
 	}
 
@@ -639,16 +642,14 @@ static int attach_xc3028(u8 addr, struct cx8802_dev *dev)
 
 	fe = dvb_attach(xc2028_attach, fe0->dvb.frontend, &cfg);
 	if (!fe) {
-		printk(KERN_ERR "%s/2: xc3028 attach failed\n",
-		       dev->core->name);
+		pr_err("xc3028 attach failed\n");
 		dvb_frontend_detach(fe0->dvb.frontend);
 		dvb_unregister_frontend(fe0->dvb.frontend);
 		fe0->dvb.frontend = NULL;
 		return -EINVAL;
 	}
 
-	printk(KERN_INFO "%s/2: xc3028 attached\n",
-	       dev->core->name);
+	pr_info("xc3028 attached\n");
 
 	return 0;
 }
@@ -664,23 +665,21 @@ static int attach_xc4000(struct cx8802_dev *dev, struct xc4000_config *cfg)
 		return -EINVAL;
 
 	if (!fe0->dvb.frontend) {
-		printk(KERN_ERR "%s/2: dvb frontend not attached. Can't attach xc4000\n",
-		       dev->core->name);
+		pr_err("dvb frontend not attached. Can't attach xc4000\n");
 		return -EINVAL;
 	}
 
 	fe = dvb_attach(xc4000_attach, fe0->dvb.frontend, &dev->core->i2c_adap,
 			cfg);
 	if (!fe) {
-		printk(KERN_ERR "%s/2: xc4000 attach failed\n",
-		       dev->core->name);
+		pr_err("xc4000 attach failed\n");
 		dvb_frontend_detach(fe0->dvb.frontend);
 		dvb_unregister_frontend(fe0->dvb.frontend);
 		fe0->dvb.frontend = NULL;
 		return -EINVAL;
 	}
 
-	printk(KERN_INFO "%s/2: xc4000 attached\n", dev->core->name);
+	pr_info("xc4000 attached\n");
 
 	return 0;
 }
@@ -798,12 +797,12 @@ static int cx8802_alloc_frontends(struct cx8802_dev *dev)
 	if (!core->board.num_frontends)
 		return -ENODEV;
 
-	printk(KERN_INFO "%s() allocating %d frontend(s)\n", __func__,
-			 core->board.num_frontends);
+	pr_info("%s: allocating %d frontend(s)\n", __func__,
+		core->board.num_frontends);
 	for (i = 1; i <= core->board.num_frontends; i++) {
 		fe = vb2_dvb_alloc_frontend(&dev->frontends, i);
 		if (!fe) {
-			printk(KERN_ERR "%s() failed to alloc\n", __func__);
+			pr_err("%s() failed to alloc\n", __func__);
 			vb2_dvb_dealloc_frontends(&dev->frontends);
 			return -ENOMEM;
 		}
@@ -1007,7 +1006,7 @@ static int dvb_register(struct cx8802_dev *dev)
 	int res = -EINVAL;
 
 	if (0 != core->i2c_rc) {
-		printk(KERN_ERR "%s/2: no i2c-bus available, cannot attach dvb drivers\n", core->name);
+		pr_err("no i2c-bus available, cannot attach dvb drivers\n");
 		goto frontend_detach;
 	}
 
@@ -1182,8 +1181,7 @@ static int dvb_register(struct cx8802_dev *dev)
 				goto frontend_detach;
 		}
 #else
-		printk(KERN_ERR "%s/2: built without vp3054 support\n",
-				core->name);
+		pr_err("built without vp3054 support\n");
 #endif
 		break;
 	case CX88_BOARD_DVICO_FUSIONHDTV_DVB_T_HYBRID:
@@ -1615,15 +1613,12 @@ static int dvb_register(struct cx8802_dev *dev)
 		break;
 
 	default:
-		printk(KERN_ERR "%s/2: The frontend of your DVB/ATSC card isn't supported yet\n",
-		       core->name);
+		pr_err("The frontend of your DVB/ATSC card isn't supported yet\n");
 		break;
 	}
 
 	if ( (NULL == fe0->dvb.frontend) || (fe1 && NULL == fe1->dvb.frontend) ) {
-		printk(KERN_ERR
-		       "%s/2: frontend initialization failed\n",
-		       core->name);
+		pr_err("frontend initialization failed\n");
 		goto frontend_detach;
 	}
 	/* define general-purpose callback pointer */
@@ -1762,7 +1757,7 @@ static int cx8802_dvb_probe(struct cx8802_driver *drv)
 		goto fail_core;
 
 	/* dvb stuff */
-	printk(KERN_INFO "%s/2: cx2388x based DVB/ATSC card\n", core->name);
+	pr_info("cx2388x based DVB/ATSC card\n");
 	dev->ts_gen_cntrl = 0x0c;
 
 	err = cx8802_alloc_frontends(dev);
@@ -1774,8 +1769,8 @@ static int cx8802_dvb_probe(struct cx8802_driver *drv)
 
 		fe = vb2_dvb_get_frontend(&core->dvbdev->frontends, i);
 		if (fe == NULL) {
-			printk(KERN_ERR "%s() failed to get frontend(%d)\n",
-					__func__, i);
+			pr_err("%s() failed to get frontend(%d)\n",
+			       __func__, i);
 			err = -ENODEV;
 			goto fail_probe;
 		}
@@ -1803,8 +1798,7 @@ static int cx8802_dvb_probe(struct cx8802_driver *drv)
 	err = dvb_register(dev);
 	if (err)
 		/* frontends/adapter de-allocated in dvb_register */
-		printk(KERN_ERR "%s/2: dvb_register failed (err = %d)\n",
-		       core->name, err);
+		pr_err("dvb_register failed (err = %d)\n", err);
 	return err;
 fail_probe:
 	vb2_dvb_dealloc_frontends(&core->dvbdev->frontends);
@@ -1839,8 +1833,7 @@ static struct cx8802_driver cx8802_dvb_driver = {
 
 static int __init dvb_init(void)
 {
-	printk(KERN_INFO "cx88/2: cx2388x dvb driver version %s loaded\n",
-	       CX88_VERSION);
+	pr_info("cx2388x dvb driver version %s loaded\n", CX88_VERSION);
 	return cx8802_register_driver(&cx8802_dvb_driver);
 }
 
diff --git a/drivers/media/pci/cx88/cx88-i2c.c b/drivers/media/pci/cx88/cx88-i2c.c
index 804f7417d19f..831f8db5150e 100644
--- a/drivers/media/pci/cx88/cx88-i2c.c
+++ b/drivers/media/pci/cx88/cx88-i2c.c
@@ -27,12 +27,13 @@
 
 */
 
+#include "cx88.h"
+
 #include <linux/module.h>
 #include <linux/init.h>
 
 #include <asm/io.h>
 
-#include "cx88.h"
 #include <media/v4l2-common.h>
 
 static unsigned int i2c_debug;
@@ -47,8 +48,11 @@ static unsigned int i2c_udelay = 5;
 module_param(i2c_udelay, int, 0644);
 MODULE_PARM_DESC(i2c_udelay, "i2c delay at insmod time, in usecs (should be 5 or higher). Lower value means higher bus speed.");
 
-#define dprintk(level,fmt, arg...)	if (i2c_debug >= level) \
-	printk(KERN_DEBUG "%s: " fmt, core->name , ## arg)
+#define dprintk(level, fmt, arg...) do {				\
+	if (i2c_debug >= level)						\
+		printk(KERN_DEBUG pr_fmt("%s: i2c:" fmt),		\
+			__func__, ##arg);				\
+} while (0)
 
 /* ----------------------------------------------------------------------- */
 
@@ -126,8 +130,8 @@ static void do_i2c_scan(const char *name, struct i2c_client *c)
 		rc = i2c_master_recv(c,&buf,0);
 		if (rc < 0)
 			continue;
-		printk("%s: i2c scan: found device @ 0x%x  [%s]\n",
-		       name, i << 1, i2c_devs[i] ? i2c_devs[i] : "???");
+		pr_info("i2c scan: found device @ 0x%x  [%s]\n",
+			i << 1, i2c_devs[i] ? i2c_devs[i] : "???");
 	}
 }
 
@@ -166,8 +170,7 @@ int cx88_i2c_init(struct cx88_core *core, struct pci_dev *pci)
 			case CX88_BOARD_HAUPPAUGE_HVR1300:
 			case CX88_BOARD_HAUPPAUGE_HVR3000:
 			case CX88_BOARD_HAUPPAUGE_HVR4000:
-				printk("%s: i2c init: enabling analog demod on HVR1300/3000/4000 tuner\n",
-					core->name);
+				pr_info("i2c init: enabling analog demod on HVR1300/3000/4000 tuner\n");
 				i2c_transfer(core->i2c_client.adapter, &tuner_msg, 1);
 				break;
 			default:
@@ -176,7 +179,7 @@ int cx88_i2c_init(struct cx88_core *core, struct pci_dev *pci)
 		if (i2c_scan)
 			do_i2c_scan(core->name,&core->i2c_client);
 	} else
-		printk("%s: i2c register FAILED\n", core->name);
+		pr_err("i2c register FAILED\n");
 
 	return core->i2c_rc;
 }
diff --git a/drivers/media/pci/cx88/cx88-input.c b/drivers/media/pci/cx88/cx88-input.c
index cd7687183381..3a05629ba6e4 100644
--- a/drivers/media/pci/cx88/cx88-input.c
+++ b/drivers/media/pci/cx88/cx88-input.c
@@ -22,13 +22,14 @@
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
  */
 
+#include "cx88.h"
+
 #include <linux/init.h>
 #include <linux/hrtimer.h>
 #include <linux/pci.h>
 #include <linux/slab.h>
 #include <linux/module.h>
 
-#include "cx88.h"
 #include <media/rc-core.h>
 
 #define MODULE_NAME "cx88xx"
diff --git a/drivers/media/pci/cx88/cx88-mpeg.c b/drivers/media/pci/cx88/cx88-mpeg.c
index 86b46b62d985..ed3fcc8149bd 100644
--- a/drivers/media/pci/cx88/cx88-mpeg.c
+++ b/drivers/media/pci/cx88/cx88-mpeg.c
@@ -22,6 +22,8 @@
  *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#include "cx88.h"
+
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/init.h>
@@ -30,8 +32,6 @@
 #include <linux/interrupt.h>
 #include <asm/delay.h>
 
-#include "cx88.h"
-
 /* ------------------------------------------------------------------ */
 
 MODULE_DESCRIPTION("mpeg driver for cx2388x based TV cards");
@@ -45,15 +45,11 @@ static unsigned int debug;
 module_param(debug,int,0644);
 MODULE_PARM_DESC(debug,"enable debug messages [mpeg]");
 
-#define dprintk(level, fmt, arg...) do {				       \
-	if (debug + 1 > level)						       \
-		printk(KERN_DEBUG "%s/2-mpeg: " fmt, dev->core->name, ## arg); \
-} while(0)
-
-#define mpeg_dbg(level, fmt, arg...) do {				  \
-	if (debug + 1 > level)						  \
-		printk(KERN_DEBUG "%s/2-mpeg: " fmt, core->name, ## arg); \
-} while(0)
+#define dprintk(level, fmt, arg...) do {				\
+	if (debug + 1 > level)						\
+		printk(KERN_DEBUG pr_fmt("%s: mpeg:" fmt),		\
+			__func__, ##arg);				\
+} while (0)
 
 #if defined(CONFIG_MODULES) && defined(MODULE)
 static void request_module_async(struct work_struct *work)
@@ -92,7 +88,7 @@ int cx8802_start_dma(struct cx8802_dev    *dev,
 {
 	struct cx88_core *core = dev->core;
 
-	dprintk(1, "cx8802_start_dma w: %d, h: %d, f: %d\n",
+	dprintk(1, "w: %d, h: %d, f: %d\n",
 		core->width, core->height, core->field);
 
 	/* setup fifo + format */
@@ -105,12 +101,12 @@ int cx8802_start_dma(struct cx8802_dev    *dev,
 	/* FIXME: this needs a review.
 	 * also: move to cx88-blackbird + cx88-dvb source files? */
 
-	dprintk( 1, "core->active_type_id = 0x%08x\n", core->active_type_id);
+	dprintk(1, "core->active_type_id = 0x%08x\n", core->active_type_id);
 
 	if ( (core->active_type_id == CX88_MPEG_DVB) &&
 		(core->board.mpeg & CX88_MPEG_DVB) ) {
 
-		dprintk( 1, "cx8802_start_dma doing .dvb\n");
+		dprintk(1, "cx8802_start_dma doing .dvb\n");
 		/* negedge driven & software reset */
 		cx_write(TS_GEN_CNTRL, 0x0040 | dev->ts_gen_cntrl);
 		udelay(100);
@@ -154,7 +150,7 @@ int cx8802_start_dma(struct cx8802_dev    *dev,
 		udelay(100);
 	} else if ( (core->active_type_id == CX88_MPEG_BLACKBIRD) &&
 		(core->board.mpeg & CX88_MPEG_BLACKBIRD) ) {
-		dprintk( 1, "cx8802_start_dma doing .blackbird\n");
+		dprintk(1, "cx8802_start_dma doing .blackbird\n");
 		cx_write(MO_PINMUX_IO, 0x88); /* enable MPEG parallel IO */
 
 		cx_write(TS_GEN_CNTRL, 0x46); /* punctured clock TS & posedge driven & software reset */
@@ -166,8 +162,8 @@ int cx8802_start_dma(struct cx8802_dev    *dev,
 		cx_write(TS_GEN_CNTRL, 0x06); /* punctured clock TS & posedge driven */
 		udelay(100);
 	} else {
-		printk( "%s() Failed. Unsupported value in .mpeg (0x%08x)\n", __func__,
-			core->board.mpeg );
+		pr_err("%s() Failed. Unsupported value in .mpeg (0x%08x)\n",
+		       __func__, core->board.mpeg);
 		return -EINVAL;
 	}
 
@@ -176,7 +172,7 @@ int cx8802_start_dma(struct cx8802_dev    *dev,
 	q->count = 0;
 
 	/* enable irqs */
-	dprintk( 1, "setting the interrupt mask\n" );
+	dprintk(1, "setting the interrupt mask\n");
 	cx_set(MO_PCI_INTMSK, core->pci_irqmask | PCI_INT_TSINT);
 	cx_set(MO_TS_INTMSK,  0x1f0011);
 
@@ -189,7 +185,7 @@ int cx8802_start_dma(struct cx8802_dev    *dev,
 static int cx8802_stop_dma(struct cx8802_dev *dev)
 {
 	struct cx88_core *core = dev->core;
-	dprintk( 1, "cx8802_stop_dma\n" );
+	dprintk(1, "\n");
 
 	/* stop dma */
 	cx_clear(MO_TS_DMACNTRL, 0x11);
@@ -208,7 +204,7 @@ static int cx8802_restart_queue(struct cx8802_dev    *dev,
 {
 	struct cx88_buffer *buf;
 
-	dprintk( 1, "cx8802_restart_queue\n" );
+	dprintk(1, "\n");
 	if (list_empty(&q->active))
 		return 0;
 
@@ -249,25 +245,25 @@ void cx8802_buf_queue(struct cx8802_dev *dev, struct cx88_buffer *buf)
 	struct cx88_buffer    *prev;
 	struct cx88_dmaqueue  *cx88q = &dev->mpegq;
 
-	dprintk( 1, "cx8802_buf_queue\n" );
+	dprintk(1, "\n");
 	/* add jump to start */
 	buf->risc.cpu[1] = cpu_to_le32(buf->risc.dma + 8);
 	buf->risc.jmp[0] = cpu_to_le32(RISC_JUMP | RISC_CNT_INC);
 	buf->risc.jmp[1] = cpu_to_le32(buf->risc.dma + 8);
 
 	if (list_empty(&cx88q->active)) {
-		dprintk( 1, "queue is empty - first active\n" );
+		dprintk(1, "queue is empty - first active\n");
 		list_add_tail(&buf->list, &cx88q->active);
 		dprintk(1,"[%p/%d] %s - first active\n",
 			buf, buf->vb.vb2_buf.index, __func__);
 
 	} else {
 		buf->risc.cpu[0] |= cpu_to_le32(RISC_IRQ1);
-		dprintk( 1, "queue is not empty - append to active\n" );
+		dprintk(1, "queue is not empty - append to active\n");
 		prev = list_entry(cx88q->active.prev, struct cx88_buffer, list);
 		list_add_tail(&buf->list, &cx88q->active);
 		prev->risc.jmp[1] = cpu_to_le32(buf->risc.dma);
-		dprintk( 1, "[%p/%d] %s - append to active\n",
+		dprintk(1, "[%p/%d] %s - append to active\n",
 			buf, buf->vb.vb2_buf.index, __func__);
 	}
 }
@@ -291,7 +287,7 @@ static void do_cancel_buffers(struct cx8802_dev *dev)
 
 void cx8802_cancel_buffers(struct cx8802_dev *dev)
 {
-	dprintk( 1, "cx8802_cancel_buffers" );
+	dprintk(1, "\n");
 	cx8802_stop_dma(dev);
 	do_cancel_buffers(dev);
 }
@@ -310,7 +306,7 @@ static void cx8802_mpeg_irq(struct cx8802_dev *dev)
 	struct cx88_core *core = dev->core;
 	u32 status, mask, count;
 
-	dprintk( 1, "cx8802_mpeg_irq\n" );
+	dprintk(1, "\n");
 	status = cx_read(MO_TS_INTSTAT);
 	mask   = cx_read(MO_TS_INTMSK);
 	if (0 == (status & mask))
@@ -319,20 +315,20 @@ static void cx8802_mpeg_irq(struct cx8802_dev *dev)
 	cx_write(MO_TS_INTSTAT, status);
 
 	if (debug || (status & mask & ~0xff))
-		cx88_print_irqbits(core->name, "irq mpeg ",
+		cx88_print_irqbits("irq mpeg ",
 				   cx88_mpeg_irqs, ARRAY_SIZE(cx88_mpeg_irqs),
 				   status, mask);
 
 	/* risc op code error */
 	if (status & (1 << 16)) {
-		printk(KERN_WARNING "%s: mpeg risc op code error\n",core->name);
+		pr_warn("mpeg risc op code error\n");
 		cx_clear(MO_TS_DMACNTRL, 0x11);
 		cx88_sram_channel_dump(dev->core, &cx88_sram_channels[SRAM_CH28]);
 	}
 
 	/* risc1 y */
 	if (status & 0x01) {
-		dprintk( 1, "wake up\n" );
+		dprintk(1, "wake up\n");
 		spin_lock(&dev->slock);
 		count = cx_read(MO_TS_GPCNT);
 		cx88_wakeup(dev->core, &dev->mpegq, count);
@@ -341,7 +337,7 @@ static void cx8802_mpeg_irq(struct cx8802_dev *dev)
 
 	/* other general errors */
 	if (status & 0x1f0100) {
-		dprintk( 0, "general errors: 0x%08x\n", status & 0x1f0100 );
+		dprintk(0, "general errors: 0x%08x\n", status & 0x1f0100);
 		spin_lock(&dev->slock);
 		cx8802_stop_dma(dev);
 		spin_unlock(&dev->slock);
@@ -362,9 +358,9 @@ static irqreturn_t cx8802_irq(int irq, void *dev_id)
 			(core->pci_irqmask | PCI_INT_TSINT);
 		if (0 == status)
 			goto out;
-		dprintk( 1, "cx8802_irq\n" );
-		dprintk( 1, "    loop: %d/%d\n", loop, MAX_IRQ_LOOP );
-		dprintk( 1, "    status: %d\n", status );
+		dprintk(1, "cx8802_irq\n");
+		dprintk(1, "    loop: %d/%d\n", loop, MAX_IRQ_LOOP);
+		dprintk(1, "    status: %d\n", status);
 		handled = 1;
 		cx_write(MO_PCI_INTSTAT, status);
 
@@ -374,9 +370,8 @@ static irqreturn_t cx8802_irq(int irq, void *dev_id)
 			cx8802_mpeg_irq(dev);
 	}
 	if (MAX_IRQ_LOOP == loop) {
-		dprintk( 0, "clearing mask\n" );
-		printk(KERN_WARNING "%s/0: irq loop -- clearing mask\n",
-		       core->name);
+		dprintk(0, "clearing mask\n");
+		pr_warn("irq loop -- clearing mask\n");
 		cx_write(MO_PCI_INTMSK,0);
 	}
 
@@ -395,16 +390,16 @@ static int cx8802_init_common(struct cx8802_dev *dev)
 	pci_set_master(dev->pci);
 	err = pci_set_dma_mask(dev->pci,DMA_BIT_MASK(32));
 	if (err) {
-		printk("%s/2: Oops: no 32bit PCI DMA ???\n",dev->core->name);
+		pr_err("Oops: no 32bit PCI DMA ???\n");
 		return -EIO;
 	}
 
 	dev->pci_rev = dev->pci->revision;
 	pci_read_config_byte(dev->pci, PCI_LATENCY_TIMER,  &dev->pci_lat);
-	printk(KERN_INFO "%s/2: found at %s, rev: %d, irq: %d, latency: %d, mmio: 0x%llx\n",
-	       dev->core->name,
-	       pci_name(dev->pci), dev->pci_rev, dev->pci->irq,
-	       dev->pci_lat,(unsigned long long)pci_resource_start(dev->pci,0));
+	pr_info("found at %s, rev: %d, irq: %d, latency: %d, mmio: 0x%llx\n",
+		pci_name(dev->pci), dev->pci_rev, dev->pci->irq,
+		dev->pci_lat,
+		(unsigned long long)pci_resource_start(dev->pci, 0));
 
 	/* initialize driver struct */
 	spin_lock_init(&dev->slock);
@@ -416,8 +411,7 @@ static int cx8802_init_common(struct cx8802_dev *dev)
 	err = request_irq(dev->pci->irq, cx8802_irq,
 			  IRQF_SHARED, dev->core->name, dev);
 	if (err < 0) {
-		printk(KERN_ERR "%s: can't get IRQ %d\n",
-		       dev->core->name, dev->pci->irq);
+		pr_err("can't get IRQ %d\n", dev->pci->irq);
 		return err;
 	}
 	cx_set(MO_PCI_INTMSK, core->pci_irqmask);
@@ -429,7 +423,7 @@ static int cx8802_init_common(struct cx8802_dev *dev)
 
 static void cx8802_fini_common(struct cx8802_dev *dev)
 {
-	dprintk( 2, "cx8802_fini_common\n" );
+	dprintk(2, "\n");
 	cx8802_stop_dma(dev);
 	pci_disable_device(dev->pci);
 
@@ -442,14 +436,13 @@ static void cx8802_fini_common(struct cx8802_dev *dev)
 static int cx8802_suspend_common(struct pci_dev *pci_dev, pm_message_t state)
 {
 	struct cx8802_dev *dev = pci_get_drvdata(pci_dev);
-	struct cx88_core *core = dev->core;
 	unsigned long flags;
 
 	/* stop mpeg dma */
 	spin_lock_irqsave(&dev->slock, flags);
 	if (!list_empty(&dev->mpegq.active)) {
-		dprintk( 2, "suspend\n" );
-		printk("%s: suspend mpeg\n", core->name);
+		dprintk(2, "suspend\n");
+		pr_info("suspend mpeg\n");
 		cx8802_stop_dma(dev);
 	}
 	spin_unlock_irqrestore(&dev->slock, flags);
@@ -468,23 +461,20 @@ static int cx8802_suspend_common(struct pci_dev *pci_dev, pm_message_t state)
 static int cx8802_resume_common(struct pci_dev *pci_dev)
 {
 	struct cx8802_dev *dev = pci_get_drvdata(pci_dev);
-	struct cx88_core *core = dev->core;
 	unsigned long flags;
 	int err;
 
 	if (dev->state.disabled) {
 		err=pci_enable_device(pci_dev);
 		if (err) {
-			printk(KERN_ERR "%s: can't enable device\n",
-					       dev->core->name);
+			pr_err("can't enable device\n");
 			return err;
 		}
 		dev->state.disabled = 0;
 	}
 	err=pci_set_power_state(pci_dev, PCI_D0);
 	if (err) {
-		printk(KERN_ERR "%s: can't enable device\n",
-					       dev->core->name);
+		pr_err("can't enable device\n");
 		pci_disable_device(pci_dev);
 		dev->state.disabled = 1;
 
@@ -498,7 +488,7 @@ static int cx8802_resume_common(struct pci_dev *pci_dev)
 	/* restart video+vbi capture */
 	spin_lock_irqsave(&dev->slock, flags);
 	if (!list_empty(&dev->mpegq.active)) {
-		printk("%s: resume mpeg\n", core->name);
+		pr_info("resume mpeg\n");
 		cx8802_restart_queue(dev,&dev->mpegq);
 	}
 	spin_unlock_irqrestore(&dev->slock, flags);
@@ -550,7 +540,7 @@ static int cx8802_request_acquire(struct cx8802_driver *drv)
 			drv->advise_acquire(drv);
 		}
 
-		mpeg_dbg(1,"%s() Post acquire GPIO=%x\n", __func__, cx_read(MO_GP0_IO));
+		dprintk(1, "Post acquire GPIO=%x\n", cx_read(MO_GP0_IO));
 	}
 
 	return 0;
@@ -571,7 +561,7 @@ static int cx8802_request_release(struct cx8802_driver *drv)
 
 		drv->advise_release(drv);
 		core->active_type_id = CX88_BOARD_NONE;
-		mpeg_dbg(1,"%s() Post release GPIO=%x\n", __func__, cx_read(MO_GP0_IO));
+		dprintk(1, "Post release GPIO=%x\n", cx_read(MO_GP0_IO));
 	}
 
 	return 0;
@@ -605,24 +595,22 @@ int cx8802_register_driver(struct cx8802_driver *drv)
 	struct cx8802_driver *driver;
 	int err, i = 0;
 
-	printk(KERN_INFO
-	       "cx88/2: registering cx8802 driver, type: %s access: %s\n",
-	       drv->type_id == CX88_MPEG_DVB ? "dvb" : "blackbird",
-	       drv->hw_access == CX8802_DRVCTL_SHARED ? "shared" : "exclusive");
+	pr_info("registering cx8802 driver, type: %s access: %s\n",
+		drv->type_id == CX88_MPEG_DVB ? "dvb" : "blackbird",
+		drv->hw_access == CX8802_DRVCTL_SHARED ? "shared" : "exclusive");
 
 	if ((err = cx8802_check_driver(drv)) != 0) {
-		printk(KERN_ERR "cx88/2: cx8802_driver is invalid\n");
+		pr_err("cx8802_driver is invalid\n");
 		return err;
 	}
 
 	mutex_lock(&cx8802_mutex);
 
 	list_for_each_entry(dev, &cx8802_devlist, devlist) {
-		printk(KERN_INFO
-		       "%s/2: subsystem: %04x:%04x, board: %s [card=%d]\n",
-		       dev->core->name, dev->pci->subsystem_vendor,
-		       dev->pci->subsystem_device, dev->core->board.name,
-		       dev->core->boardnr);
+		pr_info("subsystem: %04x:%04x, board: %s [card=%d]\n",
+			dev->pci->subsystem_vendor,
+			dev->pci->subsystem_device, dev->core->board.name,
+			dev->core->boardnr);
 
 		/* Bring up a new struct for each driver instance */
 		driver = kzalloc(sizeof(*drv),GFP_KERNEL);
@@ -645,9 +633,7 @@ int cx8802_register_driver(struct cx8802_driver *drv)
 			i++;
 			list_add_tail(&driver->drvlist, &dev->drvlist);
 		} else {
-			printk(KERN_ERR
-			       "%s/2: cx8802 probe failed, err = %d\n",
-			       dev->core->name, err);
+			pr_err("cx8802 probe failed, err = %d\n", err);
 		}
 		mutex_unlock(&drv->core->lock);
 	}
@@ -664,19 +650,17 @@ int cx8802_unregister_driver(struct cx8802_driver *drv)
 	struct cx8802_driver *d, *dtmp;
 	int err = 0;
 
-	printk(KERN_INFO
-	       "cx88/2: unregistering cx8802 driver, type: %s access: %s\n",
-	       drv->type_id == CX88_MPEG_DVB ? "dvb" : "blackbird",
-	       drv->hw_access == CX8802_DRVCTL_SHARED ? "shared" : "exclusive");
+	pr_info("unregistering cx8802 driver, type: %s access: %s\n",
+		drv->type_id == CX88_MPEG_DVB ? "dvb" : "blackbird",
+		drv->hw_access == CX8802_DRVCTL_SHARED ? "shared" : "exclusive");
 
 	mutex_lock(&cx8802_mutex);
 
 	list_for_each_entry(dev, &cx8802_devlist, devlist) {
-		printk(KERN_INFO
-		       "%s/2: subsystem: %04x:%04x, board: %s [card=%d]\n",
-		       dev->core->name, dev->pci->subsystem_vendor,
-		       dev->pci->subsystem_device, dev->core->board.name,
-		       dev->core->boardnr);
+		pr_info("subsystem: %04x:%04x, board: %s [card=%d]\n",
+			dev->pci->subsystem_vendor,
+			dev->pci->subsystem_device, dev->core->board.name,
+			dev->core->boardnr);
 
 		mutex_lock(&dev->core->lock);
 
@@ -690,8 +674,8 @@ int cx8802_unregister_driver(struct cx8802_driver *drv)
 				list_del(&d->drvlist);
 				kfree(d);
 			} else
-				printk(KERN_ERR "%s/2: cx8802 driver remove failed (%d)\n",
-				       dev->core->name, err);
+				pr_err("cx8802 driver remove failed (%d)\n",
+				       err);
 		}
 
 		mutex_unlock(&dev->core->lock);
@@ -715,7 +699,7 @@ static int cx8802_probe(struct pci_dev *pci_dev,
 	if (NULL == core)
 		return -EINVAL;
 
-	printk("%s/2: cx2388x 8802 Driver Manager\n", core->name);
+	pr_info("cx2388x 8802 Driver Manager\n");
 
 	err = -ENODEV;
 	if (!core->board.mpeg)
@@ -758,7 +742,7 @@ static void cx8802_remove(struct pci_dev *pci_dev)
 
 	dev = pci_get_drvdata(pci_dev);
 
-	dprintk( 1, "%s\n", __func__);
+	dprintk(1, "%s\n", __func__);
 
 	flush_request_modules(dev);
 
@@ -768,16 +752,15 @@ static void cx8802_remove(struct pci_dev *pci_dev)
 		struct cx8802_driver *drv, *tmp;
 		int err;
 
-		printk(KERN_WARNING "%s/2: Trying to remove cx8802 driver while cx8802 sub-drivers still loaded?!\n",
-		       dev->core->name);
+		pr_warn("Trying to remove cx8802 driver while cx8802 sub-drivers still loaded?!\n");
 
 		list_for_each_entry_safe(drv, tmp, &dev->drvlist, drvlist) {
 			err = drv->remove(drv);
 			if (err == 0) {
 				list_del(&drv->drvlist);
 			} else
-				printk(KERN_ERR "%s/2: cx8802 driver remove failed (%d)\n",
-				       dev->core->name, err);
+				pr_err("cx8802 driver remove failed (%d)\n",
+				       err);
 			kfree(drv);
 		}
 	}
diff --git a/drivers/media/pci/cx88/cx88-tvaudio.c b/drivers/media/pci/cx88/cx88-tvaudio.c
index dd8e6f324204..b1d8680235e6 100644
--- a/drivers/media/pci/cx88/cx88-tvaudio.c
+++ b/drivers/media/pci/cx88/cx88-tvaudio.c
@@ -35,6 +35,8 @@
     Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */
 
+#include "cx88.h"
+
 #include <linux/module.h>
 #include <linux/errno.h>
 #include <linux/freezer.h>
@@ -50,8 +52,6 @@
 #include <linux/delay.h>
 #include <linux/kthread.h>
 
-#include "cx88.h"
-
 static unsigned int audio_debug;
 module_param(audio_debug, int, 0644);
 MODULE_PARM_DESC(audio_debug, "enable debug messages [audio]");
@@ -64,9 +64,11 @@ static unsigned int radio_deemphasis;
 module_param(radio_deemphasis,int,0644);
 MODULE_PARM_DESC(radio_deemphasis, "Radio deemphasis time constant, 0=None, 1=50us (elsewhere), 2=75us (USA)");
 
-#define dprintk(fmt, arg...)	if (audio_debug) \
-	printk(KERN_DEBUG "%s/0: " fmt, core->name , ## arg)
-
+#define dprintk(fmt, arg...) do {				\
+	if (audio_debug)						\
+		printk(KERN_DEBUG pr_fmt("%s: tvaudio:" fmt),		\
+			__func__, ##arg);				\
+} while (0)
 /* ----------------------------------------------------------- */
 
 static const char * const aud_ctl_names[64] = {
@@ -797,8 +799,7 @@ void cx88_set_tvaudio(struct cx88_core *core)
 		break;
 	case WW_NONE:
 	case WW_I2SPT:
-		printk("%s/0: unknown tv audio mode [%d]\n",
-		       core->name, core->tvaudio);
+		pr_info("unknown tv audio mode [%d]\n", core->tvaudio);
 		break;
 	}
 	return;
diff --git a/drivers/media/pci/cx88/cx88-vbi.c b/drivers/media/pci/cx88/cx88-vbi.c
index d3237cf8ffa3..227f0f66e015 100644
--- a/drivers/media/pci/cx88/cx88-vbi.c
+++ b/drivers/media/pci/cx88/cx88-vbi.c
@@ -1,17 +1,21 @@
 /*
  */
+
+#include "cx88.h"
+
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
 
-#include "cx88.h"
-
 static unsigned int vbi_debug;
 module_param(vbi_debug,int,0644);
 MODULE_PARM_DESC(vbi_debug,"enable debug messages [vbi]");
 
-#define dprintk(level,fmt, arg...)	if (vbi_debug >= level) \
-	printk(KERN_DEBUG "%s: " fmt, dev->core->name , ## arg)
+#define dprintk(level, fmt, arg...) do {			\
+	if (vbi_debug >= level)					\
+		printk(KERN_DEBUG pr_fmt("%s: vbi:" fmt),	\
+			__func__, ##arg);			\
+} while (0)
 
 /* ------------------------------------------------------------------ */
 
diff --git a/drivers/media/pci/cx88/cx88-video.c b/drivers/media/pci/cx88/cx88-video.c
index 418e2db40b39..3d349dfb23ff 100644
--- a/drivers/media/pci/cx88/cx88-video.c
+++ b/drivers/media/pci/cx88/cx88-video.c
@@ -25,6 +25,8 @@
  *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#include "cx88.h"
+
 #include <linux/init.h>
 #include <linux/list.h>
 #include <linux/module.h>
@@ -37,7 +39,6 @@
 #include <linux/kthread.h>
 #include <asm/div64.h>
 
-#include "cx88.h"
 #include <media/v4l2-common.h>
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-event.h>
@@ -70,8 +71,12 @@ static unsigned int irq_debug;
 module_param(irq_debug,int,0644);
 MODULE_PARM_DESC(irq_debug,"enable debug messages [IRQ handler]");
 
-#define dprintk(level,fmt, arg...)	if (video_debug >= level) \
-	printk(KERN_DEBUG "%s/0: " fmt, core->name , ## arg)
+#define dprintk(level, fmt, arg...) do {			\
+	if (video_debug >= level)				\
+		printk(KERN_DEBUG pr_fmt("%s: video:" fmt),	\
+			__func__, ##arg);			\
+} while (0)
+
 
 /* ------------------------------------------------------------------- */
 /* static data                                                         */
@@ -414,7 +419,6 @@ static int stop_video_dma(struct cx8800_dev    *dev)
 static int restart_video_queue(struct cx8800_dev    *dev,
 			       struct cx88_dmaqueue *q)
 {
-	struct cx88_core *core = dev->core;
 	struct cx88_buffer *buf;
 
 	if (!list_empty(&q->active)) {
@@ -513,7 +517,6 @@ static void buffer_queue(struct vb2_buffer *vb)
 	struct cx8800_dev *dev = vb->vb2_queue->drv_priv;
 	struct cx88_buffer    *buf = container_of(vbuf, struct cx88_buffer, vb);
 	struct cx88_buffer    *prev;
-	struct cx88_core      *core = dev->core;
 	struct cx88_dmaqueue  *q    = &dev->vidq;
 
 	/* add jump to start */
@@ -1090,13 +1093,13 @@ static void cx8800_vid_irq(struct cx8800_dev *dev)
 		return;
 	cx_write(MO_VID_INTSTAT, status);
 	if (irq_debug  ||  (status & mask & ~0xff))
-		cx88_print_irqbits(core->name, "irq vid",
+		cx88_print_irqbits("irq vid",
 				   cx88_vid_irqs, ARRAY_SIZE(cx88_vid_irqs),
 				   status, mask);
 
 	/* risc op code error */
 	if (status & (1 << 16)) {
-		printk(KERN_WARNING "%s/0: video risc op code error\n",core->name);
+		pr_warn("video risc op code error\n");
 		cx_clear(MO_VID_DMACNTRL, 0x11);
 		cx_clear(VID_CAPTURE_CONTROL, 0x06);
 		cx88_sram_channel_dump(core, &cx88_sram_channels[SRAM_CH21]);
@@ -1140,8 +1143,7 @@ static irqreturn_t cx8800_irq(int irq, void *dev_id)
 			cx8800_vid_irq(dev);
 	}
 	if (10 == loop) {
-		printk(KERN_WARNING "%s/0: irq loop -- clearing mask\n",
-		       core->name);
+		pr_warn("irq loop -- clearing mask\n");
 		cx_write(MO_PCI_INTMSK,0);
 	}
 
@@ -1307,15 +1309,15 @@ static int cx8800_initdev(struct pci_dev *pci_dev,
 	/* print pci info */
 	dev->pci_rev = pci_dev->revision;
 	pci_read_config_byte(pci_dev, PCI_LATENCY_TIMER,  &dev->pci_lat);
-	printk(KERN_INFO "%s/0: found at %s, rev: %d, irq: %d, latency: %d, mmio: 0x%llx\n",
-	       core->name,
-	       pci_name(pci_dev), dev->pci_rev, pci_dev->irq,
-	       dev->pci_lat,(unsigned long long)pci_resource_start(pci_dev,0));
+	pr_info("found at %s, rev: %d, irq: %d, latency: %d, mmio: 0x%llx\n",
+		pci_name(pci_dev), dev->pci_rev, pci_dev->irq,
+		dev->pci_lat,
+		(unsigned long long)pci_resource_start(pci_dev, 0));
 
 	pci_set_master(pci_dev);
 	err = pci_set_dma_mask(pci_dev,DMA_BIT_MASK(32));
 	if (err) {
-		printk("%s/0: Oops: no 32bit PCI DMA ???\n",core->name);
+		pr_err("Oops: no 32bit PCI DMA ???\n");
 		goto fail_core;
 	}
 
@@ -1332,8 +1334,7 @@ static int cx8800_initdev(struct pci_dev *pci_dev,
 	err = request_irq(pci_dev->irq, cx8800_irq,
 			  IRQF_SHARED, core->name, dev);
 	if (err < 0) {
-		printk(KERN_ERR "%s/0: can't get IRQ %d\n",
-		       core->name,pci_dev->irq);
+		pr_err("can't get IRQ %d\n", pci_dev->irq);
 		goto fail_core;
 	}
 	cx_set(MO_PCI_INTMSK, core->pci_irqmask);
@@ -1470,12 +1471,11 @@ static int cx8800_initdev(struct pci_dev *pci_dev,
 	err = video_register_device(&dev->video_dev, VFL_TYPE_GRABBER,
 				    video_nr[core->nr]);
 	if (err < 0) {
-		printk(KERN_ERR "%s/0: can't register video device\n",
-		       core->name);
+		pr_err("can't register video device\n");
 		goto fail_unreg;
 	}
-	printk(KERN_INFO "%s/0: registered device %s [v4l2]\n",
-	       core->name, video_device_node_name(&dev->video_dev));
+	pr_info("registered device %s [v4l2]\n",
+		video_device_node_name(&dev->video_dev));
 
 	cx88_vdev_init(core, dev->pci, &dev->vbi_dev,
 		       &cx8800_vbi_template, "vbi");
@@ -1484,12 +1484,11 @@ static int cx8800_initdev(struct pci_dev *pci_dev,
 	err = video_register_device(&dev->vbi_dev, VFL_TYPE_VBI,
 				    vbi_nr[core->nr]);
 	if (err < 0) {
-		printk(KERN_ERR "%s/0: can't register vbi device\n",
-		       core->name);
+		pr_err("can't register vbi device\n");
 		goto fail_unreg;
 	}
-	printk(KERN_INFO "%s/0: registered device %s\n",
-	       core->name, video_device_node_name(&dev->vbi_dev));
+	pr_info("registered device %s\n",
+		video_device_node_name(&dev->vbi_dev));
 
 	if (core->board.radio.type == CX88_RADIO) {
 		cx88_vdev_init(core, dev->pci, &dev->radio_dev,
@@ -1499,12 +1498,11 @@ static int cx8800_initdev(struct pci_dev *pci_dev,
 		err = video_register_device(&dev->radio_dev, VFL_TYPE_RADIO,
 					    radio_nr[core->nr]);
 		if (err < 0) {
-			printk(KERN_ERR "%s/0: can't register radio device\n",
-			       core->name);
+			pr_err("can't register radio device\n");
 			goto fail_unreg;
 		}
-		printk(KERN_INFO "%s/0: registered device %s\n",
-		       core->name, video_device_node_name(&dev->radio_dev));
+		pr_info("registered device %s\n",
+			video_device_node_name(&dev->radio_dev));
 	}
 
 	/* start tvaudio thread */
@@ -1512,8 +1510,8 @@ static int cx8800_initdev(struct pci_dev *pci_dev,
 		core->kthread = kthread_run(cx88_audio_thread, core, "cx88 tvaudio");
 		if (IS_ERR(core->kthread)) {
 			err = PTR_ERR(core->kthread);
-			printk(KERN_ERR "%s/0: failed to create cx88 audio thread, err=%d\n",
-			       core->name, err);
+			pr_err("failed to create cx88 audio thread, err=%d\n",
+			       err);
 		}
 	}
 	mutex_unlock(&core->lock);
@@ -1571,11 +1569,11 @@ static int cx8800_suspend(struct pci_dev *pci_dev, pm_message_t state)
 	/* stop video+vbi capture */
 	spin_lock_irqsave(&dev->slock, flags);
 	if (!list_empty(&dev->vidq.active)) {
-		printk("%s/0: suspend video\n", core->name);
+		pr_info("suspend video\n");
 		stop_video_dma(dev);
 	}
 	if (!list_empty(&dev->vbiq.active)) {
-		printk("%s/0: suspend vbi\n", core->name);
+		pr_info("suspend vbi\n");
 		cx8800_stop_vbi_dma(dev);
 	}
 	spin_unlock_irqrestore(&dev->slock, flags);
@@ -1603,8 +1601,7 @@ static int cx8800_resume(struct pci_dev *pci_dev)
 	if (dev->state.disabled) {
 		err=pci_enable_device(pci_dev);
 		if (err) {
-			printk(KERN_ERR "%s/0: can't enable device\n",
-			       core->name);
+			pr_err("can't enable device\n");
 			return err;
 		}
 
@@ -1612,7 +1609,7 @@ static int cx8800_resume(struct pci_dev *pci_dev)
 	}
 	err= pci_set_power_state(pci_dev, PCI_D0);
 	if (err) {
-		printk(KERN_ERR "%s/0: can't set power state\n", core->name);
+		pr_err("can't set power state\n");
 		pci_disable_device(pci_dev);
 		dev->state.disabled = 1;
 
@@ -1630,11 +1627,11 @@ static int cx8800_resume(struct pci_dev *pci_dev)
 	/* restart video+vbi capture */
 	spin_lock_irqsave(&dev->slock, flags);
 	if (!list_empty(&dev->vidq.active)) {
-		printk("%s/0: resume video\n", core->name);
+		pr_info("resume video\n");
 		restart_video_queue(dev,&dev->vidq);
 	}
 	if (!list_empty(&dev->vbiq.active)) {
-		printk("%s/0: resume vbi\n", core->name);
+		pr_info("resume vbi\n");
 		cx8800_restart_vbi_queue(dev,&dev->vbiq);
 	}
 	spin_unlock_irqrestore(&dev->slock, flags);
diff --git a/drivers/media/pci/cx88/cx88-vp3054-i2c.c b/drivers/media/pci/cx88/cx88-vp3054-i2c.c
index deede6e25d94..4f47ea2ae344 100644
--- a/drivers/media/pci/cx88/cx88-vp3054-i2c.c
+++ b/drivers/media/pci/cx88/cx88-vp3054-i2c.c
@@ -22,15 +22,15 @@
 
 */
 
+#include "cx88.h"
+#include "cx88-vp3054-i2c.h"
+
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/init.h>
 
 #include <asm/io.h>
 
-#include "cx88.h"
-#include "cx88-vp3054-i2c.h"
-
 MODULE_DESCRIPTION("driver for cx2388x VP3054 design");
 MODULE_AUTHOR("Chris Pascoe <c.pascoe@itee.uq.edu.au>");
 MODULE_LICENSE("GPL");
@@ -133,7 +133,7 @@ int vp3054_i2c_probe(struct cx8802_dev *dev)
 
 	rc = i2c_bit_add_bus(&vp3054_i2c->adap);
 	if (0 != rc) {
-		printk("%s: vp3054_i2c register FAILED\n", core->name);
+		pr_err("vp3054_i2c register FAILED\n");
 
 		kfree(dev->vp3054);
 		dev->vp3054 = NULL;
diff --git a/drivers/media/pci/cx88/cx88.h b/drivers/media/pci/cx88/cx88.h
index ecd4b7bece99..72af83ea405a 100644
--- a/drivers/media/pci/cx88/cx88.h
+++ b/drivers/media/pci/cx88/cx88.h
@@ -19,6 +19,8 @@
  *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/pci.h>
 #include <linux/i2c.h>
 #include <linux/i2c-algo-bit.h>
@@ -614,7 +616,7 @@ struct cx8802_dev {
 
 extern unsigned int cx88_core_debug;
 
-extern void cx88_print_irqbits(const char *name, const char *tag, const char *strings[],
+extern void cx88_print_irqbits(const char *tag, const char *strings[],
 			       int len, u32 bits, u32 mask);
 
 extern int cx88_core_irq(struct cx88_core *core, u32 status);
-- 
2.7.4


