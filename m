Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from 202.7.249.79.dynamic.rev.aanet.com.au ([202.7.249.79]
	helo=home.singlespoon.org.au)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <paulc@singlespoon.org.au>) id 1KXZ5y-0004Gr-8j
	for linux-dvb@linuxtv.org; Mon, 25 Aug 2008 12:14:48 +0200
Received: from [192.168.3.112] (unknown [192.168.3.112])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by home.singlespoon.org.au (Postfix) with ESMTP id 28CD4644013
	for <linux-dvb@linuxtv.org>; Mon, 25 Aug 2008 20:18:03 +1000 (EST)
Message-ID: <48B285BA.2090101@singlespoon.org.au>
Date: Mon, 25 Aug 2008 20:13:14 +1000
From: Paul Chubb <paulc@singlespoon.org.au>
MIME-Version: 1.0
To: linux dvb <linux-dvb@linuxtv.org>
Content-Type: multipart/mixed; boundary="------------090903020504030503030603"
Subject: [linux-dvb] leadtek dtv1800 h support
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
--------------090903020504030503030603
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,
     a few months ago Miroslav Sustek created a patch for this card 
against Markus Rechberger's v4l repository. This patch is attached as 
dtv1800.patch. A patched and compiled set of drivers fails on ubuntu 
hardy heron 8.04 with lots of symbol errors. Hardy is running 2.6.24.19. 
I have attempted to backport this patch to the current v4l tree with 
limited success. The driver loads however fails to do anything useful. 
My patch is attached as dtv1800h-v4l.patch.

I *think* the issue is with loading firmware. The tuner-xc2028.c 
function check_firmware is passed a frontend without the firmware name - 
producing the error shown in the dmesg listing below. If I hack the 
function and hardcode the firmware file name, it attempts to load the 
firmware but fails when it tries to read back.

Now that I am totally out of my depth I am not sure what to try next. 
Any help will be gratefully received.

Cheers Paul

dmesg:

