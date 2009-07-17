Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n6H18HJ2030769
	for <video4linux-list@redhat.com>; Thu, 16 Jul 2009 21:08:17 -0400
Received: from web34505.mail.mud.yahoo.com (web34505.mail.mud.yahoo.com
	[66.163.178.171])
	by mx3.redhat.com (8.13.8/8.13.8) with SMTP id n6H17e0u018445
	for <video4linux-list@redhat.com>; Thu, 16 Jul 2009 21:07:40 -0400
Message-ID: <50828.51121.qm@web34505.mail.mud.yahoo.com>
Date: Thu, 16 Jul 2009 18:07:39 -0700 (PDT)
From: Carlos Limarino <climarino@yahoo.com.ar>
To: video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Subject: problems with cx88 and PAL-Nc
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

After many attempts, I finally made some progress with my Compro Videomate =
x50 (cx88 + xc2028). I added the necessary bits to a 'custom' callback func=
tion and I'm able to get the TV signal and change channels. However, I'm ha=
ving a hard time trying to use PAL-Nc . At first, I thought it was a proble=
m related with the tuner, but it also happens with S-Video.=20

It works fine with PAL and NTSC, using TV as input or S-Video as input,. bu=
t when I set PAL-Nc as the norm this happens (Fedora 11, lastest v4l-dvb, S=
-Video input):=20

