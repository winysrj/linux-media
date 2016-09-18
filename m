Return-path: <linux-media-owner@vger.kernel.org>
Received: from iq.passwd.hu ([217.27.212.140]:44127 "EHLO iq.passwd.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755474AbcIRNnW (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 18 Sep 2016 09:43:22 -0400
Received: from localhost (localhost [127.0.0.1])
        by iq.passwd.hu (Postfix) with ESMTP id B6DFE100C59
        for <linux-media@vger.kernel.org>; Sun, 18 Sep 2016 15:34:50 +0200 (CEST)
Received: from iq.passwd.hu ([127.0.0.1])
        by localhost (iq.passwd.hu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id QaDY2EkbwWbp for <linux-media@vger.kernel.org>;
        Sun, 18 Sep 2016 15:34:46 +0200 (CEST)
Received: from iq.passwd.hu (unknown [217.27.212.140])
        by iq.passwd.hu (Postfix) with ESMTPS id D7252100B4F
        for <linux-media@vger.kernel.org>; Sun, 18 Sep 2016 15:34:45 +0200 (CEST)
Date: Sun, 18 Sep 2016 15:34:45 +0200 (CEST)
From: Marton Balint <cus@passwd.hu>
To: linux-media@vger.kernel.org
Subject: WARN at vb2_dma_sg_alloc since 4.8-rc1
Message-ID: <alpine.LNX.2.00.1609181517380.20769@iq.passwd.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

Since 4.8-rc1, I am getting WARN-s when trying to capture from an 
AverMedia Hybrid+FM DVB-T card using dvbstream:

------------[ cut here ]------------
WARNING: CPU: 0 PID: 1889 at 
../drivers/media/v4l2-core/videobuf2-dma-sg.c:107 
vb2_dma_sg_alloc+0x284/0x4d0 [videobuf2_dma_sg]
Modules linked in: nf_log_ipv6 xt_pkttype nf_log_ipv4 nf_log_common xt_LOG 
xt_limit af_packet iscsi_ibft iscsi_boot_sysfs ip6t_REJECT nf_reject_ip
CPU: 0 PID: 1889 Comm: dvbstream Not tainted 4.8.0-rc1-0.gf3b2ad2-default 
#1
Hardware name: Gigabyte Technology Co., Ltd. B85-HD3/B85-HD3, BIOS F2 
07/04/2014
  0000000000000000 ffffffff813a2792 0000000000000000 0000000000000000
  ffffffff8107daee ffff8802157fba08 0000000000000000 0000000000000002
  ffff8802157fb828 ffff8801ff3ab818 0000000000000000 ffffffffa02eddb4
Call Trace:
  [<ffffffff8102ef0e>] dump_trace+0x5e/0x310
  [<ffffffff8102f2db>] show_stack_log_lvl+0x11b/0x1a0
  [<ffffffff81030011>] show_stack+0x21/0x40
  [<ffffffff813a2792>] dump_stack+0x5c/0x7a
  [<ffffffff8107daee>] __warn+0xbe/0xe0
  [<ffffffffa02eddb4>] vb2_dma_sg_alloc+0x284/0x4d0 [videobuf2_dma_sg]
  [<ffffffffa0502a61>] __vb2_queue_alloc+0x161/0x3f0 [videobuf2_core]
  [<ffffffffa0502e70>] vb2_core_reqbufs+0x180/0x380 [videobuf2_core]
  [<ffffffffa0503271>] __vb2_init_fileio+0xd1/0x2e0 [videobuf2_core]
  [<ffffffffa0503c0e>] vb2_thread_start+0x8e/0x150 [videobuf2_core]
  [<ffffffffa02f21ab>] vb2_dvb_start_feed+0x6b/0x90 [videobuf2_dvb]
  [<ffffffffa052697b>] dmx_ts_feed_start_filtering+0x5b/0xf0 [dvb_core]
  [<ffffffffa05247d2>] dvb_dmxdev_start_feed.isra.5+0xa2/0xe0 [dvb_core]
  [<ffffffffa0524894>] dvb_dmxdev_filter_start+0x84/0x3a0 [dvb_core]
  [<ffffffffa05252e0>] dvb_demux_do_ioctl+0x2a0/0x530 [dvb_core]
  [<ffffffffa05237d1>] dvb_usercopy+0x51/0x160 [dvb_core]
  [<ffffffffa0523cd1>] dvb_demux_ioctl+0x11/0x20 [dvb_core]
  [<ffffffff8122b700>] do_vfs_ioctl+0x90/0x5c0
  [<ffffffff8122bca4>] SyS_ioctl+0x74/0x80
  [<ffffffff816d1d36>] entry_SYSCALL_64_fastpath+0x1e/0xa8
DWARF2 unwinder stuck at entry_SYSCALL_64_fastpath+0x1e/0xa8

Leftover inexact backtrace:

---[ end trace 441c231b428d24a2 ]---

The above backtrace is for a SuSE kernel, but the same happens 
for vanilla kernels as well.

Full dmesg is attached in the relevant kernel bugzilla entry:

https://bugzilla.kernel.org/show_bug.cgi?id=156751

Any idea what can cause this?

Thanks,
Marton
