Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from mail-bw0-f18.google.com ([209.85.218.18])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <gregoire.favre@gmail.com>) id 1LJRJy-0007JW-7F
	for linux-dvb@linuxtv.org; Sun, 04 Jan 2009 12:39:09 +0100
Received: by bwz11 with SMTP id 11so15125276bwz.17
	for <linux-dvb@linuxtv.org>; Sun, 04 Jan 2009 03:38:32 -0800 (PST)
Date: Sun, 4 Jan 2009 12:37:38 +0100
To: linux-dvb@linuxtv.org
Message-ID: <20090104113738.GD3551@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="nFreZHaLTZJo0R7j"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
From: Gregoire Favre <gregoire.favre@gmail.com>
Subject: [linux-dvb] s2-lipliandvb oops (cx88)
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


--nFreZHaLTZJo0R7j
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hello,

in order to use S2API I compiled s2-lipliandvb with attached config and
it ended with an oops which make me loose my USB keyboard...

What can I do in order to help this being fixed ?
-- 
Grégoire FAVRE http://gregoire.favre.googlepages.com http://www.gnupg.org
               http://picasaweb.google.com/Gregoire.Favre

--nFreZHaLTZJo0R7j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=".config"

#
# Automatically generated make config: don't edit
# Linux kernel version: KERNELVERSION
# Sun Jan  4 12:11:38 2009
#
CONFIG_INPUT=y
CONFIG_USB=y
# CONFIG_SPARC64 is not set
# CONFIG_of is not set
# CONFIG_M is not set
# CONFIG_PLAT_M32700UT is not set
# CONFIG_GENERIC_GPIO is not set
# CONFIG_SOUND_PRIME is not set
# CONFIG_dependencies is not set
CONFIG_FB_CFB_IMAGEBLIT=y
# CONFIG_GPIO_PCA953X is not set
# CONFIG_HAVE_CLK is not set
# CONFIG_SND_MPU401_UART is not set
CONFIG_SND=y
# CONFIG_ARCH_OMAP2 is not set
# CONFIG_SPARC32 is not set
CONFIG_I2C_ALGOBIT=m
# CONFIG_IR is not set
CONFIG_INET=y
CONFIG_CRC32=y
CONFIG_SYSFS=y
# CONFIG_ISA is not set
CONFIG_PCI=y
# CONFIG_PARPORT_1284 is not set
CONFIG_FB_CFB_FILLRECT=y
CONFIG_VIRT_TO_BUS=y
# CONFIG_PARPORT is not set
# CONFIG_Avoids is not set
# CONFIG_due is not set
CONFIG_NET=y
CONFIG_FB_CFB_COPYAREA=y
# CONFIG_SND_AC97_CODEC is not set
# CONFIG_PXA27x is not set
# CONFIG_SGI_IP22 is not set
CONFIG_I2C=y
# CONFIG_STANDALONE is not set
# CONFIG_Y is not set
CONFIG_MODULES=y
CONFIG_HAS_IOMEM=y
# CONFIG_SND_OPL3_LIB is not set
CONFIG_PROC_FS=y
# CONFIG_VIDEO_SAA7115 is not set
# CONFIG_DVB_FE_CUSTOMIZE is not set
# CONFIG_to is not set
CONFIG_HAS_DMA=y
# CONFIG_pvrusb is not set
CONFIG_FB=y
# CONFIG_DVB is not set
# CONFIG_SONY_LAPTOP is not set
CONFIG_SND_PCM=y
CONFIG_EXPERIMENTAL=y
# CONFIG_M32R is not set
# CONFIG_I2C_ALGO_SGI is not set
CONFIG_VIDEO_KERNEL_VERSION=y

#
# Multimedia devices
#

#
# Multimedia core support
#
CONFIG_VIDEO_DEV=m
CONFIG_VIDEO_V4L2_COMMON=m
CONFIG_VIDEO_ALLOW_V4L1=y
CONFIG_VIDEO_V4L1_COMPAT=y
CONFIG_DVB_CORE=m
CONFIG_VIDEO_MEDIA=m

