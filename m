Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:59909 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750718AbdJKWmn (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 11 Oct 2017 18:42:43 -0400
From: "Jasmin J." <jasmin@anw.at>
To: linux-media@vger.kernel.org
Cc: hverkuil@xs4all.nl, d.scheller@gmx.net, jasmin@anw.at
Subject: [PATCH] build: Update backports/v2.6.37_dont_use_alloc_ordered_workqueue.patch
Date: Thu, 12 Oct 2017 00:42:36 +0200
Message-Id: <1507761756-23020-1-git-send-email-jasmin@anw.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jasmin Jessich <jasmin@anw.at>

Signed-off-by: Jasmin Jessich <jasmin@anw.at>
---
 backports/v2.6.37_dont_use_alloc_ordered_workqueue.patch | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/backports/v2.6.37_dont_use_alloc_ordered_workqueue.patch b/backports/v2.6.37_dont_use_alloc_ordered_workqueue.patch
index 89f508f..19d45f3 100644
--- a/backports/v2.6.37_dont_use_alloc_ordered_workqueue.patch
+++ b/backports/v2.6.37_dont_use_alloc_ordered_workqueue.patch
@@ -2,13 +2,13 @@ diff --git a/drivers/media/pci/cx18/cx18-driver.c b/drivers/media/pci/cx18/cx18-
 index 004d8ac..6508785 100644
 --- a/drivers/media/pci/cx18/cx18-driver.c
 +++ b/drivers/media/pci/cx18/cx18-driver.c
-@@ -695,7 +695,7 @@ static int cx18_create_in_workq(struct cx18 *cx)
+@@ -697,7 +697,7 @@ static int cx18_create_in_workq(struct cx18 *cx)
  {
  	snprintf(cx->in_workq_name, sizeof(cx->in_workq_name), "%s-in",
  		 cx->v4l2_dev.name);
 -	cx->in_work_queue = alloc_ordered_workqueue(cx->in_workq_name, 0);
 +	cx->in_work_queue = create_singlethread_workqueue(cx->in_workq_name);
- 	if (cx->in_work_queue == NULL) {
+ 	if (!cx->in_work_queue) {
  		CX18_ERR("Unable to create incoming mailbox handler thread\n");
  		return -ENOMEM;
 @@ -703,6 +703,18 @@ static int cx18_create_in_workq(struct cx18 *cx)
-- 
2.7.4
