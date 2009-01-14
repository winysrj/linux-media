Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from wf-out-1314.google.com ([209.85.200.171])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <mo.ucina@gmail.com>) id 1LMzMe-0007UN-HY
	for linux-dvb@linuxtv.org; Wed, 14 Jan 2009 07:36:36 +0100
Received: by wf-out-1314.google.com with SMTP id 27so441634wfd.17
	for <linux-dvb@linuxtv.org>; Tue, 13 Jan 2009 22:36:27 -0800 (PST)
Message-ID: <496D87E5.5040708@gmail.com>
Date: Wed, 14 Jan 2009 17:36:21 +1100
From: O&M Ugarcina <mo.ucina@gmail.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Problem with video4linux
Reply-To: mo.ucina@gmail.com
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

Hello Guys,

Just upgraded to newest kernel for fc8 as well as new v4l module 
video4linux-kmdl-2.6.26.8-57.fc8-20090106-88.0.1.fc8  via the ATRPMs 
repo . The  V4L software is from 20090106 and I could not use myth with 
it , when pressing watchtv nothing happens . I have 2 cards one based on 
cx88 and other on saa7146 neither would work . Got following error in 
/var/log/messages :

Jan 13 18:11:02 localhost kernel: cx88[0]: TV tuner type 4, Radio tuner 
type -1
Jan 13 18:11:02 localhost kernel: cx88[0]/2: cx2388x 8802 Driver Manager
Jan 13 18:11:02 localhost kernel: ACPI: PCI Interrupt 0000:04:02.2[A] -> 
GSI 23 (level, low) -> IRQ 23
Jan 13 18:11:02 localhost kernel: cx88[0]/2: found at 0000:04:02.2, rev: 
5, irq: 23, latency: 64, mmio: 0xfd000000
Jan 13 18:11:02 localhost kernel: cx88/2: cx2388x dvb driver version 
0.0.6 loaded
Jan 13 18:11:02 localhost kernel: cx88/2: registering cx8802 driver, 
type: dvb access: shared
Jan 13 18:11:02 localhost kernel: cx88[0]/2: subsystem: 18ac:db10, 
board: DViCO FusionHDTV DVB-T Plus [card=21]
Jan 13 18:11:02 localhost kernel: cx88[0]/2: cx2388x based DVB/ATSC card
Jan 13 18:11:02 localhost kernel: BUG: unable to handle kernel NULL 
pointer dereference at 00000000
Jan 13 18:11:02 localhost kernel: IP: [<c05024d1>] __list_add+0x22/0x4d
Jan 13 18:11:02 localhost kernel: *pde = bb5e0067
Jan 13 18:11:02 localhost kernel: Oops: 0000 [#1] SMP
Jan 13 18:11:02 localhost kernel: Modules linked in: cx88_dvb(+)(U) 
cx88_vp3054_i2c(U) videobuf_dvb(U) lnbp21(U) snd_hda_intel(+) 
snd_seq_dummy snd_seq_oss(+) snd_seq_midi_event snd_seq cx8800(+)(U) 
cx8802(U) snd_seq_device snd_pcm_oss snd_mixer_oss stv0299(U) cx88xx(U) 
snd_pcm snd_timer v4l2_common(U) snd_page_alloc i2c_algo_bit tveeprom(U) 
budget_ci(U) snd_hwdep videodev(U) v4l1_compat(U) btcx_risc(U) 
videobuf_dma_sg(U) snd budget_core(U) nvidia(P)(U) dvb_core(U) 
videobuf_core(U) saa7146(U) ttpci_eeprom(U) ir_common(U) ftdi_sio 
soundcore pcspkr iTCO_wdt parport_pc usbserial r8169 sr_mod parport 
i2c_i801 i2c_core sg cdrom floppy iTCO_vendor_support usb_storage 
dm_snapshot dm_zero dm_mirror dm_log dm_mod ata_piix ata_generic 
pata_acpi libata sd_mod scsi_mod ext3 jbd mbcache uhci_hcd ohci_hcd 
ehci_hcd [last unloaded: scsi_wait_scan]
Jan 13 18:11:02 localhost kernel:
Jan 13 18:11:02 localhost kernel: Pid: 1320, comm: modprobe Tainted: 
P          (2.6.26.8-57.fc8 #1)
Jan 13 18:11:02 localhost kernel: EIP: 0060:[<c05024d1>] EFLAGS: 
00010246 CPU: 0
Jan 13 18:11:02 localhost kernel: EIP is at __list_add+0x22/0x4d
Jan 13 18:11:02 localhost kernel: EAX: 00000000 EBX: f71fcdc4 ECX: 
f71bf920 EDX: 00000000
Jan 13 18:11:02 localhost kernel: ESI: f71bf920 EDI: f71bf91c EBP: 
f71fcdb8 ESP: f71fcdb0
Jan 13 18:11:02 localhost kernel:  DS: 007b ES: 007b FS: 00d8 GS: 0033 
SS: 0068
Jan 13 18:11:02 localhost kernel: Process modprobe (pid: 1320, 
ti=f71fc000 task=f7312580 task.ti=f71fc000)
Jan 13 18:11:02 localhost kernel: Stack: f71bf918 f71bf920 f71fcddc 
c062f389 f7312580 f8cf5800 0000003f f71fce38
Jan 13 18:11:02 localhost kernel:        f71bf918 f71bf918 00000001 
f71fcdec c062f25a f71fcdf8 f71bf910 f71fce00
Jan 13 18:11:02 localhost kernel:        f8c010f2 f7965010 00000001 
f7329b74 f71fce2c f8cf13a3 f7965000 f71bf800
Jan 13 18:11:02 localhost kernel: Call Trace:
Jan 13 18:11:02 localhost kernel:  [<c062f389>] ? 
__mutex_lock_slowpath+0x2e/0x80
Jan 13 18:11:02 localhost kernel:  [<c062f25a>] ? mutex_lock+0x29/0x2d
Jan 13 18:11:02 localhost kernel:  [<f8c010f2>] ? 
videobuf_dvb_get_frontend+0x14/0x3b [videobuf_dvb]
Jan 13 18:11:02 localhost kernel:  [<f8cf13a3>] ? 
cx8802_dvb_probe+0xcc/0x199a [cx88_dvb]
Jan 13 18:11:02 localhost kernel:  [<f8be900f>] ? 
cx8802_register_driver+0xda/0x1ca [cx8802]
Jan 13 18:11:02 localhost kernel:  [<f8be9050>] ? 
cx8802_register_driver+0x11b/0x1ca [cx8802]
Jan 13 18:11:02 localhost kernel:  [<f8cf2d08>] ? dvb_init+0x1d/0x1f 
[cx88_dvb]
Jan 13 18:11:02 localhost kernel:  [<c0446f32>] ? 
sys_init_module+0x16bd/0x182d
Jan 13 18:11:02 localhost kernel:  [<c0430c93>] ? msleep+0x0/0x16
Jan 13 18:11:02 localhost kernel:  [<c0404bde>] ? syscall_call+0x7/0xb
Jan 13 18:11:02 localhost kernel:  [<c043007b>] ? 
ptrace_report_clone+0x5b/0x101
Jan 13 18:11:02 localhost kernel:  [<c0630000>] ? 
rwsem_down_failed_common+0x89/0x159
Jan 13 18:11:02 localhost kernel:  =======================
Jan 13 18:11:02 localhost kernel: Code: 00 01 10 00 8b 5d fc c9 c3 55 89 
e5 56 53 89 c3 8b 41 04 39 d0 74 14 51 50 52 68 c3 94 6e c0 e8 b2 6d f2 
ff 0f 0b 83 c4 10 eb fe <8b> 32 39 ce 74 14 52 56 51 68 13 95 6e c0 e8 
98 6d f2 ff 0f 0b
Jan 13 18:11:02 localhost kernel: EIP: [<c05024d1>] __list_add+0x22/0x4d 
SS:ESP 0068:f71fcdb0
Jan 13 18:11:02 localhost kernel: ---[ end trace 7a95638960de9401 ]---
Jan 13 18:11:02 localhost kernel: ACPI: PCI Interrupt 0000:04:02.0[A] -> 
GSI 23 (level, low) -> IRQ 23
Jan 13 18:11:02 localhost kernel: cx88[0]/0: found at 0000:04:02.0, rev: 
5, irq: 23, latency: 64, mmio: 0xfc000000
Jan 13 18:11:02 localhost kernel: cx88[0]/0: registered device video0 
[v4l2]
Jan 13 18:11:02 localhost kernel: cx88[0]/0: registered device vbi0
Jan 13 18:11:02 localhost kernel: cx2388x alsa driver version 0.0.6 loaded
Jan 13 18:11:02 localhost kernel: NET: Registered protocol family 10
Jan 13 18:11:02 localhost kernel: lo: Disabled Privacy Extensions
Jan 13 18:11:02 localhost kernel: EXT3 FS on dm-0, internal journal
Jan 13 18:11:02 localhost kernel: kjournald starting.  Commit interval 5 
seconds
Jan 13 18:11:02 localhost kernel: EXT3 FS on sda1, internal journal
Jan 13 18:11:02 localhost kernel: EXT3-fs: mounted filesystem with 
ordered data mode.
Jan 13 18:11:02 localhost kernel: kjournald starting.  Commit interval 5 
seconds
Jan 13 18:11:02 localhost kernel: EXT3 FS on dm-1, internal journal
Jan 13 18:11:02 localhost kernel: EXT3-fs: mounted filesystem with 
ordered data mode.
Jan 13 18:11:02 localhost kernel: Adding 2031608k swap on 
/dev/mapper/VolGroup00-LogVol02.  Priority:-1 extents:1 across:2031608k
Jan 13 18:11:02 localhost kernel: Adding 4194296k swap on 
/storage/swapfile.  Priority:-2 extents:1166 across:29428172k
Jan 13 18:11:02 localhost kernel: warning: process `kudzu' used the 
deprecated sysctl system call with 1.23.
Jan 13 18:11:02 localhost kernel: r8169: eth0: link up
Jan 13 18:11:02 localhost kernel: r8169: eth0: link up


After going back to 
video4linux-kmdl-2.6.26.8-57.fc8-20081218-87.99.fc8.i686.rpm all working 
again , both cards. This module was built using v4l from 20081218 .

Best Regards
Milorad

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
