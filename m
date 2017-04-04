Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f180.google.com ([209.85.128.180]:35209 "EHLO
        mail-wr0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754262AbdDDMcb (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 4 Apr 2017 08:32:31 -0400
Received: by mail-wr0-f180.google.com with SMTP id k6so208593623wre.2
        for <linux-media@vger.kernel.org>; Tue, 04 Apr 2017 05:32:26 -0700 (PDT)
From: Lee Jones <lee.jones@linaro.org>
To: hans.verkuil@cisco.com, mchehab@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, patrice.chotard@st.com,
        linux-media@vger.kernel.org, benjamin.gaignard@st.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 1/2] [media] cec: Move capability check inside #if
Date: Tue,  4 Apr 2017 13:32:18 +0100
Message-Id: <20170404123219.22040-1-lee.jones@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If CONFIG_RC_CORE is not enabled then none of the RC code will be
executed anyway, so we're placing the capability check inside the

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/media/cec/cec-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/cec/cec-core.c b/drivers/media/cec/cec-core.c
index 37217e2..06a312c 100644
--- a/drivers/media/cec/cec-core.c
+++ b/drivers/media/cec/cec-core.c
@@ -234,10 +234,10 @@ struct cec_adapter *cec_allocate_adapter(const struct cec_adap_ops *ops,
 		return ERR_PTR(res);
 	}
 
+#if IS_REACHABLE(CONFIG_RC_CORE)
 	if (!(caps & CEC_CAP_RC))
 		return adap;
 
-#if IS_REACHABLE(CONFIG_RC_CORE)
 	/* Prepare the RC input device */
 	adap->rc = rc_allocate_device(RC_DRIVER_SCANCODE);
 	if (!adap->rc) {
-- 
2.9.3
