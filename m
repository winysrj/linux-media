Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45367 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752893AbbCZNGZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 26 Mar 2015 09:06:25 -0400
Subject: [PATCH] cx23885: Always initialise dev->slock spinlock
From: David Howells <dhowells@redhat.com>
To: hans.verkuil@cisco.com
Cc: dhowells@redhat.com, crope@iki.fi, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org
Date: Thu, 26 Mar 2015 13:06:21 +0000
Message-ID: <20150326130621.12064.62788.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The slock spinlock in the cx23885_dev struct is only initialised if analogue
video is being used, but is used in other places too, leading to the attached
lockdep complaint.

Move the lock initialisation so that it is done unconditionally.

INFO: trying to register non-static key.
the code is fine but needs lockdep annotation.
turning off the locking correctness validator.
CPU: 1 PID: 4413 Comm: scandvb Tainted: G        W       4.0.0-rc1-fsdevel+ #25
Hardware name: System manufacturer System Product Name/P5Q PRO TURBO, BIOS 0701    10/08/2012
 0000000000000000 ffff880129d779d8 ffffffff8162bbdf 0000000000000006
 0000000000000000 ffff880129d77aa8 ffffffff810780e3 0000000000000001
 0000000000000046 0000000000000004 ffffffff81c3f180 0000000000000000
Call Trace:
 [<ffffffff8162bbdf>] dump_stack+0x4c/0x65
 [<ffffffff810780e3>] __lock_acquire+0x7b5/0x1a0e
 [<ffffffff810799ee>] lock_acquire+0x97/0x10c
 [<ffffffffa006494e>] ? cx23885_buf_queue+0x69/0x142 [cx23885]
 [<ffffffff8102e9bc>] ? amd_set_subcaches+0x19b/0x19b
 [<ffffffff816313b4>] _raw_spin_lock_irqsave+0x36/0x4a
 [<ffffffffa006494e>] ? cx23885_buf_queue+0x69/0x142 [cx23885]
 [<ffffffffa006494e>] cx23885_buf_queue+0x69/0x142 [cx23885]
 [<ffffffffa00662cb>] buffer_queue+0x17/0x19 [cx23885]
 [<ffffffffa00382d5>] __enqueue_in_driver+0x6a/0x6f [videobuf2_core]
 [<ffffffffa0038ead>] vb2_start_streaming+0x37/0x129 [videobuf2_core]
 [<ffffffffa003a6c0>] vb2_internal_streamon+0xc5/0x105 [videobuf2_core]
 [<ffffffffa003b889>] __vb2_init_fileio+0x224/0x286 [videobuf2_core]
 [<ffffffffa003bcc0>] ? vb2_thread_start+0x7b/0x15f [videobuf2_core]
 [<ffffffffa0050182>] ? vb2_dvb_start_feed+0x86/0x86 [videobuf2_dvb]
 [<ffffffffa003bd06>] vb2_thread_start+0xc1/0x15f [videobuf2_core]
 [<ffffffff8150d393>] ? dmx_section_feed_start_filtering+0x2f/0x14f
 [<ffffffffa0050157>] vb2_dvb_start_feed+0x5b/0x86 [videobuf2_dvb]
 [<ffffffff8150d461>] dmx_section_feed_start_filtering+0xfd/0x14f
 [<ffffffff8150afc7>] dvb_dmxdev_filter_start+0x23f/0x315
 [<ffffffff8150b6ad>] dvb_demux_do_ioctl+0x1fb/0x556
 [<ffffffff81509e94>] dvb_usercopy+0xb4/0x11c
 [<ffffffff8150b4b2>] ? dvb_dmxdev_ts_callback+0xd0/0xd0
 [<ffffffff8150a11a>] dvb_demux_ioctl+0x10/0x14
 [<ffffffff81144ac4>] do_vfs_ioctl+0x3c1/0x474
 [<ffffffff8126f181>] ? file_has_perm+0x5b/0x7f
 [<ffffffff810bf6ca>] ? __audit_syscall_entry+0xbc/0xde
 [<ffffffff81144bcc>] SyS_ioctl+0x55/0x7a
 [<ffffffff81631d52>] system_call_fastpath+0x12/0x17

Signed-off-by: David Howells <dhowells@redhat.com>
---

 drivers/media/pci/cx23885/cx23885-core.c  |    1 +
 drivers/media/pci/cx23885/cx23885-video.c |    1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/pci/cx23885/cx23885-core.c b/drivers/media/pci/cx23885/cx23885-core.c
index 1ad4994..7aee76a 100644
--- a/drivers/media/pci/cx23885/cx23885-core.c
+++ b/drivers/media/pci/cx23885/cx23885-core.c
@@ -825,6 +825,7 @@ static int cx23885_dev_setup(struct cx23885_dev *dev)
 	int i;
 
 	spin_lock_init(&dev->pci_irqmask_lock);
+	spin_lock_init(&dev->slock);
 
 	mutex_init(&dev->lock);
 	mutex_init(&dev->gpio_lock);
diff --git a/drivers/media/pci/cx23885/cx23885-video.c b/drivers/media/pci/cx23885/cx23885-video.c
index 5e93c68..2232b38 100644
--- a/drivers/media/pci/cx23885/cx23885-video.c
+++ b/drivers/media/pci/cx23885/cx23885-video.c
@@ -1137,7 +1137,6 @@ int cx23885_video_register(struct cx23885_dev *dev)
 	int err;
 
 	dprintk(1, "%s()\n", __func__);
-	spin_lock_init(&dev->slock);
 
 	/* Initialize VBI template */
 	cx23885_vbi_template = cx23885_video_template;