[   28.783219] Linux agpgart interface v0.102
[   28.888020] i2c-adapter i2c-0: nForce2 SMBus adapter at 0x600
[   28.888048] i2c-adapter i2c-1: nForce2 SMBus adapter at 0x700
[   29.925721] Linux video capture interface: v2.00
[   30.130841] input: PC Speaker as /devices/platform/pcspkr/input/input5
[   30.214305] cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.6 loaded
[   30.214405] cx88[0]: subsystem: 107d:6654, board: LeadTek Winfast 
DTV1800 Hybrid [card=65,autodetected]
[   30.214408] cx88[0]: TV tuner type 71, Radio tuner type 0
[   30.305188] cx88/0: cx2388x v4l2 driver version 0.0.6 loaded
[   31.206991] parport_pc 00:06: reported by Plug and Play ACPI
[   31.207113] parport0: PC-style at 0x378 (0x778), irq 7, dma 3 
[PCSPP,TRISTATE,COMPAT,EPP,ECP,DMA]
[   31.924986] cx88[0]: i2c register ok
[   31.964435] cx88[0]/2: cx2388x 8802 Driver Manager
[   31.964761] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 19
[   31.964772] ACPI: PCI Interrupt 0000:04:09.2[A] -> Link [LNKB] -> GSI 
19 (level, low) -> IRQ 20
[   31.964781] cx88[0]/2: found at 0000:04:09.2, rev: 5, irq: 20, 
latency: 64, mmio: 0xf9000000
[   31.964830] ACPI: PCI Interrupt 0000:04:09.0[A] -> Link [LNKB] -> GSI 
19 (level, low) -> IRQ 20
[   31.964838] cx88[0]/0: found at 0000:04:09.0, rev: 5, irq: 20, 
latency: 64, mmio: 0xf7000000
[   32.223609] cx88/2: cx2388x dvb driver version 0.0.6 loaded
[   32.223614] cx88/2: registering cx8802 driver, type: dvb access: shared
[   32.223618] cx88[0]/2: subsystem: 107d:6654, board: LeadTek Winfast 
DTV1800 Hybrid [card=65]
[   32.223621] cx88[0]/2-dvb: cx8802_dvb_probe
[   32.223623] cx88[0]/2-dvb:  ->being probed by Card=65 Name=cx88[0], 
PCI 04:09
[   32.223625] cx88[0]/2: cx2388x based DVB/ATSC card
[   32.364033] xc2028: Xcv2028/3028 init called!
[   32.364038] xc2028 2-0061: type set to XCeive xc2028/xc3028 tuner
[   32.366880] tuner' 2-0061: chip found @ 0xc2 (cx88[0])
[   32.366901] cx88[0]: tuner' i2c attach [addr=0x61,client=(tuner unset)]
[   32.366904] xc2028: Xcv2028/3028 init called!
[   32.366907] xc2028 2-0061: type set to XCeive xc2028/xc3028 tuner
[   32.366910] xc2028 2-0061: xc2028_set_analog_freq called
[   32.366912] xc2028 2-0061: generic_set_freq called
[   32.366914] xc2028 2-0061: should set frequency 400000 kHz
[   32.366918] xc2028 2-0061: check_firmware called
[   32.366920] xc2028 2-0061: xc2028/3028 firmware name not set!
[   32.373091] xc2028 2-0061: xc2028_sleep called
[   32.377853] cx88[0]/0: registered device video0 [v4l2]
[   32.377871] cx88[0]/0: registered device vbi0
[   32.377885] cx88[0]/0: registered device radio0
[   32.378262] xc2028 2-0061: xc2028_set_analog_freq called
[   32.378265] xc2028 2-0061: generic_set_freq called
[   32.386753] DVB: registering new adapter (cx88[0])
[   32.386758] dvb_register_frontend
[   32.386761] DVB: registering frontend 0 (Zarlink ZL10353 DVB-T)...
[   32.387035] xc2028 2-0061: should set frequency 400000 kHz
[   32.387039] xc2028 2-0061: check_firmware called
[   32.387041] xc2028 2-0061: xc2028/3028 firmware name not set!
[   32.389074] ACPI: PCI Interrupt Link [LAZA] enabled at IRQ 23
[   32.389080] ACPI: PCI Interrupt 0000:00:10.1[B] -> Link [LAZA] -> GSI 
23 (level, low) -> IRQ 16
[   32.389101] PCI: Setting latency timer of device 0000:00:10.1 to 64
[   33.774579] lp0: using parport0 (interrupt-driven).
[   33.914661] NET: Registered protocol family 10
[   33.914892] lo: Disabled Privacy Extensions
[   34.192244] Adding 1317288k swap on /dev/sda5.  Priority:-1 extents:1 
across:1317288k
[   34.850791] EXT3 FS on sda1, internal journal
[   37.379550] No dock devices found.
[   37.807328] powernow-k8: Found 1 AMD Athlon(tm) 64 Processor 3200+ 
processors (1 cpu cores) (version 2.20.00)
[   37.807362] powernow-k8:    0 : fid 0xc (2000 MHz), vid 0x8
[   37.807364] powernow-k8:    1 : fid 0xa (1800 MHz), vid 0x8
[   37.807366] powernow-k8:    2 : fid 0x2 (1000 MHz), vid 0x12
[   40.505929] apm: BIOS version 1.2 Flags 0x03 (Driver version 1.16ac)
[   40.505935] apm: overridden by ACPI.
[   44.131140] eth0: no IPv6 routers present
[   45.324947] xc2028 2-0061: xc2028_sleep called
[   91.100371] Marking TSC unstable due to: cpufreq changes.
[   91.108149] Time: acpi_pm clocksource has been installed.
[   91.226100] dvb_frontend_open
[   91.226112] cx88[0]/2-dvb: cx8802_dvb_advise_acquire
[   91.226116] dvb_frontend_start
[   91.228838] dvb_frontend_ioctl
[   91.228849] dvb_frontend_thread
[   91.228853] DVB: initialising frontend 0 (Zarlink ZL10353 DVB-T)...
[   91.231486] dvb_frontend_release
[   91.231493] cx88[0]/2-dvb: cx8802_dvb_advise_release
[   91.231551] dvb_frontend_open
[   91.231554] cx88[0]/2-dvb: cx8802_dvb_advise_acquire
[   91.231558] dvb_frontend_start
[   91.231563] dvb_frontend_ioctl
[   91.231568] dvb_frontend_release
[   91.231572] cx88[0]/2-dvb: cx8802_dvb_advise_release
[   91.231631] dvb_frontend_open
[   91.231642] cx88[0]/2-dvb: cx8802_dvb_advise_acquire
[   91.231645] dvb_frontend_start
[   91.231649] dvb_frontend_ioctl
[   91.500033] Clocksource tsc unstable (delta = -199997434 ns)
[   92.328714] xc2028 2-0061: xc2028_set_analog_freq called
[   92.328725] xc2028 2-0061: generic_set_freq called
[   92.328729] xc2028 2-0061: should set frequency 87500 kHz
[   92.328737] xc2028 2-0061: check_firmware called
[   92.328741] xc2028 2-0061: xc2028/3028 firmware name not set!
[   92.343976] xc2028 2-0061: xc2028_sleep called

