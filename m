Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Message-ID: <48BA5B10.5030802@singlespoon.org.au>
Date: Sun, 31 Aug 2008 18:49:20 +1000
From: Paul Chubb <paulc@singlespoon.org.au>
MIME-Version: 1.0
To: Steven Toth <stoth@linuxtv.org>
References: <48B285BA.2090101@singlespoon.org.au>
	<48B2C052.5030905@linuxtv.org>
In-Reply-To: <48B2C052.5030905@linuxtv.org>
Cc: linux dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] leadtek dtv1800 h support
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

Steven,
                thanks for that. Sorry to take so long to respond, 
business, sickness and a broken laptop belonging to the wife had 
priority. I have made that change and it is still not working.  Can 
anyone tell me whether the "xc2028 2-0061: xc2028/3028 firmware name not 
set!" is normal?

any help gratefully received.

Cheers Paul

dmesg is saying:

[   28.638400] Linux agpgart interface v0.102
[   28.718353] i2c-adapter i2c-0: nForce2 SMBus adapter at 0x600
[   28.718382] i2c-adapter i2c-1: nForce2 SMBus adapter at 0x700
[   29.581087] Linux video capture interface: v2.00
[   29.826439] cx88/0: cx2388x v4l2 driver version 0.0.6 loaded
[   29.826815] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 19
[   29.826825] ACPI: PCI Interrupt 0000:04:09.0[A] -> Link [LNKB] -> GSI 
19 (level, low) -> IRQ 20
[   29.826882] cx88[0]: subsystem: 107d:6654, board: LeadTek Winfast 
DTV1800 Hybrid [card=65,autodetected]
[   29.826884] cx88[0]: TV tuner type 71, Radio tuner type 0
[   29.876688] cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.6 loaded
[   30.712104] input: PC Speaker as /devices/platform/pcspkr/input/input5
[   31.088959] parport_pc 00:06: reported by Plug and Play ACPI
[   31.089080] parport0: PC-style at 0x378 (0x778), irq 7, dma 3 
[PCSPP,TRISTATE,COMPAT,EPP,ECP,DMA]
[   31.743004] cx88[0]: i2c register ok
[   31.782451] cx88[0]/0: found at 0000:04:09.0, rev: 5, irq: 20, 
latency: 64, mmio: 0xf7000000
[   32.072372] tuner' 2-0061: chip found @ 0xc2 (cx88[0])
[   32.072393] cx88[0]: tuner' i2c attach [addr=0x61,client=(tuner unset)]
[   32.072397] xc2028: Xcv2028/3028 init called!
[   32.072400] xc2028 2-0061: type set to XCeive xc2028/xc3028 tuner
[   32.072403] xc2028 2-0061: xc2028_set_analog_freq called
[   32.072405] xc2028 2-0061: generic_set_freq called
[   32.072407] xc2028 2-0061: should set frequency 400000 kHz
[   32.072409] xc2028 2-0061: check_firmware called
[   32.072411] xc2028 2-0061: xc2028/3028 firmware name not set!
[   32.081148] cx88[0]/0: registered device video0 [v4l2]
[   32.081165] cx88[0]/0: registered device vbi0
[   32.081181] cx88[0]/0: registered device radio0
[   32.081241] xc2028 2-0061: xc2028_set_analog_freq called
[   32.081244] xc2028 2-0061: generic_set_freq called
[   32.081246] xc2028 2-0061: should set frequency 400000 kHz
[   32.081248] xc2028 2-0061: check_firmware called
[   32.081250] xc2028 2-0061: xc2028/3028 firmware name not set!
[   32.082569] cx88[0]/2: cx2388x 8802 Driver Manager
[   32.082591] ACPI: PCI Interrupt 0000:04:09.2[A] -> Link [LNKB] -> GSI 
19 (level, low) -> IRQ 20
[   32.082599] cx88[0]/2: found at 0000:04:09.2, rev: 5, irq: 20, 
latency: 64, mmio: 0xf9000000
[   32.083266] ACPI: PCI Interrupt Link [LAZA] enabled at IRQ 23
[   32.083268] ACPI: PCI Interrupt 0000:00:10.1[B] -> Link [LAZA] -> GSI 
23 (level, low) -> IRQ 16
[   32.083287] PCI: Setting latency timer of device 0000:00:10.1 to 64
[   32.127731] cx88/2: cx2388x dvb driver version 0.0.6 loaded
[   32.127736] cx88/2: registering cx8802 driver, type: dvb access: shared
[   32.127740] cx88[0]/2: subsystem: 107d:6654, board: LeadTek Winfast 
DTV1800 Hybrid [card=65]
[   32.127743] cx88[0]/2-dvb: cx8802_dvb_probe
[   32.127745] cx88[0]/2-dvb:  ->being probed by Card=65 Name=cx88[0], 
PCI 04:09
[   32.127747] cx88[0]/2: cx2388x based DVB/ATSC card
[   32.156427] xc2028: Xcv2028/3028 init called!
[   32.156433] xc2028 2-0061: type set to XCeive xc2028/xc3028 tuner
[   32.156732] xc2028 2-0061: xc2028_sleep called
[   32.169974] DVB: registering new adapter (cx88[0])
[   32.169979] dvb_register_frontend
[   32.169982] DVB: registering frontend 0 (Zarlink ZL10353 DVB-T)...
[   33.317397] NET: Registered protocol family 10
[   33.317628] lo: Disabled Privacy Extensions
[   33.712824] lp0: using parport0 (interrupt-driven).
[   33.898837] Adding 1317288k swap on /dev/sda5.  Priority:-1 extents:1 
across:1317288k
[   34.557544] EXT3 FS on sda1, internal journal
[   37.102885] No dock devices found.
[   37.531957] powernow-k8: Found 1 AMD Athlon(tm) 64 Processor 3200+ 
processors (1 cpu cores) (version 2.20.00)
[   37.531990] powernow-k8:    0 : fid 0xc (2000 MHz), vid 0x8
[   37.531992] powernow-k8:    1 : fid 0xa (1800 MHz), vid 0x8
[   37.531994] powernow-k8:    2 : fid 0x2 (1000 MHz), vid 0x12
[   40.272294] apm: BIOS version 1.2 Flags 0x03 (Driver version 1.16ac)
[   40.272300] apm: overridden by ACPI.
[   43.834306] eth0: no IPv6 routers present
[   45.221024] dvb_frontend_open
[   45.221032] cx88[0]/2-dvb: cx8802_dvb_advise_acquire
[   45.221034] dvb_frontend_start
[   45.223064] dvb_frontend_ioctl
[   45.223071] dvb_frontend_thread
[   45.223073] DVB: initialising frontend 0 (Zarlink ZL10353 DVB-T)...
[   45.225411] dvb_frontend_release
[   45.225415] cx88[0]/2-dvb: cx8802_dvb_advise_release
[   45.225456] dvb_frontend_open
[   45.225458] cx88[0]/2-dvb: cx8802_dvb_advise_acquire
[   45.225459] dvb_frontend_start
[   45.225462] dvb_frontend_ioctl
[   45.225465] dvb_frontend_release
[   45.225466] cx88[0]/2-dvb: cx8802_dvb_advise_release
[   45.225505] dvb_frontend_open
[   45.225507] cx88[0]/2-dvb: cx8802_dvb_advise_acquire
[   45.225508] dvb_frontend_start
[   45.225511] dvb_frontend_ioctl
[   90.905975] Marking TSC unstable due to: cpufreq changes.
[   90.913866] Time: acpi_pm clocksource has been installed.
[   91.313691] Clocksource tsc unstable (delta = -204020896 ns)
[   91.855061] xc2028 2-0061: xc2028_set_analog_freq called
[   91.855073] xc2028 2-0061: generic_set_freq called
[   91.855077] xc2028 2-0061: should set frequency 87500 kHz
[   91.855081] xc2028 2-0061: check_firmware called
[   91.855085] xc2028 2-0061: xc2028/3028 firmware name not set!
[   91.870584] xc2028 2-0061: xc2028_sleep called

