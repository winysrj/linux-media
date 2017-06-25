Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.anw.at ([195.234.101.228]:44753 "EHLO mail.anw.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751363AbdFYVhY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 25 Jun 2017 17:37:24 -0400
From: "Jasmin J." <jasmin@anw.at>
To: linux-media@vger.kernel.org
Cc: mchehab@s-opensource.com, max.kellermann@gmail.com,
        rjkm@metzlerbros.de, d.scheller@gmx.net, jasmin@anw.at
Subject: [PATCH v2 2/7] [media] dvb-core/dvb_ca_en50221.c: Increase timeout for link init
Date: Sun, 25 Jun 2017 23:37:06 +0200
Message-Id: <1498426631-17376-3-git-send-email-jasmin@anw.at>
In-Reply-To: <1498426631-17376-1-git-send-email-jasmin@anw.at>
References: <1498426631-17376-1-git-send-email-jasmin@anw.at>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Ralph Metzler <rjkm@metzlerbros.de>

Some CAMs do a really slow initialization, which requires a longer timeout
for the first response.

Original code change by Ralph Metzler, modified by Jasmin Jessich to match
Kernel code style.

Signed-off-by: Ralph Metzler <rjkm@metzlerbros.de>
Signed-off-by: Jasmin Jessich <jasmin@anw.at>
---
 drivers/media/dvb-core/dvb_ca_en50221.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/dvb-core/dvb_ca_en50221.c b/drivers/media/dvb-core/dvb_ca_en50221.c
index 80edbe8..529e7ec 100644
--- a/drivers/media/dvb-core/dvb_ca_en50221.c
+++ b/drivers/media/dvb-core/dvb_ca_en50221.c
@@ -349,7 +349,8 @@ static int dvb_ca_en50221_link_init(struct dvb_ca_private *ca, int slot)
 	/* read the buffer size from the CAM */
 	if ((ret = ca->pub->write_cam_control(ca->pub, slot, CTRLIF_COMMAND, IRQEN | CMDREG_SR)) != 0)
 		return ret;
-	if ((ret = dvb_ca_en50221_wait_if_status(ca, slot, STATUSREG_DA, HZ / 10)) != 0)
+	ret = dvb_ca_en50221_wait_if_status(ca, slot, STATUSREG_DA, HZ);
+	if (ret != 0)
 		return ret;
 	if ((ret = dvb_ca_en50221_read_data(ca, slot, buf, 2)) != 2)
 		return -EIO;
-- 
2.7.4
