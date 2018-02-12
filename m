Return-path: <linux-media-owner@vger.kernel.org>
Received: from gofer.mess.org ([88.97.38.141]:40585 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932629AbeBLPCN (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 12 Feb 2018 10:02:13 -0500
From: Sean Young <sean@mess.org>
To: linux-media@vger.kernel.org
Subject: [PATCH 3/5] media: rc: remove obsolete comment
Date: Mon, 12 Feb 2018 15:02:09 +0000
Message-Id: <20180212150211.28355-3-sean@mess.org>
In-Reply-To: <20180212150211.28355-1-sean@mess.org>
References: <20180212150211.28355-1-sean@mess.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This comment is no longer relevant.

Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/rc-core-priv.h | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
index 96a941aa2581..60083e609f2b 100644
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -286,11 +286,4 @@ static inline int ir_lirc_register(struct rc_dev *dev) { return 0; }
 static inline void ir_lirc_unregister(struct rc_dev *dev) { }
 #endif
 
-/*
- * Decoder initialization code
- *
- * Those load logic are called during ir-core init, and automatically
- * loads the compiled decoders for their usage with IR raw events
- */
-
 #endif /* _RC_CORE_PRIV */
-- 
2.14.3
