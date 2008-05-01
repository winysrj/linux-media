Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m41M7C24018579
	for <video4linux-list@redhat.com>; Thu, 1 May 2008 18:07:12 -0400
Received: from smtp6-g19.free.fr (smtp6-g19.free.fr [212.27.42.36])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m41M6uJl019315
	for <video4linux-list@redhat.com>; Thu, 1 May 2008 18:06:56 -0400
Message-ID: <481A3EFD.4000101@users.sourceforge.net>
Date: Fri, 02 May 2008 00:06:53 +0200
From: =?ISO-8859-1?Q?Andr=E9_AUZI?= <aauzi@users.sourceforge.net>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Subject: [PATCH] kernel 2.6.24: Add support for Items ITV-301 Stereo TV Tuner
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Changes include:
  - addition of the keymap for the remote control: ir_codes_items_h338
  - addition of the board: SAA7134_BOARD_ITEMS_ITV301
  - minor adaptation to the debug logs for easier GPIO bit change 
identification

Signed-off-by: Andre Auzi <aauzi@users.sourceforge.net>

diff -r 5e73425c1968 -r f091994a981b 
linux/Documentation/video4linux/CARDLIST.saa7134
--- a/linux/Documentation/video4linux/CARDLIST.saa7134    Wed Apr 30 
23:18:40 2008 -0300
+++ b/linux/Documentation/video4linux/CARDLIST.saa7134    Thu May 01 
23:07:52 2008 +0200
@@ -141,3 +141,4 @@ 140 -> Avermedia DVB-S Pro A700         
 140 -> Avermedia DVB-S Pro A700                 [1461:a7a1]
 141 -> Avermedia DVB-S Hybrid+FM A700           [1461:a7a2]
 142 -> Beholder BeholdTV H6                     [5ace:6290]
+143 -> Items ITV-301 PCI Stero TV Tuner
diff -r 5e73425c1968 -r f091994a981b linux/drivers/media/common/ir-keymaps.c
--- a/linux/drivers/media/common/ir-keymaps.c    Wed Apr 30 23:18:40 
2008 -0300
+++ b/linux/drivers/media/common/ir-keymaps.c    Thu May 01 23:07:52 
2008 +0200
@@ -2251,3 +2251,98 @@ IR_KEYTAB_TYPE ir_codes_powercolor_real_
     [0x25] = KEY_POWER,        /* power */
 };
 EXPORT_SYMBOL_GPL(ir_codes_powercolor_real_angel);
