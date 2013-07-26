Return-path: <linux-media-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:48518 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757496Ab3GZJKO (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Jul 2013 05:10:14 -0400
Date: Fri, 26 Jul 2013 11:10:13 +0200
From: Petr Janecek <janecek@ucw.cz>
To: linux-media@vger.kernel.org
Subject: siano: divide error: 0000 [#1] SMP
Message-ID: <20130726091013.GA1018@atrey.karlin.mff.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,
      since about 3.10, siano dvb-t tuner (usb id 187f:0202) crashes the
machine when plugged in before boot. No such problem if connected later.


Regards,

Petr


[   38.387145] divide error: 0000 [#1] SMP 
[   38.391132] Modules linked in: ip6table_filter ip6_tables ebtable_nat ebtables ipt_REJECT xt_CHECKSUM iptable_mangle xt_tcpudp iptable_filter ip_tables x_tables bridge stp llc kvm_intel kvm dm_crypt snd_hda_codec_hdmi snd_hda_codec_idt snd_hda_intel snd_hda_codec snd_hwdep smsusb smsdvb dvb_core snd_pcm smsmdtv snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer snd_seq_device snd soundcore lpc_ich serio_raw snd_page_alloc coretemp nfsd nfs_acl auth_rpcgss oid_registry nfs fscache binfmt_misc lockd sunrpc xfs exportfs libcrc32c hid_generic usbhid hid e1000e firewire_ohci ptp i915 ahci drm_kms_helper firewire_core crc_itu_t libahci drm i2c_algo_bit pps_core video usb_storage [last unloaded: ipmi_msghandler]
[   38.397124] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.11.0-rc2 #6
[   38.397124] Hardware name:                  /DG45ID, BIOS IDG4510H.86A.0135.2011.0225.1100 02/25/2011
[   38.397124] task: ffffffff81c10440 ti: ffffffff81c00000 task.ti: ffffffff81c00000
[   38.397124] RIP: 0010:[<ffffffffa043d1a2>]  [<ffffffffa043d1a2>] smsdvb_update_per_slices+0xd2/0xe0 [smsdvb]
[   38.397124] RSP: 0018:ffff88012bc03c18  EFLAGS: 00010046
[   38.397124] RAX: 0000000000000000 RBX: ffff880124599000 RCX: 0000000000000000
[   38.397124] RDX: 0000000000000000 RSI: ffff8800370da008 RDI: ffff880124599000
[   38.397124] RBP: ffff88012bc03c18 R08: 0000000000000001 R09: 0000000000000001
[   38.397124] R10: 0000000000000000 R11: 0000000000000000 R12: ffff880124d24ac0
[   38.397124] R13: ffff8800370da008 R14: ffff8800370da000 R15: ffff8800370042e0
[   38.397124] FS:  0000000000000000(0000) GS:ffff88012bc00000(0000) knlGS:0000000000000000
[   38.397124] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   38.397124] CR2: 00007f186c361c80 CR3: 00000001240a8000 CR4: 00000000000407f0
[   38.397124] Stack:
[   38.397124]  ffff88012bc03c48 ffffffffa043e088 ffff8800370da000 ffff880124d24ac0
[   38.397124]  ffff880125482000 00000000fffc020c ffff88012bc03c78 ffffffffa042e6e1
[   38.397124]  ffff8801268f0390 ffff8800370da000 ffff8801268f0000 ffff8801268f03b0
[   38.397124] Call Trace:
[   38.397124]  <IRQ> 
[   38.397124]  [<ffffffffa043e088>] smsdvb_onresponse+0x1b8/0x280 [smsdvb]
[   38.397124]  [<ffffffffa042e6e1>] smscore_onresponse+0x91/0x450 [smsmdtv]
[   38.397124]  [<ffffffffa045e184>] smsusb_onresponse+0xb4/0x1f0 [smsusb]
[   38.397124]  [<ffffffff8147f084>] usb_hcd_giveback_urb+0x64/0xe0
[   38.397124]  [<ffffffff81495d81>] ehci_urb_done+0x71/0xb0
[   38.397124]  [<ffffffff814992ed>] qh_completions+0x1ed/0x380
[   38.397124]  [<ffffffff8149994b>] scan_async+0x7b/0xe0
[   38.397124]  [<ffffffff8149b130>] ehci_work+0x70/0xd0
[   38.397124]  [<ffffffff8149b431>] ehci_irq+0x201/0x2c0
[   38.397124]  [<ffffffff8147e23e>] usb_hcd_irq+0x2e/0x50
[   38.397124]  [<ffffffff810e6af5>] handle_irq_event_percpu+0x75/0x260
[   38.397124]  [<ffffffff810e6d28>] handle_irq_event+0x48/0x70
[   38.397124]  [<ffffffff810e9d5e>] ? handle_fasteoi_irq+0x1e/0x100
[   38.397124]  [<ffffffff810e9d9a>] handle_fasteoi_irq+0x5a/0x100
[   38.397124]  [<ffffffff81004940>] handle_irq+0x60/0x150
[   38.397124]  [<ffffffff81644906>] ? atomic_notifier_call_chain+0x16/0x20
[   38.397124]  [<ffffffff8164b21a>] do_IRQ+0x5a/0xe0
[   38.397124]  [<ffffffff816406aa>] common_interrupt+0x6a/0x6a
[   38.397124]  <EOI> 
[   38.397124]  [<ffffffff814f6b5b>] ? cpuidle_enter_state+0x5b/0xe0
[   38.397124]  [<ffffffff814f6b57>] ? cpuidle_enter_state+0x57/0xe0
[   38.397124]  [<ffffffff814f6ca0>] cpuidle_idle_call+0xc0/0x260
[   38.397124]  [<ffffffff8100bcbe>] arch_cpu_idle+0xe/0x30
[   38.397124]  [<ffffffff8109dcf6>] cpu_idle_loop+0x86/0x270
[   38.397124]  [<ffffffff8109df4b>] cpu_startup_entry+0x6b/0x70
[   38.397124]  [<ffffffff81624d51>] rest_init+0xd1/0xe0
[   38.397124]  [<ffffffff81624c85>] ? rest_init+0x5/0xe0
[   38.397124]  [<ffffffff81cefe70>] start_kernel+0x3c1/0x3ce
[   38.397124]  [<ffffffff81cef941>] ? repair_env_string+0x5a/0x5a
[   38.397124]  [<ffffffff81cef5a6>] x86_64_start_reservations+0x2a/0x2c
[   38.397124]  [<ffffffff81cef694>] x86_64_start_kernel+0xec/0xf3
[   38.397124] Code: 00 00 03 48 01 87 05 0b 00 00 8b 46 4c 48 01 87 96 0a 00 00 8b 46 48 48 01 87 bb 0a 00 00 8b 4e 10 89 c8 c1 e0 10 29 c8 03 4e 0c <48> f7 f1 89 87 e8 0b 00 00 5d c3 0f 1f 00 66 66 66 66 90 55 48 
[   38.397124] RIP  [<ffffffffa043d1a2>] smsdvb_update_per_slices+0xd2/0xe0 [smsdvb]
[   38.397124]  RSP <ffff88012bc03c18>
[   38.397124] ---[ end trace 8ecbe785c081e3cd ]---

