Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:27230 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935196Ab0KQTYi (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Nov 2010 14:24:38 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id oAHJOc2x029258
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 17 Nov 2010 14:24:38 -0500
Received: from pedra (vpn-230-120.phx2.redhat.com [10.3.230.120])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id oAHJC5xR007699
	for <linux-media@vger.kernel.org>; Wed, 17 Nov 2010 14:24:15 -0500
Date: Wed, 17 Nov 2010 17:08:26 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 03/10] [media] rc: rename the remaining things to rc_core
Message-ID: <20101117170826.72c9403b@pedra>
In-Reply-To: <cover.1290020731.git.mchehab@redhat.com>
References: <cover.1290020731.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The Remote Controller subsystem is meant to be used not only by Infra Red
but also for similar types of Remote Controllers. The core is not specific
to Infra Red. As such, rename:
	- ir-core.h to rc-core.h
	- IR_CORE to RC_CORE
	- namespace inside rc-core.c/rc-core.h

To be consistent with the other changes.

No functional change on this patch.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

 delete mode 100644 include/media/ir-core.h
 create mode 100644 include/media/rc-core.h

diff --git a/drivers/media/dvb/dm1105/Kconfig b/drivers/media/dvb/dm1105/Kconfig
index 576f3b7..f3de0a4 100644
--- a/drivers/media/dvb/dm1105/Kconfig
+++ b/drivers/media/dvb/dm1105/Kconfig
@@ -8,7 +8,7 @@ config DVB_DM1105
 	select DVB_CX24116 if !DVB_FE_CUSTOMISE
 	select DVB_SI21XX if !DVB_FE_CUSTOMISE
 	select DVB_DS3000 if !DVB_FE_CUSTOMISE
-	depends on IR_CORE
+	depends on RC_CORE
 	help
 	  Support for cards based on the SDMC DM1105 PCI chip like
 	  DvbWorld 2002
diff --git a/drivers/media/dvb/dm1105/dm1105.c b/drivers/media/dvb/dm1105/dm1105.c
index d1a4385..e9cacf6 100644
--- a/drivers/media/dvb/dm1105/dm1105.c
+++ b/drivers/media/dvb/dm1105/dm1105.c
@@ -27,7 +27,7 @@
 #include <linux/pci.h>
 #include <linux/dma-mapping.h>
 #include <linux/slab.h>
-#include <media/ir-core.h>
+#include <media/rc-core.h>
 
 #include "demux.h"
 #include "dmxdev.h"
diff --git a/drivers/media/dvb/dvb-usb/Kconfig b/drivers/media/dvb/dvb-usb/Kconfig
index 2525d3b..3d48ba0 100644
--- a/drivers/media/dvb/dvb-usb/Kconfig
+++ b/drivers/media/dvb/dvb-usb/Kconfig
@@ -1,6 +1,6 @@
 config DVB_USB
 	tristate "Support for various USB DVB devices"
-	depends on DVB_CORE && USB && I2C && IR_CORE
+	depends on DVB_CORE && USB && I2C && RC_CORE
 	help
 	  By enabling this you will be able to choose the various supported
 	  USB1.1 and USB2.0 DVB devices.
diff --git a/drivers/media/dvb/dvb-usb/dvb-usb.h b/drivers/media/dvb/dvb-usb/dvb-usb.h
index 83aa982..18828cb 100644
--- a/drivers/media/dvb/dvb-usb/dvb-usb.h
+++ b/drivers/media/dvb/dvb-usb/dvb-usb.h
@@ -14,7 +14,7 @@
 #include <linux/usb.h>
 #include <linux/firmware.h>
 #include <linux/mutex.h>
-#include <media/ir-core.h>
+#include <media/rc-core.h>
 
 #include "dvb_frontend.h"
 #include "dvb_demux.h"
diff --git a/drivers/media/dvb/dvb-usb/lmedm04.c b/drivers/media/dvb/dvb-usb/lmedm04.c
index d8f1b15..f0c0308 100644
--- a/drivers/media/dvb/dvb-usb/lmedm04.c
+++ b/drivers/media/dvb/dvb-usb/lmedm04.c
@@ -61,7 +61,7 @@
 #define DVB_USB_LOG_PREFIX "LME2510(C)"
 #include <linux/usb.h>
 #include <linux/usb/input.h>
-#include <media/ir-core.h>
+#include <media/rc-core.h>
 
 #include "dvb-usb.h"
 #include "lmedm04.h"
diff --git a/drivers/media/dvb/mantis/Kconfig b/drivers/media/dvb/mantis/Kconfig
index fd0830e..a13a505 100644
--- a/drivers/media/dvb/mantis/Kconfig
+++ b/drivers/media/dvb/mantis/Kconfig
@@ -1,6 +1,6 @@
 config MANTIS_CORE
 	tristate "Mantis/Hopper PCI bridge based devices"
-	depends on PCI && I2C && INPUT && IR_CORE
+	depends on PCI && I2C && INPUT && RC_CORE
 
 	help
 	  Support for PCI cards based on the Mantis and Hopper PCi bridge.
diff --git a/drivers/media/dvb/mantis/mantis_input.c b/drivers/media/dvb/mantis/mantis_input.c
index 209f211..e030b18 100644
--- a/drivers/media/dvb/mantis/mantis_input.c
+++ b/drivers/media/dvb/mantis/mantis_input.c
@@ -18,7 +18,7 @@
 	Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */
 
-#include <media/ir-core.h>
+#include <media/rc-core.h>
 #include <linux/pci.h>
 
 #include "dmxdev.h"
diff --git a/drivers/media/dvb/siano/Kconfig b/drivers/media/dvb/siano/Kconfig
index e520bce..bc6456e 100644
--- a/drivers/media/dvb/siano/Kconfig
+++ b/drivers/media/dvb/siano/Kconfig
@@ -4,7 +4,7 @@
 
 config SMS_SIANO_MDTV
 	tristate "Siano SMS1xxx based MDTV receiver"
-	depends on DVB_CORE && IR_CORE && HAS_DMA
+	depends on DVB_CORE && RC_CORE && HAS_DMA
 	---help---
 	  Choose Y or M here if you have MDTV receiver with a Siano chipset.
 
diff --git a/drivers/media/dvb/siano/smsir.h b/drivers/media/dvb/siano/smsir.h
index c2f68a4..ae92b3a 100644
--- a/drivers/media/dvb/siano/smsir.h
+++ b/drivers/media/dvb/siano/smsir.h
@@ -28,7 +28,7 @@ along with this program.  If not, see <http://www.gnu.org/licenses/>.
 #define __SMS_IR_H__
 
 #include <linux/input.h>
