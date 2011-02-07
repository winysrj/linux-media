Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:13372 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755398Ab1BGXyb (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Feb 2011 18:54:31 -0500
Subject: Re: Tuning channels with DViCO FusionHDTV7 Dual Express
From: Andy Walls <awalls@md.metrocast.net>
To: Dave Johansen <davejohansen@gmail.com>
Cc: v4l-dvb Mailing List <linux-media@vger.kernel.org>
In-Reply-To: <AANLkTinn1XHifYy+PZTaTLP87NAqCind35iO7CBmdU-c@mail.gmail.com>
References: <AANLkTin8Rjch6o7aU-9S9m8f5aBYVeSwxSaVhyEfM5q9@mail.gmail.com>
	 <20110206232800.GA83692@io.frii.com>
	 <AANLkTinMCTh-u-JgcNB3SsZ2yf+9DgNFGA6thF7S0K15@mail.gmail.com>
	 <6C78EB6E-7722-447F-833D-637DBB64CF61@dons.net.au>
	 <AANLkTinn1XHifYy+PZTaTLP87NAqCind35iO7CBmdU-c@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Feb 2011 18:54:30 -0500
Message-ID: <1297122870.2355.21.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sun, 2011-02-06 at 22:18 -0700, Dave Johansen wrote:
> On Sun, Feb 6, 2011 at 9:10 PM, Daniel O'Connor <darius@dons.net.au> wrote:
> >
> > On 07/02/2011, at 13:34, Dave Johansen wrote:
> >>> However the drivers in Ubuntu at least work for 1 tuner, if I try and use both in mythtv one tends to lock up after a while :-/
> >>
> >> I actually had the card working and tuning channels about 2 years ago
> >> with Ubuntu 08.10 and 09.04. From what I recall 08.10 required updated
> >
> > Yes that's my recollection.
> >
> >> drivers but 09.04 didn't, so I'd imagine that it should at least be
> >> possible for it to work and possibly just out of the box. But do you
> >> think that has a high likelihood of success now?
> >
> > I would expect at least a single channel and the remote to work since your card seems very similar to mine..
> >
> > However I don't see any timeouts using mine, at least for 1 channel. Have you looked in dmesg for related parameters?
> 
> When I use MythTV's channel scan it gets to Channel 9 and says
> "Locked" at the top of the screen and then hangs there after printing
> "ATSC Channel 9 -- Timed out, no channels".
> 
> Here's the output from the terminal:
> 
> 2011-02-06 21:55:10.545 DiSEqCDevTree, Warning: No device tree for cardid 1
> 2011-02-06 21:55:10.547 New DB connection, total: 3
> 2011-02-06 21:55:10.547 Connected to database 'mythconverg' at host: localhost
> 2011-02-06 21:55:10.550 New DB connection, total: 4
> 2011-02-06 21:55:10.550 Connected to database 'mythconverg' at host: localhost
> 2011-02-06 21:55:10.553 DiSEqCDevTree, Warning: No device tree for cardid 2
> 2011-02-06 21:55:14.472 Skipping channel fetch, you need to scan for
> channels first.
> 
> Here's the output from dmesg:
> 
> [ 1233.984618] xc5000: waiting for firmware upload (dvb-fe-xc5000-1.6.114.fw)...
> [ 1233.986994] xc5000: firmware read 12401 bytes.
> [ 1233.986997] xc5000: firmware uploading...
> [ 1235.540016] xc5000: firmware upload complete...
> [ 1244.872037] BUG: unable to handle kernel paging request at 0000010100000028
> [ 1244.872057] IP: [<ffffffffa0034563>] videobuf_dma_unmap+0x43/0xb0
> [videobuf_dma_sg]
> [ 1244.872074] PGD 0
> [ 1244.872087] Oops: 0000 [#1] SMP
> [ 1244.872098] last sysfs file:
> /sys/devices/pci0000:00/0000:00:10.0/0000:03:00.0/firmware/0000:03:00.0/loading
> [ 1244.872143] CPU 1
> [ 1244.872146] Modules linked in: snd_hda_codec_nvhdmi
> snd_hda_codec_realtek nfsd exportfs nfs lockd fscache nfs_acl
> auth_rpcgss sunrpc nvidia(P) xc5000 s5h1411 s5h1409 ir_lirc_codec
> lirc_dev ir_sony_decoder ir_jvc_decoder ir_rc6_decoder ir_rc5_decoder
> snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_seq_midi snd_rawmidi
> snd_seq_midi_event snd_seq ir_nec_decoder cx23885 ir_core snd_timer
> cx2341x snd_seq_device video v4l2_common output videodev v4l1_compat
> v4l2_compat_ioctl32 videobuf_dma_sg videobuf_dvb snd edac_core psmouse
> serio_raw dvb_core videobuf_core btcx_risc tveeprom edac_mce_amd
> k8temp shpchp soundcore snd_page_alloc i2c_nforce2 lp parport
> dm_raid45 usbhid hid xor forcedeth ahci libahci pata_amd
> [ 1244.872478]
> [ 1244.872498] Pid: 2119, comm: cx23885[0] dvb Tainted: P
> 2.6.35-25-generic #44-Ubuntu K9N2GM-FIH(MS-7508)/MS-7508
> [ 1244.872544] RIP: 0010:[<ffffffffa0034563>]  [<ffffffffa0034563>]
> videobuf_dma_unmap+0x43/0xb0 [videobuf_dma_sg]
> [ 1244.872593] RSP: 0018:ffff88005c151dc0  EFLAGS: 00010246
> [ 1244.872619] RAX: 0000010100000000 RBX: ffff88005ac47ef8 RCX: 0000000000000002
> [ 1244.872646] RDX: 0000000000000006 RSI: ffffc90010918000 RDI: ffff88005d7340a0
> [ 1244.872673] RBP: ffff88005c151dd0 R08: 0000000000000000 R09: 00000000ffffffff
> [ 1244.872700] R10: 00000000ffffffff R11: 0000000000000001 R12: ffff88004e6cc028
> [ 1244.872727] R13: ffff88005ac47ef8 R14: ffff88004e6cc028 R15: ffff88005c1816e0
> [ 1244.872755] FS:  00007f0f8f1bf7c0(0000) GS:ffff880001e40000(0000)
> knlGS:0000000000000000
> [ 1244.872797] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [ 1244.872822] CR2: 0000010100000028 CR3: 000000005da71000 CR4: 00000000000006e0
> [ 1244.872849] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [ 1244.872876] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [ 1244.872904] Process cx23885[0] dvb (pid: 2119, threadinfo
> ffff88005c150000, task ffff88005c1816e0)
> [ 1244.872950] Stack:
> [ 1244.872968]  ffff88005ac47ef8 ffff88005ac47e00 ffff88005c151e00
> ffffffffa0b6a11a
> [ 1244.872999] <0> ffff88005c151df0 ffff88004e6cc028 ffff88004e6cc028
> ffff88004e6cc128
> [ 1244.873045] <0> ffff88005c151e10 ffffffffa0b6bd4e ffff88005c151e40
> ffffffffa011e457
> [ 1244.873106] Call Trace:
> [ 1244.873138]  [<ffffffffa0b6a11a>] cx23885_free_buffer+0x5a/0xa0 [cx23885]
> [ 1244.873170]  [<ffffffffa0b6bd4e>] dvb_buf_release+0xe/0x10 [cx23885]
> [ 1244.873200]  [<ffffffffa011e457>] videobuf_queue_cancel+0xf7/0x120
> [videobuf_core]
> [ 1244.873244]  [<ffffffffa011e4e7>] __videobuf_read_stop+0x17/0x70
> [videobuf_core]
> [ 1244.873289]  [<ffffffffa011e55e>] videobuf_read_stop+0x1e/0x30
> [videobuf_core]
> [ 1244.873331]  [<ffffffffa00138c8>] videobuf_dvb_thread+0x168/0x1e0
> [videobuf_dvb]
> [ 1244.873373]  [<ffffffffa0013760>] ? videobuf_dvb_thread+0x0/0x1e0
> [videobuf_dvb]
> [ 1244.873416]  [<ffffffff8107f266>] kthread+0x96/0xa0
> [ 1244.873442]  [<ffffffff8100aee4>] kernel_thread_helper+0x4/0x10
> [ 1244.873468]  [<ffffffff8107f1d0>] ? kthread+0x0/0xa0
> [ 1244.873492]  [<ffffffff8100aee0>] ? kernel_thread_helper+0x0/0x10
> [ 1244.873517] Code: 19 75 6e 8b 53 28 85 d2 74 4b 48 8b 7f 28 8b 4b
> 30 48 8b 73 20 48 85 ff 74 4e 48 8b 87 e8 01 00 00 48 85 c0 74 42 83
> f9 02 77 5d <48> 8b 40 28 48 85 c0 74 0a 45 31 c0 90 ff d0 48 8b 73 20
> 48 89
> [ 1244.873693] RIP  [<ffffffffa0034563>] videobuf_dma_unmap+0x43/0xb0
> [videobuf_dma_sg]
> [ 1244.873736]  RSP <ffff88005c151dc0>
> [ 1244.873756] CR2: 0000010100000028
> [ 1244.874101] ---[ end trace aa715ac226248964 ]---

The cx23885 driver is bombing out in videobuf routines:

http://git.linuxtv.org/media_tree.git?a=blob;f=drivers/media/video/cx23885/cx23885-dvb.c;h=5958cb882e939db4908aa44cdefef8d8cb3948fc;hb=staging/for_v2.6.39#l108
http://git.linuxtv.org/media_tree.git?a=blob;f=drivers/media/video/cx23885/cx23885-core.c;h=359882419b7f588b7c698dbcfb6a39ddb1603301;hb=staging/for_v2.6.39#l1226
http://git.linuxtv.org/media_tree.git?a=blob;f=drivers/media/video/videobuf-dma-sg.c;h=ddb8f4b46c03bacea044ec9395adefdcee69350d;hb=staging/for_v2.6.39#l301
http://git.linuxtv.org/media_tree.git?a=blob;f=include/asm-generic/dma-mapping-common.h;h=0c80bb38773f142ef829dcbc190c60f2cf6ccff8;hb=staging/for_v2.6.39#l66

The local variable "ops" in dma_unmap_sg() is apparently a bad pointer;
it is the value RAX: 0000010100000000.  Maybe that is some sort of
"poison" value for memory pointers.  Your next BUG has the exact same
bad pointer.

I'm not sure where the actual failure is coming from though. 

I never bothered to understand videobuf enough to help further on this
one.


> The error output happens after the scanning of 189028615:8VSB. No
> additional output is added during or after it locks up at the warning
> message that is displayed.
> 
> Is there any additional information that I can provide to help debug this issue?

You perhaps could 

A. provide the smallest window of known good vs known bad kernel
versions.  Maybe someone with time and hardware can 'git bisect' the
issue down to the problem commit.  (I'm guessing this problem might be
specific to a particular 64 bit platform IOMMU type, given the bad
dma_ops pointer.)

B. Try the latest drivers and/or bleeding edege kernel to see if the
problem has already been solved.  (Back up your current stuff first.)

Regards,
Andy

> Thanks,
> Dave


