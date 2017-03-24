Return-path: <linux-media-owner@vger.kernel.org>
Received: from us01smtprelay-2.synopsys.com ([198.182.47.9]:58496 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936314AbdCXQsZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 24 Mar 2017 12:48:25 -0400
From: Jose Abreu <Jose.Abreu@synopsys.com>
To: linux-media@vger.kernel.org
Cc: hans.verkuil@cisco.com, mchehab@kernel.org,
        linux-kernel@vger.kernel.org, Jose Abreu <Jose.Abreu@synopsys.com>
Subject: [PATCH 1/8] [media] cec: Add cec_get_drvdata()
Date: Fri, 24 Mar 2017 16:47:52 +0000
Message-Id: <abb9e3086b6f5166cb7a3eac362d59e1d3358582.1490373499.git.joabreu@synopsys.com>
In-Reply-To: <cover.1490373499.git.joabreu@synopsys.com>
References: <cover.1490373499.git.joabreu@synopsys.com>
In-Reply-To: <cover.1490373499.git.joabreu@synopsys.com>
References: <cover.1490373499.git.joabreu@synopsys.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a helper function to get driver private data from CEC
adapter. This helps the readability a little bit and allows
to change the 'priv' field name to something else without
needing to touch all drivers.

Signed-off-by: Jose Abreu <joabreu@synopsys.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/media/cec.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/media/cec.h b/include/media/cec.h
index 96a0aa7..0daff8c 100644
--- a/include/media/cec.h
+++ b/include/media/cec.h
@@ -184,6 +184,11 @@ struct cec_adapter {
 	char input_drv[32];
 };
 
+static inline void *cec_get_drvdata(const struct cec_adapter *adap)
+{
+	return adap->priv;
+}
+
 static inline bool cec_has_log_addr(const struct cec_adapter *adap, u8 log_addr)
 {
 	return adap->log_addrs.log_addr_mask & (1 << log_addr);
-- 
1.9.1
