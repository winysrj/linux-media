Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:30793 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754995AbaJHIrG (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 8 Oct 2014 04:47:06 -0400
Received: from epcpsbgm1.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0ND4004JLB2H7RC0@mailout2.samsung.com> for
 linux-media@vger.kernel.org; Wed, 08 Oct 2014 17:47:05 +0900 (KST)
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-media@vger.kernel.org, kyungmin.park@samsung.com
Cc: s.nawrocki@samsung.com
Subject: [PATCH 1/3] async: Add async_domain_init_exclusive() helper
Date: Wed, 08 Oct 2014 10:46:51 +0200
Message-id: <1412758013-23608-1-git-send-email-j.anaszewski@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Sylwester Nawrocki <s.nawrocki@samsung.com>

Add a helper to allow initialization of struct async_domain at runtime.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 include/linux/async.h |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/linux/async.h b/include/linux/async.h
index 6b0226b..807e40b 100644
--- a/include/linux/async.h
+++ b/include/linux/async.h
@@ -37,6 +37,12 @@ struct async_domain {
 	struct async_domain _name = { .pending = LIST_HEAD_INIT(_name.pending), \
 				      .registered = 0 }
 
+static inline void async_domain_init_exclusive(struct async_domain *domain)
+{
+	INIT_LIST_HEAD(&domain->pending);
+	domain->registered = 0;
+}
+
 extern async_cookie_t async_schedule(async_func_t func, void *data);
 extern async_cookie_t async_schedule_domain(async_func_t func, void *data,
 					    struct async_domain *domain);
-- 
1.7.9.5

