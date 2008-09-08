Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from 202.7.249.79.dynamic.rev.aanet.com.au ([202.7.249.79]
	helo=home.singlespoon.org.au)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <paulc@singlespoon.org.au>) id 1KcboF-0002yz-EG
	for linux-dvb@linuxtv.org; Mon, 08 Sep 2008 10:09:23 +0200
Received: from [192.168.3.112] (unknown [192.168.3.112])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by home.singlespoon.org.au (Postfix) with ESMTP id 61DC0664003
	for <linux-dvb@linuxtv.org>; Mon,  8 Sep 2008 18:13:05 +1000 (EST)
Message-ID: <48C4DD2F.5090706@singlespoon.org.au>
Date: Mon, 08 Sep 2008 18:07:11 +1000
From: Paul Chubb <paulc@singlespoon.org.au>
MIME-Version: 1.0
To: linux dvb <linux-dvb@linuxtv.org>
Subject: [linux-dvb] leadtek dtv1800h
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Hi,
     support for this device has progressed. However it is at the stage 
now where I am not seeing error messages but it is still not working. 
The code is based on a working patch so I am pretty confident that the 
gpio settings and other addresses are correct. Could someone have a look 
and see if something leaps out at them? This would be much appreciated. 
The dmesg is from the response to a scan using a single scan line.

Cheers Paul

--- cx88-cards.c.prepatch    2008-09-06 11:54:19.000000000 +1000
+++ cx88-cards.c    2008-09-07 15:50:47.000000000 +1000
@@ -1611,6 +1611,37 @@
            } },
            .mpeg           = CX88_MPEG_DVB,
        },
+       [CX88_BOARD_WINFAST_DTV1800H] = {
+               .name           = "LeadTek Winfast DTV1800 Hybrid",
+               .tuner_type     = TUNER_XC2028,
+//               .radio_type     = TUNER_XC2028,
+               .tuner_addr     = 0x61,
+//               .radio_addr     = 0x61,
+               .input          = {{
+                       .type   = CX88_VMUX_TELEVISION,
+                       .vmux   = 0,
+                       .gpio0  = 0x0400,       //pin 2:mute = 0 (off)
+                       .gpio1  = 0x6040,       //pin 13:audio = 0 
(tuner), pin 14:FM = 1 (off?)
+                       .gpio2  = 0x0000,
+               },{
+                       .type   = CX88_VMUX_COMPOSITE1,
+                       .vmux   = 1,
+                       .gpio0  = 0x0400,       //pin 2:mute = 0 (off)
+                       .gpio1  = 0x6060,       //pin 13:audio = 1 
(line), pin 14:FM = 1 (off?)
+                       .gpio2  = 0x0000,
+               },{
+                       .type   = CX88_VMUX_SVIDEO,
+                       .vmux   = 2,
+               }},
+               .radio = {
+                       .type   = CX88_RADIO,
+                       .gpio0  = 0x0400,       //pin 2:mute = 0 (off)
+                       .gpio1  = 0x6000,       //pin 13:audio = 0? 
(tuner), pin 14:FM = 0? (on?)
+                       .gpio2  = 0x0000,
+               },
+               .mpeg           = CX88_MPEG_DVB,
+       },
+
 };
 
 /* ------------------------------------------------------------------ */
@@ -1948,6 +1979,11 @@
         .subvendor = 0x14f1,
         .subdevice = 0x8852,
         .card      = CX88_BOARD_GENIATECH_X8000_MT,
+        }, {
+                .subvendor = 0x107d,
+                .subdevice = 0x6654,
+                .card      = CX88_BOARD_WINFAST_DTV1800H,
+
     }
 };
 
@@ -2182,7 +2218,6 @@
 {
     struct i2c_algo_bit_data *i2c_algo = priv;
     struct cx88_core *core = i2c_algo->data;
-
     /* Board-specific callbacks */
     switch (core->boardnr) {
     case CX88_BOARD_WINFAST_TV2000_XP_GLOBAL:
@@ -2192,7 +2227,6 @@
     case CX88_BOARD_DVICO_FUSIONHDTV_DVB_T_PRO:
         return cx88_dvico_xc2028_callback(priv, command, arg);
     }
-
     switch (command) {
     case XC2028_TUNER_RESET:
     {
@@ -2221,7 +2255,7 @@
             mdelay(250);
             return 0;
         }
-    }
+       }
     }
     return -EINVAL;
 }
@@ -2310,6 +2344,18 @@
         cx_set(MO_GP0_IO, 0x00000080); /* 702 out of reset */
         udelay(1000);
         break;
+        case CX88_BOARD_WINFAST_DTV1800H:
+//                cx_set(MO_GP1_IO, 0x000010);  //gpio 12 = 1: powerup 
XC3028
+cx_write(MO_GP1_IO,0x101010);
+                mdelay(250);
+//                cx_clear(MO_GP1_IO, 0x000010);  //gpio 12 = 0: 
powerdown XC3028
+cx_write(MO_GP1_IO,0x101000);
+                mdelay(250);
+//                cx_set(MO_GP1_IO, 0x000010);  //gpio 12 = 1: powerup 
XC3028
+cx_write(MO_GP1_IO,0x101010);
+                mdelay(250);
+                break;
+
     }
 }
 
