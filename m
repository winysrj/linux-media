Return-path: <mchehab@pedra>
Received: from smtp6-g21.free.fr ([212.27.42.6]:50839 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932892Ab1ESVNk (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 May 2011 17:13:40 -0400
Received: from UNKNOWN (unknown [172.20.243.135])
	by smtp6-g21.free.fr (Postfix) with ESMTP id AD50F8225D
	for <linux-media@vger.kernel.org>; Thu, 19 May 2011 23:13:32 +0200 (CEST)
Message-ID: <1305839612.4dd587fc20a03@imp.free.fr>
Date: Thu, 19 May 2011 23:13:32 +0200
From: wallak@free.fr
To: linux-media@vger.kernel.org
Subject: AverMedia A306 (cx23385, xc3028, af9013) (A577 too ?)
References: <S932606Ab1ESVJJ/20110519210909Z+86@vger.kernel.org>
In-Reply-To: <S932606Ab1ESVJJ/20110519210909Z+86@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hello All,

I've tried to use my A306 board on my system. All the main chips are fully
supported by linux.

At this stage the CX23385 and the tuner: xc3028 seem to respond properly. But
the DVB-T chip (af9013) is silent. Nevertheless both chips are visible on the
I2C bus.

I've no full datasheet of theses chips. with exception of the af9013 where this
information is available:
http://wenku.baidu.com/view/42240f72f242336c1eb95e08.html

At this stage the CLK signal of the DVB-T chip may be missing or something is
wrong elsewhere.

If you have the datasheets... Any help will be appreciated.


Best Regards,
Wallak.




diff -u -r -b -B -w -x '*.o' -x '*.cmd' -x '*.ko' -x '*.mod.c' -x 'modules.*'
tmp/linux-2.6.37.6/drivers/media/common/tuners/tuner-xc2028.c
linux-2.6.37.6-mdf/drivers/media/common/tuners/tuner-xc2028.c
--- linux-2.6.37.6/drivers/media/common/tuners/tuner-xc2028.c    2011-03-27
21:01:41.000000000 +0200
+++ linux-2.6.37.6-mdf/drivers/media/common/tuners/tuner-xc2028.c    2011-05-07
23:30:20.000000000 +0200
@@ -813,6 +813,10 @@
           hwmodel, (version & 0xf000) >> 12, (version & 0xf00) >> 8,
           (version & 0xf0) >> 4, version & 0xf);

+    {
+      void af9013_execdebug(struct dvb_frontend *fe);
+      af9013_execdebug(fe);
+    }

     if (priv->ctrl.read_not_reliable)
         goto read_not_reliable;
diff -u -r -b -B -w -x '*.o' -x '*.cmd' -x '*.ko' -x '*.mod.c' -x 'modules.*'
tmp/linux-2.6.37.6/drivers/media/dvb/frontends/af9013.c
linux-2.6.37.6-mdf/drivers/media/dvb/frontends/af9013.c
--- linux-2.6.37.6/drivers/media/dvb/frontends/af9013.c    2011-03-27
21:01:41.000000000 +0200
+++ linux-2.6.37.6-mdf/drivers/media/dvb/frontends/af9013.c    2011-05-15
02:58:34.000000000 +0200
@@ -69,6 +69,8 @@
     buf[2] = mbox;
     memcpy(&buf[3], val, len);

+    printk(KERN_DEBUG "af9013_write_regs(%02x, %02x %02x
%02x)\n",state->config.demod_address,buf[0],buf[1],buf[2]);
+
     if (i2c_transfer(state->i2c, &msg, 1) != 1) {
         warn("I2C write failed reg:%04x len:%d", reg, len);
         return -EREMOTEIO;
@@ -119,6 +121,10 @@
         warn("I2C read failed reg:%04x", reg);
         return -EREMOTEIO;
     }
+
+        printk(KERN_DEBUG "af9013_read_reg(%02x, %02x %02x %02x)
=%02x\n",state->config.demod_address,reg >> 8,reg & 0xff, 0, ibuf[0]);
+
+
     *val = ibuf[0];
     return 0;
 }
@@ -1448,6 +1454,22 @@
     kfree(state);
 }

