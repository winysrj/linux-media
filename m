Return-path: <mchehab@pedra>
Received: from smtp-vbr4.xs4all.nl ([194.109.24.24]:3777 "EHLO
	smtp-vbr4.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756834Ab1F1QUm (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jun 2011 12:20:42 -0400
Received: from tschai.localnet (215.80-203-102.nextgentel.com [80.203.102.215])
	(authenticated bits=0)
	by smtp-vbr4.xs4all.nl (8.13.8/8.13.8) with ESMTP id p5SGKeHs014539
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Tue, 28 Jun 2011 18:20:41 +0200 (CEST)
	(envelope-from hverkuil@xs4all.nl)
From: Hans Verkuil <hverkuil@xs4all.nl>
To: "linux-media" <linux-media@vger.kernel.org>
Subject: [PATCH] Fix locking problem in vivi
Date: Tue, 28 Jun 2011 18:20:40 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201106281820.40189.hverkuil@xs4all.nl>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Fix sleep-in-atomic-context bug in vivi (you need to run with lock debugging on):

Jun 28 18:14:39 tschai kernel: [   80.970478] BUG: sleeping function called from invalid context at kernel/mutex.c:271
Jun 28 18:14:39 tschai kernel: [   80.970483] in_atomic(): 0, irqs_disabled(): 1, pid: 2854, name: vivi-000
Jun 28 18:14:39 tschai kernel: [   80.970485] INFO: lockdep is turned off.
Jun 28 18:14:39 tschai kernel: [   80.970486] irq event stamp: 0
Jun 28 18:14:39 tschai kernel: [   80.970487] hardirqs last  enabled at (0): [<          (null)>]           (null)
Jun 28 18:14:39 tschai kernel: [   80.970490] hardirqs last disabled at (0): [<ffffffff8109a90b>] copy_process+0x61b/0x1440
Jun 28 18:14:39 tschai kernel: [   80.970495] softirqs last  enabled at (0): [<ffffffff8109a90b>] copy_process+0x61b/0x1440
Jun 28 18:14:39 tschai kernel: [   80.970498] softirqs last disabled at (0): [<          (null)>]           (null)
Jun 28 18:14:39 tschai kernel: [   80.970502] Pid: 2854, comm: vivi-000 Tainted: P            3.0.0-rc1-tschai #372
Jun 28 18:14:39 tschai kernel: [   80.970504] Call Trace:
Jun 28 18:14:39 tschai kernel: [   80.970509]  [<ffffffff81089be3>] __might_sleep+0xf3/0x130
Jun 28 18:14:39 tschai kernel: [   80.970512]  [<ffffffff8176967f>] mutex_lock_nested+0x2f/0x60
Jun 28 18:14:39 tschai kernel: [   80.970517]  [<ffffffffa0acee3e>] vivi_fillbuff+0x20e/0x3f0 [vivi]
Jun 28 18:14:39 tschai kernel: [   80.970520]  [<ffffffff81407004>] ? do_raw_spin_lock+0x54/0x150
Jun 28 18:14:39 tschai kernel: [   80.970524]  [<ffffffff8104ef5e>] ? read_tsc+0xe/0x20
Jun 28 18:14:39 tschai kernel: [   80.970528]  [<ffffffff810c9d87>] ? getnstimeofday+0x57/0xe0
Jun 28 18:14:39 tschai kernel: [   80.970531]  [<ffffffffa0acf1b1>] vivi_thread+0x191/0x2f0 [vivi]
Jun 28 18:14:39 tschai kernel: [   80.970534]  [<ffffffff81093aa0>] ? try_to_wake_up+0x2d0/0x2d0
Jun 28 18:14:39 tschai kernel: [   80.970537]  [<ffffffffa0acf020>] ? vivi_fillbuff+0x3f0/0x3f0 [vivi]
Jun 28 18:14:39 tschai kernel: [   80.970541]  [<ffffffff810bff46>] kthread+0xb6/0xc0
Jun 28 18:14:39 tschai kernel: [   80.970544]  [<ffffffff817743e4>] kernel_thread_helper+0x4/0x10
Jun 28 18:14:39 tschai kernel: [   80.970547]  [<ffffffff8176b4d4>] ? retint_restore_args+0x13/0x13
Jun 28 18:14:39 tschai kernel: [   80.970550]  [<ffffffff810bfe90>] ? __init_kthread_worker+0x70/0x70
Jun 28 18:14:39 tschai kernel: [   80.970552]  [<ffffffff817743e0>] ? gs_change+0x13/0x13

Tested with vivi.

This bug was introduced in 2.6.39.

Regards,

	Hans

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/drivers/media/video/vivi.c b/drivers/media/video/vivi.c
index 2238a61..52eff8b 100644
--- a/drivers/media/video/vivi.c
+++ b/drivers/media/video/vivi.c
@@ -524,11 +524,13 @@ static void vivi_thread_tick(struct vivi_dev *dev)
 	spin_lock_irqsave(&dev->slock, flags);
 	if (list_empty(&dma_q->active)) {
 		dprintk(dev, 1, "No active queue to serve\n");
-		goto unlock;
+		spin_unlock_irqrestore(&dev->slock, flags);
+		return;
 	}
 
 	buf = list_entry(dma_q->active.next, struct vivi_buffer, list);
 	list_del(&buf->list);
+	spin_unlock_irqrestore(&dev->slock, flags);
 
 	do_gettimeofday(&buf->vb.v4l2_buf.timestamp);
 
@@ -538,8 +540,6 @@ static void vivi_thread_tick(struct vivi_dev *dev)
 
 	vb2_buffer_done(&buf->vb, VB2_BUF_STATE_DONE);
 	dprintk(dev, 2, "[%p/%d] done\n", buf, buf->vb.v4l2_buf.index);
-unlock:
-	spin_unlock_irqrestore(&dev->slock, flags);
 }
 
 #define frames_to_ms(frames)					\
