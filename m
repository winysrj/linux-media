Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:47111 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757292Ab1FILVh (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Jun 2011 07:21:37 -0400
Message-ID: <4DF0ACDB.9000800@redhat.com>
Date: Thu, 09 Jun 2011 13:22:03 +0200
From: Hans de Goede <hdegoede@redhat.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Crash on unplug with the uvc driver in linuxtv/staging/for_v3.1
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

When I unplug a uvc camera *while streaming* I get:

Jun  9 13:20:02 shalem kernel: [15824.809741] BUG: unable to handle kernel NULL pointer dereference at           (null)
Jun  9 13:20:02 shalem kernel: [15824.809816] IP: [<ffffffffa0309eae>] media_entity_put+0x12/0x2c [media]
Jun  9 13:20:02 shalem kernel: [15824.809877] PGD 0
Jun  9 13:20:02 shalem kernel: [15824.809898] Oops: 0000 [#1] SMP
Jun  9 13:20:02 shalem kernel: [15824.809933] CPU 1
Jun  9 13:20:02 shalem kernel: [15824.809952] Modules linked in: uvcvideo videodev media v4l2_compat_ioctl32 nf_conntrack_ipv4 nf_defrag_ipv4 vfat fat tcp_lp tun fuse ebtable_nat ebtables cpufreq_ondemand acpi_cpufreq freq_table mperf bridge stp llc be2iscsi iscsi_boot_sysfs bnx2i cnic uio cxgb3i libcxgbi iw_cxgb3 cxgb3 mdio ib_iser rdma_cm ib_cm iw_cm ib_sa ib_mad ib_core ib_addr iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi ip6t_REJECT nf_conntrack_ipv6 coretemp xt_physdev nf_defrag_ipv6 ip6table_filter xt_state ip6_tables nf_conntrack snd_hda_codec_hdmi snd_hda_codec_conexant 
snd_hda_intel snd_hda_codec snd_bt87x usb_storage snd_seq snd_usb_audio uas snd_pcm snd_hwdep snd_usbmidi_lib ppdev snd_rawmidi microcode e1000e snd_seq_device serio_raw i2c_i801 snd_timer tpm_infineon snd iTCO_wdt parport_pc parport soundcore mei(C) iTCO_vendor_support snd_page_alloc virtio_net kvm_intel kvm ipv6 i915 drm_kms_helper drm i2c_algo_bit i2c_core video [last unloaded: tuner_types]
Jun  9 13:20:02 shalem kernel: [15824.810794]
Jun  9 13:20:02 shalem kernel: [15824.810811] Pid: 4944, comm: camorama Tainted: G         C  3.0.0-rc1+ #5 FUJITSU D3071-S1/D3071-S1
Jun  9 13:20:02 shalem kernel: [15824.810888] RIP: 0010:[<ffffffffa0309eae>]  [<ffffffffa0309eae>] media_entity_put+0x12/0x2c [media]
Jun  9 13:20:02 shalem kernel: [15824.810961] RSP: 0018:ffff88011da23d98  EFLAGS: 00010286
Jun  9 13:20:02 shalem kernel: [15824.811003] RAX: 0000000000000000 RBX: ffff88006a864400 RCX: 0000000000000118
Jun  9 13:20:02 shalem kernel: [15824.811057] RDX: 0000000000000001 RSI: 0000000000000004 RDI: ffff88006a864400
Jun  9 13:20:02 shalem kernel: [15824.811112] RBP: ffff88011da23d98 R08: ffffea0002896e28 R09: ffff88011da23d38
Jun  9 13:20:02 shalem kernel: [15824.811165] R10: ffffffffa0526026 R11: ffffffff81a58210 R12: ffff880027d43840
Jun  9 13:20:02 shalem kernel: [15824.811219] R13: 0000000000000008 R14: ffff880133310dc0 R15: ffff88012db76300
Jun  9 13:20:02 shalem kernel: [15824.811274] FS:  00007f7942ff49c0(0000) GS:ffff88013e280000(0000) knlGS:0000000000000000
Jun  9 13:20:02 shalem kernel: [15824.811336] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Jun  9 13:20:02 shalem kernel: [15824.811381] CR2: 0000000000000000 CR3: 0000000001a03000 CR4: 00000000000406e0
Jun  9 13:20:02 shalem kernel: [15824.811435] DR0: 0000000000000003 DR1: 00000000000000b0 DR2: 0000000000000001
Jun  9 13:20:02 shalem kernel: [15824.811491] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Jun  9 13:20:02 shalem kernel: [15824.811546] Process camorama (pid: 4944, threadinfo ffff88011da22000, task ffff880113618000)
Jun  9 13:20:02 shalem kernel: [15824.811609] Stack:
Jun  9 13:20:02 shalem kernel: [15824.811629]  ffff88011da23db8 ffffffffa0510203 ffff880027d43840 ffff880133310dc0
Jun  9 13:20:02 shalem kernel: [15824.811695]  ffff88011da23e08 ffffffff811233fe ffff880027d43850 ffff880134530500
Jun  9 13:20:02 shalem kernel: [15824.811763]  ffffffff811e3397 ffff880027d43840 ffff8801347a5b80 0000000000000000
Jun  9 13:20:02 shalem kernel: [15824.811829] Call Trace:
Jun  9 13:20:02 shalem kernel: [15824.811856]  [<ffffffffa0510203>] v4l2_release+0x7b/0x8e [videodev]
Jun  9 13:20:02 shalem kernel: [15824.811910]  [<ffffffff811233fe>] fput+0x121/0x1e3
Jun  9 13:20:02 shalem kernel: [15824.811953]  [<ffffffff811e3397>] ? exit_sem+0x1c7/0x1d8
Jun  9 13:20:02 shalem kernel: [15824.811998]  [<ffffffff811208a7>] filp_close+0x6e/0x7a
Jun  9 13:20:02 shalem kernel: [15824.812041]  [<ffffffff81131b33>] ? __d_free+0x53/0x58
Jun  9 13:20:02 shalem kernel: [15824.812084]  [<ffffffff810567e1>] put_files_struct+0x6e/0xd5
Jun  9 13:20:02 shalem kernel: [15824.812130]  [<ffffffff810568d5>] exit_files+0x41/0x46
Jun  9 13:20:02 shalem kernel: [15824.812172]  [<ffffffff81056e55>] do_exit+0x2aa/0x738
Jun  9 13:20:02 shalem kernel: [15824.812214]  [<ffffffff8104be73>] ? wake_up_state+0x10/0x12
Jun  9 13:20:02 shalem kernel: [15824.812259]  [<ffffffff81062ba2>] ? signal_wake_up+0x32/0x43
Jun  9 13:20:02 shalem kernel: [15824.812304]  [<ffffffff810638b4>] ? zap_other_threads+0x59/0x82
Jun  9 13:20:02 shalem kernel: [15824.812352]  [<ffffffff81057568>] do_group_exit+0x7a/0xa2
Jun  9 13:20:02 shalem kernel: [15824.812395]  [<ffffffff810575a7>] sys_exit_group+0x17/0x17
Jun  9 13:20:02 shalem kernel: [15824.812440]  [<ffffffff81487802>] system_call_fastpath+0x16/0x1b
Jun  9 13:20:02 shalem kernel: [15824.812486] Code: 10 66 41 ff 44 24 40 48 83 c4 18 44 89 f0 5b 41 5c 41 5d 41 5e 41 5f 5d c3 55 48 89 e5 66 66 66 66 90 48 85 ff 74 1c 48 8b 47 10
Jun  9 13:20:02 shalem kernel: [15824.812783] RIP  [<ffffffffa0309eae>] media_entity_put+0x12/0x2c [media]
Jun  9 13:20:02 shalem kernel: [15824.812839]  RSP <ffff88011da23d98>
Jun  9 13:20:02 shalem kernel: [15824.812867] CR2: 0000000000000000
Jun  9 13:20:02 shalem kernel: [15824.873494] ---[ end trace bfc278787db8cbfb ]---
Jun  9 13:20:02 shalem kernel: [15824.873496] Fixing recursive fault but reboot is needed!

I've not tested if this also impacts 3.0!!

I also get the following during building linuxtv/staging/for_v3.1:

   CC [M]  drivers/media/video/uvc/uvc_entity.o
drivers/media/video/uvc/uvc_entity.c: In function ‘uvc_mc_register_entities’:
drivers/media/video/uvc/uvc_entity.c:110:6: warning: ‘ret’ may be used uninitialized in this function [-Wuninitialized]

Regards,

Hans