#
# Multimedia drivers
#
CONFIG_VIDEO_SAA7146=m
CONFIG_VIDEO_SAA7146_VV=m
CONFIG_MEDIA_ATTACH=y
CONFIG_MEDIA_TUNER=m
# CONFIG_MEDIA_TUNER_CUSTOMIZE is not set
CONFIG_MEDIA_TUNER_SIMPLE=m
CONFIG_MEDIA_TUNER_TDA8290=m
CONFIG_MEDIA_TUNER_TDA827X=m
CONFIG_MEDIA_TUNER_TDA18271=m
CONFIG_MEDIA_TUNER_TDA9887=m
CONFIG_MEDIA_TUNER_TEA5761=m
CONFIG_MEDIA_TUNER_TEA5767=m
CONFIG_MEDIA_TUNER_MT20XX=m
CONFIG_MEDIA_TUNER_MT2131=m
CONFIG_MEDIA_TUNER_XC2028=m
CONFIG_MEDIA_TUNER_XC5000=m
CONFIG_MEDIA_TUNER_MXL5005S=m
CONFIG_VIDEO_V4L2=m
CONFIG_VIDEO_V4L1=m
CONFIG_VIDEOBUF_GEN=m
CONFIG_VIDEOBUF_DMA_SG=m
CONFIG_VIDEOBUF_DVB=m
CONFIG_VIDEO_BTCX=m
CONFIG_VIDEO_IR=m
CONFIG_VIDEO_TVEEPROM=m
CONFIG_VIDEO_TUNER=m
CONFIG_VIDEO_CAPTURE_DRIVERS=y
CONFIG_VIDEO_ADV_DEBUG=y
# CONFIG_VIDEO_FIXED_MINOR_RANGES is not set
CONFIG_VIDEO_HELPER_CHIPS_AUTO=y
CONFIG_VIDEO_IR_I2C=m
CONFIG_VIDEO_MSP3400=m
CONFIG_VIDEO_CS5345=m
CONFIG_VIDEO_CS53L32A=m
CONFIG_VIDEO_M52790=m
CONFIG_VIDEO_WM8775=m
CONFIG_VIDEO_WM8739=m
CONFIG_VIDEO_VP27SMPX=m
CONFIG_VIDEO_SAA711X=m
CONFIG_VIDEO_SAA717X=m
CONFIG_VIDEO_CX25840=m
CONFIG_VIDEO_CX2341X=m
CONFIG_VIDEO_SAA7127=m
CONFIG_VIDEO_UPD64031A=m
CONFIG_VIDEO_UPD64083=m
# CONFIG_VIDEO_VIVI is not set
# CONFIG_VIDEO_BT848 is not set
# CONFIG_VIDEO_CPIA is not set
# CONFIG_VIDEO_CPIA2 is not set
# CONFIG_VIDEO_SAA5246A is not set
# CONFIG_VIDEO_SAA5249 is not set
# CONFIG_VIDEO_STRADIS is not set
# CONFIG_VIDEO_ZORAN is not set
# CONFIG_VIDEO_SAA7134 is not set
# CONFIG_VIDEO_MXB is not set
# CONFIG_VIDEO_HEXIUM_ORION is not set
# CONFIG_VIDEO_HEXIUM_GEMINI is not set
CONFIG_VIDEO_CX88=m
CONFIG_VIDEO_CX88_ALSA=m
CONFIG_VIDEO_CX88_BLACKBIRD=m
CONFIG_VIDEO_CX88_DVB=m
CONFIG_VIDEO_CX88_VP3054=m
CONFIG_VIDEO_CX23885=m
# CONFIG_VIDEO_AU0828 is not set
CONFIG_VIDEO_IVTV=m
CONFIG_VIDEO_FB_IVTV=m
CONFIG_VIDEO_CX18=m
# CONFIG_VIDEO_CAFE_CCIC is not set
# CONFIG_SOC_CAMERA is not set
# CONFIG_V4L_USB_DRIVERS is not set
# CONFIG_RADIO_ADAPTERS is not set
# CONFIG_DVB_DYNAMIC_MINORS is not set
CONFIG_DVB_CAPTURE_DRIVERS=y

#
# Supported SAA7146 based PCI Adapters
#
CONFIG_TTPCI_EEPROM=m
# CONFIG_DVB_AV7110 is not set
CONFIG_DVB_BUDGET_CORE=m
CONFIG_DVB_BUDGET=m
CONFIG_DVB_BUDGET_CI=m
CONFIG_DVB_BUDGET_AV=m

#
# Supported USB Adapters
#
# CONFIG_DVB_USB is not set
# CONFIG_DVB_TTUSB_BUDGET is not set
# CONFIG_DVB_TTUSB_DEC is not set
# CONFIG_DVB_SIANO_SMS1XXX is not set

#
# Supported FlexCopII (B2C2) Adapters
#
# CONFIG_DVB_B2C2_FLEXCOP is not set

#
# Supported BT878 Adapters
#

#
# Supported Pluto2 Adapters
#
# CONFIG_DVB_PLUTO2 is not set

#
# Supported SDMC DM1105 Adapters
#
# CONFIG_DVB_DM1105 is not set

#
# Supported Mantis Adapters
#
# CONFIG_DVB_MANTIS is not set

#
# Supported DVB Frontends
#

#
# Customise DVB Frontends
#
# CONFIG_DVB_FE_CUSTOMISE is not set

#
# Multistandard (satellite) frontends
#
CONFIG_DVB_STB0899=m
CONFIG_DVB_STB6100=m

#
# DVB-S (satellite) frontends
#
CONFIG_DVB_CX24110=m
CONFIG_DVB_CX24123=m
CONFIG_DVB_MT312=m
CONFIG_DVB_S5H1420=m
CONFIG_DVB_STV0288=m
CONFIG_DVB_STB6000=m
CONFIG_DVB_STV0299=m
CONFIG_DVB_TDA8083=m
CONFIG_DVB_TDA10086=m
CONFIG_DVB_TDA8261=m
CONFIG_DVB_VES1X93=m
CONFIG_DVB_TUNER_ITD1000=m
CONFIG_DVB_TUNER_CX24113=m
CONFIG_DVB_TDA826X=m
CONFIG_DVB_TUA6100=m
CONFIG_DVB_CX24116=m
CONFIG_DVB_SI21XX=m
CONFIG_DVB_MB86A16=m
CONFIG_DVB_CU1216=m

#
# DVB-T (terrestrial) frontends
#
CONFIG_DVB_SP8870=m
CONFIG_DVB_SP887X=m
CONFIG_DVB_CX22700=m
CONFIG_DVB_CX22702=m
CONFIG_DVB_DRX397XD=m
CONFIG_DVB_L64781=m
CONFIG_DVB_TDA1004X=m
CONFIG_DVB_NXT6000=m
CONFIG_DVB_MT352=m
CONFIG_DVB_ZL10353=m
CONFIG_DVB_DIB3000MB=m
CONFIG_DVB_DIB3000MC=m
CONFIG_DVB_DIB7000M=m
CONFIG_DVB_DIB7000P=m
CONFIG_DVB_TDA10048=m

