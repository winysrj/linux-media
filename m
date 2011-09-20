Return-path: <linux-media-owner@vger.kernel.org>
Received: from mr.siano-ms.com ([62.0.79.70]:6223 "EHLO
	Siano-NV.ser.netvision.net.il" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752141Ab1ITKSR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Sep 2011 06:18:17 -0400
Subject: [PATCH  3/17]DVB:Siano drivers - Changing some field names and
 debug messages.
From: Doron Cohen <doronc@siano-ms.com>
Reply-To: doronc@siano-ms.com
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 20 Sep 2011 13:30:59 +0300
Message-ID: <1316514659.5199.81.camel@Doron-Ubuntu>
Mime-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
This patch is changing field names and debug messages to be more clear.

>From 5b3525a0860992b3811dd9ebd4c797b79e14631a Mon Sep 17 00:00:00 2001
From: Doron Cohen <doronc@siano-ms.com>
Date: Thu, 15 Sep 2011 14:30:24 +0300
Subject: [PATCH 06/21] Change debug prints and struct field names to be
more clear.

Thanks,
Doron Cohen

---
 drivers/media/dvb/siano/Kconfig      |   17 +++-------
 drivers/media/dvb/siano/Makefile     |   10 ++++++
 drivers/media/dvb/siano/smscoreapi.c |   20 +++++++----
 drivers/media/dvb/siano/smsir.c      |   60
++++++++++++++++-----------------
 drivers/media/dvb/siano/smsir.h      |    2 +-
 5 files changed, 57 insertions(+), 52 deletions(-)

diff --git a/drivers/media/dvb/siano/Kconfig
b/drivers/media/dvb/siano/Kconfig
index aeca46f..bb91911 100644
--- a/drivers/media/dvb/siano/Kconfig
+++ b/drivers/media/dvb/siano/Kconfig
@@ -4,7 +4,7 @@
 
 config SMS_SIANO_MDTV
 	tristate "Siano SMS1xxx based MDTV receiver"
-	depends on DVB_CORE && RC_CORE && HAS_DMA
+	depends on DVB_CORE && HAS_DMA
 	---help---
 	  Choose Y or M here if you have MDTV receiver with a Siano chipset.
 
@@ -19,18 +19,12 @@ menu "Siano module components"
 
 # Kernel sub systems support
 
-config SMS_DVB3_SUBSYS
-	bool "DVB v.3 Subsystem support"
-	depends on DVB_CORE
-	default y if DVB_CORE
-	---help---
-	Choose if you would like to have DVB v.3 kernel sub-system support.
-
-config SMS_DVB5_S2API_SUBSYS
-	bool "DVB v.5 (S2 API) Subsystem support"
+config SMS_RC_SUPPORT_SUBSYS
+	bool "Remote Control Subsystem support"
+	depends on RC_CORE
 	default n
 	---help---
-	Choose if you would like to have DVB v.5 (S2 API) kernel sub-system
support.
+	Choose if you would like to have Siano's ir remote control sub-system
support.
 
 config SMS_HOSTLIB_SUBSYS
 	bool "Host Library Subsystem support"
@@ -39,7 +33,6 @@ config SMS_HOSTLIB_SUBSYS
 	Choose if you would like to have Siano's host library kernel
sub-system support.
 
 if SMS_HOSTLIB_SUBSYS
-
 config SMS_NET_SUBSYS
 	tristate "Siano Network Adapter"
 	depends on NET
diff --git a/drivers/media/dvb/siano/Makefile
b/drivers/media/dvb/siano/Makefile
index affaf01..a5e52f5 100644
--- a/drivers/media/dvb/siano/Makefile
+++ b/drivers/media/dvb/siano/Makefile
@@ -11,3 +11,13 @@ EXTRA_CFLAGS += -Idrivers/media/dvb/dvb-core
 
 EXTRA_CFLAGS += $(extra-cflags-y) $(extra-cflags-m)
 
+ifdef CONFIG_SMS_RC_SUPPORT_SUBSYS
+	EXTRA_CFLAGS += -DSMS_RC_SUPPORT_SUBSYS
+endif
+
+ifdef CONFIG_SMS_HOSTLIB_SUBSYS
+	EXTRA_CFLAGS += -DSMS_HOSTLIB_SUBSYS
+endif
+
+
+
diff --git a/drivers/media/dvb/siano/smscoreapi.c
b/drivers/media/dvb/siano/smscoreapi.c
index 115604c..7c74544 100644
--- a/drivers/media/dvb/siano/smscoreapi.c
+++ b/drivers/media/dvb/siano/smscoreapi.c
@@ -426,27 +426,26 @@ static int smscore_sendrequest_and_wait(struct
smscore_device_t *coredev,
 			msecs_to_jiffies(SMS_PROTOCOL_MAX_RAOUNDTRIP_MS)) ?
 			0 : -ETIME;
 }
