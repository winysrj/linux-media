Return-path: <linux-media-owner@vger.kernel.org>
Received: from web39105.mail.mud.yahoo.com ([209.191.87.224]:25010 "HELO
	web39105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752646AbZGRCbo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 17 Jul 2009 22:31:44 -0400
Message-ID: <1257.76939.qm@web39105.mail.mud.yahoo.com>
Date: Fri, 17 Jul 2009 19:31:43 -0700 (PDT)
From: James Guo <jinp65@yahoo.com>
Subject: [PATCH] saa7134 - ir remote for sinovideo 1300
To: linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Have a tv tuner believe to be sinovideo 1300, and the remote has h-338 in the back, the tuner is detected as saa7134 proteus 2309, and working fine, the patch is for the remote.

following buttons supposed to be working: all the number button, channel up and down, volumn up and down, off, mute, full screen, recall, snapshot, tv.  Some buttons do not have valid entry for tvtime, so I did not map them(record, stop ...)

to apply, use command
modprobe saa7134 card=157
if it does not work, use
modprobe saa7134 card=157 ir_debug=1
and send me(yahoo.com) the output of dmesg(after modprobe and after a button is pressed)

--- a/include/media/ir-common.h    2009-07-08 19:28:50.000000000 -0400
+++ b/include/media/ir-common.h    2009-07-16 01:37:41.000000000 -0400
@@ -162,6 +162,7 @@
 extern IR_KEYTAB_TYPE ir_codes_kworld_plus_tv_analog[IR_KEYTAB_SIZE];
 extern IR_KEYTAB_TYPE ir_codes_kaiomy[IR_KEYTAB_SIZE];
 extern IR_KEYTAB_TYPE ir_codes_dm1105_nec[IR_KEYTAB_SIZE];
+extern IR_KEYTAB_TYPE ir_codes_sinovideo_1300[IR_KEYTAB_SIZE];
 #endif
 
 /*
--- a/drivers/media/common/ir-keymaps.c    2009-07-08 19:28:49.000000000 -0400
+++ b/drivers/media/common/ir-keymaps.c    2009-07-16 13:17:30.000000000 -0400
@@ -62,6 +62,38 @@
 };
 
 EXPORT_SYMBOL_GPL(ir_codes_proteus_2309);
+
+IR_KEYTAB_TYPE ir_codes_sinovideo_1300[IR_KEYTAB_SIZE] = {
+    /* numeric */
+    [ 0x00 ] = KEY_0,
+    [ 0x01 ] = KEY_1,
+    [ 0x02 ] = KEY_2,
+    [ 0x03 ] = KEY_3,
+    [ 0x04 ] = KEY_4,
+    [ 0x05 ] = KEY_5,
+    [ 0x06 ] = KEY_6,
+    [ 0x07 ] = KEY_7,
+    [ 0x08 ] = KEY_8,
+    [ 0x09 ] = KEY_9,
+
+    [ 0x5c ] = KEY_POWER,     /* power       */
+    [ 0x20 ] = KEY_F,         /* full screen */
+    [ 0x0f ] = KEY_BACKSPACE, /* recall      */
+    [ 0x1b ] = KEY_M,         /* mute        */
+    [ 0x41 ] = KEY_RECORD,    /* record      */
+    [ 0x43 ] = KEY_STOP,      /* stop        */
+    [ 0x16 ] = KEY_S,         /* snapshot    */
+    [ 0x1a ] = KEY_Q,         /* off         */
+    [ 0x2e ] = KEY_RED,
+    [ 0x1f ] = KEY_DOWN,      /* channel -   */
+    [ 0x1c ] = KEY_UP,        /* channel +   */
+    [ 0x10 ] = KEY_LEFT,      /* volume -    */
+    [ 0x1e ] = KEY_RIGHT,     /* volume +    */
+    [ 0x14 ] = KEY_F1,
+    [ 0x15 ] = KEY_I,         /* tv          */
+};
+
+EXPORT_SYMBOL_GPL(ir_codes_sinovideo_1300);
 /* Matt Jesson <dvb@jesson.eclipse.co.uk */
 IR_KEYTAB_TYPE ir_codes_avermedia_dvbt[IR_KEYTAB_SIZE] = {
     [ 0x28 ] = KEY_0,         //'0' / 'enter'
--- a/drivers/media/video/saa7134/saa7134-cards.c    2009-07-08 19:28:49.000000000 -0400
+++ b/drivers/media/video/saa7134/saa7134-cards.c    2009-07-15 22:37:16.000000000 -0400
@@ -4744,6 +4744,37 @@
             .gpio = 0x01,
         },
     },