+
+/* Andre Auzi <aauzi@users.sourceforge.net>
+   inspired by Michael Tokarev <mjt@tls.msk.ru> ir_codes_manli
+
+   Keytable is used by Items ITV-301 PCI TV Tuner (remote
+   control identification code, on the back of the device,
+   is H-338).
+
+   The "ascii-art picture" below (in comments, first row
+   is the keycode in hex, and subsequent row(s) shows
+   the button labels) helps to describe which keycodes are
+   assigned to the buttons.
+ */
+IR_KEYTAB_TYPE ir_codes_items_h338[IR_KEYTAB_SIZE] = {
+
+    /*  0x1c        0x12  *
+     * RADIO        POWER *
+     *              */
+    [0x1c] = KEY_RADIO,    /*XXX*/
+    [0x12] = KEY_POWER,
+
+    /*  0x01    0x02    0x03  *
+     *   1       2       3    *
+     *                        *
+     *  0x04    0x05    0x06  *
+     *   4       5       6    *
+     *                        *
+     *  0x07    0x08    0x09  *
+     *   7       8       9    *
+     *                        */
+    [0x01] = KEY_1,
+    [0x02] = KEY_2,
+    [0x03] = KEY_3,
+    [0x04] = KEY_4,
+    [0x05] = KEY_5,
+    [0x06] = KEY_6,
+    [0x07] = KEY_7,
+    [0x08] = KEY_8,
+    [0x09] = KEY_9,
+
+    /*  0x0a    0x00    0x17  *
+     * RECALL    0      PLUS  *
+     *                        */
+    [0x0a] = KEY_LAST,    /*XXX Recall Last for Recall */
+    [0x00] = KEY_0,
+    [0x17] = KEY_DIGITS,    /*XXX for Plus */
+
+    /*  0x14            0x10  *
+     *  OSD             MODE  */
+    [0x14] = KEY_MENU,
+    [0x10] = KEY_MODE,
+
+    /*          0x0b          *
+     *           Ch+          *
+     *                        *
+     *  0x18    0x16    0x0c  *
+     *  Vol-     Ok     Vol+  *
+     *                        *
+     *         0x015          *
+     *           Ch-          *
+     *                        */
+    [0x0b] = KEY_CHANNELUP,
+    [0x18] = KEY_VOLUMEDOWN,
+    [0x16] = KEY_OK,
+    [0x0c] = KEY_VOLUMEUP,
+    [0x15] = KEY_CHANNELDOWN,
+
+    /*  0x11            0x0d  *
+     *  OSD             MODE  *
+     *                        */
+    [0x11] = KEY_TV,    /*XXX*/
+    [0x0d] = KEY_AUDIO,    /*XXX there's no KEY_STEREO */
+
+    /*  0x0f    0x1b    0x1a  *
+     *  PREVIOUS        NEXT  *
+     *        TIMESHIFT       *
+     *                        *
+     *  0x0e    0x1f    0x1e  *
+     *  STOP    PLAY    PAUSE *
+     *                        */
+    [0x0f] = KEY_PREVIOUS,
+    [0x1b] = KEY_COFFEE,   /*XXX there's no KEY_TIMESHIFTING */
+    [0x1a] = KEY_NEXT,
+    [0x0e] = KEY_STOP,
+    [0x1f] = KEY_PLAY,
+    [0x1e] = KEY_PAUSE,
+
+    /* 0x1d    0x13     0x19  *
+     * RECORD  MUTE   SNAPSHOT*
+     *                        */
+    [0x1d] = KEY_RECORD,
+    [0x13] = KEY_MUTE,
+    [0x19] = KEY_SYSRQ,    /*XXX there's no KEY_SNAPSHOT */
+};
+EXPORT_SYMBOL_GPL(ir_codes_items_h338);
diff -r 5e73425c1968 -r f091994a981b 
linux/drivers/media/video/saa7134/saa7134-cards.c
--- a/linux/drivers/media/video/saa7134/saa7134-cards.c    Wed Apr 30 
23:18:40 2008 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-cards.c    Thu May 01 
23:07:52 2008 +0200
@@ -4322,6 +4322,66 @@ struct saa7134_board saa7134_boards[] =
         },
         /* no DVB support for now */
         /* .mpeg           = SAA7134_MPEG_DVB, */
+    },
+    [SAA7134_BOARD_ITEMS_ITV301] = {
+        /* Andre Auzi <aauzi@users.sourceforge.net>
+         *
+         * INPUTS:
+         * vmux = 0, S-video input, bad synchronization, no color
+         * vmux = 1, composite input, OK
+         *         tested with PAL DVD and SECAM VHS
+         * vmux = 2, S-video input, bad synchronization, no color
+         * vmux = 3, TV tuner, OK - tested in SECAM (france)
+         * vmux = 4, FM radio tuner, OK
+         * vmux = 5, no video signal
+         * vmux = 6, S-video input, bad synchronization, no color
+         * vmux = 7, S-video input, bad synchronization, no color
+         *
+         * amux = LINE2, tuner stereo input, OK
+         * amux = LINE1, jack stereo input, OK
+         *
+         * GPIO:
+         * bits[8-12] IR key code value (mask: 0x1F00)
+         * bit14 IR key pressed, active low (mask: 0x4000)
+         * bit15 (output) when set to zero, enables bit14's key pressed
+         * status and auto repeat (gpiomask: 0x8000)
+         *
+         * alsa mixing OK
+         * remote OK
+         * mpeg not tested
+         * teletext not tested
+         */
+        .name        = "Items ITV-301 PCI Stero TV Tuner",
+        .audio_clock    = 0x00187de7,
+        .tuner_type    = TUNER_PHILIPS_FM1216ME_MK3,
+        .radio_type    = UNSET,
+        .tuner_addr    = ADDR_UNSET,
+        .radio_addr    = ADDR_UNSET,
+        .tuner_config    = 0,
+        .mpeg        = SAA7134_MPEG_EMPRESS,
+        .tda9887_conf    = (TDA9887_PRESENT
+                   | TDA9887_INTERCARRIER
+                   | TDA9887_PORT2_INACTIVE),
+        .gpiomask    = 0x8000,
+        .inputs        = {{
+            .name = name_tv,
+            .vmux = 3,
+            .amux = LINE2,
+            .tv   = 1,
+        }, {
+            .name = name_comp1,
+            .vmux = 1,
+            .amux = LINE1,
+        }, {
+            .name = name_svideo,
+            .vmux = 0,
+            .amux = LINE1,
+        } },
+        .radio = {
+            .name = name_radio,
+            .vmux = 4,
+            .amux = LINE2,
+        },
     },
 };
 
