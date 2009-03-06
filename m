Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55399 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752678AbZCFBtO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 5 Mar 2009 20:49:14 -0500
Date: Thu, 5 Mar 2009 17:49:09 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-media@vger.kernel.org
Cc: strawks <strawks@yahoo.fr>
Subject: Fw: oops in pwc_reset_buffers
Message-Id: <20090305174909.9186d8d3.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="Multipart=_Thu__5_Mar_2009_17_49_09_-0800_4bkqFhLpWSHGh77_"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This is a multi-part message in MIME format.

--Multipart=_Thu__5_Mar_2009_17_49_09_-0800_4bkqFhLpWSHGh77_
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit



Begin forwarded message:

Date: Thu, 05 Mar 2009 14:53:17 +0100
From: strawks <strawks@yahoo.fr>
To: linux-kernel@vger.kernel.org
Subject: oops in pwc_reset_buffers


Hi all,

On 2.6.29-rc6, when resuming from suspend to RAM I got the following 
oops when motion tried to open /dev/video0. Just ask me if you need some 
additionnal info (full log attached).

regards,
strawks

Mar  5 08:26:38 evangeline kernel: [109985.797284] BUG: unable to handle 
kernel NULL pointer dereference at 0000000000000008
Mar  5 08:26:38 evangeline kernel: [109985.797290] IP: 
[<ffffffffa01d1439>] pwc_reset_buffers+0x4a/0xdd [pwc]
Mar  5 08:26:38 evangeline kernel: [109985.797299] PGD 51dad067 PUD 
18485067 PMD 0
Mar  5 08:26:38 evangeline kernel: [109985.797302] Oops: 0002 [#1] SMP
Mar  5 08:26:38 evangeline kernel: [109985.797305] last sysfs file: 
/sys/class/video4linux/video0/index
Mar  5 08:26:38 evangeline kernel: [109985.797307] CPU 0
Mar  5 08:26:38 evangeline kernel: [109985.797308] Modules linked in: 
i915 drm i2c_algo_bit acpi_cpufreq cpufreq_conservative 
cpufreq_powersave cpufreq_userspace cpufreq_stats cpufreq_ondemand 
freq_table ipv6 fuse coretemp it87 hwmon_vid sbp2 loop 
snd_hda_codec_intelhdmi snd_hda_codec_realtek snd_usb_audio 
snd_hda_intel snd_usb_lib snd_hda_codec snd_seq_midi snd_seq_midi_event 
snd_rawmidi snd_pcm snd_hwdep snd_seq snd_timer snd_seq_device pwc 
i2c_i801 psmouse snd videodev v4l1_compat i2c_core serio_raw iTCO_wdt 
snd_page_alloc soundcore pcspkr v4l2_compat_ioctl32 joydev intel_agp 
button evdev ext3 jbd mbcache ide_gd_mod ata_piix ata_generic libata 
scsi_mod hid_logitech ff_memless usbhid hid ohci1394 ieee1394 
ide_pci_generic it8213 ide_core ehci_hcd r8169 mii uhci_hcd thermal 
processor fan thermal_sys
Mar  5 08:26:38 evangeline kernel: [109985.797356] Pid: 26749, comm: 
motion Not tainted 2.6.29-rc6 #1 EG45M-DS2H
Mar  5 08:26:38 evangeline kernel: [109985.797359] RIP: 
0010:[<ffffffffa01d1439>]  [<ffffffffa01d1439>] 
pwc_reset_buffers+0x4a/0xdd [pwc]
Mar  5 08:26:38 evangeline kernel: [109985.797366] RSP: 
0018:ffff880018519cb8  EFLAGS: 00010046
Mar  5 08:26:38 evangeline kernel: [109985.797368] RAX: 0000000000000000 
RBX: ffff880037968c00 RCX: 0000000000000000
Mar  5 08:26:38 evangeline kernel: [109985.797370] RDX: ffffffff805852b8 
RSI: 0000000000000296 RDI: 0000000000000000
Mar  5 08:26:38 evangeline kernel: [109985.797372] RBP: ffff880037968e70 
R08: 0000000000000003 R09: 0000000000000000
Mar  5 08:26:38 evangeline kernel: [109985.797375] R10: 0000000000000000 
R11: ffffffff804697f2 R12: 0000000000000001
Mar  5 08:26:38 evangeline kernel: [109985.797377] R13: 000000000000000a 
R14: 00000000000000f0 R15: 0000000000000140
Mar  5 08:26:38 evangeline kernel: [109985.797379] FS: 
00007faba7078950(0000) GS:ffffffff80671000(0000) knlGS:0000000000000000
Mar  5 08:26:38 evangeline kernel: [109985.797382] CS:  0010 DS: 0000 
ES: 0000 CR0: 000000008005003b
Mar  5 08:26:38 evangeline kernel: [109985.797384] CR2: 0000000000000008 
CR3: 00000000533a7000 CR4: 00000000000406e0
Mar  5 08:26:38 evangeline kernel: [109985.797386] DR0: 0000000000000000 
DR1: 0000000000000000 DR2: 0000000000000000
Mar  5 08:26:38 evangeline kernel: [109985.797388] DR3: 0000000000000000 
DR6: 00000000ffff0ff0 DR7: 0000000000000400
Mar  5 08:26:38 evangeline kernel: [109985.797391] Process motion (pid: 
26749, threadinfo ffff880018518000, task ffff88007b3b0050)
Mar  5 08:26:38 evangeline kernel: [109985.797393] Stack:
Mar  5 08:26:38 evangeline kernel: [109985.797394]  0000000000000001 
0000000000000000 ffff880037968c00 ffffffffa01d270d
Mar  5 08:26:38 evangeline kernel: [109985.797397]  0000000000000000 
00000000c0d05605 ffff88007b8ac080 ffff880037968c00
Mar  5 08:26:38 evangeline kernel: [109985.797401]  ffff88007a8c5400 
0000000000000000 0000000000000000 ffffffffa01d616c
Mar  5 08:26:38 evangeline kernel: [109985.797405] Call Trace:
Mar  5 08:26:38 evangeline kernel: [109985.797408]  [<ffffffffa01d270d>] 
? pwc_try_video_mode+0x2d/0xa5 [pwc]
Mar  5 08:26:38 evangeline kernel: [109985.797414]  [<ffffffffa01d616c>] 
? pwc_video_do_ioctl+0xe8b/0x127b [pwc]
Mar  5 08:26:38 evangeline kernel: [109985.797421]  [<ffffffff802379d7>] 
? default_wake_function+0x0/0x9
Mar  5 08:26:38 evangeline kernel: [109985.797426]  [<ffffffffa01a1a46>] 
? video_usercopy+0x17a/0x217 [videodev]
Mar  5 08:26:38 evangeline kernel: [109985.797433]  [<ffffffffa01d52e1>] 
? pwc_video_do_ioctl+0x0/0x127b [pwc]
Mar  5 08:26:38 evangeline kernel: [109985.797439]  [<ffffffffa01d164c>] 
? pwc_video_ioctl+0x65/0x7f [pwc]
Mar  5 08:26:38 evangeline kernel: [109985.797446]  [<ffffffffa01a110b>] 
? v4l2_ioctl+0x38/0x3a [videodev]
Mar  5 08:26:38 evangeline kernel: [109985.797451]  [<ffffffff802c2aa3>] 
? vfs_ioctl+0x56/0x6c
Mar  5 08:26:38 evangeline kernel: [109985.797455]  [<ffffffff802c2ef2>] 
? do_vfs_ioctl+0x439/0x472
Mar  5 08:26:38 evangeline kernel: [109985.797458]  [<ffffffff802b74c3>] 
? vfs_write+0x121/0x156
Mar  5 08:26:38 evangeline kernel: [109985.797462]  [<ffffffff802c2f7c>] 
? sys_ioctl+0x51/0x70
Mar  5 08:26:38 evangeline kernel: [109985.797465]  [<ffffffff8020bfea>] 
? system_call_fastpath+0x16/0x1b
Mar  5 08:26:38 evangeline kernel: [109985.797469] Code: 00 00 00 00 48 
c7 83 f0 00 00 00 00 00 00 00 48 89 c6 44 8b 05 81 23 01 00 31 ff 31 c9 
eb 36 48 89 c8 48 03 83 d0 00 00 00 85 ff <c7> 40 08 00 00 00 00 48 8b 
93 d0 00 00 00 7e 0c 48 8d 44 0a e8
Mar  5 08:26:38 evangeline kernel: [109985.797497] RIP 
[<ffffffffa01d1439>] pwc_reset_buffers+0x4a/0xdd [pwc]
Mar  5 08:26:38 evangeline kernel: [109985.797503]  RSP <ffff880018519cb8>
Mar  5 08:26:38 evangeline kernel: [109985.797505] CR2: 0000000000000008
Mar  5 08:26:38 evangeline kernel: [109985.797507] ---[ end trace 
9eae6837a465e0c1 ]---
Mar  5 08:27:08 evangeline motion: [0] Thread 1 - Watchdog timeout, 
trying to do a graceful restart
Mar  5 08:27:08 evangeline motion: [0] httpd Closing
Mar  5 08:27:08 evangeline motion: [0] httpd thread exit
Mar  5 08:28:08 evangeline motion: [0] Thread 1 - Watchdog timeout, did 
NOT restart graceful,killing it!
Mar  5 08:28:08 evangeline motion: [0] Calling vid_close() from 
motion_cleanup


--Multipart=_Thu__5_Mar_2009_17_49_09_-0800_4bkqFhLpWSHGh77_
Content-Type: text/plain;
 name="pwc_oops.txt"
Content-Disposition: attachment;
 filename="pwc_oops.txt"
Content-Transfer-Encoding: 7bit

Mar  4 23:44:23 evangeline motion: [1] Calling vid_close() from motion_cleanup
Mar  4 23:44:23 evangeline motion: [1] Closing video device /dev/video0
Mar  4 23:44:25 evangeline motion: [0] httpd Closing
Mar  4 23:44:25 evangeline motion: [0] httpd thread exit
Mar  4 23:44:25 evangeline motion: [0] Motion terminating
Mar  4 23:44:25 evangeline motion: [0] Removed process id file (pid file).
Mar  4 23:44:25 evangeline kernel: [109975.744529] PM: Syncing filesystems ... done.
Mar  5 08:26:38 evangeline kernel: [109976.151050] [drm:i915_get_vblank_counter] *ERROR* trying to get vblank count for disabled pipe 1
Mar  5 08:26:38 evangeline kernel: [109976.151853] Freezing user space processes ... (elapsed 0.01 seconds) done.
Mar  5 08:26:38 evangeline kernel: [109976.166792] Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
Mar  5 08:26:38 evangeline kernel: [109976.170089] Suspending console(s) (use no_console_suspend to debug)
Mar  5 08:26:38 evangeline kernel: [109976.596109] ACPI handle has no context!
Mar  5 08:26:38 evangeline kernel: [109976.596165] ACPI handle has no context!
Mar  5 08:26:38 evangeline kernel: [109976.612107] ITE8213_IDE 0000:03:05.0: PCI INT A disabled
Mar  5 08:26:38 evangeline kernel: [109976.612112] ACPI handle has no context!
Mar  5 08:26:38 evangeline kernel: [109976.628139] ACPI handle has no context!
Mar  5 08:26:38 evangeline kernel: [109976.628143] r8169 0000:02:00.0: PME# enabled
Mar  5 08:26:38 evangeline kernel: [109976.628149] ACPI handle has no context!
Mar  5 08:26:38 evangeline kernel: [109976.644141] ata_piix 0000:00:1f.5: PCI INT B disabled
Mar  5 08:26:38 evangeline kernel: [109976.660155] ata_piix 0000:00:1f.2: PCI INT B disabled
Mar  5 08:26:38 evangeline kernel: [109976.676132] ehci_hcd 0000:00:1d.7: PCI INT A disabled
Mar  5 08:26:38 evangeline kernel: [109976.676168] ehci_hcd 0000:00:1d.7: PME# disabled
Mar  5 08:26:38 evangeline kernel: [109976.692084] uhci_hcd 0000:00:1d.2: PCI INT C disabled
Mar  5 08:26:38 evangeline kernel: [109976.692115] uhci_hcd 0000:00:1d.1: PCI INT B disabled
Mar  5 08:26:38 evangeline kernel: [109976.692144] uhci_hcd 0000:00:1d.0: PCI INT A disabled
Mar  5 08:26:38 evangeline kernel: [109976.708089] HDA Intel 0000:00:1b.0: PCI INT A disabled
Mar  5 08:26:38 evangeline kernel: [109976.724081] ehci_hcd 0000:00:1a.7: PCI INT C disabled
Mar  5 08:26:38 evangeline kernel: [109976.724116] ehci_hcd 0000:00:1a.7: PME# disabled
Mar  5 08:26:38 evangeline kernel: [109976.740081] uhci_hcd 0000:00:1a.2: PCI INT C disabled
Mar  5 08:26:38 evangeline kernel: [109976.740111] uhci_hcd 0000:00:1a.1: PCI INT B disabled
Mar  5 08:26:38 evangeline kernel: [109976.740140] uhci_hcd 0000:00:1a.0: PCI INT A disabled
Mar  5 08:26:38 evangeline kernel: [109976.741032] ACPI: Preparing to enter system sleep state S3
Mar  5 08:26:38 evangeline kernel: [109976.743624] Disabling non-boot CPUs ...
Mar  5 08:26:38 evangeline kernel: [109976.745885] CPU 1 is now offline
Mar  5 08:26:38 evangeline kernel: [109976.745887] SMP alternatives: switching to UP code
Mar  5 08:26:38 evangeline kernel: [109976.853879] CPU0 attaching NULL sched-domain.
Mar  5 08:26:38 evangeline kernel: [109976.853881] CPU1 attaching NULL sched-domain.
Mar  5 08:26:38 evangeline kernel: [109976.860337] CPU0 attaching NULL sched-domain.
Mar  5 08:26:38 evangeline kernel: [109976.860458] CPU1 is down
Mar  5 08:26:38 evangeline kernel: [109976.860463] Back to C!
Mar  5 08:26:38 evangeline kernel: [109976.860463] CPU0: Thermal monitoring enabled (TM2)
Mar  5 08:26:38 evangeline kernel: [109976.860463] pci 0000:00:02.1: restoring config space at offset 0x4 (was 0x4, writing 0xe1400004)
Mar  5 08:26:38 evangeline kernel: [109976.860463] pci 0000:00:02.1: restoring config space at offset 0x1 (was 0x900000, writing 0x900007)
Mar  5 08:26:38 evangeline kernel: [109976.860463] HDA Intel 0000:00:1b.0: restoring config space at offset 0xf (was 0x100, writing 0x103)
Mar  5 08:26:38 evangeline kernel: [109976.860463] HDA Intel 0000:00:1b.0: restoring config space at offset 0x4 (was 0x4, writing 0xe1700004)
Mar  5 08:26:38 evangeline kernel: [109976.860463] HDA Intel 0000:00:1b.0: restoring config space at offset 0x3 (was 0x0, writing 0x8)
Mar  5 08:26:38 evangeline kernel: [109976.860463] HDA Intel 0000:00:1b.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100002)
Mar  5 08:26:38 evangeline kernel: [109976.860463] pcieport-driver 0000:00:1c.5: restoring config space at offset 0xf (was 0x200, writing 0x205)
Mar  5 08:26:38 evangeline kernel: [109976.860463] pcieport-driver 0000:00:1c.5: restoring config space at offset 0x9 (was 0x10001, writing 0xe151e151)
Mar  5 08:26:38 evangeline kernel: [109976.860463] pcieport-driver 0000:00:1c.5: restoring config space at offset 0x8 (was 0x0, writing 0xe0f0e000)
Mar  5 08:26:38 evangeline kernel: [109976.860463] pcieport-driver 0000:00:1c.5: restoring config space at offset 0x7 (was 0xf0f0, writing 0xc0c0)
Mar  5 08:26:38 evangeline kernel: [109976.860463] pcieport-driver 0000:00:1c.5: restoring config space at offset 0x3 (was 0x810000, writing 0x810008)
Mar  5 08:26:38 evangeline kernel: [109976.860463] pcieport-driver 0000:00:1c.5: restoring config space at offset 0x1 (was 0x100000, writing 0x100407)
Mar  5 08:26:38 evangeline kernel: [109976.860463] ata_piix 0000:00:1f.5: restoring config space at offset 0x1 (was 0x2b00003, writing 0x2b00007)
Mar  5 08:26:38 evangeline kernel: [109976.860463] r8169 0000:02:00.0: restoring config space at offset 0xf (was 0x1ff, writing 0x105)
Mar  5 08:26:38 evangeline kernel: [109976.860463] r8169 0000:02:00.0: restoring config space at offset 0x8 (was 0xc, writing 0xe150000c)
Mar  5 08:26:38 evangeline kernel: [109976.860463] r8169 0000:02:00.0: restoring config space at offset 0x6 (was 0xc, writing 0xe151000c)
Mar  5 08:26:38 evangeline kernel: [109976.860463] r8169 0000:02:00.0: restoring config space at offset 0x4 (was 0xfc01, writing 0xc001)
Mar  5 08:26:38 evangeline kernel: [109976.860463] r8169 0000:02:00.0: restoring config space at offset 0x3 (was 0x0, writing 0x8)
Mar  5 08:26:38 evangeline kernel: [109976.860463] r8169 0000:02:00.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100407)
Mar  5 08:26:38 evangeline kernel: [109976.860463] ITE8213_IDE 0000:03:05.0: restoring config space at offset 0xf (was 0x8080100, writing 0x808010a)
Mar  5 08:26:38 evangeline kernel: [109976.860463] ITE8213_IDE 0000:03:05.0: restoring config space at offset 0x8 (was 0x1, writing 0xd401)
Mar  5 08:26:38 evangeline kernel: [109976.860463] ITE8213_IDE 0000:03:05.0: restoring config space at offset 0x7 (was 0x1, writing 0xd301)
Mar  5 08:26:38 evangeline kernel: [109976.860463] ITE8213_IDE 0000:03:05.0: restoring config space at offset 0x6 (was 0x1, writing 0xd201)
Mar  5 08:26:38 evangeline kernel: [109976.860463] ITE8213_IDE 0000:03:05.0: restoring config space at offset 0x5 (was 0x1, writing 0xd101)
Mar  5 08:26:38 evangeline kernel: [109976.860463] ITE8213_IDE 0000:03:05.0: restoring config space at offset 0x4 (was 0x1, writing 0xd001)
Mar  5 08:26:38 evangeline kernel: [109976.860463] ITE8213_IDE 0000:03:05.0: restoring config space at offset 0x3 (was 0x2000, writing 0x4000)
Mar  5 08:26:38 evangeline kernel: [109976.860463] ITE8213_IDE 0000:03:05.0: restoring config space at offset 0x1 (was 0x2100000, writing 0x2100007)
Mar  5 08:26:38 evangeline kernel: [109976.860463] ohci1394 0000:03:07.0: restoring config space at offset 0xf (was 0x4020100, writing 0x4020104)
Mar  5 08:26:38 evangeline kernel: [109976.860463] ohci1394 0000:03:07.0: restoring config space at offset 0x5 (was 0x0, writing 0xe1600000)
Mar  5 08:26:38 evangeline kernel: [109976.860463] ohci1394 0000:03:07.0: restoring config space at offset 0x4 (was 0x0, writing 0xe1604000)
Mar  5 08:26:38 evangeline kernel: [109976.860463] ohci1394 0000:03:07.0: restoring config space at offset 0x3 (was 0x0, writing 0x2008)
Mar  5 08:26:38 evangeline kernel: [109976.860463] ohci1394 0000:03:07.0: restoring config space at offset 0x1 (was 0x2100000, writing 0x2100006)
Mar  5 08:26:38 evangeline kernel: [109976.871063] Enabling non-boot CPUs ...
Mar  5 08:26:38 evangeline kernel: [109976.871194] SMP alternatives: switching to SMP code
Mar  5 08:26:38 evangeline kernel: [109976.954102] Booting processor 1 APIC 0x1 ip 0x6000
Mar  5 08:26:38 evangeline kernel: [109976.853715] Initializing CPU#1
Mar  5 08:26:38 evangeline kernel: [109976.853715] Calibrating delay using timer specific routine.. 5999.35 BogoMIPS (lpj=11998713)
Mar  5 08:26:38 evangeline kernel: [109976.853715] CPU: L1 I cache: 32K, L1 D cache: 32K
Mar  5 08:26:38 evangeline kernel: [109976.853715] CPU: L2 cache: 6144K
Mar  5 08:26:38 evangeline kernel: [109976.853715] [ds] using Core 2/Atom configuration
Mar  5 08:26:38 evangeline kernel: [109976.853715] CPU 1/0x1 -> Node 0
Mar  5 08:26:38 evangeline kernel: [109976.853715] CPU: Physical Processor ID: 0
Mar  5 08:26:38 evangeline kernel: [109976.853715] CPU: Processor Core ID: 1
Mar  5 08:26:38 evangeline kernel: [109976.853715] CPU1: Thermal monitoring enabled (TM2)
Mar  5 08:26:38 evangeline kernel: [109977.044710] CPU1: Intel(R) Core(TM)2 Duo CPU     E8400  @ 3.00GHz stepping 0a
Mar  5 08:26:38 evangeline kernel: [109977.044737] CPU0 attaching NULL sched-domain.
Mar  5 08:26:38 evangeline kernel: [109977.048502] Switched to high resolution mode on CPU 1
Mar  5 08:26:38 evangeline kernel: [109977.060243] CPU0 attaching sched-domain:
Mar  5 08:26:38 evangeline kernel: [109977.060244]  domain 0: span 0-1 level MC
Mar  5 08:26:38 evangeline kernel: [109977.060245]   groups: 0 1
Mar  5 08:26:38 evangeline kernel: [109977.060248] CPU1 attaching sched-domain:
Mar  5 08:26:38 evangeline kernel: [109977.060249]  domain 0: span 0-1 level MC
Mar  5 08:26:38 evangeline kernel: [109977.060249]   groups: 1 0
Mar  5 08:26:38 evangeline kernel: [109977.060509] CPU1 is up
Mar  5 08:26:38 evangeline kernel: [109977.060511] ACPI: Waking up from system sleep state S3
Mar  5 08:26:38 evangeline kernel: [109977.064099] pci 0000:00:02.0: PME# disabled
Mar  5 08:26:38 evangeline kernel: [109977.064102] pci 0000:00:02.1: PME# disabled
Mar  5 08:26:38 evangeline kernel: [109977.064128] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Mar  5 08:26:38 evangeline kernel: [109977.064132] uhci_hcd 0000:00:1a.0: setting latency timer to 64
Mar  5 08:26:38 evangeline kernel: [109977.064149] usb usb1: root hub lost power or was reset
Mar  5 08:26:38 evangeline kernel: [109977.064190] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
Mar  5 08:26:38 evangeline kernel: [109977.064193] uhci_hcd 0000:00:1a.1: setting latency timer to 64
Mar  5 08:26:38 evangeline kernel: [109977.064209] usb usb2: root hub lost power or was reset
Mar  5 08:26:38 evangeline kernel: [109977.064241] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
Mar  5 08:26:38 evangeline kernel: [109977.064245] uhci_hcd 0000:00:1a.2: setting latency timer to 64
Mar  5 08:26:38 evangeline kernel: [109977.064261] usb usb3: root hub lost power or was reset
Mar  5 08:26:38 evangeline kernel: [109977.064303] ehci_hcd 0000:00:1a.7: PME# disabled
Mar  5 08:26:38 evangeline kernel: [109977.064306] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
Mar  5 08:26:38 evangeline kernel: [109977.064309] ehci_hcd 0000:00:1a.7: setting latency timer to 64
Mar  5 08:26:38 evangeline kernel: [109977.064313] ehci_hcd 0000:00:1a.7: PME# disabled
Mar  5 08:26:38 evangeline kernel: [109977.064344] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
Mar  5 08:26:38 evangeline kernel: [109977.064348] HDA Intel 0000:00:1b.0: setting latency timer to 64
Mar  5 08:26:38 evangeline kernel: [109977.064365] pcieport-driver 0000:00:1c.0: setting latency timer to 64
Mar  5 08:26:38 evangeline kernel: [109977.064370] pcieport-driver 0000:00:1c.5: setting latency timer to 64
Mar  5 08:26:38 evangeline kernel: [109977.064394] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
Mar  5 08:26:38 evangeline kernel: [109977.064398] uhci_hcd 0000:00:1d.0: setting latency timer to 64
Mar  5 08:26:38 evangeline kernel: [109977.064414] usb usb4: root hub lost power or was reset
Mar  5 08:26:38 evangeline kernel: [109977.064446] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
Mar  5 08:26:38 evangeline kernel: [109977.064449] uhci_hcd 0000:00:1d.1: setting latency timer to 64
Mar  5 08:26:38 evangeline kernel: [109977.064466] usb usb5: root hub lost power or was reset
Mar  5 08:26:38 evangeline kernel: [109977.064497] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
Mar  5 08:26:38 evangeline kernel: [109977.064504] uhci_hcd 0000:00:1d.2: setting latency timer to 64
Mar  5 08:26:38 evangeline kernel: [109977.064522] usb usb6: root hub lost power or was reset
Mar  5 08:26:38 evangeline kernel: [109977.064566] ehci_hcd 0000:00:1d.7: PME# disabled
Mar  5 08:26:38 evangeline kernel: [109977.064568] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
Mar  5 08:26:38 evangeline kernel: [109977.064572] ehci_hcd 0000:00:1d.7: setting latency timer to 64
Mar  5 08:26:38 evangeline kernel: [109977.064576] ehci_hcd 0000:00:1d.7: PME# disabled
Mar  5 08:26:38 evangeline kernel: [109977.064582] pci 0000:00:1e.0: setting latency timer to 64
Mar  5 08:26:38 evangeline kernel: [109977.064607] ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
Mar  5 08:26:38 evangeline kernel: [109977.064609] ata_piix 0000:00:1f.2: setting latency timer to 64
Mar  5 08:26:38 evangeline kernel: [109977.064652] ata_piix 0000:00:1f.5: PCI INT B -> GSI 19 (level, low) -> IRQ 19
Mar  5 08:26:38 evangeline kernel: [109977.064655] ata_piix 0000:00:1f.5: setting latency timer to 64
Mar  5 08:26:38 evangeline kernel: [109977.064729] r8169 0000:02:00.0: PME# disabled
Mar  5 08:26:38 evangeline kernel: [109977.064736] ITE8213_IDE 0000:03:05.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
Mar  5 08:26:38 evangeline kernel: [109977.080102] r8169: eth0: link down
Mar  5 08:26:38 evangeline kernel: [109977.120097] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[23]  MMIO=[e1604000-e16047ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
Mar  5 08:26:38 evangeline kernel: [109977.149264] r8169: eth0: link up
Mar  5 08:26:38 evangeline kernel: [109977.394578] ata3: SATA link down (SStatus 4 SControl 300)
Mar  5 08:26:38 evangeline kernel: [109977.405124] ata4: SATA link down (SStatus 4 SControl 300)
Mar  5 08:26:38 evangeline kernel: [109977.714588] ata1.00: SATA link down (SStatus 4 SControl 300)
Mar  5 08:26:38 evangeline kernel: [109977.714598] ata1.01: SATA link down (SStatus 4 SControl 300)
Mar  5 08:26:38 evangeline kernel: [109977.714605] usb 1-1: reset low speed USB device using uhci_hcd and address 2
Mar  5 08:26:38 evangeline kernel: [109977.726592] ata2.00: SATA link down (SStatus 4 SControl 300)
Mar  5 08:26:38 evangeline kernel: [109977.726603] ata2.01: SATA link down (SStatus 4 SControl 300)
Mar  5 08:26:38 evangeline kernel: [109984.187775] hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
Mar  5 08:26:38 evangeline kernel: [109984.196036] hda: UDMA/133 mode selected
Mar  5 08:26:38 evangeline kernel: [109984.197256] hda: dma_intr: status=0x51 { DriveReady SeekComplete Error }
Mar  5 08:26:38 evangeline kernel: [109984.197261] hda: dma_intr: error=0x84 <3>{ DriveStatusError BadCRC }
Mar  5 08:26:38 evangeline kernel: [109984.197262] ide: failed opcode was: unknown
Mar  5 08:26:38 evangeline kernel: [109984.202314] hda: dma_intr: status=0x51 { DriveReady SeekComplete Error }
Mar  5 08:26:38 evangeline kernel: [109984.202320] hda: dma_intr: error=0x84 <3>{ DriveStatusError BadCRC }
Mar  5 08:26:38 evangeline kernel: [109984.202322] ide: failed opcode was: unknown
Mar  5 08:26:38 evangeline kernel: [109984.229080] hda: dma_intr: status=0x51 { DriveReady SeekComplete Error }
Mar  5 08:26:38 evangeline kernel: [109984.229085] hda: dma_intr: error=0x84 <3>{ DriveStatusError BadCRC }
Mar  5 08:26:38 evangeline kernel: [109984.229088] ide: failed opcode was: unknown
Mar  5 08:26:38 evangeline kernel: [109984.233784] hda: dma_intr: status=0x51 { DriveReady SeekComplete Error }
Mar  5 08:26:38 evangeline kernel: [109984.233790] hda: dma_intr: error=0x84 <3>{ DriveStatusError BadCRC }
Mar  5 08:26:38 evangeline kernel: [109984.233792] ide: failed opcode was: unknown
Mar  5 08:26:38 evangeline kernel: [109984.233798] hda: UDMA/100 mode selected
Mar  5 08:26:38 evangeline kernel: [109984.280023] ide0: reset: success
Mar  5 08:26:38 evangeline kernel: [109984.308814] hda: Host Protected Area detected.
Mar  5 08:26:38 evangeline kernel: [109984.308815]      current capacity is 488395055 sectors (250058 MB)
Mar  5 08:26:38 evangeline kernel: [109984.308816]      native  capacity is 488397168 sectors (250059 MB)
Mar  5 08:26:38 evangeline kernel: [109984.319097] hda: task_no_data_intr: status=0x51 { DriveReady SeekComplete Error }
Mar  5 08:26:38 evangeline kernel: [109984.319103] hda: task_no_data_intr: error=0x04 <3>{ DriveStatusError }
Mar  5 08:26:38 evangeline kernel: [109984.319105] ide: failed opcode was: 0x37
Mar  5 08:26:38 evangeline kernel: [109984.319193] pci 0000:00:02.0: setting latency timer to 64
Mar  5 08:26:38 evangeline kernel: [109984.432029] usb 1-2: reset full speed USB device using uhci_hcd and address 4
Mar  5 08:26:38 evangeline kernel: [109985.080104] snd-usb-audio 1-2:1.1: no reset_resume for driver snd-usb-audio?
Mar  5 08:26:38 evangeline kernel: [109985.080106] snd-usb-audio 1-2:1.2: no reset_resume for driver snd-usb-audio?
Mar  5 08:26:38 evangeline kernel: [109985.092224] pwc: Logitech QuickCam 4000 Pro USB webcam detected.
Mar  5 08:26:38 evangeline kernel: [109985.092249] pwc: Registered as /dev/video0.
Mar  5 08:26:38 evangeline kernel: [109985.335512] Restarting tasks ... done.
Mar  5 08:26:38 evangeline acpid: client connected from 3861[0:0]
Mar  5 08:26:38 evangeline acpid: 1 client rule loaded
Mar  5 08:26:38 evangeline motion: [0] Processing thread 0 - config file /etc/motion/motion.conf
Mar  5 08:26:38 evangeline motion: [0] Motion 3.2.11 Started
Mar  5 08:26:38 evangeline motion: [0] Created process id file /var/run/motion/motion.pid. Process ID is 26748
Mar  5 08:26:38 evangeline motion: [0] Motion running as daemon process
Mar  5 08:26:38 evangeline motion: [0] ffmpeg LIBAVCODEC_BUILD 3355136 LIBAVFORMAT_BUILD 3409664
Mar  5 08:26:38 evangeline motion: [0] Thread 1 is from /etc/motion/motion.conf
Mar  5 08:26:38 evangeline motion: [1] Thread 1 started
Mar  5 08:26:38 evangeline motion: [0] motion-httpd/3.2.11 running, accepting connections
Mar  5 08:26:38 evangeline motion: [0] motion-httpd: waiting for data on port TCP 8080
Mar  5 08:26:38 evangeline motion: [1] cap.driver: "pwc"
Mar  5 08:26:38 evangeline motion: [1] cap.card: "Logitech QuickCam Pro 4000"
Mar  5 08:26:38 evangeline motion: [1] cap.bus_info: "usb-0000:00:1a.0-2"
Mar  5 08:26:38 evangeline motion: [1] cap.capabilities=0x05000001
Mar  5 08:26:38 evangeline motion: [1] - VIDEO_CAPTURE
Mar  5 08:26:38 evangeline motion: [1] - READWRITE
Mar  5 08:26:38 evangeline motion: [1] - STREAMING
Mar  5 08:26:38 evangeline motion: [1] Supported palettes:
Mar  5 08:26:38 evangeline motion: [1] 0: PWC2 (Raw Philips Webcam)
Mar  5 08:26:38 evangeline motion: [1] 1: YU12 (4:2:0, planar, Y-Cb-Cr)
Mar  5 08:26:38 evangeline motion: [1] Selected palette YU12
Mar  5 08:26:38 evangeline motion: [1] index_format 8 Test palette YU12 (320x240)
Mar  5 08:26:38 evangeline kernel: [109985.797284] BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
Mar  5 08:26:38 evangeline kernel: [109985.797290] IP: [<ffffffffa01d1439>] pwc_reset_buffers+0x4a/0xdd [pwc]
Mar  5 08:26:38 evangeline kernel: [109985.797299] PGD 51dad067 PUD 18485067 PMD 0 
Mar  5 08:26:38 evangeline kernel: [109985.797302] Oops: 0002 [#1] SMP 
Mar  5 08:26:38 evangeline kernel: [109985.797305] last sysfs file: /sys/class/video4linux/video0/index
Mar  5 08:26:38 evangeline kernel: [109985.797307] CPU 0 
Mar  5 08:26:38 evangeline kernel: [109985.797308] Modules linked in: i915 drm i2c_algo_bit acpi_cpufreq cpufreq_conservative cpufreq_powersave cpufreq_userspace cpufreq_stats cpufreq_ondemand freq_table ipv6 fuse coretemp it87 hwmon_vid sbp2 loop snd_hda_codec_intelhdmi snd_hda_codec_realtek snd_usb_audio snd_hda_intel snd_usb_lib snd_hda_codec snd_seq_midi snd_seq_midi_event snd_rawmidi snd_pcm snd_hwdep snd_seq snd_timer snd_seq_device pwc i2c_i801 psmouse snd videodev v4l1_compat i2c_core serio_raw iTCO_wdt snd_page_alloc soundcore pcspkr v4l2_compat_ioctl32 joydev intel_agp button evdev ext3 jbd mbcache ide_gd_mod ata_piix ata_generic libata scsi_mod hid_logitech ff_memless usbhid hid ohci1394 ieee1394 ide_pci_generic it8213 ide_core ehci_hcd r8169 mii uhci_hcd thermal processor fan thermal_sys
Mar  5 08:26:38 evangeline kernel: [109985.797356] Pid: 26749, comm: motion Not tainted 2.6.29-rc6 #1 EG45M-DS2H
Mar  5 08:26:38 evangeline kernel: [109985.797359] RIP: 0010:[<ffffffffa01d1439>]  [<ffffffffa01d1439>] pwc_reset_buffers+0x4a/0xdd [pwc]
Mar  5 08:26:38 evangeline kernel: [109985.797366] RSP: 0018:ffff880018519cb8  EFLAGS: 00010046
Mar  5 08:26:38 evangeline kernel: [109985.797368] RAX: 0000000000000000 RBX: ffff880037968c00 RCX: 0000000000000000
Mar  5 08:26:38 evangeline kernel: [109985.797370] RDX: ffffffff805852b8 RSI: 0000000000000296 RDI: 0000000000000000
Mar  5 08:26:38 evangeline kernel: [109985.797372] RBP: ffff880037968e70 R08: 0000000000000003 R09: 0000000000000000
Mar  5 08:26:38 evangeline kernel: [109985.797375] R10: 0000000000000000 R11: ffffffff804697f2 R12: 0000000000000001
Mar  5 08:26:38 evangeline kernel: [109985.797377] R13: 000000000000000a R14: 00000000000000f0 R15: 0000000000000140
Mar  5 08:26:38 evangeline kernel: [109985.797379] FS:  00007faba7078950(0000) GS:ffffffff80671000(0000) knlGS:0000000000000000
Mar  5 08:26:38 evangeline kernel: [109985.797382] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Mar  5 08:26:38 evangeline kernel: [109985.797384] CR2: 0000000000000008 CR3: 00000000533a7000 CR4: 00000000000406e0
Mar  5 08:26:38 evangeline kernel: [109985.797386] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Mar  5 08:26:38 evangeline kernel: [109985.797388] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Mar  5 08:26:38 evangeline kernel: [109985.797391] Process motion (pid: 26749, threadinfo ffff880018518000, task ffff88007b3b0050)
Mar  5 08:26:38 evangeline kernel: [109985.797393] Stack:
Mar  5 08:26:38 evangeline kernel: [109985.797394]  0000000000000001 0000000000000000 ffff880037968c00 ffffffffa01d270d
Mar  5 08:26:38 evangeline kernel: [109985.797397]  0000000000000000 00000000c0d05605 ffff88007b8ac080 ffff880037968c00
Mar  5 08:26:38 evangeline kernel: [109985.797401]  ffff88007a8c5400 0000000000000000 0000000000000000 ffffffffa01d616c
Mar  5 08:26:38 evangeline kernel: [109985.797405] Call Trace:
Mar  5 08:26:38 evangeline kernel: [109985.797408]  [<ffffffffa01d270d>] ? pwc_try_video_mode+0x2d/0xa5 [pwc]
Mar  5 08:26:38 evangeline kernel: [109985.797414]  [<ffffffffa01d616c>] ? pwc_video_do_ioctl+0xe8b/0x127b [pwc]
Mar  5 08:26:38 evangeline kernel: [109985.797421]  [<ffffffff802379d7>] ? default_wake_function+0x0/0x9
Mar  5 08:26:38 evangeline kernel: [109985.797426]  [<ffffffffa01a1a46>] ? video_usercopy+0x17a/0x217 [videodev]
Mar  5 08:26:38 evangeline kernel: [109985.797433]  [<ffffffffa01d52e1>] ? pwc_video_do_ioctl+0x0/0x127b [pwc]
Mar  5 08:26:38 evangeline kernel: [109985.797439]  [<ffffffffa01d164c>] ? pwc_video_ioctl+0x65/0x7f [pwc]
Mar  5 08:26:38 evangeline kernel: [109985.797446]  [<ffffffffa01a110b>] ? v4l2_ioctl+0x38/0x3a [videodev]
Mar  5 08:26:38 evangeline kernel: [109985.797451]  [<ffffffff802c2aa3>] ? vfs_ioctl+0x56/0x6c
Mar  5 08:26:38 evangeline kernel: [109985.797455]  [<ffffffff802c2ef2>] ? do_vfs_ioctl+0x439/0x472
Mar  5 08:26:38 evangeline kernel: [109985.797458]  [<ffffffff802b74c3>] ? vfs_write+0x121/0x156
Mar  5 08:26:38 evangeline kernel: [109985.797462]  [<ffffffff802c2f7c>] ? sys_ioctl+0x51/0x70
Mar  5 08:26:38 evangeline kernel: [109985.797465]  [<ffffffff8020bfea>] ? system_call_fastpath+0x16/0x1b
Mar  5 08:26:38 evangeline kernel: [109985.797469] Code: 00 00 00 00 48 c7 83 f0 00 00 00 00 00 00 00 48 89 c6 44 8b 05 81 23 01 00 31 ff 31 c9 eb 36 48 89 c8 48 03 83 d0 00 00 00 85 ff <c7> 40 08 00 00 00 00 48 8b 93 d0 00 00 00 7e 0c 48 8d 44 0a e8 
Mar  5 08:26:38 evangeline kernel: [109985.797497] RIP  [<ffffffffa01d1439>] pwc_reset_buffers+0x4a/0xdd [pwc]
Mar  5 08:26:38 evangeline kernel: [109985.797503]  RSP <ffff880018519cb8>
Mar  5 08:26:38 evangeline kernel: [109985.797505] CR2: 0000000000000008
Mar  5 08:26:38 evangeline kernel: [109985.797507] ---[ end trace 9eae6837a465e0c1 ]---
Mar  5 08:27:08 evangeline motion: [0] Thread 1 - Watchdog timeout, trying to do a graceful restart
Mar  5 08:27:08 evangeline motion: [0] httpd Closing
Mar  5 08:27:08 evangeline motion: [0] httpd thread exit
Mar  5 08:28:08 evangeline motion: [0] Thread 1 - Watchdog timeout, did NOT restart graceful,killing it!
Mar  5 08:28:08 evangeline motion: [0] Calling vid_close() from motion_cleanup
Mar  5 08:35:01 evangeline /USR/SBIN/CRON[26764]: (root) CMD (command -v debian-sa1 > /dev/null && debian-sa1 1 1)
Mar  5 08:43:36 evangeline shutdown[26766]: shutting down for system halt

--Multipart=_Thu__5_Mar_2009_17_49_09_-0800_4bkqFhLpWSHGh77_--