+    [SAA7134_BOARD_SINOVIDEO_1300] = {
+        .name           = "Sinovideo 1300",
+        .audio_clock    = 0x00187de7,
+        .tuner_type    = TUNER_PHILIPS_FM1216ME_MK3,
+        .radio_type     = UNSET,
+        .tuner_addr    = ADDR_UNSET,
+        .radio_addr    = ADDR_UNSET,
+        .tda9887_conf   = TDA9887_PRESENT,
+        .inputs         = {{
+            .name = name_tv,
+            .vmux = 1,
+            .amux = LINE2,
+            .tv   = 1,
+        },{
+            .name = name_comp1,
+            .vmux = 0,
+            .amux = LINE2,
+        },{
+            .name = name_comp2,
+            .vmux = 3,
+            .amux = LINE2,
+        },{
+            .name = name_svideo,
+            .vmux = 8,
+            .amux = LINE2,
+        }},
+        .mute = {
+            .name = name_mute,
+            .amux = LINE1,
+        },
+    },
 };
 
 const unsigned int saa7134_bcount = ARRAY_SIZE(saa7134_boards);
@@ -5838,6 +5869,12 @@
         .subvendor    = 0x1461, /* Avermedia Technologies Inc */
         .subdevice    = 0xf31d,
         .driver_data  = SAA7134_BOARD_AVERMEDIA_GO_007_FM_PLUS,
