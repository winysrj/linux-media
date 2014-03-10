Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:50445 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753315AbaCJL7w (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 10 Mar 2014 07:59:52 -0400
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 03/15] drx39xxj.h: Fix undefined reference to attach function
Date: Mon, 10 Mar 2014 08:58:55 -0300
Message-Id: <1394452747-5426-4-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1394452747-5426-1-git-send-email-m.chehab@samsung.com>
References: <1394452747-5426-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

As reported by the kbuild test robot <fengguang.wu@intel.com>:

drivers/built-in.o: In function `em28xx_dvb_init':
    em28xx-dvb.c:(.text+0x876f2c): undefined reference to `drx39xxj_attach'

That happens when CONFIG_VIDEO_EM28XX_DVB is selected, and neither
CONFIG_MEDIA_SUBDRV_AUTOSELECT or DVB_DRX39XYJ is selected.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/drx39xyj/drx39xxj.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/media/dvb-frontends/drx39xyj/drx39xxj.h b/drivers/media/dvb-frontends/drx39xyj/drx39xxj.h
index 2e0c50f0a12a..cfd0b96b6939 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx39xxj.h
+++ b/drivers/media/dvb-frontends/drx39xyj/drx39xxj.h
@@ -34,6 +34,12 @@ struct drx39xxj_state {
 	const struct firmware *fw;
 };
 
+#if IS_ENABLED(CONFIG_DVB_DRX39XYJ)
 struct dvb_frontend *drx39xxj_attach(struct i2c_adapter *i2c);
+#else
+static inline struct dvb_frontend *drx39xxj_attach(struct i2c_adapter *i2c) {
+	return NULL;
+};
+#endif
 
 #endif /* DVB_DUMMY_FE_H */
-- 
1.8.5.3