-#include <media/ir-core.h>
+#include <media/rc-core.h>
 
 #define IR_DEFAULT_TIMEOUT		100
 
diff --git a/drivers/media/dvb/ttpci/Kconfig b/drivers/media/dvb/ttpci/Kconfig
index 0ffd694..44afab2 100644
--- a/drivers/media/dvb/ttpci/Kconfig
+++ b/drivers/media/dvb/ttpci/Kconfig
@@ -97,7 +97,7 @@ config DVB_BUDGET_CI
 	select DVB_LNBP21 if !DVB_FE_CUSTOMISE
 	select DVB_TDA10023 if !DVB_FE_CUSTOMISE
 	select MEDIA_TUNER_TDA827X if !MEDIA_TUNER_CUSTOMISE
-	depends on IR_CORE
+	depends on RC_CORE
 	help
 	  Support for simple SAA7146 based DVB cards
 	  (so called Budget- or Nova-PCI cards) without onboard
diff --git a/drivers/media/dvb/ttpci/budget-ci.c b/drivers/media/dvb/ttpci/budget-ci.c
index 9aca0f3..32caa9b 100644
--- a/drivers/media/dvb/ttpci/budget-ci.c
+++ b/drivers/media/dvb/ttpci/budget-ci.c
@@ -34,7 +34,7 @@
 #include <linux/slab.h>
 #include <linux/interrupt.h>
 #include <linux/spinlock.h>
-#include <media/ir-core.h>
+#include <media/rc-core.h>
 
 #include "budget.h"
 
diff --git a/drivers/media/rc/Kconfig b/drivers/media/rc/Kconfig
index ef19375..42b4feb 100644
--- a/drivers/media/rc/Kconfig
+++ b/drivers/media/rc/Kconfig
@@ -1,16 +1,17 @@
-menuconfig IR_CORE
-	tristate "Infrared remote controller adapters"
+menuconfig RC_CORE
+	tristate "Remote Controller adapters"
 	depends on INPUT
 	default INPUT
 	---help---
 	  Enable support for Remote Controllers on Linux. This is
 	  needed in order to support several video capture adapters.
+	  Currently, all supported devices use InfraRed.
 
 	  Enable this option if you have a video capture board even
 	  if you don't need IR, as otherwise, you may not be able to
 	  compile the driver for your adapter.
 
-if IR_CORE
+if RC_CORE
 
 config LIRC
 	tristate
@@ -27,7 +28,7 @@ source "drivers/media/rc/keymaps/Kconfig"
 
 config IR_NEC_DECODER
 	tristate "Enable IR raw decoder for the NEC protocol"
-	depends on IR_CORE
+	depends on RC_CORE
 	select BITREVERSE
 	default y
 
@@ -37,7 +38,7 @@ config IR_NEC_DECODER
 
 config IR_RC5_DECODER
 	tristate "Enable IR raw decoder for the RC-5 protocol"
-	depends on IR_CORE
+	depends on RC_CORE
 	select BITREVERSE
 	default y
 
@@ -47,7 +48,7 @@ config IR_RC5_DECODER
 
 config IR_RC6_DECODER
 	tristate "Enable IR raw decoder for the RC6 protocol"
-	depends on IR_CORE
+	depends on RC_CORE
 	select BITREVERSE
 	default y
 
@@ -57,7 +58,7 @@ config IR_RC6_DECODER
 
 config IR_JVC_DECODER
 	tristate "Enable IR raw decoder for the JVC protocol"
-	depends on IR_CORE
+	depends on RC_CORE
 	select BITREVERSE
 	default y
 
@@ -67,7 +68,7 @@ config IR_JVC_DECODER
 
 config IR_SONY_DECODER
 	tristate "Enable IR raw decoder for the Sony protocol"
-	depends on IR_CORE
+	depends on RC_CORE
 	default y
 
 	---help---
@@ -76,7 +77,7 @@ config IR_SONY_DECODER
 
 config IR_RC5_SZ_DECODER
 	tristate "Enable IR raw decoder for the RC-5 (streamzap) protocol"
-	depends on IR_CORE
+	depends on RC_CORE
 	select BITREVERSE
 	default y
 
@@ -88,7 +89,7 @@ config IR_RC5_SZ_DECODER
 
 config IR_LIRC_CODEC
 	tristate "Enable IR to LIRC bridge"
-	depends on IR_CORE
+	depends on RC_CORE
 	depends on LIRC
 	default y
 
@@ -99,7 +100,7 @@ config IR_LIRC_CODEC
 config IR_ENE
 	tristate "ENE eHome Receiver/Transceiver (pnp id: ENE0100/ENE02xxx)"
 	depends on PNP
-	depends on IR_CORE
+	depends on RC_CORE
 	---help---
 	   Say Y here to enable support for integrated infrared receiver
 	   /transceiver made by ENE.
@@ -113,7 +114,7 @@ config IR_ENE
 config IR_IMON
 	tristate "SoundGraph iMON Receiver and Display"
 	depends on USB_ARCH_HAS_HCD
-	depends on IR_CORE
+	depends on RC_CORE
 	select USB
 	---help---
 	   Say Y here if you want to use a SoundGraph iMON (aka Antec Veris)
@@ -125,7 +126,7 @@ config IR_IMON
 config IR_MCEUSB
 	tristate "Windows Media Center Ed. eHome Infrared Transceiver"
 	depends on USB_ARCH_HAS_HCD
-	depends on IR_CORE
+	depends on RC_CORE
 	select USB
 	---help---
 	   Say Y here if you want to use a Windows Media Center Edition
@@ -137,7 +138,7 @@ config IR_MCEUSB
 config IR_NUVOTON
 	tristate "Nuvoton w836x7hg Consumer Infrared Transceiver"
 	depends on PNP
-	depends on IR_CORE
+	depends on RC_CORE
 	---help---
 	   Say Y here to enable support for integrated infrared receiver
 	   /transciever made by Nuvoton (formerly Winbond). This chip is
@@ -150,7 +151,7 @@ config IR_NUVOTON
 config IR_STREAMZAP
 	tristate "Streamzap PC Remote IR Receiver"
 	depends on USB_ARCH_HAS_HCD
-	depends on IR_CORE
+	depends on RC_CORE
 	select USB
 	---help---
 	   Say Y here if you want to use a Streamzap PC Remote
@@ -162,7 +163,7 @@ config IR_STREAMZAP
 config IR_WINBOND_CIR
         tristate "Winbond IR remote control"
         depends on X86 && PNP
-	depends on IR_CORE
+	depends on RC_CORE
         select NEW_LEDS
         select LEDS_CLASS
         select LEDS_TRIGGERS
