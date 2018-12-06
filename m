Return-Path: <SRS0=eh97=OP=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50953C04EB8
	for <linux-media@archiver.kernel.org>; Thu,  6 Dec 2018 16:18:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1BB5B20838
	for <linux-media@archiver.kernel.org>; Thu,  6 Dec 2018 16:18:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1BB5B20838
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-media-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725952AbeLFQSr (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Thu, 6 Dec 2018 11:18:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44924 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725862AbeLFQSr (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 6 Dec 2018 11:18:47 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 51F6EC02938F;
        Thu,  6 Dec 2018 16:18:47 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-122-74.rdu2.redhat.com [10.10.122.74])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 754EA1001F5B;
        Thu,  6 Dec 2018 16:18:43 +0000 (UTC)
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
Subject: [PATCH] dma-buf: balance refcount inbalance
Date:   Thu,  6 Dec 2018 11:18:40 -0500
Message-Id: <20181206161840.6578-1-jglisse@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Thu, 06 Dec 2018 16:18:47 +0000 (UTC)
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

From: Jérôme Glisse <jglisse@redhat.com>

The debugfs take reference on fence without dropping them.

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
 drivers/dma-buf/dma-buf.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
index 13884474d158..69842145c223 100644
--- a/drivers/dma-buf/dma-buf.c
+++ b/drivers/dma-buf/dma-buf.c
@@ -1069,6 +1069,7 @@ static int dma_buf_debug_show(struct seq_file *s, void *unused)
 				   fence->ops->get_driver_name(fence),
 				   fence->ops->get_timeline_name(fence),
 				   dma_fence_is_signaled(fence) ? "" : "un");
+			dma_fence_put(fence);
 		}
 		rcu_read_unlock();
 
-- 
2.17.2

