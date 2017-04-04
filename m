Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f174.google.com ([209.85.128.174]:35227 "EHLO
        mail-wr0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753799AbdDDMcm (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 4 Apr 2017 08:32:42 -0400
Received: by mail-wr0-f174.google.com with SMTP id k6so208594373wre.2
        for <linux-media@vger.kernel.org>; Tue, 04 Apr 2017 05:32:32 -0700 (PDT)
From: Lee Jones <lee.jones@linaro.org>
To: hans.verkuil@cisco.com, mchehab@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, patrice.chotard@st.com,
        linux-media@vger.kernel.org, benjamin.gaignard@st.com,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 2/2] [media] cec: Fix runtime BUG when (CONFIG_RC_CORE && !CEC_CAP_RC)
Date: Tue,  4 Apr 2017 13:32:19 +0100
Message-Id: <20170404123219.22040-2-lee.jones@linaro.org>
In-Reply-To: <20170404123219.22040-1-lee.jones@linaro.org>
References: <20170404123219.22040-1-lee.jones@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Currently when the RC Core is enabled (reachable) core code located
in cec_register_adapter() attempts to populate the RC structure with
a pointer to the 'parent' passed in by the caller.

Unfortunately if the caller did not specify RC capibility when calling
cec_allocate_adapter(), then there will be no RC structure to populate.

This causes a "NULL pointer dereference" error.

Fixes: f51e80804f0 ("[media] cec: pass parent device in register(), not allocate()")
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/media/cec/cec-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/cec/cec-core.c b/drivers/media/cec/cec-core.c
index 06a312c..d64937b 100644
--- a/drivers/media/cec/cec-core.c
+++ b/drivers/media/cec/cec-core.c
@@ -286,8 +286,8 @@ int cec_register_adapter(struct cec_adapter *adap,
 	adap->devnode.dev.parent = parent;
 
 #if IS_REACHABLE(CONFIG_RC_CORE)
-	adap->rc->dev.parent = parent;
 	if (adap->capabilities & CEC_CAP_RC) {
+		adap->rc->dev.parent = parent;
 		res = rc_register_device(adap->rc);
 
 		if (res) {
-- 
2.9.3
