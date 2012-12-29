Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f51.google.com ([74.125.83.51]:62086 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654Ab2L2EdO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 28 Dec 2012 23:33:14 -0500
Received: by mail-ee0-f51.google.com with SMTP id d4so5340120eek.24
        for <linux-media@vger.kernel.org>; Fri, 28 Dec 2012 20:33:13 -0800 (PST)
Message-ID: <50DE70CB.5020107@gmail.com>
Date: Sat, 29 Dec 2012 05:25:47 +0100
From: thomas schorpp <thomas.schorpp@gmail.com>
Reply-To: thomas.schorpp@gmail.com
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: j@jannau.net, jarod@redhat.com
Subject: [BUG] crystalhd git.linuxtv.org kernel driver: NULL pointer deref
 in bc_cproc_reset_stats() after crashing bino3d
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello guys,

I'm working on supporting BCM 970012/15 crystalhd decoder in userspace video/tv apps and

can't find where to report bugs of

http://git.linuxtv.org/jarod/crystalhd.git
<devinheitmueller> I think he just borrowed our git server.

So I borrow this list to get more developers, testers and sw- quality guys in.

Got a double free null pointer deref OOPS in chd_dec_free_iodata on crashing bino3d using crystalhd driver on
debian wheezy
Linux vdr1 3.6.10-PM #8 PREEMPT Sat Dec 15 00:54:11 CET 2012 i686 GNU/Linux
crystalhd driver+lib, libavcodec crystalhd.c git HEAD but libavcodec53

reproducible and only occuring after
Dec 27 12:12:17 vdr1 kernel: [33147.169731] crystalhd_hw_stats: Invalid Arguments
log message.

System not crashing, driver still usable.

Note: I've disabled the legacy h264 software codec in libavcodec53 to force every app using h264_crystalhd for h.264 with
my backport patch -Attached- from ffmpeg git HEAD of yesterday to libavcodec.so.53.61.100 , debian src ffmpeg 7:0.10.3-dmo1 0
using
./configure ... --disable-decoder='h264,h264_vdpau,h264_vda'
to automate testing of (lib)crystalhd(.ko) with all apps requesting libavcodec h.264 ;-)
Don't worry, I've left the "childlock" in the patch to not get this patch in any distro.

y
tom

-Att: Kernel OOPS bt, etc

