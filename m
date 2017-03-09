Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f180.google.com ([209.85.128.180]:33455 "EHLO
        mail-wr0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754427AbdCINpi (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 9 Mar 2017 08:45:38 -0500
Received: by mail-wr0-f180.google.com with SMTP id u48so45385303wrc.0
        for <linux-media@vger.kernel.org>; Thu, 09 Mar 2017 05:45:37 -0800 (PST)
Date: Thu, 9 Mar 2017 17:46:18 +0400
From: Anton Sviridenko <anton@corp.bluecherry.net>
To: Bluecherry Maintainers <maintainers@bluecherrydvr.com>,
        Andrey Utkin <andrey.utkin@corp.bluecherry.net>,
        Ismael Luceno <ismael@iodev.co.uk>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] [media] solo6x10: release vb2 buffers in
 solo_stop_streaming()
Message-ID: <20170309134615.GA17229@magpie-gentoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

v2: removed var dbg_buf_cnt, left-over from debugging

Fixes warning that appears in dmesg after closing V4L2 userspace
application that plays video from the display device
(first device from V4L2 device nodes provided by solo, usually /dev/video0
when no other V4L2 devices are present). Encoder device nodes are not
affected. Can be reproduced by starting and closing

ffplay -f video4linux2  /dev/video0

[ 8130.281251] ------------[ cut here ]------------
[ 8130.281256] WARNING: CPU: 1 PID: 20414 at drivers/media/v4l2-core/videobuf2-core.c:1651 __vb2_queue_cancel+0x14b/0x230
[ 8130.281257] Modules linked in: ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat solo6x10 x86_pkg_temp_thermal vboxpci(O) vboxnetadp(O) vboxnetflt(O) vboxdrv(O)
[ 8130.281264] CPU: 1 PID: 20414 Comm: ffplay Tainted: G           O    4.10.0-gentoo #1
[ 8130.281264] Hardware name: ASUS All Series/B85M-E, BIOS 2301 03/30/2015
[ 8130.281265] Call Trace:
[ 8130.281267]  dump_stack+0x4f/0x72
[ 8130.281270]  __warn+0xc7/0xf0
[ 8130.281271]  warn_slowpath_null+0x18/0x20
[ 8130.281272]  __vb2_queue_cancel+0x14b/0x230
[ 8130.281273]  vb2_core_streamoff+0x23/0x90
[ 8130.281275]  vb2_streamoff+0x24/0x50
[ 8130.281276]  vb2_ioctl_streamoff+0x3d/0x50
[ 8130.281278]  v4l_streamoff+0x15/0x20
[ 8130.281279]  __video_do_ioctl+0x25e/0x2f0
[ 8130.281280]  video_usercopy+0x279/0x520
[ 8130.281282]  ? v4l_enum_fmt+0x1330/0x1330
[ 8130.281285]  ? unmap_region+0xdf/0x110
[ 8130.281285]  video_ioctl2+0x10/0x20
[ 8130.281286]  v4l2_ioctl+0xce/0xe0
[ 8130.281289]  do_vfs_ioctl+0x8b/0x5b0
[ 8130.281290]  ? __fget+0x72/0xa0
[ 8130.281291]  SyS_ioctl+0x74/0x80
[ 8130.281294]  entry_SYSCALL_64_fastpath+0x13/0x94
[ 8130.281295] RIP: 0033:0x7ff86fee6b27
[ 8130.281296] RSP: 002b:00007ffe467f6a08 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[ 8130.281297] RAX: ffffffffffffffda RBX: 00000000d1a4d788 RCX: 00007ff86fee6b27
[ 8130.281297] RDX: 00007ffe467f6a14 RSI: 0000000040045613 RDI: 0000000000000006
[ 8130.281298] RBP: 000000000373f8d0 R08: 00000000ffffffff R09: 00007ff860001140
[ 8130.281298] R10: 0000000000000243 R11: 0000000000000246 R12: 0000000000000000
[ 8130.281299] R13: 00000000000000a0 R14: 00007ffe467f6530 R15: 0000000001f32228
[ 8130.281300] ---[ end trace 00695dc96be646e7 ]---

Signed-off-by: Anton Sviridenko <anton@corp.bluecherry.net>
---
 drivers/media/pci/solo6x10/solo6x10-v4l2.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/media/pci/solo6x10/solo6x10-v4l2.c b/drivers/media/pci/solo6x10/solo6x10-v4l2.c
index 896bec6..3266fc2 100644
--- a/drivers/media/pci/solo6x10/solo6x10-v4l2.c
+++ b/drivers/media/pci/solo6x10/solo6x10-v4l2.c
@@ -341,6 +341,17 @@ static void solo_stop_streaming(struct vb2_queue *q)
 	struct solo_dev *solo_dev = vb2_get_drv_priv(q);
 
 	solo_stop_thread(solo_dev);
+
+	spin_lock(&solo_dev->slock);
+	while (!list_empty(&solo_dev->vidq_active)) {
+		struct solo_vb2_buf *buf = list_entry(
+				solo_dev->vidq_active.next,
+				struct solo_vb2_buf, list);
+
+		list_del(&buf->list);
+		vb2_buffer_done(&buf->vb.vb2_buf, VB2_BUF_STATE_ERROR);
+	}
+	spin_unlock(&solo_dev->slock);
 	INIT_LIST_HEAD(&solo_dev->vidq_active);
 }
 
-- 
2.10.2
