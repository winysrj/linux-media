Return-path: <mchehab@pedra>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35765 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264Ab1BGFSP (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 7 Feb 2011 00:18:15 -0500
Received: by wwa36 with SMTP id 36so4417497wwa.1
        for <linux-media@vger.kernel.org>; Sun, 06 Feb 2011 21:18:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <6C78EB6E-7722-447F-833D-637DBB64CF61@dons.net.au>
References: <AANLkTin8Rjch6o7aU-9S9m8f5aBYVeSwxSaVhyEfM5q9@mail.gmail.com>
	<20110206232800.GA83692@io.frii.com>
	<AANLkTinMCTh-u-JgcNB3SsZ2yf+9DgNFGA6thF7S0K15@mail.gmail.com>
	<6C78EB6E-7722-447F-833D-637DBB64CF61@dons.net.au>
Date: Sun, 6 Feb 2011 22:18:13 -0700
Message-ID: <AANLkTinn1XHifYy+PZTaTLP87NAqCind35iO7CBmdU-c@mail.gmail.com>
Subject: Re: Tuning channels with DViCO FusionHDTV7 Dual Express
From: Dave Johansen <davejohansen@gmail.com>
To: v4l-dvb Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Sun, Feb 6, 2011 at 9:10 PM, Daniel O'Connor <darius@dons.net.au> wrote:
>
> On 07/02/2011, at 13:34, Dave Johansen wrote:
>>> However the drivers in Ubuntu at least work for 1 tuner, if I try and use both in mythtv one tends to lock up after a while :-/
>>
>> I actually had the card working and tuning channels about 2 years ago
>> with Ubuntu 08.10 and 09.04. From what I recall 08.10 required updated
>
> Yes that's my recollection.
>
>> drivers but 09.04 didn't, so I'd imagine that it should at least be
>> possible for it to work and possibly just out of the box. But do you
>> think that has a high likelihood of success now?
>
> I would expect at least a single channel and the remote to work since your card seems very similar to mine..
>
> However I don't see any timeouts using mine, at least for 1 channel. Have you looked in dmesg for related parameters?

When I use MythTV's channel scan it gets to Channel 9 and says
"Locked" at the top of the screen and then hangs there after printing
"ATSC Channel 9 -- Timed out, no channels".

Here's the output from the terminal:

2011-02-06 21:55:10.545 DiSEqCDevTree, Warning: No device tree for cardid 1
2011-02-06 21:55:10.547 New DB connection, total: 3
2011-02-06 21:55:10.547 Connected to database 'mythconverg' at host: localhost
2011-02-06 21:55:10.550 New DB connection, total: 4
2011-02-06 21:55:10.550 Connected to database 'mythconverg' at host: localhost
2011-02-06 21:55:10.553 DiSEqCDevTree, Warning: No device tree for cardid 2
2011-02-06 21:55:14.472 Skipping channel fetch, you need to scan for
channels first.

Here's the output from dmesg:

[ 1233.984618] xc5000: waiting for firmware upload (dvb-fe-xc5000-1.6.114.fw)...
[ 1233.986994] xc5000: firmware read 12401 bytes.
[ 1233.986997] xc5000: firmware uploading...
[ 1235.540016] xc5000: firmware upload complete...
[ 1244.872037] BUG: unable to handle kernel paging request at 0000010100000028
[ 1244.872057] IP: [<ffffffffa0034563>] videobuf_dma_unmap+0x43/0xb0
[videobuf_dma_sg]
[ 1244.872074] PGD 0
[ 1244.872087] Oops: 0000 [#1] SMP
[ 1244.872098] last sysfs file:
/sys/devices/pci0000:00/0000:00:10.0/0000:03:00.0/firmware/0000:03:00.0/loading
[ 1244.872143] CPU 1
[ 1244.872146] Modules linked in: snd_hda_codec_nvhdmi
snd_hda_codec_realtek nfsd exportfs nfs lockd fscache nfs_acl
auth_rpcgss sunrpc nvidia(P) xc5000 s5h1411 s5h1409 ir_lirc_codec
lirc_dev ir_sony_decoder ir_jvc_decoder ir_rc6_decoder ir_rc5_decoder
snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_seq_midi snd_rawmidi
snd_seq_midi_event snd_seq ir_nec_decoder cx23885 ir_core snd_timer
cx2341x snd_seq_device video v4l2_common output videodev v4l1_compat
v4l2_compat_ioctl32 videobuf_dma_sg videobuf_dvb snd edac_core psmouse
serio_raw dvb_core videobuf_core btcx_risc tveeprom edac_mce_amd
k8temp shpchp soundcore snd_page_alloc i2c_nforce2 lp parport
dm_raid45 usbhid hid xor forcedeth ahci libahci pata_amd
[ 1244.872478]
[ 1244.872498] Pid: 2119, comm: cx23885[0] dvb Tainted: P
2.6.35-25-generic #44-Ubuntu K9N2GM-FIH(MS-7508)/MS-7508
[ 1244.872544] RIP: 0010:[<ffffffffa0034563>]  [<ffffffffa0034563>]
videobuf_dma_unmap+0x43/0xb0 [videobuf_dma_sg]
[ 1244.872593] RSP: 0018:ffff88005c151dc0  EFLAGS: 00010246
[ 1244.872619] RAX: 0000010100000000 RBX: ffff88005ac47ef8 RCX: 0000000000000002
[ 1244.872646] RDX: 0000000000000006 RSI: ffffc90010918000 RDI: ffff88005d7340a0
[ 1244.872673] RBP: ffff88005c151dd0 R08: 0000000000000000 R09: 00000000ffffffff
[ 1244.872700] R10: 00000000ffffffff R11: 0000000000000001 R12: ffff88004e6cc028
[ 1244.872727] R13: ffff88005ac47ef8 R14: ffff88004e6cc028 R15: ffff88005c1816e0
[ 1244.872755] FS:  00007f0f8f1bf7c0(0000) GS:ffff880001e40000(0000)
knlGS:0000000000000000
[ 1244.872797] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 1244.872822] CR2: 0000010100000028 CR3: 000000005da71000 CR4: 00000000000006e0
[ 1244.872849] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1244.872876] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 1244.872904] Process cx23885[0] dvb (pid: 2119, threadinfo
ffff88005c150000, task ffff88005c1816e0)
[ 1244.872950] Stack:
[ 1244.872968]  ffff88005ac47ef8 ffff88005ac47e00 ffff88005c151e00
ffffffffa0b6a11a
[ 1244.872999] <0> ffff88005c151df0 ffff88004e6cc028 ffff88004e6cc028
ffff88004e6cc128
[ 1244.873045] <0> ffff88005c151e10 ffffffffa0b6bd4e ffff88005c151e40
ffffffffa011e457
[ 1244.873106] Call Trace:
[ 1244.873138]  [<ffffffffa0b6a11a>] cx23885_free_buffer+0x5a/0xa0 [cx23885]
[ 1244.873170]  [<ffffffffa0b6bd4e>] dvb_buf_release+0xe/0x10 [cx23885]
[ 1244.873200]  [<ffffffffa011e457>] videobuf_queue_cancel+0xf7/0x120
[videobuf_core]
[ 1244.873244]  [<ffffffffa011e4e7>] __videobuf_read_stop+0x17/0x70
[videobuf_core]
[ 1244.873289]  [<ffffffffa011e55e>] videobuf_read_stop+0x1e/0x30
[videobuf_core]
[ 1244.873331]  [<ffffffffa00138c8>] videobuf_dvb_thread+0x168/0x1e0
[videobuf_dvb]
[ 1244.873373]  [<ffffffffa0013760>] ? videobuf_dvb_thread+0x0/0x1e0
[videobuf_dvb]
[ 1244.873416]  [<ffffffff8107f266>] kthread+0x96/0xa0
[ 1244.873442]  [<ffffffff8100aee4>] kernel_thread_helper+0x4/0x10
[ 1244.873468]  [<ffffffff8107f1d0>] ? kthread+0x0/0xa0
[ 1244.873492]  [<ffffffff8100aee0>] ? kernel_thread_helper+0x0/0x10
[ 1244.873517] Code: 19 75 6e 8b 53 28 85 d2 74 4b 48 8b 7f 28 8b 4b
30 48 8b 73 20 48 85 ff 74 4e 48 8b 87 e8 01 00 00 48 85 c0 74 42 83
f9 02 77 5d <48> 8b 40 28 48 85 c0 74 0a 45 31 c0 90 ff d0 48 8b 73 20
48 89
[ 1244.873693] RIP  [<ffffffffa0034563>] videobuf_dma_unmap+0x43/0xb0
[videobuf_dma_sg]
[ 1244.873736]  RSP <ffff88005c151dc0>
[ 1244.873756] CR2: 0000010100000028
[ 1244.874101] ---[ end trace aa715ac226248964 ]---



