Return-path: <mchehab@gaivota>
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:35267 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156Ab0KBUR5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Nov 2010 16:17:57 -0400
Subject: [PATCH 3/6] ir-core: more cleanups of ir-functions.c
To: linux-media@vger.kernel.org
From: David =?utf-8?b?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: jarod@wilsonet.com, mchehab@infradead.org
Date: Tue, 02 Nov 2010 21:17:54 +0100
Message-ID: <20101102201754.12010.27662.stgit@localhost.localdomain>
In-Reply-To: <20101102201733.12010.30019.stgit@localhost.localdomain>
References: <20101102201733.12010.30019.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

cx88 only depends on VIDEO_IR because it needs ir_extract_bits().
Move that function to ir-core.h and make it inline.

Lots of drivers had dependencies on VIDEO_IR when they really
wanted IR_CORE.

The only remaining drivers to depend on VIDEO_IR are bt8xx and
saa7134 (ir_rc5_timer_end is the only function exported by
ir-functions).

Rename VIDEO_IR -> IR_LEGACY to give a hint to anyone writing or
converting drivers to IR_CORE that they do not want a dependency
on IR_LEGACY.

Signed-off-by: David Härdeman <david@hardeman.nu>
Acked-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/media/IR/Kconfig              |    2 +-
 drivers/media/IR/Makefile             |    2 +-
 drivers/media/IR/ir-functions.c       |   19 -------------------
 drivers/media/dvb/dm1105/Kconfig      |    3 +--
 drivers/media/dvb/ttpci/Kconfig       |    3 +--
 drivers/media/video/Kconfig           |    2 +-
 drivers/media/video/bt8xx/Kconfig     |    4 ++--
 drivers/media/video/cx18/Kconfig      |    3 +--
 drivers/media/video/cx231xx/Kconfig   |    4 ++--
 drivers/media/video/cx88/Kconfig      |    3 +--
 drivers/media/video/cx88/cx88-input.c |    1 -
 drivers/media/video/em28xx/Kconfig    |    4 ++--
 drivers/media/video/ivtv/Kconfig      |    3 +--
 drivers/media/video/saa7134/Kconfig   |    2 +-
 drivers/media/video/tlg2300/Kconfig   |    4 ++--
 drivers/staging/cx25821/Kconfig       |    4 ++--
 drivers/staging/go7007/Kconfig        |    4 ++--
 include/media/ir-common.h             |    1 -
 include/media/ir-core.h               |   19 +++++++++++++++++++
 19 files changed, 40 insertions(+), 47 deletions(-)

diff --git a/drivers/media/IR/Kconfig b/drivers/media/IR/Kconfig
index aa4163e..20e02a0 100644
--- a/drivers/media/IR/Kconfig
+++ b/drivers/media/IR/Kconfig
@@ -10,7 +10,7 @@ menuconfig IR_CORE
 	  if you don't need IR, as otherwise, you may not be able to
 	  compile the driver for your adapter.
 
-config VIDEO_IR
+config IR_LEGACY
 	tristate
 	depends on IR_CORE
 	default IR_CORE
diff --git a/drivers/media/IR/Makefile b/drivers/media/IR/Makefile
index f9574ad..38873cf 100644
--- a/drivers/media/IR/Makefile
+++ b/drivers/media/IR/Makefile
@@ -4,7 +4,7 @@ ir-core-objs	:= ir-keytable.o ir-sysfs.o ir-raw-event.o rc-map.o
 obj-y += keymaps/
 
 obj-$(CONFIG_IR_CORE) += ir-core.o
-obj-$(CONFIG_VIDEO_IR) += ir-common.o
+obj-$(CONFIG_IR_LEGACY) += ir-common.o
 obj-$(CONFIG_LIRC) += lirc_dev.o
 obj-$(CONFIG_IR_NEC_DECODER) += ir-nec-decoder.o
 obj-$(CONFIG_IR_RC5_DECODER) += ir-rc5-decoder.o
diff --git a/drivers/media/IR/ir-functions.c b/drivers/media/IR/ir-functions.c
index fca734c..ec021c9 100644
--- a/drivers/media/IR/ir-functions.c
+++ b/drivers/media/IR/ir-functions.c
@@ -31,25 +31,6 @@
 MODULE_AUTHOR("Gerd Knorr <kraxel@bytesex.org> [SuSE Labs]");
 MODULE_LICENSE("GPL");
 
