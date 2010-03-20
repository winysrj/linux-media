Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.155]:25688 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753003Ab0CTQDJ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 20 Mar 2010 12:03:09 -0400
Received: by fg-out-1718.google.com with SMTP id 19so337168fgg.1
        for <linux-media@vger.kernel.org>; Sat, 20 Mar 2010 09:03:07 -0700 (PDT)
Message-ID: <4BA4F1B5.80500@googlemail.com>
Date: Sat, 20 Mar 2010 17:03:01 +0100
From: e9hack <e9hack@googlemail.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
CC: linux-media@vger.kernel.org
Subject: Re: av7110 and budget_av are broken!
References: <4B8E4A6F.2050809@googlemail.com> <4B9FDC37.8000806@googlemail.com> <201003201507.09504@orion.escape-edv.de> <201003201520.40069.hverkuil@xs4all.nl>
In-Reply-To: <201003201520.40069.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Am 20.3.2010 15:20, schrieb Hans Verkuil:
> Hartmut, is the problem with unloading the module something that my patch
> caused? Or was that there as well before changeset 14351:2eda2bcc8d6f?
> Are there any kernel messages indicating why it won't unload?

Changset 14351:2eda2bcc8d6f causes a kernel oops during unload of the module for my dvb
cards. The call trace points to dvb_ttpci. I assumed, that the FF card is affected only.
It may be possible, that budget-av does crash also, if it is unload as second.

Regards,
Hartmut

