Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:45037 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074Ab2CIMS7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 9 Mar 2012 07:18:59 -0500
Received: by eaaq12 with SMTP id q12so427843eaa.19
        for <linux-media@vger.kernel.org>; Fri, 09 Mar 2012 04:18:58 -0800 (PST)
From: Gianluca Gennari <gennarone@gmail.com>
To: linux-media@vger.kernel.org, mchehab@redhat.com
Cc: Gianluca Gennari <gennarone@gmail.com>
Subject: [PATCH] fix backport patch v2.6.32_kfifo
Date: Fri,  9 Mar 2012 13:18:47 +0100
Message-Id: <1331295527-25038-1-git-send-email-gennarone@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The backport patch v2.6.32_kfifo-patch collides with:
http://patchwork.linuxtv.org/patch/9914/

Moreover, struct kfifo_rec_ptr_1 is not defined in 2.6.32,
so we have to stay with the old buggy implementation.

Signed-off-by: Gianluca Gennari <gennarone@gmail.com>
---
 backports/v2.6.32_kfifo.patch |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/backports/v2.6.32_kfifo.patch b/backports/v2.6.32_kfifo.patch
index 10075b9..88a435a 100644
--- a/backports/v2.6.32_kfifo.patch
+++ b/backports/v2.6.32_kfifo.patch
@@ -14,7 +14,7 @@
  	struct list_head		list;		/* to keep track of raw clients */
  	struct task_struct		*thread;
  	spinlock_t			lock;
--	struct kfifo			kfifo;		/* fifo for the pulse/space durations */
+-	struct kfifo_rec_ptr_1		kfifo;		/* fifo for the pulse/space durations */
 +	struct kfifo			*kfifo;		/* fifo for the pulse/space durations */
  	ktime_t				last_event;	/* when last event occurred */
  	enum raw_event_type		last_type;	/* last event type */
-- 
1.7.0.4

