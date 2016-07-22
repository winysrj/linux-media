Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud6.xs4all.net ([194.109.24.28]:43717 "EHLO
	lb2-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751455AbcGVIgg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 22 Jul 2016 04:36:36 -0400
Received: from [192.168.1.137] (marune.xs4all.nl [80.101.105.217])
	by tschai.lan (Postfix) with ESMTPSA id 82E2F180241
	for <linux-media@vger.kernel.org>; Fri, 22 Jul 2016 10:36:30 +0200 (CEST)
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH for v4.8] cec: fix off-by-one memset
Message-ID: <25978667-969b-be9e-2600-8a8b50554856@xs4all.nl>
Date: Fri, 22 Jul 2016 10:36:29 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The unused bytes of the features array should be zeroed, but the start index was one
byte too early. This caused the device features byte to be overwritten by 0.

The compliance test for the CEC_S_LOG_ADDRS ioctl didn't catch this because it tested
byte continuation with the second device features byte being 0 :-(

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/drivers/staging/media/cec/cec-adap.c b/drivers/staging/media/cec/cec-adap.c
index 9fffddb..b2393bb 100644
--- a/drivers/staging/media/cec/cec-adap.c
+++ b/drivers/staging/media/cec/cec-adap.c
@@ -1252,7 +1252,7 @@ int __cec_s_log_addrs(struct cec_adapter *adap,
 			return -EINVAL;
 		}
 		/* Zero unused part of the feature array */
-		memset(features + i, 0, feature_sz - i);
+		memset(features + i + 1, 0, feature_sz - i - 1);
 	}

 	if (log_addrs->cec_version >= CEC_OP_CEC_VERSION_2_0) {
