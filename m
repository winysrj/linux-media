Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:33841 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751370AbcEKHLn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 May 2016 03:11:43 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 3/3] cec: correctly cancel delayed work when the CEC adapter is disabled
Date: Wed, 11 May 2016 09:11:28 +0200
Message-Id: <1462950688-23290-4-git-send-email-hverkuil@xs4all.nl>
In-Reply-To: <1462950688-23290-1-git-send-email-hverkuil@xs4all.nl>
References: <1462950688-23290-1-git-send-email-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hans.verkuil@cisco.com>

When cleaning up pending work from the wait_queue list, make sure to cancel the
delayed work. Otherwise nasty kernel oopses will occur when the timer goes off
and the cec_data struct has disappeared.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/staging/media/cec/cec.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/cec/cec.c b/drivers/staging/media/cec/cec.c
index 9a62aa2..c2a876e 100644
--- a/drivers/staging/media/cec/cec.c
+++ b/drivers/staging/media/cec/cec.c
@@ -393,13 +393,28 @@ static int cec_thread_func(void *_adap)
 							struct cec_data, list);
 				cec_data_cancel(data);
 			}
+			if (adap->transmitting)
+				cec_data_cancel(adap->transmitting);
+
+			/*
+			 * Cancel the pending timeout work. We have to unlock
+			 * the mutex when flushing the work since
+			 * cec_wait_timeout() will take it. This is OK since
+			 * no new entries can be added to wait_queue as long
+			 * as adap->transmitting is NULL, which it is due to
+			 * the cec_data_cancel() above.
+			 */
 			while (!list_empty(&adap->wait_queue)) {
 				data = list_first_entry(&adap->wait_queue,
 							struct cec_data, list);
+
+				if (!cancel_delayed_work(&data->work)) {
+					mutex_unlock(&adap->lock);
+					flush_scheduled_work();
+					mutex_lock(&adap->lock);
+				}
 				cec_data_cancel(data);
 			}
-			if (adap->transmitting)
-				cec_data_cancel(adap->transmitting);
 			goto unlock;
 		}
 
-- 
2.8.1

