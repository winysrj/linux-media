Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:3911 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718Ab3EJMHH (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 10 May 2013 08:07:07 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Borislav Petkov <bp@alien8.de>
Subject: Re: WARNING: at drivers/media/v4l2-core/videobuf2-core.c:2065 vb2_queue_init+0x74/0x142()
Date: Fri, 10 May 2013 14:06:50 +0200
Cc: linux-media@vger.kernel.org
References: <20130508201118.GH30955@pd.tnic>
In-Reply-To: <20130508201118.GH30955@pd.tnic>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201305101406.50935.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed May 8 2013 22:11:18 Borislav Petkov wrote:
> This one looks legit: bw-qcam.c doesn't set q->timestamp_type.
> 
> [  146.989016] Colour QuickCam for Video4Linux v0.06
> [  147.713065] ------------[ cut here ]------------
> [  147.928854] WARNING: at drivers/media/v4l2-core/videobuf2-core.c:2065 vb2_queue_init+0x74/0x142()
> [  148.364433] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.9.0-12947-g0f99ebe5052a #1
> [  148.799135] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
> [  149.017598]  ffffffff8239cab3 ffff88007b789d48 ffffffff81d81cb0 ffff88007b789d88
> [  149.465524]  ffffffff810943a8 ffff88007b789d88 0000000000000000 ffff880079a7a700
> [  149.909985]  ffff880079a7a068 ffff880079a7a608 ffff8800798d1c00 ffff88007b789d98
> [  150.345653] Call Trace:
> [  150.550444]  [<ffffffff81d81cb0>] dump_stack+0x19/0x1b
> [  150.756860]  [<ffffffff810943a8>] warn_slowpath_common+0x62/0x7b
> [  150.962012]  [<ffffffff8109448c>] warn_slowpath_null+0x1a/0x1e
> [  151.160574]  [<ffffffff818e914a>] vb2_queue_init+0x74/0x142
> [  151.354795]  [<ffffffff818ff072>] bwqcam_attach+0x1e0/0x54a
> [  151.543644]  [<ffffffff815cdeb1>] parport_register_driver+0x2e/0x6d
> [  151.727651]  [<ffffffff82a8ddf5>] ? cqcam_init+0x20/0x20
> [  151.906958]  [<ffffffff82a8de05>] init_bw_qcams+0x10/0x12
> [  152.084031]  [<ffffffff82a3cdb9>] do_one_initcall+0x7b/0x116
> [  152.262088]  [<ffffffff82a3cfb4>] kernel_init_freeable+0x160/0x1f2
> [  152.441466]  [<ffffffff82a3c73a>] ? do_early_param+0x8c/0x8c
> [  152.619998]  [<ffffffff81d6874b>] ? rest_init+0xdf/0xdf
> [  152.797458]  [<ffffffff81d68759>] kernel_init+0xe/0xdb
> [  152.970650]  [<ffffffff81d9663c>] ret_from_fork+0x7c/0xb0
> [  153.140434]  [<ffffffff81d6874b>] ? rest_init+0xdf/0xdf
> [  153.305520] ---[ end trace a72f2983de4c60b5 ]---
> [  154.459479] No Quickcam found on port parport0
> [  154.613448] Quickcam detection counter: 0
> 
> 

Hi Borislav!

Thanks for the report.

Can you try this patch? This should fix it.

Regards,

	Hans

diff --git a/drivers/media/parport/bw-qcam.c b/drivers/media/parport/bw-qcam.c
index 06231b8..d12bd33 100644
--- a/drivers/media/parport/bw-qcam.c
+++ b/drivers/media/parport/bw-qcam.c
@@ -687,6 +687,7 @@ static int buffer_finish(struct vb2_buffer *vb)
 
 	parport_release(qcam->pdev);
 	mutex_unlock(&qcam->lock);
+	v4l2_get_timestamp(&vb->v4l2_buf.timestamp);
 	if (len != size)
 		vb->state = VB2_BUF_STATE_ERROR;
 	vb2_set_plane_payload(vb, 0, len);
@@ -964,6 +965,7 @@ static struct qcam *qcam_init(struct parport *port)
 	q->drv_priv = qcam;
 	q->ops = &qcam_video_qops;
 	q->mem_ops = &vb2_vmalloc_memops;
+	q->timestamp_type = V4L2_BUF_FLAG_TIMESTAMP_MONOTONIC;
 	err = vb2_queue_init(q);
 	if (err < 0) {
 		v4l2_err(v4l2_dev, "couldn't init vb2_queue for %s.\n", port->name);
-- 
1.7.10.4

