Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.comexp.ru ([78.110.60.213]:35616 "EHLO mail.comexp.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753419AbaF0N2X (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 27 Jun 2014 09:28:23 -0400
Message-ID: <1403870714.2767.5.camel@madomr-fc.comexp.ru>
Subject: [PATCH 2/2] xc5000: add product id of xc5000C
From: Mikhail Domrachev <mihail.domrychev@comexp.ru>
To: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Date: Fri, 27 Jun 2014 16:05:14 +0400
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Signed-off-by: Mikhail Domrachev <mihail.domrychev@comexp.ru>
---
 drivers/media/tuners/xc5000.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/tuners/xc5000.c b/drivers/media/tuners/xc5000.c
index 2b3d514..d1f539c 100644
--- a/drivers/media/tuners/xc5000.c
+++ b/drivers/media/tuners/xc5000.c
@@ -85,6 +85,7 @@ struct xc5000_priv {
 /* Product id */
 #define XC_PRODUCT_ID_FW_NOT_LOADED	0x2000
 #define XC_PRODUCT_ID_FW_LOADED	0x1388
+#define XC_PRODUCT_ID_FW_LOADED_5000C	0x14b4
 
 /* Registers */
 #define XREG_INIT         0x00
@@ -1344,6 +1345,7 @@ struct dvb_frontend *xc5000_attach(struct dvb_frontend *fe,
 
 	switch (id) {
 	case XC_PRODUCT_ID_FW_LOADED:
+	case XC_PRODUCT_ID_FW_LOADED_5000C:
 		printk(KERN_INFO
 			"xc5000: Successfully identified at address 0x%02x\n",
 			cfg->i2c_address);
-- 
1.9.3