+void af9013_execdebug(struct dvb_frontend *fe)
+{
+  struct af9013_state *state = fe->demodulator_priv;
+  u8 val;
+  u8 buf[4];
+  int ret, i;
+
+  ret = af9013_read_reg(state, 0x98be, &val);
+  printk(KERN_DEBUG "(0x0c) running = %02x, ret=%02x\n",val, ret);
+
+  ret = af9013_read_reg_bits(state, 0xd733, 4, 4, &buf[2]);
+  for (i = 0; i < 2; i++) { ret = af9013_read_reg(state, 0x116b + i, &buf[i]);
}
+  printk(KERN_DEBUG "%s: chip version:%d ROM version:%d.%d (ret=%d)\n",
__func__, buf[2], buf[0], buf[1], ret);
+}
+EXPORT_SYMBOL(af9013_execdebug);
+
 static struct dvb_frontend_ops af9013_ops;

 struct dvb_frontend *af9013_attach(const struct af9013_config *config,
@@ -1484,7 +1506,18 @@
     if (state->config.output_mode != AF9013_OUTPUT_MODE_USB) {
         ret = af9013_download_firmware(state);
         if (ret)
-            goto error;
+          {
+            deb_info("%s: continue...\n", __func__);
+
+            /* create dvb_frontend */
+            memcpy(&state->frontend.ops, &af9013_ops,
+               sizeof(struct dvb_frontend_ops));
+            state->frontend.demodulator_priv = state;
+
+            return &state->frontend;
+
+            //goto error;
+          }
     }

     /* firmware version */
diff -u -r -b -B -w -x '*.o' -x '*.cmd' -x '*.ko' -x '*.mod.c' -x 'modules.*'
tmp/linux-2.6.37.6/drivers/media/video/cx23885/cx23885-cards.c
linux-2.6.37.6-mdf/drivers/media/video/cx23885/cx23885-cards.c
--- linux-2.6.37.6/drivers/media/video/cx23885/cx23885-cards.c    2011-03-27
21:01:41.000000000 +0200
+++ linux-2.6.37.6-mdf/drivers/media/video/cx23885/cx23885-cards.c    2011-05-15
04:12:20.000000000 +0200
@@ -275,6 +275,10 @@
         .name        = "Compro VideoMate E800",
         .portc        = CX23885_MPEG_DVB,
     },
+    [CX23885_BOARD_AVERMEDIA_A306] = {
+        .name        = "Avermedia A306",
+        .portc        = CX23885_MPEG_DVB,
+    },
     [CX23885_BOARD_HAUPPAUGE_HVR1290] = {
         .name        = "Hauppauge WinTV-HVR1290",
         .portc        = CX23885_MPEG_DVB,
@@ -485,6 +489,10 @@
         .subdevice = 0xe800,
         .card      = CX23885_BOARD_COMPRO_VIDEOMATE_E800,
     }, {
+            .subvendor = 0x1461,
+        .subdevice = 0xc139,
+        .card      = CX23885_BOARD_AVERMEDIA_A306,
+    }, {
         .subvendor = 0x0070,
         .subdevice = 0x8551,
         .card      = CX23885_BOARD_HAUPPAUGE_HVR1290,
@@ -967,6 +975,31 @@
         /* CX24228 GPIO */
         /* Connected to IF / Mux */
         break;
+    case CX23885_BOARD_AVERMEDIA_A306:
+      // ?? PIO0: 1:on 0:nothing work
+      // ?? PIO1: demodulator address 1: 0x1c, 0:0x1d ??
+      // ?? PIO2: tuner reset ?
+      // ?? PIO3: demodulator reset ?
+      printk(KERN_INFO "gpio...\n");
+
+      cx_set(GP0_IO, 0x000f0000);
+      mdelay(100);
+      cx_clear(GP0_IO, 0x0000000f);
+      mdelay(100);
+
+
+      cx_set(GP0_IO, 0x000f0000 | (1<<3) | (1<<2) | (1<<1) | (0<<0));
+      mdelay(100);
+      //cx_clear(GP0_IO, 0x00000000 | (1<<3) | (1<<2));
+      cx_set(GP0_IO, 0x000f0000 | (1<<3) | (0<<2) | (1<<1) | (0<<0));
+      mdelay(100);
+      cx_set(GP0_IO, 0x000f0000 | (1<<3) | (0<<2) | (1<<1) | (1<<0));
+      //cx_clear(GP0_IO, 0x0000000f);
+      //cx_set(GP0_IO, 0x00000003);
+      //cx_clear(GP0_IO, 0x00000002);
+          mdelay(100);
+
+      break;
     }
 }

@@ -1012,6 +1045,7 @@
     case CX23885_BOARD_HAUPPAUGE_HVR1275:
     case CX23885_BOARD_HAUPPAUGE_HVR1255:
     case CX23885_BOARD_HAUPPAUGE_HVR1210:
+    case CX23885_BOARD_AVERMEDIA_A306:
         /* FIXME: Implement me */
         break;
     case CX23885_BOARD_HAUPPAUGE_HVR1850:
