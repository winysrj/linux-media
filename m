Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from alsikeapila.uta.fi ([153.1.1.44])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <pauli@borodulin.fi>) id 1Jy8bV-00076q-Hy
	for linux-dvb@linuxtv.org; Mon, 19 May 2008 18:52:55 +0200
Message-ID: <4831B058.1030107@borodulin.fi>
Date: Mon, 19 May 2008 19:52:40 +0300
From: Pauli Borodulin <pauli@borodulin.fi>
MIME-Version: 1.0
To: Markus Rechberger <mrechberger@gmail.com>
References: <482E114E.1000609@borodulin.fi>
	<d9def9db0805161621n1a291192n8c15db11949b3dad@mail.gmail.com>
In-Reply-To: <d9def9db0805161621n1a291192n8c15db11949b3dad@mail.gmail.com>
Content-Type: multipart/mixed; boundary="------------030909060005000501090207"
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Updated Mantis VP-2033 remote control patch for
 Manu's jusst.de Mantis branch
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--------------030909060005000501090207
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Heya!

> On 5/17/08, Pauli Borodulin <pauli@borodulin.fi> wrote:
>> Since there has been some direct requests for this via email, I'm
>> posting a updated version of Kristian Slavov's original remote control
>> patch[1] for Manu's jusst.de Mantis branch. The new version is
>> functionally the same as the one I posted in March[2].
 >> [...]

Markus Rechberger wrote:
> +int mantis_rc_exit(struct mantis_pci *mantis)
>  +{
>  +        mmwrite(mmread(MANTIS_INT_MASK) & (~MANTIS_INT_IRQ1),
> MANTIS_INT_MASK);
>  +
>  +        cancel_delayed_work(&mantis->ir.rc_query_work);
>  +        input_unregister_device(mantis->ir.rc_dev);
>  +        dprintk(verbose, MANTIS_DEBUG, 1, "RC unregistered");
>  +        return 0;
>  +}
> 
> this might be dangerous when unloading the driver because the callback
> function might still be running after cancel_delayed_work.
> I ran into that problem a while ago and it could lock up the whole input system.
 > [...]

Thanks Markus! I created a revised version of the patch with call to 
flush_scheduled_work() after calling cancel_delayed_work. I also changed 
RC polling a bit so that it would work alike on different kernel 
configurations (thanks go to Kristian Slavov for pointing this out).

The patch is against 
http://www.jusst.de/hg/mantis/archive/b14e79e460fc.tar.bz2.

Regards,
Pauli Borodulin

--------------030909060005000501090207
Content-Type: text/plain;
 name="mantis-rc-b14e79e460fc.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="mantis-rc-b14e79e460fc.patch"

diff -urN mantis-b14e79e460fc.ORIG/linux/drivers/media/common/ir-keymaps.c mantis-b14e79e460fc/linux/drivers/media/common/ir-keymaps.c
--- mantis-b14e79e460fc.ORIG/linux/drivers/media/common/ir-keymaps.c	2008-05-19 17:00:01.000000000 +0300
+++ mantis-b14e79e460fc/linux/drivers/media/common/ir-keymaps.c	2008-05-19 17:39:32.000000000 +0300
@@ -2037,3 +2037,68 @@
 };
 
 EXPORT_SYMBOL_GPL(ir_codes_behold);
