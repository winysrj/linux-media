Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:35906 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755693AbdEGWFE (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 7 May 2017 18:05:04 -0400
From: "Jasmin J." <jasmin@anw.at>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, max.kellermann@gmail.com,
        rjkm@metzlerbros.de, d.scheller@gmx.net, jasmin@anw.at
Subject: [PATCH 2/7] [media] dvb-core/dvb_ca_en50221.c: Increase timeout for link init
Date: Sun,  7 May 2017 22:51:48 +0200
Message-Id: <1494190313-18557-3-git-send-email-jasmin@anw.at>
In-Reply-To: <1494190313-18557-1-git-send-email-jasmin@anw.at>
References: <1494190313-18557-1-git-send-email-jasmin@anw.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Jasmin Jessich <jasmin@anw.at>

Some CAMs do a really slow initialization, which requires a longer timeout
for the first response.

Signed-off-by: Ralph Metzler <rjkm@metzlerbros.de>
Signed-off-by: Daniel Scheller <d.scheller@gmx.net>
Signed-off-by: Jasmin Jessich <jasmin@anw.at>
---
 drivers/media/dvb-core/dvb_ca_en50221.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/dvb-core/dvb_ca_en50221.c b/drivers/media/dvb-core/dvb_ca_en50221.c
index 9b90d3e..1cdd80a 100644
--- a/drivers/media/dvb-core/dvb_ca_en50221.c
+++ b/drivers/media/dvb-core/dvb_ca_en50221.c
@@ -347,7 +347,7 @@ static int dvb_ca_en50221_link_init(struct dvb_ca_private *ca, int slot)
 	/* read the buffer size from the CAM */
 	if ((ret = ca->pub->write_cam_control(ca->pub, slot, CTRLIF_COMMAND, IRQEN | CMDREG_SR)) != 0)
 		return ret;
-	if ((ret = dvb_ca_en50221_wait_if_status(ca, slot, STATUSREG_DA, HZ / 10)) != 0)
+	if ((ret = dvb_ca_en50221_wait_if_status(ca, slot, STATUSREG_DA, HZ)) != 0)
 		return ret;
 	if ((ret = dvb_ca_en50221_read_data(ca, slot, buf, 2)) != 2)
 		return -EIO;
-- 
2.7.4
