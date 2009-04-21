Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:60929 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750760AbZDUHBp (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 21 Apr 2009 03:01:45 -0400
From: "Christoph Pinkl" <c.pinkl@gmx.at>
To: <linux-media@vger.kernel.org>
Subject: IR Remote Support for Mantis VP-1041
Date: Tue, 21 Apr 2009 09:01:32 +0200
Message-ID: <99FCDAABC8A64EF89FF5A194D919B0EE@chrishome>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0024_01C9C25F.C4B333D0"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.

------=_NextPart_000_0024_01C9C25F.C4B333D0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit

Hello,

Here is a patch against the s2-liplianin [1] repo to support ir remote for
the mantis vp-1041 (TerraTec Cinergy S2 PCI HD) cards. This patch is based
on the remote control patch from Pauli Borodulin [2]
and adds support for the vp-1041 cards. The ir-keymap is based on the 
remote-control from the TerraTec Cinergy S2 PCI HD Card. 

[1] http://mercurial.intuxication.org/hg/s2-liplianin
[2] http://pauli.borodulin.fi/blog/?p=8

chris

------=_NextPart_000_0024_01C9C25F.C4B333D0
Content-Type: application/octet-stream;
	name="mantis-rc-s2-liplianin.diff"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="mantis-rc-s2-liplianin.diff"

diff -r 2866ecb5e66b linux/drivers/media/common/ir-keymaps.c=0A=
--- a/linux/drivers/media/common/ir-keymaps.c	Sun Mar 15 18:24:26 2009 =
+0200=0A=
+++ b/linux/drivers/media/common/ir-keymaps.c	Thu Apr 02 00:01:24 2009 =
+0200=0A=
@@ -2693,6 +2693,178 @@=0A=
 };=0A=
 EXPORT_SYMBOL_GPL(ir_codes_avermedia_a16d);=0A=
 =0A=
