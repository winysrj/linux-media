Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:56090 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935216AbaH0Pb5 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Aug 2014 11:31:57 -0400
Received: by mail-pa0-f51.google.com with SMTP id ey11so508605pad.24
        for <linux-media@vger.kernel.org>; Wed, 27 Aug 2014 08:31:56 -0700 (PDT)
From: tskd08@gmail.com
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com
Subject: [PATCH v2 1/5] dvb-core: add a new tuner ops to dvb_frontend for APIv5
Date: Thu, 28 Aug 2014 00:29:12 +0900
Message-Id: <1409153356-1887-2-git-send-email-tskd08@gmail.com>
In-Reply-To: <1409153356-1887-1-git-send-email-tskd08@gmail.com>
References: <1409153356-1887-1-git-send-email-tskd08@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Akihiro Tsukada <tskd08@gmail.com>

fe->ops.tuner_ops.get_rf_strength() reports its result in u16,
while in DVB APIv5 it should be reported in s64 and by 0.001dBm.

Signed-off-by: Akihiro Tsukada <tskd08@gmail.com>
---
 drivers/media/dvb-core/dvb_frontend.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/dvb-core/dvb_frontend.h b/drivers/media/dvb-core/dvb_frontend.h
index 816269e..f6222b5 100644
--- a/drivers/media/dvb-core/dvb_frontend.h
+++ b/drivers/media/dvb-core/dvb_frontend.h
@@ -222,6 +222,8 @@ struct dvb_tuner_ops {
 #define TUNER_STATUS_STEREO 2
 	int (*get_status)(struct dvb_frontend *fe, u32 *status);
 	int (*get_rf_strength)(struct dvb_frontend *fe, u16 *strength);
+	/** get signal strengh in 0.001dBm, in accordance with APIv5 */
+	int (*get_rf_strength_dbm)(struct dvb_frontend *fe, s64 *strength);
 	int (*get_afc)(struct dvb_frontend *fe, s32 *afc);
 
 	/** These are provided separately from set_params in order to facilitate silicon
-- 
2.1.0

