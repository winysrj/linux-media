Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49303 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753567AbaCCKHt (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Mar 2014 05:07:49 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 16/79] [media] drx-j: remove the unused tuner_i2c_write_read() function
Date: Mon,  3 Mar 2014 07:06:10 -0300
Message-Id: <1393841233-24840-17-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
References: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

This function is not static. Also, it is not used anywhere.
So, drop it.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/drx39xyj/drxj.c | 16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/drxj.c b/drivers/media/dvb-frontends/drx39xyj/drxj.c
index bd7ad1838d89..5bf215e33f2f 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drxj.c
+++ b/drivers/media/dvb-frontends/drx39xyj/drxj.c
@@ -4204,22 +4204,6 @@ ctrl_i2c_write_read(pdrx_demod_instance_t demod, pdrxi2c_data_t i2c_data)
 	return (DRX_STS_FUNC_NOT_AVAILABLE);
 }
 
-int
-tuner_i2c_write_read(struct tuner_instance *tuner,
-		     struct i2c_device_addr *w_dev_addr,
-		  u16 w_count,
-		  u8 *wData,
-		  struct i2c_device_addr *r_dev_addr, u16 r_count, u8 *r_data)
-{
-	pdrx_demod_instance_t demod;
-	drxi2c_data_t i2c_data =
-	    { 2, w_dev_addr, w_count, wData, r_dev_addr, r_count, r_data };
-
-	demod = (pdrx_demod_instance_t) (tuner->my_common_attr->myUser_data);
-
-	return (ctrl_i2c_write_read(demod, &i2c_data));
-}
-
 /* -------------------------------------------------------------------------- */
 /**
 * \brief Measure result of ADC synchronisation
-- 
1.8.5.3