+
+/* Twinhan CAB-CI 2033 */
+IR_KEYTAB_TYPE ir_codes_mantis_vp2033[IR_KEYTAB_SIZE] = {
+	[ 0x29 ] = KEY_POWER,
+	[ 0x28 ] = KEY_FAVORITES,
+	[ 0x30 ] = KEY_TEXT,
+	[ 0x17 ] = KEY_INFO,		// Preview
+	[ 0x23 ] = KEY_EPG,
+	[ 0x3b ] = KEY_F22,		// Record List
+
+	[ 0x3c ] = KEY_1,
+	[ 0x3e ] = KEY_2,
+	[ 0x39 ] = KEY_3,
+	[ 0x36 ] = KEY_4,
+	[ 0x22 ] = KEY_5,
+	[ 0x20 ] = KEY_6,
+	[ 0x32 ] = KEY_7,
+	[ 0x26 ] = KEY_8,
+	[ 0x24 ] = KEY_9,
+	[ 0x2a ] = KEY_0,
+
+	[ 0x33 ] = KEY_CANCEL,
+	[ 0x2c ] = KEY_BACK,
+	[ 0x15 ] = KEY_CLEAR,
+	[ 0x3f ] = KEY_TAB,
+	[ 0x10 ] = KEY_ENTER,
+	[ 0x14 ] = KEY_UP,
+	[ 0x0d ] = KEY_RIGHT,
+	[ 0x0e ] = KEY_DOWN,
+	[ 0x11 ] = KEY_LEFT,
+
+	[ 0x21 ] = KEY_VOLUMEUP,
+	[ 0x35 ] = KEY_VOLUMEDOWN,
+	[ 0x3d ] = KEY_CHANNELDOWN,
+	[ 0x3a ] = KEY_CHANNELUP,
+	[ 0x2e ] = KEY_RECORD,
+	[ 0x2b ] = KEY_PLAY,
+	[ 0x13 ] = KEY_PAUSE,
+	[ 0x25 ] = KEY_STOP,
+
+	[ 0x1f ] = KEY_REWIND,
+	[ 0x2d ] = KEY_FASTFORWARD,
+	[ 0x1e ] = KEY_PREVIOUS,	// Replay |<
+	[ 0x1d ] = KEY_NEXT,		// Skip   >|
+
+	[ 0x0b ] = KEY_CAMERA,		// Capture
+	[ 0x0f ] = KEY_LANGUAGE,	// SAP
+	[ 0x18 ] = KEY_MODE,		// PIP
+	[ 0x12 ] = KEY_ZOOM,		// Full screen,
+	[ 0x1c ] = KEY_SUBTITLE,
+	[ 0x2f ] = KEY_MUTE,
+	[ 0x16 ] = KEY_F20,		// L/R,
+	[ 0x38 ] = KEY_F21,		// Hibernate,
+
+	[ 0x37 ] = KEY_SWITCHVIDEOMODE,	// A/V
+	[ 0x31 ] = KEY_AGAIN,		// Recall,
+	[ 0x1a ] = KEY_KPPLUS,		// Zoom+,
+	[ 0x19 ] = KEY_KPMINUS,		// Zoom-,
+	[ 0x27 ] = KEY_RED,
+	[ 0x0C ] = KEY_GREEN,
+	[ 0x01 ] = KEY_YELLOW,
+	[ 0x00 ] = KEY_BLUE,
+};
+
+EXPORT_SYMBOL_GPL(ir_codes_mantis_vp2033);
diff -urN mantis-b14e79e460fc.ORIG/linux/drivers/media/dvb/mantis/Makefile mantis-b14e79e460fc/linux/drivers/media/dvb/mantis/Makefile
--- mantis-b14e79e460fc.ORIG/linux/drivers/media/dvb/mantis/Makefile	2008-05-19 17:00:01.000000000 +0300
+++ mantis-b14e79e460fc/linux/drivers/media/dvb/mantis/Makefile	2008-05-19 17:39:56.000000000 +0300
@@ -12,7 +12,8 @@
 		mantis_vp1041.o	\
 		mantis_vp2033.o	\
 		mantis_vp2040.o	\
-		mantis_vp3030.o
+		mantis_vp3030.o \
+		mantis_rc.o
 
 obj-$(CONFIG_DVB_MANTIS) += mantis.o
 
diff -urN mantis-b14e79e460fc.ORIG/linux/drivers/media/dvb/mantis/mantis_common.h mantis-b14e79e460fc/linux/drivers/media/dvb/mantis/mantis_common.h
--- mantis-b14e79e460fc.ORIG/linux/drivers/media/dvb/mantis/mantis_common.h	2008-05-19 17:00:01.000000000 +0300
+++ mantis-b14e79e460fc/linux/drivers/media/dvb/mantis/mantis_common.h	2008-05-19 17:42:59.000000000 +0300
@@ -26,6 +26,8 @@
 #include <linux/kernel.h>
 #include <linux/pci.h>
 #include <linux/mutex.h>
+#include <linux/input.h>
+#include <media/ir-common.h>
 
 #include "dvbdev.h"
 #include "dvb_demux.h"
@@ -74,6 +76,20 @@
 	char			*model_name;
 	char			*dev_type;
 	u32			ts_size;
+	IR_KEYTAB_TYPE		*ir_codes;
+};
+
+struct mantis_ir {
+	struct input_dev	*rc_dev;
+	char			rc_name[80];
+	char			rc_phys[80];
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20)
+	struct work_struct	rc_query_work;
+#else
+	struct delayed_work	rc_query_work;
+#endif
+	u32			ir_last_code;
+	struct ir_input_state	ir;
 };
 
 struct mantis_pci {
@@ -140,6 +156,9 @@
 	u32			gpio_status;
 
 	struct mantis_ca	*mantis_ca;
+
+	/*	IR			*/
+	struct mantis_ir	ir;
 };
 
 #define MANTIS_HIF_STATUS	(mantis->gpio_status << 12)
