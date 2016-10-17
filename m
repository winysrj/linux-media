Return-path: <linux-media-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:33109 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1757497AbcJQS0S (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 17 Oct 2016 14:26:18 -0400
From: Andrey Utkin <andrey_utkin@fastmail.com>
To: hverkuil@xs4all.nl, mchehab@kernel.org
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        pmhahn+video@pmhahn.de, Andrey Utkin <andrey_utkin@fastmail.com>
Subject: [PATCH v1] media: saa7146: Fix for "[BUG] process stuck when closing saa7146 [dvb_ttpci]"
Date: Mon, 17 Oct 2016 20:25:59 +0100
Message-Id: <20161017192559.2918-1-andrey_utkin@fastmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Release queued DMA buffers when ending streaming, so that
videobuf_waiton() doesn't block forever.

As reported, this fixes avoids occasional lockup of process reading from
video device, which manifests in such log:

INFO: task ffmpeg:9864 blocked for more than 120 seconds.
      Tainted: P           O    4.6.7 #3
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
ffmpeg          D ffff880177cc7b00     0  9864      1 0x00000000
 ffff880177cc7b00 0000000000000202 0000000000000202 ffffffff8180b4c0
 ffff88019d79e4c0 ffffffff81064050 ffff880177cc7ae0 ffff880177cc8000
 ffff880177cc7b18 ffff8801fd41d648 ffff8802307acca0 ffff8802307acc70
Call Trace:
 [<ffffffff81064050>] ? preempt_count_add+0x89/0xab
 [<ffffffff81477215>] schedule+0x86/0x9e
 [<ffffffff81477215>] ? schedule+0x86/0x9e
 [<ffffffffa0fe1c96>] videobuf_waiton+0x131/0x15e [videobuf_core]
 [<ffffffff8107727b>] ? wait_woken+0x6d/0x6d
 [<ffffffffa1017be9>] saa7146_dma_free+0x39/0x5b [saa7146_vv]
 [<ffffffffa10186c4>] buffer_release+0x2a/0x3e [saa7146_vv]
 [<ffffffffa0fee4a8>] videobuf_vm_close+0xd8/0x103 [videobuf_dma_sg]
 [<ffffffff8112049e>] remove_vma+0x25/0x4d
 [<ffffffff81121a32>] exit_mmap+0xce/0xf7
 [<ffffffff8104381d>] mmput+0x4e/0xe2
 [<ffffffff810491fd>] do_exit+0x372/0x920
 [<ffffffff81049813>] do_group_exit+0x3c/0x98
 [<ffffffff810522ef>] get_signal+0x4e8/0x56e
 [<ffffffff810710a5>] ? task_dead_fair+0xd/0xf
 [<ffffffff81017020>] do_signal+0x23/0x521
 [<ffffffff81479e82>] ? _raw_spin_unlock_irqrestore+0x13/0x25
 [<ffffffff8109710d>] ? hrtimer_try_to_cancel+0xd7/0x104
 [<ffffffff8109b306>] ? ktime_get+0x4c/0xa1
 [<ffffffff81096ea6>] ? update_rmtp+0x46/0x5b
 [<ffffffff81097ce0>] ? hrtimer_nanosleep+0xe4/0x10e
 [<ffffffff81096e3c>] ? hrtimer_init+0xeb/0xeb
 [<ffffffff810014f8>] exit_to_usermode_loop+0x4f/0x93
 [<ffffffff810019fe>] syscall_return_slowpath+0x3b/0x46
 [<ffffffff8147a355>] entry_SYSCALL_64_fastpath+0x8d/0x8f

Reported-by: Philipp Matthias Hahn <pmhahn+video@pmhahn.de>
Tested-by: Philipp Matthias Hahn <pmhahn+video@pmhahn.de>
Signed-off-by: Andrey Utkin <andrey_utkin@fastmail.com>
---

Dear maintainers,
Please check whether the used buffer status (DONE) is correct for this
situation. I am in doubt, shouldn't it be VIDEOBUF_ERROR? However, ERROR
wasn't tested by Philipp and I guess it may indicate some undesired failure
status to application.

[PATCH v1] prefix is used to distinguish it from old letter with subj
"[PATCH] ..." which was a quick reply to Philipp's request and wasn't signed
off and otherwise properly formatted for submission.

 drivers/media/common/saa7146/saa7146_video.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/media/common/saa7146/saa7146_video.c b/drivers/media/common/saa7146/saa7146_video.c
index ea2f3bf..e034bcf 100644
--- a/drivers/media/common/saa7146/saa7146_video.c
+++ b/drivers/media/common/saa7146/saa7146_video.c
@@ -390,6 +390,7 @@ static int video_end(struct saa7146_fh *fh, struct file *file)
 {
 	struct saa7146_dev *dev = fh->dev;
 	struct saa7146_vv *vv = dev->vv_data;
+	struct saa7146_dmaqueue *q = &vv->video_dmaq;
 	struct saa7146_format *fmt = NULL;
 	unsigned long flags;
 	unsigned int resource;
@@ -428,6 +429,9 @@ static int video_end(struct saa7146_fh *fh, struct file *file)
 	/* shut down all used video dma transfers */
 	saa7146_write(dev, MC1, dmas);
 
+	if (q->curr)
+		saa7146_buffer_finish(dev, q, VIDEOBUF_DONE);
+
 	spin_unlock_irqrestore(&dev->slock, flags);
 
 	vv->video_fh = NULL;
-- 
2.10.1

