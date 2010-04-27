Return-path: <linux-media-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:38184 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254Ab0D0PDQ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Apr 2010 11:03:16 -0400
From: Sergio Aguirre <saaguirre@ti.com>
To: Sakari Ailus <sakari.ailus@maxwell.research.nokia.com>
Cc: linux-media@vger.kernel.org, Sergio Aguirre <saaguirre@ti.com>
Subject: [PATCH] V4L: Events: Include slab.h explicitly
Date: Tue, 27 Apr 2010 10:08:19 -0500
Message-Id: <1272380899-30398-1-git-send-email-saaguirre@ti.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

After commit ID:

  commit de380b55f92986c1a84198149cb71b7228d15fbd
  Author: Tejun Heo <tj@kernel.org>
  Date:   Wed Mar 24 17:06:43 2010 +0900

      percpu: don't implicitly include slab.h from percpu.h

slab.h include was not longer implicitly included with sched.h.

So, now we have to include slab.h explicitly.

Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
---
 drivers/media/video/v4l2-event.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/v4l2-event.c b/drivers/media/video/v4l2-event.c
index aea4332..7f31cd2 100644
--- a/drivers/media/video/v4l2-event.c
+++ b/drivers/media/video/v4l2-event.c
@@ -26,6 +26,7 @@
 #include <media/v4l2-fh.h>
 #include <media/v4l2-event.h>
 
+#include <linux/slab.h>
 #include <linux/sched.h>
 
 int v4l2_event_init(struct v4l2_fh *fh)
-- 
1.6.3.3

