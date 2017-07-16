Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:46243 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751250AbdGPAni (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 15 Jul 2017 20:43:38 -0400
From: "Jasmin J." <jasmin@anw.at>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, max.kellermann@gmail.com,
        rjkm@metzlerbros.de, d.scheller@gmx.net, crope@iki.fi,
        jasmin@anw.at
Subject: [PATCH V3 07/16] [media] dvb-core/dvb_ca_en50221.c: Added line breaks
Date: Sun, 16 Jul 2017 02:43:08 +0200
Message-Id: <1500165797-16987-8-git-send-email-jasmin@anw.at>
In-Reply-To: <1500165797-16987-1-git-send-email-jasmin@anw.at>
References: <1500165797-16987-1-git-send-email-jasmin@anw.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jasmin Jessich <jasmin@anw.at>

Fixed all:
  WARNING: Missing a blank line after declarations

Signed-off-by: Jasmin Jessich <jasmin@anw.at>
---
 drivers/media/dvb-core/dvb_ca_en50221.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_ca_en50221.c b/drivers/media/dvb-core/dvb_ca_en50221.c
index 7207ff5..678bd6a 100644
--- a/drivers/media/dvb-core/dvb_ca_en50221.c
+++ b/drivers/media/dvb-core/dvb_ca_en50221.c
@@ -178,7 +178,9 @@ static void dvb_ca_private_free(struct dvb_ca_private *ca)
 
 static void dvb_ca_private_release(struct kref *ref)
 {
-	struct dvb_ca_private *ca = container_of(ref, struct dvb_ca_private, refcount);
+	struct dvb_ca_private *ca;
+
+	ca = container_of(ref, struct dvb_ca_private, refcount);
 	dvb_ca_private_free(ca);
 }
 
@@ -297,8 +299,10 @@ static int dvb_ca_en50221_wait_if_status(struct dvb_ca_private *ca, int slot,
 	start = jiffies;
 	timeout = jiffies + timeout_hz;
 	while (1) {
+		int res;
+
 		/* read the status and check for error */
-		int res = ca->pub->read_cam_control(ca->pub, slot, CTRLIF_STATUS);
+		res = ca->pub->read_cam_control(ca->pub, slot, CTRLIF_STATUS);
 		if (res < 0)
 			return -EIO;
 
-- 
2.7.4