--- cx88-dvb.c.prepatch    2008-09-06 11:54:19.000000000 +1000
+++ cx88-dvb.c    2008-09-07 15:50:41.000000000 +1000
@@ -391,10 +391,18 @@
             msleep(100);
             cx_set(MO_GP0_IO, 0x00000010);
             msleep(100);
-            break;
-        }
-
-        break;
+            break;   
+                case CX88_BOARD_WINFAST_DTV1800H:
+            printk(KERN_INFO "setting GPIO to TV!\n");
+            cx_write(MO_GP1_IO, 0x101010);
+            mdelay(250);
+            cx_write(MO_GP1_IO, 0x101000);
+            mdelay(250);
+            cx_write(MO_GP1_IO, 0x101010);
+            mdelay(250);
+            return 0;                     
+                break;
+                 }
     case XC2028_RESET_CLK:
         dprintk(1, "%s: XC2028_RESET_CLK %d\n", __FUNCTION__, arg);
         break;
@@ -459,6 +467,11 @@
 #endif
 };
 
+static struct zl10353_config cx88_dtv1800h = {
+       .demod_address = (0x1e >> 1),
+       .no_tuner = 1,
+};
+
 
 static int dvb_register(struct cx8802_dev *dev)
 {
@@ -773,6 +786,31 @@
                 fe->ops.tuner_ops.set_config(fe, &ctl);
         }
         break;
