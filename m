Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:4538 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878Ab3DNPhK (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Apr 2013 11:37:10 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Sri Deevi <Srinivasa.Deevi@conexant.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [REVIEW PATCH 12/30] cx25821: remove bogus dependencies.
Date: Sun, 14 Apr 2013 17:27:08 +0200
Message-Id: <1365953246-8972-13-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1365953246-8972-1-git-send-email-hverkuil@xs4all.nl>
References: <1365953246-8972-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

This driver doesn't use DVB, RC, cx25840 or tveeprom.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/pci/cx25821/Kconfig         |    7 +------
 drivers/media/pci/cx25821/Makefile        |    3 ---
 drivers/media/pci/cx25821/cx25821-cards.c |   21 ---------------------
 drivers/media/pci/cx25821/cx25821-core.c  |    2 --
 drivers/media/pci/cx25821/cx25821-gpio.c  |    1 +
 drivers/media/pci/cx25821/cx25821-i2c.c   |    3 ++-
 drivers/media/pci/cx25821/cx25821.h       |   11 -----------
 7 files changed, 4 insertions(+), 44 deletions(-)

diff --git a/drivers/media/pci/cx25821/Kconfig b/drivers/media/pci/cx25821/Kconfig
index 4017c94..6439a84 100644
--- a/drivers/media/pci/cx25821/Kconfig
+++ b/drivers/media/pci/cx25821/Kconfig
@@ -1,14 +1,9 @@
 config VIDEO_CX25821
 	tristate "Conexant cx25821 support"
-	depends on DVB_CORE && VIDEO_DEV && PCI && I2C
+	depends on VIDEO_DEV && PCI && I2C
 	select I2C_ALGOBIT
 	select VIDEO_BTCX
-	select VIDEO_TVEEPROM
-	depends on RC_CORE
-	select VIDEOBUF_DVB
 	select VIDEOBUF_DMA_SG
-	select VIDEO_CX25840
-	select VIDEO_CX2341X
 	---help---
 	  This is a video4linux driver for Conexant 25821 based
 	  TV cards.
diff --git a/drivers/media/pci/cx25821/Makefile b/drivers/media/pci/cx25821/Makefile
index caa32b7b..b54a32e 100644
--- a/drivers/media/pci/cx25821/Makefile
+++ b/drivers/media/pci/cx25821/Makefile
@@ -9,6 +9,3 @@ obj-$(CONFIG_VIDEO_CX25821_ALSA) += cx25821-alsa.o
 
 ccflags-y += -Idrivers/media/i2c
 ccflags-y += -Idrivers/media/common
-ccflags-y += -Idrivers/media/tuners
-ccflags-y += -Idrivers/media/dvb-core
-ccflags-y += -Idrivers/media/dvb-frontends
diff --git a/drivers/media/pci/cx25821/cx25821-cards.c b/drivers/media/pci/cx25821/cx25821-cards.c
index c09ec68..2b2f1f4 100644
--- a/drivers/media/pci/cx25821/cx25821-cards.c
+++ b/drivers/media/pci/cx25821/cx25821-cards.c
@@ -26,8 +26,6 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/pci.h>
-#include <linux/delay.h>
-#include <media/cx25840.h>
 
 #include "cx25821.h"
 
@@ -50,22 +48,3 @@ struct cx25821_board cx25821_boards[] = {
 };
 
 const unsigned int cx25821_bcount = ARRAY_SIZE(cx25821_boards);
-
-struct cx25821_subid cx25821_subids[] = {
-	{
-		.subvendor = 0x14f1,
-		.subdevice = 0x0920,
-		.card = CX25821_BOARD,
-	},
-};
-
-void cx25821_card_setup(struct cx25821_dev *dev)
-{
-	static u8 eeprom[256];
-
-	if (dev->i2c_bus[0].i2c_rc == 0) {
-		dev->i2c_bus[0].i2c_client.addr = 0xa0 >> 1;
-		tveeprom_read(&dev->i2c_bus[0].i2c_client, eeprom,
-				sizeof(eeprom));
-	}
-}
diff --git a/drivers/media/pci/cx25821/cx25821-core.c b/drivers/media/pci/cx25821/cx25821-core.c
index 6205ade..82c2db0 100644
--- a/drivers/media/pci/cx25821/cx25821-core.c
+++ b/drivers/media/pci/cx25821/cx25821-core.c
@@ -953,8 +953,6 @@ static int cx25821_dev_setup(struct cx25821_dev *dev)
 	CX25821_INFO("i2c register! bus->i2c_rc = %d\n",
 			dev->i2c_bus[0].i2c_rc);
 
-	cx25821_card_setup(dev);
-
 	if (medusa_video_init(dev) < 0)
 		CX25821_ERR("%s(): Failed to initialize medusa!\n", __func__);
 
diff --git a/drivers/media/pci/cx25821/cx25821-gpio.c b/drivers/media/pci/cx25821/cx25821-gpio.c
index 29e43b0..95e8ddf 100644
--- a/drivers/media/pci/cx25821/cx25821-gpio.c
+++ b/drivers/media/pci/cx25821/cx25821-gpio.c
@@ -20,6 +20,7 @@
  *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#include <linux/module.h>
 #include "cx25821.h"
 
 /********************* GPIO stuffs *********************/
diff --git a/drivers/media/pci/cx25821/cx25821-i2c.c b/drivers/media/pci/cx25821/cx25821-i2c.c
index a8dc945..dca37c7 100644
--- a/drivers/media/pci/cx25821/cx25821-i2c.c
+++ b/drivers/media/pci/cx25821/cx25821-i2c.c
@@ -23,8 +23,9 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
-#include "cx25821.h"
+#include <linux/module.h>
 #include <linux/i2c.h>
+#include "cx25821.h"
 
 static unsigned int i2c_debug;
 module_param(i2c_debug, int, 0644);
diff --git a/drivers/media/pci/cx25821/cx25821.h b/drivers/media/pci/cx25821/cx25821.h
index 033993f..61c6cfc 100644
--- a/drivers/media/pci/cx25821/cx25821.h
+++ b/drivers/media/pci/cx25821/cx25821.h
@@ -33,9 +33,7 @@
 
 #include <media/v4l2-common.h>
 #include <media/v4l2-device.h>
-#include <media/tveeprom.h>
 #include <media/videobuf-dma-sg.h>
-#include <media/videobuf-dvb.h>
 
 #include "btcx-risc.h"
 #include "cx25821-reg.h"
@@ -178,12 +176,6 @@ struct cx25821_board {
 	struct cx25821_input input[CX25821_NR_INPUT];
 };
 
-struct cx25821_subid {
-	u16 subvendor;
-	u16 subdevice;
-	u32 card;
-};
-
 struct cx25821_i2c {
 	struct cx25821_dev *dev;
 
@@ -406,7 +398,6 @@ static inline struct cx25821_dev *get_cx25821(struct v4l2_device *v4l2_dev)
 	v4l2_device_call_all(&dev->v4l2_dev, 0, o, f, ##args)
 
 extern struct cx25821_board cx25821_boards[];
-extern struct cx25821_subid cx25821_subids[];
 
 #define SRAM_CH00  0		/* Video A */
 #define SRAM_CH01  1		/* Video B */
@@ -487,8 +478,6 @@ extern const struct sram_channel cx25821_sram_channels[];
 	pr_info("(%d): " fmt, dev->board, ##args)
 
 extern int cx25821_i2c_register(struct cx25821_i2c *bus);
-extern void cx25821_card_setup(struct cx25821_dev *dev);
-extern int cx25821_ir_init(struct cx25821_dev *dev);
 extern int cx25821_i2c_read(struct cx25821_i2c *bus, u16 reg_addr, int *value);
 extern int cx25821_i2c_write(struct cx25821_i2c *bus, u16 reg_addr, int value);
 extern int cx25821_i2c_unregister(struct cx25821_i2c *bus);
-- 
1.7.10.4