@@ -1258,6 +1292,7 @@
     /* AUX-PLL 27MHz CLK */
     switch (dev->board) {
     case CX23885_BOARD_NETUP_DUAL_DVBS2_CI:
+      //case CX23885_BOARD_AVERMEDIA_A306:
         netup_initialize(dev);
         break;
     }
diff -u -r -b -B -w -x '*.o' -x '*.cmd' -x '*.ko' -x '*.mod.c' -x 'modules.*'
tmp/linux-2.6.37.6/drivers/media/video/cx23885/cx23885-dvb.c
linux-2.6.37.6-mdf/drivers/media/video/cx23885/cx23885-dvb.c
--- linux-2.6.37.6/drivers/media/video/cx23885/cx23885-dvb.c    2011-03-27
21:01:41.000000000 +0200
+++ linux-2.6.37.6-mdf/drivers/media/video/cx23885/cx23885-dvb.c    2011-05-15
04:03:54.000000000 +0200
@@ -48,6 +48,7 @@
 #include "stv0900.h"
 #include "stv0900_reg.h"
 #include "stv6110.h"
+#include "af9013.h"
 #include "lnbh24.h"
 #include "cx24116.h"
 #include "cimax2.h"
@@ -571,6 +572,14 @@
     .osc_clk = 20
 };

+static struct af9013_config af9013_config = {
+  .demod_address = (0x1c << 1),                         /* #define
AF9015_I2C_DEMOD   0x38 */ /*0x1c or 0x1d*/
+  .output_mode   = AF9013_OUTPUT_MODE_PARALLEL,
+  .api_version = { 0, 1, 9, 0 },
+  /*.gpio[0] = AF9013_GPIO_TUNER_ON,
+    .gpio[1] = AF9013_GPIO_LO,*/
+};
+
 static int dvb_register(struct cx23885_tsport *port)
 {
     struct cx23885_dev *dev = port->dev;
@@ -966,6 +975,34 @@
             break;
         }
         break;
+    case CX23885_BOARD_AVERMEDIA_A306:
+      printk("# %d\n", port->nr - 1);
+      i2c_bus = &dev->i2c_bus[0];
+
+      fe0->dvb.frontend = dvb_attach(af9013_attach,
+                     &af9013_config,
+                     &i2c_bus->i2c_adap);
+
+      if (fe0->dvb.frontend != NULL || 1) {
+        struct dvb_frontend *fe;
+        struct xc2028_config cfg = {
+          .i2c_adap  = &dev->i2c_bus[1].i2c_adap,
+          .i2c_addr  = 0x61,
+        };
+        static struct xc2028_ctrl ctl = {
+          .fname       = XC2028_DEFAULT_FIRMWARE,
+          .max_len     = 64,
+          .demod       = XC3028_FE_ZARLINK456 /*XC3028_FE_OREN538: Loading
SCODE for type=DTV6 ATSC OREN538 SCODE HAS_IF_5580 (60110020)*/,
+        };
+
+        printk(KERN_INFO "xc2028_attach %p\n", fe0->dvb.frontend);
+        fe = dvb_attach(xc2028_attach, fe0->dvb.frontend, &cfg);
+        printk(KERN_INFO "xc2028_attach %p\n", fe);
+        if (fe != NULL && fe->ops.tuner_ops.set_config != NULL) {
+            fe->ops.tuner_ops.set_config(fe, &ctl);
+        }
+      }
+      break;

     default:
         printk(KERN_INFO "%s: The frontend of your DVB/ATSC card "
diff -u -r -b -B -w -x '*.o' -x '*.cmd' -x '*.ko' -x '*.mod.c' -x 'modules.*'
tmp/linux-2.6.37.6/drivers/media/video/cx23885/cx23885.h
linux-2.6.37.6-mdf/drivers/media/video/cx23885/cx23885.h
--- linux-2.6.37.6/drivers/media/video/cx23885/cx23885.h    2011-03-27
21:01:41.000000000 +0200
+++ linux-2.6.37.6-mdf/drivers/media/video/cx23885/cx23885.h    2011-05-05
02:58:01.000000000 +0200
@@ -84,6 +84,7 @@
 #define CX23885_BOARD_HAUPPAUGE_HVR1290        26
 #define CX23885_BOARD_MYGICA_X8558PRO          27
 #define CX23885_BOARD_LEADTEK_WINFAST_PXTV1200 28
+#define CX23885_BOARD_AVERMEDIA_A306           29

 #define GPIO_0 0x00000001
 #define GPIO_1 0x00000002
