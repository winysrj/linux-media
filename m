Return-path: <linux-media-owner@vger.kernel.org>
Received: from resqmta-po-07v.sys.comcast.net ([96.114.154.166]:42185 "EHLO
        resqmta-po-07v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S936099AbcJFX6F (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 6 Oct 2016 19:58:05 -0400
From: Shuah Khan <shuahkh@osg.samsung.com>
To: corbet@lwn.net, broonie@kernel.org, tglx@linutronix.de,
        mmarek@suse.com, mchehab@kernel.org, davem@davemloft.net,
        ecree@solarflare.com, arnd@arndb.de, j.anaszewski@samsung.com,
        akpm@linux-foundation.org, keescook@chromium.org, mingo@kernel.org,
        paulmck@linux.vnet.ibm.com, dan.j.williams@intel.com,
        aryabinin@virtuozzo.com, tj@kernel.org, jpoimboe@redhat.com,
        nikolay@cumulusnetworks.com, dvyukov@google.com, olof@lixom.net,
        nab@linux-iscsi.org, rostedt@goodmis.org, hans.verkuil@cisco.com,
        valentinrothberg@gmail.com, paul.gortmaker@windriver.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-kbuild@vger.kernel.org, linux-media@vger.kernel.org
Subject: [PATCH v2 1/2] samples: move blackfin gptimers-example from Documentation
Date: Thu,  6 Oct 2016 17:48:51 -0600
Message-Id: <52b01f5213600a917875bbf86f4da4d5a428b60b.1475792539.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1475792538.git.shuahkh@osg.samsung.com>
References: <cover.1475792538.git.shuahkh@osg.samsung.com>
In-Reply-To: <cover.1475792538.git.shuahkh@osg.samsung.com>
References: <cover.1475792538.git.shuahkh@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Move blackfin gptimers-example to samples and remove it from Documentation
Makefile. Update samples Kconfig and Makefile to build gptimers-example.

blackfin is the last CONFIG_BUILD_DOCSRC target in Documentation/Makefile.
Hence this patch also includes changes to remove CONFIG_BUILD_DOCSRC from
Makefile and lib/Kconfig.debug and updates VIDEO_PCI_SKELETON dependency
on BUILD_DOCSRC.

Documentation/Makefile is not deleted to avoid braking make htmldocs and
make distclean.

Acked-by: Michal Marek <mmarek@suse.com>
Acked-by: Jonathan Corbet <corbet@lwn.net>
Reviewed-by: Kees Cook <keescook@chromium.org>
Reported-by: Valentin Rothberg <valentinrothberg@gmail.com>
Reported-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 Documentation/Makefile                    |  2 +-
 Documentation/blackfin/00-INDEX           |  4 --
 Documentation/blackfin/Makefile           |  5 --
 Documentation/blackfin/gptimers-example.c | 91 -------------------------------
 Makefile                                  |  3 -
 drivers/media/v4l2-core/Kconfig           |  2 +-
 lib/Kconfig.debug                         |  9 ---
 samples/Kconfig                           |  6 ++
 samples/Makefile                          |  2 +-
 samples/blackfin/Makefile                 |  1 +
 samples/blackfin/gptimers-example.c       | 91 +++++++++++++++++++++++++++++++
 11 files changed, 101 insertions(+), 115 deletions(-)
 delete mode 100644 Documentation/blackfin/Makefile
 delete mode 100644 Documentation/blackfin/gptimers-example.c
 create mode 100644 samples/blackfin/Makefile
 create mode 100644 samples/blackfin/gptimers-example.c

diff --git a/Documentation/Makefile b/Documentation/Makefile
index 8435965..c2a4691 100644
--- a/Documentation/Makefile
+++ b/Documentation/Makefile
@@ -1 +1 @@
-subdir-y := blackfin
+subdir-y :=
diff --git a/Documentation/blackfin/00-INDEX b/Documentation/blackfin/00-INDEX
index c54fcdd..265a1ef 100644
--- a/Documentation/blackfin/00-INDEX
+++ b/Documentation/blackfin/00-INDEX
@@ -1,10 +1,6 @@
 00-INDEX
 	- This file
-Makefile
-	- Makefile for gptimers example file.
 bfin-gpio-notes.txt
 	- Notes in developing/using bfin-gpio driver.
 bfin-spi-notes.txt
 	- Notes for using bfin spi bus driver.
-gptimers-example.c
-	- gptimers example
diff --git a/Documentation/blackfin/Makefile b/Documentation/blackfin/Makefile
deleted file mode 100644
index 6782c58..0000000
--- a/Documentation/blackfin/Makefile
+++ /dev/null
@@ -1,5 +0,0 @@
-ifneq ($(CONFIG_BLACKFIN),)
-ifneq ($(CONFIG_BFIN_GPTIMERS),)
-obj-m := gptimers-example.o
-endif
-endif
diff --git a/Documentation/blackfin/gptimers-example.c b/Documentation/blackfin/gptimers-example.c
deleted file mode 100644
index 283eba9..0000000
--- a/Documentation/blackfin/gptimers-example.c
+++ /dev/null
@@ -1,91 +0,0 @@
-/*
- * Simple gptimers example
- *	http://docs.blackfin.uclinux.org/doku.php?id=linux-kernel:drivers:gptimers
- *
- * Copyright 2007-2009 Analog Devices Inc.
- *
- * Licensed under the GPL-2 or later.
- */
-
-#include <linux/interrupt.h>
-#include <linux/module.h>
-
-#include <asm/gptimers.h>
-#include <asm/portmux.h>
-
-/* ... random driver includes ... */
-
-#define DRIVER_NAME "gptimer_example"
-
-#ifdef IRQ_TIMER5
-#define SAMPLE_IRQ_TIMER IRQ_TIMER5
-#else
-#define SAMPLE_IRQ_TIMER IRQ_TIMER2
-#endif
-
-struct gptimer_data {
-	uint32_t period, width;
-};
-static struct gptimer_data data;
-
-/* ... random driver state ... */
-
-static irqreturn_t gptimer_example_irq(int irq, void *dev_id)
-{
-	struct gptimer_data *data = dev_id;
-
-	/* make sure it was our timer which caused the interrupt */
-	if (!get_gptimer_intr(TIMER5_id))
-		return IRQ_NONE;
-
-	/* read the width/period values that were captured for the waveform */
-	data->width = get_gptimer_pwidth(TIMER5_id);
-	data->period = get_gptimer_period(TIMER5_id);
-
-	/* acknowledge the interrupt */
-	clear_gptimer_intr(TIMER5_id);
-
-	/* tell the upper layers we took care of things */
-	return IRQ_HANDLED;
-}
-
-/* ... random driver code ... */
-
-static int __init gptimer_example_init(void)
-{
-	int ret;
-
-	/* grab the peripheral pins */
-	ret = peripheral_request(P_TMR5, DRIVER_NAME);
-	if (ret) {
-		printk(KERN_NOTICE DRIVER_NAME ": peripheral request failed\n");
-		return ret;
-	}
-
-	/* grab the IRQ for the timer */
-	ret = request_irq(SAMPLE_IRQ_TIMER, gptimer_example_irq,
-			IRQF_SHARED, DRIVER_NAME, &data);
-	if (ret) {
-		printk(KERN_NOTICE DRIVER_NAME ": IRQ request failed\n");
-		peripheral_free(P_TMR5);
-		return ret;
-	}
-
-	/* setup the timer and enable it */
-	set_gptimer_config(TIMER5_id,
-			WDTH_CAP | PULSE_HI | PERIOD_CNT | IRQ_ENA);
-	enable_gptimers(TIMER5bit);
-
-	return 0;
-}
-module_init(gptimer_example_init);
-
-static void __exit gptimer_example_exit(void)
-{
-	disable_gptimers(TIMER5bit);
-	free_irq(SAMPLE_IRQ_TIMER, &data);
-	peripheral_free(P_TMR5);
-}
-module_exit(gptimer_example_exit);
-
-MODULE_LICENSE("BSD");
diff --git a/Makefile b/Makefile
index 1a8c8dd..de5136a 100644
--- a/Makefile
+++ b/Makefile
@@ -926,9 +926,6 @@ vmlinux_prereq: $(vmlinux-deps) FORCE
 ifdef CONFIG_HEADERS_CHECK
 	$(Q)$(MAKE) -f $(srctree)/Makefile headers_check
 endif
-ifdef CONFIG_BUILD_DOCSRC
-	$(Q)$(MAKE) $(build)=Documentation
-endif
 ifdef CONFIG_GDB_SCRIPTS
 	$(Q)ln -fsn `cd $(srctree) && /bin/pwd`/scripts/gdb/vmlinux-gdb.py
 endif
diff --git a/drivers/media/v4l2-core/Kconfig b/drivers/media/v4l2-core/Kconfig
index 29b3436..367523a 100644
--- a/drivers/media/v4l2-core/Kconfig
+++ b/drivers/media/v4l2-core/Kconfig
@@ -27,7 +27,7 @@ config VIDEO_FIXED_MINOR_RANGES
 
 config VIDEO_PCI_SKELETON
 	tristate "Skeleton PCI V4L2 driver"
-	depends on PCI && BUILD_DOCSRC
+	depends on PCI
 	depends on VIDEO_V4L2 && VIDEOBUF2_CORE
 	depends on VIDEOBUF2_MEMOPS && VIDEOBUF2_DMA_CONTIG
 	---help---
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 2e2cca5..ac15feb 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1857,15 +1857,6 @@ config PROVIDE_OHCI1394_DMA_INIT
 
 	  See Documentation/debugging-via-ohci1394.txt for more information.
 
-config BUILD_DOCSRC
-	bool "Build targets in Documentation/ tree"
-	depends on HEADERS_CHECK
-	help
-	  This option attempts to build objects from the source files in the
-	  kernel Documentation/ tree.
-
-	  Say N if you are unsure.
-
 config DMA_API_DEBUG
 	bool "Enable debugging of DMA-API usage"
 	depends on HAVE_DMA_API_DEBUG
diff --git a/samples/Kconfig b/samples/Kconfig
index 85c405f..a6d2a43 100644
--- a/samples/Kconfig
+++ b/samples/Kconfig
@@ -99,4 +99,10 @@ config SAMPLE_SECCOMP
 	  Build samples of seccomp filters using various methods of
 	  BPF filter construction.
 
+config SAMPLE_BLACKFIN_GPTIMERS
+	tristate "Build blackfin gptimers sample code -- loadable modules only"
+	depends on BLACKFIN && BFIN_GPTIMERS && m
+	help
+	  Build samples of blackfin gptimers sample module.
+
 endif # SAMPLES
diff --git a/samples/Makefile b/samples/Makefile
index 1a20169..e17d66d 100644
--- a/samples/Makefile
+++ b/samples/Makefile
@@ -2,4 +2,4 @@
 
 obj-$(CONFIG_SAMPLES)	+= kobject/ kprobes/ trace_events/ livepatch/ \
 			   hw_breakpoint/ kfifo/ kdb/ hidraw/ rpmsg/ seccomp/ \
-			   configfs/ connector/ v4l/ trace_printk/
+			   configfs/ connector/ v4l/ trace_printk/ blackfin/
diff --git a/samples/blackfin/Makefile b/samples/blackfin/Makefile
new file mode 100644
index 0000000..89b86cf
--- /dev/null
+++ b/samples/blackfin/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_SAMPLE_BLACKFIN_GPTIMERS) += gptimers-example.o
diff --git a/samples/blackfin/gptimers-example.c b/samples/blackfin/gptimers-example.c
new file mode 100644
index 0000000..283eba9
--- /dev/null
+++ b/samples/blackfin/gptimers-example.c
@@ -0,0 +1,91 @@
+/*
+ * Simple gptimers example
+ *	http://docs.blackfin.uclinux.org/doku.php?id=linux-kernel:drivers:gptimers
+ *
+ * Copyright 2007-2009 Analog Devices Inc.
+ *
+ * Licensed under the GPL-2 or later.
+ */
+
+#include <linux/interrupt.h>
+#include <linux/module.h>
+
+#include <asm/gptimers.h>
+#include <asm/portmux.h>
+
+/* ... random driver includes ... */
+
+#define DRIVER_NAME "gptimer_example"
+
+#ifdef IRQ_TIMER5
+#define SAMPLE_IRQ_TIMER IRQ_TIMER5
+#else
+#define SAMPLE_IRQ_TIMER IRQ_TIMER2
+#endif
+
+struct gptimer_data {
+	uint32_t period, width;
+};
+static struct gptimer_data data;
+
+/* ... random driver state ... */
+
+static irqreturn_t gptimer_example_irq(int irq, void *dev_id)
+{
+	struct gptimer_data *data = dev_id;
+
+	/* make sure it was our timer which caused the interrupt */
+	if (!get_gptimer_intr(TIMER5_id))
+		return IRQ_NONE;
+
+	/* read the width/period values that were captured for the waveform */
+	data->width = get_gptimer_pwidth(TIMER5_id);
+	data->period = get_gptimer_period(TIMER5_id);
+
+	/* acknowledge the interrupt */
+	clear_gptimer_intr(TIMER5_id);
+
+	/* tell the upper layers we took care of things */
+	return IRQ_HANDLED;
+}
+
+/* ... random driver code ... */
+
+static int __init gptimer_example_init(void)
+{
+	int ret;
+
+	/* grab the peripheral pins */
+	ret = peripheral_request(P_TMR5, DRIVER_NAME);
+	if (ret) {
+		printk(KERN_NOTICE DRIVER_NAME ": peripheral request failed\n");
+		return ret;
+	}
+
+	/* grab the IRQ for the timer */
+	ret = request_irq(SAMPLE_IRQ_TIMER, gptimer_example_irq,
+			IRQF_SHARED, DRIVER_NAME, &data);
+	if (ret) {
+		printk(KERN_NOTICE DRIVER_NAME ": IRQ request failed\n");
+		peripheral_free(P_TMR5);
+		return ret;
+	}
+
+	/* setup the timer and enable it */
+	set_gptimer_config(TIMER5_id,
+			WDTH_CAP | PULSE_HI | PERIOD_CNT | IRQ_ENA);
+	enable_gptimers(TIMER5bit);
+
+	return 0;
+}
+module_init(gptimer_example_init);
+
+static void __exit gptimer_example_exit(void)
+{
+	disable_gptimers(TIMER5bit);
+	free_irq(SAMPLE_IRQ_TIMER, &data);
+	peripheral_free(P_TMR5);
+}
+module_exit(gptimer_example_exit);
+
+MODULE_LICENSE("BSD");
-- 
2.7.4

