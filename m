Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:47486 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388940AbeHGOkv (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 7 Aug 2018 10:40:51 -0400
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: [PATCH 1/3] media: tuner-xc2028: don't use casts for printing sizes
Date: Tue,  7 Aug 2018 08:26:40 -0400
Message-Id: <7fbc03c87b03ffb9128fe67bcbca6f1c6cc96c5c.1533644783.git.mchehab+samsung@kernel.org>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Makes smatch happier by using %zd instead of casting sizes:
	drivers/media/tuners/tuner-xc2028.c:378 load_all_firmwares() warn: argument 4 to %d specifier is cast from pointer
	drivers/media/tuners/tuner-xc2028.c:619 load_firmware() warn: argument 6 to %d specifier is cast from pointer

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/media/tuners/tuner-xc2028.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/media/tuners/tuner-xc2028.c b/drivers/media/tuners/tuner-xc2028.c
index 222b93ef31c0..aa6861dcd3fd 100644
--- a/drivers/media/tuners/tuner-xc2028.c
+++ b/drivers/media/tuners/tuner-xc2028.c
@@ -376,9 +376,8 @@ static int load_all_firmwares(struct dvb_frontend *fe,
 			tuner_err("Firmware type ");
 			dump_firm_type(type);
 			printk(KERN_CONT
-			       "(%x), id %llx is corrupted (size=%d, expected %d)\n",
-			       type, (unsigned long long)id,
-			       (unsigned)(endp - p), size);
+			       "(%x), id %llx is corrupted (size=%zd, expected %d)\n",
+			       type, (unsigned long long)id, (endp - p), size);
 			goto corrupt;
 		}
 
@@ -616,8 +615,8 @@ static int load_firmware(struct dvb_frontend *fe, unsigned int type,
 		}
 
 		if ((size + p > endp)) {
-			tuner_err("missing bytes: need %d, have %d\n",
-				   size, (int)(endp - p));
+			tuner_err("missing bytes: need %d, have %zd\n",
+				   size, (endp - p));
 			return -EINVAL;
 		}
 
-- 
2.17.1
