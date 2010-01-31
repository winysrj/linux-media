Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:53668 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753091Ab0AaUdl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 31 Jan 2010 15:33:41 -0500
Received: by bwz27 with SMTP id 27so2576351bwz.21
        for <linux-media@vger.kernel.org>; Sun, 31 Jan 2010 12:33:40 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 31 Jan 2010 21:33:40 +0100
Message-ID: <f509f3091001311233s4991ac2bn9c0a527f57501dae@mail.gmail.com>
Subject: Twinhan dtv 3030 mantis dvb-t
From: Niklas Claesson <nicke.claesson@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,
I'm trying to use this tv-card with ubuntu 9.10. I've installed Manu's
drivers from http://jusst.de/hg/mantis-v4l-dvb/ and did "modprobe
mantis" which resulted in the following in /var/log/messages

Jan 31 20:57:40 niklas-desktop kernel: [  179.000227] Mantis
0000:05:02.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
Jan 31 20:57:40 niklas-desktop kernel: [  179.001234] DVB: registering
new adapter (Mantis DVB adapter)
Jan 31 20:57:41 niklas-desktop kernel: [  179.672664] *pde = bac3e067
Jan 31 20:57:41 niklas-desktop kernel: [  179.672676] Modules linked
in: mantis(+) mantis_core ir_common ir_core tda665x lnbp21 mb86a16
stb6100 tda10021 tda10023 zl10353 stb0899 stv0299 dvb_core joydev hidp
binfmt_misc ppdev bridge stp bnep arc4 ecb snd_hda_codec_analog
rtl8187 mac80211 led_class eeprom_93cx6 snd_hda_intel snd_hda_codec
snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm usblp snd_seq_dummy
iptable_filter ip_tables x_tables btusb cfg80211 asus_atk0110
lirc_imon lirc_dev lp parport snd_seq_oss snd_seq_midi snd_rawmidi
snd_seq_midi_event snd_seq snd_timer snd_seq_device snd soundcore
snd_page_alloc nvidia(P) usbhid skge ohci1394 ieee1394 sky2 intel_agp
agpgart
Jan 31 20:57:41 niklas-desktop kernel: [  179.672743]
Jan 31 20:57:41 niklas-desktop kernel: [  179.672748] Pid: 2768, comm:
modprobe Tainted: P           (2.6.31-17-generic #54-Ubuntu) System
Product Name
Jan 31 20:57:41 niklas-desktop kernel: [  179.672752] EIP:
0060:[<f8517480>] EFLAGS: 00010292 CPU: 1
Jan 31 20:57:41 niklas-desktop kernel: [  179.672761] EIP is at
dvb_unregister_frontend+0x10/0xe0 [dvb_core]
Jan 31 20:57:41 niklas-desktop kernel: [  179.672764] EAX: 00000000
EBX: f398f800 ECX: f6a51cc0 EDX: 00000000
Jan 31 20:57:41 niklas-desktop kernel: [  179.672767] ESI: 00000000
EDI: f398f9fc EBP: f4983dec ESP: f4983dc8
Jan 31 20:57:41 niklas-desktop kernel: [  179.672771]  DS: 007b ES:
007b FS: 00d8 GS: 00e0 SS: 0068
Jan 31 20:57:41 niklas-desktop kernel: [  179.672779]  f4983dec
f851c07e f398f800 00000000 f398f9fc f4983dec f398f800 f398f800
Jan 31 20:57:41 niklas-desktop kernel: [  179.672797] <0> ffffffff
f4983e2c f85955d5 f70fc858 f8599b50 f398f800 00000000 f398fc70
Jan 31 20:57:41 niklas-desktop kernel: [  179.672804] <0> f398f848
f398fc64 f398fc58 f85a9500 f398fbfc f398f9ac f398f800 00000000
Jan 31 20:57:41 niklas-desktop kernel: [  179.672820]  [<f851c07e>] ?
dvb_net_release+0x1e/0xb0 [dvb_core]
Jan 31 20:57:41 niklas-desktop kernel: [  179.672827]  [<f85955d5>] ?
mantis_dvb_init+0x398/0x3de [mantis_core]
Jan 31 20:57:41 niklas-desktop kernel: [  179.672833]  [<f85a6606>] ?
mantis_pci_probe+0x1d7/0x2f8 [mantis]
Jan 31 20:57:41 niklas-desktop kernel: [  179.672839]  [<c03285ae>] ?
local_pci_probe+0xe/0x10
Jan 31 20:57:41 niklas-desktop kernel: [  179.672843]  [<c0329330>] ?
pci_device_probe+0x60/0x80
Jan 31 20:57:41 niklas-desktop kernel: [  179.672848]  [<c03a2e30>] ?
really_probe+0x50/0x140
Jan 31 20:57:41 niklas-desktop kernel: [  179.672852]  [<c0570cea>] ?
_spin_lock_irqsave+0x2a/0x40
Jan 31 20:57:41 niklas-desktop kernel: [  179.672855]  [<c03a2f39>] ?
driver_probe_device+0x19/0x20
Jan 31 20:57:41 niklas-desktop kernel: [  179.672859]  [<c03a2fb9>] ?
__driver_attach+0x79/0x80
Jan 31 20:57:41 niklas-desktop kernel: [  179.672862]  [<c03a2488>] ?
bus_for_each_dev+0x48/0x70
Jan 31 20:57:41 niklas-desktop kernel: [  179.672866]  [<c03a2cf9>] ?
driver_attach+0x19/0x20
Jan 31 20:57:41 niklas-desktop kernel: [  179.672869]  [<c03a2f40>] ?
__driver_attach+0x0/0x80
Jan 31 20:57:41 niklas-desktop kernel: [  179.672872]  [<c03a26df>] ?
bus_add_driver+0xbf/0x2a0
Jan 31 20:57:41 niklas-desktop kernel: [  179.672876]  [<c0329270>] ?
pci_device_remove+0x0/0x40
Jan 31 20:57:41 niklas-desktop kernel: [  179.672879]  [<c03a3245>] ?
driver_register+0x65/0x120
Jan 31 20:57:41 niklas-desktop kernel: [  179.672883]  [<c0329550>] ?
__pci_register_driver+0x40/0xb0
Jan 31 20:57:41 niklas-desktop kernel: [  179.672887]  [<f85a642d>] ?
mantis_init+0x17/0x19 [mantis]
Jan 31 20:57:41 niklas-desktop kernel: [  179.672890]  [<c010112c>] ?
do_one_initcall+0x2c/0x190
Jan 31 20:57:41 niklas-desktop kernel: [  179.672894]  [<f85a6416>] ?
mantis_init+0x0/0x19 [mantis]
Jan 31 20:57:41 niklas-desktop kernel: [  179.672899]  [<c0173711>] ?
sys_init_module+0xb1/0x1f0
Jan 31 20:57:41 niklas-desktop kernel: [  179.672903]  [<c01e83ed>] ?
sys_write+0x3d/0x70
Jan 31 20:57:41 niklas-desktop kernel: [  179.672906]  [<c010336c>] ?
syscall_call+0x7/0xb
Jan 31 20:57:41 niklas-desktop kernel: [  179.672961] ---[ end trace
035b3cc151b9cf1a ]---

I can't even get the drivers from http://jusst.de/hg/mantis/ to compile:

Kernel build directory is /lib/modules/2.6.31-17-generic/build
make -C /lib/modules/2.6.31-17-generic/build
SUBDIRS=/home/niklas/Hämtningar/mantis-5292a47772ad/v4l  modules
make[2]: Entering directory `/usr/src/linux-headers-2.6.31-17-generic'
  CC [M]  /home/niklas/Hämtningar/mantis-5292a47772ad/v4l/tuner-xc2028.o
In file included from
/home/niklas/Hämtningar/mantis-5292a47772ad/v4l/tuner-xc2028.h:10,
                 from
/home/niklas/Hämtningar/mantis-5292a47772ad/v4l/tuner-xc2028.c:21:
/home/niklas/Hämtningar/mantis-5292a47772ad/v4l/dvb_frontend.h:52:
error: field 'fe_params' has incomplete type
/home/niklas/Hämtningar/mantis-5292a47772ad/v4l/dvb_frontend.h:297:
warning: 'struct dvbfe_info' declared inside parameter list
/home/niklas/Hämtningar/mantis-5292a47772ad/v4l/dvb_frontend.h:297:
warning: its scope is only this definition or declaration, which is
probably not what you want
/home/niklas/Hämtningar/mantis-5292a47772ad/v4l/dvb_frontend.h:298:
warning: 'enum dvbfe_delsys' declared inside parameter list
/home/niklas/Hämtningar/mantis-5292a47772ad/v4l/dvb_frontend.h:299:
warning: 'enum dvbfe_delsys' declared inside parameter list
/home/niklas/Hämtningar/mantis-5292a47772ad/v4l/dvb_frontend.h:316:
error: field 'fe_events' has incomplete type
/home/niklas/Hämtningar/mantis-5292a47772ad/v4l/dvb_frontend.h:317:
error: field 'fe_params' has incomplete type
/home/niklas/Hämtningar/mantis-5292a47772ad/v4l/dvb_frontend.h:354:
warning: 'enum dvbfe_fec' declared inside parameter list
/home/niklas/Hämtningar/mantis-5292a47772ad/v4l/dvb_frontend.h:354:
warning: 'enum dvbfe_modulation' declared inside parameter list
/home/niklas/Hämtningar/mantis-5292a47772ad/v4l/dvb_frontend.h:359:
warning: 'enum dvbfe_delsys' declared inside parameter list
/home/niklas/Hämtningar/mantis-5292a47772ad/v4l/tuner-xc2028.c:49:
error: 'FIRMWARE_NAME_MAX' undeclared here (not in a function)
make[3]: *** [/home/niklas/Hämtningar/mantis-5292a47772ad/v4l/tuner-xc2028.o]
Error 1
make[2]: *** [_module_/home/niklas/Hämtningar/mantis-5292a47772ad/v4l] Error 2
make[2]: Leaving directory `/usr/src/linux-headers-2.6.31-17-generic'
make[1]: *** [default] Fel 2
make[1]: Lämnar katalogen "/home/niklas/Hämtningar/mantis-5292a47772ad/v4l"
make: *** [all] Fel 2

Am I doing something wrong?

Niklas Claesson
