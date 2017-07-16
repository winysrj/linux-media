Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:46231 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751244AbdGPAni (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 15 Jul 2017 20:43:38 -0400
From: "Jasmin J." <jasmin@anw.at>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, max.kellermann@gmail.com,
        rjkm@metzlerbros.de, d.scheller@gmx.net, crope@iki.fi,
        jasmin@anw.at
Subject: [PATCH V3 12/16] [media] dvb-core/dvb_ca_en50221.c: Fixed typo
Date: Sun, 16 Jul 2017 02:43:13 +0200
Message-Id: <1500165797-16987-13-git-send-email-jasmin@anw.at>
In-Reply-To: <1500165797-16987-1-git-send-email-jasmin@anw.at>
References: <1500165797-16987-1-git-send-email-jasmin@anw.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jasmin Jessich <jasmin@anw.at>

- "dont" -> "don't"

Signed-off-by: Jasmin Jessich <jasmin@anw.at>
---
 drivers/media/dvb-core/dvb_ca_en50221.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/dvb-core/dvb_ca_en50221.c b/drivers/media/dvb-core/dvb_ca_en50221.c
index 8c0c730..aba80d8 100644
--- a/drivers/media/dvb-core/dvb_ca_en50221.c
+++ b/drivers/media/dvb-core/dvb_ca_en50221.c
@@ -1304,7 +1304,7 @@ static void dvb_ca_en50221_thread_state_machine(struct dvb_ca_private *ca,
 			 */
 			if (dvb_ca_en50221_check_camstatus(ca, slot)) {
 				/*
-				 * we dont want to sleep on the next iteration
+				 * we don't want to sleep on the next iteration
 				 * so we can handle the cam change
 				 */
 				ca->wakeup = 1;
@@ -1314,7 +1314,7 @@ static void dvb_ca_en50221_thread_state_machine(struct dvb_ca_private *ca,
 			/* check if we've hit our limit this time */
 			if (++pktcount >= MAX_RX_PACKETS_PER_ITERATION) {
 				/*
-				 * dont sleep; there is likely to be more data
+				 * don't sleep; there is likely to be more data
 				 * to read
 				 */
 				ca->wakeup = 1;
-- 
2.7.4
