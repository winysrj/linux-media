Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:35912 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751140AbbIMWpb (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Sep 2015 18:45:31 -0400
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Fengguang Wu <fengguang.wu@intel.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Sergey Kozlov <serjk@netup.ru>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Subject: [PATCH] [media] lnbh25: Fix lnbh25_attach() function return type
Date: Mon, 14 Sep 2015 00:45:21 +0200
Message-Id: <1442184321-25171-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If CONFIG_DVB_LNBH25 is disabled, a stub static inline function is
defined that just prints a warning about the driver being disabled
but the function return type was wrong which caused a build error.

Fixes: e025273b86fb ("[media] lnbh25: LNBH25 SEC controller driver")
Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>

---
The offending commit landed in v4.3-rc1 so this patch is -rc material.

 drivers/media/dvb-frontends/lnbh25.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/lnbh25.h b/drivers/media/dvb-frontends/lnbh25.h
index 69f30e21f6b3..1f329ef05acc 100644
--- a/drivers/media/dvb-frontends/lnbh25.h
+++ b/drivers/media/dvb-frontends/lnbh25.h
@@ -43,7 +43,7 @@ struct dvb_frontend *lnbh25_attach(
 	struct lnbh25_config *cfg,
 	struct i2c_adapter *i2c);
 #else
-static inline dvb_frontend *lnbh25_attach(
+static inline struct dvb_frontend *lnbh25_attach(
 	struct dvb_frontend *fe,
 	struct lnbh25_config *cfg,
 	struct i2c_adapter *i2c)
-- 
2.4.3