diff -urN mantis-b14e79e460fc.ORIG/linux/drivers/media/dvb/mantis/mantis_core.c mantis-b14e79e460fc/linux/drivers/media/dvb/mantis/mantis_core.c
--- mantis-b14e79e460fc.ORIG/linux/drivers/media/dvb/mantis/mantis_core.c	2008-05-19 17:00:01.000000000 +0300
+++ mantis-b14e79e460fc/linux/drivers/media/dvb/mantis/mantis_core.c	2008-05-19 17:46:15.000000000 +0300
@@ -164,6 +164,10 @@
 		dprintk(verbose, MANTIS_DEBUG, 1, "Mantis DVB init failed");
 		return err;
 	}
+	if ((err = mantis_rc_init(mantis)) < 0) {
+		dprintk(verbose, MANTIS_DEBUG, 1, "Mantis RC init failed");
+		return err;
+	}
 
 	return 0;
 }
diff -urN mantis-b14e79e460fc.ORIG/linux/drivers/media/dvb/mantis/mantis_core.h mantis-b14e79e460fc/linux/drivers/media/dvb/mantis/mantis_core.h
--- mantis-b14e79e460fc.ORIG/linux/drivers/media/dvb/mantis/mantis_core.h	2008-05-19 17:00:01.000000000 +0300
+++ mantis-b14e79e460fc/linux/drivers/media/dvb/mantis/mantis_core.h	2008-05-19 17:44:18.000000000 +0300
@@ -53,5 +53,7 @@
 extern int mantis_i2c_exit(struct mantis_pci *mantis);
 extern int mantis_core_init(struct mantis_pci *mantis);
 extern int mantis_core_exit(struct mantis_pci *mantis);
+extern int mantis_rc_init(struct mantis_pci *mantis);
+extern int mantis_rc_exit(struct mantis_pci *mantis);
 
 #endif //__MANTIS_CORE_H
diff -urN mantis-b14e79e460fc.ORIG/linux/drivers/media/dvb/mantis/mantis_pci.c mantis-b14e79e460fc/linux/drivers/media/dvb/mantis/mantis_pci.c
--- mantis-b14e79e460fc.ORIG/linux/drivers/media/dvb/mantis/mantis_pci.c	2008-05-19 17:00:01.000000000 +0300
+++ mantis-b14e79e460fc/linux/drivers/media/dvb/mantis/mantis_pci.c	2008-05-19 17:44:56.000000000 +0300
@@ -80,6 +80,7 @@
 		schedule_work(&ca->hif_evm_work);
 	}
 	if (stat & MANTIS_INT_IRQ1) {
+		mantis->ir.ir_last_code = mmread(0xe8);
 		dprintk(verbose, MANTIS_DEBUG, 0, "* INT IRQ-1 *");
 	}
 	if (stat & MANTIS_INT_OCERR) {
@@ -228,6 +229,7 @@
 		dprintk(verbose, MANTIS_ERROR, 1, "Aeio, Mantis NULL ptr");
 		return;
 	}
