Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud9.xs4all.net ([194.109.24.22]:33315 "EHLO
        lb1-smtp-cloud9.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751560AbdHGHcg (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 7 Aug 2017 03:32:36 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCHv2] cec-api: log the reason for the -EINVAL in cec_s_mode
Message-ID: <b897ed0f-8898-54bd-2d28-de87e3e8ec9f@xs4all.nl>
Date: Mon, 7 Aug 2017 09:32:34 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If cec_debug >= 1 then log why the requested mode returned -EINVAL.

It can be hard to debug this since -EINVAL can be returned for many
reasons. So this should help.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
Changes since v1:

Removed some error injection code that inadvertently ended up in the patch
I posted.
---
 drivers/media/cec/cec-api.c | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff --git a/drivers/media/cec/cec-api.c b/drivers/media/cec/cec-api.c
index 8dd16e263452..00d43d74020f 100644
--- a/drivers/media/cec/cec-api.c
+++ b/drivers/media/cec/cec-api.c
@@ -357,34 +357,47 @@ static long cec_s_mode(struct cec_adapter *adap, struct cec_fh *fh,

 	if (copy_from_user(&mode, parg, sizeof(mode)))
 		return -EFAULT;
-	if (mode & ~(CEC_MODE_INITIATOR_MSK | CEC_MODE_FOLLOWER_MSK))
+	if (mode & ~(CEC_MODE_INITIATOR_MSK | CEC_MODE_FOLLOWER_MSK)) {
+		dprintk(1, "%s: invalid mode bits set\n", __func__);
 		return -EINVAL;
+	}

 	mode_initiator = mode & CEC_MODE_INITIATOR_MSK;
 	mode_follower = mode & CEC_MODE_FOLLOWER_MSK;

 	if (mode_initiator > CEC_MODE_EXCL_INITIATOR ||
-	    mode_follower > CEC_MODE_MONITOR_ALL)
+	    mode_follower > CEC_MODE_MONITOR_ALL) {
+		dprintk(1, "%s: unknown mode\n", __func__);
 		return -EINVAL;
+	}

 	if (mode_follower == CEC_MODE_MONITOR_ALL &&
-	    !(adap->capabilities & CEC_CAP_MONITOR_ALL))
+	    !(adap->capabilities & CEC_CAP_MONITOR_ALL)) {
+		dprintk(1, "%s: MONITOR_ALL not supported\n", __func__);
 		return -EINVAL;
+	}

 	if (mode_follower == CEC_MODE_MONITOR_PIN &&
-	    !(adap->capabilities & CEC_CAP_MONITOR_PIN))
+	    !(adap->capabilities & CEC_CAP_MONITOR_PIN)) {
+		dprintk(1, "%s: MONITOR_PIN not supported\n", __func__);
 		return -EINVAL;
+	}

 	/* Follower modes should always be able to send CEC messages */
 	if ((mode_initiator == CEC_MODE_NO_INITIATOR ||
 	     !(adap->capabilities & CEC_CAP_TRANSMIT)) &&
 	    mode_follower >= CEC_MODE_FOLLOWER &&
-	    mode_follower <= CEC_MODE_EXCL_FOLLOWER_PASSTHRU)
+	    mode_follower <= CEC_MODE_EXCL_FOLLOWER_PASSTHRU) {
+		dprintk(1, "%s: cannot transmit\n", __func__);
 		return -EINVAL;
+	}

 	/* Monitor modes require CEC_MODE_NO_INITIATOR */
-	if (mode_initiator && mode_follower >= CEC_MODE_MONITOR_PIN)
+	if (mode_initiator && mode_follower >= CEC_MODE_MONITOR_PIN) {
+		dprintk(1, "%s: monitor modes require NO_INITIATOR\n",
+			__func__);
 		return -EINVAL;
+	}

 	/* Monitor modes require CAP_NET_ADMIN */
 	if (mode_follower >= CEC_MODE_MONITOR_PIN && !capable(CAP_NET_ADMIN))
-- 
2.13.2
