Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f43.google.com ([74.125.83.43]:51791 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404Ab3ABHsX (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 2 Jan 2013 02:48:23 -0500
Received: by mail-ee0-f43.google.com with SMTP id e49so6873481eek.16
        for <linux-media@vger.kernel.org>; Tue, 01 Jan 2013 23:48:21 -0800 (PST)
Message-ID: <50E3E643.7070701@gmail.com>
Date: Wed, 02 Jan 2013 08:48:19 +0100
From: thomas schorpp <thomas.schorpp@gmail.com>
Reply-To: thomas.schorpp@gmail.com
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: j@jannau.net, jarod@redhat.com
Subject: [BUG] crystalhd git.linuxtv.org kernel driver: unable to handle kernel
 paging requests, improper (spin)locking(?) and paging
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

Forgot to mention the attached Oopses under high load and "multithreading" in half automated stress/mass testing.

Scenario e.g.:
Dec 29 15:58:29 vdr1 kernel: [ 5698.364950] crystalhd 0000:02:00.0: Opening new user[0] handle
Dec 29 15:58:30 vdr1 kernel: [ 5698.557932] crystalhd 0000:02:00.0: Opening new user[0] handle
Dec 29 15:58:30 vdr1 kernel: [ 5698.846312] crystalhd 0000:02:00.0: Close the handle first..

Looks like the driver is not "threadsave", rebuilding kernel with spinlock debugging, should show more up.

y
tom

-Att: Kernel OOPS bt, etc

Dec 29 15:56:10 vdr1 kernel: [ 5558.568671] BUG: unable to handle kernel paging request at 2062696c
Dec 29 15:56:10 vdr1 kernel: [ 5558.568678] IP: [<2062696c>] 0x2062696b
Dec 29 15:56:10 vdr1 kernel: [ 5558.568681] *pdpt = 0000000008497001 *pde = 0000000000000000
Dec 29 15:56:10 vdr1 kernel: [ 5558.568684] Oops: 0010 [#4] PREEMPT
Dec 29 15:56:10 vdr1 kernel: [ 5558.568731] Modules linked in: md5 crypto_hash cpufreq_stats cpufreq_powersave cpufreq_userspace cpufreq_conservative bnep bluetooth crc16 binfmt_misc uinput fuse nfsd exportfs auth_rpcgss nfs_acl nfs lockd sunrpc nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack xt_limit iptable_filter ip_tables af_packet ipv6 w83627ehf hwmon_vid hwmon uvcvideo isl6405 cryptomgr aead dvb_pll tda10086 saa7134_dvb tuner arc4 crypto_blkcipher crypto_algapi tda10021 snd_usb_audio snd_usbmidi_lib snd_hwdep rt73usb snd_pcm_oss rt2x00usb rt2x00lib stv0297 mac80211 snd_intel8x0 snd_ac97_codec snd_mixer_oss ac97_bus joydev snd_seq_dummy snd_pcm videobuf_dvb snd_seq_oss hid_sunplus hid_generic saa7134 videobuf2_vmalloc videobuf2_memops usbhid cfg80211 videobuf2_core snd_seq_midi hid snd_page_alloc snd_rawmidi budget_av dvb_ttpci crc_itu_t crypto budget_core saa7146_vv ttpci_eeprom saa7146 dvb_core snd_seq_midi_even
t tveeprom videobuf_dma_sg
Dec 29 15:56:10 vdr1 kernel: videobuf_core v4l2_common snd_seq rc_core videodev snd_seq_device crystalhd(O) snd_timer shpchp snd rng_core pci_hotplug serio_raw pcspkr i2c_i801 8250_pnp 8250 soundcore serial_core acpi_cpufreq mperf processor evdev ext3 mbcache jbd sg sr_mod sd_mod crc_t10dif cdrom ata_piix ahci libahci uhci_hcd libata ehci_hcd scsi_mod usbcore
Dec 29 15:56:10 vdr1 kernel: [ 5558.568770] Pid: 11841, comm: mplayer Tainted: G      D    O 3.6.10-PM #8    /Alviso
Dec 29 15:56:10 vdr1 kernel: [ 5558.568772] EIP: 0060:[<2062696c>] EFLAGS: 00010286 CPU: 0
Dec 29 15:56:10 vdr1 kernel: [ 5558.568775] EIP is at 0x2062696c
Dec 29 15:56:10 vdr1 kernel: [ 5558.568777] EAX: 00370042 EBX: c843c000 ECX: 636e3800 EDX: 00001c10
Dec 29 15:56:10 vdr1 kernel: [ 5558.568778] ESI: 000238fc EDI: fb0068fc EBP: c842dea8 ESP: c842de74
Dec 29 15:56:10 vdr1 kernel: [ 5558.568780]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Dec 29 15:56:10 vdr1 kernel: [ 5558.568781] CR0: 8005003b CR2: 2062696c CR3: 084d9000 CR4: 000007f0
Dec 29 15:56:10 vdr1 kernel: [ 5558.568783] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
Dec 29 15:56:10 vdr1 kernel: [ 5558.568784] DR6: ffff0ff0 DR7: 00000400
Dec 29 15:56:10 vdr1 kernel: [ 5558.568786] Process mplayer (pid: 11841, ti=c842c000 task=f0aba940 task.ti=c842c000)
Dec 29 15:56:10 vdr1 kernel: [ 5558.568787] Stack:
Dec 29 15:56:10 vdr1 kernel: [ 5558.568793]  fa18a569 ffffff10 c117e3f6 00000060 00010246 002a8464 f7138064 fafe3000
Dec 29 15:56:10 vdr1 kernel: [ 5558.568798]  002a8440 c117e811 f5920988 fafe3000 c843c000 c842ded8 fa18564d c842ded8
Dec 29 15:56:10 vdr1 kernel: [ 5558.568803]  fa182597 f595a400 f595a62c c842ded8 fa182977 002a8464 f5920900 f595a400
Dec 29 15:56:10 vdr1 kernel: [ 5558.568804] Call Trace:
Dec 29 15:56:10 vdr1 kernel: [ 5558.568818]  [<fa18a569>] ? crystalhd_link_download_fw+0x189/0x300 [crystalhd]
Dec 29 15:56:10 vdr1 kernel: [ 5558.568823]  [<c117e3f6>] ? __copy_from_user_ll+0xd6/0xf0
Dec 29 15:56:10 vdr1 kernel: [ 5558.568828]  [<c117e811>] ? _copy_from_user+0x41/0xb0
Dec 29 15:56:10 vdr1 kernel: [ 5558.568839]  [<fa18564d>] bc_cproc_download_fw+0xed/0x150 [crystalhd]
Dec 29 15:56:10 vdr1 kernel: [ 5558.568846]  [<fa182597>] ? chd_dec_proc_user_data+0x237/0x320 [crystalhd]
Dec 29 15:56:10 vdr1 kernel: [ 5558.568854]  [<fa182977>] ? chd_dec_alloc_iodata+0xf7/0x120 [crystalhd]
Dec 29 15:56:10 vdr1 kernel: [ 5558.568861]  [<fa182b5e>] chd_dec_ioctl+0x16e/0x1c0 [crystalhd]
Dec 29 15:56:10 vdr1 kernel: [ 5558.568870]  [<fa185560>] ? bc_proc_in_completion+0x70/0x70 [crystalhd]
Dec 29 15:56:10 vdr1 kernel: [ 5558.568877]  [<fa1829f0>] ? chd_dec_free_iodata+0x50/0x50 [crystalhd]
Dec 29 15:56:10 vdr1 kernel: [ 5558.568881]  [<c10f4355>] do_vfs_ioctl+0x535/0x580
Dec 29 15:56:10 vdr1 kernel: [ 5558.568886]  [<c10685ef>] ? ktime_get+0x6f/0xf0
Dec 29 15:56:10 vdr1 kernel: [ 5558.568891]  [<c101ca56>] ? lapic_next_event+0x16/0x20
Dec 29 15:56:10 vdr1 kernel: [ 5558.568895]  [<c106f287>] ? clockevents_program_event+0xe7/0x130
Dec 29 15:56:10 vdr1 kernel: [ 5558.568898]  [<c10e4ab8>] ? fget_light+0xe8/0x120
Dec 29 15:56:10 vdr1 kernel: [ 5558.568901]  [<c10e4ad1>] ? fget_light+0x101/0x120
Dec 29 15:56:10 vdr1 kernel: [ 5558.568904]  [<c10e4a30>] ? fget_light+0x60/0x120
Dec 29 15:56:10 vdr1 kernel: [ 5558.568906]  [<c10f43cd>] sys_ioctl+0x2d/0x60
Dec 29 15:56:10 vdr1 kernel: [ 5558.568910]  [<c137238c>] sysenter_do_call+0x12/0x32
Dec 29 15:56:10 vdr1 kernel: [ 5558.568914]  [<c1360000>] ? asus_hides_smbus_hostbridge+0x264/0x269
Dec 29 15:56:10 vdr1 kernel: [ 5558.568917] Code:  Bad EIP value.
Dec 29 15:56:10 vdr1 kernel: [ 5558.568922] EIP: [<2062696c>] 0x2062696c SS:ESP 0068:c842de74
Dec 29 15:56:10 vdr1 kernel: [ 5558.568923] CR2: 000000002062696c
Dec 29 15:56:10 vdr1 kernel: [ 5558.568926] ---[ end trace f5ae98f349325070 ]---

Dec 29 15:58:29 vdr1 kernel: [ 5698.364950] crystalhd 0000:02:00.0: Opening new user[0] handle
Dec 29 15:58:30 vdr1 kernel: [ 5698.557932] crystalhd 0000:02:00.0: Opening new user[0] handle
Dec 29 15:58:30 vdr1 kernel: [ 5698.846312] crystalhd 0000:02:00.0: Close the handle first..
Dec 29 15:58:30 vdr1 kernel: [ 5698.858268] crystalhd 0000:02:00.0: Closing user[0] handle via ioctl with mode 1417200
Dec 29 15:58:30 vdr1 kernel: [ 5698.961171] crystalhd_hw_stats: Invalid Arguments
Dec 29 15:58:30 vdr1 kernel: [ 5698.961204] BUG: unable to handle kernel NULL pointer dereference at 00000040
Dec 29 15:58:30 vdr1 kernel: [ 5698.962005] IP: [<c11848d8>] do_raw_spin_trylock+0x8/0x50
Dec 29 15:58:30 vdr1 kernel: [ 5698.962005] *pdpt = 0000000030a1d001 *pde = 0000000000000000
Dec 29 15:58:30 vdr1 kernel: [ 5698.962005] Oops: 0000 [#5] PREEMPT
Dec 29 15:58:30 vdr1 kernel: [ 5698.962005] Modules linked in: md5 crypto_hash cpufreq_stats cpufreq_powersave cpufreq_userspace cpufreq_conservative bnep bluetooth crc16 binfmt_misc uinput fuse nfsd exportfs auth_rpcgss nfs_acl nfs lockd sunrpc nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack xt_limit iptable_filter ip_tables af_packet ipv6 w83627ehf hwmon_vid hwmon uvcvideo isl6405 cryptomgr aead dvb_pll tda10086 saa7134_dvb tuner arc4 crypto_blkcipher crypto_algapi tda10021 snd_usb_audio snd_usbmidi_lib snd_hwdep rt73usb snd_pcm_oss rt2x00usb rt2x00lib stv0297 mac80211 snd_intel8x0 snd_ac97_codec snd_mixer_oss ac97_bus joydev snd_seq_dummy snd_pcm videobuf_dvb snd_seq_oss hid_sunplus hid_generic saa7134 videobuf2_vmalloc videobuf2_memops usbhid cfg80211 videobuf2_core snd_seq_midi hid snd_page_alloc snd_rawmidi budget_av dvb_ttpci crc_itu_t crypto budget_core saa7146_vv ttpci_eeprom saa7146 dvb_core snd_seq_midi_even
t tveeprom videobuf_dma_sg
Dec 29 15:58:30 vdr1 kernel: videobuf_core v4l2_common snd_seq rc_core videodev snd_seq_device crystalhd(O) snd_timer shpchp snd rng_core pci_hotplug serio_raw pcspkr i2c_i801 8250_pnp 8250 soundcore serial_core acpi_cpufreq mperf processor evdev ext3 mbcache jbd sg sr_mod sd_mod crc_t10dif cdrom ata_piix ahci libahci uhci_hcd libata ehci_hcd scsi_mod usbcore
Dec 29 15:58:30 vdr1 kernel: [ 5698.962005] Pid: 11927, comm: mplayer Tainted: G      D    O 3.6.10-PM #8    /Alviso
Dec 29 15:58:30 vdr1 kernel: [ 5698.962005] EIP: 0060:[<c11848d8>] EFLAGS: 00210046 CPU: 0
Dec 29 15:58:30 vdr1 kernel: [ 5698.962005] EIP is at do_raw_spin_trylock+0x8/0x50
Dec 29 15:58:30 vdr1 kernel: [ 5698.962005] EAX: 00000040 EBX: 00000000 ECX: 00000040 EDX: 00000000
Dec 29 15:58:30 vdr1 kernel: [ 5698.962005] ESI: 00000040 EDI: 00200292 EBP: c85a7e5c ESP: c85a7e58
Dec 29 15:58:30 vdr1 kernel: [ 5698.962005]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Dec 29 15:58:30 vdr1 kernel: [ 5698.962005] CR0: 8005003b CR2: 00000040 CR3: 34276000 CR4: 000007f0
Dec 29 15:58:30 vdr1 kernel: [ 5698.962005] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
Dec 29 15:58:30 vdr1 kernel: [ 5698.962005] DR6: ffff0ff0 DR7: 00000400
Dec 29 15:58:30 vdr1 kernel: [ 5698.962005] Process mplayer (pid: 11927, ti=c85a6000 task=f48ce720 task.ti=c85a6000)
Dec 29 15:58:30 vdr1 kernel: [ 5698.962005] Stack:
Dec 29 15:58:30 vdr1 kernel: [ 5698.962005]  00000050 c85a7e80 c136c9b5 00000000 00000002 00000000 fa184bd6 f5955c00
Dec 29 15:58:30 vdr1 kernel: [ 5698.962005]  f5920988 00000000 c85a7ed8 fa184bd6 00000218 c85a6000 00000000 c85a7eb0
Dec 29 15:58:30 vdr1 kernel: [ 5698.962005]  c117e811 09ce6618 0c955c00 f5955c00 00000000 09ce6618 c85a7ed8 fa1823b9
Dec 29 15:58:30 vdr1 kernel: [ 5698.962005] Call Trace:
Dec 29 15:58:30 vdr1 kernel: [ 5698.962005]  [<c136c9b5>] _raw_spin_lock_irqsave+0x55/0x90
Dec 29 15:58:30 vdr1 kernel: [ 5698.962005]  [<fa184bd6>] ? bc_cproc_get_stats+0x226/0x280 [crystalhd]
Dec 29 15:58:30 vdr1 kernel: [ 5698.962005]  [<fa184bd6>] bc_cproc_get_stats+0x226/0x280 [crystalhd]
Dec 29 15:58:30 vdr1 kernel: [ 5698.962005]  [<c117e811>] ? _copy_from_user+0x41/0xb0
Dec 29 15:58:30 vdr1 kernel: [ 5698.962005]  [<fa1823b9>] ? chd_dec_proc_user_data+0x59/0x320 [crystalhd]
Dec 29 15:58:30 vdr1 kernel: [ 5698.962005]  [<fa182977>] ? chd_dec_alloc_iodata+0xf7/0x120 [crystalhd]
Dec 29 15:58:30 vdr1 kernel: [ 5698.962005]  [<fa182b5e>] chd_dec_ioctl+0x16e/0x1c0 [crystalhd]
Dec 29 15:58:30 vdr1 kernel: [ 5698.962005]  [<fa1849b0>] ? bc_cproc_reset_stats+0x20/0x20 [crystalhd]
Dec 29 15:58:30 vdr1 kernel: [ 5698.962005]  [<fa1829f0>] ? chd_dec_free_iodata+0x50/0x50 [crystalhd]
Dec 29 15:58:30 vdr1 kernel: [ 5698.962005]  [<c10f4355>] do_vfs_ioctl+0x535/0x580
Dec 29 15:58:30 vdr1 kernel: [ 5698.962005]  [<c104e73e>] ? hrtimer_nanosleep+0x6e/0xf0
Dec 29 15:58:30 vdr1 kernel: [ 5698.962005]  [<c10e4ab8>] ? fget_light+0xe8/0x120
Dec 29 15:58:30 vdr1 kernel: [ 5698.962005]  [<c10e4ad1>] ? fget_light+0x101/0x120
Dec 29 15:58:30 vdr1 kernel: [ 5698.962005]  [<c10e4a30>] ? fget_light+0x60/0x120
Dec 29 15:58:30 vdr1 kernel: [ 5698.962005]  [<c10f43cd>] sys_ioctl+0x2d/0x60
Dec 29 15:58:30 vdr1 kernel: [ 5698.962005]  [<c137238c>] sysenter_do_call+0x12/0x32
Dec 29 15:58:30 vdr1 kernel: [ 5698.962005] Code: a2 66 90 c7 43 08 00 00 00 00 8b 75 f8 8b 7d fc a1 2c dc 4e c1 89 43 0c 8b 5d f4 89 ec 5d c3 8d 74 26 00 55 89 c1 89 e5 53 31 db <8b> 00 c7 01 00 00 00 00 84 c0 0f 9f c3 85 db 74 17 a1 2c dc 4e
Dec 29 15:58:30 vdr1 kernel: [ 5698.962005] EIP: [<c11848d8>] do_raw_spin_trylock+0x8/0x50 SS:ESP 0068:c85a7e58
Dec 29 15:58:30 vdr1 kernel: [ 5698.962005] CR2: 0000000000000040
Dec 29 15:58:30 vdr1 kernel: [ 5698.962005] ---[ end trace f5ae98f349325071 ]---
Dec 29 15:58:30 vdr1 kernel: [ 5699.232992] note: mplayer[11927] exited with preempt_count 1
Dec 29 15:58:30 vdr1 kernel: [ 5699.251706] crystalhd 0000:02:00.0: Opening new user[0] handle
Dec 29 15:58:31 vdr1 kernel: [ 5699.281871] BUG: unable to handle kernel paging request at 6e757474
Dec 29 15:58:31 vdr1 kernel: [ 5699.282005] IP: [<6e757474>] 0x6e757473
Dec 29 15:58:31 vdr1 kernel: [ 5699.282005] *pdpt = 000000002fb8b001 *pde = 0000000000000000
Dec 29 15:58:31 vdr1 kernel: [ 5699.282005] Oops: 0010 [#6] PREEMPT
Dec 29 15:58:31 vdr1 kernel: [ 5699.282005] Modules linked in: md5 crypto_hash cpufreq_stats cpufreq_powersave cpufreq_userspace cpufreq_conservative bnep bluetooth crc16 binfmt_misc uinput fuse nfsd exportfs auth_rpcgss nfs_acl nfs lockd sunrpc nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack xt_limit iptable_filter ip_tables af_packet ipv6 w83627ehf hwmon_vid hwmon uvcvideo isl6405 cryptomgr aead dvb_pll tda10086 saa7134_dvb tuner arc4 crypto_blkcipher crypto_algapi tda10021 snd_usb_audio snd_usbmidi_lib snd_hwdep rt73usb snd_pcm_oss rt2x00usb rt2x00lib stv0297 mac80211 snd_intel8x0 snd_ac97_codec snd_mixer_oss ac97_bus joydev snd_seq_dummy snd_pcm videobuf_dvb snd_seq_oss hid_sunplus hid_generic saa7134 videobuf2_vmalloc videobuf2_memops usbhid cfg80211 videobuf2_core snd_seq_midi hid snd_page_alloc snd_rawmidi budget_av dvb_ttpci crc_itu_t crypto budget_core saa7146_vv ttpci_eeprom saa7146 dvb_core snd_seq_midi_even
t tveeprom videobuf_dma_sg
Dec 29 15:58:31 vdr1 kernel: videobuf_core v4l2_common snd_seq rc_core videodev snd_seq_device crystalhd(O) snd_timer shpchp snd rng_core pci_hotplug serio_raw pcspkr i2c_i801 8250_pnp 8250 soundcore serial_core acpi_cpufreq mperf processor evdev ext3 mbcache jbd sg sr_mod sd_mod crc_t10dif cdrom ata_piix ahci libahci uhci_hcd libata ehci_hcd scsi_mod usbcore
Dec 29 15:58:31 vdr1 kernel: [ 5699.282005] Pid: 11926, comm: mplayer Tainted: G      D    O 3.6.10-PM #8    /Alviso
Dec 29 15:58:31 vdr1 kernel: [ 5699.282005] EIP: 0060:[<6e757474>] EFLAGS: 00210206 CPU: 0
Dec 29 15:58:31 vdr1 kernel: [ 5699.282005] EIP is at 0x6e757474
Dec 29 15:58:31 vdr1 kernel: [ 5699.282005] EAX: 726f6863 EBX: c538c000 ECX: 00000000 EDX: 00001c08
Dec 29 15:58:31 vdr1 kernel: [ 5699.282005] ESI: 000251ac EDI: fb55c1a8 EBP: c8497ea8 ESP: c8497e74
Dec 29 15:58:31 vdr1 kernel: [ 5699.282005]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Dec 29 15:58:31 vdr1 kernel: [ 5699.282005] CR0: 8005003b CR2: 6e757474 CR3: 34276000 CR4: 000007f0
Dec 29 15:58:31 vdr1 kernel: [ 5699.282005] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
Dec 29 15:58:31 vdr1 kernel: [ 5699.282005] DR6: ffff0ff0 DR7: 00000400
Dec 29 15:58:31 vdr1 kernel: [ 5699.282005] Process mplayer (pid: 11926, ti=c8496000 task=f48c8000 task.ti=c8496000)
Dec 29 15:58:31 vdr1 kernel: [ 5699.282005] Stack:
Dec 29 15:58:31 vdr1 kernel: [ 5699.282005]  fa18a556 ffffffbe c117e3f6 00000060 00210246 002a8464 f7138064 fb537000
Dec 29 15:58:31 vdr1 kernel: [ 5699.282005]  002a8440 c117e811 f5920988 fb537000 c538c000 c8497ed8 fa18564d c8497ed8
Dec 29 15:58:31 vdr1 kernel: [ 5699.282005]  fa182597 f595a000 f595a22c c8497ed8 fa182977 002a8464 f5920900 f595a000
Dec 29 15:58:31 vdr1 kernel: [ 5699.282005] Call Trace:
Dec 29 15:58:31 vdr1 kernel: [ 5699.282005]  [<fa18a556>] ? crystalhd_link_download_fw+0x176/0x300 [crystalhd]
Dec 29 15:58:31 vdr1 kernel: [ 5699.282005]  [<c117e3f6>] ? __copy_from_user_ll+0xd6/0xf0
Dec 29 15:58:31 vdr1 kernel: [ 5699.282005]  [<c117e811>] ? _copy_from_user+0x41/0xb0
Dec 29 15:58:31 vdr1 kernel: [ 5699.282005]  [<fa18564d>] bc_cproc_download_fw+0xed/0x150 [crystalhd]
Dec 29 15:58:31 vdr1 kernel: [ 5699.282005]  [<fa182597>] ? chd_dec_proc_user_data+0x237/0x320 [crystalhd]
Dec 29 15:58:31 vdr1 kernel: [ 5699.282005]  [<fa182977>] ? chd_dec_alloc_iodata+0xf7/0x120 [crystalhd]
Dec 29 15:58:31 vdr1 kernel: [ 5699.282005]  [<fa182b5e>] chd_dec_ioctl+0x16e/0x1c0 [crystalhd]
Dec 29 15:58:31 vdr1 kernel: [ 5699.282005]  [<fa185560>] ? bc_proc_in_completion+0x70/0x70 [crystalhd]
Dec 29 15:58:31 vdr1 kernel: [ 5699.282005]  [<fa1829f0>] ? chd_dec_free_iodata+0x50/0x50 [crystalhd]
Dec 29 15:58:31 vdr1 kernel: [ 5699.282005]  [<c10f4355>] do_vfs_ioctl+0x535/0x580
Dec 29 15:58:31 vdr1 kernel: [ 5699.282005]  [<c136c865>] ? _raw_spin_lock+0x65/0x70
Dec 29 15:58:31 vdr1 kernel: [ 5699.282005]  [<c109c156>] ? handle_fasteoi_irq+0xb6/0xd0
Dec 29 15:58:31 vdr1 kernel: [ 5699.282005]  [<c10e4ab8>] ? fget_light+0xe8/0x120
Dec 29 15:58:31 vdr1 kernel: [ 5699.282005]  [<c10e4ad1>] ? fget_light+0x101/0x120
Dec 29 15:58:31 vdr1 kernel: [ 5699.282005]  [<c10e4a30>] ? fget_light+0x60/0x120
Dec 29 15:58:31 vdr1 kernel: [ 5699.282005]  [<c10f43cd>] sys_ioctl+0x2d/0x60
Dec 29 15:58:31 vdr1 kernel: [ 5699.282005]  [<c137238c>] sysenter_do_call+0x12/0x32
Dec 29 15:58:31 vdr1 kernel: [ 5699.282005] Code:  Bad EIP value.
Dec 29 15:58:31 vdr1 kernel: [ 5699.282005] EIP: [<6e757474>] 0x6e757474 SS:ESP 0068:c8497e74
Dec 29 15:58:31 vdr1 kernel: [ 5699.282005] CR2: 000000006e757474
Dec 29 15:58:31 vdr1 kernel: [ 5699.538480] ---[ end trace f5ae98f349325072 ]---
Dec 29 15:58:33 vdr1 kernel: [ 5701.629049] crystalhd 0000:02:00.0: F/w Signature mismatch
Dec 29 15:58:33 vdr1 kernel: [ 5701.629065] crystalhd 0000:02:00.0: Firmware Download Failure!! - 21
Dec 29 15:58:33 vdr1 kernel: [ 5701.754795] crystalhd 0000:02:00.0: Closing user[0] handle via ioctl with mode 1417200

Dec 29 15:58:31 vdr1 kernel: [ 5699.281871] BUG: unable to handle kernel paging request at 6e757474
Dec 29 15:58:31 vdr1 kernel: [ 5699.282005] IP: [<6e757474>] 0x6e757473
Dec 29 15:58:31 vdr1 kernel: [ 5699.282005] *pdpt = 000000002fb8b001 *pde = 0000000000000000
Dec 29 15:58:31 vdr1 kernel: [ 5699.282005] Oops: 0010 [#6] PREEMPT
Dec 29 15:58:31 vdr1 kernel: [ 5699.282005] Modules linked in: md5 crypto_hash cpufreq_stats cpufreq_powersave cpufreq_userspace cpufreq_conservative bnep bluetooth crc16 binfmt_misc uinput fuse nfsd exportfs auth_rpcgss nfs_acl nfs lockd sunrpc nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack xt_limit iptable_filter ip_tables af_packet ipv6 w83627ehf hwmon_vid hwmon uvcvideo isl6405 cryptomgr aead dvb_pll tda10086 saa7134_dvb tuner arc4 crypto_blkcipher crypto_algapi tda10021 snd_usb_audio snd_usbmidi_lib snd_hwdep rt73usb snd_pcm_oss rt2x00usb rt2x00lib stv0297 mac80211 snd_intel8x0 snd_ac97_codec snd_mixer_oss ac97_bus joydev snd_seq_dummy snd_pcm videobuf_dvb snd_seq_oss hid_sunplus hid_generic saa7134 videobuf2_vmalloc videobuf2_memops usbhid cfg80211 videobuf2_core snd_seq_midi hid snd_page_alloc snd_rawmidi budget_av dvb_ttpci crc_itu_t crypto budget_core saa7146_vv ttpci_eeprom saa7146 dvb_core snd_seq_midi_even
t tveeprom videobuf_dma_sg
Dec 29 15:58:31 vdr1 kernel: videobuf_core v4l2_common snd_seq rc_core videodev snd_seq_device crystalhd(O) snd_timer shpchp snd rng_core pci_hotplug serio_raw pcspkr i2c_i801 8250_pnp 8250 soundcore serial_core acpi_cpufreq mperf processor evdev ext3 mbcache jbd sg sr_mod sd_mod crc_t10dif cdrom ata_piix ahci libahci uhci_hcd libata ehci_hcd scsi_mod usbcore
Dec 29 15:58:31 vdr1 kernel: [ 5699.282005] Pid: 11926, comm: mplayer Tainted: G      D    O 3.6.10-PM #8    /Alviso
Dec 29 15:58:31 vdr1 kernel: [ 5699.282005] EIP: 0060:[<6e757474>] EFLAGS: 00210206 CPU: 0
Dec 29 15:58:31 vdr1 kernel: [ 5699.282005] EIP is at 0x6e757474
Dec 29 15:58:31 vdr1 kernel: [ 5699.282005] EAX: 726f6863 EBX: c538c000 ECX: 00000000 EDX: 00001c08
Dec 29 15:58:31 vdr1 kernel: [ 5699.282005] ESI: 000251ac EDI: fb55c1a8 EBP: c8497ea8 ESP: c8497e74
Dec 29 15:58:31 vdr1 kernel: [ 5699.282005]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Dec 29 15:58:31 vdr1 kernel: [ 5699.282005] CR0: 8005003b CR2: 6e757474 CR3: 34276000 CR4: 000007f0
Dec 29 15:58:31 vdr1 kernel: [ 5699.282005] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
Dec 29 15:58:31 vdr1 kernel: [ 5699.282005] DR6: ffff0ff0 DR7: 00000400
Dec 29 15:58:31 vdr1 kernel: [ 5699.282005] Process mplayer (pid: 11926, ti=c8496000 task=f48c8000 task.ti=c8496000)
Dec 29 15:58:31 vdr1 kernel: [ 5699.282005] Stack:
Dec 29 15:58:31 vdr1 kernel: [ 5699.282005]  fa18a556 ffffffbe c117e3f6 00000060 00210246 002a8464 f7138064 fb537000
Dec 29 15:58:31 vdr1 kernel: [ 5699.282005]  002a8440 c117e811 f5920988 fb537000 c538c000 c8497ed8 fa18564d c8497ed8
Dec 29 15:58:31 vdr1 kernel: [ 5699.282005]  fa182597 f595a000 f595a22c c8497ed8 fa182977 002a8464 f5920900 f595a000
Dec 29 15:58:31 vdr1 kernel: [ 5699.282005] Call Trace:
Dec 29 15:58:31 vdr1 kernel: [ 5699.282005]  [<fa18a556>] ? crystalhd_link_download_fw+0x176/0x300 [crystalhd]
Dec 29 15:58:31 vdr1 kernel: [ 5699.282005]  [<c117e3f6>] ? __copy_from_user_ll+0xd6/0xf0
Dec 29 15:58:31 vdr1 kernel: [ 5699.282005]  [<c117e811>] ? _copy_from_user+0x41/0xb0
Dec 29 15:58:31 vdr1 kernel: [ 5699.282005]  [<fa18564d>] bc_cproc_download_fw+0xed/0x150 [crystalhd]
Dec 29 15:58:31 vdr1 kernel: [ 5699.282005]  [<fa182597>] ? chd_dec_proc_user_data+0x237/0x320 [crystalhd]
Dec 29 15:58:31 vdr1 kernel: [ 5699.282005]  [<fa182977>] ? chd_dec_alloc_iodata+0xf7/0x120 [crystalhd]
Dec 29 15:58:31 vdr1 kernel: [ 5699.282005]  [<fa182b5e>] chd_dec_ioctl+0x16e/0x1c0 [crystalhd]
Dec 29 15:58:31 vdr1 kernel: [ 5699.282005]  [<fa185560>] ? bc_proc_in_completion+0x70/0x70 [crystalhd]
Dec 29 15:58:31 vdr1 kernel: [ 5699.282005]  [<fa1829f0>] ? chd_dec_free_iodata+0x50/0x50 [crystalhd]
Dec 29 15:58:31 vdr1 kernel: [ 5699.282005]  [<c10f4355>] do_vfs_ioctl+0x535/0x580
Dec 29 15:58:31 vdr1 kernel: [ 5699.282005]  [<c136c865>] ? _raw_spin_lock+0x65/0x70
Dec 29 15:58:31 vdr1 kernel: [ 5699.282005]  [<c109c156>] ? handle_fasteoi_irq+0xb6/0xd0
Dec 29 15:58:31 vdr1 kernel: [ 5699.282005]  [<c10e4ab8>] ? fget_light+0xe8/0x120
Dec 29 15:58:31 vdr1 kernel: [ 5699.282005]  [<c10e4ad1>] ? fget_light+0x101/0x120
Dec 29 15:58:31 vdr1 kernel: [ 5699.282005]  [<c10e4a30>] ? fget_light+0x60/0x120
Dec 29 15:58:31 vdr1 kernel: [ 5699.282005]  [<c10f43cd>] sys_ioctl+0x2d/0x60
Dec 29 15:58:31 vdr1 kernel: [ 5699.282005]  [<c137238c>] sysenter_do_call+0x12/0x32
Dec 29 15:58:31 vdr1 kernel: [ 5699.282005] Code:  Bad EIP value.
Dec 29 15:58:31 vdr1 kernel: [ 5699.282005] EIP: [<6e757474>] 0x6e757474 SS:ESP 0068:c8497e74
Dec 29 15:58:31 vdr1 kernel: [ 5699.282005] CR2: 000000006e757474
Dec 29 15:58:31 vdr1 kernel: [ 5699.538480] ---[ end trace f5ae98f349325072 ]---
Dec 29 15:58:33 vdr1 kernel: [ 5701.629049] crystalhd 0000:02:00.0: F/w Signature mismatch
Dec 29 15:58:33 vdr1 kernel: [ 5701.629065] crystalhd 0000:02:00.0: Firmware Download Failure!! - 21
Dec 29 15:58:33 vdr1 kernel: [ 5701.754795] crystalhd 0000:02:00.0: Closing user[0] handle via ioctl with mode 1417200