@@ -176,4 +177,4 @@ config IR_WINBOND_CIR
            To compile this driver as a module, choose M here: the module will
 	   be called winbond_cir.
 
-endif #IR_CORE
+endif #RC_CORE
diff --git a/drivers/media/rc/Makefile b/drivers/media/rc/Makefile
index 8c0e4cb..21251ba 100644
--- a/drivers/media/rc/Makefile
+++ b/drivers/media/rc/Makefile
@@ -2,7 +2,7 @@ rc-core-objs	:= rc-main.o rc-raw.o
 
 obj-y += keymaps/
 
-obj-$(CONFIG_IR_CORE) += rc-core.o
+obj-$(CONFIG_RC_CORE) += rc-core.o
 obj-$(CONFIG_LIRC) += lirc_dev.o
 obj-$(CONFIG_IR_NEC_DECODER) += ir-nec-decoder.o
 obj-$(CONFIG_IR_RC5_DECODER) += ir-rc5-decoder.o
diff --git a/drivers/media/rc/ene_ir.c b/drivers/media/rc/ene_ir.c
index 0a4151f..1ace458 100644
--- a/drivers/media/rc/ene_ir.c
+++ b/drivers/media/rc/ene_ir.c
@@ -37,7 +37,7 @@
 #include <linux/interrupt.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
-#include <media/ir-core.h>
+#include <media/rc-core.h>
 #include "ene_ir.h"
 
 static int sample_period;
diff --git a/drivers/media/rc/imon.c b/drivers/media/rc/imon.c
index 8d4b35d..b6ba3c7 100644
--- a/drivers/media/rc/imon.c
+++ b/drivers/media/rc/imon.c
@@ -38,7 +38,7 @@
 #include <linux/input.h>
 #include <linux/usb.h>
 #include <linux/usb/input.h>
-#include <media/ir-core.h>
+#include <media/rc-core.h>
 
 #include <linux/time.h>
 #include <linux/timer.h>
diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
index ceabea6..f9086c5 100644
--- a/drivers/media/rc/ir-lirc-codec.c
+++ b/drivers/media/rc/ir-lirc-codec.c
@@ -16,7 +16,7 @@
 #include <linux/wait.h>
 #include <media/lirc.h>
 #include <media/lirc_dev.h>
-#include <media/ir-core.h>
+#include <media/rc-core.h>
 #include "rc-core-priv.h"
 
 #define LIRCBUF_SIZE 256
diff --git a/drivers/media/rc/keymaps/Kconfig b/drivers/media/rc/keymaps/Kconfig
index 14b22f5..8e615fd 100644
--- a/drivers/media/rc/keymaps/Kconfig
+++ b/drivers/media/rc/keymaps/Kconfig
@@ -1,6 +1,6 @@
 config RC_MAP
 	tristate "Compile Remote Controller keymap modules"
-	depends on IR_CORE
+	depends on RC_CORE
 	default y
 
 	---help---
diff --git a/drivers/media/rc/keymaps/rc-lirc.c b/drivers/media/rc/keymaps/rc-lirc.c
index 43fcf90..9c8577d 100644
--- a/drivers/media/rc/keymaps/rc-lirc.c
+++ b/drivers/media/rc/keymaps/rc-lirc.c
@@ -9,7 +9,7 @@
  * (at your option) any later version.
  */
 
