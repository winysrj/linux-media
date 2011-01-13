Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:46052 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756675Ab1AMSPS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 13 Jan 2011 13:15:18 -0500
Date: Thu, 13 Jan 2011 16:13:34 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: mkrufky@kernellabs.com
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 3/3] [media] tda8290: Fix a bug if no tuner is detected
Message-ID: <20110113161334.1a089a9c@pedra>
In-Reply-To: <7c3d11fc6242f190067a9c64cb2b3ba670e51739.1294942291.git.mchehab@redhat.com>
References: <7c3d11fc6242f190067a9c64cb2b3ba670e51739.1294942291.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

If tda8290 is detected, but no tuner is found, the driver will do bad
things:

tuner 2-0060: chip found @ 0xc0 (saa7133[0])
tda829x 2-0060: could not clearly identify tuner address, defaulting to 60
tda829x 2-0060: tuner access failed!
BUG: unable to handle kernel NULL pointer dereference at 0000000000000020
IP: [<ffffffffa048c267>] set_audio+0x47/0x170 [tda8290]
PGD 1187b0067 PUD 11771e067 PMD 0
Oops: 0002 [#1] SMP
last sysfs file: /sys/module/i2c_core/initstate
CPU 0
Modules linked in: tda8290(U) tea5767(U) tuner(U) ir_lirc_codec(U) lirc_dev(U) ir_sony_decoder(U) ir_jvc_decoder(U) ir_rc6_decoder(U) ir_rc5_decoder(U) saa7134(+)(U) v4l2_common(U) ir_nec_decoder(U) videodev(U) v4l2_compat_ioctl32(U) rc_core(U) videobuf_dma_sg(U) videobuf_core(U) tveeprom(U) ebtable_nat ebtables xt_CHECKSUM iptable_mangle ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT bridge stp llc autofs4 sunrpc cpufreq_ondemand acpi_cpufreq freq_table xt_physdev iptable_filter ip_tables ip6t_REJECT ip6table_filter ip6_tables ipv6 dm_mirror dm_region_hash dm_log parport kvm_intel kvm uinput floppy tpm_infineon wmi sg serio_raw iTCO_wdt iTCO_vendor_support tg3 snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm snd_timer snd soundcore snd_page_alloc i7core_edac edac_core nouveau
Modules linked in: tda8290(U) tea5767(U) tuner(U) ir_lirc_codec(U) lirc_dev(U) ir_sony_decoder(U) ir_jvc_decoder(U) ir_rc6_decoder(U) ir_rc5_decoder(U) saa7134(+)(U) v4l2_common(U) ir_nec_decoder(U) videodev(U) v4l2_compat_ioctl32(U) rc_core(U) videobuf_dma_sg(U) videobuf_core(U) tveeprom(U) ebtable_nat ebtables xt_CHECKSUM iptable_mangle ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT bridge stp llc autofs4 sunrpc cpufreq_ondemand acpi_cpufreq freq_table xt_physdev iptable_filter ip_tables ip6t_REJECT ip6table_filter ip6_tables ipv6 dm_mirror dm_region_hash dm_log parport kvm_intel kvm uinput floppy tpm_infineon wmi sg serio_raw iTCO_wdt iTCO_vendor_support tg3 snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm snd_timer snd soundcore snd_page_alloc i7core_edac edac_core nouveau ttm drm_kms_helper drm i2c_algo_bit video output i2c_core ext3 jbd mbcache firewire_ohci firewire_core crc!
 _itu_t sr_mod cdrom sd_mod crc_t10dif ahci dm_mod [last unloaded: microcode]
Pid: 9497, comm: modprobe Not tainted 2.6.32-72.el6.x86_64 #1 HP Z400 Workstation
RIP: 0010:[<ffffffffa048c267>]  [<ffffffffa048c267>] set_audio+0x47/0x170 [tda8290]
RSP: 0018:ffff88010ba01b28  EFLAGS: 00010206
RAX: 00000000000000ff RBX: ffff880119522800 RCX: 0000000000000002
RDX: 0000000000003be0 RSI: ffff88010ba01bb8 RDI: 0000000000000000
RBP: ffff88010ba01b28 R08: 0000000000000002 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: ffff88010ba01bb8 R14: 0000000000001900 R15: 0000000000001900
FS:  00007f4b96b3d700(0000) GS:ffff880028200000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000020 CR3: 000000011866c000 CR4: 00000000000026f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process modprobe (pid: 9497, threadinfo ffff88010ba00000, task ffff880100708a70)
Stack:
 ffff88010ba01b98 ffffffffa048c95b ffff88010ba01b78 0000000000000060
<0> 0000000000000000 0000000e00000000 000000000000001d ffffffffa03ec838
<0> ffff88010abac240 ffff880119522800 ffff880119522800 ffff880119522bc0
Call Trace:
 [<ffffffffa048c95b>] tda8295_set_params+0x3b/0x210 [tda8290]
 [<ffffffffa03ec838>] ? v4l2_i2c_new_subdev_cfg+0x88/0xc0 [v4l2_common]
 [<ffffffffa0484418>] set_freq+0x128/0x2f0 [tuner]
 [<ffffffffa0486464>] tuner_s_std+0xc4/0x740 [tuner]
 [<ffffffffa04b9ae6>] saa7134_set_tvnorm_hw+0x2d6/0x3d0 [saa7134]
 [<ffffffffa04ba455>] set_tvnorm+0xd5/0x100 [saa7134]
 [<ffffffffa04bc9fd>] saa7134_video_init2+0x1d/0x50 [saa7134]
 [<ffffffffa04bf57e>] saa7134_initdev+0x6e1/0xb1d [saa7134]
 [<ffffffff8125afea>] ? kobject_get+0x1a/0x30
 [<ffffffff812765f7>] local_pci_probe+0x17/0x20
 [<ffffffff812777e1>] pci_device_probe+0x101/0x120
 [<ffffffff8132ec72>] ? driver_sysfs_add+0x62/0x90
 [<ffffffff8132ee10>] driver_probe_device+0xa0/0x2a0
 [<ffffffff8132f0bb>] __driver_attach+0xab/0xb0
 [<ffffffff8132f010>] ? __driver_attach+0x0/0xb0
 [<ffffffff8132e074>] bus_for_each_dev+0x64/0x90
 [<ffffffff8132ebae>] driver_attach+0x1e/0x20
 [<ffffffff8132e4b0>] bus_add_driver+0x200/0x300
 [<ffffffff8132f3e6>] driver_register+0x76/0x140
 [<ffffffff814c7c43>] ? printk+0x41/0x46
 [<ffffffff81277a46>] __pci_register_driver+0x56/0xd0
 [<ffffffffa04de000>] ? saa7134_init+0x0/0x4f [saa7134]
 [<ffffffffa04de04d>] saa7134_init+0x4d/0x4f [saa7134]
 [<ffffffff8100a04c>] do_one_initcall+0x3c/0x1d0
 [<ffffffff810af5ef>] sys_init_module+0xdf/0x250
 [<ffffffff81013172>] system_call_fastpath+0x16/0x1b
Code: 20 01 49 c7 c0 c9 ec 48 a0 83 7e 04 01 74 2d 8b 0d 3f 2f 00 00 85 c9 0f 85 d7 00 00 00 c9 c3 0f 1f 44 00 00 a9 03 00 01 00 74 61 <c6> 47 20 02 83 7e 04 01 49 c7 c0 cc ec 48 a0 75 d3 0f b6 47 22
RIP  [<ffffffffa048c267>] set_audio+0x47/0x170 [tda8290]
 RSP <ffff88010ba01b28>
CR2: 0000000000000020

This happens because some I2C callbacks actually depend on having the
driver entirely initialized. To avoid this OOPS, just clean the I2C
callbacks, as if no device were detected.

Cc: Michael Krufky <mkrufky@kernellabs.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/common/tuners/tda8290.c b/drivers/media/common/tuners/tda8290.c
index 5f889c1..11ea4e0 100644
--- a/drivers/media/common/tuners/tda8290.c
+++ b/drivers/media/common/tuners/tda8290.c
@@ -755,8 +755,11 @@ struct dvb_frontend *tda829x_attach(struct dvb_frontend *fe,
 	}
 
 	if ((!(cfg) || (TDA829X_PROBE_TUNER == cfg->probe_tuner)) &&
-	    (tda829x_find_tuner(fe) < 0))
+	    (tda829x_find_tuner(fe) < 0)) {
+		memset(&fe->ops.analog_ops, 0, sizeof(struct analog_demod_ops));
+
 		goto fail;
+	}
 
 	switch (priv->ver) {
 	case TDA8290:
-- 
1.7.1