+	mantis_rc_exit(mantis);
 	mantis_core_exit(mantis);
 	dprintk(verbose, MANTIS_ERROR, 1, "Removing -->Mantis irq: %d, latency: %d\n memory: 0x%lx, mmio: 0x%p",
 		pdev->irq, mantis->latency, mantis->mantis_addr,
diff -urN mantis-b14e79e460fc.ORIG/linux/drivers/media/dvb/mantis/mantis_rc.c mantis-b14e79e460fc/linux/drivers/media/dvb/mantis/mantis_rc.c
--- mantis-b14e79e460fc.ORIG/linux/drivers/media/dvb/mantis/mantis_rc.c	1970-01-01 02:00:00.000000000 +0200
+++ mantis-b14e79e460fc/linux/drivers/media/dvb/mantis/mantis_rc.c	2008-05-19 17:57:33.000000000 +0300
@@ -0,0 +1,94 @@
+#include <linux/bitops.h>
+#include "mantis_common.h"
+#include "mantis_core.h"
+
+#include "dmxdev.h"
+#include "dvbdev.h"
+#include "dvb_demux.h"
+#include "dvb_frontend.h"
+#include "mantis_vp1033.h"
+#include "mantis_vp1034.h"
+#include "mantis_vp2033.h"
+#include "mantis_vp3030.h"
+
+#define POLL_FREQ 100
+
+void mantis_query_rc(struct work_struct *work)
+{
+        struct mantis_pci *mantis =
+                container_of(work, struct mantis_pci, ir.rc_query_work.work);
+        struct ir_input_state *ir = &mantis->ir.ir;
+
+        u32 lastkey = mantis->ir.ir_last_code;
+
+        if (lastkey != -1) {
+                ir_input_keydown(mantis->ir.rc_dev, ir, lastkey, 0);
+                mantis->ir.ir_last_code = -1;
+        } else {
+                ir_input_nokey(mantis->ir.rc_dev, ir);
+        }
+        schedule_delayed_work(&mantis->ir.rc_query_work,
+		msecs_to_jiffies(POLL_FREQ));
+}
+
+int mantis_rc_init(struct mantis_pci *mantis)
+{
+        struct input_dev *rc_dev;
+        struct mantis_ir *mir = &mantis->ir;
+        struct ir_input_state *ir = &mir->ir;
+        int err;
+
+        if (!mantis->hwconfig->ir_codes) {
+                dprintk(verbose, MANTIS_DEBUG, 1, "No RC codes available");
+                return 0;
+        }
+
+        mmwrite(mmread(MANTIS_INT_MASK) | MANTIS_INT_IRQ1, MANTIS_INT_MASK);
+
+        rc_dev = input_allocate_device();
+        if (!rc_dev) {
+                dprintk(verbose, MANTIS_ERROR, 1, "dvb_rc_init failed");
+                return -ENOENT;
+        }
+
+        mir->rc_dev = rc_dev;
+
+        snprintf(mir->rc_name, sizeof(mir->rc_name), 
+                 "Mantis %s IR Receiver", mantis->hwconfig->model_name);
+        snprintf(mir->rc_phys, sizeof(mir->rc_phys), 
+                 "pci-%s/ir0", pci_name(mantis->pdev));
+
+        rc_dev->name = mir->rc_name;
+        rc_dev->phys = mir->rc_phys;
+
+        ir_input_init(rc_dev, ir, IR_TYPE_OTHER, mantis->hwconfig->ir_codes);
+
+        rc_dev->id.bustype = BUS_PCI;
+        rc_dev->id.vendor  = mantis->vendor_id;
+        rc_dev->id.product = mantis->device_id;
+        rc_dev->id.version = 1;
+        rc_dev->cdev.dev = &mantis->pdev->dev;
+
+        INIT_DELAYED_WORK(&mir->rc_query_work, mantis_query_rc);
+
+        err = input_register_device(rc_dev);
+        if (err) {
+                dprintk(verbose, MANTIS_ERROR, 1, "rc registering failed");
+                return -ENOENT;
+        }
+
+        schedule_delayed_work(&mir->rc_query_work,
+		msecs_to_jiffies(POLL_FREQ));
+        return 0;
+}
+
+int mantis_rc_exit(struct mantis_pci *mantis)
+{
+        mmwrite(mmread(MANTIS_INT_MASK) & (~MANTIS_INT_IRQ1), MANTIS_INT_MASK);
+
+        cancel_delayed_work(&mantis->ir.rc_query_work);
+	flush_scheduled_work();
+        input_unregister_device(mantis->ir.rc_dev);
+        dprintk(verbose, MANTIS_DEBUG, 1, "RC unregistered");
+        return 0;
+}
diff -urN mantis-b14e79e460fc.ORIG/linux/drivers/media/dvb/mantis/mantis_vp2033.c mantis-b14e79e460fc/linux/drivers/media/dvb/mantis/mantis_vp2033.c
--- mantis-b14e79e460fc.ORIG/linux/drivers/media/dvb/mantis/mantis_vp2033.c	2008-05-19 17:00:01.000000000 +0300
+++ mantis-b14e79e460fc/linux/drivers/media/dvb/mantis/mantis_vp2033.c	2008-05-19 17:47:51.000000000 +0300
@@ -28,6 +28,7 @@
 	.model_name	= MANTIS_MODEL_NAME,
 	.dev_type	= MANTIS_DEV_TYPE,
 	.ts_size	= MANTIS_TS_204,
+	.ir_codes	= ir_codes_mantis_vp2033,
 };
 
 struct tda1002x_config philips_cu1216_config = {
diff -urN mantis-b14e79e460fc.ORIG/linux/include/media/ir-common.h mantis-b14e79e460fc/linux/include/media/ir-common.h
--- mantis-b14e79e460fc.ORIG/linux/include/media/ir-common.h	2008-05-19 17:00:01.000000000 +0300
+++ mantis-b14e79e460fc/linux/include/media/ir-common.h	2008-05-19 17:50:43.000000000 +0300
@@ -142,6 +142,7 @@
 extern IR_KEYTAB_TYPE ir_codes_fusionhdtv_mce[IR_KEYTAB_SIZE];
 extern IR_KEYTAB_TYPE ir_codes_behold[IR_KEYTAB_SIZE];
 extern IR_KEYTAB_TYPE ir_codes_pinnacle_pctv_hd[IR_KEYTAB_SIZE];
+extern IR_KEYTAB_TYPE ir_codes_mantis_vp2033[IR_KEYTAB_SIZE];
 
 #endif
 

--------------030909060005000501090207
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------030909060005000501090207--