+         case CX88_BOARD_WINFAST_DTV1800H:
+                dev->dvb.frontend = dvb_attach(zl10353_attach,
+                                               &cx88_dtv1800h,
+                                               &dev->core->i2c_adap);
+                if (dev->dvb.frontend != NULL) {
+            struct dvb_frontend *fe;
+                struct xc2028_config cfg = {
+                    .i2c_adap  = &dev->core->i2c_adap,
+                    .i2c_addr  = 0x61,
+                    .video_dev = dev->core,
+                                .callback  = cx88_xc3028_callback,
+                };
+            static struct xc2028_ctrl ctl = {
+                .fname       = "xc3028-v27.fw",
+                .max_len     = 64,
+            };
+
+            fe = dvb_attach(xc2028_attach, dev->dvb.frontend, &cfg);
+            if (fe != NULL && fe->ops.tuner_ops.set_config != NULL)
+                fe->ops.tuner_ops.set_config(fe, &ctl);
+        }
+                dev->dvb.frontend->ops.i2c_gate_ctrl = NULL;
+        dev->dvb.frontend->ops.sleep = NULL;
+                break;
+
      case CX88_BOARD_PINNACLE_HYBRID_PCTV:
         dev->dvb.frontend = dvb_attach(zl10353_attach,
                            &cx88_geniatech_x8000_mt,
--- cx88.h.prepatch    2008-09-06 11:54:19.000000000 +1000
+++ cx88.h    2008-09-06 15:13:25.000000000 +1000
@@ -220,6 +220,7 @@
 #define CX88_BOARD_POWERCOLOR_REAL_ANGEL   62
 #define CX88_BOARD_GENIATECH_X8000_MT      63
 #define CX88_BOARD_DVICO_FUSIONHDTV_DVB_T_PRO 64
+#define CX88_BOARD_WINFAST_DTV1800H        65
 
 enum cx88_itype {
     CX88_VMUX_COMPOSITE1 = 1,

[   29.956665] Linux video capture interface: v2.00
[   30.276215] cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.6 loaded
[   30.276311] cx88[0]: subsystem: 107d:6654, board: LeadTek Winfast 
DTV1800 Hybrid [card=65,autodetected]
[   30.276314] cx88[0]: TV tuner type 71, Radio tuner type 0
[   30.324181] cx88/0: cx2388x v4l2 driver version 0.0.6 loaded
[   30.364246] input: PC Speaker as /devices/platform/pcspkr/input/input5
[   31.461127] parport_pc 00:06: reported by Plug and Play ACPI
[   31.461249] parport0: PC-style at 0x378 (0x778), irq 7, dma 3 
[PCSPP,TRISTATE,COMPAT,EPP,ECP,DMA]
[   32.348865] cx88[0]: i2c register ok
[   32.389079] cx88[0]/2: cx2388x 8802 Driver Manager
[   32.389440] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 19
[   32.389450] ACPI: PCI Interrupt 0000:04:09.2[A] -> Link [LNKB] -> GSI 
19 (level, low) -> IRQ 20
[   32.389459] cx88[0]/2: found at 0000:04:09.2, rev: 5, irq: 20, 
latency: 64, mmio: 0xf9000000
[   32.389509] ACPI: PCI Interrupt 0000:04:09.0[A] -> Link [LNKB] -> GSI 
19 (level, low) -> IRQ 20
[   32.389522] cx88[0]/0: found at 0000:04:09.0, rev: 5, irq: 20, 
latency: 64, mmio: 0xf7000000
[   32.553715] cx88/2: cx2388x dvb driver version 0.0.6 loaded
[   32.553720] cx88/2: registering cx8802 driver, type: dvb access: shared
[   32.553724] cx88[0]/2: subsystem: 107d:6654, board: LeadTek Winfast 
DTV1800 Hybrid [card=65]
[   32.553727] cx88[0]/2-dvb: cx8802_dvb_probe
[   32.553729] cx88[0]/2-dvb:  ->being probed by Card=65 Name=cx88[0], 
PCI 04:09
[   32.553731] cx88[0]/2: cx2388x based DVB/ATSC card
[   32.654884] xc2028: Xcv2028/3028 init called!
[   32.654889] xc2028 2-0061: type set to XCeive xc2028/xc3028 tuner
[   32.654891] xc2028 2-0061: xc2028_set_config called
[   32.654895] DVB: registering new adapter (cx88[0])
[   32.654897] dvb_register_frontend
[   32.654900] DVB: registering frontend 0 (Zarlink ZL10353 DVB-T)...
[   32.687199] tuner' 2-0061: Setting mode_mask to 0x0e
[   32.687203] tuner' 2-0061: chip found @ 0xc2 (cx88[0])
[   32.687205] tuner' 2-0061: tuner 0x61: Tuner type absent
[   32.687224] cx88[0]: tuner' i2c attach [addr=0x61,client=(tuner unset)]
[   32.687227] tuner' 2-0061: Calling set_type_addr for type=71, 
addr=0x61, mode=0x04, config=0x00
[   32.687229] tuner' 2-0061: set addr for type -1
[   32.687231] tuner' 2-0061: defining GPIO callback
[   32.687234] xc2028: Xcv2028/3028 init called!
[   32.687236] xc2028 2-0061: type set to XCeive xc2028/xc3028 tuner
[   32.687239] tuner' 2-0061: type set to Xceive XC3028
[   32.687241] tuner' 2-0061: tv freq set to 400.00
[   32.687243] xc2028 2-0061: xc2028_set_analog_freq called
[   32.687246] xc2028 2-0061: generic_set_freq called
[   32.687247] xc2028 2-0061: should set frequency 400000 kHz
[   32.687249] xc2028 2-0061: check_firmware called
[   32.687251] xc2028 2-0061: xc2028/3028 firmware name not set!
[   32.687254] tuner' 2-0061: cx88[0] tuner' I2C addr 0xc2 with type 71 
used for 0x0e
[   32.696728] cx88[0]/0: registered device video0 [v4l2]
[   32.696745] cx88[0]/0: registered device vbi0
[   32.696765] cx88[0]/0: registered device radio0
[   32.696824] tuner' 2-0061: switching to v4l2
[   32.696827] tuner' 2-0061: tv freq set to 400.00
[   32.696830] xc2028 2-0061: xc2028_set_analog_freq called
[   32.696833] xc2028 2-0061: generic_set_freq called
[   32.696835] xc2028 2-0061: should set frequency 400000 kHz
[   32.696837] xc2028 2-0061: check_firmware called
[   32.696838] xc2028 2-0061: xc2028/3028 firmware name not set!
[   32.699882] ACPI: PCI Interrupt Link [LAZA] enabled at IRQ 23
[   32.699888] ACPI: PCI Interrupt 0000:00:10.1[B] -> Link [LAZA] -> GSI 
23 (level, low) -> IRQ 16
[   32.699909] PCI: Setting latency timer of device 0000:00:10.1 to 64
[   34.018829] NET: Registered protocol family 10
[   34.019070] lo: Disabled Privacy Extensions
[   34.019570] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   34.655590] lp0: using parport0 (interrupt-driven).
[   34.824967] Adding 1317288k swap on /dev/sda5.  Priority:-1 extents:1 
across:1317288k
[   35.483892] EXT3 FS on sda1, internal journal
[   37.921646] No dock devices found.
[   38.366665] powernow-k8: Found 1 AMD Athlon(tm) 64 Processor 3200+ 
processors (1 cpu cores) (version 2.20.00)
[   38.366699] powernow-k8:    0 : fid 0xc (2000 MHz), vid 0x8
[   38.366701] powernow-k8:    1 : fid 0xa (1800 MHz), vid 0x8
[   38.366704] powernow-k8:    2 : fid 0x2 (1000 MHz), vid 0x12
[   41.090309] apm: BIOS version 1.2 Flags 0x03 (Driver version 1.16ac)
[   41.090316] apm: overridden by ACPI.
[   91.552043] Marking TSC unstable due to: cpufreq changes.
[   91.561971] Time: acpi_pm clocksource has been installed.
[   91.847487] tuner' 2-0061: Cmd TUNER_SET_STANDBY accepted for analog TV
[   91.847497] xc2028 2-0061: xc2028_sleep called
[   91.956780] Clocksource tsc unstable (delta = -202508653 ns)
[   92.093595] dvb_frontend_open
[   92.093606] cx88[0]/2-dvb: cx8802_dvb_advise_acquire
[   92.093610] dvb_frontend_start
[   92.105319] dvb_frontend_ioctl
[   92.105330] dvb_frontend_thread
[   92.105334] DVB: initialising frontend 0 (Zarlink ZL10353 DVB-T)...
[   92.107883] dvb_frontend_release
[   92.107890] cx88[0]/2-dvb: cx8802_dvb_advise_release
[   92.107949] dvb_frontend_open
[   92.107952] cx88[0]/2-dvb: cx8802_dvb_advise_acquire
[   92.107956] dvb_frontend_start
[   92.107960] dvb_frontend_ioctl
[   92.107966] dvb_frontend_release
[   92.107969] cx88[0]/2-dvb: cx8802_dvb_advise_release
[   92.108029] dvb_frontend_open
[   92.108032] cx88[0]/2-dvb: cx8802_dvb_advise_acquire
[   92.108035] dvb_frontend_start
[   92.108039] dvb_frontend_ioctl
[   93.528877] tuner' 2-0061: Cmd AUDC_SET_RADIO accepted for radio
[   93.528888] tuner' 2-0061: radio freq set to 87.50
[   93.528893] xc2028 2-0061: xc2028_set_analog_freq called
[   93.528898] xc2028 2-0061: generic_set_freq called
[   93.528902] xc2028 2-0061: should set frequency 87500 kHz
[   93.528905] xc2028 2-0061: check_firmware called
[   93.528909] xc2028 2-0061: xc2028/3028 firmware name not set!
[   93.544429] tuner' 2-0061: Cmd TUNER_SET_STANDBY accepted for radio
[   93.544438] xc2028 2-0061: xc2028_sleep called
[   93.545436] xc2028 2-0061: Error on line 1075: -121
[   61.910344] Inbound IN=eth0 OUT= MAC= SRC=192.168.3.17 
DST=239.255.255.250 LEN=346 TOS=0x00 PREC=0x00 TTL=4 ID=0 DF PROTO=UDP 
SPT=1900 DPT=1900 LEN=326
[   62.043777] Inbound IN=eth0 OUT= MAC= SRC=192.168.3.17 
DST=239.255.255.250 LEN=346 TOS=0x00 PREC=0x00 TTL=4 ID=0 DF PROTO=UDP 
SPT=1900 DPT=1900 LEN=326
[   62.043932] Inbound IN=eth0 OUT= MAC= SRC=192.168.3.17 
DST=239.255.255.250 LEN=355 TOS=0x00 PREC=0x00 TTL=4 ID=0 DF PROTO=UDP 
SPT=1900 DPT=1900 LEN=335
[   62.192098] Inbound IN=eth0 OUT= MAC= SRC=192.168.3.17 
DST=239.255.255.250 LEN=355 TOS=0x00 PREC=0x00 TTL=4 ID=0 DF PROTO=UDP 
SPT=1900 DPT=1900 LEN=335
[   62.192229] Inbound IN=eth0 OUT= MAC= SRC=192.168.3.17 
DST=239.255.255.250 LEN=402 TOS=0x00 PREC=0x00 TTL=4 ID=0 DF PROTO=UDP 
SPT=1900 DPT=1900 LEN=382
[   62.403580] Inbound IN=eth0 OUT= MAC= SRC=192.168.3.17 
DST=239.255.255.250 LEN=402 TOS=0x00 PREC=0x00 TTL=4 ID=0 DF PROTO=UDP 
SPT=1900 DPT=1900 LEN=382
[   62.403729] Inbound IN=eth0 OUT= MAC= SRC=192.168.3.17 
DST=239.255.255.250 LEN=412 TOS=0x00 PREC=0x00 TTL=4 ID=0 DF PROTO=UDP 
SPT=1900 DPT=1900 LEN=392
[   62.509589] Inbound IN=eth0 OUT= MAC= SRC=192.168.3.17 
DST=239.255.255.250 LEN=345 TOS=0x00 PREC=0x00 TTL=4 ID=0 DF PROTO=UDP 
SPT=1900 DPT=1900 LEN=325
[   62.727394] Inbound IN=eth0 OUT= MAC= SRC=192.168.3.17 
DST=239.255.255.250 LEN=354 TOS=0x00 PREC=0x00 TTL=4 ID=0 DF PROTO=UDP 
SPT=1900 DPT=1900 LEN=334
[   63.031197] Inbound IN=eth0 OUT= MAC= SRC=192.168.3.17 
DST=239.255.255.250 LEN=411 TOS=0x00 PREC=0x00 TTL=4 ID=0 DF PROTO=UDP 
SPT=1900 DPT=1900 LEN=391
[  162.664155] dvb_frontend_release
[  162.664166] cx88[0]/2-dvb: cx8802_dvb_advise_release
[  164.538048] xc2028 2-0061: xc2028_sleep called
[  164.539220] xc2028 2-0061: Error on line 1075: -121
[  166.924301] dvb_frontend_open
[  166.924312] cx88[0]/2-dvb: cx8802_dvb_advise_acquire
[  166.924316] dvb_frontend_start
[  166.925247] dvb_frontend_ioctl
[  166.925255] dvb_frontend_thread
[  166.925258] DVB: initialising frontend 0 (Zarlink ZL10353 DVB-T)...
[  166.948442] dvb_frontend_ioctl
[  166.948456] dvb_frontend_add_event
[  166.948478] dvb_frontend_swzigzag_autotune: drift:0 inversion:0 
auto_step:0 auto_sub_step:0 started_auto_step:0
[  166.951013] zl10353: zl10353_calc_nominal_rate: bw 7, adc_clock 
450560 => 0x5ae9
[  166.951621] zl10353: zl10353_calc_input_freq: if2 361667, ife 88893, 
adc_clock 450560 => -12930 / 0xcd7e
[  166.952833] xc2028 2-0061: xc2028_set_params called
[  166.952838] xc2028 2-0061: generic_set_freq called
[  166.952841] xc2028 2-0061: should set frequency 205625 kHz
[  166.952845] xc2028 2-0061: check_firmware called
[  166.952849] xc2028 2-0061: load_all_firmwares called
[  166.952852] xc2028 2-0061: Reading firmware xc3028-v27.fw
[  167.016500] xc2028 2-0061: Loading 80 firmware images from 
xc3028-v27.fw, type: xc2028 firmware, ver 2.7
[  167.016524] xc2028 2-0061: Reading firmware type BASE F8MHZ (3), id 
0, size=8718.
[  167.016548] xc2028 2-0061: Reading firmware type BASE F8MHZ MTS (7), 
id 0, size=8712.
[  167.016573] xc2028 2-0061: Reading firmware type BASE FM (401), id 0, 
size=8562.
[  167.016596] xc2028 2-0061: Reading firmware type BASE FM INPUT1 
(c01), id 0, size=8576.
[  167.016619] xc2028 2-0061: Reading firmware type BASE (1), id 0, 
size=8706.
[  167.016640] xc2028 2-0061: Reading firmware type BASE MTS (5), id 0, 
size=8682.
[  167.016652] xc2028 2-0061: Reading firmware type (0), id 100000007, 
size=161.
[  167.016658] xc2028 2-0061: Reading firmware type MTS (4), id 
100000007, size=169.
[  167.016665] xc2028 2-0061: Reading firmware type (0), id 200000007, 
size=161.
[  167.016671] xc2028 2-0061: Reading firmware type MTS (4), id 
200000007, size=169.
[  167.016677] xc2028 2-0061: Reading firmware type (0), id 400000007, 
size=161.
[  167.016683] xc2028 2-0061: Reading firmware type MTS (4), id 
400000007, size=169.
[  167.016689] xc2028 2-0061: Reading firmware type (0), id 800000007, 
size=161.
[  167.016695] xc2028 2-0061: Reading firmware type MTS (4), id 
800000007, size=169.
[  167.016701] xc2028 2-0061: Reading firmware type (0), id 3000000e0, 
size=161.
[  167.016706] xc2028 2-0061: Reading firmware type MTS (4), id 
3000000e0, size=169.
[  167.016712] xc2028 2-0061: Reading firmware type (0), id c000000e0, 
size=161.
[  167.016718] xc2028 2-0061: Reading firmware type MTS (4), id 
c000000e0, size=169.
[  167.016724] xc2028 2-0061: Reading firmware type (0), id 200000, 
size=161.
[  167.016729] xc2028 2-0061: Reading firmware type MTS (4), id 200000, 
size=169.
[  167.016735] xc2028 2-0061: Reading firmware type (0), id 4000000, 
size=161.
[  167.016741] xc2028 2-0061: Reading firmware type MTS (4), id 4000000, 
size=169.
[  167.016747] xc2028 2-0061: Reading firmware type D2633 DTV6 ATSC 
(10030), id 0, size=149.
[  167.016754] xc2028 2-0061: Reading firmware type D2620 DTV6 QAM (68), 
id 0, size=149.
[  167.016761] xc2028 2-0061: Reading firmware type D2633 DTV6 QAM (70), 
id 0, size=149.
[  167.016767] xc2028 2-0061: Reading firmware type D2620 DTV7 (88), id 
0, size=149.
[  167.016774] xc2028 2-0061: Reading firmware type D2633 DTV7 (90), id 
0, size=149.
[  167.016780] xc2028 2-0061: Reading firmware type D2620 DTV78 (108), 
id 0, size=149.
[  167.016786] xc2028 2-0061: Reading firmware type D2633 DTV78 (110), 
id 0, size=149.
[  167.016792] xc2028 2-0061: Reading firmware type D2620 DTV8 (208), id 
0, size=149.
[  167.016798] xc2028 2-0061: Reading firmware type D2633 DTV8 (210), id 
0, size=149.
[  167.016804] xc2028 2-0061: Reading firmware type FM (400), id 0, 
size=135.
[  167.016810] xc2028 2-0061: Reading firmware type (0), id 10, size=161.
[  167.016816] xc2028 2-0061: Reading firmware type MTS (4), id 10, 
size=169.
[  167.016822] xc2028 2-0061: Reading firmware type (0), id 1000400000, 
size=169.
[  167.016828] xc2028 2-0061: Reading firmware type (0), id c00400000, 
size=161.
[  167.016833] xc2028 2-0061: Reading firmware type (0), id 800000, 
size=161.
[  167.016839] xc2028 2-0061: Reading firmware type (0), id 8000, size=161.
[  167.016844] xc2028 2-0061: Reading firmware type LCD (1000), id 8000, 
size=161.
[  167.016850] xc2028 2-0061: Reading firmware type LCD NOGD (3000), id 
8000, size=161.
[  167.016857] xc2028 2-0061: Reading firmware type MTS (4), id 8000, 
size=169.
[  167.016863] xc2028 2-0061: Reading firmware type (0), id b700, size=161.
[  167.016869] xc2028 2-0061: Reading firmware type LCD (1000), id b700, 
size=161.
[  167.016875] xc2028 2-0061: Reading firmware type LCD NOGD (3000), id 
b700, size=161.
[  167.016881] xc2028 2-0061: Reading firmware type (0), id 2000, size=161.
[  167.016887] xc2028 2-0061: Reading firmware type MTS (4), id b700, 
size=169.
[  167.016893] xc2028 2-0061: Reading firmware type MTS LCD (1004), id 
b700, size=169.
[  167.016899] xc2028 2-0061: Reading firmware type MTS LCD NOGD (3004), 
id b700, size=169.
[  167.016906] xc2028 2-0061: Reading firmware type SCODE HAS_IF_3280 
(60000000), id 0, size=192.
[  167.016913] xc2028 2-0061: Reading firmware type SCODE HAS_IF_3300 
(60000000), id 0, size=192.
[  167.016920] xc2028 2-0061: Reading firmware type SCODE HAS_IF_3440 
(60000000), id 0, size=192.
[  167.016927] xc2028 2-0061: Reading firmware type SCODE HAS_IF_3460 
(60000000), id 0, size=192.
[  167.016934] xc2028 2-0061: Reading firmware type DTV6 ATSC OREN36 
SCODE HAS_IF_3800 (60210020), id 0, size=192.
[  167.016943] xc2028 2-0061: Reading firmware type SCODE HAS_IF_4000 
(60000000), id 0, size=192.
[  167.016949] xc2028 2-0061: Reading firmware type DTV6 ATSC TOYOTA388 
SCODE HAS_IF_4080 (60410020), id 0, size=192.
[  167.016958] xc2028 2-0061: Reading firmware type SCODE HAS_IF_4200 
(60000000), id 0, size=192.
[  167.016987] xc2028 2-0061: Reading firmware type MONO SCODE 
HAS_IF_4320 (60008000), id 8000, size=192.
[  167.016995] xc2028 2-0061: Reading firmware type SCODE HAS_IF_4450 
(60000000), id 0, size=192.
[  167.017002] xc2028 2-0061: Reading firmware type MTS LCD NOGD MONO IF 
SCODE HAS_IF_4500 (6002b004), id b700, size=192.
[  167.017012] xc2028 2-0061: Reading firmware type LCD NOGD IF SCODE 
HAS_IF_4600 (60023000), id 8000, size=192.
[  167.017020] xc2028 2-0061: Reading firmware type DTV6 QAM DTV7 DTV78 
DTV8 ZARLINK456 SCODE HAS_IF_4760 (620003e0), id 0, size=192.
[  167.017030] xc2028 2-0061: Reading firmware type SCODE HAS_IF_4940 
(60000000), id 0, size=192.
[  167.017037] xc2028 2-0061: Reading firmware type SCODE HAS_IF_5260 
(60000000), id 0, size=192.
[  167.017044] xc2028 2-0061: Reading firmware type MONO SCODE 
HAS_IF_5320 (60008000), id f00000007, size=192.
[  167.017051] xc2028 2-0061: Reading firmware type DTV7 DTV78 DTV8 
DIBCOM52 CHINA SCODE HAS_IF_5400 (65000380), id 0, size=192.
[  167.017061] xc2028 2-0061: Reading firmware type DTV6 ATSC OREN538 
SCODE HAS_IF_5580 (60110020), id 0, size=192.
[  167.017069] xc2028 2-0061: Reading firmware type SCODE HAS_IF_5640 
(60000000), id 300000007, size=192.
[  167.017076] xc2028 2-0061: Reading firmware type SCODE HAS_IF_5740 
(60000000), id c00000007, size=192.
[  167.017084] xc2028 2-0061: Reading firmware type SCODE HAS_IF_5900 
(60000000), id 0, size=192.
[  167.017091] xc2028 2-0061: Reading firmware type MONO SCODE 
HAS_IF_6000 (60008000), id c04c000f0, size=192.
[  167.017099] xc2028 2-0061: Reading firmware type DTV6 QAM ATSC LG60 
F6MHZ SCODE HAS_IF_6200 (68050060), id 0, size=192.
[  167.017108] xc2028 2-0061: Reading firmware type SCODE HAS_IF_6240 
(60000000), id 10, size=192.
[  167.017115] xc2028 2-0061: Reading firmware type MONO SCODE 
HAS_IF_6320 (60008000), id 200000, size=192.
[  167.017123] xc2028 2-0061: Reading firmware type SCODE HAS_IF_6340 
(60000000), id 200000, size=192.
[  167.017130] xc2028 2-0061: Reading firmware type MONO SCODE 
HAS_IF_6500 (60008000), id c044000e0, size=192.
[  167.017138] xc2028 2-0061: Reading firmware type DTV6 ATSC ATI638 
SCODE HAS_IF_6580 (60090020), id 0, size=192.
[  167.017146] xc2028 2-0061: Reading firmware type SCODE HAS_IF_6600 
(60000000), id 3000000e0, size=192.
[  167.017154] xc2028 2-0061: Reading firmware type MONO SCODE 
HAS_IF_6680 (60008000), id 3000000e0, size=192.
[  167.017162] xc2028 2-0061: Reading firmware type DTV6 ATSC TOYOTA794 
SCODE HAS_IF_8140 (60810020), id 0, size=192.
[  167.017171] xc2028 2-0061: Reading firmware type SCODE HAS_IF_8200 
(60000000), id 0, size=192.
[  167.017188] xc2028 2-0061: Firmware files loaded.
[  167.017192] xc2028 2-0061: checking firmware, user requested 
type=F8MHZ D2620 DTV7 (8a), id 0000000000000000, scode_tbl (0), scode_nr 0
[  167.017201] callback: ddb23b80
[  167.017205] cx88[0]/2-dvb: cx88_xc3028_callback: XC2028_TUNER_RESET 0
[  167.017209] setting GPIO to TV!
[  167.761794] xc2028 2-0061: load_firmware called
[  167.761799] xc2028 2-0061: seek_firmware called, want type=BASE F8MHZ 
D2620 DTV7 (8b), id 0000000000000000.
[  167.761807] xc2028 2-0061: Found firmware for type=BASE F8MHZ (3), id 
0000000000000000.
[  167.761813] xc2028 2-0061: Loading firmware for type=BASE F8MHZ (3), 
id 0000000000000000.
[  167.761819] cx88[0]/2-dvb: cx88_xc3028_callback: XC2028_TUNER_RESET 0
[  167.761822] setting GPIO to TV!
[  168.512587] dvb_frontend_ioctl
[   85.009452] five<7>xc2028 2-0061: Load init1 firmware, if exists
[   85.009461] xc2028 2-0061: load_firmware called
[   85.009463] xc2028 2-0061: seek_firmware called, want type=BASE INIT1 
F8MHZ D2620 DTV7 (408b), id 0000000000000000.
[   85.009470] xc2028 2-0061: Can't find firmware for type=BASE INIT1 
F8MHZ (4003), id 0000000000000000.
[   85.009473] xc2028 2-0061: load_firmware called
[   85.009475] xc2028 2-0061: seek_firmware called, want type=BASE INIT1 
D2620 DTV7 (4089), id 0000000000000000.
[   85.009480] xc2028 2-0061: Can't find firmware for type=BASE INIT1 
(4001), id 0000000000000000.
[   85.009482] Skip base<7>xc2028 2-0061: load_firmware called
[   85.009485] xc2028 2-0061: seek_firmware called, want type=F8MHZ 
D2620 DTV7 (8a), id 0000000000000000.
[   85.009488] xc2028 2-0061: Found firmware for type=D2620 DTV7 (88), 
id 0000000000000000.
[   85.009491] xc2028 2-0061: Loading firmware for type=D2620 DTV7 (88), 
id 0000000000000000.
[   85.023254] xc2028 2-0061: Trying to load scode 0
[   85.023257] xc2028 2-0061: load_scode called
[   85.023259] xc2028 2-0061: seek_firmware called, want type=F8MHZ 
D2620 DTV7 SCODE (2000008a), id 0000000000000000.
[   85.023264] xc2028 2-0061: Can't find firmware for type=DTV7 SCODE 
(20000080), id 0000000000000000.
[   85.023267] xc2028 2-0061: xc2028_get_reg 0004 called
[   85.024461] xc2028 2-0061: xc2028_get_reg 0008 called
[   85.025211] xc2028 2-0061: Device is Xceive 3028 version 1.0, 
firmware version 2.7
[   85.040489] cx88[0]/2-dvb: cx88_xc3028_callback: XC2028_RESET_CLK 1
[   85.160383] xc2028 2-0061: divisor= 00 00 32 b8 (freq=205.625)
[   85.362226] dvb_frontend_ioctl
[   95.136175] dvb_frontend_ioctl
[   95.337363] dvb_frontend_ioctl
[   95.538537] dvb_frontend_ioctl
[   95.733733] dvb_frontend_add_event
[   95.733918] dvb_frontend_swzigzag_autotune: drift:0 inversion:1 
auto_step:0 auto_sub_step:1 started_auto_step:0
[   95.736624] zl10353: zl10353_calc_nominal_rate: bw 7, adc_clock 
450560 => 0x5ae9
[   95.737385] zl10353: zl10353_calc_input_freq: if2 361667, ife 88893, 
adc_clock 450560 => -12930 / 0xcd7e
[   95.738760] xc2028 2-0061: xc2028_set_params called
[   95.738763] xc2028 2-0061: generic_set_freq called
[   95.738986] xc2028 2-0061: should set frequency 205625 kHz
[   95.738989] xc2028 2-0061: check_firmware called
[   95.738991] xc2028 2-0061: checking firmware, user requested 
type=F8MHZ D2620 DTV7 (8a), id 0000000000000000, scode_tbl (0), scode_nr 0
[   95.738997] xc2028 2-0061: BASE firmware not changed.
[   95.738999] Skip base<7>xc2028 2-0061: Std-specific firmware already 
loaded.
[   95.739002] xc2028 2-0061: SCODE firmware already loaded.
[   95.739004] xc2028 2-0061: xc2028_get_reg 0004 called
[   95.739914] dvb_frontend_ioctl
[   95.740726] xc2028 2-0061: xc2028_get_reg 0008 called
[   95.741478] xc2028 2-0061: Device is Xceive 3028 version 1.0, 
firmware version 2.7
[   95.756472] cx88[0]/2-dvb: cx88_xc3028_callback: XC2028_RESET_CLK 1
[   95.876356] xc2028 2-0061: divisor= 00 00 32 b8 (freq=205.625)
[   96.078261] dvb_frontend_ioctl
[   96.279441] dvb_frontend_ioctl
[  173.554811] dvb_frontend_ioctl
[  173.756052] dvb_frontend_ioctl
[  173.757425] dvb_frontend_ioctl
[  173.757431] dvb_frontend_add_event
[  173.758070] dvb_frontend_swzigzag_autotune: drift:0 inversion:1 
auto_step:0 auto_sub_step:0 started_auto_step:0
[  173.760934] zl10353: zl10353_calc_nominal_rate: bw 7, adc_clock 
450560 => 0x5ae9
[  173.761828] zl10353: zl10353_calc_input_freq: if2 361667, ife 88893, 
adc_clock 450560 => -12930 / 0xcd7e
[  173.763385] xc2028 2-0061: xc2028_set_params called
[  173.763391] xc2028 2-0061: generic_set_freq called
[  173.763780] xc2028 2-0061: should set frequency 205625 kHz
[  173.763786] xc2028 2-0061: check_firmware called
[  173.763789] xc2028 2-0061: checking firmware, user requested 
type=F8MHZ D2620 DTV7 (8a), id 0000000000000000, scode_tbl (0), scode_nr 0
[  173.763800] xc2028 2-0061: BASE firmware not changed.
[  173.763803] Skip base<7>xc2028 2-0061: Std-specific firmware already 
loaded.
[  173.763809] xc2028 2-0061: SCODE firmware already loaded.
[  173.763813] xc2028 2-0061: xc2028_get_reg 0004 called
[  173.765939] xc2028 2-0061: xc2028_get_reg 0008 called
[  173.768126] xc2028 2-0061: Device is Xceive 3028 version 1.0, 
firmware version 2.7
[  173.782342] cx88[0]/2-dvb: cx88_xc3028_callback: XC2028_RESET_CLK 1
[  173.902113] xc2028 2-0061: divisor= 00 00 32 b8 (freq=205.625)
[  173.957394] dvb_frontend_ioctl
[  174.158652] dvb_frontend_ioctl
[  174.359882] dvb_frontend_ioctl
[  174.561108] dvb_frontend_ioctl
[  174.762363] dvb_frontend_ioctl
[  174.903148] dvb_frontend_add_event
[  174.903426] dvb_frontend_swzigzag_autotune: drift:0 inversion:0 
auto_step:0 auto_sub_step:1 started_auto_step:0
[  174.906293] zl10353: zl10353_calc_nominal_rate: bw 7, adc_clock 
450560 => 0x5ae9
[  174.907186] zl10353: zl10353_calc_input_freq: if2 361667, ife 88893, 
adc_clock 450560 => -12930 / 0xcd7e
[  174.908720] xc2028 2-0061: xc2028_set_params called
[  174.908726] xc2028 2-0061: generic_set_freq called
[  174.909161] xc2028 2-0061: should set frequency 205625 kHz
[  174.909167] xc2028 2-0061: check_firmware called
[  174.909171] xc2028 2-0061: checking firmware, user requested 
type=F8MHZ D2620 DTV7 (8a), id 0000000000000000, scode_tbl (0), scode_nr 0
[  174.909181] xc2028 2-0061: BASE firmware not changed.
[  174.909184] Skip base<7>xc2028 2-0061: Std-specific firmware already 
loaded.
[  174.909190] xc2028 2-0061: SCODE firmware already loaded.
[  174.909194] xc2028 2-0061: xc2028_get_reg 0004 called
[  174.911370] xc2028 2-0061: xc2028_get_reg 0008 called
[  174.912227] xc2028 2-0061: Device is Xceive 3028 version 1.0, 
firmware version 2.7
[  174.925768] cx88[0]/2-dvb: cx88_xc3028_callback: XC2028_RESET_CLK 1
[  174.963629] dvb_frontend_ioctl
[  175.045724] xc2028 2-0061: divisor= 00 00 32 b8 (freq=205.625)
[  175.247850] dvb_frontend_ioctl
[  175.449076] dvb_frontend_ioctl
[  175.650321] dvb_frontend_ioctl
[  175.851554] dvb_frontend_ioctl
[  175.852892] dvb_frontend_release
[  175.852897] cx88[0]/2-dvb: cx8802_dvb_advise_release
[  176.045401] xc2028 2-0061: xc2028_sleep called

-- 
This message has been scanned for viruses and
dangerous content by MailScanner, and is
believed to be clean.


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
