Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:52233 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423Ab0APAiS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 15 Jan 2010 19:38:18 -0500
Received: by fxm25 with SMTP id 25so717805fxm.21
        for <linux-media@vger.kernel.org>; Fri, 15 Jan 2010 16:38:16 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 16 Jan 2010 01:38:16 +0100
Message-ID: <bcb3ef431001151638h1b68fa66s5b1e7867d17264a0@mail.gmail.com>
Subject: s2-liplianin, mantis: kobject_add_internal failed for irrcv with
	-EEXIST, don't try to register things with the same name in the same
	directory.
From: MartinG <gronslet@gmail.com>
To: Linux Media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Using kernel 2.6.30.10-105.fc11.x86_64,  sasc-ng-0.0.2-77.x86_64 and
the mantis driver from
http://mercurial.intuxication.org/hg/s2-liplianin, I get the following
when I boot my machine (TerraTec Cinergy C HD DVB-C, VP-2040 PCI
DVB-C:

  sysfs: cannot create duplicate filename '/devices/virtual/irrcv'

Relevant parts of dmesg below.

Otherwise the driver seems to work.

Version of the mantis driver:
$ hg log|head
changeset:   14125:cc01851735c3
tag:         tip
parent:      14061:cc46bddbd1c8
parent:      14124:d490d84a64ac
user:        Igor M. Liplianin <liplianin@me.by>
date:        Wed Jan 13 17:25:36 2010 +0200
summary:     merge http://linuxtv.org/hg/v4l-dvb

I'd be happy to test stuff in order to solve this, please let me know
(CC me directly)

Thanks,

MartinG

Relevant parts of dmesg:

eth0: no IPv6 routers present
mantis_core_exit (0): DMA engine stopping
mantis_dma_exit (0): DMA=0xcf060000 cpu=0xffff8800cf060000 size=65536
mantis_dma_exit (0): RISC=0xcf028000 cpu=0xffff8800cf028000 size=1000
mantis_hif_exit (0): Adapter(0) Exiting Mantis Host Interface
mantis_ca_exit (0): Unregistering EN50221 device
mantis_pci_remove (0): Removing -->Mantis irq: 16, latency: 64
 memory: 0xfdfff000, mmio: 0xffffc200111fc000
Mantis 0000:04:00.0: PCI INT A disabled
Mantis 0000:04:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
irq: 16, latency: 64
 memory: 0xfdfff000, mmio: 0xffffc20023da2000
found a VP-2040 PCI DVB-C device on (04:00.0),
    Mantis Rev 1 [153b:1178], irq: 16, latency: 64
    memory: 0xfdfff000, mmio: 0xffffc20023da2000
    MAC Address=[00:08:ca:1d:bd:a6]
mantis_alloc_buffers (0): DMA=0xcf060000 cpu=0xffff8800cf060000
size=65536
mantis_alloc_buffers (0): RISC=0xcf033000 cpu=0xffff8800cf033000
size=1000
DVB: registering new adapter (Mantis dvb adapter)
mantis_frontend_init (0): Probing for CU1216 (DVB-C)
TDA10023: i2c-addr = 0x0c, id = 0x7d
mantis_frontend_init (0): found Philips CU1216 DVB-C frontend
(TDA10023) @ 0x0c
mantis_frontend_init (0): Mantis DVB-C Philips CU1216 frontend attach
success
DVB: registering adapter 0 frontend 0 (Philips TDA10023 DVB-C)...
mantis_ca_init (0): Registering EN50221 device
mantis_ca_init (0): Registered EN50221 device
mantis_hif_init (0): Adapter(0) Initializing Mantis Host Interface
input: Mantis VP-2040 IR Receiver as /devices/virtual/input/input9
------------[ cut here ]------------
WARNING: at fs/sysfs/dir.c:487 sysfs_add_one+0xd9/0xf3() (Not tainted)
Hardware name: P5E-VM HDMI
sysfs: cannot create duplicate filename '/devices/virtual/irrcv'
Modules linked in: mantis(+) lnbp21 mb86a16 ir_common stb6100 tda10021
tda10023 stb0899 stv0299 dvb_core ir_core nfsd nfs_acl auth_rpcgss
exportfs sco bridge stp llc bnep l2cap bluetooth lockd sunrpc autofs4
w83627ehf hwmon_vid coretemp ip6t_REJECT nf_conntrack_ipv6
ip6table_filter ip6_tables ipv6 cpufreq_ondemand acpi_cpufreq
freq_table jfs dm_multipath lirc_serial uinput snd_hda_codec_intelhdmi
snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_seq
snd_seq_device firewire_ohci snd_pcm snd_timer firewire_core snd
soundcore lirc_imon lirc_dev crc_itu_t snd_page_alloc atl1
pata_jmicron i2c_i801 pcspkr mii iTCO_wdt asus_atk0110
iTCO_vendor_support serio_raw hwmon ata_generic pata_acpi i915 drm
i2c_algo_bit video output i2c_core [last unloaded: ir_core]
Pid: 2693, comm: work_for_cpu Not tainted 2.6.30.10-105.fc11.x86_64 #1
Call Trace:
 [<ffffffff81049505>] warn_slowpath_common+0x84/0x9c
 [<ffffffff81049574>] warn_slowpath_fmt+0x41/0x43
 [<ffffffff8113564b>] sysfs_add_one+0xd9/0xf3
 [<ffffffff811356c2>] create_dir+0x5d/0x8d
 [<ffffffff8113572f>] sysfs_create_dir+0x3d/0x50
 [<ffffffff811c94f6>] kobject_add_internal+0x116/0x1f3
 [<ffffffff811c96a9>] kobject_add_varg+0x41/0x50
 [<ffffffff811c9773>] kobject_add+0x64/0x66
 [<ffffffff811c8ffc>] ? kobject_init+0x43/0x83
 [<ffffffff8126f4f5>] get_device_parent+0x11e/0x14a
 [<ffffffff81270430>] device_add+0x100/0x599
 [<ffffffff811d0aef>] ? kvasprintf+0x5e/0x6e
 [<ffffffff812708e7>] device_register+0x1e/0x23
 [<ffffffff812709ab>] device_create_vargs+0xbf/0xf0
 [<ffffffff81270a0d>] device_create+0x31/0x33
 [<ffffffffa040182e>] ir_register_class+0x62/0xc5 [ir_core]
 [<ffffffffa04012f6>] ir_input_register+0x1e8/0x23d [ir_core]
 [<ffffffffa045ac69>] mantis_rc_init+0x173/0x1c8 [mantis]
 [<ffffffffa045b2d9>] mantis_core_init+0x2f8/0x35d [mantis]
 [<ffffffffa045b61c>] mantis_pci_probe+0x2b9/0x3d4 [mantis]
 [<ffffffff813d994c>] ? schedule+0xe/0x22
 [<ffffffff811ddbf1>] local_pci_probe+0x17/0x1b
 [<ffffffff81059d2c>] do_work_for_cpu+0x18/0x2a
 [<ffffffff81059d14>] ? do_work_for_cpu+0x0/0x2a
 [<ffffffff8105d32c>] kthread+0x5a/0x85
 [<ffffffff81011d0a>] child_rip+0xa/0x20
 [<ffffffff8105d2d2>] ? kthread+0x0/0x85
 [<ffffffff81011d00>] ? child_rip+0x0/0x20
---[ end trace 00809ea120621562 ]---
kobject_add_internal failed for irrcv with -EEXIST, don't try to
register things with the same name in the same directory.
Pid: 2693, comm: work_for_cpu Tainted: G        W
2.6.30.10-105.fc11.x86_64 #1
Call Trace:
 [<ffffffff811c9587>] kobject_add_internal+0x1a7/0x1f3
 [<ffffffff811c96a9>] kobject_add_varg+0x41/0x50
 [<ffffffff811c9773>] kobject_add+0x64/0x66
 [<ffffffff811c8ffc>] ? kobject_init+0x43/0x83
 [<ffffffff8126f4f5>] get_device_parent+0x11e/0x14a
 [<ffffffff81270430>] device_add+0x100/0x599
 [<ffffffff811d0aef>] ? kvasprintf+0x5e/0x6e
 [<ffffffff812708e7>] device_register+0x1e/0x23
 [<ffffffff812709ab>] device_create_vargs+0xbf/0xf0
 [<ffffffff81270a0d>] device_create+0x31/0x33
 [<ffffffffa040182e>] ir_register_class+0x62/0xc5 [ir_core]
 [<ffffffffa04012f6>] ir_input_register+0x1e8/0x23d [ir_core]
 [<ffffffffa045ac69>] mantis_rc_init+0x173/0x1c8 [mantis]
 [<ffffffffa045b2d9>] mantis_core_init+0x2f8/0x35d [mantis]
 [<ffffffffa045b61c>] mantis_pci_probe+0x2b9/0x3d4 [mantis]
 [<ffffffff813d994c>] ? schedule+0xe/0x22
 [<ffffffff811ddbf1>] local_pci_probe+0x17/0x1b
 [<ffffffff81059d2c>] do_work_for_cpu+0x18/0x2a
 [<ffffffff81059d14>] ? do_work_for_cpu+0x0/0x2a
 [<ffffffff8105d32c>] kthread+0x5a/0x85
 [<ffffffff81011d0a>] child_rip+0xa/0x20
 [<ffffffff8105d2d2>] ? kthread+0x0/0x85
 [<ffffffff81011d00>] ? child_rip+0x0/0x20
Creating IR device irrcv0
Mantis VP-2040 IR Receiver: unknown key for scancode 0x0000
Mantis VP-2040 IR Receiver: unknown key: key=0x00 down=1
Mantis VP-2040 IR Receiver: unknown key: key=0x00 down=0
/home/gronslet/rpmbuild/BUILD/sasc-ng-0.0.2/dvbloopback/module/dvb_loopback.c:
frontend loopback driver v0.0.1
dvbloopback: registering 1 adapters
DVB: registering new adapter (DVB-LOOPBACK)
CPU0 attaching NULL sched-domain.
CPU1 attaching NULL sched-domain.
CPU0 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 0 1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 1 0
audit(1263601063.900:48338): auid=4294967295 ses=4294967295 op=remove
rule key=(null) list=4 res=1
audit(1263601063.900:48339): audit_enabled=0 old=1 auid=4294967295
ses=4294967295 res=1
Slow work thread pool: Starting up
Slow work thread pool: Ready
FS-Cache: Loaded
FS-Cache: Netfs 'nfs' registered for caching
mantis start feed & dma
mantis stop feed and dma
mantis start feed & dma
mantis stop feed and dma
mantis start feed & dma
mantis stop feed and dma