-/* -------------------------------------------------------------------------- */
-/* extract mask bits out of data and pack them into the result */
-u32 ir_extract_bits(u32 data, u32 mask)
-{
-	u32 vbit = 1, value = 0;
-
-	do {
-	    if (mask&1) {
-		if (data&1)
-			value |= vbit;
-		vbit<<=1;
-	    }
-	    data>>=1;
-	} while (mask>>=1);
-
-	return value;
-}
-EXPORT_SYMBOL_GPL(ir_extract_bits);
-
 /* RC5 decoding stuff, moved from bttv-input.c to share it with
  * saa7134 */
 
diff --git a/drivers/media/dvb/dm1105/Kconfig b/drivers/media/dvb/dm1105/Kconfig
index a6ceb08..576f3b7 100644
--- a/drivers/media/dvb/dm1105/Kconfig
+++ b/drivers/media/dvb/dm1105/Kconfig
@@ -1,7 +1,6 @@
 config DVB_DM1105
 	tristate "SDMC DM1105 based PCI cards"
 	depends on DVB_CORE && PCI && I2C
-	depends on INPUT
 	select DVB_PLL if !DVB_FE_CUSTOMISE
 	select DVB_STV0299 if !DVB_FE_CUSTOMISE
 	select DVB_STV0288 if !DVB_FE_CUSTOMISE
@@ -9,7 +8,7 @@ config DVB_DM1105
 	select DVB_CX24116 if !DVB_FE_CUSTOMISE
 	select DVB_SI21XX if !DVB_FE_CUSTOMISE
 	select DVB_DS3000 if !DVB_FE_CUSTOMISE
-	depends on VIDEO_IR
+	depends on IR_CORE
 	help
 	  Support for cards based on the SDMC DM1105 PCI chip like
 	  DvbWorld 2002
diff --git a/drivers/media/dvb/ttpci/Kconfig b/drivers/media/dvb/ttpci/Kconfig
index debea8d..0ffd694 100644
--- a/drivers/media/dvb/ttpci/Kconfig
+++ b/drivers/media/dvb/ttpci/Kconfig
@@ -89,7 +89,6 @@ config DVB_BUDGET
 config DVB_BUDGET_CI
 	tristate "Budget cards with onboard CI connector"
 	depends on DVB_BUDGET_CORE && I2C
-	depends on INPUT # due to IR
 	select DVB_STV0297 if !DVB_FE_CUSTOMISE
 	select DVB_STV0299 if !DVB_FE_CUSTOMISE
 	select DVB_TDA1004X if !DVB_FE_CUSTOMISE
@@ -98,7 +97,7 @@ config DVB_BUDGET_CI
 	select DVB_LNBP21 if !DVB_FE_CUSTOMISE
 	select DVB_TDA10023 if !DVB_FE_CUSTOMISE
 	select MEDIA_TUNER_TDA827X if !MEDIA_TUNER_CUSTOMISE
-	depends on VIDEO_IR
+	depends on IR_CORE
 	help
 	  Support for simple SAA7146 based DVB cards
 	  (so called Budget- or Nova-PCI cards) without onboard
diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index ac16e81..9c66f50 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -96,7 +96,7 @@ config VIDEO_HELPER_CHIPS_AUTO
 
 config VIDEO_IR_I2C
 	tristate "I2C module for IR" if !VIDEO_HELPER_CHIPS_AUTO
-	depends on I2C && VIDEO_IR
+	depends on I2C && IR_CORE
 	default y
 	---help---
 	  Most boards have an IR chip directly connected via GPIO. However,
diff --git a/drivers/media/video/bt8xx/Kconfig b/drivers/media/video/bt8xx/Kconfig
index 1a4a89f..659e448 100644
--- a/drivers/media/video/bt8xx/Kconfig
+++ b/drivers/media/video/bt8xx/Kconfig
@@ -1,10 +1,10 @@
 config VIDEO_BT848
 	tristate "BT848 Video For Linux"
-	depends on VIDEO_DEV && PCI && I2C && VIDEO_V4L2 && INPUT
+	depends on VIDEO_DEV && PCI && I2C && VIDEO_V4L2
 	select I2C_ALGOBIT
 	select VIDEO_BTCX
 	select VIDEOBUF_DMA_SG
-	depends on VIDEO_IR
+	depends on IR_LEGACY
 	select VIDEO_TUNER
 	select VIDEO_TVEEPROM
 	select VIDEO_MSP3400 if VIDEO_HELPER_CHIPS_AUTO
