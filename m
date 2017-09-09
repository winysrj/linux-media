Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout.web.de ([217.72.192.78]:64854 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751060AbdIIUbT (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 9 Sep 2017 16:31:19 -0400
Subject: [PATCH 1/3] [media] xc2028: Delete two error messages for a failed
 memory allocation in load_all_firmwares()
From: SF Markus Elfring <elfring@users.sourceforge.net>
To: linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
References: <c2317603-f640-b0a6-ab86-7fda8040b6ba@users.sourceforge.net>
Message-ID: <8c68a1b2-5e6b-ab26-290b-3f9ab46f7a42@users.sourceforge.net>
Date: Sat, 9 Sep 2017 22:31:13 +0200
MIME-Version: 1.0
In-Reply-To: <c2317603-f640-b0a6-ab86-7fda8040b6ba@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 9 Sep 2017 21:30:11 +0200

Omit extra messages for a memory allocation failure in this function.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/media/tuners/tuner-xc2028.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/tuners/tuner-xc2028.c b/drivers/media/tuners/tuner-xc2028.c
index b5b62b08159e..7353f25f9e7d 100644
--- a/drivers/media/tuners/tuner-xc2028.c
+++ b/drivers/media/tuners/tuner-xc2028.c
@@ -339,4 +339,3 @@ static int load_all_firmwares(struct dvb_frontend *fe,
-		tuner_err("Not enough memory to load firmware file.\n");
 		rc = -ENOMEM;
 		goto err;
 	}
@@ -389,4 +388,3 @@ static int load_all_firmwares(struct dvb_frontend *fe,
-			tuner_err("Not enough memory to load firmware file.\n");
 			rc = -ENOMEM;
 			goto err;
 		}
-- 
2.14.1
