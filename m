Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49431 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754192AbaCCKIC (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 3 Mar 2014 05:08:02 -0500
From: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 71/79] [media] drx-j: Use single master mode
Date: Mon,  3 Mar 2014 07:07:05 -0300
Message-Id: <1393841233-24840-72-git-send-email-m.chehab@samsung.com>
In-Reply-To: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
References: <1393841233-24840-1-git-send-email-m.chehab@samsung.com>
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are no other I2C masters here. Also, the Windows driver uses
this mode (and both drxd and drxk Kernel drivers). So, switch
to it.

That helps to compare the logs between the Linux driver and the
Windows one.

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/media/dvb-frontends/drx39xyj/drx_driver.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-frontends/drx39xyj/drx_driver.h b/drivers/media/dvb-frontends/drx39xyj/drx_driver.h
index 8419989b4c38..e54eb35b52d9 100644
--- a/drivers/media/dvb-frontends/drx39xyj/drx_driver.h
+++ b/drivers/media/dvb-frontends/drx39xyj/drx_driver.h
@@ -260,7 +260,7 @@ int drxbsp_tuner_default_i2c_write_read(struct tuner_instance *tuner,
 *
 */
 #ifndef DRXDAP_SINGLE_MASTER
-#define DRXDAP_SINGLE_MASTER 0
+#define DRXDAP_SINGLE_MASTER 1
 #endif
 
 /**
-- 
1.8.5.3