cx88/0: cx2388x v4l2 driver version 0.0.7 loaded
cx8800 0000:04:01.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
cx88[0]: subsystem: 185b:e000, board: Compro VideoMate X50 [card=3D82,autod=
etected], frontend(s): 0
cx88[0]: TV tuner type 71, Radio tuner type 71
cx88[0]: cx88_reset
tuner 1-0061: chip found @ 0xc2 (cx88[0])
xc2028 1-0061: creating new instance
xc2028 1-0061: type set to XCeive xc2028/xc3028 tuner
xc2028 1-0061: destroying instance
xc2028 1-0061: creating new instance
xc2028 1-0061: type set to XCeive xc2028/xc3028 tuner
cx88[0]: Asking xc2028/3028 to load firmware xc3028-v27.fw
xc2028 1-0061: Error on line 1139: -6
cx88[0]/0: found at 0000:04:01.0, rev: 5, irq: 19, latency: 32, mmio: 0xf40=
00000
IRQ 19/cx88[0]: IRQF_DISABLED is not guaranteed on shared IRQs
cx88[0]/0: registered device video0 [v4l2]
cx88[0]/0: registered device vbi0
cx88[0]/0: registered device radio0
cx88[0]: set_tvnorm: "NTSC-M" fsc8=3D28636360 adc=3D28636363 vdec=3D2863636=
0 db/dr=3D28636360/28636360
cx88[0]: set_pll:=A0=A0=A0 MO_PLL_REG=A0=A0=A0=A0=A0=A0 0x00fffffe [old=3D0=
x00f15f18,freq=3D28636360]
cx88[0]: pll locked [pre=3D2,ofreq=3D28636360]
cx88[0]: set_tvnorm: MO_INPUT_FORMAT=A0 0x00000001 [old=3D0x00000007]
cx88[0]: set_tvnorm: MO_OUTPUT_FORMAT 0x181f0008 [old=3D0x181f0000]
cx88[0]: set_tvnorm: MO_SCONV_REG=A0=A0=A0=A0 0x00020000 [old=3D0x00021f07]
cx88[0]: set_tvnorm: MO_SUB_STEP=A0=A0=A0=A0=A0 0x00400000 [old=3D0x0043e0f=
8]
cx88[0]: set_tvnorm: MO_SUB_STEP_DR=A0=A0 0x00400000 [old=3D0x00538e38]
cx88[0]: set_tvnorm: MO_AGC_BURST=A0=A0=A0=A0 0x00007270 [old=3D0x00006d63,=
bdelay=3D114,agcdelay=3D112]
cx88[0]: set_tvnorm: MO_HTOTAL=A0=A0=A0=A0=A0=A0=A0 0x0000038e [old=3D0x000=
0135a,htotal=3D910]
cx88[0]: set_scale: 320x240 [TB,NTSC-M]
cx88[0]: set_scale: hdelay=A0 0x0038 (width 754)
cx88[0]: set_scale: hscale=A0 0x15b3
cx88[0]: set_scale: hactive 0x0140
cx88[0]: set_scale: vdelay=A0 0x0018
cx88[0]: set_scale: vscale=A0 0x1e00
cx88[0]: set_scale: vactive 0x01e0
cx88[0]: set_scale: filter=A0 0x80009
cx8800 0000:04:01.0: firmware: requesting xc3028-v27.fw
xc2028 1-0061: Loading 80 firmware images from xc3028-v27.fw, type: xc2028 =
firmware, ver 2.7
cx88[0]: Calling XC2028/3028 callback
xc2028 1-0061: Loading firmware for type=3DBASE (1), id 0000000000000000.
cx88[0]: Calling XC2028/3028 callback
xc2028 1-0061: Loading firmware for type=3D(0), id 000000000000b700.
SCODE (20000000), id 000000000000b700:
xc2028 1-0061: Loading SCODE for type=3DMONO SCODE HAS_IF_4320 (60008000), =
id 0000000000008000.
cx88[0]: Calling XC2028/3028 callback
cx88[0]: Calling XC2028/3028 callback
xc2028 1-0061: Loading firmware for type=3DBASE FM (401), id 00000000000000=
00.
cx88[0]: Calling XC2028/3028 callback
wlan0: no IPv6 routers present
xc2028 1-0061: Loading firmware for type=3DFM (400), id 0000000000000000.
cx88[0]: Calling XC2028/3028 callback
cx88[0]: set_tvnorm: "PAL-Nc" fsc8=3D28656448 adc=3D28636363 vdec=3D2865644=
8 db/dr=3D28656448/28656448
cx88[0]: set_pll:=A0=A0=A0 MO_PLL_REG=A0=A0=A0=A0=A0=A0 0x01002df7 [old=3D0=
x00fffffe,freq=3D28656448]
cx88[0]: pll locked [pre=3D2,ofreq=3D28656448]
cx88[0]: set_tvnorm: MO_INPUT_FORMAT=A0 0x00000007 [old=3D0x00000001]
cx88[0]: set_tvnorm: MO_OUTPUT_FORMAT 0x1c1f0008 [old=3D0x181f0008]
cx88[0]: set_tvnorm: MO_SCONV_REG=A0=A0=A0=A0 0x0001ffa4 [old=3D0x00020000]
cx88[0]: set_tvnorm: MO_SUB_STEP=A0=A0=A0=A0=A0 0x00400000 [old=3D0x0040000=
0]
cx88[0]: set_tvnorm: MO_SUB_STEP_DR=A0=A0 0x00400000 [old=3D0x00400000]
cx88[0]: set_tvnorm: MO_AGC_BURST=A0=A0=A0=A0 0x00007270 [old=3D0x00007270,=
bdelay=3D114,agcdelay=3D112]
cx88[0]: set_tvnorm: MO_HTOTAL=A0=A0=A0=A0=A0=A0=A0 0x00000395 [old=3D0x000=
0038e,htotal=3D917]
cx88[0]: set_scale: 320x240 [TB,PAL-Nc]
cx88[0]: set_scale: hdelay=A0 0x0040 (width 922)
cx88[0]: set_scale: hscale=A0 0x1e19
cx88[0]: set_scale: hactive 0x0140
cx88[0]: set_scale: vdelay=A0 0x0024
cx88[0]: set_scale: vscale=A0 0x1d34
cx88[0]: set_scale: vactive 0x0240
cx88[0]: set_scale: filter=A0 0x80009
cx88[0]/0: tvaudio support needs work for this tv norm [PAL-Nc], sorry
cx88[0]: Calling XC2028/3028 callback
xc2028 1-0061: Loading firmware for type=3DBASE (1), id 0000000000000000.
cx88[0]: Calling XC2028/3028 callback
xc2028 1-0061: Loading firmware for type=3D(0), id 000000000000b700.
SCODE (20000000), id 000000000000b700:
xc2028 1-0061: Loading SCODE for type=3DMONO SCODE HAS_IF_4320 (60008000), =
id 0000000000008000.
cx88[0]: Calling XC2028/3028 callback
cx88[0]: set_scale: 720x576 [TB,PAL-Nc]
cx88[0]: set_scale: hdelay=A0 0x0090 (width 922)
cx88[0]: set_scale: hscale=A0 0x047d
cx88[0]: set_scale: hactive 0x02d0
cx88[0]: set_scale: vdelay=A0 0x0024
cx88[0]: set_scale: vscale=A0 0x0000
cx88[0]: set_scale: vactive 0x0240
cx88[0]: set_scale: filter=A0 0x80008
cx88[0]: set_tvnorm: "PAL-Nc" fsc8=3D28656448 adc=3D28636363 vdec=3D2865644=
8 db/dr=3D28656448/28656448
cx88[0]: set_pll:=A0=A0=A0 MO_PLL_REG=A0=A0=A0=A0=A0=A0 0x01002df7 [old=3D0=
x01002df7,freq=3D28656448]
cx88[0]: pll locked [pre=3D2,ofreq=3D28656448]
cx88[0]: set_tvnorm: MO_INPUT_FORMAT=A0 0x00000007 [old=3D0x00000007]
cx88[0]: set_tvnorm: MO_OUTPUT_FORMAT 0x1c1f0008 [old=3D0x1c1f0008]
cx88[0]: set_tvnorm: MO_SCONV_REG=A0=A0=A0=A0 0x0001ffa4 [old=3D0x0001ffa4]
cx88[0]: set_tvnorm: MO_SUB_STEP=A0=A0=A0=A0=A0 0x00400000 [old=3D0x0040000=
0]
cx88[0]: set_tvnorm: MO_SUB_STEP_DR=A0=A0 0x00400000 [old=3D0x00400000]
cx88[0]: set_tvnorm: MO_AGC_BURST=A0=A0=A0=A0 0x00007270 [old=3D0x00007270,=
bdelay=3D114,agcdelay=3D112]
cx88[0]: set_tvnorm: MO_HTOTAL=A0=A0=A0=A0=A0=A0=A0 0x00000395 [old=3D0x000=
00395,htotal=3D917]
cx88[0]: set_scale: 320x240 [TB,PAL-Nc]
cx88[0]: set_scale: hdelay=A0 0x0040 (width 922)
cx88[0]: set_scale: hscale=A0 0x1e19
cx88[0]: set_scale: hactive 0x0140
cx88[0]: set_scale: vdelay=A0 0x0024
cx88[0]: set_scale: vscale=A0 0x1d34
cx88[0]: set_scale: vactive 0x0240
cx88[0]: set_scale: filter=A0 0x82029
cx88[0]: Calling XC2028/3028 callback
cx88[0]: set_scale: 720x576 [TB,PAL-Nc]
cx88[0]: set_scale: hdelay=A0 0x0090 (width 922)
cx88[0]: set_scale: hscale=A0 0x047d
cx88[0]: set_scale: hactive 0x02d0
cx88[0]: set_scale: vdelay=A0 0x0024
cx88[0]: set_scale: vscale=A0 0x0000
cx88[0]: set_scale: vactive 0x0240
cx88[0]: set_scale: filter=A0 0x82028
cx88[0]: video y / packed - dma channel status dump
cx88[0]:=A0=A0 cmds: initial risc: 0xcd9d6000
cx88[0]:=A0=A0 cmds: cdt base=A0=A0=A0 : 0x00180440
cx88[0]:=A0=A0 cmds: cdt size=A0=A0=A0 : 0x0000000c
cx88[0]:=A0=A0 cmds: iq base=A0=A0=A0=A0 : 0x00180400
cx88[0]:=A0=A0 cmds: iq size=A0=A0=A0=A0 : 0x00000010
cx88[0]:=A0=A0 cmds: risc pc=A0=A0=A0=A0 : 0xcd9d6034
cx88[0]:=A0=A0 cmds: iq wr ptr=A0=A0 : 0x0000010d
cx88[0]:=A0=A0 cmds: iq rd ptr=A0=A0 : 0x00000101
cx88[0]:=A0=A0 cmds: cdt current : 0x00000458
cx88[0]:=A0=A0 cmds: pci target=A0 : 0x00000000
cx88[0]:=A0=A0 cmds: line / byte : 0x00000000
cx88[0]:=A0=A0 risc0: 0x80008000 [ sync resync count=3D0 ]
cx88[0]:=A0=A0 risc1: 0x1c0005a0 [ write sol eol count=3D1440 ]
cx88[0]:=A0=A0 risc2: 0xcd831000 [ arg #1 ]
cx88[0]:=A0=A0 risc3: 0x180004c0 [ write sol count=3D1216 ]
cx88[0]:=A0=A0 iq 0: 0x80008000 [ sync resync count=3D0 ]
cx88[0]:=A0=A0 iq 1: 0x1c0005a0 [ write sol eol count=3D1440 ]
cx88[0]:=A0=A0 iq 2: 0xcd831000 [ arg #1 ]
cx88[0]:=A0=A0 iq 3: 0x180004c0 [ write sol count=3D1216 ]
cx88[0]:=A0=A0 iq 4: 0xcd831b40 [ arg #1 ]
cx88[0]:=A0=A0 iq 5: 0x140000e0 [ write eol count=3D224 ]
cx88[0]:=A0=A0 iq 6: 0xcd832000 [ arg #1 ]
cx88[0]:=A0=A0 iq 7: 0x1c0005a0 [ write sol eol count=3D1440 ]
cx88[0]:=A0=A0 iq 8: 0xcd832680 [ arg #1 ]
cx88[0]:=A0=A0 iq 9: 0x1c0005a0 [ write sol eol count=3D1440 ]
cx88[0]:=A0=A0 iq a: 0xcd8331c0 [ arg #1 ]
cx88[0]:=A0=A0 iq b: 0x18000300 [ write sol count=3D768 ]
cx88[0]:=A0=A0 iq c: 0xcd833d00 [ arg #1 ]
cx88[0]:=A0=A0 iq d: 0x0031c040 [ INVALID 21 20 cnt0 resync 14 count=3D64 ]
cx88[0]:=A0=A0 iq e: 0x00000000 [ INVALID count=3D0 ]
cx88[0]:=A0=A0 iq f: 0x00000011 [ INVALID count=3D17 ]
cx88[0]: fifo: 0x00180c00 -> 0x183400
cx88[0]: ctrl: 0x00180400 -> 0x180460
cx88[0]:=A0=A0 ptr1_reg: 0x00181ce0
cx88[0]:=A0=A0 ptr2_reg: 0x00180478
cx88[0]:=A0=A0 cnt1_reg: 0x00000000
cx88[0]:=A0=A0 cnt2_reg: 0x00000000
cx88[0]/0: [ffff880121dfcc00/0] timeout - dma=3D0xcd9d6000
cx88[0]/0: [ffff880121dfde00/1] timeout - dma=3D0xcd91a000
cx88[0]/0: [ffff88011bdc8000/2] timeout - dma=3D0xcdb90000
cx88[0]/0: [ffff88011bdc9200/3] timeout - dma=3D0xcdb92000
=0A=0A__________________________________________________=0ACorreo Yahoo!=0A=
Espacio para todos tus mensajes, antivirus y antispam =A1gratis! =0A=A1Abr=
=ED tu cuenta ya! - http://correo.yahoo.com.ar
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
