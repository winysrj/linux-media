Return-path: <linux-media-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:35713 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812Ab2AYIBs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Jan 2012 03:01:48 -0500
Date: Wed, 25 Jan 2012 11:01:38 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] [media] az6007: precedence bug in az6007_i2c_xfer()
Message-ID: <20120125080138.GB20199@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The intent here was to test that the flag was clear but the '!' has
higher precedence than the '&'.  I2C_M_RD is 0x1 so the current code is
equivalent to "&& (!sgs[i].flags) ..."

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/media/dvb/dvb-usb/az6007.c b/drivers/media/dvb/dvb-usb/az6007.c
index 02efd94..e693913 100644
--- a/drivers/media/dvb/dvb-usb/az6007.c
+++ b/drivers/media/dvb/dvb-usb/az6007.c
@@ -343,7 +343,7 @@ static int az6007_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[],
 		addr = msgs[i].addr << 1;
 		if (((i + 1) < num)
 		    && (msgs[i].len == 1)
-		    && (!msgs[i].flags & I2C_M_RD)
+		    && (!(msgs[i].flags & I2C_M_RD))
 		    && (msgs[i + 1].flags & I2C_M_RD)
 		    && (msgs[i].addr == msgs[i + 1].addr)) {
 			/*
