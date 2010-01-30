Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:63997 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902Ab0A3IEh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 30 Jan 2010 03:04:37 -0500
Received: by bwz27 with SMTP id 27so1979918bwz.21
        for <linux-media@vger.kernel.org>; Sat, 30 Jan 2010 00:04:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <d7fc510e1001290151q3520d106g88aceca5db22778b@mail.gmail.com>
References: <d7fc510e1001290151q3520d106g88aceca5db22778b@mail.gmail.com>
Date: Sat, 30 Jan 2010 11:04:34 +0300
Message-ID: <d7fc510e1001300004t7a75f553ya74a6d38a8e5cd43@mail.gmail.com>
Subject: [PATCH] Add support for Twinhan 1027 DVB-S card
From: Sergey Ivanov <123kash@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This patch is the modified version of sfstudio (Denis Romanenko)
patch, adapted for current mercurial revision.

diff -r d6520e486ee6 linux/drivers/media/video/cx88/cx88-cards.c
--- a/linux/drivers/media/video/cx88/cx88-cards.c       Sat Jan 30
01:27:34 2010 -0200
+++ b/linux/drivers/media/video/cx88/cx88-cards.c       Sat Jan 30
11:02:24 2010 +0300
@@ -2120,6 +2120,18 @@
                } },
                .mpeg           = CX88_MPEG_DVB,
        },
+       [CX88_BOARD_TWINHAN_VP1027_DVBS] = {
+               .name           = "Twinhan VP-1027 DVB-S",
+               .tuner_type     = TUNER_ABSENT,
+               .radio_type     = UNSET,
+               .tuner_addr     = ADDR_UNSET,
+               .radio_addr     = ADDR_UNSET,
+               .input          = {{
+                      .type   = CX88_VMUX_DVB,
+                      .vmux   = 0,
+               } },
+               .mpeg           = CX88_MPEG_DVB,
+       },
 };

 /* ------------------------------------------------------------------ */
@@ -2584,6 +2596,10 @@
                .subvendor = 0xb034,
                .subdevice = 0x3034,
                .card      = CX88_BOARD_PROF_7301,
+       }, {
+               .subvendor = 0x1822,
+               .subdevice = 0x0023,
+               .card      = CX88_BOARD_TWINHAN_VP1027_DVBS,
        },
 };

@@ -3075,6 +3091,13 @@
                cx_set(MO_GP1_IO, 0x10);
                mdelay(50);
                break;
+
+       case CX88_BOARD_TWINHAN_VP1027_DVBS:
+               cx_write(MO_GP0_IO, 0x00003230);
+               cx_write(MO_GP0_IO, 0x00003210);
+               msleep(1);
+               cx_write(MO_GP0_IO, 0x00001230);
+               break;
        }
 }

diff -r d6520e486ee6 linux/drivers/media/video/cx88/cx88-dvb.c
--- a/linux/drivers/media/video/cx88/cx88-dvb.c Sat Jan 30 01:27:34 2010 -0200
+++ b/linux/drivers/media/video/cx88/cx88-dvb.c Sat Jan 30 11:02:24 2010 +0300
@@ -57,6 +57,7 @@
 #include "stv0900.h"
 #include "stb6100.h"
 #include "stb6100_proc.h"
+#include "mb86a16.h"

 MODULE_DESCRIPTION("driver for cx2388x based DVB cards");
 MODULE_AUTHOR("Chris Pascoe <c.pascoe@itee.uq.edu.au>");
@@ -251,6 +252,10 @@
        .if2           = 45600,
 };

+static struct mb86a16_config twinhan_vp1027 = {
+       .demod_address  = 0x08,
+};
+
 #if defined(CONFIG_VIDEO_CX88_VP3054) ||
(defined(CONFIG_VIDEO_CX88_VP3054_MODULE) && defined(MODULE))
 static int dntv_live_dvbt_pro_demod_init(struct dvb_frontend* fe)
 {
@@ -430,15 +435,41 @@

        cx_set(MO_GP0_IO, 0x6040);
        switch (voltage) {
-               case SEC_VOLTAGE_13:
-                       cx_clear(MO_GP0_IO, 0x20);
-                       break;
-               case SEC_VOLTAGE_18:
-                       cx_set(MO_GP0_IO, 0x20);
-                       break;
-               case SEC_VOLTAGE_OFF:
-                       cx_clear(MO_GP0_IO, 0x20);
-                       break;
+       case SEC_VOLTAGE_13:
+               cx_clear(MO_GP0_IO, 0x20);
+               break;
+       case SEC_VOLTAGE_18:
+               cx_set(MO_GP0_IO, 0x20);
+               break;
+       case SEC_VOLTAGE_OFF:
+               cx_clear(MO_GP0_IO, 0x20);
+               break;
+       }
+
+       if (core->prev_set_voltage)
+               return core->prev_set_voltage(fe, voltage);
+       return 0;
+}
+
+static int vp1027_set_voltage(struct dvb_frontend *fe,
+                                   fe_sec_voltage_t voltage)
+{
+       struct cx8802_dev *dev = fe->dvb->priv;
+       struct cx88_core *core = dev->core;
+
+       switch (voltage) {
+       case SEC_VOLTAGE_13:
+               dprintk(1, "LNB SEC Voltage=13\n");
+               cx_write(MO_GP0_IO, 0x00001220);
+               break;
+       case SEC_VOLTAGE_18:
+               dprintk(1, "LNB SEC Voltage=18\n");
+               cx_write(MO_GP0_IO, 0x00001222);
+               break;
+       case SEC_VOLTAGE_OFF:
+               dprintk(1, "LNB Voltage OFF\n");
+               cx_write(MO_GP0_IO, 0x00001230);
+               break;
        }

        if (core->prev_set_voltage)
@@ -1210,6 +1241,19 @@
                }
                break;
                }
+       case CX88_BOARD_TWINHAN_VP1027_DVBS:
+               dev->ts_gen_cntrl = 0x00;
+               fe0->dvb.frontend = dvb_attach(mb86a16_attach,
+                                               &twinhan_vp1027,
+                                               &core->i2c_adap);
+               if (fe0->dvb.frontend) {
+                       core->prev_set_voltage =
+                                       fe0->dvb.frontend->ops.set_voltage;
+                       fe0->dvb.frontend->ops.set_voltage =
+                                       vp1027_set_voltage;
+               }
+               break;
+
        default:
                printk(KERN_ERR "%s/2: The frontend of your DVB/ATSC
card isn't supported yet\n",
                       core->name);
diff -r d6520e486ee6 linux/drivers/media/video/cx88/cx88.h
--- a/linux/drivers/media/video/cx88/cx88.h     Sat Jan 30 01:27:34 2010 -0200
+++ b/linux/drivers/media/video/cx88/cx88.h     Sat Jan 30 11:02:24 2010 +0300
@@ -240,6 +240,7 @@
 #define CX88_BOARD_WINFAST_DTV1800H        81
 #define CX88_BOARD_WINFAST_DTV2000H_J      82
 #define CX88_BOARD_PROF_7301               83
+#define CX88_BOARD_TWINHAN_VP1027_DVBS     84

 enum cx88_itype {
        CX88_VMUX_COMPOSITE1 = 1,


--------------------------------------------------------------
WBR Sergey Kash Ivanov