+/* Twinhan VP-1041 */=0A=
+IR_KEYTAB_TYPE ir_codes_mantis_vp1041[IR_KEYTAB_SIZE] =3D {=0A=
+=0A=
+	[ 0x03 ] =3D KEY_NEXT,=0A=
+	[ 0x07 ] =3D KEY_RECORD,=0A=
+	[ 0x0b ] =3D KEY_PREVIOUS,=0A=
+	[ 0x10 ] =3D KEY_FASTFORWARD,=0A=
+	[ 0x11 ] =3D KEY_REWIND,=0A=
+	[ 0x12 ] =3D KEY_BACK,=0A=
+	[ 0x13 ] =3D KEY_PLAYCD,=0A=
+	[ 0x14 ] =3D KEY_F9,		//DVD-Menu=0A=
+	[ 0x15 ] =3D KEY_AUDIO,=0A=
+	[ 0x16 ] =3D KEY_VIDEO,=0A=
+	[ 0x17 ] =3D KEY_STOPCD,=0A=
+	[ 0x18 ] =3D KEY_DVD,=0A=
+	[ 0x19 ] =3D KEY_TV,=0A=
+	[ 0x1a ] =3D KEY_DELETE,=0A=
+	[ 0x1b ] =3D KEY_TEXT,=0A=
+	[ 0x1c ] =3D KEY_SUBTITLE,=0A=
+	[ 0x1d ] =3D KEY_F10,		//Photos=0A=
+	[ 0x1e ] =3D KEY_HOME,=0A=
+	[ 0x1f ] =3D KEY_PAUSECD,=0A=
+	[ 0x20 ] =3D KEY_CHANNELDOWN,=0A=
+	[ 0x21 ] =3D KEY_VOLUMEDOWN,=0A=
+	[ 0x22 ] =3D KEY_MUTE,=0A=
+	[ 0x23 ] =3D KEY_VOLUMEUP,=0A=
+	[ 0x24 ] =3D KEY_CHANNELUP,=0A=
+	[ 0x25 ] =3D KEY_BLUE,=0A=
+	[ 0x26 ] =3D KEY_YELLOW,=0A=
+	[ 0x27 ] =3D KEY_GREEN,=0A=
+	[ 0x28 ] =3D KEY_RED,=0A=
+	[ 0x29 ] =3D KEY_INFO,=0A=
+	[ 0x2b ] =3D KEY_DOWN,=0A=
+	[ 0x2c ] =3D KEY_RIGHT,=0A=
+	[ 0x2d ] =3D KEY_OK,=0A=
+	[ 0x2e ] =3D KEY_LEFT,=0A=
+	[ 0x2f ] =3D KEY_UP,=0A=
+	[ 0x30 ] =3D KEY_EPG,=0A=
+	[ 0x32 ] =3D KEY_F5,=0A=
+	[ 0x33 ] =3D KEY_0,=0A=
+	[ 0x34 ] =3D KEY_VCR,=0A=
+	[ 0x35 ] =3D KEY_9,=0A=
+	[ 0x36 ] =3D KEY_8,=0A=
+	[ 0x37 ] =3D KEY_7,=0A=
+	[ 0x38 ] =3D KEY_6,=0A=
+	[ 0x39 ] =3D KEY_5,=0A=
+	[ 0x3a ] =3D KEY_4,=0A=
+	[ 0x3b ] =3D KEY_3,=0A=
+	[ 0x3c ] =3D KEY_2,=0A=
+	[ 0x3d ] =3D KEY_1,=0A=
+	[ 0x3e ] =3D KEY_POWER,=0A=
+=0A=
+};=0A=
+EXPORT_SYMBOL_GPL(ir_codes_mantis_vp1041);=0A=
+=0A=
+/* Twinhan CAB-CI 2033 */=0A=
+IR_KEYTAB_TYPE ir_codes_mantis_vp2033[IR_KEYTAB_SIZE] =3D {=0A=
+	[ 0x29 ] =3D KEY_POWER,=0A=
+	[ 0x28 ] =3D KEY_FAVORITES,=0A=
+	[ 0x30 ] =3D KEY_TEXT,=0A=
+	[ 0x17 ] =3D KEY_INFO,		// Preview=0A=
+	[ 0x23 ] =3D KEY_EPG,=0A=
+	[ 0x3b ] =3D KEY_F22,		// Record List=0A=
+=0A=
+	[ 0x3c ] =3D KEY_1,=0A=
+	[ 0x3e ] =3D KEY_2,=0A=
+	[ 0x39 ] =3D KEY_3,=0A=
+	[ 0x36 ] =3D KEY_4,=0A=
+	[ 0x22 ] =3D KEY_5,=0A=
+	[ 0x20 ] =3D KEY_6,=0A=
+	[ 0x32 ] =3D KEY_7,=0A=
+	[ 0x26 ] =3D KEY_8,=0A=
+	[ 0x24 ] =3D KEY_9,=0A=
+	[ 0x2a ] =3D KEY_0,=0A=
+=0A=
+	[ 0x33 ] =3D KEY_CANCEL,=0A=
+	[ 0x2c ] =3D KEY_BACK,=0A=
+	[ 0x15 ] =3D KEY_CLEAR,=0A=
+	[ 0x3f ] =3D KEY_TAB,=0A=
+	[ 0x10 ] =3D KEY_ENTER,=0A=
+	[ 0x14 ] =3D KEY_UP,=0A=
+	[ 0x0d ] =3D KEY_RIGHT,=0A=
+	[ 0x0e ] =3D KEY_DOWN,=0A=
+	[ 0x11 ] =3D KEY_LEFT,=0A=
+=0A=
+	[ 0x21 ] =3D KEY_VOLUMEUP,=0A=
+	[ 0x35 ] =3D KEY_VOLUMEDOWN,=0A=
+	[ 0x3d ] =3D KEY_CHANNELDOWN,=0A=
+	[ 0x3a ] =3D KEY_CHANNELUP,=0A=
+	[ 0x2e ] =3D KEY_RECORD,=0A=
+	[ 0x2b ] =3D KEY_PLAY,=0A=
+	[ 0x13 ] =3D KEY_PAUSE,=0A=
+	[ 0x25 ] =3D KEY_STOP,=0A=
+=0A=
+	[ 0x1f ] =3D KEY_REWIND,=0A=
+	[ 0x2d ] =3D KEY_FASTFORWARD,=0A=
+	[ 0x1e ] =3D KEY_PREVIOUS,	// Replay |<=0A=
+	[ 0x1d ] =3D KEY_NEXT,		// Skip   >|=0A=
+=0A=
+	[ 0x0b ] =3D KEY_CAMERA,		// Capture=0A=
+	[ 0x0f ] =3D KEY_LANGUAGE,	// SAP=0A=
+	[ 0x18 ] =3D KEY_MODE,		// PIP=0A=
+	[ 0x12 ] =3D KEY_ZOOM,		// Full screen,=0A=
+	[ 0x1c ] =3D KEY_SUBTITLE,=0A=
+	[ 0x2f ] =3D KEY_MUTE,=0A=
+	[ 0x16 ] =3D KEY_F20,		// L/R,=0A=
+	[ 0x38 ] =3D KEY_F21,		// Hibernate,=0A=
+=0A=
+	[ 0x37 ] =3D KEY_SWITCHVIDEOMODE,	// A/V=0A=
+	[ 0x31 ] =3D KEY_AGAIN,		// Recall,=0A=
+	[ 0x1a ] =3D KEY_KPPLUS,		// Zoom+,=0A=
+	[ 0x19 ] =3D KEY_KPMINUS,		// Zoom-,=0A=
+	[ 0x27 ] =3D KEY_RED,=0A=
+	[ 0x0C ] =3D KEY_GREEN,=0A=
+	[ 0x01 ] =3D KEY_YELLOW,=0A=
+	[ 0x00 ] =3D KEY_BLUE,=0A=
+};=0A=
+EXPORT_SYMBOL_GPL(ir_codes_mantis_vp2033);=0A=
+=0A=
+/* Twinhan mantis vp2040 - terratec cinergy c */=0A=
+IR_KEYTAB_TYPE ir_codes_mantis_vp2040[IR_KEYTAB_SIZE] =3D {=0A=
+	[ 0x3e ] =3D KEY_POWER,=0A=
+	[ 0x3d ] =3D KEY_1,=0A=
+	[ 0x3c ] =3D KEY_2,=0A=
+	[ 0x3b ] =3D KEY_3,=0A=
+	[ 0x3a ] =3D KEY_4,=0A=
+	[ 0x39 ] =3D KEY_5,=0A=
+	[ 0x38 ] =3D KEY_6,=0A=
+	[ 0x37 ] =3D KEY_7,=0A=
+	[ 0x36 ] =3D KEY_8,=0A=
+	[ 0x35 ] =3D KEY_9,=0A=
+	[ 0x34 ] =3D KEY_VIDEO_NEXT, /* AV */=0A=
+	[ 0x33 ] =3D KEY_0,=0A=
+	[ 0x32 ] =3D KEY_REFRESH,=0A=
+	[ 0x30 ] =3D KEY_EPG,=0A=
+	[ 0x2f ] =3D KEY_UP,=0A=
+	[ 0x2e ] =3D KEY_LEFT,=0A=
+	[ 0x2d ] =3D KEY_OK,=0A=
+	[ 0x2c ] =3D KEY_RIGHT,=0A=
+	[ 0x2b ] =3D KEY_DOWN,=0A=
+	[ 0x29 ] =3D KEY_INFO,=0A=
+	[ 0x28 ] =3D KEY_RED,=0A=
+	[ 0x27 ] =3D KEY_GREEN,=0A=
+	[ 0x26 ] =3D KEY_YELLOW,=0A=
+	[ 0x25 ] =3D KEY_BLUE,=0A=
+	[ 0x24 ] =3D KEY_CHANNELUP,=0A=
+	[ 0x23 ] =3D KEY_VOLUMEUP,=0A=
+	[ 0x22 ] =3D KEY_MUTE,=0A=
+	[ 0x21 ] =3D KEY_VOLUMEDOWN,=0A=
+	[ 0x20 ] =3D KEY_CHANNELDOWN,=0A=
+	[ 0x1f ] =3D KEY_PAUSE,=0A=
+	[ 0x1e ] =3D KEY_HOME,=0A=
+	[ 0x1d ] =3D KEY_MENU, /* DVD Menu */=0A=
+	[ 0x1c ] =3D KEY_SUBTITLE,=0A=
+	[ 0x1b ] =3D KEY_TEXT, /* Teletext */=0A=
+	[ 0x1a ] =3D KEY_DELETE,=0A=
+	[ 0x19 ] =3D KEY_TV,=0A=
+	[ 0x18 ] =3D KEY_DVD,=0A=
+	[ 0x17 ] =3D KEY_STOP,=0A=
+	[ 0x16 ] =3D KEY_VIDEO,=0A=
+	[ 0x15 ] =3D KEY_AUDIO, /* Music */=0A=
+	[ 0x14 ] =3D KEY_SCREEN, /* Pic */=0A=
+	[ 0x13 ] =3D KEY_PLAY,=0A=
+	[ 0x12 ] =3D KEY_BACK,=0A=
+	[ 0x11 ] =3D KEY_REWIND,=0A=
+	[ 0x10 ] =3D KEY_FASTFORWARD,=0A=
+	[ 0x0b ] =3D KEY_PREVIOUS,=0A=
+	[ 0x07 ] =3D KEY_RECORD,=0A=
+	[ 0x03 ] =3D KEY_NEXT,=0A=
+};=0A=
+EXPORT_SYMBOL_GPL(ir_codes_mantis_vp2040);=0A=
+=0A=
 /* Encore ENLTV-FM v5.3=0A=
    Mauro Carvalho Chehab <mchehab@infradead.org>=0A=
  */=0A=