When I run scan on the command line, here's the output on the terminal:

scanning us-ATSC-center-frequencies-8VSB
using '/dev/dvb/adapter0/frontend0' and '/dev/dvb/adapter0/demux0'
>>> tune to: 57028615:8VSB
WARNING: >>> tuning failed!!!
>>> tune to: 57028615:8VSB (tuning failed)
WARNING: >>> tuning failed!!!
>>> tune to: 63028615:8VSB
WARNING: >>> tuning failed!!!
>>> tune to: 63028615:8VSB (tuning failed)
WARNING: >>> tuning failed!!!
>>> tune to: 69028615:8VSB
WARNING: >>> tuning failed!!!
>>> tune to: 69028615:8VSB (tuning failed)
WARNING: >>> tuning failed!!!
>>> tune to: 79028615:8VSB
WARNING: >>> tuning failed!!!
>>> tune to: 79028615:8VSB (tuning failed)
WARNING: >>> tuning failed!!!
>>> tune to: 85028615:8VSB
WARNING: >>> tuning failed!!!
>>> tune to: 85028615:8VSB (tuning failed)
WARNING: >>> tuning failed!!!
>>> tune to: 177028615:8VSB
WARNING: >>> tuning failed!!!
>>> tune to: 177028615:8VSB (tuning failed)
WARNING: >>> tuning failed!!!
>>> tune to: 183028615:8VSB
WARNING: >>> tuning failed!!!
>>> tune to: 183028615:8VSB (tuning failed)
WARNING: >>> tuning failed!!!
>>> tune to: 189028615:8VSB
service is running. Channel number: 9:1. Name: 'KGUN-DT'
service is running. Channel number: 9:2. Name: 'MEXI   '
service is running. Channel number: 9:3. Name: 'COOLTV '
>>> tune to: 195028615:8VSB
WARNING: >>> tuning failed!!!
>>> tune to: 195028615:8VSB (tuning failed)
WARNING: >>> tuning failed!!!
>>> tune to: 201028615:8VSB
WARNING: >>> tuning failed!!!
>>> tune to: 201028615:8VSB (tuning failed)
WARNING: >>> tuning failed!!!
>>> tune to: 207028615:8VSB
WARNING: >>> tuning failed!!!
>>> tune to: 207028615:8VSB (tuning failed)
WARNING: >>> tuning failed!!!
>>> tune to: 213028615:8VSB
WARNING: >>> tuning failed!!!
>>> tune to: 213028615:8VSB (tuning failed)
WARNING: >>> tuning failed!!!
>>> tune to: 473028615:8VSB
WARNING: >>> tuning failed!!!
>>> tune to: 473028615:8VSB (tuning failed)
WARNING: >>> tuning failed!!!
>>> tune to: 479028615:8VSB
WARNING: >>> tuning failed!!!
>>> tune to: 479028615:8VSB (tuning failed)
WARNING: >>> tuning failed!!!
>>> tune to: 485028615:8VSB
WARNING: >>> tuning failed!!!
>>> tune to: 485028615:8VSB (tuning failed)
WARNING: >>> tuning failed!!!
>>> tune to: 491028615:8VSB
WARNING: >>> tuning failed!!!
>>> tune to: 491028615:8VSB (tuning failed)
WARNING: >>> tuning failed!!!
>>> tune to: 497028615:8VSB
WARNING: >>> tuning failed!!!
>>> tune to: 497028615:8VSB (tuning failed)
WARNING: >>> tuning failed!!!
>>> tune to: 503028615:8VSB
WARNING: >>> tuning failed!!!
>>> tune to: 503028615:8VSB (tuning failed)
WARNING: >>> tuning failed!!!
>>> tune to: 509028615:8VSB
WARNING: >>> tuning failed!!!
>>> tune to: 509028615:8VSB (tuning failed)
WARNING: >>> tuning failed!!!
>>> tune to: 515028615:8VSB
WARNING: >>> tuning failed!!!
>>> tune to: 515028615:8VSB (tuning failed)
WARNING: >>> tuning failed!!!
>>> tune to: 521028615:8VSB
WARNING: >>> tuning failed!!!
>>> tune to: 521028615:8VSB (tuning failed)
WARNING: >>> tuning failed!!!
>>> tune to: 527028615:8VSB
WARNING: filter timeout pid 0x0000
WARNING: filter timeout pid 0x1ffb


