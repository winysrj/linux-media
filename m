Return-path: <linux-media-owner@vger.kernel.org>
Received: from bar.sig21.net ([80.81.252.164]:45396 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750821AbaIYN02 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Sep 2014 09:26:28 -0400
Date: Thu, 25 Sep 2014 14:53:53 +0200
From: Johannes Stezenbach <js@linuxtv.org>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: em28xx breaks after hibernate
Message-ID: <20140925125353.GA5129@linuxtv.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Shuah,

ever since your patchset which implements suspend/resume
for em28xx, hibernating the system breaks the Hauppauge WinTV HVR 930C driver.
In v3.15.y and v3.16.y it throws a request_firmware warning
during hibernate + resume, and the /dev/dvb/ device nodes disappears after
resume.  In current git v3.17-rc6-247-g005f800, it hangs
after resume.  I bisected the hang in qemu to
b89193e0b06f "media: em28xx - remove reset_resume interface",
the hang is fixed if I revert this commit on top of v3.17-rc6-247-g005f800.

Regarding the request_firmware issue. I think a possible
fix would be:

--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -2568,16 +2568,8 @@ int dvb_frontend_resume(struct dvb_frontend *fe)
        dev_dbg(fe->dvb->device, "%s: adap=%d fe=%d\n", __func__, fe->dvb->num,
                        fe->id);

-       fe->exit = DVB_FE_DEVICE_RESUME;
-       if (fe->ops.init)
-               ret = fe->ops.init(fe);
-
-       if (fe->ops.tuner_ops.init)
-               ret = fe->ops.tuner_ops.init(fe);
-
-       fe->exit = DVB_FE_NO_EXIT;
        fepriv->state = FESTATE_RETUNE;
-       dvb_frontend_wakeup(fe);
+       dvb_frontend_reinitialise(fe);

        return ret;
 }


But of course this has the potential of breaking other drivers...

Below is a full log of the suspend + resume in qemu with
no_console_suspend.


Johannes


qemu command line:

qemu-system-x86_64 -enable-kvm -smp cpus=4 -m 1G -net nic,model=virtio -net user -hda debian-7.6.0.qcow2 -device usb-ehci,id=ehci -device usb-host,vendorid=0x2040,productid=0x1605,bus=ehci.0 -nographic -kernel ~/src/linux/linux/arch/x86/boot/bzImage -initrd initrd.img-3.16.0 -append "BOOT_IMAGE=/boot/vmlinuz-3.16.0 root=UUID=0ae480bd-5598-4e64-97d7-2c42f9fc181f ro console=ttyS0 no_console_suspend


root@debian:~# echo disk >/sys/power/state
[   19.480127] PM: Syncing filesystems ... done.
[   19.668347] Freezing user space processes ... (elapsed 0.001 seconds) done.
[   19.671188] PM: Preallocating image memory... done (allocated 28094 pages)
[   19.712341] PM: Allocated 112376 kbytes in 0.03 seconds (3745.86 MB/s)
[   19.713514] Freezing remaining freezable tasks ... (elapsed 0.001 seconds) done.
[   19.717168] em2884 #0: Suspending extensions
[   19.717966] em2884 #0: Suspending video extensionem2884 #0: Suspending DVB extension
[   19.727558] em2884 #0: fe0 suspend 0[   19.729164] PM: freeze of devices complete after 12.270 msecs
[   19.730921] PM: late freeze of devices complete after 0.719 msecs
[   19.733542] PM: noirq freeze of devices complete after 1.502 msecs
[   19.734705] ACPI: Preparing to enter system sleep state S4
[   19.735779] PM: Saving platform NVS memory
[   19.736533] Disabling non-boot CPUs ...
[   19.741134] smpboot: CPU 1 is now offline
[   19.848207] smpboot: CPU 2 is now offline
[   19.852923] smpboot: CPU 3 is now offline
[   19.855558] PM: Creating hibernation image:
[   19.856897] PM: Need to copy 27321 pages
[   19.856897] PM: Hibernation image created (27321 pages copied)
[   19.856897] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S0_] (20140724/hwxface-580)
[   19.856897] PM: Restoring platform NVS memory
[   19.856897] Enabling non-boot CPUs ...
[   19.856897] x86: Booting SMP configuration:
[   19.857612] smpboot: Booting Node 0 Processor 1 APIC 0x1
[   19.890484] CPU1 is up
[   19.891693] smpboot: Booting Node 0 Processor 2 APIC 0x2
[   19.924539] CPU2 is up
[   19.925693] smpboot: Booting Node 0 Processor 3 APIC 0x3
[   19.958401] CPU3 is up
[   19.961935] ACPI: Waking up from system sleep state S4
[   19.963712] PM: noirq thaw of devices complete after 0.705 msecs
[   19.965505] PM: early thaw of devices complete after 0.572 msecs
[   19.967322] rtc_cmos 00:00: System wakeup disabled by ACPI
[   20.003710] em2884 #0: Resuming extensions
[   20.004481] em2884 #0: Resuming video extensionem2884 #0: Resuming DVB extension
[   20.007581] ------------[ cut here ]------------
[   20.008557] WARNING: CPU: 0 PID: 2061 at drivers/base/firmware_class.c:1124 _request_firmware+0x205/0x568()
[   20.010348] Modules linked in:
[   20.011001] CPU: 0 PID: 2061 Comm: kworker/u8:11 Not tainted 3.17.0-rc6+ #78
[   20.012289] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
[   20.014149] Workqueue: events_unbound async_run_entry_fn
[   20.015144]  0000000000000000 ffff88003c233a28 ffffffff814b5228 0000000000000000
[   20.016551]  ffff88003c233a60 ffffffff81032d75 ffffffff81320b03 00000000fffffff5
[   20.018012]  ffff88003cf10640 ffff88003c68be80 00000000ffffff00 ffff88003c233a70
[   20.019410] Call Trace:
[   20.019850]  [<ffffffff814b5228>] dump_stack+0x4e/0x7a
[   20.020890]  [<ffffffff81032d75>] warn_slowpath_common+0x7a/0x93
[   20.021976]  [<ffffffff81320b03>] ? _request_firmware+0x205/0x568
[   20.023079]  [<ffffffff81032e32>] warn_slowpath_null+0x15/0x17
[   20.024092]  [<ffffffff81320b03>] _request_firmware+0x205/0x568
[   20.025063]  [<ffffffff813b4a3d>] ? i2c_unlock_adapter+0x2c/0x2f
[   20.026051]  [<ffffffff813b5890>] ? i2c_transfer+0x68/0x77
[   20.026903]  [<ffffffff81320e96>] request_firmware+0x30/0x42
[   20.027766]  [<ffffffff813ccc00>] xc_load_fw_and_init_tuner+0x5c/0x504
[   20.028821]  [<ffffffff8107329d>] ? vprintk_emit+0x48a/0x4ce
[   20.029721]  [<ffffffff813621da>] ? usb_dev_restore+0x10/0x10
[   20.030687]  [<ffffffff813621da>] ? usb_dev_restore+0x10/0x10
[   20.031597]  [<ffffffff813cd0e8>] xc5000_init+0x40/0x72
[   20.032435]  [<ffffffff8140ef4c>] dvb_frontend_resume+0x3d/0x6b
[   20.033358]  [<ffffffff8141b2d3>] em28xx_dvb_resume+0x4a/0x88
[   20.034251]  [<ffffffff81415871>] em28xx_resume_extension+0x4b/0x63
[   20.035322]  [<ffffffff81416d0f>] em28xx_usb_resume+0x15/0x1c
[   20.036256]  [<ffffffff8136e2a9>] usb_resume_interface.isra.6+0x9e/0xc1
[   20.037324]  [<ffffffff8136e542>] usb_resume_both+0xe3/0x103
[   20.038245]  [<ffffffff8136eec6>] usb_resume+0x16/0x5b
[   20.039068]  [<ffffffff813621e8>] usb_dev_thaw+0xe/0x10
[   20.039870]  [<ffffffff8131d71b>] dpm_run_callback+0x3f/0x76
[   20.040767]  [<ffffffff8131e34b>] device_resume+0x155/0x17f
[   20.041637]  [<ffffffff8131e38d>] async_resume+0x18/0x3e
[   20.042472]  [<ffffffff8104c526>] async_run_entry_fn+0x5c/0x106
[   20.043389]  [<ffffffff8104585c>] process_one_work+0x1d2/0x38a
[   20.044309]  [<ffffffff81062d20>] ? trace_hardirqs_off_caller+0x40/0xad
[   20.045342]  [<ffffffff810462f0>] worker_thread+0x1f6/0x2a3
[   20.046204]  [<ffffffff810460fa>] ? rescuer_thread+0x214/0x214
[   20.047111]  [<ffffffff81049c09>] kthread+0xc7/0xcf
[   20.047870]  [<ffffffff8125d4c9>] ? debug_smp_processor_id+0x17/0x19
[   20.048872]  [<ffffffff8106555c>] ? trace_hardirqs_on_caller+0x183/0x19f
[   20.049929]  [<ffffffff81049b42>] ? __kthread_parkme+0x62/0x62
[   20.050846]  [<ffffffff814c0dac>] ret_from_fork+0x7c/0xb0
[   20.051668]  [<ffffffff81049b42>] ? __kthread_parkme+0x62/0x62
[   20.052594] ---[ end trace 341a76dbbf738774 ]---
[   20.053304] usb 1-1: firmware: dvb-fe-xc5000-1.6.114.fw will not be loaded
[   20.054397] xc5000: Upload failed. (file not found?)
[   20.055180] xc5000: Unable to initialise tuner
[   20.055913] em2884 #0: fe0 resume -121
[   20.126710] ata2.00: configured for MWDMA2
[   20.127755] ata1.00: configured for MWDMA2
[   20.150715] PM: thaw of devices complete after 184.135 msecs
[   20.154370] PM: Using 3 thread(s) for compression.
[   20.154370] PM: Compressing and saving image data (27375 pages)...
[   20.156441] PM: Image saving progress:   0%
[   20.210485] PM: Image saving progress:  10%
[   20.239342] PM: Image saving progress:  20%
[   20.271955] PM: Image saving progress:  30%
[   20.317421] PM: Image saving progress:  40%
[   20.387014] PM: Image saving progress:  50%
[   20.441198] PM: Image saving progress:  60%
[   20.484778] PM: Image saving progress:  70%
[   20.515542] PM: Image saving progress:  80%
[   20.567877] PM: Image saving progress:  90%
[   20.633093] PM: Image saving progress: 100%
[   20.645414] PM: Image saving done.
[   20.646053] PM: Wrote 109500 kbytes in 0.48 seconds (228.12 MB/s)
[   20.648376] PM: S|
[   20.670678] em2884 #0: Suspending extensions
[   20.671609] em2884 #0: Suspending video extension[   20.671821] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[   20.674728] em2884 #0: Suspending DVB extension
[   20.682641] em2884 #0: fe0 suspend 0[   21.153386] sd 0:0:0:0: [sda] Stopping disk
[   21.155681] PM: hibernate of devices complete after 485.213 msecs
[   21.158574] PM: late hibernate of devices complete after 1.078 msecs
[   21.162488] PM: noirq hibernate of devices complete after 1.511 msecs
[   21.164919] ACPI: Preparing to enter system sleep state S4
[   21.166179] PM: Saving platform NVS memory
[   21.167430] Disabling non-boot CPUs ...
[   21.170629] smpboot: CPU 1 is now offline
[   21.174669] smpboot: CPU 2 is now offline
[   21.178254] smpboot: CPU 3 is now offline

