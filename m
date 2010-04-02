Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-in-07.arcor-online.net ([151.189.21.47]:50987 "EHLO
	mail-in-07.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754894Ab0DBQyG (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 2 Apr 2010 12:54:06 -0400
From: stefan.ringel@arcor.de
To: linux-media@vger.kernel.org
Cc: mchehab@redhat.com, dheitmueller@kernellabs.com,
	Stefan Ringel <stefan.ringel@arcor.de>
Subject: [PATCH 2/2] tm6000: tm6000_i2c_xfer: request labeling
Date: Fri,  2 Apr 2010 18:52:50 +0200
Message-Id: <1270227170-4879-2-git-send-email-stefan.ringel@arcor.de>
In-Reply-To: <1270227170-4879-1-git-send-email-stefan.ringel@arcor.de>
References: <1270227170-4879-1-git-send-email-stefan.ringel@arcor.de>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Stefan Ringel <stefan.ringel@arcor.de>

labeling the request after tuner reading and writeing


Signed-off-by: Stefan Ringel <stefan.ringel@arcor.de>
---
 drivers/staging/tm6000/tm6000-i2c.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/tm6000/tm6000-i2c.c b/drivers/staging/tm6000/tm6000-i2c.c
index ec4c938..2ab632b 100644
--- a/drivers/staging/tm6000/tm6000-i2c.c
+++ b/drivers/staging/tm6000/tm6000-i2c.c
@@ -135,8 +135,8 @@ static int tm6000_i2c_xfer(struct i2c_adapter *i2c_adap,
 			i++;
 
 			if (addr == dev->tuner_addr << 1) {
-				tm6000_set_reg(dev, 0x32, 0,0);
-				tm6000_set_reg(dev, 0x33, 0,0);
+				tm6000_set_reg(dev, REQ_50_SET_START, 0, 0);
+				tm6000_set_reg(dev, REQ_51_SET_STOP, 0, 0);
 			}
 			if (i2c_debug >= 2)
 				for (byte = 0; byte < msgs[i].len; byte++)
@@ -150,8 +150,8 @@ static int tm6000_i2c_xfer(struct i2c_adapter *i2c_adap,
 				msgs[i].buf + 1, msgs[i].len - 1);
 
 			if (addr == dev->tuner_addr  << 1) {
-				tm6000_set_reg(dev, 0x32, 0,0);
-				tm6000_set_reg(dev, 0x33, 0,0);
+				tm6000_set_reg(dev, REQ_50_SET_START, 0, 0);
+				tm6000_set_reg(dev, REQ_51_SET_STOP, 0, 0);
 			}
 		}
 		if (i2c_debug >= 2)
-- 
1.6.6.1