#
# DVB-C (cable) frontends
#
CONFIG_DVB_VES1820=m
CONFIG_DVB_TDA10021=m
CONFIG_DVB_TDA10023=m
CONFIG_DVB_STV0297=m

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#
CONFIG_DVB_NXT200X=m
# CONFIG_DVB_OR51211 is not set
CONFIG_DVB_OR51132=m
# CONFIG_DVB_BCM3510 is not set
CONFIG_DVB_LGDT330X=m
# CONFIG_DVB_LGDT3304 is not set
CONFIG_DVB_S5H1409=m
# CONFIG_DVB_AU8522 is not set
CONFIG_DVB_S5H1411=m

#
# ISDB-T (terrestrial) frontends
#
CONFIG_DVB_S921=m

#
# Digital terrestrial only tuners/PLL
#
CONFIG_DVB_PLL=m
CONFIG_DVB_TUNER_DIB0070=m

#
# SEC control devices for DVB-S
#
CONFIG_DVB_LNBP21=m
CONFIG_DVB_LNBP22=m
CONFIG_DVB_ISL6405=m
CONFIG_DVB_ISL6421=m
CONFIG_DVB_LGS8GL5=m

#
# Tools to develop new frontends
#
CONFIG_DVB_DUMMY_FE=m
CONFIG_DVB_AF9013=m
# CONFIG_DAB is not set

#
# Audio devices for multimedia
#

#
# ALSA sound
#
# CONFIG_SND_BT87X is not set

#
# OSS sound
#

--nFreZHaLTZJo0R7j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dvb-oops.txt"
Content-Transfer-Encoding: quoted-printable

