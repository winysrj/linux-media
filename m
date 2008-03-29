Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from sub87-230-124-80.he-dsl.de ([87.230.124.80] helo=ts4.de)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <linux-dvb@ts4.de>) id 1JfbOq-0003j4-55
	for linux-dvb@linuxtv.org; Sat, 29 Mar 2008 14:47:15 +0100
Received: from tom by ts4.de with local (Exim 4.62)
	(envelope-from <linux-dvb@ts4.de>) id 1JfbOI-0003YK-0B
	for linux-dvb@linuxtv.org; Sat, 29 Mar 2008 14:46:38 +0100
Date: Sat, 29 Mar 2008 14:46:37 +0100
From: Thomas Schuering <linux-dvb@ts4.de>
To: linux-dvb@linuxtv.org
Message-ID: <20080329134637.GA13258@ts4.de>
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] DViCO Dual Digital 4 w/ Ubuntu 7.10/amd64 => 'general
	protection fault' by modprobe
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

Hi,

this is a DD4 rev. 1.0 (0fe9:db78).

I'm running an up-to-date ubuntu-7.10 amd64 desktop
(booted from USB-stick) (Linux mybox 2.6.22-14-generic #1 SMP
 Tue Feb 12 02:46:46 UTC 2008 x86_64 GNU/Linux)

I failed to get the card running.
Could someone please give me a hint what I missed?
(If I should provide more details, just ask.)


I followed  <https://help.ubuntu.com/community/DViCO_Dual_Digital_4> and:
- compiled the drivers this morning:
 1. sudo apt-get install mercurial linux-headers-generic build-essential
 2. hg clone http://linuxtv.org/hg/v4l-dvb
 3. cd v4l-dvb
 4. make
 5. sudo make installa
    (No errors/ warnings here)

- downloaded the following firmware-files to /lib/firmware [0]:
 6. wget http://www.linuxtv.org/downloads/firmware/dvb-usb-bluebird-01.fw
 7. wget http://www.itee.uq.edu.au/~chrisp/Linux-DVB/DVICO/dvb-usb-bluebird-02.fw
 8. wget http://www.itee.uq.edu.au/~chrisp/Linux-DVB/DVICO/xc3028-dvico-au-01.fw
 9. sudo cp *.fw /lib/firmware

Rebooting results in general protection faults[1].
(BTW: What modules [and in which sequence] should be modprobed anyway?)


Note:
To be able to boot normally I had to remove the lines with 'tuner-xc2028.ko'
and 'tuner.ko' from /lib/modules/2.6.22-14-generic/modules.dep .

The card is detected.

lsusb:
----------------------------------------------------------------------
Bus 010 Device 003: ID 0fe9:db78 DVICO 
Bus 010 Device 002: ID 0fe9:db78 DVICO 
Bus 010 Device 001: ID 0000:0000  
Bus 008 Device 002: ID 0951:1602 Kingston Technology 
Bus 008 Device 001: ID 0000:0000  
Bus 001 Device 001: ID 0000:0000  
Bus 009 Device 001: ID 0000:0000  
Bus 005 Device 001: ID 0000:0000  
Bus 006 Device 001: ID 0000:0000  
Bus 002 Device 001: ID 0000:0000  
Bus 007 Device 001: ID 0000:0000  
Bus 004 Device 001: ID 0000:0000  
Bus 003 Device 001: ID 0000:0000  
----------------------------------------------------------------------

Any ideas if thses general protection faults are driver or firmware related?

Any constructive tips are welcome.
Thanks in advance for your time!


Regards, Thomas

[0] md5sum of /lib/firmware:
658397cb9eba9101af9031302671f49d  dvb-usb-bluebird-01.fw
62821fd26437eb9e0e4bcef7355f4ca7  dvb-usb-bluebird-02.fw
c5475ab3c699e5c811bd391e8ee5dbb6  xc3028-dvico-au-01.fw


