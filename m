Return-path: <linux-media-owner@vger.kernel.org>
Received: from us01smtprelay-2.synopsys.com ([198.182.47.9]:52822 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751757AbdGGLh3 (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Fri, 7 Jul 2017 07:37:29 -0400
From: Jose Abreu <Jose.Abreu@synopsys.com>
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Jose Abreu <Jose.Abreu@synopsys.com>,
        Carlos Palminha <CARLOS.PALMINHA@synopsys.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH v7.1 1/5] [media] cec.h: Add stub function for cec_register_cec_notifier()
Date: Fri,  7 Jul 2017 12:37:16 +0100
Message-Id: <bcf671fd7de56db2a224394e21766eae01d0ad02.1499427365.git.joabreu@synopsys.com>
In-Reply-To: <cover.1499427365.git.joabreu@synopsys.com>
References: <cover.1499427365.git.joabreu@synopsys.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Add a new stub function for cec_register_cec_notifier() so that
we can still call this function when CONFIG_CEC_NOTIFIER and
CONFIG_CEC_CORE are not set.

Signed-off-by: Jose Abreu <joabreu@synopsys.com>
Cc: Carlos Palminha <palminha@synopsys.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
---
 include/media/cec.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/media/cec.h b/include/media/cec.h
index 56643b2..8357f60 100644
--- a/include/media/cec.h
+++ b/include/media/cec.h
@@ -365,6 +365,14 @@ static inline int cec_phys_addr_validate(u16 phys_addr, u16 *parent, u16 *port)
 	return 0;
 }
 
+#ifndef CONFIG_CEC_NOTIFIER
+struct cec_notifier;
+static inline void cec_register_cec_notifier(struct cec_adapter *adap,
+					     struct cec_notifier *notifier)
+{
+}
+#endif
+
 #endif
 
 /**
-- 
1.9.1
