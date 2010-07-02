Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:37516 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752614Ab0GBGT5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Jul 2010 02:19:57 -0400
Received: by iwn7 with SMTP id 7so2891053iwn.19
        for <linux-media@vger.kernel.org>; Thu, 01 Jul 2010 23:19:56 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 2 Jul 2010 08:19:56 +0200
Message-ID: <AANLkTimOb5ojsAxYlr0VqIu4oTXgLVDA9CDbLzDcYUrK@mail.gmail.com>
Subject: DVB-C Twinhan DCT-CI (VP-2031) ... card can't get a lock
From: =?UTF-8?Q?Igor_=C5=A0erko?= <igor.serko@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As the subject says I am using a DVB-C PCI card from Twinhan. Model is VP-2031.
The kernel is 2.6.32 on Debian squeeze (v6.0).

So first of all this card is over 5 years old and has had various emails sent
to linux-dvb mailing list. However in my situation I can't seem to get
it working.
The card worked on a Vista 64-bit machine, so it isn't broken. The card also has
a valid RF input as I tried it with a DVB-C Set-Top-Box.

At first I was receiving checksum errors, I fixed this by following
Manu's instructions
from http://www.mail-archive.com/linux-dvb@linuxtv.org/msg18716.html

As soon as I changed it, I wasn't getting any checksum errors, however
I couldn't
tune to a frequency. When tuning to frequency 466MHz with 6875 kS/s the dst
driver sends the following byte sequence "09 00 07 1c 50 00 1a db 00 8f".
The response from the card is "09 00 00 00 00 00 1a db 00 02".
Now I have no idea what a proper response should look like, but it
seems that the card
returned back everything exactly the same except the frequency ... "07
1c 50" = 466000kHz.
The symbol rate is ok "1a db" = 6875

My problem is almost exactly the same as
http://www.spinics.net/lists/linux-dvb/msg02032.html,
but the fix that was posted is wrong.
http://www.spinics.net/lists/linux-dvb/msg02101.html
The fix changed the where decode_lock is being read from. It read it from the
1st byte of the symbol rate.

I hope anyone with a bit more knowledge on this can help with this.

Regards
Igor


Below you can see the module options, the dmesg output when the card was
initialized and a test with scan and czap.

***** Loading the necessary module *****
# modprobe -v dvb_bt8xx

insmod /lib/modules/2.6.32-5-686/kernel/drivers/media/video/tveeprom.ko
insmod /lib/modules/2.6.32-5-686/kernel/drivers/media/video/btcx-risc.ko
insmod /lib/modules/2.6.32-5-686/kernel/drivers/media/video/videodev.ko
insmod /lib/modules/2.6.32-5-686/kernel/drivers/media/video/v4l2-common.ko
insmod /lib/modules/2.6.32-5-686/kernel/drivers/media/video/bt8xx/bttv.ko
i2c_hw=10 i2c_debug=10 bttv_verbose=10 bttv_debug=10
insmod /lib/modules/2.6.32-5-686/kernel/drivers/media/dvb/bt8xx/bt878.ko
debug=10 verbose=10
insmod /lib/modules/2.6.32-5-686/kernel/drivers/media/dvb/dvb-core/dvb-core.ko
debug=10 dvbdev_debug=10

