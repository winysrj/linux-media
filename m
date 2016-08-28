Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:36816 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755745AbcH1Qhx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 28 Aug 2016 12:37:53 -0400
Received: by mail-wm0-f66.google.com with SMTP id i138so6448524wmf.3
        for <linux-media@vger.kernel.org>; Sun, 28 Aug 2016 09:37:52 -0700 (PDT)
From: Chris Wilson <chris@chris-wilson.co.uk>
To: intel-gfx@lists.freedesktop.org
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org
Subject: [PATCH] dma-buf: Do a fast lockless check for poll with timeout=0
Date: Sun, 28 Aug 2016 17:37:47 +0100
Message-Id: <20160828163747.32751-1-chris@chris-wilson.co.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently we install a callback for performing poll on a dma-buf,
irrespective of the timeout. This involves taking a spinlock, as well as
unnecessary work, and greatly reduces scaling of poll(.timeout=0) across
multiple threads.

We can query whether the poll will block prior to installing the
callback to make the busy-query fast.

Single thread: 60% faster
8 threads on 4 (+4 HT) cores: 600% faster

Still not quite the perfect scaling we get with a native busy ioctl, but
poll(dmabuf) is faster due to the quicker lookup of the object and
avoiding drm_ioctl().

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org
Cc: linaro-mm-sig@lists.linaro.org
---
 drivers/dma-buf/dma-buf.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index cf04d249a6a4..c7a7bc579941 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -156,6 +156,18 @@ static unsigned int dma_buf_poll(struct file *file, poll_table *poll)
 	if (!events)
 		return 0;
 
+	if (poll_does_not_wait(poll)) {
+		if (events & POLLOUT &&
+		    !reservation_object_test_signaled_rcu(resv, true))
+			events &= ~(POLLOUT | POLLIN);
+
+		if (events & POLLIN &&
+		    !reservation_object_test_signaled_rcu(resv, false))
+			events &= ~POLLIN;
+
+		return events;
+	}
+
 retry:
 	seq = read_seqcount_begin(&resv->seq);
 	rcu_read_lock();
-- 
2.9.3

