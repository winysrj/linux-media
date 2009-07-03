Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx1.redhat.com (mx1.redhat.com [172.16.48.31])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n639LuVw008225
	for <video4linux-list@redhat.com>; Fri, 3 Jul 2009 05:21:56 -0400
Received: from smtp6-g21.free.fr (smtp6-g21.free.fr [212.27.42.6])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n639LbfT026021
	for <video4linux-list@redhat.com>; Fri, 3 Jul 2009 05:21:39 -0400
Received: from smtp6-g21.free.fr (localhost [127.0.0.1])
	by smtp6-g21.free.fr (Postfix) with ESMTP id DBF54E08151
	for <video4linux-list@redhat.com>;
	Fri,  3 Jul 2009 11:21:35 +0200 (CEST)
Received: from [192.168.0.20] (mor77-1-88-176-241-62.fbx.proxad.net
	[88.176.241.62])
	by smtp6-g21.free.fr (Postfix) with ESMTP id D50B7E080ED
	for <video4linux-list@redhat.com>;
	Fri,  3 Jul 2009 11:21:32 +0200 (CEST)
Message-ID: <4A4DCD9C.3090002@digitalspirit.org>
Date: Fri, 03 Jul 2009 11:21:32 +0200
From: Hugo <hugo@digitalspirit.org>
MIME-Version: 1.0
To: video4linux-list@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: em28xx device problem since 2.6.30 kernel
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

Hi,

I have a  em28xx based device : Pinnacle PCTV USB 2 worked great before
kernel 2.6.30
On 2.6.30 and 2.6.31 kernel, device don't work...

dmesg :

