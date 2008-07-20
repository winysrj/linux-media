Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m6KIFM9u020804
	for <video4linux-list@redhat.com>; Sun, 20 Jul 2008 14:15:22 -0400
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.159])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m6KIFAM3012181
	for <video4linux-list@redhat.com>; Sun, 20 Jul 2008 14:15:10 -0400
Received: by fg-out-1718.google.com with SMTP id e21so593729fga.7
	for <video4linux-list@redhat.com>; Sun, 20 Jul 2008 11:15:09 -0700 (PDT)
From: Thomas PEGEOT <thomas.pegeot@gmail.com>
Date: Sun, 20 Jul 2008 20:15:05 +0200
MIME-Version: 1.0
Content-Disposition: inline
To: video4linux-list@redhat.com
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200807202015.05795.thomas.pegeot@gmail.com>
Subject: Issue with Hauppauge hvr-1100 and 2.6.26
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

Hello,

My dvb card (Hauppauge HVR-1100 - cx88) is running fine with kernels prior to 
2.6.25. Unfortunately I lost my working .config file ... so i had to compile 
the 2.6.26 kernel from scratch and my tv card does not work any more.
Is there any thing that i forgot to enable ? 

Thank you in advance. 

Regards

The dmesg command shows the following output : 

divide error: 0000 [1] PREEMPT
CPU 0
Modules linked in: nouveau drm cx88_dvb dvb_pll videobuf_dvb tuner cx8800 
cx8802 cx88_alsa cx88xx k8temp ir_common i2c_algo_bit tveeprom btcx_risc 
i2c_nforce2 sky2 videobuf_dma_sg videobuf_core
Pid: 3881, comm: kdvb-fe-0 Not tainted 2.6.26 #1
RIP: 0010:[<ffffffff80414341>]  [<ffffffff80414341>] 
simple_dvb_calc_regs+0x99/0x223
RSP: 0018:ffff810026235d30  EFLAGS: 00010246
RAX: 000000002de54480 RBX: ffff810026235dc0 RCX: 0000000000000000
RDX: 0000000000000000 RSI: ffffffff80733f20 RDI: ffff81003ed9b810
RBP: ffff810026235da0 R08: ffff810026235d76 R09: 0000000000000001
R10: 00000007518a83aa R11: ffff810026238588 R12: ffff81003ed9b810
R13: ffff81003eccd640 R14: ffff81003ed9b408 R15: ffff81003ed9b810
FS:  00007f8e57672750(0000) GS:ffffffff80755000(0000) knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 00007f8e568f1eb5 CR3: 0000000026094000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process kdvb-fe-0 (pid: 3881, threadinfo ffff810026234000, task 
ffff810026238540)
Stack:  ffffffff807b9930 00000000ffffffff 0000004295938ee2 00000000ffffffff
 ffff810026235d90 ffffffff80223498 ffffffff807330a0 0000000000000000
 8e017fff00003020 ffff81003eccd640 ffff81003ed9b810 0000000000000000
Call Trace:
 [<ffffffff80223498>] ? hrtick_set+0xbe/0x139
 [<ffffffff804146a2>] simple_dvb_set_params+0x3f/0xbe
 [<ffffffff80231f08>] ? lock_timer_base+0x2f/0x6c
 [<ffffffff80231f08>] ? lock_timer_base+0x2f/0x6c
 [<ffffffff8042dbb6>] cx22702_set_tps+0x28/0x1d0
 [<ffffffff804299ca>] dvb_frontend_swzigzag_autotune+0x190/0x1b7
 [<ffffffff8042a1da>] dvb_frontend_swzigzag+0x1bc/0x21e
 [<ffffffff8042a550>] dvb_frontend_thread+0x314/0x3f2
 [<ffffffff8023c34a>] ? autoremove_wake_function+0x0/0x38
 [<ffffffff8042a23c>] ? dvb_frontend_thread+0x0/0x3f2
 [<ffffffff8023be81>] kthread+0x49/0x76
 [<ffffffff8020bc78>] child_rip+0xa/0x12
 [<ffffffff8023be38>] ? kthread+0x0/0x76
 [<ffffffff8020bc6e>] ? child_rip+0x0/0x12


Code: 00 00 48 8b 45 c0 8b 48 1c 48 8b 05 9a 1d 42 00 0f b7 40 0a 89 ca 03 45 
d0 d1 ea 69 c0 24 f4 00 00 03 05 93 1d 42 00 01 d0 31 d2 <f7> f1 8a 55 d6 88 
53 04 41 89 c4 c1 e8 08 88 43 01 8a 45 d7 44
RIP  [<ffffffff80414341>] simple_dvb_calc_regs+0x99/0x223
 RSP <ffff810026235d30>
---[ end trace 49544f812ce3f799 ]---

Here is an extract of my .config : 
#
# Multimedia devices
#

#
# Multimedia core support
#
CONFIG_VIDEO_DEV=y
CONFIG_VIDEO_V4L2_COMMON=y
CONFIG_VIDEO_ALLOW_V4L1=y
CONFIG_VIDEO_V4L1_COMPAT=y
CONFIG_DVB_CORE=y
CONFIG_VIDEO_MEDIA=y

