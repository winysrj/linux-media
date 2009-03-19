Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from imo-d21.mx.aol.com ([205.188.144.207])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <td9678td@aim.com>) id 1LkHQ9-0005X9-IH
	for linux-dvb@linuxtv.org; Thu, 19 Mar 2009 13:32:28 +0100
Received: from td9678td@aim.com
	by imo-d21.mx.aol.com  (mail_out_v39.1.) id m.c68.4923fa8e (37035)
	for <linux-dvb@linuxtv.org>; Thu, 19 Mar 2009 08:31:47 -0400 (EDT)
References: <221784.66631.qm@web59912.mail.ac4.yahoo.com>
To: linux-dvb@linuxtv.org
Date: Thu, 19 Mar 2009 08:31:43 -0400
In-Reply-To: <221784.66631.qm@web59912.mail.ac4.yahoo.com>
MIME-Version: 1.0
From: td9678td@aim.com
Message-Id: <8CB76A5CB99620E-C80-3B5D@WEBMAIL-MY17.sysops.aol.com>
Subject: Re: [linux-dvb] Compro VideoMate E600F analog - someone please take
 pity on me and help me.
Reply-To: linux-media@vger.kernel.org
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

Hello,

it seems, Compro has some curious things, that makes the driver 
development difficult. Having the same problem with a T750 
(http://linuxtv.org/wiki/index.php/Compro_Videomate_T750).

@Marek: under Windows, do you use the bundled ComproDTV software? Is 
there perhaps an other software, that can recognize this card in 
Windows, and can use the analog features of it?




-----Original Message-----
From: Marek Marek <albatrosmwdvb@yahoo.com>
To: linux-dvb@linuxtv.org
Sent: Sun, 15 Mar 2009 10:02 pm
Subject: [linux-dvb] Compro VideoMate E600F analog - someone please 
take pity on me and help me.


I have Compro VideoMate E600F analog PCIe TV/FM capture card with MPEG 
II A/V Encoder. I use Gentoo 2008.0 with 2.6.25-gentoo-r7 x86_64 
kernel. There's no any support for this card on the V4L/DVB repository 
yet, so anybody help me?

Conexant CX23885-13Z PCIe A/V Decoder
Conexant CX23417-11Z MPEG II A/V Encoder
XCeive XC2028ACQ Video Tuner

lsmod:
Module                  Size  Used by
tuner_xc2028           18992  1
tuner                  24972  0
cx25840                26096  0
cx23885               100348  0
cx2341x                11268  1 cx23885
videobuf_dma_sg        11844  1 cx23885
fglrx                2278056  27
btcx_risc               4232  1 cx23885
tveeprom               13508  1 cx23885
videobuf_dvb            5060  1 cx23885
dvb_core               74996  1 videobuf_dvb
snd_hda_intel         331316  5
videobuf_core          16516  3 cx23885,videobuf_dma_sg,videobuf_dvb

dmesg:
v4l1_compat: module is already loaded
videodev: exports duplicate symbol video_unregister_device (owned by 
kernel)
compat_ioctl32: exports duplicate symbol v4l_compat_ioctl32 (owned by 
kernel)
cx23885 driver version 0.0.1 loaded
ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 16 (level, low) -> IRQ 16
CORE cx23885[0]: subsystem: 185b:e800, board: Compro Videomate E600F 
[card=12,autodetected]
cx23885[0]: i2c bus 0 registered
cx23885[0]: i2c bus 1 registered
cx23885[0]: i2c bus 2 registered
tveeprom 1-0050: Encountered bad packet header [ff]. Corrupt or not a 
Hauppauge eeprom.
cx23885[0]: warning: unknown hauppauge model #0
cx23885[0]: hauppauge eeprom: model=0
v4l2_common: exports duplicate symbol v4l2_i2c_attach (owned by kernel)
cx25840' 3-0044: cx25  0-21 found @ 0x88 (cx23885[0])
v4l2_common: exports duplicate symbol v4l2_i2c_attach (owned by kernel)
v4l1_compat: module is already loaded
videodev: exports duplicate symbol video_unregister_device (owned by 
kernel)
tuner' 1-0068: chip found @ 0xd0 (cx23885[0])
tuner' 2-0061: chip found @ 0xc2 (cx23885[0])
xc2028 2-0061: creating new instance
xc2028 2-0061: type set to XCeive xc2028/xc3028 tuner
xc2028 2-0061: destroying instance
xc2028 2-0061: creating new instance
xc2028 2-0061: type set to XCeive xc2028/xc3028 tuner
cx23885[0]/0: registered device video31 [v4l2]
cx23885[0]/1: registered ALSA audio device
xc2028 2-0061: Loading 80 firmware images from xc3028-v27.fw, type: 
xc2028 firmware, ver 2.7
xc2028 2-0061: Loading firmware for type=BASE (1), id 0000000000000000.
xc2028 2-0061: Loading firmware for type=(0), id 000000000000b700.
SCODE (20000000), id 000000000000b700:
xc2028 2-0061: Loading SCODE for type=MONO SCODE HAS_IF_4320 
(60008000), id 0000000000008000.
cx25840' 3-0044: loaded v4l-cx23885-avcore-01.fw firmware (16382 bytes)
cx23885[0]: registered device video31 [mpeg]
cx23885_dev_checkrevision() Hardware revision = 0xb0
cx23885[0]/0: found at 0000:02:00.0, rev: 2, irq: 16, latency: 0, mmio: 
0xfd600000
PCI: Setting latency timer of device 0000:02:00.0 to 64

patch:
diff -Naur 
czysty/cx23885-audio/linux/drivers/media/video/cx23885/cx23885-cards.c 
cx23885-audio/linux/drivers/media/video/cx23885/cx23885-cards.c
--- 
czysty/cx23885-audio/linux/drivers/media/video/cx23885/cx23885-cards.c  
    2009-03-15 21:25:47.000000000 +0100
+++ cx23885-audio/linux/drivers/media/video/cx23885/cx23885-cards.c     
2009-03-15 21:39:56.000000000 +0100
@@ -178,6 +178,33 @@
                .portb          = CX23885_MPEG_DVB,
                .portc          = CX23885_MPEG_DVB,
        },