diff --git a/drivers/media/video/cx18/Kconfig b/drivers/media/video/cx18/Kconfig
index 76c054d..f3c3ccb 100644
--- a/drivers/media/video/cx18/Kconfig
+++ b/drivers/media/video/cx18/Kconfig
@@ -1,9 +1,8 @@
 config VIDEO_CX18
 	tristate "Conexant cx23418 MPEG encoder support"
 	depends on VIDEO_V4L2 && DVB_CORE && PCI && I2C && EXPERIMENTAL
-	depends on INPUT	# due to VIDEO_IR
 	select I2C_ALGOBIT
-	depends on VIDEO_IR
+	depends on IR_CORE
 	select VIDEO_TUNER
 	select VIDEO_TVEEPROM
 	select VIDEO_CX2341X
diff --git a/drivers/media/video/cx231xx/Kconfig b/drivers/media/video/cx231xx/Kconfig
index bb04914..99f8683 100644
--- a/drivers/media/video/cx231xx/Kconfig
+++ b/drivers/media/video/cx231xx/Kconfig
@@ -1,9 +1,9 @@
 config VIDEO_CX231XX
 	tristate "Conexant cx231xx USB video capture support"
-	depends on VIDEO_DEV && I2C && INPUT
+	depends on VIDEO_DEV && I2C
 	select VIDEO_TUNER
 	select VIDEO_TVEEPROM
-	depends on VIDEO_IR
+	depends on IR_CORE
 	select VIDEOBUF_VMALLOC
 	select VIDEO_CX25840
 	select VIDEO_CX2341X
diff --git a/drivers/media/video/cx88/Kconfig b/drivers/media/video/cx88/Kconfig
index bcfd1ac..dbae629 100644
--- a/drivers/media/video/cx88/Kconfig
+++ b/drivers/media/video/cx88/Kconfig
@@ -1,12 +1,11 @@
 config VIDEO_CX88
 	tristate "Conexant 2388x (bt878 successor) support"
-	depends on VIDEO_DEV && PCI && I2C && INPUT && IR_CORE
+	depends on VIDEO_DEV && PCI && I2C && IR_CORE
 	select I2C_ALGOBIT
 	select VIDEO_BTCX
 	select VIDEOBUF_DMA_SG
 	select VIDEO_TUNER
 	select VIDEO_TVEEPROM
-	depends on VIDEO_IR
 	select VIDEO_WM8775 if VIDEO_HELPER_CHIPS_AUTO
 	---help---
 	  This is a video4linux driver for Conexant 2388x based
diff --git a/drivers/media/video/cx88/cx88-input.c b/drivers/media/video/cx88/cx88-input.c
index 564e3cb..8c41124 100644
--- a/drivers/media/video/cx88/cx88-input.c
+++ b/drivers/media/video/cx88/cx88-input.c
@@ -31,7 +31,6 @@
 
 #include "cx88.h"
 #include <media/ir-core.h>
-#include <media/ir-common.h>
 
 #define MODULE_NAME "cx88xx"
 
diff --git a/drivers/media/video/em28xx/Kconfig b/drivers/media/video/em28xx/Kconfig
index 66aefd6..f363069 100644
--- a/drivers/media/video/em28xx/Kconfig
+++ b/drivers/media/video/em28xx/Kconfig
@@ -1,9 +1,9 @@
 config VIDEO_EM28XX
 	tristate "Empia EM28xx USB video capture support"
-	depends on VIDEO_DEV && I2C && INPUT
+	depends on VIDEO_DEV && I2C
 	select VIDEO_TUNER
 	select VIDEO_TVEEPROM
-	depends on VIDEO_IR
+	depends on IR_CORE
 	select VIDEOBUF_VMALLOC
 	select VIDEO_SAA711X if VIDEO_HELPER_CHIPS_AUTO
 	select VIDEO_TVP5150 if VIDEO_HELPER_CHIPS_AUTO
diff --git a/drivers/media/video/ivtv/Kconfig b/drivers/media/video/ivtv/Kconfig
index be4af1f..c4f1980 100644
--- a/drivers/media/video/ivtv/Kconfig
+++ b/drivers/media/video/ivtv/Kconfig
@@ -1,9 +1,8 @@
 config VIDEO_IVTV
 	tristate "Conexant cx23416/cx23415 MPEG encoder/decoder support"
 	depends on VIDEO_V4L2 && PCI && I2C
-	depends on INPUT   # due to VIDEO_IR
 	select I2C_ALGOBIT