diff -r 2866ecb5e66b linux/drivers/media/dvb/mantis/Makefile=0A=
--- a/linux/drivers/media/dvb/mantis/Makefile	Sun Mar 15 18:24:26 2009 =
+0200=0A=
+++ b/linux/drivers/media/dvb/mantis/Makefile	Thu Apr 02 00:01:24 2009 =
+0200=0A=
@@ -12,7 +12,8 @@=0A=
 		mantis_vp1041.o	\=0A=
 		mantis_vp2033.o	\=0A=
 		mantis_vp2040.o	\=0A=
-		mantis_vp3030.o=0A=
+		mantis_vp3030.o \=0A=
+		mantis_rc.o=0A=
 =0A=
 obj-$(CONFIG_DVB_MANTIS) +=3D mantis.o=0A=
 =0A=
diff -r 2866ecb5e66b linux/drivers/media/dvb/mantis/mantis_common.h=0A=
--- a/linux/drivers/media/dvb/mantis/mantis_common.h	Sun Mar 15 18:24:26 =
2009 +0200=0A=
+++ b/linux/drivers/media/dvb/mantis/mantis_common.h	Thu Apr 02 00:01:24 =
2009 +0200=0A=
@@ -26,6 +26,8 @@=0A=
 #include <linux/kernel.h>=0A=
 #include <linux/pci.h>=0A=
 #include <linux/mutex.h>=0A=