Dec 27 12:11:57 vdr1 kernel: [33127.022053] crystalhd 0000:02:00.0: Opening new user[0] handle
Dec 27 12:12:00 vdr1 kernel: [33129.862089] start_capture: pause_th:12, resume_th:5
Dec 27 12:12:00 vdr1 kernel: [33130.273355] crystalhd 0000:02:00.0: Closing user[0] handle via ioctl with mode 1417200
Dec 27 12:12:00 vdr1 kernel: [33130.589582] crystalhd 0000:02:00.0: Opening new user[0] handle
Dec 27 12:12:03 vdr1 kernel: [33133.464029] start_capture: pause_th:12, resume_th:5
Dec 27 12:12:17 vdr1 kernel: [33146.856414] crystalhd 0000:02:00.0: Closing user[0] handle with mode 1417200
Dec 27 12:12:17 vdr1 kernel: [33147.169731] crystalhd_hw_stats: Invalid Arguments
Dec 27 12:12:17 vdr1 kernel: [33147.169778] BUG: unable to handle kernel NULL pointer dereference at 00000040
Dec 27 12:12:17 vdr1 kernel: [33147.170259] IP: [<c11848d8>] do_raw_spin_trylock+0x8/0x50
Dec 27 12:12:17 vdr1 kernel: [33147.170621] *pdpt = 000000002b9cb001 *pde = 0000000000000000
Dec 27 12:12:17 vdr1 kernel: [33147.170622] Oops: 0000 [#1] PREEMPT
Dec 27 12:12:17 vdr1 kernel: [33147.170622] Modules linked in: dvb_ttpci md5 crypto_hash cpufreq_stats cpufreq_powersave cpufreq_userspace cpufreq_conservative bnep rfcomm bluetooth crc16 binfmt_misc uinput fuse nfsd exportfs auth_rpcgss nfs_acl nfs lockd sunrpc nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack xt_limit iptable_filter ip_tables af_packet ipv6 w83627ehf hwmon_vid hwmon uvcvideo isl6405 dvb_pll tda10086 saa7134_dvb tuner videobuf_dvb tda10021 saa7134 stv0297 snd_usb_audio cryptomgr aead arc4 crypto_blkcipher crypto_algapi snd_usbmidi_lib snd_hwdep rt73usb rt2x00usb rt2x00lib snd_pcm_oss budget_av snd_intel8x0 saa7146_vv budget_core ttpci_eeprom snd_ac97_codec saa7146 mac80211 ac97_bus snd_mixer_oss snd_seq_dummy snd_pcm snd_seq_oss cfg80211 dvb_core tveeprom videobuf2_vmalloc videobuf2_memops videobuf_dma_sg videobuf2_core snd_page_alloc snd_seq_midi joydev videobuf_core v4l2_common crc_itu_t crypto snd_ra

wmidi videodev snd_seq_mid
Dec 27 12:12:17 vdr1 kernel: i_event snd_seq rc_core shpchp snd_seq_device snd_timer snd serio_raw i2c_i801 pcspkr pci_hotplug rng_core crystalhd(O) 8250_pnp soundcore 8250 serial_core acpi_cpufreq mperf processor evdev ext3 mbcache jbd sg sr_mod sd_mod cdrom crc_t10dif hid_generic hid_sunplus usbhid hid ata_piix ahci libahci uhci_hcd ehci_hcd libata scsi_mod usbcore [last unloaded: dvb_ttpci]
Dec 27 12:12:17 vdr1 kernel: [33147.170622] Pid: 23337, comm: bino Tainted: G           O 3.6.10-PM #8    /Alviso
Dec 27 12:12:17 vdr1 kernel: [33147.170622] EIP: 0060:[<c11848d8>] EFLAGS: 00210046 CPU: 0
Dec 27 12:12:17 vdr1 kernel: [33147.170622] EIP is at do_raw_spin_trylock+0x8/0x50
Dec 27 12:12:17 vdr1 kernel: [33147.170622] EAX: 00000040 EBX: 00000000 ECX: 00000040 EDX: 00000000
Dec 27 12:12:17 vdr1 kernel: [33147.170622] ESI: 00000040 EDI: 00200292 EBP: f5379e5c ESP: f5379e58
Dec 27 12:12:17 vdr1 kernel: [33147.170622]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Dec 27 12:12:17 vdr1 kernel: [33147.170622] CR0: 8005003b CR2: 00000040 CR3: 315c7000 CR4: 000007f0
Dec 27 12:12:17 vdr1 kernel: [33147.170622] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
Dec 27 12:12:17 vdr1 kernel: [33147.170622] DR6: ffff0ff0 DR7: 00000400
Dec 27 12:12:17 vdr1 kernel: [33147.170622] Process bino (pid: 23337, ti=f5378000 task=f59e2940 task.ti=f5378000)
Dec 27 12:12:17 vdr1 kernel: [33147.170622] Stack:
Dec 27 12:12:17 vdr1 kernel: [33147.170622]  00000050 f5379e80 c136c9b5 00000000 00000002 00000000 fa1f1bd6 f42e9400
Dec 27 12:12:17 vdr1 kernel: [33147.170622]  f595dc88 00000000 f5379ed8 fa1f1bd6 00000218 f5378000 00000000 f5379eb0
Dec 27 12:12:17 vdr1 kernel: [33147.170622]  c117e811 08679940 042e9400 f42e9400 00000000 08679940 f5379ed8 fa1ef3b9
Dec 27 12:12:17 vdr1 kernel: [33147.170622] Call Trace:
Dec 27 12:12:17 vdr1 kernel: [33147.170622]  [<c136c9b5>] _raw_spin_lock_irqsave+0x55/0x90
Dec 27 12:12:17 vdr1 kernel: [33147.170622]  [<fa1f1bd6>] ? bc_cproc_get_stats+0x226/0x280 [crystalhd]
Dec 27 12:12:17 vdr1 kernel: [33147.170622]  [<fa1f1bd6>] bc_cproc_get_stats+0x226/0x280 [crystalhd]
Dec 27 12:12:17 vdr1 kernel: [33147.170622]  [<c117e811>] ? _copy_from_user+0x41/0xb0
Dec 27 12:12:17 vdr1 kernel: [33147.170622]  [<fa1ef3b9>] ? chd_dec_proc_user_data+0x59/0x320 [crystalhd]
Dec 27 12:12:17 vdr1 kernel: [33147.170622]  [<fa1ef977>] ? chd_dec_alloc_iodata+0xf7/0x120 [crystalhd]
Dec 27 12:12:17 vdr1 kernel: [33147.170622]  [<fa1efb5e>] chd_dec_ioctl+0x16e/0x1c0 [crystalhd]
Dec 27 12:12:17 vdr1 kernel: [33147.170622]  [<fa1f19b0>] ? bc_cproc_reset_stats+0x20/0x20 [crystalhd]
Dec 27 12:12:17 vdr1 kernel: [33147.170622]  [<fa1ef9f0>] ? chd_dec_free_iodata+0x50/0x50 [crystalhd]
Dec 27 12:12:17 vdr1 kernel: [33147.170622]  [<c10f4355>] do_vfs_ioctl+0x535/0x580
Dec 27 12:12:17 vdr1 kernel: [33147.170622]  [<c104e73e>] ? hrtimer_nanosleep+0x6e/0xf0
Dec 27 12:12:17 vdr1 kernel: [33147.170622]  [<c10e4ab8>] ? fget_light+0xe8/0x120
Dec 27 12:12:17 vdr1 kernel: [33147.170622]  [<c10e4ad1>] ? fget_light+0x101/0x120
Dec 27 12:12:17 vdr1 kernel: [33147.170622]  [<c10e4a30>] ? fget_light+0x60/0x120
Dec 27 12:12:17 vdr1 kernel: [33147.170622]  [<c10f43cd>] sys_ioctl+0x2d/0x60
Dec 27 12:12:17 vdr1 kernel: [33147.170622]  [<c137238c>] sysenter_do_call+0x12/0x32
Dec 27 12:12:17 vdr1 kernel: [33147.170622]  [<c1360000>] ? asus_hides_smbus_hostbridge+0x264/0x269
Dec 27 12:12:17 vdr1 kernel: [33147.170622] Code: a2 66 90 c7 43 08 00 00 00 00 8b 75 f8 8b 7d fc a1 2c dc 4e c1 89 43 0c 8b 5d f4 89 ec 5d c3 8d 74 26 00 55 89 c1 89 e5 53 31 db <8b> 00 c7 01 00 00 00 00 84 c0 0f 9f c3 85 db 74 17 a1 2c dc 4e
Dec 27 12:12:17 vdr1 kernel: [33147.170622] EIP: [<c11848d8>] do_raw_spin_trylock+0x8/0x50 SS:ESP 0068:f5379e58
Dec 27 12:12:17 vdr1 kernel: [33147.170622] CR2: 0000000000000040
Dec 27 12:12:17 vdr1 kernel: [33147.170622] ---[ end trace 41db3e0e4ba186f9 ]---
Dec 27 12:12:17 vdr1 kernel: [33147.470034] note: bino[23337] exited with preempt_count 1
Dec 27 12:14:54 vdr1 kernel: [33304.694760] crystalhd 0000:02:00.0: Handle is already closed


Dec 28 01:44:24 vdr1 kernel: [81873.888316] crystalhd 0000:02:00.0: Closing user[0] handle via ioctl with mode 1417200
Dec 28 01:44:24 vdr1 kernel: [81874.194675] crystalhd 0000:02:00.0: Opening new user[0] handle
Dec 28 01:44:26 vdr1 kernel: [81876.705679] start_capture: pause_th:12, resume_th:5
Dec 28 01:44:37 vdr1 vdr: [15683] frontend 2/0 lost lock on channel 76, tp 212480
Dec 28 01:44:37 vdr1 vdr: [15683] frontend 2/0 regained lock on channel 76, tp 212480
Dec 28 01:44:59 vdr1 kernel: [81909.012564] crystalhd 0000:02:00.0: Closing user[0] handle with mode 1417200
Dec 28 01:45:00 vdr1 kernel: [81909.318416] crystalhd_hw_stats: Invalid Arguments
Dec 28 01:45:00 vdr1 kernel: [81909.318446] BUG: unable to handle kernel NULL pointer dereference at 00000040
Dec 28 01:45:00 vdr1 kernel: [81909.319394] IP: [<c11848d8>] do_raw_spin_trylock+0x8/0x50
Dec 28 01:45:00 vdr1 kernel: [81909.319394] *pdpt = 0000000014069001 *pde = 0000000000000000
6_tables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack xt_limit iptable_filter ip_tables af_packet ipv6 w83627ehf hwmon_vid hwmon uvcvideo isl6405 dvb_pll tda10086 saa7134_dvb tuner videobuf_dvb tda10021 saa7134 stv0297 snd_usb_audio cryptomgr aead arc4 crypto_blkcipher crypto_algapi snd_usbmidi_lib snd_hwdep rt73usb rt2x00usb rt2x00lib snd_pcm_oss budget_av snd_intel8x0 saa7146_vv budget_core ttpci_eeprom snd_ac97_codec saa7146 mac80211 ac97_bus snd_mixer_oss snd_seq_dummy snd_pcm snd_seq_oss cfg80211 dvb_core tveeprom videobuf2_vmalloc videobuf2_memops videobuf_dma_sg videobuf2_core snd_page_alloc snd_seq_midi joydev videobuf_core v4l2_common crc_itu_t crypto snd_rawmidi videodev snd_seq_mid
Dec 28 01:45:00 vdr1 kernel: i_event snd_seq rc_core shpchp snd_seq_device snd_timer snd serio_raw i2c_i801 pcspkr pci_hotplug rng_core crystalhd(O) 8250_pnp soundcore 8250 serial_core acpi_cpufreq mperf processor evdev ext3 mbcache jbd sg sr_mod sd_mod cdrom crc_t10dif hid_generic hid_sunplus usbhid hid ata_piix ahci libahci uhci_hcd ehci_hcd libata scsi_mod usbcore [last unloaded: dvb_ttpci]
Dec 28 01:45:00 vdr1 kernel: [81909.319394] Pid: 15899, comm: bino Tainted: G      D    O 3.6.10-PM #8    /Alviso
Dec 28 01:45:00 vdr1 kernel: [81909.319394] EIP: 0060:[<c11848d8>] EFLAGS: 00010046 CPU: 0
Dec 28 01:45:00 vdr1 kernel: [81909.319394] EIP is at do_raw_spin_trylock+0x8/0x50
Dec 28 01:45:00 vdr1 kernel: [81909.319394] EAX: 00000040 EBX: 00000000 ECX: 00000040 EDX: 00000000
Dec 28 01:45:00 vdr1 kernel: [81909.319394] ESI: 00000040 EDI: 00000292 EBP: d415fe5c ESP: d415fe58
Dec 28 01:45:00 vdr1 kernel: [81909.319394]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Dec 28 01:45:00 vdr1 kernel: [81909.319394] CR0: 8005003b CR2: 00000040 CR3: 34dae000 CR4: 000007f0
Dec 28 01:45:00 vdr1 kernel: [81909.319394] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
Dec 28 01:45:00 vdr1 kernel: [81909.319394] DR6: ffff0ff0 DR7: 00000400
Dec 28 01:45:00 vdr1 kernel: [81909.319394] Process bino (pid: 15899, ti=d415e000 task=c67a94a0 task.ti=d415e000)
Dec 28 01:45:00 vdr1 kernel: [81909.319394] Stack:
Dec 28 01:45:00 vdr1 kernel: [81909.319394]  00000050 d415fe80 c136c9b5 00000000 00000002 00000000 fa1f1bd6 f42e9800
Dec 28 01:45:00 vdr1 kernel: [81909.319394]  f595dc88 00000000 d415fed8 fa1f1bd6 00000218 d415e000 00000000 d415feb0
Dec 28 01:45:00 vdr1 kernel: [81909.319394]  c117e811 b0b08f98 042e9800 f42e9800 00000000 b0b08f98 d415fed8 fa1ef3b9
Dec 28 01:45:00 vdr1 kernel: [81909.319394] Call Trace:
Dec 28 01:45:00 vdr1 kernel: [81909.319394]  [<c136c9b5>] _raw_spin_lock_irqsave+0x55/0x90
Dec 28 01:45:00 vdr1 kernel: [81909.319394]  [<fa1f1bd6>] ? bc_cproc_get_stats+0x226/0x280 [crystalhd]
Dec 28 01:45:00 vdr1 kernel: [81909.319394]  [<fa1f1bd6>] bc_cproc_get_stats+0x226/0x280 [crystalhd]
Dec 28 01:45:00 vdr1 kernel: [81909.319394]  [<c117e811>] ? _copy_from_user+0x41/0xb0
Dec 28 01:45:00 vdr1 kernel: [81909.319394]  [<fa1ef3b9>] ? chd_dec_proc_user_data+0x59/0x320 [crystalhd]
Dec 28 01:45:00 vdr1 kernel: [81909.319394]  [<fa1ef977>] ? chd_dec_alloc_iodata+0xf7/0x120 [crystalhd]
Dec 28 01:45:00 vdr1 kernel: [81909.319394]  [<fa1efb5e>] chd_dec_ioctl+0x16e/0x1c0 [crystalhd]
Dec 28 01:45:00 vdr1 kernel: [81909.319394]  [<fa1f19b0>] ? bc_cproc_reset_stats+0x20/0x20 [crystalhd]
Dec 28 01:45:00 vdr1 kernel: [81909.319394]  [<fa1ef9f0>] ? chd_dec_free_iodata+0x50/0x50 [crystalhd]
Dec 28 01:45:00 vdr1 kernel: [81909.319394]  [<c10f4355>] do_vfs_ioctl+0x535/0x580
Dec 28 01:45:00 vdr1 kernel: [81909.319394]  [<c104e73e>] ? hrtimer_nanosleep+0x6e/0xf0
Dec 28 01:45:00 vdr1 kernel: [81909.319394]  [<c10e4ab8>] ? fget_light+0xe8/0x120
Dec 28 01:45:00 vdr1 kernel: [81909.319394]  [<c10e4ad1>] ? fget_light+0x101/0x120
Dec 28 01:45:00 vdr1 kernel: [81909.319394]  [<c10e4a30>] ? fget_light+0x60/0x120
Dec 28 01:45:00 vdr1 kernel: [81909.319394]  [<c10f43cd>] sys_ioctl+0x2d/0x60
Dec 28 01:45:00 vdr1 kernel: [81909.319394]  [<c137238c>] sysenter_do_call+0x12/0x32
Dec 28 01:45:00 vdr1 kernel: [81909.319394]  [<c1360000>] ? asus_hides_smbus_hostbridge+0x264/0x269
Dec 28 01:45:00 vdr1 kernel: [81909.319394] Code: a2 66 90 c7 43 08 00 00 00 00 8b 75 f8 8b 7d fc a1 2c dc 4e c1 89 43 0c 8b 5d f4 89 ec 5d c3 8d 74 26 00 55 89 c1 89 e5 53 31 db <8b> 00 c7 01 00 00 00 00 84 c0 0f 9f c3 85 db 74 17 a1 2c dc 4e
Dec 28 01:45:00 vdr1 kernel: [81909.319394] EIP: [<c11848d8>] do_raw_spin_trylock+0x8/0x50 SS:ESP 0068:d415fe58
Dec 28 01:45:00 vdr1 kernel: [81909.319394] CR2: 0000000000000040
Dec 28 01:45:00 vdr1 kernel: [81909.319394] ---[ end trace 41db3e0e4ba186fa ]---
Dec 28 01:45:00 vdr1 kernel: [81909.866655] note: bino[15899] exited with preempt_count 1





