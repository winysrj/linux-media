Return-path: <linux-media-owner@vger.kernel.org>
Received: from v-smtpgw2.han.skanova.net ([81.236.60.205]:55070 "EHLO
        v-smtpgw2.han.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727364AbeJTVmh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 20 Oct 2018 17:42:37 -0400
Received: from [192.168.0.3] (tobbe.home.lan [192.168.0.3])
        by gammdatan.home.lan (8.15.2/8.14.7) with ESMTP id w9KDQ47J030501
        for <linux-media@vger.kernel.org>; Sat, 20 Oct 2018 15:26:05 +0200
From: Torbjorn Jansson <torbjorn.jansson@mbox200.swipnet.se>
Subject: cec kernel oops with pulse8 usb cec adapter
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Message-ID: <b067e063-641c-0498-4989-3edda5296f9a@mbox200.swipnet.se>
Date: Sat, 20 Oct 2018 15:26:05 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello

i'm using the pulse8 usb cec adapter to control my tv.
i have a few scripts that poll the power status of my tv and after a while it 
stops working returning errors when trying to check if tv is on or off.
this i think matches a kernel oops i'm seeing that i suspect is related to this.

i have sometimes been able to recover from this problem by completely cutting 
power to my tv and also unplugging the usb cec adapter.
i have a feeling that the tv is at least partly to blame for cec-ctl not 
working but in any case there shouldn't be a kernel oops.


also every now and then i see this in dmesg:
cec cec0: transmit: failed 05
cec cec0: transmit: failed 06
but that doesn't appear to do any harm as far as i can tell.

any idea whats causing the oops?

the ops:

BUG: unable to handle kernel NULL pointer dereference at 0000000000000038
PGD 0 P4D 0
Oops: 0000 [#1] SMP PTI
CPU: 9 PID: 27687 Comm: kworker/9:2 Tainted: P           OE 
4.18.12-200.fc28.x86_64 #1
Hardware name: Supermicro C7X99-OCE-F/C7X99-OCE-F, BIOS 2.1a 06/15/2018
Workqueue: events pulse8_irq_work_handler [pulse8_cec]
RIP: 0010:ir_lirc_scancode_event+0x3d/0xb0 [rc_core]
Code: 8d ae b4 07 00 00 49 81 c6 b8 07 00 00 53 e8 4a df c3 d5 48 89 ef 49 89 
45 00 e8 4e 84 41 d6 49 8b 1e 49 89 c4 4c 39 f3 74 58 <8b> 43 38 8b 53 40 89 c1 
2b 4b 3c 39 ca 72 41 21 d0 49 8b 7d 00 49
RSP: 0018:ffffaa10e3c07d58 EFLAGS: 00010017
RAX: 0000000000000002 RBX: 0000000000000000 RCX: 0000000000000018
RDX: 0000000000000001 RSI: 00316245397fa93c RDI: ffff966d31c8d7b4
RBP: ffff966d31c8d7b4 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000003 R11: ffffaa10e3c07e28 R12: 0000000000000002
R13: ffffaa10e3c07d88 R14: ffff966d31c8d7b8 R15: 0000000000000073
FS:  0000000000000000(0000) GS:ffff966d3f440000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000038 CR3: 00000009d820a003 CR4: 00000000003606e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  ir_do_keydown+0x75/0x260 [rc_core]
  rc_keydown+0x54/0xc0 [rc_core]
  cec_received_msg_ts+0xaa8/0xaf0 [cec]
  process_one_work+0x1a1/0x350
  worker_thread+0x30/0x380
  ? pwq_unbound_release_workfn+0xd0/0xd0
  kthread+0x112/0x130
  ? kthread_create_worker_on_cpu+0x70/0x70
  ret_from_fork+0x35/0x40
Modules linked in: rc_tt_1500 dvb_usb_dvbsky dvb_usb_v2 uas usb_storage fuse 
vhost_net vhost tap xt_CHECKSUM iptable_mangle ip6t_REJECT nf_reject_ipv6 tun 
8021q garp mrp xt_nat macvlan xfs devlink ebta
  si2157 si2168 cx25840 cx23885 kvm altera_ci tda18271 joydev ir_rc6_decoder 
rc_rc6_mce crct10dif_pclmul crc32_pclmul ghash_clmulni_intel intel_cstate 
intel_uncore altera_stapl m88ds3103 tveeprom cx2341
  mxm_wmi igb crc32c_intel megaraid_sas dca i2c_algo_bit wmi vfio_pci irqbypass 
vfio_virqfd vfio_iommu_type1 vfio i2c_dev
CR2: 0000000000000038
---[ end trace 6cea307e2666b11a ]---
RIP: 0010:ir_lirc_scancode_event+0x3d/0xb0 [rc_core]
Code: 8d ae b4 07 00 00 49 81 c6 b8 07 00 00 53 e8 4a df c3 d5 48 89 ef 49 89 
45 00 e8 4e 84 41 d6 49 8b 1e 49 89 c4 4c 39 f3 74 58 <8b> 43 38 8b 53 40 89 c1 
2b 4b 3c 39 ca 72 41 21 d0 49 8b 7d 00 49
RSP: 0018:ffffaa10e3c07d58 EFLAGS: 00010017
RAX: 0000000000000002 RBX: 0000000000000000 RCX: 0000000000000018
RDX: 0000000000000001 RSI: 00316245397fa93c RDI: ffff966d31c8d7b4
RBP: ffff966d31c8d7b4 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000003 R11: ffffaa10e3c07e28 R12: 0000000000000002
R13: ffffaa10e3c07d88 R14: ffff966d31c8d7b8 R15: 0000000000000073
FS:  0000000000000000(0000) GS:ffff966d3f440000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000038 CR3: 00000009d820a003 CR4: 00000000003606e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