[ 1822.572852] em28xx: New device Pinnacle Systems GmbH PCTV USB2 PAL @
480 Mbps (2304:0208, interface 0, class 0)
[ 1822.572856] em28xx #0: Identified as Pinnacle PCTV USB 2 (card=3)
[ 1822.573037] em28xx #0: chip ID is em2820
[ 1822.678037] em28xx #0: i2c eeprom 00: 1a eb 67 95 04 23 08 02 10 00
1e 03 98 1e 6a 2e
[ 1822.678049] em28xx #0: i2c eeprom 10: 00 00 06 57 6e 00 00 00 8e 00
00 00 07 00 00 00
[ 1822.678059] em28xx #0: i2c eeprom 20: 16 00 01 00 00 00 00 00 00 00
00 00 00 00 00 00
[ 1822.678250] em28xx #0: i2c eeprom 30: 00 00 20 40 20 80 02 20 10 01
00 00 00 00 00 00
[ 1822.678261] em28xx #0: i2c eeprom 40: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[ 1822.678271] em28xx #0: i2c eeprom 50: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[ 1822.678280] em28xx #0: i2c eeprom 60: 00 00 00 00 00 00 00 00 00 00
2e 03 50 00 69 00
[ 1822.678290] em28xx #0: i2c eeprom 70: 6e 00 6e 00 61 00 63 00 6c 00
65 00 20 00 53 00
[ 1822.678300] em28xx #0: i2c eeprom 80: 79 00 73 00 74 00 65 00 6d 00
73 00 20 00 47 00
[ 1822.678310] em28xx #0: i2c eeprom 90: 6d 00 62 00 48 00 00 00 1e 03
50 00 43 00 54 00
[ 1822.678320] em28xx #0: i2c eeprom a0: 56 00 20 00 55 00 53 00 42 00
32 00 20 00 50 00
[ 1822.678330] em28xx #0: i2c eeprom b0: 41 00 4c 00 00 00 06 03 31 00
00 00 00 00 00 00
[ 1822.678339] em28xx #0: i2c eeprom c0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[ 1822.678349] em28xx #0: i2c eeprom d0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[ 1822.678359] em28xx #0: i2c eeprom e0: 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00
[ 1822.678369] em28xx #0: i2c eeprom f0: 00 00 00 00 00 00 00 00 0e 5d
62 39 03 c6 00 0b
[ 1822.678381] em28xx #0: EEPROM ID= 0x9567eb1a, EEPROM hash = 0x1d1a34bf
[ 1822.678383] em28xx #0: EEPROM info:
[ 1822.678385] em28xx #0:    AC97 audio (5 sample rates)
[ 1822.678386] em28xx #0:    500mA max power
[ 1822.678389] em28xx #0:    Table at 0x06, strings=0x1e98, 0x2e6a, 0x0000
[ 1822.904387] saa7115 4-0025: saa7113 found (1f7113d0e100000) @ 0x4a
(em28xx #0)
[ 1823.274678] tuner 4-0043: chip found @ 0x86 (em28xx #0)
[ 1823.277509] tda9887 4-0043: creating new instance
[ 1823.277513] tda9887 4-0043: tda988[5/6/7] found
[ 1823.283317] tda9887 4-0043: destroying instance
[ 1823.287462] tuner-simple 4-0043: creating new instance
[ 1823.287466] tuner-simple 4-0043: type set to 38 (Philips PAL/SECAM
multi (FM1216ME MK3))
[ 1823.287474] BUG: unable to handle kernel NULL pointer dereference at
00000020
[ 1823.287478] IP: [<f873ea02>] tda9887_set_params+0xd/0x2a [tda9887]
[ 1823.287486] *pde = 00000000
[ 1823.287489] Oops: 0002 [#1] PREEMPT SMP
[ 1823.287493] last sysfs file: /sys/module/v4l2_common/initstate
[ 1823.287495] Modules linked in: tuner_simple tuner_types tda9887
tda8290 tuner saa7115 em28xx(+) ir_common v4l2_common videobuf_vmalloc
videobuf_core tveeprom dvb_core nvidia(P) sco bnep rfcomm l2cap
snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device
snd_pcm_oss snd_mixer_oss ext4 jbd2 crc16 ide_cd_mod
snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_pcm snd_timer
btusb snd bluetooth soundcore pwc ftdi_sio usbserial floppy jmicron
ide_core r8169 videodev v4l1_compat snd_page_alloc
[ 1823.287535]
[ 1823.287538] Pid: 25833, comm: modprobe Tainted: P           (2.6.30.1
#4) EX58-UD5
[ 1823.287542] EIP: 0060:[<f873ea02>] EFLAGS: 00010283 CPU: 1
[ 1823.287546] EIP is at tda9887_set_params+0xd/0x2a [tda9887]
[ 1823.287549] EAX: f73bfc00 EBX: 00000000 ECX: 00000002 EDX: dab01c28
[ 1823.287552] ESI: f73bfc00 EDI: dab01c3c EBP: dab01bfc ESP: dab01bf8
[ 1823.287555]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[ 1823.287558] Process modprobe (pid: 25833, ti=dab00000 task=f6b84020
task.ti=dab00000)
[ 1823.287561] Stack:
[ 1823.287562]  00000000 dab01c48 f86e33cf 00000005 00000000 00000000
dab01c28 dab01c44
[ 1823.287569]  f87bc774 f73bfc00 00000001 00000002 000002c0 00000002
00000001 00000000
[ 1823.287575]  00000000 f87bc3c4 f73bfc00 f86e61bf dab01c80 f86e4da3
f7316938 f73bfc00
[ 1823.287583] Call Trace:
[ 1823.287585]  [<f86e33cf>] ? set_freq+0x220/0x267 [tuner]
[ 1823.287592]  [<f87bc774>] ? simple_tuner_attach+0x3b0/0x3bf
[tuner_simple]
[ 1823.287599]  [<f87bc3c4>] ? simple_tuner_attach+0x0/0x3bf [tuner_simple]
[ 1823.287605]  [<f86e4da3>] ? set_type+0x612/0x8de [tuner]
[ 1823.287611]  [<f86e55b5>] ? tuner_s_type_addr+0x86/0xd5 [tuner]
[ 1823.287618]  [<f871f5cc>] ? em28xx_tuner_callback+0x0/0x21 [em28xx]
[ 1823.287630]  [<f871f3ee>] ? em28xx_card_setup+0x656/0x834 [em28xx]
[ 1823.287642]  [<c056a537>] ? printk+0xf/0x11
[ 1823.287648]  [<f871eb2b>] ? em28xx_i2c_register+0x324/0x365 [em28xx]
[ 1823.287660]  [<f871f5cc>] ? em28xx_tuner_callback+0x0/0x21 [em28xx]
[ 1823.287671]  [<f8720086>] ? em28xx_usb_probe+0x564/0x6e2 [em28xx]
[ 1823.287685]  [<c0428f96>] ? usb_probe_interface+0xe2/0x12b
[ 1823.287691]  [<c03df78c>] ? driver_probe_device+0x79/0x105
[ 1823.287696]  [<c03df85b>] ? __driver_attach+0x43/0x5f
[ 1823.287700]  [<c03df1a6>] ? bus_for_each_dev+0x3d/0x67
[ 1823.287705]  [<c03df665>] ? driver_attach+0x14/0x16
[ 1823.287709]  [<c03df818>] ? __driver_attach+0x0/0x5f
[ 1823.287713]  [<c03dec2b>] ? bus_add_driver+0xfb/0x21f
[ 1823.287717]  [<c03dfa9f>] ? driver_register+0x8b/0xe8
[ 1823.287721]  [<c0237b9a>] ? enqueue_entity+0x110/0x118
[ 1823.287726]  [<c0428d9f>] ? usb_register_driver+0x66/0xc0
[ 1823.287731]  [<f8039018>] ? em28xx_module_init+0x18/0x3c [em28xx]
[ 1823.287740]  [<c0201137>] ? do_one_initcall+0x4a/0x10c
[ 1823.287745]  [<f8039000>] ? em28xx_module_init+0x0/0x3c [em28xx]
[ 1823.287754]  [<c02540d0>] ? __blocking_notifier_call_chain+0x40/0x4c
[ 1823.287760]  [<c02607f1>] ? sys_init_module+0x87/0x18b
[ 1823.287765]  [<c021cb30>] ? sysenter_do_call+0x12/0x22
[ 1823.287771] Code: f6 ff ff 31 c0 5d c3 8b 90 2c 02 00 00 55 89 e5 c7
42 20 00 00 00 80 e8 6a f6 ff ff 5d c3 55 89 e5 53 8b 98 2c 02 00 00 8b
4a 04 <89> 4b 20 8b 4a 08 89 4b 24 8b 4a 10 8b 52 0c 89 4b 2c 89 53 28
[ 1823.287807] EIP: [<f873ea02>] tda9887_set_params+0xd/0x2a [tda9887]
SS:ESP 0068:dab01bf8
[ 1823.287814] CR2: 0000000000000020
[ 1823.287817] ---[ end trace b1fd98e6e01f3d35 ]---


Anynone have some idea ?
Thank you !

Regards

-- 
http://www.digitalspirit.org/
Jabber: hugo@im.digitalspirit.org

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
