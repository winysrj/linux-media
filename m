Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:35903 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862AbbIMWZq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 13 Sep 2015 18:25:46 -0400
From: Javier Martinez Canillas <javier@osg.samsung.com>
To: linux-kernel@vger.kernel.org
Cc: Fengguang Wu <fengguang.wu@intel.com>,
	Javier Martinez Canillas <javier@osg.samsung.com>,
	Sergey Kozlov <serjk@netup.ru>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	linux-media@vger.kernel.org
Subject: [PATCH] [media] horus3a: Fix horus3a_attach() function parameters
Date: Mon, 14 Sep 2015 00:25:36 +0200
Message-Id: <1442183136-18340-1-git-send-email-javier@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If CONFIG_DVB_HORUS3A is disabled a stub static inline function is
defined that just prints a warning about the driver being disabled
but the function parameters were wrong which caused a build error.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Javier Martinez Canillas <javier@osg.samsung.com>

---

 drivers/media/dvb-frontends/horus3a.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/horus3a.h b/drivers/media/dvb-frontends/horus3a.h
index b055319d532e..c1e2d1834b78 100644
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
2.4.3

