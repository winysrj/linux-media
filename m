Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud2.xs4all.net ([194.109.24.29]:58957 "EHLO
	lb3-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751089AbcGQPCt (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jul 2016 11:02:49 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 6/7] cec: fix test for unconfigured adapter in main message loop
Date: Sun, 17 Jul 2016 17:02:33 +0200
Message-Id: <1468767754-48542-7-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1468767754-48542-1-git-send-email-hverkuil@xs4all.nl>
References: <1468767754-48542-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

The main message loop checks if the physical address was valid, and if
not it is assumed that the adapter had been unconfigured.

However, this check is no longer correct, instead it should check
that both adap->is_configured and adap->is_configuring are false.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/cec/cec-adap.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/cec/cec-adap.c b/drivers/staging/media/cec/cec-adap.c
index 159a893..6fa3db5 100644
--- a/drivers/staging/media/cec/cec-adap.c
+++ b/drivers/staging/media/cec/cec-adap.c
@@ -332,7 +332,7 @@ int cec_thread_func(void *_adap)
 			 */
 			err = wait_event_interruptible_timeout(adap->kthread_waitq,
 				kthread_should_stop() ||
-				adap->phys_addr == CEC_PHYS_ADDR_INVALID ||
+				(!adap->is_configured && !adap->is_configuring) ||
 				(!adap->transmitting &&
 				 !list_empty(&adap->transmit_queue)),
 				msecs_to_jiffies(CEC_XFER_TIMEOUT_MS));
@@ -347,7 +347,7 @@ int cec_thread_func(void *_adap)
 
 		mutex_lock(&adap->lock);
 
-		if (adap->phys_addr == CEC_PHYS_ADDR_INVALID ||
+		if ((!adap->is_configured && !adap->is_configuring) ||
 		    kthread_should_stop()) {
 			/*
 			 * If the adapter is disabled, or we're asked to stop,
-- 
2.8.1