***** dmesg output *****
[15760.720575] bt878_mem: 0xfcfb0000.
[15760.720603] bt878 0000:01:00.1: PCI INT A disabled
[15760.723779] bttv0: unloading
[15760.747565] Linux video capture interface: v2.00
[15760.761286] bttv: driver version 0.9.18 loaded
[15760.761290] bttv: using 8 buffers with 2080k (520 pages) each for capture
[15760.761345] bttv: Bt8xx card found (0).
[15760.761360] bttv0: Bt878 (rev 17) at 0000:01:00.0, irq: 17,
latency: 64, mmio: 0xfdefe000
[15760.761496] bttv0: detected: Twinhan VisionPlus DVB [card=113], PCI
subsystem ID is 1822:0001
[15760.761499] bttv0: using: Twinhan DST + clones [card=113,autodetected]
[15760.761502] IRQ 17/bttv0: IRQF_DISABLED is not guaranteed on shared IRQs
[15760.761721] bttv0: risc main @ 350b4000
[15760.761728] bttv0: gpio: en=00000000, out=00000000 in=00f100fd [init]
[15760.761861] bttv0: tuner absent
[15760.761881] bttv0: add subdevice "dvb0"
[15760.762162] bt-i2c:bt-i2c:bt-i2c:bt-i2c:bt-i2c: ERR: -5
[15760.763985] bt878: AUDIO driver version 0.0.0 loaded
[15760.764627] bt878: Bt878 AUDIO function found (0).
[15760.764642] bt878 0000:01:00.1: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[15760.764646] bt878_probe: card id=[0x11822],[ Twinhan VisionPlus DVB
] has DVB functions.
[15760.764654] bt878(0): Bt878 (rev 17) at 01:00.1, irq: 17, latency:
64, memory: 0xfdeff000
[15760.764797] IRQ 17/bt878: IRQF_DISABLED is not guaranteed on shared IRQs
[15760.773205] dvb_bt8xx: identified card0 as bttv0
[15760.773209] DVB: registering new adapter (bttv0)
[15760.773683] DVB: register adapter0/demux0 @ minor: 0 (0x00)
[15760.773715] DVB: register adapter0/dvr0 @ minor: 1 (0x01)
[15760.773746] DVB: register adapter0/net0 @ minor: 2 (0x02)
[15760.880019] dst(0) dst_comm_init: Initializing DST.
[15760.880027] dst(0) dst_gpio_outb: mask=[ffffffff], enbb=[0001],
outhigh=[0000]
[15760.882020] dst(0) rdc_reset_state: Resetting state machine
[15760.882025] dst(0) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0000]
[15760.896013] dst(0) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0002]
[15761.012007] writing [ 00 06 00 00 00 00 00 fa ]
[15761.012019] bt-i2c: <W aa 00 06 00 00 00 00 00 fa >
[15761.013196] dst(0) dst_gpio_outb: mask=[ffffffff], enbb=[0000],
outhigh=[0000]
[15761.014194] bt-i2c: <R ab =ff >
[15761.014428] dst(0) read_dst: reply is 0xff
[15761.028021] dst(0) dst_wait_dst_ready: dst wait ready after 1
[15761.028027] bt-i2c: <R ab =00 =44 =43 =54 =2d =43 =49 =6c >
[15761.029206] dst(0) read_dst: reply is 0x0
[15761.029210]  0x44 0x43 0x54 0x2d 0x43 0x49 0x6c
[15761.029219] dst(0) dst_gpio_outb: mask=[ffffffff], enbb=[0000],
outhigh=[0000]
[15761.030218] dst(0) dst_get_device_id: Recognise [DCT-CI]
[15761.030223] dst(0) dst_type_print: DST type: cable
[15761.030226] DST type flags : 0x1 newtuner 0x1000 VLF 0x8 firmware
version = 1 0x10 firmware version = 2
[15761.030235] dst(0) dst_comm_init: Initializing DST.
[15761.030239] dst(0) dst_gpio_outb: mask=[ffffffff], enbb=[0001],
outhigh=[0000]
[15761.032230] dst(0) rdc_reset_state: Resetting state machine
[15761.032234] dst(0) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0000]
[15761.048015] dst(0) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0002]
[15761.152017] writing [ 00 0a 00 00 00 00 00 f6 ]
[15761.152028] bt-i2c: <W aa 00 0a 00 00 00 00 00 f6 >
[15761.153202] dst(0) dst_gpio_outb: mask=[ffffffff], enbb=[0000],
outhigh=[0000]
[15761.158168] bt-i2c: <R ab =ff >
[15761.158401] dst(0) read_dst: reply is 0xff
[15761.161388] dst(0) dst_wait_dst_ready: dst wait ready after 0
[15761.161391] bt-i2c: <R ab =00 =08 =ca =10 =16 =15 =5a =99 >
[15761.162570] dst(0) read_dst: reply is 0x0
[15761.162573]  0x8 0xca 0x10 0x16 0x15 0x5a 0x99
[15761.162582] dst(0) dst_get_mac: MAC Address=[00:08:ca:10:16:15]
[15761.162586] dst(0) dst_get_tuner_info: DST TYpe = MULTI FE
[15761.162590] dst(0) dst_comm_init: Initializing DST.
[15761.162594] dst(0) dst_gpio_outb: mask=[ffffffff], enbb=[0001],
outhigh=[0000]
[15761.164585] dst(0) rdc_reset_state: Resetting state machine
[15761.164589] dst(0) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0000]
[15761.180009] dst(0) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0002]
[15761.284007] writing [ 00 13 00 00 00 00 00 ed ]
[15761.284018] bt-i2c: <W aa 00 13 00 00 00 00 00 ed >
[15761.285193] dst(0) dst_gpio_outb: mask=[ffffffff], enbb=[0000],
outhigh=[0000]
[15761.290159] bt-i2c: <R ab =ff >
[15761.290397] dst(0) read_dst: reply is 0xff
[15761.293384] dst(0) dst_wait_dst_ready: dst wait ready after 0
[15761.293388] bt-i2c: <R ab =bc =01 =00 =00 =00 =00 =00 =43 >
[15761.294566] dst(0) read_dst: reply is 0xbc
[15761.294569]  0x1 0x0 0x0 0x0 0x0 0x0 0x43
[15761.294578] dst(0) dst_get_tuner_info: Board Info: 0xbc 0x01. Type
Flags= 0x1219
[15761.294582] dst(0) dst_get_tuner_info: DST type has TS=188
[15761.294586] dst(0) dst_get_tuner_info: DST has Daughterboard
[15761.294590] dst(0) dst_get_tuner_info: Board Info: 0xbc 0x01. Type
Flags= 0x1219
[15761.299420] dst_ca_attach: registering DST-CA device
[15761.299516] DVB: register adapter0/ca0 @ minor: 3 (0x03)
[15761.299522] DVB: registering adapter 0 frontend 1365504 (DST DVB-C)...
[15761.299573] DVB: register adapter0/frontend0 @ minor: 4 (0x04)

***** Running scan using one single frequency *****
# scan -vvv /usr/share/dvb/dvb-c/si-Telemach
scanning /usr/share/dvb/dvb-c/si-Telemach
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
initial transponder 466000000 6875000 0 6
>>> tune to: 466000000:INVERSION_AUTO:6875000:FEC_NONE:QAM_AUTO
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
WARNING: >>> tuning failed!!!
>>> tune to: 466000000:INVERSION_AUTO:6875000:FEC_NONE:QAM_AUTO (tuning failed)
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
>>> tuning status == 0x00
WARNING: >>> tuning failed!!!
ERROR: initial tuning failed
dumping lists (0 services)
Done.

