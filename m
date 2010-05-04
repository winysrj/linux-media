Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37253 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757684Ab0EDMbY (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 4 May 2010 08:31:24 -0400
Date: Tue, 4 May 2010 14:31:13 +0200
From: Dan Carpenter <error27@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch -next 1/2] media/az6027: handle -EIO failure
Message-ID: <20100504123113.GY29093@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If the az6027_usb_in_op() returns a negative errno ret is -EIO and in
that case the value of b[0] may be undefined.  The original code
assigned 0 to ret, but since it's already 0 now we can skip that.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/media/dvb/dvb-usb/az6027.c b/drivers/media/dvb/dvb-usb/az6027.c
index baaa301..6681ac1 100644
--- a/drivers/media/dvb/dvb-usb/az6027.c
+++ b/drivers/media/dvb/dvb-usb/az6027.c
@@ -701,10 +701,7 @@ static int az6027_ci_poll_slot_status(struct dvb_ca_en50221 *ca, int slot, int o
 	} else
 		ret = 0;
 
-	if (b[0] == 0) {
-		ret = 0;
-
-	} else if (b[0] == 1) {
+	if (!ret && b[0] == 1) {
 		ret = DVB_CA_EN50221_POLL_CAM_PRESENT |
 		      DVB_CA_EN50221_POLL_CAM_READY;
 	}