-#include <media/ir-core.h>
+#include <media/rc-core.h>
 
 static struct ir_scancode lirc[] = {
 	{ },
diff --git a/drivers/media/rc/mceusb.c b/drivers/media/rc/mceusb.c
index 968cf1f..057e6c6 100644
--- a/drivers/media/rc/mceusb.c
+++ b/drivers/media/rc/mceusb.c
@@ -36,7 +36,7 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/usb.h>
-#include <media/ir-core.h>
+#include <media/rc-core.h>
 
 #define DRIVER_VERSION	"1.91"
 #define DRIVER_AUTHOR	"Jarod Wilson <jarod@wilsonet.com>"
diff --git a/drivers/media/rc/nuvoton-cir.c b/drivers/media/rc/nuvoton-cir.c
index 0ce328f..bf3f58f 100644
--- a/drivers/media/rc/nuvoton-cir.c
+++ b/drivers/media/rc/nuvoton-cir.c
@@ -32,7 +32,7 @@
 #include <linux/interrupt.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
-#include <media/ir-core.h>
+#include <media/rc-core.h>
 #include <linux/pci_ids.h>
 
 #include "nuvoton-cir.h"
diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
index 3616c32..48065b7 100644
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -18,7 +18,7 @@
 
 #include <linux/slab.h>
 #include <linux/spinlock.h>
-#include <media/ir-core.h>
+#include <media/rc-core.h>
 
 struct ir_raw_handler {
 	struct list_head list;
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 5b67eea..d91b62c 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -12,7 +12,7 @@
  *  GNU General Public License for more details.
  */
 
-#include <media/ir-core.h>
+#include <media/rc-core.h>
 #include <linux/spinlock.h>
 #include <linux/delay.h>
 #include <linux/input.h>
@@ -1103,11 +1103,11 @@ EXPORT_SYMBOL_GPL(rc_unregister_device);
  * Init/exit code for the module. Basically, creates/removes /sys/class/rc
  */
 
-static int __init ir_core_init(void)
+static int __init rc_core_init(void)
 {
 	int rc = class_register(&ir_input_class);
 	if (rc) {
-		printk(KERN_ERR "ir_core: unable to register rc class\n");
+		printk(KERN_ERR "rc_core: unable to register rc class\n");
 		return rc;
 	}
 
@@ -1118,18 +1118,18 @@ static int __init ir_core_init(void)
 	return 0;
 }
 
-static void __exit ir_core_exit(void)
+static void __exit rc_core_exit(void)
 {
 	class_unregister(&ir_input_class);
 	ir_unregister_map(&empty_map);
 }
 
-module_init(ir_core_init);
-module_exit(ir_core_exit);
+module_init(rc_core_init);
+module_exit(rc_core_exit);
 
-int ir_core_debug;    /* ir_debug level (0,1,2) */
-EXPORT_SYMBOL_GPL(ir_core_debug);
-module_param_named(debug, ir_core_debug, int, 0644);
+int rc_core_debug;    /* ir_debug level (0,1,2) */
+EXPORT_SYMBOL_GPL(rc_core_debug);
+module_param_named(debug, rc_core_debug, int, 0644);
 
 MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
 MODULE_LICENSE("GPL");
diff --git a/drivers/media/rc/rc-raw.c b/drivers/media/rc/rc-raw.c
index ab9b1e4..165412f 100644
--- a/drivers/media/rc/rc-raw.c
+++ b/drivers/media/rc/rc-raw.c
@@ -357,7 +357,7 @@ static void init_decoders(struct work_struct *work)
 	load_lirc_codec();
 
 	/* If needed, we may later add some init code. In this case,
-	   it is needed to change the CONFIG_MODULE test at ir-core.h
+	   it is needed to change the CONFIG_MODULE test at rc-core.h
 	 */
 }
 #endif
diff --git a/drivers/media/rc/streamzap.c b/drivers/media/rc/streamzap.c
index 7781910..f72d670 100644
--- a/drivers/media/rc/streamzap.c
+++ b/drivers/media/rc/streamzap.c
@@ -35,7 +35,7 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/usb.h>
-#include <media/ir-core.h>
+#include <media/rc-core.h>
 
 #define DRIVER_VERSION	"1.61"
 #define DRIVER_NAME	"streamzap"
diff --git a/drivers/media/rc/winbond-cir.c b/drivers/media/rc/winbond-cir.c
index 0ee16ec..186de55 100644
--- a/drivers/media/rc/winbond-cir.c
+++ b/drivers/media/rc/winbond-cir.c
@@ -50,7 +50,7 @@
 #include <linux/io.h>
 #include <linux/bitrev.h>
 #include <linux/slab.h>
-#include <media/ir-core.h>
+#include <media/rc-core.h>
 
 #define DRVNAME "winbond-cir"
 
diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index cd1d335..3385f8e 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -96,7 +96,7 @@ config VIDEO_HELPER_CHIPS_AUTO
 
 config VIDEO_IR_I2C
 	tristate "I2C module for IR" if !VIDEO_HELPER_CHIPS_AUTO
-	depends on I2C && IR_CORE
+	depends on I2C && RC_CORE
 	default y
 	---help---
 	  Most boards have an IR chip directly connected via GPIO. However,
diff --git a/drivers/media/video/bt8xx/Kconfig b/drivers/media/video/bt8xx/Kconfig
index 3c7c0a5..7da5c2e 100644
--- a/drivers/media/video/bt8xx/Kconfig
+++ b/drivers/media/video/bt8xx/Kconfig
@@ -4,7 +4,7 @@ config VIDEO_BT848
 	select I2C_ALGOBIT
 	select VIDEO_BTCX
 	select VIDEOBUF_DMA_SG
-	depends on IR_CORE
+	depends on RC_CORE
 	select VIDEO_TUNER
 	select VIDEO_TVEEPROM
 	select VIDEO_MSP3400 if VIDEO_HELPER_CHIPS_AUTO
diff --git a/drivers/media/video/bt8xx/bttvp.h b/drivers/media/video/bt8xx/bttvp.h
index 0bbdd48..b71d04d 100644
--- a/drivers/media/video/bt8xx/bttvp.h
+++ b/drivers/media/video/bt8xx/bttvp.h
@@ -41,7 +41,7 @@
 #include <linux/device.h>
 #include <media/videobuf-dma-sg.h>
 #include <media/tveeprom.h>
-#include <media/ir-core.h>
+#include <media/rc-core.h>
 #include <media/ir-kbd-i2c.h>
 
 #include "bt848.h"
diff --git a/drivers/media/video/cx18/Kconfig b/drivers/media/video/cx18/Kconfig
index f3c3ccb..d9d2f6a 100644
--- a/drivers/media/video/cx18/Kconfig
+++ b/drivers/media/video/cx18/Kconfig
@@ -2,7 +2,7 @@ config VIDEO_CX18
 	tristate "Conexant cx23418 MPEG encoder support"
 	depends on VIDEO_V4L2 && DVB_CORE && PCI && I2C && EXPERIMENTAL
 	select I2C_ALGOBIT
-	depends on IR_CORE
+	depends on RC_CORE
 	select VIDEO_TUNER
 	select VIDEO_TVEEPROM
 	select VIDEO_CX2341X
diff --git a/drivers/media/video/cx231xx/Kconfig b/drivers/media/video/cx231xx/Kconfig
index d6a2350..ae85a7a 100644
--- a/drivers/media/video/cx231xx/Kconfig
+++ b/drivers/media/video/cx231xx/Kconfig
@@ -3,7 +3,7 @@ config VIDEO_CX231XX
 	depends on VIDEO_DEV && I2C
 	select VIDEO_TUNER
 	select VIDEO_TVEEPROM
-	depends on IR_CORE
+	depends on RC_CORE
 	select VIDEOBUF_VMALLOC
 	select VIDEO_CX25840
 	select VIDEO_CX2341X
@@ -16,7 +16,7 @@ config VIDEO_CX231XX
 
 config VIDEO_CX231XX_RC
 	bool "Conexant cx231xx Remote Controller additional support"
-	depends on IR_CORE
+	depends on RC_CORE
 	depends on VIDEO_CX231XX
 	default y
 	---help---
diff --git a/drivers/media/video/cx231xx/cx231xx.h b/drivers/media/video/cx231xx/cx231xx.h
index fcccc9d..87a20ae 100644
--- a/drivers/media/video/cx231xx/cx231xx.h
+++ b/drivers/media/video/cx231xx/cx231xx.h
@@ -34,7 +34,7 @@
 
 #include <media/videobuf-vmalloc.h>
 #include <media/v4l2-device.h>
-#include <media/ir-core.h>
+#include <media/rc-core.h>
 #include <media/ir-kbd-i2c.h>
 #include <media/videobuf-dvb.h>
 
diff --git a/drivers/media/video/cx23885/Kconfig b/drivers/media/video/cx23885/Kconfig
index e1367b3..6b4a516 100644
--- a/drivers/media/video/cx23885/Kconfig
+++ b/drivers/media/video/cx23885/Kconfig
@@ -5,7 +5,7 @@ config VIDEO_CX23885
 	select VIDEO_BTCX
 	select VIDEO_TUNER
 	select VIDEO_TVEEPROM
-	depends on IR_CORE
+	depends on RC_CORE
 	select VIDEOBUF_DVB
 	select VIDEOBUF_DMA_SG
 	select VIDEO_CX25840
diff --git a/drivers/media/video/cx23885/cx23885-input.c b/drivers/media/video/cx23885/cx23885-input.c
index f1bb3a8..e824ba6 100644
--- a/drivers/media/video/cx23885/cx23885-input.c
+++ b/drivers/media/video/cx23885/cx23885-input.c
@@ -36,7 +36,7 @@
  */
 
 #include <linux/slab.h>
-#include <media/ir-core.h>
+#include <media/rc-core.h>
 #include <media/v4l2-subdev.h>
 
 #include "cx23885.h"
diff --git a/drivers/media/video/cx23885/cx23885.h b/drivers/media/video/cx23885/cx23885.h
index f350d88..fd38722 100644
--- a/drivers/media/video/cx23885/cx23885.h
+++ b/drivers/media/video/cx23885/cx23885.h
@@ -30,7 +30,7 @@
 #include <media/tveeprom.h>
 #include <media/videobuf-dma-sg.h>
 #include <media/videobuf-dvb.h>
-#include <media/ir-core.h>
+#include <media/rc-core.h>
 
 #include "btcx-risc.h"
 #include "cx23885-reg.h"
diff --git a/drivers/media/video/cx23885/cx23888-ir.c b/drivers/media/video/cx23885/cx23888-ir.c
index e78e3e4..e37be6f 100644
--- a/drivers/media/video/cx23885/cx23888-ir.c
+++ b/drivers/media/video/cx23885/cx23888-ir.c
@@ -26,7 +26,7 @@
 
 #include <media/v4l2-device.h>
 #include <media/v4l2-chip-ident.h>
-#include <media/ir-core.h>
+#include <media/rc-core.h>
 
 #include "cx23885.h"
 
diff --git a/drivers/media/video/cx25840/cx25840-ir.c b/drivers/media/video/cx25840/cx25840-ir.c
index 97a4e9b..627926f 100644
--- a/drivers/media/video/cx25840/cx25840-ir.c
+++ b/drivers/media/video/cx25840/cx25840-ir.c
@@ -24,7 +24,7 @@
 #include <linux/slab.h>
 #include <linux/kfifo.h>
 #include <media/cx25840.h>
-#include <media/ir-core.h>
+#include <media/rc-core.h>
 
 #include "cx25840-core.h"
 
diff --git a/drivers/media/video/cx88/Kconfig b/drivers/media/video/cx88/Kconfig
index dbae629..5c42abd 100644
--- a/drivers/media/video/cx88/Kconfig
+++ b/drivers/media/video/cx88/Kconfig
@@ -1,6 +1,6 @@
 config VIDEO_CX88
 	tristate "Conexant 2388x (bt878 successor) support"
-	depends on VIDEO_DEV && PCI && I2C && IR_CORE
+	depends on VIDEO_DEV && PCI && I2C && RC_CORE
 	select I2C_ALGOBIT
 	select VIDEO_BTCX
 	select VIDEOBUF_DMA_SG
diff --git a/drivers/media/video/cx88/cx88-input.c b/drivers/media/video/cx88/cx88-input.c
index 3b2ef45..a730338 100644
--- a/drivers/media/video/cx88/cx88-input.c
+++ b/drivers/media/video/cx88/cx88-input.c
@@ -29,7 +29,7 @@
 #include <linux/module.h>
 
 #include "cx88.h"
-#include <media/ir-core.h>
+#include <media/rc-core.h>
 
 #define MODULE_NAME "cx88xx"
 
diff --git a/drivers/media/video/em28xx/Kconfig b/drivers/media/video/em28xx/Kconfig
index 72ea2ba..985100e 100644
--- a/drivers/media/video/em28xx/Kconfig
+++ b/drivers/media/video/em28xx/Kconfig
@@ -3,7 +3,7 @@ config VIDEO_EM28XX
 	depends on VIDEO_DEV && I2C
 	select VIDEO_TUNER
 	select VIDEO_TVEEPROM
-	depends on IR_CORE
+	depends on RC_CORE
 	select VIDEOBUF_VMALLOC
 	select VIDEO_SAA711X if VIDEO_HELPER_CHIPS_AUTO
 	select VIDEO_TVP5150 if VIDEO_HELPER_CHIPS_AUTO
diff --git a/drivers/media/video/em28xx/em28xx.h b/drivers/media/video/em28xx/em28xx.h
index 6a48043..6f2795a 100644
--- a/drivers/media/video/em28xx/em28xx.h
+++ b/drivers/media/video/em28xx/em28xx.h
@@ -33,7 +33,7 @@
 #include <media/videobuf-vmalloc.h>
 #include <media/v4l2-device.h>
 #include <media/ir-kbd-i2c.h>
-#include <media/ir-core.h>
+#include <media/rc-core.h>
 #if defined(CONFIG_VIDEO_EM28XX_DVB) || defined(CONFIG_VIDEO_EM28XX_DVB_MODULE)
 #include <media/videobuf-dvb.h>
 #endif
diff --git a/drivers/media/video/ir-kbd-i2c.c b/drivers/media/video/ir-kbd-i2c.c
index de0060f..83662a4 100644
--- a/drivers/media/video/ir-kbd-i2c.c
+++ b/drivers/media/video/ir-kbd-i2c.c
@@ -46,7 +46,7 @@
 #include <linux/i2c.h>
 #include <linux/workqueue.h>
 
-#include <media/ir-core.h>
+#include <media/rc-core.h>
 #include <media/ir-kbd-i2c.h>
 
 /* ----------------------------------------------------------------------- */
diff --git a/drivers/media/video/ivtv/Kconfig b/drivers/media/video/ivtv/Kconfig
index c4f1980..89f6591 100644
--- a/drivers/media/video/ivtv/Kconfig
+++ b/drivers/media/video/ivtv/Kconfig
@@ -2,7 +2,7 @@ config VIDEO_IVTV
 	tristate "Conexant cx23416/cx23415 MPEG encoder/decoder support"
 	depends on VIDEO_V4L2 && PCI && I2C
 	select I2C_ALGOBIT
-	depends on IR_CORE
+	depends on RC_CORE
 	select VIDEO_TUNER
 	select VIDEO_TVEEPROM
 	select VIDEO_CX2341X
diff --git a/drivers/media/video/saa7134/Kconfig b/drivers/media/video/saa7134/Kconfig
index e03bff9..380f1b2 100644
--- a/drivers/media/video/saa7134/Kconfig
+++ b/drivers/media/video/saa7134/Kconfig
@@ -26,7 +26,7 @@ config VIDEO_SAA7134_ALSA
 
 config VIDEO_SAA7134_RC
 	bool "Philips SAA7134 Remote Controller support"
-	depends on IR_CORE
+	depends on RC_CORE
 	depends on VIDEO_SAA7134
 	default y
 	---help---
diff --git a/drivers/media/video/saa7134/saa7134.h b/drivers/media/video/saa7134/saa7134.h
index c6ef95e..1923f3c 100644
--- a/drivers/media/video/saa7134/saa7134.h
+++ b/drivers/media/video/saa7134/saa7134.h
@@ -37,7 +37,7 @@
 #include <media/v4l2-ioctl.h>
 #include <media/v4l2-device.h>
 #include <media/tuner.h>
-#include <media/ir-core.h>
+#include <media/rc-core.h>
 #include <media/ir-kbd-i2c.h>
 #include <media/videobuf-dma-sg.h>
 #include <sound/core.h>
diff --git a/drivers/media/video/tlg2300/Kconfig b/drivers/media/video/tlg2300/Kconfig
index 580580e..645d915 100644
--- a/drivers/media/video/tlg2300/Kconfig
+++ b/drivers/media/video/tlg2300/Kconfig
@@ -3,7 +3,7 @@ config VIDEO_TLG2300
 	depends on VIDEO_DEV && I2C && SND && DVB_CORE
 	select VIDEO_TUNER
 	select VIDEO_TVEEPROM
-	depends on IR_CORE
+	depends on RC_CORE
 	select VIDEOBUF_VMALLOC
 	select SND_PCM
 	select VIDEOBUF_DVB
diff --git a/drivers/staging/cx25821/Kconfig b/drivers/staging/cx25821/Kconfig
index f8f2bb0..b265695 100644
--- a/drivers/staging/cx25821/Kconfig
+++ b/drivers/staging/cx25821/Kconfig
@@ -5,7 +5,7 @@ config VIDEO_CX25821
 	select I2C_ALGOBIT
 	select VIDEO_BTCX
 	select VIDEO_TVEEPROM
-	depends on IR_CORE
+	depends on RC_CORE
 	select VIDEOBUF_DVB
 	select VIDEOBUF_DMA_SG
 	select VIDEO_CX25840
diff --git a/drivers/staging/go7007/Kconfig b/drivers/staging/go7007/Kconfig
index edc9091..1da57df 100644
--- a/drivers/staging/go7007/Kconfig
+++ b/drivers/staging/go7007/Kconfig
@@ -4,7 +4,7 @@ config VIDEO_GO7007
 	depends on BKL # please fix
 	depends on SND
 	select VIDEOBUF_DMA_SG
-	depends on IR_CORE
+	depends on RC_CORE
 	select VIDEO_TUNER
 	select VIDEO_TVEEPROM
 	select SND_PCM
diff --git a/drivers/staging/tm6000/Kconfig b/drivers/staging/tm6000/Kconfig
index de7ebb9..114eec8 100644
--- a/drivers/staging/tm6000/Kconfig
+++ b/drivers/staging/tm6000/Kconfig
@@ -1,6 +1,6 @@
 config VIDEO_TM6000
 	tristate "TV Master TM5600/6000/6010 driver"
-	depends on VIDEO_DEV && I2C && INPUT && IR_CORE && USB && EXPERIMENTAL
+	depends on VIDEO_DEV && I2C && INPUT && RC_CORE && USB && EXPERIMENTAL
 	select VIDEO_TUNER
 	select MEDIA_TUNER_XC2028
 	select MEDIA_TUNER_XC5000
diff --git a/drivers/staging/tm6000/tm6000-input.c b/drivers/staging/tm6000/tm6000-input.c
index 3517d20..58e93d0 100644
--- a/drivers/staging/tm6000/tm6000-input.c
+++ b/drivers/staging/tm6000/tm6000-input.c
@@ -24,7 +24,7 @@
 #include <linux/input.h>
 #include <linux/usb.h>
 
-#include <media/ir-core.h>
+#include <media/rc-core.h>
 
 #include "tm6000.h"
 #include "tm6000-regs.h"
diff --git a/include/media/ir-core.h b/include/media/ir-core.h
deleted file mode 100644
index c590998..0000000
--- a/include/media/ir-core.h
+++ /dev/null
@@ -1,211 +0,0 @@
-/*
- * Remote Controller core header
- *
- * Copyright (C) 2009-2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
- *
- * This program is free software; you can redistribute it and/or modify
- *  it under the terms of the GNU General Public License as published by
- *  the Free Software Foundation version 2 of the License.
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *  GNU General Public License for more details.
- */
-
-#ifndef _IR_CORE
-#define _IR_CORE
-
-#include <linux/spinlock.h>
-#include <linux/kfifo.h>
-#include <linux/time.h>
-#include <linux/timer.h>
-#include <media/rc-map.h>
-
-extern int ir_core_debug;
-#define IR_dprintk(level, fmt, arg...)	if (ir_core_debug >= level) \
-	printk(KERN_DEBUG "%s: " fmt , __func__, ## arg)
-
-enum rc_driver_type {
-	RC_DRIVER_SCANCODE = 0,	/* Driver or hardware generates a scancode */
-	RC_DRIVER_IR_RAW,	/* Needs a Infra-Red pulse/space decoder */
-};
-
-/**
- * struct rc_dev - represents a remote control device
- * @dev: driver model's view of this device
- * @input_name: name of the input child device
- * @input_phys: physical path to the input child device
- * @input_id: id of the input child device (struct input_id)
- * @driver_name: name of the hardware driver which registered this device
- * @map_name: name of the default keymap
- * @rc_tab: current scan/key table
- * @devno: unique remote control device number
- * @raw: additional data for raw pulse/space devices
- * @input_dev: the input child device used to communicate events to userspace
- * @driver_type: specifies if protocol decoding is done in hardware or software 
- * @idle: used to keep track of RX state
- * @allowed_protos: bitmask with the supported IR_TYPE_* protocols
- * @scanmask: some hardware decoders are not capable of providing the full
- *	scancode to the application. As this is a hardware limit, we can't do
- *	anything with it. Yet, as the same keycode table can be used with other
- *	devices, a mask is provided to allow its usage. Drivers should generally
- *	leave this field in blank
- * @priv: driver-specific data
- * @keylock: protects the remaining members of the struct
- * @keypressed: whether a key is currently pressed
- * @keyup_jiffies: time (in jiffies) when the current keypress should be released
- * @timer_keyup: timer for releasing a keypress
- * @last_keycode: keycode of last keypress
- * @last_scancode: scancode of last keypress
- * @last_toggle: toggle value of last command
- * @timeout: optional time after which device stops sending data
- * @min_timeout: minimum timeout supported by device
- * @max_timeout: maximum timeout supported by device
- * @rx_resolution : resolution (in ns) of input sampler
- * @tx_resolution: resolution (in ns) of output sampler
- * @change_protocol: allow changing the protocol used on hardware decoders
- * @open: callback to allow drivers to enable polling/irq when IR input device
- *	is opened.
- * @close: callback to allow drivers to disable polling/irq when IR input device
- *	is opened.
- * @s_tx_mask: set transmitter mask (for devices with multiple tx outputs)
- * @s_tx_carrier: set transmit carrier frequency
- * @s_tx_duty_cycle: set transmit duty cycle (0% - 100%)
- * @s_rx_carrier: inform driver about carrier it is expected to handle
- * @tx_ir: transmit IR
- * @s_idle: enable/disable hardware idle mode, upon which,
- *	device doesn't interrupt host until it sees IR pulses
- * @s_learning_mode: enable wide band receiver used for learning
- * @s_carrier_report: enable carrier reports
- */
-struct rc_dev {
-	struct device			dev;
-	const char			*input_name;
-	const char			*input_phys;
-	struct input_id			input_id;
-	char				*driver_name;
-	const char			*map_name;
-	struct ir_scancode_table	rc_tab;
-	unsigned long			devno;
-	struct ir_raw_event_ctrl	*raw;
-	struct input_dev		*input_dev;
-	enum rc_driver_type		driver_type;
-	bool				idle;
-	u64				allowed_protos;
-	u32				scanmask;
-	void				*priv;
-	spinlock_t			keylock;
-	bool				keypressed;
-	unsigned long			keyup_jiffies;
-	struct timer_list		timer_keyup;
-	u32				last_keycode;
-	u32				last_scancode;
-	u8				last_toggle;
-	u32				timeout;
-	u32				min_timeout;
-	u32				max_timeout;
-	u32				rx_resolution;
-	u32				tx_resolution;
-	int				(*change_protocol)(struct rc_dev *dev, u64 ir_type);
-	int				(*open)(struct rc_dev *dev);
-	void				(*close)(struct rc_dev *dev);
-	int				(*s_tx_mask)(struct rc_dev *dev, u32 mask);
-	int				(*s_tx_carrier)(struct rc_dev *dev, u32 carrier);
-	int				(*s_tx_duty_cycle)(struct rc_dev *dev, u32 duty_cycle);
-	int				(*s_rx_carrier_range)(struct rc_dev *dev, u32 min, u32 max);
-	int				(*tx_ir)(struct rc_dev *dev, int *txbuf, u32 n);
-	void				(*s_idle)(struct rc_dev *dev, bool enable);
-	int				(*s_learning_mode)(struct rc_dev *dev, int enable);
-	int				(*s_carrier_report) (struct rc_dev *dev, int enable);
-};
-
-enum raw_event_type {
-	IR_SPACE        = (1 << 0),
-	IR_PULSE        = (1 << 1),
-	IR_START_EVENT  = (1 << 2),
-	IR_STOP_EVENT   = (1 << 3),
-};
-
-#define to_rc_dev(d) container_of(d, struct rc_dev, dev)
-
-
-void ir_repeat(struct rc_dev *dev);
-void ir_keydown(struct rc_dev *dev, int scancode, u8 toggle);
-void ir_keydown_notimeout(struct rc_dev *dev, int scancode, u8 toggle);
-void ir_keyup(struct rc_dev *dev);
-u32 ir_g_keycode_from_table(struct rc_dev *dev, u32 scancode);
-
-/* From ir-raw-event.c */
-struct ir_raw_event {
-	union {
-		u32             duration;
-
-		struct {
-			u32     carrier;
-			u8      duty_cycle;
-		};
-	};
-
-	unsigned                pulse:1;
-	unsigned                reset:1;
-	unsigned                timeout:1;
-	unsigned                carrier_report:1;
-};
-
-#define DEFINE_IR_RAW_EVENT(event) \
-	struct ir_raw_event event = { \
-		{ .duration = 0 } , \
-		.pulse = 0, \
-		.reset = 0, \
-		.timeout = 0, \
-		.carrier_report = 0 }
-
-static inline void init_ir_raw_event(struct ir_raw_event *ev)
-{
-	memset(ev, 0, sizeof(*ev));
-}
-
-#define IR_MAX_DURATION         0xFFFFFFFF      /* a bit more than 4 seconds */
-
-struct rc_dev *rc_allocate_device(void);
-void rc_free_device(struct rc_dev *dev);
-int rc_register_device(struct rc_dev *dev);
-void rc_unregister_device(struct rc_dev *dev);
-
-void ir_raw_event_handle(struct rc_dev *dev);
-int ir_raw_event_store(struct rc_dev *dev, struct ir_raw_event *ev);
-int ir_raw_event_store_edge(struct rc_dev *dev, enum raw_event_type type);
-int ir_raw_event_store_with_filter(struct rc_dev *dev,
-				struct ir_raw_event *ev);
-void ir_raw_event_set_idle(struct rc_dev *dev, bool idle);
-
-static inline void ir_raw_event_reset(struct rc_dev *dev)
-{
-	DEFINE_IR_RAW_EVENT(ev);
-	ev.reset = true;
-
-	ir_raw_event_store(dev, &ev);
-	ir_raw_event_handle(dev);
-}
-
-
-/* extract mask bits out of data and pack them into the result */
-static inline u32 ir_extract_bits(u32 data, u32 mask)
-{
-	u32 vbit = 1, value = 0;
-
-	do {
-	    if (mask & 1) {
-		if (data & 1)
-			value |= vbit;
-		vbit <<= 1;
-	    }
-	    data >>= 1;
-	} while (mask >>= 1);
-
-	return value;
-}
-
-
-#endif /* _IR_CORE */
diff --git a/include/media/ir-kbd-i2c.h b/include/media/ir-kbd-i2c.h
index d27505f..f22b359 100644
--- a/include/media/ir-kbd-i2c.h
+++ b/include/media/ir-kbd-i2c.h
@@ -1,7 +1,7 @@
 #ifndef _IR_I2C
 #define _IR_I2C
 
-#include <media/ir-core.h>
+#include <media/rc-core.h>
 
 #define DEFAULT_POLLING_INTERVAL	100	/* ms */
 
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
new file mode 100644
index 0000000..eedb2f0
--- /dev/null
+++ b/include/media/rc-core.h
@@ -0,0 +1,211 @@
+/*
+ * Remote Controller core header
+ *
+ * Copyright (C) 2009-2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation version 2 of the License.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ */
+
+#ifndef _IR_CORE
+#define _IR_CORE
+
+#include <linux/spinlock.h>
+#include <linux/kfifo.h>
+#include <linux/time.h>
+#include <linux/timer.h>
+#include <media/rc-map.h>
+
+extern int rc_core_debug;
+#define IR_dprintk(level, fmt, arg...)	if (rc_core_debug >= level) \
+	printk(KERN_DEBUG "%s: " fmt , __func__, ## arg)
+
+enum rc_driver_type {
+	RC_DRIVER_SCANCODE = 0,	/* Driver or hardware generates a scancode */
+	RC_DRIVER_IR_RAW,	/* Needs a Infra-Red pulse/space decoder */
+};
+
+/**
+ * struct rc_dev - represents a remote control device
+ * @dev: driver model's view of this device
+ * @input_name: name of the input child device
+ * @input_phys: physical path to the input child device
+ * @input_id: id of the input child device (struct input_id)
+ * @driver_name: name of the hardware driver which registered this device
+ * @map_name: name of the default keymap
+ * @rc_tab: current scan/key table
+ * @devno: unique remote control device number
+ * @raw: additional data for raw pulse/space devices
+ * @input_dev: the input child device used to communicate events to userspace
+ * @driver_type: specifies if protocol decoding is done in hardware or software 
+ * @idle: used to keep track of RX state
+ * @allowed_protos: bitmask with the supported IR_TYPE_* protocols
+ * @scanmask: some hardware decoders are not capable of providing the full
+ *	scancode to the application. As this is a hardware limit, we can't do
+ *	anything with it. Yet, as the same keycode table can be used with other
+ *	devices, a mask is provided to allow its usage. Drivers should generally
+ *	leave this field in blank
+ * @priv: driver-specific data
+ * @keylock: protects the remaining members of the struct
+ * @keypressed: whether a key is currently pressed
+ * @keyup_jiffies: time (in jiffies) when the current keypress should be released
+ * @timer_keyup: timer for releasing a keypress
+ * @last_keycode: keycode of last keypress
+ * @last_scancode: scancode of last keypress
+ * @last_toggle: toggle value of last command
+ * @timeout: optional time after which device stops sending data
+ * @min_timeout: minimum timeout supported by device
+ * @max_timeout: maximum timeout supported by device
+ * @rx_resolution : resolution (in ns) of input sampler
+ * @tx_resolution: resolution (in ns) of output sampler
+ * @change_protocol: allow changing the protocol used on hardware decoders
+ * @open: callback to allow drivers to enable polling/irq when IR input device
+ *	is opened.
+ * @close: callback to allow drivers to disable polling/irq when IR input device
+ *	is opened.
+ * @s_tx_mask: set transmitter mask (for devices with multiple tx outputs)
+ * @s_tx_carrier: set transmit carrier frequency
+ * @s_tx_duty_cycle: set transmit duty cycle (0% - 100%)
+ * @s_rx_carrier: inform driver about carrier it is expected to handle
+ * @tx_ir: transmit IR
+ * @s_idle: enable/disable hardware idle mode, upon which,
+ *	device doesn't interrupt host until it sees IR pulses
+ * @s_learning_mode: enable wide band receiver used for learning
+ * @s_carrier_report: enable carrier reports
+ */
+struct rc_dev {
+	struct device			dev;
+	const char			*input_name;
+	const char			*input_phys;
+	struct input_id			input_id;
+	char				*driver_name;
+	const char			*map_name;
+	struct ir_scancode_table	rc_tab;
+	unsigned long			devno;
+	struct ir_raw_event_ctrl	*raw;
+	struct input_dev		*input_dev;
+	enum rc_driver_type		driver_type;
+	bool				idle;
+	u64				allowed_protos;
+	u32				scanmask;
+	void				*priv;
+	spinlock_t			keylock;
+	bool				keypressed;
+	unsigned long			keyup_jiffies;
+	struct timer_list		timer_keyup;
+	u32				last_keycode;
+	u32				last_scancode;
+	u8				last_toggle;
+	u32				timeout;
+	u32				min_timeout;
+	u32				max_timeout;
+	u32				rx_resolution;
+	u32				tx_resolution;
+	int				(*change_protocol)(struct rc_dev *dev, u64 ir_type);
+	int				(*open)(struct rc_dev *dev);
+	void				(*close)(struct rc_dev *dev);
+	int				(*s_tx_mask)(struct rc_dev *dev, u32 mask);
+	int				(*s_tx_carrier)(struct rc_dev *dev, u32 carrier);
+	int				(*s_tx_duty_cycle)(struct rc_dev *dev, u32 duty_cycle);
+	int				(*s_rx_carrier_range)(struct rc_dev *dev, u32 min, u32 max);
+	int				(*tx_ir)(struct rc_dev *dev, int *txbuf, u32 n);
+	void				(*s_idle)(struct rc_dev *dev, bool enable);
+	int				(*s_learning_mode)(struct rc_dev *dev, int enable);
+	int				(*s_carrier_report) (struct rc_dev *dev, int enable);
+};
+
+enum raw_event_type {
+	IR_SPACE        = (1 << 0),
+	IR_PULSE        = (1 << 1),
+	IR_START_EVENT  = (1 << 2),
+	IR_STOP_EVENT   = (1 << 3),
+};
+
+#define to_rc_dev(d) container_of(d, struct rc_dev, dev)
+
+
+void ir_repeat(struct rc_dev *dev);
+void ir_keydown(struct rc_dev *dev, int scancode, u8 toggle);
+void ir_keydown_notimeout(struct rc_dev *dev, int scancode, u8 toggle);
+void ir_keyup(struct rc_dev *dev);
+u32 ir_g_keycode_from_table(struct rc_dev *dev, u32 scancode);
+
+/* From ir-raw-event.c */
+struct ir_raw_event {
+	union {
+		u32             duration;
+
+		struct {
+			u32     carrier;
+			u8      duty_cycle;
+		};
+	};
+
+	unsigned                pulse:1;
+	unsigned                reset:1;
+	unsigned                timeout:1;
+	unsigned                carrier_report:1;
+};
+
+#define DEFINE_IR_RAW_EVENT(event) \
+	struct ir_raw_event event = { \
+		{ .duration = 0 } , \
+		.pulse = 0, \
+		.reset = 0, \
+		.timeout = 0, \
+		.carrier_report = 0 }
+
+static inline void init_ir_raw_event(struct ir_raw_event *ev)
+{
+	memset(ev, 0, sizeof(*ev));
+}
+
+#define IR_MAX_DURATION         0xFFFFFFFF      /* a bit more than 4 seconds */
+
+struct rc_dev *rc_allocate_device(void);
+void rc_free_device(struct rc_dev *dev);
+int rc_register_device(struct rc_dev *dev);
+void rc_unregister_device(struct rc_dev *dev);
+
+void ir_raw_event_handle(struct rc_dev *dev);
+int ir_raw_event_store(struct rc_dev *dev, struct ir_raw_event *ev);
+int ir_raw_event_store_edge(struct rc_dev *dev, enum raw_event_type type);
+int ir_raw_event_store_with_filter(struct rc_dev *dev,
+				struct ir_raw_event *ev);
+void ir_raw_event_set_idle(struct rc_dev *dev, bool idle);
+
+static inline void ir_raw_event_reset(struct rc_dev *dev)
+{
+	DEFINE_IR_RAW_EVENT(ev);
+	ev.reset = true;
+
+	ir_raw_event_store(dev, &ev);
+	ir_raw_event_handle(dev);
+}
+
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
+#endif /* _IR_CORE */
-- 
1.7.1