+#include <linux/input.h>=0A=
+#include <media/ir-common.h>=0A=
 =0A=
 #include "dvbdev.h"=0A=
 #include "dvb_demux.h"=0A=
@@ -74,6 +76,20 @@=0A=
 	char			*model_name;=0A=
 	char			*dev_type;=0A=
 	u32			ts_size;=0A=
+	IR_KEYTAB_TYPE		*ir_codes;=0A=
+};=0A=
+=0A=
+struct mantis_ir {=0A=
+	struct input_dev	*rc_dev;=0A=
+	char			rc_name[80];=0A=
+	char			rc_phys[80];=0A=
+#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20)=0A=
+	struct work_struct	rc_query_work;=0A=
+#else=0A=
+	struct delayed_work	rc_query_work;=0A=
+#endif=0A=
+	u32			ir_last_code;=0A=
+	struct ir_input_state	ir;=0A=
 };=0A=
 =0A=
 struct mantis_pci {=0A=
@@ -142,6 +158,9 @@=0A=
 	u32			gpif_status;=0A=
 =0A=
 	struct mantis_ca	*mantis_ca;=0A=
+=0A=
+	/*	IR			*/=0A=
+	struct mantis_ir	ir;=0A=
 };=0A=
 =0A=
 #define MANTIS_HIF_STATUS	(mantis->gpio_status)=0A=
