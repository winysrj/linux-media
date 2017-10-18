Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud7.xs4all.net ([194.109.24.31]:46899 "EHLO
        lb3-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1758923AbdJRILv (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 18 Oct 2017 04:11:51 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] cec-pin: use IS_ERR instead of PTR_ERR_OR_ZERO
Message-ID: <6b9fa779-1217-2e81-12cb-309a8313c9ef@xs4all.nl>
Date: Wed, 18 Oct 2017 10:11:46 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

cec_allocate_adapter never returns NULL, so just use IS_ERR instead of
PTR_ERR_OR_ZERO.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
---
diff --git a/drivers/media/cec/cec-pin.c b/drivers/media/cec/cec-pin.c
index e2aa5d6e619d..d98f4725253c 100644
--- a/drivers/media/cec/cec-pin.c
+++ b/drivers/media/cec/cec-pin.c
@@ -796,7 +796,7 @@ struct cec_adapter *cec_pin_allocate_adapter(const struct cec_pin_ops *pin_ops,
 			    caps | CEC_CAP_MONITOR_ALL | CEC_CAP_MONITOR_PIN,
 			    CEC_MAX_LOG_ADDRS);

-	if (PTR_ERR_OR_ZERO(adap)) {
+	if (IS_ERR(adap)) {
 		kfree(pin);
 		return adap;
 	}