***** dmesg output *****
[72822.041591] dst(0) dst_set_freq: set Frequency 466000000
[72822.041597] dst(0) dst_set_frontend: Set Frequency=[466000000]
[72822.041602] dst(0) dst_set_symbolrate: set symrate 6875000
[72822.041605] dst(0) dst_set_symbolrate: DCT-CI
[72822.041609] dst(0) dst_write_tuna: type_flags 0x1219
[72822.041613] dst(0) dst_comm_init: Initializing DST.
[72822.041618] dst(0) dst_gpio_outb: mask=[ffffffff], enbb=[0001],
outhigh=[0000]
[72822.043610] dst(0) rdc_reset_state: Resetting state machine
[72822.043614] dst(0) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0000]
[72822.060022] dst(0) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0002]
[72822.164014] writing [ 09 00 07 1c 50 00 1a db 00 8f ]
[72822.164027] bt-i2c: <W aa 09 00 07 1c 50 00 1a db 00 8f >
[72822.165472] dst(0) dst_gpio_outb: mask=[ffffffff], enbb=[0000],
outhigh=[0000]
[72822.167462] bt-i2c: <R ab =ff >
[72822.167693] dst(0) read_dst: reply is 0xff
[72823.544016] dst(0) dst_wait_dst_ready: dst wait ready after 86
[72823.544023] bt-i2c: <R ab =09 =00 =00 =00 =00 =00 =1a =db =00 =02 >
[72823.545475] dst(0) read_dst: reply is 0x9
[72823.545478]  0x0 0x0 0x0 0x0 0x0 0x1a 0xdb 0x0 0x2
[72823.592025] dst(0) dst_set_freq: set Frequency 466000000
[72823.592030] dst(0) dst_set_frontend: Set Frequency=[466000000]
[72823.592034] dst(0) dst_set_symbolrate: set symrate 6875000
[72823.592038] dst(0) dst_set_symbolrate: DCT-CI
[72823.592042] dst(0) dst_write_tuna: type_flags 0x1219
[72823.592046] dst(0) dst_comm_init: Initializing DST.
[72823.592050] dst(0) dst_gpio_outb: mask=[ffffffff], enbb=[0001],
outhigh=[0000]
[72823.594042] dst(0) rdc_reset_state: Resetting state machine
[72823.594046] dst(0) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0000]
[72823.608037] dst(0) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0002]
[72823.712017] writing [ 09 00 07 1c 50 00 1a db 00 8f ]
[72823.712031] bt-i2c: <W aa 09 00 07 1c 50 00 1a db 00 8f >
[72823.713476] dst(0) dst_gpio_outb: mask=[ffffffff], enbb=[0000],
outhigh=[0000]
[72823.715466] bt-i2c: <R ab =ff >
[72823.715700] dst(0) read_dst: reply is 0xff
[72825.088015] dst(0) dst_wait_dst_ready: dst wait ready after 86
[72825.088021] bt-i2c: <R ab =09 =00 =00 =00 =00 =00 =1a =db =00 =02 >
[72825.089471] dst(0) read_dst: reply is 0x9
[72825.089474]  0x0 0x0 0x0 0x0 0x0 0x1a 0xdb 0x0 0x2
[72825.136020] dst(0) dst_set_freq: set Frequency 466000000
[72825.136025] dst(0) dst_set_frontend: Set Frequency=[466000000]
[72825.136030] dst(0) dst_set_symbolrate: set symrate 6875000
[72825.136033] dst(0) dst_set_symbolrate: DCT-CI
[72825.136037] dst(0) dst_write_tuna: type_flags 0x1219
[72825.136041] dst(0) dst_comm_init: Initializing DST.
[72825.136045] dst(0) dst_gpio_outb: mask=[ffffffff], enbb=[0001],
outhigh=[0000]
[72825.138037] dst(0) rdc_reset_state: Resetting state machine
[72825.138041] dst(0) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0000]
[72825.152035] dst(0) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0002]
[72825.256020] writing [ 09 00 07 1c 50 00 1a db 00 8f ]
[72825.256034] bt-i2c: <W aa 09 00 07 1c 50 00 1a db 00 8f >
[72825.257480] dst(0) dst_gpio_outb: mask=[ffffffff], enbb=[0000],
outhigh=[0000]
[72825.259470] bt-i2c: <R ab =ff >
[72825.259704] dst(0) read_dst: reply is 0xff
[72826.632015] dst(0) dst_wait_dst_ready: dst wait ready after 86
[72826.632022] bt-i2c: <R ab =09 =00 =00 =00 =00 =00 =1a =db =00 =02 >
[72826.633499] dst(0) read_dst: reply is 0x9
[72826.633503]  0x0 0x0 0x0 0x0 0x0 0x1a 0xdb 0x0 0x2
[72826.680025] dst(0) dst_set_freq: set Frequency 466000000
[72826.680031] dst(0) dst_set_frontend: Set Frequency=[466000000]
[72826.680036] dst(0) dst_set_symbolrate: set symrate 6875000
[72826.680039] dst(0) dst_set_symbolrate: DCT-CI
[72826.680044] dst(0) dst_write_tuna: type_flags 0x1219
[72826.680048] dst(0) dst_comm_init: Initializing DST.
[72826.680052] dst(0) dst_gpio_outb: mask=[ffffffff], enbb=[0001],
outhigh=[0000]
[72826.682044] dst(0) rdc_reset_state: Resetting state machine
[72826.682049] dst(0) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0000]
[72826.696023] dst(0) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0002]
[72826.800018] writing [ 09 00 07 1c 50 00 1a db 00 8f ]
[72826.800031] bt-i2c: <W aa 09 00 07 1c 50 00 1a db 00 8f >
[72826.801475] dst(0) dst_gpio_outb: mask=[ffffffff], enbb=[0000],
outhigh=[0000]
[72826.803466] bt-i2c: <R ab =ff >
[72826.803699] dst(0) read_dst: reply is 0xff
[72828.176016] dst(0) dst_wait_dst_ready: dst wait ready after 86
[72828.176024] bt-i2c: <R ab =09 =00 =00 =00 =00 =00 =1a =db =00 =02 >
[72828.177475] dst(0) read_dst: reply is 0x9
[72828.177478]  0x0 0x0 0x0 0x0 0x0 0x1a 0xdb 0x0 0x2
[72828.224023] dst(0) dst_set_freq: set Frequency 466000000
[72828.224029] dst(0) dst_set_frontend: Set Frequency=[466000000]
[72828.224034] dst(0) dst_set_symbolrate: set symrate 6875000
[72828.224037] dst(0) dst_set_symbolrate: DCT-CI
[72828.224041] dst(0) dst_write_tuna: type_flags 0x1219
[72828.224045] dst(0) dst_comm_init: Initializing DST.
[72828.224050] dst(0) dst_gpio_outb: mask=[ffffffff], enbb=[0001],
outhigh=[0000]
[72828.226041] dst(0) rdc_reset_state: Resetting state machine
[72828.226046] dst(0) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0000]
[72828.240036] dst(0) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0002]
[72828.344033] writing [ 09 00 07 1c 50 00 1a db 00 8f ]
[72828.344047] bt-i2c: <W aa 09 00 07 1c 50 00 1a db 00 8f >
[72828.345493] dst(0) dst_gpio_outb: mask=[ffffffff], enbb=[0000],
outhigh=[0000]
[72828.347483] bt-i2c: <R ab =ff >
[72828.347717] dst(0) read_dst: reply is 0xff
[72829.720017] dst(0) dst_wait_dst_ready: dst wait ready after 86
[72829.720024] bt-i2c: <R ab =09 =00 =00 =00 =00 =00 =1a =db =00 =02 >
[72829.721475] dst(0) read_dst: reply is 0x9
[72829.721478]  0x0 0x0 0x0 0x0 0x0 0x1a 0xdb 0x0 0x2
[72829.768023] dst(0) dst_set_freq: set Frequency 466000000
[72829.768028] dst(0) dst_set_frontend: Set Frequency=[466000000]
[72829.768032] dst(0) dst_set_symbolrate: set symrate 6875000
[72829.768036] dst(0) dst_set_symbolrate: DCT-CI
[72829.768040] dst(0) dst_write_tuna: type_flags 0x1219
[72829.768044] dst(0) dst_comm_init: Initializing DST.
[72829.768048] dst(0) dst_gpio_outb: mask=[ffffffff], enbb=[0001],
outhigh=[0000]
[72829.770040] dst(0) rdc_reset_state: Resetting state machine
[72829.770045] dst(0) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0000]
[72829.784027] dst(0) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0002]
[72829.888016] writing [ 09 00 07 1c 50 00 1a db 00 8f ]
[72829.888031] bt-i2c: <W aa 09 00 07 1c 50 00 1a db 00 8f >
[72829.889476] dst(0) dst_gpio_outb: mask=[ffffffff], enbb=[0000],
outhigh=[0000]
[72829.891466] bt-i2c: <R ab =ff >
[72829.891700] dst(0) read_dst: reply is 0xff
[72831.264015] dst(0) dst_wait_dst_ready: dst wait ready after 86
[72831.264021] bt-i2c: <R ab =09 =00 =00 =00 =00 =00 =1a =db =00 =02 >
[72831.265473] dst(0) read_dst: reply is 0x9
[72831.265476]  0x0 0x0 0x0 0x0 0x0 0x1a 0xdb 0x0 0x2
[72831.312023] dst(0) dst_set_freq: set Frequency 466000000
[72831.312029] dst(0) dst_set_frontend: Set Frequency=[466000000]
[72831.312033] dst(0) dst_set_symbolrate: set symrate 6875000
[72831.312037] dst(0) dst_set_symbolrate: DCT-CI
[72831.312041] dst(0) dst_write_tuna: type_flags 0x1219
[72831.312045] dst(0) dst_comm_init: Initializing DST.
[72831.312050] dst(0) dst_gpio_outb: mask=[ffffffff], enbb=[0001],
outhigh=[0000]
[72831.314042] dst(0) rdc_reset_state: Resetting state machine
[72831.314046] dst(0) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0000]
[72831.328025] dst(0) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0002]
[72831.432020] writing [ 09 00 07 1c 50 00 1a db 00 8f ]
[72831.432034] bt-i2c: <W aa 09 00 07 1c 50 00 1a db 00 8f >
[72831.433477] dst(0) dst_gpio_outb: mask=[ffffffff], enbb=[0000],
outhigh=[0000]
[72831.435467] bt-i2c: <R ab =ff >
[72831.435699] dst(0) read_dst: reply is 0xff
[72832.808016] dst(0) dst_wait_dst_ready: dst wait ready after 86
[72832.808023] bt-i2c: <R ab =09 =00 =00 =00 =00 =00 =1a =db =00 =02 >
[72832.809491] dst(0) read_dst: reply is 0x9
[72832.809495]  0x0 0x0 0x0 0x0 0x0 0x1a 0xdb 0x0 0x2
[72832.856020] dst(0) dst_set_freq: set Frequency 466000000
[72832.856026] dst(0) dst_set_frontend: Set Frequency=[466000000]
[72832.856030] dst(0) dst_set_symbolrate: set symrate 6875000
[72832.856034] dst(0) dst_set_symbolrate: DCT-CI
[72832.856038] dst(0) dst_write_tuna: type_flags 0x1219
[72832.856041] dst(0) dst_comm_init: Initializing DST.
[72832.856046] dst(0) dst_gpio_outb: mask=[ffffffff], enbb=[0001],
outhigh=[0000]
[72832.858037] dst(0) rdc_reset_state: Resetting state machine
[72832.858042] dst(0) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0000]
[72832.872025] dst(0) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0002]
[72832.976015] writing [ 09 00 07 1c 50 00 1a db 00 8f ]
[72832.976029] bt-i2c: <W aa 09 00 07 1c 50 00 1a db 00 8f >
[72832.977476] dst(0) dst_gpio_outb: mask=[ffffffff], enbb=[0000],
outhigh=[0000]
[72832.979465] bt-i2c: <R ab =ff >
[72832.979699] dst(0) read_dst: reply is 0xff
[72834.352015] dst(0) dst_wait_dst_ready: dst wait ready after 86
[72834.352022] bt-i2c: <R ab =09 =00 =00 =00 =00 =00 =1a =db =00 =02 >
[72834.353727] dst(0) read_dst: reply is 0x9
[72834.353731]  0x0 0x0 0x0 0x0 0x0 0x1a 0xdb 0x0 0x2
[72834.400022] dst(0) dst_set_freq: set Frequency 466000000
[72834.400028] dst(0) dst_set_frontend: Set Frequency=[466000000]
[72834.400033] dst(0) dst_set_symbolrate: set symrate 6875000
[72834.400036] dst(0) dst_set_symbolrate: DCT-CI
[72834.400041] dst(0) dst_write_tuna: type_flags 0x1219
[72834.400045] dst(0) dst_comm_init: Initializing DST.
[72834.400049] dst(0) dst_gpio_outb: mask=[ffffffff], enbb=[0001],
outhigh=[0000]
[72834.402041] dst(0) rdc_reset_state: Resetting state machine
[72834.402045] dst(0) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0000]
[72834.416014] dst(0) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0002]
[72834.520015] writing [ 09 00 07 1c 50 00 1a db 00 8f ]
[72834.520029] bt-i2c: <W aa 09 00 07 1c 50 00 1a db 00 8f >
[72834.521475] dst(0) dst_gpio_outb: mask=[ffffffff], enbb=[0000],
outhigh=[0000]
[72834.523465] bt-i2c: <R ab =ff >
[72834.523699] dst(0) read_dst: reply is 0xff
[72835.896015] dst(0) dst_wait_dst_ready: dst wait ready after 86
[72835.896021] bt-i2c: <R ab =09 =00 =00 =00 =00 =00 =1a =db =00 =02 >
[72835.897473] dst(0) read_dst: reply is 0x9
[72835.897476]  0x0 0x0 0x0 0x0 0x0 0x1a 0xdb 0x0 0x2
[72835.944025] dst(0) dst_set_freq: set Frequency 466000000
[72835.944031] dst(0) dst_set_frontend: Set Frequency=[466000000]
[72835.944036] dst(0) dst_set_symbolrate: set symrate 6875000
[72835.944040] dst(0) dst_set_symbolrate: DCT-CI
[72835.944044] dst(0) dst_write_tuna: type_flags 0x1219
[72835.944048] dst(0) dst_comm_init: Initializing DST.
[72835.944052] dst(0) dst_gpio_outb: mask=[ffffffff], enbb=[0001],
outhigh=[0000]
[72835.946044] dst(0) rdc_reset_state: Resetting state machine
[72835.946049] dst(0) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0000]
[72835.960025] dst(0) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0002]
[72836.064013] writing [ 09 00 07 1c 50 00 1a db 00 8f ]
[72836.064027] bt-i2c: <W aa 09 00 07 1c 50 00 1a db 00 8f >
[72836.065471] dst(0) dst_gpio_outb: mask=[ffffffff], enbb=[0000],
outhigh=[0000]
[72836.067461] bt-i2c: <R ab =ff >
[72836.067693] dst(0) read_dst: reply is 0xff
[72837.440019] dst(0) dst_wait_dst_ready: dst wait ready after 86
[72837.440026] bt-i2c: <R ab =09 =00 =00 =00 =00 =00 =1a =db =00 =02 >
[72837.441479] dst(0) read_dst: reply is 0x9
[72837.441482]  0x0 0x0 0x0 0x0 0x0 0x1a 0xdb 0x0 0x2
[72837.441562] dst(0) dst_set_freq: set Frequency 466000000
[72837.441567] dst(0) dst_set_frontend: Set Frequency=[466000000]
[72837.441571] dst(0) dst_set_symbolrate: set symrate 6875000
[72837.441574] dst(0) dst_set_symbolrate: DCT-CI
[72837.441578] dst(0) dst_write_tuna: type_flags 0x1219
[72837.441582] dst(0) dst_comm_init: Initializing DST.
[72837.441587] dst(0) dst_gpio_outb: mask=[ffffffff], enbb=[0001],
outhigh=[0000]
[72837.443578] dst(0) rdc_reset_state: Resetting state machine
[72837.443582] dst(0) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0000]
[72837.460022] dst(0) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0002]
[72837.564017] writing [ 09 00 07 1c 50 00 1a db 00 8f ]
[72837.564032] bt-i2c: <W aa 09 00 07 1c 50 00 1a db 00 8f >
[72837.565477] dst(0) dst_gpio_outb: mask=[ffffffff], enbb=[0000],
outhigh=[0000]
[72837.567467] bt-i2c: <R ab =ff >
[72837.567699] dst(0) read_dst: reply is 0xff
[72838.940015] dst(0) dst_wait_dst_ready: dst wait ready after 86
[72838.940021] bt-i2c: <R ab =09 =00 =00 =00 =00 =00 =1a =db =00 =02 >
[72838.941473] dst(0) read_dst: reply is 0x9
[72838.941476]  0x0 0x0 0x0 0x0 0x0 0x1a 0xdb 0x0 0x2
[72838.988023] dst(0) dst_set_freq: set Frequency 466000000
[72838.988029] dst(0) dst_set_frontend: Set Frequency=[466000000]
[72838.988033] dst(0) dst_set_symbolrate: set symrate 6875000
[72838.988037] dst(0) dst_set_symbolrate: DCT-CI
[72838.988041] dst(0) dst_write_tuna: type_flags 0x1219
[72838.988045] dst(0) dst_comm_init: Initializing DST.
[72838.988049] dst(0) dst_gpio_outb: mask=[ffffffff], enbb=[0001],
outhigh=[0000]
[72838.990041] dst(0) rdc_reset_state: Resetting state machine
[72838.990045] dst(0) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0000]
[72839.004035] dst(0) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0002]
[72839.108024] writing [ 09 00 07 1c 50 00 1a db 00 8f ]
[72839.108038] bt-i2c: <W aa 09 00 07 1c 50 00 1a db 00 8f >
[72839.109482] dst(0) dst_gpio_outb: mask=[ffffffff], enbb=[0000],
outhigh=[0000]
[72839.111472] bt-i2c: <R ab =ff >
[72839.111704] dst(0) read_dst: reply is 0xff
[72840.484016] dst(0) dst_wait_dst_ready: dst wait ready after 86
[72840.484023] bt-i2c: <R ab =09 =00 =00 =00 =00 =00 =1a =db =00 =02 >
[72840.485474] dst(0) read_dst: reply is 0x9
[72840.485477]  0x0 0x0 0x0 0x0 0x0 0x1a 0xdb 0x0 0x2
[72840.532021] dst(0) dst_set_freq: set Frequency 466000000
[72840.532027] dst(0) dst_set_frontend: Set Frequency=[466000000]
[72840.532031] dst(0) dst_set_symbolrate: set symrate 6875000
[72840.532035] dst(0) dst_set_symbolrate: DCT-CI
[72840.532039] dst(0) dst_write_tuna: type_flags 0x1219
[72840.532042] dst(0) dst_comm_init: Initializing DST.
[72840.532047] dst(0) dst_gpio_outb: mask=[ffffffff], enbb=[0001],
outhigh=[0000]
[72840.534038] dst(0) rdc_reset_state: Resetting state machine
[72840.534043] dst(0) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0000]
[72840.548037] dst(0) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0002]
[72840.652020] writing [ 09 00 07 1c 50 00 1a db 00 8f ]
[72840.652034] bt-i2c: <W aa 09 00 07 1c 50 00 1a db 00 8f >
[72840.653479] dst(0) dst_gpio_outb: mask=[ffffffff], enbb=[0000],
outhigh=[0000]
[72840.655469] bt-i2c: <R ab =ff >
[72840.655703] dst(0) read_dst: reply is 0xff
[72842.028017] dst(0) dst_wait_dst_ready: dst wait ready after 86
[72842.028023] bt-i2c: <R ab =09 =00 =00 =00 =00 =00 =1a =db =00 =02 >
[72842.029473] dst(0) read_dst: reply is 0x9
[72842.029476]  0x0 0x0 0x0 0x0 0x0 0x1a 0xdb 0x0 0x2
[72842.076022] dst(0) dst_set_freq: set Frequency 466000000
[72842.076029] dst(0) dst_set_frontend: Set Frequency=[466000000]
[72842.076033] dst(0) dst_set_symbolrate: set symrate 6875000
[72842.076037] dst(0) dst_set_symbolrate: DCT-CI
[72842.076041] dst(0) dst_write_tuna: type_flags 0x1219
[72842.076045] dst(0) dst_comm_init: Initializing DST.
[72842.076050] dst(0) dst_gpio_outb: mask=[ffffffff], enbb=[0001],
outhigh=[0000]
[72842.078042] dst(0) rdc_reset_state: Resetting state machine
[72842.078046] dst(0) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0000]
[72842.092023] dst(0) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0002]
[72842.196017] writing [ 09 00 07 1c 50 00 1a db 00 8f ]
[72842.196030] bt-i2c: <W aa 09 00 07 1c 50 00 1a db 00 8f >
[72842.197474] dst(0) dst_gpio_outb: mask=[ffffffff], enbb=[0000],
outhigh=[0000]
[72842.199464] bt-i2c: <R ab =ff >
[72842.199696] dst(0) read_dst: reply is 0xff
[72843.572016] dst(0) dst_wait_dst_ready: dst wait ready after 86
[72843.572023] bt-i2c: <R ab =09 =00 =00 =00 =00 =00 =1a =db =00 =02 >
[72843.573476] dst(0) read_dst: reply is 0x9
[72843.573479]  0x0 0x0 0x0 0x0 0x0 0x1a 0xdb 0x0 0x2
[72843.620023] dst(0) dst_set_freq: set Frequency 466000000
[72843.620029] dst(0) dst_set_frontend: Set Frequency=[466000000]
[72843.620033] dst(0) dst_set_symbolrate: set symrate 6875000
[72843.620037] dst(0) dst_set_symbolrate: DCT-CI
[72843.620041] dst(0) dst_write_tuna: type_flags 0x1219
[72843.620044] dst(0) dst_comm_init: Initializing DST.
[72843.620049] dst(0) dst_gpio_outb: mask=[ffffffff], enbb=[0001],
outhigh=[0000]
[72843.622040] dst(0) rdc_reset_state: Resetting state machine
[72843.622045] dst(0) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0000]
[72843.636035] dst(0) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0002]
[72843.740014] writing [ 09 00 07 1c 50 00 1a db 00 8f ]
[72843.740028] bt-i2c: <W aa 09 00 07 1c 50 00 1a db 00 8f >
[72843.741473] dst(0) dst_gpio_outb: mask=[ffffffff], enbb=[0000],
outhigh=[0000]
[72843.743463] bt-i2c: <R ab =ff >
[72843.743697] dst(0) read_dst: reply is 0xff
[72845.116080] dst(0) dst_wait_dst_ready: dst wait ready after 86
[72845.116087] bt-i2c: <R ab =09 =00 =00 =00 =00 =00 =1a =db =00 =02 >
[72845.117540] dst(0) read_dst: reply is 0x9
[72845.117543]  0x0 0x0 0x0 0x0 0x0 0x1a 0xdb 0x0 0x2
[72845.164024] dst(0) dst_set_freq: set Frequency 466000000
[72845.164030] dst(0) dst_set_frontend: Set Frequency=[466000000]
[72845.164034] dst(0) dst_set_symbolrate: set symrate 6875000
[72845.164037] dst(0) dst_set_symbolrate: DCT-CI
[72845.164041] dst(0) dst_write_tuna: type_flags 0x1219
[72845.164045] dst(0) dst_comm_init: Initializing DST.
[72845.164050] dst(0) dst_gpio_outb: mask=[ffffffff], enbb=[0001],
outhigh=[0000]
[72845.166041] dst(0) rdc_reset_state: Resetting state machine
[72845.166046] dst(0) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0000]
[72845.180035] dst(0) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0002]
[72845.284016] writing [ 09 00 07 1c 50 00 1a db 00 8f ]
[72845.284031] bt-i2c: <W aa 09 00 07 1c 50 00 1a db 00 8f >
[72845.285476] dst(0) dst_gpio_outb: mask=[ffffffff], enbb=[0000],
outhigh=[0000]
[72845.287467] bt-i2c: <R ab =ff >
[72845.287699] dst(0) read_dst: reply is 0xff
[72846.660015] dst(0) dst_wait_dst_ready: dst wait ready after 86
[72846.660022] bt-i2c: <R ab =09 =00 =00 =00 =00 =00 =1a =db =00 =02 >
[72846.661472] dst(0) read_dst: reply is 0x9
[72846.661475]  0x0 0x0 0x0 0x0 0x0 0x1a 0xdb 0x0 0x2
[72846.708023] dst(0) dst_set_freq: set Frequency 466000000
[72846.708030] dst(0) dst_set_frontend: Set Frequency=[466000000]
[72846.708034] dst(0) dst_set_symbolrate: set symrate 6875000
[72846.708038] dst(0) dst_set_symbolrate: DCT-CI
[72846.708042] dst(0) dst_write_tuna: type_flags 0x1219
[72846.708046] dst(0) dst_comm_init: Initializing DST.
[72846.708050] dst(0) dst_gpio_outb: mask=[ffffffff], enbb=[0001],
outhigh=[0000]
[72846.710043] dst(0) rdc_reset_state: Resetting state machine
[72846.710047] dst(0) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0000]
[72846.724024] dst(0) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0002]
[72846.828018] writing [ 09 00 07 1c 50 00 1a db 00 8f ]
[72846.828030] bt-i2c: <W aa 09 00 07 1c 50 00 1a db 00 8f >
[72846.829476] dst(0) dst_gpio_outb: mask=[ffffffff], enbb=[0000],
outhigh=[0000]
[72846.831466] bt-i2c: <R ab =ff >
[72846.831700] dst(0) read_dst: reply is 0xff
[72848.204016] dst(0) dst_wait_dst_ready: dst wait ready after 86
[72848.204023] bt-i2c: <R ab =09 =00 =00 =00 =00 =00 =1a =db =00 =02 >
[72848.205475] dst(0) read_dst: reply is 0x9
[72848.205478]  0x0 0x0 0x0 0x0 0x0 0x1a 0xdb 0x0 0x2
[72848.252024] dst(0) dst_set_freq: set Frequency 466000000
[72848.252029] dst(0) dst_set_frontend: Set Frequency=[466000000]
[72848.252033] dst(0) dst_set_symbolrate: set symrate 6875000
[72848.252037] dst(0) dst_set_symbolrate: DCT-CI
[72848.252041] dst(0) dst_write_tuna: type_flags 0x1219
[72848.252045] dst(0) dst_comm_init: Initializing DST.
[72848.252050] dst(0) dst_gpio_outb: mask=[ffffffff], enbb=[0001],
outhigh=[0000]
[72848.254041] dst(0) rdc_reset_state: Resetting state machine
[72848.254046] dst(0) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0000]
[72848.268036] dst(0) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0002]
[72848.372009] writing [ 09 00 07 1c 50 00 1a db 00 8f ]
[72848.372023] bt-i2c: <W aa 09 00 07 1c 50 00 1a db 00 8f >
[72848.373468] dst(0) dst_gpio_outb: mask=[ffffffff], enbb=[0000],
outhigh=[0000]
[72848.375459] bt-i2c: <R ab =ff >
[72848.375693] dst(0) read_dst: reply is 0xff
[72849.748015] dst(0) dst_wait_dst_ready: dst wait ready after 86
[72849.748021] bt-i2c: <R ab =09 =00 =00 =00 =00 =00 =1a =db =00 =02 >
[72849.749472] dst(0) read_dst: reply is 0x9
[72849.749475]  0x0 0x0 0x0 0x0 0x0 0x1a 0xdb 0x0 0x2
[72849.796023] dst(0) dst_set_freq: set Frequency 466000000
[72849.796028] dst(0) dst_set_frontend: Set Frequency=[466000000]
[72849.796033] dst(0) dst_set_symbolrate: set symrate 6875000
[72849.796036] dst(0) dst_set_symbolrate: DCT-CI
[72849.796040] dst(0) dst_write_tuna: type_flags 0x1219
[72849.796044] dst(0) dst_comm_init: Initializing DST.
[72849.796049] dst(0) dst_gpio_outb: mask=[ffffffff], enbb=[0001],
outhigh=[0000]
[72849.798040] dst(0) rdc_reset_state: Resetting state machine
[72849.798044] dst(0) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0000]
[72849.812035] dst(0) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0002]
[72849.916019] writing [ 09 00 07 1c 50 00 1a db 00 8f ]
[72849.916033] bt-i2c: <W aa 09 00 07 1c 50 00 1a db 00 8f >
[72849.917479] dst(0) dst_gpio_outb: mask=[ffffffff], enbb=[0000],
outhigh=[0000]
[72849.919470] bt-i2c: <R ab =ff >
[72849.919704] dst(0) read_dst: reply is 0xff
[72851.292015] dst(0) dst_wait_dst_ready: dst wait ready after 86
[72851.292021] bt-i2c: <R ab =09 =00 =00 =00 =00 =00 =1a =db =00 =02 >
[72851.293472] dst(0) read_dst: reply is 0x9
[72851.293475]  0x0 0x0 0x0 0x0 0x0 0x1a 0xdb 0x0 0x2
[72851.340022] dst(0) dst_set_freq: set Frequency 466000000
[72851.340029] dst(0) dst_set_frontend: Set Frequency=[466000000]
[72851.340033] dst(0) dst_set_symbolrate: set symrate 6875000
[72851.340037] dst(0) dst_set_symbolrate: DCT-CI
[72851.340041] dst(0) dst_write_tuna: type_flags 0x1219
[72851.340045] dst(0) dst_comm_init: Initializing DST.
[72851.340050] dst(0) dst_gpio_outb: mask=[ffffffff], enbb=[0001],
outhigh=[0000]
[72851.342042] dst(0) rdc_reset_state: Resetting state machine
[72851.342046] dst(0) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0000]
[72851.356023] dst(0) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0002]
[72851.460016] writing [ 09 00 07 1c 50 00 1a db 00 8f ]
[72851.460030] bt-i2c: <W aa 09 00 07 1c 50 00 1a db 00 8f >
[72851.461475] dst(0) dst_gpio_outb: mask=[ffffffff], enbb=[0000],
outhigh=[0000]
[72851.463465] bt-i2c: <R ab =ff >
[72851.463699] dst(0) read_dst: reply is 0xff
[72852.836016] dst(0) dst_wait_dst_ready: dst wait ready after 86
[72852.836023] bt-i2c: <R ab =09 =00 =00 =00 =00 =00 =1a =db =00 =02 >
[72852.837476] dst(0) read_dst: reply is 0x9
[72852.837479]  0x0 0x0 0x0 0x0 0x0 0x1a 0xdb 0x0 0x2