diff -r 2866ecb5e66b linux/drivers/media/dvb/mantis/mantis_core.c=0A=
--- a/linux/drivers/media/dvb/mantis/mantis_core.c	Sun Mar 15 18:24:26 =
2009 +0200=0A=
+++ b/linux/drivers/media/dvb/mantis/mantis_core.c	Thu Apr 02 00:01:24 =
2009 +0200=0A=
@@ -145,6 +145,10 @@=0A=
 		dprintk(verbose, MANTIS_DEBUG, 1, "Mantis DVB init failed");=0A=
 		return err;=0A=
 	}=0A=
+	if ((err =3D mantis_rc_init(mantis)) < 0) {=0A=
+		dprintk(verbose, MANTIS_DEBUG, 1, "Mantis RC init failed");=0A=
+		return err;=0A=
+	}=0A=
 =0A=
 	return 0;=0A=
 }=0A=
diff -r 2866ecb5e66b linux/drivers/media/dvb/mantis/mantis_core.h=0A=
--- a/linux/drivers/media/dvb/mantis/mantis_core.h	Sun Mar 15 18:24:26 =
2009 +0200=0A=
+++ b/linux/drivers/media/dvb/mantis/mantis_core.h	Thu Apr 02 00:01:24 =
2009 +0200=0A=
@@ -53,5 +53,7 @@=0A=
 extern int mantis_i2c_exit(struct mantis_pci *mantis);=0A=
 extern int mantis_core_init(struct mantis_pci *mantis);=0A=
 extern int mantis_core_exit(struct mantis_pci *mantis);=0A=
+extern int mantis_rc_init(struct mantis_pci *mantis);=0A=
+extern int mantis_rc_exit(struct mantis_pci *mantis);=0A=
 =0A=
 #endif //__MANTIS_CORE_H=0A=
diff -r 2866ecb5e66b linux/drivers/media/dvb/mantis/mantis_pci.c=0A=
--- a/linux/drivers/media/dvb/mantis/mantis_pci.c	Sun Mar 15 18:24:26 =
2009 +0200=0A=
+++ b/linux/drivers/media/dvb/mantis/mantis_pci.c	Thu Apr 02 00:01:24 =
2009 +0200=0A=
@@ -93,6 +93,7 @@=0A=
 		schedule_work(&ca->hif_evm_work);=0A=
 	}=0A=
 	if (stat & MANTIS_INT_IRQ1) {=0A=
+		mantis->ir.ir_last_code =3D mmread(0xe8);=0A=
 		dprintk(verbose, MANTIS_DEBUG, 0, "* INT IRQ-1 *");=0A=
 	}=0A=
 	if (stat & MANTIS_INT_OCERR) {=0A=
@@ -247,6 +248,7 @@=0A=
 		dprintk(verbose, MANTIS_ERROR, 1, "Aeio, Mantis NULL ptr");=0A=
 		return;=0A=
 	}=0A=
