Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:44389 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933431AbdKAVGU (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 1 Nov 2017 17:06:20 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>,
        Max Kellermann <max.kellermann@gmail.com>
Subject: [PATCH v2 25/26] media: mb86a16: be more resilient if I2C fails on sync
Date: Wed,  1 Nov 2017 17:06:02 -0400
Message-Id: <185aeccbac20f1c9e280d7d3c15f9935d0274901.1509569763.git.mchehab@s-opensource.com>
In-Reply-To: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
References: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
In-Reply-To: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
References: <c4389ab1c02bb08c1a55012fdb859c8b10bdc47e.1509569763.git.mchehab@s-opensource.com>
To: unlisted-recipients:; (no To-header on input)@bombadil.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

If the I2C read fails while check for sync, there's no point
on doing adjusting the tuner due to a random value that might
be at VIRM var. So, set VIRM to zero, as that makes the caller
for check_sync() to return an error.

Fix those smatch warnings:
	drivers/media/dvb-frontends/mb86a16.c:1460 mb86a16_set_fe() error: uninitialized symbol 'VIRM'.
	drivers/media/dvb-frontends/mb86a16.c:1461 mb86a16_set_fe() error: uninitialized symbol 'VIRM'.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 drivers/media/dvb-frontends/mb86a16.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/dvb-frontends/mb86a16.c b/drivers/media/dvb-frontends/mb86a16.c
index dfe322eccaa1..f1aad52094c3 100644
--- a/drivers/media/dvb-frontends/mb86a16.c
+++ b/drivers/media/dvb-frontends/mb86a16.c
@@ -635,6 +635,7 @@ static int sync_chk(struct mb86a16_state *state,
 	return sync;
 err:
 	dprintk(verbose, MB86A16_ERROR, 1, "I2C transfer error");
+	*VIRM = 0;
 	return -EREMOTEIO;
 
 }
-- 
2.13.6
