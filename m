Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:40375
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754645AbdERMiu (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 May 2017 08:38:50 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Max Kellermann <max.kellermann@gmail.com>
Subject: [PATCH 1/5] [media] bcm3510: fix handling of VSB16 modulation
Date: Thu, 18 May 2017 09:38:35 -0300
Message-Id: <8072ec0b3dd754f84e5d5c5835dc79f0ac077d63.1495110899.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1495110899.git.mchehab@s-opensource.com>
References: <cover.1495110899.git.mchehab@s-opensource.com>
In-Reply-To: <cover.1495110899.git.mchehab@s-opensource.com>
References: <cover.1495110899.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There's a missing break for VSB16 modulation logic, with would
cause it to return -EINVAL, instead of handling it.

Fix it.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-frontends/bcm3510.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/dvb-frontends/bcm3510.c b/drivers/media/dvb-frontends/bcm3510.c
index 617c5e29f919..30cfc0f2b575 100644
--- a/drivers/media/dvb-frontends/bcm3510.c
+++ b/drivers/media/dvb-frontends/bcm3510.c
@@ -538,6 +538,7 @@ static int bcm3510_set_frontend(struct dvb_frontend *fe)
 			cmd.ACQUIRE0.MODE = 0x9;
 			cmd.ACQUIRE1.SYM_RATE = 0x0;
 			cmd.ACQUIRE1.IF_FREQ = 0x0;
+			break;
 		default:
 			return -EINVAL;
 	}
-- 
2.9.3