Mar  3 11:42:33 vdr kernel: [ 3291.915576] saa7146: unregister extension 'budget_av'.
Mar  3 11:42:33 vdr kernel: [ 3291.916426] budget_av 0000:04:07.0: PCI INT A disabled
Mar  3 11:42:33 vdr kernel: [ 3291.918565] saa7146: unregister extension 'dvb'.
Mar  3 11:42:33 vdr kernel: [ 3291.918750] BUG: unable to handle kernel NULL pointer
dereference at (null)
Mar  3 11:42:33 vdr kernel: [ 3291.918966] IP: [<ffffffffa0286aac>]
v4l2_device_unregister+0x1c/0x60 [videodev]
Mar  3 11:42:33 vdr kernel: [ 3291.919013] PGD 3db10067 PUD 37a3d067 PMD 0
Mar  3 11:42:33 vdr kernel: [ 3291.919013] Oops: 0000 [#1] PREEMPT SMP
Mar  3 11:42:33 vdr kernel: [ 3291.919013] last sysfs file:
/sys/devices/platform/w83627ehf.2576/cpu0_vid
Mar  3 11:42:33 vdr kernel: [ 3291.919013] CPU 0
Mar  3 11:42:33 vdr kernel: [ 3291.919013] Pid: 15305, comm: rmmod Not tainted
2.6.33-64-suse-11.0 #4 MS-7207PV/MS-7207PV
Mar  3 11:42:33 vdr kernel: [ 3291.919013] RIP: 0010:[<ffffffffa0286aac>]
[<ffffffffa0286aac>] v4l2_device_unregister+0x1c/0x60 [videodev]
Mar  3 11:42:33 vdr kernel: [ 3291.919013] RSP: 0018:ffff88003da55cc8  EFLAGS: 00010203
Mar  3 11:42:33 vdr kernel: [ 3291.919013] RAX: 0000000000000000 RBX: 0000000000000000
RCX: ffff88003d64d3e0
Mar  3 11:42:34 vdr kernel: [ 3291.919013] RDX: 0000000000000001 RSI: 0000000000000000
RDI: 0000000000000000
Mar  3 11:42:34 vdr kernel: [ 3291.919013] RBP: ffff880037fd7018 R08: 0000000080808081
R09: 0000000000000000
Mar  3 11:42:34 vdr kernel: [ 3291.919013] R10: 0000000000000000 R11: ffffffffa02812a0
R12: ffff880037fd7020
Mar  3 11:42:34 vdr kernel: [ 3291.919013] R13: 0000000000000000 R14: 0000000000000001
R15: ffff88003fb98888
Mar  3 11:42:34 vdr kernel: [ 3291.919013] FS:  00007f2def23b6f0(0000)
GS:ffff880001800000(0000) knlGS:0000000000000000
Mar  3 11:42:34 vdr kernel: [ 3291.919013] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Mar  3 11:42:34 vdr kernel: [ 3291.919013] CR2: 0000000000000000 CR3: 0000000037abd000
CR4: 00000000000006f0
Mar  3 11:42:34 vdr kernel: [ 3291.919013] DR0: 0000000000000000 DR1: 0000000000000000
DR2: 0000000000000000
Mar  3 11:42:34 vdr kernel: [ 3291.919013] DR3: 0000000000000000 DR6: 00000000ffff0ff0
DR7: 0000000000000400
Mar  3 11:42:34 vdr kernel: [ 3291.919013] Process rmmod (pid: 15305, threadinfo
ffff88003da54000, task ffff880009830080)
Mar  3 11:42:34 vdr kernel: [ 3291.919013] Stack:
Mar  3 11:42:34 vdr kernel: [ 3291.919013]  ffff88003edc0108 ffff880037fd7000
ffff88003db47000 ffffffffa0396ca5
Mar  3 11:42:34 vdr kernel: [ 3291.919013] <0> ffffffffa03df158 ffff88003edc0108
ffff880037fd7118 ffff880037fd7000
Mar  3 11:42:34 vdr kernel: [ 3291.919013] <0> ffffffffa03df158 0000000000000001
ffff88003fb98888 ffffffffa03cb2c5
Mar  3 11:42:34 vdr kernel: [ 3291.919013] Call Trace:
Mar  3 11:42:34 vdr kernel: [ 3291.919013]  [<ffffffffa0396ca5>] ?
saa7146_vv_release+0x45/0x140 [saa7146_vv]
Mar  3 11:42:34 vdr kernel: [ 3291.919013]  [<ffffffffa03cb2c5>] ?
av7110_exit_v4l+0x45/0x60 [dvb_ttpci]
Mar  3 11:42:34 vdr kernel: [ 3291.919013]  [<ffffffffa03d9748>] ?
av7110_detach+0x138/0x2a0 [dvb_ttpci]
Mar  3 11:42:34 vdr kernel: [ 3291.919013]  [<ffffffffa02dd322>] ?
saa7146_remove_one+0xb2/0x230 [saa7146]
Mar  3 11:42:34 vdr kernel: [ 3291.919013]  [<ffffffff811dd37f>] ? pci_device_remove+0x2f/0x60
Mar  3 11:42:34 vdr kernel: [ 3291.919013]  [<ffffffff81270c88>] ?
__device_release_driver+0x78/0xf0
Mar  3 11:42:34 vdr kernel: [ 3291.919013]  [<ffffffff81270db0>] ? driver_detach+0xb0/0xc0
Mar  3 11:42:34 vdr kernel: [ 3291.919013]  [<ffffffff8126fca4>] ? bus_remove_driver+0x84/0xe0
Mar  3 11:42:34 vdr kernel: [ 3291.919013]  [<ffffffff811dd69f>] ?
pci_unregister_driver+0x3f/0xc0
Mar  3 11:42:34 vdr kernel: [ 3291.919013]  [<ffffffffa02dd1a7>] ?
saa7146_unregister_extension+0x27/0x60 [saa7146]
Mar  3 11:42:34 vdr kernel: [ 3291.919013]  [<ffffffff81084db6>] ?
sys_delete_module+0x1f6/0x2d0
Mar  3 11:42:34 vdr kernel: [ 3291.919013]  [<ffffffff81344255>] ?
_raw_spin_unlock_irqrestore+0x15/0x40
Mar  3 11:42:34 vdr kernel: [ 3291.919013]  [<ffffffff81002e6b>] ?
system_call_fastpath+0x16/0x1b
Mar  3 11:42:34 vdr kernel: [ 3291.919013] Code: fe e0 48 c7 03 00 00 00 00 5b c3 0f 1f 40
00 41 54 48 85 ff 55 48 89 fd 53 74 4a e8 cf ff ff ff 48 8b 5d 08 4c 8d 65 08 4c 39 e3 <
Mar  3 11:42:34 vdr kernel: [ 3291.919013] RIP  [<ffffffffa0286aac>]
v4l2_device_unregister+0x1c/0x60 [videodev]
Mar  3 11:42:34 vdr kernel: [ 3291.919013]  RSP <ffff88003da55cc8>
Mar  3 11:42:34 vdr kernel: [ 3291.919013] CR2: 0000000000000000
Mar  3 11:42:34 vdr kernel: [ 3291.934087] ---[ end trace 685f9ceb9b064f25 ]---
Mar  3 11:42:52 vdr logger: rcvdr: stop
Mar  3 11:43:34 vdr shutdown[5610]: shutting down for system reboot
