Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18946 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754130Ab2HEDaS (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sat, 4 Aug 2012 23:30:18 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q753UGB8025405
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Sat, 4 Aug 2012 23:30:18 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 4/5] [media] az6007: fix the I2C W+R logic
Date: Sun,  5 Aug 2012 00:30:10 -0300
Message-Id: <1344137411-27948-5-git-send-email-mchehab@redhat.com>
In-Reply-To: <1344137411-27948-1-git-send-email-mchehab@redhat.com>
References: <1344137411-27948-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)@canuck.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The test for I2C W+R will never be true. Fix it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/media/dvb/dvb-usb-v2/az6007.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb/dvb-usb-v2/az6007.c b/drivers/media/dvb/dvb-usb-v2/az6007.c
index 9d2ad49..35ed915 100644
--- a/drivers/media/dvb/dvb-usb-v2/az6007.c
+++ b/drivers/media/dvb/dvb-usb-v2/az6007.c
@@ -707,7 +707,7 @@ static int az6007_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[],
 		addr = msgs[i].addr << 1;
 		if (((i + 1) < num)
 		    && (msgs[i].len == 1)
-		    && (!msgs[i].flags & I2C_M_RD)
+		    && ((msgs[i].flags & I2C_M_RD) != I2C_M_RD)
 		    && (msgs[i + 1].flags & I2C_M_RD)
 		    && (msgs[i].addr == msgs[i + 1].addr)) {
 			/*
-- 
1.7.11.2