+	mantis_rc_exit(mantis);=0A=
 	mantis_core_exit(mantis);=0A=
 	dprintk(verbose, MANTIS_ERROR, 1, "Removing -->Mantis irq: %d, =
latency: %d\n memory: 0x%lx, mmio: 0x%p",=0A=
 		pdev->irq, mantis->latency, mantis->mantis_addr,=0A=
diff -r 2866ecb5e66b linux/drivers/media/dvb/mantis/mantis_rc.c=0A=
--- /dev/null	Thu Jan 01 00:00:00 1970 +0000=0A=
+++ b/linux/drivers/media/dvb/mantis/mantis_rc.c	Thu Apr 02 00:01:24 =
2009 +0200=0A=
@@ -0,0 +1,93 @@=0A=
+#include <linux/bitops.h>=0A=
+#include "mantis_common.h"=0A=
+#include "mantis_core.h"=0A=
+=0A=
+#include "dmxdev.h"=0A=
+#include "dvbdev.h"=0A=
+#include "dvb_demux.h"=0A=
+#include "dvb_frontend.h"=0A=
+#include "mantis_vp1033.h"=0A=
+#include "mantis_vp1034.h"=0A=
+#include "mantis_vp2033.h"=0A=
+#include "mantis_vp3030.h"=0A=
+=0A=
+#define POLL_FREQ 100=0A=
+=0A=
+void mantis_query_rc(struct work_struct *work)=0A=
+{=0A=
+        struct mantis_pci *mantis =3D=0A=
+                container_of(work, struct mantis_pci, =
ir.rc_query_work.work);=0A=
+        struct ir_input_state *ir =3D &mantis->ir.ir;=0A=
+=0A=
+        u32 lastkey =3D mantis->ir.ir_last_code;=0A=
+=0A=
+        if (lastkey !=3D -1) {=0A=
+                ir_input_keydown(mantis->ir.rc_dev, ir, lastkey, 0);=0A=
+                mantis->ir.ir_last_code =3D -1;=0A=
+        } else {=0A=
+                ir_input_nokey(mantis->ir.rc_dev, ir);=0A=
+        }=0A=
+        schedule_delayed_work(&mantis->ir.rc_query_work,=0A=
+		msecs_to_jiffies(POLL_FREQ));=0A=
+}=0A=
+=0A=
+int mantis_rc_init(struct mantis_pci *mantis)=0A=
+{=0A=
+        struct input_dev *rc_dev;=0A=
+        struct mantis_ir *mir =3D &mantis->ir;=0A=
+        struct ir_input_state *ir =3D &mir->ir;=0A=
+        int err;=0A=
+=0A=
+        if (!mantis->hwconfig->ir_codes) {=0A=
+                dprintk(verbose, MANTIS_DEBUG, 1, "No RC codes =
available");=0A=
+                return 0;=0A=
+        }=0A=
+=0A=
+        mmwrite(mmread(MANTIS_INT_MASK) | MANTIS_INT_IRQ1, =
MANTIS_INT_MASK);=0A=
+=0A=
+        rc_dev =3D input_allocate_device();=0A=
+        if (!rc_dev) {=0A=
+                dprintk(verbose, MANTIS_ERROR, 1, "dvb_rc_init failed");=0A=
+                return -ENOENT;=0A=
+        }=0A=
+=0A=
+        mir->rc_dev =3D rc_dev;=0A=
+=0A=
+        snprintf(mir->rc_name, sizeof(mir->rc_name), =0A=
+                 "Mantis %s IR Receiver", mantis->hwconfig->model_name);=0A=
+        snprintf(mir->rc_phys, sizeof(mir->rc_phys), =0A=
+                 "pci-%s/ir0", pci_name(mantis->pdev));=0A=
+=0A=
+        rc_dev->name =3D mir->rc_name;=0A=
+        rc_dev->phys =3D mir->rc_phys;=0A=
+=0A=
+        ir_input_init(rc_dev, ir, IR_TYPE_OTHER, =
mantis->hwconfig->ir_codes);=0A=
+=0A=
+        rc_dev->id.bustype =3D BUS_PCI;=0A=
+        rc_dev->id.vendor  =3D mantis->vendor_id;=0A=
+        rc_dev->id.product =3D mantis->device_id;=0A=
+        rc_dev->id.version =3D 1;=0A=
+=0A=
+        INIT_DELAYED_WORK(&mir->rc_query_work, mantis_query_rc);=0A=
+=0A=
+        err =3D input_register_device(rc_dev);=0A=
+        if (err) {=0A=
+                dprintk(verbose, MANTIS_ERROR, 1, "rc registering =
failed");=0A=
+                return -ENOENT;=0A=
+        }=0A=
+=0A=
+        schedule_delayed_work(&mir->rc_query_work,=0A=
+		msecs_to_jiffies(POLL_FREQ));=0A=
+        return 0;=0A=
+}=0A=
+=0A=
+int mantis_rc_exit(struct mantis_pci *mantis)=0A=
+{=0A=
+        mmwrite(mmread(MANTIS_INT_MASK) & (~MANTIS_INT_IRQ1), =
MANTIS_INT_MASK);=0A=
+=0A=
+        cancel_delayed_work(&mantis->ir.rc_query_work);=0A=
+	flush_scheduled_work();=0A=
+        input_unregister_device(mantis->ir.rc_dev);=0A=
+        dprintk(verbose, MANTIS_DEBUG, 1, "RC unregistered");=0A=
+        return 0;=0A=
+}=0A=
diff -r 2866ecb5e66b linux/drivers/media/dvb/mantis/mantis_vp1041.c=0A=
--- a/linux/drivers/media/dvb/mantis/mantis_vp1041.c	Sun Mar 15 18:24:26 =
2009 +0200=0A=
+++ b/linux/drivers/media/dvb/mantis/mantis_vp1041.c	Thu Apr 02 00:01:24 =
2009 +0200=0A=
@@ -31,6 +31,7 @@=0A=
 	.model_name	=3D MANTIS_MODEL_NAME,=0A=
 	.dev_type	=3D MANTIS_DEV_TYPE,=0A=
 	.ts_size	=3D MANTIS_TS_188,=0A=
+	.ir_codes       =3D ir_codes_mantis_vp1041,=0A=
 };=0A=
 =0A=
 static const struct stb0899_s1_reg vp1041_stb0899_s1_init_1[] =3D {=0A=
diff -r 2866ecb5e66b linux/drivers/media/dvb/mantis/mantis_vp2033.c=0A=
--- a/linux/drivers/media/dvb/mantis/mantis_vp2033.c	Sun Mar 15 18:24:26 =
2009 +0200=0A=
+++ b/linux/drivers/media/dvb/mantis/mantis_vp2033.c	Thu Apr 02 00:01:24 =
2009 +0200=0A=
@@ -28,6 +28,7 @@=0A=
 	.model_name	=3D MANTIS_MODEL_NAME,=0A=
 	.dev_type	=3D MANTIS_DEV_TYPE,=0A=
 	.ts_size	=3D MANTIS_TS_204,=0A=
+	.ir_codes	=3D ir_codes_mantis_vp2033,=0A=
 };=0A=
 =0A=
 struct tda1002x_config philips_cu1216_config =3D {=0A=
diff -r 2866ecb5e66b linux/drivers/media/dvb/mantis/mantis_vp2040.c=0A=
--- a/linux/drivers/media/dvb/mantis/mantis_vp2040.c	Sun Mar 15 18:24:26 =
2009 +0200=0A=
+++ b/linux/drivers/media/dvb/mantis/mantis_vp2040.c	Thu Apr 02 00:01:24 =
2009 +0200=0A=
@@ -28,6 +28,7 @@=0A=
 	.model_name	=3D MANTIS_MODEL_NAME,=0A=
 	.dev_type	=3D MANTIS_DEV_TYPE,=0A=
 	.ts_size	=3D MANTIS_TS_204,=0A=
+	.ir_codes       =3D ir_codes_mantis_vp2040,=0A=
 };=0A=
 =0A=
 struct tda10023_config tda10023_cu1216_config =3D {=0A=
diff -r 2866ecb5e66b linux/include/media/ir-common.h=0A=
--- a/linux/include/media/ir-common.h	Sun Mar 15 18:24:26 2009 +0200=0A=
+++ b/linux/include/media/ir-common.h	Thu Apr 02 00:01:24 2009 +0200=0A=
@@ -156,6 +156,9 @@=0A=
 extern IR_KEYTAB_TYPE ir_codes_genius_tvgo_a11mce[IR_KEYTAB_SIZE];=0A=
 extern IR_KEYTAB_TYPE ir_codes_powercolor_real_angel[IR_KEYTAB_SIZE];=0A=
 extern IR_KEYTAB_TYPE ir_codes_avermedia_a16d[IR_KEYTAB_SIZE];=0A=
+extern IR_KEYTAB_TYPE ir_codes_mantis_vp1041[IR_KEYTAB_SIZE];=0A=
+extern IR_KEYTAB_TYPE ir_codes_mantis_vp2033[IR_KEYTAB_SIZE];=0A=
+extern IR_KEYTAB_TYPE ir_codes_mantis_vp2040[IR_KEYTAB_SIZE];=0A=
 extern IR_KEYTAB_TYPE ir_codes_encore_enltv_fm53[IR_KEYTAB_SIZE];=0A=
 extern IR_KEYTAB_TYPE ir_codes_real_audio_220_32_keys[IR_KEYTAB_SIZE];=0A=
 extern IR_KEYTAB_TYPE ir_codes_msi_tvanywhere_plus[IR_KEYTAB_SIZE];=0A=

------=_NextPart_000_0024_01C9C25F.C4B333D0--

