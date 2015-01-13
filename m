Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud3.xs4all.net ([194.109.24.26]:51411 "EHLO
	lb2-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751190AbbAMOCf (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 13 Jan 2015 09:02:35 -0500
Message-ID: <54B52548.7010109@xs4all.nl>
Date: Tue, 13 Jan 2015 15:01:44 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
To: linux-media <linux-media@vger.kernel.org>, gtmkramer@xs4all.nl,
	ray@apollo.lv
Subject: [PATCH] cx23885/vb2 regression: please test this patch
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Raimonds, Jurgen,

Can you both test this patch? It should (I hope) solve the problems you
both had with the cx23885 driver.

This patch fixes a race condition in the vb2_thread that occurs when
the thread is stopped. The crucial fix is calling kthread_stop much
earlier in vb2_thread_stop(). But I also made the vb2_thread more
robust.

Regards,

	Hans

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
index d09a891..bc08a82 100644
--- a/drivers/media/v4l2-core/videobuf2-core.c
+++ b/drivers/media/v4l2-core/videobuf2-core.c
@@ -3146,27 +3146,26 @@ static int vb2_thread(void *data)
 			prequeue--;
 		} else {
 			call_void_qop(q, wait_finish, q);
-			ret = vb2_internal_dqbuf(q, &fileio->b, 0);
+			if (!threadio->stop)
+				ret = vb2_internal_dqbuf(q, &fileio->b, 0);
 			call_void_qop(q, wait_prepare, q);
 			dprintk(5, "file io: vb2_dqbuf result: %d\n", ret);
 		}
-		if (threadio->stop)
-			break;
-		if (ret)
+		if (ret || threadio->stop)
 			break;
 		try_to_freeze();
 
 		vb = q->bufs[fileio->b.index];
 		if (!(fileio->b.flags & V4L2_BUF_FLAG_ERROR))
-			ret = threadio->fnc(vb, threadio->priv);
-		if (ret)
-			break;
+			if (threadio->fnc(vb, threadio->priv))
+				break;
 		call_void_qop(q, wait_finish, q);
 		if (set_timestamp)
 			v4l2_get_timestamp(&fileio->b.timestamp);
-		ret = vb2_internal_qbuf(q, &fileio->b);
+		if (!threadio->stop)
+			ret = vb2_internal_qbuf(q, &fileio->b);
 		call_void_qop(q, wait_prepare, q);
-		if (ret)
+		if (ret || threadio->stop)
 			break;
 	}
 
@@ -3235,11 +3234,11 @@ int vb2_thread_stop(struct vb2_queue *q)
 	threadio->stop = true;
 	vb2_internal_streamoff(q, q->type);
 	call_void_qop(q, wait_prepare, q);
+	err = kthread_stop(threadio->thread);
 	q->fileio = NULL;
 	fileio->req.count = 0;
 	vb2_reqbufs(q, &fileio->req);
 	kfree(fileio);
-	err = kthread_stop(threadio->thread);
 	threadio->thread = NULL;
 	kfree(threadio);
 	q->fileio = NULL;
