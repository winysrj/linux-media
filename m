Return-path: <linux-media-owner@vger.kernel.org>
Received: from canardo.mork.no ([148.122.252.1]:44736 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750886Ab3EUNHO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 21 May 2013 09:07:14 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: stable@vger.kernel.org
Cc: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	Alan Cox <alan@linux.intel.com>
Subject: [PATCH stable < v3.7] media mantis: fix silly crash case
Date: Tue, 21 May 2013 15:07:03 +0200
Message-ID: <87ehd0lbwo.fsf@nemi.mork.no>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

--=-=-=
Content-Type: text/plain

Hello,

Please apply mainline commit e1d45ae to any maintained stable kernel
prior to v3.7.  I just hit this bug on a Debian 3.2.41-2+deb7u2 kernel:


May 19 06:52:54 canardo kernel: [   49.013774] BUG: unable to handle kernel NULL pointer dereference at 0000000000000308
May 19 06:52:54 canardo kernel: [   49.017735] IP: [<ffffffffa02e7ae5>] dvb_unregister_frontend+0x10/0xf4 [dvb_core]
May 19 06:52:54 canardo kernel: [   49.017735] PGD 0 
May 19 06:52:54 canardo kernel: [   49.017735] Oops: 0000 [#1] SMP 
May 19 06:52:54 canardo kernel: [   49.017735] CPU 2 
May 19 06:52:54 canardo kernel: [   49.017735] Modules linked in: tda10023 tda10021 ir_lirc_codec lirc_dev ir_mce_kbd_decoder ir_sony_decoder ir_jvc_decoder mantis(+) ir_rc6_decoder snd_pcm mantis_core dvb_core ir_rc5_decoder ir_nec_decoder io_edgeport radeon snd_page_alloc snd_timer rc_core ttm snd usbserial soundcore serio_raw drm_kms_helper acpi_cpufreq drm mperf i2c_i801 power_supply i2c_algo_bit iTCO_wdt pcspkr joydev coretemp iTCO_vendor_support evdev asus_atk0110 i2c_core button processor thermal_sys ext3 mbcache jbd dm_mod raid1 md_mod microcode usbhid hid sg sd_mod crc_t10dif mptsas ata_generic scsi_transport_sas mptscsih firewire_ohci uhci_hcd pata_jmicron ahci libahci mptbase atl1 mii libata ehci_hcd firewire_core crc_itu_t scsi_mod e1000e usbcore usb_common [last unloaded: scsi_wait_scan]
May 19 06:52:54 canardo kernel: [   49.017735] 
May 19 06:52:54 canardo kernel: [   49.017735] Pid: 612, comm: modprobe Not tainted 3.2.0-4-amd64 #1 Debian 3.2.41-2+deb7u2 System manufacturer P5K/P5K
May 19 06:52:54 canardo kernel: [   49.017735] RIP: 0010:[<ffffffffa02e7ae5>]  [<ffffffffa02e7ae5>] dvb_unregister_frontend+0x10/0xf4 [dvb_core]
May 19 06:52:54 canardo kernel: [   49.017735] RSP: 0018:ffff88021274bcc8  EFLAGS: 00010246
May 19 06:52:54 canardo kernel: [   49.017735] RAX: 0000000000000023 RBX: ffff880213571000 RCX: ffff8802135d3208
May 19 06:52:54 canardo kernel: [   49.017735] RDX: 0000000000000022 RSI: ffff880213078ac0 RDI: 0000000000000000
May 19 06:52:54 canardo kernel: [   49.017735] RBP: 0000000000000000 R08: 0000000000000011 R09: 0000000000000011
May 19 06:52:54 canardo kernel: [   49.017735] R10: 0000000000000000 R11: 0000000000000000 R12: 00000000ffffffff
May 19 06:52:54 canardo kernel: [   49.017735] R13: ffff8802135714a0 R14: ffff880213571838 R15: ffff880213571058
May 19 06:52:54 canardo kernel: [   49.017735] FS:  00007f03b3934700(0000) GS:ffff88021fd00000(0000) knlGS:0000000000000000
May 19 06:52:54 canardo kernel: [   49.017735] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
May 19 06:52:54 canardo kernel: [   49.017735] CR2: 0000000000000308 CR3: 0000000214969000 CR4: 00000000000006e0
May 19 06:52:54 canardo kernel: [   49.017735] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
May 19 06:52:54 canardo kernel: [   49.017735] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
May 19 06:52:54 canardo kernel: [   49.017735] Process modprobe (pid: 612, threadinfo ffff88021274a000, task ffff8802125d2970)
May 19 06:52:54 canardo kernel: [   49.017735] Stack:
May 19 06:52:54 canardo kernel: [   49.017735]  ffff880213571080 ffffffff81072f0e ffff880213571000 ffffffffa03ba000
May 19 06:52:54 canardo kernel: [   49.017735]  ffff8802135714a0 ffffffff8104be19 ffff880213571410 ffff880213571000
May 19 06:52:54 canardo kernel: [   49.017735]  ffff880213571410 ffffffffa03ffd6f ffff880213571790 ffff880213571850
May 19 06:52:54 canardo kernel: [   49.017735] Call Trace:
May 19 06:52:54 canardo kernel: [   49.017735]  [<ffffffff81072f0e>] ? __symbol_put+0x29/0x2e
May 19 06:52:54 canardo kernel: [   49.017735]  [<ffffffff8104be19>] ? tasklet_kill+0x4a/0x60
May 19 06:52:54 canardo kernel: [   49.017735]  [<ffffffffa03ffd6f>] ? mantis_dvb_init+0x3ac/0x402 [mantis_core]
May 19 06:52:54 canardo kernel: [   49.017735]  [<ffffffffa03d8707>] ? mantis_pci_probe+0x173/0x270 [mantis]
May 19 06:52:54 canardo kernel: [   49.017735]  [<ffffffff811c5a5b>] ? local_pci_probe+0x39/0x68
May 19 06:52:54 canardo kernel: [   49.017735]  [<ffffffff811c6504>] ? pci_device_probe+0xcd/0xfa
May 19 06:52:54 canardo kernel: [   49.017735]  [<ffffffff812510c1>] ? driver_probe_device+0xa8/0x138
May 19 06:52:54 canardo kernel: [   49.017735]  [<ffffffff812511a0>] ? __driver_attach+0x4f/0x6f
May 19 06:52:54 canardo kernel: [   49.017735]  [<ffffffff81251151>] ? driver_probe_device+0x138/0x138
May 19 06:52:54 canardo kernel: [   49.017735]  [<ffffffff8124fcf0>] ? bus_for_each_dev+0x4f/0x7a
May 19 06:52:54 canardo kernel: [   49.017735]  [<ffffffff81250a5a>] ? bus_add_driver+0xa5/0x1f5
May 19 06:52:54 canardo kernel: [   49.017735]  [<ffffffffa03d8804>] ? mantis_pci_probe+0x270/0x270 [mantis]
May 19 06:52:54 canardo kernel: [   49.017735]  [<ffffffff812515c8>] ? driver_register+0x8d/0xf5
May 19 06:52:54 canardo kernel: [   49.017735]  [<ffffffffa03d8804>] ? mantis_pci_probe+0x270/0x270 [mantis]
May 19 06:52:54 canardo kernel: [   49.017735]  [<ffffffff811c6d1f>] ? __pci_register_driver+0x4d/0xb6
May 19 06:52:54 canardo kernel: [   49.017735]  [<ffffffffa03d8804>] ? mantis_pci_probe+0x270/0x270 [mantis]
May 19 06:52:54 canardo kernel: [   49.017735]  [<ffffffff81002085>] ? do_one_initcall+0x75/0x12c
May 19 06:52:54 canardo kernel: [   49.017735]  [<ffffffff8107540f>] ? sys_init_module+0x10c/0x25b
May 19 06:52:54 canardo kernel: [   49.017735]  [<ffffffff813529d2>] ? system_call_fastpath+0x16/0x1b
May 19 06:52:54 canardo kernel: [   49.017735] Code: 48 8b b3 18 02 00 00 48 85 f6 74 0d 5b 48 c7 c7 47 f8 2e a0 e9 c2 f7 05 e1 5b c3 55 48 89 fd 53 48 83 ec 38 83 3d 43 a2 00 00 00 <48> 8b 9f 08 03 00 00 74 15 48 c7 c6 90 d5 2e a0 48 c7 c7 40 f6 
May 19 06:52:54 canardo kernel: [   49.017735] RIP  [<ffffffffa02e7ae5>] dvb_unregister_frontend+0x10/0xf4 [dvb_core]
May 19 06:52:54 canardo kernel: [   49.017735]  RSP <ffff88021274bcc8>
May 19 06:52:54 canardo kernel: [   49.017735] CR2: 0000000000000308
May 19 06:52:54 canardo kernel: [   53.786264] ---[ end trace c8caf018e0a882dd ]---



--=-=-=
Content-Type: text/x-diff
Content-Disposition: inline;
 filename=0001-media-mantis-fix-silly-crash-case.patch

>From e1d45ae10aea8e8a403e5d96bf5902ee670007ff Mon Sep 17 00:00:00 2001
From: Alan Cox <alan@linux.intel.com>
Date: Thu, 9 Aug 2012 12:33:52 -0300
Subject: [PATCH] [media] mantis: fix silly crash case

If we set mantis->fe to NULL on an error its not a good idea to then try
passing NULL to the unregister paths and oopsing really.

Resolves-bug: https://bugzilla.kernel.org/show_bug.cgi?id=16473

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/mantis/mantis_dvb.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb/mantis/mantis_dvb.c b/drivers/media/dvb/mantis/mantis_dvb.c
index e5180e4..5d15c6b 100644
--- a/drivers/media/dvb/mantis/mantis_dvb.c
+++ b/drivers/media/dvb/mantis/mantis_dvb.c
@@ -248,8 +248,10 @@ int __devinit mantis_dvb_init(struct mantis_pci *mantis)
 err5:
 	tasklet_kill(&mantis->tasklet);
 	dvb_net_release(&mantis->dvbnet);
-	dvb_unregister_frontend(mantis->fe);
-	dvb_frontend_detach(mantis->fe);
+	if (mantis->fe) {
+		dvb_unregister_frontend(mantis->fe);
+		dvb_frontend_detach(mantis->fe);
+	}
 err4:
 	mantis->demux.dmx.remove_frontend(&mantis->demux.dmx, &mantis->fe_mem);
 
-- 
1.7.10.4


--=-=-=--