Here's the dmesg output from when I run scan:

[  269.724190] xc5000: waiting for firmware upload (dvb-fe-xc5000-1.6.114.fw)...
[  269.726431] xc5000: firmware read 12401 bytes.
[  269.726435] xc5000: firmware uploading...
[  271.290017] xc5000: firmware upload complete...
[  302.280684] BUG: unable to handle kernel paging request at 0000010100000028
[  302.280820] IP: [<ffffffffa0079563>] videobuf_dma_unmap+0x43/0xb0
[videobuf_dma_sg]
[  302.280919] PGD 0
[  302.281001] Oops: 0000 [#1] SMP
[  302.281124] last sysfs file:
/sys/devices/pci0000:00/0000:00:10.0/0000:03:00.0/firmware/0000:03:00.0/loading
[  302.281207] CPU 1
[  302.281250] Modules linked in: snd_hda_codec_nvhdmi
snd_hda_codec_realtek nfsd exportfs nfs lockd fscache nfs_acl
auth_rpcgss sunrpc nvidia(P) xc5000 s5h1411 s5h1409 ir_lirc_codec
lirc_dev ir_sony_decoder ir_jvc_decoder ir_rc6_decoder snd_hda_intel
ir_rc5_decoder snd_hda_codec snd_hwdep ir_nec_decoder snd_pcm
snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer
snd_seq_device psmouse cx23885 ir_core cx2341x v4l2_common video
output videodev v4l1_compat serio_raw v4l2_compat_ioctl32
videobuf_dma_sg videobuf_dvb edac_core snd dvb_core videobuf_core
k8temp shpchp edac_mce_amd soundcore btcx_risc tveeprom snd_page_alloc
lp i2c_nforce2 parport dm_raid45 xor ahci forcedeth libahci pata_amd
[  302.284115]
[  302.284171] Pid: 2034, comm: cx23885[0] dvb Tainted: P
2.6.35-25-generic #44-Ubuntu K9N2GM-FIH(MS-7508)/MS-7508
[  302.284255] RIP: 0010:[<ffffffffa0079563>]  [<ffffffffa0079563>]
videobuf_dma_unmap+0x43/0xb0 [videobuf_dma_sg]
[  302.284380] RSP: 0018:ffff88004e271dc0  EFLAGS: 00010246
[  302.284441] RAX: 0000010100000000 RBX: ffff88005a83c0f8 RCX: 0000000000000002
[  302.284506] RDX: 0000000000000006 RSI: ffffc90000379000 RDI: ffff88005d7340a0
[  302.284571] RBP: ffff88004e271dd0 R08: ffff88004e270000 R09: 00000000ffffffff
[  302.284636] R10: 00000000ffffffff R11: 0000000000000001 R12: ffff88004df04828
[  302.284700] R13: ffff88005a83c0f8 R14: ffff88004df04828 R15: ffff88005d1144a0
[  302.284766] FS:  00007f8502279740(0000) GS:ffff880001e40000(0000)
knlGS:0000000000000000
[  302.284845] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  302.284907] CR2: 0000010100000028 CR3: 000000004e20a000 CR4: 00000000000006e0
[  302.284972] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  302.285037] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  302.285102] Process cx23885[0] dvb (pid: 2034, threadinfo
ffff88004e270000, task ffff88005d1144a0)
[  302.285182] Stack:
[  302.285238]  ffff88005a83c0f8 ffff88005a83c000 ffff88004e271e00
ffffffffa016311a
[  302.285420] <0> ffff88004e271df0 ffff88004df04828 ffff88004df04828
ffff88004df04928
[  302.285694] <0> ffff88004e271e10 ffffffffa0164d4e ffff88004e271e40
ffffffffa0056457
[  302.286020] Call Trace:
[  302.286086]  [<ffffffffa016311a>] cx23885_free_buffer+0x5a/0xa0 [cx23885]
[  302.286155]  [<ffffffffa0164d4e>] dvb_buf_release+0xe/0x10 [cx23885]
[  302.286222]  [<ffffffffa0056457>] videobuf_queue_cancel+0xf7/0x120
[videobuf_core]
[  302.286302]  [<ffffffffa00564e7>] __videobuf_read_stop+0x17/0x70
[videobuf_core]
[  302.286382]  [<ffffffffa005655e>] videobuf_read_stop+0x1e/0x30
[videobuf_core]
[  302.286462]  [<ffffffffa003d8c8>] videobuf_dvb_thread+0x168/0x1e0
[videobuf_dvb]
[  302.286541]  [<ffffffffa003d760>] ? videobuf_dvb_thread+0x0/0x1e0
[videobuf_dvb]
[  302.286622]  [<ffffffff8107f266>] kthread+0x96/0xa0
[  302.286685]  [<ffffffff8100aee4>] kernel_thread_helper+0x4/0x10
[  302.286748]  [<ffffffff8107f1d0>] ? kthread+0x0/0xa0
[  302.286810]  [<ffffffff8100aee0>] ? kernel_thread_helper+0x0/0x10
[  302.286873] Code: 19 75 6e 8b 53 28 85 d2 74 4b 48 8b 7f 28 8b 4b
30 48 8b 73 20 48 85 ff 74 4e 48 8b 87 e8 01 00 00 48 85 c0 74 42 83
f9 02 77 5d <48> 8b 40 28 48 85 c0 74 0a 45 31 c0 90 ff d0 48 8b 73 20
48 89
[  302.289546] RIP  [<ffffffffa0079563>] videobuf_dma_unmap+0x43/0xb0
[videobuf_dma_sg]
[  302.289666]  RSP <ffff88004e271dc0>
[  302.289724] CR2: 0000010100000028
[  302.289816] ---[ end trace 5c4743a41e045eed ]---


The error output happens after the scanning of 189028615:8VSB. No
additional output is added during or after it locks up at the warning
message that is displayed.

Is there any additional information that I can provide to help debug this issue?

Thanks,
Dave