patch is:
--- cx88-cards.c.prepatch    2008-08-23 16:24:33.000000000 +1000
+++ cx88-cards.c    2008-08-31 18:26:01.000000000 +1000
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
 
@@ -2310,6 +2346,15 @@
         cx_set(MO_GP0_IO, 0x00000080); /* 702 out of reset */
         udelay(1000);
         break;
+        case CX88_BOARD_WINFAST_DTV1800H:
+                cx_set(MO_GP1_IO, 0x000010);  //gpio 12 = 1: powerup XC3028
+                mdelay(250);
+                cx_clear(MO_GP1_IO, 0x000010);  //gpio 12 = 0: 
powerdown XC3028
+                mdelay(250);
+                cx_set(MO_GP1_IO, 0x000010);  //gpio 12 = 1: powerup XC3028
+                mdelay(250);
+                break;
+
     }
 }
 
--- cx88-dvb.c.prepatch    2008-08-23 16:48:59.000000000 +1000
+++ cx88-dvb.c    2008-08-31 17:47:12.000000000 +1000
@@ -773,6 +773,7 @@
                 fe->ops.tuner_ops.set_config(fe, &ctl);
         }
         break;
+         case CX88_BOARD_WINFAST_DTV1800H:
      case CX88_BOARD_PINNACLE_HYBRID_PCTV:
         dev->dvb.frontend = dvb_attach(zl10353_attach,
                            &cx88_geniatech_x8000_mt,
--- cx88.h.prepatch    2008-08-23 16:49:16.000000000 +1000
+++ cx88.h    2008-08-24 18:28:22.000000000 +1000
@@ -220,6 +220,7 @@
 #define CX88_BOARD_POWERCOLOR_REAL_ANGEL   62
 #define CX88_BOARD_GENIATECH_X8000_MT      63
 #define CX88_BOARD_DVICO_FUSIONHDTV_DVB_T_PRO 64
+#define CX88_BOARD_WINFAST_DTV1800H        65
 
 enum cx88_itype {
     CX88_VMUX_COMPOSITE1 = 1,

Steven Toth wrote:
> Paul Chubb wrote:
>> Hi,
>>     a few months ago Miroslav Sustek created a patch for this card 
>> against Markus Rechberger's v4l repository. This patch is attached as 
>> dtv1800.patch. A patched and compiled set of drivers fails on ubuntu 
>> hardy heron 8.04 with lots of symbol errors. Hardy is running 
>> 2.6.24.19. I have attempted to backport this patch to the current v4l 
>> tree with limited success. The driver loads however fails to do 
>> anything useful. My patch is attached as dtv1800h-v4l.patch.
>>
>> I *think* the issue is with loading firmware. The tuner-xc2028.c 
>> function check_firmware is passed a frontend without the firmware 
>> name - producing the error shown in the dmesg listing below. If I 
>> hack the function and hardcode the firmware file name, it attempts to 
>> load the firmware but fails when it tries to read back.
>>
>> Now that I am totally out of my depth I am not sure what to try next. 
>> Any help will be gratefully received.
>
> Don't call cx_write() inside the gpio card setup, you're potentially 
> destroying the other bits, it's risky.
>
> +    case CX88_BOARD_WINFAST_DTV1800H:
> +        cx_write(MO_GP1_IO, 0x101010);  //gpio 12 = 1: powerup XC3028
> +        mdelay(250);
> +        cx_write(MO_GP1_IO, 0x101000);  //gpio 12 = 0: powerdown XC3028
> +        mdelay(250);
> +        cx_write(MO_GP1_IO, 0x101010);  //gpio 12 = 1: powerup XC3028
> +        mdelay(250);
> +        break;
>
>
> Call cx_clear() and cx_set() instead, for the specific gpio bit (12) 
> that you need.
>
> - Steve
>
>
>
>
>


-- 
This message has been scanned for viruses and
dangerous content by MailScanner, and is
believed to be clean.


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