Linux video capture interface: v2.00
saa7146: register extension 'budget dvb'.
saa7146: register extension 'budget_ci dvb'.
budget_ci dvb 0000:04:00.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
saa7146: found saa7146 @ mem ffffc20001220c00 (revision 1, irq 21) (0x13c2,=
0x100f).
saa7146 (0): dma buffer size 192512
DVB: registering new adapter (TT-Budget/WinTV-NOVA-CI PCI)
adapter has MAC addr =3D 00:d0:5c:23:a3:9b
input: Budget-CI dvb ir receiver saa7146 (0) as /devices/pci0000:00/0000:00=
:1e.0/0000:04:00.0/input/input7
DVB: registering adapter 0 frontend 0 (ST STV0299 DVB-S)...
cx88/0: cx2388x v4l2 driver version 0.0.6 loaded
cx8800 0000:04:02.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
cx88[0]: subsystem: 0070:6902, board: Hauppauge WinTV-HVR4000 DVB-S/S2/T/Hy=
brid [card=3D68,autodetected], frontend(s): 2
cx88[0]: TV tuner type 63, Radio tuner type -1
tuner' 8-0043: chip found @ 0x86 (cx88[0])
tda9887 8-0043: creating new instance
tda9887 8-0043: tda988[5/6/7] found
tuner' 8-0061: chip found @ 0xc2 (cx88[0])
tuner' 8-0063: chip found @ 0xc6 (cx88[0])
tveeprom 8-0050: Hauppauge model 69009, rev B2A0, serial# 1241151
tveeprom 8-0050: MAC address is 00-0D-FE-12-F0-3F
tveeprom 8-0050: tuner model is Philips FMD1216ME (idx 100, type 63)
tveeprom 8-0050: TV standards PAL(B/G) PAL(I) SECAM(L/L') PAL(D/D1/K) ATSC/=
DVB Digital (eeprom 0xf4)
tveeprom 8-0050: audio processor is CX882 (idx 33)
tveeprom 8-0050: decoder processor is CX882 (idx 25)
tveeprom 8-0050: has radio, has IR receiver, has no IR transmitter
cx88[0]: hauppauge eeprom: model=3D69009
tuner-simple 8-0061: creating new instance
tuner-simple 8-0061: type set to 63 (Philips FMD1216ME MK3 Hybrid Tuner)
input: cx88 IR (Hauppauge WinTV-HVR400 as /devices/pci0000:00/0000:00:1e.0/=
0000:04:02.0/input/input8
cx88[0]/0: found at 0000:04:02.0, rev: 5, irq: 23, latency: 64, mmio: 0xdb0=
00000
wm8775' 8-001b: chip found @ 0x36 (cx88[0])
cx88[0]/0: registered device video0 [v4l2]
cx88[0]/0: registered device vbi0
cx88[0]/0: registered device radio0
cx8800 0000:04:05.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
cx88[1]: subsystem: 14f1:0084, board: Geniatech DVB-S [card=3D52,autodetect=
ed], frontend(s): 1
cx88[1]: TV tuner type 4, Radio tuner type -1
cx88[1]/0: found at 0000:04:05.0, rev: 3, irq: 20, latency: 64, mmio: 0xd90=
00000
cx88[1]/0: registered device video1 [v4l2]
cx88[1]/0: registered device vbi1
saa7146: register extension 'budget_av'.
cx88/2: cx2388x MPEG-TS Driver Manager version 0.0.6 loaded
cx88[0]/2: cx2388x 8802 Driver Manager
cx88-mpeg driver manager 0000:04:02.2: PCI INT A -> GSI 23 (level, low) -> =
IRQ 23
cx88[0]/2: found at 0000:04:02.2, rev: 5, irq: 23, latency: 64, mmio: 0xdd0=
00000
cx8802_probe() allocating 2 frontend(s)
cx88[1]/2: cx2388x 8802 Driver Manager
cx88-mpeg driver manager 0000:04:05.2: PCI INT A -> GSI 20 (level, low) -> =
IRQ 20
cx88[1]/2: found at 0000:04:05.2, rev: 3, irq: 20, latency: 64, mmio: 0xda0=
00000
cx8802_probe() allocating 1 frontend(s)
cx88/2: cx2388x dvb driver version 0.0.6 loaded
cx88/2: registering cx8802 driver, type: dvb access: shared
cx88[0]/2: subsystem: 0070:6902, board: Hauppauge WinTV-HVR4000 DVB-S/S2/T/=
Hybrid [card=3D68]
BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
IP: [<ffffffffa088f15a>] vp3054_i2c_probe+0x1a/0x160 [cx88_vp3054_i2c]
PGD 159003067 PUD 164e2d067 PMD 0=20
Oops: 0000 [#1] PREEMPT SMP=20
last sysfs file: /sys/devices/pci0000:00/0000:00:1e.0/0000:04:05.0/video4li=
nux/video1/index
CPU 0=20
Modules linked in: cx88_dvb(+) vp27smpx cx25840 upd64031a saa717x cx8802 cs=
53l32a budget_av saa7127 cx2341x msp3400 wm8775 cx8800 cs5345 tuner m52790 =
upd64083 v4l2_common budget_ci cx88xx budget saa7146_vv dib3000mc or51132 t=
uner_simple dib7000m videobuf_dma_sg videodev dib7000p budget_core ir_kbd_i=
2c videobuf_dvb lgdt330x stv0299 mxl5005s nxt200x ves1x93 ves1820 stb0899 s=
tv0288 sp887x dvb_pll v4l2_compat_ioctl32 stv0297 stb6000 dib3000mb v4l2_in=
t_device tda8083 drx397xD s5h1409 sp8870 lnbp22 cx24113 tda8290 lnbp21 dibx=
000_common mt2131 videobuf_core tuner_types tda10023 tua6100 tveeprom l6478=
1 mt20xx tda9887 isl6421 ir_common btcx_risc mb86a16 zl10353 lgs8gl5 tda182=
71 tda10021 cx24110 tda827x cx22702 cx22700 s5h1420 tda10086 mt352 tea5767 =
mt312 cx24116 v4l1_compat s921 saa7146 cx24123 dvb_core ttpci_eeprom stb610=
0 dvb_dummy_fe tda10048 tda826x tda8261 dib0070 si21xx isl6405 af9013 xc500=
0 tuner_xc2028 nxt6000 cx88_vp3054_i2c cu1216 tda1004x itd1000 s5h1411 tea5=
761 i2c_algo_bit ipv6 coretemp w83627ehf w83791d hwmon_vid hwmon nfs lockd =
sunrpc firewire_ohci firewire_core crc_itu_t ohci1394 i2c_i801 ieee1394 snd=
_hda_intel nvidia(P) usb_storage
Pid: 10973, comm: modprobe Tainted: P           2.6.28-gentoo #1
RIP: 0010:[<ffffffffa088f15a>]  [<ffffffffa088f15a>] vp3054_i2c_probe+0x1a/=
0x160 [cx88_vp3054_i2c]
RSP: 0018:ffff880164d73d18  EFLAGS: 00010246
RAX: ffffffffa0bc4080 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffff8801653a7000 R08: 0000000000000000 R09: ffff88016e986360
R10: 0000000000000000 R11: 00000000807ca320 R12: ffff88016e986360
R13: 0000000000000000 R14: 00000000021d2160 R15: 00000000021d2178
FS:  00007f8431dc36f0(0000) GS:ffffffff80721200(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000164eb4000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process modprobe (pid: 10973, threadinfo ffff880164d72000, task ffff880161d=
0ef40)
Stack:
 0000000000000070 00000000ffffffed ffff8801653a7000 ffff88016e986360
 0000000000000000 ffffffffa0bf0848 0000000000000000 0000000000000001
 ffff88002da6e7b8 ffff880164d73d78 0000000000000000 ffff880164eb9050
Call Trace:
 [<ffffffffa0bf0848>] ? cx8802_dvb_probe+0x78/0x1e10 [cx88_dvb]
 [<ffffffff802f3019>] ? __sysfs_add_one+0x39/0xb0
 [<ffffffffa0bc572f>] ? cx8802_register_driver+0x1cf/0x258 [cx8802]
 [<ffffffff80230090>] ? update_curr+0xd0/0x130
 [<ffffffffa0bf26a0>] ? dvb_init+0x0/0x30 [cx88_dvb]
 [<ffffffff80209042>] ? _stext+0x42/0x1b0
 [<ffffffff802314fb>] ? enqueue_entity+0x1b/0x170
 [<ffffffff803bf589>] ? __next_cpu+0x19/0x30
 [<ffffffff80239d9c>] ? tg_shares_up+0xcc/0x240
 [<ffffffff80230090>] ? update_curr+0xd0/0x130
 [<ffffffff802315dd>] ? enqueue_entity+0xfd/0x170
 [<ffffffff80230278>] ? wakeup_preempt_entity+0x48/0x50
 [<ffffffff802372a3>] ? check_preempt_wakeup+0x163/0x190
 [<ffffffff80235e3e>] ? try_to_wake_up+0xee/0x190
 [<ffffffff802673a5>] ? sys_init_module+0xb5/0x1e0
 [<ffffffff8020bbcb>] ? system_call_fastpath+0x16/0x1b
Code: a0 df 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 48 83 ec 28 48 89 =
5c 24 08 48 89 6c 24 10 4c 89 64 24 18 4c 89 6c 24 20 31 db <4c> 8b 27 48 8=
9 fd 41 83 bc 24 c0 06 00 00 2a 74 1b 89 d8 48 8b=20
RIP  [<ffffffffa088f15a>] vp3054_i2c_probe+0x1a/0x160 [cx88_vp3054_i2c]
 RSP <ffff880164d73d18>
CR2: 0000000000000000
---[ end trace 6fa57888c07c1ca8 ]---
cx2388x alsa driver version 0.0.6 loaded
cx88_audio 0000:04:02.1: PCI INT A -> GSI 23 (level, low) -> IRQ 23
cx88[0]/1: CX88x/0: ALSA support for cx2388x boards
cx18:  Start initialization, version 1.0.4
cx18:  End initialization
ivtv: Start initialization, version 1.4.0
ivtv: End initialization
cx2388x blackbird driver version 0.0.6 loaded
cx88/2: registering cx8802 driver, type: blackbird access: shared
cx23885 driver version 0.0.1 loaded
ivtvfb:  no cards found

--nFreZHaLTZJo0R7j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="lspci.txt"

00:00.0 Host bridge: Intel Corporation 82P965/G965 Memory Controller Hub (rev 02)
	Subsystem: ASUSTeK Computer Inc. P5B
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: [e0] Vendor Specific Information <?>

00:01.0 PCI bridge: Intel Corporation 82P965/G965 PCI Express Root Port (rev 02) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
	I/O behind bridge: 0000a000-0000afff
	Memory behind bridge: cdc00000-d3cfffff
	Prefetchable memory behind bridge: 00000000ada00000-00000000cd9fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [88] Subsystem: Intel Corporation Device 277d
	Capabilities: [80] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [90] Message Signalled Interrupts: Mask- 64bit- Count=1/1 Enable-
		Address: 00000000  Data: 0000
	Capabilities: [a0] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #2, Speed 2.5GT/s, Width x16, ASPM L0s, Latency L0 <256ns, L1 <4us
			ClockPM- Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surpise-
			Slot #  0, PowerLimit 0.000000; Interlock- NoCompl+
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Off, PwrInd On, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet+ LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Kernel driver in use: pcieport-driver

00:1a.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #4 (rev 02) (prog-if 00 [UHCI])
	Subsystem: ASUSTeK Computer Inc. P5B
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 16
	Region 4: I/O ports at e000 [size=32]
	Kernel driver in use: uhci_hcd

00:1a.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #5 (rev 02) (prog-if 00 [UHCI])
	Subsystem: ASUSTeK Computer Inc. P5B
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 17
	Region 4: I/O ports at e080 [size=32]
	Kernel driver in use: uhci_hcd

00:1a.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI Controller #2 (rev 02) (prog-if 20 [EHCI])
	Subsystem: ASUSTeK Computer Inc. P5B
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin C routed to IRQ 18
	Region 0: Memory at dffff400 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Debug port: BAR=1 offset=00a0
	Kernel driver in use: ehci_hcd

00:1b.0 Audio device: Intel Corporation 82801H (ICH8 Family) HD Audio Controller (rev 02)
	Subsystem: ASUSTeK Computer Inc. P5B
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 22
	Region 0: Memory at dfff8000 (64-bit, non-prefetchable) [size=16K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [60] Message Signalled Interrupts: Mask- 64bit+ Count=1/1 Enable-
		Address: 0000000000000000  Data: 0000
	Capabilities: [70] Express (v1) Root Complex Integrated Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed unknown, Width x0, ASPM unknown, Latency L0 <64ns, L1 <1us
			ClockPM- Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed unknown, Width x0, TrErr- Train- SlotClk- DLActive- BWMgmt- ABWMgmt-
	Kernel driver in use: HDA Intel
	Kernel modules: snd-hda-intel

00:1c.0 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 1 (rev 02) (prog-if 00 [Normal decode])
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
	Prefetchable memory behind bridge: 00000000cda00000-00000000cdafffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 unlimited
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #1, Speed 2.5GT/s, Width x4, ASPM L0s L1, Latency L0 <1us, L1 <4us
			ClockPM- Suprise- LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surpise+
			Slot #  0, PowerLimit 0.000000; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Count=1/1 Enable-
		Address: 00000000  Data: 0000
	Capabilities: [90] Subsystem: ASUSTeK Computer Inc. Device 81ec
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: pcieport-driver

00:1c.5 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express Port 6 (rev 02) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
	I/O behind bridge: 0000b000-0000bfff
	Memory behind bridge: d3d00000-d3dfffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 unlimited
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #6, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <256ns, L1 <4us
			ClockPM- Suprise- LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surpise+
			Slot #  0, PowerLimit 0.000000; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet+ LinkState+
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Count=1/1 Enable-
		Address: 00000000  Data: 0000
	Capabilities: [90] Subsystem: ASUSTeK Computer Inc. Device 81ec
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: pcieport-driver

00:1d.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #1 (rev 02) (prog-if 00 [UHCI])
	Subsystem: ASUSTeK Computer Inc. P5B
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 23
	Region 4: I/O ports at d800 [size=32]
	Kernel driver in use: uhci_hcd

00:1d.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #2 (rev 02) (prog-if 00 [UHCI])
	Subsystem: ASUSTeK Computer Inc. P5B
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 19
	Region 4: I/O ports at d880 [size=32]
	Kernel driver in use: uhci_hcd

00:1d.2 USB Controller: Intel Corporation 82801H (ICH8 Family) USB UHCI Controller #3 (rev 02) (prog-if 00 [UHCI])
	Subsystem: ASUSTeK Computer Inc. P5B
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin C routed to IRQ 18
	Region 4: I/O ports at dc00 [size=32]
	Kernel driver in use: uhci_hcd

00:1d.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI Controller #1 (rev 02) (prog-if 20 [EHCI])
	Subsystem: ASUSTeK Computer Inc. P5B
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 23
	Region 0: Memory at dffff000 (32-bit, non-prefetchable) [size=1K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [58] Debug port: BAR=1 offset=00a0
	Kernel driver in use: ehci_hcd

00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev f2) (prog-if 01 [Subtractive decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Bus: primary=00, secondary=04, subordinate=04, sec-latency=32
	I/O behind bridge: 0000c000-0000cfff
	Memory behind bridge: d3e00000-dfefffff
	Prefetchable memory behind bridge: 0000000088000000-00000000880fffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [50] Subsystem: ASUSTeK Computer Inc. Device 81ec

00:1f.0 ISA bridge: Intel Corporation 82801HB/HR (ICH8/R) LPC Interface Controller (rev 02)
	Subsystem: ASUSTeK Computer Inc. P5B
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: [e0] Vendor Specific Information <?>

00:1f.2 SATA controller: Intel Corporation 82801HR/HO/HH (ICH8R/DO/DH) 6 port SATA AHCI Controller (rev 02) (prog-if 01 [AHCI 1.0])
	Subsystem: ASUSTeK Computer Inc. Device 81ec
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 19
	Region 0: I/O ports at ec00 [size=8]
	Region 1: I/O ports at e880 [size=4]
	Region 2: I/O ports at e800 [size=8]
	Region 3: I/O ports at e480 [size=4]
	Region 4: I/O ports at e400 [size=32]
	Region 5: Memory at dffff800 (32-bit, non-prefetchable) [size=2K]
	Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Count=1/16 Enable-
		Address: 00000000  Data: 0000
	Capabilities: [70] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [a8] SATA HBA <?>
	Kernel driver in use: ahci

00:1f.3 SMBus: Intel Corporation 82801H (ICH8 Family) SMBus Controller (rev 02)
	Subsystem: ASUSTeK Computer Inc. P5B
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin C routed to IRQ 18
	Region 0: Memory at 88100000 (32-bit, non-prefetchable) [size=256]
	Region 4: I/O ports at 0400 [size=32]
	Kernel driver in use: i801_smbus
	Kernel modules: i2c-i801

01:00.0 VGA compatible controller: nVidia Corporation G94 [GeForce 9600 GT] (rev a1) (prog-if 00 [VGA controller])
	Subsystem: ASUSTeK Computer Inc. Device 827c
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at d2000000 (32-bit, non-prefetchable) [size=16M]
	Region 1: Memory at b0000000 (64-bit, prefetchable) [size=256M]
	Region 3: Memory at d0000000 (64-bit, non-prefetchable) [size=32M]
	Region 5: I/O ports at ac00 [size=128]
	[virtual] Expansion ROM at d3c80000 [disabled] [size=512K]
	Capabilities: [60] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [68] Message Signalled Interrupts: Mask- 64bit+ Count=1/1 Enable-
		Address: 0000000000000000  Data: 0000
	Capabilities: [78] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <512ns, L1 <4us
			ExtTag+ AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x16, ASPM L0s L1, Latency L0 <512ns, L1 <1us
			ClockPM- Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 128 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
	Capabilities: [b4] Vendor Specific Information <?>
	Kernel driver in use: nvidia
	Kernel modules: nvidia

02:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8056 PCI-E Gigabit Ethernet Controller (rev 12)
	Subsystem: ASUSTeK Computer Inc. Device 81f8
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 10
	Region 0: Memory at d3dfc000 (64-bit, non-prefetchable) [size=16K]
	Region 2: I/O ports at b800 [size=256]
	Expansion ROM at d3dc0000 [disabled] [size=128K]
	Capabilities: [48] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=1 PME-
	Capabilities: [50] Vital Product Data <?>
	Capabilities: [5c] Message Signalled Interrupts: Mask- 64bit+ Count=1/1 Enable-
		Address: 0000000000000000  Data: 0000
	Capabilities: [e0] Express (v1) Legacy Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s unlimited, L1 unlimited
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr+ UncorrErr- FatalErr- UnsuppReq+ AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <256ns, L1 unlimited
			ClockPM+ Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 128 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
	Kernel modules: sky2

04:00.0 Multimedia controller: Philips Semiconductors SAA7146 (rev 01)
	Subsystem: Technotrend Systemtechnik GmbH Technotrend-Budget/Hauppauge WinTV-NOVA-CI DVB card
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64 (3750ns min, 9500ns max)
	Interrupt: pin A routed to IRQ 21
	Region 0: Memory at dfeffc00 (32-bit, non-prefetchable) [size=512]
	Kernel driver in use: budget_ci dvb
	Kernel modules: budget-ci

04:02.0 Multimedia video controller: Conexant CX23880/1/2/3 PCI Video and Audio Decoder (rev 05)
	Subsystem: Hauppauge computer works Inc. Device 6902
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64 (5000ns min, 13750ns max), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 23
	Region 0: Memory at db000000 (32-bit, non-prefetchable) [size=16M]
	Capabilities: [44] Vital Product Data <?>
	Capabilities: [4c] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: cx8800
	Kernel modules: cx8800

04:02.1 Multimedia controller: Conexant CX23880/1/2/3 PCI Video and Audio Decoder [Audio Port] (rev 05)
	Subsystem: Hauppauge computer works Inc. Device 6902
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64 (1000ns min, 63750ns max), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 23
	Region 0: Memory at dc000000 (32-bit, non-prefetchable) [size=16M]
	Capabilities: [4c] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: cx88_audio
	Kernel modules: cx88-alsa

04:02.2 Multimedia controller: Conexant CX23880/1/2/3 PCI Video and Audio Decoder [MPEG Port] (rev 05)
	Subsystem: Hauppauge computer works Inc. Device 6902
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64 (1500ns min, 22000ns max), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 23
	Region 0: Memory at dd000000 (32-bit, non-prefetchable) [size=16M]
	Capabilities: [4c] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: cx88-mpeg driver manager
	Kernel modules: cx8802

04:02.4 Multimedia controller: Conexant CX23880/1/2/3 PCI Video and Audio Decoder [IR Port] (rev 05)
	Subsystem: Hauppauge computer works Inc. Device 6902
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64 (1500ns min, 63750ns max), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 7
	Region 0: Memory at de000000 (32-bit, non-prefetchable) [size=16M]
	Capabilities: [4c] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-

04:03.0 FireWire (IEEE 1394): Texas Instruments TSB43AB22/A IEEE-1394a-2000 Controller (PHY/Link) (prog-if 10 [OHCI])
	Subsystem: ASUSTeK Computer Inc. K8N4-E Mainboard
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64 (500ns min, 1000ns max), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 21
	Region 0: Memory at dfeff000 (32-bit, non-prefetchable) [size=2K]
	Region 1: Memory at dfef8000 (32-bit, non-prefetchable) [size=16K]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME+
	Kernel driver in use: ohci1394
	Kernel modules: firewire-ohci, ohci1394

04:04.0 Ethernet controller: Marvell Technology Group Ltd. 88E8001 Gigabit Ethernet Controller (rev 13)
	Subsystem: ASUSTeK Computer Inc. Marvell 88E8001 Gigabit Ethernet Controller (Asus)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64 (5750ns min, 7750ns max), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 19
	Region 0: Memory at dfef4000 (32-bit, non-prefetchable) [size=16K]
	Region 1: I/O ports at c800 [size=256]
	Expansion ROM at 88000000 [disabled] [size=128K]
	Capabilities: [48] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 PME-Enable- DSel=0 DScale=1 PME-
	Capabilities: [50] Vital Product Data <?>
	Kernel driver in use: skge

04:05.0 Multimedia video controller: Conexant CX23880/1/2/3 PCI Video and Audio Decoder (rev 03)
	Subsystem: Conexant Device 0084
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64 (5000ns min, 13750ns max), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 20
	Region 0: Memory at d9000000 (32-bit, non-prefetchable) [size=16M]
	Capabilities: [44] Vital Product Data <?>
	Capabilities: [4c] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: cx8800
	Kernel modules: cx8800

04:05.2 Multimedia controller: Conexant CX23880/1/2/3 PCI Video and Audio Decoder [MPEG Port] (rev 03)
	Subsystem: Conexant Device 0084
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 64 (1500ns min, 22000ns max), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 20
	Region 0: Memory at da000000 (32-bit, non-prefetchable) [size=16M]
	Capabilities: [44] Vital Product Data <?>
	Capabilities: [4c] Power Management version 2
		Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: cx88-mpeg driver manager
	Kernel modules: cx8802


--nFreZHaLTZJo0R7j
Content-Type: text/plain; charset=us-ascii
Content-Description: ksymoops
Content-Disposition: attachment; filename="dvb-oops.txt2"

ksymoops 2.4.11 on x86_64 2.6.28-gentoo.  Options used
     -V (default)
     -k /proc/ksyms (default)
     -l /proc/modules (default)
     -o /lib/modules/2.6.28-gentoo/ (default)
     -m /usr/src/linux/System.map (default)

Warning: You did not tell me where to find symbol information.  I will
assume that the log matches the kernel and modules that are running
right now and I'll use the default options above for symbol resolution.
If the current kernel and/or modules do not match the log, you can get
more accurate output by telling me the kernel version and where to find
map, modules, ksyms etc.  ksymoops -h explains the options.

Error (regular_file): read_ksyms stat /proc/ksyms failed
No modules in ksyms, skipping objects
No ksyms, skipping lsmod
BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
Oops: 0000 [#1] PREEMPT SMP 
CPU 0 
Pid: 10973, comm: modprobe Tainted: P           2.6.28-gentoo #1
RIP: 0010:[<ffffffffa088f15a>]  [<ffffffffa088f15a>] vp3054_i2c_probe+0x1a/0x160 [cx88_vp3054_i2c]
Using defaults from ksymoops -t elf64-x86-64 -a i386:x86-64
RSP: 0018:ffff880164d73d18  EFLAGS: 00010246
RAX: ffffffffa0bc4080 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffff8801653a7000 R08: 0000000000000000 R09: ffff88016e986360
R10: 0000000000000000 R11: 00000000807ca320 R12: ffff88016e986360
R13: 0000000000000000 R14: 00000000021d2160 R15: 00000000021d2178
FS:  00007f8431dc36f0(0000) GS:ffffffff80721200(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 0000000164eb4000 CR4: 00000000000006e0
 0000000000000070 00000000ffffffed ffff8801653a7000 ffff88016e986360
 0000000000000000 ffffffffa0bf0848 0000000000000000 0000000000000001
 ffff88002da6e7b8 ffff880164d73d78 0000000000000000 ffff880164eb9050
Call Trace:
 [<ffffffffa0bf0848>] ? cx8802_dvb_probe+0x78/0x1e10 [cx88_dvb]
 [<ffffffff802f3019>] ? __sysfs_add_one+0x39/0xb0
 [<ffffffffa0bc572f>] ? cx8802_register_driver+0x1cf/0x258 [cx8802]
 [<ffffffff80230090>] ? update_curr+0xd0/0x130
 [<ffffffffa0bf26a0>] ? dvb_init+0x0/0x30 [cx88_dvb]
 [<ffffffff80209042>] ? _stext+0x42/0x1b0
 [<ffffffff802314fb>] ? enqueue_entity+0x1b/0x170
 [<ffffffff803bf589>] ? __next_cpu+0x19/0x30
 [<ffffffff80239d9c>] ? tg_shares_up+0xcc/0x240
 [<ffffffff80230090>] ? update_curr+0xd0/0x130
 [<ffffffff802315dd>] ? enqueue_entity+0xfd/0x170
 [<ffffffff80230278>] ? wakeup_preempt_entity+0x48/0x50
 [<ffffffff802372a3>] ? check_preempt_wakeup+0x163/0x190
 [<ffffffff80235e3e>] ? try_to_wake_up+0xee/0x190
 [<ffffffff802673a5>] ? sys_init_module+0xb5/0x1e0
 [<ffffffff8020bbcb>] ? system_call_fastpath+0x16/0x1b
Code: a0 df 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 48 83 ec 28 48 89 5c 24 08 48 89 6c 24 10 4c 89 64 24 18 4c 89 6c 24 20 31 db <4c> 8b 27 48 89 fd 41 83 bc 24 c0 06 00 00 2a 74 1b 89 d8 48 8b 


>>RIP; ffffffffa088f15a <_end+200a7eea/7ee18d90>   <=====

>>RAX; ffffffffa0bc4080 <_end+203dce10/7ee18d90>
>>RBP; ffff8801653a7000 <phys_startup_64+ffff8801651a7000/ffffffff80000000>
>>R09; ffff88016e986360 <phys_startup_64+ffff88016e786360/ffffffff80000000>
>>R11; 00000000807ca320 <phys_startup_64+805ca320/ffffffff80000000>
>>R12; ffff88016e986360 <phys_startup_64+ffff88016e786360/ffffffff80000000>
>>R14; 00000000021d2160 <phys_startup_64+1fd2160/ffffffff80000000>
>>R15; 00000000021d2178 <phys_startup_64+1fd2178/ffffffff80000000>

Trace; ffffffffa0bf0848 <_end+204095d8/7ee18d90>
Trace; ffffffff802f3019 <__sysfs_add_one+39/b0>
Trace; ffffffffa0bc572f <_end+203de4bf/7ee18d90>
Trace; ffffffff80230090 <update_curr+d0/130>
Trace; ffffffffa0bf26a0 <_end+2040b430/7ee18d90>
Trace; ffffffff80209042 <do_one_initcall+42/1b0>
Trace; ffffffff802314fb <enqueue_entity+1b/170>
Trace; ffffffff803bf589 <__next_cpu+19/30>
Trace; ffffffff80239d9c <tg_shares_up+cc/240>
Trace; ffffffff80230090 <update_curr+d0/130>
Trace; ffffffff802315dd <enqueue_entity+fd/170>
Trace; ffffffff80230278 <wakeup_preempt_entity+48/50>
Trace; ffffffff802372a3 <check_preempt_wakeup+163/190>
Trace; ffffffff80235e3e <try_to_wake_up+ee/190>
Trace; ffffffff802673a5 <sys_init_module+b5/1e0>
Trace; ffffffff8020bbcb <system_call_fastpath+16/1b>

Code;  ffffffffa088f12f <_end+200a7ebf/7ee18d90>
0000000000000000 <_RIP>:
Code;  ffffffffa088f12f <_end+200a7ebf/7ee18d90>
   0:   a0 df 66 66 66 66 66      mov    0x2e666666666666df,%al
Code;  ffffffffa088f136 <_end+200a7ec6/7ee18d90>
   7:   66 2e 
Code;  ffffffffa088f138 <_end+200a7ec8/7ee18d90>
   9:   0f 1f 84 00 00 00 00      nopl   0x0(%rax,%rax,1)
Code;  ffffffffa088f13f <_end+200a7ecf/7ee18d90>
  10:   00 
Code;  ffffffffa088f140 <_end+200a7ed0/7ee18d90>
  11:   48 83 ec 28               sub    $0x28,%rsp
Code;  ffffffffa088f144 <_end+200a7ed4/7ee18d90>
  15:   48 89 5c 24 08            mov    %rbx,0x8(%rsp)
Code;  ffffffffa088f149 <_end+200a7ed9/7ee18d90>
  1a:   48 89 6c 24 10            mov    %rbp,0x10(%rsp)
Code;  ffffffffa088f14e <_end+200a7ede/7ee18d90>
  1f:   4c 89 64 24 18            mov    %r12,0x18(%rsp)
Code;  ffffffffa088f153 <_end+200a7ee3/7ee18d90>
  24:   4c 89 6c 24 20            mov    %r13,0x20(%rsp)
Code;  ffffffffa088f158 <_end+200a7ee8/7ee18d90>
  29:   31 db                     xor    %ebx,%ebx
Code;  ffffffffa088f15a <_end+200a7eea/7ee18d90>   <=====
  2b:   4c 8b 27                  mov    (%rdi),%r12   <=====
Code;  ffffffffa088f15d <_end+200a7eed/7ee18d90>
  2e:   48 89 fd                  mov    %rdi,%rbp
Code;  ffffffffa088f160 <_end+200a7ef0/7ee18d90>
  31:   41 83 bc 24 c0 06 00      cmpl   $0x2a,0x6c0(%r12)
Code;  ffffffffa088f167 <_end+200a7ef7/7ee18d90>
  38:   00 2a 
Code;  ffffffffa088f169 <_end+200a7ef9/7ee18d90>
  3a:   74 1b                     je     57 <_RIP+0x57>
Code;  ffffffffa088f16b <_end+200a7efb/7ee18d90>
  3c:   89 d8                     mov    %ebx,%eax
Code;  ffffffffa088f16d <_end+200a7efd/7ee18d90>
  3e:   48                        rex.W
Code;  ffffffffa088f16e <_end+200a7efe/7ee18d90>
  3f:   8b                        .byte 0x8b

CR2: 0000000000000000

1 warning and 1 error issued.  Results may not be reliable.

--nFreZHaLTZJo0R7j
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--nFreZHaLTZJo0R7j--