***** Running czap to lock on a frequency and channel (I got the
channels.conf *****
***** by scanning using a different DVB-C card)
        *****
# czap -H "RTV SLO HD"
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
reading channels from file '/home/user/.czap/channels.conf'
 48 RTV SLO HD:466000000:INVERSION_AUTO:6875000:FEC_AUTO:QAM_AUTO:1818:401:11001
 48 RTV SLO HD: f 466000000, s 6875000, i 2, fec 9, qam 6, v 0x71a, a
0x191, s 0x2af9
status 00 | signal   0% | snr   0% | ber -1079662840 | unc 134527780 |
status 00 | signal   0% | snr   0% | ber -1079662840 | unc 134527780 |

***** dmesg output ******
[16311.197944] dvb_bt8xx: start_feed
[16311.197949] bt878 debug: bt878_start (ctl=02204f2c)
[16311.197952] bt878: risc len lines 64, bytes per line 2048
[16311.198364] dvb_bt8xx: start_feed
[16311.198410] dst(0) dst_set_freq: set Frequency 466000000
[16311.198416] dst(0) dst_set_frontend: Set Frequency=[466000000]
[16311.198420] dst(0) dst_set_symbolrate: set symrate 6875000
[16311.198424] dst(0) dst_set_symbolrate: DCT-CI
[16311.198428] dst(0) dst_write_tuna: type_flags 0x1219
[16311.198431] dst(0) dst_comm_init: Initializing DST.
[16311.198436] dst(0) dst_gpio_outb: mask=[ffffffff], enbb=[0001],
outhigh=[0000]
[16311.200427] dst(0) rdc_reset_state: Resetting state machine
[16311.200432] dst(0) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0000]
[16311.216022] dst(0) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0002]
[16311.320019] writing [ 09 00 07 1c 50 00 1a db 00 8f ]
[16311.320032] bt-i2c: <W aa 09 00 07 1c 50 00 1a db 00 8f >
[16311.321475] dst(0) dst_gpio_outb: mask=[ffffffff], enbb=[0000],
outhigh=[0000]
[16311.323466] bt-i2c: <R ab =ff >
[16311.323698] dst(0) read_dst: reply is 0xff
[16312.696522] dst(0) dst_wait_dst_ready: dst wait ready after 86
[16312.696530] bt-i2c: <R ab =09 =00 =00 =00 =00 =00 =1a =db =00 =02 >
[16312.697980] dst(0) read_dst: reply is 0x9
[16312.697983]  0x0 0x0 0x0 0x0 0x0 0x1a 0xdb 0x0 0x2
[16312.744025] dst(0) dst_set_freq: set Frequency 466000000
[16312.744031] dst(0) dst_set_frontend: Set Frequency=[466000000]
[16312.744035] dst(0) dst_set_symbolrate: set symrate 6875000
[16312.744039] dst(0) dst_set_symbolrate: DCT-CI
[16312.744043] dst(0) dst_write_tuna: type_flags 0x1219
[16312.744046] dst(0) dst_comm_init: Initializing DST.
[16312.744051] dst(0) dst_gpio_outb: mask=[ffffffff], enbb=[0001],
outhigh=[0000]
[16312.746042] dst(0) rdc_reset_state: Resetting state machine
[16312.746046] dst(0) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0000]
[16312.760016] dst(0) dst_gpio_outb: mask=[0002], enbb=[0002], outhigh=[0002]
[16312.864027] writing [ 09 00 07 1c 50 00 1a db 00 8f ]
[16312.864040] bt-i2c: <W aa 09 00 07 1c 50 00 1a db 00 8f >
[16312.865483] dst(0) dst_gpio_outb: mask=[ffffffff], enbb=[0000],
outhigh=[0000]
[16312.867472] bt-i2c: <R ab =ff >
[16312.867704] dst(0) read_dst: reply is 0xff
[16313.540107] dvb_bt8xx: stop_feed
[16313.540132] dvb_bt8xx: stop_feed
[16313.540135] bt878 debug: bt878_stop
[16313.540141] bt878(0) debug: bt878_stop, i=0, stat=0x50000000
[16314.240016] dst(0) dst_wait_dst_ready: dst wait ready after 86
[16314.240023] bt-i2c: <R ab =09 =00 =00 =00 =00 =00 =1a =db =00 =02 >
[16314.241475] dst(0) read_dst: reply is 0x9
[16314.241478]  0x0 0x0 0x0 0x0 0x0 0x1a 0xdb 0x0 0x2