-- 
This message has been scanned for viruses and
dangerous content by MailScanner, and is
believed to be clean.


--------------090903020504030503030603
Content-Type: text/x-patch;
 name="dtv1800.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dtv1800.patch"

diff -r 55d60e988b89 linux/drivers/media/video/cx88/cx88-cards.c
--- a/linux/drivers/media/video/cx88/cx88-cards.c	Fri Oct 12 01:03:30 2007 +0200
+++ b/linux/drivers/media/video/cx88/cx88-cards.c	Sun Feb 24 22:07:35 2008 +0100
@@ -1549,6 +1549,36 @@ struct cx88_board cx88_boards[] = {
 			.gpio0  = 0x07fa,
 		}},
 	},
+	[CX88_BOARD_WINFAST_DTV1800H] = {
+		.name           = "LeadTek Winfast DTV1800 Hybrid",
+		.tuner_type     = TUNER_XCEIVE_XC3028,
+		.radio_type     = TUNER_XCEIVE_XC3028,
+		.tuner_addr     = 0x61,
+		.radio_addr     = 0x61,
+		.input          = {{
+			.type   = CX88_VMUX_TELEVISION,
+			.vmux   = 0,
+			.gpio0  = 0x0400,       //pin 2:mute = 0 (off)
+			.gpio1  = 0x6040,       //pin 13:audio = 0 (tuner), pin 14:FM = 1 (off?)
+			.gpio2  = 0x0000,
+		},{
+			.type   = CX88_VMUX_COMPOSITE1,
+			.vmux   = 1,
+			.gpio0  = 0x0400,       //pin 2:mute = 0 (off)
+			.gpio1  = 0x6060,       //pin 13:audio = 1 (line), pin 14:FM = 1 (off?)
+			.gpio2  = 0x0000,
+		},{
+			.type   = CX88_VMUX_SVIDEO,
+			.vmux   = 2,
+		}},
+		.radio = {
+			.type   = CX88_RADIO,
+			.gpio0  = 0x0400,       //pin 2:mute = 0 (off)
+			.gpio1  = 0x6000,       //pin 13:audio = 0? (tuner), pin 14:FM = 0? (on?)
+			.gpio2  = 0x0000,
+		},
+		.mpeg           = CX88_MPEG_DVB,
+	},
 };
 const unsigned int cx88_bcount = ARRAY_SIZE(cx88_boards);
 
@@ -1868,6 +1898,10 @@ struct cx88_subid cx88_subids[] = {
 		.subdevice = 0x6f18,
 		.card      = CX88_BOARD_WINFAST_TV2000_XP_GLOBAL,
 	},{
+		.subvendor = 0x107d,
+		.subdevice = 0x6654,
+		.card      = CX88_BOARD_WINFAST_DTV1800H,
+	},{
 		.subvendor = 0x14f1,
 		.subdevice = 0x8852,
 		.card      = CX88_BOARD_GENIATECH_X8000_MT,
@@ -2087,6 +2121,14 @@ void cx88_card_setup_pre_i2c(struct cx88
 		cx_set(MO_GP0_IO, 0x00000080); /* 702 out of reset */
 		udelay(1000);
 		break;
+	case CX88_BOARD_WINFAST_DTV1800H:
+		cx_write(MO_GP1_IO, 0x101010);  //gpio 12 = 1: powerup XC3028
+		mdelay(250);
+		cx_write(MO_GP1_IO, 0x101000);  //gpio 12 = 0: powerdown XC3028
+		mdelay(250);
+		cx_write(MO_GP1_IO, 0x101010);  //gpio 12 = 1: powerup XC3028
+		mdelay(250);
+		break;
 	}
 }
 
diff -r 55d60e988b89 linux/drivers/media/video/cx88/cx88-dvb.c
--- a/linux/drivers/media/video/cx88/cx88-dvb.c	Fri Oct 12 01:03:30 2007 +0200
+++ b/linux/drivers/media/video/cx88/cx88-dvb.c	Sun Feb 24 22:07:35 2008 +0100
@@ -314,6 +314,12 @@ static struct zl10353_config cx88_geniat
 	.r5c_clk_mpegts_output = 0x75,
 };
 
