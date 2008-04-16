Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wf-out-1314.google.com ([209.85.200.173])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <rod@dailysnore.com>) id 1Jlvbt-0006wI-DV
	for linux-dvb@linuxtv.org; Wed, 16 Apr 2008 02:34:51 +0200
Received: by wf-out-1314.google.com with SMTP id 28so2193153wfa.17
	for <linux-dvb@linuxtv.org>; Tue, 15 Apr 2008 17:34:39 -0700 (PDT)
Message-Id: <5DE6BC0E-41BE-4A05-B387-444DDC8F7612@dailysnore.com>
From: Rod Telford <rod@dailysnore.com>
To: linux-dvb@linuxtv.org
Mime-Version: 1.0 (Apple Message framework v919.2)
Date: Wed, 16 Apr 2008 10:34:33 +1000
Subject: [linux-dvb] Avermedia DVB-S Hybrid+FM A700 help
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

Hello All,

I have been playing with the experimental patches from both Tino and  
Zzam over the last couple of days, with limited success. So far I have  
been unable to get a lock on any channels.

As a result of my most recent efforts I am getting the below error in  
dmesg after this I am unable to rmmod the dvb module and utils like  
szap just hang. Any help on this would be greatly appreciated.

My Config
--------------
- Ubuntu Server 7.10
- v4l cloned with hg changeset 7575
- zzam patch a700_full_20080412.diff
- xc3028-v27.fw extracted from the Steven Toth download (sha1sum:  
a7c98dada5fa6356ce47416612b3f73a43c57cba)