-	depends on VIDEO_IR
+	depends on IR_CORE
 	select VIDEO_TUNER
 	select VIDEO_TVEEPROM
 	select VIDEO_CX2341X
diff --git a/drivers/media/video/saa7134/Kconfig b/drivers/media/video/saa7134/Kconfig
index 3fe71be..32a95a2 100644
--- a/drivers/media/video/saa7134/Kconfig
+++ b/drivers/media/video/saa7134/Kconfig
@@ -26,7 +26,7 @@ config VIDEO_SAA7134_ALSA
 
 config VIDEO_SAA7134_RC
 	bool "Philips SAA7134 Remote Controller support"
-	depends on VIDEO_IR
+	depends on IR_LEGACY
 	depends on VIDEO_SAA7134
 	default y
 	---help---
diff --git a/drivers/media/video/tlg2300/Kconfig b/drivers/media/video/tlg2300/Kconfig
index 1686ebf..580580e 100644
--- a/drivers/media/video/tlg2300/Kconfig
+++ b/drivers/media/video/tlg2300/Kconfig
@@ -1,9 +1,9 @@
 config VIDEO_TLG2300
 	tristate "Telegent TLG2300 USB video capture support"
-	depends on VIDEO_DEV && I2C && INPUT && SND && DVB_CORE
+	depends on VIDEO_DEV && I2C && SND && DVB_CORE
 	select VIDEO_TUNER
 	select VIDEO_TVEEPROM
-	depends on VIDEO_IR
+	depends on IR_CORE
 	select VIDEOBUF_VMALLOC
 	select SND_PCM
 	select VIDEOBUF_DVB
diff --git a/drivers/staging/cx25821/Kconfig b/drivers/staging/cx25821/Kconfig
index 1d73334..f8f2bb0 100644
--- a/drivers/staging/cx25821/Kconfig
+++ b/drivers/staging/cx25821/Kconfig
@@ -1,11 +1,11 @@
 config VIDEO_CX25821
 	tristate "Conexant cx25821 support"
-	depends on DVB_CORE && VIDEO_DEV && PCI && I2C && INPUT
+	depends on DVB_CORE && VIDEO_DEV && PCI && I2C
 	depends on BKL # please fix
 	select I2C_ALGOBIT
 	select VIDEO_BTCX
 	select VIDEO_TVEEPROM
-	depends on VIDEO_IR
+	depends on IR_CORE
 	select VIDEOBUF_DVB
 	select VIDEOBUF_DMA_SG
 	select VIDEO_CX25840
diff --git a/drivers/staging/go7007/Kconfig b/drivers/staging/go7007/Kconfig
index 3aecd30..edc9091 100644
--- a/drivers/staging/go7007/Kconfig
+++ b/drivers/staging/go7007/Kconfig
@@ -1,10 +1,10 @@
 config VIDEO_GO7007
 	tristate "WIS GO7007 MPEG encoder support"
-	depends on VIDEO_DEV && PCI && I2C && INPUT
+	depends on VIDEO_DEV && PCI && I2C
 	depends on BKL # please fix
 	depends on SND
 	select VIDEOBUF_DMA_SG
-	depends on VIDEO_IR
+	depends on IR_CORE
 	select VIDEO_TUNER
 	select VIDEO_TVEEPROM
 	select SND_PCM
diff --git a/include/media/ir-common.h b/include/media/ir-common.h
index 4a32e89..d1ae869 100644
--- a/include/media/ir-common.h
+++ b/include/media/ir-common.h
@@ -73,7 +73,6 @@ struct card_ir {
 };
 
 /* Routines from ir-functions.c */
-u32  ir_extract_bits(u32 data, u32 mask);
 void ir_rc5_timer_end(unsigned long data);
 
 #endif
diff --git a/include/media/ir-core.h b/include/media/ir-core.h
index bff75f2..53048a2 100644
--- a/include/media/ir-core.h
+++ b/include/media/ir-core.h
@@ -212,4 +212,23 @@ static inline void ir_raw_event_reset(struct input_dev *input_dev)
 	ir_raw_event_handle(input_dev);
 }
 
+
+/* extract mask bits out of data and pack them into the result */
+static inline u32 ir_extract_bits(u32 data, u32 mask)
+{
+	u32 vbit = 1, value = 0;
+
+	do {
+	    if (mask & 1) {
+		if (data & 1)
+			value |= vbit;
+		vbit <<= 1;
+	    }
+	    data >>= 1;
+	} while (mask >>= 1);
+
+	return value;
+}
+
+
 #endif /* _IR_CORE */