+static struct zl10353_config cx88_winfast_dtv1800h = {
+	.demod_address = (0x1e >> 1),
+	.no_tuner = 1,
+	.input_frequency = 0xe609,
+};
+
 static int nxt200x_set_ts_param(struct dvb_frontend* fe, int is_punctured)
 {
 	struct cx8802_dev *dev= fe->dvb->priv;
@@ -386,7 +392,9 @@ static struct xc3028_config geniatech_x8
 
 static int v4l_dvb_tuner_ioctl(struct v4l_dvb_tuner_ops *ops, int cmd, int arg)
 {
-	return ((struct cx88_core*)(ops->dev))->callback(ops->dev, cmd, arg);
+	struct cx88_core *core = ops->dev;
+
+	return core->callback(core->i2c_adap.algo_data, cmd, arg);
 }
 
 
@@ -421,6 +429,19 @@ static int dvb_register(struct cx8802_de
 			dvb_attach(dvb_pll_attach, &dev->dvb.frontend->ops.tuner_ops, 0x60,
 				   &dev->core->i2c_adap,
 				   &dvb_pll_thomson_dtt7579);
+		}
+		break;
+	case CX88_BOARD_WINFAST_DTV1800H:
+		dev->dvb.frontend = dvb_attach(zl10353_attach, &cx88_winfast_dtv1800h, &dev->core->i2c_adap);
+		if (dev->dvb.frontend != NULL) {
+			dev->dvb.frontend->ops.tuner_ops.fe = dev->dvb.frontend;
+
+			dev->dvb.frontend->ops.tuner_ops.ioctl = v4l_dvb_tuner_ioctl;
+			dev->dvb.frontend->ops.tuner_ops.dev = dev->core;
+			dev->dvb.frontend->ops.i2c_gate_ctrl = NULL;
+			dev->dvb.frontend->ops.sleep = NULL;
+
+			dvb_attach(xc3028_attach, &dev->dvb.frontend->ops.tuner_ops, &dev->core->i2c_adap, &dev->core->xc3028conf);
 		}
 		break;
 	case CX88_BOARD_WINFAST_DTV2000H:
diff -r 55d60e988b89 linux/drivers/media/video/cx88/cx88-i2c.c
--- a/linux/drivers/media/video/cx88/cx88-i2c.c	Fri Oct 12 01:03:30 2007 +0200
+++ b/linux/drivers/media/video/cx88/cx88-i2c.c	Sun Feb 24 22:07:35 2008 +0100
@@ -199,7 +199,7 @@ static int cx88_xc3028_control(void *pri
 	switch (command) {
 	case TUNER_RESET1:
 	case TUNER_RESET2:
-	case TUNER_RESET3:
+//	case TUNER_RESET3:
 		switch (mode) {
 		case V4L2_INT_TUNER_RADIO:
 			printk("Switching to radio!\n");
@@ -291,6 +291,7 @@ static int attach_inform(struct i2c_clie
 
 			case CX88_BOARD_WINFAST_TV2000_XP_GLOBAL:
 			case CX88_BOARD_PINNACLE_HYBRID_PCTV:
+			case CX88_BOARD_WINFAST_DTV1800H:
 				/* tun_setup.tuner_mode = TODO */
 				tun_setup.tuner_mode     = &core->mode;
 				tun_setup.tuner_callback = core->callback = cx88_xc3028_control;
@@ -311,9 +312,10 @@ static int attach_inform(struct i2c_clie
 			case CX88_BOARD_POWERCOLOR_REAL_ANGEL:
 			case CX88_BOARD_WINFAST_TV2000_XP_GLOBAL:
 			case CX88_BOARD_PINNACLE_HYBRID_PCTV:
+			case CX88_BOARD_WINFAST_DTV1800H:
 				/* tun_setup.tuner_mode = TODO */
 				tun_setup.tuner_mode     = &core->mode;
-				tun_setup.tuner_callback = cx88_xc3028_control;
+				tun_setup.tuner_callback = core->callback = cx88_xc3028_control;
 				break;
 			}
 
diff -r 55d60e988b89 linux/drivers/media/video/cx88/cx88.h
--- a/linux/drivers/media/video/cx88/cx88.h	Fri Oct 12 01:03:30 2007 +0200
+++ b/linux/drivers/media/video/cx88/cx88.h	Sun Feb 24 22:07:35 2008 +0100
@@ -219,6 +219,7 @@ extern struct sram_channel cx88_sram_cha
 #define CX88_BOARD_POWERCOLOR_REAL_ANGEL   60
 #define CX88_BOARD_GENIATECH_X8000_MT	   61
 #define CX88_BOARD_PIXELVIEW_PLAYTV_MPEG   62
+#define CX88_BOARD_WINFAST_DTV1800H        63
 
 enum cx88_itype {
 	CX88_VMUX_COMPOSITE1 = 1,

--------------090903020504030503030603
Content-Type: text/x-patch;
 name="dtv1800h-v4l.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dtv1800h-v4l.patch"

--- cx88-cards.c.prepatch	2008-08-23 16:24:33.000000000 +1000
+++ cx88-cards.c	2008-08-24 20:23:51.000000000 +1000
@@ -1611,6 +1611,36 @@
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
+                       .gpio1  = 0x6040,       //pin 13:audio = 0 (tuner), pin 14:FM = 1 (off?)
+                       .gpio2  = 0x0000,
+               },{
+                       .type   = CX88_VMUX_COMPOSITE1,
+                       .vmux   = 1,
+                       .gpio0  = 0x0400,       //pin 2:mute = 0 (off)
+                       .gpio1  = 0x6060,       //pin 13:audio = 1 (line), pin 14:FM = 1 (off?)
+                       .gpio2  = 0x0000,
+               },{
+                       .type   = CX88_VMUX_SVIDEO,
+                       .vmux   = 2,
+               }},
+               .radio = {
+                       .type   = CX88_RADIO,
+                       .gpio0  = 0x0400,       //pin 2:mute = 0 (off)
+                       .gpio1  = 0x6000,       //pin 13:audio = 0? (tuner), pin 14:FM = 0? (on?)
+                       .gpio2  = 0x0000,
+               },
+               .mpeg           = CX88_MPEG_DVB,
+       },
 };
 
 /* ------------------------------------------------------------------ */
@@ -1948,6 +1978,10 @@
 		.subvendor = 0x14f1,
 		.subdevice = 0x8852,
 		.card      = CX88_BOARD_GENIATECH_X8000_MT,
+        }, {
+                .subvendor = 0x107d,
+                .subdevice = 0x6654,
+                .card      = CX88_BOARD_WINFAST_DTV1800H,
 	}
 };
 
