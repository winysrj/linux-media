Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48474 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754516AbbEORnD (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 15 May 2015 13:43:03 -0400
From: Laura Abbott <labbott@fedoraproject.org>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	James Harper <james.harper@ejbdigital.com.au>
Cc: Laura Abbott <labbott@fedoraproject.org>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [media] Fix more regressions in some dib0700 based devices
Date: Fri, 15 May 2015 10:42:35 -0700
Message-Id: <1431711755-32265-1-git-send-email-labbott@fedoraproject.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Several more devices need need to have size_of_priv set, otherwise
we oops:

 DVB: registering new adapter (Hauppauge Nova-TD Stick/Elgato Eye-TV Diversity)
 BUG: unable to handle kernel NULL pointer dereference at 0000000000000080
 IP: [<ffffffffa0669141>] dib7000p_attach+0x11/0xa0 [dib7000p]
 PGD 0 
 Oops: 0002 [#1] SMP 
 Modules linked in: dib7000p dvb_usb_dib0700(+) dib7000m dib0090 dib0070
 dib3000mc dibx000_common dvb_usb dvb_core rc_core bnep bluetooth rfkill
 ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 xt_conntrack ebtable_nat
 ebtable_broute bridge stp llc ebtable_filter ebtables ip6table_nat
 nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_security
 ip6table_raw ip6table_filter ip6_tables iptable_nat nf_conntrack_ipv4
 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_security
 iptable_raw snd_hda_codec_analog snd_hda_codec_generic joydev coretemp kvm
 snd_hda_intel iTCO_wdt gpio_ich iTCO_vendor_support ppdev snd_hda_controller
 dell_wmi sparse_keymap snd_hda_codec snd_hwdep snd_seq snd_seq_device dcdbas
 hid_logitech_hidpp snd_pcm serio_raw lpc_ich mfd_core i2c_i801
 snd_timer snd parport_pc soundcore mei_me tpm_tis parport tpm wmi mei shpchp
 acpi_cpufreq nfsd auth_rpcgss nfs_acl lockd grace sunrpc hid_logitech_dj i915
 e1000e i2c_algo_bit video drm_kms_helper drm ptp pps_core ata_generic
 pata_acpi
 CPU: 0 PID: 23460 Comm: systemd-udevd Not tainted 3.19.5-200.fc21.x86_64 #1
 Hardware name: Dell Inc. OptiPlex 760                 /0R230R, BIOS A05 08/17/2009
 task: ffff880026e29360 ti: ffff880030b64000 task.ti: ffff880030b64000
 RIP: 0010:[<ffffffffa0669141>]  [<ffffffffa0669141>] dib7000p_attach+0x11/0xa0 [dib7000p]
 RSP: 0018:ffff880030b679f8  EFLAGS: 00010202
 RAX: 0000000000000010 RBX: ffff880047b71278 RCX: 0000000000000001
 RDX: 0000000000000000 RSI: ffffffffa06707d8 RDI: 0000000000000010
 RBP: ffff880030b679f8 R08: ffffffff81119fe0 R09: 0000000000017840
 R10: ffffffff810b07e4 R11: 0000000000000246 R12: 0000000000000000
 R13: 0000000000000010 R14: ffff880047b71308 R15: ffff880047b71398
 FS:  00007f005f380880(0000) GS:ffff88007c800000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
 CR2: 0000000000000080 CR3: 000000004e38d000 CR4: 00000000000407f0
 Stack:
 ffff880030b67a28 ffffffffa06430fb ffff880047b71278 ffff880047b71880
 ffff880047b71278 0000000000000000 ffff880030b67a68 ffffffffa0626872
 ffff880047b70000 0000000000000000 ffff880047b71280 ffff880047b70000
 Call Trace:
 [<ffffffffa06430fb>] stk7700d_frontend_attach+0x3b/0x200 [dvb_usb_dib0700]
 [<ffffffffa0626872>] dvb_usb_adapter_frontend_init+0xe2/0x1a0 [dvb_usb]
 [<ffffffffa0625ab7>] dvb_usb_device_init+0x517/0x6f0 [dvb_usb]
 [<ffffffffa063f40e>] dib0700_probe+0x6e/0x100 [dvb_usb_dib0700]
 [<ffffffff817731e6>] ? mutex_lock+0x16/0x40
 [<ffffffff815598fb>] usb_probe_interface+0x1bb/0x300
 [<ffffffff814c9e13>] driver_probe_device+0xa3/0x400
 [<ffffffff814ca24b>] __driver_attach+0x9b/0xa0
 [<ffffffff814ca1b0>] ? __device_attach+0x40/0x40
 [<ffffffff814c7ad3>] bus_for_each_dev+0x73/0xc0
 [<ffffffff814c987e>] driver_attach+0x1e/0x20
 [<ffffffff814c9430>] bus_add_driver+0x180/0x250
 [<ffffffff814caa44>] driver_register+0x64/0xf0
 [<ffffffff81557ff2>] usb_register_driver+0x82/0x160
 [<ffffffffa0663000>] ? 0xffffffffa0663000
 [<ffffffffa066301e>] dib0700_driver_init+0x1e/0x1000 [dvb_usb_dib0700]
 [<ffffffff81002148>] do_one_initcall+0xd8/0x210
 [<ffffffff811fbb59>] ? kmem_cache_alloc_trace+0x1a9/0x230
 [<ffffffff8111f053>] ? load_module+0x2203/0x2800
 [<ffffffff8111f08b>] load_module+0x223b/0x2800
 [<ffffffff8111a810>] ? store_uevent+0x70/0x70
 [<ffffffff8111f71d>] SyS_init_module+0xcd/0x120
 [<ffffffff817752c9>] system_call_fastpath+0x12/0x17
 Code: 8b 87 18 03 00 00 55 48 89 e5 48 05 68 16 00 00 5d c3 0f 1f 84 00 00 00 00 00 66 66 66 66 90 55 48 85 ff 48 89 f8 48 89 e5 74 7f <48> c7 47 70 b0 a9 66 a0 48 c7 47 68 40 9a 66 a0 48 c7 47 30 90 
 RIP  [<ffffffffa0669141>] dib7000p_attach+0x11/0xa0 [dib7000p]
 RSP <ffff880030b679f8>
 CR2: 0000000000000080
 ---[ end trace 288814f44b010d3e ]---

Set it properly.

Signed-off-by: Laura Abbott <labbott@fedoraproject.org>
---
 drivers/media/usb/dvb-usb/dib0700_devices.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/usb/dvb-usb/dib0700_devices.c b/drivers/media/usb/dvb-usb/dib0700_devices.c
index d7d55a2..8030670 100644
--- a/drivers/media/usb/dvb-usb/dib0700_devices.c
+++ b/drivers/media/usb/dvb-usb/dib0700_devices.c
@@ -3944,6 +3944,7 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 
 				DIB0700_DEFAULT_STREAMING_CONFIG(0x02),
 			}},
+				.size_of_priv     = sizeof(struct dib0700_adapter_state),
 			}, {
 			.num_frontends = 1,
 			.fe = {{
@@ -3956,6 +3957,7 @@ struct dvb_usb_device_properties dib0700_devices[] = {
 
 				DIB0700_DEFAULT_STREAMING_CONFIG(0x03),
 			}},
+				.size_of_priv     = sizeof(struct dib0700_adapter_state),
 			}
 		},
 
-- 
2.1.0