$ ./run-qemu.sh
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.17.0-rc6+ (js@abc) (gcc version 4.9.1 (Debian 4.9.1-15) ) #78 SMP PREEMPT Thu Sep 25 14:13:36 CEST 2014
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-3.16.0 root=UUID=0ae480bd-5598-4e64-97d7-2c42f9fc181f ro console=ttyS0 no_console_suspend
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000f0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000003ffdffff] usable
[    0.000000] BIOS-e820: [mem 0x000000003ffe0000-0x000000003fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000feffc000-0x00000000feffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fffc0000-0x00000000ffffffff] reserved
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.8 present.
[    0.000000] e820: last_pfn = 0x3ffe0 max_arch_pfn = 0x400000000
[    0.000000] PAT not supported by CPU.
[    0.000000] found SMP MP-table at [mem 0x000f0e80-0x000f0e8f] mapped at [ffff8800000f0e80]
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000] init_memory_mapping: [mem 0x3fc00000-0x3fdfffff]
[    0.000000] init_memory_mapping: [mem 0x3c000000-0x3fbfffff]
[    0.000000] init_memory_mapping: [mem 0x00100000-0x3bffffff]
[    0.000000] init_memory_mapping: [mem 0x3fe00000-0x3ffdffff]
[    0.000000] RAMDISK: [mem 0x3fe0f000-0x3ffdffff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F0BD0 000014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 0x000000003FFE1968 000034 (v01 BOCHS  BXPCRSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: FACP 0x000000003FFE0B37 000074 (v01 BOCHS  BXPCFACP 00000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 0x000000003FFE0040 000AF7 (v01 BOCHS  BXPCDSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: FACS 0x000000003FFE0000 000040
[    0.000000] ACPI: SSDT 0x000000003FFE0BAB 000CF5 (v01 BOCHS  BXPCSSDT 00000001 BXPC 00000001)
[    0.000000] ACPI: APIC 0x000000003FFE18A0 000090 (v01 BOCHS  BXPCAPIC 00000001 BXPC 00000001)
[    0.000000] ACPI: HPET 0x000000003FFE1930 000038 (v01 BOCHS  BXPCHPET 00000001 BXPC 00000001)
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009efff]
[    0.000000]   node   0: [mem 0x00100000-0x3ffdffff]
[    0.000000] ACPI: PM-Timer IO Port: 0x608
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high level)
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000effff]
[    0.000000] PM: Registered nosave memory: [mem 0x000f0000-0x000fffff]
[    0.000000] e820: [mem 0x40000000-0xfeffbfff] available for PCI devices
[    0.000000] setup_percpu: NR_CPUS:16 nr_cpumask_bits:16 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 476 pages/cpu @ffff88003e000000 s1917376 r8192 d24128 u2097152
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 258409
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.16.0 root=UUID=0ae480bd-5598-4e64-97d7-2c42f9fc181f ro console=ttyS0 no_console_suspend
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
[    0.000000] Memory: 993136K/1048056K available (4877K kernel code, 872K rwdata, 2996K rodata, 2668K init, 15516K bss, 54920K reserved)
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000]  RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000]  RCU restricting CPUs from NR_CPUS=16 to nr_cpu_ids=4.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=4
[    0.000000] NR_IRQS:4352 nr_irqs:456 0
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [ttyS0] enabled
[    0.000000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.000000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.000000] ... MAX_LOCK_DEPTH:          48
[    0.000000] ... MAX_LOCKDEP_KEYS:        8191
[    0.000000] ... CLASSHASH_SIZE:          4096
[    0.000000] ... MAX_LOCKDEP_ENTRIES:     32768
[    0.000000] ... MAX_LOCKDEP_CHAINS:      65536
[    0.000000] ... CHAINHASH_SIZE:          32768
[    0.000000]  memory used by lock dependency info: 8671 kB
[    0.000000]  per task-struct memory footprint: 2688 bytes
[    0.000000] ODEBUG: selftest passed
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 3300.005 MHz processor
[    0.008003] Calibrating delay loop (skipped), value calculated using timer frequency.. 6600.01 BogoMIPS (lpj=13200020)
[    0.009841] pid_max: default: 32768 minimum: 301
[    0.012056] ACPI: Core revision 20140724
[    0.017232] ACPI: All ACPI Tables successfully acquired
[    0.018452] Security Framework initialized
[    0.019198] AppArmor: AppArmor disabled by boot time parameter
[    0.020062] Mount-cache hash table entries: 2048 (order: 2, 16384 bytes)
[    0.021217] Mountpoint-cache hash table entries: 2048 (order: 2, 16384 bytes)
[    0.023443] Initializing cgroup subsys devices
[    0.024023] Initializing cgroup subsys freezer
[    0.024835] Initializing cgroup subsys blkio
[    0.025594] Initializing cgroup subsys perf_event
[    0.026484] Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
[    0.026484] Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
[    0.028241] Freeing SMP alternatives memory: 12K (ffffffff81d77000 - ffffffff81d7a000)
[    0.032181] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.073142] smpboot: CPU0: Intel QEMU Virtual CPU version 2.1.0 (fam: 06, model: 06, stepping: 03)
[    0.076000] Performance Events: Broken PMU hardware detected, using software events only.
[    0.076000] Failed to access perfctr msr (MSR c1 is 0)
[    0.096251] NMI watchdog: disabled (cpu0): hardware events not enabled
[    0.104767] x86: Booting SMP configuration:
[    0.105704] .... node  #0, CPUs:      #1 #2 #3
[    0.400047] x86: Booted up 1 node, 4 CPUs
[    0.400837] smpboot: Total of 4 processors activated (26401.72 BogoMIPS)
[    0.402582] devtmpfs: initialized
[    0.405501] NET: Registered protocol family 16
[    0.408870] cpuidle: using governor menu
[    0.409712] ACPI: bus type PCI registered
[    0.410748] PCI: Using configuration type 1 for base access
[    0.436864] ACPI: Added _OSI(Module Device)
[    0.437126] ACPI: Added _OSI(Processor Device)
[    0.440004] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.440889] ACPI: Added _OSI(Processor Aggregator Device)
[    0.447801] ACPI: Interpreter enabled
[    0.448008] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20140724/hwxface-580)
[    0.449697] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20140724/hwxface-580)
[    0.451387] ACPI: (supports S0 S3 S4 S5)
[    0.452003] ACPI: Using IOAPIC for interrupt routing
[    0.452927] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.469357] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.470489] acpi PNP0A03:00: _OSC: OS supports [ASPM ClockPM Segments MSI]
[    0.471759] acpi PNP0A03:00: _OSC failed (AE_NOT_FOUND); disabling ASPM
[    0.472286] acpi PNP0A03:00: fail to add MMCONFIG information, can't access extended PCI configuration space under this bridge.
[    0.474571] PCI host bridge to bus 0000:00
[    0.476005] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.476931] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.477911] pci_bus 0000:00: root bus resource [io  0x0d00-0xadff]
[    0.478853] pci_bus 0000:00: root bus resource [io  0xae0f-0xaeff]
[    0.480003] pci_bus 0000:00: root bus resource [io  0xaf20-0xafdf]
[    0.480953] pci_bus 0000:00: root bus resource [io  0xafe4-0xffff]
[    0.481903] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.482966] pci_bus 0000:00: root bus resource [mem 0x40000000-0xfebfffff]
[    0.489221] pci 0000:00:01.1: legacy IDE quirk: reg 0x10: [io  0x01f0-0x01f7]
[    0.490499] pci 0000:00:01.1: legacy IDE quirk: reg 0x14: [io  0x03f6]
[    0.491649] pci 0000:00:01.1: legacy IDE quirk: reg 0x18: [io  0x0170-0x0177]
[    0.492003] pci 0000:00:01.1: legacy IDE quirk: reg 0x1c: [io  0x0376]
[    0.493966] pci 0000:00:01.3: quirk: [io  0x0600-0x063f] claimed by PIIX4 ACPI
[    0.496013] pci 0000:00:01.3: quirk: [io  0x0700-0x070f] claimed by PIIX4 SMB
[    0.521089] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.522398] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.523684] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.524460] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.525621] ACPI: PCI Interrupt Link [LNKS] (IRQs *9)
[    0.528789] ACPI: Enabled 16 GPEs in block 00 to 0F
[    0.530415] vgaarb: setting as boot device: PCI:0000:00:02.0
[    0.530415] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.532005] vgaarb: loaded
[    0.532522] vgaarb: bridge control possible 0000:00:02.0
[    0.534290] SCSI subsystem initialized
[    0.536339] ACPI: bus type USB registered
[    0.537085] usbcore: registered new interface driver usbfs
[    0.538172] usbcore: registered new interface driver hub
[    0.539289] usbcore: registered new device driver usb
[    0.540139] Linux video capture interface: v2.00
[    0.541040] PCI: Using ACPI for IRQ routing
[    0.542990] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.544023] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.544954] hpet0: 3 comparators, 64-bit 100.000000 MHz counter
[    0.550797] Switched to clocksource hpet
[    0.575439] pnp: PnP ACPI init
[    0.578087] pnp: PnP ACPI: found 6 devices
[    0.602325] NET: Registered protocol family 2
[    0.604233] TCP established hash table entries: 8192 (order: 4, 65536 bytes)
[    0.605806] TCP bind hash table entries: 8192 (order: 7, 655360 bytes)
[    0.607736] TCP: Hash tables configured (established 8192 bind 8192)
[    0.609240] TCP: reno registered
[    0.609846] UDP hash table entries: 512 (order: 4, 98304 bytes)
[    0.611021] UDP-Lite hash table entries: 512 (order: 4, 98304 bytes)
[    0.613256] NET: Registered protocol family 1
[    0.614118] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.615185] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.616240] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.776576] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[    0.938281] Unpacking initramfs...
[    0.972552] Freeing initrd memory: 1860K (ffff88003fe0f000 - ffff88003ffe0000)
[    0.977096] futex hash table entries: 1024 (order: 5, 131072 bytes)
[    0.978532] audit: initializing netlink subsys (disabled)
[    0.979685] audit: type=2000 audit(1411647433.976:1): initialized
[    0.982257] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.986563] msgmni has been set to 1943
[    0.988218] cryptomgr_test (44) used greatest stack depth: 13744 bytes left
[    0.991147] alg: No test for stdrng (krng)
[    0.992115] bounce: pool size: 64 pages
[    0.993013] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.994364] io scheduler noop registered
[    0.995095] io scheduler deadline registered
[    0.996164] io scheduler cfq registered (default)
[    0.999181] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    1.000655] ACPI: Power Button [PWRF]
[    1.002215] GHES: HEST is not enabled!
[    1.170574] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.195612] 00:05: ttyS0 at I/O 0x3f8 (irq = 4, base_baud = 115200) is a 16550A
[    1.198825] Linux agpgart interface v0.103
[    1.200126] [drm] Initialized drm 1.1.0 20060810
[    1.202535] Floppy drive(s):
[    1.203070]  fd0 is 1.44M[    1.203584]
[    1.206540] loop: module loaded
[    1.210757] scsi host0: ata_piix
[    1.212493] scsi host1: ata_piix
[    1.213397] ata1: PATA max MWDMA2 cmd 0x1f0 ctl 0x3f6 bmdma 0xc020 irq 14
[    1.214611] ata2: PATA max MWDMA2 cmd 0x170 ctl 0x376 bmdma 0xc028 irq 15
[    1.218321] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    1.219531] ehci-pci: EHCI PCI platform driver
[    1.225656] FDC 0 is a S82078B
[    1.373312] ata2.00: ATAPI: QEMU DVD-ROM, 2.1.0, max UDMA/100
[    1.374602] ata1.00: ATA-7: QEMU HARDDISK, 2.1.0, max UDMA/100
[    1.375668] ata1.00: 16777216 sectors, multi 16: LBA48
[    1.377339] ata2.00: configured for MWDMA2
[    1.378261] ata1.00: configured for MWDMA2
[    1.387757] ehci-pci 0000:00:04.0: EHCI Host Controller
[    1.389320] ehci-pci 0000:00:04.0: new USB bus registered, assigned bus number 1
[    1.541889] ehci-pci 0000:00:04.0: irq 11, io mem 0xfebd2000
[    1.542554] scsi 0:0:0:0: Direct-Access     ATA      QEMU HARDDISK    0    PQ: 0 ANSI: 5
[    1.544480] sd 0:0:0:0: [sda] 16777216 512-byte logical blocks: (8.58 GB/8.00 GiB)
[    1.544851] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    1.544886] sd 0:0:0:0: [sda] Write Protect is off
[    1.545018] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.546528] scsi 1:0:0:0: CD-ROM            QEMU     QEMU DVD-ROM     2.1. PQ: 0 ANSI: 5
[    1.549967]  sda: sda1 sda2
[    1.551665] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.557081] sr 1:0:0:0: [sr0] scsi3-mmc drive: 4x/4x cd/rw xa/form2 tray
[    1.558312] cdrom: Uniform CD-ROM driver Revision: 3.20
[    1.561004] sr 1:0:0:0: Attached scsi generic sg1 type 5
[    1.564132] ehci-pci 0000:00:04.0: USB 2.0 started, EHCI 1.00
[    1.565415] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    1.566640] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.567930] usb usb1: Product: EHCI Host Controller
[    1.568915] usb usb1: Manufacturer: Linux 3.17.0-rc6+ ehci_hcd
[    1.569986] usb usb1: SerialNumber: 0000:00:04.0
[    1.571882] hub 1-0:1.0: USB hub found
[    1.572659] hub 1-0:1.0: 6 ports detected
[    1.574930] uhci_hcd: USB Universal Host Controller Interface driver
[    1.576498] usbcore: registered new interface driver usb-storage
[    1.577719] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
[    1.580157] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.581162] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.583110] mousedev: PS/2 mouse device common for all mice
[    1.585879] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input1
[    1.587719] rtc_cmos 00:00: RTC can wake from S4
[    1.590271] rtc_cmos 00:00: rtc core: registered rtc_cmos as rtc0
[    1.591734] rtc_cmos 00:00: alarms up to one day, 114 bytes nvram, hpet irqs
[    1.593417] piix4_smbus 0000:00:01.3: SMBus Host Controller at 0x700, revision 0
[    1.596473] usbcore: registered new interface driver em28xx
[    1.597544] em28xx: Registered (Em28xx v4l2 Extension) extension
[    1.598644] em28xx: Registered (Em28xx dvb Extension) extension
[    1.600492] usbcore: registered new interface driver usbhid
[    1.601483] usbhid: USB HID core driver
[    1.602252] TCP: cubic registered
[    1.602862] NET: Registered protocol family 17
[    1.604628] registered taskstats version 1
[    1.606628] rtc_cmos 00:00: setting system clock to 2014-09-25 12:17:15 UTC (1411647435)
[    1.614294] Freeing unused kernel memory: 2668K (ffffffff81adc000 - ffffffff81d77000)
[    1.615703] Write protecting the kernel read-only data: 10240k
[    1.621271] Freeing unused kernel memory: 1260K (ffff8800014c5000 - ffff880001600000)
[    1.625984] Freeing unused kernel memory: 1100K (ffff8800018ed000 - ffff880001a00000)
Loading, please wait...
[    1.653961] udevd[79]: starting version 175
[    1.824003] ata_id (161) used greatest stack depth: 13408 bytes left
[    1.978760] tsc: Refined TSC clocksource calibration: 3299.997 MHz
[    1.999472] ata_id (160) used greatest stack depth: 12408 bytes left
[    2.032199] usb 1-1: new high-speed USB device number 2 using ehci-pci
modprobe: chdir(3.17.0-rc6+): No such file or directory
Begin: Loading essential drivers ... modprobe: chdir(3.17.0-rc6+): No such file or directory
modprobe: chdir(3.17.0-rc6+): No such file or directory
done.
Begin: Running /scripts/init-premount ... done.
Begin: Mounting root file system ... Begin: Running /scripts/local-top ... done.
Begin: Running /scripts/local-premount ... [    2.258357] PM: Starting manual resume from disk
[    2.268775] Freezing user space processes ... (elapsed 0.003 seconds) done.
[    2.279909] PM: Using 3 thread(s) for decompression.
[    2.279909] PM: Loading and decompressing image data (27375 pages)...
[    2.316994] PM: Image loading progress:   0%
[    2.319476] usb 1-1: New USB device found, idVendor=2040, idProduct=1605
[    2.320928] usb 1-1: New USB device strings: Mfr=0, Product=1, SerialNumber=2
[    2.322236] usb 1-1: Product: WinTV HVR-930C
[    2.323126] usb 1-1: SerialNumber: 4034209007
[    2.326389] em28xx: New device  WinTV HVR-930C @ 480 Mbps (2040:1605, interface 0, class 0)
[    2.327949] em28xx: Audio interface 0 found (Vendor Class)
[    2.329072] em28xx: Video interface 0 found: isoc
[    2.329934] em28xx: DVB interface 0 found: isoc
[    2.331397] em28xx: chip ID is em2884
[    2.400710] em2884 #0: EEPROM ID = 26 00 01 00, EEPROM hash = 0x33f006aa
[    2.402240] em2884 #0: EEPROM info:
[    2.402901] em2884 #0:       microcode start address = 0x0004, boot configuration = 0x01
[    2.424604] em2884 #0:       I2S audio, 5 sample rates
[    2.425919] em2884 #0:       500mA max power
[    2.426856] em2884 #0:       Table at offset 0x24, strings=0x1e82, 0x186a, 0x0000
[    2.428604] em2884 #0: Identified as Hauppauge WinTV HVR 930C (card=81)
[    2.430181] tveeprom 2-0050: Hauppauge model 16009, rev B1F0, serial# 7677167
[    2.431754] tveeprom 2-0050: MAC address is 00:0d:fe:75:24:ef
[    2.432973] tveeprom 2-0050: tuner model is Xceive XC5000 (idx 150, type 76)
[    2.434591] tveeprom 2-0050: TV standards PAL(B/G) PAL(I) SECAM(L/L') PAL(D/D1/K) ATSC/DVB Digital (eeprom 0xf4)
[    2.436503] tveeprom 2-0050: audio processor is unknown (idx 45)
[    2.437651] tveeprom 2-0050: decoder processor is unknown (idx 44)
[    2.438788] tveeprom 2-0050: has no radio, has IR receiver, has no IR transmitter
[    2.440241] em2884 #0: analog set to isoc mode.
[    2.441086] em2884 #0: dvb set to isoc mode.
[    2.442069] em2884 #0: Registering V4L2 extension
[    2.443805] em2884 #0: Config register raw data: 0xc3
[    2.458044] PM: Image loading progress:  10%
[    2.463275] em2884 #0: V4L2 video device registered as video0
[    2.464437] em2884 #0: V4L2 extension successfully initialized
[    2.465560] em2884 #0: Binding DVB extension
[    2.479459] input: ImExPS/2 Generic Explorer Mouse as /devices/platform/i8042/serio1/input/input3
[    2.485455] PM: Image loading progress:  20%
[    2.507997] PM: Image loading progress:  30%
[    2.528243] PM: Image loading progress:  40%
[    2.548193] PM: Image loading progress:  50%
[    2.567568] PM: Image loading progress:  60%
[    2.584754] PM: Image loading progress:  70%
[    2.605406] PM: Image loading progress:  80%
[    2.622287] PM: Image loading progress:  90%
[    2.640716] PM: Image loading progress: 100%
[    2.641694] PM: Image loading done.
[    2.642317] PM: Read 109500 kbytes in 0.35 seconds (312.85 MB/s)
[    2.652111] em2884 #0: Suspending extensions
[    2.981457] Switched to clocksource tsc
[    3.776327] ------------[ cut here ]------------
[    3.778261] WARNING: CPU: 2 PID: 40 at drivers/base/firmware_class.c:1124 _request_firmware+0x205/0x568()
[    3.780934] Modules linked in:
[    3.781765] CPU: 2 PID: 40 Comm: kworker/2:1 Not tainted 3.17.0-rc6+ #78
[    3.783389] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.7.5-20140531_083030-gandalf 04/01/2014
[    3.785887] Workqueue: events request_module_async
[    3.787451]  0000000000000000 ffff88003d403b40 ffffffff814b5228 0000000000000000
[    3.789003]  ffff88003d403b78 ffffffff81032d75 ffffffff81320b03 00000000fffffff5
[    3.790558]  ffff880039ebada0 ffff88003ca61700 ffff88003cf20900 ffff88003d403b88
[    3.792082] Call Trace:
[    3.792597]  [<ffffffff814b5228>] dump_stack+0x4e/0x7a
[    3.793514]  [<ffffffff81032d75>] warn_slowpath_common+0x7a/0x93
[    3.794555]  [<ffffffff81320b03>] ? _request_firmware+0x205/0x568
[    3.795610]  [<ffffffff81032e32>] warn_slowpath_null+0x15/0x17
[    3.796566]  [<ffffffff81320b03>] _request_firmware+0x205/0x568
[    3.797514]  [<ffffffff81065585>] ? trace_hardirqs_on+0xd/0xf
[    3.798420]  [<ffffffff81063c2c>] ? lockdep_init_map+0xc4/0x13f
[    3.799350]  [<ffffffff81320e96>] request_firmware+0x30/0x42
[    3.800293]  [<ffffffff813f2f6b>] drxk_attach+0x546/0x656
[    3.801170]  [<ffffffff814ba9e2>] em28xx_dvb_init.part.3+0xa1c/0x1cc6
[    3.802181]  [<ffffffff8106555c>] ? trace_hardirqs_on_caller+0x183/0x19f
[    3.803229]  [<ffffffff814be28d>] ? mutex_unlock+0x9/0xb
[    3.804091]  [<ffffffff814b96b1>] ? em28xx_v4l2_init.part.11+0xcbd/0xd04
[    3.805147]  [<ffffffff8141b7fa>] em28xx_dvb_init+0x1d/0x1f
[    3.806049]  [<ffffffff81415753>] em28xx_init_extension+0x51/0x67
[    3.807032]  [<ffffffff81416d4b>] request_module_async+0x19/0x1b
[    3.807984]  [<ffffffff8104585c>] process_one_work+0x1d2/0x38a
[    3.808916]  [<ffffffff810462f0>] worker_thread+0x1f6/0x2a3
[    3.809799]  [<ffffffff810460fa>] ? rescuer_thread+0x214/0x214
[    3.810694]  [<ffffffff81049c09>] kthread+0xc7/0xcf
[    3.811437]  [<ffffffff8125d4c9>] ? debug_smp_processor_id+0x17/0x19
[    3.812442]  [<ffffffff8106555c>] ? trace_hardirqs_on_caller+0x183/0x19f
[    3.813514]  [<ffffffff81049b42>] ? __kthread_parkme+0x62/0x62
[    3.814460]  [<ffffffff814c0dac>] ret_from_fork+0x7c/0xb0
[    3.815325]  [<ffffffff81049b42>] ? __kthread_parkme+0x62/0x62
[    3.816251] ---[ end trace aacc7afef85cf9bc ]---
[    3.817008] usb 1-1: firmware: dvb-usb-hauppauge-hvr930c-drxk.fw will not be loaded
[    3.818212] drxk: Could not load firmware file dvb-usb-hauppauge-hvr930c-drxk.fw.
[    3.819342] drxk: Copy dvb-usb-hauppauge-hvr930c-drxk.fw to your hotplug directory!
[    3.855389] drxk: status = 0x439130d9
[    3.856161] drxk: detected a drx-3913k, spin A2, xtal 20.250 MHz
[    3.958678] drxk: DRXK driver version 0.9.4300
[    4.044508] drxk: frontend initialized.
[    4.046224] xc5000 2-0061: creating new instance
[    4.053942] xc5000: Successfully identified at address 0x61
[    4.056237] xc5000: Firmware has not been loaded previously
[    4.058346] DVB: registering new adapter (em2884 #0)
[    4.059633] usb 1-1: DVB: registering adapter 0 frontend 0 (DRXK DVB-C DVB-T)...
[    4.061572] dvb dvb0.frontend0: parent 1-1 should not be sleeping
[    4.063825] dvb dvb0.demux0: parent 1-1 should not be sleeping
[    4.065179] dvb dvb0.dvr0: parent 1-1 should not be sleeping
[    4.066456] dvb dvb0.net0: parent 1-1 should not be sleeping
[    4.067742] em2884 #0: DVB extension successfully initialized
[    4.068859] em2884 #0: Suspending video extension
[    4.073226] em2884 #0: Suspending DVB extensionem2884 #0: fe0 suspend 0
[    4.082060] PM: quiesce of devices complete after 1430.328 msecs
[    4.084126] PM: late quiesce of devices complete after 0.945 msecs
[    4.086801] PM: noirq quiesce of devices complete after 1.571 msecs
[    4.088083] Disabling non-boot CPUs ...
[    4.161837] smpboot: CPU 1 is now offline
[    4.344159] smpboot: CPU 2 is now offline
[    4.417596] smpboot: CPU 3 is now offline
[   19.856897] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S0_] (20140724/hwxface-580)
[   19.856897] PM: Restoring platform NVS memory
[   19.856897] Enabling non-boot CPUs ...
[   19.856897] x86: Booting SMP configuration:
[   19.857663] smpboot: Booting Node 0 Processor 1 APIC 0x1
[   19.890544] CPU1 is up
[   19.891716] smpboot: Booting Node 0 Processor 2 APIC 0x2
[   19.924528] CPU2 is up
[   19.925751] smpboot: Booting Node 0 Processor 3 APIC 0x3
[   19.958521] CPU3 is up
[   19.959262] ACPI: Waking up from system sleep state S4
[   19.962267] PM: noirq restore of devices complete after 1.908 msecs
[   19.964326] PM: early restore of devices complete after 0.814 msecs
[   19.992310] rtc_cmos 00:00: System wakeup disabled by ACPI
[   19.996155] usb usb1: root hub lost power or was reset
[   20.149788] sd 0:0:0:0: [sda] Starting disk
[   20.153624] ata1.00: configured for MWDMA2
[   20.301061] ata2.00: configured for MWDMA2
[   20.570672] Clocksource tsc unstable (delta = -90514299 ns)
[   20.572354] Switched to clocksource hpet
[   20.624243] usb 1-1: reset high-speed USB device number 2 using ehci-pci
[   20.915865] em2884 #0: Disconnecting em2884 #0
[   20.917709] em2884 #0: Closing video extension
[   20.918605] em2884 #0: V4L2 device video0 deregistered
[   20.921576] em2884 #0: Closing DVB extension
[   20.925706] xc5000 2-0061: destroying instance
[  240.440383] INFO: task kworker/u8:11:2061 blocked for more than 120 seconds.
[  240.443089]       Not tainted 3.17.0-rc6+ #78
[  240.444747] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  240.447486] kworker/u8:11   D ffff88003cbea4d0 13352  2061      2 0x00000000
[  240.450013] Workqueue: events_unbound async_run_entry_fn
[  240.451956]  ffff88003cd139b0 0000000000000046 ffffffff81a13580 ffff88003cd13fd8
[  240.454602]  ffff88003cbea4d0 00000000001d3400 7fffffffffffffff ffff88003d50a7e8
[  240.457202]  0000000000000002 ffffffff814bf9b1 ffff88003d50a7f0 ffff88003cd139c0
[  240.460130] Call Trace:
[  240.460625]  [<ffffffff814bf9b1>] ? console_conditional_schedule+0x27/0x27
[  240.461916]  [<ffffffff814bc514>] schedule+0x64/0x66
[  240.462878]  [<ffffffff814bf9e0>] schedule_timeout+0x2f/0xef
[  240.464695]  [<ffffffff810653c2>] ? mark_held_locks+0x5d/0x74
[  240.466417]  [<ffffffff814c0387>] ? _raw_spin_unlock_irq+0x27/0x46
[  240.468391]  [<ffffffff814bf9b1>] ? console_conditional_schedule+0x27/0x27
[  240.470376]  [<ffffffff8106555c>] ? trace_hardirqs_on_caller+0x183/0x19f
[  240.472433]  [<ffffffff81065585>] ? trace_hardirqs_on+0xd/0xf
[  240.474065]  [<ffffffff814bcce4>] do_wait_for_common+0xf9/0x131
[  240.475804]  [<ffffffff814bcce4>] ? do_wait_for_common+0xf9/0x131
[  240.477595]  [<ffffffff81053dd9>] ? wake_up_state+0xd/0xd
[  240.479220]  [<ffffffff814bcde5>] wait_for_common+0x4a/0x64
[  240.480802]  [<ffffffff814bce17>] wait_for_completion+0x18/0x1a
[  240.482413]  [<ffffffff813b5587>] i2c_del_adapter+0x17b/0x1be
[  240.484115]  [<ffffffff81416b3b>] em28xx_i2c_unregister+0x24/0x28
[  240.485777]  [<ffffffff81416c8c>] em28xx_release_resources+0x3b/0x64
[  240.487577]  [<ffffffff81416da4>] em28xx_usb_disconnect+0x57/0x6a
[  240.489331]  [<ffffffff8136ec49>] usb_unbind_interface+0x75/0x1fd
[  240.491037]  [<ffffffff81315190>] __device_release_driver+0x84/0xde
[  240.492792]  [<ffffffff813151ff>] device_release_driver+0x15/0x21
[  240.494371]  [<ffffffff8136ee14>] usb_driver_release_interface+0x43/0x78
[  240.496276]  [<ffffffff813621ca>] ? usb_for_each_dev+0x2b/0x2b
[  240.497788]  [<ffffffff8136ee67>] usb_forced_unbind_intf+0x1e/0x25
[  240.499477]  [<ffffffff8136eea6>] unbind_marked_interfaces.isra.9+0x38/0x42
[  240.501365]  [<ffffffff8136eef8>] usb_resume+0x48/0x5b
[  240.502707]  [<ffffffff813621d8>] usb_dev_restore+0xe/0x10
[  240.504192]  [<ffffffff8131d71b>] dpm_run_callback+0x3f/0x76
[  240.505602]  [<ffffffff8131e34b>] device_resume+0x155/0x17f
[  240.507047]  [<ffffffff8131e38d>] async_resume+0x18/0x3e
[  240.508452]  [<ffffffff8104c526>] async_run_entry_fn+0x5c/0x106
[  240.509939]  [<ffffffff8104585c>] process_one_work+0x1d2/0x38a
[  240.511455]  [<ffffffff81062d20>] ? trace_hardirqs_off_caller+0x40/0xad
[  240.513149]  [<ffffffff810462f0>] worker_thread+0x1f6/0x2a3
[  240.514488]  [<ffffffff810460fa>] ? rescuer_thread+0x214/0x214
[  240.515949]  [<ffffffff81049c09>] kthread+0xc7/0xcf
[  240.517188]  [<ffffffff8125d4c9>] ? debug_smp_processor_id+0x17/0x19
[  240.518712]  [<ffffffff8106555c>] ? trace_hardirqs_on_caller+0x183/0x19f
[  240.520435]  [<ffffffff81049b42>] ? __kthread_parkme+0x62/0x62
[  240.521833]  [<ffffffff814c0dac>] ret_from_fork+0x7c/0xb0
[  240.523202]  [<ffffffff81049b42>] ? __kthread_parkme+0x62/0x62
[  240.524603] 5 locks held by kworker/u8:11/2061:
[  240.525647]  #0:  ("events_unbound"){.+.+.+}, at: [<ffffffff810457e0>] process_one_work+0x156/0x38a
[  240.527878]  #1:  ((&entry->work)){+.+.+.}, at: [<ffffffff810457e0>] process_one_work+0x156/0x38a
[  240.530065]  #2:  (&dev->mutex){......}, at: [<ffffffff8131e243>] device_resume+0x4d/0x17f
[  240.532163]  #3:  (&dev->mutex){......}, at: [<ffffffff81314f37>] device_lock+0xf/0x11
[  240.534106]  #4:  (&dev->lock){+.+.+.}, at: [<ffffffff81416c6c>] em28xx_release_resources+0x1b/0x64
[  240.536394] INFO: task kworker/u8:12:2062 blocked for more than 120 seconds.
[  240.537948]       Not tainted 3.17.0-rc6+ #78
[  240.538939] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  240.540747] kworker/u8:12   D ffff88003cbd8510 14072  2062      2 0x00000000
[  240.542349] Workqueue: events_unbound async_run_entry_fn
[  240.543607]  ffff88003ccfbb70 0000000000000046 ffff88003cbca550 ffff88003ccfbfd8
[  240.545362]  ffff88003cbd8510 00000000001d3400 7fffffffffffffff ffff88003c6f5a18
[  240.547090]  0000000000000002 ffffffff814bf9b1 ffff88003c6f5a20 ffff88003ccfbb80
[  240.548789] Call Trace:
[  240.549336]  [<ffffffff814bf9b1>] ? console_conditional_schedule+0x27/0x27
[  240.550798]  [<ffffffff814bc514>] schedule+0x64/0x66
[  240.551906]  [<ffffffff814bf9e0>] schedule_timeout+0x2f/0xef
[  240.553172]  [<ffffffff810653c2>] ? mark_held_locks+0x5d/0x74
[  240.554400]  [<ffffffff814c0387>] ? _raw_spin_unlock_irq+0x27/0x46
[  240.555788]  [<ffffffff814bf9b1>] ? console_conditional_schedule+0x27/0x27
[  240.557268]  [<ffffffff8106555c>] ? trace_hardirqs_on_caller+0x183/0x19f
[  240.558647]  [<ffffffff81065585>] ? trace_hardirqs_on+0xd/0xf
[  240.559905]  [<ffffffff814bcce4>] do_wait_for_common+0xf9/0x131
[  240.561189]  [<ffffffff814bcce4>] ? do_wait_for_common+0xf9/0x131
[  240.562452]  [<ffffffff81053dd9>] ? wake_up_state+0xd/0xd
[  240.563619]  [<ffffffff814bcde5>] wait_for_common+0x4a/0x64
[  240.564814]  [<ffffffff814bce17>] wait_for_completion+0x18/0x1a
[  240.566041]  [<ffffffff8131d3bb>] dpm_wait+0x2c/0x2e
[  240.567078]  [<ffffffff8131e239>] device_resume+0x43/0x17f
[  240.568239]  [<ffffffff8131e38d>] async_resume+0x18/0x3e
[  240.569309]  [<ffffffff8104c526>] async_run_entry_fn+0x5c/0x106
[  240.570493]  [<ffffffff8104585c>] process_one_work+0x1d2/0x38a
[  240.571706]  [<ffffffff81062d20>] ? trace_hardirqs_off_caller+0x40/0xad
[  240.573079]  [<ffffffff810462f0>] worker_thread+0x1f6/0x2a3
[  240.574192]  [<ffffffff810460fa>] ? rescuer_thread+0x214/0x214
[  240.575411]  [<ffffffff81049c09>] kthread+0xc7/0xcf
[  240.576434]  [<ffffffff8125d4c9>] ? debug_smp_processor_id+0x17/0x19
[  240.577660]  [<ffffffff8106555c>] ? trace_hardirqs_on_caller+0x183/0x19f
[  240.579018]  [<ffffffff81049b42>] ? __kthread_parkme+0x62/0x62
[  240.580205]  [<ffffffff814c0dac>] ret_from_fork+0x7c/0xb0
[  240.581250]  [<ffffffff81049b42>] ? __kthread_parkme+0x62/0x62
[  240.582414] 2 locks held by kworker/u8:12/2062:
[  240.583034]  #0:  ("events_unbound"){.+.+.+}, at: [<ffffffff810457e0>] process_one_work+0x156/0x38a
[  240.584301]  #1:  ((&entry->work)){+.+.+.}, at: [<ffffffff810457e0>] process_one_work+0x156/0x38a
[  240.585488] INFO: task kworker/u8:13:2063 blocked for more than 120 seconds.
[  240.586770]       Not tainted 3.17.0-rc6+ #78
[  240.587664] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  240.589237] kworker/u8:13   D ffff88003cbca550 14072  2063      2 0x00000000
[  240.590676] Workqueue: events_unbound async_run_entry_fn
[  240.591778]  ffff88003ccf7b70 0000000000000046 ffff88003cbb8590 ffff88003ccf7fd8
[  240.593330]  ffff88003cbca550 00000000001d3400 7fffffffffffffff ffff88003c0d01b8
[  240.594827]  0000000000000002 ffffffff814bf9b1 ffff88003c0d01c0 ffff88003ccf7b80
[  240.596418] Call Trace:
[  240.596912]  [<ffffffff814bf9b1>] ? console_conditional_schedule+0x27/0x27
[  240.598251]  [<ffffffff814bc514>] schedule+0x64/0x66
[  240.599242]  [<ffffffff814bf9e0>] schedule_timeout+0x2f/0xef
[  240.600354]  [<ffffffff810653c2>] ? mark_held_locks+0x5d/0x74
[  240.601406]  [<ffffffff814c0387>] ? _raw_spin_unlock_irq+0x27/0x46
[  240.602561]  [<ffffffff814bf9b1>] ? console_conditional_schedule+0x27/0x27
[  240.603861]  [<ffffffff8106555c>] ? trace_hardirqs_on_caller+0x183/0x19f
[  240.605117]  [<ffffffff81065585>] ? trace_hardirqs_on+0xd/0xf
[  240.606154]  [<ffffffff814bcce4>] do_wait_for_common+0xf9/0x131
[  240.607238]  [<ffffffff814bcce4>] ? do_wait_for_common+0xf9/0x131
[  240.608368]  [<ffffffff81053dd9>] ? wake_up_state+0xd/0xd
[  240.609330]  [<ffffffff814bcde5>] wait_for_common+0x4a/0x64
[  240.610360]  [<ffffffff814bce17>] wait_for_completion+0x18/0x1a
[  240.611434]  [<ffffffff8131d3bb>] dpm_wait+0x2c/0x2e
[  240.612348]  [<ffffffff8131e239>] device_resume+0x43/0x17f
[  240.613297]  [<ffffffff8131e38d>] async_resume+0x18/0x3e
[  240.614247]  [<ffffffff8104c526>] async_run_entry_fn+0x5c/0x106
[  240.615317]  [<ffffffff8104585c>] process_one_work+0x1d2/0x38a
[  240.616390]  [<ffffffff81062d20>] ? trace_hardirqs_off_caller+0x40/0xad
[  240.617519]  [<ffffffff810462f0>] worker_thread+0x1f6/0x2a3
[  240.618484]  [<ffffffff810460fa>] ? rescuer_thread+0x214/0x214
[  240.619639]  [<ffffffff81049c09>] kthread+0xc7/0xcf
[  240.620531]  [<ffffffff8125d4c9>] ? debug_smp_processor_id+0x17/0x19
[  240.621624]  [<ffffffff8106555c>] ? trace_hardirqs_on_caller+0x183/0x19f
[  240.622806]  [<ffffffff81049b42>] ? __kthread_parkme+0x62/0x62
[  240.623855]  [<ffffffff814c0dac>] ret_from_fork+0x7c/0xb0
[  240.624823]  [<ffffffff81049b42>] ? __kthread_parkme+0x62/0x62
[  240.625846] 2 locks held by kworker/u8:13/2063:
[  240.626654]  #0:  ("events_unbound"){.+.+.+}, at: [<ffffffff810457e0>] process_one_work+0x156/0x38a
[  240.628378]  #1:  ((&entry->work)){+.+.+.}, at: [<ffffffff810457e0>] process_one_work+0x156/0x38a
[  240.629976] INFO: task kworker/u8:14:2064 blocked for more than 120 seconds.
[  240.631286]       Not tainted 3.17.0-rc6+ #78
[  240.632085] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  240.633421] kworker/u8:14   D ffff88003cbb8590 14072  2064      2 0x00000000
[  240.634655] Workqueue: events_unbound async_run_entry_fn
[  240.635646]  ffff88003cbdfb70 0000000000000046 ffff88003cbb05d0 ffff88003cbdffd8
[  240.637027]  ffff88003cbb8590 00000000001d3400 7fffffffffffffff ffff88003c0d01b8
[  240.638351]  0000000000000002 ffffffff814bf9b1 ffff88003c0d01c0 ffff88003cbdfb80
[  240.639735] Call Trace:
[  240.640200]  [<ffffffff814bf9b1>] ? console_conditional_schedule+0x27/0x27
[  240.641379]  [<ffffffff814bc514>] schedule+0x64/0x66
[  240.642229]  [<ffffffff814bf9e0>] schedule_timeout+0x2f/0xef
[  240.643276]  [<ffffffff810653c2>] ? mark_held_locks+0x5d/0x74
[  240.644339]  [<ffffffff814c0387>] ? _raw_spin_unlock_irq+0x27/0x46
[  240.645398]  [<ffffffff814bf9b1>] ? console_conditional_schedule+0x27/0x27
[  240.646631]  [<ffffffff8106555c>] ? trace_hardirqs_on_caller+0x183/0x19f
[  240.647832]  [<ffffffff81065585>] ? trace_hardirqs_on+0xd/0xf
[  240.648860]  [<ffffffff814bcce4>] do_wait_for_common+0xf9/0x131
[  240.649881]  [<ffffffff814bcce4>] ? do_wait_for_common+0xf9/0x131
[  240.650954]  [<ffffffff81053dd9>] ? wake_up_state+0xd/0xd
[  240.651900]  [<ffffffff814bcde5>] wait_for_common+0x4a/0x64
[  240.652901]  [<ffffffff814bce17>] wait_for_completion+0x18/0x1a
[  240.653915]  [<ffffffff8131d3bb>] dpm_wait+0x2c/0x2e
[  240.654806]  [<ffffffff8131e239>] device_resume+0x43/0x17f
[  240.655806]  [<ffffffff8131e38d>] async_resume+0x18/0x3e
[  240.656760]  [<ffffffff8104c526>] async_run_entry_fn+0x5c/0x106
[  240.657777]  [<ffffffff8104585c>] process_one_work+0x1d2/0x38a
[  240.658794]  [<ffffffff81062d20>] ? trace_hardirqs_off_caller+0x40/0xad
[  240.659989]  [<ffffffff810462f0>] worker_thread+0x1f6/0x2a3
[  240.660985]  [<ffffffff810460fa>] ? rescuer_thread+0x214/0x214
[  240.661988]  [<ffffffff81049c09>] kthread+0xc7/0xcf
[  240.662853]  [<ffffffff8125d4c9>] ? debug_smp_processor_id+0x17/0x19
[  240.663994]  [<ffffffff8106555c>] ? trace_hardirqs_on_caller+0x183/0x19f
[  240.665179]  [<ffffffff81049b42>] ? __kthread_parkme+0x62/0x62
[  240.666183]  [<ffffffff814c0dac>] ret_from_fork+0x7c/0xb0
[  240.667208]  [<ffffffff81049b42>] ? __kthread_parkme+0x62/0x62
[  240.668275] 2 locks held by kworker/u8:14/2064:
[  240.669060]  #0:  ("events_unbound"){.+.+.+}, at: [<ffffffff810457e0>] process_one_work+0x156/0x38a
[  240.670689]  #1:  ((&entry->work)){+.+.+.}, at: [<ffffffff810457e0>] process_one_work+0x156/0x38a
[  240.672391] INFO: task kworker/u8:15:2065 blocked for more than 120 seconds.
[  240.673591]       Not tainted 3.17.0-rc6+ #78
[  240.674374] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  240.675804] kworker/u8:15   D ffff88003cbb05d0 14192  2065      2 0x00000000
[  240.677119] Workqueue: events_unbound async_run_entry_fn
[  240.678110]  ffff88003cbd7b70 0000000000000046 ffff88003cb7a610 ffff88003cbd7fd8
[  240.679510]  ffff88003cbb05d0 00000000001d3400 7fffffffffffffff ffff88003c0d01b8
[  240.680917]  0000000000000002 ffffffff814bf9b1 ffff88003c0d01c0 ffff88003cbd7b80
[  240.682292] Call Trace:
[  240.682751]  [<ffffffff814bf9b1>] ? console_conditional_schedule+0x27/0x27
[  240.683977]  [<ffffffff814bc514>] schedule+0x64/0x66
[  240.684867]  [<ffffffff814bf9e0>] schedule_timeout+0x2f/0xef
[  240.685844]  [<ffffffff810653c2>] ? mark_held_locks+0x5d/0x74
[  240.686872]  [<ffffffff814c0387>] ? _raw_spin_unlock_irq+0x27/0x46
[  240.687996]  [<ffffffff814bf9b1>] ? console_conditional_schedule+0x27/0x27
[  240.689218]  [<ffffffff8106555c>] ? trace_hardirqs_on_caller+0x183/0x19f
[  240.690363]  [<ffffffff81065585>] ? trace_hardirqs_on+0xd/0xf
[  240.691424]  [<ffffffff814bcce4>] do_wait_for_common+0xf9/0x131
[  240.692519]  [<ffffffff814bcce4>] ? do_wait_for_common+0xf9/0x131
[  240.693561]  [<ffffffff81053dd9>] ? wake_up_state+0xd/0xd
[  240.694497]  [<ffffffff814bcde5>] wait_for_common+0x4a/0x64
[  240.695588]  [<ffffffff814bce17>] wait_for_completion+0x18/0x1a
[  240.696785]  [<ffffffff8131d3bb>] dpm_wait+0x2c/0x2e
[  240.697711]  [<ffffffff8131e239>] device_resume+0x43/0x17f
[  240.698738]  [<ffffffff8131e38d>] async_resume+0x18/0x3e
[  240.699813]  [<ffffffff8104c526>] async_run_entry_fn+0x5c/0x106
[  240.700966]  [<ffffffff8104585c>] process_one_work+0x1d2/0x38a
[  240.702056]  [<ffffffff81062d20>] ? trace_hardirqs_off_caller+0x40/0xad
[  240.703296]  [<ffffffff810462f0>] worker_thread+0x1f6/0x2a3
[  240.704323]  [<ffffffff810460fa>] ? rescuer_thread+0x214/0x214
[  240.705373]  [<ffffffff81049c09>] kthread+0xc7/0xcf
[  240.706233]  [<ffffffff8125d4c9>] ? debug_smp_processor_id+0x17/0x19
[  240.707379]  [<ffffffff8106555c>] ? trace_hardirqs_on_caller+0x183/0x19f
[  240.708595]  [<ffffffff81049b42>] ? __kthread_parkme+0x62/0x62
[  240.709601]  [<ffffffff814c0dac>] ret_from_fork+0x7c/0xb0
[  240.710563]  [<ffffffff81049b42>] ? __kthread_parkme+0x62/0x62
[  240.711648] 2 locks held by kworker/u8:15/2065:
[  240.712471]  #0:  ("events_unbound"){.+.+.+}, at: [<ffffffff810457e0>] process_one_work+0x156/0x38a
[  240.714092]  #1:  ((&entry->work)){+.+.+.}, at: [<ffffffff810457e0>] process_one_work+0x156/0x38a
[  240.715727] INFO: task kworker/u8:16:2066 blocked for more than 120 seconds.
[  240.717016]       Not tainted 3.17.0-rc6+ #78
[  240.717773] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  240.719210] kworker/u8:16   D ffff88003cb7a610 14192  2066      2 0x00000000
[  240.720545] Workqueue: events_unbound async_run_entry_fn
[  240.721484]  ffff88003cbcfb70 0000000000000046 ffff88003cb68650 ffff88003cbcffd8
[  240.722874]  ffff88003cb7a610 00000000001d3400 7fffffffffffffff ffff88003c0d01b8
[  240.724313]  0000000000000002 ffffffff814bf9b1 ffff88003c0d01c0 ffff88003cbcfb80
[  240.725629] Call Trace:
[  240.726079]  [<ffffffff814bf9b1>] ? console_conditional_schedule+0x27/0x27
[  240.727355]  [<ffffffff814bc514>] schedule+0x64/0x66
[  240.728271]  [<ffffffff814bf9e0>] schedule_timeout+0x2f/0xef
[  240.729269]  [<ffffffff810653c2>] ? mark_held_locks+0x5d/0x74
[  240.730283]  [<ffffffff814c0387>] ? _raw_spin_unlock_irq+0x27/0x46
[  240.731427]  [<ffffffff814bf9b1>] ? console_conditional_schedule+0x27/0x27
[  240.732667]  [<ffffffff8106555c>] ? trace_hardirqs_on_caller+0x183/0x19f
[  240.733812]  [<ffffffff81065585>] ? trace_hardirqs_on+0xd/0xf
[  240.734838]  [<ffffffff814bcce4>] do_wait_for_common+0xf9/0x131
[  240.735928]  [<ffffffff814bcce4>] ? do_wait_for_common+0xf9/0x131
[  240.737009]  [<ffffffff81053dd9>] ? wake_up_state+0xd/0xd
[  240.737935]  [<ffffffff814bcde5>] wait_for_common+0x4a/0x64
[  240.738974]  [<ffffffff814bce17>] wait_for_completion+0x18/0x1a
[  240.740055]  [<ffffffff8131d3bb>] dpm_wait+0x2c/0x2e
[  240.740911]  [<ffffffff8131e239>] device_resume+0x43/0x17f
[  240.741893]  [<ffffffff8131e38d>] async_resume+0x18/0x3e
[  240.742841]  [<ffffffff8104c526>] async_run_entry_fn+0x5c/0x106
[  240.743929]  [<ffffffff8104585c>] process_one_work+0x1d2/0x38a
[  240.744971]  [<ffffffff81062d20>] ? trace_hardirqs_off_caller+0x40/0xad
[  240.746119]  [<ffffffff810462f0>] worker_thread+0x1f6/0x2a3
[  240.747153]  [<ffffffff810460fa>] ? rescuer_thread+0x214/0x214
[  240.748226]  [<ffffffff81049c09>] kthread+0xc7/0xcf
[  240.749098]  [<ffffffff8125d4c9>] ? debug_smp_processor_id+0x17/0x19
[  240.750182]  [<ffffffff8106555c>] ? trace_hardirqs_on_caller+0x183/0x19f
[  240.751417]  [<ffffffff81049b42>] ? __kthread_parkme+0x62/0x62
[  240.752515]  [<ffffffff814c0dac>] ret_from_fork+0x7c/0xb0
[  240.753466]  [<ffffffff81049b42>] ? __kthread_parkme+0x62/0x62
[  240.754502] 2 locks held by kworker/u8:16/2066:
[  240.755345]  #0:  ("events_unbound"){.+.+.+}, at: [<ffffffff810457e0>] process_one_work+0x156/0x38a
[  240.757049]  #1:  ((&entry->work)){+.+.+.}, at: [<ffffffff810457e0>] process_one_work+0x156/0x38a
[  240.758676] INFO: task kworker/u8:17:2067 blocked for more than 120 seconds.
[  240.759994]       Not tainted 3.17.0-rc6+ #78
[  240.760802] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  240.762174] kworker/u8:17   D ffff88003cb68650 14192  2067      2 0x00000000
[  240.763469] Workqueue: events_unbound async_run_entry_fn
[  240.764468]  ffff88003cbbfb70 0000000000000046 ffff88003cb56690 ffff88003cbbffd8
[  240.765792]  ffff88003cb68650 00000000001d3400 7fffffffffffffff ffff88003c6f5a18
[  240.767180]  0000000000000002 ffffffff814bf9b1 ffff88003c6f5a20 ffff88003cbbfb80
[  240.768543] Call Trace:
[  240.768967]  [<ffffffff814bf9b1>] ? console_conditional_schedule+0x27/0x27
[  240.770197]  [<ffffffff814bc514>] schedule+0x64/0x66
[  240.771139]  [<ffffffff814bf9e0>] schedule_timeout+0x2f/0xef
[  240.772144]  [<ffffffff810653c2>] ? mark_held_locks+0x5d/0x74
[  240.773137]  [<ffffffff814c0387>] ? _raw_spin_unlock_irq+0x27/0x46
[  240.774240]  [<ffffffff814bf9b1>] ? console_conditional_schedule+0x27/0x27
[  240.775491]  [<ffffffff8106555c>] ? trace_hardirqs_on_caller+0x183/0x19f
[  240.776722]  [<ffffffff81065585>] ? trace_hardirqs_on+0xd/0xf
[  240.777706]  [<ffffffff814bcce4>] do_wait_for_common+0xf9/0x131
[  240.778727]  [<ffffffff814bcce4>] ? do_wait_for_common+0xf9/0x131
[  240.779836]  [<ffffffff81053dd9>] ? wake_up_state+0xd/0xd
[  240.780839]  [<ffffffff814bcde5>] wait_for_common+0x4a/0x64
[  240.781793]  [<ffffffff814bce17>] wait_for_completion+0x18/0x1a
[  240.782855]  [<ffffffff8131d3bb>] dpm_wait+0x2c/0x2e
[  240.783803]  [<ffffffff8131e239>] device_resume+0x43/0x17f
[  240.784821]  [<ffffffff8131e38d>] async_resume+0x18/0x3e
[  240.785739]  [<ffffffff8104c526>] async_run_entry_fn+0x5c/0x106
[  240.786798]  [<ffffffff8104585c>] process_one_work+0x1d2/0x38a
[  240.787915]  [<ffffffff81062d20>] ? trace_hardirqs_off_caller+0x40/0xad
[  240.789158]  [<ffffffff810462f0>] worker_thread+0x1f6/0x2a3
[  240.790187]  [<ffffffff810460fa>] ? rescuer_thread+0x214/0x214
[  240.791279]  [<ffffffff81049c09>] kthread+0xc7/0xcf
[  240.792176]  [<ffffffff8125d4c9>] ? debug_smp_processor_id+0x17/0x19
[  240.793347]  [<ffffffff8106555c>] ? trace_hardirqs_on_caller+0x183/0x19f
[  240.794578]  [<ffffffff81049b42>] ? __kthread_parkme+0x62/0x62
[  240.795648]  [<ffffffff814c0dac>] ret_from_fork+0x7c/0xb0
[  240.796656]  [<ffffffff81049b42>] ? __kthread_parkme+0x62/0x62
[  240.797720] 2 locks held by kworker/u8:17/2067:
[  240.798535]  #0:  ("events_unbound"){.+.+.+}, at: [<ffffffff810457e0>] process_one_work+0x156/0x38a
[  240.800346]  #1:  ((&entry->work)){+.+.+.}, at: [<ffffffff810457e0>] process_one_work+0x156/0x38a

