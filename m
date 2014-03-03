Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49428 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754188AbaCCKIC (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Mar 2014 05:08:02 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 73/79] [media] drx-j: be sure to do a full software reset
Date: Mon,  3 Mar 2014 07:07:07 -0300
Message-Id: <1393841233-24840-74-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
References: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Mimic what windows driver does here: it writes 0x07 to
SIO_CC_SOFT_RST__A, instead of just 0x03.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/drx39xyj/drxj.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.c b/drivers/media/dvb-frontends/drx39xyj/drxj.c
index 97a30057ff09..ed68c52f4e96 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.c
@@ -19876,8 +19876,15 @@ int drxj_open(struct drx_demod_instance *demod)
 		goto rw_error;
 	}
 
-	/* Soft reset of sys- and osc-clockdomain */
-	rc = drxj_dap_write_reg16(dev_addr, SIO_CC_SOFT_RST__A, (SIO_CC_SOFT_RST_SYS__M | SIO_CC_SOFT_RST_OSC__M), 0);
+	/*
+	 * Soft reset of sys- and osc-clockdomain
+	 *
+	 * HACK: On windows, it writes a 0x07 here, instead of just 0x03.
+	 * As we didn't load the firmware here yet, we should do the same.
+	 * Btw, this is coherent with DRX-K, where we send reset codes
+	 * for modulation (OFTM, in DRX-k), SYS and OSC clock domains.
+	 */
+	rc = drxj_dap_write_reg16(dev_addr, SIO_CC_SOFT_RST__A, (0x04 | SIO_CC_SOFT_RST_SYS__M | SIO_CC_SOFT_RST_OSC__M), 0);
 	if (rc != 0) {
 		pr_err("error %d\n", rc);
 		goto rw_error;
-- 
1.8.5.3