[1] According to /var/log/kern.log:
----------------------------------------------------------------------
[   65.027037] dvb-usb: found a 'DViCO FusionHDTV DVB-T Dual Digital 4' in warm state.
[   65.027215] dvb-usb: will pass the complete MPEG2 transport stream to the software demuxer.
[   65.058552] DVB: registering new adapter (DViCO FusionHDTV DVB-T Dual Digital 4)
[   65.066162] nvidia: module license 'NVIDIA' taints kernel.
[   65.318690] ACPI: PCI Interrupt 0000:01:00.0[A] -> Link [LNKA] -> GSI 11 (level, low) -> IRQ 11
[   65.318857] PCI: Setting latency timer of device 0000:01:00.0 to 64
[   65.318936] NVRM: loading NVIDIA UNIX x86_64 Kernel Module  100.14.19  Wed Sep 12 14:08:38 PDT 2007
[   65.580935] DVB: registering frontend 0 (Zarlink ZL10353 DVB-T)...
[   65.677294] general protection fault: 0000 [1] SMP 
[   65.677414] CPU 0 
[   65.677492] Modules linked in: tuner_xc2028 snd_seq_midi zl10353 snd_rawmidi snd_seq_midi_event snd_seq nvidia(P) snd_timer snd_seq_device dvb_usb_cxusb dvb_usb sky2 usb_storage ide_core dvb_core libusual i2c_core snd soundcore snd_page_alloc psmouse serio_raw intel_agp iTCO_wdt iTCO_vendor_support pcspkr shpchp pci_hotplug evdev ext3 jbd mbcache sg sr_mod cdrom sd_mod ohci1394 ieee1394 ahci libata scsi_mod ehci_hcd uhci_hcd usbcore thermal processor fan fuse apparmor commoncap
[   65.679347] Pid: 4023, comm: modprobe Tainted: P       2.6.22-14-generic #1
[   65.679396] RIP: 0010:[<ffffffff88919b56>]  [<ffffffff88919b56>] :tuner_xc2028:xc2028_attach+0x166/0x240
[   65.679492] RSP: 0018:ffff8101728b1bd8  EFLAGS: 00010206
[   65.679540] RAX: 0020000000a08c00 RBX: ffffffff8891e500 RCX: 0000000000000080
[   65.679590] RDX: 00000000ffffffff RSI: ffffffff8891c1a0 RDI: ffff81017a2fbe78
[   65.679639] RBP: ffff8101728b1c08 R08: ffff8101728b0000 R09: 0000000000000000
[   65.679688] R10: ffffffff805d0880 R11: 0000000000000000 R12: ffff81017a2fbc08
[   65.679737] R13: 0000000000000000 R14: ffff810171252040 R15: 0000000000000000
[   65.679786] FS:  00002af7fb0446e0(0000) GS:ffffffff80561000(0000) knlGS:0000000000000000
[   65.679844] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   65.679892] CR2: 00002b67540ba680 CR3: 00000001728f8000 CR4: 00000000000006e0
[   65.679941] Process modprobe (pid: 4023, threadinfo ffff8101728b0000, task ffff8101771fe000)
[   65.679998] Stack:  0000000000000000 ffff810171252db8 0000000000000000 ffff810171252db0
[   65.680226]  ffff810171252000 ffffffff8822ad7b ffff810171252a28 0000000000000061
[   65.680420]  0000000000000000 0000000000000000 ffffffff8822b420 0000000000000000
[   65.680571] Call Trace:
[   65.680661]  [<ffffffff8822ad7b>] :dvb_usb_cxusb:cxusb_dvico_xc3028_tuner_attach+0x5b/0xe0
[   65.680721]  [<ffffffff8822b420>] :dvb_usb_cxusb:dvico_bluebird_xc2028_callback+0x0/0xa0
[   65.680781]  [<ffffffff882230f0>] :dvb_usb:dvb_usb_adapter_frontend_init+0x80/0x100
[   65.680840]  [<ffffffff8822298c>] :dvb_usb:dvb_usb_device_init+0x40c/0x650
[   65.680893]  [<ffffffff8822a0fb>] :dvb_usb_cxusb:cxusb_probe+0xab/0x100
[   65.680952]  [<ffffffff8803dad1>] :usbcore:usb_probe_interface+0xd1/0x120
[   65.681005]  [<ffffffff80391133>] driver_probe_device+0xa3/0x1b0
[   65.681055]  [<ffffffff803913f9>] __driver_attach+0xc9/0xd0
[   65.681103]  [<ffffffff80391330>] __driver_attach+0x0/0xd0
[   65.681727]  [<ffffffff8039030d>] bus_for_each_dev+0x4d/0x80
[   65.681776]  [<ffffffff8039076f>] bus_add_driver+0xaf/0x1f0
[   65.681832]  [<ffffffff8803d4a9>] :usbcore:usb_register_driver+0xa9/0x120
[   65.681882]  [<ffffffff8807301b>] :dvb_usb_cxusb:cxusb_module_init+0x1b/0x35
[   65.681933]  [<ffffffff80256f1b>] sys_init_module+0x19b/0x19b0
[   65.681986]  [<ffffffff80326af1>] __up_write+0x21/0x130
[   65.682037]  [<ffffffff80209e8e>] system_call+0x7e/0x83
[   65.682086] 
[   65.682129] 
[   65.682129] Code: 8b 90 10 03 00 00 48 8b 73 28 31 c0 0f b6 c9 49 c7 c0 61 c4 
[   65.682941] RIP  [<ffffffff88919b56>] :tuner_xc2028:xc2028_attach+0x166/0x240
[   65.683025]  RSP <ffff8101728b1bd8>
[   65.815554] NET: Registered protocol family 10
[   65.815665] lo: Disabled Privacy Extensions
[   65.815744] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   66.129679] ACPI: PCI Interrupt Link [LNKG] enabled at IRQ 3
[   66.129730] PCI: setting IRQ 3 as level-triggered
[   66.129779] ACPI: PCI Interrupt 0000:00:1b.0[A] -> Link [LNKG] -> GSI 3 (level, low) -> IRQ 3
[   66.130622] PCI: Setting latency timer of device 0000:00:1b.0 to 64
[   66.650738] sky2 eth0: Link is up at 100 Mbps, full duplex, flow control both
[   66.655059] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   69.957706] usb-storage: device scan complete
[   69.958210] scsi 6:0:0:0: Direct-Access     Kingston DataTravelerMini PMAP PQ: 0 ANSI: 0 CCS
[   69.959314] sd 6:0:0:0: [sdc] 2015232 512-byte hardware sectors (1032 MB)
[   69.959937] sd 6:0:0:0: [sdc] Write Protect is off
[   69.959987] sd 6:0:0:0: [sdc] Mode Sense: 23 00 00 00
[   69.960043] sd 6:0:0:0: [sdc] Assuming drive cache: write through
[   69.962185] sd 6:0:0:0: [sdc] 2015232 512-byte hardware sectors (1032 MB)
[   69.962808] sd 6:0:0:0: [sdc] Write Protect is off
[   69.962857] sd 6:0:0:0: [sdc] Mode Sense: 23 00 00 00
[   69.962906] sd 6:0:0:0: [sdc] Assuming drive cache: write through
[   69.962958]  sdc: sdc1
[   69.964187] sd 6:0:0:0: [sdc] Attached SCSI removable disk
[   69.964266] sd 6:0:0:0: Attached scsi generic sg3 type 0
[   77.303485] eth0: no IPv6 routers present
[  244.651267] loop: module loaded
[  244.686771] lp: driver loaded but no devices found
[  244.787164] coretemp coretemp.0: Using undocumented features, absolute temperature might be wrong!
[  244.787250] coretemp coretemp.1: Using undocumented features, absolute temperature might be wrong!
[  244.813414] Adding 1952968k swap on /dev/sda6.  Priority:-1 extents:1 across:1952968k
[  245.214467] EXT3 FS on sda5, internal journal
[  743.102163] kjournald starting.  Commit interval 5 seconds
[  743.109232] EXT3 FS on sdb5, internal journal
[  743.109235] EXT3-fs: mounted filesystem with ordered data mode.
[  746.071120] input: Power Button (FF) as /class/input/input4
[  746.071134] ACPI: Power Button (FF) [PWRF]
[  746.071219] input: Power Button (CM) as /class/input/input5
[  746.071230] ACPI: Power Button (CM) [PWRB]
[  746.085777] No dock devices found.
[  749.229945] ppdev: user-space parallel port driver
[  749.797148] audit(1206781294.005:3):  type=1503 operation="inode_permission" requested_mask="a" denied_mask="a" name="/dev/tty" pid=5710 profile="/usr/sbin/cupsd"
[  765.350458] process nmpd' is using deprecated sysctl (syscall) net.ipv6.neigh.lo.retrans_time; Use net.ipv6.neigh.lo.retrans_time_ms instead.
[  765.811284] vboxdrv: Trying to deactivate the NMI watchdog permanently...
[  765.811289] vboxdrv: Successfully done.
[  767.583063] Failure registering capabilities with primary security module.
[  770.937263] Bluetooth: Core ver 2.11
[  770.937510] NET: Registered protocol family 31
[  770.937513] Bluetooth: HCI device and connection manager initialized
[  770.937516] Bluetooth: HCI socket layer initialized
[  770.952819] Bluetooth: L2CAP ver 2.8
[  770.952824] Bluetooth: L2CAP socket layer initialized
[  771.017289] Bluetooth: RFCOMM socket layer initialized
[  771.017301] Bluetooth: RFCOMM TTY layer initialized
[  771.017303] Bluetooth: RFCOMM ver 1.8
[  774.050737] general protection fault: 0000 [2] SMP 
[  774.050871] CPU 0 
[  774.050952] Modules linked in: rfcomm l2cap bluetooth vboxdrv ppdev acpi_cpufreq cpufreq_stats cpufreq_conservative cpufreq_ondemand freq_table cpufreq_userspace cpufreq_powersave container ac video sbs dock button battery ext2 coretemp w83627ehf i2c_isa sbp2 parport_pc lp parport loop snd_hda_intel snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss ipv6 tuner_xc1028 snd_seq_midi zl10353 snd_rawmidi snd_seq_midi_event snd_seq nvidia(P) snd_timer snd_seq_device dvb_usb_cxusb dvb_usb sky2 usb_storage ide_core dvb_core libusual i2c_core snd soundcore snd_page_alloc psmouse serio_raw intel_agp iTCO_wdt iTCO_vendor_support pcspkr shpchp pci_hotplug evdev ext3 jbd mbcache sg sr_mod cdrom sd_mod ohci1394 ieee1394 ahci libata scsi_mod ehci_hcd uhci_hcd usbcore thermal processor fan fuse apparmor commoncap
[  774.054814] Pid: 6802, comm: kdvb-fe-0 Tainted: P       2.6.22-14-generic #1
[  774.054866] RIP: 0010:[<ffffffff881b3262>]  [<ffffffff881b3262>] :i2c_core:i2c_transfer+0x22/0x80
[  774.054971] RSP: 0018:ffff81016fc09e60  EFLAGS: 00010286
[  774.055021] RAX: 0000000000000080 RBX: 0000000000000000 RCX: ffff81017787e800
[  774.055073] RDX: 0000000000000001 RSI: ffff81016fc09e90 RDI: 0020000000a08c00
[  774.055126] RBP: 0020000000a08c00 R08: ffff81016fc08000 R09: 0000000000000000
[  774.055178] R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff8891e5a0
[  774.055230] R13: 0000000000000001 R14: ffff81017787e9e0 R15: ffff81017787e9b0
[  774.055283] FS:  0000000000000000(0000) GS:ffffffff80561000(0000) knlGS:0000000000000000
[  774.055343] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
[  774.055393] CR2: 00002ad3ef26e000 CR3: 000000010bce4000 CR4: 00000000000006e0
[  774.055446] Process kdvb-fe-0 (pid: 6802, threadinfo ffff81016fc08000, task ffff81015cd1adc0)
[  774.055506] Stack:  0000000000000000 ffffffff8891e500 ffffffff8891e5a0 ffff81016fc09ec0
[  774.055748]  ffff81017787e9e0 ffffffff8891c001 0000000400000080 ffffffff8891e522
[  774.055951]  0000000000000000 ffff81017a2fbc08 ffff81017787e800 ffffffff881cb792
[  774.056112] Call Trace:
[  774.056209]  [<ffffffff8891c001>] :tuner_xc1028:xc2028_sleep+0x101/0x18c
[  774.056271]  [<ffffffff881cb792>] :dvb_core:dvb_frontend_thread+0x1e2/0x350
[  774.056328]  [<ffffffff8024b2b0>] autoremove_wake_function+0x0/0x30
[  774.056389]  [<ffffffff881cb5b0>] :dvb_core:dvb_frontend_thread+0x0/0x350
[  774.056444]  [<ffffffff8024aeeb>] kthread+0x4b/0x80
[  774.056496]  [<ffffffff8020aca8>] child_rip+0xa/0x12
[  774.056554]  [<ffffffff8024aea0>] kthread+0x0/0x80
[  774.056605]  [<ffffffff8020ac9e>] child_rip+0x0/0x12
[  774.056657] 
[  774.056703] 
[  774.056704] Code: 48 8b 47 10 49 89 f6 41 bc da ff ff ff 48 83 38 00 74 26 48 
[  774.057555] RIP  [<ffffffff881b3262>] :i2c_core:i2c_transfer+0x22/0x80
[  774.057646]  RSP <ffff81016fc09e60>
----------------------------------------------------------------------

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
