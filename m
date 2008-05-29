Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from [213.161.191.158] (helo=patton.snap.tv)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <sigmund@snap.tv>) id 1K1lKx-0001vx-Gf
	for linux-dvb@linuxtv.org; Thu, 29 May 2008 18:50:47 +0200
Received: from [192.168.43.91] (rommel.snap.tv [192.168.43.91])
	(using TLSv1 with cipher RC4-MD5 (128/128 bits))
	(No client certificate requested)
	by patton.snap.tv (Postfix) with ESMTP id 29D6EF14007
	for <linux-dvb@linuxtv.org>; Thu, 29 May 2008 18:50:44 +0200 (CEST)
From: Sigmund Augdal <sigmund@snap.tv>
To: linux-dvb@linuxtv.org
Date: Thu, 29 May 2008 18:50:43 +0200
Message-Id: <1212079844.26238.22.camel@rommel.snap.tv>
Mime-Version: 1.0
Subject: [linux-dvb] Oops in tda10023
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

I just got this output when trying to load  budget-av with a satelco
easywatch dvb-c MK3 in the computer.
----
saa7146 (4) saa7146_i2c_writeout [irq]: timed out waiting for end of
xfer
BUG: unable to handle kernel NULL pointer dereference at virtual address
00000000
 printing eip:
f8fc011e
*pde = 00000000
Oops: 0000 [#1]
PREEMPT SMP 
Modules linked in: budget_av saa7146_vv videobuf_dma_sg videobuf_core
budget budget_core saa7146 dvb_usb_dibusb_mb dvb_usb_umt_010 ultracam
dvb_usb_nova_t_usb2 cpia_usb konicawc dvb_usb_a800 ibmcam quickcam_
messenger dvb_usb_dibusb_mc vicam dvb_usb_gl861 w9968cf ov511
dvb_usb_dtt200u cpia2 se401 dvb_usb_anysee pwc dvb_usb_digitv stv680
b2c2_flexcop_usb radio_si470x radio_maestro usbvideo cafe_ccic saa5249
dvb_u
sb_au6610 cx18 dvb_usb_m920x dvb_usb_dib0700 dvb_usb_vp702x et61x251
radio_maxiradio radio_gemtek_pci dsbr100 zc0301 dvb_usb_gp8psk
dvb_usb_cxusb dvb_usb_opera b2c2_flexcop_pci cpia dvb_usb_af9005 pvrusb2
us
bvision sn9c102 tuner ivtv zr364xx dvb_usb_vp7045 dvb_usb_ttusb2
saa5246a dvb_usb_dibusb_common wm8739 or51132 cx25840 videodev ttusb_dec
zr36060 ov7670 cinergyT2 cs5345 stv0299 upd64083 pluto2 au0828 dib300
0mc saa7115 vp27smpx dib7000m wm8775 dvb_usb upd64031a tvaudio
dvb_ttusb_budget dib7000p ir_kbd_i2c or51211 tlv320aic23b saa717x
b2c2_flexcop zr36050 cs53l32a tvp5150 saa7127 cx2341x lgdt330x zr36016
m52790 
ves1x93 adv7175 sp887x stv0297 bt856 compat_ioctl32 dib3000mb adv7170
tda8083 saa7185 s5h1409 lnbp21 ks0127 dibx000_common tea6415c tda10023
tua6100 saa7114 isl6421 tuner_3036 btcx_risc zl10353 tda10021 dvb_
usb_af9005_remote cx22702 cx22700 videocodec s5h1420 tda10086 mt352
mt312 v4l1_compat dvb_core isl6405 tda1004x tda9875 nxt200x mxl5005s
ves1820 bcm3510 vpx3220 v4l2_common dvb_pll au8522 v4l2_int_device sp8
870 tda9840 bt819 saa7110 ovcamchip l64781 tveeprom ir_common cx24110
saa7111 saa7191 bt866 dabusb tea6420 cx24123 ttpci_eeprom tda10048
tda826x dib0070 ttusbdecfe nxt6000 s5h1411 itd1000 ipv6 rtc button i2c
_algo_bit i2c_i801 i2c_core intel_agp agpgart shpchp pci_hotplug pcspkr
sg jfs pata_pcmcia pcmcia pcmcia_core sbp2 ohci1394 ieee1394 sl811_hcd
usbhid ff_memless ohci_hcd uhci_hcd usb_storage ehci_hcd usbcore
CPU:    0
EIP:    0060:[<f8fc011e>]    Not tainted VLI
EFLAGS: 00010286   (2.6.20-snaptv-r2489 #1)
EIP is at tda10023_writereg+0x73/0x91 [tda10023]
eax: 00000000   ebx: eac5dc00   ecx: e55ebd44   edx: 00000000
esi: f8f435bc   edi: f1b7a89c   ebp: 00000048   esp: e55ebd28
ds: 007b   es: 007b   ss: 0068
Process insmod (pid: 10503, ti=e55ea000 task=f2293570 task.ti=e55ea000)
Stack: f8e7a5e0 f1b7a8bc f8fc0cb0 00000000 00000033 fffffffb 0033f7c0
0000000c 
       00000002 e55ebd52 33000b01 eac5dc00 f8fc0b38 e55ebd6f f8fc0b01
f1b7a800 
       e8ae52c0 00000004 f8f404da f8f410e4 00000004 00000000 00000009
000000d6 
Call Trace:
 [<f8fc0b38>] tda10023_attach+0x37/0x117 [tda10023]
 [<f8fc0b01>] tda10023_attach+0x0/0x117 [tda10023]
 [<f8f404da>] budget_av_attach+0x7d4/0xabf [budget_av]
 [<f8e77464>] saa7146_init_one+0x445/0x566 [saa7146]
 [<c02a3bf9>] pci_device_probe+0x36/0x57
 [<c02f23ee>] really_probe+0x7f/0x103
 [<c02f24b6>] driver_probe_device+0x44/0xa5
 [<c02f258f>] __driver_attach+0x0/0x7f
 [<c02f25d8>] __driver_attach+0x49/0x7f
 [<c02f1adc>] bus_for_each_dev+0x33/0x55
 [<c02f22a8>] driver_attach+0x16/0x18
 [<c02f258f>] __driver_attach+0x0/0x7f
 [<c02f1d68>] bus_add_driver+0x5e/0x15f
 [<c02a3d5e>] __pci_register_driver+0x6e/0x9a
 [<c0138751>] sys_init_module+0x17ae/0x18f5
 [<c02558dd>] xfs_iunlock+0x51/0x6d
 [<c0102e16>] sysenter_past_esp+0x5f/0x85
 [<c0510033>] rt_mutex_slowlock+0x8e/0x446
 =======================
Code: 31 d2 83 f8 01 74 3b 89 44 24 14 0f b6 44 24 1a c7 44 24 08 b0 0c
fc f8 89 44 24 10 0f b6 44 24 1b 89 44 24 0c 8b 83 08 02 00 00 <8b> 00
c7 04 24 0d 0d fc f8 89 44 24 04 e8 23 f3 15 c7 ba 87 ff 
EIP: [<f8fc011e>] tda10023_writereg+0x73/0x91 [tda10023] SS:ESP
0068:e55ebd28
 
----
It seems the problem is that tda10023_writereg accesses
state.frontend.dvb->num in the error message. I guess tda10023_writereg
is called during initialization before state.frontend.dvb is properly
assigned.

Next question is of course if anyone have any idea why I get the i2c
timeout. I seem to get it quite often but not quite allways with this
card.

using latest hg v4l-dvb on a 2.6.20 kernel.

Best Regards

Sigmund Augdal


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
