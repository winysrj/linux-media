Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46405 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756808Ab0I3Rqv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 30 Sep 2010 13:46:51 -0400
Received: by wyb28 with SMTP id 28so2112570wyb.19
        for <linux-media@vger.kernel.org>; Thu, 30 Sep 2010 10:46:50 -0700 (PDT)
Message-ID: <4CA4CD07.3000601@gmail.com>
Date: Thu, 30 Sep 2010 19:46:47 +0200
From: Giorgio <mywing81@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <maurochehab@gmail.com>
CC: linux-media@vger.kernel.org
Subject: Re: ASUS My Cinema-P7131 Hybrid (saa7134) and slow IR
References: <AANLkTik4NpV5C=Ct_8u=awZ-tthDC=ORJj8u1DHTNu+q@mail.gmail.com> <4CA37755.5060608@redhat.com> <4CA3A9B3.6080703@gmail.com>
In-Reply-To: <4CA3A9B3.6080703@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 29/09/2010 23:03, Mauro Carvalho Chehab wrote:
> Em 29-09-2010 14:28, Mauro Carvalho Chehab escreveu:
>> Em 29-09-2010 14:06, Giorgio escreveu:
>>> Hello,
>>>
>>> I have an Asus P7131 Hybrid card, and it works like a charm with
>>> Ubuntu 8.04 and stock kernel 2.6.24. But, after upgrading my system to
>>> Ubuntu 10.04 x86-64, I noticed that the remote control was quite slow
>>> to respond. Sometimes the keypresses aren't recognized, and you have
>>> to keep pressing the same button two or three times until it works.
>>> The remote feels slow, not very responsive.
>>> So, to investigate the issue, I loaded the ir-common module with
>>> debug=1 and looked at the logs. They report lots of "ir-common:
>>> spurious timer_end". The funny thing is, I have tried the Ubuntu 10.04
>>> i386 livecd (with the same kernel) and the problem is not present
>>> there.
>>
>>> Sep 27 15:48:59 holden-desktop kernel: [  256.770031] ir-common: spurious timer_end
>>> Sep 27 15:48:59 holden-desktop kernel: [  256.880030] ir-common: spurious timer_end
>>
>> It is using the old RC support. This support will be removed soon, so, the
>> better is to convert it to use the new IR core, and fix a bug there, if is
>> there any.

Understood.

>> Please apply the attached patch (it is against my -git tree, but it will probably
>> apply fine if you have a new kernel).

Applied, and indeed I was able to collect all the scancodes I needed :)

>> You should notice that the RC_MAP_ASUS_PC39 table is not ready for the new IR
>> infrastructure. So, you'll need to enable ir-core debug, and check what scancodes are
>> detected there. Probably, all we need is to add the RC5 address to all codes at the table.

Done.

> Giorgio,
> 
> Based on the pastebin you posted via IRC, this is likely the patch you
> need to also change your current keytable to work with the new RC core.

Thanks to your help on IRC, I fixed the keytable, new patch below.

Everything should work now, here's the log of my test:

holden@holden-desktop:~$ sudo modprobe -v saa7134
insmod /lib/modules/2.6.35.6-dvb1/kernel/drivers/media/video/tveeprom.ko 
insmod /lib/modules/2.6.35.6-dvb1/kernel/drivers/media/IR/ir-core.ko debug=1
insmod /lib/modules/2.6.35.6-dvb1/kernel/drivers/media/IR/ir-common.ko 
insmod /lib/modules/2.6.35.6-dvb1/kernel/drivers/media/video/videobuf-core.ko 
insmod /lib/modules/2.6.35.6-dvb1/kernel/drivers/media/video/videobuf-dma-sg.ko 
insmod /lib/modules/2.6.35.6-dvb1/kernel/drivers/media/video/v4l2-compat-ioctl32.ko 
insmod /lib/modules/2.6.35.6-dvb1/kernel/drivers/media/video/v4l1-compat.ko 
insmod /lib/modules/2.6.35.6-dvb1/kernel/drivers/media/video/videodev.ko 
insmod /lib/modules/2.6.35.6-dvb1/kernel/drivers/media/video/v4l2-common.ko 
install /sbin/modprobe --ignore-install saa7134  && { /sbin/modprobe --quiet --use-blacklist saa7134-alsa ; : ; }
insmod /lib/modules/2.6.35.6-dvb1/kernel/drivers/media/video/saa7134/saa7134.ko ir_debug=1
insmod /lib/modules/2.6.35.6-dvb1/kernel/drivers/media/video/saa7134/saa7134-alsa.ko index=-2