-
+#ifdef SMS_RC_SUPPORT_SUBSYS
 /**
  * Starts & enables IR operations
  *
  * @return 0 on success, < 0 on error.
  */
 static int smscore_init_ir(struct smscore_device_t *coredev)
-{
+{ 
 	int ir_io;
 	int rc;
 	void *buffer;
-
-	coredev->ir.dev = NULL;
+	coredev->ir.rc_dev = NULL;
 	ir_io = sms_get_board(smscore_get_board_id(coredev))->board_cfg.ir;
 	if (ir_io) {/* only if IR port exist we use IR sub-module */
 		sms_info("IR loading");
 		rc = sms_ir_init(coredev);
-
 		if	(rc != 0)
 			sms_err("Error initialization DTV IR sub-module");
-		else {
+		else 
+		{
 			buffer = kmalloc(sizeof(struct SmsMsgData_ST2) +
 						SMS_DMA_ALIGNMENT,
 						GFP_KERNEL | GFP_DMA);
@@ -477,6 +476,7 @@ static int smscore_init_ir(struct smscore_device_t
*coredev)
 
 	return 0;
 }
+#endif /*SMS_RC_SUPPORT_SUBSYS*/
 
 /**
  * sets initial device mode and notifies client hotplugs that device is
ready
@@ -498,7 +498,9 @@ int smscore_start_device(struct smscore_device_t
*coredev)
 	kmutex_lock(&g_smscore_deviceslock);
 
 	rc = smscore_notify_callbacks(coredev, coredev->device, 1);
+#ifdef SMS_RC_SUPPORT_SUBSYS
 	smscore_init_ir(coredev);
+#endif /*SMS_RC_SUPPORT_SUBSYS*/
 
 	sms_info("device %p started, rc %d", coredev, rc);
 
@@ -688,8 +690,9 @@ void smscore_unregister_device(struct
smscore_device_t *coredev)
 	kmutex_lock(&g_smscore_deviceslock);
 
 	/* Release input device (IR) resources */
+#ifdef SMS_RC_SUPPORT_SUBSYS
 	sms_ir_exit(coredev);
-
+#endif /*SMS_RC_SUPPORT_SUBSYS*/
 	smscore_notify_clients(coredev);
 	smscore_notify_callbacks(coredev, NULL, 0);
 
@@ -1073,6 +1076,7 @@ void smscore_onresponse(struct smscore_device_t
*coredev,
 		case MSG_SMS_START_IR_RES:
 			complete(&coredev->ir_init_done);
 			break;
+#ifdef SMS_RC_SUPPORT_SUBSYS
 		case MSG_SMS_IR_SAMPLES_IND:
 			sms_ir_event(coredev,
 				(const char *)
@@ -1081,7 +1085,7 @@ void smscore_onresponse(struct smscore_device_t
*coredev,
 				(int)phdr->msgLength
 				- sizeof(struct SmsMsgHdr_ST));
 			break;
-
+#endif /*SMS_RC_SUPPORT_SUBSYS*/
 		default:
 			break;
 		}
diff --git a/drivers/media/dvb/siano/smsir.c
b/drivers/media/dvb/siano/smsir.c
index 37bc5c4..f9d065b 100644
--- a/drivers/media/dvb/siano/smsir.c
+++ b/drivers/media/dvb/siano/smsir.c
@@ -32,8 +32,11 @@
 #include "smsir.h"
 #include "sms-cards.h"
 
+#ifdef SMS_RC_SUPPORT_SUBSYS
 #define MODULE_NAME "smsmdtv"
 
+extern int sms_dbg;
+
 void sms_ir_event(struct smscore_device_t *coredev, const char *buf,
int len)
 {
 	int i;
@@ -45,27 +48,28 @@ void sms_ir_event(struct smscore_device_t *coredev,
const char *buf, int len)
 		ev.duration = abs(samples[i]) * 1000; /* Convert to ns */
 		ev.pulse = (samples[i] > 0) ? false : true;
 
-		ir_raw_event_store(coredev->ir.dev, &ev);
+		ir_raw_event_store(coredev->ir.rc_dev, &ev);
 	}
-	ir_raw_event_handle(coredev->ir.dev);
+	ir_raw_event_handle(coredev->ir.rc_dev);
+
 }
 
 int sms_ir_init(struct smscore_device_t *coredev)
 {
 	int err;
 	int board_id = smscore_get_board_id(coredev);
-	struct rc_dev *dev;
+	struct rc_dev *rc_dev;
 
-	sms_log("Allocating rc device");
-	dev = rc_allocate_device();
-	if (!dev) {
+	sms_info("Allocating input device");
+	rc_dev = rc_allocate_device();
+	if (!rc_dev)	{
 		sms_err("Not enough memory");
 		return -ENOMEM;
 	}
 
 	coredev->ir.controller = 0;	/* Todo: vega/nova SPI number */
 	coredev->ir.timeout = IR_DEFAULT_TIMEOUT;
-	sms_log("IR port %d, timeout %d ms",
+	sms_info("IR port %d, timeout %d ms",
 			coredev->ir.controller, coredev->ir.timeout);
 
 	snprintf(coredev->ir.name, sizeof(coredev->ir.name),
@@ -74,41 +78,35 @@ int sms_ir_init(struct smscore_device_t *coredev)
 	strlcpy(coredev->ir.phys, coredev->devpath, sizeof(coredev->ir.phys));
 	strlcat(coredev->ir.phys, "/ir0", sizeof(coredev->ir.phys));
 
-	dev->input_name = coredev->ir.name;
-	dev->input_phys = coredev->ir.phys;
-	dev->dev.parent = coredev->device;
-
-#if 0
-	/* TODO: properly initialize the parameters bellow */
-	dev->input_id.bustype = BUS_USB;
-	dev->input_id.version = 1;
-	dev->input_id.vendor = le16_to_cpu(dev->udev->descriptor.idVendor);
-	dev->input_id.product = le16_to_cpu(dev->udev->descriptor.idProduct);
-#endif
+	rc_dev->input_name = coredev->ir.name;
+	rc_dev->input_phys = coredev->ir.phys;
+	rc_dev->dev.parent = coredev->device;
+	rc_dev->priv = coredev;
+	rc_dev->driver_type = RC_DRIVER_IR_RAW;
+	rc_dev->allowed_protos = RC_TYPE_ALL;
+	rc_dev->map_name = sms_get_board(board_id)->rc_codes;
+	rc_dev->driver_name = MODULE_NAME;
 
-	dev->priv = coredev;
-	dev->driver_type = RC_DRIVER_IR_RAW;
-	dev->allowed_protos = RC_TYPE_ALL;
-	dev->map_name = sms_get_board(board_id)->rc_codes;
-	dev->driver_name = MODULE_NAME;
+	sms_info("Input device (IR) %s is set for key events",
rc_dev->input_name);
 
-	sms_log("Input device (IR) %s is set for key events",
dev->input_name);
-
-	err = rc_register_device(dev);
+	err = rc_register_device(rc_dev);
 	if (err < 0) {
 		sms_err("Failed to register device");
-		rc_free_device(dev);
+		rc_free_device(rc_dev);
 		return err;
 	}
 
-	coredev->ir.dev = dev;
+	coredev->ir.rc_dev = rc_dev;
 	return 0;
 }
 
 void sms_ir_exit(struct smscore_device_t *coredev)
 {
-	if (coredev->ir.dev)
-		rc_unregister_device(coredev->ir.dev);
+	if (coredev->ir.rc_dev)
+		rc_unregister_device(coredev->ir.rc_dev);
 
-	sms_log("");
+	sms_info("");
 }
+#endif /*SMS_RC_SUPPORT_SUBSYS*/
+
+
diff --git a/drivers/media/dvb/siano/smsir.h
b/drivers/media/dvb/siano/smsir.h
index ae92b3a..701fcfe 100644
--- a/drivers/media/dvb/siano/smsir.h
+++ b/drivers/media/dvb/siano/smsir.h
@@ -35,7 +35,7 @@ along with this program.  If not, see
<http://www.gnu.org/licenses/>.
 struct smscore_device_t;
 
 struct ir_t {
-	struct rc_dev *dev;
+	struct rc_dev *rc_dev;
 	char name[40];
 	char phys[32];
 
-- 
1.7.4.1

