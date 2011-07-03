Return-path: <mchehab@pedra>
Received: from mailout-de.gmx.net ([213.165.64.22]:56350 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752122Ab1GCV2Q (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 3 Jul 2011 17:28:16 -0400
From: Oliver Endriss <o.endriss@gmx.de>
To: linux-media@vger.kernel.org
Subject: [PATCH 4/5] cxd2099: Fix compilation of ngene/ddbridge for DVB_CXD2099=n
Date: Sun, 3 Jul 2011 23:26:22 +0200
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
References: <201107032321.46092@orion.escape-edv.de>
In-Reply-To: <201107032321.46092@orion.escape-edv.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201107032326.23996@orion.escape-edv.de>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Fix compilation of ngene/ddbridge for DVB_CXD2099=n.

Note: Bug was introduced by commit 'cxd2099: Update to latest version'.

Signed-off-by: Oliver Endriss <o.endriss@gmx.de>
---
 drivers/staging/cxd2099/cxd2099.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/cxd2099/cxd2099.h b/drivers/staging/cxd2099/cxd2099.h
index 75459d4..19c588a 100644
--- a/drivers/staging/cxd2099/cxd2099.h
+++ b/drivers/staging/cxd2099/cxd2099.h
@@ -41,7 +41,7 @@ struct dvb_ca_en50221 *cxd2099_attach(struct cxd2099_cfg *cfg,
 #else
 
 static inline struct dvb_ca_en50221 *cxd2099_attach(struct cxd2099_cfg *cfg,
-					void *priv, struct i2c_adapter *i2c);
+					void *priv, struct i2c_adapter *i2c)
 {
 	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
 	return NULL;
-- 
1.7.4.1

