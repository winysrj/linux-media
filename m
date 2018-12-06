Return-Path: <SRS0=eh97=OP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0A9DC64EB1
	for <linux-media@archiver.kernel.org>; Thu,  6 Dec 2018 15:47:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 89392214F1
	for <linux-media@archiver.kernel.org>; Thu,  6 Dec 2018 15:47:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 89392214F1
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726104AbeLFPrO (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 6 Dec 2018 10:47:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48666 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725908AbeLFPrO (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 6 Dec 2018 10:47:14 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 72E57307D85A;
        Thu,  6 Dec 2018 15:47:13 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-122-74.rdu2.redhat.com [10.10.122.74])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 98D251057074;
        Thu,  6 Dec 2018 15:47:11 +0000 (UTC)
From:   jglisse@redhat.com
To:     linux-kernel@vger.kernel.org
Cc:     =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org,
        =?UTF-8?q?St=C3=A9phane=20Marchesin?= <marcheu@chromium.org>,
        stable@vger.kernel.org
Subject: [PATCH] dma-buf: fix debugfs versus rcu and fence dumping v2
Date:   Thu,  6 Dec 2018 10:47:04 -0500
Message-Id: <20181206154704.5366-1-jglisse@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Thu, 06 Dec 2018 15:47:13 +0000 (UTC)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Jérôme Glisse <jglisse@redhat.com>

The debugfs take reference on fence without dropping them. Also the
rcu section are not well balance. Fix all that ...

Changed since v1:
    - moved fobj logic around to be rcu safe

Signed-off-by: Jérôme Glisse <jglisse@redhat.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org
Cc: linaro-mm-sig@lists.linaro.org
Cc: Stéphane Marchesin <marcheu@chromium.org>
Cc: stable@vger.kernel.org
---
 drivers/dma-buf/dma-buf.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index 13884474d158..9688d99894d6 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -1048,27 +1048,38 @@ static int dma_buf_debug_show(struct seq_file *s, void *unused)
 		while (true) {
 			seq = read_seqcount_begin(&robj->seq);
 			rcu_read_lock();
-			fobj = rcu_dereference(robj->fence);
-			shared_count = fobj ? fobj->shared_count : 0;
 			fence = rcu_dereference(robj->fence_excl);
+			fence = dma_fence_get_rcu(fence);
 			if (!read_seqcount_retry(&robj->seq, seq))
 				break;
 			rcu_read_unlock();
 		}
-
-		if (fence)
+		if (fence) {
 			seq_printf(s, "\tExclusive fence: %s %s %ssignalled\n",
 				   fence->ops->get_driver_name(fence),
 				   fence->ops->get_timeline_name(fence),
 				   dma_fence_is_signaled(fence) ? "" : "un");
-		for (i = 0; i < shared_count; i++) {
+			dma_fence_put(fence);
+		}
+
+		rcu_read_lock();
+		fobj = rcu_dereference(robj->fence);
+		shared_count = fobj ? fobj->shared_count : 0;
+		for (i = 0, fence = NULL; i < shared_count; i++) {
 			fence = rcu_dereference(fobj->shared[i]);
 			if (!dma_fence_get_rcu(fence))
 				continue;
+			rcu_read_unlock();
+
 			seq_printf(s, "\tShared fence: %s %s %ssignalled\n",
 				   fence->ops->get_driver_name(fence),
 				   fence->ops->get_timeline_name(fence),
 				   dma_fence_is_signaled(fence) ? "" : "un");
+			dma_fence_put(fence);
+
+			rcu_read_lock();
+			fobj = rcu_dereference(robj->fence);
+			shared_count = fobj ? fobj->shared_count : 0;
 		}
 		rcu_read_unlock();
 
-- 
2.17.2

