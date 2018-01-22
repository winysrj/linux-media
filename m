Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:39701 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751028AbeAVRNx (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 Jan 2018 12:13:53 -0500
Received: by mail-wr0-f194.google.com with SMTP id z48so9500698wrz.6
        for <linux-media@vger.kernel.org>; Mon, 22 Jan 2018 09:13:53 -0800 (PST)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: rascobie@slingshot.co.nz
Subject: [PATCH v2 2/5] media: dvb_frontend: add DVB-S2X rolloff factors
Date: Mon, 22 Jan 2018 18:13:43 +0100
Message-Id: <20180122171346.822-3-d.scheller.oss@gmail.com>
In-Reply-To: <20180122171346.822-1-d.scheller.oss@gmail.com>
References: <20180122171346.822-1-d.scheller.oss@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Add 15%, 10% and 5% DVB-S2X rolloff factors. Also fix roloff typos.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
---
 Documentation/media/frontend.h.rst.exceptions |  3 +++
 drivers/media/dvb-core/dvb_frontend.c         |  9 +++++++++
 include/uapi/linux/dvb/frontend.h             | 16 +++++++++++-----
 3 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/Documentation/media/frontend.h.rst.exceptions b/Documentation/media/frontend.h.rst.exceptions
index ae1148be0a39..c1643ce93426 100644
--- a/Documentation/media/frontend.h.rst.exceptions
+++ b/Documentation/media/frontend.h.rst.exceptions
@@ -167,6 +167,9 @@ ignore symbol ROLLOFF_35
 ignore symbol ROLLOFF_20
 ignore symbol ROLLOFF_25
 ignore symbol ROLLOFF_AUTO
+ignore symbol ROLLOFF_15
+ignore symbol ROLLOFF_10
+ignore symbol ROLLOFF_5
 
 ignore symbol INVERSION_ON
 ignore symbol INVERSION_OFF
diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
index 722b86a43497..e5105c1783b8 100644
--- a/drivers/media/dvb-core/dvb_frontend.c
+++ b/drivers/media/dvb-core/dvb_frontend.c
@@ -2183,6 +2183,15 @@ static int dtv_set_frontend(struct dvb_frontend *fe)
 		break;
 	case SYS_DVBS2:
 		switch (c->rolloff) {
+		case ROLLOFF_5:
+			rolloff = 105;
+			break;
+		case ROLLOFF_10:
+			rolloff = 110;
+			break;
+		case ROLLOFF_15:
+			rolloff = 115;
+			break;
 		case ROLLOFF_20:
 			rolloff = 120;
 			break;
diff --git a/include/uapi/linux/dvb/frontend.h b/include/uapi/linux/dvb/frontend.h
index 227268a657cd..8bf1c63627a2 100644
--- a/include/uapi/linux/dvb/frontend.h
+++ b/include/uapi/linux/dvb/frontend.h
@@ -580,20 +580,26 @@ enum fe_pilot {
 
 /**
  * enum fe_rolloff - Rolloff factor
- * @ROLLOFF_35:		Roloff factor: α=35%
- * @ROLLOFF_20:		Roloff factor: α=20%
- * @ROLLOFF_25:		Roloff factor: α=25%
- * @ROLLOFF_AUTO:	Auto-detect the roloff factor.
+ * @ROLLOFF_35:		Rolloff factor: α=35%
+ * @ROLLOFF_20:		Rolloff factor: α=20%
+ * @ROLLOFF_25:		Rolloff factor: α=25%
+ * @ROLLOFF_AUTO:	Auto-detect the rolloff factor.
+ * @ROLLOFF_15:		Rolloff factor: α=15%
+ * @ROLLOFF_10:		Rolloff factor: α=10%
+ * @ROLLOFF_5:		Rolloff factor: α=5%
  *
  * .. note:
  *
- *    Roloff factor of 35% is implied on DVB-S. On DVB-S2, it is default.
+ *    Rolloff factor of 35% is implied on DVB-S. On DVB-S2, it is default.
  */
 enum fe_rolloff {
 	ROLLOFF_35,
 	ROLLOFF_20,
 	ROLLOFF_25,
 	ROLLOFF_AUTO,
+	ROLLOFF_15,
+	ROLLOFF_10,
+	ROLLOFF_5,
 };
 
 /**
-- 
2.13.6