@@ -2188,6 +2222,7 @@
 	case CX88_BOARD_WINFAST_TV2000_XP_GLOBAL:
 	case CX88_BOARD_POWERCOLOR_REAL_ANGEL:
 	case CX88_BOARD_GENIATECH_X8000_MT:
+        case CX88_BOARD_WINFAST_DTV1800H:
 		return cx88_xc3028_geniatech_tuner_callback(priv, command, arg);
 	case CX88_BOARD_DVICO_FUSIONHDTV_DVB_T_PRO:
 		return cx88_dvico_xc2028_callback(priv, command, arg);
@@ -2310,6 +2345,14 @@
 		cx_set(MO_GP0_IO, 0x00000080); /* 702 out of reset */
 		udelay(1000);
 		break;
+        case CX88_BOARD_WINFAST_DTV1800H:
+                cx_write(MO_GP1_IO, 0x101010);  //gpio 12 = 1: powerup XC3028
+                mdelay(250);
+                cx_write(MO_GP1_IO, 0x101000);  //gpio 12 = 0: powerdown XC3028
+                mdelay(250);
+                cx_write(MO_GP1_IO, 0x101010);  //gpio 12 = 1: powerup XC3028
+                mdelay(250);
+                break;
 	}
 }
 
--- cx88-dvb.c.prepatch	2008-08-23 16:48:59.000000000 +1000
+++ cx88-dvb.c	2008-08-24 18:28:44.000000000 +1000
@@ -773,6 +773,14 @@
 				fe->ops.tuner_ops.set_config(fe, &ctl);
 		}
 		break;
+         case CX88_BOARD_WINFAST_DTV1800H:
+//               dev->ts_gen_cntrl = 0x00;
+               dev->dvb.frontend = dvb_attach(zl10353_attach,
+                                               &cx88_geniatech_x8000_mt,
+                                               &dev->core->i2c_adap);
+                attach_xc3028 = 1;
+                break;
+
 	 case CX88_BOARD_PINNACLE_HYBRID_PCTV:
 		dev->dvb.frontend = dvb_attach(zl10353_attach,
 					       &cx88_geniatech_x8000_mt,
--- cx88.h.prepatch	2008-08-23 16:49:16.000000000 +1000
+++ cx88.h	2008-08-24 18:28:22.000000000 +1000
@@ -220,6 +220,7 @@
 #define CX88_BOARD_POWERCOLOR_REAL_ANGEL   62
 #define CX88_BOARD_GENIATECH_X8000_MT      63
 #define CX88_BOARD_DVICO_FUSIONHDTV_DVB_T_PRO 64
+#define CX88_BOARD_WINFAST_DTV1800H        65
 
 enum cx88_itype {
 	CX88_VMUX_COMPOSITE1 = 1,

--------------090903020504030503030603
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------090903020504030503030603--
