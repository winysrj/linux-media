Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54886 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758683Ab0DAR6M (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 1 Apr 2010 13:58:12 -0400
Date: Thu, 1 Apr 2010 14:56:31 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: linux-input@vger.kernel.org,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 14/15] V4L/DVB: cx88: Only start IR if the input device is
 opened
Message-ID: <20100401145631.60201d22@pedra>
In-Reply-To: <cover.1270142346.git.mchehab@redhat.com>
References: <cover.1270142346.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/video/cx88/cx88-input.c b/drivers/media/video/cx88/cx88-input.c
index 8f1b846..a7214d0 100644
--- a/drivers/media/video/cx88/cx88-input.c
+++ b/drivers/media/video/cx88/cx88-input.c
@@ -39,6 +39,10 @@ struct cx88_IR {
 	struct cx88_core *core;
 	struct input_dev *input;
 	struct ir_input_state ir;
+	struct ir_dev_props props;
+
+	int users;
+
 	char name[32];
 	char phys[32];
 
@@ -160,8 +164,16 @@ static enum hrtimer_restart cx88_ir_work(struct hrtimer *timer)
 	return HRTIMER_RESTART;
 }
 
-void cx88_ir_start(struct cx88_core *core, struct cx88_IR *ir)
+static int __cx88_ir_start(void *priv)
 {
+	struct cx88_core *core = priv;
+	struct cx88_IR *ir;
+
+	if (!core || !core->ir)
+		return -EINVAL;
+
+	ir = core->ir;
+
 	if (ir->polling) {
 		hrtimer_init(&ir->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 		ir->timer.function = cx88_ir_work;
@@ -174,10 +186,18 @@ void cx88_ir_start(struct cx88_core *core, struct cx88_IR *ir)
 		cx_write(MO_DDS_IO, 0xa80a80);	/* 4 kHz sample rate */
 		cx_write(MO_DDSCFG_IO, 0x5);	/* enable */
 	}
+	return 0;
 }
 
-void cx88_ir_stop(struct cx88_core *core, struct cx88_IR *ir)
+static void __cx88_ir_stop(void *priv)
 {
+	struct cx88_core *core = priv;
+	struct cx88_IR *ir;
+
+	if (!core || !core->ir)
+		return;
+
+	ir = core->ir;
 	if (ir->sampling) {
 		cx_write(MO_DDSCFG_IO, 0x0);
 		core->pci_irqmask &= ~PCI_INT_IR_SMPINT;
@@ -187,6 +207,37 @@ void cx88_ir_stop(struct cx88_core *core, struct cx88_IR *ir)
 		hrtimer_cancel(&ir->timer);
 }
 
+int cx88_ir_start(struct cx88_core *core)
+{
+	if (core->ir->users)
+		return __cx88_ir_start(core);
+
+	return 0;
+}
+
+void cx88_ir_stop(struct cx88_core *core)
+{
+	if (core->ir->users)
+		__cx88_ir_stop(core);
+}
+
+static int cx88_ir_open(void *priv)
+{
+	struct cx88_core *core = priv;
+
+	core->ir->users++;
+	return __cx88_ir_start(core);
+}
+
+static void cx88_ir_close(void *priv)
+{
+	struct cx88_core *core = priv;
+
+	core->ir->users--;
+	if (!core->ir->users)
+		__cx88_ir_stop(core);
+}
+
 /* ---------------------------------------------------------------------- */
 
 int cx88_ir_init(struct cx88_core *core, struct pci_dev *pci)
@@ -382,19 +433,19 @@ int cx88_ir_init(struct cx88_core *core, struct pci_dev *pci)
 	ir->core = core;
 	core->ir = ir;
 
-	cx88_ir_start(core, ir);
+	ir->props.priv = core;
+	ir->props.open = cx88_ir_open;
+	ir->props.close = cx88_ir_close;
 
 	/* all done */
-	err = ir_input_register(ir->input, ir_codes, NULL, MODULE_NAME);
+	err = ir_input_register(ir->input, ir_codes, &ir->props, MODULE_NAME);
 	if (err)
-		goto err_out_stop;
+		goto err_out_free;
 
 	return 0;
 
- err_out_stop:
-	cx88_ir_stop(core, ir);
-	core->ir = NULL;
  err_out_free:
+	core->ir = NULL;
 	kfree(ir);
 	return err;
 }
@@ -407,7 +458,7 @@ int cx88_ir_fini(struct cx88_core *core)
 	if (NULL == ir)
 		return 0;
 
-	cx88_ir_stop(core, ir);
+	cx88_ir_stop(core);
 	ir_input_unregister(ir->input);
 	kfree(ir);
 
diff --git a/drivers/media/video/cx88/cx88-video.c b/drivers/media/video/cx88/cx88-video.c
index 48c450f..8e414f7 100644
--- a/drivers/media/video/cx88/cx88-video.c
+++ b/drivers/media/video/cx88/cx88-video.c
@@ -1977,7 +1977,7 @@ static void __devexit cx8800_finidev(struct pci_dev *pci_dev)
 	}
 
 	if (core->ir)
-		cx88_ir_stop(core, core->ir);
+		cx88_ir_stop(core);
 
 	cx88_shutdown(core); /* FIXME */
 	pci_disable_device(pci_dev);
@@ -2015,7 +2015,7 @@ static int cx8800_suspend(struct pci_dev *pci_dev, pm_message_t state)
 	spin_unlock(&dev->slock);
 
 	if (core->ir)
-		cx88_ir_stop(core, core->ir);
+		cx88_ir_stop(core);
 	/* FIXME -- shutdown device */
 	cx88_shutdown(core);
 
@@ -2056,7 +2056,7 @@ static int cx8800_resume(struct pci_dev *pci_dev)
 	/* FIXME: re-initialize hardware */
 	cx88_reset(core);
 	if (core->ir)
-		cx88_ir_start(core, core->ir);
+		cx88_ir_start(core);
 
 	cx_set(MO_PCI_INTMSK, core->pci_irqmask);
 
diff --git a/drivers/media/video/cx88/cx88.h b/drivers/media/video/cx88/cx88.h
index b5f054d..bdb03d3 100644
--- a/drivers/media/video/cx88/cx88.h
+++ b/drivers/media/video/cx88/cx88.h
@@ -41,7 +41,7 @@
 
 #include <linux/version.h>
 #include <linux/mutex.h>
-#define CX88_VERSION_CODE KERNEL_VERSION(0,0,7)
+#define CX88_VERSION_CODE KERNEL_VERSION(0, 0, 8)
 
 #define UNSET (-1U)
 
@@ -683,8 +683,8 @@ s32 cx88_dsp_detect_stereo_sap(struct cx88_core *core);
 int cx88_ir_init(struct cx88_core *core, struct pci_dev *pci);
 int cx88_ir_fini(struct cx88_core *core);
 void cx88_ir_irq(struct cx88_core *core);
-void cx88_ir_start(struct cx88_core *core, struct cx88_IR *ir);
-void cx88_ir_stop(struct cx88_core *core, struct cx88_IR *ir);
+int cx88_ir_start(struct cx88_core *core);
+void cx88_ir_stop(struct cx88_core *core);
 
 /* ----------------------------------------------------------- */
 /* cx88-mpeg.c                                                 */
-- 
1.6.6.1