#
# Multimedia drivers
#
CONFIG_MEDIA_ATTACH=y
CONFIG_MEDIA_TUNER=y
# CONFIG_MEDIA_TUNER_CUSTOMIZE is not set
CONFIG_MEDIA_TUNER_SIMPLE=y
CONFIG_MEDIA_TUNER_TDA8290=y
CONFIG_MEDIA_TUNER_TDA9887=y
CONFIG_MEDIA_TUNER_TEA5761=y
CONFIG_MEDIA_TUNER_TEA5767=y
CONFIG_MEDIA_TUNER_MT20XX=y
CONFIG_MEDIA_TUNER_XC2028=y
CONFIG_MEDIA_TUNER_XC5000=y
CONFIG_VIDEO_V4L2=y
CONFIG_VIDEO_V4L1=y
CONFIG_VIDEOBUF_GEN=m
CONFIG_VIDEOBUF_DMA_SG=m
CONFIG_VIDEOBUF_DVB=m
CONFIG_VIDEO_BTCX=m
CONFIG_VIDEO_IR_I2C=m
CONFIG_VIDEO_IR=m
CONFIG_VIDEO_TVEEPROM=m
CONFIG_VIDEO_TUNER=m
CONFIG_VIDEO_CAPTURE_DRIVERS=y
# CONFIG_VIDEO_ADV_DEBUG is not set
CONFIG_VIDEO_HELPER_CHIPS_AUTO=y
CONFIG_VIDEO_WM8775=m
CONFIG_VIDEO_CX2341X=m
# CONFIG_VIDEO_VIVI is not set
# CONFIG_VIDEO_BT848 is not set
# CONFIG_VIDEO_CPIA is not set
# CONFIG_VIDEO_CPIA2 is not set
# CONFIG_VIDEO_SAA5246A is not set
# CONFIG_VIDEO_SAA5249 is not set
# CONFIG_TUNER_3036 is not set
# CONFIG_VIDEO_STRADIS is not set
# CONFIG_VIDEO_ZORAN is not set
# CONFIG_VIDEO_SAA7134 is not set
# CONFIG_VIDEO_MXB is not set
# CONFIG_VIDEO_DPC is not set
# CONFIG_VIDEO_HEXIUM_ORION is not set
# CONFIG_VIDEO_HEXIUM_GEMINI is not set
CONFIG_VIDEO_CX88=m
CONFIG_VIDEO_CX88_ALSA=m
CONFIG_VIDEO_CX88_BLACKBIRD=m
CONFIG_VIDEO_CX88_DVB=m
CONFIG_VIDEO_CX88_VP3054=m
# CONFIG_VIDEO_CX23885 is not set
# CONFIG_VIDEO_AU0828 is not set
# CONFIG_VIDEO_IVTV is not set
# CONFIG_VIDEO_CX18 is not set
# CONFIG_VIDEO_CAFE_CCIC is not set
# CONFIG_V4L_USB_DRIVERS is not set
# CONFIG_SOC_CAMERA is not set
# CONFIG_RADIO_ADAPTERS is not set
CONFIG_DVB_CAPTURE_DRIVERS=y

#
# Supported SAA7146 based PCI Adapters
#
# CONFIG_TTPCI_EEPROM is not set
# CONFIG_DVB_AV7110 is not set
# CONFIG_DVB_BUDGET_CORE is not set

#
# Supported USB Adapters
#
# CONFIG_DVB_USB is not set
# CONFIG_DVB_TTUSB_BUDGET is not set
# CONFIG_DVB_TTUSB_DEC is not set
# CONFIG_DVB_CINERGYT2 is not set

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
# Supported DVB Frontends
#

#
# Customise DVB Frontends
#
# CONFIG_DVB_FE_CUSTOMISE is not set

#
# DVB-S (satellite) frontends
#
# CONFIG_DVB_CX24110 is not set
CONFIG_DVB_CX24123=m
# CONFIG_DVB_MT312 is not set
# CONFIG_DVB_S5H1420 is not set
# CONFIG_DVB_STV0299 is not set
# CONFIG_DVB_TDA8083 is not set
# CONFIG_DVB_TDA10086 is not set
# CONFIG_DVB_VES1X93 is not set
# CONFIG_DVB_TUNER_ITD1000 is not set
# CONFIG_DVB_TDA826X is not set
# CONFIG_DVB_TUA6100 is not set

#
# DVB-T (terrestrial) frontends
#
# CONFIG_DVB_SP8870 is not set
# CONFIG_DVB_SP887X is not set
CONFIG_DVB_CX22700=m
CONFIG_DVB_CX22702=y
# CONFIG_DVB_L64781 is not set
# CONFIG_DVB_TDA1004X is not set
# CONFIG_DVB_NXT6000 is not set
CONFIG_DVB_MT352=m
CONFIG_DVB_ZL10353=m
# CONFIG_DVB_DIB3000MB is not set
# CONFIG_DVB_DIB3000MC is not set
# CONFIG_DVB_DIB7000M is not set
# CONFIG_DVB_DIB7000P is not set
# CONFIG_DVB_TDA10048 is not set

#
# DVB-C (cable) frontends
#
# CONFIG_DVB_VES1820 is not set
# CONFIG_DVB_TDA10021 is not set
# CONFIG_DVB_TDA10023 is not set
# CONFIG_DVB_STV0297 is not set

#
# ATSC (North American/Korean Terrestrial/Cable DTV) frontends
#
CONFIG_DVB_NXT200X=m
# CONFIG_DVB_OR51211 is not set
CONFIG_DVB_OR51132=m
# CONFIG_DVB_BCM3510 is not set
CONFIG_DVB_LGDT330X=m
# CONFIG_DVB_S5H1409 is not set
# CONFIG_DVB_AU8522 is not set
CONFIG_DVB_S5H1411=m

#
# Digital terrestrial only tuners/PLL
#
CONFIG_DVB_PLL=m
# CONFIG_DVB_TUNER_DIB0070 is not set

#
# SEC control devices for DVB-S
#
# CONFIG_DVB_LNBP21 is not set
# CONFIG_DVB_ISL6405 is not set
CONFIG_DVB_ISL6421=m
# CONFIG_DAB is not set

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