THE ERROR
-----------------
[   95.749478] saa7134 ALSA driver for DMA sound unloaded
[  136.017905] saa7130/34: v4l2 driver version 0.2.14 loaded
[  136.017943] saa7133[0]: found at 0000:02:02.0, rev: 209, irq: 22,  
latency: 64, mmio: 0xf8fdf800
[  136.017949] saa7133[0]: subsystem: 1461:a7a2, board: Avermedia DVB- 
S Hybrid+FM A700 [card=141,insmod option]
[  136.017958] saa7133[0]: board init: gpio is 6a6eb00
[  136.409568] saa7133[0]: i2c eeprom 00: 61 14 a2 a7 ff ff ff ff ff  
ff ff ff ff ff ff ff
[  136.409579] saa7133[0]: i2c eeprom 10: ff ff ff ff ff ff ff ff ff  
ff ff ff ff ff ff ff
[  136.409587] saa7133[0]: i2c eeprom 20: ff ff ff ff ff ff ff ff ff  
ff ff ff ff ff ff ff
[  136.409596] saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff  
ff ff ff ff ff ff ff
[  136.409604] saa7133[0]: i2c eeprom 40: ff ff ff ff ff ff ff ff ff  
ff ff ff ff ff ff ff
[  136.409613] saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff  
ff ff ff ff ff ff ff
[  136.409621] saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff  
ff ff ff ff ff ff ff
[  136.409630] saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff  
ff ff ff ff ff ff ff
[  136.409639] saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff  
ff ff ff ff ff ff ff
[  136.409647] saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff  
ff ff ff ff ff ff ff
[  136.409656] saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff  
ff ff ff ff ff ff ff
[  136.409664] saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff  
ff ff ff ff ff ff ff
[  136.409673] saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff  
ff ff ff ff ff ff ff
[  136.409681] saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff  
ff ff ff ff ff ff ff
[  136.409689] saa7133[0]: i2c eeprom e0: 00 01 81 b0 09 9e ff ff ff  
ff ff ff ff ff ff ff
[  136.409698] saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff  
ff ff ff ff ff ff ff
[  136.420225] saa7133[0]: registered device video2 [v4l2]
[  136.420244] saa7133[0]: registered device vbi2
[  136.420263] saa7133[0]: registered device radio0
[  136.435529] saa7134 ALSA driver for DMA sound loaded
[  136.435555] saa7133[0]/alsa: saa7133[0] at 0xf8fdf800 irq 22  
registered as card -2
[  136.495965] zl1003x_attach: Warning, unsupported silicon tuner!
[  136.495988] saa7133[0]/dvb: dvb_init: No zl1003x found!
[  136.495991] DVB: registering new adapter (saa7133[0])
[  136.495994] DVB: registering frontend 2 (Zarlink ZL10313 DVB-S)...
[  136.878384] BUG: unable to handle kernel NULL pointer dereference  
at virtual address 00000000
[  136.878495]  printing eip:
[  136.878543] fae31035
[  136.878544] *pdpt = 0000000037d78001
[  136.878592] *pde = 0000000000000000
[  136.878642] Oops: 0000 [#1]
[  136.878689] SMP
[  136.878804] Modules linked in: zl1003x saa7134_dvb saa7134_alsa  
saa7134 af_packet jfs lp loop mt312 tuner tea5767 tda8290 tda18271  
tda827x tuner_xc2028 xc5000 tda9887 tuner_simple tuner_types mt20xx  
tea5761 snd_intel8x0 snd_ac97_codec ac97_bus dvb_pll cx22702  
snd_pcm_oss snd_mixer_oss cx88_dvb cx88_vp3054_i2c videobuf_dvb  
dvb_core snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi  
snd_seq_midi_event snd_seq snd_timer snd_seq_device serio_raw pcspkr  
parport_pc parport psmouse ir_kbd_i2c cx8802 snd soundcore cx8800  
cx88xx ir_common i2c_algo_bit videodev v4l1_compat compat_ioctl32  
v4l2_common tveeprom btcx_risc videobuf_dma_sg videobuf_core  
snd_page_alloc i2c_core iTCO_wdt i82875p_edac edac_mc ipv6  
iTCO_vendor_support intel_agp agpgart shpchp pci_hotplug evdev ext3  
jbd mbcache sg sd_mod sr_mod cdrom ata_piix floppy e1000 ata_generic  
libata scsi_mod ehci_hcd uhci_hcd usbcore thermal processor fan fuse  
apparmor commoncap
[  136.882402] CPU:    0
[  136.882403] EIP:    0060:[<fae31035>]    Not tainted VLI
[  136.882404] EFLAGS: 00010246   (2.6.22-14-server #1)
[  136.882551] EIP is at zl1003x_write+0x25/0x1a0 [zl1003x]
[  136.882601] eax: 000000f0   ebx: 00000000   ecx: 00000002   edx:  
000000f0
[  136.882654] esi: 0000000c   edi: f7d7be5e   ebp: f7c50408   esp:  
f7d7be24
[  136.882706] ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
[  136.882758] Process modprobe (pid: 4653, ti=f7d7a000 task=f7b4f4c0  
task.ti=f7d7a000)
[  136.882811] Stack: f7d7be10 f7d7be20 f7c50400 02d7be1c 0000000e  
df970002 f7d7be20 f7c50408
[  136.883185]        df97c000 df97c0fc f7c50408 fae311ee 00000001  
8c0c0000 80f00000 00000000
[  136.883560]        fb0c1687 df8d7848 fb0c5cc0 fb0c3744 00000078  
df97c000 c047aaac c047aab0
[  136.883934] Call Trace:
[  136.884048]  [<fae311ee>] zl1003x_sleep+0x3e/0x50 [zl1003x]
[  136.884143]  [<fb0c1687>] dvb_init+0x107/0x15a0 [saa7134_dvb]
[  136.884248]  [<c0148fd0>] __link_module+0x0/0x20
[  136.884339]  [<c02fa5ca>] wait_for_completion+0x9a/0xe0
[  136.884432]  [<c01227a0>] default_wake_function+0x0/0x10
[  136.884529]  [<f9b40e5c>] mpeg_ops_attach+0x3c/0x50 [saa7134]
[  136.884628]  [<f9b41aeb>] saa7134_ts_register+0x2b/0x70 [saa7134]
[  136.884723]  [<c014a501>] sys_init_module+0x151/0x1a00
[  136.884862]  [<c0171c79>] do_mmap_pgoff+0x599/0x7f0
[  136.885018]  [<c010418a>] sysenter_past_esp+0x6b/0xa1
[  136.885121]  [<c013007b>] __ptrace_link+0x6b/0x70
[  136.885227]  =======================
[  136.885274] Code: 02 31 c0 c3 66 90 55 89 c5 57 89 d7 56 be 02 00  
00 00 53 83 ec 1c 88 4c 24 0f 8b 98 08 02 00 00 0f b6 02 84 c0 0f 88  
c5 00 00 00 <8b> 03 66 c7 44 24 12 00 00 89 7c 24 18 66 89 44 24 10 66  
0f b6
[  136.887600] EIP: [<fae31035>] zl1003x_write+0x25/0x1a0 [zl1003x]  
SS:ESP 0068:f7d7be24


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