+       [CX23885_BOARD_COMPRO_VIDEOMATE_E600F] = {
+               .name           = "Compro Videomate E600F",
+               .porta          = CX23885_ANALOG_VIDEO,
+               .portb          = CX23885_MPEG_ENCODER,
+               .tuner_type     = TUNER_XC2028,
+               .tuner_addr     = 0x61,
+               .input          = {{
+                       .type   = CX23885_VMUX_TELEVISION,
+                       .vmux   =       CX25840_VIN7_CH3 |
+                                       CX25840_VIN5_CH2 |
+                                       CX25840_VIN2_CH1,
+                       .gpio0  = 0,
+               }, {
+                       .type   = CX23885_VMUX_COMPOSITE1,
+                       .vmux   =       CX25840_VIN7_CH3 |
+                                       CX25840_VIN4_CH2 |
+                                       CX25840_VIN6_CH1,
+                       .gpio0  = 0,
+               }, {
+                       .type   = CX23885_VMUX_SVIDEO,
+                       .vmux   =       CX25840_VIN7_CH3 |
+                                       CX25840_VIN4_CH2 |
+                                       CX25840_VIN8_CH1 |
+                                       CX25840_SVIDEO_ON,
+                       .gpio0  = 0,
+               } },
+       },
 };
 const unsigned int cx23885_bcount = ARRAY_SIZE(cx23885_boards);

@@ -253,6 +280,10 @@
                .subvendor = 0x18ac,
                .subdevice = 0xdb78,
                 .card      = 
CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP,
+       },{
+               .subvendor = 0x185b,
+               .subdevice = 0xe800,
+               .card      = CX23885_BOARD_COMPRO_VIDEOMATE_E600F,
        },
 };
 const unsigned int cx23885_idcount = ARRAY_SIZE(cx23885_subids);
@@ -372,6 +403,7 @@
        case CX23885_BOARD_HAUPPAUGE_HVR1400:
        case CX23885_BOARD_HAUPPAUGE_HVR1500:
        case CX23885_BOARD_HAUPPAUGE_HVR1500Q:
+       case CX23885_BOARD_COMPRO_VIDEOMATE_E600F:
                /* Tuner Reset Command */
                if (command == 0)
                        bitmask = 0x04;
@@ -515,6 +547,15 @@
                mdelay(20);
                cx_set(GP0_IO, 0x000f000f);
                break;
+        case CX23885_BOARD_COMPRO_VIDEOMATE_E600F:
+               /* GPIO-2  xc3008 tuner reset */
+               /* Put the parts into reset and back */
+                cx_set(GP0_IO, 0x00040000);
+                mdelay(20);
+                cx_clear(GP0_IO, 0x00000004);
+                mdelay(20);
+                cx_set(GP0_IO, 0x00040004);
+                break;
        }
 }

@@ -555,6 +596,7 @@
        case CX23885_BOARD_HAUPPAUGE_HVR1500:
        case CX23885_BOARD_HAUPPAUGE_HVR1500Q:
        case CX23885_BOARD_HAUPPAUGE_HVR1400:
+       case CX23885_BOARD_COMPRO_VIDEOMATE_E600F:
                if (dev->i2c_bus[0].i2c_rc == 0)
                        hauppauge_eeprom(dev, eeprom+0x80);
                break;
@@ -602,6 +644,7 @@
        case CX23885_BOARD_HAUPPAUGE_HVR1200:
        case CX23885_BOARD_HAUPPAUGE_HVR1700:
        case CX23885_BOARD_HAUPPAUGE_HVR1400:
+       case CX23885_BOARD_COMPRO_VIDEOMATE_E600F:
        default:
                 ts2->gen_ctrl_val  = 0xc; /* Serial bus + punctured 
clock */
                ts2->ts_clk_en_val = 0x1; /* Enable TS_CLK */
@@ -616,6 +659,7 @@
        case CX23885_BOARD_HAUPPAUGE_HVR1800lp:
        case CX23885_BOARD_HAUPPAUGE_HVR1700:
        case CX23885_BOARD_HAUPPAUGE_HVR1500:
+       case CX23885_BOARD_COMPRO_VIDEOMATE_E600F:
                request_module("cx25840");
                break;
        }
diff -Naur 
czysty/cx23885-audio/linux/drivers/media/video/cx23885/cx23885.h 
cx23885-audio/linux/drivers/media/video/cx23885/cx23885.h
--- czysty/cx23885-audio/linux/drivers/media/video/cx23885/cx23885.h    
2009-03-15 21:25:47.000000000 +0100
+++ cx23885-audio/linux/drivers/media/video/cx23885/cx23885.h   
2009-03-15 21:39:50.000000000 +0100
@@ -66,6 +66,7 @@
 #define CX23885_BOARD_HAUPPAUGE_HVR1400        9
 #define CX23885_BOARD_DVICO_FUSIONHDTV_7_DUAL_EXP 10
 #define CX23885_BOARD_DVICO_FUSIONHDTV_DVB_T_DUAL_EXP 11
+#define CX23885_BOARD_COMPRO_VIDEOMATE_E600F   12

  /* Currently unsupported by the driver: PAL/H, NTSC/Kr, SECAM B/G/H/LC 
*/
 #define CX23885_NORMS (\

lspci -vvnn:
02:00.0 Multimedia video controller [0400]: Conexant Systems, Inc. 
CX23885 PCI Video and Audio Decoder [14f1:8852] (rev 02)
        Subsystem: Compro Technology, Inc. Device [185b:e800]
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 4 bytes
        Interrupt: pin A routed to IRQ 16
         Region 0: Memory at fd600000 (64-bit, non-prefetchable) 
[size=2M]
        Capabilities: [40] Express (v1) Endpoint, MSI 00
                 DevCap: MaxPayload 128 bytes, PhantFunc 0, Latency L0s 
<64ns, L1 <1us
                        ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
                 DevCtl: Report errors: Correctable- Non-Fatal- Fatal- 
Unsupported-
                        RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
                        MaxPayload 128 bytes, MaxReadReq 512 bytes
                 DevSta: CorrErr- UncorrErr+ FatalErr- UnsuppReq+ 
AuxPwr- TransPend-
                 LnkCap: Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, 
Latency L0 <2us, L1 <4us
                        ClockPM- Surprise- LLActRep- BwNot-
                 LnkCtl: ASPM Disabled; RCB 64 bytes Disabled- Retrain- 
CommClk+
                        ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
                 LnkSta: Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ 
DLActive- BWMgmt- ABWMgmt-
        Capabilities: [80] Power Management version 2
                 Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [90] Vital Product Data
                Not readable
        Capabilities: [a0] MSI: Mask- 64bit+ Count=1/1 Enable-
                Address: 0000000000000000  Data: 0000
        Capabilities: [100] Advanced Error Reporting
                 UESta:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq+ ACSViol-
                 UEMsk:  DLP- SDES- TLP- FCP- CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF- MalfTLP- ECRC- UnsupReq- ACSViol-
                 UESvrt: DLP+ SDES- TLP- FCP+ CmpltTO- CmpltAbrt- 
UnxCmplt- RxOF+ MalfTLP+ ECRC- UnsupReq- ACSViol-
                 CESta:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- 
NonFatalErr-
                 CEMsk:  RxErr- BadTLP- BadDLLP- Rollover- Timeout- 
NonFatalErr-
                 AERCap: First Error Pointer: 14, GenCap- CGenEn- 
ChkCap- ChkEn-
        Capabilities: [200] Virtual Channel <?>
        Kernel driver in use: cx23885
        Kernel modules: cx23885

i2cdetect -l:
i2c-0   smbus           SMBus PIIX4 adapter at 0b00             SMBus 
adapter
i2c-1   i2c             cx23885[0]                              I2C 
adapter
i2c-2   i2c             cx23885[0]                              I2C 
adapter
i2c-3   i2c             cx23885[0]                              I2C 
adapter

cat /dev/v4l/video*:
cat: /dev/v4l/video0: No such device
cat: /dev/v4l/video1: No such device

Detailed info:
http://linuxtv.org/wiki/index.php/Compro_VideoMate_E600F

Someone help me please?
Thanks for any help.

Marek Wasilow

PS: Sorry for my poor english...






_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb



_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
