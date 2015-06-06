Return-path: <linux-media-owner@vger.kernel.org>
Received: from wp210.webpack.hosteurope.de ([80.237.132.217]:44943 "EHLO
	wp210.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932432AbbFFURu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 6 Jun 2015 16:17:50 -0400
From: =?UTF-8?q?Jan=20Kl=C3=B6tzke?= <jan@kloetzke.net>
To: mchehab@osg.samsung.com, linux-media@vger.kernel.org
Cc: abraham.manu@gmail.com
Subject: [PATCH 5/5] [media] mantis: add remote control support
Date: Sat,  6 Jun 2015 21:58:13 +0200
Message-Id: <1433620693-6235-6-git-send-email-jan@kloetzke.net>
In-Reply-To: <1433620693-6235-1-git-send-email-jan@kloetzke.net>
References: <1433620693-6235-1-git-send-email-jan@kloetzke.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The embedded UART is apparently used to receive decoded IR (RC5?) codes.
Forward these scan codes to the RC framework and (where known) add
corresponding mapping tables to translate them into regular keys.

This patch has been tested on a TechniSat CableStar HD2. The mappings of other
rc-maps were taken from Christoph Pinkl's patch
(http://patchwork.linuxtv.org/patch/7217/) and the s2-liplianin repository. The
major difference to Christoph's patch is a reworked interrupt handling of the
UART because the RX interrupt is apparently level triggered and requires
masking until the FIFO is read by the UART worker.

Signed-off-by: Jan Klötzke <jan@kloetzke.net>
---
 drivers/media/pci/mantis/hopper_cards.c  |  13 +++-
 drivers/media/pci/mantis/mantis_cards.c  |  60 +++++++++++++----
 drivers/media/pci/mantis/mantis_common.h |  33 ++++++++--
 drivers/media/pci/mantis/mantis_dma.c    |   5 +-
 drivers/media/pci/mantis/mantis_i2c.c    |   8 +--
 drivers/media/pci/mantis/mantis_input.c  | 106 +++++--------------------------
 drivers/media/pci/mantis/mantis_input.h  |  28 ++++++++
 drivers/media/pci/mantis/mantis_pcmcia.c |   4 +-
 drivers/media/pci/mantis/mantis_uart.c   |  62 +++++++++---------
 9 files changed, 170 insertions(+), 149 deletions(-)
 create mode 100644 drivers/media/pci/mantis/mantis_input.h

diff --git a/drivers/media/pci/mantis/hopper_cards.c b/drivers/media/pci/mantis/hopper_cards.c
index 104914a..97b7a32 100644
--- a/drivers/media/pci/mantis/hopper_cards.c
+++ b/drivers/media/pci/mantis/hopper_cards.c
@@ -106,6 +106,9 @@ static irqreturn_t hopper_irq_handler(int irq, void *dev_id)
 	}
 	if (stat & MANTIS_INT_IRQ1) {
 		dprintk(MANTIS_DEBUG, 0, "<%s>", label[2]);
+		spin_lock(&mantis->intmask_lock);
+		mmwrite(mmread(MANTIS_INT_MASK) & ~MANTIS_INT_IRQ1, MANTIS_INT_MASK);
+		spin_unlock(&mantis->intmask_lock);
 		schedule_work(&mantis->uart_work);
 	}
 	if (stat & MANTIS_INT_OCERR) {
@@ -154,6 +157,7 @@ static irqreturn_t hopper_irq_handler(int irq, void *dev_id)
 static int hopper_pci_probe(struct pci_dev *pdev,
 			    const struct pci_device_id *pci_id)
 {
+	struct mantis_pci_drvdata *drvdata;
 	struct mantis_pci *mantis;
 	struct mantis_hwconfig *config;
 	int err = 0;
@@ -165,12 +169,16 @@ static int hopper_pci_probe(struct pci_dev *pdev,
 		goto fail0;
 	}
 
+	drvdata			= (struct mantis_pci_drvdata *) pci_id->driver_data;
 	mantis->num		= devs;
 	mantis->verbose		= verbose;
 	mantis->pdev		= pdev;
-	config			= (struct mantis_hwconfig *) pci_id->driver_data;
+	config			= drvdata->hwconfig;
 	config->irq_handler	= &hopper_irq_handler;
 	mantis->hwconfig	= config;
+	mantis->rc_map_name	= drvdata->rc_map_name;
+
+	spin_lock_init(&mantis->intmask_lock);
 
 	err = mantis_pci_init(mantis);
 	if (err) {
@@ -247,7 +255,8 @@ static void hopper_pci_remove(struct pci_dev *pdev)
 }
 
 static struct pci_device_id hopper_pci_table[] = {
-	MAKE_ENTRY(TWINHAN_TECHNOLOGIES, MANTIS_VP_3028_DVB_T, &vp3028_config),
+	MAKE_ENTRY(TWINHAN_TECHNOLOGIES, MANTIS_VP_3028_DVB_T, &vp3028_config,
+		NULL),
 	{ }
 };
 
diff --git a/drivers/media/pci/mantis/mantis_cards.c b/drivers/media/pci/mantis/mantis_cards.c
index 801fc55..9294efe 100644
--- a/drivers/media/pci/mantis/mantis_cards.c
+++ b/drivers/media/pci/mantis/mantis_cards.c
@@ -25,6 +25,7 @@
 #include <linux/slab.h>
 #include <asm/irq.h>
 #include <linux/interrupt.h>
+#include <media/rc-map.h>
 
 #include "dmxdev.h"
 #include "dvbdev.h"
@@ -49,6 +50,7 @@
 #include "mantis_pci.h"
 #include "mantis_i2c.h"
 #include "mantis_reg.h"
+#include "mantis_input.h"
 
 static unsigned int verbose;
 module_param(verbose, int, 0644);
@@ -114,6 +116,9 @@ static irqreturn_t mantis_irq_handler(int irq, void *dev_id)
 	}
 	if (stat & MANTIS_INT_IRQ1) {
 		dprintk(MANTIS_DEBUG, 0, "<%s>", label[2]);
+		spin_lock(&mantis->intmask_lock);
+		mmwrite(mmread(MANTIS_INT_MASK) & ~MANTIS_INT_IRQ1, MANTIS_INT_MASK);
+		spin_unlock(&mantis->intmask_lock);
 		schedule_work(&mantis->uart_work);
 	}
 	if (stat & MANTIS_INT_OCERR) {
@@ -162,6 +167,7 @@ static irqreturn_t mantis_irq_handler(int irq, void *dev_id)
 static int mantis_pci_probe(struct pci_dev *pdev,
 			    const struct pci_device_id *pci_id)
 {
+	struct mantis_pci_drvdata *drvdata;
 	struct mantis_pci *mantis;
 	struct mantis_hwconfig *config;
 	int err = 0;
@@ -173,12 +179,16 @@ static int mantis_pci_probe(struct pci_dev *pdev,
 		goto fail0;
 	}
 
+	drvdata			= (struct mantis_pci_drvdata *) pci_id->driver_data;
 	mantis->num		= devs;
 	mantis->verbose		= verbose;
 	mantis->pdev		= pdev;
-	config			= (struct mantis_hwconfig *) pci_id->driver_data;
+	config			= drvdata->hwconfig;
 	config->irq_handler	= &mantis_irq_handler;
 	mantis->hwconfig	= config;
+	mantis->rc_map_name	= drvdata->rc_map_name;
+
+	spin_lock_init(&mantis->intmask_lock);
 
 	err = mantis_pci_init(mantis);
 	if (err) {
@@ -215,6 +225,13 @@ static int mantis_pci_probe(struct pci_dev *pdev,
 		dprintk(MANTIS_ERROR, 1, "ERROR: Mantis DVB initialization failed <%d>", err);
 		goto fail4;
 	}
+
+	err = mantis_input_init(mantis);
+	if (err < 0) {
+		dprintk(MANTIS_ERROR, 1, "ERROR: Mantis DVB initialization failed <%d>", err);
+		goto fail5;
+	}
+
 	err = mantis_uart_init(mantis);
 	if (err < 0) {
 		dprintk(MANTIS_ERROR, 1, "ERROR: Mantis UART initialization failed <%d>", err);
@@ -230,6 +247,13 @@ static int mantis_pci_probe(struct pci_dev *pdev,
 	mantis_uart_exit(mantis);
 
 fail6:
+	dprintk(MANTIS_ERROR, 1, "ERROR: Mantis INPUT exit! <%d>", err);
+	mantis_input_exit(mantis);
+
+fail5:
+	dprintk(MANTIS_ERROR, 1, "ERROR: Mantis DVB exit! <%d>", err);
+	mantis_dvb_exit(mantis);
+
 fail4:
 	dprintk(MANTIS_ERROR, 1, "ERROR: Mantis DMA exit! <%d>", err);
 	mantis_dma_exit(mantis);
@@ -257,6 +281,7 @@ static void mantis_pci_remove(struct pci_dev *pdev)
 	if (mantis) {
 
 		mantis_uart_exit(mantis);
+		mantis_input_exit(mantis);
 		mantis_dvb_exit(mantis);
 		mantis_dma_exit(mantis);
 		mantis_i2c_exit(mantis);
@@ -267,17 +292,28 @@ static void mantis_pci_remove(struct pci_dev *pdev)
 }
 
 static struct pci_device_id mantis_pci_table[] = {
-	MAKE_ENTRY(TWINHAN_TECHNOLOGIES, MANTIS_VP_1033_DVB_S, &vp1033_config),
-	MAKE_ENTRY(TWINHAN_TECHNOLOGIES, MANTIS_VP_1034_DVB_S, &vp1034_config),
-	MAKE_ENTRY(TWINHAN_TECHNOLOGIES, MANTIS_VP_1041_DVB_S2, &vp1041_config),
-	MAKE_ENTRY(TECHNISAT, SKYSTAR_HD2_10, &vp1041_config),
-	MAKE_ENTRY(TECHNISAT, SKYSTAR_HD2_20, &vp1041_config),
-	MAKE_ENTRY(TERRATEC, CINERGY_S2_PCI_HD, &vp1041_config),
-	MAKE_ENTRY(TWINHAN_TECHNOLOGIES, MANTIS_VP_2033_DVB_C, &vp2033_config),
-	MAKE_ENTRY(TWINHAN_TECHNOLOGIES, MANTIS_VP_2040_DVB_C, &vp2040_config),
-	MAKE_ENTRY(TECHNISAT, CABLESTAR_HD2, &vp2040_config),
-	MAKE_ENTRY(TERRATEC, CINERGY_C, &vp2040_config),
-	MAKE_ENTRY(TWINHAN_TECHNOLOGIES, MANTIS_VP_3030_DVB_T, &vp3030_config),
+	MAKE_ENTRY(TECHNISAT, CABLESTAR_HD2, &vp2040_config,
+		RC_MAP_TECHNISAT_TS35),
+	MAKE_ENTRY(TECHNISAT, SKYSTAR_HD2_10, &vp1041_config,
+		NULL),
+	MAKE_ENTRY(TECHNISAT, SKYSTAR_HD2_20, &vp1041_config,
+		NULL),
+	MAKE_ENTRY(TERRATEC, CINERGY_C, &vp2040_config,
+		RC_MAP_TERRATEC_CINERGY_C_PCI),
+	MAKE_ENTRY(TERRATEC, CINERGY_S2_PCI_HD, &vp1041_config,
+		RC_MAP_TERRATEC_CINERGY_S2_HD),
+	MAKE_ENTRY(TWINHAN_TECHNOLOGIES, MANTIS_VP_1033_DVB_S, &vp1033_config,
+		NULL),
+	MAKE_ENTRY(TWINHAN_TECHNOLOGIES, MANTIS_VP_1034_DVB_S, &vp1034_config,
+		NULL),
+	MAKE_ENTRY(TWINHAN_TECHNOLOGIES, MANTIS_VP_1041_DVB_S2, &vp1041_config,
+		RC_MAP_TWINHAN_DTV_CAB_CI),
+	MAKE_ENTRY(TWINHAN_TECHNOLOGIES, MANTIS_VP_2033_DVB_C, &vp2033_config,
+		RC_MAP_TWINHAN_DTV_CAB_CI),
+	MAKE_ENTRY(TWINHAN_TECHNOLOGIES, MANTIS_VP_2040_DVB_C, &vp2040_config,
+		NULL),
+	MAKE_ENTRY(TWINHAN_TECHNOLOGIES, MANTIS_VP_3030_DVB_T, &vp3030_config,
+		NULL),
 	{ }
 };
 
diff --git a/drivers/media/pci/mantis/mantis_common.h b/drivers/media/pci/mantis/mantis_common.h
index 8ff448b..d48778a 100644
--- a/drivers/media/pci/mantis/mantis_common.h
+++ b/drivers/media/pci/mantis/mantis_common.h
@@ -25,6 +25,7 @@
 #include <linux/mutex.h>
 #include <linux/workqueue.h>
 
+#include "mantis_reg.h"
 #include "mantis_uart.h"
 
 #include "mantis_link.h"
@@ -68,12 +69,13 @@
 #define TECHNISAT		0x1ae4
 #define TERRATEC		0x153b
 
-#define MAKE_ENTRY(__subven, __subdev, __configptr) {			\
+#define MAKE_ENTRY(__subven, __subdev, __configptr, __rc) {		\
 		.vendor		= TWINHAN_TECHNOLOGIES,			\
 		.device		= MANTIS,				\
 		.subvendor	= (__subven),				\
 		.subdevice	= (__subdev),				\
-		.driver_data	= (unsigned long) (__configptr)		\
+		.driver_data	= (unsigned long)			\
+			&(struct mantis_pci_drvdata){__configptr, __rc}	\
 }
 
 enum mantis_i2c_mode {
@@ -101,6 +103,11 @@ struct mantis_hwconfig {
 	enum mantis_i2c_mode	i2c_mode;
 };
 
+struct mantis_pci_drvdata {
+	struct mantis_hwconfig *hwconfig;
+	char *rc_map_name;
+};
+
 struct mantis_pci {
 	unsigned int		verbose;
 
@@ -131,6 +138,7 @@ struct mantis_pci {
 	dma_addr_t		risc_dma;
 
 	struct tasklet_struct	tasklet;
+	spinlock_t		intmask_lock;
 
 	struct i2c_adapter	adapter;
 	int			i2c_rc;
@@ -165,15 +173,32 @@ struct mantis_pci {
 
 	struct mantis_ca	*mantis_ca;
 
-	wait_queue_head_t	uart_wq;
 	struct work_struct	uart_work;
-	spinlock_t		uart_lock;
 
 	struct rc_dev		*rc;
 	char			input_name[80];
 	char			input_phys[80];
+	char			*rc_map_name;
 };
 
 #define MANTIS_HIF_STATUS	(mantis->gpio_status)
 
+static inline void mantis_mask_ints(struct mantis_pci *mantis, u32 mask)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&mantis->intmask_lock, flags);
+	mmwrite(mmread(MANTIS_INT_MASK) & ~mask, MANTIS_INT_MASK);
+	spin_unlock_irqrestore(&mantis->intmask_lock, flags);
+}
+
+static inline void mantis_unmask_ints(struct mantis_pci *mantis, u32 mask)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&mantis->intmask_lock, flags);
+	mmwrite(mmread(MANTIS_INT_MASK) | mask, MANTIS_INT_MASK);
+	spin_unlock_irqrestore(&mantis->intmask_lock, flags);
+}
+
 #endif /* __MANTIS_COMMON_H */
diff --git a/drivers/media/pci/mantis/mantis_dma.c b/drivers/media/pci/mantis/mantis_dma.c
index 566c407..1d59c7e 100644
--- a/drivers/media/pci/mantis/mantis_dma.c
+++ b/drivers/media/pci/mantis/mantis_dma.c
@@ -190,7 +190,7 @@ void mantis_dma_start(struct mantis_pci *mantis)
 	mmwrite(0, MANTIS_DMA_CTL);
 	mantis->last_block = mantis->busy_block = 0;
 
-	mmwrite(mmread(MANTIS_INT_MASK) | MANTIS_INT_RISCI, MANTIS_INT_MASK);
+	mantis_unmask_ints(mantis, MANTIS_INT_RISCI);
 
 	mmwrite(MANTIS_FIFO_EN | MANTIS_DCAP_EN
 			       | MANTIS_RISC_EN, MANTIS_DMA_CTL);
@@ -209,8 +209,7 @@ void mantis_dma_stop(struct mantis_pci *mantis)
 
 	mmwrite(mmread(MANTIS_INT_STAT), MANTIS_INT_STAT);
 
-	mmwrite(mmread(MANTIS_INT_MASK) & ~(MANTIS_INT_RISCI |
-					    MANTIS_INT_RISCEN), MANTIS_INT_MASK);
+	mantis_mask_ints(mantis, MANTIS_INT_RISCI | MANTIS_INT_RISCEN);
 }
 
 
diff --git a/drivers/media/pci/mantis/mantis_i2c.c b/drivers/media/pci/mantis/mantis_i2c.c
index 895ddba..a938234 100644
--- a/drivers/media/pci/mantis/mantis_i2c.c
+++ b/drivers/media/pci/mantis/mantis_i2c.c
@@ -245,8 +245,7 @@ int mantis_i2c_init(struct mantis_pci *mantis)
 	intmask = mmread(MANTIS_INT_MASK);
 	mmwrite(intstat, MANTIS_INT_STAT);
 	dprintk(MANTIS_DEBUG, 1, "Disabling I2C interrupt");
-	intmask = mmread(MANTIS_INT_MASK);
-	mmwrite((intmask & ~MANTIS_INT_I2CDONE), MANTIS_INT_MASK);
+	mantis_mask_ints(mantis, MANTIS_INT_I2CDONE);
 
 	return 0;
 }
@@ -254,11 +253,8 @@ EXPORT_SYMBOL_GPL(mantis_i2c_init);
 
 int mantis_i2c_exit(struct mantis_pci *mantis)
 {
-	u32 intmask;
-
 	dprintk(MANTIS_DEBUG, 1, "Disabling I2C interrupt");
-	intmask = mmread(MANTIS_INT_MASK);
-	mmwrite((intmask & ~MANTIS_INT_I2CDONE), MANTIS_INT_MASK);
+	mantis_mask_ints(mantis, MANTIS_INT_I2CDONE);
 
 	dprintk(MANTIS_DEBUG, 1, "Removing I2C adapter");
 	i2c_del_adapter(&mantis->adapter);
diff --git a/drivers/media/pci/mantis/mantis_input.c b/drivers/media/pci/mantis/mantis_input.c
index 0e5252e..abf0ddf 100644
--- a/drivers/media/pci/mantis/mantis_input.c
+++ b/drivers/media/pci/mantis/mantis_input.c
@@ -18,8 +18,6 @@
 	Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */
 
-#if 0 /* Currently unused */
-
 #include <media/rc-core.h>
 #include <linux/pci.h>
 
@@ -30,100 +28,32 @@
 #include "dvb_net.h"
 
 #include "mantis_common.h"
-#include "mantis_reg.h"
-#include "mantis_uart.h"
+#include "mantis_input.h"
 
 #define MODULE_NAME "mantis_core"
-#define RC_MAP_MANTIS "rc-mantis"
-
-static struct rc_map_table mantis_ir_table[] = {
-	{ 0x29, KEY_POWER	},
-	{ 0x28, KEY_FAVORITES	},
-	{ 0x30, KEY_TEXT	},
-	{ 0x17, KEY_INFO	}, /* Preview */
-	{ 0x23, KEY_EPG		},
-	{ 0x3b, KEY_F22		}, /* Record List */
-	{ 0x3c, KEY_1		},
-	{ 0x3e, KEY_2		},
-	{ 0x39, KEY_3		},
-	{ 0x36, KEY_4		},
-	{ 0x22, KEY_5		},
-	{ 0x20, KEY_6		},
-	{ 0x32, KEY_7		},
-	{ 0x26, KEY_8		},
-	{ 0x24, KEY_9		},
-	{ 0x2a, KEY_0		},
-
-	{ 0x33, KEY_CANCEL	},
-	{ 0x2c, KEY_BACK	},
-	{ 0x15, KEY_CLEAR	},
-	{ 0x3f, KEY_TAB		},
-	{ 0x10, KEY_ENTER	},
-	{ 0x14, KEY_UP		},
-	{ 0x0d, KEY_RIGHT	},
-	{ 0x0e, KEY_DOWN	},
-	{ 0x11, KEY_LEFT	},
-
-	{ 0x21, KEY_VOLUMEUP	},
-	{ 0x35, KEY_VOLUMEDOWN	},
-	{ 0x3d, KEY_CHANNELDOWN	},
-	{ 0x3a, KEY_CHANNELUP	},
-	{ 0x2e, KEY_RECORD	},
-	{ 0x2b, KEY_PLAY	},
-	{ 0x13, KEY_PAUSE	},
-	{ 0x25, KEY_STOP	},
-
-	{ 0x1f, KEY_REWIND	},
-	{ 0x2d, KEY_FASTFORWARD	},
-	{ 0x1e, KEY_PREVIOUS	}, /* Replay |< */
-	{ 0x1d, KEY_NEXT	}, /* Skip   >| */
-
-	{ 0x0b, KEY_CAMERA	}, /* Capture */
-	{ 0x0f, KEY_LANGUAGE	}, /* SAP */
-	{ 0x18, KEY_MODE	}, /* PIP */
-	{ 0x12, KEY_ZOOM	}, /* Full screen */
-	{ 0x1c, KEY_SUBTITLE	},
-	{ 0x2f, KEY_MUTE	},
-	{ 0x16, KEY_F20		}, /* L/R */
-	{ 0x38, KEY_F21		}, /* Hibernate */
-
-	{ 0x37, KEY_SWITCHVIDEOMODE }, /* A/V */
-	{ 0x31, KEY_AGAIN	}, /* Recall */
-	{ 0x1a, KEY_KPPLUS	}, /* Zoom+ */
-	{ 0x19, KEY_KPMINUS	}, /* Zoom- */
-	{ 0x27, KEY_RED		},
-	{ 0x0C, KEY_GREEN	},
-	{ 0x01, KEY_YELLOW	},
-	{ 0x00, KEY_BLUE	},
-};
-
-static struct rc_map_list ir_mantis_map = {
-	.map = {
-		.scan = mantis_ir_table,
-		.size = ARRAY_SIZE(mantis_ir_table),
-		.rc_type = RC_TYPE_UNKNOWN,
-		.name = RC_MAP_MANTIS,
-	}
-};
+
+void mantis_input_process(struct mantis_pci *mantis, int scancode)
+{
+	if (mantis->rc)
+		rc_keydown(mantis->rc, RC_TYPE_UNKNOWN, scancode, 0);
+}
 
 int mantis_input_init(struct mantis_pci *mantis)
 {
 	struct rc_dev *dev;
 	int err;
 
-	err = rc_map_register(&ir_mantis_map);
-	if (err)
-		goto out;
-
 	dev = rc_allocate_device();
 	if (!dev) {
 		dprintk(MANTIS_ERROR, 1, "Remote device allocation failed");
 		err = -ENOMEM;
-		goto out_map;
+		goto out;
 	}
 
-	sprintf(mantis->input_name, "Mantis %s IR receiver", mantis->hwconfig->model_name);
-	sprintf(mantis->input_phys, "pci-%s/ir0", pci_name(mantis->pdev));
+	snprintf(mantis->input_name, sizeof(mantis->input_name),
+		"Mantis %s IR receiver", mantis->hwconfig->model_name);
+	snprintf(mantis->input_phys, sizeof(mantis->input_phys),
+		"pci-%s/ir0", pci_name(mantis->pdev));
 
 	dev->input_name         = mantis->input_name;
 	dev->input_phys         = mantis->input_phys;
@@ -132,7 +62,7 @@ int mantis_input_init(struct mantis_pci *mantis)
 	dev->input_id.product   = mantis->device_id;
 	dev->input_id.version   = 1;
 	dev->driver_name        = MODULE_NAME;
-	dev->map_name           = RC_MAP_MANTIS;
+	dev->map_name           = mantis->rc_map_name ? : RC_MAP_EMPTY;
 	dev->dev.parent         = &mantis->pdev->dev;
 
 	err = rc_register_device(dev);
@@ -146,17 +76,13 @@ int mantis_input_init(struct mantis_pci *mantis)
 
 out_dev:
 	rc_free_device(dev);
-out_map:
-	rc_map_unregister(&ir_mantis_map);
 out:
 	return err;
 }
+EXPORT_SYMBOL_GPL(mantis_input_init);
 
-int mantis_init_exit(struct mantis_pci *mantis)
+void mantis_input_exit(struct mantis_pci *mantis)
 {
 	rc_unregister_device(mantis->rc);
-	rc_map_unregister(&ir_mantis_map);
-	return 0;
 }
-
-#endif
+EXPORT_SYMBOL_GPL(mantis_input_exit);
diff --git a/drivers/media/pci/mantis/mantis_input.h b/drivers/media/pci/mantis/mantis_input.h
new file mode 100644
index 0000000..3bbde8b
--- /dev/null
+++ b/drivers/media/pci/mantis/mantis_input.h
@@ -0,0 +1,28 @@
+/*
+	Mantis PCI bridge driver
+
+	Copyright (C) Manu Abraham (abraham.manu@gmail.com)
+
+	This program is free software; you can redistribute it and/or modify
+	it under the terms of the GNU General Public License as published by
+	the Free Software Foundation; either version 2 of the License, or
+	(at your option) any later version.
+
+	This program is distributed in the hope that it will be useful,
+	but WITHOUT ANY WARRANTY; without even the implied warranty of
+	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+	GNU General Public License for more details.
+
+	You should have received a copy of the GNU General Public License
+	along with this program; if not, write to the Free Software
+	Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+*/
+
+#ifndef __MANTIS_INPUT_H
+#define __MANTIS_INPUT_H
+
+extern int mantis_input_init(struct mantis_pci *mantis);
+extern void mantis_input_exit(struct mantis_pci *mantis);
+extern void mantis_input_process(struct mantis_pci *mantis, int scancode);
+
+#endif /* __MANTIS_UART_H */
diff --git a/drivers/media/pci/mantis/mantis_pcmcia.c b/drivers/media/pci/mantis/mantis_pcmcia.c
index 2f188c0..b2dbc7b 100644
--- a/drivers/media/pci/mantis/mantis_pcmcia.c
+++ b/drivers/media/pci/mantis/mantis_pcmcia.c
@@ -89,7 +89,7 @@ int mantis_pcmcia_init(struct mantis_ca *ca)
 
 	u32 gpif_stat, card_stat;
 
-	mmwrite(mmread(MANTIS_INT_MASK) | MANTIS_INT_IRQ0, MANTIS_INT_MASK);
+	mantis_unmask_ints(mantis, MANTIS_INT_IRQ0);
 	gpif_stat = mmread(MANTIS_GPIF_STATUS);
 	card_stat = mmread(MANTIS_GPIF_IRQCFG);
 
@@ -117,5 +117,5 @@ void mantis_pcmcia_exit(struct mantis_ca *ca)
 	struct mantis_pci *mantis = ca->ca_priv;
 
 	mmwrite(mmread(MANTIS_GPIF_STATUS) & (~MANTIS_CARD_PLUGOUT | ~MANTIS_CARD_PLUGIN), MANTIS_GPIF_STATUS);
-	mmwrite(mmread(MANTIS_INT_MASK) & ~MANTIS_INT_IRQ0, MANTIS_INT_MASK);
+	mantis_mask_ints(mantis, MANTIS_INT_IRQ0);
 }
diff --git a/drivers/media/pci/mantis/mantis_uart.c b/drivers/media/pci/mantis/mantis_uart.c
index a707192..4834109 100644
--- a/drivers/media/pci/mantis/mantis_uart.c
+++ b/drivers/media/pci/mantis/mantis_uart.c
@@ -25,6 +25,7 @@
 #include <linux/signal.h>
 #include <linux/sched.h>
 #include <linux/interrupt.h>
+#include <linux/pci.h>
 
 #include "dmxdev.h"
 #include "dvbdev.h"
@@ -35,6 +36,7 @@
 #include "mantis_common.h"
 #include "mantis_reg.h"
 #include "mantis_uart.h"
+#include "mantis_input.h"
 
 struct mantis_uart_params {
 	enum mantis_baud	baud_rate;
@@ -59,51 +61,53 @@ static struct {
 	{ "EVEN" }
 };
 
-#define UART_MAX_BUF			16
-
-static int mantis_uart_read(struct mantis_pci *mantis, u8 *data)
+static void mantis_uart_read(struct mantis_pci *mantis)
 {
 	struct mantis_hwconfig *config = mantis->hwconfig;
-	u32 stat = 0, i;
+	int i, scancode = 0, err = 0;
 
 	/* get data */
+	dprintk(MANTIS_DEBUG, 1, "UART Reading ...");
 	for (i = 0; i < (config->bytes + 1); i++) {
+		int data = mmread(MANTIS_UART_RXD);
+		dprintk(MANTIS_DEBUG, 0, " <%02x>", data);
 
-		stat = mmread(MANTIS_UART_STAT);
-
-		if (stat & MANTIS_UART_RXFIFO_FULL) {
-			dprintk(MANTIS_ERROR, 1, "RX Fifo FULL");
-		}
-		data[i] = mmread(MANTIS_UART_RXD) & 0x3f;
-
-		dprintk(MANTIS_DEBUG, 1, "Reading ... <%02x>", data[i] & 0x3f);
+		scancode = (scancode << 8) | (data & 0x3f);
+		err |= data;
 
-		if (data[i] & (1 << 7)) {
+		if (data & (1 << 7))
 			dprintk(MANTIS_ERROR, 1, "UART framing error");
-			return -EINVAL;
-		}
-		if (data[i] & (1 << 6)) {
+
+		if (data & (1 << 6))
 			dprintk(MANTIS_ERROR, 1, "UART parity error");
-			return -EINVAL;
-		}
 	}
+	dprintk(MANTIS_DEBUG, 0, "\n");
 
-	return 0;
+	if ((err & 0xC0) == 0)
+		mantis_input_process(mantis, scancode);
 }
 
 static void mantis_uart_work(struct work_struct *work)
 {
 	struct mantis_pci *mantis = container_of(work, struct mantis_pci, uart_work);
-	struct mantis_hwconfig *config = mantis->hwconfig;
-	u8 buf[16];
-	int i;
+	u32 stat;
 
-	mantis_uart_read(mantis, buf);
+	stat = mmread(MANTIS_UART_STAT);
 
-	for (i = 0; i < (config->bytes + 1); i++)
-		dprintk(MANTIS_INFO, 1, "UART BUF:%d <%02x> ", i, buf[i]);
+	if (stat & MANTIS_UART_RXFIFO_FULL)
+		dprintk(MANTIS_ERROR, 1, "RX Fifo FULL");
 
-	dprintk(MANTIS_DEBUG, 0, "\n");
+	/*
+	 * MANTIS_UART_RXFIFO_DATA is only set if at least config->bytes + 1 bytes
+	 * are in the FIFO.
+	 */
+	while (stat & MANTIS_UART_RXFIFO_DATA) {
+		mantis_uart_read(mantis);
+		stat = mmread(MANTIS_UART_STAT);
+	}
+
+	/* re-enable UART (RX) interrupt */
+	mantis_unmask_ints(mantis, MANTIS_INT_IRQ1);
 }
 
 static int mantis_uart_setup(struct mantis_pci *mantis,
@@ -152,9 +156,6 @@ int mantis_uart_init(struct mantis_pci *mantis)
 		rates[params.baud_rate].string,
 		parity[params.parity].string);
 
-	init_waitqueue_head(&mantis->uart_wq);
-	spin_lock_init(&mantis->uart_lock);
-
 	INIT_WORK(&mantis->uart_work, mantis_uart_work);
 
 	/* disable interrupt */
@@ -169,8 +170,8 @@ int mantis_uart_init(struct mantis_pci *mantis)
 	mmwrite((mmread(MANTIS_UART_CTL) | MANTIS_UART_RXFLUSH), MANTIS_UART_CTL);
 
 	/* enable interrupt */
-	mmwrite(mmread(MANTIS_INT_MASK) | 0x800, MANTIS_INT_MASK);
 	mmwrite(mmread(MANTIS_UART_CTL) | MANTIS_UART_RXINT, MANTIS_UART_CTL);
+	mantis_unmask_ints(mantis, MANTIS_INT_IRQ1);
 
 	schedule_work(&mantis->uart_work);
 	dprintk(MANTIS_DEBUG, 1, "UART successfully initialized");
@@ -182,6 +183,7 @@ EXPORT_SYMBOL_GPL(mantis_uart_init);
 void mantis_uart_exit(struct mantis_pci *mantis)
 {
 	/* disable interrupt */
+	mantis_mask_ints(mantis, MANTIS_INT_IRQ1);
 	mmwrite(mmread(MANTIS_UART_CTL) & 0xffef, MANTIS_UART_CTL);
 	flush_work(&mantis->uart_work);
 }
-- 
2.1.4

