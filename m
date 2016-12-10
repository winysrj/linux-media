Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:50390 "EHLO
        lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751741AbcLJJoR (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 10 Dec 2016 04:44:17 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: Hans Verkuil <hansverk@cisco.com>
Subject: [PATCH for v4.10 2/6] cec: CEC_MSG_GIVE_FEATURES should abort for CEC version < 2
Date: Sat, 10 Dec 2016 10:44:09 +0100
Message-Id: <20161210094413.8832-3-hverkuil@xs4all.nl>
In-Reply-To: <20161210094413.8832-1-hverkuil@xs4all.nl>
References: <20161210094413.8832-1-hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Hans Verkuil <hansverk@cisco.com>

This is a 2.0 only message, so it should return Feature Abort if the
adapter is configured for CEC version 1.4.

Right now it does nothing, which means that the sender will time out.

Signed-off-by: Hans Verkuil <hansverk@cisco.com>
---
 drivers/media/cec/cec-adap.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/cec/cec-adap.c b/drivers/media/cec/cec-adap.c
index 3191c0c..c05956f 100644
--- a/drivers/media/cec/cec-adap.c
+++ b/drivers/media/cec/cec-adap.c
@@ -1777,9 +1777,9 @@ static int cec_receive_notify(struct cec_adapter *adap, struct cec_msg *msg,
 	}
 
 	case CEC_MSG_GIVE_FEATURES:
-		if (adap->log_addrs.cec_version >= CEC_OP_CEC_VERSION_2_0)
-			return cec_report_features(adap, la_idx);
-		return 0;
+		if (adap->log_addrs.cec_version < CEC_OP_CEC_VERSION_2_0)
+			return cec_feature_abort(adap, msg);
+		return cec_report_features(adap, la_idx);
 
 	default:
 		/*
-- 
2.10.2

