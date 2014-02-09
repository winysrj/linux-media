Return-path: <linux-media-owner@vger.kernel.org>
Received: from outrelay02.libero.it ([212.52.84.102]:40932 "EHLO
	outrelay02.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641AbaBIWvZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 9 Feb 2014 17:51:25 -0500
Received: from wmail47 (172.31.0.237) by outrelay02.libero.it (8.5.140.03)
        id 52F1E20A009741FF for linux-media@vger.kernel.org; Sun, 9 Feb 2014 23:51:22 +0100
Message-ID: <24531158.2645611391986282827.JavaMail.defaultUser@defaultHost>
Date: Sun, 9 Feb 2014 23:51:22 +0100 (CET)
From: "valerio.vanni@inwind.it" <valerio.vanni@inwind.it>
Reply-To: "valerio.vanni@inwind.it" <valerio.vanni@inwind.it>
To: <linux-media@vger.kernel.org>
Subject: saa7134 warning during resume from S3
MIME-Version: 1.0
Content-Type: text/plain;charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

[1.] One line summary of the problem:

Kernel from 3.12.6 (did not try lower) to 3.13.2 gives a warning during resume 
from S3 sleep

[2.] Full description of the problem/report:

It doesn't happen with 2.6.24.7.
OS is Debian Lenny, with vanilla kernel. It happens the same after upgrade to 
Squeeze.

I suspend the machine with s2ram and it goes off.
During the resume it writes that warning, then it seem to work normally, 
except for serial redirection of console.

I use redirection of console to serial port (with lilo directive: append="
console=ttyS0 console=tty0") and I check the messages in another machine.
This stops working as soon as I resume. It begins to send mangled lines and 
it doesn't work again until the next full restart.
Only the serial redirection has this problem, the local console  works.

dmesg:

PM: Syncing filesystems ... done.
PM: Preparing system for mem sleep
Freezing user space processes ... (elapsed 0.001 seconds) done.
Freezing remaining freezable tasks ... (elapsed 0.006 seconds) done.
PM: Entering mem sleep
Suspending console(s) (use no_console_suspend to debug)
sd 5:0:0:0: [sdc] Synchronizing SCSI cache
sd 4:0:0:0: [sdb] Synchronizing SCSI cache
sd 5:0:0:0: [sdc] Stopping disk
sd 4:0:0:0: [sdb] Stopping disk
sd 1:0:0:0: [sda] Synchronizing SCSI cache
parport_pc 00:09: disabled
serial 00:08: disabled
serial 00:08: System wakeup disabled by ACPI
serial 00:07: disabled
serial 00:07: System wakeup disabled by ACPI
sd 1:0:0:0: [sda] Stopping disk
PM: suspend of devices complete after 859.795 msecs
PM: late suspend of devices complete after 0.144 msecs
pcieport 0000:00:1c.5: System wakeup enabled by ACPI
ehci-pci 0000:00:1d.7: System wakeup enabled by ACPI
uhci_hcd 0000:00:1d.2: System wakeup enabled by ACPI
uhci_hcd 0000:00:1d.1: System wakeup enabled by ACPI
uhci_hcd 0000:00:1d.0: System wakeup enabled by ACPI
ehci-pci 0000:00:1a.7: System wakeup enabled by ACPI
uhci_hcd 0000:00:1a.2: System wakeup enabled by ACPI
uhci_hcd 0000:00:1a.1: System wakeup enabled by ACPI
uhci_hcd 0000:00:1a.0: System wakeup enabled by ACPI
PM: noirq suspend of devices complete after 32.930 msecs
ACPI: Preparing to enter system sleep state S3
PM: Saving platform NVS memory
Disabling non-boot CPUs ...
smpboot: CPU 1 is now offline
smpboot: CPU 2 is now offline
smpboot: CPU 3 is now offline
ACPI: Low-level resume complete
PM: Restoring platform NVS memory
Enabling non-boot CPUs ...
x86: Booting SMP configuration:
smpboot: Booting Node 0 Processor 1 APIC 0x1
Initializing CPU#1
CPU1 is up
smpboot: Booting Node 0 Processor 2 APIC 0x3
Initializing CPU#2
CPU2 is up
smpboot: Booting Node 0 Processor 3 APIC 0x2
Initializing CPU#3
CPU3 is up
ACPI: Waking up from system sleep state S3
uhci_hcd 0000:00:1a.0: System wakeup disabled by ACPI
uhci_hcd 0000:00:1a.1: System wakeup disabled by ACPI
uhci_hcd 0000:00:1a.2: System wakeup disabled by ACPI
ehci-pci 0000:00:1a.7: System wakeup disabled by ACPI
uhci_hcd 0000:00:1d.0: System wakeup disabled by ACPI
uhci_hcd 0000:00:1d.1: System wakeup disabled by ACPI
uhci_hcd 0000:00:1d.2: System wakeup disabled by ACPI
ehci-pci 0000:00:1d.7: System wakeup disabled by ACPI
PM: noirq resume of devices complete after 99.105 msecs
PM: early resume of devices complete after 0.059 msecs
usb usb3: root hub lost power or was reset
usb usb4: root hub lost power or was reset
usb usb5: root hub lost power or was reset
snd_hda_intel 0000:00:1b.0: irq 45 for MSI/MSI-X
usb usb6: root hub lost power or was reset
usb usb7: root hub lost power or was reset
pcieport 0000:00:1c.5: System wakeup disabled by ACPI
usb usb8: root hub lost power or was reset
saa7133[0]: board init: gpio is 40000
serial 00:07: activated
serial 00:08: activated
parport_pc 00:09: activated
r8169 0000:03:00.0 eth0: link down
------------[ cut here ]------------
WARNING: CPU: 0 PID: 7928 at kernel/kmod.c:148 __request_module+0x34/0x1ae()
Modules linked in: vmnet(O) vsock(O) vmci(O) vmmon(O) lp fbcon font bitblit 
softcursor i915 drm_kms_helper fb fbdev cfbcopyarea video backlight cfbimgblt 
cfbfillrect bnep nfsd lockd sunrpc fuse saa7134_alsa snd_seq_dummy snd_seq_oss 
snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_seq_device cifs rfcomm 
bluetooth rfkill it87 hwmon_vid isofs zlib_inflate nls_utf8 nls_iso8859_1 
nls_cp850 nls_cp437 nls_ascii cpuid vfat ntfs msdos fat udf nls_iso8859_15 
softdog loop tda1004x saa7134_dvb videobuf_dvb dvb_core tda827x mousedev 
tda8290 tuner snd_hda_codec_realtek snd_hda_intel snd_hda_codec saa7134 
v4l2_common usb_storage videodev r8169 snd_hwdep parport_pc snd_pcm_oss 
snd_mixer_oss videobuf_dma_sg mii ehci_pci parport videobuf_core snd_pcm 
uhci_hcd firewire_ohci firewire_core evdev crc_itu_t ehci_hcd psmouse rtc_cmos 
tveeprom pcspkr intel_agp intel_gtt snd_timer snd_page_alloc
CPU: 0 PID: 7928 Comm: kworker/u8:12 Tainted: G           O 3.13.2 #1
Hardware name: Gigabyte Technology Co., Ltd. G33M-S2/G33M-S2, BIOS F7f 
04/02/2008
Workqueue: events_unbound async_run_entry_fn
 00000000 00000000 c13534fe c103d476 c102e079 00000009 f13ede00 f534f1a4
 f80630d0 f534f024 c102e099 00000009 00000000 c103d476 ffffffff 01000282
 c1036a29 00000282 f13edda4 c155c680 c155c680 c1036a5c 003a8aba c1353657
Call Trace:
 [<c13534fe>] ? dump_stack+0x3e/0x50
 [<c103d476>] ? __request_module+0x34/0x1ae
 [<c102e079>] ? warn_slowpath_common+0x66/0x7a
 [<c102e099>] ? warn_slowpath_null+0xc/0xf
 [<c103d476>] ? __request_module+0x34/0x1ae
 [<c1036a29>] ? try_to_del_timer_sync+0x3a/0x41
 [<c1036a5c>] ? del_timer_sync+0x2c/0x36
 [<c1353657>] ? schedule_timeout+0x147/0x15d
 [<c1036aa6>] ? del_timer+0x40/0x40
 [<f8062370>] ? v4l2_i2c_new_subdev_board+0x23/0xa7 [v4l2_common]
 [<f806243d>] ? v4l2_i2c_new_subdev+0x49/0x51 [v4l2_common]
 [<f831290b>] ? saa7134_board_init2+0x869/0xb58 [saa7134]
 [<c1036a29>] ? try_to_del_timer_sync+0x3a/0x41
 [<c1036a5c>] ? del_timer_sync+0x2c/0x36
 [<c1353657>] ? schedule_timeout+0x147/0x15d
 [<c1030003>] ? do_exit+0x51a/0x7ce
 [<f8313ca7>] ? saa7134_resume+0xbf/0x150 [saa7134]
 [<c11ef0a7>] ? pci_legacy_resume+0x23/0x2c
 [<c11ef19a>] ? pci_pm_thaw+0x62/0x62
 [<c12650d5>] ? dpm_run_callback+0x25/0x60
 [<c1265308>] ? device_resume+0x10f/0x12c
 [<c1265338>] ? async_resume+0x13/0x33
 [<c1048004>] ? async_run_entry_fn+0x52/0xf3
 [<c103fba7>] ? process_one_work+0x200/0x331
 [<c103fe83>] ? worker_thread+0x1ab/0x2e1
 [<c103fcd8>] ? process_one_work+0x331/0x331
 [<c1044120>] ? kthread+0xa1/0xaa
 [<c135b837>] ? ret_from_kernel_thread+0x1b/0x28
 [<c104407f>] ? kthread_freezable_should_stop+0x4d/0x4d
---[ end trace d02ad8471166632e ]---
ata7.01: ACPI cmd ef/03:0c:00:00:00:b0 (SET FEATURES) filtered out
ata7.01: ACPI cmd ef/03:46:00:00:00:b0 (SET FEATURES) filtered out
ata7.01: configured for UDMA/66
ata1: SATA link down (SStatus 0 SControl 300)
/dev/vmmon[0]: HostIFReadUptimeWork: detected settimeofday: fixed uptimeBase 
old 18445352091656191211 new 18445352091650191210 attempts 1
firewire_core 0000:04:07.0: rediscovered device fw0
r8169 0000:03:00.0 eth0: link up
ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata2.00: configured for UDMA/133
sd 1:0:0:0: [sda] Starting disk
ata6: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata6.00: configured for UDMA/133
sd 5:0:0:0: [sdc] Starting disk
ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata5.00: configured for UDMA/133
sd 4:0:0:0: [sdb] Starting disk

floppy driver state
-------------------
now=3846048 last interrupt=4294717586 diff=4095758 last called 
handler=seek_interrupt
timeout_message=lock fdc
last output bytes:
 8 80 4294677234
 8 80 4294677234
 8 80 4294677234
 8 80 4294677234
12 80 4294717581
 0 90 4294717581
13 90 4294717581
 0 90 4294717581
1a 90 4294717581
 0 90 4294717581
 3 90 4294717581
c1 90 4294717581
10 90 4294717581
 7 90 4294717581
 0 90 4294717581
 8 81 4294717581
 f 80 4294717581
 0 90 4294717581
 1 91 4294717581
 8 81 4294717586
last result at 4294717586
last redo_fd_request at 4294717606
20 01                                             .
status=0
fdc_busy=1
do_floppy=reset_interrupt
cont=c139ffb8
current_req=  (null)
command_status=-1

floppy0: floppy timeout called
PM: resume of devices complete after 10521.796 msecs
psmouse serio1: Wheel Mouse at isa0060/serio1/input0 lost synchronization, 
throwing 3 bytes away.
psmouse serio1: resync failed, issuing reconnect request
PM: Finishing wakeup.
Restarting tasks ... done.
device eth0 left promiscuous mode
bridge-eth0: disabled promiscuous mode
bridge-eth0: disabling the bridge
bridge-eth0: down
bridge-eth0: detached
/dev/vmnet: open called by PID 3506 (vmnet-bridge)
/dev/vmnet: port on hub 0 successfully opened
bridge-eth0: up
bridge-eth0: attached
device eth0 entered promiscuous mode
bridge-eth0: enabled promiscuous mode
userif-3: sent link down event.
userif-3: sent link up event.

