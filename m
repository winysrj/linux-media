Return-path: <linux-media-owner@vger.kernel.org>
Received: from cpsmtpb-ews10.kpnxchange.com ([213.75.39.15]:51685 "EHLO
	cpsmtpb-ews10.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751142Ab3HTVJP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Aug 2013 17:09:15 -0400
Message-ID: <5213D986.4070204@xutrox.com>
Date: Tue, 20 Aug 2013 23:03:02 +0200
From: Arjan Koers <0h61vkll2ly8@xutrox.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: gennarone@gmail.com
Subject: r820t tuner oops on kernel 3.10.8
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

Can commit 4aab0398e003ac2effae98ba66a012ed715967ba be added to linux
stable?

Without this patch I get the following error (after unplugging and
reconnecting the dvb-t device):

[  255.245514] BUG: unable to handle kernel NULL pointer dereference at 0000000000000050
[  255.245705] IP: [<ffffffffa00fa502>] i2c_transfer+0x6/0x90 [i2c_core]
[  255.245852] PGD 40fca1067 PUD 40fca2067 PMD 0
[  255.245979] Oops: 0000 [#1] SMP
[  255.246069] Modules linked in: r820t rtl2832 dvb_usb_rtl28xxu rtl2830 dvb_usb_v2 dvb_core netconsole xt_hl ip6t_rt nf_conntrack_ipv6 nf_defrag_ipv6 ipt_REJECT xt_LOG xt_limit xt_tcpudp xt_addrtype nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack ip6table_filter ip6_tables ipv6 nf_conntrack_netbios_ns nf_conntrack_broadcast nf_nat_ftp nf_nat nf_conntrack_ftp nf_conntrack iptable_filter ip_tables x_tables loop radeon snd_hda_codec_hdmi snd_hda_codec_realtek fbcon bitblit softcursor font drm_kms_helper ttm snd_hda_intel snd_hda_codec drm acpi_cpufreq mperf cfbfillrect kvm_amd cfbimgblt cfbcopyarea i2c_algo_bit i2c_core snd_pcm backlight snd_page_alloc kvm snd_timer fb snd processor thermal_sys evdev button soundcore fbdev hwmon sd_mod hid_generic usbhid hid r8169 mii ahci libahci libata scsi_mod ohci_hcd ehci_pci ehci_hcd
[  255.248354] CPU: 1 PID: 357 Comm: kworker/1:1 Not tainted 3.10.8-201308201925-6f5405942321c322f1ba83960837b63a8ebb039e #1
[  255.248575] Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./M3A785GMH/128M, BIOS P1.50 04/20/2010
[  255.248851] Workqueue: events dvb_usbv2_init_work [dvb_usb_v2]
[  255.248969] task: ffff88042d97c640 ti: ffff88041e718000 task.ti: ffff88041e718000
[  255.249104] RIP: 0010:[<ffffffffa00fa502>]  [<ffffffffa00fa502>] i2c_transfer+0x6/0x90 [i2c_core]
[  255.249283] RSP: 0000:ffff88041e719d18  EFLAGS: 00010282
[  255.249382] RAX: 0000000000000000 RBX: ffff88041dd61080 RCX: 0000000000000001
[  255.249511] RDX: 0000000000000002 RSI: ffff88041e719d60 RDI: 0000000000000040
[  255.249640] RBP: ffff88041e719da8 R08: 0000000000000001 R09: 0000000000000001
[  255.249769] R10: ffff88041e719d50 R11: 0000000000000005 R12: 00000000ffffffed
[  255.249898] R13: 0000000000000005 R14: ffff88041dd610fc R15: ffff88041e719dbb
[  255.250028] FS:  00007feaa4840700(0000) GS:ffff88042fd00000(0000) knlGS:0000000000000000
[  255.250174] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  255.250280] CR2: 0000000000000050 CR3: 000000040fcb4000 CR4: 00000000000007e0
[  255.250408] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  255.250537] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  255.250664] Stack:
[  255.250708]  ffff88041dd61080 ffff88041e719da8 00000000ffffffed 0000000000000005
[  255.250896]  ffffffffa03ce759 0000000000000001 ffffffffa03c94fd 0300000000000000
[  255.251084]  01ffffff812a0930 ffff000100000000 ffff88041dd610fb ffff000500010000
[  255.251270] Call Trace:
[  255.251330]  [<ffffffffa03ce759>] ? r820t_read.constprop.6+0x70/0x14e [r820t]
[  255.251481]  [<ffffffffa03c94fd>] ? rtl2832_wr_demod_reg+0x11f/0x12e [rtl2832]
[  255.251634]  [<ffffffffa03ce9ad>] ? r820t_attach+0x176/0x25a [r820t]
[  255.251771]  [<ffffffffa03c0042>] ? rtl2832u_tuner_attach+0x2fd/0x36b [dvb_usb_rtl28xxu]
[  255.251940]  [<ffffffffa03b9e6c>] ? dvb_usbv2_init_work+0x777/0x857 [dvb_usb_v2]
[  255.252099]  [<ffffffff8103a6bb>] ? process_one_work+0x15a/0x210
[  255.252213]  [<ffffffff8103ab1c>] ? worker_thread+0x139/0x1de
[  255.252322]  [<ffffffff8103a9e3>] ? rescuer_thread+0x24f/0x24f
[  255.252434]  [<ffffffff8103e78f>] ? kthread+0x7d/0x85
[  255.252533]  [<ffffffff81040000>] ? posix_cpu_nsleep+0x94/0xe5
[  255.252644]  [<ffffffff8103e712>] ? __kthread_parkme+0x59/0x59
[  255.252758]  [<ffffffff812a532c>] ? ret_from_fork+0x7c/0xb0
[  255.252866]  [<ffffffff8103e712>] ? __kthread_parkme+0x59/0x59
[  255.252974] Code: 8d 74 24 04 48 c7 c2 73 af 0f a0 e8 08 03 0e e1 eb 10 8b 74 24 04 48 89 c7 e8 80 ff ff ff 85 c0 74 d9 5b 5b c3 41 55 41 54 55 53 <48> 8b 47 10 48 89 fb 48 83 38 00 74 6a 65 48 8b 04 25 60 b7 00
[  255.254114] RIP  [<ffffffffa00fa502>] i2c_transfer+0x6/0x90 [i2c_core]
[  255.254264]  RSP <ffff88041e719d18>
[  255.254332] CR2: 0000000000000050
[  255.254456] ---[ end trace b50b69fee84c5f70 ]---
[  255.255493] BUG: unable to handle kernel paging request at ffffffffffffffd8
[  255.263390] IP: [<ffffffff8103ea4b>] kthread_data+0x7/0xc
[  255.270487] PGD 13ae067 PUD 13b0067 PMD 0
[  255.277589] Oops: 0000 [#2] SMP
[  255.284619] Modules linked in: r820t rtl2832 dvb_usb_rtl28xxu rtl2830 dvb_usb_v2 dvb_core netconsole xt_hl ip6t_rt nf_conntrack_ipv6 nf_defrag_ipv6 ipt_REJECT xt_LOG xt_limit xt_tcpudp xt_addrtype nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack ip6table_filter ip6_tables ipv6 nf_conntrack_netbios_ns nf_conntrack_broadcast nf_nat_ftp nf_nat nf_conntrack_ftp nf_conntrack iptable_filter ip_tables x_tables loop radeon snd_hda_codec_hdmi
