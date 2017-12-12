Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:35337 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751625AbdLLSrC (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 12 Dec 2017 13:47:02 -0500
Received: by mail-wr0-f196.google.com with SMTP id g53so22180189wra.2
        for <linux-media@vger.kernel.org>; Tue, 12 Dec 2017 10:47:01 -0800 (PST)
From: Daniel Scheller <d.scheller.oss@gmail.com>
To: linux-media@vger.kernel.org, mchehab@kernel.org,
        mchehab@s-opensource.com
Cc: jasmin@anw.at
Subject: [PATCH 1/3] [media] staging/cxd2099: fix remaining checkpatch-strict issues
Date: Tue, 12 Dec 2017 19:46:55 +0100
Message-Id: <20171212184657.19730-2-d.scheller.oss@gmail.com>
In-Reply-To: <20171212184657.19730-1-d.scheller.oss@gmail.com>
References: <20171212184657.19730-1-d.scheller.oss@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Daniel Scheller <d.scheller@gmx.net>

Fix up all remaining cosmetic issues as reported by checkpatch.pl.

Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
Signed-off-by: Jasmin Jessich <jasmin@anw.at>
---
 drivers/staging/media/cxd2099/cxd2099.c | 19 +++++--------------
 drivers/staging/media/cxd2099/cxd2099.h | 14 +++-----------
 2 files changed, 8 insertions(+), 25 deletions(-)

diff --git a/drivers/staging/media/cxd2099/cxd2099.c b/drivers/staging/media/cxd2099/cxd2099.c
index 3e30f4864e2b..21b1c6fcf9bf 100644
--- a/drivers/staging/media/cxd2099/cxd2099.c
+++ b/drivers/staging/media/cxd2099/cxd2099.c
@@ -3,23 +3,14 @@
  *
  * Copyright (C) 2010-2013 Digital Devices GmbH
  *
- *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
  * version 2 only, as published by the Free Software Foundation.
  *
- *
  * This program is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
- *
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA
- * Or, point your browser to http://www.gnu.org/copyleft/gpl.html
  */
 
 #include <linux/slab.h>
@@ -59,7 +50,7 @@ struct cxd {
 	int    amem_read;
 
 	int    cammode;
-	struct mutex lock;
+	struct mutex lock; /* device access lock */
 
 	u8     rbuf[1028];
 	u8     wbuf[1028];
@@ -101,7 +92,7 @@ static int i2c_read_reg(struct i2c_adapter *adapter, u8 adr,
 				   .buf = val, .len = 1} };
 
 	if (i2c_transfer(adapter, msgs, 2) != 2) {
-		dev_err(&adapter->dev, "error in i2c_read_reg\n");
+		dev_err(&adapter->dev, "error in %s()\n", __func__);
 		return -1;
 	}
 	return 0;
@@ -116,7 +107,7 @@ static int i2c_read(struct i2c_adapter *adapter, u8 adr,
 				   .buf = data, .len = n} };
 
 	if (i2c_transfer(adapter, msgs, 2) != 2) {
-		dev_err(&adapter->dev, "error in i2c_read\n");
+		dev_err(&adapter->dev, "error in %s()\n", __func__);
 		return -1;
 	}
 	return 0;
@@ -134,7 +125,7 @@ static int read_block(struct cxd *ci, u8 adr, u8 *data, u16 n)
 		while (n) {
 			int len = n;
 
-			if (ci->cfg.max_i2c && (len > ci->cfg.max_i2c))
+			if (ci->cfg.max_i2c && len > ci->cfg.max_i2c)
 				len = ci->cfg.max_i2c;
 			status = i2c_read(ci->i2c, ci->cfg.adr, 1, data, len);
 			if (status)
@@ -591,7 +582,7 @@ static int campoll(struct cxd *ci)
 			}
 		}
 		if ((istat & 8) &&
-		    (ci->slot_stat == DVB_CA_EN50221_POLL_CAM_PRESENT)) {
+		    ci->slot_stat == DVB_CA_EN50221_POLL_CAM_PRESENT) {
 			ci->ready = 1;
 			ci->slot_stat |= DVB_CA_EN50221_POLL_CAM_READY;
 		}
diff --git a/drivers/staging/media/cxd2099/cxd2099.h b/drivers/staging/media/cxd2099/cxd2099.h
index f4b29b1d6eb8..aba803268e94 100644
--- a/drivers/staging/media/cxd2099/cxd2099.h
+++ b/drivers/staging/media/cxd2099/cxd2099.h
@@ -3,23 +3,14 @@
  *
  * Copyright (C) 2010-2011 Digital Devices GmbH
  *
- *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
  * version 2 only, as published by the Free Software Foundation.
  *
- *
  * This program is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
- *
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
- * 02110-1301, USA
- * Or, point your browser to http://www.gnu.org/copyleft/gpl.html
  */
 
 #ifndef _CXD2099_H_
@@ -42,8 +33,9 @@ struct dvb_ca_en50221 *cxd2099_attach(struct cxd2099_cfg *cfg,
 				      void *priv, struct i2c_adapter *i2c);
 #else
 
-static inline struct dvb_ca_en50221 *cxd2099_attach(struct cxd2099_cfg *cfg,
-					void *priv, struct i2c_adapter *i2c)
+static inline struct
+dvb_ca_en50221 *cxd2099_attach(struct cxd2099_cfg *cfg, void *priv,
+			       struct i2c_adapter *i2c)
 {
 	dev_warn(&i2c->dev, "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
-- 
2.13.6
