Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:43470 "EHLO
        lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932072AbdDDQnh (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 4 Apr 2017 12:43:37 -0400
To: Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] cec: fix confusing CEC_CAP_RC and
 IS_REACHABLE(CONFIG_RC_CORE) code
Message-ID: <0bce68f1-c9a6-ad11-c95b-7a044e20c1aa@xs4all.nl>
Date: Tue, 4 Apr 2017 18:43:33 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

It is a bit confusing how CEC_CAP_RC and IS_REACHABLE(CONFIG_RC_CORE)
interact. By stripping CEC_CAP_RC at the beginning rather than after #else
it should be a bit clearer what is going on.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Reported-by: Lee Jones <lee.jones@linaro.org>
---
diff --git a/drivers/media/cec/cec-core.c b/drivers/media/cec/cec-core.c
index e5070b374276..66fd3de15ef8 100644
--- a/drivers/media/cec/cec-core.c
+++ b/drivers/media/cec/cec-core.c
@@ -220,6 +220,10 @@ struct cec_adapter *cec_allocate_adapter(const struct cec_adap_ops *ops,
 	struct cec_adapter *adap;
 	int res;

+#if !IS_REACHABLE(CONFIG_RC_CORE)
+	caps &= ~CEC_CAP_RC;
+#endif
+
 	if (WARN_ON(!caps))
 		return ERR_PTR(-EINVAL);
 	if (WARN_ON(!ops))
@@ -252,10 +256,10 @@ struct cec_adapter *cec_allocate_adapter(const struct cec_adap_ops *ops,
 		return ERR_PTR(res);
 	}

+#if IS_REACHABLE(CONFIG_RC_CORE)
 	if (!(caps & CEC_CAP_RC))
 		return adap;

-#if IS_REACHABLE(CONFIG_RC_CORE)
 	/* Prepare the RC input device */
 	adap->rc = rc_allocate_device(RC_DRIVER_SCANCODE);
 	if (!adap->rc) {
@@ -282,8 +286,6 @@ struct cec_adapter *cec_allocate_adapter(const struct cec_adap_ops *ops,
 	adap->rc->priv = adap;
 	adap->rc->map_name = RC_MAP_CEC;
 	adap->rc->timeout = MS_TO_NS(100);
-#else
-	adap->capabilities &= ~CEC_CAP_RC;
 #endif
 	return adap;
 }