holden@holden-desktop:~$ sudo modprobe -vr ir_sony_decoder ir_jvc_decoder ir_rc6_decoder ir_nec_decoder
rmmod /lib/modules/2.6.35.6-dvb1/kernel/drivers/media/IR/ir-sony-decoder.ko
rmmod /lib/modules/2.6.35.6-dvb1/kernel/drivers/media/IR/ir-jvc-decoder.ko
rmmod /lib/modules/2.6.35.6-dvb1/kernel/drivers/media/IR/ir-rc6-decoder.ko
rmmod /lib/modules/2.6.35.6-dvb1/kernel/drivers/media/IR/ir-nec-decoder.ko


Sep 30 12:27:57 holden-desktop kernel: [ 1119.452985] IR NEC protocol handler initialized
Sep 30 12:27:57 holden-desktop kernel: [ 1119.475713] IR RC5(x) protocol handler initialized
Sep 30 12:27:57 holden-desktop kernel: [ 1119.479107] IR RC6 protocol handler initialized
Sep 30 12:27:57 holden-desktop kernel: [ 1119.479344] Linux video capture interface: v2.00
Sep 30 12:27:57 holden-desktop kernel: [ 1119.489334] IR JVC protocol handler initialized
Sep 30 12:27:57 holden-desktop kernel: [ 1119.496464] IR Sony protocol handler initialized
Sep 30 12:27:57 holden-desktop kernel: [ 1119.521130] saa7130/34: v4l2 driver version 0.2.16 loaded
Sep 30 12:27:57 holden-desktop kernel: [ 1119.521227] saa7133[0]: found at 0000:02:07.0, rev: 209, irq: 20, latency: 64, mmio: 0xfbfff800
Sep 30 12:27:57 holden-desktop kernel: [ 1119.521234] saa7133[0]: subsystem: 1043:4876, board: ASUSTeK P7131 Hybrid [card=112,autodetected]
Sep 30 12:27:57 holden-desktop kernel: [ 1119.521275] saa7133[0]: board init: gpio is 40000
Sep 30 12:27:57 holden-desktop kernel: [ 1119.550016] Registered IR keymap rc-asus-pc39
Sep 30 12:27:57 holden-desktop kernel: [ 1119.550026] __ir_input_register: Allocated space for 64 keycode entries (512 bytes)
Sep 30 12:27:57 holden-desktop kernel: [ 1119.550030] ir_do_setkeycode: #0: New scan 0x082a with key 0x000b
Sep 30 12:27:57 holden-desktop kernel: [ 1119.550032] ir_do_setkeycode: #0: New scan 0x0816 with key 0x0002
Sep 30 12:27:57 holden-desktop kernel: [ 1119.550035] ir_do_setkeycode: #0: New scan 0x0812 with key 0x0003
Sep 30 12:27:57 holden-desktop kernel: [ 1119.550038] ir_do_setkeycode: #1: New scan 0x0814 with key 0x0004
Sep 30 12:27:57 holden-desktop kernel: [ 1119.550040] ir_do_setkeycode: #4: New scan 0x0836 with key 0x0005
Sep 30 12:27:57 holden-desktop kernel: [ 1119.550042] ir_do_setkeycode: #4: New scan 0x0832 with key 0x0006
Sep 30 12:27:57 holden-desktop kernel: [ 1119.550045] ir_do_setkeycode: #5: New scan 0x0834 with key 0x0007
Sep 30 12:27:57 holden-desktop kernel: [ 1119.550047] ir_do_setkeycode: #0: New scan 0x080e with key 0x0008
Sep 30 12:27:57 holden-desktop kernel: [ 1119.550050] ir_do_setkeycode: #0: New scan 0x080a with key 0x0009
Sep 30 12:27:57 holden-desktop kernel: [ 1119.550052] ir_do_setkeycode: #1: New scan 0x080c with key 0x000a
Sep 30 12:27:57 holden-desktop kernel: [ 1119.550055] ir_do_setkeycode: #0: New scan 0x0801 with key 0x0181
Sep 30 12:27:57 holden-desktop kernel: [ 1119.550057] ir_do_setkeycode: #11: New scan 0x083c with key 0x008b
Sep 30 12:27:57 holden-desktop kernel: [ 1119.550060] ir_do_setkeycode: #6: New scan 0x0815 with key 0x0073
Sep 30 12:27:57 holden-desktop kernel: [ 1119.550062] ir_do_setkeycode: #8: New scan 0x0826 with key 0x0072
Sep 30 12:27:57 holden-desktop kernel: [ 1119.550065] ir_do_setkeycode: #1: New scan 0x0808 with key 0x0067
Sep 30 12:27:57 holden-desktop kernel: [ 1119.550067] ir_do_setkeycode: #1: New scan 0x0804 with key 0x006c
Sep 30 12:27:57 holden-desktop kernel: [ 1119.550070] ir_do_setkeycode: #10: New scan 0x0818 with key 0x0069
Sep 30 12:27:57 holden-desktop kernel: [ 1119.550072] ir_do_setkeycode: #6: New scan 0x0810 with key 0x006a
Sep 30 12:27:57 holden-desktop kernel: [ 1119.550075] ir_do_setkeycode: #12: New scan 0x081a with key 0x0189
Sep 30 12:27:57 holden-desktop kernel: [ 1119.550077] ir_do_setkeycode: #2: New scan 0x0806 with key 0x0188
Sep 30 12:27:57 holden-desktop kernel: [ 1119.550080] ir_do_setkeycode: #14: New scan 0x081e with key 0x0179
Sep 30 12:27:57 holden-desktop kernel: [ 1119.550083] ir_do_setkeycode: #15: New scan 0x0822 with key 0x00ae
Sep 30 12:27:57 holden-desktop kernel: [ 1119.550085] ir_do_setkeycode: #20: New scan 0x0835 with key 0x0192
Sep 30 12:27:57 holden-desktop kernel: [ 1119.550087] ir_do_setkeycode: #16: New scan 0x0824 with key 0x0193
Sep 30 12:27:57 holden-desktop kernel: [ 1119.550090] ir_do_setkeycode: #17: New scan 0x0825 with key 0x001c
Sep 30 12:27:57 holden-desktop kernel: [ 1119.550092] ir_do_setkeycode: #24: New scan 0x0839 with key 0x0077
Sep 30 12:27:57 holden-desktop kernel: [ 1119.550095] ir_do_setkeycode: #15: New scan 0x0821 with key 0x019c
Sep 30 12:27:57 holden-desktop kernel: [ 1119.550097] ir_do_setkeycode: #13: New scan 0x0819 with key 0x0197
Sep 30 12:27:57 holden-desktop kernel: [ 1119.550100] ir_do_setkeycode: #22: New scan 0x0831 with key 0x00a8
Sep 30 12:27:57 holden-desktop kernel: [ 1119.550103] ir_do_setkeycode: #2: New scan 0x0805 with key 0x00d0
Sep 30 12:27:57 holden-desktop kernel: [ 1119.550105] ir_do_setkeycode: #5: New scan 0x0809 with key 0x0080
Sep 30 12:27:57 holden-desktop kernel: [ 1119.550108] ir_do_setkeycode: #10: New scan 0x0811 with key 0x00a7
Sep 30 12:27:57 holden-desktop kernel: [ 1119.550111] ir_do_setkeycode: #24: New scan 0x0829 with key 0x0074
Sep 30 12:27:57 holden-desktop kernel: [ 1119.550113] ir_do_setkeycode: #26: New scan 0x082e with key 0x0174
Sep 30 12:27:57 holden-desktop kernel: [ 1119.550116] ir_do_setkeycode: #26: New scan 0x082c with key 0x0070
Sep 30 12:27:57 holden-desktop kernel: [ 1119.550118] ir_do_setkeycode: #18: New scan 0x081c with key 0x0066
Sep 30 12:27:57 holden-desktop kernel: [ 1119.550121] ir_do_setkeycode: #35: New scan 0x083a with key 0x016e
Sep 30 12:27:57 holden-desktop kernel: [ 1119.550123] ir_do_setkeycode: #1: New scan 0x0802 with key 0x0071
Sep 30 12:27:57 holden-desktop kernel: [ 1119.550126] ir_do_setkeycode: #38: New scan 0x083e with key 0x0185
Sep 30 12:27:57 holden-desktop kernel: [ 1119.550212] input: saa7134 IR (ASUSTeK P7131 Hybri as /devices/pci0000:00/0000:00:02.0/0000:02:07.0/rc/rc0/input14
Sep 30 12:27:57 holden-desktop kernel: [ 1119.550274] rc0: saa7134 IR (ASUSTeK P7131 Hybri as /devices/pci0000:00/0000:00:02.0/0000:02:07.0/rc/rc0
Sep 30 12:27:57 holden-desktop kernel: [ 1119.550286] __ir_input_register: Registered input device on saa7134 for rc-asus-pc39 remote.
Sep 30 12:27:57 holden-desktop kernel: [ 1119.730021] saa7133[0]: i2c eeprom 00: 43 10 76 48 54 20 1c 00 43 43 a9 1c 55 d2 b2 92
Sep 30 12:27:57 holden-desktop kernel: [ 1119.730040] saa7133[0]: i2c eeprom 10: ff ff ff 0f ff 20 ff ff ff ff ff ff ff ff ff ff
Sep 30 12:27:57 holden-desktop kernel: [ 1119.730057] saa7133[0]: i2c eeprom 20: 01 40 01 02 03 01 01 03 08 ff 00 d5 ff ff ff ff
Sep 30 12:27:57 holden-desktop kernel: [ 1119.730073] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Sep 30 12:27:57 holden-desktop kernel: [ 1119.730089] saa7133[0]: i2c eeprom 40: ff 21 00 c2 96 10 03 32 55 50 ff ff ff ff ff ff
Sep 30 12:27:57 holden-desktop kernel: [ 1119.730104] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Sep 30 12:27:57 holden-desktop kernel: [ 1119.730120] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Sep 30 12:27:57 holden-desktop kernel: [ 1119.730136] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Sep 30 12:27:57 holden-desktop kernel: [ 1119.730151] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Sep 30 12:27:57 holden-desktop kernel: [ 1119.730167] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Sep 30 12:27:57 holden-desktop kernel: [ 1119.730183] saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Sep 30 12:27:57 holden-desktop kernel: [ 1119.730198] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Sep 30 12:27:57 holden-desktop kernel: [ 1119.730214] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Sep 30 12:27:57 holden-desktop kernel: [ 1119.730230] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Sep 30 12:27:57 holden-desktop kernel: [ 1119.730245] saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Sep 30 12:27:57 holden-desktop kernel: [ 1119.730261] saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
Sep 30 12:27:57 holden-desktop kernel: [ 1119.730278] saa7133[0]/ir: No I2C IR support for board 70
Sep 30 12:27:57 holden-desktop kernel: [ 1119.850226] tuner 3-004b: chip found @ 0x96 (saa7133[0])
Sep 30 12:27:57 holden-desktop kernel: [ 1120.020024] tda829x 3-004b: setting tuner address to 61
Sep 30 12:27:57 holden-desktop kernel: [ 1120.150021] tda829x 3-004b: type set to tda8290+75a
Sep 30 12:28:03 holden-desktop kernel: [ 1125.870997] saa7133[0]: registered device video0 [v4l2]
Sep 30 12:28:03 holden-desktop kernel: [ 1125.871952] saa7133[0]: registered device vbi0
Sep 30 12:28:03 holden-desktop kernel: [ 1125.872515] saa7133[0]: registered device radio0
Sep 30 12:28:03 holden-desktop kernel: [ 1125.892561] saa7134 ALSA driver for DMA sound loaded
Sep 30 12:28:03 holden-desktop kernel: [ 1125.892618] saa7133[0]/alsa: saa7133[0] at 0xfbfff800 irq 20 registered as card -2
Sep 30 12:28:03 holden-desktop kernel: [ 1126.041151] dvb_init() allocating 1 frontend
Sep 30 12:28:04 holden-desktop kernel: [ 1126.840236] DVB: registering new adapter (saa7133[0])
Sep 30 12:28:04 holden-desktop kernel: [ 1126.840247] DVB: registering adapter 0 frontend 0 (Philips TDA10046H DVB-T)...
Sep 30 12:28:05 holden-desktop kernel: [ 1127.640016] tda1004x: setting up plls for 48MHz sampling clock
Sep 30 12:28:07 holden-desktop kernel: [ 1129.780016] tda1004x: found firmware revision 20 -- ok

Now, pressing the keys: '0', '1', '2', '3', '4', '5', '6', '7', '8', '9' on the remote I get:

Sep 30 12:28:41 holden-desktop kernel: [ 1164.130035] ir_rc5_decode: RC5 scancode 0x082a (toggle: 0)
Sep 30 12:28:41 holden-desktop kernel: [ 1164.130044] ir_g_keycode_from_table: saa7134 IR (ASUSTeK P7131 Hybri: scancode 0x082a keycode 0x0b
Sep 30 12:28:41 holden-desktop kernel: [ 1164.130050] ir_keydown: saa7134 IR (ASUSTeK P7131 Hybri: key down event, key 0x000b, scancode 0x082a
Sep 30 12:28:42 holden-desktop kernel: [ 1164.380021] ir_keyup: keyup key 0x000b
Sep 30 12:28:51 holden-desktop kernel: [ 1173.570046] ir_rc5_decode: RC5 scancode 0x0816 (toggle: 0)
Sep 30 12:28:51 holden-desktop kernel: [ 1173.570055] ir_g_keycode_from_table: saa7134 IR (ASUSTeK P7131 Hybri: scancode 0x0816 keycode 0x02
Sep 30 12:28:51 holden-desktop kernel: [ 1173.570061] ir_keydown: saa7134 IR (ASUSTeK P7131 Hybri: key down event, key 0x0002, scancode 0x0816
Sep 30 12:28:51 holden-desktop kernel: [ 1173.820019] ir_keyup: keyup key 0x0002
Sep 30 12:28:59 holden-desktop kernel: [ 1181.370031] ir_rc5_decode: RC5 scancode 0x0812 (toggle: 1)
Sep 30 12:28:59 holden-desktop kernel: [ 1181.370040] ir_g_keycode_from_table: saa7134 IR (ASUSTeK P7131 Hybri: scancode 0x0812 keycode 0x03
Sep 30 12:28:59 holden-desktop kernel: [ 1181.370046] ir_keydown: saa7134 IR (ASUSTeK P7131 Hybri: key down event, key 0x0003, scancode 0x0812
Sep 30 12:28:59 holden-desktop kernel: [ 1181.620024] ir_keyup: keyup key 0x0003
Sep 30 12:29:06 holden-desktop kernel: [ 1188.370035] ir_rc5_decode: RC5 scancode 0x0814 (toggle: 0)
Sep 30 12:29:06 holden-desktop kernel: [ 1188.370044] ir_g_keycode_from_table: saa7134 IR (ASUSTeK P7131 Hybri: scancode 0x0814 keycode 0x04
Sep 30 12:29:06 holden-desktop kernel: [ 1188.370050] ir_keydown: saa7134 IR (ASUSTeK P7131 Hybri: key down event, key 0x0004, scancode 0x0814
Sep 30 12:29:06 holden-desktop kernel: [ 1188.370087] ir_rc5_decode: RC5 scancode 0x0814 (toggle: 0)
Sep 30 12:29:06 holden-desktop kernel: [ 1188.370092] ir_g_keycode_from_table: saa7134 IR (ASUSTeK P7131 Hybri: scancode 0x0814 keycode 0x04
Sep 30 12:29:06 holden-desktop kernel: [ 1188.620015] ir_keyup: keyup key 0x0004
Sep 30 12:29:11 holden-desktop kernel: [ 1193.930036] ir_rc5_decode: RC5 scancode 0x0836 (toggle: 1)
Sep 30 12:29:11 holden-desktop kernel: [ 1193.930044] ir_g_keycode_from_table: saa7134 IR (ASUSTeK P7131 Hybri: scancode 0x0836 keycode 0x05
Sep 30 12:29:11 holden-desktop kernel: [ 1193.930051] ir_keydown: saa7134 IR (ASUSTeK P7131 Hybri: key down event, key 0x0005, scancode 0x0836
Sep 30 12:29:11 holden-desktop kernel: [ 1193.930087] ir_rc5_decode: RC5 scancode 0x0836 (toggle: 1)
Sep 30 12:29:11 holden-desktop kernel: [ 1193.930093] ir_g_keycode_from_table: saa7134 IR (ASUSTeK P7131 Hybri: scancode 0x0836 keycode 0x05
Sep 30 12:29:11 holden-desktop kernel: [ 1194.180024] ir_keyup: keyup key 0x0005
Sep 30 12:29:16 holden-desktop kernel: [ 1199.210049] ir_rc5_decode: RC5 scancode 0x0832 (toggle: 0)
Sep 30 12:29:16 holden-desktop kernel: [ 1199.210058] ir_g_keycode_from_table: saa7134 IR (ASUSTeK P7131 Hybri: scancode 0x0832 keycode 0x06
Sep 30 12:29:16 holden-desktop kernel: [ 1199.210064] ir_keydown: saa7134 IR (ASUSTeK P7131 Hybri: key down event, key 0x0006, scancode 0x0832
Sep 30 12:29:17 holden-desktop kernel: [ 1199.460021] ir_keyup: keyup key 0x0006
Sep 30 12:29:23 holden-desktop kernel: [ 1205.650115] ir_rc5_decode: RC5 scancode 0x0834 (toggle: 1)
Sep 30 12:29:23 holden-desktop kernel: [ 1205.650123] ir_g_keycode_from_table: saa7134 IR (ASUSTeK P7131 Hybri: scancode 0x0834 keycode 0x07
Sep 30 12:29:23 holden-desktop kernel: [ 1205.650129] ir_keydown: saa7134 IR (ASUSTeK P7131 Hybri: key down event, key 0x0007, scancode 0x0834
Sep 30 12:29:23 holden-desktop kernel: [ 1205.900015] ir_keyup: keyup key 0x0007
Sep 30 12:29:28 holden-desktop kernel: [ 1210.890032] ir_rc5_decode: RC5 scancode 0x080e (toggle: 0)
Sep 30 12:29:28 holden-desktop kernel: [ 1210.890040] ir_g_keycode_from_table: saa7134 IR (ASUSTeK P7131 Hybri: scancode 0x080e keycode 0x08
Sep 30 12:29:28 holden-desktop kernel: [ 1210.890047] ir_keydown: saa7134 IR (ASUSTeK P7131 Hybri: key down event, key 0x0008, scancode 0x080e
Sep 30 12:29:28 holden-desktop kernel: [ 1211.140024] ir_keyup: keyup key 0x0008
Sep 30 12:29:35 holden-desktop kernel: [ 1217.620029] ir_rc5_decode: RC5 scancode 0x080a (toggle: 1)
Sep 30 12:29:35 holden-desktop kernel: [ 1217.620038] ir_g_keycode_from_table: saa7134 IR (ASUSTeK P7131 Hybri: scancode 0x080a keycode 0x09
Sep 30 12:29:35 holden-desktop kernel: [ 1217.620044] ir_keydown: saa7134 IR (ASUSTeK P7131 Hybri: key down event, key 0x0009, scancode 0x080a
Sep 30 12:29:35 holden-desktop kernel: [ 1217.870029] ir_keyup: keyup key 0x0009
Sep 30 12:29:41 holden-desktop kernel: [ 1224.160038] ir_rc5_decode: RC5 scancode 0x080c (toggle: 0)
Sep 30 12:29:41 holden-desktop kernel: [ 1224.160046] ir_g_keycode_from_table: saa7134 IR (ASUSTeK P7131 Hybri: scancode 0x080c keycode 0x0a
Sep 30 12:29:41 holden-desktop kernel: [ 1224.160053] ir_keydown: saa7134 IR (ASUSTeK P7131 Hybri: key down event, key 0x000a, scancode 0x080c
Sep 30 12:29:42 holden-desktop kernel: [ 1224.410016] ir_keyup: keyup key 0x000a

All the other keys work as well. Regards,

Giorgio Vazzana

---

saa7134: port Asus P7131 Hybrid to use the new rc-core

The rc map table were corrected thanks to Giorgio input.

Tested-by: Giorgio Vazzana <mywing81@gmail.com>

diff --git a/drivers/media/IR/keymaps/rc-asus-pc39.c b/drivers/media/IR/keymaps/rc-asus-pc39.c
index 2aa068c..2996e0a 100644
--- a/drivers/media/IR/keymaps/rc-asus-pc39.c
+++ b/drivers/media/IR/keymaps/rc-asus-pc39.c
@@ -20,56 +20,56 @@
 
 static struct ir_scancode asus_pc39[] = {
 	/* Keys 0 to 9 */
-	{ 0x15, KEY_0 },
-	{ 0x29, KEY_1 },
-	{ 0x2d, KEY_2 },
-	{ 0x2b, KEY_3 },
-	{ 0x09, KEY_4 },
-	{ 0x0d, KEY_5 },
-	{ 0x0b, KEY_6 },
-	{ 0x31, KEY_7 },
-	{ 0x35, KEY_8 },
-	{ 0x33, KEY_9 },
+	{ 0x082a, KEY_0 },
+	{ 0x0816, KEY_1 },
+	{ 0x0812, KEY_2 },
+	{ 0x0814, KEY_3 },
+	{ 0x0836, KEY_4 },
+	{ 0x0832, KEY_5 },
+	{ 0x0834, KEY_6 },
+	{ 0x080e, KEY_7 },
+	{ 0x080a, KEY_8 },
+	{ 0x080c, KEY_9 },
 
-	{ 0x3e, KEY_RADIO },		/* radio */
-	{ 0x03, KEY_MENU },		/* dvd/menu */
-	{ 0x2a, KEY_VOLUMEUP },
-	{ 0x19, KEY_VOLUMEDOWN },
-	{ 0x37, KEY_UP },
-	{ 0x3b, KEY_DOWN },
-	{ 0x27, KEY_LEFT },
-	{ 0x2f, KEY_RIGHT },
-	{ 0x25, KEY_VIDEO },		/* video */
-	{ 0x39, KEY_AUDIO },		/* music */
+	{ 0x0801, KEY_RADIO },		/* radio */
+	{ 0x083c, KEY_MENU },		/* dvd/menu */
+	{ 0x0815, KEY_VOLUMEUP },
+	{ 0x0826, KEY_VOLUMEDOWN },
+	{ 0x0808, KEY_UP },
+	{ 0x0804, KEY_DOWN },
+	{ 0x0818, KEY_LEFT },
+	{ 0x0810, KEY_RIGHT },
+	{ 0x081a, KEY_VIDEO },		/* video */
+	{ 0x0806, KEY_AUDIO },		/* music */
 
-	{ 0x21, KEY_TV },		/* tv */
-	{ 0x1d, KEY_EXIT },		/* back */
-	{ 0x0a, KEY_CHANNELUP },	/* channel / program + */
-	{ 0x1b, KEY_CHANNELDOWN },	/* channel / program - */
-	{ 0x1a, KEY_ENTER },		/* enter */
+	{ 0x081e, KEY_TV },		/* tv */
+	{ 0x0822, KEY_EXIT },		/* back */
+	{ 0x0835, KEY_CHANNELUP },	/* channel / program + */
+	{ 0x0824, KEY_CHANNELDOWN },	/* channel / program - */
+	{ 0x0825, KEY_ENTER },		/* enter */
 
-	{ 0x06, KEY_PAUSE },		/* play/pause */
-	{ 0x1e, KEY_PREVIOUS },		/* rew */
-	{ 0x26, KEY_NEXT },		/* forward */
-	{ 0x0e, KEY_REWIND },		/* backward << */
-	{ 0x3a, KEY_FASTFORWARD },	/* forward >> */
-	{ 0x36, KEY_STOP },
-	{ 0x2e, KEY_RECORD },		/* recording */
-	{ 0x16, KEY_POWER },		/* the button that reads "close" */
+	{ 0x0839, KEY_PAUSE },		/* play/pause */
+	{ 0x0821, KEY_PREVIOUS },		/* rew */
+	{ 0x0819, KEY_NEXT },		/* forward */
+	{ 0x0831, KEY_REWIND },		/* backward << */
+	{ 0x0805, KEY_FASTFORWARD },	/* forward >> */
+	{ 0x0809, KEY_STOP },
+	{ 0x0811, KEY_RECORD },		/* recording */
+	{ 0x0829, KEY_POWER },		/* the button that reads "close" */
 
-	{ 0x11, KEY_ZOOM },		/* full screen */
-	{ 0x13, KEY_MACRO },		/* recall */
-	{ 0x23, KEY_HOME },		/* home */
-	{ 0x05, KEY_PVR },		/* picture */
-	{ 0x3d, KEY_MUTE },		/* mute */
-	{ 0x01, KEY_DVD },		/* dvd */
+	{ 0x082e, KEY_ZOOM },		/* full screen */
+	{ 0x082c, KEY_MACRO },		/* recall */
+	{ 0x081c, KEY_HOME },		/* home */
+	{ 0x083a, KEY_PVR },		/* picture */
+	{ 0x0802, KEY_MUTE },		/* mute */
+	{ 0x083e, KEY_DVD },		/* dvd */
 };
 
 static struct rc_keymap asus_pc39_map = {
 	.map = {
 		.scan    = asus_pc39,
 		.size    = ARRAY_SIZE(asus_pc39),
-		.ir_type = IR_TYPE_UNKNOWN,	/* Legacy IR type */
+		.ir_type = IR_TYPE_RC5,
 		.name    = RC_MAP_ASUS_PC39,
 	}
 };
diff --git a/drivers/media/video/saa7134/saa7134-input.c b/drivers/media/video/saa7134/saa7134-input.c
index 0b336ca..24677f2 100644
--- a/drivers/media/video/saa7134/saa7134-input.c
+++ b/drivers/media/video/saa7134/saa7134-input.c
@@ -772,8 +772,10 @@ int saa7134_input_init1(struct saa7134_dev *dev)
 	case SAA7134_BOARD_ASUSTeK_P7131_HYBRID_LNA:
 	case SAA7134_BOARD_ASUSTeK_P7131_ANALOG:
 		ir_codes     = RC_MAP_ASUS_PC39;
-		mask_keydown = 0x0040000;
-		rc5_gpio = 1;
+		mask_keydown = 0x0040000;	/* Enable GPIO18 line on both edges */
+		mask_keyup   = 0x0040000;
+		mask_keycode = 0xffff;
+		raw_decode   = 1;
 		break;
 	case SAA7134_BOARD_ENCORE_ENLTV:
 	case SAA7134_BOARD_ENCORE_ENLTV_FM:
