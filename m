Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:45956 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752391AbcAFKVo (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 6 Jan 2016 05:21:44 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Junghak Sung <jh1009.sung@samsung.com>
From: Matthias Schwarzott <zzam@gentoo.org>
Subject: [REGRESSION/bisected] kernel oops in vb2_core_qbuf when tuning to DVB
 on the HVR-4400 caused by videobuf2: Refactor vb2_fileio_data and vb2_thread
Cc: Geunyoung Kim <nenggun.kim@samsung.com>,
	Seung-Woo Kim <sw0312.kim@samsung.com>,
	Inki Dae <inki.dae@samsung.com>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Message-ID: <568CEA98.1070403@gentoo.org>
Date: Wed, 6 Jan 2016 11:21:12 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

When tuning the HVR-4400 to a DVB-C channel I get this kernel oops:

Jan  3 21:59:39 gauss kernel: BUG: unable to handle kernel NULL pointer
dereference at 00000000000001a0
Jan  3 21:59:39 gauss kernel: IP: [<ffffffffa019e2c8>]
vb2_core_qbuf+0x18/0x200 [videobuf2_core]
Jan  3 21:59:39 gauss kernel: PGD bbf99067 PUD b9dbf067 PMD 0
Jan  3 21:59:39 gauss kernel: Oops: 0000 [#1] SMP
Jan  3 21:59:39 gauss kernel: Modules linked in: si2165(O) a8293(O)
tda10071(O) tea5767(O) tuner(O) cx23885(O) tda18271(O) videobuf2_dvb(O)
videobuf2_dma_sg(O) videobuf2_memops(O) frame_vector(PO)
videobuf2_v4l2(O) videobuf2_core(O) tveeprom(O) cx2341x(O)
v4l2_common(O) videodev(O) media(O) dvb_core(O) rc_core(O) regmap_i2c
bluetooth rtl8192cu rtl_usb rtl8192c_common uas rtlwifi usb_storage
snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic
snd_hda_intel snd_hda_codec x86_pkg_temp_thermal kvm_intel kvm snd_hwdep
snd_hda_core [last unloaded: si2165]
Jan  3 21:59:39 gauss kernel: CPU: 2 PID: 29081 Comm: vb2-cx23885[0]
Tainted: P        W  O    4.2.8-gentoo #1
Jan  3 21:59:39 gauss kernel: Hardware name: MEDION E2050
2391/H81H3-EM2, BIOS H81EM2W08.308 08/25/2014
Jan  3 21:59:39 gauss kernel: task: ffff880087533300 ti:
ffff880101ca8000 task.ti: ffff880101ca8000
Jan  3 21:59:39 gauss kernel: RIP: 0010:[<ffffffffa019e2c8>]
[<ffffffffa019e2c8>] vb2_core_qbuf+0x18/0x200 [videobuf2_core]
Jan  3 21:59:39 gauss kernel: RSP: 0018:ffff880101cabe28  EFLAGS: 00010246
Jan  3 21:59:39 gauss kernel: RAX: ffff880087533300 RBX:
ffff8800a9c98000 RCX: 00000000000003a5
Jan  3 21:59:39 gauss kernel: RDX: ffff8800a9c98000 RSI:
0000000000005e00 RDI: ffff88011995e828
Jan  3 21:59:39 gauss kernel: RBP: ffff880101cabe48 R08:
0000000000000007 R09: 0000000000000001
Jan  3 21:59:39 gauss kernel: R10: 0000000000000000 R11:
ffff88011995e828 R12: ffff88011a457780
Jan  3 21:59:39 gauss kernel: R13: 0000000000000000 R14:
ffff8800a9c98000 R15: ffff88011995e828
Jan  3 21:59:39 gauss kernel: FS:  0000000000000000(0000)
GS:ffff88011fb00000(0000) knlGS:0000000000000000
Jan  3 21:59:39 gauss kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
0000000080050033
Jan  3 21:59:39 gauss kernel: CR2: 00000000000001a0 CR3:
00000000b9e63000 CR4: 00000000001406e0
Jan  3 21:59:39 gauss kernel: Stack:
Jan  3 21:59:39 gauss kernel:  ffff8800a9c98000 ffff88011a457780
0000000000000000 0000000000000000
Jan  3 21:59:39 gauss kernel:  ffff880101cabeb8 ffffffffa019f83c
ffff88004550bb58 ffff880087533300
Jan  3 21:59:39 gauss kernel:  ffff8800a9c9a400 0000000000cac000
ffff88011995e828 ffffffffa019f610
Jan  3 21:59:39 gauss kernel: Call Trace:
Jan  3 21:59:39 gauss kernel:  [<ffffffffa019f83c>]
vb2_thread+0x22c/0x3c0 [videobuf2_core]
Jan  3 21:59:39 gauss kernel:  [<ffffffffa019f610>] ?
vb2_core_dqbuf+0x5a0/0x5a0 [videobuf2_core]
Jan  3 21:59:39 gauss kernel:  [<ffffffffa019f610>] ?
vb2_core_dqbuf+0x5a0/0x5a0 [videobuf2_core]
Jan  3 21:59:39 gauss kernel:  [<ffffffff8106c464>] kthread+0xc4/0xe0
Jan  3 21:59:39 gauss kernel:  [<ffffffff8106c3a0>] ?
kthread_worker_fn+0x150/0x150
Jan  3 21:59:39 gauss kernel:  [<ffffffff8189d04f>] ret_from_fork+0x3f/0x70
Jan  3 21:59:39 gauss kernel:  [<ffffffff8106c3a0>] ?
kthread_worker_fn+0x150/0x150
Jan  3 21:59:39 gauss kernel: Code: c7 a8 1d 1a a0 e8 12 67 6f e1 31 c0
e9 70 ff ff ff 66 90 55 89 f6 48 89 e5 41 56 41 55 41 54 53 49 89 d6 4c
8b ac f7 80 00 00 00 <41> 8b 95 a0 01 00 00 83 fa 01 0f 84 fb 00 00 00
49 89 fc 0f 82
Jan  3 21:59:39 gauss kernel: RIP  [<ffffffffa019e2c8>]
vb2_core_qbuf+0x18/0x200 [videobuf2_core]
Jan  3 21:59:39 gauss kernel:  RSP <ffff880101cabe28>
Jan  3 21:59:39 gauss kernel: CR2: 00000000000001a0
Jan  3 21:59:39 gauss kernel: ---[ end trace f45084629c26b0e2 ]---

It oopses in vb2_core_qbuf+0x18
addr2line shows this:
	media_build/v4l/videobuf2-core.c:1377

>From decodecode:
  13:   55                      push   %rbp
  14:   89 f6                   mov    %esi,%esi
  16:   48 89 e5                mov    %rsp,%rbp
  19:   41 56                   push   %r14
  1b:   41 55                   push   %r13
  1d:   41 54                   push   %r12
  1f:   53                      push   %rbx
  20:   49 89 d6                mov    %rdx,%r14
  23:   4c 8b ac f7 80 00 00    mov    0x80(%rdi,%rsi,8),%r13
  2a:   00
  2b:*  41 8b 95 a0 01 00 00    mov    0x1a0(%r13),%edx         <--
trapping instruction
  32:   83 fa 01                cmp    $0x1,%edx
  35:   0f 84 fb 00 00 00       je     0x136
  3b:   49 89 fc                mov    %rdi,%r12

1375: vb = q->bufs[index];
1376:
1377: switch (vb->state) {

The value vb (r13) is equal to 0 here.

I bisected the oops to this commit:
70433a152f0058404afb5496a9329e4e26b127df is the first bad commit
commit 70433a152f0058404afb5496a9329e4e26b127df
Author: Junghak Sung <jh1009.sung@samsung.com>
Date:   Tue Nov 3 08:16:41 2015 -0200

    [media] media: videobuf2: Refactor vb2_fileio_data and vb2_thread

    Replace v4l2-stuffs with common things in struct vb2_fileio_data and
    vb2_thread().

    Signed-off-by: Junghak Sung <jh1009.sung@samsung.com>
    Signed-off-by: Geunyoung Kim <nenggun.kim@samsung.com>
    Acked-by: Seung-Woo Kim <sw0312.kim@samsung.com>
    Acked-by: Inki Dae <inki.dae@samsung.com>
    Acked-by: Hans Verkuil <hans.verkuil@cisco.com>
    Signed-off-by: Hans Verkuil <hansverk@cisco.com>
    Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

:040000 040000 58629432fa60b955a899c49e4cd70fecbc6529eb
f93e018351853d33208a464a21256f2b3374f72b M      drivers

Regards
Matthias