@@ -5617,6 +5677,7 @@ int saa7134_board_init1(struct saa7134_d
     case SAA7134_BOARD_BEHOLD_505FM:
     case SAA7134_BOARD_BEHOLD_507_9FM:
     case SAA7134_BOARD_GENIUS_TVGO_A11MCE:
+    case SAA7134_BOARD_ITEMS_ITV301:
         dev->has_remote = SAA7134_REMOTE_GPIO;
         break;
     case SAA7134_BOARD_FLYDVBS_LR300:
diff -r 5e73425c1968 -r f091994a981b 
linux/drivers/media/video/saa7134/saa7134-input.c
--- a/linux/drivers/media/video/saa7134/saa7134-input.c    Wed Apr 30 
23:18:40 2008 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134-input.c    Thu May 01 
23:07:52 2008 +0200
@@ -85,14 +85,37 @@ static int build_key(struct saa7134_dev
 
     gpio = saa_readl(SAA7134_GPIO_GPSTATUS0 >> 2);
     if (ir->polling) {
-        if (ir->last_gpio == gpio)
+        /* limit observation to selected bits */
+        /* should (slightly) accelerate treatments of false positives */
+        /* ie. when gpio bits non-related to IR change */
+        u32 mask_selected = (ir->mask_keycode
+                     | ir->mask_keydown
+                     | ir->mask_keyup);
+        u32 changed = ir->last_gpio ^ gpio;
+
+        if ((changed & mask_selected) == 0) {
+            if (ir_debug && changed) {
+                data = ir_extract_bits(gpio, ir->mask_keycode);
+                dprintk("build_key gpio=0x%08x "
+                    "mask=0x%08x data=0x%02x "
+                    "changed=0x%08x\n",
+                    gpio, ir->mask_keycode, data, changed);
+                ir->last_gpio = gpio;
+            }
+
+            /* count polls with same key state */
+            ir->last_count++;
             return 0;
+        }
         ir->last_gpio = gpio;
     }
 
     data = ir_extract_bits(gpio, ir->mask_keycode);
-    dprintk("build_key gpio=0x%x mask=0x%x data=%d\n",
-        gpio, ir->mask_keycode, data);
+    dprintk("build_key gpio=0x%08x mask=0x%08x data=0x%02x count=%d\n",
+        gpio, ir->mask_keycode, data, ir->last_count);
+
+    /* key state changed reset the poll counter */
+    ir->last_count = 0;
 
     if (ir->polling) {
         if ((ir->mask_keydown  &&  (0 != (gpio & ir->mask_keydown))) ||
@@ -423,6 +446,18 @@ int saa7134_input_init1(struct saa7134_d
         mask_keydown = 0xf00000;
         polling = 50; /* ms */
         break;
+    case SAA7134_BOARD_ITEMS_ITV301:
+        ir_codes     = ir_codes_items_h338;
+        mask_keycode = 0x00001f00;
+        mask_keyup   = 0x00004000;
+        polling         = 12; /* ms : has to be fast enough to sample auto
+                    * repeat sequences - Nyquist and Shannon
+                    * said so (or something quite similar).
+                    * We must trust them.
+                    * Tuned to have at minimun one no change
+                    * for each key state when auto repeat is
+                    * active.
+                    */
     }
     if (NULL == ir_codes) {
         printk("%s: Oops: IR config error [card=%d]\n",
diff -r 5e73425c1968 -r f091994a981b 
linux/drivers/media/video/saa7134/saa7134.h
--- a/linux/drivers/media/video/saa7134/saa7134.h    Wed Apr 30 23:18:40 
2008 -0300
+++ b/linux/drivers/media/video/saa7134/saa7134.h    Thu May 01 23:07:52 
2008 +0200
@@ -271,6 +271,7 @@ struct saa7134_format {
 #define SAA7134_BOARD_AVERMEDIA_A700_PRO    140
 #define SAA7134_BOARD_AVERMEDIA_A700_HYBRID 141
 #define SAA7134_BOARD_BEHOLD_H6      142
+#define SAA7134_BOARD_ITEMS_ITV301       143
 
 
 #define SAA7134_MAXBOARDS 8
diff -r 5e73425c1968 -r f091994a981b linux/include/media/ir-common.h
--- a/linux/include/media/ir-common.h    Wed Apr 30 23:18:40 2008 -0300
+++ b/linux/include/media/ir-common.h    Thu May 01 23:07:52 2008 +0200
@@ -26,8 +26,8 @@
 #include <linux/input.h>
 #include <linux/workqueue.h>
 
-#define IR_TYPE_RC5     1
-#define IR_TYPE_PD      2 /* Pulse distance encoded IR */
+#define IR_TYPE_RC5    1
+#define IR_TYPE_PD    2 /* Pulse distance encoded IR */
 #define IR_TYPE_OTHER  99
 
 #define IR_KEYTAB_TYPE    u32
@@ -43,31 +43,32 @@
 
 struct ir_input_state {
     /* configuration */
-    int                ir_type;
-    IR_KEYTAB_TYPE     ir_codes[IR_KEYTAB_SIZE];
+    int           ir_type;
+    IR_KEYTAB_TYPE       ir_codes[IR_KEYTAB_SIZE];
 
     /* key info */
-    u32                ir_raw;      /* raw data */
-    u32                ir_key;      /* ir key code */
-    u32                keycode;     /* linux key code */
-    int                keypressed;  /* current state */
+    u32           ir_raw;    /* raw data */
+    u32           ir_key;    /* ir key code */
+    u32           keycode;    /* linux key code */
+    int           keypressed;    /* current state */
 };
 
 /* this was saa7134_ir and bttv_ir, moved here for
  * rc5 decoding. */
 struct card_ir {
-    struct input_dev        *dev;
-    struct ir_input_state   ir;
-    char                    name[32];
-    char                    phys[32];
+    struct input_dev    *dev;
+    struct ir_input_state    ir;
+    char            name[32];
+    char            phys[32];
 
     /* Usual gpio signalling */
 
-    u32                     mask_keycode;
-    u32                     mask_keydown;
-    u32                     mask_keyup;
-    u32                     polling;
-    u32                     last_gpio;
+    u32            mask_keycode;
+    u32            mask_keydown;
+    u32            mask_keyup;
+    u32            polling;
+    u32            last_gpio;
+    int            last_count;
     int            shift_by;
     int            start; // What should RC5_START() be
     int            addr; // What RC5_ADDR() should be.
@@ -146,6 +147,7 @@ extern IR_KEYTAB_TYPE ir_codes_pinnacle_
 extern IR_KEYTAB_TYPE ir_codes_pinnacle_pctv_hd[IR_KEYTAB_SIZE];
 extern IR_KEYTAB_TYPE ir_codes_genius_tvgo_a11mce[IR_KEYTAB_SIZE];
 extern IR_KEYTAB_TYPE ir_codes_powercolor_real_angel[IR_KEYTAB_SIZE];
+extern IR_KEYTAB_TYPE ir_codes_items_h338[IR_KEYTAB_SIZE];
 
 #endif

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
