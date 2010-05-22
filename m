Return-path: <linux-media-owner@vger.kernel.org>
Received: from v-smtp-auth-relay-3.gradwell.net ([79.135.125.42]:44193 "EHLO
	v-smtp-auth-relay-3.gradwell.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752860Ab0EVXW3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 22 May 2010 19:22:29 -0400
Received: from zntrx-gw.adsl.newnet.co.uk ([80.175.181.245] helo=echelon.upsilon.org.uk country=GB ident=dave#pop3*upsilon#org^uk)
          by v-smtp-auth-relay-3.gradwell.net with esmtpa (Gradwell gwh-smtpd 1.290) id 4bf865a4.4a42.0
          for linux-media@vger.kernel.org; Sun, 23 May 2010 00:15:48 +0100
          (envelope-sender <news004@upsilon.org.uk>)
Message-ID: <PgbRXOHhWG+LFwFS@echelon.upsilon.org.uk>
Date: Sun, 23 May 2010 00:15:45 +0100
To: linux-media@vger.kernel.org
From: dave cunningham <news004@upsilon.org.uk>
Subject: kernel oops with TT S2-3200
MIME-Version: 1.0
Content-Type: text/plain;charset=us-ascii;format=flowed
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I'm running debian testing on an AMD Sempron box, kernel 2.6.32-3amd64, 
with a TT S2-3200.

I've been setting the box up as a Myth TV backend.

The stock kernel drivers for the S2-3200 appear to work (to the extent 
that I was able to scan for channels in Myth TV) however I was getting 
errors during channel scan (fec_inner not supported in the mythtv log) 
so I updated to v4l-dvb tip to see if this error disappeared.

I now get a kernel oops on loading budget_ci as below.

This is changeset 14873:b576509ea6d2.

I see on the wiki that there is an hg bisect utility that I can use to 
narrow down where this has been introduced. Would it be useful I do so?

Would any more information be useful?


May 22 23:19:31 beta kernel: [   98.394646] IR NEC protocol handler initialized
May 22 23:19:31 beta kernel: [   98.394857] saa7146: register extension 'budget_ci dvb'.
May 22 23:19:31 beta kernel: [   98.394966] budget_ci dvb 0000:04:05.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
May 22 23:19:31 beta kernel: [   98.395020] IRQ 20/: IRQF_DISABLED is not guaranteed on shared IRQs
May 22 23:19:31 beta kernel: [   98.395055] saa7146: found saa7146 @ mem ffffc900116f8c00 (revision 1, irq 20) (0x13c2,0x1019).
May 22 23:19:31 beta kernel: [   98.395069] saa7146 (0): dma buffer size 192512
May 22 23:19:31 beta kernel: [   98.395074] DVB: registering new adapter (TT-Budget S2-3200 PCI)
May 22 23:19:31 beta kernel: [   98.399843] IR RC5(x) protocol handler initialized
May 22 23:19:31 beta kernel: [   98.404301] IR RC6 protocol handler initialized
May 22 23:19:31 beta kernel: [   98.408724] IR JVC protocol handler initialized
May 22 23:19:31 beta kernel: [   98.413024] IR Sony protocol handler initialized
May 22 23:19:31 beta kernel: [   98.429164] adapter has MAC addr = 00:d0:5c:68:2c:ca
May 22 23:19:31 beta kernel: [   98.468015] Registered IR keymap rc-budget-ci-old
May 22 23:19:31 beta kernel: [   98.468261] PGD 0
May 22 23:19:31 beta kernel: [   98.468479] CPU 0
May 22 23:19:31 beta kernel: [   98.468549] Modules linked in: rc_budget_ci_old ir_sony_decoder ir_jvc_decoder ir_rc6_decoder ir_rc5_decoder
ir_nec_decoder budget_ci(+) ir_core budget_core ttpci_eeprom dvb_core saa7146 cryptd aes_x86_64 aes_generic xt_mac xt_TCPMSS xt_tcpudp ipt_LOG
iptable_raw xt_conntrack xt_comment iptable_nat nf_nat xt_MARK ipt_REJECT ipt_addrtype xt_multiport iptable_mangle nf_conntrack_ipv4
nf_defrag_ipv4 xt_state nf_conntrack iptable_filter ip_tables x_tables fuse nfsd exportfs nfs lockd fscache nfs_acl auth_rpcgss sunrpc pppoatm
ppp_generic slhc powernow_k8 it87 hwmon_vid loop arc4 ecb ath9k ath9k_common mac80211 ath9k_hw ath snd_hda_codec_realtek amd64_edac_mod shpchp
cfg80211 i2c_piix4 edac_core k10temp edac_mce_amd i2c_core pci_hotplug rfkill snd_hda_intel parport_pc led_class snd_hda_codec snd_hwdep
snd_pcm_oss snd_mixer_oss snd_pcm evdev parport snd_timer snd soundcore snd_page_alloc speedtch usbatm pcspkr atm psmouse processor serio_raw
ext3 jbd mbcache fan ide_gd_mod ata_generic
May 22 23:19:31 beta kernel: ohci_hcd ide_pci_generic ahci libata atiixp button thermal thermal_sys r8169 mii ehci_hcd scsi_mod ide_core usbcore
nls_base [last unloaded: scsi_wait_scan]
May 22 23:19:31 beta kernel: [   98.472002] Pid: 2746, comm: work_for_cpu Not tainted 2.6.32-3-amd64 #1 A760G M2+
May 22 23:19:31 beta kernel: [   98.472002] RIP: 0010:[<ffffffffa068db7e>]  [<ffffffffa068db7e>] ir_register_class+0x4d/0x18f [ir_core]
May 22 23:19:31 beta kernel: [   98.472002] RSP: 0018:ffff88007cf67db0  EFLAGS: 00010246
May 22 23:19:31 beta kernel: [   98.472002] RAX: 0000000000000000 RBX: ffff88007c1a5400 RCX: ffffffffa068ee60
May 22 23:19:31 beta kernel: [   98.472002] RDX: 0000000000000000 RSI: ffffffffa068e94a RDI: ffff88007c1a5400
May 22 23:19:31 beta kernel: [   98.472002] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000073
May 22 23:19:31 beta kernel: [   98.472002] R10: 0000000000000000 R11: 00000000000000dc R12: ffffffffa06c0060
May 22 23:19:31 beta kernel: [   98.472002] R13: ffff88007cf4c000 R14: 0000000000000286 R15: ffffffffa0698ed3
May 22 23:19:31 beta kernel: [   98.472002] FS:  00007f498d78c6f0(0000) GS:ffff880001800000(0000) knlGS:0000000000000000
May 22 23:19:31 beta kernel: [   98.472002] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
May 22 23:19:31 beta kernel: [   98.472002] CR2: 0000000000000000 CR3: 0000000001001000 CR4: 00000000000006f0
May 22 23:19:31 beta kernel: [   98.472002] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
May 22 23:19:31 beta kernel: [   98.472002] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
May 22 23:19:31 beta kernel: [   98.472002] Process work_for_cpu (pid: 2746, threadinfo ffff88007cf66000, task ffff88007b67cdb0)
May 22 23:19:31 beta kernel: [   98.472002]  ffff88007c1a5400 ffff88007cf4c000 ffffffffa06c0060 000000000000002d
May 22 23:19:31 beta kernel: [   98.472002] <0> 0000000000000286 ffffffffa068d9b6 0000000000000004 ffffffff00000000
May 22 23:19:31 beta kernel: [   98.472002] <0> ffff88007c1a5630 ffff88007c1a5608 ffff88007cf66000 ffff88007cf4a000
May 22 23:19:31 beta kernel: [   98.472002]  [<ffffffffa068d9b6>] ? __ir_input_register+0x264/0x308 [ir_core]
May 22 23:19:31 beta kernel: [   98.472002]  [<ffffffffa069848e>] ? budget_ci_attach+0x25c/0xc52 [budget_ci]
May 22 23:19:31 beta kernel: [   98.472002]  [<ffffffffa065988c>] ? saa7146_init_one+0x442/0x566 [saa7146]
May 22 23:19:31 beta kernel: [   98.472002]  [<ffffffff81060e3c>] ? do_work_for_cpu+0x0/0x1b
May 22 23:19:31 beta kernel: [   98.472002]  [<ffffffff81197ad5>] ? local_pci_probe+0x12/0x16
May 22 23:19:31 beta kernel: [   98.472002]  [<ffffffff81060e47>] ? do_work_for_cpu+0xb/0x1b
May 22 23:19:31 beta kernel: [   98.472002]  [<ffffffff81063ea5>] ? kthread+0x75/0x7d
May 22 23:19:31 beta kernel: [   98.472002]  [<ffffffff81011aea>] ? child_rip+0xa/0x20
May 22 23:19:31 beta kernel: [   98.472002]  [<ffffffff81063e30>] ? kthread+0x0/0x7d
May 22 23:19:31 beta kernel: [   98.472002]  [<ffffffff81011ae0>] ? child_rip+0x0/0x20
May 22 23:19:31 beta kernel: [   98.472002]  RSP <ffff88007cf67db0>
May 22 23:19:31 beta kernel: [   98.476558] ---[ end trace fef3457bebe88aec ]---

-- 
Dave Cunningham                                  dave at upsilon org uk
                                                  PGP KEY ID: 0xA78636DC