+    },{
+        .vendor       = PCI_VENDOR_ID_PHILIPS,
+        .device       = PCI_DEVICE_ID_PHILIPS_SAA7130,
+        .subvendor    = 0x0919,
+        .subdevice    = 0x2003,
+        .driver_data  = SAA7134_BOARD_SINOVIDEO_1300,
 
     }, {
         /* --- boards without eeprom + subsystem ID --- */
@@ -6133,6 +6170,7 @@
     case SAA7134_BOARD_REAL_ANGEL_220:
     case SAA7134_BOARD_KWORLD_PLUS_TV_ANALOG:
     case SAA7134_BOARD_AVERMEDIA_GO_007_FM_PLUS:
+    case SAA7134_BOARD_SINOVIDEO_1300:
         dev->has_remote = SAA7134_REMOTE_GPIO;
         break;
     case SAA7134_BOARD_FLYDVBS_LR300:
--- a/drivers/media/video/saa7134/saa7134.h    2009-07-08 19:28:49.000000000 -0400
+++ b/drivers/media/video/saa7134/saa7134.h    2009-07-16 15:31:54.000000000 -0400
@@ -280,6 +280,7 @@
 #define SAA7134_BOARD_AVERMEDIA_GO_007_FM_PLUS 154
 #define SAA7134_BOARD_HAUPPAUGE_HVR1120     155
 #define SAA7134_BOARD_HAUPPAUGE_HVR1110R3   156
+#define SAA7134_BOARD_SINOVIDEO_1300   157
 
 #define SAA7134_MAXBOARDS 32
 #define SAA7134_INPUT_MAX 8
--- a/drivers/media/video/saa7134/saa7134-input.c    2009-03-23 19:12:14.000000000 -0400
+++ b/drivers/media/video/saa7134/saa7134-input.c    2009-07-16 15:08:50.000000000 -0400
@@ -67,6 +67,7 @@
 static int saa7134_nec_irq(struct saa7134_dev *dev);
 static void nec_task(unsigned long data);
 static void saa7134_nec_timer(unsigned long data);
+static void ir_sv_timer_end(unsigned long data);
 
 /* -------------------- GPIO generic keycode builder -------------------- */
 
@@ -367,7 +368,10 @@
     } else if (ir->rc5_gpio) {
         /* set timer_end for code completion */
         init_timer(&ir->timer_end);
-        ir->timer_end.function = ir_rc5_timer_end;
+        if (dev->board == SAA7134_BOARD_SINOVIDEO_1300)
+            ir->timer_end.function = ir_sv_timer_end;
+        else
+            ir->timer_end.function = ir_rc5_timer_end;
         ir->timer_end.data = (unsigned long)ir;
         init_timer(&ir->timer_keyup);
         ir->timer_keyup.function = ir_rc5_timer_keyup;
@@ -601,6 +605,13 @@
         mask_keycode = 0x7f;
         polling = 40; /* ms */
         break;
+    case SAA7134_BOARD_SINOVIDEO_1300:
+        ir_codes     = ir_codes_sinovideo_1300;
+        mask_keycode = 0x00007F;
+        mask_keyup   = 0x040000;
+        rc5_gpio = 1;
+        ir_rc5_remote_gap = 1125;
+        break;
     }
     if (NULL == ir_codes) {
         printk("%s: Oops: IR config error [card=%d]\n",
@@ -748,6 +759,7 @@
             tv.tv_usec - ir->base_time.tv_usec;
     }
 
+    dprintk("gap is %d\n", gap);
     /* active code => add bit */
     if (ir->active) {
         /* only if in the code (otherwise spurious IRQ or timer
@@ -764,7 +776,10 @@
         ir->base_time = tv;
         ir->last_bit = 0;
 
-        timeout = current_jiffies + (500 + 30 * HZ) / 1000;
+        if (dev->board == SAA7134_BOARD_SINOVIDEO_1300)
+            timeout = current_jiffies + (500 + 35 * HZ) / 1000;
+        else
+            timeout = current_jiffies + (500 + 30 * HZ) / 1000;
         mod_timer(&ir->timer_end, timeout);
     }
 
@@ -893,3 +908,140 @@
 
     return 1;
 }
+
+static u32 ir_sv_decode(unsigned int code)
+{
+    u32 sv5;
+
+    switch (code) {
+    case 0xaaaaffa:
+        sv5 = 0x1c;
+        break;
+    case 0xaaabfea:
+        sv5 = 0x1f;
+        break;
+    case 0xaaadfda:
+        sv5 = 0x1e;
+        break;
+    case 0xaaaffaa:
+        sv5 = 0x10;
+        break;
+    case 0xaabbf5a:
+        sv5 = 0x16;
+        break;
+    case 0xaabfeaa:
+        sv5 = 0x0f;
+        break;
+    case 0xaad5f7a:
+        sv5 = 0x43; //stop
+        break;
+    case 0xaad7eea:
+        sv5 = 0x41; //record
+        break;
+    case 0xaadbeda:
+        sv5 = 0x1a;
+        break;
+    case 0xaadfdaa:
+        //sv5 = 0x09; //FM
+        break;
+    case 0xaaebeba:
+        //sv5 = 0x04; //POWER
+        break;
+    case 0xaaffaaa:
+        //sv5 = 0x1b; //TIMESHIFT
+        break;
+    case 0xab55efa:
+        sv5 = 0x00;
+        break;
+    case 0xab57dea:
+        sv5 = 0x01;
+        break;
+    case 0xab5bdda:
+        sv5 = 0x02;
+        break;
+    case 0xab5fbaa:
+        sv5 = 0x03;
+        break;
+    case 0xab6bdba:
+        sv5 = 0x04;
+        break;
+    case 0xab6fb6a:
+        sv5 = 0x05;
+        break;
+    case 0xab77b5a:
+        sv5 = 0x06;
+        break;
+    case 0xab7f6aa:
+        sv5 = 0x07;
+        break;
+    case 0xababd7a:
+        sv5 = 0x08;
+        break;
+    case 0xabafaea:
+        sv5 = 0x09;
+        break;
+    case 0xabb7ada:
+        sv5 = 0x20;
+        break;
+    case 0xabbf5aa:
+        sv5 = 0x15;
+        break;
+    case 0xabfeaaa:
+        sv5 = 0x1b;
+        break;
+    default:
+        sv5 = 0xff;
+    }
+
+
+    return sv5;
+}
+
+static void ir_sv_timer_end(unsigned long data)
+{
+    struct card_ir *ir = (struct card_ir *)data;
+    struct saa7134_dev *dev = (struct saa7134_dev *)ir->dev;
+    struct timeval tv;
+    unsigned long current_jiffies, timeout;
+    u32 gap;
+    u32 sv5 = 0;
+
+    dprintk("sv timer: code = %x\n", ir->code);
+    /* get time */
+    current_jiffies = jiffies;
+    do_gettimeofday(&tv);
+
+    /* avoid overflow with gap >1s */
+    if (tv.tv_sec - ir->base_time.tv_sec > 1) {
+        gap = 200000;
+    } else {
+        gap = 1000000 * (tv.tv_sec - ir->base_time.tv_sec) +
+            tv.tv_usec - ir->base_time.tv_usec;
+    }
+
+    /* signal we're ready to start a new code */
+    ir->active = 0;
+
+    /* Allow some timer jitter (RC5 is ~24ms anyway so this is ok) */
+    if (gap < 28000) {
+        dprintk("sv timer: spurious timer_end\n");
+        return;
+    }
+
+    if (ir->last_bit < 20) {
+        /* ignore spurious codes (caused by light/other remotes) */
+        dprintk("sv timer: short code: %x\n", ir->code);
+        return;
+    }
+    sv5 = ir_sv_decode(ir->code);
+    if (sv5 == 0xff)
+        return;
+
+    ir_input_nokey(ir->dev, &ir->ir);
+    ir_input_keydown(ir->dev, &ir->ir, sv5, sv5);
+    /* Set/reset key-up timer */
+    timeout = current_jiffies +
+          msecs_to_jiffies(ir->rc5_key_timeout);
+    mod_timer(&ir->timer_keyup, timeout);
+
+}




      
