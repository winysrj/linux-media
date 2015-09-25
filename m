Return-path: <linux-media-owner@vger.kernel.org>
Received: from team.netup.ru ([77.72.80.1]:34178 "EHLO a-desktop"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752789AbbIYHJs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 25 Sep 2015 03:09:48 -0400
From: Abylay Ospan <aospan@netup.ru>
To: linux-media@vger.kernel.org, mchehab@osg.samsung.com
Cc: Abylay Ospan <aospan@netup.ru>
Subject: [PATCH] fix compile error when CONFIG_DVB_HORUS3A is disabled
Date: Fri, 25 Sep 2015 03:03:49 -0400
Message-Id: <1443164629-27703-1-git-send-email-aospan@netup.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Abylay Ospan <aospan@netup.ru>
---
 drivers/media/dvb-frontends/horus3a.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/horus3a.h b/drivers/media/dvb-frontends/horus3a.h
index b055319..c1e2d18 100644
--- a/drivers/media/dvb-frontends/horus3a.h
+++ b/drivers/media/dvb-frontends/horus3a.h
@@ -46,8 +46,8 @@ extern struct dvb_frontend *horus3a_attach(struct dvb_frontend *fe,
 					const struct horus3a_config *config,
 					struct i2c_adapter *i2c);
 #else
-static inline struct dvb_frontend *horus3a_attach(
-					const struct cxd2820r_config *config,
+static inline struct dvb_frontend *horus3a_attach(struct dvb_frontend *fe,
+					const struct horus3a_config *config,
 					struct i2c_adapter *i2c)
 {
 	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
-- 
2.1.4

